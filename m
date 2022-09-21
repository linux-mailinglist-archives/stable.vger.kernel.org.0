Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437405C0052
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 16:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiIUOyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 10:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiIUOyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 10:54:06 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3646D5EDD5
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 07:54:05 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i26so9596641lfp.11
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 07:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=3xh6qSfnk72aIq5PPq1PboXWTaapoBlxdPaCgFLtKR4=;
        b=lgpK/4OuqSfkaiYhGhtq2E2966wSCB2Sl2SOz4WjFcJb/C/JO5oJjSqfOEpeVKbt80
         WMtMs7hpEeXbSI2tLBpX9gEofcY7LnfnaHatInklDKx0rzBRb8U2Lh9G6s42p5b6XlXz
         sh4HkV+KPh1sJNaVQhH5/YZypLKXpnyEgqEVYoLlaTHDTZG48XyUKLcxdlhBO13Ljpuo
         gt4WXXyALNuQzPooN06izrjfYigYAhusPXz6Ro2cLW2vYRqYrBmP9ReGcDEQnqeez05U
         Lt4MpKtRCB2laihvVk1I4z9xhVeh96q5jh67AOkyjFGbqB/6o8m6BVQDq2O8+juUJbR4
         rqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3xh6qSfnk72aIq5PPq1PboXWTaapoBlxdPaCgFLtKR4=;
        b=avnWDve2FDoO0UB6/OKtCpfVCFbRtMIqy951LTZZUNU3GBeXl2maUhhplOydLjoaIq
         nhV2I3RaU0zL3yRpO6Pd4RMt9B5MlAZryP7LbEZNYCi30dy49Tov3+5/kdIzoY3rF/BJ
         Ow2sB5JekiUGVv1jKuFig36DDF5QKBqImDveuuX1sEuEuFfbYb5MELOcVFt/29O5ZJzI
         kViRBm19EwFog45Tt3mbpeTzP4LhDgn9JVs3EjE71jGbKbTOhod49yqNjAe4c6T+L9ev
         BEXQCrsJBOpVJSUoU2LX6CpyOiNZKjw0k3AixHxDyNV+Uz6mTEcfr/n0yCIJrip0mNAD
         FRjg==
X-Gm-Message-State: ACrzQf3rtXJAztN170+c4JL6MT1FxebhA4IFaodDdGyFk4MfMn4SiRq0
        TfKyB2gmC9f3NlKNCC4xsCMPJQ==
X-Google-Smtp-Source: AMsMyM4iJNIrY+YOXPembYGou4Yel/GzNQeJh3rqW/SiaUkEjZsRJ/PsN9t8Fdy7GfD/l5rRB6FiiA==
X-Received: by 2002:ac2:53a1:0:b0:49f:6086:4868 with SMTP id j1-20020ac253a1000000b0049f60864868mr8245124lfh.518.1663772043369;
        Wed, 21 Sep 2022 07:54:03 -0700 (PDT)
Received: from krzk-bin.. (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id c24-20020a056512075800b00494a1e875a9sm461981lfs.191.2022.09.21.07.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 07:54:02 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Vinod Koul <vkoul@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ASoC: wcd934x: fix order of Slimbus unprepare/disable
Date:   Wed, 21 Sep 2022 16:53:54 +0200
Message-Id: <20220921145354.1683791-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
References: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
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

Slimbus streams are first prepared and then enabled, so the cleanup path
should reverse it.  The unprepare sets stream->num_ports to 0 and frees
the stream->ports.  Calling disable after unprepare was not really
effective (channels was not deactivated) and could lead to further
issues due to making transfers on unprepared stream.

Fixes: a61f3b4f476e ("ASoC: wcd934x: add support to wcd9340/wcd9341 codec")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 sound/soc/codecs/wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index f56907d0942d..28175c746b9a 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -1913,8 +1913,8 @@ static int wcd934x_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		slim_stream_unprepare(dai_data->sruntime);
 		slim_stream_disable(dai_data->sruntime);
+		slim_stream_unprepare(dai_data->sruntime);
 		break;
 	default:
 		break;
-- 
2.34.1

