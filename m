Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDF95528DF
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 03:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbiFUBGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 21:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbiFUBGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 21:06:21 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946AF12D32
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 18:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655773580; x=1687309580;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=dQqpTw+G0WnkIQNJjCvYecNoRx7eQ4MOgFUYcDyD+Ko=;
  b=hAzej4zJfAd8mup3TQt730df0xOtJ9hUkv5Bn3k3NOQ9VRNT/3rJ2qTC
   jgBIzkfbdcQxVYoKrVAusAzcCNiaK2yOcpltT8U1iy37ZhM2R3q0Q3ZTp
   w1C1Xl0+QuRNHYdgDRtiMtpDTyzvpZVP/EvKdTQQNnNgL+hlUiuFWtMIU
   3sftT+zmtrqu+m3dh105QmqOaeNAI8P62ijdZP1N4YEdEjuyKhjYM5IDp
   p7aWDSHo3xSzMRbXmRB5rzdazVaRd7p0vinRxkjOust55vlBHQZ9vIWR+
   +lOWt3pWt7o2udTGLnJebPM49rfggGQzGm5rIj0ucw+DlFE87m3ZOsM9k
   A==;
X-IronPort-AV: E=Sophos;i="5.92,207,1650902400"; 
   d="scan'208";a="202368482"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2022 09:06:20 +0800
IronPort-SDR: Ys92t+oNa4k+inB5HD+awIs06uXAwzrkUUE6FYA3umO22kRSJp7aRR0lFCOkiZfLrq8BvPvMsh
 FyNwQqTxzWI/1dxhe4wFvZa1GeCLIM6yvkgu01ScDm4gbpGIDKGAtEbcraS9SbRUrOqkPeoCCD
 QV4U+bJub0n9/ZCc7jofqIxuhuQOvG3PiSR8zczdirAEKRsOG2jfJ1/4FxALA04gDAddFlw52b
 JTMxbvYsDNRhBeciqtTTom2UbyjHAbQdzv8pEgPtVJ/R1M71SYDAgtrmOmi/Tg1LACL5k7rEDv
 8+IPT9DK7H8wjG3FaVz2DpUS
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jun 2022 17:28:51 -0700
IronPort-SDR: xISpYKhCzJuL4L/WRUMFBJ4YrYX6KFKJbWWjBv4MUsL2j3QutMizisbcL4t3fsaYmp3sV4QBfm
 oAAbJMR5U1ktnBDHYsoQIRL9+pn85d9C2W6YQk2L23o1leWiSsOcxwEScUbNd1R79NIYYTOW1u
 lagbKxLFZ5yaBUnzrgi7TwIzjIrw8URgsXv4Qdl7UCol/1927HR5xrtAe570RARXnbaCqvWDIZ
 6pCmyfSnXru5U2nIIVdjI6iYtM1yWJWHqNnHKPR1UMIAfvQ1LqVGtgiDH0kyrirr5rLx269g92
 hcI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jun 2022 18:06:21 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LRpHb6FRKz1SVp1
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 18:06:19 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1655773579; x=1658365580; bh=dQqpTw+G0WnkIQNJjC
        vYecNoRx7eQ4MOgFUYcDyD+Ko=; b=nIc1jF6IRJO9FFWYKr608EBWcj+C5ujD3j
        avM1yHg/uzuNb/3OMALkJO6yw/kUW6+/n9Oeq0YQF3WfFH4epYpnT3OZ6gpvjPse
        eUOk7JQSn02H7P2+PSeFG4JKMgAokpbbwPOd99NkgSCPGwUrLzpupUvvEgok+J2t
        GjLyvPtQN/5jb+NMs31SgxCNx9gUeL9H0ZXYGqwNuwMRz9Lq/JaimA9ePgGlXNFb
        f0649GA9Ad5Yo4QOZANzJJa3zBMJhz5t9Evmkd3AN7jlQsFbIFwrXCl31OGyJkC+
        9WZN+S/IQQ+Cu3pX6/eiq7UPu+PWbAwUaOghRHB17OplEqifEjsw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WOQRsAJAH5Gj for <stable@vger.kernel.org>;
        Mon, 20 Jun 2022 18:06:19 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LRpHZ6KWnz1SVnx;
        Mon, 20 Jun 2022 18:06:18 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] zonefs: fix zonefs_iomap_begin() for reads
