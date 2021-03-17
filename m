Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AF333E3F4
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhCQA6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhCQA5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E26964F9E;
        Wed, 17 Mar 2021 00:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942639;
        bh=yVGfVRO7Xj7U+lHvrEE+sQIiCYb5eGK2AG3Ak+dYvGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7orrcEJ5GpdqNxZRhFV6QmshihuyXsu3D8q263WEkjCcPFC9viofKGkI4LWYm/yr
         Nz/fvcFwV5qVP9ge6/S0m22IT/Uh652ciDdCbdTySmi/J+yznmbDjpCzjb3JtCRosb
         F148QmXvyqMaNZgGQ1FIFwERaLsqwDUZdgqRD1EF/HSJ6JeOI9LIp8dtTlwFz58Cpf
         ScxCMujWLPnt4i9V5pXRUuhv0Buz76HBNrzsOCdx1QhUuT1o5M5E3UYyQt9eHoZCpc
         djCosf0x7K5dGx9dpIDpTGh98wk02UvUU5rbORmbcTORUULb2pCKtIyaZ+QM001YAl
         0B8WSEWike/4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Timo Rothenpieler <timo@rothenpieler.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/54] nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default
Date:   Tue, 16 Mar 2021 20:56:19 -0400
Message-Id: <20210317005654.724862-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index e2a488d403a6..14a72224b657 100644
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

