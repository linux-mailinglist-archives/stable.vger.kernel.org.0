Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF75138D50
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 09:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgAMI5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 03:57:25 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47317 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727325AbgAMI5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 03:57:25 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C8A3621D28;
        Mon, 13 Jan 2020 03:57:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 13 Jan 2020 03:57:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=TDCPsxrYqs//WyL2k7ckPOpBjU
        qhsO9I3Xy7BwtRXHU=; b=o4qduLEuWCxaqPOdqosajxkG2qqiJDQYn/VGVPpQ6I
        NwAskyR0BANAdScDv5H4pRjQ8lRNt0a0FjWnsuEeqyTBY/OBYiPIV+BTPUOlQDEw
        dKBR/G8Ov+LN6K8AKbx2iPGPa6hcfG//A07Z5ViaVRjgnWQeGZeVs+GGrKLqqBek
        iZ5bjHVMnjn0hmDBZ/AE+YsRtO1bI3aEscLNzkDHyszTmE+22n0SUQldjec2BIw9
        a1jXNu7FtRhs9Hjq24CvPNZ6PKRJJqBwvOvtK2pJhau1+zixrk63kl3j1Tw3uTdZ
        1qE9UrEPwYaJ2m3bAdAnqlzQ/Eg0+mkDOfq5SSCfx5Tg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TDCPsxrYqs//WyL2k
        7ckPOpBjUqhsO9I3Xy7BwtRXHU=; b=jArVN7Q0KfoLbRxKl05WuTyenawNBcHQ4
        Fe3HgHVAyvBquXocFYwlT7YoVH5OHVzJFK/j2I/M6BMpdO8ICEJqZv4KYLzQRh0N
        1AqWK4f7WkXDRiSWbWdAUKPjA9JcjlRwmntr9kATTBb7OteiJh68CVd0xP5IIv9I
        IVIzPaQqnsa+O2A+lAo5ysqplaBgtEl24DrT5KMQiYhsqR8ObRhDAAvUvwDljkLy
        u2pn6gdgMU4IHIVPRPeYA7x8LsmT/jf4O++GqMlvnRkIOAfL96BxBgiju3blIqMl
        Z8PE1AY2AY5eoVbo6/Zuk8/jfU6gQIfghO97k2hHqZGb0GNcbw1fQ==
X-ME-Sender: <xms:8jAcXkfhShS44yOfLYxlMoqG4MAe095fgSTQLETPBJkY4on2u1MueA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiledguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepvfgrkhgrshhh
    ihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
    eqnecukfhppedugedrfedrjeehrddukedunecurfgrrhgrmhepmhgrihhlfhhrohhmpeho
    qdhtrghkrghshhhisehsrghkrghmohgttghhihdrjhhpnecuvehluhhsthgvrhfuihiivg
    eptd
X-ME-Proxy: <xmx:8jAcXrNS4W_PffB0M-sXDg_cl0bU8fSpjw7HdQeJpTNQQSkq-hcPbQ>
    <xmx:8jAcXmbPraWpH6HcbRnGAb1CWDUE3tq77xLQyD1AK6OHXb1DOg-xjQ>
    <xmx:8jAcXvs1HS66U-CFkKCWEJB3OGXKqVsmpv8DNOGI6I9R40VLBEH-Iw>
    <xmx:8zAcXqH04VTojGRs39UIqMm2yRbNhqcfkaPFxXY5UHmOiJHpV_3TnA>
Received: from workstation.flets-east.jp (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9967D8005C;
        Mon, 13 Jan 2020 03:57:21 -0500 (EST)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     alsa-devel@alsa-project.org, Scott Bahling <sbahling@suse.com>,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: firewire-tascam: fix corruption due to spin lock without restoration in SoftIRQ context
Date:   Mon, 13 Jan 2020 17:57:19 +0900
Message-Id: <20200113085719.26788-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ALSA firewire-tascam driver can bring corruption due to spin lock without
restoration of IRQ flag in SoftIRQ context. This commit fixes the bug.

Cc: Scott Bahling <sbahling@suse.com>
Cc: <stable@vger.kernel.org> # v4.21
Fixes: d7167422433c ("ALSA: firewire-tascam: queue events for change of control surface")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/tascam/amdtp-tascam.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/tascam/amdtp-tascam.c b/sound/firewire/tascam/amdtp-tascam.c
index e80bb84c43f6..f823a2ab3544 100644
--- a/sound/firewire/tascam/amdtp-tascam.c
+++ b/sound/firewire/tascam/amdtp-tascam.c
@@ -157,14 +157,15 @@ static void read_status_messages(struct amdtp_stream *s,
 			if ((before ^ after) & mask) {
 				struct snd_firewire_tascam_change *entry =
 						&tscm->queue[tscm->push_pos];
+				unsigned long flag;
 
-				spin_lock_irq(&tscm->lock);
+				spin_lock_irqsave(&tscm->lock, flag);
 				entry->index = index;
 				entry->before = before;
 				entry->after = after;
 				if (++tscm->push_pos >= SND_TSCM_QUEUE_COUNT)
 					tscm->push_pos = 0;
-				spin_unlock_irq(&tscm->lock);
+				spin_unlock_irqrestore(&tscm->lock, flag);
 
 				wake_up(&tscm->hwdep_wait);
 			}
-- 
2.20.1

