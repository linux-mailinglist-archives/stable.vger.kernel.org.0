Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1B913E28F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgAPQ4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733299AbgAPQ4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EE312051A;
        Thu, 16 Jan 2020 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193814;
        bh=0JjqsHQF+v6lqic0Hv75qSHw8WQM8B6vzqVxnEFjj8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgp44EMxBvRrn6e9QFnnIi+R4dCDR/Xl7EuEPBWY9Mqooz0KvK+aehJmiKLDFn4TN
         O1RbyGR3+jPxm+0BsRgx4EuUuckLLy64go5vlC3/2QnuD36SbeUtbSRV+w+oqUp11T
         K4ZXV6bVt038a6tEaeqknMqnkUxDNw7Q4/AoqUJ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 075/671] pinctrl: sh-pfc: r8a77980: Add missing MOD_SEL0 field
Date:   Thu, 16 Jan 2020 11:45:06 -0500
Message-Id: <20200116165502.8838-75-sashal@kernel.org>
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

[ Upstream commit b0f77269f6bba385f1f4dce44e7756cf8fbc0176 ]

The Module Select Register 0 contains 20 (= 5 x 4) reserved bits, and 12
single-bit fields, but the variable field descriptor lacks a field of 4
reserved bits.

Fixes: f59125248a691dfe ("pinctrl: sh-pfc: Add R8A77980 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a77980.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a77980.c b/drivers/pinctrl/sh-pfc/pfc-r8a77980.c
index 3f6967331f64..81a710bb8555 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a77980.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a77980.c
@@ -2751,7 +2751,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
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

