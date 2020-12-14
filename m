Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EFB2D9EFF
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408321AbgLNS16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:27:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502299AbgLNRiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:02 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Yong Mao <yong.mao@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 079/105] mmc: mediatek: Extend recheck_sdio_irq fix to more variants
Date:   Mon, 14 Dec 2020 18:28:53 +0100
Message-Id: <20201214172559.074769061@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yong mao <yong.mao@mediatek.com>

commit 903a72eca4abf241293dcc1385896fd428e15fe9 upstream.

The SDIO recheck fix is required for more of the supported variants. Let's
add it to those that needs it.

Reported-by: Fabien Parent <fparent@baylibre.com>
Reported-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Signed-off-by: Yong Mao <yong.mao@mediatek.com>
Link: https://lore.kernel.org/r/20201119030237.9414-1-yong.mao@mediatek.com
Fixes: 9e2582e57407 ("mmc: mediatek: fix SDIO irq issue")
Cc: stable@vger.kernel.org
[Ulf: Clarified commitmsg ]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mtk-sd.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -447,7 +447,7 @@ struct msdc_host {
 
 static const struct mtk_mmc_compatible mt8135_compat = {
 	.clk_div_bits = 8,
-	.recheck_sdio_irq = false,
+	.recheck_sdio_irq = true,
 	.hs400_tune = false,
 	.pad_tune_reg = MSDC_PAD_TUNE,
 	.async_fifo = false,
@@ -486,7 +486,7 @@ static const struct mtk_mmc_compatible m
 
 static const struct mtk_mmc_compatible mt2701_compat = {
 	.clk_div_bits = 12,
-	.recheck_sdio_irq = false,
+	.recheck_sdio_irq = true,
 	.hs400_tune = false,
 	.pad_tune_reg = MSDC_PAD_TUNE0,
 	.async_fifo = true,
@@ -512,7 +512,7 @@ static const struct mtk_mmc_compatible m
 
 static const struct mtk_mmc_compatible mt7622_compat = {
 	.clk_div_bits = 12,
-	.recheck_sdio_irq = false,
+	.recheck_sdio_irq = true,
 	.hs400_tune = false,
 	.pad_tune_reg = MSDC_PAD_TUNE0,
 	.async_fifo = true,
@@ -525,7 +525,7 @@ static const struct mtk_mmc_compatible m
 
 static const struct mtk_mmc_compatible mt8516_compat = {
 	.clk_div_bits = 12,
-	.recheck_sdio_irq = false,
+	.recheck_sdio_irq = true,
 	.hs400_tune = false,
 	.pad_tune_reg = MSDC_PAD_TUNE0,
 	.async_fifo = true,
@@ -536,7 +536,7 @@ static const struct mtk_mmc_compatible m
 
 static const struct mtk_mmc_compatible mt7620_compat = {
 	.clk_div_bits = 8,
-	.recheck_sdio_irq = false,
+	.recheck_sdio_irq = true,
 	.hs400_tune = false,
 	.pad_tune_reg = MSDC_PAD_TUNE,
 	.async_fifo = false,
@@ -549,6 +549,7 @@ static const struct mtk_mmc_compatible m
 
 static const struct mtk_mmc_compatible mt6779_compat = {
 	.clk_div_bits = 12,
+	.recheck_sdio_irq = false,
 	.hs400_tune = false,
 	.pad_tune_reg = MSDC_PAD_TUNE0,
 	.async_fifo = true,


