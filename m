Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9ED2E3633
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgL1LJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:09:57 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50561 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgL1LJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:09:56 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 945CD7F2;
        Mon, 28 Dec 2020 06:09:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 28 Dec 2020 06:09:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=O9Ahvs
        Yz1iC3U7HJSPEKvfOhXNnp7Xkfbw9pZkEeRtg=; b=WF3VUu9X0UD8ZbTYk9jVXE
        GM0TA/oK/Tz6B7yNYtDo3lqsWu/uDKj6ydI8hdBCsFysIWjvYZFBV4v2wEjjQbAa
        iVBp0w8MKIfJ0KdUZ34UveBpi9m9VXlxmdgxYRxX706Swg9ZTFeip1hVB/IL49Bh
        j4jj142IchZorHrlfhnMKNxX0vw+Be9NWxcpYLZyHi0k6FKYABDrwbidp28fQ9an
        49H5+tVhsphKvgnOyyugQgDGt5tB53YgiMNEWfJGfG9BFhIxfB3MG+Ywtk1mqkP/
        9aZ9NJq7j52CvqhKoer484pBZYnXI+6AvMF44+YjfLmJmhNhbkzk1lQT/og0kY3g
        ==
X-ME-Sender: <xms:1bzpX6u6Ubw_79CykZq5ZgBp1dORfGXn5k3cKPwDm5JcVjhXNMwvjw>
    <xme:1bzpXzsSS52XMteJH2k-RlSgnqU-iQOh_W4FtWotxxn6HYFnstIFj0ivCiGISXhvs
    Fyl5ljKUq_yEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1bzpXwyyZiUeJzL_Ky8t3bOgNfX25nyyHA0SoIFotlO4PiKNIUc7_g>
    <xmx:1bzpX5igv8qy8xVScJsFCcOWMNcgRSINuJV44h2bqn2DST9EW6MYxQ>
    <xmx:1bzpX0CQkzJ8TgH6akZLiKLGli_OocoCKcXGW77T2QuwmWiJzxjLQQ>
    <xmx:1rzpX-9eyDuG98szi4s5SImh4oX7kxDKWeEUQI8uvJKJh-8DLlHYiPb3PJk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B0B85240057;
        Mon, 28 Dec 2020 06:09:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix crash during driver load on big endian" failed to apply to 4.14-stable tree
To:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:10:30 +0100
Message-ID: <1609153830245194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8de309e7299a00b3045fb274f82b326f356404f0 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Wed, 2 Dec 2020 05:23:04 -0800
Subject: [PATCH] scsi: qla2xxx: Fix crash during driver load on big endian
 machines

Crash stack:
	[576544.715489] Unable to handle kernel paging request for data at address 0xd00000000f970000
	[576544.715497] Faulting instruction address: 0xd00000000f880f64
	[576544.715503] Oops: Kernel access of bad area, sig: 11 [#1]
	[576544.715506] SMP NR_CPUS=2048 NUMA pSeries
	:
	[576544.715703] NIP [d00000000f880f64] .qla27xx_fwdt_template_valid+0x94/0x100 [qla2xxx]
	[576544.715722] LR [d00000000f7952dc] .qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
	[576544.715726] Call Trace:
	[576544.715731] [c0000004d0ffb000] [c0000006fe02c350] 0xc0000006fe02c350 (unreliable)
	[576544.715750] [c0000004d0ffb080] [d00000000f7952dc] .qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
	[576544.715770] [c0000004d0ffb170] [d00000000f7aa034] .qla81xx_load_risc+0x84/0x1a0 [qla2xxx]
	[576544.715789] [c0000004d0ffb210] [d00000000f79f7c8] .qla2x00_setup_chip+0xc8/0x910 [qla2xxx]
	[576544.715808] [c0000004d0ffb300] [d00000000f7a631c] .qla2x00_initialize_adapter+0x4dc/0xb00 [qla2xxx]
	[576544.715826] [c0000004d0ffb3e0] [d00000000f78ce28] .qla2x00_probe_one+0xf08/0x2200 [qla2xxx]

Link: https://lore.kernel.org/r/20201202132312.19966-8-njavali@marvell.com
Fixes: f73cb695d3ec ("[SCSI] qla2xxx: Add support for ISP2071.")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 84f4416d366f..a6bb1c0e2245 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -928,7 +928,8 @@ qla27xx_template_checksum(void *p, ulong size)
 static inline int
 qla27xx_verify_template_checksum(struct qla27xx_fwdt_template *tmp)
 {
-	return qla27xx_template_checksum(tmp, tmp->template_size) == 0;
+	return qla27xx_template_checksum(tmp,
+		le32_to_cpu(tmp->template_size)) == 0;
 }
 
 static inline int
@@ -944,7 +945,7 @@ qla27xx_execute_fwdt_template(struct scsi_qla_host *vha,
 	ulong len = 0;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		tmp = memcpy(buf, tmp, len);
 		ql27xx_edit_template(vha, tmp);
 		qla27xx_walk_template(vha, tmp, buf, &len);
@@ -960,7 +961,7 @@ qla27xx_fwdt_calculate_dump_size(struct scsi_qla_host *vha, void *p)
 	ulong len = 0;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		qla27xx_walk_template(vha, tmp, NULL, &len);
 	}
 
@@ -972,7 +973,7 @@ qla27xx_fwdt_template_size(void *p)
 {
 	struct qla27xx_fwdt_template *tmp = p;
 
-	return tmp->template_size;
+	return le32_to_cpu(tmp->template_size);
 }
 
 int
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h b/drivers/scsi/qla2xxx/qla_tmpl.h
index c47184db5081..6e0987edfceb 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -12,7 +12,7 @@
 struct __packed qla27xx_fwdt_template {
 	__le32 template_type;
 	__le32 entry_offset;
-	uint32_t template_size;
+	__le32 template_size;
 	uint32_t count;		/* borrow field for running/residual count */
 
 	__le32 entry_count;

