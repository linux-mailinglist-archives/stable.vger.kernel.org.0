Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC7230284D
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 17:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbhAYQ47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 11:56:59 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:39005 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728901AbhAYQ4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 11:56:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 50462F11;
        Mon, 25 Jan 2021 11:55:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 11:55:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PKeZBc
        3aWgAhd5A6P8dJ9OlR+itPrcxaJVHRr09rR3E=; b=Pla/3ENmY5wRoWmSDSvXps
        IlIXn/BcBSuxZndUxg1WFg5yxVp3F/Ocx5n+tt6p+E80l/fyvOHN4gk4+Pvy0cZL
        eoajniloAlexpxDE78HfPk7r9c8R+d0iK6P1u8Ou/+wAPhFRcsFLtKp4fGTrRd3i
        gBewaw9C0u1a229KKPrQHmLTDMWLk4uVqQWN5N3LF/+1wcEpsw0JMPIMpR2jriI7
        t6FULN1A0J4pASH7g7kGSMNLoow5BomDOeE+rDSeOmV2v2rpBDreTa0waBda9RZC
        rDLpgOTxWaz4B9cDCLOB2pJe24zi4bXqvCCRqNAZ1JfLsMtLPttcPKgvnjDfIKkQ
        ==
X-ME-Sender: <xms:__cOYPDqiVfvjARFlHsYWTsgmfvbwfz6gyC9jHYmWHFIbTCINt7pSw>
    <xme:__cOYFjEAiwc2uWvlt6mEHKqKSIUzHtm423GAqg7jJKvU6qPLHTkPgX9AdHEy0dJ2
    -Mp084BCo16WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:__cOYKkBFYK7WCdAq1zGvCuvfb1ZhwlegZZUyFp-lKUVG3j5tS1T-g>
    <xmx:__cOYBz3Hp2EZWIaDQ8_D0RIK7zr23-2nf0R1Nn4Ki4vySWYp_hPcg>
    <xmx:__cOYEQjRgq32IHqNf0c-nVXGSc3w2mjRT4IT1UtSFdb18fJmMFJXg>
    <xmx:__cOYKegs9Wswn51I_y1oQgsMYXrTK78cpfLVdBjLfnE70gyKIsKRgH02q4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0802A1080063;
        Mon, 25 Jan 2021 11:55:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] ASoC: hdmi-codec: Fix return value in hdmi_codec_set_jack()" failed to apply to 5.10-stable tree
To:     stephan@gerhold.net, broonie@kernel.org, cychiang@chromium.org,
        nicoleotsuka@gmail.com, srinivas.kandagatla@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 17:55:25 +0100
Message-ID: <16115937256210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2a0435df963f996ca870a2ef1cbf1773dc0ea25a Mon Sep 17 00:00:00 2001
From: Stephan Gerhold <stephan@gerhold.net>
Date: Thu, 7 Jan 2021 17:51:31 +0100
Subject: [PATCH] ASoC: hdmi-codec: Fix return value in hdmi_codec_set_jack()

Sound is broken on the DragonBoard 410c (apq8016_sbc) since 5.10:

  hdmi-audio-codec hdmi-audio-codec.1.auto: ASoC: error at snd_soc_component_set_jack on hdmi-audio-codec.1.auto: -95
  qcom-apq8016-sbc 7702000.sound: Failed to set jack: -95
  ADV7533: ASoC: error at snd_soc_link_init on ADV7533: -95
  hdmi-audio-codec hdmi-audio-codec.1.auto: ASoC: error at snd_soc_component_set_jack on hdmi-audio-codec.1.auto: -95
  qcom-apq8016-sbc: probe of 7702000.sound failed with error -95

This happens because apq8016_sbc calls snd_soc_component_set_jack() on
all codec DAIs and attempts to ignore failures with return code -ENOTSUPP.
-ENOTSUPP is also excluded from error logging in soc_component_ret().

However, hdmi_codec_set_jack() returns -E*OP*NOTSUPP if jack detection
is not supported, which is not handled in apq8016_sbc and soc_component_ret().
Make it return -ENOTSUPP instead to fix sound and silence the errors.

Cc: Cheng-Yi Chiang <cychiang@chromium.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: 55c5cc63ab32 ("ASoC: hdmi-codec: Use set_jack ops to set jack")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/20210107165131.2535-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index d5fcc4db8284..0f3ac22f2cf8 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -717,7 +717,7 @@ static int hdmi_codec_set_jack(struct snd_soc_component *component,
 			       void *data)
 {
 	struct hdmi_codec_priv *hcp = snd_soc_component_get_drvdata(component);
-	int ret = -EOPNOTSUPP;
+	int ret = -ENOTSUPP;
 
 	if (hcp->hcd.ops->hook_plugged_cb) {
 		hcp->jack = jack;
diff --git a/sound/soc/fsl/imx-hdmi.c b/sound/soc/fsl/imx-hdmi.c
index ede4a9ad1054..dbbb7618351c 100644
--- a/sound/soc/fsl/imx-hdmi.c
+++ b/sound/soc/fsl/imx-hdmi.c
@@ -90,7 +90,7 @@ static int imx_hdmi_init(struct snd_soc_pcm_runtime *rtd)
 	}
 
 	ret = snd_soc_component_set_jack(component, &data->hdmi_jack, NULL);
-	if (ret && ret != -EOPNOTSUPP) {
+	if (ret && ret != -ENOTSUPP) {
 		dev_err(card->dev, "Can't set HDMI Jack %d\n", ret);
 		return ret;
 	}

