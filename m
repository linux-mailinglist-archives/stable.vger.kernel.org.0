Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DBC57B078
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 07:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiGTFoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 01:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGTFoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 01:44:01 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B733652FD1
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:44:00 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id sz17so31081005ejc.9
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JK9DuNUn5xxUaIm5zeiot/4MTm9draBeWT/9N7PpVX4=;
        b=Dq77v5VY2Gnca7iBh2PI/gj8jwBx2qzz8c+Rk+OUvqtAjz1cpesCufrGZ+Yax1Bqtk
         QPdVRV4/U97VnC3LMCXJEWD9FZXOnskkOT6Jtq3BlDGDal7fGNxcicgNkaMcd8GJ/fb4
         FndfHjL9VRsS3znKIHom0knJRGeXjb+A1/E02dlj84TJTrp/4p5LxgpS01eR/LsEPCSl
         5abn1S60zmPrVyrgxK04N/DtTUK+IrSsJXu7thbIo5V/cdonO1oMfvqsjrWE3dTn+5ug
         wNiDSJCu3OgPTPsy5rD+Q4+2ZV5Uj0/hGMEga9Na90wX/WHHwmLK3wGVSve33rypMzrU
         Knnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JK9DuNUn5xxUaIm5zeiot/4MTm9draBeWT/9N7PpVX4=;
        b=25HGTJFWpvAkOJLyAAbz7gTo4ao2strYsSvlmxlXJRHQTZckAjPbOWh5ZiWGNs7GTd
         nykBxULH0Wgi+74B8ciefdGSOIAn6mdH3unwgZ23MqxkV6DcU5XInihsqKn8REtWqn9R
         xp6PsZhxu704wRS78l7PmC26DZN0f0gjtmgmEHkuzycKCCtomS6xysL//mam6muXweLQ
         sXI8BaNo5w7a6VaODXpcmYG5EZBW5/XAZjooMcBoiJksU/62zENmnxFbmMHXmBjYc37g
         NLrZem0w2LZ+8dwhWE2F6bm1IVhxm4Di4Mp00tf+71N/P3wTRRw+BYqsPyzfUgpBh00o
         ddGA==
X-Gm-Message-State: AJIora+Xcwk/65EQCi4h8fum2DE3KdEtoFHqBY1UpzaTKcvTYuAqHfwm
        UXxghK5r1XA9Ral6Plei/YSaIhdbAKs=
X-Google-Smtp-Source: AGRyM1vp5wRcDDy0PIjKkuuer4nEIKqPGetA8JW576js490UKOIRjN59GwWINYWik2f8LkpaHdjQLg==
X-Received: by 2002:a17:906:3f49:b0:722:e1d2:f857 with SMTP id f9-20020a1709063f4900b00722e1d2f857mr34266681ejj.15.1658295838968;
        Tue, 19 Jul 2022 22:43:58 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id dy20-20020a05640231f400b0043ba1798785sm1776144edb.57.2022.07.19.22.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 22:43:58 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH v3 5.18 1/2] bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
Date:   Wed, 20 Jul 2022 07:43:40 +0200
Message-Id: <20220720054341.542391-2-fabio.porcedda@gmail.com>
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

commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2 upstream.

Add Telit FN980 v1 hardware revision:

01:00.0 Unassigned class [ff00]: Qualcomm Device [17cb:0306]
        Subsystem: Device [1c5d:2000]

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20220427072648.17635-1-dnlplm@gmail.com
[mani: Added "host" to the subject]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
---
 drivers/bus/mhi/pci_generic.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 0982642a7907..1621e4ac94b2 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -406,7 +406,45 @@ static const struct mhi_pci_dev_info mhi_mv31_info = {
 	.mru_default = 32768,
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
+	/* Telit FN980 hardware revision v1 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x1C5D, 0x2000),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn980_hw_v1_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0306),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx55_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0304),
-- 
2.37.1

