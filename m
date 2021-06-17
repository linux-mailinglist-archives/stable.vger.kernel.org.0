Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2843AAA96
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 06:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhFQE7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 00:59:03 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:24491 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhFQE7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 00:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623905816; x=1655441816;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FhPyoTCQdd6PxIxdzyfFf2b7ixNGYH4zx5UBGvcDRYs=;
  b=NnD4oIavGCafMvuZCJgf81v42L5VahfERy3pujDt6JNsUSJTTLL1pCHk
   GXDU7u4o5op08ROzdD7lwra9tT6HUuXd8cjGjkMBO+WPaVWbxDfv1JvZz
   J7evuXCT5NP/BJivIlgwmz2fkbKWfYwRHL+dVUcRn0piisGWQBeVt3X3r
   SOFqw5kKgHfLuhe2Y4Ld0LY1cRk/7TB33UYMZw9Iaiq9GbO/55/I0cABG
   nK2mnE8gL74NNKH/oNMFmubXXLFXgBmmIAZFkaHdZ2W98FJQZq0mAN6CC
   hsPfPF5GFpcoC1NOuRxwRXKWvCproXbDwzFK54kPNid1gQpnaxsakgics
   w==;
IronPort-SDR: FoaDHPoI7AmUn/+0N7mf51MWbh71Lac8hOLHeamY3ibXcXPoqSkuEUVBEnfz1tvsJTfvsjCTBj
 E/U39onU9hrM43UZPPdh7sE6XClrcX2X5qn8qk2Ar+vyvHSKfI+o5EfbM7DpgMMyhxt43xAq6y
 RHfMKN7rF0/EQQf6iYuTn19AYsSA48bMQIe7d2YK7P3gSo4m7vhNdGaJ8ejo1oLcOxDW/OLeyg
 kFf1FOSzP5Iho1ONlXI1jNh/wY3jDMlj34n2mev2by2BxzOC4YCT/NNuCtBXRWDq4V+Gt6gdWe
 vRQ=
X-IronPort-AV: E=Sophos;i="5.83,278,1616428800"; 
   d="scan'208";a="171433731"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2021 12:56:56 +0800
IronPort-SDR: HA6kW7uRoWWRVlGJYJ/OP3JghFNl1LWhcdAbt5unraqLGRfEon65PtE80p1jiFpbZuGCvIQz3q
 AVureJNGVoDnKGzY9c6CxOR2hS9tJCK7AnqW97DmYJMtdIlt/96rnIlJRvvO4/g+ZTu7vS0V5/
 zqqGzxwCkYktDs6bvoaDOTDyytSJW/lcZ+6h8kgDvlS380rNEXIIqO9HB1nadHUuz9XSdy5gBa
 /mDP+i56prN/bzI0lhei/itR5vNeb7zQ4MVdBPKIj/ljfFmvvRu3+TWbShuhgr8wpNx5Y4lxjT
 sC8zxKu4QblGzgpf5LFjQHcl
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 21:35:45 -0700
IronPort-SDR: HFFdfobZb9P95QYmPHzOuFfNmgfExvqB4j8qt7j833qssQe3+BEeMRwgHf7j6DG0Xs9gzl6pKS
 /OHYYbWiZg7nRYcJBIqv+lL1w4wx8u7qqfAN9fMcTukkiZirIc6r+BZJql5iJVnc5jorkHqYtS
 sDaqIM35zkklU3cnnbg0kRw0qMuGKVWZeRH/wt58tYyELKy9nGdBQctvmsd810GgE4t6b0Ax27
 F8TJA300L0yxP17kF02aebTfr0IvbDUHScroMhldj8E6ofstHaqiRnOSKuOLdbrlsisOkDuGp7
 TKY=
WDCIronportException: Internal
Received: from gyd5zf2.ad.shared (HELO localhost.localdomain) ([10.225.50.171])
  by uls-op-cesaip02.wdc.com with ESMTP; 16 Jun 2021 21:56:55 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: fix negative space_info->bytes_readonly
Date:   Thu, 17 Jun 2021 13:56:18 +0900
Message-Id: <20210617045618.1179079-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Consider we have a using block group on zoned btrfs.

|<- ZU ->|<- used ->|<---free--->|
                     `- Alloc offset
ZU: Zone unusable

Marking the block group read-only will migrate the zone unusable bytes
to the read-only bytes. So, we will have this.

|<- RO ->|<- used ->|<--- RO --->|
RO: Read only

When marking it back to read-write, btrfs_dec_block_group_ro()
subtracts the above "RO" bytes from the
space_info->bytes_readonly. And, it moves the zone unusable bytes back
and again subtracts those bytes from the space_info->bytes_readonly,
leading to negative bytes_readonly.

This commit fixes the issue by reordering the operations.

Link: https://github.com/naota/linux/issues/37
Fixes: 169e0da91a21 ("btrfs: zoned: track unusable bytes for zones")
Cc: stable@vger.kernel.org # 5.12+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/block-group.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 38885b29e6e5..c42b6528552f 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2442,16 +2442,16 @@ void btrfs_dec_block_group_ro(struct btrfs_block_group *cache)
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 	if (!--cache->ro) {
-		num_bytes = cache->length - cache->reserved -
-			    cache->pinned - cache->bytes_super -
-			    cache->zone_unusable - cache->used;
-		sinfo->bytes_readonly -= num_bytes;
 		if (btrfs_is_zoned(cache->fs_info)) {
 			/* Migrate zone_unusable bytes back */
 			cache->zone_unusable = cache->alloc_offset - cache->used;
 			sinfo->bytes_zone_unusable += cache->zone_unusable;
 			sinfo->bytes_readonly -= cache->zone_unusable;
 		}
+		num_bytes = cache->length - cache->reserved -
+			    cache->pinned - cache->bytes_super -
+			    cache->zone_unusable - cache->used;
+		sinfo->bytes_readonly -= num_bytes;
 		list_del_init(&cache->ro_list);
 	}
 	spin_unlock(&cache->lock);
-- 
2.32.0

