Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F1559A162
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350135AbiHSPrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350158AbiHSPqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:46:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA35BCBD;
        Fri, 19 Aug 2022 08:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1554615E9;
        Fri, 19 Aug 2022 15:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E303CC433D6;
        Fri, 19 Aug 2022 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923993;
        bh=t8aBSXZyR6pXAwCE1GwGbstpS9XP3hAfI2b0z8JcBWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CeYe3O/uEVLAEyFRu2y+FvKe6VUyYvq3RsKeV+oY3SVhX/zXnSzSOU6TJrRmMHu9
         ro2H5nYweBlXYmetk7+hun0QQT1yQ7Aca6vkTn1ggi0rVEvXLED4dzV9lu7XCiDEHz
         kG4nAm6cdaWm9uCzSnyxohDCSodycQNtViYpfrmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ivan Hasenkampf <ivan.hasenkampf@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 007/545] ALSA: hda/realtek: Add quirk for HP Spectre x360 15-eb0xxx
Date:   Fri, 19 Aug 2022 17:36:17 +0200
Message-Id: <20220819153829.497232391@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Hasenkampf <ivan.hasenkampf@gmail.com>

commit 24df5428ef9d1ca1edd54eca7eb667110f2dfae3 upstream.

Fixes speaker output on HP Spectre x360 15-eb0xxx

[ re-sorted in SSID order by tiwai ]

Signed-off-by: Ivan Hasenkampf <ivan.hasenkampf@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220803164001.290394-1-ivan.hasenkampf@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8790,6 +8790,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
+	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8720, "HP EliteBook x360 1040 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),


