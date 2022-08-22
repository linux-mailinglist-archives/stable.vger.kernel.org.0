Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5345859B8FB
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 08:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiHVGHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 02:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiHVGH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 02:07:29 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFFC20BD6;
        Sun, 21 Aug 2022 23:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661148448; x=1692684448;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GUuSyLB9RAxe6gl0cgCTwUI/qzd/Th5hOKBPDk0zlfM=;
  b=Uop8mjH3Bm/vazq3D5PHofroYaw1THjZR+iZIwKbkBHm2aoAYXrRLYv9
   nc3ixVYcB7dtvT0BuTO3DByqLr4mj4YfBathobqf0tZlKCcs0OSPw3jsf
   p0IAIlFAwR0WE+bkZcUWDc+hJs6kEegJraPaGDCop2N9e1iIWDVlIVvst
   UQKssxKYcuRxb4/T78wnNxxCK53BODOJB6bOJwfyEIaa9KP8Um+4r8vtv
   C8CqssSXcOyp52hWH43PccZoB+69AZ28IQHkCrOqI38Bc38JKygAB2RJ1
   anJzVlwVd5+C4cqqTtw8HxENU8sX6ff4M+YPteA6NHrMAv5YSBGmL5j8D
   A==;
X-IronPort-AV: E=Sophos;i="5.93,254,1654531200"; 
   d="scan'208";a="321397067"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2022 14:07:27 +0800
IronPort-SDR: 6KODIXRnUea+zsPIwxLXBBNZqiOtW+m9mwBT9v+KZAjuccx1cQ6Z1L3uBwAgl2fr/xFZPwg9nR
 3fo+nmmTLQAIqRI93o4uCIMbZxOosLK8iyQzFgY7UYkm0o9qgfkA9fJVa1pEY2/HfTv98K0Ag1
 MGfiX75a8hN937UUHSnj1Uec+fMJRyho/CPl90xKUYt57Y6ClEwMHVV0Ygg5cGcmaV+bbTPHze
 08IoWv7TiaKVmSmKMM6hosEiD4Ht8QeJWEMnsKWXH68VlCIo1wgTLMjTVn+FP+tua7q7kYUXR+
 sf6c/qZm3HM5gjE405ticCIx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Aug 2022 22:28:09 -0700
IronPort-SDR: CGXKaHPCxhDOpVcn+GIrlR/MWZGU7aMUcXU1ylo3j75Vduqpv0mRhDsRwBptMCmO9jqbXKzEcU
 A6g21Oz1SPQaExqccyKBQP/2WL0pvNEtjc4BwsSpqoaA7jKe6CfiXbRy2YwNGn5s3O/I2KQwnv
 WNfSeML9z7tFA4biQ30vb3PR6JXgO2mWfgRpr04FY4sgg2TT1FI0+wVhBlgCvXTdVH0BHcLKfP
 xRJOCFGHS/aKq9YxytkYlHd4gEfWxTlE+u1tOJnQLJPXb6Fpdro8ml8qOuohhLoEpjRWNyshxI
 NFQ=
WDCIronportException: Internal
Received: from unknown (HELO naota-xeon.wdc.com) ([10.225.50.191])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Aug 2022 23:07:26 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH STABLE 5.15 0/5] btrfs: zoned: backport max_extent_size fix
Date:   Mon, 22 Aug 2022 15:06:59 +0900
Message-Id: <20220822060704.1278361-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These patches are backport for the 5.15 branch.

This series backports fixes for expecting the number of on-going write
extents on zoned mode.

It picks up patches 1 to 3 for the dependencies of patches 4 and 5.

Christoph Hellwig (1):
  block: add a bdev_max_zone_append_sectors helper

Naohiro Aota (4):
  block: add bdev_max_segments() helper
  btrfs: zoned: revive max_zone_append_bytes
  btrfs: replace BTRFS_MAX_EXTENT_SIZE with fs_info->max_extent_size
  btrfs: convert count_max_extents() to use fs_info->max_extent_size

 drivers/nvme/target/zns.c |  3 +--
 fs/btrfs/ctree.h          | 29 +++++++++++++++++++++--------
 fs/btrfs/delalloc-space.c |  6 +++---
 fs/btrfs/disk-io.c        |  2 ++
 fs/btrfs/extent_io.c      |  4 +++-
 fs/btrfs/inode.c          | 22 ++++++++++++----------
 fs/btrfs/zoned.c          | 20 ++++++++++++++++++++
 fs/btrfs/zoned.h          |  1 +
 fs/zonefs/super.c         |  3 +--
 include/linux/blkdev.h    | 11 +++++++++++
 10 files changed, 75 insertions(+), 26 deletions(-)

-- 
2.37.2

