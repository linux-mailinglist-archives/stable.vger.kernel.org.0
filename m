Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85A555D7FA
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbiF0LW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbiF0LW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1DB654D;
        Mon, 27 Jun 2022 04:22:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB4CD6144F;
        Mon, 27 Jun 2022 11:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BF3C3411D;
        Mon, 27 Jun 2022 11:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656328976;
        bh=nBhjCPGpSeo3MHttf5t9TyBcvWOO6HTWCsIE0qzL+aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLFiCNN9gL0HyPDVdQgsLG+MXDOmFWD5qGT14ASSY6mEYbeSxtDgG2NoTbIo3tNB1
         kVutWx0Xd685A2fx7luGAQktpVE9kXlTFITp4h+KMEblbxHjGCbUn7FDPlHeJTVnda
         OoekIZXuHT7kBe4teUPqIJ/I10JRfaarCIB7xgQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Crawford <tcrawford@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 010/102] ALSA: hda/realtek: Add quirk for Clevo NS50PU
Date:   Mon, 27 Jun 2022 13:20:21 +0200
Message-Id: <20220627111933.769964022@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Crawford <tcrawford@system76.com>

commit 627ce0d68eb4b53e995b08089fa9da1e513ec5ba upstream.

Fixes headset detection on Clevo NS50PU.

Signed-off-by: Tim Crawford <tcrawford@system76.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220622150017.9897-1-tcrawford@system76.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8933,6 +8933,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x70f3, "Clevo NH77DPQ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f4, "Clevo NH77EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f6, "Clevo NH77DPQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x7716, "Clevo NS50PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8228, "Clevo NR40BU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8520, "Clevo NH50D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8521, "Clevo NH77D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


