Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEC14FF954
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbiDMOuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiDMOuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:50:39 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DDD63BF0
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:48:18 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id x4so2127388iop.7
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mfrhGGBj0Sk85zrOhsdb8TtI3LhLRBO2IGMEqKkv48Y=;
        b=gLH2FmLxxK0THSmKMCbixs/2G77Gh3wNSwGe8nrgYwaMdkmFxJoiPFwAHbXUxwGI15
         aUdRjTnfXvEus80+QDNVfucSuyyK1BFZWdEx/UkZNijzqt8kyRa/WQV+zUJ7E7B/3xCz
         7VUID1LQDVpVnO8CsWOAmmIh6BLz+BXefSGs6GyApCYX6BQjjsX+Nkg3aaG1VR3phYdt
         Lh1oVfebuUafEO0Bh35Y41klO2bx9AbnfXxLWKX3y01lEQQwkIQ1edMv7rrfW+eOQ6kO
         33yPwOpfJL730VnwcKSdpcfDHWYr+ix8typh2tHSJOVRyGkvGlqDBDfru3uNqJvdQoSL
         Snmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mfrhGGBj0Sk85zrOhsdb8TtI3LhLRBO2IGMEqKkv48Y=;
        b=57CEDIF43Am/oEleEeIG36xaCHKaaOyIDuyInLgZdcrM3ix2UiJKvU8/S6AvV3IlET
         XQygrumOYfS6kjT4RzyCIa5VSt2LK2EVXtw1oseocQozWdn0dTXwxvKQwziO2qVVw90J
         gJrfJrxYeYwEHpBo5T/HV3l9ZVw1yH1pg0pBLVCOYt+5Iz31r5IUMHim84m+HGrlOU1n
         Rfhz3n0gCytf9riELEYCsChNMWDf95fpLJWxRqLnEtxTVcJ5qd6+93eI3t64jwrOowoR
         OYNZ0Y870wAyO6VhhxIipxdr1M37upGOMygBRpSR1CfGWkP82zYR9rU3h2dE+yDVp9lx
         Ajog==
X-Gm-Message-State: AOAM531jFCPAwiAM7yL4Uu7Uzih6aHhlSHPfl/Gf/f+fA2zASXitSkDg
        golYFXTF3SFmExYxSQBUnoILTuI+3PCw3g==
X-Google-Smtp-Source: ABdhPJwsMCD+rr0Zu/DkdIyJhSCIHw5l59HdZAx/CVcnrBSLhZKxaISiIO9df9RCO5JaS2QnqtDKTQ==
X-Received: by 2002:a6b:4e19:0:b0:645:d838:9218 with SMTP id c25-20020a6b4e19000000b00645d8389218mr17992920iob.69.1649861297464;
        Wed, 13 Apr 2022 07:48:17 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u15-20020a056e021a4f00b002c665afb993sm108381ilv.11.2022.04.13.07.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:48:16 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org, clew@codeaurora.org, deesin@codeaurora.org,
        swboyd@chromium.org, bjorn.andersson@linaro.org, elder@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH 2/3] dt-bindings: net: qcom,ipa: add optional qcom,qmp property
Date:   Wed, 13 Apr 2022 09:48:10 -0500
Message-Id: <20220413144811.522143-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220413144811.522143-1-elder@linaro.org>
References: <20220413144811.522143-1-elder@linaro.org>
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

commit ac62a0174d62ae0f4447c0c8cf35a8e5d793df56 upstream.

For some systems, the IPA driver must make a request to ensure that
its registers are retained across power collapse of the IPA hardware.
On such systems, we'll use the existence of the "qcom,qmp" property
as a signal that this request is required.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index b8a0b392b24ea..c52ec1ee7df6e 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -106,6 +106,10 @@ properties:
           - const: imem
           - const: config
 
+  qcom,qmp:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle to the AOSS side-channel message RAM
+
   qcom,smem-states:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     description: State bits used in by the AP to signal the modem.
@@ -221,6 +225,8 @@ examples:
                                      "imem",
                                      "config";
 
+                qcom,qmp = <&aoss_qmp>;
+
                 qcom,smem-states = <&ipa_smp2p_out 0>,
                                    <&ipa_smp2p_out 1>;
                 qcom,smem-state-names = "ipa-clock-enabled-valid",
-- 
2.32.0

