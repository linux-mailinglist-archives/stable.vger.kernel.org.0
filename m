Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4851FAEC53
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 15:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfIJNwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 09:52:03 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:33447 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfIJNwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 09:52:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 2D10E54C;
        Tue, 10 Sep 2019 09:52:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Sep 2019 09:52:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=VP0+wK5/okPUg
        MvIwSQ3xYqO4BcezYHzLCzGeoeNW8k=; b=dE/E+dexYa/c2Q5Kamjd9nIniiuLs
        wD7mZ3oLLq2RVo0+kBBlL15nlbqZfwFShGua4dv6/PQ2YycwDH+y9RTNbO7HtxfV
        CDXvh9C2PuPwAnM1wlscfkrIeMRWP3MVuWhQ5lDvEzcqcxeW/xp2p5MHIGlXNTDN
        o3hLI+Fa5snYdxMN2NXMZCnGGP2ChFNsNR/8WlxlDkEz0QwsJuQSH6oG6jRg1y2u
        yzsbCb0ltF3DKMpQiyZmtQ3M2P0LtalgQm+BpOurM8RErhsyO/l7PO+qEiXXp5O9
        b/03uo1CcC0T5uP8KS5bZjPlOj3nxvzQsNCq4aTrEKDq0HL4zxynQWORw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=VP0+wK5/okPUgMvIwSQ3xYqO4BcezYHzLCzGeoeNW8k=; b=wMUypOki
        1GZBBhG9VgsC0M2BwP5o3JnKBxrBBCuKjhSxuNNo+yb2URYuzjr6rhjf3I9nBk0+
        d7UsWJdUAHQVGhQmMkyqODvaOpMhQg9avPKe6gBy1kLxxQKy6qe73TlFeefZA0DJ
        0W03jWFAhhkau5us6tU0fTkXCKKM6td+MKQJ4bAfNHJIozhY+455S6nINgQCYBHM
        bv4H9QSZLoeKgvgUEBN4kH2rNX3HTMJrWYJhxpuQnC6CUw1lfbkP6LyYSyK+Q3j6
        ljO8pWy0wwCF1DqCLOeJlsoHx+SNw46zeq/NTxTOpVGQGan7EYphWMRO7UMXmPxm
        Xbo4y2Oc74fgMQ==
X-ME-Sender: <xms:gKp3XbtY1Q7AwgNnzxcremYp8ouQX8RKd_xMqMmX9PdrUpqvrB_U6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtddtgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghs
    hhhisehsrghkrghmohgttghhihdrjhhpqeenucfkphepudegrdefrdejhedrudekudenuc
    frrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhi
    rdhjphenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:gKp3XRJD0z39TSH5pPKBXXDKwoLLj0lfEe08iabm5zCYHsGVogSfQA>
    <xmx:gKp3XbnWvV2SyjwaVGSByu6cCU-N0iZzEWuOUok52bS7tP93yD77mQ>
    <xmx:gKp3XXEWxRYz7LCdu9LLBnh8KjXQQaC8Y_R-WHFKqvvY8XjddiRhYA>
    <xmx:gKp3XfztWbzZ1VS6_siYfamEs0EcOpkKgntVlrqqr3-1zjyX2fCGuQ>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C446D6005E;
        Tue, 10 Sep 2019 09:51:59 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH 2/2] ALSA: firewire-tascam: check intermediate state of clock status and retry
Date:   Tue, 10 Sep 2019 22:51:52 +0900
Message-Id: <20190910135152.29800-3-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190910135152.29800-1-o-takashi@sakamocchi.jp>
References: <20190910135152.29800-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2 bytes in MSB of register for clock status is zero during intermediate
state after changing status of sampling clock in models of TASCAM FireWire
series. The duration of this state differs depending on cases. During the
state, it's better to retry reading the register for current status of
the clock.

In current implementation, the intermediate state is checked only when
getting current sampling transmission frequency, then retry reading.
This care is required for the other operations to read the register.

This commit moves the codes of check and retry into helper function
commonly used for operations to read the register.

Fixes: e453df44f0d6 ("ALSA: firewire-tascam: add PCM functionality")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/tascam/tascam-stream.c | 42 ++++++++++++++++++---------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/sound/firewire/tascam/tascam-stream.c b/sound/firewire/tascam/tascam-stream.c
index 9e2dc2fe3271..adf69a520b80 100644
--- a/sound/firewire/tascam/tascam-stream.c
+++ b/sound/firewire/tascam/tascam-stream.c
@@ -8,20 +8,37 @@
 #include <linux/delay.h>
 #include "tascam.h"
 
+#define CLOCK_STATUS_MASK      0xffff0000
+#define CLOCK_CONFIG_MASK      0x0000ffff
+
 #define CALLBACK_TIMEOUT 500
 
 static int get_clock(struct snd_tscm *tscm, u32 *data)
 {
+	int trial = 0;
 	__be32 reg;
 	int err;
 
-	err = snd_fw_transaction(tscm->unit, TCODE_READ_QUADLET_REQUEST,
-				 TSCM_ADDR_BASE + TSCM_OFFSET_CLOCK_STATUS,
-				 &reg, sizeof(reg), 0);
-	if (err >= 0)
+	while (trial++ < 5) {
+		err = snd_fw_transaction(tscm->unit, TCODE_READ_QUADLET_REQUEST,
+				TSCM_ADDR_BASE + TSCM_OFFSET_CLOCK_STATUS,
+				&reg, sizeof(reg), 0);
+		if (err < 0)
+			return err;
+
 		*data = be32_to_cpu(reg);
+		if (*data & CLOCK_STATUS_MASK)
+			break;
 
-	return err;
+		// In intermediate state after changing clock status.
+		msleep(50);
+	}
+
+	// Still in the intermediate state.
+	if (trial >= 5)
+		return -EAGAIN;
+
+	return 0;
 }
 
 static int set_clock(struct snd_tscm *tscm, unsigned int rate,
@@ -34,7 +51,7 @@ static int set_clock(struct snd_tscm *tscm, unsigned int rate,
 	err = get_clock(tscm, &data);
 	if (err < 0)
 		return err;
-	data &= 0x0000ffff;
+	data &= CLOCK_CONFIG_MASK;
 
 	if (rate > 0) {
 		data &= 0x000000ff;
@@ -79,17 +96,14 @@ static int set_clock(struct snd_tscm *tscm, unsigned int rate,
 
 int snd_tscm_stream_get_rate(struct snd_tscm *tscm, unsigned int *rate)
 {
-	u32 data = 0x0;
-	unsigned int trials = 0;
+	u32 data;
 	int err;
 
-	while (data == 0x0 || trials++ < 5) {
-		err = get_clock(tscm, &data);
-		if (err < 0)
-			return err;
+	err = get_clock(tscm, &data);
+	if (err < 0)
+		return err;
 
-		data = (data & 0xff000000) >> 24;
-	}
+	data = (data & 0xff000000) >> 24;
 
 	/* Check base rate. */
 	if ((data & 0x0f) == 0x01)
-- 
2.20.1

