Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879185BE92
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfGAOn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 10:43:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60663 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727176AbfGAOn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 10:43:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C5EF021785;
        Mon,  1 Jul 2019 10:43:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Jul 2019 10:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=y9UxOCNaIW1NMTXNOLa9uEwlJb
        fea+yfKQ0OmjIzOP8=; b=CBW3EpFWLROkq2EqhCsRrcg67GpkfbhV5TlmlMtCpZ
        mXKhgyOMOURhZWI4J9GpgMR+XN/Y6u2FQVXlQkosrNIDhbrv2mEeong3iOxQoelB
        jkMTJtvdoEy4HYaWeOQFRTyFwwu9PjI3JW9djcHG/f+43779Y5n1t1UkImJXdrRW
        iPJQ5Etfp3FNpfw0+sN2fodHzHEA6mYP3U1/QiEFswrelJhRbVcHMtnL6+cjBB1Z
        ZYcjrR1gms4glj5LY4xY/0Vcl/JuoPyj7GDyK4kqWjIz4FDythFvlIFEI44DQ29H
        zFVjnnKLYvON62EVnMmCJJmJTeRxnl0YqOSajFF+Wr+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=y9UxOCNaIW1NMTXNO
        La9uEwlJbfea+yfKQ0OmjIzOP8=; b=qBcyfRSVB/GbXDO3eI8uAwlPKKxtn41oO
        vC2Y//QOHem6DVC/GnznJ6gh30qCT9cdhaTtQx3QAqzyg2Bi7EVM0UKuXVHHsZss
        UyuWCmPjIZHL0N+g6NHzQf+grd9+2WHf5maGupILeKInoRFpen+6OWN2WvB42ook
        qwdoNb6TgMBud6omwdZTkowPyK/et40Q2vAhdUS4VprTmMXnZPQLIECf5z+XDEmN
        2f+CsDwQvjUIMDj7qljBs5BoykjAVHhKzvmkC55H1Cc0vLWH8Y1FI11v45kO62TA
        X5xwYCL4zuIE0tOxyPDxhvcQ20tsDrhGOtO08yEDIrREo6PBxEaCQ==
X-ME-Sender: <xms:LRwaXStB5xMKjwJ8L9dYG_JsF9c7PIv4Xi6BZoo6R4TSic1Euvm6fw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhi
    sehsrghkrghmohgttghhihdrjhhpqeenucfkphepudegrdefrdejhedrudekudenucfrrg
    hrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhj
    phenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:LRwaXQ7lk6IwhY2ca3Lhs5DBf6SMJ0xE6xn0c5f0ux1NpGYO6ADs6Q>
    <xmx:LRwaXel1jTX2etEK32yZ8jRyNWCElyiHvw_kpOU9uuz9-64s8ksZlA>
    <xmx:LRwaXYjfYQI7zKnP8PBUBF_GY3UvGm0R57EqGSU1ILYt9ft0Nq5tqg>
    <xmx:LhwaXeKAGE8ER1jjsuVHT7b_7TzScn_meOXmpdVwQYiHszvRmJDGJQ>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3FA46380088;
        Mon,  1 Jul 2019 10:43:56 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH v2] ALSA: firewire-lib/fireworks: fix miss detection of received MIDI messages
Date:   Mon,  1 Jul 2019 23:43:53 +0900
Message-Id: <20190701144353.4875-1-o-takashi@sakamocchi.jp>
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
this patch and the latest tree. I request maintainers to solve the
conflict to replace 'tx_first_dbc' with 'ctx_data.tx.first_dbc'.

Fixes: df075feefbd3 ("ALSA: firewire-lib: complete AM824 data block processing layer")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/amdtp-am824.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/amdtp-am824.c b/sound/firewire/amdtp-am824.c
index bebddc60fde8..99654e7eb2d4 100644
--- a/sound/firewire/amdtp-am824.c
+++ b/sound/firewire/amdtp-am824.c
@@ -388,7 +388,7 @@ static void read_midi_messages(struct amdtp_stream *s,
 	u8 *b;
 
 	for (f = 0; f < frames; f++) {
-		port = (s->data_block_counter + f) % 8;
+		port = (8 - s->tx_first_dbc + s->data_block_counter + f) % 8;
 		b = (u8 *)&buffer[p->midi_position];
 
 		len = b[0] - 0x80;
-- 
2.20.1

