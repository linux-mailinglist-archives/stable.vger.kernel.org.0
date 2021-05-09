Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F7737762C
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 12:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhEIKLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 06:11:31 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:56245 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhEIKLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 06:11:31 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 1C6581A17;
        Sun,  9 May 2021 06:10:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 09 May 2021 06:10:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5rxmVy
        ug6cZ0dKBLHFZuGPOI+k5O0OMdszw0FfREtys=; b=M/soaqXX6c/YXqNSgdvVui
        BbCfKixvVMc0BW3fxXkj6i6LBafCN+pCYZgXYBCTnjJJD1s/VucC7/uqT356FfTv
        d0Fd/QJr3PW8PfChigccrd6ebaQAmhMZSarcy/4SPZt21aicnxKUoS5GtK65DZgl
        Bf0Rd+DPPNNtUEa0K/2SufXvwlxlsurijj0qWN7KiXYcKL3SqitT60ljDhoHMGIU
        67+31ACtQc17LCpNvY2TxGArdkT1o4P9g847LX47+kHDUqzYXxqKhJGbOxd/I64x
        gBJp9E7z2CdGYAsvRluUftj6k4tGqyvXqkxvOy8m9C9xHm8QJXag1vimlCv6PY/g
        ==
X-ME-Sender: <xms:E7WXYCOr3mHGrCa97HaEoAcEHsPGnTZCqjiKw583BfYZ5neAlRMeJg>
    <xme:E7WXYA9syh9ZMVVvUzRdNm7VwbZydDiyeQJkcgpFz5UgeXp1Bty__45B9d0eHQIEw
    9A74uGBZych8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:E7WXYJTUef3sXmqUiT0tonx_sqsnrhTQ29i3bZG4UMlF4DJdaVLIQQ>
    <xmx:E7WXYCvnL_drcWNUn2oR5oAtejuwL6vkLfhTtUnyNuuwLKT622XlWQ>
    <xmx:E7WXYKfT_eqn9T5n_bCdaUWKB4eGqaeboWAI7hyjJCVl06ntEsFhrw>
    <xmx:E7WXYLoOG_6zYS--5VvSWNzgAQhmIbck8wr-P3Z3a2feyMx96ASxuVbsA2Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 06:10:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] f2fs: fix to avoid out-of-bounds memory access" failed to apply to 4.9-stable tree
To:     chao@kernel.org, butterflyhuangxx@gmail.com, jaegeuk@kernel.org,
        yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 12:10:25 +0200
Message-ID: <162055502551185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From b862676e371715456c9dade7990c8004996d0d9e Mon Sep 17 00:00:00 2001
From: Chao Yu <chao@kernel.org>
Date: Mon, 22 Mar 2021 19:47:30 +0800
Subject: [PATCH] f2fs: fix to avoid out-of-bounds memory access

butt3rflyh4ck <butterflyhuangxx@gmail.com> reported a bug found by
syzkaller fuzzer with custom modifications in 5.12.0-rc3+ [1]:

 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x82/0x32c mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 f2fs_test_bit fs/f2fs/f2fs.h:2572 [inline]
 current_nat_addr fs/f2fs/node.h:213 [inline]
 get_next_nat_page fs/f2fs/node.c:123 [inline]
 __flush_nat_entry_set fs/f2fs/node.c:2888 [inline]
 f2fs_flush_nat_entries+0x258e/0x2960 fs/f2fs/node.c:2991
 f2fs_write_checkpoint+0x1372/0x6a70 fs/f2fs/checkpoint.c:1640
 f2fs_issue_checkpoint+0x149/0x410 fs/f2fs/checkpoint.c:1807
 f2fs_sync_fs+0x20f/0x420 fs/f2fs/super.c:1454
 __sync_filesystem fs/sync.c:39 [inline]
 sync_filesystem fs/sync.c:67 [inline]
 sync_filesystem+0x1b5/0x260 fs/sync.c:48
 generic_shutdown_super+0x70/0x370 fs/super.c:448
 kill_block_super+0x97/0xf0 fs/super.c:1394

The root cause is, if nat entry in checkpoint journal area is corrupted,
e.g. nid of journalled nat entry exceeds max nid value, during checkpoint,
once it tries to flush nat journal to NAT area, get_next_nat_page() may
access out-of-bounds memory on nat_bitmap due to it uses wrong nid value
as bitmap offset.

[1] https://lore.kernel.org/lkml/CAFcO6XOMWdr8pObek6eN6-fs58KG9doRFadgJj-FnF-1x43s2g@mail.gmail.com/T/#u

Reported-and-tested-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4b0e2e3c2c88..45c8cf1afe66 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2785,6 +2785,9 @@ static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
 		struct f2fs_nat_entry raw_ne;
 		nid_t nid = le32_to_cpu(nid_in_journal(journal, i));
 
+		if (f2fs_check_nid_range(sbi, nid))
+			continue;
+
 		raw_ne = nat_in_journal(journal, i);
 
 		ne = __lookup_nat_cache(nm_i, nid);

