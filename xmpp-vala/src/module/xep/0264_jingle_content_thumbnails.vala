namespace Xmpp.Xep.JingleContentThumbnails {
    public const string NS_URI = "urn:xmpp:thumbs:1";

    public Gee.List<Thumbnail> get_thumbnails(StanzaNode node) {
        var thumbnails = new Gee.ArrayList<Thumbnail>();
        foreach (StanzaNode thumbnail_node in node.get_subnodes("thumbnail", Xep.JingleContentThumbnails.NS_URI)) {
            var thumbnail = Thumbnail.from_stanza_node(thumbnail_node);
            if (thumbnail != null) {
                thumbnails.add(thumbnail);
            }
        }
        return thumbnails;
    }

    public class Thumbnail {
        public Bytes data;
        public string? media_type;
        public int width;
        public int height;

        public StanzaNode to_stanza_node() {
            string data_uri = "data:image/png;base64," + Base64.encode(data.get_data());

            StanzaNode node = new StanzaNode.build("thumbnail", NS_URI).add_self_xmlns()
                    .put_attribute("uri", data_uri);
            if (this.media_type != null) {
                node.put_attribute("media-type", this.media_type);
            }
            if (this.width != -1) {
                node.put_attribute("width", this.width.to_string());
            }
            if (this.height != -1) {
                node.put_attribute("height", this.height.to_string());
            }
            return node;
        }

        public static Thumbnail? from_stanza_node(StanzaNode node) {
            string uri = node.get_attribute("uri");
            if (uri == null) return null;

            Bytes data = Xmpp.get_data_for_uri(uri);

            Thumbnail thumbnail = new Thumbnail();
            thumbnail.data = data;
            thumbnail.media_type = node.get_attribute("media-type");
            thumbnail.width = node.get_attribute_int("width");
            thumbnail.height = node.get_attribute_int("height");
            return thumbnail;
        }
    }
}