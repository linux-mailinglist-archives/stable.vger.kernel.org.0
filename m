Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ED64524DF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357445AbhKPBqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241430AbhKOSUB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:20:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D63A632B0;
        Mon, 15 Nov 2021 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998731;
        bh=EVn2yfLHm9q/wqjSRj8hZ9IX6wJGTdARclm73WbQRpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ch1m1PchBUX+6gyxQQ0F0isYfyRZ63e7UJUiitlEx7DhRWQ9wbG8pRMTDEITb8CFJ
         dUurF7YCTG7zKV250T1m8JZqyDzjCZHPLf9dcaLOrVMWhIKzBo+ccjkHsmx6p4Fz53
         vx0WZ5pwELnY4OM0QvXJeSqZJKOFnBwWRJ7BmAY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Ormes <skryking@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 041/849] ALSA: usb-audio: Line6 HX-Stomp XL USB_ID for 48k-fixed quirk
Date:   Mon, 15 Nov 2021 17:52:04 +0100
Message-Id: <20211115165421.395620879@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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


