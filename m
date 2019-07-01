Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207955BA3F
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 12:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfGAK7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 06:59:35 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36375 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727208AbfGAK7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 06:59:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A8C8921EFE;
        Mon,  1 Jul 2019 06:59:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Jul 2019 06:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=CdL3mD7LfGbmKgyOEqreWsUfw6
        XAqpc5nokDFsYBJGY=; b=u3Xu9lncnAfpkadiQXig8QK27A3YgxCK+t+vGk7o3L
        q8ffTbnozwIT+N+Da10RES0UQKaohes/xbt82CTEmP8MiDUwL0LbgRjJRPeM0BKn
        mPUQYIF7dCqYV4ESDe73VafBMNn5AVRpUxbf07xB15PCACuJQgZ67agdMUgbJtfr
        AEs6of9mIrunnewSNdhIrwktMQDem0PVd0YQXl7G00dSeohHcvyCKQ8CkzQjYBCa
        DdagQVzHyHp1imv0nKOSBd8PKV65St2KCFmYTbAx2aWS1CuYDaD4ks6aiTaLNRlo
        WB7EfYJfqTTbNOpuS5IJ6NlYgg8QPNU9EhYUwPHdxhWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CdL3mD7LfGbmKgyOE
        qreWsUfw6XAqpc5nokDFsYBJGY=; b=j1r6vQtb9u90ynw15tYp8SgTn99RPxLpX
        kIRH/jqUOsOf80F1sqvAbWFuDYRhIOl35F0Ftaj+KDJnnH61wrwBzOeVQxCfr3Pu
        gkrJnHgO1hVNct8yUfUfmTIhU/UIX03ZnfM/TCDpOGbhAlfGhG+eF82m/3Kp5yxA
        0AUlLSNID/c/T0GNIK5I8q9V0QI/xUXJ93ETTkxOCs4XqJ2It6ff+voNkiu0aK4v
        v4fbsQBLA9A2ms5QqzDujTIEAlPysvXfUvgiGBN6HAakMzfnvStTvz3Cs7MC2CkV
        M0kbllyPXxeZ2iwIw4ic3oB3w+IeSkm0ewdf4QIA7QXHRJyo6RjoQ==
X-ME-Sender: <xms:lecZXcPRvCouX5WH8yhGkabmXjVlbkYT7LBVK9a1jqnWr_C94VzVtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhi
    sehsrghkrghmohgttghhihdrjhhpqeenucfkphepudegrdefrdejhedrudekudenucfrrg
    hrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhj
    phenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:lecZXdqHSy8XFWVqrfHXrMyRGTY7mL8CNihI0lcwRNum8xZ4wsr2HA>
    <xmx:lecZXb99sPVdXBZmTaoGDmiwD3elK5kGk8Cnj5ryyYjr0iFNOXMW7A>
    <xmx:lecZXb3GKHXtzXpZBulLZHX9D-uZx40yQE14rwoC-omLeRf5ldWE6A>
    <xmx:lucZXXE-o0LH6GBhuhp1mahKJFOEt-w4AVNBRod8VHmZn4pp9LzurA>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A3D8380075;
        Mon,  1 Jul 2019 06:59:31 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH] ALSA: firewire-lib/fireworks: fix miss detection of received MIDI messages
Date:   Mon,  1 Jul 2019 19:59:27 +0900
Message-Id: <20190701105927.13998-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In IEC 61883-6, 8 MIDI data streams are multiplexed into single
MIDI conformant data channel. The index of stream is calculated by
modulo 8 of the value of data block counter.

In fireworks, the value of data block counter in CIP header has a quirk
with firmware version v5.0.0, v5.7.3 and v5.8.0. This brings ALSA
IEC 61883-1/6 packet streaming engine to miss detection of MIDI
messages.

This commit fixes the miss detection to modify the value of data block
counter for the modulo calculation.

For maintainers, this bug exists since a commit 18f5ed365d3f ("ALSA:
fireworks/firewire-lib: add support for recent firmware quirk") in Linux
kernel v4.2. There're many changes since the commit.  This fix can be
backported to Linux kernel v4.4 or later. I tagged a base commit to the
backport for your convenience.

Besides, my work for Linux kernel v5.3 brings heavy code refactoring and
some structure members are renamed in 'sound/firewire/amdtp-stream.h'.
The content of this patch brings conflict when merging -rc tree with
this patch to the latest tree. I request maintainers to solve the
conflict by replacing 'tx_first_dbc' with 'ctx_data.tx.first_dbc'.

Fixes: df075feefbd3 ("ALSA: firewire-lib: complete AM824 data block processing layer")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/amdtp-am824.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/firewire/amdtp-am824.c b/sound/firewire/amdtp-am824.c
index 4210e5c6262e..4d677fcb4fc2 100644
--- a/sound/firewire/amdtp-am824.c
+++ b/sound/firewire/amdtp-am824.c
@@ -321,6 +321,7 @@ static void read_midi_messages(struct amdtp_stream *s,
 	u8 *b;
 
 	for (f = 0; f < frames; f++) {
+		port = (8 - s->tx_first_dbc + s->data_block_counter + f) % 8;
 		port = (s->data_block_counter + f) % 8;
 		b = (u8 *)&buffer[p->midi_position];
 
-- 
2.20.1

