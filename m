Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81E25FF599
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 23:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiJNVxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 17:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJNVxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 17:53:06 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64391186CD
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 14:53:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l1so5893965pld.13
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 14:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o1t17x5zzSpdCuf+jFEyQQCtGA/0x7inpYCOmKSTCbI=;
        b=Uo/GHpK8vU+smItb6OkYUg4Tbd+055hEHZN7hanO/jiPIWezUApYxsQMXMB6pYaNHW
         YN66dB0oETBKwriK4Nmb5J9TkN89fw0Z1ls/fLsECw/qHWGQjTN79WOUuwSOTqI8vUme
         ycK4KPHzIMv/LQwAtM1LH0zOkn9dBCsMmfJoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o1t17x5zzSpdCuf+jFEyQQCtGA/0x7inpYCOmKSTCbI=;
        b=jXTALb3c+IDkp+jj8hRP3FYRhZ6Ceqw9wGtBcgWd41fTEHzfMY53F+w6i9vEGRQ/+f
         aq1fzBiL5UWV+k/Qqyt+VFx6lk58g4Mcu2hc0dfC7B/ta1AkgdVH8E43b5NllJbkAf4/
         MrUXovnPtkoFeFn++mMCoxI5ujCdAv63OTyOFYO1Fd8Bt67gZBkni+PqgelBJL6Vdiyn
         QwVLFwrKY+s5SVK6QTcAM9xID95TQd/O0mzw5BpjY93k9Vkj6FCCVW5R1PZgP7EMrTYW
         0A/KxDoNnR5fWiQF/aSAlcBjLmhLDj6yTJ3j0qs56jCzbaTwATPnA3AbfJ1rD7wTqEa5
         40Sg==
X-Gm-Message-State: ACrzQf2N2wpUBi3qsIKtu5bFPbzEJgK6b29Dhn91J1nkuN6ogeC/o8IS
        MpkHVMYTBPO9ddrrIkbTxOQgpTBspxQjgg==
X-Google-Smtp-Source: AMsMyM68dam+bk2zRi9fPwq4foTUHTm41a5WwL7uUAIKb98CVmZlEOlpn3mQ8qWzIX9UqFFtGO8dCQ==
X-Received: by 2002:a17:90b:380b:b0:20d:7364:796f with SMTP id mq11-20020a17090b380b00b0020d7364796fmr30737pjb.13.1665784384453;
        Fri, 14 Oct 2022 14:53:04 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:9d:2:9f6e:fc87:d13f:1fa6])
        by smtp.gmail.com with ESMTPSA id p184-20020a625bc1000000b005618189b0ffsm2197437pfb.104.2022.10.14.14.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:53:03 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Sibi Sankar <sibis@codeaurora.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, Alex Elder <elder@linaro.org>,
        Evan Green <evgreen@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.10] arm64: dts: qcom: sc7180-trogdor: Fixup modem memory region
Date:   Fri, 14 Oct 2022 14:53:02 -0700
Message-Id: <20221014215302.3905135-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

