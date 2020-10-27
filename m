Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266D729B9BB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802760AbgJ0PvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802065AbgJ0Ppa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7096D22265;
        Tue, 27 Oct 2020 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813527;
        bh=K5QXepUTlPLsvzjXreFIj/pzZe/3r3kaWx0hy31khZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lo9csJ7b8lmohXR430sF5pBXfOPqIip/Ysg7zOUFGe9PpF+s3TVLzYHtYcXTNS0hH
         JvqnXhhciuL/MCLOTEqngdkItTnvlUvKKaYPJLOrJNR0DEg6KRbuPQ2tscYb35cIV2
         o9dW/ltrWoL6OkoM83NMZa1WYAtfkfKTAtmvuxXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wendell Lin <wendell.lin@mediatek.com>,
        Hanks Chen <hanks.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 540/757] clk: mediatek: add UART0 clock support
Date:   Tue, 27 Oct 2020 14:53:10 +0100
Message-Id: <20201027135515.818938603@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanks Chen <hanks.chen@mediatek.com>

[ Upstream commit 804a892456b73604b7ecfb1b00a96a29f3d2aedf ]

Add MT6779 UART0 clock support.

Fixes: 710774e04861 ("clk: mediatek: Add MT6779 clock support")
Signed-off-by: Wendell Lin <wendell.lin@mediatek.com>
Signed-off-by: Hanks Chen <hanks.chen@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt6779.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/mediatek/clk-mt6779.c b/drivers/clk/mediatek/clk-mt6779.c
index 9766cccf5844c..6e0d3a1667291 100644
--- a/drivers/clk/mediatek/clk-mt6779.c
+++ b/drivers/clk/mediatek/clk-mt6779.c
@@ -919,6 +919,8 @@ static const struct mtk_gate infra_clks[] = {
 		    "pwm_sel", 19),
 	GATE_INFRA0(CLK_INFRA_PWM, "infra_pwm",
 		    "pwm_sel", 21),
+	GATE_INFRA0(CLK_INFRA_UART0, "infra_uart0",
+		    "uart_sel", 22),
 	GATE_INFRA0(CLK_INFRA_UART1, "infra_uart1",
 		    "uart_sel", 23),
 	GATE_INFRA0(CLK_INFRA_UART2, "infra_uart2",
-- 
2.25.1



