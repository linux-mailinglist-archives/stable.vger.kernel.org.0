Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9E869CCF7
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjBTNpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjBTNpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:45:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BBA1CF65
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:44:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 704BF60CBA
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82224C4339B;
        Mon, 20 Feb 2023 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900683;
        bh=4o1zMhTYcnnme5AOxislWD3/gtGl4yDiiAUbS3cAHK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tcz9nkdjH54llg7DYkQ4U0SFF2v5YxnG3S/rK6Y0LE4g/imW+US62F3UKtY4lydr9
         NZEDtQ46B6rbj4mI4xMBiI7GaoWxB1o+zHvy8XPSMa0NbrzGoBSOE7n3/hgabwPidr
         RIS6Si99a+pqrv5CsU+Mo2GwBEy/d+AiEdOSU+Fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wesley Cheng <wcheng@codeaurora.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/156] usb: dwc3: dwc3-qcom: Fix typo in the dwc3 vbus override API
Date:   Mon, 20 Feb 2023 14:34:32 +0100
Message-Id: <20230220133603.608463219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit 8e6cb5d27e8246d9c986ec162d066a502d2b602b ]

There was an extra character in the dwc3_qcom_vbus_override_enable()
function.  Removed the extra character.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210704013314.200951-2-bryan.odonoghue@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: eb320f76e31d ("usb: dwc3: qcom: enable vbus override when in OTG dr-mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index aed35276e0e0..03321457a4a1 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -102,7 +102,7 @@ static inline void dwc3_qcom_clrbits(void __iomem *base, u32 offset, u32 val)
 	readl(base + offset);
 }
 
-static void dwc3_qcom_vbus_overrride_enable(struct dwc3_qcom *qcom, bool enable)
+static void dwc3_qcom_vbus_override_enable(struct dwc3_qcom *qcom, bool enable)
 {
 	if (enable) {
 		dwc3_qcom_setbits(qcom->qscratch_base, QSCRATCH_SS_PHY_CTRL,
@@ -123,7 +123,7 @@ static int dwc3_qcom_vbus_notifier(struct notifier_block *nb,
 	struct dwc3_qcom *qcom = container_of(nb, struct dwc3_qcom, vbus_nb);
 
 	/* enable vbus override for device mode */
-	dwc3_qcom_vbus_overrride_enable(qcom, event);
+	dwc3_qcom_vbus_override_enable(qcom, event);
 	qcom->mode = event ? USB_DR_MODE_PERIPHERAL : USB_DR_MODE_HOST;
 
 	return NOTIFY_DONE;
@@ -135,7 +135,7 @@ static int dwc3_qcom_host_notifier(struct notifier_block *nb,
 	struct dwc3_qcom *qcom = container_of(nb, struct dwc3_qcom, host_nb);
 
 	/* disable vbus override in host mode */
-	dwc3_qcom_vbus_overrride_enable(qcom, !event);
+	dwc3_qcom_vbus_override_enable(qcom, !event);
 	qcom->mode = event ? USB_DR_MODE_HOST : USB_DR_MODE_PERIPHERAL;
 
 	return NOTIFY_DONE;
@@ -670,7 +670,7 @@ static int dwc3_qcom_probe(struct platform_device *pdev)
 
 	/* enable vbus override for device mode */
 	if (qcom->mode == USB_DR_MODE_PERIPHERAL)
-		dwc3_qcom_vbus_overrride_enable(qcom, true);
+		dwc3_qcom_vbus_override_enable(qcom, true);
 
 	/* register extcon to override sw_vbus on Vbus change later */
 	ret = dwc3_qcom_register_extcon(qcom);
-- 
2.39.0



