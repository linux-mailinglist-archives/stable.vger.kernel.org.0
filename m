Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A994EEEBC
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389535AbfKDWDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:03:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389532AbfKDWDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:03:35 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E66205C9;
        Mon,  4 Nov 2019 22:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905015;
        bh=NwuLJVx/kg0lq7+2WchIbuQPlPNyXtL83vEvZVMiZ5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQPUY/HfvN5mFd/51YUp35aPsNeWXLogh2TWk+YsG9JkNJopG6OPsrcNseGIG6nb5
         aVmDpGDwv+A/KFKVCpmUGRWtb1cVW5xnvLEE0571boVy+ol4sBnLaiFo2wQjXF/pmS
         cUmx+3d1aBaI7o0oey1zM9bsgZVyillZvuIIYYIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Song <flyingecar@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/149] ALSA: usb-audio: Add DSD support for Gustard U16/X26 USB Interface
Date:   Mon,  4 Nov 2019 22:45:42 +0100
Message-Id: <20191104212147.114659457@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Song <flyingecar@gmail.com>

[ Upstream commit e2995b95a914bbc6b5352be27d5d5f33ec802d2c ]

This patch adds native DSD support for Gustard U16/X26 USB Interface.
Tested using VID and fp->dsd_raw method.

Signed-off-by: Justin Song <flyingecar@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CA+9XP1ipsFn+r3bCBKRinQv-JrJ+EHOGBdZWZoMwxFv0R8Y1MQ@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 28035c59cb37c..c102c0377ad91 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1434,6 +1434,7 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	case 0x23ba:  /* Playback Designs */
 	case 0x25ce:  /* Mytek devices */
 	case 0x278b:  /* Rotel? */
+	case 0x292b:  /* Gustard/Ess based devices */
 	case 0x2ab6:  /* T+A devices */
 	case 0x3842:  /* EVGA */
 	case 0xc502:  /* HiBy devices */
-- 
2.20.1



