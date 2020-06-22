Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F10F203E59
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 19:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgFVRuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 13:50:15 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:48017 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729886AbgFVRuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 13:50:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 565EA11F8;
        Mon, 22 Jun 2020 13:50:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 13:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AD3Seq
        gNK7pePFmFuy/aaM5SzIEv99lF1alN3TDBXxc=; b=YaJzcYKgk5VjCLp29LerJb
        /VyL/GSr7NgfJYXWN1F0l3yXiK19B4j30Cg8+b8wRFE4jeFi/0eNa706zH5KcGYr
        sJ1B8qraSmFpMAAN1Rzv3P17A1yEHdZwLTzt5EK4wpl9yz5YlumWscgEoV5ZkktV
        0NJFa/iT/HihcD9fE4Z+hwPNVcr1wRg7ebwvoVmMyt2WhNl4lG28go6P65nOpXVh
        f3F0Yj+jCOjYvizcMGxOyNnGlblzMP83ZfCNg3IvOqjopT8E1Zm9hDngCj6vvgMS
        pYt6uvqCZStKATYESapSt2+gEsqKm2UTTTz54RWSlQDfbZ3xJS8qLsVtUBdPjx7w
        ==
X-ME-Sender: <xms:Ve_wXmirU0AgTdNvmINWL2Z3xMGMdxixfhsMdDTO4S8C5peRk41GCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Ve_wXnCHdQsb6r1P_WPwWAEihsTVq9LlL-R4xNSdg5w1bbAt880vHQ>
    <xmx:Ve_wXuGiWWupKyT9jmsiZ0RcRsEsVKVIWX_5kQ6cnQ94wN3uluh9xA>
    <xmx:Ve_wXvTrz8cRgIfMHTJKpmUjP15Eb0cqAqY3LAr_salHqlyustEKOg>
    <xmx:Ve_wXhbbifRNd6F070JDhVPrIdSubbWVgy2UG2dUn2HDjLY6bSRJEa6-15Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77629328005A;
        Mon, 22 Jun 2020 13:50:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix partial cluster initialization when splitting" failed to apply to 4.14-stable tree
To:     jefflexu@linux.alibaba.com, enwlinux@gmail.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 19:50:09 +0200
Message-ID: <1592848209164101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From cfb3c85a600c6aa25a2581b3c1c4db3460f14e46 Mon Sep 17 00:00:00 2001
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Fri, 22 May 2020 12:18:44 +0800
Subject: [PATCH] ext4: fix partial cluster initialization when splitting
 extent

Fix the bug when calculating the physical block number of the first
block in the split extent.

This bug will cause xfstests shared/298 failure on ext4 with bigalloc
enabled occasionally. Ext4 error messages indicate that previously freed
blocks are being freed again, and the following fsck will fail due to
the inconsistency of block bitmap and bg descriptor.

The following is an example case:

1. First, Initialize a ext4 filesystem with cluster size '16K', block size
'4K', in which case, one cluster contains four blocks.

2. Create one file (e.g., xxx.img) on this ext4 filesystem. Now the extent
tree of this file is like:

...
36864:[0]4:220160
36868:[0]14332:145408
51200:[0]2:231424
...

3. Then execute PUNCH_HOLE fallocate on this file. The hole range is
like:

..
ext4_ext_remove_space: dev 254,16 ino 12 since 49506 end 49506 depth 1
ext4_ext_remove_space: dev 254,16 ino 12 since 49544 end 49546 depth 1
ext4_ext_remove_space: dev 254,16 ino 12 since 49605 end 49607 depth 1
...

4. Then the extent tree of this file after punching is like

...
49507:[0]37:158047
49547:[0]58:158087
...

5. Detailed procedure of punching hole [49544, 49546]

5.1. The block address space:
```
lblk        ~49505  49506   49507~49543     49544~49546    49547~
	  ---------+------+-------------+----------------+--------
	    extent | hole |   extent	|	hole	 | extent
	  ---------+------+-------------+----------------+--------
pblk       ~158045  158046  158047~158083  158084~158086   158087~
```

5.2. The detailed layout of cluster 39521:
```
		cluster 39521
	<------------------------------->

		hole		  extent
	<----------------------><--------

lblk      49544   49545   49546   49547
	+-------+-------+-------+-------+
	|	|	|	|	|
	+-------+-------+-------+-------+
pblk     158084  1580845  158086  158087
```

5.3. The ftrace output when punching hole [49544, 49546]:
- ext4_ext_remove_space (start 49544, end 49546)
  - ext4_ext_rm_leaf (start 49544, end 49546, last_extent [49507(158047), 40], partial [pclu 39522 lblk 0 state 2])
    - ext4_remove_blocks (extent [49507(158047), 40], from 49544 to 49546, partial [pclu 39522 lblk 0 state 2]
      - ext4_free_blocks: (block 158084 count 4)
        - ext4_mballoc_free (extent 1/6753/1)

5.4. Ext4 error message in dmesg:
EXT4-fs error (device vdb): mb_free_blocks:1457: group 1, block 158084:freeing already freed block (bit 6753); block bitmap corrupt.
EXT4-fs error (device vdb): ext4_mb_generate_buddy:747: group 1, block bitmap and bg descriptor inconsistent: 19550 vs 19551 free clusters

In this case, the whole cluster 39521 is freed mistakenly when freeing
pblock 158084~158086 (i.e., the first three blocks of this cluster),
although pblock 158087 (the last remaining block of this cluster) has
not been freed yet.

The root cause of this isuue is that, the pclu of the partial cluster is
calculated mistakenly in ext4_ext_remove_space(). The correct
partial_cluster.pclu (i.e., the cluster number of the first block in the
next extent, that is, lblock 49597 (pblock 158086)) should be 39521 rather
than 39522.

Fixes: f4226d9ea400 ("ext4: fix partial cluster initialization")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Eric Whitney <enwlinux@gmail.com>
Cc: stable@kernel.org # v3.19+
Link: https://lore.kernel.org/r/1590121124-37096-1-git-send-email-jefflexu@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7d088ff1e902..221f240eae60 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2844,7 +2844,7 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 			 * in use to avoid freeing it when removing blocks.
 			 */
 			if (sbi->s_cluster_ratio > 1) {
-				pblk = ext4_ext_pblock(ex) + end - ee_block + 2;
+				pblk = ext4_ext_pblock(ex) + end - ee_block + 1;
 				partial.pclu = EXT4_B2C(sbi, pblk);
 				partial.state = nofree;
 			}

