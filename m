Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275C911F7CC
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 13:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfLOMwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 07:52:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45297 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726101AbfLOMwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 07:52:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 754422215D;
        Sun, 15 Dec 2019 07:52:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 07:52:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pNcgPR
        TKhoX2KjkZopqIli1XhebVwtAzkuJbNhMioN8=; b=BdER9WykqeRygWQCz0mqJx
        rSycAqOzqSSJixc83vjFKA+/NSVSxXKKhzO4+qTgPUcCqR7Uk2+ts48BmxpSvaUz
        dzYq8NSd18OB/cqi+6hmR6cDihcG58t2ZCwIHiiH7dBAkWQ3z4rY8ZI7DqkgIuLG
        aNPf1HLKBMv+cRwm4GqxfVMJBQaAaJm2Qt9tIqu5U/ivzfPa5bZ0vMk3K9raGEfZ
        /WTg87pY5F0yZ6EgFtOGTJgut/TEAbIKWjXhPbyyvG8GsUimKoBraGrU580xNw0H
        t83WzrFLDG6UbBFhvz/RDzByzfynUhgzufwA3sHI0eSnKLWudquqHThy9H3qespQ
        ==
X-ME-Sender: <xms:fSz2XUqV_-4RcxL4cNzpsDHGyxxHapvDfKqrW0RzITEF_5jlMBufKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:fSz2Xa0ogOznLXd097XWDtEjCSMmnNHyyDOhzHJGtCZeBECIJWIwWQ>
    <xmx:fSz2Xb0kfLDqlec4euy1lBgj-TIo9IP_PDOAwrVlIG5Pws8mTgdQlg>
    <xmx:fSz2XXdpmcjgTVYC97FOCHV2F2F_kHryXvfzzg1tnuq9TtKRCgTdnQ>
    <xmx:fSz2XdJaAcX4AfFD9NSkZ4OoQ1SzCkk-4LD-LybUokzLsfRIyJPiBQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E6BA28005C;
        Sun, 15 Dec 2019 07:52:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] perf scripts python: exported-sql-viewer.py: Fix use of TRUE" failed to apply to 5.3-stable tree
To:     adrian.hunter@intel.com, acme@redhat.com, jolsa@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 13:52:01 +0100
Message-ID: <157641432117936@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From af833988c088d3fed3e7188e7c3dd9ca17178dc3 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 13 Nov 2019 14:02:06 +0200
Subject: [PATCH] perf scripts python: exported-sql-viewer.py: Fix use of TRUE
 with SQLite

Prior to version 3.23 SQLite does not support TRUE or FALSE, so always
use 1 and 0 for SQLite.

Fixes: 26c11206f433 ("perf scripts python: exported-sql-viewer.py: Use new 'has_calls' column")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.3+
Link: http://lore.kernel.org/lkml/20191113120206.26957-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/scripts/python/exported-sql-viewer.py b/tools/perf/scripts/python/exported-sql-viewer.py
index ebc6a2e5eae9..26d7be785288 100755
--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -637,7 +637,7 @@ class CallGraphRootItem(CallGraphLevelItemBase):
 		self.query_done = True
 		if_has_calls = ""
 		if IsSelectable(glb.db, "comms", columns = "has_calls"):
-			if_has_calls = " WHERE has_calls = TRUE"
+			if_has_calls = " WHERE has_calls = " + glb.dbref.TRUE
 		query = QSqlQuery(glb.db)
 		QueryExec(query, "SELECT id, comm FROM comms" + if_has_calls)
 		while query.next():
@@ -918,7 +918,7 @@ class CallTreeRootItem(CallGraphLevelItemBase):
 		self.query_done = True
 		if_has_calls = ""
 		if IsSelectable(glb.db, "comms", columns = "has_calls"):
-			if_has_calls = " WHERE has_calls = TRUE"
+			if_has_calls = " WHERE has_calls = " + glb.dbref.TRUE
 		query = QSqlQuery(glb.db)
 		QueryExec(query, "SELECT id, comm FROM comms" + if_has_calls)
 		while query.next():
@@ -1290,7 +1290,7 @@ class SwitchGraphData(GraphData):
 		QueryExec(query, "SELECT id, c_time"
 					" FROM comms"
 					" WHERE c_thread_id = " + str(thread_id) +
-					"   AND exec_flag = TRUE"
+					"   AND exec_flag = " + self.collection.glb.dbref.TRUE +
 					"   AND c_time >= " + str(start_time) +
 					"   AND c_time <= " + str(end_time) +
 					" ORDER BY c_time, id")
@@ -5016,6 +5016,12 @@ class DBRef():
 	def __init__(self, is_sqlite3, dbname):
 		self.is_sqlite3 = is_sqlite3
 		self.dbname = dbname
+		self.TRUE = "TRUE"
+		self.FALSE = "FALSE"
+		# SQLite prior to version 3.23 does not support TRUE and FALSE
+		if self.is_sqlite3:
+			self.TRUE = "1"
+			self.FALSE = "0"
 
 	def Open(self, connection_name):
 		dbname = self.dbname

