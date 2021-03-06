<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet exclude-result-prefixes="java" version="2.0" xmlns:java="http://www.java.com/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which	apply to all nodes  -->
	<xsl:template match="*" mode="common-pattern">
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">common</xsl:with-param>
			<xsl:with-param name="role">content</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates mode="common-content-rules" select="//*[text()]"/>
		<xsl:apply-templates mode="common-comment-rules" select="//*[comment()]"/>
		<xsl:apply-templates mode="common-textual-rules" select="//*[text()]"/>

		<!-- structure rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">common</xsl:with-param>
			<xsl:with-param name="role">structure</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates mode="conref-structure-rules" select="//*[@conref]"/>
		<xsl:apply-templates mode="collection-type-structure-rules" select="//*[@collection-type]"/>
		<xsl:apply-templates mode="refcols-structure-rules" select="//*[@refcols]"/>
		<xsl:apply-templates mode="boolean-structure-rules" select="//boolean"/>
		<xsl:apply-templates mode="indextermref-structure-rules" select="//indextermref"/>
		<xsl:apply-templates mode="lq-structure-rules" select="//lq[@type]"/>
		<xsl:apply-templates mode="role-structure-rules" select="//*[@role]"/>
		
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">common</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates mode="colsep-style-rules" select="//*[@colsep]"/>
		<xsl:apply-templates mode="conref-style-rules" select="//*[@conref]"/>
		<xsl:apply-templates mode="href-style-rules" select="//*[@href]"/>
		<xsl:apply-templates mode="id-style-rules" select="//*"/>
		<xsl:apply-templates mode="rowsep-style-rules" select="//*[@rowsep]"/>
	</xsl:template>




	<!--
		Common DITA Content Rules - proscribed words.
	-->
	<xsl:template match="*[not(self::keyword)]" mode="common-content-rules">
		<!-- Running text checks-->
		<xsl:variable name="running-text">
			<xsl:value-of select="text()"/>
		</xsl:variable>
		<!--
			running-text-fixme - The words FIXME should not be found in the running text
		-->
		<xsl:if test="contains(lower-case($running-text),'fixme')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">running-text-fixme</xsl:with-param>
				<xsl:with-param name="test">matches(lower-case(text()),'fixme')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="replace($running-text, '\\', '\\\\')"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			running-text-todo - The words TODO should not be found in the running text
		-->
		<xsl:if test="contains(lower-case($running-text),'todo')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">running-text-todo</xsl:with-param>
				<xsl:with-param name="test">matches(lower-case(text()),'fixme')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="replace($running-text, '\\', '\\\\')"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			running-text-lorem-ipsum - The words lorem ipsum should not be found in the running text
		-->
		<xsl:if test="contains(lower-case($running-text),'lorem') or contains(lower-case($running-text),'ipsum')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">running-text-lorem-ipsum</xsl:with-param>
				<xsl:with-param name="test">matches(lower-case(text()),'lorem ipsum')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="replace($running-text, '\\', '\\\\')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="common-content-rules"/>
	<!--
		Common comment Rules - FIXME and TODO in the comments.
	-->
	<xsl:template match="*[comment()]" mode="common-comment-rules">
		<!-- Comment checks-->
		<xsl:variable name="comment">
			<xsl:value-of select="comment()"/>
		</xsl:variable>
		<!--
			comment-fixme - The words FIXME should not be found in the comments
		-->
		<xsl:if test="contains(lower-case($comment),'fixme')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">comment-fixme</xsl:with-param>
				<xsl:with-param name="test">contains(lower-case(text()),'fixme')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="$comment"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			comment-todo - The words TODO should not be found in the comments
		-->
		<xsl:if test="contains(lower-case($comment),'todo')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">comment-todo</xsl:with-param>
				<xsl:with-param name="test">contains(lower-case(text()),'todo')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="$comment"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="boolean" mode="boolean-structure-rules">
		<!--
			boolean-deprecated - The boolean element is deprecated
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">boolean-deprecated</xsl:with-param>
			<xsl:with-param name="test">name() ='boolean'</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="indextermref" mode="indextermref-structure-rules">
		<!--
			indextermref-deprecated - The indextermref element is deprecated
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">indextermref-deprecated</xsl:with-param>
			<xsl:with-param name="test">name() ='indextermref'</xsl:with-param>
		</xsl:call-template>
	</xsl:template>


	<xsl:template match="*[@collection-type]" mode="collection-type-structure-rules">
		<xsl:if test="name() = 'linkpool' and @collection-type='tree'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">linkpool-collection-type-tree-deprecated</xsl:with-param>
				<xsl:with-param name="test">name() = 'linkpool'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="name() = 'linklist' and @collection-type='tree'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">linklist-collection-type-tree-deprecated</xsl:with-param>
				<xsl:with-param name="test">name() = 'linklist'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!--
		Common conref DITA Structure Rules - missing links and ids for content references.
	-->
	<xsl:template match="*[@conref]" mode="conref-structure-rules">
		<xsl:variable name="isFileRef" select="(contains(@conref, '.dita') or contains(@conref, '.xml')) and not(contains(@conref, 'file:/'))"/>
		<xsl:variable name="isIdRef" select="starts-with(@conref, '#') and not(contains(@conref, '/'))"/>
		<xsl:variable name="isIdIdRef" select="starts-with(@conref, '#') and contains(@conref, '/')"/>
		<xsl:variable name="idRefPart" select="if (contains(@conref, '#')) then substring-after(@conref, '#') else false()"/>
		<xsl:variable name="idRef" select="if (boolean($idRefPart)) then (if (contains($idRefPart, '/')) then substring-before($idRefPart, '/') else $idRefPart) else false()"/>
		<xsl:variable name="idIdRef" select="if ($idRefPart) then substring-after($idRefPart, '/') else false()"/>
		<xsl:variable name="filePath" select="if (contains(@conref, '#')) then resolve-uri(substring-before(@conref, '#'), resolve-uri('.', document-uri(/)))  else resolve-uri(@conref, resolve-uri('.', document-uri(/)))"/>
		<xsl:variable name="file" select="if ($isFileRef) then tokenize($filePath, '/')[last()] else ''"/>
		<xsl:variable name="isFileRefAndFileExists" select="if ($isFileRef and $file) then java:file-exists($filePath, base-uri()) else false()"/>
		<xsl:variable name="idRefNode" select="if ($isFileRefAndFileExists and $idRef) then document($filePath)//*[@id = $idRef] else false()"/>
		<xsl:variable name="idIdRefNode" select="if ($isFileRefAndFileExists and ($idRef and $idIdRef)) then document($filePath)//*[@id = $idIdRef] else false()"/>
		<!--
			conref-internal-id-not-found - For a conref within a single file, the ID linked to must exist
		-->
		<xsl:if test="$isIdRef and not(//*/@id = $idRef)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">conref-internal-id-not-found</xsl:with-param>
				<xsl:with-param name="test">not(//*/@id = $idRef)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			conref-internal-path-not-found - For a conref within a single file, the path linked to must exist
		-->
		<xsl:if test="$isIdIdRef and not(//*[@id = $idIdRef]/ancestor:: */@id=$idRef)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">conref-internal-path-not-found</xsl:with-param>
				<xsl:with-param name="test">not(//*/@id = $idRef)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			conref-external-file-not-found - For a conref to an another file within the document, the file linked to must exist
		-->
		<xsl:if test="$isFileRef and not($isFileRefAndFileExists)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">conref-external-file-not-found</xsl:with-param>
				<xsl:with-param name="test">not($isFileRefAndFileExists)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			Checks for content-references to within a single file.
		-->
		<xsl:if test="not($isFileRefAndFileExists) and $idRef">
			<xsl:choose>
				<!--
					conref-internal-id-mismatch  - For a conref within a single file, the ID linked to must be
													a node of the same type as the original
				-->
				<xsl:when test="$idRefNode and not($idIdRefNode) and not(name() = $idRefNode/name())">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-internal-id-mismatch</xsl:with-param>
						<xsl:with-param name="test">not(name() = $idRefNode/name())</xsl:with-param>
						<!-- Placeholders -->
						<xsl:with-param name="param1" select="$idRefNode/name()"/>
					</xsl:call-template>
				</xsl:when>
				<!--
					conref-internal-path-mismatch  - For a conref to within a single file, the path linked to must be a node of the same type as the original
				-->
				<xsl:when test="$idIdRefNode and ($idIdRefNode/ancestor:: */@id=$idRef)  and not(name() = $idIdRefNode/name())">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-internal-path-mismatch</xsl:with-param>
						<xsl:with-param name="test">not(name() = $idIdRefNode/name())</xsl:with-param>
						<!-- Placeholders -->
						<xsl:with-param name="param1" select="$idIdRefNode/name()"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<!--
			Checks for content-references to an another file within the document.
		-->
		<xsl:if test="$isFileRefAndFileExists and $idRef">
			<xsl:choose>
				<!--
					conref-external-id-not-found - For a conref to an another file within the document, the ID linked to must exist
				-->
				<xsl:when test="not($idIdRef) and not(document($filePath)//*/@id = $idRef)">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-external-id-not-found</xsl:with-param>
						<xsl:with-param name="test">not($idIdRef) and not(document($filePath)//*/@id = $idRef)</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<!--
					conref-external-path-not-found - For a conref to an another file within the document, the path linked to must exist
				-->
				<xsl:when test="$idIdRef and not(document($filePath)//*[@id = $idIdRef]/ancestor:: */@id=$idRef)">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-external-path-not-found</xsl:with-param>
						<xsl:with-param name="test">$idIdRef and not(document($filePath)//*[@id = $idIdRef]/ancestor:: */@id=$idRef)</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<!--
					conref-external-id-mismatch - For a conref to an another file within the document, the ID a node of the same type as the original
				-->
				<xsl:when test="$idRefNode and not($idIdRefNode) and not(name() = $idRefNode/name())">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-external-id-mismatch</xsl:with-param>
						<xsl:with-param name="test">not(name() = $idRefNode/name())</xsl:with-param>
						<xsl:with-param name="param1" select="$idRefNode/name()"/>
					</xsl:call-template>
				</xsl:when>
				<!--
					conref-external-path-mismatch - For a conref to an another file within the document, the path linked to must be a node of the same type as the original
				-->
				<xsl:when test="$idIdRefNode and ($idIdRefNode/ancestor:: */@id=$idRef)  and not(name() = $idIdRefNode/name())">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-external-path-mismatch</xsl:with-param>
						<xsl:with-param name="test">not(name() = $idIdRefNode/name())</xsl:with-param>
						<!-- Placeholders -->
						<xsl:with-param name="param1" select="$idIdRefNode/name()"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@conref]" mode="conref-style-rules">
		<!--
			conref-not-lower-case - For all elements, @conref where it exists, filename must be lower case dash and separated.
		-->
		<xsl:variable name="isFileRef" select="not(starts-with(@conref, '#'))"/>
		<xsl:variable name="filePath" select="if (contains(@conref, '#'))  then resolve-uri(substring-before(@conref, '#'), resolve-uri('.', document-uri(/)))  else resolve-uri(@conref, resolve-uri('.', document-uri(/)))"/>
		<xsl:variable name="file" select="if ($isFileRef) then tokenize($filePath, '/')[last()] else ''"/>
		<xsl:if test="matches($file, '[A-Z_]+')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">conref-not-lower-case</xsl:with-param>
				<xsl:with-param name="test">matches(@conref, '[A-Z_]+')</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@colsep]" mode="colsep-style-rules">
		<!--
			colsep-invalid - For all elements, @colsep where it exists, must be 1 or 0.
		-->
		<xsl:if test="not(matches(@colsep, '^[0|1]$'))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">colsep-invalid</xsl:with-param>
				<xsl:with-param name="test">not(matches(@colsep, '^[0|1]$'))</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@href]" mode="href-style-rules">
		<!--
			href-not-lower-case - For all elements, @href where it exists, filename must be lower case dash and separated.
		-->
		<xsl:variable name="isWWWRef" select="starts-with(@href, 'http://') or starts-with(@href, 'https://')"/>
		<xsl:variable name="isFileRef" select="not($isWWWRef) and not(starts-with(@href, '#')) and not(contains(@href, 'file:/')) and not(contains(@href, 'mailto'))"/>
		<xsl:variable name="filePath" select="if (contains(@href, '#'))  then resolve-uri(substring-before(@href, '#'), resolve-uri('.', document-uri(/)))  else resolve-uri(@href, resolve-uri('.', document-uri(/)))"/>
		<xsl:variable name="file" select="if ($isFileRef) then tokenize($filePath, '/')[last()] else ''"/>
		<xsl:if test="matches($file, '[A-Z_]+')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">href-not-lower-case</xsl:with-param>
				<xsl:with-param name="test">matches(@href, '[A-Z_]+')</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template match="lq[@type]" mode="lq-structure-rules">
		<!--
			lq-type-deprecated - The type attribute is deprecated on lq elements
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">lq-type-deprecated</xsl:with-param>
			<xsl:with-param name="test">name() ='lq' and @type</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*[@refcols]" mode="refcols-structure-rules">
		<!--
			refcols-deprecated - The refcols attribute is deprecated
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">refcols-deprecated</xsl:with-param>
			<xsl:with-param name="test">@refcols</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*[@role]" mode="role-structure-rules">
		<xsl:if test="@role='sample'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">role-sample-deprecated</xsl:with-param>
				<xsl:with-param name="test">@role='sample''</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="@role='external'">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">role-external-deprecated</xsl:with-param>
				<xsl:with-param name="test">@role='external'</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@rowsep]" mode="rowsep-style-rules">
		<!--
			rowsep-invalid - For all elements, @rowsep where it exists, must be 1 or 0.
		-->
		<xsl:if test="not(matches(@rowsep, '^[0|1]$'))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">rowsep-invalid</xsl:with-param>
				<xsl:with-param name="test">not(matches(@rowsep, '^[0|1]$'))</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@id]" mode="id-style-rules">
		<!--
			id-not-lower-case - For all elements, @id where it exists, must be lower case and dash separated.
		-->
		<xsl:if test="matches(@id, '[A-Z_]+')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">id-not-lower-case</xsl:with-param>
				<xsl:with-param name="test">matches(@id, '[A-Z_]+')</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			id-not-unique - For all elements, @id where it exists, must be unique.
		-->
		<xsl:if test="@id = preceding:: */@id">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">id-not-unique</xsl:with-param>
				<xsl:with-param name="test">@id = preceding:: */@id</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			fig-id-invalid - For <fig>elements, ID for a	must start "fig-''
		-->
		<xsl:if test="(name() = 'fig') and not(starts-with(@id, 'fig-'))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">fig-id-invalid</xsl:with-param>
				<xsl:with-param name="test">(name() = 'table') and not(starts-with(@id, 'fig-'))</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			table-id-invalid - For <table>elements, ID must start "table-''
		-->
		<xsl:if test="(name() = 'table') and not(starts-with(@id, 'table-'))">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">table-id-invalid</xsl:with-param>
				<xsl:with-param name="test">(name() = 'table') and not(starts-with(@id, 'table-'))</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!--
		Common DITA Style Rules - checks for mandatory ID attributes
	-->
	<xsl:template match="*[not(@id)]" mode="id-style-rules">
		<xsl:apply-templates mode="id-mandatory" select="."/>
	</xsl:template>
	<xsl:template match="section|topic" mode="id-mandatory">
		<!--
			*-id-missing - For <section>and <topic>elements, ID is mandatory
		-->
		<xsl:call-template name="failed-assert">
			<xsl:with-param name="rule-id">
				<xsl:value-of select="name()"/>-id-missing</xsl:with-param>
			<xsl:with-param name="test">(name() = '
				<xsl:value-of select="name()"/>
				') and not(@id)</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="*" mode="id-mandatory"/>

</xsl:stylesheet>