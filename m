Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76CE736C2
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 20:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfGXSkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 14:40:55 -0400
Received: from mout.gmx.net ([212.227.17.20]:55711 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfGXSky (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 14:40:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1563993647;
        bh=NCeUojoxFFYM+G1ohpSdCBkGGMqb0rVc9tlVw55xvYA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Qkdi+wqiZT4MSOSFRy0R1umIV7CN2SBHRP4GHI/3lcW2kVrdG4I9vXKcPbQun/B07
         cSryTShaxMFa+sql25ZY8izinkvHy0yX7CLP1/MBbmIgwNzoeOuTWLV+nCEsNSPS5x
         NDjQBC9o6Vw/NlWVVtFthUd352+3Jg7jMxnQKDW8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([95.91.214.136]) by mail.gmx.com
 (mrgmx102 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0LaaVn-1iGJP62OQJ-00mI7v; Wed, 24 Jul 2019 20:40:47 +0200
From:   Sebastian Parschauer <s.parschauer@gmx.de>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org,
        Sebastian Parschauer <s.parschauer@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH] HID: Add quirk for HP X1200 PIXART OEM mouse
Date:   Wed, 24 Jul 2019 20:40:03 +0200
Message-Id: <20190724184003.12402-1-s.parschauer@gmx.de>
X-Mailer: git-send-email 2.16.4
X-Provags-ID: V03:K1:xYKG7v5hCxteWa0jER/cY+3tgK2y34RnYQl9cmkczWHJFm2466r
 JPigP3gjrizdEaZqBNOj2+TKufV2h+LyBVz3HPjvyYWhiZ5guJvWkxfm27U33m++BJkY5m6
 FVlf1FCTtfL0hJVdHr+ykotN+Uz44IaE2sfozNJbkldw2PzhziC83TGUMWLTVOC3jAhyun8
 pYpwlWFQ38nvhi0zPzluw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fCBKbaUNs/w=:HCIF7NCPhMZa+bhAaOy4K5
 kw49RZuAAyWW9yLqK/rcl8bnBoSJ1f9RJAiCUqgMO21q3IBmbtjHewS9pc0w+f3f7PvLgIMqt
 o90Y6vBdRS8suxdZ5fTf2wvlIvGZV9OxLS67TwSfz10XbI2KawhF4GpRmGLpO/3AnxFl8fRb2
 1HCPfxWk2X2HmyStI3M30P8x3LzYPrT96CYsqH3MqxNMgS3bJzXikJ4KeKMa991aGwCF3dE2g
 nKignNOGxZFc7ObXsmbzSrDBOKuv8vXI1QZlT0uEX8Q+3y1FTjYccr9CLnLgOsbAc2XrC9+ez
 FG+pYcB5kRMhvBmyZgraa/by8XC+FLNTAmcbgL7+puYaCoavkNW8H2ioc11ucdgtsFSgTyMH/
 DnzsjL0fYTRmp5u57bbDf/5VG8+849T0vD56kIf+QLUNQVokRJZ+s15dDhwtxblAcAZbyw1lg
 Fv6e26zKquBfM/HpFF7YjB38mTJ90YTr1+h73EJaN0b/tT0HYvd5gWkz/gPR8GIM9EyJSYGrr
 P8k1vkGalgoEvZ7UhyB3nHRsOP9Ok3gerFMZh28gWaYWRXkC2q5FXqV/zKeH/1ro99/wJ4pEL
 pVfm8wunhakjXylmSucRO5lRtGjxQt5KvVJi5LnwFafB17Ffr2mBCcLtA+SE97lRSXcZo3m5N
 4zUC2MaPrHqfTD+brQ4iSISyjV0N7EtuSKlb8tlMQViZ/0HqThqTppfqeYapbNzPAutL1IxKB
 x0ckUb1epg56Vwl1C5Cpy6HGBuJhUFuh49aHCyxvsc1YIZ+BKQC8An5q2Kk6egcmfRAFSbCn4
 Riy/CWNRyi/aROYA4Bz1jfK3/V7qf/tPDzpK9n394yGsMirn8i6V68M8b3P+F6nYF9G86xDgr
 MBqV39kygz1E1mwwrWU74qlA/LypRMcSstSMw8ya+W5raH2Yhh/7jcqLA1/StXGJ4V1IGoqMP
 BxbeW2+QVTdmSYoZz6U7Lf/nWKZbnq1TMCGDtwqGQeRtmZGKfqch3m4cpoev7o8on5L8+yjz3
 Wz65XujpO6KBy7qvkwPNO/NcmZ0yGysV5EWsT2GbP5F578TQ4wjPSvESygxyX4zYX4G1EKlGn
 JLK643pFP8PlQg=
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
CC: stable@vger.kernel.org
=2D--
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0d695f8e1b2c..2b5bdc654501 100644
=2D-- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -568,6 +568,7 @@
 #define USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0B4A	0x0b4a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE		0x134a
 #define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_094A	0x094a
+#define USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_0641	0x0641

 #define USB_VENDOR_ID_HUION		0x256c
 #define USB_DEVICE_ID_HUION_TABLET	0x006e
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 185a577c46f6..7239b9724b4b 100644
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
CAL_MOUSE_0641), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), =
HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_AT=
ARI), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X), HI=
D_QUIRK_MULTI_INPUT },
=2D-
2.16.4

