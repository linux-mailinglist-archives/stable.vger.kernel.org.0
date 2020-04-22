Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF691B3F63
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbgDVKhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730219AbgDVKWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8EAB2075A;
        Wed, 22 Apr 2020 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550958;
        bh=P04iBLwJn0vDXHqxsvdHNKZ9hXQfsXc2NSGvEKJvR4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znGjceKa/IELiTPUvjeB00iu0Y6GHRVXllCdkrlyS7QdipdskNEgUAY5hPo4G+Idc
         mocpOTsT90inovm+X1UYCaEz/BKRp4qfiqwJNIDBjc7eTHn+hsGRG/u3Rns0y6tYV1
         hJwaquGL+sQmfei/t9DNuw2j/h2EUSQzDRjbBXn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 043/166] clk: imx: pll14xx: Add new frequency entries for pll1443x table
Date:   Wed, 22 Apr 2020 11:56:10 +0200
Message-Id: <20200422095053.703642471@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 57795654fb553a78f07a9f92d87fb2582379cd93 ]

Add new frequency entries to pll1443x table to meet different
display settings requirement.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-pll14xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/imx/clk-pll14xx.c b/drivers/clk/imx/clk-pll14xx.c
index 5b0519a81a7af..37e311e1d0586 100644
--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -55,8 +55,10 @@ static const struct imx_pll14xx_rate_table imx_pll1416x_tbl[] = {
 };
 
 static const struct imx_pll14xx_rate_table imx_pll1443x_tbl[] = {
+	PLL_1443X_RATE(1039500000U, 173, 2, 1, 16384),
 	PLL_1443X_RATE(650000000U, 325, 3, 2, 0),
 	PLL_1443X_RATE(594000000U, 198, 2, 2, 0),
+	PLL_1443X_RATE(519750000U, 173, 2, 2, 16384),
 	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
 	PLL_1443X_RATE(361267200U, 361, 3, 3, 17511),
 };
-- 
2.20.1



