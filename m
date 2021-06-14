Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ECD3A647B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhFNLZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235743AbhFNLXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:23:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67B226147E;
        Mon, 14 Jun 2021 10:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667982;
        bh=Jj3vv+pNNL9qPkapLmO4ot0tfOVqoylq7CGsXHxp5f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gF/4YNSOFJVKqdXiSZXr6JZ4BHCE5foz3daenVCIaj0vUpYm86CEL4oFCbxngbZdi
         2oHr/kRSKlmG+O90oB73ZwJD4ic45ZCDDTVnl9ykZrkWTd9Gkb3mXDaYarvMiDQLFi
         Z7krGaoW0PFnUR+8Viak5bpBcxCn94aExwup3eq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.12 150/173] pinctrl: qcom: Fix duplication in gpio_groups
Date:   Mon, 14 Jun 2021 12:28:02 +0200
Message-Id: <20210614102703.161332172@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 0e4bf265b11a00bde9fef6b791bd8ee2d8059701 upstream.

"gpio52" and "gpio53" are duplicated in gpio_groups, fix them!

Fixes: ac43c44a7a37 ("pinctrl: qcom: Add SDX55 pincontrol driver")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210526082857.174682-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-sdx55.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/pinctrl/qcom/pinctrl-sdx55.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdx55.c
@@ -410,15 +410,15 @@ static const char * const gpio_groups[]
 	"gpio29", "gpio30", "gpio31", "gpio32", "gpio33", "gpio34", "gpio35",
 	"gpio36", "gpio37", "gpio38", "gpio39", "gpio40", "gpio41", "gpio42",
 	"gpio43", "gpio44", "gpio45", "gpio46", "gpio47", "gpio48", "gpio49",
-	"gpio50", "gpio51", "gpio52", "gpio52", "gpio53", "gpio53", "gpio54",
-	"gpio55", "gpio56", "gpio57", "gpio58", "gpio59", "gpio60", "gpio61",
-	"gpio62", "gpio63", "gpio64", "gpio65", "gpio66", "gpio67", "gpio68",
-	"gpio69", "gpio70", "gpio71", "gpio72", "gpio73", "gpio74", "gpio75",
-	"gpio76", "gpio77", "gpio78", "gpio79", "gpio80", "gpio81", "gpio82",
-	"gpio83", "gpio84", "gpio85", "gpio86", "gpio87", "gpio88", "gpio89",
-	"gpio90", "gpio91", "gpio92", "gpio93", "gpio94", "gpio95", "gpio96",
-	"gpio97", "gpio98", "gpio99", "gpio100", "gpio101", "gpio102",
-	"gpio103", "gpio104", "gpio105", "gpio106", "gpio107",
+	"gpio50", "gpio51", "gpio52", "gpio53", "gpio54", "gpio55", "gpio56",
+	"gpio57", "gpio58", "gpio59", "gpio60", "gpio61", "gpio62", "gpio63",
+	"gpio64", "gpio65", "gpio66", "gpio67", "gpio68", "gpio69", "gpio70",
+	"gpio71", "gpio72", "gpio73", "gpio74", "gpio75", "gpio76", "gpio77",
+	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83", "gpio84",
+	"gpio85", "gpio86", "gpio87", "gpio88", "gpio89", "gpio90", "gpio91",
+	"gpio92", "gpio93", "gpio94", "gpio95", "gpio96", "gpio97", "gpio98",
+	"gpio99", "gpio100", "gpio101", "gpio102", "gpio103", "gpio104",
+	"gpio105", "gpio106", "gpio107",
 };
 
 static const char * const qdss_stm_groups[] = {


