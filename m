Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 201E713A65F
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbgANKLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:11:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732359AbgANKLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:11:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E82E24685;
        Tue, 14 Jan 2020 10:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996664;
        bh=E/QgGsKX187fm06fbc72l+VFzYNIk6fBCxejTqhkB1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqlISAb3/OCKSciEy6yIGgHHKikISp+RmXWzdC74uLvWMm52aj7zUouvNGy3ADEXt
         NThgIrbxzao7b6Jnu9z7xdLIgpCpa1L5ek6O+fC0XhLWI29sDrPxsn/dXIb/cMR81J
         3IxK2EUKH7Fkn1BuqUAO7MKZ0QZtZJW2pmX6fdJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 04/31] ALSA: usb-audio: Apply the sample rate quirk for Bose Companion 5
Date:   Tue, 14 Jan 2020 11:01:56 +0100
Message-Id: <20200114094340.082217722@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
References: <20200114094334.725604663@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 51d4efab7865e6ea6a4ebcd25b3f03c019515c4c upstream.

Bose Companion 5 (with USB ID 05a7:1020) doesn't seem supporting
reading back the sample rate, so the existing quirk is needed.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206063
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200104110936.14288-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1141,6 +1141,7 @@ bool snd_usb_get_sample_rate_quirk(struc
 	case USB_ID(0x04D8, 0xFEEA): /* Benchmark DAC1 Pre */
 	case USB_ID(0x0556, 0x0014): /* Phoenix Audio TMX320VC */
 	case USB_ID(0x05A3, 0x9420): /* ELP HD USB Camera */
+	case USB_ID(0x05a7, 0x1020): /* Bose Companion 5 */
 	case USB_ID(0x074D, 0x3553): /* Outlaw RR2150 (Micronas UAC3553B) */
 	case USB_ID(0x1395, 0x740a): /* Sennheiser DECT */
 	case USB_ID(0x1901, 0x0191): /* GE B850V3 CP2114 audio interface */


