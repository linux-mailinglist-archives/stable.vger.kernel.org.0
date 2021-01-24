Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE40301C39
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbhAXN3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:29:12 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:46369 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbhAXN3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:29:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9DE72E77;
        Sun, 24 Jan 2021 08:28:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:28:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=faV2DQ
        lxicypihPF/LTVXFvgqytXcHxMnVB2qOLt+I8=; b=gzjHFRncmJh3HF+YyU6/EX
        PfojaMi+Y5ZAhpbE9f9lN280349Hrf+5x7zPhpzWkOeqUbV4e/Uf+IEGVz1p3hz0
        JXvINYCTfqyP2OfDzy8V+KvcgHKtC0Nu3hqyiCv72ek6xyCPPYyWEYmQ+7ySPULp
        bMuXN4iumObEybMZQ5GeZEd2WxptW8p3yi6scKmc8dbTR/uvS4XJCflmgFKUrXHM
        WPDfX9QaMqX6/zrQwOBjRcZcvxzOZaK8M1DtRLkvXcoLe+PCpr1DrMqhZrsjC7nG
        mn08pScegh4BP6nkf1KdpZl8IEMwBtZlmoeOumFpEoHVRIwuvB8UE4pxz/avmKCg
        ==
X-ME-Sender: <xms:-HUNYI-M8aYZqp8ueUtal_od5lyT2MdOHzTui6ddyAeyF0Of5lCndw>
    <xme:-HUNYAtv6_bvKV0ydSNerh12m1qyvev1jaUs6lT2sLugkGWkJnF0Jo4jlKVc-F5ce
    OkYilnM10XhgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:-HUNYOCBhoey52GmF8fbLoQD6BsAXVi4NtbyVuhxYugjhsPRVH5MZg>
    <xmx:-HUNYIf4V8yJS5O6Ip63CMi3c4BPGLCCJpfFF0mb7j4S-EAeliir7A>
    <xmx:-HUNYNPfdXWUHU94vhbGiNAUtAltXBe6HleyoFZkOH8MJlTS_DlVqA>
    <xmx:-HUNYL3tjNoXxGdE8ieEoe7AUzf6HUsSPQP-iYhPo_bqAufLGEjzS3AZDbc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA91724005A;
        Sun, 24 Jan 2021 08:28:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm integrity: conditionally disable "recalculate" feature" failed to apply to 4.14-stable tree
To:     mpatocka@redhat.com, dg@emlix.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:28:20 +0100
Message-ID: <1611494900207235@kroah.com>
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

From 5c02406428d5219c367c5f53457698c58bc5f917 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 20 Jan 2021 13:59:11 -0500
Subject: [PATCH] dm integrity: conditionally disable "recalculate" feature

Otherwise a malicious user could (ab)use the "recalculate" feature
that makes dm-integrity calculate the checksums in the background
while the device is already usable. When the system restarts before all
checksums have been calculated, the calculation continues where it was
interrupted even if the recalculate feature is not requested the next
time the dm device is set up.

Disable recalculating if we use internal_hash or journal_hash with a
key (e.g. HMAC) and we don't have the "legacy_recalculate" flag.

This may break activation of a volume, created by an older kernel,
that is not yet fully recalculated -- if this happens, the user should
add the "legacy_recalculate" flag to constructor parameters.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Daniel Glockner <dg@emlix.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 4e6f504474ac..2cc5488acbd9 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -177,14 +177,20 @@ bitmap_flush_interval:number
 	The bitmap flush interval in milliseconds. The metadata buffers
 	are synchronized when this interval expires.
 
+allow_discards
+	Allow block discard requests (a.k.a. TRIM) for the integrity device.
+	Discards are only allowed to devices using internal hash.
+
 fix_padding
 	Use a smaller padding of the tag area that is more
 	space-efficient. If this option is not present, large padding is
 	used - that is for compatibility with older kernels.
 
-allow_discards
-	Allow block discard requests (a.k.a. TRIM) for the integrity device.
-	Discards are only allowed to devices using internal hash.
+legacy_recalculate
+	Allow recalculating of volumes with HMAC keys. This is disabled by
+	default for security reasons - an attacker could modify the volume,
+	set recalc_sector to zero, and the kernel would not detect the
+	modification.
 
 The journal mode (D/J), buffer_sectors, journal_watermark, commit_time and
 allow_discards can be changed when reloading the target (load an inactive
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index cce203adcf77..b64fede032dc 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -257,8 +257,9 @@ struct dm_integrity_c {
 	bool journal_uptodate;
 	bool just_formatted;
 	bool recalculate_flag;
-	bool fix_padding;
 	bool discard;
+	bool fix_padding;
+	bool legacy_recalculate;
 
 	struct alg_spec internal_hash_alg;
 	struct alg_spec journal_crypt_alg;
@@ -386,6 +387,14 @@ static int dm_integrity_failed(struct dm_integrity_c *ic)
 	return READ_ONCE(ic->failed);
 }
 
+static bool dm_integrity_disable_recalculate(struct dm_integrity_c *ic)
+{
+	if ((ic->internal_hash_alg.key || ic->journal_mac_alg.key) &&
+	    !ic->legacy_recalculate)
+		return true;
+	return false;
+}
+
 static commit_id_t dm_integrity_commit_id(struct dm_integrity_c *ic, unsigned i,
 					  unsigned j, unsigned char seq)
 {
@@ -3140,6 +3149,7 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
 		arg_count += (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0;
+		arg_count += ic->legacy_recalculate;
 		DMEMIT("%s %llu %u %c %u", ic->dev->name, ic->start,
 		       ic->tag_size, ic->mode, arg_count);
 		if (ic->meta_dev)
@@ -3163,6 +3173,8 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		}
 		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0)
 			DMEMIT(" fix_padding");
+		if (ic->legacy_recalculate)
+			DMEMIT(" legacy_recalculate");
 
 #define EMIT_ALG(a, n)							\
 		do {							\
@@ -3792,7 +3804,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	unsigned extra_args;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 15, "Invalid number of feature args"},
+		{0, 16, "Invalid number of feature args"},
 	};
 	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
 	bool should_write_sb;
@@ -3940,6 +3952,8 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			ic->discard = true;
 		} else if (!strcmp(opt_string, "fix_padding")) {
 			ic->fix_padding = true;
+		} else if (!strcmp(opt_string, "legacy_recalculate")) {
+			ic->legacy_recalculate = true;
 		} else {
 			r = -EINVAL;
 			ti->error = "Invalid argument";
@@ -4243,6 +4257,14 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		}
 	}
 
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
+	    le64_to_cpu(ic->sb->recalc_sector) < ic->provided_data_sectors &&
+	    dm_integrity_disable_recalculate(ic)) {
+		ti->error = "Recalculating with HMAC is disabled for security reasons - if you really need it, use the argument \"legacy_recalculate\"";
+		r = -EOPNOTSUPP;
+		goto bad;
+	}
+
 	ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
 			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL);
 	if (IS_ERR(ic->bufio)) {

