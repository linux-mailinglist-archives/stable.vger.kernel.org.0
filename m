Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0833233017B
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhCGN4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:56:04 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56665 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231512AbhCGNzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:55:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id ABD891A81;
        Sun,  7 Mar 2021 08:55:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:55:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JuGx4f
        yJU+6A/IGPDjr1JSJCjxz8pEo5p+orMWeO9K8=; b=Uim/UVHi7GqLc46SKOZUBA
        lESECHTm60cfdsB4XhSuo1WCeaPzlG6RrIAiQQFdQtABEL8t+eFnjSCB6QSzGvkf
        5WQALMMv6XtmOo6ZYG+AG+rFyhXSo6hxarvTYlJcoYezgjmAY+XHi5Tfa1Z5jca9
        8eh+ENitiA7ztzOyPWUzFCBAvAwyXP4Tei/Ek4xK1ZDl1qyNEWlynHkEcxKsvJBp
        0l3e1yxJHYQnrrk8chTMEY0Etry3cyxXPXqNkHRqHJ5zFWnvoCRR2JSRKfG/B7MF
        eiGSkHUqzN61b6HG1RKJM+ZEGRN86HNMukBxwQgdzdwdbHx2gF5Mke99WgBjUYmA
        ==
X-ME-Sender: <xms:Y9tEYClzFxI5j64C7ORmUEp91H9Y-GrJBXfnLW7ELsTwEZrzXfQZvg>
    <xme:Y9tEYJ36NMXROceAtqLmp2Igr7eJx6OSn2iw_k81Os2JoJ0sfD1unyqNSI4r2xhm7
    LQ6EM6FAYt4GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Y9tEYAob1LaEm6A1iVhXlfzPmNiE6kfK5EY2EqUzSYBhFxKxGhU1XQ>
    <xmx:Y9tEYGnrtUY3MnCDED1Av2jT2yr_0KqWRk5aswjx3xNBWUh_2jiSCA>
    <xmx:Y9tEYA1WBdx1FepoP4Mvs3EUGHwAOTpHlTEPHZ-0lix948FcIWdcbg>
    <xmx:Y9tEYOA3zuxHxd4zT8cR_s73KxVJXycK3DbRrPxkQ786suuJ2boV54b2JVM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 03E791080054;
        Sun,  7 Mar 2021 08:55:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm verity: fix FEC for RS roots unaligned to block size" failed to apply to 4.9-stable tree
To:     gmazyland@gmail.com, cJ-ko@zougloub.eu, samitolvanen@google.com,
        snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:55:45 +0100
Message-ID: <1615125345145189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From df7b59ba9245c4a3115ebaa905e3e5719a3810da Mon Sep 17 00:00:00 2001
From: Milan Broz <gmazyland@gmail.com>
Date: Tue, 23 Feb 2021 21:21:21 +0100
Subject: [PATCH] dm verity: fix FEC for RS roots unaligned to block size
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Optional Forward Error Correction (FEC) code in dm-verity uses
Reed-Solomon code and should support roots from 2 to 24.

The error correction parity bytes (of roots lengths per RS block) are
stored on a separate device in sequence without any padding.

Currently, to access FEC device, the dm-verity-fec code uses dm-bufio
client with block size set to verity data block (usually 4096 or 512
bytes).

Because this block size is not divisible by some (most!) of the roots
supported lengths, data repair cannot work for partially stored parity
bytes.

This fix changes FEC device dm-bufio block size to "roots << SECTOR_SHIFT"
where we can be sure that the full parity data is always available.
(There cannot be partial FEC blocks because parity must cover whole
sectors.)

Because the optional FEC starting offset could be unaligned to this
new block size, we have to use dm_bufio_set_sector_offset() to
configure it.

