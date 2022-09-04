package pchchecker;

import com.moviejukebox.MovieJukebox;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.Serializable;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;
import net.sourceforge.tuned.FileUtilities;
import net.sourceforge.tuned.FileUtilities.ExtensionFileFilter;
import org.apache.http.HttpException;
import org.apache.log4j.spi.LoggingEvent;
import org.xml.sax.SAXException;
import pt.unl.fct.di.tsantos.util.FileMultipleFilter;
import pt.unl.fct.di.tsantos.util.exceptions.UnsupportedFormatException;
import pt.unl.fct.di.tsantos.util.pch.PCHJukeboxHelper;
import pt.unl.fct.di.tsantos.util.thetvdb.TheTVDBSearch;
import pt.unl.fct.di.tsantos.util.tmdb.TMDbSearch;

public class Jukebox implements Serializable {
    protected File folder;
    protected List<File> movies;
    protected List<File> tvshows;
    protected List<File> all;
    protected String name;
    // cache
    protected Map<String, Long> cache;
    protected Map<String, Long> cacheNFO;
    protected Set<String> view;
    protected Set<String> viewNFO;
    protected Long watchedMod;

    private static final
            Logger logger = Logger.getLogger(Jukebox.class.getName());

    static {
        Handler recordToThis = new Handler() {

            @Override
            public void publish(LogRecord record) {
                logger.log(record);
            }

            @Override
            public void flush() {
            }

            @Override
            public void close() throws SecurityException {}
        };
        TheTVDBSearch.getLogger().addHandler(recordToThis);
        TMDbSearch.getLogger().addHandler(recordToThis);
        org.apache.log4j.Logger.getLogger("moviejukebox").addAppender(
                new org.apache.log4j.AppenderSkeleton() {

            @Override
            protected void append(LoggingEvent le) {
                org.apache.log4j.Level lel = le.getLevel();
                Level theLevel = null;
                if (lel.equals(org.apache.log4j.Level.FATAL))
                    theLevel = Level.SEVERE;
                else if(lel.equals(org.apache.log4j.Level.ERROR))
                    theLevel = Level.SEVERE;
                else if(lel.equals(org.apache.log4j.Level.WARN))
                    theLevel = Level.WARNING;
                else if(lel.equals(org.apache.log4j.Level.INFO))
                    theLevel = Level.INFO;
                else if(lel.equals(org.apache.log4j.Level.DEBUG))
                    theLevel = Level.FINE;
                else if(lel.equals(org.apache.log4j.Level.TRACE))
                    theLevel = Level.FINER;
                else if(lel.equals(org.apache.log4j.Level.ALL))
                    theLevel = Level.ALL;
                else if(lel.equals(org.apache.log4j.Level.OFF))
                    theLevel = Level.OFF;
                logger.log(new LogRecord(theLevel,
                        le.getMessage().toString()));
            }

            public void close() {
            }

            public boolean requiresLayout() {
                return false;
            }
        });
    }

    public static Logger getLogger() {
        return logger;
    }

    public Jukebox(String name, File folder,
            List<File> movies, List<File> tvshows) {
        this.name = name;
        this.folder = folder;
        this.movies = movies;
        this.tvshows = tvshows;
        cache = new HashMap<String, Long>();
        cacheNFO = new HashMap<String, Long>();
        all = new LinkedList<File>();
        all.addAll(movies);
        all.addAll(tvshows);
        view = new HashSet<String>();
        viewNFO = new HashSet<String>();
    }

    public File getFolder() {
        return folder;
    }

    public File getNFO() {
        return new File(folder, "NFO");
    }

    public File getWatchedFolder() {
        return new File(folder, "watched");
    }

    public File getWacthedXML() {
        return new File(folder, "watchedList.xml");
    }

    public File getLibrary() {
        return new File(folder, "mylibrary.xml");
    }

    public File getJukeboxFolder() {
        return new File(folder, "Jukebox");
    }

    public List<File> getMovies() {
        return movies;
    }

    public List<File> getTVShows() {
        return tvshows;
    }

    @Override
    public String toString() {
        return name;
    }

