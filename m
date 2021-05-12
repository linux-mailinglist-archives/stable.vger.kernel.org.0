Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6084737CD48
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbhELQx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243751AbhELQmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF4C961108;
        Wed, 12 May 2021 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835592;
        bh=H65KWihhEKJKDJqcAIuVElhniSKNtEvkE3ZpZLvF/Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZlQZkDmf1PSLC8RzNYu26HrE9BTXRzbUf+pTZOrVG9y5r42pAchlU5uieMjjdnCM
         pR5Vfh1mPJtoGAtPjfPz6tfTMrqbW/et6Ga4iDwnwdgnQhigjBSFnbOcv8+FnT8idw
         WlYVqyYALuMmu6z6C3Dkt+cuTVRDZ0OJSQTJEkiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Hui <clare.chenhui@huawei.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 405/677] clk: qcom: a7-pll: Add missing MODULE_DEVICE_TABLE
Date:   Wed, 12 May 2021 16:47:31 +0200
Message-Id: <20210512144850.789499261@linuxfoundation.org>
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

[ Upstream commit 77a618b1481f6fdb41b7585ed0f67c47fb8401e5 ]

CONFIG_QCOM_A7PLL is tristate option and therefore this driver can be
compiled as a module. This patch adds missing MODULE_DEVICE_TABLE
definition which generates correct modalias for automatic loading of
this driver when it is built as an external module.

Fixes: 5a5223ffd7ef ("clk: qcom: Add A7 PLL support")
Signed-off-by: Chen Hui <clare.chenhui@huawei.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210409082352.233810-2-clare.chenhui@huawei.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/a7-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/a7-pll.c b/drivers/clk/qcom/a7-pll.c
index e171d3caf2cf..c4a53e5db229 100644
--- a/drivers/clk/qcom/a7-pll.c
+++ b/drivers/clk/qcom/a7-pll.c
@@ -86,6 +86,7 @@ static const struct of_device_id qcom_a7pll_match_table[] = {
 	{ .compatible = "qcom,sdx55-a7pll" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, qcom_a7pll_match_table);
 
 static struct platform_driver qcom_a7pll_driver = {
 	.probe = qcom_a7pll_probe,
-- 
2.30.2



