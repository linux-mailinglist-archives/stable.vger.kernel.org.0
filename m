Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322E51496C0
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 18:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAYRAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 12:00:40 -0500
Received: from mout.gmx.net ([212.227.17.22]:42339 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgAYRAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jan 2020 12:00:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1579971636;
        bh=wNH9BllkKG8EE89X1RLE191MHeXHVB0YQd5SRPjfqIc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=WPjHJJDM6kWflVCUCbkaD1/m5QGDrqzmQQcbCVNxBS9ofarOCtaGzHXfWSFoPn519
         6Nqh0LH2fss3hxIbCxmF2lK4Xo/rCY0jF1B1rbowTyiSsvRou2lmMJAuZH1U6JZmAz
         Ki0ce7zKDx/3snf9CkSFQ76Yt014oumIVpwTNhxk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from b450.fritz.box ([79.213.222.219]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N4Qwg-1jcsZ3223q-011OIm; Sat, 25
 Jan 2020 18:00:36 +0100
From:   Tim Schumacher <timschumi@gmx.de>
To:     hdegoede@redhat.com
Cc:     stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        timschumi@gmx.de, stable@vger.kernel.org
Subject: [PATCH v2] USB: uas: Add the no-UAS quirk for JMicron JMS561U
Date:   Sat, 25 Jan 2020 18:00:30 +0100
Message-Id: <20200125170030.25331-1-timschumi@gmx.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200125064838.2511-1-timschumi@gmx.de>
References: <20200125064838.2511-1-timschumi@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:q8k5tYkzfGEoYPSnVRjumFwBh321VZgrtFo3RV3n4nyIhdgtCSd
 NrORl2I4lZV5f9fqvXgyUBGg79f7b2zT+Q8a5UdmGauQFfvkDB+oKyYKYKZB0OUVXZ4c7iF
 Qb2ZyijkC77we2YBPa/ZWlpuN9xtsYHcO5H9CHFOkS8ojxFB0aRmszIvmJT6DNWYvaIQR+0
 HEqKcjHiZc4K9c9w+SfCA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1qrIIkD+eXk=:zombyqa2IrTvhdexNqjuRq
 DGxj/nMhONMv4EE28RV+zc1Frx5W4TZjniH3kzNQCvUZ7hGadOilKvfUtAwzd8AFMv0Zn5hB7
 bUyQEkKseZ4Pn2cZzUf93qGOj4AXUQXseujOGLTHPLDS+IR1VznyGqXQjoDIO5jsujIlKqxW0
 iQAcPq3OJmirDyjX3CsvO+6ibtbqwjBWlsjXzFdJ4UxlSgFUeIClP9hrmaB/j6rTV8DrTjIRz
 nYq6bffB1Q6icXdiY9heqE6N6b1XmPRG3sSxP0wKw03a+lq5wZlhenJnIbKp+kHkBjFA5+ZO3
 eV0YfPhMW44TvfRCPdou56qGY1Ny4pFqmR/EwqxDRsrIZoJEzjIYAvF+wLLkdsMtRtsgxQIrW
 IBcNzVYBkDKz0JuB9XAZL+Mvpe9re4rZ9xuSx7cGan8SOzHrNg5eNXbCUQ1IjMSwq5Gxpl0UQ
 v06fnSXZ9L0su/Caw4Qn58HFO0SYQ6rKBNq3+ZPxUnjsO0cnY+DI084sbkOS3O5chjDKI2ehf
 nms/FBzk8iSaPu135NihHdIDaRGnjhN3bravtt2Z0DLpCe/xOZRY+UA1kCk/FlyRdmAyL+Ky3
 j58XY1AxszvLtq+QUrfLuDvXiDRCDBeTfQoC4ZIGcvGRmYK049rY4SE4qnjIHEFGHj/wK6v4t
 EbVzU5i/VFoVaMA/BPOmxPv8tlP68TjvSA6COLYcPYf8ZnSkgvHVGZaEQnAaNx3Kgjr3tED9p
 v7T9Omq/VrJIpHkUY53hiuP2M4r6IEOhreiLX6qOxNRGsUF30Ryei3pKwyv0SABK7SrorM3Jc
 uyiqtXUVNPhd0thbkxDdmqjlxxqdY24qHMFYFyz+etszaYrXVEXe3VoGbne+NejiBdDPaMioc
 5OFT15Qh7uCdzGPi5aWksxGb0/lBIUWo2n8pFTANN9jf74hNj0YYsDKXIdD6r+TZcBJWnG/+O
 K71em4eEPGJecQMxpQ2ZmO6akg+gMHosN1L26B3SFxxAMNImV5U6nV2NlbHWnqvIGiHueOh9e
 hDaQnSgbG9dfCASg/HGP9n35A0y49enBU/ifxRqHG0MoBBszfK4k2G9hm5dThll0kkwvYYehB
 uffAw7kq1CtN2pzUl26bXJoKgW9SWB0GWpR7mB1byoplULGgXhYn2sqk5voEGWivkriS3AxCI
 +p6EPlb9TuubGThEk/ja81lXw8APh+zg8x8br5Xcu5UZ3fZefaaP/MTD9LuNoq5fP2PpZ0cNd
 twf8kHLtdaI87de9J
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
v2: Fixed entry order. Also, CCing the correct people now.
=2D--
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusu=
al_uas.h
index 1b23741036ee..a590f4a0d4b9 100644
=2D-- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -73,6 +73,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BROKEN_FUA),

+/* Reported-by: Tim Schumacher <timschumi@gmx.de> */
+UNUSUAL_DEV(0x152d, 0x1561, 0x0000, 0x9999,
+		"JMicron",
+		"JMS561U",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
 UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
 		"VIA",
=2D-
2.25.0

