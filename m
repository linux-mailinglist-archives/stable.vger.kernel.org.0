Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF6433E4E3
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhCQBAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232409AbhCQA7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 009DE64FA8;
        Wed, 17 Mar 2021 00:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942773;
        bh=hxKPIy9xQ4pAbVLd6IuSOXfvIsSt1TcXC72K92hLpB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msh7CET1vpM51TdVMpPEGmEt/3qANwQ60PavHAiJ6g+j6WPkdjSCULytepHcRwDGi
         Go0PGeQGiX1hc3zXwzCYXuKAFA91CyEoMN+p5oZuWsdXz9Yiyz9FlLUFzdlvCeeZ6A
         iRf0fBa/ncvF/7cuVtRwOwvgemr5VZS/03q/AjmKU4Am0FsxvMbmtymI4HpwSkk+Pl
         7GvwyQvH1s4xBRyPtaznDQvuDha4D2rVsMWXMAHV55v4ySLdc7kwHTfz+TfHvtx8es
         kCBDNjqoCpkDBahGZjBW0E6JQdQG+/G7ASU11QBGNb3kN9uVwVU1beIaq44GgE60un
         7XVFS4jmfVK0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Timo Rothenpieler <timo@rothenpieler.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/21] nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default
Date:   Tue, 16 Mar 2021 20:59:09 -0400
Message-Id: <20210317005920.726931-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005920.726931-1-sashal@kernel.org>
References: <20210317005920.726931-1-sashal@kernel.org>
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

