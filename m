Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991793BB349
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhGDXRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234377AbhGDXPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B78E0613FC;
        Sun,  4 Jul 2021 23:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440346;
        bh=xNZHQJvcgNRFaQ8eiwggEpWrLCEadieOmm+NlS87DBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmZKOJLRaQNEchyMHfHmea06e8rIPTE4DrXG0WKQSFZZ/Q9fUe4He/KWNqCq8TJKm
         yhEIKLceAnBSyeGqK+ea1IKLZQe9bd8Inw8Ts78atQzLpjPBiJEuVzwGTd22Gc90eD
         JA8fVpReYoAN9OdoO1uweEMT0FACPAGTXa8UXImfyaIQYh33sxy6ujCEWcOHBlc3cz
         WxG1Wa+sUOTOVBbvFbCNLJ5JJstdwIBEQnbQ4wPZVYh+r3j1F0ulZs/sc5ewLUClOe
         x6EmLOMNeKr13mGHXq6FZdq17/EOlwib++T1uDnADy/qp83PqZ7v8P55jRUJzUelGw
         gNSztrdd4hhog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 03/15] crypto: nx - add missing MODULE_DEVICE_TABLE
Date:   Sun,  4 Jul 2021 19:12:09 -0400
Message-Id: <20210704231222.1492037-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231222.1492037-1-sashal@kernel.org>
References: <20210704231222.1492037-1-sashal@kernel.org>
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
index cddc6d8b55d9..2e5b4004f0ee 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -1086,6 +1086,7 @@ static struct vio_device_id nx842_vio_driver_ids[] = {
 	{"ibm,compression-v1", "ibm,compression"},
 	{"", ""},
 };
+MODULE_DEVICE_TABLE(vio, nx842_vio_driver_ids);
 
 static struct vio_driver nx842_vio_driver = {
 	.name = KBUILD_MODNAME,
-- 
2.30.2

