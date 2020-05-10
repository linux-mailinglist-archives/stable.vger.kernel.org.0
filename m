Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0501CC7B2
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 09:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgEJHnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 03:43:08 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52461 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbgEJHnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 03:43:08 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id B1AC25C0081;
        Sun, 10 May 2020 03:43:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 10 May 2020 03:43:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=LXOTGcRk5He84
        rg3s/Ou6yI0iMopv+DCIDPQ/wnQy0k=; b=mMp7Pgo9z6l8/T8fHV3IA1fFLVSyE
        APAwkq30C1tKl/1qXtS7aLRnmaFzEbQZvtkcoP4EvExUADW/+dI2NfG5v7RgxbRy
        03vYHtfYl5V/+Ubaq7VTwhG9kgxcA4O+HGLeOPNFSVaxPEwbEysLkSDiPKIofDqD
        FH8INKXcP4OXtG3zKOzjpu6qgb1/9aKj0D+XFDNgFEs3RRSKX+D6p7k6NZRArjd4
        jEMqutbV2S0u2+z0kZzyMTiz23jeYX1PtQ3KzIbe0w1ny5lngvojnRSrejket/Vo
        4oQXGpyCMFdPonB47tvRMgB/PAGnC0O4+Iky4KLCb6DGo+f8ctKUaMDLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=LXOTGcRk5He84rg3s/Ou6yI0iMopv+DCIDPQ/wnQy0k=; b=1VLO9l68
        mZ4DjJ8dpuglzQL0MgKK8Y8RNz8N2Z6lKinaOrfneKIETmyFgRL3GFQgedm1Z5Ab
        4ieL/hSr5WsPVXXAgZ/nQL0B4Xxt9bSf+KudDlxD1r4IUTfHtiPvAKcyht9IcFND
        BdTRuTJC/Asi8qKZSY4e83YACIp+ATr/3UvbUc+BkROYRQ57W00w74iXAu4QD2ro
        YX5/EQe4G41SGYXLl9tlrfEBiFR+npMYpK0lcBqHzHOdolLf829Ug5JkjRAo8HAq
        kz8c1CpRP/WUo9ssVU8nl8i8dWGRezXhF3N32Kf0V/M3P3JlChhHcXzRMcXo2RZZ
        BuNeQsGiKWlhNQ==
X-ME-Sender: <xms:irC3XmGiSJSa0ybK8aEX733SrIF3WtWFWC-RTmbN5UzSJ9bkoW-iXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghs
    hhhisehsrghkrghmohgttghhihdrjhhpqeenucggtffrrghtthgvrhhnpeevfefffeekte
    fgveegfeelheffhfeujedtjeevtefhkeevkedtjeejvddtjefhjeenucfkphepudektddr
    vdefhedrfedrheegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:irC3XnSKnTNt_WIk1C0HcAilJYgiUxFKktFknpcuQVOhaL5xr7McKw>
    <xmx:irC3XrtJac8OIYruMe9_Ct37VecVQ2fMSrk7H0b-lA0jH8769m1i9g>
    <xmx:irC3XlC7PmedgIIAVEt5j1xbTjkyBNUo2KvG8m8i8TTlE44WWcdsdg>
    <xmx:irC3Xtpqfnt2L3g3cn03DvckAMRVoV_6VsS7rQ290oBnUHiGZl1VIg>
Received: from workstation.flets-east.jp (ad003054.dynamic.ppp.asahi-net.or.jp [180.235.3.54])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A37A306625B;
        Sun, 10 May 2020 03:43:05 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, ffado-devel@lists.sourceforge.net,
        stable@vger.kernel.org
Subject: [PATCH 1/6] ALSA: fireface: fix configuration error for nominal sampling transfer frequency
Date:   Sun, 10 May 2020 16:42:56 +0900
Message-Id: <20200510074301.116224-2-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200510074301.116224-1-o-takashi@sakamocchi.jp>
References: <20200510074301.116224-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

128000 and 192000 are congruence modulo 32000, thus it's wrong to
distinguish them as multiple of 32000 and 48000 by modulo 32000 at
first.

Additionally, used condition statement to detect quadruple speed can
cause missing bit flag.

Furthermore, counter to ensure the configuration is wrong and it
causes false positive.

This commit fixes the above three bugs.

Cc: <stable@vger.kernel.org>
Fixes: 60aec494b389 ("ALSA: fireface: support allocate_resources operation in latter protocol")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/fireface/ff-protocol-latter.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/firewire/fireface/ff-protocol-latter.c b/sound/firewire/fireface/ff-protocol-latter.c
index 0e4c3a9ed5e4..76ae568489ef 100644
--- a/sound/firewire/fireface/ff-protocol-latter.c
+++ b/sound/firewire/fireface/ff-protocol-latter.c
@@ -107,18 +107,18 @@ static int latter_allocate_resources(struct snd_ff *ff, unsigned int rate)
 	int err;
 
 	// Set the number of data blocks transferred in a second.
-	if (rate % 32000 == 0)
-		code = 0x00;
+	if (rate % 48000 == 0)
+		code = 0x04;
 	else if (rate % 44100 == 0)
 		code = 0x02;
-	else if (rate % 48000 == 0)
-		code = 0x04;
+	else if (rate % 32000 == 0)
+		code = 0x00;
 	else
 		return -EINVAL;
 
 	if (rate >= 64000 && rate < 128000)
 		code |= 0x08;
-	else if (rate >= 128000 && rate < 192000)
+	else if (rate >= 128000)
 		code |= 0x10;
 
 	reg = cpu_to_le32(code);
@@ -140,7 +140,7 @@ static int latter_allocate_resources(struct snd_ff *ff, unsigned int rate)
 		if (curr_rate == rate)
 			break;
 	}
-	if (count == 10)
+	if (count > 10)
 		return -ETIMEDOUT;
 
 	for (i = 0; i < ARRAY_SIZE(amdtp_rate_table); ++i) {
-- 
2.25.1

