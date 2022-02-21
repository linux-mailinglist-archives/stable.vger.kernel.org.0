Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277C14BE9AC
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352067AbiBUJwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:52:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352123AbiBUJvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:51:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93E013E20;
        Mon, 21 Feb 2022 01:22:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55E62CE0E80;
        Mon, 21 Feb 2022 09:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F70C340E9;
        Mon, 21 Feb 2022 09:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435371;
        bh=XHeZTLhOEsGIZMErWZ33p31NioQ7wMoUH7X7H5dXHEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDi1bKwFpZYT+GY+R9/qRONxtv+0JgpYjyZOMtnRf/tWYat/rG6OUKiU3TuVFZrTn
         LVSiiNclasINPsZvnERy6cuUzfyPZe9Uc9+X2n/9oM5LGS7wvJMRJyxX8zV68fiv11
         sAhbgq60p76ki+dVZeMusH04j0vOVbJwW2C6t/dI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Huang <diwang90@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 139/227] ALSA: hda/realtek: Add quirk for Legion Y9000X 2019
Date:   Mon, 21 Feb 2022 09:49:18 +0100
Message-Id: <20220221084939.466504140@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Yu Huang <diwang90@gmail.com>

commit c07f2c7b45413a9e50ba78630fda04ecfa17b4f2 upstream.

Legion Y9000X 2019 has the same speaker with Y9000X 2020,
but with a different quirk address. Add one quirk entry
to make the speaker work on Y9000X 2019 too.

Signed-off-by: Yu Huang <diwang90@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220212160835.165065-1-diwang90@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9013,6 +9013,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3824, "Legion Y9000X 2020", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x383d, "Legion Y9000X 2019", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),


