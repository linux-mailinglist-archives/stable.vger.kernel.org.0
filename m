Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087D3651207
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 19:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiLSSdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 13:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiLSSc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 13:32:26 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DBB13E0B
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 10:31:34 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id x2so9827951plb.13
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 10:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0mC3YHxzlEQlwMPao/Y7ASve0hKwhscYa/RkKUoFYA=;
        b=XP3AwAH3vWxz0xfNNFiGJ5EgonMs84vx5Gf0ya1zoxdRXLS4mgG7GJljlIBSp3sWSp
         pE/P+777utad613pX0v1LpwSeiQaQvT4BLznyztZI4BRxJ5UCdxvQf89huY3c6odg0BZ
         beom1cAixCxe2nouy47FZellniD8Vj/wWCeqrhrqnkFR5Qq6FVs9El10bowukBUYxbJ0
         xPlgcxMmxk4q03q9VnvSF3FMGZEKbhc1dlcU1cDCt9J7ry2zH1y19dccMivVxxN4upEw
         VJcf3SeWyVV/qqV6sPnsX4Li7PS8XBkntHkOC/PKcKZHZEyaZWDgxxizO3meAyubPNKE
         VQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0mC3YHxzlEQlwMPao/Y7ASve0hKwhscYa/RkKUoFYA=;
        b=GSm4lGf2Atc8ybVs3rZ9WlC/JX8K+jq/ObiguhQCdwvfw6usuJBhjyKlcas/BWjsOk
         PYF2gk8Ukyv4j5s/0MyRy64Rfn/ZGcG1i/3w4PD9sHEK5l6ZXYwoGwqViU7pZ1LNIVFo
         Olt/w4SgG7fabd2hiRCdViOf9Pf8DD8eyifJPTan3w0yHA4cS9cMgS26XNr+ZkIz81vQ
         I+8TdO7Nj555CkDxP70dDc7GZb+sC05NieHVmVuKwHd5dHrIE34N/x8r3Z8Eff11UkhJ
         ZRNOzs9PQ18OQnV3ll7AZTH3Z42iJ/dn7OwsD0G6sxC4FguTw4Wqcqx3IibtdS6B79VD
         g/mA==
X-Gm-Message-State: ANoB5pmMSrzOkk2TqUGZ+DxJBN+STrA9ucjAEIX/IYAh5KILB4yJ+WMe
        C2CE376OgR9+7+NmjKjNwDpf
X-Google-Smtp-Source: AA0mqf68ucZQ4pkSIP4B+LV1flkcOGQPj3b5PkGW/rCTTB9ay4fMMIaU9BVc6OCx2wDMonxlDiHDWg==
X-Received: by 2002:a17:903:251:b0:189:7891:574d with SMTP id j17-20020a170903025100b001897891574dmr50681181plh.47.1671474693614;
        Mon, 19 Dec 2022 10:31:33 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.17])
        by smtp.gmail.com with ESMTPSA id d2-20020a170903230200b00186e34524e3sm7480979plh.136.2022.12.19.10.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 10:31:32 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v3 12/15] EDAC/device: Make use of poll_msec value in edac_device_ctl_info struct
Date:   Mon, 19 Dec 2022 23:59:55 +0530
Message-Id: <20221219182958.476231-13-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221219182958.476231-1-manivannan.sadhasivam@linaro.org>
References: <20221219182958.476231-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The EDAC drivers may optionally pass the poll_msec value. Use that value if
available, else fall back to 1000ms.

Cc: <stable@vger.kernel.org> # 4.9
Fixes: e27e3dac6517 ("drivers/edac: add edac_device class")
Reported-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/edac/edac_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 19522c568aa5..19c3ab2a434e 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -447,7 +447,7 @@ int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
 		 * enable workq processing on this instance,
 		 * default = 1000 msec
 		 */
-		edac_device_workq_setup(edac_dev, 1000);
+		edac_device_workq_setup(edac_dev, edac_dev->poll_msec ? edac_dev->poll_msec : 1000);
 	} else {
 		edac_dev->op_state = OP_RUNNING_INTERRUPT;
 	}
-- 
2.25.1

