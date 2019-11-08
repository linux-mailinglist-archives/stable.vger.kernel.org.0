Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60645F55B8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389660AbfKHTEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:04:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732428AbfKHTEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:04:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E282067B;
        Fri,  8 Nov 2019 19:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239854;
        bh=zy4tbe8pw1MO7Bj4qek8GqStWBL+RTXZSE5eYlxDNkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCnaHklPiBqmaud6hLe+Bs1FpvuzA17jx7xiPY6IbzFizk61HW6Snnep3sMcXNtcq
         jd8w9AETkzRy8L784nLbvvW+S11tFl18ZUBnHgsKFQRra479J2JPCS4Xfh31+8N7Fl
         yUm4A/nhri1TThvV3zKD2q5etTM3O9tZSOdGnkbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.19 77/79] ASoC: pcm3168a: The codec does not support S32_LE
Date:   Fri,  8 Nov 2019 19:50:57 +0100
Message-Id: <20191108174829.033434277@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 7b2db65b59c30d58c129d3c8b2101feca686155a upstream.

24 bits is supported in all modes and 16 bit only when the codec is slave
and the DAI is set to RIGHT_J.

Remove the unsupported sample format.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20190919071652.31724-1-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/pcm3168a.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -24,8 +24,7 @@
 
 #define PCM3168A_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | \
 			 SNDRV_PCM_FMTBIT_S24_3LE | \
-			 SNDRV_PCM_FMTBIT_S24_LE | \
-			 SNDRV_PCM_FMTBIT_S32_LE)
+			 SNDRV_PCM_FMTBIT_S24_LE)
 
 #define PCM3168A_FMT_I2S		0x0
 #define PCM3168A_FMT_LEFT_J		0x1


