Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A9A59E068
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357004AbiHWLJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357039AbiHWLIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:08:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1D48709F;
        Tue, 23 Aug 2022 02:16:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E6ACB81C85;
        Tue, 23 Aug 2022 09:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A38C433C1;
        Tue, 23 Aug 2022 09:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246157;
        bh=4Gyvd+hSemj/t2Aj6GxH9n5af81P84czFCf1nA5WxL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtHs+py1s8OkTm+GeJGdQRZTo2qZ4TKKxL3ZtxNbB0pg77iFmAM8ZdB5XLo8xWCHF
         GQgXVd8MoqdF45B1hwk8aJl1R71J6ToKYJq8R+jKgCkQ9CWgnEFllBEH+qNNpmRr3U
         ggR2dRJ+SIFYrZlKfQlP09SvGvkrGWlSnxrT6jR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Ballway <ballway@chromium.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 020/389] ALSA: hda/cirrus - support for iMac 12,1 model
Date:   Tue, 23 Aug 2022 10:21:38 +0200
Message-Id: <20220823080116.550258333@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -396,6 +396,7 @@ static const struct snd_pci_quirk cs420x
 
 	/* codec SSID */
 	SND_PCI_QUIRK(0x106b, 0x0600, "iMac 14,1", CS420X_IMAC27_122),
+	SND_PCI_QUIRK(0x106b, 0x0900, "iMac 12,1", CS420X_IMAC27_122),
 	SND_PCI_QUIRK(0x106b, 0x1c00, "MacBookPro 8,1", CS420X_MBP81),
 	SND_PCI_QUIRK(0x106b, 0x2000, "iMac 12,2", CS420X_IMAC27_122),
 	SND_PCI_QUIRK(0x106b, 0x2800, "MacBookPro 10,1", CS420X_MBP101),


