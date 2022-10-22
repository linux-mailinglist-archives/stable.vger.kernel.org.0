Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5581E6085B2
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiJVHhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiJVHgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:36:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4658F2498A8;
        Sat, 22 Oct 2022 00:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A824CE1D33;
        Sat, 22 Oct 2022 07:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89397C433D6;
        Sat, 22 Oct 2022 07:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424126;
        bh=78i/cgAWTbQkSXWQ+NR65kH4S/tabs/wimPBpwk6rOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oa2kFztiO2AQDL3JCXftYywb+Ag4A0Lvblvsc+rTK4fKTv/632lKNUpB7EVl+HkBz
         lz2zSLb8v1gt4GxOxYxPlX+fz1jW0GDuaR6fe/FFFNUxC1rGnVeSa/yGMq6AYsi69Y
         wCdE8vmjuq6zcku+XIYl+R64lE8bVoJLdZo/FY08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saranya Gopal <saranya.gopal@intel.com>,
        Ninad Naik <ninad.naik@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 009/717] ALSA: hda/realtek: Add Intel Reference SSID to support headset keys
Date:   Sat, 22 Oct 2022 09:18:08 +0200
Message-Id: <20221022072416.724433893@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saranya Gopal <saranya.gopal@intel.com>

commit 4f2e56a59b9947b3e698d3cabcb858765c12b1e8 upstream.

This patch fixes the issue with 3.5mm headset keys
on RPL-P platform.

[ Rearranged the entry in SSID order by tiwai ]

Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
Signed-off-by: Ninad Naik <ninad.naik@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221011044916.2278867-1-saranya.gopal@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9398,6 +9398,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x10ec, 0x1230, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1252, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1254, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),


