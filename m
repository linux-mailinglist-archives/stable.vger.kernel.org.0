Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B672576B1
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgHaJjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:39:32 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:43865 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbgHaJjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 05:39:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 1C0FC858;
        Mon, 31 Aug 2020 05:39:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 05:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oruvtm
        7J8U5EV9e2ZgxP64sO8TWU+n8b7MQyXyfsA4s=; b=AX+wXshHXoqYOGm7oGK0cw
        nPv0E+iGKIzvS5vIMIIOwakwsGRHgNoMYRSWqAecZOZcchiXM+WazebjT3B/hymL
        1R6yLSpPm1OeIfzhpJsF0b/YkQfOiUtXcKyNMl74CPmpNb/mpGogTR0jizPHoTRy
        Vz73YokBBKwjDA299LPcIMZuuNE2ZH7d+AQX0Y7e6CnNMCT0PvB24t+kLpyD/SvT
        MJkg3woC0Z4PVRho4tTKhScbmLqaS9Yy5Zq7Cg3t6zZNblUqoraBgSLvPtFpunD/
        yRR3pH+WujdlaZmUdZ07yPtZgrcD1l4Sy/DTCMDChSxuS6mwE9BEtj5yfRAlqH+Q
        ==
X-ME-Sender: <xms:UcVMX2IAe4p-sp6pePyxw9Wl8ce2OFNd8Wv9X_Ekhf1BSGKHTpqTYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:UcVMX-JRBRfog8t5uDwqJ6fvgpuD_zLGSgHpgPP-4FtFdZ9lXDuuSg>
    <xmx:UcVMX2tBjQR_9amtirFZBXSnJka7cIEFdmZkKGh-WazFMopYoYmZ3g>
    <xmx:UcVMX7ZocjZvWKlxBmGj1rPaJdmmB15M-WP-8_OM7knc1dsUCTH2Kg>
    <xmx:UcVMX_0e-eghjjwniTu9Z4tZZ5iz77__MOHdL4pqUi2HURP0zdCsO1ATeDg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F36130600A6;
        Mon, 31 Aug 2020 05:39:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: reset compression level for lzo on remount" failed to apply to 4.9-stable tree
To:     mpdesouza@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 11:39:37 +0200
Message-ID: <15988667771656@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 282dd7d7718444679b046b769d872b188818ca35 Mon Sep 17 00:00:00 2001
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 3 Aug 2020 16:55:01 -0300
Subject: [PATCH] btrfs: reset compression level for lzo on remount

Currently a user can set mount "-o compress" which will set the
compression algorithm to zlib, and use the default compress level for
zlib (3):

  relatime,compress=zlib:3,space_cache

If the user remounts the fs using "-o compress=lzo", then the old
compress_level is used:

  relatime,compress=lzo:3,space_cache

But lzo does not expose any tunable compression level. The same happens
if we set any compress argument with different level, also with zstd.

Fix this by resetting the compress_level when compress=lzo is
specified.  With the fix applied, lzo is shown without compress level:

  relatime,compress=lzo,space_cache

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e529ddb35b87..25967ecaaf0a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -625,6 +625,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			} else if (strncmp(args[0].from, "lzo", 3) == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
+				info->compress_level = 0;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);

