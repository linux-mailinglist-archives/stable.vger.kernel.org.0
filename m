Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D27D147B91
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbgAXJom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732654AbgAXJog (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:44:36 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 497D2208C4;
        Fri, 24 Jan 2020 09:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859076;
        bh=jUFc12YtfQ5xLyvvnotPv8V6wr2mDXMXqm1rRAHKl/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5WBeGhCLK0CVauUqimxc3/yOeqM+jpeZYfRTP2EC7wZd8Y0rwqFZnW8DxMOpcgD1
         rA8uH226ykXaWu+2w239WuOpLS5tbuGR+1ykdO2AiJsTErGlzF/pWI/Q5NenNsq6NC
         uu5i7rgL4P2Ts5ndJNXON8lR4y+x8UpEefackvco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 037/343] pinctrl: sh-pfc: sh7734: Add missing IPSR11 field
Date:   Fri, 24 Jan 2020 10:27:35 +0100
Message-Id: <20200124092924.674341808@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 94482af7055e1ffa211c1135256b85590ebcac99 ]

The Peripheral Function Select Register 11 contains 3 reserved bits and
15 variable-width fields, but the variable field descriptor does not
contain the 3-bit field IP11[25:23].

Fixes: 856cb4bb337ee504 ("sh: Add support pinmux for SH7734")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-sh7734.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7734.c b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
index 3eccc9b3ca84a..05ccb27f77818 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7734.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
@@ -2237,7 +2237,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 		FN_LCD_DATA15_B, 0, 0, 0 }
 	},
 	{ PINMUX_CFG_REG_VAR("IPSR11", 0xFFFC0048, 32,
-			3, 1, 2, 2, 2, 3, 3, 1, 2, 3, 3, 1, 1, 1, 1) {
+			3, 1, 2, 3, 2, 2, 3, 3, 1, 2, 3, 3, 1, 1, 1, 1) {
 	    /* IP11_31_29 [3] */
 	    0, 0, 0, 0, 0, 0, 0, 0,
 	    /* IP11_28 [1] */
-- 
2.20.1



