Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91562617FEA
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 15:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiKCOrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 10:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiKCOrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 10:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE443186F3
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 07:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667486786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YJXibA0h5EKEv6IPvm5uKuXU6CZAaOV8NDSOv2jfpHY=;
        b=RJMBy3u1odo84ezBDyTqEXocvui6I0+zcvugIed9vLmaXMVarC4ph6I+/7jFEkxWXHLNI5
        tP4OIXMy8ZfzcZ/ou0qQv98BbCkHj7RyEeRFcv38IrAgYrVFBS/eUnH8CGm+UTmZiuJsKf
        gx11FbCRTv9zN+xxZ7sdOcns0aDnIJc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-159-5323iRszMjOUJG3RZSiycg-1; Thu, 03 Nov 2022 10:46:25 -0400
X-MC-Unique: 5323iRszMjOUJG3RZSiycg-1
Received: by mail-qt1-f197.google.com with SMTP id cm12-20020a05622a250c00b003a521f66e8eso1952590qtb.17
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 07:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJXibA0h5EKEv6IPvm5uKuXU6CZAaOV8NDSOv2jfpHY=;
        b=XaGmRWUpEv4AzxiMfTAlvgc00AOddJzoS4G1fvLFibC4tR8Domi6TbT7x71s7bnct/
         ee86angm1f0PqoE3FvaA71ip12hSIUHXrWmgGg0/MXvst3FUyXqYtaU4JCdZe1VwPPzc
         xOZKoIGO9ddFDbsIt3bNBi4PVXwbMMu1YZECbQKQTV+XqO7AQ1i1Y2tnrUuNJpRI0P0k
         nWBfXxqET2h/PDfPezjcFSmab4tGqDom28m+lZ/sXHga0UAvDpM0pKJmfSiAUuaNHewI
         o9uV/In4OKmflpE2FT017XptgQ4hHgLk4pmHCJMQF/7bjZNNUgI74myESwuWxV5HJHxR
         6NJw==
X-Gm-Message-State: ACrzQf1tB9Hbj/X+wTCJ8Fx+zb37a0om0J4QYuX8h+X3c861p4orDnNR
        BUNmZbbnPORyFtHXSvpTtd8urc5U6uuygj65myKeLd8uHtCRWG2bsPOvSNfxAm080GT8lgoeCn8
        kpzjfP4bL0YjAXeRO
X-Received: by 2002:ae9:ec07:0:b0:6cf:4190:246 with SMTP id h7-20020ae9ec07000000b006cf41900246mr21110399qkg.760.1667486782960;
        Thu, 03 Nov 2022 07:46:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4bk/lucYFrTehGoPTfO4GaH3jiwxkOh9YtFwCTaUkFUDWKuoNdHR7lGGIqfCeXvIoqPaCE1A==
X-Received: by 2002:ae9:ec07:0:b0:6cf:4190:246 with SMTP id h7-20020ae9ec07000000b006cf41900246mr21110377qkg.760.1667486782760;
        Thu, 03 Nov 2022 07:46:22 -0700 (PDT)
Received: from p1.montleon.intra (066-026-073-226.inf.spectrum.com. [66.26.73.226])
        by smtp.gmail.com with ESMTPSA id h15-20020a05620a244f00b006fa468342a3sm873175qkn.108.2022.11.03.07.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 07:46:22 -0700 (PDT)
From:   Jason Montleon <jmontleo@redhat.com>
To:     pierre-louis.bossart@linux.intel.com
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org,
        cezary.rojewski@intel.com, ckeepax@opensource.cirrus.com,
        jmontleo@redhat.com, oder_chiou@realtek.com,
        regressions@lists.linux.dev, tiwai@suse.com, stable@vger.kernel.org
Subject: [PATCH v4 2/2] ASoC: rt5677: fix legacy dai naming
Date:   Thu,  3 Nov 2022 10:46:12 -0400
Message-Id: <20221103144612.4431-2-jmontleo@redhat.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221103144612.4431-1-jmontleo@redhat.com>
References: <20221103144612.4431-1-jmontleo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Starting with 6.0-rc1 the CPU DAI is not registered and the sound
card is unavailable. Adding legacy_dai_naming causes it to function
properly again.

Fixes: fc34ece41f71 ("ASoC: Refactor non_legacy_dai_naming flag")
Signed-off-by: Jason Montleon <jmontleo@redhat.com>
---
 sound/soc/codecs/rt5677-spi.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/rt5677-spi.c b/sound/soc/codecs/rt5677-spi.c
index 8f3993a4c1cc..d25703dd7499 100644
--- a/sound/soc/codecs/rt5677-spi.c
+++ b/sound/soc/codecs/rt5677-spi.c
@@ -396,15 +396,16 @@ static int rt5677_spi_pcm_probe(struct snd_soc_component *component)
 }
 
 static const struct snd_soc_component_driver rt5677_spi_dai_component = {
-	.name		= DRV_NAME,
-	.probe		= rt5677_spi_pcm_probe,
-	.open		= rt5677_spi_pcm_open,
-	.close		= rt5677_spi_pcm_close,
-	.hw_params	= rt5677_spi_hw_params,
-	.hw_free	= rt5677_spi_hw_free,
-	.prepare	= rt5677_spi_prepare,
-	.pointer	= rt5677_spi_pcm_pointer,
-	.pcm_construct	= rt5677_spi_pcm_new,
+	.name			= DRV_NAME,
+	.probe			= rt5677_spi_pcm_probe,
+	.open			= rt5677_spi_pcm_open,
+	.close			= rt5677_spi_pcm_close,
+	.hw_params		= rt5677_spi_hw_params,
+	.hw_free		= rt5677_spi_hw_free,
+	.prepare		= rt5677_spi_prepare,
+	.pointer		= rt5677_spi_pcm_pointer,
+	.pcm_construct		= rt5677_spi_pcm_new,
+	.legacy_dai_naming	= 1,
 };
 
 /* Select a suitable transfer command for the next transfer to ensure
-- 
2.37.3

