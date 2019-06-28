Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C3459357
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 07:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfF1FWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 01:22:05 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44005 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726240AbfF1FWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 01:22:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 51D6721111;
        Fri, 28 Jun 2019 01:22:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 28 Jun 2019 01:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=9uHbDy+yscQcQ9si3v6fybcJcZ
        oszIfrJ/wKIKt3L5A=; b=XYZfq4XmRbn9uY7fFd73NGF1UJ6t7cX2LWeX7sVae4
        wq8ehNPcZ5cjIimlRl6lmunR+QtAUsVAQDDOvmNJu5Pkh1S7rRWlScu1JHcF7E2G
        I57eY0XnzA5vyt3GHpkbJBQ8Er6S9eCJMVzJ9tPT0+q/2HyoDMknpde3ujuV2XXi
        HcPW4PWdugujw5359bM0sbZho4mwtLRJ7EonBljjpeeyr2O/k+g8R924Pp7T31Lz
        WAfdPdqlHD4pWq04HD4IHoT4bDb6D6EwQWkzNoX5icCic13dhOMM3vx7Trhwhprp
        LOcxAQuf7sXkUY3qcfGFo0U58jjT14i7HSTmC9umYHLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9uHbDy+yscQcQ9si3
        v6fybcJcZoszIfrJ/wKIKt3L5A=; b=i4teDIJhHJ8efm3U7K077V3lHwzV1IoTz
        UzKwl3g5V6G6scim31YbNk/Y4/fLeUPk1asyo6K5NifNdlXo/WHS7bCEldTch1qX
        iEBWMbyVi0AmMLaliHddwgI+sC0eKNNlEwtMxwuOMAbCxdqPUlLHjdr6qx7ieCyt
        ykR6OqgCXJOjQoRwNjttBSs172geXA2UnBci+zB/Z85H9TM9kCoxFBmuh2D9ULDR
        iBhjLyVfxDVRvTEucHfnVDf8BYFv8bACpBTVGU2b78IBgwtMXMrla4Ca1e/s3agP
        lMOYzFrLJAaWrcHE8ScdE8Xk/8svfApEMS+RZw3wbeT7a4GSU96Yw==
X-ME-Sender: <xms:-6MVXWdN7QJE64n8ktEXMj5JlliWhu5oV4VdwwwfjYy39KuwMDa6lA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudelgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefvrghkrghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhi
    sehsrghkrghmohgttghhihdrjhhpqeenucfkphepudegrdefrdejhedrudekudenucfrrg
    hrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhj
    phenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:-6MVXVeIhy5itQyao3MC9YYCpy5UkaoikWCwc1c7vd03CBbOpSOgUQ>
    <xmx:-6MVXZPW-o6iUVImsSMTQT40XEtxMXN-UpdPnny8FRpVRNUz7CsYAg>
    <xmx:-6MVXcJkYrtqJ474UFxx8W1Fs99OMKavdE0OzmWvRjIwwj1K9FBBTQ>
    <xmx:_KMVXaL8xAA6tQISqPY7aVkPfC2Oo20oa9lmrqy1HQYAx19Qlgdvhw>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id D35A080063;
        Fri, 28 Jun 2019 01:22:01 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     clemens@ladisch.de, tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH] ALSA: firewire-lib/fireworks: fix miss detection of received MIDI messages
Date:   Fri, 28 Jun 2019 14:21:58 +0900
Message-Id: <20190628052158.27693-1-o-takashi@sakamocchi.jp>
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

Fixes: df075feefbd3 ("ALSA: firewire-lib: complete AM824 data block processing layer")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/amdtp-am824.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/amdtp-am824.c b/sound/firewire/amdtp-am824.c
index 7019a2143581..623d014c0e7e 100644
--- a/sound/firewire/amdtp-am824.c
+++ b/sound/firewire/amdtp-am824.c
@@ -321,7 +321,7 @@ static void read_midi_messages(struct amdtp_stream *s,
 	u8 *b;
 
 	for (f = 0; f < frames; f++) {
-		port = (s->data_block_counter + f) % 8;
+		port = (8 - s->ctx_data.tx.first_dbc + s->data_block_counter + f) % 8;
 		b = (u8 *)&buffer[p->midi_position];
 
 		len = b[0] - 0x80;
-- 
2.20.1

