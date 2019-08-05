Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D4081EBF
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 16:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfHEOL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 10:11:57 -0400
Received: from mout.gmx.net ([212.227.17.21]:38767 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfHEOL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 10:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565014315;
        bh=7qGUGvG9eztDZmM8KYBS8i4Uz4eBvtlYbDA+bmuOtSI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=IhuyGtKXm2ty067dr7jsnlS4d2ogKsbYAWKrAxZx0aeCuuiO7hDk1Qx+p8g1RbtyM
         3k3voFi27RgANjXa3qGjEX5x6XQbQBSEV065vR28FJZFlaa5M7wNZptOo2K7uTnnKx
         bzv14dujCYIWMXFJul4xa54sg34strSd8ZxSqC50=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([95.91.214.154]) by mail.gmx.com
 (mrgmx102 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0LgNGi-1iiE8s3sWq-00ndm9; Mon, 05 Aug 2019 16:11:55 +0200
From:   Sebastian Parschauer <s.parschauer@gmx.de>
To:     stable@vger.kernel.org
Cc:     Sebastian Parschauer <s.parschauer@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14] HID: Add quirk for HP X1200 PIXART OEM mouse
Date:   Mon,  5 Aug 2019 16:10:56 +0200
Message-Id: <20190805141056.8764-1-s.parschauer@gmx.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190724210324.4868F218B8@mail.kernel.org>
References: <20190724210324.4868F218B8@mail.kernel.org>
X-Provags-ID: V03:K1:bQUYknMypS7uuxQjFqvpwRh3uVG9eyT0yp6BYV0mGCXNxArPfV0
 +zr1WrLckieQ3XOE4QOIcIuI571cd7KaY6jZJ9wYPj5yJlgui7CRxZ/62UZegNI+ub5CmAe
 xz+OT8MvUOoyuq/aSUj0Qyo5DPPeuxuqYTmvY7534mLvBxI7CHHafa9hQHBqHHecbjdq0qP
 bXxt4PoiIEsZOT3IsbZxA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gqLUoX94IM4=:gbyQb70rWTv+XbiABWV6Jk
 X68vz5bengu3XQwJ3ggoPMQ70ig9i5TxUc8bPVFO5C98oNDYz+Mow/QK029wQ71841s40CkhM
 Ypas0f8K+ZO0bUBJIaO5ABYULiPaP7A0pr95lwtwaYN12n/XloSxGt4u6bQ5LOkxmcdAGREUt
 FN9S/1IWcYe2VcuQP92LlF7JaGRASpi0OJOybLRxFe9i/BGPhhxyuWUB/u07gdY173ct1zubT
 W0LuFFrhL9rnmjomj6D98LM1GMO7livIn2PKsZqGomVdyyOwYqxYW9DKhmI9auNSNnuqo12nd
 q3xCzkDApNaMIDVCZ3U6VYkvVAMzyFAV52yvOdJ0AUyh9FohUhyEKFiAhGbGdlr6fqP7ejRvO
 ClTrF44XpGoLnl/mHZmDiE2h8ne/w+XWWTYeRiqvjj4uKA6ZTLEA6kzVNLoF7sDO5P9mTBzBi
 fFDioeDeSNQ+usOT83oS8LLH+Dhiu1qnCb38RvO1puQaxbm+ZBMvdtSPwDVP65v8Ny15Obu4K
 VZJDaDUZoJirxnN6mN8Xgw8NEYaiNcbOLUkpcI0Z/97snU2A1VujNKrNNsxEi35DvvVXQMe9k
 WSFhaSLcu/aLFmRX6uVy+HICrymMG/tMaDCi3uWmDzLwyImqQT7qCZvMT6xmt1M43LuCfWtg0
 hI3fCejiY5GWTGytsAkNyamwhSeD0tuxaxV5UO4QmU6XkiZa0RqvpVJbv5UYMrhp4bWTRNbY0
 xHuTATa74dngZsMq06Oc71i3rG500psS/vjTkSXof/fJ3lK42YpwoLrsuld32FEYKFqbOhfq5
 XohB0/y4Soy3+rZ15HrsglmLSI3dfpGbpo2plYUuKKhOTbZIis+buqZKOwQSPILQVk1abWyGn
 RLfaoDY4s9j8Ad05yvx8tvydQ/PRj/TdedTnkkfuUDoLIgiUd/o6Ra4aHKhfyfNHQIe9R5Fbb
 lSDl53CbGrvE8SC9Z0Lwt8N54L4sqVatkGnhcWduQOa/WR+SBynrgIEqMCsOyFAIZY5aoFljN
 3qoxs5gymJfmCTsG3iz2AUaaEzxBQXh+AOQtPgHDjnaecSYpywYmsN4G4U8SiciF/B6sUug0u
 COwrGlugs8cqJTMfwWFAdkVQ166ezVQkK8hzhqYkXaOY4YrznzfKua/zw==
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PixArt OEM mice are known for disconnecting every minute in
runlevel 1 or 3 if they are not always polled. So add quirk
ALWAYS_POLL for this one as well.

Jonathan Teh (@jonathan-teh) reported and tested the quirk.
Reference: https://github.com/sriemer/fix-linux-mouse/issues/15

Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
CC: stable@vger.kernel.org # v4.14.x
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[sparschauer: Backport to < v4.16 hid_blacklist]
Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
=2D--
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 28ae3dc57103..1e2e6e58256a 100644
=2D-- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -537,6 +537,7 @@
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A	0x0b4a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE		0x134a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A	0x094a
+#define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641	0x0641

 #define USB_VENDOR_ID_HUION		0x256c
 #define USB_DEVICE_ID_HUION_TABLET	0x006e
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quir=
ks.c
index e10eda031b01..7b5c6bd92d56 100644
=2D-- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -100,6 +100,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4=
A, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE, HID_=
QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A,=
 HID_QUIRK_ALWAYS_POLL },
+	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641,=
 HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680, HID_QUIRK_MULTI_=
INPUT },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C007, HID_QUIRK_ALWAYS_=
POLL },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C077, HID_QUIRK_ALWAYS_=
POLL },
=2D-
2.16.4

