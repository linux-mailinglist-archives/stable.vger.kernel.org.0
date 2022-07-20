Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC55757B07A
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 07:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiGTFoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 01:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiGTFoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 01:44:04 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73A652FD1
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:44:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x91so22409680ede.1
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m+q5sLjFrEX3IbHxKAke7BvnfFTjZ/i+IpeLQG9nQkE=;
        b=Cr67fF4MAW1UTtbp8KbFy+/tJRvFbLOIpbOl14a1GKHg/mm18XYW8D+KVVbARCkiWw
         IasTJD8PbVhR3bNkx/ycUOu6CuElpVfcQO53DN4kEdIglHPTkRRaD3CwtGsn3YBY2z9V
         404RLCz2Z1ftr4hlQ411342LOJzMes5pwHJIVSu9dZ022QQBK8f4mqlBpiHalepAUoSi
         JUaU8wpIKc453JV6JOTnaX4mQTFf/T220SJQrnhATE5LkCCDCnMgvItLFyHNE7tgmzRe
         5cukwUStSjxIvI+wSUCLSQ0Fpn67fFAa8JBRxT+bTgV86ZUeqS1+ONQ9+APYmfQHFAEI
         XGaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+q5sLjFrEX3IbHxKAke7BvnfFTjZ/i+IpeLQG9nQkE=;
        b=uDYiBLgxB77WHV+MO/JvCrUESiwjUQpOAX1zQkJveCkXSd752wNir8FKpA/DNwniSF
         rM+CgloYWNEOCSUN9r1s4SNmo7SM2mDXH8jk3UyG+YQZVuWCCbrVj0FLyFTryQSce8G1
         pOjcWDiepji67k75Q7GQtdtyds8MbnlfiQUDlR2doezpQY/e8Ddz7BAivtjdF6pJma4V
         rCgcreKT/8zIm/cSxcqEBMdRKE9/G4QF5J6FsCKcXwr/qj6aDJlga9wEM0/oTSfAV3VZ
         +sS5/k52M12RE0IMWvNe38V2F8b3hQYefwjVG75GtiYNDDw8B4Y4wQI/t+yFMu25n91c
         ZKLw==
X-Gm-Message-State: AJIora87yLgeA04SSrUPKIr3iLEBXDqtdXgxn1cUIz68SS4rfynh9zn8
        yfyp7WSxYnmqLlbmsoQrpCeMFuawA1s=
X-Google-Smtp-Source: AGRyM1sUt9xl9rD55Q7dI+mz6OajnwmocB+2Qgc4+8WSnxA3ogMhEB/SMZt9o+yndxNDTVZkGjv2pQ==
X-Received: by 2002:aa7:d753:0:b0:43b:a7df:60b0 with SMTP id a19-20020aa7d753000000b0043ba7df60b0mr4961268eds.191.1658295840821;
        Tue, 19 Jul 2022 22:44:00 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id dy20-20020a05640231f400b0043ba1798785sm1776144edb.57.2022.07.19.22.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 22:44:00 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH v3 5.18 2/2] bus: mhi: host: pci_generic: add Telit FN990
Date:   Wed, 20 Jul 2022 07:43:41 +0200
Message-Id: <20220720054341.542391-3-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220720054341.542391-1-fabio.porcedda@gmail.com>
References: <20220720054341.542391-1-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 77fc41204734042861210b9d05338c9b8360affb upstream.

Add Telit FN990:

01:00.0 Unassigned class [ff00]: Qualcomm Device 0308
        Subsystem: Device 1c5d:2010

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20220502112036.443618-1-dnlplm@gmail.com
[mani: Added "host" to the subject]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
---
 drivers/bus/mhi/pci_generic.c | 41 +++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 1621e4ac94b2..b780990faf80 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -441,6 +441,44 @@ static const struct mhi_pci_dev_info mhi_telit_fn980_hw_v1_info = {
 	.sideband_wake = false,
 };
 
+static const struct mhi_channel_config mhi_telit_fn990_channels[] = {
+	MHI_CHANNEL_CONFIG_UL_SBL(2, "SAHARA", 32, 0),
+	MHI_CHANNEL_CONFIG_DL_SBL(3, "SAHARA", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(4, "DIAG", 64, 1),
+	MHI_CHANNEL_CONFIG_DL(5, "DIAG", 64, 1),
+	MHI_CHANNEL_CONFIG_UL(12, "MBIM", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(13, "MBIM", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(32, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(33, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0_MBIM", 128, 2),
+	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0_MBIM", 128, 3),
+};
+
+static struct mhi_event_config mhi_telit_fn990_events[] = {
+	MHI_EVENT_CONFIG_CTRL(0, 128),
+	MHI_EVENT_CONFIG_DATA(1, 128),
+	MHI_EVENT_CONFIG_HW_DATA(2, 1024, 100),
+	MHI_EVENT_CONFIG_HW_DATA(3, 2048, 101)
+};
+
+static const struct mhi_controller_config modem_telit_fn990_config = {
+	.max_channels = 128,
+	.timeout_ms = 20000,
+	.num_channels = ARRAY_SIZE(mhi_telit_fn990_channels),
+	.ch_cfg = mhi_telit_fn990_channels,
+	.num_events = ARRAY_SIZE(mhi_telit_fn990_events),
+	.event_cfg = mhi_telit_fn990_events,
+};
+
+static const struct mhi_pci_dev_info mhi_telit_fn990_info = {
+	.name = "telit-fn990",
+	.config = &modem_telit_fn990_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.sideband_wake = false,
+	.mru_default = 32768,
+};
+
 static const struct pci_device_id mhi_pci_id_table[] = {
 	/* Telit FN980 hardware revision v1 */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x1C5D, 0x2000),
@@ -449,6 +487,9 @@ static const struct pci_device_id mhi_pci_id_table[] = {
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx55_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0304),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx24_info },
+	/* Telit FN990 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, 0x1c5d, 0x2010),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn990_info },
 	{ PCI_DEVICE(0x1eac, 0x1001), /* EM120R-GL (sdx24) */
 		.driver_data = (kernel_ulong_t) &mhi_quectel_em1xx_info },
 	{ PCI_DEVICE(0x1eac, 0x1002), /* EM160R-GL (sdx24) */
-- 
2.37.1

