/*
 * PCHCheckerApp.java
 */

package pchchecker;

import java.net.URL;
import java.util.HashSet;
import java.util.Observer;
import java.util.Set;
import java.util.Timer;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import org.jdesktop.application.Application;
import pt.unl.fct.di.tsantos.util.app.Data;
import pt.unl.fct.di.tsantos.util.app.DefaultSingleFrameApplication;
import pt.unl.fct.di.tsantos.util.app.Setting;
import pt.unl.fct.di.tsantos.util.time.Ticker;

/**
 * The main class of the application.
 */
public class PCHCheckerApp extends DefaultSingleFrameApplication {
    @Data protected Set<Jukebox> jukeboxes = new HashSet<Jukebox>();
    @Setting protected int searchMinutes = 30; // DEFAULT SEARCH TIME IS 30 min
    @Setting protected boolean searchAtStartup = false;
    protected Ticker ticker;
    protected Timer timer;
    @Setting protected String uTorrentHost;
    @Setting protected int uTorrentPort = 8080;
    @Setting protected String uTorrentUser;
    @Setting protected String uTorrentPwd;

    private static final Logger logger =
            Logger.getLogger(PCHCheckerApp.class.getName());

    static {
        Jukebox.getLogger().addHandler(new Handler() {
            @Override
            public void publish(LogRecord record) {
                logger.log(record);
            }

            @Override
            public void flush() {
            }

            @Override
            public void close() throws SecurityException {
            }
        });
    }

    public static Logger getLogger() {
        return logger;
    }

    public Iterable<Jukebox> getJukeboxes() {
        return jukeboxes;
    }

    public boolean add(Jukebox jb) {
        boolean res = jukeboxes.add(jb);
        configurationChanged();
        return res;
    }

    public boolean remove(Jukebox jb) {
        boolean res = jukeboxes.remove(jb);
        configurationChanged();
        return res;
    }

    @Override
    protected void initApplication() {
        super.initApplication();
        setFrameIcon(getContext().getResourceMap().
                getImageIcon("Application.trayIcon"));
        setTrayImageIcon(getContext().getResourceMap().
                getImageIcon("Application.trayIcon"));
        timer = new Timer();
    }

    /**
     * A convenient static getter for the application instance.
     * @return the instance of PCHCheckerApp
     */
    public static PCHCheckerApp getApplication() {
        return Application.getInstance(PCHCheckerApp.class);
    }

    /**
     * Main method launching the application.
     */
    public static void main(String[] args) {
        launch(PCHCheckerApp.class, args);
    }

    @Override
    protected void createSettingsDirectory() {}

    @Override
    protected void populateSettingsDirectory() {}

    @Override
    protected void update() throws Exception {}

    @Override
    protected String initSettingsDirectory() {
        return ".pchchecker";
    }

    @Override
    protected URL initWebLocation() {
        return null;
    }

    @Override
    protected String initName() {
        return "Popcorn Hour Checker";
    }

    @Override
    protected Long initUpdateInterval() {
        return null;
    }

    public int getSearchMinutes() {
        return searchMinutes;
    }

    public void setSearchMinutes(int minutes) {
        searchMinutes = minutes;
        configurationChanged();
    }

    public void setSearchAtStartup(boolean searchAtStartup) {
        this.searchAtStartup = searchAtStartup;
        configurationChanged();
    }

    public boolean searchAtStartup() {
        return searchAtStartup;
    }

    public String getUTorrentUser() {
        return uTorrentUser;
    }

    public void setUTorrentUser(String uTorrentUser) {
        this.uTorrentUser = uTorrentUser;
        configurationChanged();
    }

    public String getUTorrentPassword() {
        return uTorrentPwd;
    }

    public void setUTorrentPassword(String uTorrentPwd) {
        this.uTorrentPwd = uTorrentPwd;
        configurationChanged();
    }

    public void addObserver(Observer obs) {
        if (ticker == null) { // lazy initialization
            ticker = new Ticker(searchMinutes, searchAtStartup);
            ticker.add(obs);
            ticker.add(new Runnable() {
            public void run() {
                synchronized (jukeboxes) {
                    for (Jukebox jb : jukeboxes) {
                        try {
                            jb.start(uTorrentHost, uTorrentPort,
                                    uTorrentUser, uTorrentPwd);
                        } catch (Exception ex) {
                            logger.log(Level.SEVERE, null, ex);
                        } catch (Throwable ex) {
                            logger.log(Level.SEVERE, null, ex);
                        }
                    }
                    try {
                        saveData();
                    } catch (Exception ex) {
                        /*logger.log(Level.SEVERE, null, ex);*/
                    }
                }
            }
            });
            timer.schedule(ticker, 0, 60*1000);
        } else ticker.add(obs);
    }

    public void check() {
        if (ticker != null) ticker.execute();
    }

    protected void configurationChanged() {
        timer.purge();
        ticker.setTick(searchMinutes);
        silentSaveSettings();
    }
  
    public String getUTorrentHost() {
        return uTorrentHost;
    }

    public void setUTorrentHost(String uTorrentHost) {
        this.uTorrentHost = uTorrentHost;
        configurationChanged();
    }

    public int getUTorrentPort() {
        return uTorrentPort;
    }

    public void setUTorrentPort(int uTorrentPort) {
        this.uTorrentPort = uTorrentPort;
        configurationChanged();
    }    
}
