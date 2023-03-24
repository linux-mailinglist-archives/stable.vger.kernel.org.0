Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDFE6C82EE
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 18:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjCXRKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 13:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjCXRKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 13:10:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDFE20A36
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 10:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679677769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JLRKnXRPip+ks27gdmBMUhtEnFO7L9UtH6SSkGcCZo0=;
        b=OI1S2Uf+E1Lx8x1xDXlrYC6VaZJUKf1Myzcq1JKMVeHE68N1rcwtZMMijpKybvZQQYbUcg
        A1kEEnQA43LAFGldvQww0V9WuFyE7Rwl+venHaxUTFrnCson0txswBe6E3X9ZtxEao+89F
        eUyMQm+Rl7j+PRvbsxpVb/TbEA5QPWg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-wHa0ylXkP2qYjzEfwl2Fug-1; Fri, 24 Mar 2023 13:09:28 -0400
X-MC-Unique: wHa0ylXkP2qYjzEfwl2Fug-1
Received: by mail-qt1-f199.google.com with SMTP id i24-20020ac84f58000000b003bfe3358691so1374704qtw.21
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 10:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679677768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JLRKnXRPip+ks27gdmBMUhtEnFO7L9UtH6SSkGcCZo0=;
        b=ZUK5O0upuJKC+n6nuLBOn6khhcMGlBTATvYJdHZ0b1FtCUPB9A1M5P3FsYta0/HICq
         7PwACLtOnqgQ5SQnyNvZq3XP0X94EtBfSNjZsY8TXC8GfZaE+I1SIchbT2Xb1ubuaafP
         5clfRYRxaiZpO5shT6b+z8jAt0QkEq6Is2ELd84RpVVFezHEfCvIzLQDgE43L148juYi
         YXqIU1RmfmyEEB6uLbpQzyl8w7l1jNixF3HxMQC0dT3ouQjPmzTllUlxku33MKHV1yMn
         LI01biRwplNUF785OE0QQFfaETpgz2f2WRmdAstbM+8cVWM/86Ij4zDVNcjN6fVmIwjy
         Oatg==
X-Gm-Message-State: AAQBX9eWcH/Z/4OStXtuFAf4Jhc3Zqz0HwYcEbG2rQkHJ5yyJ+AbquVZ
        bptgGI8KaW20QG0yuKIV2wRA203IVL/0yOEnsicNMMc5EmfKJxwktxiLCO84ryftsz68/pvHppc
        IMm64sGegX8Pvlv+g
X-Received: by 2002:a05:622a:352:b0:3e4:d90a:b12a with SMTP id r18-20020a05622a035200b003e4d90ab12amr1803631qtw.17.1679677767863;
        Fri, 24 Mar 2023 10:09:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350apy3oW7a9FJs0e8hOcJ3R4VeI8/w3JZazN2ebmIBP53MZF2bGhguV/L5X6EHjjOcdVuhZaIQ==
X-Received: by 2002:a05:622a:352:b0:3e4:d90a:b12a with SMTP id r18-20020a05622a035200b003e4d90ab12amr1803594qtw.17.1679677767627;
        Fri, 24 Mar 2023 10:09:27 -0700 (PDT)
Received: from p1.montleon.net (066-026-073-226.inf.spectrum.com. [66.26.73.226])
        by smtp.gmail.com with ESMTPSA id de21-20020a05620a371500b007422fd3009esm14460324qkb.20.2023.03.24.10.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 10:09:27 -0700 (PDT)
From:   Jason Montleon <jmontleo@redhat.com>
To:     alsa-devel@alsa-project.org, regressions@lists.linux.dev,
        yung-chuan.liao@linux.intel.com, broonie@kernel.org,
        tiwai@suse.com, bagasdotme@gmail.com,
        pierre-louis.bossart@linux.intel.com
Cc:     Jason Montleon <jmontleo@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ASoC: hdac_hdmi: use set_stream() instead of set_tdm_slots()
Date:   Fri, 24 Mar 2023 13:07:11 -0400
Message-Id: <20230324170711.2526-1-jmontleo@redhat.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hdac_hdmi was not updated to use set_stream() instead of set_tdm_slots()
in the original commit so HDMI no longer produces audio.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/regressions/CAJD_bPKQdtaExvVEKxhQ47G-ZXDA=k+gzhMJRHLBe=mysPnuKA@mail.gmail.com/
Fixes: 636110411ca7 ("ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio")
Signed-off-by: Jason Montleon <jmontleo@redhat.com>
---
 sound/soc/codecs/hdac_hdmi.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index ed4f7cdda04f..8b6b76029694 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -436,23 +436,28 @@ static int hdac_hdmi_setup_audio_infoframe(struct hdac_device *hdev,
 	return 0;
 }
 
-static int hdac_hdmi_set_tdm_slot(struct snd_soc_dai *dai,
-		unsigned int tx_mask, unsigned int rx_mask,
-		int slots, int slot_width)
+static int hdac_hdmi_set_stream(struct snd_soc_dai *dai,
+				void *stream, int direction)
 {
 	struct hdac_hdmi_priv *hdmi = snd_soc_dai_get_drvdata(dai);
 	struct hdac_device *hdev = hdmi->hdev;
 	struct hdac_hdmi_dai_port_map *dai_map;
 	struct hdac_hdmi_pcm *pcm;
+	struct hdac_stream *hstream;
 
-	dev_dbg(&hdev->dev, "%s: strm_tag: %d\n", __func__, tx_mask);
+	if (!stream)
+		return -EINVAL;
+
+	hstream = (struct hdac_stream *)stream;
+
+	dev_dbg(&hdev->dev, "%s: strm_tag: %d\n", __func__, hstream->stream_tag);
 
 	dai_map = &hdmi->dai_map[dai->id];
 
 	pcm = hdac_hdmi_get_pcm_from_cvt(hdmi, dai_map->cvt);
 
 	if (pcm)
-		pcm->stream_tag = (tx_mask << 4);
+		pcm->stream_tag = (hstream->stream_tag << 4);
 
 	return 0;
 }
@@ -1544,7 +1549,7 @@ static const struct snd_soc_dai_ops hdmi_dai_ops = {
 	.startup = hdac_hdmi_pcm_open,
 	.shutdown = hdac_hdmi_pcm_close,
 	.hw_params = hdac_hdmi_set_hw_params,
-	.set_tdm_slot = hdac_hdmi_set_tdm_slot,
+	.set_stream = hdac_hdmi_set_stream,
 };
 
 /*
-- 
2.40.0

