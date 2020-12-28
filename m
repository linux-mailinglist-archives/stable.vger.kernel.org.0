Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8952E3FB5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503893AbgL1Onj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503892AbgL1O0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61C7F22AEC;
        Mon, 28 Dec 2020 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165567;
        bh=f9n92v3ennDuws7EOTB+m0XzhxI8hwSU2vpCCgSXu6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GflqbkiSAOBDBYQQ2FFeRxa833wbDHQVDBgQ/DZWXhqpvfb/l+qRsMmv6qCV7uYI3
         n3S8tQRi8dFVcJkuti6dQtGnRy0WptlvSY+7/kOqAVjilIlByPlR0Q0OR2YONQwqFv
         rdx7aSsG334vcBKXATkEXeAu2VcriNo+Lkj0jb0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amadej Kastelic <amadejkastelic7@gmail.com>,
        Emilio Moretti <emilio.moretti@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 547/717] ALSA: usb-audio: Add VID to support native DSD reproduction on FiiO devices
Date:   Mon, 28 Dec 2020 13:49:05 +0100
Message-Id: <20201228125047.148431834@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
@@ -1799,6 +1799,7 @@ u64 snd_usb_interface_dsd_format_quirks(
 	case 0x25ce:  /* Mytek devices */
 	case 0x278b:  /* Rotel? */
 	case 0x292b:  /* Gustard/Ess based devices */
+	case 0x2972:  /* FiiO devices */
 	case 0x2ab6:  /* T+A devices */
 	case 0x3353:  /* Khadas devices */
 	case 0x3842:  /* EVGA */


