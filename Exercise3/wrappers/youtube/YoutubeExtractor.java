
import java.net.URLEncoder;
import org.apache.commons.lang3.StringEscapeUtils;
import java.io.IOException;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.jsoup.Jsoup;
import java.lang.StringBuilder;
import java.util.LinkedList;
import java.io.*;

public class YoutubeExtractor {

    private LinkedList<Video> videos = new LinkedList<Video>();

    private class Video {

        private String title;
        private String time;
        private String user;
        private String id;
        private int views;

        public String getTitle() {
            return title;
        }

        public String getTime() {
            return time;
        }

        public String getUser() {
            return user;
        }

        public String getId() {
            return id;
        }

        public Integer getViews() {
            return views;
        }

        public String getLink() {
            return "http://www.youtube.com/watch?v=" + id;
        }

        public String getImage() {
            return "http://i2.ytimg.com/vi/" + id + "/mqdefault.jpg";
        }

        public Video(String title, String time, String user, String id, int views) {
            this.views = views;
            this.title = title;
            this.time = time;
            this.user = user;
            this.id = id;
        }
    }

    private void write(String file) throws IOException {
        // XMLs stream api sucks and I don't think it's worth to write our own for
        // such a simple file format.


        FileWriter fstream = new FileWriter(file);
        BufferedWriter out = new BufferedWriter(fstream);

        out.write("<youtube>\n");
        for (Video video : videos) {
            out.write("\t<result>\n");

            out.write("\t\t<title>");
            out.write(video.getTitle());
            out.write("</title>\n");

            out.write("\t\t<time>");
            out.write(video.getTime());
            out.write("</time>\n");

            out.write("\t\t<user>");
            out.write(StringEscapeUtils.escapeXml(video.getUser()));
            out.write("</user>\n");

            out.write("\t\t<id>");
            out.write(video.getId());
            out.write("</id>\n");

            out.write("\t\t<views>");
            out.write(video.getViews().toString());
            out.write("</views>\n");

            out.write("\t\t<link>");
            out.write(video.getLink());
            out.write("</link>\n");

            out.write("\t\t<image>");
            out.write(video.getImage());
            out.write("</image>\n");

            out.write("\t</result>\n");
        }
        out.write("</youtube>");
        out.close();
    }

    private boolean contains(String value, String cl) {
        String[] arr = value.split("\\s+");
        for (String str : arr) {
            if (str.equals(cl)) {
                return true;
            }
        }

        return false;
    }

    private int viewsToInt(String str) {
        String[] arr = str.split("\\s+".trim());
        String val = arr[0].replace(",", "");

        return Integer.parseInt(val);
    }

    private void process_result_item_video(Element item) {
        String title = item.attr("data-context-item-title");
        String time = item.attr("data-context-item-time");
        String user = item.attr("data-context-item-user");
        String id = item.attr("data-context-item-id");
        int views = viewsToInt(item.attr("data-context-item-views"));

        Video video = new Video(title, time, user, id, views);
        videos.add(video);
    }

    private void process_result_item(Element item) {
        if (contains(item.attr("data-context-item-type"), "video")) {
            process_result_item_video(item);
            //} else if (contains (item.attr ("class"), "result-item-channel")) {
            //	// We don't care about channels
        }
    }

    private void process_result_list(Element list) {
        Elements items = list.getElementsByTag("li");
        for (Element item : items) {
            process_result_item(item);
        }
    }

    public void run(String searchstr) throws IOException {
        String escaped = URLEncoder.encode(searchstr, "UTF-8");

        Document doc = Jsoup.connect("http://www.youtube.com/results?search_query=" + escaped).get();
        Elements results = doc.select("#search-results");
        for (Element lst : results) {
            process_result_list(lst);
        }

        write("youtube.xml");
    }

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: YoutubeGenerator STRING");
            return;
        }

        try {
            YoutubeExtractor extractor = new YoutubeExtractor();
            extractor.run(args[0]);
        } catch (IOException e) {
            System.out.println("Exception: " + e.getMessage());
        }

        return;
    }
}