Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C335781D8
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 14:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbiGRMOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 08:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiGRMOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 08:14:09 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449C210FCA
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 05:14:08 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id j22so20853212ejs.2
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 05:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fBMmJr1GMT1N55eVuShfJulVgG9rlF+t1UWeUctp2l4=;
        b=fdtwZlLLxUkdlxexFXeBPGpzhm5qshYNW4c0IqGlbmrHzgCA5/CvLouaaSgHw4Vsr1
         boMGYGqnPFL9RIhsEHCzIMz1ZsF0kojySLlYA8xBKLIVJYFKg3tptL5yfpQqW4yoFXuX
         xAdpM8mTlbRtMpQYjxn/6NsKFC4gVMVKozTxCCryEdsggi8Ekp2nVNVUB0mtEcJYiPeN
         cgArrluecSx4mR4+Qn0BDGGoKjh5kZBl/uPk0XOx7KU3pMniMTfV+gQleSkQthHUkdkb
         kosZwWccMJ93xRe7IsXNQA4hd5nZtKavNBPW5AuMkAce3I3AZ4ZYu8mfWcaL/Yl933UA
         UHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fBMmJr1GMT1N55eVuShfJulVgG9rlF+t1UWeUctp2l4=;
        b=kdvgZ0uhbTHrgUaFfqvUZ/W0OxZnMfyqhY2HlXjxpsMOfwIrVUYupAWxI4lJ/5mDjf
         oGEcViPvzPZmiOfSn+j38lDVnL2bPTLDTIAzcL0itSWZwSqjm8TD5FzFk9bOpfxLTj0C
         rusM5guQjPAEL7Z3P1dhPRzkn7CvOkXU2UPsKUpSMyB17V6IKUZfqu/Z6yJdbgfTt2ud
         IOwX5spN5xG/jDRYjLpbItzp4/hJ1ROY709NO/rfPeQ8Mv6M1oAj+v1C5WaM6oD0bFBV
         ajiHwNykfR+Z14Wh2WvH6csvsjqRN5aXU2A5HMznIQkU8n9vo3qUGuQZkhA/DT+VsS1Z
         be2A==
X-Gm-Message-State: AJIora/aFJMc05FNoiwsDqZEiCKIZalLMVWFTyvudInr7Gs/tdVzHIc9
        s7ERRor90AJ7tgRdKg0b+d6Vh2ot+ec=
X-Google-Smtp-Source: AGRyM1sonv8HH8U9fGdSkGDSZ1dfoPPOL2Om+x1GNgpHEQXyVV8B5/YwM5m4DPb3r6qgJW4utKdJOg==
X-Received: by 2002:a17:907:7dac:b0:72e:e75e:62d9 with SMTP id oz44-20020a1709077dac00b0072ee75e62d9mr16948416ejc.627.1658146446463;
        Mon, 18 Jul 2022 05:14:06 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id r18-20020a17090609d200b006feed200464sm5364603eje.131.2022.07.18.05.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:14:06 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
X-Google-Original-From: Fabio Porcedda <Fabio.Porcedda@telit.com>
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Fabio Porcedda <Fabio.Porcedda@telit.com>
Subject: [PATCH 2/2] bus: mhi: host: pci_generic: add Telit FN990
Date:   Mon, 18 Jul 2022 14:13:35 +0200
Message-Id: <20220718121335.386097-3-Fabio.Porcedda@telit.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220718121335.386097-1-Fabio.Porcedda@telit.com>
References: <20220718121335.386097-1-Fabio.Porcedda@telit.com>
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
Signed-off-by: Fabio Porcedda <Fabio.Porcedda@telit.com>
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

