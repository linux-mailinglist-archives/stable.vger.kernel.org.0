Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D539330E31
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhCHMfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232084AbhCHMfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C412A651DC;
        Mon,  8 Mar 2021 12:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206934;
        bh=ftmmF88sDebSjxrjTGEoA+1RmyiYZbsTlz5nBT5b2zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgSvl9K/eDJh4eivqlhQZwT+LH3cPMpNbC94S2n6veuW0KGmKDm4Mly2Gh3ywCD4z
         pIKLll4QGpoOaLT8kfU9JodYjGXdgSdXYsQUCa5J+IKiyZqc6Mzbgl8eLpEJ7rg4Xy
         tDHyJfmorhYx/rpwTDf6LvSORxtfUNAnIhahDuDI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Fagiani <andfagiani@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 02/44] ALSA: usb-audio: use Corsair Virtuoso mapping for Corsair Virtuoso SE
Date:   Mon,  8 Mar 2021 13:34:40 +0100
Message-Id: <20210308122718.706345018@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Andrea Fagiani <andfagiani@gmail.com>

commit 11302bb69e72d0526bc626ee5c451a3d22cde904 upstream.

The Corsair Virtuoso SE RGB Wireless is a USB headset with a mic and a
sidetone feature. Assign the Corsair Virtuoso name map to the SE product
ids as well, in order to label its mixer appropriately and allow
userspace to pick the correct volume controls.

Signed-off-by: Andrea Fagiani <andfagiani@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/40bbdf55-f854-e2ee-87b4-183e6451352c@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_maps.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -537,6 +537,16 @@ static const struct usbmix_ctl_map usbmi
 		.map = bose_companion5_map,
 	},
 	{
+		/* Corsair Virtuoso SE (wired mode) */
+		.id = USB_ID(0x1b1c, 0x0a3d),
+		.map = corsair_virtuoso_map,
+	},
+	{
+		/* Corsair Virtuoso SE (wireless mode) */
+		.id = USB_ID(0x1b1c, 0x0a3e),
+		.map = corsair_virtuoso_map,
+	},
+	{
 		/* Corsair Virtuoso (wired mode) */
 		.id = USB_ID(0x1b1c, 0x0a41),
 		.map = corsair_virtuoso_map,


