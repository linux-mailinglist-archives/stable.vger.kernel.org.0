Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB356D23BD
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjCaPNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbjCaPMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 11:12:54 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0786944B2
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 08:12:53 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id a44so4752744ljr.10
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 08:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680275571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xbv/I5MVp1iCuv0Iib/fBfKCalVBVtTZIuwCTcTsAn0=;
        b=jESewajAZxLET9y1IsIUBduXwUHuZrs339Hotbf7wo/xB1XRHpBQODD8iH+pzzykkc
         KKNkcxvaJNX8dc7lHH6JoZ1voiP+Jo2JnLbHsTyFS9/rJoHFTAtiIW4JjxjrfaeDi14P
         k8PyPAE5JejpoUd9NBAfvK9Qm09OoyjVsbt6EfQod4O93R9dMp8OQhUelUADmzFePYSb
         ZPTg+kSmwDGHrJ6yHKp2lQ9qqQNtcdBBH0izdDf3RrzXap78L3+xcu2Nac7jwJbhYcws
         wPhalfiALy13mHiKFVU30cy6PpZvzd0KQ0LICgoSjB+UBUIUVLidvupqI4mbfojMlW5s
         /A/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680275571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xbv/I5MVp1iCuv0Iib/fBfKCalVBVtTZIuwCTcTsAn0=;
        b=AuUZ0fBJ3R+fpevzR6HYlkzCXXcup/mN3sb+mqKQ9wiV8llhQGHiBPa/kzUgkxR1FG
         7pLAEGUmyinEVx/8N0OWkRufWXPn8uB4BFqpX4ku2N+DJ7EAp+YHLoUvtTy0mavfqemV
         6HWuUDms1JfV66q039zo4BEULzNZBABQobM5svmIdvY37ZmaPJ4DjczZ2QSWDqbUypyg
         ChC1jLBbmRnUOs3xSCt/gukwClHqCF19Qyqtceb7Yxx2Jgbrdiqp8cQ0sPGmISIyOSAy
         lSxQiA+002FnObJIO6Gbz/47tcdIG5gygoqlodxCsYKoNTUp73+bmFCVlgDYP9ZlIJa1
         WHkQ==
X-Gm-Message-State: AAQBX9f3jeynxOz+Ihs33feJdEF7OOUMbmzrTCu3j1VrOBhPGV6cmJP0
        WbqKsftEEcxFDtne122+tkUvzw==
X-Google-Smtp-Source: AKy350ZEuDaDtxdN2I7aAkhVEhAorj8u0MpeoZ3VKbgSZCRA0FEvfUSZGqrWCyDnyZeg3esd3sCgkQ==
X-Received: by 2002:a2e:9093:0:b0:298:b045:af96 with SMTP id l19-20020a2e9093000000b00298b045af96mr7952630ljg.9.1680275571213;
        Fri, 31 Mar 2023 08:12:51 -0700 (PDT)
Received: from umbar.unikie.fi ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id a8-20020a2e9808000000b002934b5d6a61sm395709ljj.121.2023.03.31.08.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 08:12:50 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH RESEND v2 1/2] phy: qcom-qmp-pcie: sc8180x PCIe PHY has 2 lanes
Date:   Fri, 31 Mar 2023 18:12:49 +0300
Message-Id: <20230331151250.4049-1-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All PCIe PHYs on sc8180x platform have 2 lanes, so change the number of
lanes to 2.

Fixes: f839f14e24f2 ("phy: qcom-qmp: Add sc8180x PCIe support")
Cc: stable@vger.kernel.org # 5.15
Sgned-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index b1e81530d551..f378c1ebefd7 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -2331,7 +2331,7 @@ static const struct qmp_phy_cfg msm8998_pciephy_cfg = {
 };
 
 static const struct qmp_phy_cfg sc8180x_pciephy_cfg = {
-	.lanes			= 1,
+	.lanes			= 2,
 
 	.tbls = {
 		.serdes		= sc8180x_qmp_pcie_serdes_tbl,
-- 
2.30.2

