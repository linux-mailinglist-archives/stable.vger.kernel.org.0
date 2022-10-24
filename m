Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E9860BE75
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 01:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiJXXWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 19:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiJXXWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 19:22:30 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4709121E104
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 14:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666647766;
        bh=34Bied5N0pFaT2PynLRhZM95fLkFnAjo4f5/weuXjTU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=N1rdQPnTaeDTxTK3b/55RWjS1L+JC1Cld/JpLRfwwNv2n6SdJYe4kI+LAVPrNlIDE
         qimG7ZNRASCgr0w6dGonuUSZAZTYsMnYzanvLz0N0XdA9UDdJfIBr50GkKBdhHdRrK
         B70swf6v5mK+wF+G7DqU7bczQCcHjIyfA1giFX1U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from silverpad ([5.147.48.161]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N1Obh-1pF6VB1TER-012o74; Mon, 24
 Oct 2022 23:42:46 +0200
From:   Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
To:     stable@vger.kernel.org
Cc:     Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Subject: [PATCH] backport 5.15: r8152: PID for the Lenovo OneLink+ Dock
Date:   Mon, 24 Oct 2022 23:42:36 +0200
Message-Id: <20221024214236.49389-1-jflf_kernel@gmx.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/9tQInCaM81292uivNOciEni0einIi2sLjK57ocOBwhIPLZW2H0
 ud19bN6SmsACBUV6rOR/h2jj4ceyr7OVWkdLqcL89zoL+hk4VXlwv9D41yA9BzF9WmYvrYz
 U7J1QpCCWfZsMh7eH+iEQlBUY5/Ug0+RJIqkI6G7wHlcAzJ1BofwlsjEjBK2BWP469xOkU2
 QP0huC+h8EDbpDLvg3b9A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gfN5gyQFmd8=:xh6NkpZLSpdlkf9cvY6m7M
 /Xve+ORd44tnygLTAsMgIvuNiASWLLEkO0E9uEYIYAiex/F2pSft6TI8PHokd3rczxCcXpMaM
 XRPeyMDnM3dOJOGMX9+jIDpDiJjaa0b3ZL2UWEfhF8hIs+rgGI77gHNVxPU6DWnmthNbWkn6w
 ZmrEenUD9mJDDibIQU5B29t1Cj4/niutiy9Fu2o6wWtiX6R5j3tI9C/9wYyVERgw3APPHq5sl
 XTw7fHPI/j8rnMNwnb7/YZsGwluM+sJpWMKEdRr8SQS6jZR4+6f/cgH3MwJRGIDf+1rp2b8n7
 DgXx0o+YdRNtwAJs+UH8JlhMkvzLLetp38QRbowj0h1ANfaAIOyz+5l95ZIXDprAqldi3k9Mg
 PoG0PTM3Be90znV8FXoyrPCbzAstBJ8cFiLgw/URxj2Sv1LiurJTlv6cqdr+bZRo1GiL2ufHj
 JQYB4z+Pk7rXViNMf8/r7kp4epqfxKzYyf5iqhUWdUuNOPzHGe4pjjCbLGZ/0O8KOVib6FkcF
 JAyC+FfO+i0VRPMs5cOUHv/7t7TpuJM6ndNA8VuzZJ/JUHjstOxRx1Tsrl/Mux59LUFUYC0Gi
 nlNezhQgNAykzooXGlJl1KYVSDrqjQzHnkLQmLgnJqUPTWVRaFDL2TXyqfAeGDyMjP4/6q8xp
 rD2p1JzTPmziU9aYFOrvNvILOZSpscRV4ChbsmqigOMba9l8i56ubufnQIfCl6lzKSPGlBmKX
 kVq1n1iOff0C9yUSzA4uijC91hLOAmAASNpQrRYAPoLwMzqIDgHGBrLkricU5fgeM++8Hrm06
 3M3jsQgI3pKWGMdPmN3CQddm04aTMgrYlz/7F6MFfPWk0loSqQz7zlwrZDvYZycI0qn/BtawH
 k+LTYLnfx5o5Jlwj9z9SFrcnE3kdeWEP/x8hfMmk0WfAkH+q4hqNMAdiOd70//jMHosTi13nv
 cldVZxBCY4svU4EFxwuQDv8ItusyMbJ8OCCQUiKXFw7gV4aFDEWD+9SW23yOiaehJ4KHlqBMo
 Ym5cNExIL8uRwRCQyym08KjtPlGzhbpGIsNNNieAGD6TWuin/Zr5y/p3NI+rn/OlxwgdxZuPx
 Gl5RR6bXqIX3heOvZ5JpysDaxmbGjyvYsVBuzcpM5eLWAwly/YGrpvMPgHicVVbtr/jFYSBkH
 M86yxP+6jdJIfZeIEE32b7BEasN9malYRANAB5hPxfGwRa1DUbxajH9qETB8Z85pjsKHWcjVH
 YZbR4C0zYlEIFk7MCfNdWoZ8fWFrURxhFnpOMY4SIaYV1eWN8kn2DuVVxxNr1guMGYw/dm4TG
 N+m+kwDpfBz/uIfZFgChHHAg/3ZamveTstBm4vP/RspZWO8UPMdjVS7yW9cbuJCGgPtKq7IYI
 uUqv7SRFqHz8mgJ8Xgc2jSaFJTzgcV3XnHD3TIwxCESnDCLNstSphhllejmfKMzo65njpUN4p
 hy89gLUr2QwMo4FGaGcBwLsEKZXSq3C8wCHCQ1Vc9Vw6B9leE5v/TRJevjfuOikzU5qv21VmC
 LU8c+RoUoeqQsxUkIUYG16Nd5HNnk6Kq4Zez4tSFS8fFs
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

Also, systems compatible with this dock provide a BIOS option to enable
MAC address passthrough (as per Lenovo document "ThinkPad Docking
Solutions 2017"). Add the custom PID to the MAC passthrough list too.

Tested on a ThinkPad 13 1st gen with the expected results:

passthrough disabled: Invalid header when reading pass-thru MAC addr
passthrough enabled:  Using pass-thru MAC addr XX:XX:XX:XX:XX:XX

This backport contains no feature change. The patch was updated to apply
cleanly to the v5.15 branch.

Applies to v5.15 only.

Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
=2D--
 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/r8152.c     | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 9b4dfa3001d6..c6b0de1b752f 100644
=2D-- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -776,6 +776,13 @@ static const struct usb_device_id	products[] =3D {
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
index 7e821bed91ce..5183f4522e26 100644
=2D-- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -770,6 +770,7 @@ enum rtl8152_flags {
 	RX_EPROTO,
 };

+#define DEVICE_ID_THINKPAD_ONELINK_PLUS_DOCK		0x3054
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387

@@ -9649,6 +9650,7 @@ static int rtl8152_probe(struct usb_interface *intf,

 	if (le16_to_cpu(udev->descriptor.idVendor) =3D=3D VENDOR_ID_LENOVO) {
 		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_ONELINK_PLUS_DOCK:
 		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
 			tp->lenovo_macpassthru =3D 1;
@@ -9807,6 +9809,7 @@ static const struct usb_device_id rtl8152_table[] =
=3D {
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082),
=2D-
2.34.1

