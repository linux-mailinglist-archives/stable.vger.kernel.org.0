Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882153C7296
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 16:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbhGMOtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 10:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236904AbhGMOtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 10:49:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E98461361;
        Tue, 13 Jul 2021 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626187593;
        bh=9gvfN36Dprd4TP8wUitT/YKG0D2SzJ4HMNTTVd9tPQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8BqSQE4rptH1MvFBDjFr07v3Ox4Bh9mvT0gpVA7UybbPUwa7RHRZ75+6FoXs8JNa
         uhYVLNhxD2jWu9bw9ko6olu8OGp3uSgshi3gTOAr5TN2sVBsG+oexuX2Wv0bXa7njv
         OBw3uNAIByt/ukuZ+F6+fjvNUfwRJZwVptYlf1UX+T6UIm8px7G7hOTMb2IIchRgkf
         JYTFJciw1zYQFs2aieFkTZMdedfkG2lfLEY0NWM7acg0uooG+mLy+kNBzGhGzCdZHX
         fqaIbHtDrjBWl8hwEQ51Qe9uDU7PQXQewV1jYvbO9/qgeGPS5O1Q/U7cDTFMCSrAYS
         Tn8iJeLjyHUOA==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-clk@vger.kernel.org
Cc:     dinguyen@kernel.org, sboyd@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org, Kris Chaplin <kris.chaplin@intel.com>
Subject: [PATCH 3/3] clk: socfpga: agilex: add the bypass register for s2f_usr0 clock
Date:   Tue, 13 Jul 2021 09:46:21 -0500
Message-Id: <20210713144621.605140-3-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210713144621.605140-1-dinguyen@kernel.org>
References: <20210713144621.605140-1-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the bypass register for the s2f_user0_clk.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Kris Chaplin <kris.chaplin@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/clk/socfpga/clk-agilex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index 7baaa16dea7b..242e94c0cf8a 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -280,7 +280,7 @@ static const struct stratix10_perip_cnt_clock agilex_main_perip_cnt_clks[] = {
 	{ AGILEX_SDMMC_FREE_CLK, "sdmmc_free_clk", NULL, sdmmc_free_mux,
 	  ARRAY_SIZE(sdmmc_free_mux), 0, 0xE4, 0, 0, 0},
 	{ AGILEX_S2F_USER0_FREE_CLK, "s2f_user0_free_clk", NULL, s2f_usr0_free_mux,
-	  ARRAY_SIZE(s2f_usr0_free_mux), 0, 0xE8, 0, 0, 0},
+	  ARRAY_SIZE(s2f_usr0_free_mux), 0, 0xE8, 0, 0x30, 2},
 	{ AGILEX_S2F_USER1_FREE_CLK, "s2f_user1_free_clk", NULL, s2f_usr1_free_mux,
 	  ARRAY_SIZE(s2f_usr1_free_mux), 0, 0xEC, 0, 0x88, 5},
 	{ AGILEX_PSI_REF_FREE_CLK, "psi_ref_free_clk", NULL, psi_ref_free_mux,
-- 
2.25.1

