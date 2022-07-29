Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C05585354
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 18:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbiG2QQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 12:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbiG2QQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 12:16:30 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE3987C3E;
        Fri, 29 Jul 2022 09:16:29 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id oy13so9388020ejb.1;
        Fri, 29 Jul 2022 09:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=PHtm+cBPWPPeTTd9kKHmMXm542fXD/fC4Zriuzo1dM8=;
        b=JgY3TSZurqMKW1iJJ62/yxHMRRNUCb3QF+Jqc+6lbXP3pWLTqoNQkyv4IKSaZXMpsA
         pEGuR4wP9VqDg7P0cgnIlaVzsSjF/thlgyAsX/EjbWPKXH1B+Ci0o7GP6rUQjg1Bz0Ug
         82/hAByGg2Rl2lpN8AizeMkRVmO39TbqKDyM4G5rKZoKzZ7HgtBYACQ7/yTEAVYw7y3/
         8O1CauSeJ1mXKoVvKPn6CxASwAdty77o+h2fj7Getlf/PiAxv/aKr2iXuedMfOTuFA0p
         hU5Tr/WEkDrvkQsdi6BVueGrndryaVhu9TD8hM4ZI22NAeQVFQR1zEqbWgHSdaprmrZF
         554A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=PHtm+cBPWPPeTTd9kKHmMXm542fXD/fC4Zriuzo1dM8=;
        b=uQP1/w04VmAGSfnSON6TtCbPyUgatTGtI/tkGFUGe4UtICkv19pbuXb2L4rFRgMHKi
         rp7r35vfK9DPYKUVu2roXXIMYXPc1336drHgCAck+rvJXJ1Ovya1xsdk2zq08jBH0YrY
         8p7nkRpJd/ji/8GrY3XZ3SEEX0azypDdl+htQ5cUUaW7jwA2w4KgzkyiVYDSJclPLGXn
         Lkrjvn3UZ1invoIjl3ekUw2YF/Zn54tHkKUUJcYaBRn/E0pGakDsw3fJ3kgsqpLxS4yP
         0JbR67sBzkvyLVybH5pvyNKziJlW8V/Uumv5tAP5Q1eBnruXepA1XOlsHthttIhAiA3a
         gtbQ==
X-Gm-Message-State: AJIora81n0T0BJz9sNjv2m2f4fNAnZYzXr6mZOhh1tTWgoU9l/SRCnqH
        lNUxL/L11jo70PSGTSlcyjE=
X-Google-Smtp-Source: AGRyM1uuSGxlBtDyJPJmn+K1uyqM5gRiAi4CzVP9TIDlYU9w/WmZxHfHQgA9qZyx08ZSrxhRXKJLHA==
X-Received: by 2002:a17:906:730c:b0:72b:4f83:51c1 with SMTP id di12-20020a170906730c00b0072b4f8351c1mr3451174ejc.515.1659111388398;
        Fri, 29 Jul 2022 09:16:28 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan (4.196.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.196.4])
        by smtp.gmail.com with ESMTPSA id fm15-20020a1709072acf00b0072b14836087sm1870116ejc.103.2022.07.29.09.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:16:27 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 v2 9/9] xfs: Enforce attr3 buffer recovery order
Date:   Fri, 29 Jul 2022 18:16:09 +0200
Message-Id: <20220729161609.4071252-10-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220729161609.4071252-1-amir73il@gmail.com>
References: <20220729161609.4071252-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit d8f4c2d0398fa1d92cacf854daf80d21a46bfefc upstream.

From the department of "WTAF? How did we miss that!?"...

When we are recovering a buffer, the first thing we do is check the
buffer magic number and extract the LSN from the buffer. If the LSN
is older than the current LSN, we replay the modification to it. If
the metadata on disk is newer than the transaction in the log, we
skip it. This is a fundamental v5 filesystem metadata recovery
behaviour.

