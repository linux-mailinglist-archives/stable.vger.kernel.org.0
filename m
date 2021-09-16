Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF7940DF07
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240608AbhIPQGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240601AbhIPQFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:05:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B30216124B;
        Thu, 16 Sep 2021 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808260;
        bh=6pMMcXncOm85zsYRsedmFxr+VYM3OOrRubhac+lyrLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFXYLjf5/CRAMO5mwy03/Q5gziHvBzHZs0Giyy1d8OSAdw998JRgLVRLNTP1ia905
         nSM+F/l73w9CASzIi9ooTJCsMp7hOtCyyl03nbl/DKA9MPaevA26tzxGhN10far+qa
         sC3usUABsdYDq7KnYIt/yUxT4aOHodzOVvWkTlM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kris Chaplin <kris.chaplin@intel.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 020/306] clk: socfpga: agilex: add the bypass register for s2f_usr0 clock
Date:   Thu, 16 Sep 2021 17:56:05 +0200
Message-Id: <20210916155754.620208738@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit d17929eb1066d1c1653aae9bb4396a9f1d6602ac upstream.

Add the bypass register for the s2f_user0_clk.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Kris Chaplin <kris.chaplin@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20210713144621.605140-3-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/socfpga/clk-agilex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -267,7 +267,7 @@ static const struct stratix10_perip_cnt_
 	{ AGILEX_SDMMC_FREE_CLK, "sdmmc_free_clk", NULL, sdmmc_free_mux,
 	  ARRAY_SIZE(sdmmc_free_mux), 0, 0xE4, 0, 0, 0},
 	{ AGILEX_S2F_USER0_FREE_CLK, "s2f_user0_free_clk", NULL, s2f_usr0_free_mux,
-	  ARRAY_SIZE(s2f_usr0_free_mux), 0, 0xE8, 0, 0, 0},
+	  ARRAY_SIZE(s2f_usr0_free_mux), 0, 0xE8, 0, 0x30, 2},
 	{ AGILEX_S2F_USER1_FREE_CLK, "s2f_user1_free_clk", NULL, s2f_usr1_free_mux,
 	  ARRAY_SIZE(s2f_usr1_free_mux), 0, 0xEC, 0, 0x88, 5},
 	{ AGILEX_PSI_REF_FREE_CLK, "psi_ref_free_clk", NULL, psi_ref_free_mux,


