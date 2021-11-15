Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A667C4512FE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbhKOTnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:43:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245243AbhKOTTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD4D2632D3;
        Mon, 15 Nov 2021 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001058;
        bh=EVn2yfLHm9q/wqjSRj8hZ9IX6wJGTdARclm73WbQRpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHDr/3F3ipBn9TvajZG7jRZaEUFCnvipGzHv/92JuqRRd2gdF1eo/qh/FINR3M8GS
         pL+6AaOvkI2Mijczm2U2WLSDaaBDe6R+R9bCgfQVo25uumZFYKp5vuhi1folrWrFV0
         Tlt7/FDC7aTvocga/3I60IDoaq98yWWEPEqW5qnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Ormes <skryking@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 044/917] ALSA: usb-audio: Line6 HX-Stomp XL USB_ID for 48k-fixed quirk
Date:   Mon, 15 Nov 2021 17:52:19 +0100
Message-Id: <20211115165430.258257757@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Ormes <skryking@gmail.com>

commit 8f27b689066113a3e579d4df171c980c54368c4e upstream.

Adding the Line6 HX-Stomp XL USB_ID as it needs this fixed frequency
quirk as well.

The device is basically just the HX-Stomp with some more buttons on
the face.  I've done some recording with it after adding it, and it
seems to function properly with this fix.  The Midi features appear to
be working as well.

[ a coding style fix and patch reformat by tiwai ]

Signed-off-by: Jason Ormes <skryking@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211030200405.1358678-1-skryking@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/format.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -414,6 +414,7 @@ static int line6_parse_audio_format_rate
 	case USB_ID(0x0e41, 0x4242): /* Line6 Helix Rack */
 	case USB_ID(0x0e41, 0x4244): /* Line6 Helix LT */
 	case USB_ID(0x0e41, 0x4246): /* Line6 HX-Stomp */
+	case USB_ID(0x0e41, 0x4253): /* Line6 HX-Stomp XL */
 	case USB_ID(0x0e41, 0x4247): /* Line6 Pod Go */
 	case USB_ID(0x0e41, 0x4248): /* Line6 Helix >= fw 2.82 */
 	case USB_ID(0x0e41, 0x4249): /* Line6 Helix Rack >= fw 2.82 */


