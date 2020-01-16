Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EC913F7B6
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733290AbgAPQ4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbgAPQ4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88ADA21D56;
        Thu, 16 Jan 2020 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193811;
        bh=is0VhQVqYE0DCdIwWOioa+NP7VecCQJeK4r3yg8YdHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vL2sohggzjEfwKMsBuFUcZaANTuiIYtuiKNaomC1inHzV3ulpGAyx8rEAIrOG2Qjx
         vnSabm5h+sL5ffuod+E8py3oAVzGlqTldEOys1K6lwin4I6u0BoSAhWu+4vxAz+lk+
         ULjBjBgwCfPDErrGUhhK4tl/4kBku1LJHZP2Txwo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 073/671] pinctrl: sh-pfc: r8a7794: Remove bogus IPSR9 field
Date:   Thu, 16 Jan 2020 11:45:04 -0500
Message-Id: <20200116165502.8838-73-sashal@kernel.org>
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

[ Upstream commit 6a6c195d98a1a5e70faa87f594d7564af1dd1bed ]

The Peripheral Function Select Register 9 contains 12 fields, but the
variable field descriptor contains a 13th bogus field of 3 bits.

Fixes: 43c4436e2f1890a7 ("pinctrl: sh-pfc: add R8A7794 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7794.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7794.c b/drivers/pinctrl/sh-pfc/pfc-r8a7794.c
index 164002437594..24b9bb1ee1fe 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7794.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7794.c
@@ -5215,7 +5215,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 		FN_AVB_MDC, FN_SSI_SDATA6_B, 0, 0, }
 	},
 	{ PINMUX_CFG_REG_VAR("IPSR9", 0xE6060044, 32,
-			     1, 3, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3, 3) {
+			     1, 3, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3) {
 		/* IP9_31 [1] */
 		0, 0,
 		/* IP9_30_28 [3] */
-- 
2.20.1

