Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3E1594365
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245671AbiHOV5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350570AbiHOV4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:56:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D67610AE21;
        Mon, 15 Aug 2022 12:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6868EB80EA8;
        Mon, 15 Aug 2022 19:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5202C433D6;
        Mon, 15 Aug 2022 19:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592046;
        bh=qRMw4Z/Z0VGv9wZhXzljXtFElEfvcInrNKvviqV8PLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufg6Tp7qDUL44QPDgBilw3sfCb5Vu0VriLbVnJC56bbzBjFoNkzFgRTzON5KjJ878
         DWXaMyoAkl/UtnQh8dz3+ltqnsJruKTRlZuRCgjyvGShxrohxWlkrHh1mQJAIw7Aq0
         fE+xg3s1J32+gR+5IeIcW0koqGUeOJcjdsoOsEvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bedant Patnaik <bedant.patnaik@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 0049/1157] ALSA: hda/realtek: Add a quirk for HP OMEN 15 (8786) mute LED
Date:   Mon, 15 Aug 2022 19:50:05 +0200
Message-Id: <20220815180441.421922862@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Bedant Patnaik <bedant.patnaik@gmail.com>

commit 30267718fe2d4dbea49015b022f6f1fe16ca31ab upstream.

Board ID 8786 seems to be another variant of the Omen 15 that needs
ALC285_FIXUP_HP_MUTE_LED for working mute LED.

Signed-off-by: Bedant Patnaik <bedant.patnaik@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220809142455.6473-1-bedant.patnaik@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9178,6 +9178,7 @@ static const struct snd_pci_quirk alc269
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8783, "HP ZBook Fury 15 G7 Mobile Workstation",
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),


