Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069075781D7
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 14:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbiGRMOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 08:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbiGRMOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 08:14:06 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A287B1057A
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 05:14:05 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id mf4so20849656ejc.3
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 05:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L0ATKTSgeE4Z1Xb/BCPTBuLq05A2fm9Oi99CJVlsVwM=;
        b=fO8fk+2yr9OPYjq9fVNyY5YVNa0tleDSfA3geCC18LvS3c4oxyZbgNJxU0Bku1MtZ8
         8LeELdjPkkYmSepggIh1gnchtwwa0khbehXIgMYlY+YApzJrSc3YS0thZyszE8GVLgM/
         lnpaqA8/JOeey9Qf5QAiGYA4c/SbQs41oy+G3IdNLaTvy21IUIcwG4rBdewFH08EJBnK
         Jfy+KD2ocwJgXV89zveSgt//BdClJvVkZMHk3rnkBXdsp0bLaTolrExtuZXQPWXkjzT8
         WfUOPgVEsQKUWRyKWTVE3GJMgfWd7v/MhCHq1IhHMSEf0XQrAm/cMjogglWDfO3cJUY9
         xIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L0ATKTSgeE4Z1Xb/BCPTBuLq05A2fm9Oi99CJVlsVwM=;
        b=DlV1RgmWA+EfOd5vUw9zqeDkLwS85R5leZUIP6skw5T9cpVF6p8wh9WKXp4sTDAHkp
         ThtTfOTkfSF/zVHnZpDZRanU7jp3HuNk2KXO+rLo6mQHWU1od9S+hqAXu0vRkllN9fkn
         QI5bgSJcFAKI44dYWe+/XUD9Rp/JWyxG/l9XcZzaaASKgEDorJT1MnRhWTIsw3im8Oxp
         KVRrxSka60m2HBUXNMV1y8/mCduT6Zpxj2y02gYJeZbulaVIbnbnzya7e6QNexgmzsic
         QH95i/CyEHKnhO+hmwZsPemgMPUgm8PCsM9R/LA1iIzUfuMmyXb6WDQfDc/TbqiYknfQ
         6rBg==
X-Gm-Message-State: AJIora9NF3yd6/je8VA5WiZIXYKR/EzMfxro3acWxPdL30F930Q9O2ep
        UjMii/JKEib4zrExacIH2NaUjOY0xrw=
X-Google-Smtp-Source: AGRyM1v5HgkW6Pno7aKuU5ILRY9jHPn5w49Kz+drTT1abKSxakuUgbr53OME0sgNEsSouHj3ugl3VQ==
X-Received: by 2002:a17:906:5a5b:b0:72b:39cf:6042 with SMTP id my27-20020a1709065a5b00b0072b39cf6042mr24906420ejc.301.1658146443802;
        Mon, 18 Jul 2022 05:14:03 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id r18-20020a17090609d200b006feed200464sm5364603eje.131.2022.07.18.05.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:14:03 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
X-Google-Original-From: Fabio Porcedda <Fabio.Porcedda@telit.com>
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Fabio Porcedda <Fabio.Porcedda@telit.com>
Subject: [PATCH 1/2] bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
Date:   Mon, 18 Jul 2022 14:13:34 +0200
Message-Id: <20220718121335.386097-2-Fabio.Porcedda@telit.com>
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

commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2 upstream.

Add Telit FN980 v1 hardware revision:

01:00.0 Unassigned class [ff00]: Qualcomm Device [17cb:0306]
        Subsystem: Device [1c5d:2000]

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20220427072648.17635-1-dnlplm@gmail.com
[mani: Added "host" to the subject]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Fabio Porcedda <Fabio.Porcedda@telit.com>
---
 drivers/bus/mhi/host/pci_generic.c | 38 ++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 541ced27d941..6b27295f566f 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -446,10 +446,48 @@ static const struct mhi_pci_dev_info mhi_sierra_em919x_info = {
 	.sideband_wake = false,
 };
 
+static const struct mhi_channel_config mhi_telit_fn980_hw_v1_channels[] = {
+	MHI_CHANNEL_CONFIG_UL(14, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(15, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 16, 0),
+	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 16, 0),
+	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 1),
+	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0", 128, 2),
+};
+
+static struct mhi_event_config mhi_telit_fn980_hw_v1_events[] = {
+	MHI_EVENT_CONFIG_CTRL(0, 128),
+	MHI_EVENT_CONFIG_HW_DATA(1, 1024, 100),
+	MHI_EVENT_CONFIG_HW_DATA(2, 2048, 101)
+};
+
+static struct mhi_controller_config modem_telit_fn980_hw_v1_config = {
+	.max_channels = 128,
+	.timeout_ms = 20000,
+	.num_channels = ARRAY_SIZE(mhi_telit_fn980_hw_v1_channels),
+	.ch_cfg = mhi_telit_fn980_hw_v1_channels,
+	.num_events = ARRAY_SIZE(mhi_telit_fn980_hw_v1_events),
+	.event_cfg = mhi_telit_fn980_hw_v1_events,
+};
+
+static const struct mhi_pci_dev_info mhi_telit_fn980_hw_v1_info = {
+	.name = "telit-fn980-hwv1",
+	.fw = "qcom/sdx55m/sbl1.mbn",
+	.edl = "qcom/sdx55m/edl.mbn",
+	.config = &modem_telit_fn980_hw_v1_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.mru_default = 32768,
+	.sideband_wake = false,
+};
+
 static const struct pci_device_id mhi_pci_id_table[] = {
 	/* EM919x (sdx55), use the same vid:pid as qcom-sdx55m */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x18d7, 0x0200),
 		.driver_data = (kernel_ulong_t) &mhi_sierra_em919x_info },
+	/* Telit FN980 hardware revision v1 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x1C5D, 0x2000),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn980_hw_v1_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0306),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx55_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0304),
-- 
2.37.1

