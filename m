Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8C37B893
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhELIwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:52:17 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:35695 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230137AbhELIwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:52:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3E7A3445;
        Wed, 12 May 2021 04:51:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NgsykN
        g+NFe2Eu7TxWyy3vETjky5YsdH8vIbGZPoYwU=; b=EqzWPwrSRLxXrwkLUsgQed
        G3lniaPtYl9VP1Xhtegji6EByrng7dKEdZLboyDPFCKQqnQIYVLwZb33Ina4Dzc2
        Kh4OveNconXau3wbYRgyG/3d3yUMCBmDebN9Uyp796fkcaUJz/Sm5AaTDa6XHhEn
        GSDLDpgHiIDWOm7PSOTtP1yzAodBEqVWEzHZHpGOelne6GL5zii0GuLOsRoegukv
        hhL0HFeRL/GflbIBKKXA7gBhRO+DfHSOwO5Hn9lFZZ2f4lv61acKxpUq86GuCeh7
        Qq8Qq6PoKYBlQwD8ziBoD+yx/iG2jPK1XOLIUe/4H3cT1wlnhynNUHEddsvDERPw
        ==
X-ME-Sender: <xms:_JabYIqFlk4mTZVYn0SR0_gQkkw0lKVbGP8iFrj41ixENJ5ywIy9EA>
    <xme:_JabYOrzPsG4WWqxXBosWpWA6oI9mov684MjSkq76SPsOBIHaDjo4uLJwZ2_M6EMC
    V1Y_bOOrkT0Ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_JabYNNuCpazLfXY3PnmJ2jo7ZP9gx82EcoelizVeRYI7qhIwoOWxw>
    <xmx:_JabYP4taquzSG_Q1VfCxOy4I42y-IX1LGMk_gu8ltlBGAM_Sq3Pqw>
    <xmx:_JabYH6N80fr42WxjKsKikDiM3KAHwVGxWXSlTXXPsNqOdFGWDDwKA>
    <xmx:_JabYAX6MQnjzxCQzqwtcKJRcIgNLdVFCoLraTu6-r6jRYvd27nMHQLyfqc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:51:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] platform/x86: intel-vbtn: Stop reporting SW_DOCK events" failed to apply to 5.12-stable tree
To:     hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:51:06 +0200
Message-ID: <162080946671117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2728f39dfc720983e2b69f0f1f0c403aaa7c346f Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 21 Mar 2021 17:35:13 +0100
Subject: [PATCH] platform/x86: intel-vbtn: Stop reporting SW_DOCK events

Stop reporting SW_DOCK events because this breaks suspend-on-lid-close.

SW_DOCK should only be reported for docking stations, but all the DSDTs in
my DSDT collection which use the intel-vbtn code, always seem to use this
for 2-in-1s / convertibles and set SW_DOCK=1 when in laptop-mode (in tandem
with setting SW_TABLET_MODE=0).

This causes userspace to think the laptop is docked to a port-replicator
and to disable suspend-on-lid-close, which is undesirable.

Map the dock events to KEY_IGNORE to avoid this broken SW_DOCK reporting.

Note this may theoretically cause us to stop reporting SW_DOCK on some
device where the 0xCA and 0xCB intel-vbtn events are actually used for
reporting docking to a classic docking-station / port-replicator but
I'm not aware of any such devices.

Also the most important thing is that we only report SW_DOCK when it
reliably reports being docked to a classic docking-station without any
false positives, which clearly is not the case here. If there is a
chance of reporting false positives then it is better to not report
SW_DOCK at all.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321163513.72328-1-hdegoede@redhat.com

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 8a8017f9ca91..3fdf4cbec9ad 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -48,8 +48,16 @@ static const struct key_entry intel_vbtn_keymap[] = {
 };
 
 static const struct key_entry intel_vbtn_switchmap[] = {
-	{ KE_SW,     0xCA, { .sw = { SW_DOCK, 1 } } },		/* Docked */
-	{ KE_SW,     0xCB, { .sw = { SW_DOCK, 0 } } },		/* Undocked */
+	/*
+	 * SW_DOCK should only be reported for docking stations, but DSDTs using the
+	 * intel-vbtn code, always seem to use this for 2-in-1s / convertibles and set
+	 * SW_DOCK=1 when in laptop-mode (in tandem with setting SW_TABLET_MODE=0).
+	 * This causes userspace to think the laptop is docked to a port-replicator
+	 * and to disable suspend-on-lid-close, which is undesirable.
+	 * Map the dock events to KEY_IGNORE to avoid this broken SW_DOCK reporting.
+	 */
+	{ KE_IGNORE, 0xCA, { .sw = { SW_DOCK, 1 } } },		/* Docked */
+	{ KE_IGNORE, 0xCB, { .sw = { SW_DOCK, 0 } } },		/* Undocked */
 	{ KE_SW,     0xCC, { .sw = { SW_TABLET_MODE, 1 } } },	/* Tablet */
 	{ KE_SW,     0xCD, { .sw = { SW_TABLET_MODE, 0 } } },	/* Laptop */
 	{ KE_END }

