Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AC157B0A2
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 07:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiGTF7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 01:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiGTF7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 01:59:31 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90F5558DA
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:59:30 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id os14so31180565ejb.4
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 22:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4zES4CYhj3tN4mi6+ASg0jwAx8/RIVXvRByb2IB3D4=;
        b=boRzy5L78YBv+4SKuCcI/vqJp5RXSuewjaHFVuJDuDWeuF+SKQBP9oPw2dJ8sPhNWM
         HdLc8ryB0r0EyFbLoBhdKPzH9w4rm4iUzyqbawAzCxuB1SDmssLBZ4Cha/QkDgybPAkc
         ZHxx5FZpZV/m22Y/7bu6du6ayy22oANBwTXCWqinJFMndaD5t5husZ+c+IznL7yJRnCM
         HIRFFEA65NBJn3n6RH5PsYmJkqnuKEFVy/u6sq6/yXUF5cb0FkNK3jyTVJRzj8e22i/x
         IT13UE+Msw0F+r2nyi0QgHgwGSy4qYkpj8ezrDG9KjzZVTVbfxu4L65ZP9ya+OpZn76G
         bfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4zES4CYhj3tN4mi6+ASg0jwAx8/RIVXvRByb2IB3D4=;
        b=3pZiD3si7bZlBAV6ikcCdu5wA50droHDJOCFQA4s5/7mC7RcEiIKt1Hqh6T9CMxKyL
         i0G0tcuBH+VTdI0aPMfoyngofkl8ubNiUhE3prDYmHB46pqk5KmeLKe8fiA/dM81plLU
         4HsxwuJRt7dAazf/+4CqT7QUpCPsVXfpEUQkDgdmoGU5rqGSI+ZgM7IiPyEbMpJvegTX
         6HfJ5y2617ktTindiA90fW8XfsO3yjQe6hY2s6sL6SFNWtJogxPgfzvno+SCkN0KH+q6
         rHtOo3P87FfxWNDyi1lFaNv3sye2r0ejnrEaswrlxA4dm9lumsiTo0HksqgGaNKaitDY
         vBPw==
X-Gm-Message-State: AJIora9cgNAhvk0HzDaOz8K2jL61mLi60gh2zBAdzYdCZ5nDVYXsNK78
        2ostME7/TsIlAcu6Cy8KeUeZnHSux7c=
X-Google-Smtp-Source: AGRyM1v2g4t6pV4x00425Hx7r0WUtoLZD/KcENMW7mVQ8n40l4WbMZemgEcle3XABUHY6gHKF6Zo9A==
X-Received: by 2002:a17:906:c10:b0:6f4:6c70:b00f with SMTP id s16-20020a1709060c1000b006f46c70b00fmr34082361ejf.660.1658296769062;
        Tue, 19 Jul 2022 22:59:29 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id u2-20020aa7db82000000b0043a253973aasm11556666edt.10.2022.07.19.22.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 22:59:28 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH v4 5.18 1/2] bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
Date:   Wed, 20 Jul 2022 07:59:23 +0200
Message-Id: <20220720055924.543750-2-fabio.porcedda@gmail.com>
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

