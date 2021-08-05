Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519993E1662
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 16:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241406AbhHEOHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 10:07:09 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:38769 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbhHEOHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 10:07:09 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 5133BC9582;
        Thu,  5 Aug 2021 14:05:25 +0000 (UTC)
Received: (Authenticated sender: thomas.perrot@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id E44E2FF80A;
        Thu,  5 Aug 2021 14:04:34 +0000 (UTC)
From:   Thomas Perrot <thomas.perrot@bootlin.com>
To:     linux-arm-msm@vger.kernel.org
Cc:     manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org,
        loic.poulain@linaro.org, stable@vger.kernel.org,
        Thomas Perrot <thomas.perrot@bootlin.com>
Subject: [PATCH] bus: mhi: pci_generic: increase timeout value for operations to 24000ms
Date:   Thu,  5 Aug 2021 16:02:31 +0200
Message-Id: <20210805140231.268273-1-thomas.perrot@bootlin.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Otherwise, the waiting time was too short to use a Sierra Wireless EM919X
connected to an i.MX6 through the PCIe bus.

Signed-off-by: Thomas Perrot <thomas.perrot@bootlin.com>
---
 drivers/bus/mhi/pci_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 4dd1077354af..e08ed6e5031b 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -248,7 +248,7 @@ static struct mhi_event_config modem_qcom_v1_mhi_events[] = {
 
 static const struct mhi_controller_config modem_qcom_v1_mhiv_config = {
 	.max_channels = 128,
-	.timeout_ms = 8000,
+	.timeout_ms = 24000,
 	.num_channels = ARRAY_SIZE(modem_qcom_v1_mhi_channels),
 	.ch_cfg = modem_qcom_v1_mhi_channels,
 	.num_events = ARRAY_SIZE(modem_qcom_v1_mhi_events),
-- 
2.31.1

