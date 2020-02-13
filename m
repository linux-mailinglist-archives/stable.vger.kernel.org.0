Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FDF15B96C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 07:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgBMGLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 01:11:52 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:34237 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726368AbgBMGLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 01:11:51 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id F2A215397;
        Thu, 13 Feb 2020 01:11:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 13 Feb 2020 01:11:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=RIhl9ui4MUMvU
        Z3Loqtrzp+BStII7YZIIhAd8D98BR8=; b=FrRY45uza9QIuvD5w+dJpQeXqiaCE
        c7bfRtWec5BqDXWDuANN1aSRBkpbHpHDJZKhM1Flzqs5uBjN2Q0SJ9WNRdkFc41Y
        udUV+f/RJhMESZsCQHfUcU5/uTi6IbdBtdmcesSn01yed2mGgyYWR9Ixd9kFxrPG
        85pgkcZbQi4CuByjj5Vk3CHigylPmknw0aRch5d4K+jIBiZbp6nPDPSd4C3b++Il
        M/oSnqrVjVXjaf1jVWJ3RoZ+GKefTBmD+zv9/kS3MgbL0/HbprW+v/zgFbiWdKIv
        c+l3xmS8oeA9Y1j4iFYBgu4d2D1F3c3o9hYP3VAQ02CtDg3nTj+OBIQ3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=RIhl9ui4MUMvUZ3Loqtrzp+BStII7YZIIhAd8D98BR8=; b=ciM6GQug
        Iw0C7/qrmPtYFYeogOGkOV+LKE3UJfNnEt1Uf388Y2HrIJMW6+SaksdhcaSWZff8
        pNt1cOsuMoHdBICa47pJIqRHTnMVRTLtexGKXoqkhJx9cy31Gr1KvE445cdsim+H
        g8bVRCZyZERGBoiKMkpeVhdWjfLayrkXOBtEgG/B49mrYg0YQdIVVsXrw6HffNFB
        Ux9xdwfwRrXZmuMj7bKQWSc6J1Mby9v4DW7F56kV3VClafRjgxtx2EWomunJ27U0
        Sa6olSwdregwsItpviPrCd65uvl8akNKQ5TF8QEzFI73UWeHUhtK8IePGm6CPZ9X
        HnJDMV1yS4LGtQ==
X-ME-Sender: <xms:pehEXn4FgcqQV0QB2W75WmQRxBAjFFyio8WwtXUKnJR9vY-r5Hb0rA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieejgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecukfhppe
    ejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:pehEXqG_tkvVnAlLW0wt6CgoCmUugWiJDHEnxRaYpbfFENSenBvs1A>
    <xmx:pehEXnCLaUgA2hBbPTjHKfpT_TV_WKMxoNjt3EZvgAb4u-aJkDxtrw>
    <xmx:pehEXnycsg15BGcKBJuRm_5AwxKWgNZ7D9_cIAelNFC-0d-zPUnTZA>
    <xmx:pehEXrF1pHEbmaet6mDBhsM37nEGOeXFFOdUuWC75nAHjOZfiOiV0A>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 114593280067;
        Thu, 13 Feb 2020 01:11:49 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jerome Brunet <jbrunet@baylibre.com>
Cc:     alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>, stable@vger.kernel.org
Subject: [PATCH 1/4] ASoC: codec2codec: avoid invalid/double-free of pcm runtime
Date:   Thu, 13 Feb 2020 00:11:44 -0600
Message-Id: <20200213061147.29386-2-samuel@sholland.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200213061147.29386-1-samuel@sholland.org>
References: <20200213061147.29386-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PCM runtime was freed during PMU in the case that the event hook
encountered an error. However, it is also unconditionally freed during
PMD. Avoid a double-free by dropping the call to kfree in the PMU hook.

Fixes: a72706ed8208 ("ASoC: codec2codec: remove ephemeral variables")
Cc: stable@vger.kernel.org
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 sound/soc/soc-dapm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index b6378f025836..935b5375ecc5 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3888,9 +3888,6 @@ snd_soc_dai_link_event_pre_pmu(struct snd_soc_dapm_widget *w,
 	runtime->rate = params_rate(params);
 
 out:
-	if (ret < 0)
-		kfree(runtime);
-
 	kfree(params);
 	return ret;
 }
-- 
2.24.1

