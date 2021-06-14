Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1A03A6495
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhFNL0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236288AbhFNLYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93C25613FA;
        Mon, 14 Jun 2021 10:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668059;
        bh=InyS7B9qMVwTUJCEn4b3cNjpO2pOj2lW+1Vi10L4TmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcnCcw++GJQAi91h7hyiPs6/6U3Sqkvy59kiVsnvVEv2goBbulLkwWx46tEeZcQ6I
         tEtUYZg0CXZKU7Hc/ba0Zr0uUMuah9wPGJqAecYDSmY80jWMoa0dLlL9g0RKSxjNB9
         wjqQ4lUQHOc93FhIWnp6LRQeuEfY0F7n3nXhHV+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 164/173] pinctrl: qcom: Make it possible to select SC8180x TLMM
Date:   Mon, 14 Jun 2021 12:28:16 +0200
Message-Id: <20210614102703.628803679@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 30e9857a134905ac0d03ca244b615cc3ff0a076e ]

It's currently not possible to select the SC8180x TLMM driver, due to it
selecting PINCTRL_MSM, rather than depending on the same. Fix this.

Fixes: 97423113ec4b ("pinctrl: qcom: Add sc8180x TLMM driver")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210608180702.2064253-1-bjorn.andersson@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/Kconfig b/drivers/pinctrl/qcom/Kconfig
index 6853a896c476..740ecf6011a9 100644
--- a/drivers/pinctrl/qcom/Kconfig
+++ b/drivers/pinctrl/qcom/Kconfig
@@ -223,7 +223,7 @@ config PINCTRL_SC7280
 config PINCTRL_SC8180X
 	tristate "Qualcomm Technologies Inc SC8180x pin controller driver"
 	depends on GPIOLIB && OF
-	select PINCTRL_MSM
+	depends on PINCTRL_MSM
 	help
 	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
 	  Qualcomm Technologies Inc TLMM block found on the Qualcomm
-- 
2.30.2



