Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0D639C6F9
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 11:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhFEJMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 05:12:49 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:52201 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229881AbhFEJMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 05:12:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4C3231637;
        Sat,  5 Jun 2021 05:11:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 05 Jun 2021 05:11:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=+FG/mfjNYGqXJsfYEvOqtoj5X2
        IszAKf/IZh5lLmLGo=; b=rQwjE36QY+7onJt+vSIPsx1Gjg3tbHbWDa4uM7ZvNb
        rhSiR8Nj2OWq0Rcu+Jqb1hwjESwfRt4fiBzXMUYfkjPQXcGJHybMj6dYopmw+AD3
        S8EbRkrofUfy7F8srjaKwATXdr5gFdBuJmInGoY0HRLuC6bkUj5ce2n/ud0eJsEW
        c4OEXqqgeKbjNUsdbDuF5OlIft6ARCO/0BX89wzeTFxM5SULxro8yMSmzMRtLoFi
        wuFp2gqq+/oJ8YeAsj8RrYlUZahmumlByO1pHXnf+T3BJENCrYJ/YxTur4upnkV2
        T3XjJcmd/tvcCR/Nbo8V+m38LN7EV6wzaRSa6XFWf4vQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+FG/mfjNYGqXJsfYE
        vOqtoj5X2IszAKf/IZh5lLmLGo=; b=U0xCjimJ5/V8MHq78dUdDTproPSXEOLKs
        nXEb0oKzBtPewR79Pey0zB/r+TbA/oCs01Bcv9vbcGAtWPiPZk1KFs7ZOpbm1ew2
        tedsCdZhs3nJ84YTHF2mT2wtZNzEb9Cyt6GC+f9/V0Xybz+4r7ULB+Aj6SExud4C
        qcKWpaaU2mc0Z6tJUQeZZsFJZ/us0uxfjNcyHmwAQiGnIWu1Bj/FZHQEVhfvlwWQ
        vaw09UemWhAFrCjUv0xSB/p51aOn0LCt5UVhFp2cwBAtGVtKhL16U3GDPBL/wjN9
        XOMqhccvI5+sxh0XzXIVfxZDRaf+mL4KMjrXkmCApPR5gcekpPPyw==
X-ME-Sender: <xms:oz-7YPH9KKIp18xVZvgEfoYKgq2zPeMd3OMhAz-sVJRavOKiAXIXEQ>
    <xme:oz-7YMXBvD_EVATh_DHqJp3lx4MFPhl0ScIj5Gfqgpr_Wc1DL5Zf_ypXcJuGTiON_
    XLbgHzr4Avq9ye8Fpg>
X-ME-Received: <xmr:oz-7YBLXcSj49XpwztsFucSKwD6gqw7eNSL00eJFhFd1RlG62boPHwr6frLJCzsK_BAFgGUz2migOgk1ZJV8fHfi2Gg7l7mYOkOysx_Kz_tWfWxu7jxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtfedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepudejteelhfdttd
    ekgfdtueeilefhgfetjeejheekgeevuddvveegieehueeukeejnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkh
    grmhhotggthhhirdhjph
X-ME-Proxy: <xmx:oz-7YNEqLqU-p5JrtFHg6Kcz8455dqNgh5A2cdtLtXakL2VfoqpCig>
    <xmx:oz-7YFXFD8KgrwEKkl2-UFeyZ0BwUAVNZKusamoDW7Atflz2HzMKSw>
    <xmx:oz-7YIP_Q-2Kv-MnYU3jS2CoBtfyQD2AJQgOmWWy2ZnMf5HknIq0Sw>
    <xmx:pD-7YChIrNztOubValKN-G4kvcWl_HrSKS3uQoTITdXyI-0xchJnGg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 5 Jun 2021 05:10:58 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: firewire-lib: fix the context to call snd_pcm_stop_xrun()
Date:   Sat,  5 Jun 2021 18:10:54 +0900
Message-Id: <20210605091054.68866-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the workqueue to queue wake-up event, isochronous context is not
processed, thus it's useless to check context for the workqueue to switch
status of runtime for PCM substream to XRUN. On the other hand, in
software IRQ context of 1394 OHCI, it's needed.

This commit fixes the bug introduced when tasklet was replaced with
workqueue.

Cc: <stable@vger.kernel.org>
Fixes: 2b3d2987d800 ("ALSA: firewire: Replace tasklet with work")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/amdtp-stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/amdtp-stream.c b/sound/firewire/amdtp-stream.c
index 945597ffacc2..19c343c53585 100644
--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -1032,7 +1032,7 @@ static void generate_pkt_descs(struct amdtp_stream *s, const __be32 *ctx_header,
 static inline void cancel_stream(struct amdtp_stream *s)
 {
 	s->packet_index = -1;
-	if (current_work() == &s->period_work)
+	if (in_interrupt())
 		amdtp_stream_pcm_abort(s);
 	WRITE_ONCE(s->pcm_buffer_pointer, SNDRV_PCM_POS_XRUN);
 }
-- 
2.27.0

