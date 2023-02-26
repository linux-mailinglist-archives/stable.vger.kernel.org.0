Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D11E6A2DE7
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjBZDxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjBZDxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:53:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D79A93C2;
        Sat, 25 Feb 2023 19:53:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4298960BEA;
        Sun, 26 Feb 2023 03:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2816CC433EF;
        Sun, 26 Feb 2023 03:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383066;
        bh=dCNqRdx9mSR55PqW/0M3NTaK7PjYG4mtv05YpTZP17o=;
        h=From:To:Cc:Subject:Date:From;
        b=gjYsetNqFus3XntPl1b0B5n1Ozxab+Pr/TS7DiO9oS+NCa6+yOIKLchNHhDRRGyDK
         mCTyCB1zxGO9Zr3RjXajgde1w/Kuvkmp9sOL7BHgP8sIGsyjL41Yd8Qp0+B+823GJZ
         UGKk1ulEyWLKwDTgZdUdBUVXpyWXGD0Mcy8L2bE9/2Z/CNmePy+DoVn7hvhnfryMoK
         2FPACuQrWHahD3BI0y0cWkUEaMLMAyPaSpQtCk5hKQWtYX0znyJoNHxX1lPZnM20Hs
         TEQrH4dR3AsK7oxhu7o9J56ng3ZsquZTj0Wugdkrl+v1bEcK/1PGHW3GOfWX7WTDGj
         DAQ5m18U3ibMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jack@suse.com
Subject: [PATCH AUTOSEL 4.19 1/3] udf: Define EFSCORRUPTED error code
Date:   Sat, 25 Feb 2023 22:44:22 -0500
Message-Id: <20230226034424.776084-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index d12e507e9eb2a..aa58173b468fb 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -57,6 +57,8 @@
 #define MF_DUPLICATE_MD		0x01
 #define MF_MIRROR_FE_LOADED	0x02
 
+#define EFSCORRUPTED EUCLEAN
+
 struct udf_meta_data {
 	__u32	s_meta_file_loc;
 	__u32	s_mirror_file_loc;
-- 
2.39.0

