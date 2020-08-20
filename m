Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E346824B215
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHTJXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbgHTJXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:23:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83A09207DE;
        Thu, 20 Aug 2020 09:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915426;
        bh=7Ct/2hrLbKTIBhpql3OXUpTZMS5i9vMkCsHD4bcfDYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beCGWrrNbcJsoDQm9FqQ+ejvQrIT7BUR06Dw/IEvqJzBuHOOc+fxYA8WDKUumKtD6
         2ILtt4SNEIuUBsOK5XVTsfiMEIKdhRAjEHeFjtM9QoCNDohR48JsrEdTQTZgAWFcsp
         Agf2bJGlHJ6eewnON79Sgty6gKRm1+0GFgJrSYoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 001/232] ALSA: hda/realtek - Fix unused variable warning
Date:   Thu, 20 Aug 2020 11:17:32 +0200
Message-Id: <20200820091612.773298222@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit e5b1d9776ad3817a8c90336038bf7a219425b57f upstream.

The previous fix forgot to remove the unused variable that triggers a
compile warning now:
  sound/pci/hda/patch_realtek.c: In function 'alc285_fixup_hp_gpio_led':
  sound/pci/hda/patch_realtek.c:4163:19: warning: unused variable 'spec' [-Wunused-variable]

Fix it.

Fixes: 404690649e6a ("ALSA: hda - reverse the setting value in the micmute_led_set")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lore.kernel.org/r/20200812070256.32145-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4171,8 +4171,6 @@ static void alc269_fixup_hp_gpio_led(str
 static void alc285_fixup_hp_gpio_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
-	struct alc_spec *spec = codec->spec;
-
 	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x01);
 }
 


