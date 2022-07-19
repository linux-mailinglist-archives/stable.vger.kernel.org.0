Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794BC579520
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 10:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbiGSISn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 04:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiGSISn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 04:18:43 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EB227B06
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 01:18:42 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ez10so25678486ejc.13
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 01:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m+q5sLjFrEX3IbHxKAke7BvnfFTjZ/i+IpeLQG9nQkE=;
        b=cZHp5lVqYvboIO3ak2Q45a3m7U17PiwmejYWR/hlcDUQjAOvxUvmugtxQmxhVoEH0f
         5UO9dqD536ldraHfecGzH3/+eBr0mW9rNBi77SXqnMyatKX9lfbCSSD/mBm6Umz+yQK4
         ZgSiNKbToKdTAZryRk3WEcprsbdMBXgdtfyNHNoexa8g9j6aczl5qPdyYiUkvxxqsuZy
         LRkCKq9t9XzDQWMk4jU/T3BEQQI74HXchVK83kUa+9zQVK/04znXjyAYm0oZH9676Zc1
         R9RcH6o7TOF2ComzJXdeNOw8+0NLBlMQdmTi25jMUFBzal5L2WJr6aPcbVc0JCzLWpQQ
         llFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+q5sLjFrEX3IbHxKAke7BvnfFTjZ/i+IpeLQG9nQkE=;
        b=tTrcD02+IE5A0ZJwjG4Ba4xgtbMrT6Rh63NnntwCFBXnqyLxeP3rYQ2YO3dygXZDA2
         6RRGbtZfsK/amGsQQpzXEVc/0P3yKVjDbNAbGBCVngFC8x5YhevSAzKNlt/ITaD64UIg
         2lX6dvEF4wE4ZovNAyNPZ9vdIZJAb4heVez3AK1+0zMcirNlrYqUtn1N9eY1Yo3QNlF0
         U7zVV+GDx8QBM/2WlhleT8uPlouaBmQu4471giJXrMlx35oMATvi9kAgRoJZTrXmHdzy
         YUKcM0fzeGFvWQZPCZigOf5DaBBePCGe6yAQ0ClebNvuEleEpA/UUCQDpWBOzaJqIW0I
         Yk6w==
X-Gm-Message-State: AJIora/kMuOYqGt5PoZSPEoRHdu8sh0pSF43hEPeBEDdDpct1vjAKo6O
        OnhkcUbholEk7XhLz29XrUptQGjqs44=
X-Google-Smtp-Source: AGRyM1uJzXfkM/WBVTDHrxrJXSpApCPQZfZbSDHkqKBjgklItf6BFI8CDulzRFE2+eQADjmqekYpAA==
X-Received: by 2002:a17:907:7255:b0:72b:50b8:82d6 with SMTP id ds21-20020a170907725500b0072b50b882d6mr5165375ejc.677.1658218720516;
        Tue, 19 Jul 2022 01:18:40 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id w13-20020aa7cb4d000000b0043a5004e714sm10008075edt.64.2022.07.19.01.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 01:18:40 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 5.15 2/2] bus: mhi: host: pci_generic: add Telit FN990
Date:   Tue, 19 Jul 2022 10:18:15 +0200
Message-Id: <20220719081815.466080-3-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719081815.466080-1-fabio.porcedda@gmail.com>
References: <20220719081815.466080-1-fabio.porcedda@gmail.com>
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

