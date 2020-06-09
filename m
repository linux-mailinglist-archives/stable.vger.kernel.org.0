Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E24E1F378A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 12:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgFIKDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 06:03:18 -0400
Received: from mout.gmx.net ([212.227.17.22]:60023 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbgFIKDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 06:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1591696992;
        bh=FecC3CcgoMyAyUL7IixAQEc5aGyHVazx2HQgrl03F0I=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=CxnvygdiyuVJ3Wu7j75TgUNC3CAHsIKH8NWxHSzMZduvN+drAmb0gE3j09gLINQ/6
         CsK7dWaR8Z79mZZDb1dYsTDejzo6dg6qPvQ/8XWbtQ5jwYPVC5XVZi5925aMRaTblf
         lmgcfJ2RNlDawg6ndLx8JpAHv8UWcOcA2czDGx0w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([95.91.214.106]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MORAU-1jIeDR3czO-00PrpT; Tue, 09 Jun 2020 12:03:11 +0200
From:   Sebastian Parschauer <s.parschauer@gmx.de>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org,
        Sebastian Parschauer <s.parschauer@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH] HID: quirks: Always poll Obins Anne Pro 2 keyboard
Date:   Tue,  9 Jun 2020 12:00:53 +0200
Message-Id: <20200609100053.15016-1-s.parschauer@gmx.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IGIu3ROjnVTEQRVzlKXmK1FJWjCNExL+/+MYjCgzt4euEDbimiL
 Bb+zGxoLGyeSXx5V5ovoXN2zVp+5yw4+vOlYYH2kP3UrD8uVpVkg4RDFqutEbllAFExxkLL
 KqxByVk5ljGJcoepWaufhFqTA7M2qdPLQZ16e1MNzWbf3VGlWVJnlObAbEMLNkFR+o+D9kh
 3gVVLEWFpbdRmeBEE8uTA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bIoJyn+1dN0=:UPhQGavs9xitq47L/F0bNz
 WFZtTRMu24KK1ObhVHstw14xBhnFup/ZSnenSxTiGs6v7qvRGOpsmaiVhmj8WdU0wVtSDPFw5
 FwHUVlGpEu12MVc0nw3QDiSNRJlmMfLEUrmlwDMc6zAXsiMwFoH26BJiWBL9Y7bPH+i2Jt3iV
 xoo01CA2JTVhwQlT98A6dQu917hN4LtpXmZGxncnQ+epDQgBHG5CMRuBMmCo3dUbJCionUnXB
 TeCRLHaqrFIc4Psq6hqFle6M2djqTfa/wmUXF6GdOdSRJIG7Bxuo67IPqWik9FciqT7yT3j8f
 piB4vEm14X6s9E/rXf0fkSaqNgo2NZF4gvO1HFxqSHlKGavP46ku4tpV1mydGViT6Mag+r9Mr
 X4UI9eLX17uhD7zww4FMh2uEvG5b3+yBxUaFmd+gV44ACSh1/MpYMY2VAqHYzimWQU3tao3Gp
 GLyY3DGmWhCvN45TzmkCrjGZrAdM1pxMenLlpP4xU2bTSF/ampqN9fdNjE3RK9eG7AcD/i5Ob
 0BvmwLkgA1GpIsLpjEJgl5Nl/XwcBXVJoLNBILopxqe9RDSIjTgl3RhQGUZZUYZYko2b/ocIo
 AKNf+GTmeuvw9GI9zqIdHaT4cqFnf9+aPzTXaes4aJM/DVrRLa1cfjIAIF7kx6v+hEyrYtoOu
 HvqZMYhWOylnzYEwIt8bbeSasgGLqtyKLQ6B+8BRL1XpxLSySExq0uueMQhA4KLxEwOJ3q5qL
 YRd2+pI04zkwXaJFC1frEx5HX5b8Qhljdi45ffBnT03BKsglavBFZ2MvP7QebJcpL7Kv0iBr5
 wkdFohEKh9uqAFSoTc0NHQRwBIWRCU0WUiOzCSB5Nw+gHdl4QdYYkOTWRYVAL/Obv8fSgZZsR
 MUFiTaixvyOWPn9YqhLHp/diYhCNT3dnoX80tGn3N3sacg01o4qNT/iDEzODNPBV9z0N3RvmO
 z8eh6cgkQbete72Xkz54iOkNheHe3OW5eGzU/W1aXJ9WQjJBVijBUfwmzSMnNkkBNVdDig54y
 TwDZaM/G7MEkf2OFe5GWnkk6nyONYTHMSC/f4MF9LrSZrV4gmyhNr+uM0d9M6kQAt1IRNKzoH
 3b56XkSnCHiKzkCXwu9dgx/dbmhnMwUmuhNsynOzfKa7h/t9B3PVTbvceJUJXcpnmmsMBfpQR
 aJK8UrvP8j8EZAJ3UF3+Ge3PVEB1ZCEp8SzOGuX/Ez+yOpgcEhpNzmeUCu87t6SebQF+Ds0TF
 PzhBp0+o6uTfdkG6c
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Obins Anne Pro 2 keyboard (04d9:a293) disconnects after a few
minutes of inactivity when using it wired and typing does not result
in any input events any more. This is a common firmware flaw. So add
the ALWAYS_POLL quirk for this device.

GitHub user Dietrich Moerman (dietrichm) tested the quirk and
requested my help in my project
https://github.com/sriemer/fix-linux-mouse issue 22 to provide
this patch.

Link: https://www.reddit.com/r/AnnePro/comments/gruzcb/anne_pro_2_linux_ca=
nt_type_after_inactivity/
Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
Cc: stable@vger.kernel.org # v4.16+
=2D--
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1c71a1aa76b2..3a1047e143d2 100644
=2D-- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -624,6 +624,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2	0xa0c2
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096	0xa096
+#define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293	0xa293

 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index e4cb543de0cd..67839d5eece8 100644
=2D-- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -88,6 +88,7 @@ static const struct hid_device_id hid_quirks[] =3D {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_Q=
UIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUI=
RK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYB=
OARD_A096), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYB=
OARD_A293), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OP=
TICAL_MOUSE_0A4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OP=
TICAL_MOUSE_0B4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTI=
CAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
=2D-
2.26.2

