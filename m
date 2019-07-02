Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84AE5CB8C
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfGBIOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbfGBIG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:06:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D95E20659;
        Tue,  2 Jul 2019 08:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054787;
        bh=BU0AhxekeNGWqi7mp/5rG6KvQm1Hk8klTrgPtxYW/Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItwU9e2Xx2F+vbWQC/lb7mNswZYvm7YI8QpkDH2ZAGELqXbW/QJhJCAgZyan6GsTQ
         k57IStpEGL68dTTSnC2rf6x0gpj7qDQqjxVGeWx7JVBhPq4HSRJM3lf021JpxZRMnd
         P6cHyVIXq9NrtrEs7S1P4XoHxA6NFvScrTTEmJUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 35/72] clk: socfpga: stratix10: fix divider entry for the emac clocks
Date:   Tue,  2 Jul 2019 10:01:36 +0200
Message-Id: <20190702080126.466485627@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit 74684cce5ebd567b01e9bc0e9a1945c70a32f32f upstream.

The fixed dividers for the emac clocks should be 2 not 4.

Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/socfpga/clk-s10.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/socfpga/clk-s10.c
+++ b/drivers/clk/socfpga/clk-s10.c
@@ -103,9 +103,9 @@ static const struct stratix10_perip_cnt_
 	{ STRATIX10_NOC_CLK, "noc_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux),
 	  0, 0, 0, 0x3C, 1},
 	{ STRATIX10_EMAC_A_FREE_CLK, "emaca_free_clk", NULL, emaca_free_mux, ARRAY_SIZE(emaca_free_mux),
-	  0, 0, 4, 0xB0, 0},
+	  0, 0, 2, 0xB0, 0},
 	{ STRATIX10_EMAC_B_FREE_CLK, "emacb_free_clk", NULL, emacb_free_mux, ARRAY_SIZE(emacb_free_mux),
-	  0, 0, 4, 0xB0, 1},
+	  0, 0, 2, 0xB0, 1},
 	{ STRATIX10_EMAC_PTP_FREE_CLK, "emac_ptp_free_clk", NULL, emac_ptp_free_mux,
 	  ARRAY_SIZE(emac_ptp_free_mux), 0, 0, 4, 0xB0, 2},
 	{ STRATIX10_GPIO_DB_FREE_CLK, "gpio_db_free_clk", NULL, gpio_db_free_mux,


