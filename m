Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAAC33E356
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhCQA4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhCQA4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5088764F9E;
        Wed, 17 Mar 2021 00:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942563;
        bh=yVGfVRO7Xj7U+lHvrEE+sQIiCYb5eGK2AG3Ak+dYvGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0AZ/9MLUwlMIYT6UsngqtZv+mK+GsI95Lg4pXnTIKVKK+94YDQUl/ge8ws5lFE9U
         goKbMDEF1QUEMBH1kDBA+uEOQgLN8FOZbmyUmKzzx8/T0tcOaUWhoLVksVDxeFv2ap
         Rk9vFFYKcCeoMW6EGRVtKbUEAsG+CDjsFArm9zGhK05zCI17ZNAf/qa2zjY2OI2S3f
         kDDvzhmRW7EckA+VrXbnX0KnFzKksNg9YJgsNJEX2zpBJ93vqptrLCYWF5QJIYbXvR
         Pnp4FnqU28ctRAkhpcmkRYia95Ms+dTftvq5wdIxoXUGnTNrVHQ1D/fpU9ZeNriSg5
         nsL0XsuZvqmSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Timo Rothenpieler <timo@rothenpieler.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 21/61] nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default
Date:   Tue, 16 Mar 2021 20:54:55 -0400
Message-Id: <20210317005536.724046-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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

