Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF178313660
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhBHPKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhBHPHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:07:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F1764EE6;
        Mon,  8 Feb 2021 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796728;
        bh=VSByKdEj4xguY8ObmVxYO9eCq2VnPqK81L7F4k1uy0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oU+UHOEp27rV3bzxUKkfvjfa2E3Vu3iBmTFTqz1eeSYSKOcHzwJNOvB8zb6gd1Tn6
         NtJo8VndTKSMVZEjqgh4/WBkJfcZLVOp+/pkcqoOfVJ8iWPIZlIZwytXsFpRH9c2mj
         7ICyI9/ykOm1wWFwYbTXuVtUHqLlq4KPMsysm2rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Shih-Yuan Lee (FourDollars)" <sylee@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 43/43] ALSA: hda/realtek - Fix typo of pincfg for Dell quirk
Date:   Mon,  8 Feb 2021 16:01:09 +0100
Message-Id: <20210208145808.049751458@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
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
@@ -6284,7 +6284,7 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0299, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		ALC225_STANDARD_PINS,
 		{0x12, 0xb7a60130},
-		{0x13, 0xb8a60140},
+		{0x13, 0xb8a61140},
 		{0x17, 0x90170110}),
 	{}
 };


