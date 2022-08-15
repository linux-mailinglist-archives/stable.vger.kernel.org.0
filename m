Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C4559423A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349267AbiHOVry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349217AbiHOVoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:44:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB80B1022BC;
        Mon, 15 Aug 2022 12:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03F2260EF0;
        Mon, 15 Aug 2022 19:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06408C433D6;
        Mon, 15 Aug 2022 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591796;
        bh=OZMGZ+zAfhth2Zc71by5JTqmTKqavg8WiA85C9vKwW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJe+6YUW6eNZUpWNYHbhYbnbnyIxja2PYFhje/fsEh+CEk79xLop2KJWWdehJFamr
         DqT82hEUuAaTURrywlc4uWBQPq7hG60AO9XPSYa18BMbHal0EcyMMKb2Zl0xdDoUOm
         lSrodhsZxMFHRh2BJDxqaqh6oynnEjmOiix0Qdx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ivan Hasenkampf <ivan.hasenkampf@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 0010/1157] ALSA: hda/realtek: Add quirk for HP Spectre x360 15-eb0xxx
Date:   Mon, 15 Aug 2022 19:49:26 +0200
Message-Id: <20220815180439.871408375@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
@@ -9044,6 +9044,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
+	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8720, "HP EliteBook x360 1040 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),


