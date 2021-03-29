Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EF234C97B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhC2I36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234296AbhC2I2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:28:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35882619D3;
        Mon, 29 Mar 2021 08:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006439;
        bh=yVGfVRO7Xj7U+lHvrEE+sQIiCYb5eGK2AG3Ak+dYvGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLWTovUiStEt9DmY1dVbb1hz101kS+QK+rncaTgi+i8hNW2pgTYs5Ux6qX+b27o8G
         1QqVIsXlSqW5ENkExejLpGHosafvD/RvqJXxDZZFqGKvKjcIFfkw+9WKuxx7wBlrfb
         eYZSc7Mln8MeGSlMmWP5En9xL/ehm5csGtYNm00U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timo Rothenpieler <timo@rothenpieler.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 021/254] nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default
Date:   Mon, 29 Mar 2021 09:55:37 +0200
Message-Id: <20210329075633.846633943@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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



