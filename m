Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50399593D57
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiHOUE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345851AbiHOUEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:04:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EC47E811;
        Mon, 15 Aug 2022 11:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 732B3B810A1;
        Mon, 15 Aug 2022 18:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C2BC433D6;
        Mon, 15 Aug 2022 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589664;
        bh=IRM5qCrAuEhQTcKNPhCPmPKbR9Vm7+BGI5WzTw2siqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4ZDrzb2CY5pYGBBiBrNkFvuURtv7jgoErxz5o661zLIDIBDkekuvAxaIgHzWXRgW
         +qgMbF3s+RrbmpTYVwbP/dDg+xE9Ww7CU5Zh/l4mClHBaWMR0ku6vxWdiRTDNzFj0x
         KKwbkq93dqIEAO0TDsDC2VXMWJpvH9KpB8r7i/uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Crawford <tcrawford@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 0010/1095] ALSA: hda/realtek: Add quirk for Clevo NV45PZ
Date:   Mon, 15 Aug 2022 19:50:09 +0200
Message-Id: <20220815180429.741750838@linuxfoundation.org>
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

From: Tim Crawford <tcrawford@system76.com>

commit be561ffad708f0cee18aee4231f80ffafaf7a419 upstream.

Fixes headset detection on Clevo NV45PZ.

Signed-off-by: Tim Crawford <tcrawford@system76.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220731032243.4300-1-tcrawford@system76.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9255,6 +9255,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x4018, "Clevo NV40M[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4019, "Clevo NV40MZ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4020, "Clevo NV40MB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x4041, "Clevo NV4[15]PZ", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x40a1, "Clevo NL40GU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x40c1, "Clevo NL40[CZ]U", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x40d1, "Clevo NL41DU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


