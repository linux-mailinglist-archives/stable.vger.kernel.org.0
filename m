Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EB724BE95
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgHTJdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728241AbgHTJbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:31:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B19C207DE;
        Thu, 20 Aug 2020 09:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915900;
        bh=KkTpjo3ubxOjKtyVT6Vor4FVC+SUr0Oso39gyEFrEDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVhDLkCspo1RVxZ0AAtugtVlUP8nxU5TZ/MP9u6HJ0htFn4AVwAZq4SXpKkV+Z4ap
         uL4GHkwth4eb48Fpy/fQPvj4UFKtNNU7exiNeo+A9ECWE9wGd3+66y13cOssQYagwK
         AMr9BlFMgQ8IcVuPO8uFtxjdUpa0kcSJazufQOlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 157/232] clk: qcom: clk-alpha-pll: remove unused/incorrect PLL_CAL_VAL
Date:   Thu, 20 Aug 2020 11:20:08 +0200
Message-Id: <20200820091620.415414589@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit c8b9002f44e4a1d2771b2f59f6de900864b1f9d7 ]

0x44 isn't a register offset, it is the value that goes into CAL_L_VAL.

Fixes: 548a909597d5 ("clk: qcom: clk-alpha-pll: Add support for Trion PLLs")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20200709135251.643-3-jonathan@marek.ca
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index 9b2dfa08acb2a..1325139173c95 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -56,7 +56,6 @@
 #define PLL_STATUS(p)		((p)->offset + (p)->regs[PLL_OFF_STATUS])
 #define PLL_OPMODE(p)		((p)->offset + (p)->regs[PLL_OFF_OPMODE])
 #define PLL_FRAC(p)		((p)->offset + (p)->regs[PLL_OFF_FRAC])
-#define PLL_CAL_VAL(p)		((p)->offset + (p)->regs[PLL_OFF_CAL_VAL])
 
 const u8 clk_alpha_pll_regs[][PLL_OFF_MAX_REGS] = {
 	[CLK_ALPHA_PLL_TYPE_DEFAULT] =  {
@@ -115,7 +114,6 @@ const u8 clk_alpha_pll_regs[][PLL_OFF_MAX_REGS] = {
 		[PLL_OFF_STATUS] = 0x30,
 		[PLL_OFF_OPMODE] = 0x38,
 		[PLL_OFF_ALPHA_VAL] = 0x40,
-		[PLL_OFF_CAL_VAL] = 0x44,
 	},
 	[CLK_ALPHA_PLL_TYPE_LUCID] =  {
 		[PLL_OFF_L_VAL] = 0x04,
-- 
2.25.1



