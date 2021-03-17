Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EB133E471
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhCQA7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232271AbhCQA7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A56C364FC0;
        Wed, 17 Mar 2021 00:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942744;
        bh=hxKPIy9xQ4pAbVLd6IuSOXfvIsSt1TcXC72K92hLpB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDTWyCt77w+VfQXJpOg3OwvuVpxD2ZZsZpyr/bGU1Kv8x0uzjBPmjD3MZ4yKjzYNC
         aLbiMPDs4G3tJbtpAtlCgxKFcQQl8ziErWGKGc976B0Utg978rtzVlobIz/+suklGe
         2qpmjQ9B9s/hdw+pLwmARwwIheh7+1EmqBp34Vir1ZafooqKFHWBnbq4dwS8RD+kOh
         uzL4/P/9T+rDbmG9QbWQsdFCjklJSIG0MuaPrKM+tLJNWqYz1cuFZIHEdFFa/D4E88
         Z4Ps3eBUg+YCMjO8eJqlDskWnEXKpc7CoZzjny0RPDVAgKPzI5nnUuzpY1YVJi4Elr
         EiR+avJ5VtlVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Timo Rothenpieler <timo@rothenpieler.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/23] nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default
Date:   Tue, 16 Mar 2021 20:58:37 -0400
Message-Id: <20210317005850.726479-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
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
index ac3e06367cb6..e55f86713948 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -127,7 +127,7 @@ config PNFS_BLOCK
 config PNFS_FLEXFILE_LAYOUT
 	tristate
 	depends on NFS_V4_1 && NFS_V3
-	default m
+	default NFS_V4
 
 config NFS_V4_1_IMPLEMENTATION_ID_DOMAIN
 	string "NFSv4.1 Implementation ID Domain"
-- 
2.30.1

