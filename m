Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B4D5F53A9
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJELiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiJELhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:37:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A4661D7B;
        Wed,  5 Oct 2022 04:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7D1B61543;
        Wed,  5 Oct 2022 11:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1CCC433C1;
        Wed,  5 Oct 2022 11:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969697;
        bh=QpZ5IYhmYr0sbxy56R21Xhgqvtwy16ZLanrt25BG6eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCbaAOSjGx22TtqaI9jMdybLAF6mzubcuwcwL6ylCr+8SZQE4AAuli8wgmnifgNnX
         eDs36frM7ytuEXBNIJPGE+SFZJgGNiJhXjYiWg6nuVALutd4C0Na0kGRKr0R+ykNBx
         Xs/prMqt+BXrEZ0uHvDECCTQZC6d9OiIac7g9+9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        YueHaibing <yuehaibing@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 48/51] xfs: remove unused variable done
Date:   Wed,  5 Oct 2022 13:32:36 +0200
Message-Id: <20221005113212.479111487@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit b3531f5fc16d4df2b12567bce48cd9f3ab5f9131 upstream.

fs/xfs/xfs_inode.c: In function 'xfs_itruncate_extents_flags':
fs/xfs/xfs_inode.c:1523:8: warning: unused variable 'done' [-Wunused-variable]

commit 4bbb04abb4ee ("xfs: truncate should remove
all blocks, not just to the end of the page cache")
left behind this, so remove it.

Fixes: 4bbb04abb4ee ("xfs: truncate should remove all blocks, not just to the end of the page cache")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1515,7 +1515,6 @@ xfs_itruncate_extents_flags(
 	xfs_fileoff_t		first_unmap_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
-	int			done = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||