The problem is easily reproduced using veritysetup, e.g. for roots=13:

  # create verity device with RS FEC
  dd if=/dev/urandom of=data.img bs=4096 count=8 status=none
  veritysetup format data.img hash.img --fec-device=fec.img --fec-roots=13 | awk '/^Root hash/{ print $3 }' >roothash

  # create an erasure that should be always repairable with this roots setting
  dd if=/dev/zero of=data.img conv=notrunc bs=1 count=8 seek=4088 status=none

  # try to read it through dm-verity
  veritysetup open data.img test hash.img --fec-device=fec.img --fec-roots=13 $(cat roothash)
  dd if=/dev/mapper/test of=/dev/null bs=4096 status=noxfer
  # wait for possible recursive recovery in kernel
  udevadm settle
  veritysetup close test

With this fix, errors are properly repaired.
  device-mapper: verity-fec: 7:1: FEC 0: corrected 8 errors
  ...

Without it, FEC code usually ends on unrecoverable failure in RS decoder:
  device-mapper: verity-fec: 7:1: FEC 0: failed to correct: -74
  ...

This problem is present in all kernels since the FEC code's
introduction (kernel 4.5).

It is thought that this problem is not visible in Android ecosystem
because it always uses a default RS roots=2.

Depends-on: a14e5ec66a7a ("dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size")
Signed-off-by: Milan Broz <gmazyland@gmail.com>
Tested-by: Jérôme Carretero <cJ-ko@zougloub.eu>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Cc: stable@vger.kernel.org # 4.5+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index fb41b4f23c48..66f4c6398f67 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -61,19 +61,18 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
 static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 			   unsigned *offset, struct dm_buffer **buf)
 {
-	u64 position, block;
+	u64 position, block, rem;
 	u8 *res;
 
 	position = (index + rsb) * v->fec->roots;
-	block = position >> v->data_dev_block_bits;
-	*offset = (unsigned)(position - (block << v->data_dev_block_bits));
+	block = div64_u64_rem(position, v->fec->roots << SECTOR_SHIFT, &rem);
+	*offset = (unsigned)rem;
 
-	res = dm_bufio_read(v->fec->bufio, v->fec->start + block, buf);
+	res = dm_bufio_read(v->fec->bufio, block, buf);
 	if (IS_ERR(res)) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
 		      v->data_dev->name, (unsigned long long)rsb,
-		      (unsigned long long)(v->fec->start + block),
-		      PTR_ERR(res));
+		      (unsigned long long)block, PTR_ERR(res));
 		*buf = NULL;
 	}
 
@@ -155,7 +154,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 
 		/* read the next block when we run out of parity bytes */
 		offset += v->fec->roots;
-		if (offset >= 1 << v->data_dev_block_bits) {
+		if (offset >= v->fec->roots << SECTOR_SHIFT) {
 			dm_bufio_release(buf);
 
 			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
@@ -674,7 +673,7 @@ int verity_fec_ctr(struct dm_verity *v)
 {
 	struct dm_verity_fec *f = v->fec;
 	struct dm_target *ti = v->ti;
-	u64 hash_blocks;
+	u64 hash_blocks, fec_blocks;
 	int ret;
 
 	if (!verity_fec_is_enabled(v)) {
@@ -744,15 +743,17 @@ int verity_fec_ctr(struct dm_verity *v)
 	}
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
-					  1 << v->data_dev_block_bits,
+					  f->roots << SECTOR_SHIFT,
 					  1, 0, NULL, NULL);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
 		return PTR_ERR(f->bufio);
 	}
 
-	if (dm_bufio_get_device_size(f->bufio) <
-	    ((f->start + f->rounds * f->roots) >> v->data_dev_block_bits)) {
+	dm_bufio_set_sector_offset(f->bufio, f->start << (v->data_dev_block_bits - SECTOR_SHIFT));
+
+	fec_blocks = div64_u64(f->rounds * f->roots, v->fec->roots << SECTOR_SHIFT);
+	if (dm_bufio_get_device_size(f->bufio) < fec_blocks) {
 		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}