Date:   Tue, 21 Jun 2022 10:06:17 +0900
Message-Id: <20220621010617.800101-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165572740383253@kroah.com>
References: <165572740383253@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c1c1204c0d0c1dccc1310b9277fb2bd8b663d8fe upstream

If a readahead is issued to a sequential zone file with an offset
exactly equal to the current file size, the iomap type is set to
IOMAP_UNWRITTEN, which will prevent an IO, but the iomap length is
calculated as 0. This causes a WARN_ON() in iomap_iter():

[17309.548939] WARNING: CPU: 3 PID: 2137 at fs/iomap/iter.c:34 iomap_iter=
+0x9cf/0xe80
[...]
[17309.650907] RIP: 0010:iomap_iter+0x9cf/0xe80
[...]
[17309.754560] Call Trace:
[17309.757078]  <TASK>
[17309.759240]  ? lock_is_held_type+0xd8/0x130
[17309.763531]  iomap_readahead+0x1a8/0x870
[17309.767550]  ? iomap_read_folio+0x4c0/0x4c0
[17309.771817]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[17309.778848]  ? lock_release+0x370/0x750
[17309.784462]  ? folio_add_lru+0x217/0x3f0
[17309.790220]  ? reacquire_held_locks+0x4e0/0x4e0
[17309.796543]  read_pages+0x17d/0xb60
[17309.801854]  ? folio_add_lru+0x238/0x3f0
[17309.807573]  ? readahead_expand+0x5f0/0x5f0
[17309.813554]  ? policy_node+0xb5/0x140
[17309.819018]  page_cache_ra_unbounded+0x27d/0x450
[17309.825439]  filemap_get_pages+0x500/0x1450
[17309.831444]  ? filemap_add_folio+0x140/0x140
[17309.837519]  ? lock_is_held_type+0xd8/0x130
[17309.843509]  filemap_read+0x28c/0x9f0
[17309.848953]  ? zonefs_file_read_iter+0x1ea/0x4d0 [zonefs]
[17309.856162]  ? trace_contention_end+0xd6/0x130
[17309.862416]  ? __mutex_lock+0x221/0x1480
[17309.868151]  ? zonefs_file_read_iter+0x166/0x4d0 [zonefs]
[17309.875364]  ? filemap_get_pages+0x1450/0x1450
[17309.881647]  ? __mutex_unlock_slowpath+0x15e/0x620
[17309.888248]  ? wait_for_completion_io_timeout+0x20/0x20
[17309.895231]  ? lock_is_held_type+0xd8/0x130
[17309.901115]  ? lock_is_held_type+0xd8/0x130
[17309.906934]  zonefs_file_read_iter+0x356/0x4d0 [zonefs]
[17309.913750]  new_sync_read+0x2d8/0x520
[17309.919035]  ? __x64_sys_lseek+0x1d0/0x1d0

Furthermore, this causes iomap_readahead() to loop forever as
iomap_readahead_iter() always returns 0, making no progress.

Fix this by treating reads after the file size as access to holes,
setting the iomap type to IOMAP_HOLE, the iomap addr to IOMAP_NULL_ADDR
and using the length argument as is for the iomap length. To simplify
the code with this change, zonefs_iomap_begin() is split into the read
variant, zonefs_read_iomap_begin() and zonefs_read_iomap_ops, and the
write variant, zonefs_write_iomap_begin() and zonefs_write_iomap_ops.

Reported-by: Jorgen Hansen <Jorgen.Hansen@wdc.com>
Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Jorgen Hansen <Jorgen.Hansen@wdc.com>
---
 fs/zonefs/super.c | 92 +++++++++++++++++++++++++++++++----------------
 1 file changed, 62 insertions(+), 30 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 8c7d01e907a3..bf5cb6efb8c0 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -68,15 +68,49 @@ static inline void zonefs_i_size_write(struct inode *=
inode, loff_t isize)
 		zi->i_flags &=3D ~ZONEFS_ZONE_OPEN;
 }
