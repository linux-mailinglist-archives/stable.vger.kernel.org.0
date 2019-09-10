Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE07CAEC52
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 15:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfIJNwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 09:52:02 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:52821 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbfIJNwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 09:52:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 6EA5F54A;
        Tue, 10 Sep 2019 09:51:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Sep 2019 09:51:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=moGB0nJAJd72r
        zqXrDEkU8H1iO7t69avZoCbt5iv/4o=; b=kaAGGE+7nrkw33MzKo69TsdZsUJee
        YMxBUKB7R/XC7HVjm4CyYXiPPhVp2J+mOi+mMTXmC5i27PuzD9YUh7sVnowY7kfL
        EumHQge+65rsXvF1TQG0ZYmvDyDOEBR9I62uWPPWOb55dlkLGPgPn9vTuqmTHz3f
        nz/SU8TiBfQLuxhdVKTZmQ0ey4Ygf8hQM1OVH4Zhe9bVgS5igVHPG7tAqth7tMxT
        CjVjqtlEz9V0m4kA4fQxZLXKUFRJ4ikmwy2mC7uTdM9SD1j7z/roHer4Ogc/XCEM
        wUW4hR81HljevxgkCm0ZmE9Jq8pjrymmuptZcyT5fO1swZkuc+/JEY1qA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=moGB0nJAJd72rzqXrDEkU8H1iO7t69avZoCbt5iv/4o=; b=ldqj6RBr
        b/5BHAz80rbgIrP696s1IEgFp6bv+zudfu/0b63KFbXq2Ybif3LYxV1gayq3G4fy
        ORR0btzVWzEuShu8lhqpnouxoUeuGJ7cA3piOeg0e7EepwmD7L5B/5JJVZcwWmA6
        afLr2KcK/sOvSKPY+9f95628kM6vNzvqHuj/kyDmJMxWrAnE8cBZegc7lXTdxvNG
        oxuL+r7dY/Iaxu0mVWQUqzQEN5LqLZBueF6gFbjRve39jW9cAMG+8UXrG9/FInvk
        kkS0z237WLgPkEdesHuGUp25JismSoS6FMtkvS4uXWunY3zfZ3sTiBS8BITuyAGH
        djdGSEiqQS43qg==
X-ME-Sender: <xms:fqp3XXpTVwyuleysU2u6m2s8qkstmbX2BrORLCg4b62Yq1UA3LBi4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtddtgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghs
    hhhisehsrghkrghmohgttghhihdrjhhpqeenucfkphepudegrdefrdejhedrudekudenuc
    frrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhi
    rdhjphenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:fqp3XWj-d_OTCX5333C8CKjTx1LELTi52wrUxX-zfKc55FoY-UjQ4A>
    <xmx:fqp3XcwK1WOZPWQ9q4tn8YluLiI-ByaseQQ_M55-z2gOdeADo-X81Q>
    <xmx:fqp3XcIvfKHMD5rZD7lqC6djvpUL-JtrG-qNrbco5COcDRilDO_RyQ>
    <xmx:f6p3XV0IgGB9YVTw0SztvMWr3CQJdmCOE6z9bXlqfSlQq6ie1-0QBA>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D49FD6005A;
        Tue, 10 Sep 2019 09:51:57 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH 1/2] ALSA: firewire-tascam: handle error code when getting current source of clock
Date:   Tue, 10 Sep 2019 22:51:51 +0900
Message-Id: <20190910135152.29800-2-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190910135152.29800-1-o-takashi@sakamocchi.jp>
References: <20190910135152.29800-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The return value of snd_tscm_stream_get_clock() is ignored. This commit
checks the value and handle error.

Fixes: e453df44f0d6 ("ALSA: firewire-tascam: add PCM functionality")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/tascam/tascam-pcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/firewire/tascam/tascam-pcm.c b/sound/firewire/tascam/tascam-pcm.c
index b5ced5415e40..2377732caa52 100644
--- a/sound/firewire/tascam/tascam-pcm.c
+++ b/sound/firewire/tascam/tascam-pcm.c
@@ -56,6 +56,9 @@ static int pcm_open(struct snd_pcm_substream *substream)
 		goto err_locked;
 
 	err = snd_tscm_stream_get_clock(tscm, &clock);
+	if (err < 0)
+		goto err_locked;
+
 	if (clock != SND_TSCM_CLOCK_INTERNAL ||
 	    amdtp_stream_pcm_running(&tscm->rx_stream) ||
 	    amdtp_stream_pcm_running(&tscm->tx_stream)) {
-- 
2.20.1

