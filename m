Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5665729B3C6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368532AbgJ0Oy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772020AbgJ0OuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:50:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D52E20709;
        Tue, 27 Oct 2020 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810210;
        bh=XQCWAfE6ln7p6SKCp4VKD/q4KHKwVU9LfjNPy2wbA80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKbdyopkZu/MUm+7qNVgvhGpj7fPJHyqmat1JkcicVzR9CSmToM/VQfiHbWZCdMr7
         1XmCNtH09DiTDwzxOHEEMicdAIvaLPemvhbeAsUb0/5Nkz5zT6TJBsjZuhC638372T
         bf5Q0QzzoyokP1s7jJrlwm1NRtHr1MNfLxRt8eIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiu Wenbo <qiuwenbo@kylinos.com.cn>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 060/633] ALSA: hda/realtek - Add mute Led support for HP Elitebook 845 G7
Date:   Tue, 27 Oct 2020 14:46:43 +0100
Message-Id: <20201027135525.512329831@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiu Wenbo <qiuwenbo@kylinos.com.cn>

commit 08befca40026136c14c3cd84f9e36c4cd20a358e upstream.

After installing archlinux, the mute led and micmute led are not working
at all. This patch fix this issue by applying a fixup from similar
model. These mute leds are confirmed working on HP Elitebook 845 G7.

Signed-off-by: Qiu Wenbo <qiuwenbo@kylinos.com.cn>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201002124454.7240-1-qiuwenbo@kylinos.com.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7786,6 +7786,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x874e, "HP", ALC274_FIXUP_HP_MIC),
+	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),


