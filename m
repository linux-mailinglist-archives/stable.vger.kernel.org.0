Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9C13BCEEF
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhGFL1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234825AbhGFLZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1627361C84;
        Tue,  6 Jul 2021 11:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570346;
        bh=vndnttYoHsnm8GQI8rEdEV7PDDJB8KqOPwOmFM5vV2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXM9xwKpK0jKK8/VnHBAly7qhmDAnE/k6/526n6Tn3uUvdxXKeVlloOoRc+zM1DJa
         sTs3F96+EFWkTTCMZTUwk1LBuz4/8zyW2GS/scHMhQRYre2nYaCAkQqy1R4hTv0yj8
         k3PS0LRLhKN9QbJaJjgnPKbDKnUYMkGrbQby2izoX/chQKUiXkWiXUZYLsMAng1JDF
         i5ajE4c8AAHrjEnlgSnjnLJ70thzwggmMvjne6egjRVWq26mO/TtxVifJlm76cr9vI
         sbxi8p60qmlsH5TbCPoTvGUtrH43hPxp+036/l89dSZ9kJ8FbfWQh49ZNbclWvYTnB
         RdDA2zSMA5pmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 029/160] pinctrl: equilibrium: Add missing MODULE_DEVICE_TABLE
Date:   Tue,  6 Jul 2021 07:16:15 -0400
Message-Id: <20210706111827.2060499-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit d7f444499d6faf9a6ae3b27ec094109528d2b9a7 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Link: https://lore.kernel.org/r/20210508031502.53637-1-cuibixuan@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-equilibrium.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-equilibrium.c b/drivers/pinctrl/pinctrl-equilibrium.c
index 067271b7d35a..ac1c47f542c1 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -929,6 +929,7 @@ static const struct of_device_id eqbr_pinctrl_dt_match[] = {
 	{ .compatible = "intel,lgm-io" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, eqbr_pinctrl_dt_match);
 
 static struct platform_driver eqbr_pinctrl_driver = {
 	.probe	= eqbr_pinctrl_probe,
-- 
2.30.2

