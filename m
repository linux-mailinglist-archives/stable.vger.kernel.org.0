Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6D438EFC0
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhEXP71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235363AbhEXP6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:58:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDAC261968;
        Mon, 24 May 2021 15:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871068;
        bh=mQTLH1+XQSZp+kboY9R83BUDOW2cDG8Tc4IPHW55bvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVOrmeghMrFQrvlErLoqHmJ6GS7a+QBfi4cFoPTMQGYihL9GbBqbySlyFRrEAJRbh
         /buCx+nCFAplpWT+xV4in+oxuHj7ZT+BWs4WixkPosQOi2fb2QwW1reRIxyE2Zvn9w
         BWEYhbvhM31pReUdKBTjOi7preuR9aa8a4VQ6GOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivia Mackintosh <livvy@base.nu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 059/127] ALSA: usb-audio: DJM-750: ensure format is set
Date:   Mon, 24 May 2021 17:26:16 +0200
Message-Id: <20210524152336.836321151@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivia Mackintosh <livvy@base.nu>

commit e7df7df5a3809d733888db6ce6592a644acaac19 upstream.

Add case statement to set sample-rate for the DJM-750 Pioneer
mixer. This was included as part of another patch but I think it has
been archived on Patchwork and hasn't been merged.

Signed-off-by: Olivia Mackintosh <livvy@base.nu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210418165901.25776-1-livvy@base.nu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1511,6 +1511,7 @@ void snd_usb_set_format_quirk(struct snd
 	case USB_ID(0x2b73, 0x0013): /* Pioneer DJM-450 */
 		pioneer_djm_set_format_quirk(subs, 0x0082);
 		break;
+	case USB_ID(0x08e4, 0x017f): /* Pioneer DJM-750 */
 	case USB_ID(0x08e4, 0x0163): /* Pioneer DJM-850 */
 		pioneer_djm_set_format_quirk(subs, 0x0086);
 		break;


