Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B8C2E430D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405156AbgL1NzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:55:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405148AbgL1NzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:55:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5DD7205CB;
        Mon, 28 Dec 2020 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163694;
        bh=et2EOgat5y5RkyzMH+LzQsIP3IgU3o2wAQD5ZmZUfY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWDAasyT+KOCGxDt7q9bzqjYLmaoyUrKV9U67JLaoee5ealtBvtSI+r/IPNKfoBnZ
         SNiKWZ9mnYXhlBnKznYjYM+8E7OhdPDTpybEcrCp60kc1ieAlFS+E4+adgsjXoPDzn
         4pQtUz+Ju0EkNV/s2+PAGLHolICYlfO5RJ0apxuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amadej Kastelic <amadejkastelic7@gmail.com>,
        Emilio Moretti <emilio.moretti@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 344/453] ALSA: usb-audio: Add VID to support native DSD reproduction on FiiO devices
Date:   Mon, 28 Dec 2020 13:49:40 +0100
Message-Id: <20201228124953.772765982@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadej Kastelic <amadejkastelic7@gmail.com>

commit 725124d10d00b2f56bb5bd08b431cc74ab3b3ace upstream.

Add VID to support native DSD reproduction on FiiO devices.

Tested-by: Amadej Kastelic <amadejkastelic7@gmail.com>
Signed-off-by: Emilio Moretti <emilio.moretti@gmail.com>
Signed-off-by: Amadej Kastelic <amadejkastelic7@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/X9j7wdXSr4XyK7Bd@ryzen.localdomain
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1731,6 +1731,7 @@ u64 snd_usb_interface_dsd_format_quirks(
 	case 0x25ce:  /* Mytek devices */
 	case 0x278b:  /* Rotel? */
 	case 0x292b:  /* Gustard/Ess based devices */
+	case 0x2972:  /* FiiO devices */
 	case 0x2ab6:  /* T+A devices */
 	case 0x3353:  /* Khadas devices */
 	case 0x3842:  /* EVGA */


