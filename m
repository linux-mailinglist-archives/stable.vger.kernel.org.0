Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0A0FA519
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbfKMByL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbfKMByL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5C24222D4;
        Wed, 13 Nov 2019 01:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610050;
        bh=4AqIKX5t8RvYRZ+5XLEmOm7MDx4bs/HyQdJ9zb2hRN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rL3Se1c9cTF/YCYGKsg55L0OjKMZAMQovEoeV5ysIBKwtPBStwuvUjaF7Belywtxn
         Gy8sDhtdfO2ZOAa+pY2DYAFAZ3uB39wfdnOETCxyPJbV1XfAKcL9LV8rK4IulNtK7u
         bBrgtmH3AADjIHOH6eTl0zWB89z0x4Ek3oVLtJzY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 137/209] mmc: renesas_sdhi_internal_dmac: Whitelist r8a774a1
Date:   Tue, 12 Nov 2019 20:49:13 -0500
Message-Id: <20191113015025.9685-137-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

[ Upstream commit 2e1501a8bdd49eaa0e967c0ad00e9dcd68d0b30f ]

We need r8a774a1 to be whitelisted for SDHI to work on the RZ/G2M,
but we don't care about the revision of the SoC, so just whitelist
the generic part number.

Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index ca0b43973769c..f4aefa8954bfc 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -298,6 +298,7 @@ static const struct soc_device_attribute gen3_soc_whitelist[] = {
 	{ .soc_id = "r8a7796", .revision = "ES1.0",
 	  .data = (void *)BIT(SDHI_INTERNAL_DMAC_ONE_RX_ONLY) },
 	/* generic ones */
+	{ .soc_id = "r8a774a1" },
 	{ .soc_id = "r8a7795" },
 	{ .soc_id = "r8a7796" },
 	{ .soc_id = "r8a77965" },
-- 
2.20.1

