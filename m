Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627FA2839D3
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgJEP2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbgJEP2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:28:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2136120637;
        Mon,  5 Oct 2020 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911726;
        bh=h/m2qR11Y6NkmkgN17ToEQjKeDpDBU0R/tT/O777toI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTtS23FtCK7wfdiDlMDL4155xwdCWTINIXGL5X3p6+bpXRhKiUzOaY3AHYgfYL0OF
         eJybMATYBZhJK52PAfLzQLxh7O0aDCQTtjOP3T77ZB/jiK+cAiCPLeI/mzxrwMZYPM
         pl+BPMkEK1VA/Wgw3gcTvHP62bt5F/PW/YKFW/xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.4 07/57] clk: socfpga: stratix10: fix the divider for the emac_ptp_free_clk
Date:   Mon,  5 Oct 2020 17:26:19 +0200
Message-Id: <20201005142110.164317264@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit b02cf0c4736c65c6667f396efaae6b5521e82abf upstream.

The fixed divider the emac_ptp_free_clk should be 2, not 4.

Fixes: 07afb8db7340 ("clk: socfpga: stratix10: add clock driver for
Stratix10 platform")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20200831202657.8224-1-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/socfpga/clk-s10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/socfpga/clk-s10.c
+++ b/drivers/clk/socfpga/clk-s10.c
@@ -107,7 +107,7 @@ static const struct stratix10_perip_cnt_
 	{ STRATIX10_EMAC_B_FREE_CLK, "emacb_free_clk", NULL, emacb_free_mux, ARRAY_SIZE(emacb_free_mux),
 	  0, 0, 2, 0xB0, 1},
 	{ STRATIX10_EMAC_PTP_FREE_CLK, "emac_ptp_free_clk", NULL, emac_ptp_free_mux,
-	  ARRAY_SIZE(emac_ptp_free_mux), 0, 0, 4, 0xB0, 2},
+	  ARRAY_SIZE(emac_ptp_free_mux), 0, 0, 2, 0xB0, 2},
 	{ STRATIX10_GPIO_DB_FREE_CLK, "gpio_db_free_clk", NULL, gpio_db_free_mux,
 	  ARRAY_SIZE(gpio_db_free_mux), 0, 0, 0, 0xB0, 3},
 	{ STRATIX10_SDMMC_FREE_CLK, "sdmmc_free_clk", NULL, sdmmc_free_mux,


