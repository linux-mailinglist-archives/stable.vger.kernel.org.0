Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A154937C52A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhELPic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235784AbhELPaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3022761C41;
        Wed, 12 May 2021 15:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832549;
        bh=Jv7KqhsBb+bNbT2AIrR659ZcXFzZz6oZDHNkxzgTNn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IS8/qD/0QhFLvkkA6YDk+ewKpvoq/KUVhQgvCcin0+LLVt5tlsROBGnpl931iQoGc
         4P46UsA/ydJ/K3as4oAFsoWi3nAAHB8zzbS/qAiEmYh+uypAey15/HHYFJ+nkvLyo9
         /jt/ImoU8iYy7gLSFSWkNGvl6PkC0tKO5wchh7MY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Hui <clare.chenhui@huawei.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/530] clk: qcom: apss-ipq-pll: Add missing MODULE_DEVICE_TABLE
Date:   Wed, 12 May 2021 16:47:14 +0200
Message-Id: <20210512144830.458071693@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Hui <clare.chenhui@huawei.com>

[ Upstream commit d0a859edda46b45baeab9687d173102300d76e2b ]

CONFIG_IPQ_APSS_PLL is tristate option and therefore this driver can
be compiled as a module. This patch adds missing MODULE_DEVICE_TABLE
definition which generates correct modalias for automatic loading of
this driver when it is built as an external module.

Fixes: ecd2bacfbbc4 ("clk: qcom: Add ipq apss pll driver")
Signed-off-by: Chen Hui <clare.chenhui@huawei.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210409082352.233810-4-clare.chenhui@huawei.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/apss-ipq-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/apss-ipq-pll.c b/drivers/clk/qcom/apss-ipq-pll.c
index 30be87fb222a..bef7899ad0d6 100644
--- a/drivers/clk/qcom/apss-ipq-pll.c
+++ b/drivers/clk/qcom/apss-ipq-pll.c
@@ -81,6 +81,7 @@ static const struct of_device_id apss_ipq_pll_match_table[] = {
 	{ .compatible = "qcom,ipq6018-a53pll" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, apss_ipq_pll_match_table);
 
 static struct platform_driver apss_ipq_pll_driver = {
 	.probe = apss_ipq_pll_probe,
-- 
2.30.2



