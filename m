Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A14557B0A3
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 07:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiGTF7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 01:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiGTF7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 01:59:33 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806A4564C3
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:59:32 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ez10so31109742ejc.13
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DEA1wCpNVn+GVcWZ4ILSg2xt/uw3C54gsVcanp/T6XE=;
        b=HOwwvAChKFxpEZgav0TgWO30Xfwwv4A4aRF0qwnfz5PRPV3EfD8PAVfukmwnM/rbUL
         5O2d1ktslAEddq1VugH0MTWlDMnt+c6TOek0+wh5F3yls9RNQd9bn8bTrx7/whCHkUaQ
         c3ePvTSxDEaJyzg70uWPHY9emFHoUlISOFT1gmtJJg0aggpYmAX+VRD2oGJuZbn4ZJaY
         K2+ydx2jPAISGY/ACUCW+tXqFpMD8INvxygzzPlDdvuhGbM1grr9xdso0gD0bdvWKBS4
         a/3xXr6kGphiLn2zq/x5wqy/neIT7zAFzj03abl/YftkRl+8Qt5sDIvyQA5UBVlh0JwA
         WBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DEA1wCpNVn+GVcWZ4ILSg2xt/uw3C54gsVcanp/T6XE=;
        b=vrViFwaQVuXzXhAwnbl7OuhOOKLl9jZJ823jkZ96ysSW8Us/vaZI72+UZywjEbKbT5
         E3fFaBz0luWGWhVdE5umNudynnxEQX9pCD7KLmmJfOUsArEutj6BjA8MN0ozL3glR9ZD
         AYcQkfVC4W1m5eG9Zj8UQXtnkFEmRo9t58od+jjyAUWNHITgUOk2PqQPffWU/9bBCLMO
         gDKUwaFNDpJ2WqPAi216jOFLvGstz3piNZtk135IpgYhnrv5QLiGBbZ4IXRVozP4kygN
         72Tmz130Pmy35gfYkECYCk1vaL0SXtnDjy+wOos0Zq3/Xd7yWLxXUw4rxbc0B7nyIHaV
         ubdQ==
X-Gm-Message-State: AJIora/JjrlMLSamhlhDsQd6KStnaijqeuHaT2Q3vqR5tyMM5FnvCZYq
        ceQvCp+bSzH2XJHf8+fjakk8z4oDao0=
X-Google-Smtp-Source: AGRyM1u53rmqetU8p7ynupye3jFdZmmMYCCYPzl6ZO1fIWEhEJpu0Z78wDeGmYNDuTRjgvwHn8LBGQ==
X-Received: by 2002:a17:907:728c:b0:72b:995f:78d with SMTP id dt12-20020a170907728c00b0072b995f078dmr33969925ejc.348.1658296770755;
        Tue, 19 Jul 2022 22:59:30 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id u2-20020aa7db82000000b0043a253973aasm11556666edt.10.2022.07.19.22.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 22:59:30 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH v4 5.18 2/2] bus: mhi: host: pci_generic: add Telit FN990
Date:   Wed, 20 Jul 2022 07:59:24 +0200
Message-Id: <20220720055924.543750-3-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220720055924.543750-1-fabio.porcedda@gmail.com>
References: <20220720055924.543750-1-fabio.porcedda@gmail.com>
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
 drivers/bus/mhi/host/pci_generic.c | 41 ++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 6b27295f566f..de1e934a4f7e 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -481,6 +481,44 @@ static const struct mhi_pci_dev_info mhi_telit_fn980_hw_v1_info = {
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
 	/* EM919x (sdx55), use the same vid:pid as qcom-sdx55m */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x18d7, 0x0200),
@@ -492,6 +530,9 @@ static const struct pci_device_id mhi_pci_id_table[] = {
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

