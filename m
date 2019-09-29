Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7387C15A4
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfI2N5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfI2N5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:57:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7C18218AC;
        Sun, 29 Sep 2019 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765462;
        bh=I2kJ2/7FJi+enkweu08eYYQvGFDJ6QywGvJCOXSoA5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtGvcFUQgCk9uUy9La61+Zi4BQcHZWlzhYqyeYT8UU0lr7TuRj652P6cPVRfmtYbV
         6RUirSNWg53nhN0//tSyleQhFTebo5kdoISYlulw8u6vEG9gaNMBNrIs9ha5NYnPQC
         QestVVl5bdnY121K6HTKb3JT1lsnF35fr3HYgjts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilya Pshonkin <sudokamikaze@protonmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 27/63] ALSA: usb-audio: Add Hiby device family to quirks for native DSD support
Date:   Sun, 29 Sep 2019 15:54:00 +0200
Message-Id: <20190929135037.126284432@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Pshonkin <sudokamikaze@protonmail.com>

commit 029d2c0fd61eac74700fb4ffff36fc63bfff7e5e upstream.

This patch adds quirk VID ID for Hiby portable players family with
native DSD playback support.

Signed-off-by: Ilya Pshonkin <sudokamikaze@protonmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190917074937.157802-1-ilya.pshonkin@netforce.ua
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1449,6 +1449,7 @@ u64 snd_usb_interface_dsd_format_quirks(
 	case 0x152a:  /* Thesycon devices */
 	case 0x25ce:  /* Mytek devices */
 	case 0x2ab6:  /* T+A devices */
+	case 0xc502:  /* HiBy devices */
 		if (fp->dsd_raw)
 			return SNDRV_PCM_FMTBIT_DSD_U32_BE;
 		break;


