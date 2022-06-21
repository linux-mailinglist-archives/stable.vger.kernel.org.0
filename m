Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E288A5528D7
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 02:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbiFUA6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 20:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241445AbiFUA6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 20:58:22 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1856479
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 17:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655773100; x=1687309100;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=C7FAGDn/hE3aml/Dp3K/pl19DAZ7KNz0oSLCuErRe28=;
  b=muD23eh/zTe/KUt8NFw/LbTVS5olgYujISHrsj4IEPjmaFp9xcDCpSOa
   2Os63VCMpfftkEEq7AwpM//fmsWYDGtrrdMnyPiVtgynW1z/OQNd0x2tx
   CyqImrAktHxviPkHfNjOfV/CEqYO+/iUbdzyUrqd9mftzk8LP/ECnjqcz
   UT/XV16D0PfntjrCwFwj+BtcrDnz/i19SH+SIraTZzFGYqKh1c2qrRkId
   OUBz2E9eP/9inIyxUZO9BmWsghTfM0aOipWFLBSejfsTh9LOO5sEbQ5dL
   TxEd8L7/koiMfr/VJFVkRv+NSEzYj+TmO93N35zyeGfdP3Wo0MzqLrb4M
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,207,1650902400"; 
   d="scan'208";a="203667815"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2022 08:58:20 +0800
IronPort-SDR: IZICWWXmKHr42wodL0QU+Q7O9w7Z5RjS8nT6rYYFhvliSe7bsHprXSwltnIDyvLFmwKWJ5qJPZ
 BYvoGyvAI4G0Pwlx2h9IcVee9Bbn6yKYIqoLj7L085VLlFtCOQoT1IBff33LDyxL7UP2lmcT7K
 IhmCyJG1wHRNarvTJhkaYXhsxChkPSsZGlgATrfuzagkSnzR9+1ghK1HfNrGPrllp+94iUqOmE
 DOpmzt3SyWd9+LUbSbCtGxpn8f/F7oeb1aUw2vyVnkjgYF7dcZKeamXoIaCyfAKwWgax6ruu6E
 ZsyHWLyCpnTq5xrDkVZ0jBBN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jun 2022 17:20:51 -0700
IronPort-SDR: LLsdv/SPKlIfow+MVKYyVBOvNlcRtJNNyt2PHJfFD/qXFZKIe3PkICIhOTtkx8ci1Ee58V0UIX
 ZZgXLR/SxuR0f/kaMHqTEnOOgHJlA1QUG0fB07GCUgUUWx0KqUSwzfkGbBMAaiFdirQwrRJZzI
 6ibE1zTdETfiHy6dtja4f8/u6da5tPoOJkcAM4NPVevYW0VR0FP6Z7v12k3gMktmtmalGnl7RZ
 k8rtzw7krd3yMa6cH4ZQYdQYHfFR+nGs6GFyAraKuJEhtEKA81LIaHYUNgx6+897NCOhot6WMT
 XBY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Jun 2022 17:58:21 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LRp6N0hWZz1SVp1
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 17:58:20 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1655773099; x=1658365100; bh=C7FAGDn/hE3aml/Dp3
        K/pl19DAZ7KNz0oSLCuErRe28=; b=U7aV5feJFVPPBbFFV8ukVWoVT/LydZtRo0
        lzISq/JEk3dIflt2LMbyt7zVaO7YWwBmWPwH/8z77f/Gl0+tEWn0B+FDdkzUOrMs
        GY1JpxQ5u/uHjRZ8ksbeXjSJd/biVP3rUt05ldxD6DYliUAhCZ11D6fqvcwgK2KR
        F4rioUDDrSnmP4FtR55r/s2hmHBrUSbn1qHNrvapzCorYu8E1C+0BJTwa+4YB1ap
        sRXfP0REqHSGl+Odyb4N/nwY9ynMNt0EDErR7F1+NFp1cmSEcJToHjshSFoXD7GD
        ObQSh2Pm0jbZU01fuvYszTo5qIw2MoKAGcadEMRK39pg82qsvcfg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4PdeG4iHTb6v for <stable@vger.kernel.org>;
        Mon, 20 Jun 2022 17:58:19 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LRp6M0hf5z1SVnx;
        Mon, 20 Jun 2022 17:58:18 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] zonefs: fix zonefs_iomap_begin() for reads
Date:   Tue, 21 Jun 2022 09:58:17 +0900
Message-Id: <20220621005817.706795-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165572740210477@kroah.com>
References: <165572740210477@kroah.com>
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
 fs/zonefs/super.c | 94 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 30 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 1c2ece961128..15a4c7c07a3b 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -72,15 +72,51 @@ static inline void zonefs_i_size_write(struct inode *=
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
+	trace_zonefs_iomap_begin(inode, iomap);
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
@@ -90,7 +126,7 @@ static int zonefs_iomap_begin(struct inode *inode, lof=
f_t offset, loff_t length,
 	 * operation.
 	 */
 	if (WARN_ON_ONCE(zi->i_ztype =3D=3D ZONEFS_ZTYPE_SEQ &&
-			 (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT)))
+			 !(flags & IOMAP_DIRECT)))
 		return -EIO;
=20
 	/*
@@ -99,47 +135,44 @@ static int zonefs_iomap_begin(struct inode *inode, l=
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
 	trace_zonefs_iomap_begin(inode, iomap);
=20
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
@@ -153,12 +186,12 @@ static int zonefs_map_blocks(struct iomap_writepage=
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
@@ -188,7 +221,8 @@ static int zonefs_swap_activate(struct swap_info_stru=
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
@@ -607,7 +641,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct =
vm_fault *vmf)
=20
 	/* Serialize against truncates */
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	ret =3D iomap_page_mkwrite(vmf, &zonefs_iomap_ops);
+	ret =3D iomap_page_mkwrite(vmf, &zonefs_write_iomap_ops);
 	filemap_invalidate_unlock_shared(inode->i_mapping);
=20
 	sb_end_pagefault(inode->i_sb);
@@ -860,7 +894,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *io=
cb, struct iov_iter *from)
 	if (append)
 		ret =3D zonefs_file_dio_append(iocb, from);
 	else
-		ret =3D iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
+		ret =3D iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
 				   &zonefs_write_dio_ops, 0, 0);
 	if (zi->i_ztype =3D=3D ZONEFS_ZTYPE_SEQ &&
 	    (ret > 0 || ret =3D=3D -EIOCBQUEUED)) {
@@ -902,7 +936,7 @@ static ssize_t zonefs_file_buffered_write(struct kioc=
b *iocb,
 	if (ret <=3D 0)
 		goto inode_unlock;
=20
-	ret =3D iomap_file_buffered_write(iocb, from, &zonefs_iomap_ops);
+	ret =3D iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops);
 	if (ret > 0)
 		iocb->ki_pos +=3D ret;
 	else if (ret =3D=3D -EIO)
@@ -995,7 +1029,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *i=
ocb, struct iov_iter *to)
 			goto inode_unlock;
 		}
 		file_accessed(iocb->ki_filp);
-		ret =3D iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
+		ret =3D iomap_dio_rw(iocb, to, &zonefs_read_iomap_ops,
 				   &zonefs_read_dio_ops, 0, 0);
 	} else {
 		ret =3D generic_file_read_iter(iocb, to);
--=20
2.36.1

