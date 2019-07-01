Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83EF15B457
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 07:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfGAFuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 01:50:01 -0400
Received: from mout.gmx.net ([212.227.15.19]:47075 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfGAFuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 01:50:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1561960165;
        bh=oc3sKYQ0mF/Td4gJJep/DqPQvOea8tFxzRguGbP7Vws=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=IOdR2wUONe8GLQd5Qx7QtrXo32UQ3X41YP8EZTGZjs76QnOWm0re05zmAt0uBCZUh
         kCIICKGgcXJUAvq1UoRi69zHWsmZnAr+B+/Ivw9mMrqj804Nm6Hq2CLUtGn2MVvZp2
         GcKDN33m8ISrN++3Jv4BA/KBkyxMB7tWjYCV3pdE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([95.91.214.143]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MZktZ-1i5HJz0xlf-00WpFc; Mon, 01 Jul 2019 07:49:24 +0200
From:   Sebastian Parschauer <s.parschauer@gmx.de>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org,
        Sebastian Parschauer <s.parschauer@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH] HID: Add another Primax PIXART OEM mouse quirk
Date:   Mon,  1 Jul 2019 07:48:17 +0200
Message-Id: <20190701054817.13991-1-s.parschauer@gmx.de>
X-Mailer: git-send-email 2.16.4
X-Provags-ID: V03:K1:iqER7KqJ739FSVKBCQj8xMiFrJiiU/1PbXgadM/Vv8+oQzkGSu2
 ABrWENv8oFNZ+T0HCZ63NNA/hQdkmuisSzwz55lTq2qOPq9cohff3Ne+w41ksDHKyigwEV+
 1Zql0xOSq9rzwLhjGHe5c8NDLJXnz2X05KYbabdAe5iLqQKNqJEbfOmM0PnXr+irdbMtxii
 KlDsAMaXKquZ6EdOfnSKA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bTBigtiAdsA=:SPZ9QLhj5HNDb/GksVXvye
 6tWFZlJDr4cVHVTJ8QtJdHVwWAWJkKXLX5ofUeKcEVdcHxwaKlpgeV1FqeayorpV869I253Aw
 oN6ja2wiKbfG+ZwNobvT7Tg2V3dYFdBostbeADWvwGRULDqYdSN6zOEmOkR+OBAYIz4jjNdh0
 q3cXrFh57Kr3Xvvh5uEDf0GkB3599Oq1JWIcVhMecxVF2I2QGXp8y07nuLCZgd2Nu7JwWcYdv
 /RKQUMiZr5pgR7ToySVFEzIYkP5OVh5krmH2baNC0NE7bxSaacOBU7Yfev9lRgMKEuxmjKDXI
 bLW+ht+X7yHPFViDYZf1CDKIyPCM0fPGGmNi2gvOC5OZgY7cVjqgkzw9DnoDHvS/8S2EmUxmE
 7On8xEszicbAp/dcm1hlQSbyHitMAJs9zPFbnAfSqA9+ZiUOOeoE5CrwcORO0rp1udECGvA3n
 EXD0vdeMiAMKryWbJzzZhd0PbYXydO517vOAbZ30CBBVx+Jd2i9oIP5j8E350izKY8sBHs8Q6
 8GOuSlqj9y6WrLTV3m4Qm2br3OwUvIui0z4nDQ1G4DMFqMfo3phLGwORRgs0KZDWop1icWIGo
 KBk3nom7ZOSqvgbSnm37rXBPC6BuYgHpzFY40Eft5CQ0kY2NsfUKHnPmby3uIQMV/Xrn8VxFe
 KnRoPFzKyyaNrmSb/5j2tmXyx4KKOtNBja21Cv7etwvIYkp/5VVFdtRtUV8VQFYXMKB8nki7B
 0R6Tsax//ShE2zw5V8AapWmRmjR59Utfq1cvB1mxpZsDF23oXvRr7P0POQv/sk9MQbFmNU05F
 itQy/sJ/SKg0y7zmKwSBikEHALfIdTzkOyFjx/QlPj1bSIVoyBVpppNKEzoWELgRzeX23r5sw
 7cBBue6z0SMfFBmGK0u7j7LHKEWaNm0VQkS7nwhKOAjoVz/dQZa3nmqI0B+naD97KXMlG07R3
 TdDIxbILsUpk/KzXpAnUNn/IHZSkxYjiGhXr/5phw4esBD7ycH7DQHEztsy5k+4m+vimNBczy
 Nne1q6Iv4ely/MCqyBYafnJTHMETE2znWZJGwRedEowV4+HysRMkmBchrcy6L+usvzyTeqZUS
 y1Y9kShZxGL3UE=
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PixArt OEM mice are known for disconnecting every minute in
runlevel 1 or 3 if they are not always polled. So add quirk
ALWAYS_POLL for this Alienware branded Primax mouse as well.

Daniel Schepler (@dschepler) reported and tested the quirk.
Reference: https://github.com/sriemer/fix-linux-mouse/issues/15

Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
CC: stable@vger.kernel.org
=2D--
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index eac0c54c5970..ea04b37cdac2 100644
=2D-- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1238,6 +1238,7 @@
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD	0x4e05
 #define USB_DEVICE_ID_PRIMAX_REZEL	0x4e72
 #define USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D0F	0x4d0f
+#define USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D65	0x4d65
 #define USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4E22	0x4e22


diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index e5ca6fe2ca57..4aa321e35a8e 100644
=2D-- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -129,6 +129,7 @@ static const struct hid_device_id hid_quirks[] =3D {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_USB_OPTICAL_=
MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_MOUSE_4D22),=
 HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE=
_4D0F), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE=
_4D65), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE=
_4E22), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRODIGE, USB_DEVICE_ID_PRODIGE_CORDLESS),=
 HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUC=
H_3001), HID_QUIRK_NOGET },
=2D-
2.16.4

