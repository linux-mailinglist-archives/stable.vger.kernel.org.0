Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0865B81EC2
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 16:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfHEOMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 10:12:31 -0400
Received: from mout.gmx.net ([212.227.17.21]:52685 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfHEOMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 10:12:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565014349;
        bh=PMiwrYf+1U3+NqDOHfly6kFQ5JSMZwJ7W36qbKvHzQA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=TJ/WGVFx3rkZtwMjD/y5fKi+RbT/UFwjcfco6PEBrH4j+YgpXLwESrBVznPcDtRCP
         OqXaaT74qQmY5o12i2R7EXBlvxssB9MiZk2TARKJ+72QSfHmmnNEhkx6o2dIQ1ZL4o
         kXOLyGVfPTEYN+UlNAbMt9cK5JfrHJCKB0qa6eWM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([95.91.214.154]) by mail.gmx.com
 (mrgmx101 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0MWgND-1hosI22bCF-00Xqrx; Mon, 05 Aug 2019 16:12:29 +0200
From:   Sebastian Parschauer <s.parschauer@gmx.de>
To:     stable@vger.kernel.org
Cc:     Sebastian Parschauer <s.parschauer@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.4, 4.9] HID: Add quirk for HP X1200 PIXART OEM mouse
Date:   Mon,  5 Aug 2019 16:12:01 +0200
Message-Id: <20190805141201.8822-1-s.parschauer@gmx.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190724210324.4868F218B8@mail.kernel.org>
References: <20190724210324.4868F218B8@mail.kernel.org>
X-Provags-ID: V03:K1:e5Yz1VSrQZKbuBD+1BK6FMyBnBo+VaU3Qk0jF08CdC79vNmK+pi
 RU5Lw9PySslfEbcc8cAEMtgPrXzpRebxrcU4ePwmJ23WZedvijkiWRfdqN4/PE2llNsm59Q
 6vffTjq7jvT3ODkB0WgBMiEdtw4/AHSrH62A4YP1EHrKO014nrg79ISrjcXCQENg+z6A/C4
 N8/+Dnj44dWUTMJfgqPqA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ow3sUCAhYJk=:pcooU79vZJDRPUtSl/iFEs
 Pk+8RAh1N9zgO5D0dlNsRcHSIHzv4uMPg7Ky34OUBJvPfM+cXU8aqeccz+JmOFsDvv4A1UVoJ
 jhF7PKpJOPbuyWZ3xINdTCXXpUhncFZBeUsom3xKcv5yUBjgyeVVR9xoKKKsQq520hDqhO9Pz
 hiHNqYJuDGEcoS2VBQL913CqZToxjTKXzGKS/bmq2MR8DsszA9M2wmYgmFDcZtzwYl5MFFzj6
 qWGgcoQ/cxPuW+3H3XO3x1bxiIJp+S+ZXXgmasFPUgFe2yntcJWs8ZjjV17DadRmPuTWqMSB3
 OXUQszrw5PIXpncJngiZGlHvwgPe7cgk0TI6XVsoLcLBqLSEOCt5vHaHUztY3sdVc+sQBBG09
 jja6HSZvaRi8UrwxWp4Js/qlIV/dPgNoFA27MyTBzCL/mV9Hep7HFnLJ19oLjd0G79Pi/djkh
 49Rvd8dx2YatHyrd4Z2rCVb+sQevSmghyc3i2hT5YgYVoZVTWkVNObZjqEIjNmktWOocqvhnY
 AbSMC65HikUQRGMEwLPOIFv4vizfI+8x9VBgYIrlgiygCvIly36xrwblVfHEc/iJgUrOKqPux
 xQ8pVPleKGjc5BTIdGLEBjw7Iq6vVqa/IeFsCeKSlOn5e8ySoW19Cf5ic/rHtInK1FNrAh8pi
 VCL4KAaE1Smp3UsBnk+8O4NfINX7rIhIf1j1AzWfKp4T6vlzufbIDo8oJWGmbaQmhcy7TCkSF
 D39ar4g5wH5oxKicnjbp18K1GiHVeoLmKLgU/RCi7Xudc5NL0MMJythZ5LGsn+A2jnxcWu+jy
 wqOKpgwqYfffMq04Roa5jykk1QAKOQyPksPCrYc/APzjpwkQBYqC1aPfWFn4Gz/hR85bdAqFs
 VtY7dIw2CtiWXgPtTlbvhiOdeLAdC62EdIa0K48UnvAEsxW1U2SmOwELbqe+P14LXYllIMaMs
 xDRMSyIbl0I06UlDJea1TBluKwpYp6LKI7Cxu6ndSuuzJ0ri0KV1SyHEqoC9mXPR31zNJIZHB
 4yz5rl1FUzrS14YwVxgHbhfICSsWe4xLatOQzLtnjYPg1ygGIm9nhO3k677y0NNgs9JnkBJYN
 xPGUW4MEGZK33mWgA4MT/9orlGtRoXBZmejWQtsUNNb/hTZKjc3+W/bhg==
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
CC: stable@vger.kernel.org # v4.4.x, v4.9.x
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[sparschauer: Backport to < v4.16 hid_blacklist]
Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
=2D--
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6f4c84d824e6..25c006338100 100644
=2D-- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -509,6 +509,7 @@
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4A	0x0a4a
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A	0x0b4a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE		0x134a
+#define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641	0x0641

 #define USB_VENDOR_ID_HUION		0x256c
 #define USB_DEVICE_ID_HUION_TABLET	0x006e
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quir=
ks.c
index 617ae294a318..e851926be8b0 100644
=2D-- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -98,6 +98,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4=
A, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4=
A, HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE, HID_=
QUIRK_ALWAYS_POLL },
+	{ USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641,=
 HID_QUIRK_ALWAYS_POLL },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C077, HID_QUIRK_ALWAYS_=
POLL },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KEYBOARD_G710_PLUS, HID=
_QUIRK_NOGET },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOUSE_C01A, HID_QUIRK_A=
LWAYS_POLL },
=2D-
2.16.4

