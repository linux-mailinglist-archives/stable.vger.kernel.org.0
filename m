Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A414050D124
	for <lists+stable@lfdr.de>; Sun, 24 Apr 2022 12:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbiDXK2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 06:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239103AbiDXK1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 06:27:36 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16795E74B
        for <stable@vger.kernel.org>; Sun, 24 Apr 2022 03:24:35 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6571C5C00D8;
        Sun, 24 Apr 2022 06:24:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Apr 2022 06:24:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1650795873; x=1650882273; bh=o2NRR3qRrC
        8yOSNDXCsVvkqHb0WKo+3WKhgufdfUuVA=; b=kF1hshVju822dVk8B9C92H2JZH
        U/GMCXnQWVuSe8pOCFX+DC3V9qF+sLvWUcLEJwj/6s1LdZkWVZ9wuwarD8kA7rpW
        eNkhl540nJl3wwHhJcN1tW7K+VA/B7TVV/L6Vx2MAflJMk9ufW16faMSjbJsuyrF
        3O51pYWi0SCFNKRvlb/1SIrskLjVTmLhuye+zvo/bopveseZH8u7yCx8rhVa3B0F
        wu4IPyIclmhPPTpmSsCjFWPv56Y6qZM3pbtrsRAEHb4IfpQSyz0MGfUTXz6/r5U3
        S0hH7yn307TZbv7nohXVpN9xiQp0iayW5GnUt2S3dUmZhArxBXddotIDRIvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; t=1650795873; x=1650882273; bh=o
        2NRR3qRrC8yOSNDXCsVvkqHb0WKo+3WKhgufdfUuVA=; b=UF37VAZowsGD2yiG+
        CQ0U/hyNSIIY06nv9gWn79+Wt3YDrtd1q/QC93C7teLzH2rjUuV9BCBogsnjKBNU
        xvJrHb9rz2g7y3XxH7UM9K9By/XAcrgk8YaTRZnHkACiBVZWp0NC75PfRpl8kRuD
        847B4iICu6UaEWm4H4Z8uWZusU4dUPh2rYs2MSd9WZPQjXEVMFTQ6iuYX1FAZGVL
        4BmnT3Pva6pSeui765e0eUgtqIafxADDYAZkxd2jUmCYCwNgjhoNL1LVjraLOQ1S
        HSD9et2+SUdlg0Rs1UzGG+3GP3kMhW1x0LBkLEgHspsEApQhWL+/qXhoe3zkqMTd
        ji6JA==
X-ME-Sender: <xms:YCVlYhKWcNXdO91ZgTltz84Kg2o90_-JLd9mj3Iq1V2ZWrz8QCCgkQ>
    <xme:YCVlYtItUkTTzeBGwijh_A10PViY9jUU08EYprHBq-TEIEMZ3mCmarFVTOCfOShjL
    fs5f1A9sb3rI-KACV8>
X-ME-Received: <xmr:YCVlYpuGID2DK_Bwv2QmfhmyxfraYlNEAQsyNcvvXIY64SHQ5KV0lD9oZBQ80Om31MpBhFTZHU9hc062V9_Sya_hmvJeoEv9ntXhpxWMeBOqtlT_mXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrtdelgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepffdvueelffevke
    duhfetjeduffeghfettdfguedtgfdvgfeufeduheevheevkeeknecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkh
    grmhhotggthhhirdhjph
X-ME-Proxy: <xmx:YCVlYib-jwVD3MinIsa4BKt_2tifXxbJjqy1BHKot-SFRb-P8vkKxQ>
    <xmx:YCVlYoYe8TdgaZcvbyUn6G8ixBhzIzBWOLBSIk3Bh6onY4pm4d6O3A>
    <xmx:YCVlYmD_hEtOkIzQw9LR65yy2v3yhLCWvwoDRp3DdFAPuSA7krdbdA>
    <xmx:YSVlYnk2M1izunN96-VJY7zVjk0OIy1fRIN_F9VJf9vqpZnSojUeRQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 24 Apr 2022 06:24:31 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes
Date:   Sun, 24 Apr 2022 19:24:28 +0900
Message-Id: <20220424102428.21109-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ALSA fireworks driver has a bug in its initial state to return count
shorter than expected by 4 bytes to userspace applications when handling
response frame for Echo Audio Fireworks transaction. It's due to missing
addition of the size for the type of event in ALSA firewire stack.

Fixes: 555e8a8f7f14 ("ALSA: fireworks: Add command/response functionality into hwdep interface")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/fireworks/fireworks_hwdep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/firewire/fireworks/fireworks_hwdep.c b/sound/firewire/fireworks/fireworks_hwdep.c
index 626c0c34b0b6..3a53914277d3 100644
--- a/sound/firewire/fireworks/fireworks_hwdep.c
+++ b/sound/firewire/fireworks/fireworks_hwdep.c
@@ -34,6 +34,7 @@ hwdep_read_resp_buf(struct snd_efw *efw, char __user *buf, long remained,
 	type = SNDRV_FIREWIRE_EVENT_EFW_RESPONSE;
 	if (copy_to_user(buf, &type, sizeof(type)))
 		return -EFAULT;
+	count += sizeof(type);
 	remained -= sizeof(type);
 	buf += sizeof(type);
 
-- 
2.34.1

