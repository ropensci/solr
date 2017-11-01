#' @param name Name of a collection or core. Or leave as \code{NULL} if not needed.
#' @param raw (logical) If TRUE (default) raw json or xml returned. If FALSE,
#' 		parsed data returned.
#' @param callopts Call options passed on to [crul::HttpClient]
#' @param parsetype One of list of df (data.frame)
#' @param ... Further args to be combined into query
#'
#' @section Facet parameters:
#' \itemize{
#'  \item q Query terms. See examples.
#'  \item hl.fl A comma-separated list of fields for which to generate highlighted snippets.
#' If left blank, the fields highlighted for the LuceneQParser are the defaultSearchField
#' (or the df param if used) and for the DisMax parser the qf fields are used. A '*' can
#' be used to match field globs, e.g. 'text_*' or even '*' to highlight on all fields where
#' highlighting is possible. When using '*', consider adding hl.requireFieldMatch=TRUE.
#'  \item hl.snippets Max no. of highlighted snippets to generate per field. Note:
#' it is possible for any number of snippets from zero to this value to be generated.
#' This parameter accepts per-field overrides. Default: 1.
#'  \item hl.fragsize The size, in characters, of the snippets (aka fragments) created by
#' the highlighter. In the original Highlighter, "0" indicates that the whole field value
#' should be used with no fragmenting. See
#' \url{http://wiki.apache.org/solr/HighlightingParameters} for more info.
#'  \item hl.q Set a query request to be highlighted. It overrides q parameter for
#' highlighting. Solr query syntax is acceptable for this parameter.
#'  \item hl.mergeContiguous Collapse contiguous fragments into a single fragment. "true"
#' indicates contiguous fragments will be collapsed into single fragment. This parameter
#' accepts per-field overrides. This parameter makes sense for the original Highlighter
#' only. Default: FALSE.
#'  \item hl.requireFieldMatch If TRUE, then a field will only be highlighted if the
#' query matched in this particular field (normally, terms are highlighted in all
#' requested fields regardless of which field matched the query). This only takes effect
#' if "hl.usePhraseHighlighter" is TRUE. Default: FALSE.
#'  \item hl.maxAnalyzedChars How many characters into a document to look for suitable
#' snippets. This parameter makes sense for the original Highlighter only. Default: 51200.
#' You can assign a large value to this parameter and use hl.fragsize=0 to return
#' highlighting in large fields that have size greater than 51200 characters.
#'  \item hl.alternateField If a snippet cannot be generated (due to no terms matching),
#' you can specify a field to use as the fallback. This parameter accepts per-field overrides.
#'  \item hl.maxAlternateFieldLength If hl.alternateField is specified, this parameter
#' specifies the maximum number of characters of the field to return. Any value less than or
#' equal to 0 means unlimited. Default: unlimited.
#'  \item hl.preserveMulti Preserve order of values in a multiValued list. Default: FALSE.
#'  \item hl.maxMultiValuedToExamine When highlighting a multiValued field, stop examining
#' the individual entries after looking at this many of them. Will potentially return 0
#' snippets if this limit is reached before any snippets are found. If maxMultiValuedToMatch
#' is also specified, whichever limit is hit first will terminate looking for more.
#' Default: Integer.MAX_VALUE
#'  \item hl.maxMultiValuedToMatch When highlighting a multiValued field, stop examining
#' the individual entries after looking at this many matches are found. If
#' maxMultiValuedToExamine is also specified, whichever limit is hit first will terminate
#' looking for more. Default: Integer.MAX_VALUE
#'  \item hl.formatter Specify a formatter for the highlight output. Currently the only
#' legal value is "simple", which surrounds a highlighted term with a customizable pre- and
#' post text snippet. This parameter accepts per-field overrides. This parameter makes
#' sense for the original Highlighter only.
#'  \item hl.simple.pre The text which appears before and after a highlighted term when using
#' the simple formatter. This parameter accepts per-field overrides. The default values are
#' "<em>" and "</em>" This parameter makes sense for the original Highlighter only. Use
#' hl.tag.pre and hl.tag.post for FastVectorHighlighter (see example under hl.fragmentsBuilder)
#'  \item hl.simple.post The text which appears before and after a highlighted term when using
#' the simple formatter. This parameter accepts per-field overrides. The default values are
#' "<em>" and "</em>" This parameter makes sense for the original Highlighter only. Use
#' hl.tag.pre and hl.tag.post for FastVectorHighlighter (see example under hl.fragmentsBuilder)
#'  \item hl.fragmenter Specify a text snippet generator for highlighted text. The standard
#' fragmenter is gap (which is so called because it creates fixed-sized fragments with gaps
#' for multi-valued fields). Another option is regex, which tries to create fragments that
#' "look like" a certain regular expression. This parameter accepts per-field overrides.
#' Default: "gap"
#'  \item hl.fragListBuilder Specify the name of SolrFragListBuilder.  This parameter
#' makes sense for FastVectorHighlighter only. To create a fragSize=0 with the
#' FastVectorHighlighter, use the SingleFragListBuilder. This field supports per-field
#' overrides.
#'  \item hl.fragmentsBuilder Specify the name of SolrFragmentsBuilder. This parameter makes
#' sense for FastVectorHighlighter only.
#'  \item hl.boundaryScanner Configures how the boundaries of fragments are determined. By
#' default, boundaries will split at the character level, creating a fragment such as "uick
#' brown fox jumps over the la". Valid entries are breakIterator or simple, with breakIterator
#' being the most commonly used. This parameter makes sense for FastVectorHighlighter only.
#'  \item hl.bs.maxScan Specify the length of characters to be scanned by SimpleBoundaryScanner.
#' Default: 10.  This parameter makes sense for FastVectorHighlighter only.
#'  \item hl.bs.chars Specify the boundary characters, used by SimpleBoundaryScanner.
#' This parameter makes sense for FastVectorHighlighter only.
#'  \item hl.bs.type Specify one of CHARACTER, WORD, SENTENCE and LINE, used by
#' BreakIteratorBoundaryScanner. Default: WORD. This parameter makes sense for
#' FastVectorHighlighter only.
#'  \item hl.bs.language Specify the language for Locale that is used by
#' BreakIteratorBoundaryScanner. This parameter makes sense for FastVectorHighlighter only.
#' Valid entries take the form of ISO 639-1 strings.
#'  \item hl.bs.country Specify the country for Locale that is used by
#' BreakIteratorBoundaryScanner. This parameter makes sense for FastVectorHighlighter only.
#' Valid entries take the form of ISO 3166-1 alpha-2 strings.
#'  \item hl.useFastVectorHighlighter Use FastVectorHighlighter. FastVectorHighlighter
#' requires the field is termVectors=on, termPositions=on and termOffsets=on. This
#' parameter accepts per-field overrides. Default: FALSE
#'  \item hl.usePhraseHighlighter Use SpanScorer to highlight phrase terms only when
#' they appear within the query phrase in the document. Default: TRUE.
#'  \item hl.highlightMultiTerm If the SpanScorer is also being used, enables highlighting
#' for range/wildcard/fuzzy/prefix queries. Default: FALSE. This parameter makes sense
#' for the original Highlighter only.
#'  \item hl.regex.slop Factor by which the regex fragmenter can stray from the ideal
#' fragment size (given by hl.fragsize) to accomodate the regular expression. For
#' instance, a slop of 0.2 with fragsize of 100 should yield fragments between 80
#' and 120 characters in length. It is usually good to provide a slightly smaller
#' fragsize when using the regex fragmenter. Default: .6. This parameter makes sense
#' for the original Highlighter only.
#'  \item hl.regex.pattern The regular expression for fragmenting. This could be
#' used to extract sentences (see example solrconfig.xml) This parameter makes sense
#' for the original Highlighter only.
#'  \item hl.regex.maxAnalyzedChars Only analyze this many characters from a field
#' when using the regex fragmenter (after which, the fragmenter produces fixed-sized
#' fragments). Applying a complicated regex to a huge field is expensive.
#' Default: 10000. This parameter makes sense for the original Highlighter only.
#'  \item start Record to start at, default to beginning.
#'  \item rows Number of records to return.
#'  \item wt (character) Data type returned, defaults to 'json'. One of json or xml. If json,
#' uses \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to
#' parse. csv is only supported in \code{\link{solr_search}} and \code{\link{solr_all}}.
#'  \item fl Fields to return
#'  \item fq Filter query, this does not affect the search, only what gets returned
#' }
