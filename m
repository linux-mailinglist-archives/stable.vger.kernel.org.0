Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B95617FE9
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 15:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiKCOrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 10:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiKCOrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 10:47:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17EE5FBF
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 07:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667486781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CJkpFb1DAm+sVktUmkKDmWhR4Gb2Q3CNwmufg7Xs7+c=;
        b=QtkBQHxqU6byfCXj4rd/DhGEQYbmK/7W8gK5yB0H8H6NJ462ecLwduqgkvmHxc5Z5r6dzT
        8e7qyfCh0ziZTQNKKeOq1xnzaB63qU+RvsYmHEFv/hQNmcYKVkynhzYwR/rwSqa3ggc6hr
        2GAxUUtKfe7YUR7DZ3gJFOnoCdPUcQ0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-43-ZjIhiWVFNi6qK6JaE7emAQ-1; Thu, 03 Nov 2022 10:46:20 -0400
X-MC-Unique: ZjIhiWVFNi6qK6JaE7emAQ-1
Received: by mail-qt1-f200.google.com with SMTP id cj6-20020a05622a258600b003a519d02f59so1974033qtb.5
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 07:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CJkpFb1DAm+sVktUmkKDmWhR4Gb2Q3CNwmufg7Xs7+c=;
        b=qyrR6vXaUxQ9ZBtLX4IZx+NjkdKvf5Uja5qID8f8zIDB20g/LLhrbsdE9AknCumHG8
         UBsj+l8fm0MJEmvj50Mq1DNH09o9cr6stVIBNzoJUWatBGgFzQmyHWTeVNVndhV0vwEB
         M/hqLJzTr1cdjSKgx/YMMXrSwkO9zJG5lKQmDS7iEs1RfpUVWys3UvzLdLabuz4Pmhcr
         ob0SMrrR/Q2X7fQI1GwrzhZ1hPhYMGXJc7FJlj4ol0UdHaDUXsc0nfr/9kIS1tgqXFCm
         Qc4MhqgnWR8095tvTJh4sYXL53ua3OFAwamP9vFusGrA43C02WOZ1FOhpRWzqNhv3DNe
         29ng==
X-Gm-Message-State: ACrzQf1GoMN2ZRI1OZUMi+Jp9ujnDb/noQ/BgEFvlSEL0AIUsBpDA2JR
        cRW0tICEBZJAvQtfYKkR4xL8Vh0HaY74oqKU3XPKGzi0KPUBnt+dbjE1RD50wvEdZl1KAUZ/DPg
        0h0unYX/W7j/gv6FB
X-Received: by 2002:a05:620a:244d:b0:6ee:7a23:dfa6 with SMTP id h13-20020a05620a244d00b006ee7a23dfa6mr23135199qkn.463.1667486780393;
        Thu, 03 Nov 2022 07:46:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM44Qf1+rRdA3GgSs9RSbnt8FRAE99HpxH7zhBi9j+kvh16bWVVObc8Hqnl0MvXVtoxAOKZg8w==
X-Received: by 2002:a05:620a:244d:b0:6ee:7a23:dfa6 with SMTP id h13-20020a05620a244d00b006ee7a23dfa6mr23135175qkn.463.1667486780123;
        Thu, 03 Nov 2022 07:46:20 -0700 (PDT)
Received: from p1.montleon.intra (066-026-073-226.inf.spectrum.com. [66.26.73.226])
        by smtp.gmail.com with ESMTPSA id h15-20020a05620a244f00b006fa468342a3sm873175qkn.108.2022.11.03.07.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 07:46:19 -0700 (PDT)
From:   Jason Montleon <jmontleo@redhat.com>
To:     pierre-louis.bossart@linux.intel.com
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org,
        cezary.rojewski@intel.com, ckeepax@opensource.cirrus.com,
        jmontleo@redhat.com, oder_chiou@realtek.com,
        regressions@lists.linux.dev, tiwai@suse.com, stable@vger.kernel.org
Subject: [PATCH v4 1/2] ASoC: rt5514: fix legacy dai naming
Date:   Thu,  3 Nov 2022 10:46:11 -0400
Message-Id: <20221103144612.4431-1-jmontleo@redhat.com>
X-Mailer: git-send-email 2.37.3
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

Starting with 6.0-rc1 these messages are logged and the sound card
is unavailable. Adding legacy_dai_naming to the rt5514-spi causes
it to function properly again.

[   16.928454] kbl_r5514_5663_max kbl_r5514_5663_max: ASoC: CPU DAI
spi-PRP0001:00 not registered
[   16.928561] platform kbl_r5514_5663_max: deferred probe pending

Fixes: fc34ece41f71 ("ASoC: Refactor non_legacy_dai_naming flag")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216641
Signed-off-by: Jason Montleon <jmontleo@redhat.com>
---
 sound/soc/codecs/rt5514-spi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/rt5514-spi.c b/sound/soc/codecs/rt5514-spi.c
index 1a25a3787935..362663abcb89 100644
--- a/sound/soc/codecs/rt5514-spi.c
+++ b/sound/soc/codecs/rt5514-spi.c
@@ -298,13 +298,14 @@ static int rt5514_spi_pcm_new(struct snd_soc_component *component,
 }
 
 static const struct snd_soc_component_driver rt5514_spi_component = {
-	.name		= DRV_NAME,
-	.probe		= rt5514_spi_pcm_probe,
-	.open		= rt5514_spi_pcm_open,
-	.hw_params	= rt5514_spi_hw_params,
-	.hw_free	= rt5514_spi_hw_free,
-	.pointer	= rt5514_spi_pcm_pointer,
-	.pcm_construct	= rt5514_spi_pcm_new,
+	.name			= DRV_NAME,
+	.probe			= rt5514_spi_pcm_probe,
+	.open			= rt5514_spi_pcm_open,
+	.hw_params		= rt5514_spi_hw_params,
+	.hw_free		= rt5514_spi_hw_free,
+	.pointer		= rt5514_spi_pcm_pointer,
+	.pcm_construct		= rt5514_spi_pcm_new,
+	.legacy_dai_naming	= 1,
 };
 
 /**
-- 
2.37.3

