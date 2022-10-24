Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661CD60BE74
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 01:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJXXWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 19:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiJXXVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 19:21:52 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135ED4DB0C
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 14:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666647743;
        bh=xOtq67XdsDFXrf5njSRDZKC+erQ6PBNap7r/Borl2mk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=b/AysQvysRWLo3HewIJfvQ1PxxcIPwsj1MoMOWtsN4IueCIBYvvIUZVFadKH2TrZ7
         MejRWDC8gIBjBMGwh573t1SsW7V64I4ZiX+IWyAsZTd7VDvnHpD3EwqJbnkQIyEXmj
         WsdjZzL7O+A5p4argFanSP9gRdbTLKmsREbDRGVo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from silverpad ([5.147.48.161]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MiacH-1pG6Z61QTn-00fkRs; Mon, 24
 Oct 2022 23:42:23 +0200
From:   Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
To:     stable@vger.kernel.org
Cc:     Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Subject: [PATCH] backport: r8152: PID for the Lenovo OneLink+ Dock
Date:   Mon, 24 Oct 2022 23:42:07 +0200
Message-Id: <20221024214207.49365-1-jflf_kernel@gmx.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rynlrdtP5B75eq+jaAhlecl7bS2Kll0pTmuuKdJ0eCu7oRQeJ3X
 0/DFP59N1EdXf+CEeMlEzjk8IDpSH+6CTaILeDy3eWKS0AifNhR/pHv6DvMQlDX18FHDshP
 xW6xsHdOmAWFkG84KGe9p71WwGCvdscw4tx5JQlWLAFA1Fbc2eqBRmNAHzc8CtoqBZXennM
 SVkVwR4gch65JZBjJzjPg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:iB8jqw2PmWk=:j/ji35H/RGrBmnyYK/S8cJ
 QPybIGLQULTZqtGGd+79ZA66bgUPdB5AKA/9T2+1hZrSk2bjhtU1jjfEvIYS8xlssEimJr+3B
 CvBnXFDk9NAAbc+mgwUHy9+wYG50l2F0wb+BwwZ+gM7hC3LrnUEyGfqaMBY0OoIZgN34TeHmY
 X4/dqmq31zAKa6gy4SuGmeO/a33xp5nhmKLs7bcB0H0u4uz0ByXRGS4fTm51m1pqu+9HZWQxq
 70jDuWPzxx+ur78ipFiThL6VVLnrp1SfsTWNbi378XS5z492d5zNG/UN3dY/VoYfFHPOO+uWd
 InqszUTk4BePYSdynyqwT2seWnXfjUdkzujvouZ3ke0D3sL4u/I37Sy40bjICWvjANzW8qk9w
 we9uDO1+Iizutn1vw8AKjxV/6JkT2ua9weg4OgeV7t1pwEtBm+Db/LfL1m1z6SNEOjQZ3oF/7
 qwTc2XZjaJJlfEWozhWcTS85Lp2/9y98guvIWy0ZR6dwJZRiDaC9ooxLzQmHR0SCWO7xg3V6X
 kW+t+lZrUa05llqsqT6Ss2f6DMQ8t8eTUtHFNEmnkKD1wa8EDn4nQR73pEu3G1sSX4X07wIEL
 EYRHzRTQ0MTprwIrwF3Odk/ugi4Hfbv1uwtKfPdqFUcXzbGW0eGpgAAAxq7EYAk2WZJ/VxDuq
 1JJiOXXsovLSaBpa5jblPy+/X7VLmqWuNFbvxCgLLlIhP4EkvCcSNB550V6lvTw3pjUP65MaG
 IH/Xb4by6lIhuMQLJv5iCUzdbIAq3jk0BHU74d7cFfcAML6PyP2NMiiM0RophbRkSnTEBD9r7
 mYY5m74W4SXi1dRCbOhc3PwPpcEeqMSg5BCZZETm/BL/vBFeIx8V5jTVafimrpyt0ov1tWzXm
 q6pZas/IdyJQirNtHo+RkzI4fPmv3EJTKGpI03L+AwItnisplEVS1U4aQ2nmMF4w7nqt/SYWY
 6ERqd9xpT9RO1e06/JSL4SckZq3dc3y6JfilQeJXZMF7DWdejQ658oanPDIdi5EbRoGGZUcco
 kxqravj+3u6DdPEUr2USn8LPZh3xJxyFNjleO3Skh1/yQrVpCmyL37RTqi3I4DmQ/XwyV8fCm
 5a82DDWxkQeZDcDyQ9dVtpGaJ1J1/+HrCalKEwUC0VRms4ID1K9GTjucN/C6LAYnqOMgf7prm
 cbzTlkaOVoy0PdzZXBlAfOMzcqwc8CO5B8LvDM+JF6HSUpUXkbYbkqP/4RZEk5lIgZeRNtMKd
 4YaWudrrm1OZt25yiGBM+V47gxjsfSXMGx7kUSIMlgIcsvfhTh7BTnbHNOtE7leHUFnqENILm
 jl62csB9p8E6OJ1AcnBomXy/u+oUYTh1z9XilFXKMYRqfQoLxZMMgSBDS92PSd5ciWGcsDOcH
 ZDNfeMWqmfEBZuWzKj5t09zckzGHJeo+9mZVSUL4RdFRAJp9zq0q5q3mHWsGAzAO/1dbuzP9e
 HJGPrBncsT2lNgq+3elyZ/7oWD+pAXMZetEJ+y3BKzBEkE/J5cwiTOje/1fC+JewDRGFLT2vc
 46k72Wfs4KkWsHkc89kPUoJD/I4zF2ebugWHy2qwhyXx4
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1bd3a383075c64d638e65d263c9267b08ee7733c ]

The Lenovo OneLink+ Dock contains an RTL8153 controller that behaves as
a broken CDC device by default. Add the custom Lenovo PID to the r8152
driver to support it properly.

This backport removes the PID declaration for MAC address passthrough,
for kernels that don't support the feature.

Applies to v4.14, v4.19, v5.4, v5.10

Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
=2D--
 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/r8152.c     | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 778bd9aaba9f..17b932505be0 100644
=2D-- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -777,6 +777,13 @@ static const struct usb_device_id	products[] =3D {
 },
 #endif

+/* Lenovo ThinkPad OneLink+ Dock (based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3054, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info =3D 0,
+},
+
 /* ThinkPad USB-C Dock (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3062, USB_CLASS_COMM,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 4764e4f54cef..df12af5b87df 100644
=2D-- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5325,6 +5325,7 @@ static const struct usb_device_id rtl8152_table[] =
=3D {
 	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
=2D-
2.34.1

