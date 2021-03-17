Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C213C33E53C
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhCQBCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231548AbhCQA76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C742264F9C;
        Wed, 17 Mar 2021 00:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942798;
        bh=RMOjAYX1vm174Y9ksn1z6Hf+kiX9gRDRZjgDW5Hq9zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVPQRgYNlVr7rUlJZWeN4plQR/kBT0Ps2XuI9kIPLY7yY8qkWxPYxUXLPyV+b0G4j
         LPDA49eF6MHe/u4ZlZq5xmvgTPM8D10PA1ukQeT4N01Qq7JjVXPP1vQTE+HmpoC8Mx
         fYs5+bD2+jVbnMkH0E8/YBLm0Sqw4dDrLcP8CNyI/tUSSYPgpnyj660li5tjQ73+f2
         9gQd7EhXAaV6snwfSphoNo5jlAL0oVo3h2jPaXBnjEzKHW3GXW/QWiqllC0NHOMguI
         rSx2rie599iv45D5w655Ix2MTLquqxmEER9/5mbRkyv4YgVkg/+Bbv5BoeVLNqygS3
         CsNxkgpSa4dXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Timo Rothenpieler <timo@rothenpieler.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/16] nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default
Date:   Tue, 16 Mar 2021 20:59:39 -0400
Message-Id: <20210317005948.727250-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005948.727250-1-sashal@kernel.org>
References: <20210317005948.727250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timo Rothenpieler <timo@rothenpieler.org>

[ Upstream commit a0590473c5e6c4ef17c3132ad08fbad170f72d55 ]

This follows what was done in 8c2fabc6542d9d0f8b16bd1045c2eda59bdcde13.
With the default being m, it's impossible to build the module into the
kernel.

Signed-off-by: Timo Rothenpieler <timo@rothenpieler.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index c3428767332c..55ebf9f4a824 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -132,7 +132,7 @@ config PNFS_OBJLAYOUT
 config PNFS_FLEXFILE_LAYOUT
 	tristate
 	depends on NFS_V4_1 && NFS_V3
-	default m
+	default NFS_V4
 
 config NFS_V4_1_IMPLEMENTATION_ID_DOMAIN
 	string "NFSv4.1 Implementation ID Domain"
-- 
2.30.1

