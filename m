Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0777A657DDF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiL1Pro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbiL1Pre (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:47:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772B010B56
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:47:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ECA4B81732
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937C0C433D2;
        Wed, 28 Dec 2022 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242450;
        bh=Hzszc/GtUqFEvoxto5YfhgAmKhqqPYvO/qwSglXLCFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3bdW8uBOoZDb9b9a6M7X8sArcTXhI57EMyoA9B8rhk1duyHsIbdt4fn+ErmIMhGq
         6AjHmFUeD7F9gowDDV5fqMaG442hWSEopE1wqkcFaLM66PdbK5/oo5XatvrgviJ1tj
         l/+ILYkrmCBh8P6lvCJL9ehzzLMU1l4WznL9liyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jesse Taube <mr.bossman075@gmail.com>,
        Giulio Benetti <giulio.benetti@benettiengineering.com>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0371/1146] clk: imx: imxrt1050: fix IMXRT1050_CLK_LCDIF_APB offsets
Date:   Wed, 28 Dec 2022 15:31:50 +0100
Message-Id: <20221228144340.240525349@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giulio Benetti <giulio.benetti@benettiengineering.com>

[ Upstream commit 3095c02f95e537c553e0b30948c2f6c7cbed87ee ]

Fix IMXRT1050_CLK_LCDIF_APB offsets.

Fixes: 7154b046d8f3 ("clk: imx: Add initial support for i.MXRT1050 clock driver")
Cc: Jesse Taube <mr.bossman075@gmail.com>
Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20221117181014.851505-1-giulio.benetti@benettiengineering.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imxrt1050.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imxrt1050.c b/drivers/clk/imx/clk-imxrt1050.c
index 9539d35588ee..26108e9f7e67 100644
--- a/drivers/clk/imx/clk-imxrt1050.c
+++ b/drivers/clk/imx/clk-imxrt1050.c
@@ -140,7 +140,7 @@ static int imxrt1050_clocks_probe(struct platform_device *pdev)
 	hws[IMXRT1050_CLK_USDHC1] = imx_clk_hw_gate2("usdhc1", "usdhc1_podf", ccm_base + 0x80, 2);
 	hws[IMXRT1050_CLK_USDHC2] = imx_clk_hw_gate2("usdhc2", "usdhc2_podf", ccm_base + 0x80, 4);
 	hws[IMXRT1050_CLK_LPUART1] = imx_clk_hw_gate2("lpuart1", "lpuart_podf", ccm_base + 0x7c, 24);
-	hws[IMXRT1050_CLK_LCDIF_APB] = imx_clk_hw_gate2("lcdif", "lcdif_podf", ccm_base + 0x74, 10);
+	hws[IMXRT1050_CLK_LCDIF_APB] = imx_clk_hw_gate2("lcdif", "lcdif_podf", ccm_base + 0x70, 28);
 	hws[IMXRT1050_CLK_DMA] = imx_clk_hw_gate("dma", "ipg", ccm_base + 0x7C, 6);
 	hws[IMXRT1050_CLK_DMA_MUX] = imx_clk_hw_gate("dmamux0", "ipg", ccm_base + 0x7C, 7);
 	imx_check_clk_hws(hws, IMXRT1050_CLK_END);
-- 
2.35.1



