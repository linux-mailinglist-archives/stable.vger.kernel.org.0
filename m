Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77EA6A2DCA
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjBZDqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjBZDp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:45:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD14193C8;
        Sat, 25 Feb 2023 19:45:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A9860C08;
        Sun, 26 Feb 2023 03:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505D6C4339B;
        Sun, 26 Feb 2023 03:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383050;
        bh=aX2tqQWI0kzv6Q+vvbdWIkqEj01/dVPrpdhiOS3Ds3Y=;
        h=From:To:Cc:Subject:Date:From;
        b=QVZHiu50UyW0h/bl517X6I9q9wZJESCtwm05TGejBPmilpsK2x3L+UpxB78LbsVEt
         pb8LYRpdG+EyF82sc28Nu+gB/mNg7IsCCplIpXfG/vItVzv8CvVN9qucnJ5gendtvi
         Apc/NkjtJS/tiLVvxZMeQRsxAmhvo8PIKpiHDyS3JOPpFEpXmZ/HBaP0AGa1cvj9cj
         9Tb2Jxm08G04UWXleUk0dSm5gdRx21SntF097jLNBXU49ZmQ5hx4ESSwkwvuRajWXh
         ttd6g+QK3IBZEbmoXDSvAoBkqvQVxCSZ7OhdsmoX45sWYGR0J8Jd3KyUe0d4x29m0x
         ErnwSJun6WHmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jack@suse.com
Subject: [PATCH AUTOSEL 5.10 1/5] udf: Define EFSCORRUPTED error code
Date:   Sat, 25 Feb 2023 22:44:04 -0500
Message-Id: <20230226034408.774670-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 3d2d7e61553dbcc8ba45201d8ae4f383742c8202 ]

Similarly to other filesystems define EFSCORRUPTED error code for
reporting internal filesystem corruption.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/udf_sb.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 4fa620543d302..2205859731dc2 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -51,6 +51,8 @@
 #define MF_DUPLICATE_MD		0x01
 #define MF_MIRROR_FE_LOADED	0x02
 
+#define EFSCORRUPTED EUCLEAN
+
 struct udf_meta_data {
 	__u32	s_meta_file_loc;
 	__u32	s_mirror_file_loc;
-- 
2.39.0

