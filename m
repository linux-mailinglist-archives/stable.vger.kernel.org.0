Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765C65EF634
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 15:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiI2NPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 09:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiI2NPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 09:15:49 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9B110C795
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 06:15:43 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id j24so1503490lja.4
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 06:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=riQobyzwp2LcDSstTSNaZWBzD1tl8SlvgbLUTdoCvUU=;
        b=QjKSMj0mf4wSynBHfJ3wgQvGLExaw8bbk0gGS9hrSkwoSz9BCL1/5u5Z6dTymVMzWo
         WDYScgqAyO6xh+eshaQ2IDe7D496We6Rg6ZCsiaFYgZWRX84Rpvn8npHheqbhWNE8T/6
         7x+bY6bhT32sQ0jP6Yay/Bssx4DGdrYNt/GXdo9dSSbKERsewsCmHauXdR3P6aXSD541
         jBtykxrSXE+Gowg2LlqLs6IfYlhFOkycWk8HsMNOYukLg0NrZLHL52WqF4VLENwllfFp
         2jX2Z90j6hlKwI6DVYV2g8PlfO0qGi+4gH0uv7oC0rvehojOzwgo5SrcxUabTpyOikhW
         R0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=riQobyzwp2LcDSstTSNaZWBzD1tl8SlvgbLUTdoCvUU=;
        b=rShv2Hr9ajOw7AdsPblX9ecz32aAH8PW/4bksuWsKYWI7Bh6W/ikySAkBnwAbsP/C0
         IBzG8bw+cNlayjBQ/TwMGRnO7DExpcbYnHbStA5yOQ5MOC1i0hQ7smSkXZ7Uw/axp7t4
         aeYWVI9n1ldPfJ3uRfGmNPZvpaUiq/m6vcRblLvv6p2uYXRqb4bStRwHcIhj5pznv8n+
         ikRVgCVT+mDyekbMSC0pplwAL5tATGB5Ib20FEFagrcxJ84TgJUUaQbhQDJnKqyX6YnC
         XTOr5wjMdaJzR7eAeafKqB3lk/scM3peiumLN/azr6VuavH11YI6DCYdDuJim95QxG/k
         /ceA==
X-Gm-Message-State: ACrzQf3ZGkFIfWrxJy58RWcVAcbDg0uCerGJ3QuwkCqoHdQ/RGkNTrlV
        lRCEuxuiMLJCJgsuoReBlGaBrA==
X-Google-Smtp-Source: AMsMyM4Iupv6RRV4+DR7y2lHR/XVFBoo+AQoc5QCbh7W13suskqTvGGdHeCJAykX/uTzrpYO6+YJiQ==
X-Received: by 2002:a05:651c:1546:b0:26d:9459:1a69 with SMTP id y6-20020a05651c154600b0026d94591a69mr1277613ljp.209.1664457341196;
        Thu, 29 Sep 2022 06:15:41 -0700 (PDT)
Received: from krzk-bin.. (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id r1-20020ac25a41000000b00499fe9ce5f2sm783555lfn.175.2022.09.29.06.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 06:15:40 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] ASoC: wcd-mbhc-v2: Revert "ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get()"
Date:   Thu, 29 Sep 2022 15:15:28 +0200
Message-Id: <20220929131528.217502-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit ddea4bbf287b6028eaa15a185d0693856956ecf2 ("ASoC:
wcd-mbhc-v2: use pm_runtime_resume_and_get()"), because it introduced
double runtime PM put if pm_runtime_get_sync() returns -EACCES:

  wcd934x-codec wcd934x-codec.3.auto: WCD934X Minor:0x1 Version:0x401
  wcd934x-codec wcd934x-codec.3.auto: Runtime PM usage count underflow!

The commit claimed no changes in functionality except dropping the
reference on -EACCESS.  This is exactly the change introducing bug
because function calls unconditionally pm_runtime_put_autosuspend() at
the end.

Cc: Bard Liao <yung-chuan.liao@linux.intel.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Cezary Rojewski <cezary.rojewski@intel.com>
Cc: <stable@vger.kernel.org>
Fixes: ddea4bbf287b ("ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 sound/soc/codecs/wcd-mbhc-v2.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wcd-mbhc-v2.c b/sound/soc/codecs/wcd-mbhc-v2.c
index b16a18dbfe7a..1911750f7445 100644
--- a/sound/soc/codecs/wcd-mbhc-v2.c
+++ b/sound/soc/codecs/wcd-mbhc-v2.c
@@ -714,11 +714,12 @@ static int wcd_mbhc_initialise(struct wcd_mbhc *mbhc)
 	struct snd_soc_component *component = mbhc->component;
 	int ret;
 
-	ret = pm_runtime_resume_and_get(component->dev);
+	ret = pm_runtime_get_sync(component->dev);
 	if (ret < 0 && ret != -EACCES) {
 		dev_err_ratelimited(component->dev,
-				    "pm_runtime_resume_and_get failed in %s, ret %d\n",
+				    "pm_runtime_get_sync failed in %s, ret %d\n",
 				    __func__, ret);
+		pm_runtime_put_noidle(component->dev);
 		return ret;
 	}
 
@@ -1096,11 +1097,12 @@ static void wcd_correct_swch_plug(struct work_struct *work)
 	mbhc = container_of(work, struct wcd_mbhc, correct_plug_swch);
 	component = mbhc->component;
 
-	ret = pm_runtime_resume_and_get(component->dev);
+	ret = pm_runtime_get_sync(component->dev);
 	if (ret < 0 && ret != -EACCES) {
 		dev_err_ratelimited(component->dev,
-				    "pm_runtime_resume_and_get failed in %s, ret %d\n",
+				    "pm_runtime_get_sync failed in %s, ret %d\n",
 				    __func__, ret);
+		pm_runtime_put_noidle(component->dev);
 		return;
 	}
 	micbias_mv = wcd_mbhc_get_micbias(mbhc);
-- 
2.34.1

