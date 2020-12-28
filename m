Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448482E3CDC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438561AbgL1OIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438558AbgL1OIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3306F20791;
        Mon, 28 Dec 2020 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164464;
        bh=KETyg2mYXuSuwdGb4ZTAu1V6hN3YJwXhYjzH4/YJu68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGT04fy0IcI+bwQmqWYDai7qwycE+pvYS5es1ublT/AZLqz9gydBpzy3E+gdicXT8
         q+DU2jgnCyK75WJFAnKrOcy/7GQBuDKJsMNsq27YmETe8z9oep+QqrB8Keam/Cm10o
         WgApPW2DT9eRSQQIpUjX1glcALypNL5wK4XaEc1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <frank@allwinnertech.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/717] pinctrl: sunxi: fix irq bank map for the Allwinner A100 pin controller
Date:   Mon, 28 Dec 2020 13:43:08 +0100
Message-Id: <20201228125030.074063648@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <frank@allwinnertech.com>

[ Upstream commit 6de7ed693c631d4689acfe90c434147598d75543 ]

A100's pin starts with PB, so it should start with 1.

Fixes: 473436e7647d6 ("pinctrl: sunxi: add support for the Allwinner A100 pin controller")
Signed-off-by: Yangtao Li <frank@allwinnertech.com>
Link: https://lore.kernel.org/r/9db51667bf9065be55beafd56e5c319e3bbe8310.1604988979.git.frank@allwinnertech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sun50i-a100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sun50i-a100.c b/drivers/pinctrl/sunxi/pinctrl-sun50i-a100.c
index 19cfd1e76ee2c..e69f6da40dc0a 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun50i-a100.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun50i-a100.c
@@ -677,7 +677,7 @@ static const struct sunxi_desc_pin a100_pins[] = {
 		  SUNXI_FUNCTION_IRQ_BANK(0x6, 6, 19)),
 };
 
-static const unsigned int a100_irq_bank_map[] = { 0, 1, 2, 3, 4, 5, 6};
+static const unsigned int a100_irq_bank_map[] = { 1, 2, 3, 4, 5, 6, 7};
 
 static const struct sunxi_pinctrl_desc a100_pinctrl_data = {
 	.pins = a100_pins,
-- 
2.27.0



