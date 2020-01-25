Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525231493D3
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 07:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgAYG5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 01:57:01 -0500
Received: from mout.gmx.net ([212.227.17.21]:59919 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgAYG5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jan 2020 01:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1579935419;
        bh=Pyp1Nu1ufI5bta/P31WpriK/UXcofmAdUmNwxcEi44s=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=e9YXXj4avWz6uJ5x7dOjlvLjZVihgNirp0quUr1OAUUSMNGCMu1r8uHLAX9AMWbQl
         Tgusxc8luoM9hRazbALNn7vJ4d6lVwbzo8kHBCk3KgVGy+VTyQQIYaEWxkYNcAlvTb
         OAA4BYZAerVtj3z7XopYACDgvCpkRS3x6QxJSQ0I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from b450.fritz.box ([79.213.222.219]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mn2WF-1jLk5d46JL-00k8GT; Sat, 25
 Jan 2020 07:56:59 +0100
From:   Tim Schumacher <timschumi@gmx.de>
To:     stern@rowland.harvard.edu
Cc:     linux-usb@vger.kernel.org, timschumi@gmx.de, stable@vger.kernel.org
Subject: [PATCH] USB: uas: Add the no-UAS quirk for JMicron JMS561U
Date:   Sat, 25 Jan 2020 07:48:38 +0100
Message-Id: <20200125064838.2511-1-timschumi@gmx.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2Szw5nCdli4UyPDgdZc6J706v5cIOblg7OaOuGGujjBkPPf4sSW
 nXFHQUauZIK3bq3ZoirYloImhvc0sYxoJwjLNsbb4wYgWxIzd17Qn/DDuZZEjchrKJfXQjk
 JnhJu51uXDU2diA2GX/lTeRNbDEK6FzbnLJZDiNksZFXYh6zVVLFb37vooQRhZU9pcY1HaQ
 GcscTdu2gqSWPafEYI4RA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NrTWlySXpVY=:mPTYSNjNhMIVq+Z8QD1cKW
 emrM/SE+4Xsx+Fdt3Tgv0b/DZHvcZZtN3SkBX8duqffLJwSZxf11fKIMKAoTNvhSFQzsIN0mg
 NNIGQ6x9tl69HmQ3SnxiKZaYVba+7FP32KcjLg9OScQcpqmiTzglfEqh9wkBzZTksUk8AHMuF
 FRHnbbxu9AX531PLR+izeBFEYqTi5kFefPT8dlRPJTkKzhwdZPD8i8C9K7UVBwICrVmkmaV2b
 UmJcOHnu8PigUmaWo9zThBP/p06/57Q++5gpgI3DPPc8dq8vLVJcbyVJS3MxSCFgPakn3OUPX
 rmaPRCAyVjSBUCuJyzHSELI6UmOW0CcPZbH5eIwpvZHH+7qVANeWHK5pmDM0raqNJN41TFr87
 yFmh+8nIZqzv+FeQSxPvBie0qouPjsYppnTpIzH78f//V0IZGc3baCclEryPWxOcr87cCqMOW
 rnGhHT2YnULIsOZmd8WZvWSSIBZvp3d67Arv2DDd4qYrKP6XwnbmDsXZ+k6TPa88Qhmibwnj8
 htqDej2lt/Z6rbIJUIt6/0ufUPDWejpjT75jG+Xuq/OWSGBExXrdLygrj/5aB+SxiRDie1ILV
 SzDZD1lATXFLaW+VU74Y/REJeih8ZNJXcbE/5vxuCXwXvxUtOa9Dyma+0lPIY5cK1457xfrVW
 WP7VCPdbMV8ElBDU7Z10csr94lwnFcAfFGUkDURL2nNSd00+s9ZuwOwmzhaB4y+x9A5cR+sBC
 GprKSQ30PCGHTcygSSa6wnm8P6zIbZX7Fu7VEbJWbdU9ELlCDxIf6hTtmvb01FJka5bjM9Zqv
 xNHl9RgN1WDCz6r/NBGSbZ9fWBI2EUntZ5427RR2h+AoZsIIG7pXB4JtQZvgF3FI2enAAIZnE
 mWmt3C8btr2WWza5hApOqqs3nbRkjHSzEQ6DAj5a2kWXyoLKda8U4gCuiQ0yQ5E/GA+9pM47i
 I6ej2ZCCIUdyp1hEfGIFezRRIfbAhhQngYZ8iRL4qr6cvb1Ry5WeQX2+VFy+18ZsxKpc/hUmu
 vr3w+Js0p4W1U5bOfg6IGLDK4PCVNc74NMKYDjKUVSWItrqGMPy63ZtI0Ka2WbHpd/iu06C7E
 DaeD7usT2BK/CFkF3BQUEv/yP2VVIWzLkvFloriF00h/4SWboF4PlAJpuRyB5Y+/8SARX/Yt7
 /9KkLNzvFS2R+bJLgOaFVaaPUm5wZAvQHpACLhkxP5QFWjm6jd7MWKRYQcSy0FX1HrSMwWIwP
 c44Zrd52aQTNqb38G
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The JMicron JMS561U (notably used in the Sabrent SATA-to-USB
bridge) appears to have UAS-related issues when copying large
amounts of data, causing it to stall.

Disabling the advertised UAS (either through a command-line
quirk or through this patch) mitigates those issues.

Cc: stable@vger.kernel.org
Signed-off-by: Tim Schumacher <timschumi@gmx.de>
=2D--
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusu=
al_uas.h
index 1b23741036ee..eaec7d4973b7 100644
=2D-- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -97,6 +97,13 @@ UNUSUAL_DEV(0x357d, 0x7788, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES | US_FL_IGNORE_UAS),

+/* Reported-by: Tim Schumacher <timschumi@gmx.de> */
+UNUSUAL_DEV(0x152d, 0x1561, 0x0000, 0x9999,
+		"JMicron",
+		"JMS561U",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
 UNUSUAL_DEV(0x4971, 0x1012, 0x0000, 0x9999,
 		"Hitachi",
=2D-
2.25.0

