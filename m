Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7440868D7EE
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjBGNEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjBGNEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:04:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973AE3A852
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3361461358
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C678C433EF;
        Tue,  7 Feb 2023 13:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775058;
        bh=W8LzfYwBHWkCgzq/1VsMk6yZEviYsKZDynuA1IxVJ/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTCvSGsECrclOSuHiHbpic7CCxJA+ZCwftIzZkiT0sQajmskGNSUy2zKHDeZM6rb9
         WCCZ9xb0/HcL3FJaDWKh4E6EL1d/nype9O+1EU8N4vUqbh474ZUIb/e8/RWgS0ZT7T
         rzfuJmhuEQfla99yCSD9b/SlnDweimzMT/chRPuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Victor Shyba <victor1984@riseup.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 124/208] ALSA: hda/realtek: Add Acer Predator PH315-54
Date:   Tue,  7 Feb 2023 13:56:18 +0100
Message-Id: <20230207125640.016799479@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Shyba <victor1984@riseup.net>

commit 6a28a25d358079b7d0d144689f850aecacf63cba upstream.

Same issue as SP513-54N: Headset microphone does not work without
ALC255_FIXUP_ACER_MIC_NO_PRESENCE fixup.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211853
Cc: <stable@vger.kernel.org>
Signed-off-by: Victor Shyba <victor1984@riseup.net>
Link: https://lore.kernel.org/r/20230123222129.17589-1-victor1984@riseup.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9202,6 +9202,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),


