Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F09E5EA40F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbiIZLjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238305AbiIZLix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:38:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4261108;
        Mon, 26 Sep 2022 03:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5311260C05;
        Mon, 26 Sep 2022 10:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4037EC433C1;
        Mon, 26 Sep 2022 10:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189088;
        bh=o5v81wX05L5AJeJTH1zhHV+Ku4bmxWuYIuMAGDLZUiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJG0f1niT+RxdCmdg7DRLeEmjaOgv8sJOZ7X3qpucrTIvo061o6J+c0ztAy5I/LjB
         oLEPsv7Y4Zj86KD56tXaEcgKlUn+L9eUAFaegs8Wgs57DShwm45ulscbWF8Z5YJHCX
         5dX7hyJQ84HEJ3E8ADqqxCNZ3uFtfBZj2SBIq5sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Houldsworth <dhould3@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 038/207] ALSA: hda/realtek: Add a quirk for HP OMEN 16 (8902) mute LED
Date:   Mon, 26 Sep 2022 12:10:27 +0200
Message-Id: <20220926100808.323920701@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Houldsworth <dhould3@gmail.com>

commit 496322302bf1e58dc2ff134173527493105f51ab upstream.

Similair to the HP OMEN 15, the HP OMEN 16 also needs
ALC285_FIXUP_HP_MUTE_LED for the mute LED to work.

[ Rearranged the entry in PCI SSID order by tiwai ]

Signed-off-by: Daniel Houldsworth <dhould3@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220918171300.24693-1-dhould3@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9279,6 +9279,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x896e, "HP EliteBook x360 830 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8971, "HP EliteBook 830 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8972, "HP EliteBook 840 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


