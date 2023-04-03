Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6BB6D491B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbjDCOfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbjDCOfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9116CE47
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E0F061E64
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824B9C433EF;
        Mon,  3 Apr 2023 14:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532486;
        bh=78MDaKVa6fl3R2GhVwVNkKrjOXBnd943gK41h6oEQtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfASKx6TnADbdJp8MJLNdpRfpo139Qdcy1raVzhCfh504IMCh57ODg7q719lC1Hn2
         KHOWFyViKivlhVrFkg8vI3cZdyKpTZvxntDcyKMouX+Uwyz236T6JYnVFoHX+JDUhW
         yj/kPcL5wGcYWgF94ilvHWMJZKAs6SgThum3NNrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, huangwenhui <huangwenhuia@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 83/99] ALSA: hda/realtek: Add quirk for Lenovo ZhaoYang CF4620Z
Date:   Mon,  3 Apr 2023 16:09:46 +0200
Message-Id: <20230403140406.528130427@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: huangwenhui <huangwenhuia@uniontech.com>

commit 52aad39385e1bfdb34a1b405f699a8ef302c58b0 upstream.

Fix headset microphone detection on Lenovo ZhaoYang CF4620Z.

[ adjusted to be applicable to the latest tree -- tiwai ]

Signed-off-by: huangwenhui <huangwenhuia@uniontech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230328074644.30142-1-huangwenhuia@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9332,6 +9332,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x511e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
+	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),


