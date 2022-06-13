Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DD4549B79
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 20:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiFMS3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 14:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343535AbiFMS2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 14:28:34 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9601FD28D
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:48:59 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7278C3200972;
        Mon, 13 Jun 2022 10:48:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 13 Jun 2022 10:48:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1655131737; x=1655218137; bh=nd
        A8eY6a5iymQUjqVhwiJTuImgDxQFcTtcXOYgHWCuo=; b=kAi1yhJczX7MPdDiaT
        Izrf8qWozX2mLQZm6TE6OM6a+3T4W3XPWSykMoBWwY7qImfX6bLPuVESmvJDrerl
        PdsPkWXg0TVhq6yWlxIHGpB2XcQqG2Of+1LmQchW/IEjK5urHYG7tD+cdnE39GYu
        qT6/s67cny8kPAOLYqDf4VQSicV2eWl1WB1uqjgxLcANIBB5jGnSZeem9vyHwJnL
        SyHcLBXL2CrcLAloQwlDS+8GsQ4X4p/4Tvnzz1AqcHQPu0o23Qv/57Ycbwkt4dLn
        qJ/HdBr9QJfZXISwmULMgiW6rtTok0Q419CrSaABhUukeBGhL5m6TC8v35i/1E1C
        3PLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1655131737; x=1655218137; bh=ndA8eY6a5iymQ
        UjqVhwiJTuImgDxQFcTtcXOYgHWCuo=; b=HMqq3PSD70IkmXYDcbbJS8M8WUd0m
        simBT4zCdqUe+xLJTgIPLrP4Rn2bCTS75mJLsccj2rWVXttI26JoH7gYNuRBoQcI
        L60lIpeqkzgQ0bH73ONXrXlgvz6FySmu0hSKUTpU+X0I2JalGUV4iHkHTe707lzF
        Bc9t+lSrQMrGJqRjwmkZu9sFjnBgi7vZgjOLMk2fibwzvmoX7srK6lqmcjeCCetv
        wflu4Uy+aRGpI2wEt7s5V2nkEDX2qj8gWaenLvy0VQgYxu2zNLeyUmzARPe7yCbb
        pyP1xS9cefx51DBZed4XaNgk/JpxZzzi3TaoxiLmLBlCzcOw1oWC2M+ZA==
X-ME-Sender: <xms:WU6nYomyOOgsT6i-RywMt9H8mSoGDY5mRllXJHnesDn65R1cL_ma8g>
    <xme:WU6nYn02zXwUCKzPsMLSI5FWtHLU58KOlplrZvbuRC8o2fgo9HCeFluXcl8lDZewe
    MFF-eG3D12iXRlpzpE>
X-ME-Received: <xmr:WU6nYmrZ8BpH2lSip_ZU-5oupk2onTLSxu4gg9AsIxY-yI2u0XtVxtyiMhoZdsXfhYY9-h3lAS3L3JigpxwTXM3ahb61HldqdpYQiWE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddujedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpeelkeefteduhfekjeeihfetudfguedvveekkeetteekhfekhfdtlefgfedu
    vdejhfenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:WU6nYkk6fXpx8-5t_nVZY-e7bZXR8-vbCt0dPv07P7hfeFeNpso9sA>
    <xmx:WU6nYm0rP-8jtkY2R15pgwdutKZXNQdCt6sE_b1fSzO9fJznJPlVIw>
    <xmx:WU6nYrsHTK4as33AerChKqltZEmzdmtQmbeO8shOV4r4gpYwvniX5A>
    <xmx:WU6nYgrMS1nkR3Y53sgJcGpjDRihthNGxj3BYOOEMKTL7r4CmLXC7Q>
Feedback-ID: i8771445c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jun 2022 10:48:57 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     dri-devel@lists.freedesktop.org,
        Phil Elwell <phil@raspberrypi.org>, stable@vger.kernel.org
Subject: [PATCH 17/33] drm/vc4: hdmi: Disable audio if dmas property is present but empty
Date:   Mon, 13 Jun 2022 16:47:44 +0200
Message-Id: <20220613144800.326124-18-maxime@cerno.tech>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613144800.326124-1-maxime@cerno.tech>
References: <20220613144800.326124-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.org>

The dmas property is used to hold the dmaengine channel used for audio
output.

Older device trees were missing that property, so if it's not there we
disable the audio output entirely.

However, some overlays have set an empty value to that property, mostly
to workaround the fact that overlays cannot remove a property. Let's add
a test for that case and if it's empty, let's disable it as well.

Cc: <stable@vger.kernel.org>
Signed-off-by: Phil Elwell <phil@raspberrypi.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 6aadb65eb640..c8571e17afa8 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2034,12 +2034,12 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 	struct device *dev = &vc4_hdmi->pdev->dev;
 	struct platform_device *codec_pdev;
 	const __be32 *addr;
-	int index;
+	int index, len;
 	int ret;
 
-	if (!of_find_property(dev->of_node, "dmas", NULL)) {
+	if (!of_find_property(dev->of_node, "dmas", &len) || !len) {
 		dev_warn(dev,
-			 "'dmas' DT property is missing, no HDMI audio\n");
+			 "'dmas' DT property is missing or empty, no HDMI audio\n");
 		return 0;
 	}
 
-- 
2.36.1

