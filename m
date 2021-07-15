Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C67E3CA6EF
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbhGOSva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239383AbhGOSuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2427F613EE;
        Thu, 15 Jul 2021 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374863;
        bh=vndnttYoHsnm8GQI8rEdEV7PDDJB8KqOPwOmFM5vV2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfbkVUL7mmKAIMLXDUOJHErfFoTVeZrfzhBHcPjWwwa7/NMHQUQyUaqczkZvEh1AM
         jXbzlj7Drg6uLGq8f4JwfxtRaN/WPq+9g5CKGG6msCSYGcKQjJCcFPkoCCqYq9AkgW
         oqpjM433KyIt9u9/ogwKg+Gj8BaduQMXKfhoA9VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/215] pinctrl: equilibrium: Add missing MODULE_DEVICE_TABLE
Date:   Thu, 15 Jul 2021 20:36:35 +0200
Message-Id: <20210715182602.950055269@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



