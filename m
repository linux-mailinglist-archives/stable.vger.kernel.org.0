Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C90E5EA383
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbiIZL0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiIZL0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:26:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F3D696E5;
        Mon, 26 Sep 2022 03:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CC3D6091B;
        Mon, 26 Sep 2022 10:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA0EC433C1;
        Mon, 26 Sep 2022 10:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188496;
        bh=IDU0RaCznO9HsX2dm95XQJPDe3KRRx12YYzKczRsJRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JseuXy0Isn3tfriku7cJQp9zTeEGCSTU0oFyGQccz9GRk0SCg3Naq7Iru/Nx8yqIY
         7YV7i67wDg2UTDcVRDkh1cNpZPun4bY/1RZGSsIUrnwWoyF57SrRSOM0uSEJ7ZgyFw
         /xEZ4TDnbawe4HOWM5EoMrosZgxXBwoiR5ykWywA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huangwenhui <huangwenhuia@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 027/148] ALSA: hda/realtek: Add quirk for Huawei WRT-WX9
Date:   Mon, 26 Sep 2022 12:11:01 +0200
Message-Id: <20220926100757.091109117@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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

From: huangwenhui <huangwenhuia@uniontech.com>

commit cbcdf8c4d35cd74aee8581eb2f0453e0ecab7b05 upstream.

Fixes headphone and headset microphone detection on Huawei WRT-WX9.

Signed-off-by: huangwenhui <huangwenhuia@uniontech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220913054622.15979-1-huangwenhuia@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9205,6 +9205,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
+	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
 	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),
 	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),


