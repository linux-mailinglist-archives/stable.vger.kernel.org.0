Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258DE1CC7B3
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 09:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgEJHnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 03:43:09 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40593 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728546AbgEJHnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 03:43:09 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 51C805C008D;
        Sun, 10 May 2020 03:43:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 10 May 2020 03:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=M1abo0l7aBFB5
        B5e/LqkRoptxJ7+Xxq7I7XlPHS3iCM=; b=JJfFLNX51RUSA42POH0AJTcxkD0rK
        Ng/k7v0ODTzd9jYjqshc8jAiIw1V+917xsQxnxYLg/d9FAZwZWwVCXh4L2IHLedN
        lZqYLWo5jLDa8Bv+cOAWBszCTZdZ7ptNMOf6ioJRVEQJZy9Wriuecm6FsPzkq9G2
        cQbUMxX0Q+37ReOmMJObyxgYhzYUuJi4w7Y3DCoLhEEWuHFHsQIOWapylNwJbshW
        dlXEQzmv8L8NDQLpWuF98kYJeUnOIVUcqMLIuQ7pUWz1hruJmqBQOphYnvvX/ZzT
        SqREEMUo3fqTJuyZQwGsTrDd3MGQ9GNsx9lOLSiV/I/TNwCQTE9niOSFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=M1abo0l7aBFB5B5e/LqkRoptxJ7+Xxq7I7XlPHS3iCM=; b=Czh9+Zxq
        rLqCyrOCWy3VzqP7USI8hMNC7v2dd4sNxf093S5l1nJlbQL8FY+5vMTxQbqkbGGw
        sLqY1stICO4GvwzEZKTlOpidKeXZECTUEVifnhvu0jMnRb2DSDJqFbq6Sur1V98C
        s6yJKvY+y0cBqZ8BZZq2RoWgijIINfHGFECcBVWMFa3ZCkxs+NLEix6ziz6GqSWj
        YElxMrA5eG9h+2qzGsXU+B2XMbG+aNcbvDBpzr/Tptn8gM/rGSKLF2xcerg1yizQ
        xB/bFPp1RRQi01BdDpFcYr1jgbBbrrtlpJi5uDqHXAZxX+aw+d9lAPmo7BiaBV6V
        tk3P0BQeeWxjrA==
X-ME-Sender: <xms:jLC3XnmYNuxLSyljfE4Iync1uzSpCWNz8vyF-OiO86MbO_Gxmb9tmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghs
    hhhisehsrghkrghmohgttghhihdrjhhpqeenucggtffrrghtthgvrhhnpeevfefffeekte
    fgveegfeelheffhfeujedtjeevtefhkeevkedtjeejvddtjefhjeenucfkphepudektddr
    vdefhedrfedrheegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:jLC3Xoqv5_Y8uZskK_qswvwCucv1HvQcFnAMjXGEu1fKz-DGJCm5tA>
    <xmx:jLC3XoHv1HSUODhOM9eEM0adKK4r3yyEy6Bu4zZNr4EyZU8hHd_JmA>
    <xmx:jLC3XswtWgVHsR-bQgnaqAZWcAzJu1avh4-32_xLzlg1hYhGhVbYSg>
    <xmx:jLC3XnfjJvPJ4-azle2k9txKBgX3likdJ9_-fYrbYxlxP0ovn__FVQ>
Received: from workstation.flets-east.jp (ad003054.dynamic.ppp.asahi-net.or.jp [180.235.3.54])
        by mail.messagingengine.com (Postfix) with ESMTPA id D98493066258;
        Sun, 10 May 2020 03:43:06 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, ffado-devel@lists.sourceforge.net,
        stable@vger.kernel.org
Subject: [PATCH 2/6] ALSA: fireface: start IR context immediately
Date:   Sun, 10 May 2020 16:42:57 +0900
Message-Id: <20200510074301.116224-3-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200510074301.116224-1-o-takashi@sakamocchi.jp>
References: <20200510074301.116224-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the latter models of RME Fireface series, device start to transfer
packets several dozens of milliseconds. On the other hand, ALSA fireface
driver starts IR context 2 milliseconds after the start. This results
in loss to handle incoming packets on the context.

This commit changes to start IR context immediately instead of
postponement. For Fireface 800, this affects nothing because the device
transfer packets 100 milliseconds or so after the start and this is
within wait timeout.

Cc: <stable@vger.kernel.org>
Fixes: acfedcbe1ce4 ("ALSA: firewire-lib: postpone to start IR context")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/fireface/ff-stream.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/sound/firewire/fireface/ff-stream.c b/sound/firewire/fireface/ff-stream.c
index 63b79c4a5405..5452115c0ef9 100644
--- a/sound/firewire/fireface/ff-stream.c
+++ b/sound/firewire/fireface/ff-stream.c
@@ -184,7 +184,6 @@ int snd_ff_stream_start_duplex(struct snd_ff *ff, unsigned int rate)
 	 */
 	if (!amdtp_stream_running(&ff->rx_stream)) {
 		int spd = fw_parent_device(ff->unit)->max_speed;
-		unsigned int ir_delay_cycle;
 
 		err = ff->spec->protocol->begin_session(ff, rate);
 		if (err < 0)
@@ -200,14 +199,7 @@ int snd_ff_stream_start_duplex(struct snd_ff *ff, unsigned int rate)
 		if (err < 0)
 			goto error;
 
-		// The device postpones start of transmission mostly for several
-		// cycles after receiving packets firstly.
-		if (ff->spec->protocol == &snd_ff_protocol_ff800)
-			ir_delay_cycle = 800;	// = 100 msec
-		else
-			ir_delay_cycle = 16;	// = 2 msec
-
-		err = amdtp_domain_start(&ff->domain, ir_delay_cycle);
+		err = amdtp_domain_start(&ff->domain, 0);
 		if (err < 0)
 			goto error;
 
-- 
2.25.1

