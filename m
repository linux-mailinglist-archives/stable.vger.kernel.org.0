Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7875A6B3BBF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 11:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCJKKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 05:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCJKKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 05:10:11 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49023943B7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 02:10:09 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g3so18419349eda.1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 02:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678443008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VES88RDu68rL5NDUHr3sXnSGJ9TXEfu2GH9TAuqlmkU=;
        b=Ozr1iPXoEGvcAHwAy9H9S8GCoun0lCmweQbD8YnbUqziy2u/98BqZPBfzPbRnLPABx
         nUWc5FrRdihvGHgCfjrqZPsD6V9xwGYOtcCbmoB+6DVL280iKMrB1gIdz0YBcOUR3OIN
         HSME51Il8c5yPqHjdS1detBGS/ZTEl9SWOkFovseOvMYGbvXGa7aiXgUEXWJujXap3Es
         70eqsFq6rsMnYTAy8/+vBxTFHEe/eDuueJgjnT3atKSChkJnq/t/GNZQK8W5z5sUNkgx
         82jtG7DdKnmVYLKXQGGxRUaQVEgKS+tkvwpLP7lCJ+ytuj+m8sbcvWc39sJJXMhASmKR
         svdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678443008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VES88RDu68rL5NDUHr3sXnSGJ9TXEfu2GH9TAuqlmkU=;
        b=07ZdXDj2koAveBvrJJcAZqj5Coz1X3D858fncqj+fRO1j2eGKhpvfCGOOD/tcHzARf
         FT5vzh1NpnSY2RJJwMvugrvwbF53ptNUeQZFoP/icG8bgbpi86OsW3OexxU3yXcY8vOG
         SnrbpgVqjMyfIPdHDS2D6tvqpQ0yx8dAlgM3dnfCry4X2uMqjwJVVaj6xlieftcH0q1O
         b3skGh72VWLu5Fh8NRhNR9zreUPDXQCDc86UqavvGkpYOm5vQpAzRVfwqPpvrP7lipA/
         Gxx9SVa1H+iF19LW/xZotkBv8+igmnpAPWyeuctwj0Di+spbO2pg+NwjnMHj9tIyTvYb
         xNOg==
X-Gm-Message-State: AO0yUKWaUyTIy704cTTa7PB7yLa9Z91OWbvOjZL6CA4UOxw5ItjTjCFZ
        tlDEyqqprSU4yR1AIPMAzTylJw==
X-Google-Smtp-Source: AK7set/S605bhmLAtsmVPrUq/mepr0q5FJC+/eV4WvNFS5d4216qWzvQbfEOofPJqPaTziJ7CzL1Bg==
X-Received: by 2002:a17:907:1b1e:b0:8b2:8876:2a11 with SMTP id mp30-20020a1709071b1e00b008b288762a11mr1368992ejc.28.1678443007804;
        Fri, 10 Mar 2023 02:10:07 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:2a59:841a:ebc:7974])
        by smtp.gmail.com with ESMTPSA id a20-20020a17090680d400b008c979c74732sm761350ejx.156.2023.03.10.02.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 02:10:07 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Venkata Prasad Potturu <quic_potturu@quicinc.com>,
        linux-arm-msm@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] ASoC: dt-bindings: qcom,lpass-rx-macro: correct minItems for clocks
Date:   Fri, 10 Mar 2023 11:09:37 +0100
Message-Id: <20230310100937.32485-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The RX macro codec comes on some platforms in two variants - ADSP
and ADSP bypassed - thus the clock-names varies from 3 to 5.  The clocks
must vary as well:

  sc7280-idp.dtb: codec@3200000: clocks: [[202, 8], [202, 7], [203]] is too short

Fixes: 852fda58d99a ("ASoC: qcom: dt-bindings: Update bindings for clocks in lpass digital codes")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml b/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml
index 79c6f8da1319..b0b95689d78b 100644
--- a/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml
+++ b/Documentation/devicetree/bindings/sound/qcom,lpass-rx-macro.yaml
@@ -30,6 +30,7 @@ properties:
     const: 0
 
   clocks:
+    minItems: 3
     maxItems: 5
 
   clock-names:
-- 
2.34.1

