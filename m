Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3458063D644
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 14:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiK3NGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 08:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiK3NGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 08:06:15 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00402B871
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 05:06:13 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AAD15C00C7;
        Wed, 30 Nov 2022 08:06:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 30 Nov 2022 08:06:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1669813570; x=1669899970; bh=n03KMEO/9c
        voahW97c3DR62dVdR1Q9sWEupAej+/YVg=; b=k++w+PQKrX8BdFqoW3W2G5FoFG
        qxBzT0hxPE56ua4Et/4/kY4ZsMELTrFhzWUFw9XiLCxDbzt5VIn5QsjNnAqfpZH6
        wAwuKWpcL1y2PVqG7gECpgMJAzoSlvkfi6M1uF7udxuIq6L0Recfg6I/ZxjjfAhi
        0L8+v0sN/KWJ7P0fjopNSqa/dgNTCqf6Og+WGnL9FwCwkuw0JcJFt8TXcYh62HXg
        RKZ9JmpKr7RgJ/gqBgAmZ7bZZWrgfTX4HENhdKl1TgAG35gypz4GfZRdoBOzgE48
        t6GTvk2VKagS05t9IxHiOPrQbRDMHXvqFZF6XRV7N0/t/HrtpOfUGSVxouNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1669813570; x=1669899970; bh=n03KMEO/9cvoahW97c3DR62dVdR1Q9sWEup
        Aej+/YVg=; b=Nl5EY1Wh3Kqa0SiWfYTWBgjLcSUv5ULU0VdZ0Ptzzx4N/w/b9Ku
        d0pwadUGAYNSRYJUuVwcCD38aUznOfUVKjRnegevH1LsZZB5XEKIrl7jJfENG3kv
        ojYMS6r7dIvWFVcIV7/fN7hJquALi/Cqi08MRnOsbXVpiLlvbTX7FtobuGh38Xjf
        BnUdfWldmTaQF9X3PCRvw5gGnu3K/WTA0I3bxuzvMWkowl86Ze0RBJXsaFalIql9
        dud5a6UIAQW+TpKUcc+HttchqzHiFqWe9SZrmfxBgMPWUDTY3Tb7TSrKzPBAIqZi
        lobVsOfQxE0u/ukvbv9zbtY/BL0hpvLy0vg==
X-ME-Sender: <xms:QVWHYxyYz_xmXTNlPlrq98pRwb5kyhuoPncRZMaE4mta4XQIMCYbGg>
    <xme:QVWHYxQI0_BXxuqzVwBItGos1pB5NqOiknGYDV3xrLtTnvMggI2qxZDOY7DanEfN3
    QMhPybT9jXiHyKKf1k>
X-ME-Received: <xmr:QVWHY7XA7OTUEeuwHyaIG4IXkY96tJmQGAMoc3LQOERDh-rYFcYIITiU8SxtGdMl60gpoTZna6yU9e4ourjlFUn2XFQx4FVJQaJfsxPP_GuK0p9yQj-PpmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrtdefgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgggfestdekredtre
    dttdenucfhrhhomhepvfgrkhgrshhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhh
    ihesshgrkhgrmhhotggthhhirdhjpheqnecuggftrfgrthhtvghrnhepffdvueelffevke
    duhfetjeduffeghfettdfguedtgfdvgfeufeduheevheevkeeknecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkh
    grmhhotggthhhirdhjph
X-ME-Proxy: <xmx:QVWHYzgXsA_ATLH2IS0uOIZaU25mkL9x6t1lv73-I1m2EwZR9xb8pQ>
    <xmx:QVWHYzD3uRYZOA66iFM_ccbjcQpVYgSkThmNjScPyuyb5Z_Z2A96VQ>
    <xmx:QVWHY8L7acKhp9srItPD9lfiqacTraHrPsq2kbUfIiMg2vukrHFu3w>
    <xmx:QlWHY2O6OrXW9td8uz-ioO5utG7YJE9NKxE927HK376QHJU1yjWoPg>
Feedback-ID: ie8e14432:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Nov 2022 08:06:08 -0500 (EST)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     clemens@ladisch.de, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: dice: fix regression for Lexicon I-ONIX FW810S
Date:   Wed, 30 Nov 2022 22:06:04 +0900
Message-Id: <20221130130604.29774-1-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For Lexicon I-ONIX FW810S, the call of ioctl(2) with
SNDRV_PCM_IOCTL_HW_PARAMS can returns -ETIMEDOUT. This is a regression due
to the commit 41319eb56e19 ("ALSA: dice: wait just for
NOTIFY_CLOCK_ACCEPTED after GLOBAL_CLOCK_SELECT operation"). The device
does not emit NOTIFY_CLOCK_ACCEPTED notification when accepting
GLOBAL_CLOCK_SELECT operation with the same parameters as current ones.

This commit fixes the regression. When receiving no notification, return
-ETIMEDOUT as long as operating for any change.

Fixes: 41319eb56e19 ("ALSA: dice: wait just for NOTIFY_CLOCK_ACCEPTED after GLOBAL_CLOCK_SELECT operation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/dice/dice-stream.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/firewire/dice/dice-stream.c b/sound/firewire/dice/dice-stream.c
index f99e00083141..4c677c8546c7 100644
--- a/sound/firewire/dice/dice-stream.c
+++ b/sound/firewire/dice/dice-stream.c
@@ -59,7 +59,7 @@ int snd_dice_stream_get_rate_mode(struct snd_dice *dice, unsigned int rate,
 
 static int select_clock(struct snd_dice *dice, unsigned int rate)
 {
-	__be32 reg;
+	__be32 reg, new;
 	u32 data;
 	int i;
 	int err;
@@ -83,15 +83,17 @@ static int select_clock(struct snd_dice *dice, unsigned int rate)
 	if (completion_done(&dice->clock_accepted))
 		reinit_completion(&dice->clock_accepted);
 
-	reg = cpu_to_be32(data);
+	new = cpu_to_be32(data);
 	err = snd_dice_transaction_write_global(dice, GLOBAL_CLOCK_SELECT,
-						&reg, sizeof(reg));
+						&new, sizeof(new));
 	if (err < 0)
 		return err;
 
 	if (wait_for_completion_timeout(&dice->clock_accepted,
-			msecs_to_jiffies(NOTIFICATION_TIMEOUT_MS)) == 0)
-		return -ETIMEDOUT;
+			msecs_to_jiffies(NOTIFICATION_TIMEOUT_MS)) == 0) {
+		if (reg != new)
+			return -ETIMEDOUT;
+	}
 
 	return 0;
 }
-- 
2.37.2

