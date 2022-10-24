Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4D060AA2A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiJXNb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbiJXN3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:29:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C586023EB3;
        Mon, 24 Oct 2022 05:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DCEBB8120C;
        Mon, 24 Oct 2022 12:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D4AC433D6;
        Mon, 24 Oct 2022 12:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613153;
        bh=zYHr4P+Jmp1mLYC0rOmvELARsSLzzPB5Ak6CnrGfpqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKvJproCMF+9M1Ism5N2zvz8B2ElFAm7tIOEwTCS54HeubVpYeJ7SB4e1lu4lZVZa
         rnJsEIoqUK6pyFWzFgUaPQ1t+Tj0PLgvuca/cjjBETcvIluaYfFx57Sz19bLWhRAYd
         d5g+CR4D2tbwJdPbnnYKMbXIVdUgs2tFBXLaPSSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saranya Gopal <saranya.gopal@intel.com>,
        Ninad Naik <ninad.naik@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 008/255] ALSA: hda/realtek: Add Intel Reference SSID to support headset keys
Date:   Mon, 24 Oct 2022 13:28:38 +0200
Message-Id: <20221024113002.729854973@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -8302,6 +8302,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x10ec, 0x1230, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1252, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1254, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),


