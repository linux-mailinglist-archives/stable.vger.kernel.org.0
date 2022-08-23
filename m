Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E8359E27A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353588AbiHWKR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353601AbiHWKPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:15:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE1573938;
        Tue, 23 Aug 2022 02:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1A1061524;
        Tue, 23 Aug 2022 09:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080E6C433D6;
        Tue, 23 Aug 2022 09:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245230;
        bh=aQR3DJEg3kHfSmbwMTdsmvUZ/TBQcuNlem3MABWTKe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LS39ieDq22NIkgo81EoDrQcW3r6/HUDSedlUOmxNtnX26MHlwv3biPssAMpdBh3Um
         ty0k/8mVqDc0iJnBgkT6C3fqq+PCkMeMXGlBqzVVG/MPBlREFclOYmBWRBk1BhANqi
         U10s3rJ9cF0JDrhfRyZ5UlwT5cDCBKF8igFZB+z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Ballway <ballway@chromium.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 013/287] ALSA: hda/cirrus - support for iMac 12,1 model
Date:   Tue, 23 Aug 2022 10:23:02 +0200
Message-Id: <20220823080100.715979477@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
@@ -409,6 +409,7 @@ static const struct snd_pci_quirk cs420x
 
 	/* codec SSID */
 	SND_PCI_QUIRK(0x106b, 0x0600, "iMac 14,1", CS420X_IMAC27_122),
+	SND_PCI_QUIRK(0x106b, 0x0900, "iMac 12,1", CS420X_IMAC27_122),
 	SND_PCI_QUIRK(0x106b, 0x1c00, "MacBookPro 8,1", CS420X_MBP81),
 	SND_PCI_QUIRK(0x106b, 0x2000, "iMac 12,2", CS420X_IMAC27_122),
 	SND_PCI_QUIRK(0x106b, 0x2800, "MacBookPro 10,1", CS420X_MBP101),