generic/482 failed with an attribute writeback failure during log
recovery. The write verifier caught the corruption before it got
written to disk, and the attr buffer dump looked like:

XFS (dm-3): Metadata corruption detected at xfs_attr3_leaf_verify+0x275/0x2e0, xfs_attr3_leaf block 0x19be8
XFS (dm-3): Unmount and run xfs_repair
XFS (dm-3): First 128 bytes of corrupted metadata buffer:
00000000: 00 00 00 00 00 00 00 00 3b ee 00 00 4d 2a 01 e1  ........;...M*..
00000010: 00 00 00 00 00 01 9b e8 00 00 00 01 00 00 05 38  ...............8
                                  ^^^^^^^^^^^^^^^^^^^^^^^
00000020: df 39 5e 51 58 ac 44 b6 8d c5 e7 10 44 09 bc 17  .9^QX.D.....D...
00000030: 00 00 00 00 00 02 00 83 00 03 00 cc 0f 24 01 00  .............$..
00000040: 00 68 0e bc 0f c8 00 10 00 00 00 00 00 00 00 00  .h..............
00000050: 00 00 3c 31 0f 24 01 00 00 00 3c 32 0f 88 01 00  ..<1.$....<2....
00000060: 00 00 3c 33 0f d8 01 00 00 00 00 00 00 00 00 00  ..<3............
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
.....

The highlighted bytes are the LSN that was replayed into the
buffer: 0x100000538. This is cycle 1, block 0x538. Prior to replay,
that block on disk looks like this:

$ sudo xfs_db -c "fsb 0x417d" -c "type attr3" -c p /dev/mapper/thin-vol
hdr.info.hdr.forw = 0
hdr.info.hdr.back = 0
hdr.info.hdr.magic = 0x3bee
hdr.info.crc = 0xb5af0bc6 (correct)
hdr.info.bno = 105448
hdr.info.lsn = 0x100000900
               ^^^^^^^^^^^
hdr.info.uuid = df395e51-58ac-44b6-8dc5-e7104409bc17
hdr.info.owner = 131203
hdr.count = 2
hdr.usedbytes = 120
hdr.firstused = 3796
hdr.holes = 1
hdr.freemap[0-2] = [base,size]

Note the LSN stamped into the buffer on disk: 1/0x900. The version
on disk is much newer than the log transaction that was being
replayed. That's a bug, and should -never- happen.

So I immediately went to look at xlog_recover_get_buf_lsn() to check
that we handled the LSN correctly. I was wondering if there was a
similar "two commits with the same start LSN skips the second
replay" problem with buffers. I didn't get that far, because I found
a much more basic, rudimentary bug: xlog_recover_get_buf_lsn()
doesn't recognise buffers with XFS_ATTR3_LEAF_MAGIC set in them!!!

IOWs, attr3 leaf buffers fall through the magic number checks
unrecognised, so trigger the "recover immediately" behaviour instead
of undergoing an LSN check. IOWs, we incorrectly replay ATTR3 leaf
buffers and that causes silent on disk corruption of inode attribute
forks and potentially other things....

Git history shows this is *another* zero day bug, this time
introduced in commit 50d5c8d8e938 ("xfs: check LSN ordering for v5
superblocks during recovery") which failed to handle the attr3 leaf
buffers in recovery. And we've failed to handle them ever since...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 1d649462d731..b374c9cee117 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -796,6 +796,7 @@ xlog_recover_get_buf_lsn(
 	switch (magicda) {
 	case XFS_DIR3_LEAF1_MAGIC:
 	case XFS_DIR3_LEAFN_MAGIC:
+	case XFS_ATTR3_LEAF_MAGIC:
 	case XFS_DA3_NODE_MAGIC:
 		lsn = be64_to_cpu(((struct xfs_da3_blkinfo *)blk)->lsn);
 		uuid = &((struct xfs_da3_blkinfo *)blk)->uuid;
-- 
2.25.1