    public void start(String host, int port,
            String uTorrentUser, String uTorrentPwd)
            throws ParserConfigurationException,
        UnsupportedFormatException, HttpException,
        XPathExpressionException, IOException, SAXException, Throwable {

        FileFilter fileFilter = new FileMultipleFilter(
                new ExtensionFileFilter("mkv", "avi"),
                new FileFilter() {
                    public boolean accept(File pathname) {
                        return !pathname.getName().toLowerCase().
                                contains("sample");
                    }
                });

        File infoOutput = getNFO();
        File xmlWatched = getWacthedXML();
        File watchedDir = getWatchedFolder();
        Long lastMod = xmlWatched.lastModified();
        boolean recursive = true;
        boolean forced = false;

        if (!infoOutput.exists()) infoOutput.mkdirs();
        if (!watchedDir.exists()) watchedDir.mkdirs();

        List<File> fileList = FileUtilities.flatten(all, Integer.MAX_VALUE);
        fileList = FileUtilities.filter(fileList, fileFilter);

        List<File> infoList = Arrays.asList(infoOutput.listFiles(
                    new ExtensionFileFilter("info")));

        Set<String> fileListN = new HashSet<String>();
        for (File file : fileList) fileListN.add(file.getName());
        boolean search = false;
        boolean superset = view.containsAll(fileListN);
        boolean subset = fileListN.containsAll(view);
        if (superset && subset) {
            for (File file : fileList) {
                Long lastModified = cache.get(file.getName());
                if (lastModified == null ||
                        file.lastModified() > lastModified) {
                    search = true; break;
                }
            }
            Set<String> infoListN = new HashSet<String>();
            for (File file : infoList) infoListN.add(file.getName());
            if (!search) {// check changed NFO
                superset = viewNFO.containsAll(infoListN);
                subset = infoListN.containsAll(viewNFO);
                if (superset && subset) {
                    for (File file : infoList) {
                        Long lastModified = cacheNFO.get(file.getName());
                        if (lastModified == null ||
                            file.lastModified() > lastModified) {
                            search = true; break;
                        }
                    }
                } else search = true;
            }
        } else search = true;

        if (watchedMod == null || xmlWatched.exists() && xmlWatched.isFile() &&
                lastMod > watchedMod)
            search = true;
      
        //if (!search) return;

        File[] files = watchedDir.listFiles(new ExtensionFileFilter("watched"));
        logger.log(Level.INFO,java.util.Arrays.toString(files));
        for (File f: files) f.delete(); //clear all watched files

        if (xmlWatched.exists() && xmlWatched.isFile())
            PCHJukeboxHelper.generateWatchedFiles(xmlWatched, watchedDir);

        TheTVDBSearch.saveXMLInfoDirs(getTVShows(), fileFilter,
                infoOutput, "info", recursive, forced);

        TMDbSearch.saveXMLInfoDirs(getMovies(), fileFilter,
                infoOutput, "info", recursive, forced);

        String[] args = new String[]{
            getLibrary().getAbsolutePath(), "-o", getFolder().getAbsolutePath(),
            "-c"
        };

        ////// REPLACE .originalimg //////
        File[] imgFiles = getJukeboxFolder().listFiles(new FileMultipleFilter(
                new ExtensionFileFilter("jpeg", "jpg"),
                new FileFilter() {

                    public boolean accept(File pathname) {
                        String name = pathname.getName();
                        if (name.contains(".originalimg.")) return true;
                        return false;
                    }
                }));

        for (File file : imgFiles) {
            String fname = file.getName();
            fname = fname.replace(".originalimg.",".");
            File original = new File(file.getParentFile(), fname);
            BufferedImage img = ImageIO.read(file);
            ImageIO.write(img, "JPG", original);
            file.delete();
        }
        //////////////////////////////////

        MovieJukebox.main(args);

        if (host != null && port > 0 &&
                uTorrentUser != null && uTorrentPwd != null)
            PCHJukeboxHelper.watermarkDownloadingFiles(getJukeboxFolder(),
                    host, port, uTorrentUser, uTorrentPwd);

        cache.clear();
        cacheNFO.clear();
        view.clear();
        viewNFO.clear();
        for (File file : fileList) {
            cache.put(file.getName(), file.lastModified());
            view.add(file.getName());
        }
        for (File file : infoList) {
            cacheNFO.put(file.getName(), file.lastModified());
            viewNFO.add(file.getName());
        }
        watchedMod = lastMod;
    }
}
