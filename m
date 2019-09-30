Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 266F5C23C8
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 16:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731777AbfI3O6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 10:58:45 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:21809 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731629AbfI3O6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 10:58:45 -0400
X-IronPort-AV: E=Sophos;i="5.64,567,1559487600"; 
   d="scan'208";a="27703171"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 30 Sep 2019 23:58:42 +0900
Received: from rtamta01.rta.renesas.com (transport.eroom.renesas.com [143.103.48.75])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id BBC19423A9C2;
        Mon, 30 Sep 2019 23:58:42 +0900 (JST)
Received: from localhost.localdomain (unknown [172.27.18.241])
        by rtamta01.rta.renesas.com (Postfix) with ESMTP id 4A12611A;
        Mon, 30 Sep 2019 14:58:41 +0000 (UTC)
From:   Chris Brandt <chris.brandt@renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Brandt <chris.brandt@renesas.com>, stable@vger.kernel.org
Subject: [PATCH] pinctrl: rza2: Fix gpio name typos
Date:   Mon, 30 Sep 2019 09:58:04 -0500
Message-Id: <20190930145804.30497-1-chris.brandt@renesas.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix apparent copy/paste errors that were overlooked in the original driver.
  "P0_4" -> "PF_4"
  "P0_3" -> "PG_3"

Fixes: b59d0e782706 ("pinctrl: Add RZ/A2 pin and gpio controller")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
---
 drivers/pinctrl/pinctrl-rza2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rza2.c b/drivers/pinctrl/pinctrl-rza2.c
index 3be1d833bf25..eda88cdf870d 100644
--- a/drivers/pinctrl/pinctrl-rza2.c
+++ b/drivers/pinctrl/pinctrl-rza2.c
@@ -213,8 +213,8 @@ static const char * const rza2_gpio_names[] = {
 	"PC_0", "PC_1", "PC_2", "PC_3", "PC_4", "PC_5", "PC_6", "PC_7",
 	"PD_0", "PD_1", "PD_2", "PD_3", "PD_4", "PD_5", "PD_6", "PD_7",
 	"PE_0", "PE_1", "PE_2", "PE_3", "PE_4", "PE_5", "PE_6", "PE_7",
-	"PF_0", "PF_1", "PF_2", "PF_3", "P0_4", "PF_5", "PF_6", "PF_7",
-	"PG_0", "PG_1", "PG_2", "P0_3", "PG_4", "PG_5", "PG_6", "PG_7",
+	"PF_0", "PF_1", "PF_2", "PF_3", "PF_4", "PF_5", "PF_6", "PF_7",
+	"PG_0", "PG_1", "PG_2", "PG_3", "PG_4", "PG_5", "PG_6", "PG_7",
 	"PH_0", "PH_1", "PH_2", "PH_3", "PH_4", "PH_5", "PH_6", "PH_7",
 	/* port I does not exist */
 	"PJ_0", "PJ_1", "PJ_2", "PJ_3", "PJ_4", "PJ_5", "PJ_6", "PJ_7",
-- 
2.23.0

