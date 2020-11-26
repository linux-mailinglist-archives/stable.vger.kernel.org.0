Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C86C2C5B1A
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 18:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404334AbgKZRxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 12:53:01 -0500
Received: from mout.gmx.net ([212.227.15.18]:54493 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404262AbgKZRxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 12:53:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1606413175;
        bh=nOBhEpA++W1t4UnfDj+bEykSMmjmMHvl1uT5U3edw5k=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=KT0jwrS+vQR/Dpg9WdGzePWpvXV3O6mW92lkobfvUAT+5kwLSW5XEeP5BP38+naax
         QfNgOW8YnkDz5oNmHhBIxXD5uPeVgWhL1y2KzSb6rWOO6yVe22kbX07JsNOWP5t+ig
         qxWfl678OWUrv6NnVz31URQ2dOByEvG4YEWzbn0Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([212.114.250.16]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1M7sHo-1kdPUr1Rdy-0052iY; Thu, 26 Nov 2020 18:52:55 +0100
From:   Julian Sax <jsbc@gmx.de>
To:     linux-input@vger.kernel.org
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Julian Sax <jsbc@gmx.de>, stable@vger.kernel.org
Subject: [PATCH] HID: i2c-hid: add Vero K147 to descriptor override
Date:   Thu, 26 Nov 2020 18:51:58 +0100
Message-Id: <20201126175158.1183879-1-jsbc@gmx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:TaP5smSisGTyBhAzv5a1G5dhYzS1WkBhs6Nn5KuiRK72xy/Rw13
 Iufbi1zrbOK5nNGc9clOoZgocV9Bp90YTnSzTHSFLE/SCU+HmtXMQh/w+b8SifgDvoiIOE/
 6Idc3h86he4TGrmVHpcEyub9ZZgbvOwRdnHDrthFBvgLIvDVecTnZVbV5ALgZrP6j+W00Hj
 f9svyIVDZHqsaHO973C9A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TdzFNf/ojJw=:zRqonKDzjkjBl3DxnA6G6/
 h8GdRN/aGYKrGiEhvSTXCOLQvLcLNzwkvrpoBrkaz+oUE9qT8OXv4hP20prF3ZMk6WYG7YvaZ
 4F/4a+7ORsjQtWzKLz9lAXzghK2/DtIIdwqdOVn2QTvmUUeZdcv5p1xju7Qi1rdfkM7cKV6T+
 DK8RWHwqEXXJEbmlJnfb7sxiEv1AhJq38ZIc34FANt+fsFnc4GuWbvtEc9Y5tJ34PZuFHrlDe
 SuHgFz0GpXGrvuPX6fzfvUuEZ7NegSHa/yY8y6Sr8uXUpQ5uywr8fFONZT+Y7CI+jdM3mqqZS
 95N91IYqvwzG87z6DgHeV08hpyUL35T6ZoWnyvHSR64acPxoEIFPcxSgE4Zmrt9+yWZgYVoSp
 0BT3ULfaezWgk5sNx3VSKy8H7FifJdw9wXsVcq2yF/diHel/C189GjUhbaqZ+54Yr+iUQLrXT
 R8zR9gTJrd5R0tDx/rfgLfEPFYG3Q/zVhqvz7KkyXLDwRgXqFW7wa5EAggibCh5QnEHVsdEMK
 +IAuywlTnYpNEu6c2TwKUkktznNOThobedKPPHbaGHntNceIjuTdnJhKx6fjxzRLQ4o10s4In
 jch+Y6bqb1qHi55Q/3VxyNQEFnUDiXFtWlhduBhvis2S1ODDb5TAgvYJkwcgliLBZZ/rH2X7q
 WgZfszUBQmxxRet7U1FPC81fHLBswFJwKysTI0IuSr0AuGRdcGVKtmbiG65ngF2848NOzAiS4
 HFUgAdLwV4oOsoo18HlxzAFD14uEiCNt13uOO3UAG9uH5YABufhM+bZqP+3jTiMRamUDeg2OT
 l71OtJuBcvAWrLcGerJ1fUbtQLZ3C3cRt3enTPaRKUCJkPN0P6prf+WgdSzQ1HHbKPU7CeYf3
 5cUSsIzuOO3lZUwOuRIsTfAfjz6gHeM6SMBvrlgzk=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This device uses the SIPODEV SP1064 touchpad, which does not
supply descriptors, so it has to be added to the override list.

Cc: stable@vger.kernel.org
Signed-off-by: Julian Sax <jsbc@gmx.de>
=2D--
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hi=
d/i2c-hid-dmi-quirks.c
index 35f3bfc3e6f5..8e0f67455c09 100644
=2D-- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -405,6 +405,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_ov=
erride_table[] =3D {
 		},
 		.driver_data =3D (void *)&sipodev_desc
 	},
+	{
+		.ident =3D "Vero K147",
+		.matches =3D {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "VERO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "K147"),
+		},
+		.driver_data =3D (void *)&sipodev_desc
+	},
 	{ }	/* Terminate list */
 };

=2D-
2.29.2

