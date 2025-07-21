import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata_meta.dart';

class BookCoverReader {
  static Future<List<int>?> readBookCoverAsBytes(EpubBookRef bookRef) async {
    String coverPath = "cover-image";

    List<EpubMetadataMeta> metaItems = bookRef.Schema!.Package!.Metadata?.MetaItems ?? [];
    EpubMetadataMeta? itemMeta = metaItems.firstWhereOrNull((item) => item.Name?.toLowerCase() == 'cover');
    if (itemMeta != null) {
      coverPath = itemMeta.Content ?? "cover-image";
    }

    List<EpubManifestItem> manifestItems = bookRef.Schema!.Package!.Manifest!.Items!;
    EpubManifestItem? manifestItem = manifestItems.firstWhereOrNull((item) => item.Id!.toLowerCase() == coverPath.toLowerCase());
    if (manifestItem == null) {
      manifestItem = manifestItems.firstWhereOrNull((item) => item.Properties?.toLowerCase() == coverPath.toLowerCase());
      if (manifestItem == null) {
        return null;
      }
    }

    EpubByteContentFileRef? fileRef = bookRef.Content!.Images![manifestItem.Href];
    return fileRef?.readContentAsBytes();
  }
}
