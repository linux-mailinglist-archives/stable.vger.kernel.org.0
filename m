Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378B6451438
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349360AbhKOUHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344465AbhKOTYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F61661027;
        Mon, 15 Nov 2021 18:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002684;
        bh=dqwY0WO18UAjFQEIrEH5RY9GvmILH899f4KToOaLweA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRSBdrDzLjOBYyLOQoyMUGHYR9GlgeMdVjKcsKx2a87dMXkLE1zKGz4aob0tCrkYJ
         c3ksKGtul0AHnoucoJVG0Hhlx/AFjq7dXolQiridNlFoSkbXA3iUu1cTyizDrLFx0W
         OIkQLgJHG99i1qaD+7VXmXa+Je9ZEoMS4TA8nYHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 658/917] soc: qcom: rpmhpd: fix sm8350_mxcs peer domain
Date:   Mon, 15 Nov 2021 18:02:33 +0100
Message-Id: <20211115165451.192216814@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 086f52fdc8f7bd273d06a3de2adf65a063eb5392 ]

The sm8350_mxc's domain description incorrectly references
sm8150_mmcx_ao as a peer instead of sm8350_mxc_ao. Correct this typo.

Fixes: 639c85628757 ("soc: qcom: rpmhpd: Add SM8350 power domains")
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211020012639.1183806-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmhpd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/rpmhpd.c b/drivers/soc/qcom/rpmhpd.c
index a46735cec3f0f..d98cc8c2e5d5c 100644
--- a/drivers/soc/qcom/rpmhpd.c
+++ b/drivers/soc/qcom/rpmhpd.c
@@ -206,7 +206,7 @@ static const struct rpmhpd_desc sm8250_desc = {
 static struct rpmhpd sm8350_mxc_ao;
 static struct rpmhpd sm8350_mxc = {
 	.pd = { .name = "mxc", },
-	.peer = &sm8150_mmcx_ao,
+	.peer = &sm8350_mxc_ao,
 	.res_name = "mxc.lvl",
 };
 
-- 
2.33.0



