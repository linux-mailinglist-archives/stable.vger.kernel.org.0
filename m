Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79A6304AC0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbhAZE7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731078AbhAYSuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29BE922EBD;
        Mon, 25 Jan 2021 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600604;
        bh=BXAUTlBON4b47JT11rn8DtJCdtslP5zfAcIpxMXkBKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAb3tiUszOjEKdjJCsy8EivWt+6Z1TyODMlq5WYFSPJOEjzh4DH8emRhjdBoUNgYk
         H9ymTg4yJqU6MjsgHOG7R2fXmxxDYD5C5uDosPsbDfBUFD5++uBT0AHDWnLEckNcDN
         CMhfHWULkEBynm2c3exVNZBZNVjlSH2YHuy0MQKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Billy Tsai <billy_tsai@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/199] pinctrl: aspeed: g6: Fix PWMG0 pinctrl setting
Date:   Mon, 25 Jan 2021 19:38:21 +0100
Message-Id: <20210125183219.598473411@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 92ff62a7bcc17d47c0ce8dddfb7a6e1a2e55ebf4 ]

The SCU offset for signal PWM8 in group PWM8G0 is wrong, fix it from
SCU414 to SCU4B4.

Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Fixes: 2eda1cdec49f ("pinctrl: aspeed: Add AST2600 pinmux support")
Reviewed-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20201217024912.3198-1-billy_tsai@aspeedtech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
index 34803a6c76643..5c1a109842a76 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
@@ -347,7 +347,7 @@ FUNC_GROUP_DECL(RMII4, F24, E23, E24, E25, C25, C24, B26, B25, B24);
 
 #define D22 40
 SIG_EXPR_LIST_DECL_SESG(D22, SD1CLK, SD1, SIG_DESC_SET(SCU414, 8));
-SIG_EXPR_LIST_DECL_SEMG(D22, PWM8, PWM8G0, PWM8, SIG_DESC_SET(SCU414, 8));
+SIG_EXPR_LIST_DECL_SEMG(D22, PWM8, PWM8G0, PWM8, SIG_DESC_SET(SCU4B4, 8));
 PIN_DECL_2(D22, GPIOF0, SD1CLK, PWM8);
 GROUP_DECL(PWM8G0, D22);
 
-- 
2.27.0



