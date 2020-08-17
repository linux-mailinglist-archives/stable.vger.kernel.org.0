Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FA2246FF3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389431AbgHQR4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388548AbgHQQK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:10:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83C9D22CB3;
        Mon, 17 Aug 2020 16:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680625;
        bh=IZjzyE1aX3712sShmYz1uvcd4FP+29hcOBDseRn3yik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHqnBkoSjZM2wX+2BPFccsYkAhq5ZXFg7Tikf3jICNv3+7J3J2kLcOYYnF+3iz+fT
         //yWFJLEW58EhW55z+DrqHj7q2OoJdqtgEUA69bfJS+UDygDYgsuHNZ/UW+zEmJGTa
         0dL1lABDvaawrHmseNHrVt39uOAnjIIEeHXE/rSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mirko Dietrich <buzz@l4m1.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 231/270] ALSA: usb-audio: Creative USB X-Fi Pro SB1095 volume knob support
Date:   Mon, 17 Aug 2020 17:17:12 +0200
Message-Id: <20200817143807.298484277@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mirko Dietrich <buzz@l4m1.de>

commit fec9008828cde0076aae595ac031bfcf49d335a4 upstream.

Adds an entry for Creative USB X-Fi to the rc_config array in
mixer_quirks.c to allow use of volume knob on the device.
Adds support for newer X-Fi Pro card, known as "Model No. SB1095"
with USB ID "041e:3263"

Signed-off-by: Mirko Dietrich <buzz@l4m1.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200806124850.20334-1-buzz@l4m1.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -184,6 +184,7 @@ static const struct rc_config {
 	{ USB_ID(0x041e, 0x3042), 0, 1, 1, 1,  1,  0x000d }, /* Usb X-Fi S51 */
 	{ USB_ID(0x041e, 0x30df), 0, 1, 1, 1,  1,  0x000d }, /* Usb X-Fi S51 Pro */
 	{ USB_ID(0x041e, 0x3237), 0, 1, 1, 1,  1,  0x000d }, /* Usb X-Fi S51 Pro */
+	{ USB_ID(0x041e, 0x3263), 0, 1, 1, 1,  1,  0x000d }, /* Usb X-Fi S51 Pro */
 	{ USB_ID(0x041e, 0x3048), 2, 2, 6, 6,  2,  0x6e91 }, /* Toshiba SB0500 */
 };
 


