Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAA06D7F7B
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 16:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbjDEOaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 10:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238653AbjDEO3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 10:29:52 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58D661BF
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 07:29:31 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id eg48so141465286edb.13
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 07:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680704970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Bjq5zDxQyCkbnAUsg6zX1gfO+rxaxBPGXjBwDghiQE=;
        b=H4hC3GDaNY44R/lZfk9Ppbm04ZMF5VnKXQo5sU2rs19jEBD1Dyv2ix/zvRT4NLrrsa
         gKUAAoBHb/y2VkC+zquiud4T86UODXw2uIb0xpw9Zk5c5yoHuYbA+VWMH4M3c2Wf27MV
         dlTlbX3nwRy1R8cC+JsuXrmFGrA5+GU5cZejIqv443Ffl6j16h+DEzwiUl9yDIjHpruh
         bDgn2edhzmivIj6V01L+h6g1vaanKpJn4K1aGSYr11MWd2swUep5dbnfXf+vHBsrAuFe
         7GJ8vXWNrep9nDx2niSXc2l7fLZJetgFmGBMctRaVsGSPjanVvi6f9NItyO/YtymZBXj
         dFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680704970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Bjq5zDxQyCkbnAUsg6zX1gfO+rxaxBPGXjBwDghiQE=;
        b=EHAox64ESfrx8oUskNW/UIm19QuxktT7LrnsHVvitAdfDBEhKY64Odh59bvdGUwYyP
         Fahr9fkPKWyFVRUFb9pNppAmT7qBy724AzUw6gfIsI8m/6mxVx+/yz5O6gcPoNOdtMb6
         M2bxAo6avJlHG8rVnYpikGNZMOl05hPC9ugNlc1X4LnWLqZEbwT7z9LecRO9nnSC2jxG
         UGjHzkCUIn15I8FslT9AUU9UfWQn6CBMzyPKyF4/u1lg5In4dta0K20p6Hh+lFnTdG6n
         fySMGctDat2EMyLvKUJJkh53gIYKionkFU0MhqH29NKiJlWnRHWG5naf+9aTzbhSzpCe
         baTQ==
X-Gm-Message-State: AAQBX9e0BImHAzwj3Y3QCtnmnLX7mpFV4gOrf4qoC8HcmJnZwHys4Mvi
        ME/nxVRf+qEZOSFyO6qxk2s7KQ==
X-Google-Smtp-Source: AKy350bdNfN0ijKa36g6weBhlJu2OQB7Xk7REHbQEoBD/66q2jMFOaL9TSIUlG21GWdW2wFWZjG6Qw==
X-Received: by 2002:a17:907:a413:b0:91d:9745:407a with SMTP id sg19-20020a170907a41300b0091d9745407amr3450196ejc.14.1680704969847;
        Wed, 05 Apr 2023 07:29:29 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:3f:6b2:54cd:498e])
        by smtp.gmail.com with ESMTPSA id h13-20020a1709063c0d00b008b176df2899sm7454367ejg.160.2023.04.05.07.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 07:29:29 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-arm-msm@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org, Patrick Lai <quic_plai@quicinc.com>
Subject: [PATCH] soundwire: qcom: Fix enumeration of second device on the bus
Date:   Wed,  5 Apr 2023 16:29:26 +0200
Message-Id: <20230405142926.842173-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Some Soundwire buses (like &swr0 on Qualcomm HDK8450) have two devices,
which can be brought from powerdown state one after another.  We need to
keep enumerating them on each slave attached interrupt, otherwise only
first will appear.

Cc: <stable@vger.kernel.org>
Fixes: a6e6581942ca ("soundwire: qcom: add auto enumeration support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Cc: Patrick Lai <quic_plai@quicinc.com>
---
 drivers/soundwire/qcom.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index c296e0bf897b..1e5077d91f59 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -587,14 +587,9 @@ static irqreturn_t qcom_swrm_irq_handler(int irq, void *dev_id)
 			case SWRM_INTERRUPT_STATUS_CHANGE_ENUM_SLAVE_STATUS:
 				dev_dbg_ratelimited(swrm->dev, "SWR new slave attached\n");
 				swrm->reg_read(swrm, SWRM_MCP_SLV_STATUS, &slave_status);
-				if (swrm->slave_status == slave_status) {
-					dev_dbg(swrm->dev, "Slave status not changed %x\n",
-						slave_status);
-				} else {
-					qcom_swrm_get_device_status(swrm);
-					qcom_swrm_enumerate(&swrm->bus);
-					sdw_handle_slave_status(&swrm->bus, swrm->status);
-				}
+				qcom_swrm_get_device_status(swrm);
+				qcom_swrm_enumerate(&swrm->bus);
+				sdw_handle_slave_status(&swrm->bus, swrm->status);
 				break;
 			case SWRM_INTERRUPT_STATUS_MASTER_CLASH_DET:
 				dev_err_ratelimited(swrm->dev,
-- 
2.34.1

