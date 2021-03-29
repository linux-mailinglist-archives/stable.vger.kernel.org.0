Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE1F34C597
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhC2IBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231658AbhC2IBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D6EA61969;
        Mon, 29 Mar 2021 08:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004873;
        bh=RMOjAYX1vm174Y9ksn1z6Hf+kiX9gRDRZjgDW5Hq9zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhiBSTJCJZYp9sWeaGOAg8Jp4B94UJ6lCbKbSEQ2aa8XMhPNqamPyHCZ1HSliRY/D
         tsKFAaQQ410uOe0kZfUmYr5D9+Rqp+J7j1Yox0gDlzqm8Md5YA6Ogdh8kNOjOw/5QT
         7WChv7IU40ToeIVw3PQ3Ft5Fr8bTHaGkPkQjPZG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timo Rothenpieler <timo@rothenpieler.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 07/33] nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default
Date:   Mon, 29 Mar 2021 09:57:52 +0200
Message-Id: <20210329075605.519473058@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
References: <20210329075605.290845195@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



