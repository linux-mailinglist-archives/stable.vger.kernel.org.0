Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39063AFD30
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 08:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhFVGr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 02:47:28 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15956 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhFVGr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 02:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624344311; x=1655880311;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9NppxxWgPdvS0+U7vUSE4I2gsSMQAT7WGWs5PvGI+qs=;
  b=Sz3xZPddHk76hHeFSXlEfYATrz8ctNDEEgLYfdBH+rgMbTKPAryJXEd3
   QcjuqMrEZhwqVi3+gKcvbCuBo+ll3WMo3j0TL/yRaovJSvo97cGroVdDv
   283ps/dV/1ypl7Ij1EBhaoRT+ENMN97k+7QixO5iRTxDlL/ZOB9PBaXv4
   2j8PAwFIbeJk7SYtoqXPSboQ5dyIjLdahdpNhkqQBFh5f6AjTT73lm3/0
   0epyh93nsWCSKu3QTuISZegh31Ql52g9JpWUhq3Ba2zv2xT8LEbEYmqBL
   MI9uZIfxq4gh1lTdClhQxPquj5VjVXCR0jngncmnd6IP5e1IdA1KrkQHh
   g==;
IronPort-SDR: l+9dea3BHVTMbDMDfRHjHAoIirazBXTrAOpSG09vYUWIZnPaXJLpJhi21W6MFLOA/P7y34lPK8
 AN4RRrd2sVrDuPVIeJ9fsRXmnzIIWnnhtxeK9Hdlq9fVYYZyqkmwOcMl06KijeB9//xxXEnT1x
 ztP7eLGDgA6eg5y5/D3tRGrLyI+P9QZLSdgiTW16SZsHxj1ewGTyHSiTOF/4hw59WwWm+wq1/7
 gcGVv7yGYMpvJIscvXYyUTTbQFpBuNOk359vBDAmOrrmZKbj7trnY0NqjOQBzPZG4cVKAhswG1
 bMc=
X-IronPort-AV: E=Sophos;i="5.83,291,1616428800"; 
   d="scan'208";a="177347457"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jun 2021 14:45:11 +0800
IronPort-SDR: CHs3mOAOzBXmwBn3+m8BK3u0/D1HKgCa9yOxP9WF/ORybFl2CPiqSRadOc1fhkcnkNA++pVARN
 E6/RCx7ugwmDLB6G7zpn3xuHL+yOEiD6YzvmVHbIRcKB27ZyMHwLuSeZpSeF6J8pKr6uwfrZUT
 ZjMzifaCHnq/HmycexUIN5g1UOa0iPS0Bn7skKq+KCuyE8kjP+4+MvizHTC7TDsau9dgMzWsg5
 BNTDJB9D6D9rWgvjb7wync+zLtzWT0XD5sGXUNFooPzrAsO7Yox2aR8R3FphpLBhz8WaYakCeC
 tUAT2tNNs81FCXixv4tugV8M
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 23:23:52 -0700
IronPort-SDR: tz7nXEsCegYbNtC/+cvoBQc/jJSpk7b0OVLctnxRmSa6wzVQYeVbefpt1JlXt+E1GZiWyDJa1J
 edyorr113uQ5BjdzmWzDS3/EmU5LPvFQzFLqwu8SJHzs4+QtpjuIS4jwPEKTjSx3Cxi79lw2IJ
 OBEc44h64z79YZn1r7gkgl2RmORKVwRVOJ2townuwTEc0P4Oz6xrC/CqCT7spbA25Jyi7awqzT
 qPblygIaoYkR+T9yhQ7S2pbJL4jHdG+F+OSEHrmnMPFQCKD3T88xOFmqB/vkz49A67JtU7pUaf
 MXQ=
WDCIronportException: Internal
Received: from unknown (HELO twashi.fujisawa.hgst.com) ([10.225.163.9])
  by uls-op-cesaip01.wdc.com with ESMTP; 21 Jun 2021 23:45:11 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Stephen Boyd <sboyd@kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: [PATCH] clk: k210: Fix k210_clk_set_parent()
Date:   Tue, 22 Jun 2021 15:45:02 +0900
Message-Id: <20210622064502.14841-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In k210_clk_set_parent(), add missing writel() call to update the mux
register of a clock to change its parent. This also fixes a compilation
warning with clang when compiling with W=1.

Fixes: c6ca7616f7d5 ("clk: Add RISC-V Canaan Kendryte K210 clock driver")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/clk/clk-k210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-k210.c b/drivers/clk/clk-k210.c
index 6c84abf5b2e3..67a7cb3503c3 100644
--- a/drivers/clk/clk-k210.c
+++ b/drivers/clk/clk-k210.c
@@ -722,6 +722,7 @@ static int k210_clk_set_parent(struct clk_hw *hw, u8 index)
 		reg |= BIT(cfg->mux_bit);
 	else
 		reg &= ~BIT(cfg->mux_bit);
+	writel(reg, ksc->regs + cfg->mux_reg);
 	spin_unlock_irqrestore(&ksc->clk_lock, flags);
 
 	return 0;
-- 
2.31.1

