Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAC713E12D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgAPQsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:48:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729795AbgAPQsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:48:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 733DE214AF;
        Thu, 16 Jan 2020 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193289;
        bh=FkOQnxTg5SvzIvPHLCaOZs+capOhsPMcdpjfo5aP7cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUAgSRQorB6Xsv4mjZ/r1ipk/lsgZItU2FZQ2P2mEbBMgjxuS1uCiN/YEZQCns0OS
         84PkFzFPQHFSN1eQbfn4bKVFthm6F/1PCoUtxLb1duHxGgKUe8CWSWbZdnbCNdV8+7
         pE5hCmXbSBsWv78gKObTgGz/KhuLBMkxrVvPx8/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 067/205] clk: imx7ulp: Correct system clock source option #7
Date:   Thu, 16 Jan 2020 11:40:42 -0500
Message-Id: <20200116164300.6705-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 96ac93a7c4bea4eb4186425795c00937d2dd6085 ]

In the latest reference manual Rev.0,06/2019, the SCS's option #7
is no longer from upll, it is reserved, update clock driver accordingly.

Fixes: b1260067ac3d ("clk: imx: add imx7ulp clk driver")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx7ulp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx7ulp.c b/drivers/clk/imx/clk-imx7ulp.c
index a0f650150367..d2c49fbd0563 100644
--- a/drivers/clk/imx/clk-imx7ulp.c
+++ b/drivers/clk/imx/clk-imx7ulp.c
@@ -24,7 +24,7 @@ static const char * const spll_pfd_sels[]	= { "spll_pfd0", "spll_pfd1", "spll_pf
 static const char * const spll_sels[]		= { "spll", "spll_pfd_sel", };
 static const char * const apll_pfd_sels[]	= { "apll_pfd0", "apll_pfd1", "apll_pfd2", "apll_pfd3", };
 static const char * const apll_sels[]		= { "apll", "apll_pfd_sel", };
-static const char * const scs_sels[]		= { "dummy", "sosc", "sirc", "firc", "dummy", "apll_sel", "spll_sel", "upll", };
+static const char * const scs_sels[]		= { "dummy", "sosc", "sirc", "firc", "dummy", "apll_sel", "spll_sel", "dummy", };
 static const char * const ddr_sels[]		= { "apll_pfd_sel", "upll", };
 static const char * const nic_sels[]		= { "firc", "ddr_clk", };
 static const char * const periph_plat_sels[]	= { "dummy", "nic1_bus_clk", "nic1_clk", "ddr_clk", "apll_pfd2", "apll_pfd1", "apll_pfd0", "upll", };
-- 
2.20.1

