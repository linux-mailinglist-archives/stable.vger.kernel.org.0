Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F743BB21C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhGDXNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230470AbhGDXJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:09:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CAF8613F7;
        Sun,  4 Jul 2021 23:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440007;
        bh=vKftHj88RLYECuwHY64g8MmF5WQxGF4qF+Dprtnl6OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBUa2+nkM/T9w6DbCgAyVVf6lsaTeylzKTfW2a9O58yHz761UvKkBeTiPhTYs5/m5
         AbedNNE2+AAZodxnzcg+27FIZIBu4kiRveJY6XyaPx+3VL7kbAAcqPreMxlIUNt3xJ
         LxqVsOPkGOCbRXU2bNvv3lDgTIHA8ilL1FHepHb+I2zLDDlSD6mofcnGUhqhFeg3UB
         oeKCSNgDx5nIjzvKXHDjhplYe6+7yd1ysCXtL7q+lP6gwtiEOOgUt/RSOmoKP68UjW
         pdAJB81MyMaDG8NoadqolKKRTtxFspFDEEM6to4e8h4rf5VAONygH2TT+vpCSmnRUy
         4d605hsTLa8vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.12 22/80] crypto: nx - add missing MODULE_DEVICE_TABLE
Date:   Sun,  4 Jul 2021 19:05:18 -0400
Message-Id: <20210704230616.1489200-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index cc8dd3072b8b..8ee547ee378e 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -1069,6 +1069,7 @@ static const struct vio_device_id nx842_vio_driver_ids[] = {
 	{"ibm,compression-v1", "ibm,compression"},
 	{"", ""},
 };
+MODULE_DEVICE_TABLE(vio, nx842_vio_driver_ids);
 
 static struct vio_driver nx842_vio_driver = {
 	.name = KBUILD_MODNAME,
-- 
2.30.2

