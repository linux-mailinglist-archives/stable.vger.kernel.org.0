Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5C6301C38
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbhAXN3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:29:08 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:43427 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbhAXN3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:29:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D8054EB1;
        Sun, 24 Jan 2021 08:28:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:28:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5IkqW9
        bpMVqqjYIGqqE6yUXv95+mZitnhDY4DMpZHbk=; b=MtQO0u6tm3ssElahwncqGb
        S9+gg6d5bKP08Bv+n0Vv9ZLaLORNMpkU7KcwkTVmkOjjAwME8yJ/w3k5g/0N3Ig1
        aG5mIwtEg/m2s+eXxZUAIW97V8/z1t+3+PtQtFP1YzpzjWgXQ0JrMgCxwzzmjoV9
        yhr59ZvltXyQpt/nknb/pho1IY1Pyg2g3kg/u/3bWgczQmqmuiuRG1v8PyTy3PW8
        pD8+GdymFtRQy5fXH/rYicHxUWxCOxHyFIpUDn9Y2bJagdw8nGGLbAGALqN20rpk
        SublAITMFZKVEWhV+NAfY1tiXEBevY21wMIJC+YW+ZK8xT8FN0jkc/qAKFj53NIA
        ==
X-ME-Sender: <xms:9XUNYJuw-8XScxsR1e6tsIMgu-x2NnFGRrzzzBU-i_hOv0Ul0TdUbg>
    <xme:9XUNYCeQr-356LGhGfSiaSv2oa_Tfk4-AktqVtaWsoxTXutfDjwM2Ku_ITxG9rpSP
    kOS9rjWbX48yQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:9XUNYMzCl5yR--RC4Al4kIxsN0lxknkW-A-c02RzyhrxBSON4PrqHg>
    <xmx:9XUNYAOllMYACxW4ntbB2VtycG58oMA49gYDjej-uQtRNPfbWU1VLg>
    <xmx:9XUNYJ-4kg4qWGZZqCFu98i3AB9aAYBdBpqCcxOfQsWEylzocPXwmA>
    <xmx:9XUNYLktbL1aWPU2v7_t9VX9pzDQ-yzXJNk4Gg7H0qhCgxnGrXmuZmIEWvY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0FFB1080059;
        Sun, 24 Jan 2021 08:28:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm integrity: conditionally disable "recalculate" feature" failed to apply to 5.4-stable tree
To:     mpatocka@redhat.com, dg@emlix.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:28:19 +0100
Message-ID: <161149489911460@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