=20
-static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t=
 length,
-			      unsigned int flags, struct iomap *iomap,
-			      struct iomap *srcmap)
+static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
+				   loff_t length, unsigned int flags,
+				   struct iomap *iomap, struct iomap *srcmap)
 {
 	struct zonefs_inode_info *zi =3D ZONEFS_I(inode);
 	struct super_block *sb =3D inode->i_sb;
 	loff_t isize;
=20
-	/* All I/Os should always be within the file maximum size */
+	/*
+	 * All blocks are always mapped below EOF. If reading past EOF,
+	 * act as if there is a hole up to the file maximum size.
+	 */
+	mutex_lock(&zi->i_truncate_mutex);
+	iomap->bdev =3D inode->i_sb->s_bdev;
+	iomap->offset =3D ALIGN_DOWN(offset, sb->s_blocksize);
+	isize =3D i_size_read(inode);
+	if (iomap->offset >=3D isize) {
+		iomap->type =3D IOMAP_HOLE;
+		iomap->addr =3D IOMAP_NULL_ADDR;
+		iomap->length =3D length;
+	} else {
+		iomap->type =3D IOMAP_MAPPED;
+		iomap->addr =3D (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
+		iomap->length =3D isize - iomap->offset;
+	}
+	mutex_unlock(&zi->i_truncate_mutex);
+
+	return 0;
+}
+
+static const struct iomap_ops zonefs_read_iomap_ops =3D {
+	.iomap_begin	=3D zonefs_read_iomap_begin,
+};
+
+static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
+				    loff_t length, unsigned int flags,
+				    struct iomap *iomap, struct iomap *srcmap)
+{
+	struct zonefs_inode_info *zi =3D ZONEFS_I(inode);
+	struct super_block *sb =3D inode->i_sb;
+	loff_t isize;
+
+	/* All write I/Os should always be within the file maximum size */
 	if (WARN_ON_ONCE(offset + length > zi->i_max_size))
 		return -EIO;
=20
@@ -86,7 +120,7 @@ static int zonefs_iomap_begin(struct inode *inode, lof=
f_t offset, loff_t length,
 	 * operation.
 	 */
 	if (WARN_ON_ONCE(zi->i_ztype =3D=3D ZONEFS_ZTYPE_SEQ &&
-			 (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT)))
+			 !(flags & IOMAP_DIRECT)))
 		return -EIO;
=20
 	/*
@@ -95,45 +129,42 @@ static int zonefs_iomap_begin(struct inode *inode, l=
off_t offset, loff_t length,
 	 * write pointer) and unwriten beyond.
 	 */
 	mutex_lock(&zi->i_truncate_mutex);
