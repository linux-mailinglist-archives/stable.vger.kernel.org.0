Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0773A5431
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 12:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbfIBKlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 06:41:11 -0400
Received: from mout.gmx.net ([212.227.17.20]:48881 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbfIBKlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 06:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1567420861;
        bh=tA/sQectS6ufnSvHQs9vkO51QVeunsmgYTFy/E5vD2g=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=P5fROY8sXDkzBILd2PDfITtt9raoHbEC+4YVSJXR+KhZGb+MT7OPP7+ZzzJr621H3
         P12jSc0b2QQTyimE1Yf7TvySgxtoUkUJorzQbxS6dICQRy/S64N9FQS4I4zwECFziY
         uF3lBKfHgFazF3pt/r2hlyrbpcsEX5sBF3brMqnI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([95.91.214.116]) by mail.gmx.com
 (mrgmx102 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0LkBPy-1ic9qB2n3S-00c941; Mon, 02 Sep 2019 12:41:01 +0200
From:   Sebastian Parschauer <s.parschauer@gmx.de>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org,
        Sebastian Parschauer <s.parschauer@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH] HID: Add quirk for HP X500 PIXART OEM mouse
Date:   Mon,  2 Sep 2019 12:39:30 +0200
Message-Id: <20190902103930.9004-1-s.parschauer@gmx.de>
X-Mailer: git-send-email 2.16.4
X-Provags-ID: V03:K1:D1C0akojf2gEEKL7cxVrGZ//Mx8mKrWggM0ZF3HllFS/N7zPc3P
 sq1iRJ5F0YoE2LHFUXnrh2UBGE0S4oqXZF2bjTv2RDRSvIgRMB3QQFHFeSz+1PCN4fhMFLl
 tJZO0X3IlfpNipk5sXpi0d3dQsgLuw1AwdhaB8j2RoxLA7KYod1B+fp3B4AXg+CYfShevUU
 VaeWN5GFxo32mwXyYkciA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0hkNiGe8CmM=:mhxssAESCHdrhxzb+GueIe
 xe4hShyXLwxeeFBK2NZsevnlMOp5g5pD/B9wQii5LS7z/GnJ3bzj6MkPjIEYn7KvFA0zCHvrd
 TVjoGtPj3VSlNPbaXMNtg2Fq9MLE1/1yQRVLfD0e+Fme4pc0H6nFa6jT0H6KnDiWea1GyIJ7A
 0HhjqE+H6O+HiAcFIrGZPahplRyQQj8tXFBj9J6IbEsmDJl8HapZrIWJpxAzE71s5LSf5qSQa
 Rt13V+BKzQw1/tPRoofUl8ZTzfYqg/BN8M9TFUlKmMClviS6+95qQZFfEDC3I6biwdbCRpoxq
 zN5dzGj0llUhymt0OvVP0FlKvxPqpmJsKeFFhqTi/noaGKZAARCOsDyUxsY82+o2vBx/lp5FU
 fdr9QjaxXi0xyFlkBM8+j0LFtkYqMFls40LSCyNdVxdff6YwPcznUwX0gZlVc8hItES1sIxXe
 rWwozCcisgaKDsB4jbss3DKU0822j4/U6Hs6n4LmAFMeDIzia6c10FKK8Vtws/CT4KxqPwtUJ
 3RIZV+Q4x7Oa5FNFjsotUazFzzFzrxkEblyqNCS6j0GF6YPLhawnH9kw9/dPnoL9+S+8KP+pW
 QxiIKlLL6YJi/e/vifqeo93YP3ZbdTOy+6T8eZRGbH0HpdNYKLmDEsusOc6Ej1D3VjdjHwjp7
 gt05qlw9EPi+fqkgOof4mzliQjrgA0hvHhGC2yNBNJbhR6X+u6wBs1CKR/BYVgAMBx1aWBYl4
 6BLlOPluWRWBRxXlZv5r0AUncVey8bV/EAwaaQ9o5wfbj5czdOeXYJa1wBlXrN/7H2H36wctl
 3ZnHXaqBrBo3f6kvcx/qnY2TyO4WcVtknCSA6zVCgwW7YoC8Mem4bB7qgK1perD+thI087+d+
 Vlb6lCqmD5T7081Vzvg1ASFL+ikHd/ZKmZZHM3fU4P7CGGCgLEWMw82dAFkSrm5+hNvFD2Iz8
 Ze5Ip1wFR3aavYVoSucVCB2O78Vn1reMeuJhSzfWfGg9rO7lNMBPv9epNAEDUrNXZC6avqZAD
 ArUKmtsvzM1M4XOcmYt4IkpQfRGzqJUNGwzZbE9gV+3v5ZaMITwRX2rpBV9BCD6dheDbqQgSJ
 1JBMEsEqzPkSr/8+h/ddl63svFE+votEQ71Yb2/ubFTSos387m4tVO5en1lWhu5YK/p6r+9Wl
 3NskDtzqfUoJ/FOSTBLr31EWGst5p5ftLU3GGQM1VXR/TrYw==
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PixArt OEM mice are known for disconnecting every minute in
runlevel 1 or 3 if they are not always polled. So add quirk
ALWAYS_POLL for this one as well.

Ville Viinikka (viinikv) reported and tested the quirk.
Reference: https://github.com/sriemer/fix-linux-mouse issue 15

Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
CC: stable@vger.kernel.org # v4.16+
=2D--
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0a00be19f7a0..e4d51ce20a6a 100644
=2D-- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -568,6 +568,7 @@
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A	0x0b4a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE		0x134a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A	0x094a
+#define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0941	0x0941
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641	0x0641

 #define USB_VENDOR_ID_HUION		0x256c
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 166f41f3173b..c50bcd967d99 100644
=2D-- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -92,6 +92,7 @@ static const struct hid_device_id hid_quirks[] =3D {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OP=
TICAL_MOUSE_0B4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTI=
CAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTI=
CAL_MOUSE_094A), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTI=
CAL_MOUSE_0941), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTI=
CAL_MOUSE_0641), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), =
HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_AT=
ARI), HID_QUIRK_MULTI_INPUT },
=2D-
2.16.4

