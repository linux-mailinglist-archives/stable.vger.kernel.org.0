Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C7431360C
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhBHPFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231654AbhBHPD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:03:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADC7A64EC4;
        Mon,  8 Feb 2021 15:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796603;
        bh=cmyzcyiFS8tmTtGmjJmUmSI4soPYQvZxx1s1bJpQnbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPUw1gE6JWDvDEArZZRaHT4NMzzUBFk9figgqYciXmsUdL+/Q07qPslFX41CnN7+U
         /BzIV1CWjFg8Q4JMiky8PNyLGpFjxMxrZN7jQj9M6oQFjONlQ9JLm6buD350VZm8BM
         PWJWexJN2Z0wCn/bvP+77n07qKvbV5SD8H2dr08c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Shih-Yuan Lee (FourDollars)" <sylee@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 38/38] ALSA: hda/realtek - Fix typo of pincfg for Dell quirk
Date:   Mon,  8 Feb 2021 16:01:00 +0100
Message-Id: <20210208145806.753256445@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shih-Yuan Lee (FourDollars) <sylee@canonical.com>

commit b4576de87243c32fab50dda9f8eba1e3cf13a7e2 upstream.

The PIN number for Dell headset mode of ALC3271 is wrong.

Fixes: fcc6c877a01f ("ALSA: hda/realtek - Support Dell headset mode for ALC3271")
Signed-off-by: Shih-Yuan Lee (FourDollars) <sylee@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6211,7 +6211,7 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0299, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		ALC225_STANDARD_PINS,
 		{0x12, 0xb7a60130},
-		{0x13, 0xb8a60140},
+		{0x13, 0xb8a61140},
 		{0x17, 0x90170110}),
 	{}
 };