+	iomap->bdev =3D inode->i_sb->s_bdev;
+	iomap->offset =3D ALIGN_DOWN(offset, sb->s_blocksize);
+	iomap->addr =3D (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
 	isize =3D i_size_read(inode);
-	if (offset >=3D isize)
+	if (iomap->offset >=3D isize) {
 		iomap->type =3D IOMAP_UNWRITTEN;
-	else
+		iomap->length =3D zi->i_max_size - iomap->offset;
+	} else {
 		iomap->type =3D IOMAP_MAPPED;
-	if (flags & IOMAP_WRITE)
-		length =3D zi->i_max_size - offset;
-	else
-		length =3D min(length, isize - offset);
+		iomap->length =3D isize - iomap->offset;
+	}
 	mutex_unlock(&zi->i_truncate_mutex);
=20
-	iomap->offset =3D ALIGN_DOWN(offset, sb->s_blocksize);
-	iomap->length =3D ALIGN(offset + length, sb->s_blocksize) - iomap->offs=
et;
-	iomap->bdev =3D inode->i_sb->s_bdev;
-	iomap->addr =3D (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
-
 	return 0;
 }
=20
-static const struct iomap_ops zonefs_iomap_ops =3D {
-	.iomap_begin	=3D zonefs_iomap_begin,
+static const struct iomap_ops zonefs_write_iomap_ops =3D {
+	.iomap_begin	=3D zonefs_write_iomap_begin,
 };
=20
 static int zonefs_readpage(struct file *unused, struct page *page)
 {
-	return iomap_readpage(page, &zonefs_iomap_ops);
+	return iomap_readpage(page, &zonefs_read_iomap_ops);
 }
=20
 static void zonefs_readahead(struct readahead_control *rac)
 {
-	iomap_readahead(rac, &zonefs_iomap_ops);
+	iomap_readahead(rac, &zonefs_read_iomap_ops);
 }
=20
 /*
  * Map blocks for page writeback. This is used only on conventional zone=
 files,
  * which implies that the page range can only be within the fixed inode =
size.
  */
-static int zonefs_map_blocks(struct iomap_writepage_ctx *wpc,
-			     struct inode *inode, loff_t offset)
+static int zonefs_write_map_blocks(struct iomap_writepage_ctx *wpc,
+				   struct inode *inode, loff_t offset)
 {
 	struct zonefs_inode_info *zi =3D ZONEFS_I(inode);
=20
@@ -147,12 +178,12 @@ static int zonefs_map_blocks(struct iomap_writepage=
_ctx *wpc,
 	    offset < wpc->iomap.offset + wpc->iomap.length)
 		return 0;
=20
-	return zonefs_iomap_begin(inode, offset, zi->i_max_size - offset,
-				  IOMAP_WRITE, &wpc->iomap, NULL);
+	return zonefs_write_iomap_begin(inode, offset, zi->i_max_size - offset,
+					IOMAP_WRITE, &wpc->iomap, NULL);
 }
=20
 static const struct iomap_writeback_ops zonefs_writeback_ops =3D {
-	.map_blocks		=3D zonefs_map_blocks,
+	.map_blocks		=3D zonefs_write_map_blocks,
 };
=20
 static int zonefs_writepage(struct page *page, struct writeback_control =
*wbc)
@@ -182,7 +213,8 @@ static int zonefs_swap_activate(struct swap_info_stru=
ct *sis,
 		return -EINVAL;
 	}
=20
-	return iomap_swapfile_activate(sis, swap_file, span, &zonefs_iomap_ops)=
;
+	return iomap_swapfile_activate(sis, swap_file, span,
+				       &zonefs_read_iomap_ops);
 }
=20
 static const struct address_space_operations zonefs_file_aops =3D {
@@ -612,7 +644,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct =
vm_fault *vmf)
=20
 	/* Serialize against truncates */
 	down_read(&zi->i_mmap_sem);
-	ret =3D iomap_page_mkwrite(vmf, &zonefs_iomap_ops);
+	ret =3D iomap_page_mkwrite(vmf, &zonefs_write_iomap_ops);
 	up_read(&zi->i_mmap_sem);
=20
 	sb_end_pagefault(inode->i_sb);
@@ -869,7 +901,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *io=
cb, struct iov_iter *from)
 	if (append)
 		ret =3D zonefs_file_dio_append(iocb, from);
 	else
-		ret =3D iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
+		ret =3D iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
 				   &zonefs_write_dio_ops, sync);
 	if (zi->i_ztype =3D=3D ZONEFS_ZTYPE_SEQ &&
 	    (ret > 0 || ret =3D=3D -EIOCBQUEUED)) {
@@ -911,7 +943,7 @@ static ssize_t zonefs_file_buffered_write(struct kioc=
b *iocb,
 	if (ret <=3D 0)
 		goto inode_unlock;
=20
-	ret =3D iomap_file_buffered_write(iocb, from, &zonefs_iomap_ops);
+	ret =3D iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops);
 	if (ret > 0)
 		iocb->ki_pos +=3D ret;
 	else if (ret =3D=3D -EIO)
@@ -1004,7 +1036,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *=
iocb, struct iov_iter *to)
 			goto inode_unlock;
 		}
 		file_accessed(iocb->ki_filp);
-		ret =3D iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
+		ret =3D iomap_dio_rw(iocb, to, &zonefs_read_iomap_ops,
 				   &zonefs_read_dio_ops, is_sync_kiocb(iocb));
 	} else {
 		ret =3D generic_file_read_iter(iocb, to);
--=20
2.36.1

