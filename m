Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1AC3BB1FB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbhGDXNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhGDXML (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 011DD6144E;
        Sun,  4 Jul 2021 23:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440113;
        bh=Da050tis89NjJusNn/tyP2Jxv0QPnmJ1/hwd8rD8adE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lo6elKojA/wx9+EW1PGP4Ha17X1YorWNwGJ9H3/tmZHDXcdbsWJsOeejrcCmDXc6d
         dr0+5Sc5LmZ/nSjRmEZ6CWRu+mEdQJJxBUax0R0BaQB06N6jUpHapAyUy8ii+7w7df
         uTf8hjy+zFME6PtmLoLsG1gP4BVsd8qGxrjf77GhcktVPMF1wddLS4MNCZAAPW0FVG
         knD+scdcfaEKgP1GdXG79ce10eXNSHRkxCwOikbADJ7a4/9pZ3jaeK0VcxCfA93zbQ
         58BZD04226nIC8CHsGX8xb2GHKwyYjtyg7YFN8Xy0YZDTzPMg0acBtiW1lUwGQtrcJ
         BKDBTnsNC8G/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 21/70] crypto: nx - add missing MODULE_DEVICE_TABLE
Date:   Sun,  4 Jul 2021 19:07:14 -0400
Message-Id: <20210704230804.1490078-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 06676aa1f455c74e3ad1624cea3acb9ed2ef71ae ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 2de5e3672e42..258c5e38a551 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -1071,6 +1071,7 @@ static const struct vio_device_id nx842_vio_driver_ids[] = {
 	{"ibm,compression-v1", "ibm,compression"},
 	{"", ""},
 };
+MODULE_DEVICE_TABLE(vio, nx842_vio_driver_ids);
 
 static struct vio_driver nx842_vio_driver = {
 	.name = KBUILD_MODNAME,
-- 
2.30.2

