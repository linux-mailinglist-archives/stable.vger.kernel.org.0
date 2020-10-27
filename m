Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9226529B70B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798547AbgJ0P2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796844AbgJ0PUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:20:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F6FD2064B;
        Tue, 27 Oct 2020 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812012;
        bh=np69AsM3udaKUpjwndbbBcSbkDZCkgDrrmooXS4GtxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=actZoe7xoYfuUvD38QCNw7jgTtMzjtaLuaEEJG1uKtyz5k199QmyMGgFKQY2+55sa
         Ot5vxc8sM+DEp3I3bz9935uML9D4cTS49u/RLFCl6l1Zm/68/Lc1ni2TjRQu04gZSO
         YLydGW+e6R+bi+d1WNcO2yv0PEzPmX0wB+8hMoJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Halman <lukasz.halman@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 061/757] ALSA: usb-audio: Line6 Pod Go interface requires static clock rate quirk
Date:   Tue, 27 Oct 2020 14:45:11 +0100
Message-Id: <20201027135453.428964949@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Halman <lukasz.halman@gmail.com>

commit 7da4c510abff8ad47eb2d7cc9a97def5a411947f upstream.

Recently released Line6 Pod Go requires static clock rate quirk to make
its usb audio interface working. Added its usb id to the list of similar
line6 devices.

Signed-off-by: Lukasz Halman <lukasz.halman@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201020061409.GA24382@TAG009442538903
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/format.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -406,6 +406,7 @@ static int line6_parse_audio_format_rate
 	case USB_ID(0x0e41, 0x4242): /* Line6 Helix Rack */
 	case USB_ID(0x0e41, 0x4244): /* Line6 Helix LT */
 	case USB_ID(0x0e41, 0x4246): /* Line6 HX-Stomp */
+	case USB_ID(0x0e41, 0x4247): /* Line6 Pod Go */
 	case USB_ID(0x0e41, 0x4248): /* Line6 Helix >= fw 2.82 */
 	case USB_ID(0x0e41, 0x4249): /* Line6 Helix Rack >= fw 2.82 */
 	case USB_ID(0x0e41, 0x424a): /* Line6 Helix LT >= fw 2.82 */


