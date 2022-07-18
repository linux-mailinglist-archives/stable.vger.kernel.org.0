Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955565783B0
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 15:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiGRN2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 09:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiGRN2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 09:28:23 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDDE15FEC
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 06:28:22 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e15so15298620edj.2
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 06:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7Sid+mx/01FFQ0Mck5StVhd2l+/ACF58MAiCNStLYQ=;
        b=Nuh2ACPYlRtx6ki9UIEtOiuA5llXFirhwX3970VFf0YO1MwDuljDIrC0wjMi7NK+1E
         evEhuWcF/1sS9xFteNkk1ZiOPgpoRLQABWf5tnmvQ0tvN0wT9caJAjN/I4HTYNXwjGQ0
         eEeMUYo18OorAlKrNujjxMqR5DkHlHdoHtoJKFIiiSgkX+lvLixFe/A6Ru6nlBd5E4IS
         z4rutc/l8mV8w4jnGYJCiIOy/PjhpLahmn8TDn9cyMIBUuVFCwp1rK0cpAMGsw5j1GRh
         OSqNYwFgqmDm1RbRkYiO5IQI3B8A+8EhGsksbVQZnI6jq1QA2LHSvyIZVPpkcC4h7GpJ
         Sq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7Sid+mx/01FFQ0Mck5StVhd2l+/ACF58MAiCNStLYQ=;
        b=hkSWAbgQgoO8f+c+ULM9ycKWvkvGsOvajr0RK4NYFMqxg1vH4iUggriQrj/QeoTdLR
         KY4njfjBhmFqiAHC7kZV53XTGiK9hmhxVtLNvnRJvN13UUSWIpSNXNo+K/kXRvlU9dTq
         WNp3l2rWDWcRbwirDJ3Xw3XXRHVVZpFr4Y2emytN+rKPQjXSis12SrwKD4pnQkxOkY3i
         lbWEjxCcU+Xg4pCOACK78hncnJCvZkLnDrO1BR+Kp97lnS4JfplRzmI34DU1phd196mm
         8epnRVYMa1QJv2U8IWo4zoFvC2zNQFTMA7AH4mhJZUAWBcsaWaFJbDoDs7YbM0AZ4+tl
         j7uA==
X-Gm-Message-State: AJIora+7P7o4UxIe/Afb496NLTqpx12mu9mHTuVgQDX+dWmHquXdLvfG
        ftbZzsMTEN2s889Z7oTQbBgVyvBkypc=
X-Google-Smtp-Source: AGRyM1sXkLbTBTmiHJVVRjTLIK23CTvDsQAph6ajxMmxHEUlVEBXFngzoUCzIAYXYYf31meXmLshvg==
X-Received: by 2002:a05:6402:2895:b0:43b:1e47:c132 with SMTP id eg21-20020a056402289500b0043b1e47c132mr30987106edb.425.1658150901145;
        Mon, 18 Jul 2022 06:28:21 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id s5-20020a1709066c8500b0071c6dc728b2sm5490219ejr.86.2022.07.18.06.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:28:20 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     stable@vger.kernel.org
Cc:     Fabio Porcedda <fabio.porcedda@gmail.com>,
        Daniele Palmas <dnlplm@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 5.18 2/2] bus: mhi: host: pci_generic: add Telit FN990
Date:   Mon, 18 Jul 2022 15:27:11 +0200
Message-Id: <20220718132711.393957-3-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220718132711.393957-1-fabio.porcedda@gmail.com>
References: <20220718132711.393957-1-fabio.porcedda@gmail.com>
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

