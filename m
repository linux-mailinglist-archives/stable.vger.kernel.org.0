Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F9513F7BC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436966AbgAPTNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:13:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbgAPQ4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C6E24656;
        Thu, 16 Jan 2020 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193812;
        bh=Ppki7bJOdbn0w59neb8DkdThSwj0mAlZOZ93LnaEkyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wu2hd7gC6jS1EsL9a3zVmM9OhDC525jcIe4kY/p19MBhEk1UanQwK6JyZuCixG3bf
         A6Kt5UxF7qQ+OEWwRJJVO4jasdFb2RgdjRmCvDKcAmGZxy2hDThLI5QrWKA0lKu8QQ
         4sO00rbiVHEyTQ1KxHg4R/xA/3H7D7dAps/l4am0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 074/671] pinctrl: sh-pfc: r8a77970: Add missing MOD_SEL0 field
Date:   Thu, 16 Jan 2020 11:45:05 -0500
Message-Id: <20200116165502.8838-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 67d7745bc78e16ec6b3af02bc1da6c8c868cbd89 ]

The Module Select Register 0 contains 20 (= 5 x 4) reserved bits, and 12
single-bit fields, but the variable field descriptor lacks a field of 4
reserved bits.

Fixes: b92ac66a1819602b ("pinctrl: sh-pfc: Add R8A77970 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a77970.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a77970.c b/drivers/pinctrl/sh-pfc/pfc-r8a77970.c
index eeb58b3bbc9a..53fae9fd682b 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a77970.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a77970.c
@@ -2354,7 +2354,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 #define F_(x, y)	x,
 #define FM(x)		FN_##x,
 	{ PINMUX_CFG_REG_VAR("MOD_SEL0", 0xe6060500, 32,
-			     4, 4, 4, 4,
+			     4, 4, 4, 4, 4,
 			     1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) {
 		/* RESERVED 31, 30, 29, 28 */
 		0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0,
-- 
2.20.1

