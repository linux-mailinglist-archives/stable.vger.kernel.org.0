Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D1C696F92
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjBNV1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbjBNV1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:16 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAB32107;
        Tue, 14 Feb 2023 13:26:40 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id ja21so10764590plb.13;
        Tue, 14 Feb 2023 13:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZIp7USMvmmqB5f9NmVrSQj28kTFZM5zKd61/LPwcFk=;
        b=gbkb0p23ODyB/KVw7h8ZXEn0zBgKG2kCYMXtaLIMU/Ca9pcmAjnqwl7mopVImnZvYb
         boDeqH0aUaLAXIm8Gg3XPRdQWNIrHVm/oOVNAc9eWCkkMB0r8+QMCvJcH+UXddI0mPkg
         dBuELBIZPxeKdJBQ1tzR61UJan5bgqdbdHnTTIP9U6AO2ulKZ7O+k6y2UmWLXZYegNES
         S13UgDogThNTzvvOoGBj1AQLmjr3RjUujSuQ9VJlWlZRkGcUpQPS9ozVI7GYPQ1X1pMB
         fXVgTgWMhwQ9/bYaXm7N+qPKlxvwtjm3xXIQnkEJ5NvtHK/zz/z9xDQ4NeML+WJ0PRgc
         3zvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZIp7USMvmmqB5f9NmVrSQj28kTFZM5zKd61/LPwcFk=;
        b=VXhkbHLT72l9T1B8UiIrAulbCBchHUQS4CUc1Y3aRdbWC+seweJKKMzp3q+S3BkmlM
         EZJ4ZQS2A/L8dojpN1ALl5NllJDsYG6+pMgKfRGmuOO+xDbLqNOWSiOnfa9+sRe+nS8p
         58R8+mpDNL3YRvCloY3HQ+yU3U/slvgC9SdgU2ezXtgioVKId9jRGgTwL3NOQ0pnLbw1
         P032DfH35QNibNe5yoPGXby+DGci5OI/p7vAuZntv6MJJBmNl1Z0GMQWNjwZ7BMyhS/3
         /PFLR0z4/wKr1Feqgqv7SJ097TvFGAe1/xy084vC2T/R9tr72TjQwIujpKXgS99uj4m5
         Nemw==
X-Gm-Message-State: AO0yUKWlCGgOOq/vhbArHPLwfKKkFKY44aXMslEJ5sckF+LNcw/mwTzG
        xHEQEY8oc6cwUbiWZNm04eHxNhUdCUWX5g==
X-Google-Smtp-Source: AK7set9yb2lRi9+zjzzTmKpjlOphnWF/mIGOpSPyGj5vmWKmg9BXPJItMJsUDsuOWP2xRsMjhud57g==
X-Received: by 2002:a17:902:f68f:b0:198:def1:62cc with SMTP id l15-20020a170902f68f00b00198def162ccmr145537plg.2.1676409976797;
        Tue, 14 Feb 2023 13:26:16 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:16 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 10/10] xfs: don't leak btree cursor when insrec fails after a split
Date:   Tue, 14 Feb 2023 13:25:34 -0800
Message-Id: <20230214212534.1420323-11-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230214212534.1420323-1-leah.rumancik@gmail.com>
References: <20230214212534.1420323-1-leah.rumancik@gmail.com>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit a54f78def73d847cb060b18c4e4a3d1d26c9ca6d ]

The recent patch to improve btree cycle checking caused a regression
when I rebased the in-memory btree branch atop the 5.19 for-next branch,
because in-memory short-pointer btrees do not have AG numbers.  This
produced the following complaint from kmemleak:

unreferenced object 0xffff88803d47dde8 (size 264):
  comm "xfs_io", pid 4889, jiffies 4294906764 (age 24.072s)
  hex dump (first 32 bytes):
    90 4d 0b 0f 80 88 ff ff 00 a0 bd 05 80 88 ff ff  .M..............
    e0 44 3a a0 ff ff ff ff 00 df 08 06 80 88 ff ff  .D:.............
  backtrace:
    [<ffffffffa0388059>] xfbtree_dup_cursor+0x49/0xc0 [xfs]
    [<ffffffffa029887b>] xfs_btree_dup_cursor+0x3b/0x200 [xfs]
    [<ffffffffa029af5d>] __xfs_btree_split+0x6ad/0x820 [xfs]
    [<ffffffffa029b130>] xfs_btree_split+0x60/0x110 [xfs]
    [<ffffffffa029f6da>] xfs_btree_make_block_unfull+0x19a/0x1f0 [xfs]
    [<ffffffffa029fada>] xfs_btree_insrec+0x3aa/0x810 [xfs]
    [<ffffffffa029fff3>] xfs_btree_insert+0xb3/0x240 [xfs]
    [<ffffffffa02cb729>] xfs_rmap_insert+0x99/0x200 [xfs]
    [<ffffffffa02cf142>] xfs_rmap_map_shared+0x192/0x5f0 [xfs]
    [<ffffffffa02cf60b>] xfs_rmap_map_raw+0x6b/0x90 [xfs]
    [<ffffffffa0384a85>] xrep_rmap_stash+0xd5/0x1d0 [xfs]
    [<ffffffffa0384dc0>] xrep_rmap_visit_bmbt+0xa0/0xf0 [xfs]
    [<ffffffffa0384fb6>] xrep_rmap_scan_iext+0x56/0xa0 [xfs]
    [<ffffffffa03850d8>] xrep_rmap_scan_ifork+0xd8/0x160 [xfs]
    [<ffffffffa0385195>] xrep_rmap_scan_inode+0x35/0x80 [xfs]
    [<ffffffffa03852ee>] xrep_rmap_find_rmaps+0x10e/0x270 [xfs]

I noticed that xfs_btree_insrec has a bunch of debug code that return
out of the function immediately, without freeing the "new" btree cursor
that can be returned when _make_block_unfull calls xfs_btree_split.  Fix
the error return in this function to free the btree cursor.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 482a4ccc6568..dffe4ca58493 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3266,7 +3266,7 @@ xfs_btree_insrec(
 	struct xfs_btree_block	*block;	/* btree block */
 	struct xfs_buf		*bp;	/* buffer for block */
 	union xfs_btree_ptr	nptr;	/* new block ptr */
-	struct xfs_btree_cur	*ncur;	/* new btree cursor */
+	struct xfs_btree_cur	*ncur = NULL;	/* new btree cursor */
 	union xfs_btree_key	nkey;	/* new block key */
 	union xfs_btree_key	*lkey;
 	int			optr;	/* old key/record index */
@@ -3346,7 +3346,7 @@ xfs_btree_insrec(
 #ifdef DEBUG
 	error = xfs_btree_check_block(cur, block, level, bp);
 	if (error)
-		return error;
+		goto error0;
 #endif
 
 	/*
@@ -3366,7 +3366,7 @@ xfs_btree_insrec(
 		for (i = numrecs - ptr; i >= 0; i--) {
 			error = xfs_btree_debug_check_ptr(cur, pp, i, level);
 			if (error)
-				return error;
+				goto error0;
 		}
 
 		xfs_btree_shift_keys(cur, kp, 1, numrecs - ptr + 1);
@@ -3451,6 +3451,8 @@ xfs_btree_insrec(
 	return 0;
 
 error0:
+	if (ncur)
+		xfs_btree_del_cursor(ncur, error);
 	return error;
 }
 
-- 
2.39.1.581.gbfd45094c4-goog

