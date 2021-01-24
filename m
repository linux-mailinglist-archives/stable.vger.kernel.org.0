Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E318B301C3D
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbhAXN3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:29:39 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54005 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbhAXN3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:29:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D82B8EAA;
        Sun, 24 Jan 2021 08:28:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:28:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8mPL5+
        yyY+qb4AYW7p6u9/47W9WgWDs4lx9FsajVsV4=; b=qv2ZpnKva91a5w5oGUs/vQ
        KObjAW/yfKILAmIeOKPPE4JZp/1mVeghxOLhErmA/9mX78ICz/x4AbtsnmrTclZv
        4x+lAkSf2u3B+OXXnRix7ISgCYB1vI/+njjLVcZl9pdDkVAQZwUQxOwZtZetoakz
        CPFagZ4ekbZvTyVVi7ZNIB0xgA3uHU33xmd3OH/aQ1rMn/hLGoY2ABhzmy+O56zg
        g9deHCms2k01AWFJdwexRjWMuSZCYAZtx4wXhg+LUPqb0DqMsPmU4eeFCwGTQzoc
        8vAZLpCP6dPLnhwAf44noOlvRnVH/3AxuPx0UL/tC+nH+wh1hdJU6SQtzuABO9Qw
        ==
X-ME-Sender: <xms:_XUNYCpA_M_zpYH2LDI018_bBvOSY-64GTsETek8i5y--mFWKEKTBQ>
    <xme:_XUNYAoquwoFzDuVgu4ZE-bQLOAidpVbnMPEbY5hMUVG06vBjqGw3kUENpEAvpJws
    fTJabrNz6BzWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:_XUNYHM6Dh4o1Et3vMOKUd-CLO1Di_BuTyAeXwPmoLi-ALB04eObYA>
    <xmx:_XUNYB6heXWWwfnHYgQGpU0Lz4aeFrqRqwih44neOagmUCjxdymhfA>
    <xmx:_XUNYB5SdhNup7sg9OEO0n6kUzSBAvn9MzSC7JwFLRvfC8ImdsCKmg>
    <xmx:_XUNYDRybLZ7Tk2MVc_7IiOXeuDKi4lh0YgFKSqT6sDTvGU9ZiKX-_M8gnE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EF341080059;
        Sun, 24 Jan 2021 08:28:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm integrity: conditionally disable "recalculate" feature" failed to apply to 4.4-stable tree
To:     mpatocka@redhat.com, dg@emlix.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:28:22 +0100
Message-ID: <1611494902108150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

