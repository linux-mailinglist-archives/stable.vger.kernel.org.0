Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF4B60162C
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 20:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiJQSWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 14:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJQSWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 14:22:45 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676535E64A
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 11:22:44 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so15023590pjq.3
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 11:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6K0fLEBttx8lrk4TTwV2hs18H4QMB+rkLX1+fm4Wis=;
        b=nxqUGdizsCANm/EpHpz5hqb4AimuiKiL4vxSxSv4+4wYsCrg3ZX2r+R0nalfLws+lo
         hkpfcpbWLzwK3FjxPPyjYWRoo2eJlZVFqFfN1ttObKYlxV3X/0770D3G8e0NtmrnyM2h
         NRRQp2E9X5Q+TL0/EC7JOM6GGtX+WIi/eFLLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q6K0fLEBttx8lrk4TTwV2hs18H4QMB+rkLX1+fm4Wis=;
        b=MMD8zGGMZUeMMHaMloZlgjvetpYbh4xPChVVggQBjcQXWKDSOnvoz7nMKryvF/ft76
         K9pMT0BJMo0g042jp6MVAcgaTTvT6RbUPqq3DDDOsVLqGDPHhSo7yoiwfXscFc/NWijY
         lH8ElOxKE7nK2H12xGDuMlqKp/yKwMTA9dMC7gkcKZP1PScIffhQzZVfgcEVoT2qHCad
         P7zE7JwWBJf4uXj3b7TWUweZzV7qyeJNbSplrzjaLSh+K8L1hl6QQ/khTQk0pVfuhecj
         5/27uHZoWxT5cV+sb3f41LxIle3nZ/hlyYV+7ObrokaOe7YBjmVP4bLc6Ap2fIbdZUg2
         WbPA==
X-Gm-Message-State: ACrzQf1UB2qRcWLD/JbyI6K1k3YZ8gB+yWIytsy9BdtDHxiCD6fmGA7p
        Kl83OkUmT76QIk7lBAD0ZyonEgwnz/DSaw==
X-Google-Smtp-Source: AMsMyM7GLm+6wFeWIABSOhA4Ga3nzDh8hX5DBawB8jbrqm0QCqI77NSN0GrmXH8LNM2NUdHzY7+V7A==
X-Received: by 2002:a17:903:2342:b0:181:bc30:b02f with SMTP id c2-20020a170903234200b00181bc30b02fmr12928368plh.30.1666030963439;
        Mon, 17 Oct 2022 11:22:43 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:9d:2:f043:fb90:4576:538b])
        by smtp.gmail.com with ESMTPSA id n18-20020a170903111200b001782a0d3eeasm7014597plh.115.2022.10.17.11.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 11:22:42 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Sibi Sankar <sibis@codeaurora.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, Evan Green <evgreen@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alex Elder <elder@linaro.org>
Subject: [PATCH] arm64: dts: qcom: sc7180-trogdor: Fixup modem memory region
Date:   Mon, 17 Oct 2022 11:22:41 -0700
Message-Id: <20221017182241.1086545-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

commit ef9a5d188d663753e73a3c8e8910ceab8e9305c4 upstream.

The modem firmware memory requirements vary between 32M/140M on
no-lte/lte skus respectively, so fixup the modem memory region
to reflect the requirements.

Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/1602786476-27833-1-git-send-email-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Alex Elder <elder@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This fixes boot of the modem on trogdor boards with the DTS from 5.10.y
stable tree. Without this patch I run into memory assignment errors and
then the modem fails to boot.

 arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi | 4 ++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi         | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
index 44956e3165a1..469aad4e5948 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
@@ -9,6 +9,10 @@ &ap_sar_sensor {
 	label = "proximity-wifi-lte";
 };
 
+&mpss_mem {
+	reg = <0x0 0x86000000 0x0 0x8c00000>;
+};
+
 &remoteproc_mpss {
 	firmware-name = "qcom/sc7180-trogdor/modem/mba.mbn",
 			"qcom/sc7180-trogdor/modem/qdsp6sw.mbn";
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 5b2a616c6257..cb2c47f13a8a 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -39,7 +39,7 @@ atf_mem: memory@80b00000 {
 		};
 
 		mpss_mem: memory@86000000 {
-			reg = <0x0 0x86000000 0x0 0x8c00000>;
+			reg = <0x0 0x86000000 0x0 0x2000000>;
 			no-map;
 		};
 

base-commit: 014862eecf03f58066a957027dde73cbecdf4395
-- 
https://chromeos.dev

