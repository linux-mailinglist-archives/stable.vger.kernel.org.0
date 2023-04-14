Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E6B6E24E6
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 15:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjDNN5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 09:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDNN5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 09:57:55 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F733DF
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 06:57:54 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id i26so23844497lfc.6
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 06:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681480672; x=1684072672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mXvnZiBUYIq053kMTXG6IiE5H5AHN38vkwVpGrxQfAM=;
        b=FvxzrKFv6qu6gY8IkmUHTLBKvwF2rccNgKQ52wFuyK+and5ZOaYZ/z+7oEc+6g+kba
         EGeQXR/H/gRG2Z9jiwdIaJs5+5oIDAHZMovZENKlE4qF2de4lDil03ixMVVdG4CNbhkB
         IVO8D3jCKDH0Nb1bGcXO0hY5ntWDOc4dlbreaI0IDnu7EPdBssCQpy/uQvDFLY+FLAsi
         /TrnBq2jnQd9VLBaVY8U/Q3uGGjuxT6N36e4mtenNLeU5WCGZMnONTlFowW3e3sbwXc/
         j/KKpsqJfmSR0Uyj+VDB+br8ae3DguLzeZeSUt/HZmuLUSvAV45O1cq6yCPp1cw70dVl
         s/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681480672; x=1684072672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mXvnZiBUYIq053kMTXG6IiE5H5AHN38vkwVpGrxQfAM=;
        b=R34qe2lNq2SYGEa6hi7ZtybKllj9SqT/zd7mQPfZ3g0wUdyJ3yeLHh5xGmf1DkqQq/
         jePfphb4F98s881ZcW1hbYasVgyoZnRnLta2yknRDiq2IVqOajOYQkBKnJpaQp9XApUU
         DCUJH8VCwGg9trLFBYA7MEwrqudr1YEs+9XnESNkeG1rlUT8WbaE8lAj9p+41XQA5+Nv
         XYaYbM2mxLUpCqJn7e1X/PeDMjpQTrapyDMUQFM/AVby09xOTg8h8OvXYj7hZhwKB14B
         uq/S/YA3kk64Deq5Y9ZuU2Vn9zZgouZbYM/CGrt72ccpcNhDkn29ViFnJA2aZCOhXCeK
         iAfQ==
X-Gm-Message-State: AAQBX9fJ5TdpxCk8gNEH84aGGLSDb5fHwwc8NPlfJ1NfX3o5263MkwY+
        c4RNnfzw6+Yad8TO0X+zEB4sWg==
X-Google-Smtp-Source: AKy350Y8w02zr0TOBQcRwvabEdWzYKknhuOt7AYhTw22LkM3il3oYtICOWzkj4zlx9357TC0SMPSgQ==
X-Received: by 2002:ac2:5937:0:b0:4e8:61d2:72ee with SMTP id v23-20020ac25937000000b004e861d272eemr2693701lfi.5.1681480672256;
        Fri, 14 Apr 2023 06:57:52 -0700 (PDT)
Received: from Linus-Dell.lan ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id b7-20020ac247e7000000b004cc5f44747dsm808161lfp.220.2023.04.14.06.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 06:57:51 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-arm-msm@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Herman van Hazendonk <me@herrie.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: dts: qcom-apq8060: Fix regulator node names
Date:   Fri, 14 Apr 2023 15:57:47 +0200
Message-Id: <20230414135747.34994-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 04715461abf7 altered the node names in a DTSI file
used by qcom-apq8060-dragonboard.dts breaking the board.
Align the node names in the DTS file and the board boots
again.

Cc: stable@vger.kernel.org
Fixes: 04715461abf7 ("ARM: dts: qcom-msm8660: align RPM regulators node name with bindings")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/qcom-apq8060-dragonboard.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8060-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8060-dragonboard.dts
index 8e4b61e4d4b1..e8fe321f3d89 100644
--- a/arch/arm/boot/dts/qcom-apq8060-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8060-dragonboard.dts
@@ -451,7 +451,7 @@ &rpm {
 	 * PM8901 supplies "preliminary regulators" whatever
 	 * that means
 	 */
-	pm8901-regulators {
+	regulators-0 {
 		vdd_l0-supply = <&pm8901_s4>;
 		vdd_l1-supply = <&vph>;
 		vdd_l2-supply = <&vph>;
@@ -537,7 +537,7 @@ lvs0 {
 
 	};
 
-	pm8058-regulators {
+	regulators-1 {
 		vdd_l0_l1_lvs-supply = <&pm8058_s3>;
 		vdd_l2_l11_l12-supply = <&vph>;
 		vdd_l3_l4_l5-supply = <&vph>;
-- 
2.34.1

