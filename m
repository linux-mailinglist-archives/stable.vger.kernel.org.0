Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D0937CD4E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhELQyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243758AbhELQmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 581676143A;
        Wed, 12 May 2021 16:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835594;
        bh=j21C0uGGw69LIIlZ8NcvxEXIBkOXsAvJUGkVDQuVpdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xo2NCQ6xGpg+svxnGmHuoWLNivE2sl1n4q6K4UcusMeS+/VKZkNDnzdgODD/Nrx7c
         JTSt+W1P4xhNIsJ/O96EA6DLJg6VmlcE+XOsCxj2BMQCRypfdDAlcqZ13JxU7l/CXP
         63CMxCRWpwHP6B39zy1aPhDcjFODX5diVHb+1HYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Hui <clare.chenhui@huawei.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 406/677] clk: qcom: a53-pll: Add missing MODULE_DEVICE_TABLE
Date:   Wed, 12 May 2021 16:47:32 +0200
Message-Id: <20210512144850.825126907@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Hui <clare.chenhui@huawei.com>

[ Upstream commit 790b516ada10a4dcc0f0a56dc0ced475d86d5820 ]

CONFIG_QCOM_A53PLL is tristate option and therefore this driver can be
compiled as a module. This patch adds missing MODULE_DEVICE_TABLE
definition which generates correct modalias for automatic loading of
this driver when it is built as an external module.

Fixes: 0c6ab1b8f894 ("clk: qcom: Add A53 PLL support")
Signed-off-by: Chen Hui <clare.chenhui@huawei.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210409082352.233810-3-clare.chenhui@huawei.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/a53-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/a53-pll.c b/drivers/clk/qcom/a53-pll.c
index 45cfc57bff92..af6ac17c7dae 100644
--- a/drivers/clk/qcom/a53-pll.c
+++ b/drivers/clk/qcom/a53-pll.c
@@ -93,6 +93,7 @@ static const struct of_device_id qcom_a53pll_match_table[] = {
 	{ .compatible = "qcom,msm8916-a53pll" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, qcom_a53pll_match_table);
 
 static struct platform_driver qcom_a53pll_driver = {
 	.probe = qcom_a53pll_probe,
-- 
2.30.2



