Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EAE14E24E
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbgA3SpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730986AbgA3SpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D62B320CC7;
        Thu, 30 Jan 2020 18:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409915;
        bh=dpSH7wm6P98BNVbE4Ngg343Teh85IXSxwMZFTo00bpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXhf2mPwHX3+ecBZqT6Y8kq3M7/aTUn+846r5O/R5C0yP1wDa6h6stDaQ9oLwO/zJ
         xgc113ntYiM5qgBYAYHcgjfA3eNNdjc+JGoW5reaQjfFYuqaqfSXmSHIpqNB0sWRfQ
         SYPeZJ/ePgZiN1ZbVz9dRtXhHsa55qBHrU+XEMjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Voegtle <tv@lio96.de>,
        Jan Pieter van Woerkom <jp@jpvw.nl>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/110] media: dvbsky: add support for eyeTV Geniatech T2 lite
Date:   Thu, 30 Jan 2020 19:38:58 +0100
Message-Id: <20200130183623.902015896@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Voegtle <tv@lio96.de>

[ Upstream commit 14494583336880640654300c76d0f5df3360d85f ]

Adds USB ID for the eyeTV Geniatech T2 lite to the dvbsky driver.
This is a Geniatech T230C based stick without IR and a different USB ID.

Signed-off-by: Thomas Voegtle <tv@lio96.de>
Tested-by: Jan Pieter van Woerkom <jp@jpvw.nl>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 3 +++
 include/media/dvb-usb-ids.h           | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 617a306f6815d..dc380c0c95369 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -792,6 +792,9 @@ static const struct usb_device_id dvbsky_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C,
 		&mygica_t230c_props, "MyGica Mini DVB-T2 USB Stick T230C",
 		RC_MAP_TOTAL_MEDIA_IN_HAND_02) },
+	{ DVB_USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C_LITE,
+		&mygica_t230c_props, "MyGica Mini DVB-T2 USB Stick T230C Lite",
+		NULL) },
 	{ DVB_USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C2,
 		&mygica_t230c_props, "MyGica Mini DVB-T2 USB Stick T230C v2",
 		RC_MAP_TOTAL_MEDIA_IN_HAND_02) },
diff --git a/include/media/dvb-usb-ids.h b/include/media/dvb-usb-ids.h
index 7ce4e83324219..1409230ad3a4c 100644
--- a/include/media/dvb-usb-ids.h
+++ b/include/media/dvb-usb-ids.h
@@ -389,6 +389,7 @@
 #define USB_PID_MYGICA_T230				0xc688
 #define USB_PID_MYGICA_T230C				0xc689
 #define USB_PID_MYGICA_T230C2				0xc68a
+#define USB_PID_MYGICA_T230C_LITE			0xc699
 #define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
 #define USB_PID_ELGATO_EYETV_DTT			0x0021
 #define USB_PID_ELGATO_EYETV_DTT_2			0x003f
-- 
2.20.1



