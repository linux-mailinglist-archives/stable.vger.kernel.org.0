Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D2F593C1A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbiHOUOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243473AbiHOUJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:09:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5627844D1;
        Mon, 15 Aug 2022 11:56:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D1A26123D;
        Mon, 15 Aug 2022 18:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95DAC43142;
        Mon, 15 Aug 2022 18:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589769;
        bh=5T9sZsUjVjATFoJV6q2ZZ2gMz8QuQmNVK0O3y/brn4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBwgeNjsWhISEosYxjGbSRoh1CQm5wBA2QAZBolGp3+12cDSQYxwuGEst/kgs0dgm
         K+Fh/S3Z3LUtR0VOZsOrfwYSCeROpFsHerEc285xhU8dBjhjvSf2KeICcV3qFTKpVf
         D3rSHR41kSw3iFVKLCCv/z2fIohsRHP40iqP3Rp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Ballway <ballway@chromium.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 0043/1095] ALSA: hda/cirrus - support for iMac 12,1 model
Date:   Mon, 15 Aug 2022 19:50:42 +0200
Message-Id: <20220815180431.225529328@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Allen Ballway <ballway@chromium.org>

commit 74bba640d69914cf832b87f6bbb700e5ba430672 upstream.

The 12,1 model requires the same configuration as the 12,2 model
to enable headphones but has a different codec SSID. Adds
12,1 SSID for matching quirk.

[ re-sorted in SSID order by tiwai ]

Signed-off-by: Allen Ballway <ballway@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220810152701.1.I902c2e591bbf8de9acb649d1322fa1f291849266@changeid
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_cirrus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -395,6 +395,7 @@ static const struct snd_pci_quirk cs420x
 
 	/* codec SSID */
 	SND_PCI_QUIRK(0x106b, 0x0600, "iMac 14,1", CS420X_IMAC27_122),
+	SND_PCI_QUIRK(0x106b, 0x0900, "iMac 12,1", CS420X_IMAC27_122),
 	SND_PCI_QUIRK(0x106b, 0x1c00, "MacBookPro 8,1", CS420X_MBP81),
 	SND_PCI_QUIRK(0x106b, 0x2000, "iMac 12,2", CS420X_IMAC27_122),
 	SND_PCI_QUIRK(0x106b, 0x2800, "MacBookPro 10,1", CS420X_MBP101),


