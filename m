Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4BB1C5ABA
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgEEPMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:12:23 -0400
Received: from mout.gmx.net ([212.227.17.20]:33091 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729332AbgEEPMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 11:12:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1588691536;
        bh=rP2jwm5r1DSsgQcMQyTdDXK8vZHVg6r+l7O9JIrJHNM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=iDiXTUjqdcI/8c04L3AeaCi0hUu+fW5bzn8Lw4h2BNmoYekmHUUNpNyynneYirP4I
         ejhAYNpUIKvarVuvfzOVFmgq/e4a2eCCD67GDUtUNBZwHyFYFS9S5zyZh1kKq2yLOJ
         N68KyFNHiO+7DYQHkXgbrJCLYYrmUqUoJsXacW9Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([212.114.250.16]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1N3KTy-1j66P743ve-010L62; Tue, 05 May 2020 17:12:16 +0200
From:   Julian Sax <jsbc@gmx.de>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julian Sax <jsbc@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH] HID: i2c-hid: add Schneider SCL142ALM to descriptor override
Date:   Tue,  5 May 2020 17:10:42 +0200
Message-Id: <20200505151042.122157-1-jsbc@gmx.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1xGtNobj9IeDfNsT7NU9grJu6PKvdVE4rsepR8eiLGugWh9vK2t
 X374UBlmCSX1GJbm+Vis111h+wVie9BpMQt/QVPyEle8yJRHGLsRFSWerk7KbU6rVgUvIFI
 iAWMmR2+Uc6cv2jSLm5zlwA17JdxerpnOfDqMP+nvCIIxJN+KQVpbLT9zHR6KCEhjGo6+15
 HEuZ7/ugGknrEmahEJBWw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2vDpBxRuuzs=:ODep58ZEW2ncfPvvDJi5tC
 KL9PsAJNtm8M0ZjM7nSNLCYSMoUA1kAX/neIPBo9QgiAl13fMvPwwVTC68yN0HiG8Wcn7DHmX
 iqHtyYzhvCFBhmzOPbAW6dFZcYh6tHZPIlhVZPphak/q6qFlSY1+iRuqrfiN3f5Rp5s9dTcOw
 cYpu1DsEwF69JLQv7xMv1XnnGmlQBqZIaLTpTMKsX4XHhL4eNtCqHDj2suDAwBMk/L0JCfivW
 0FCZSlrpaQBJCUU6Ff6YfqtTn26Fz3pjyaUmYgokiUv2ac2dCqvXGqICT1bJFZhyaoo/IFapW
 /AJ1GHc6cG3zbUHr48mZ0gz/YVpVhDPiPV1vPnKWSFTnXQ58OMpJHcQF4quJ+wP/P/jROPGxc
 6YFGIUKl5s4QYXw5enkFxNYAun4Bz4QHLCwDNNSqADTlXC+wsH/Apw8fNoyABI+mAlIXy8Q/A
 fVlkhrvah+AWOoWNcfiRGYrjy9E7iiJlGrgzJGIkw34O9OKYxUVFeL0iEu87BgJcLRS9TyITO
 i+6N5+3jA+AwGS4Ki0LZBPgoMKVR/ystVB+HD48lCw9tqcuNDRKo1BbOmAVC9c+YZtvw9yiFv
 K07vr/tc9EBUul93FH0L6BsWKp1S+8iJWURuRpar8Fsf9ym3619gH8Wk/t808bQiHBMa1brzs
 cnfs5SOJ65s3jYKP2ud2+fMuUf6M2/WSC5T4/oDBXLF3F/gSp7AMIwNpbyx5hZ3EmJmquQhUN
 dLndPl4d6cJtHT3sVmfxxYhjzasfbyutv637HYfOyJkUJ4nB1M62CfqrwCsCxg3mENqdQXxOP
 1qP34DZX0l6QKNUJawGoxqmO6A3/+zNREdZXeiqPnKrMaaKVx6YrshgnbK7+0pS+CaIRq+jIY
 7ojY9RriOyfuMGozeSbYmz1kht2bgJ1Wm2NgODVJ0F71bDPCq6MCYnt63UT8Su6NUnQIUvZD3
 G9SZfA91TW+3oi96CV6fal2HIzOssG8L/WXMp2VocqSK6ONIDIIQxqu1evZ0lUiMDXkxWc99N
 +TeBgs1F73WyuHNEouvbKlhISKb0SIxs8kCRpSVLWKQ16cpkMzVKKv6sD2ULsOy8qaXE0p216
 3jfx5YJIx/iQE6tyywDpzw9dU8stKpM3lYIU2KJXImZxBBbjymbKAjVOfPmLRy4BmpH1RSrs2
 hDBj8K6suxsSgAmlyQfiSvAqlQgaJXv/wP5ohNmL6TzcXwWKFoAoyUf6ISrUrQfelH97c=
Sender: stable-owner@vger.kernel.org
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
index a66f08041a1a..ec142bc8c1da 100644
=2D-- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -389,6 +389,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_ov=
erride_table[] =3D {
 		},
 		.driver_data =3D (void *)&sipodev_desc
 	},
+	{
+		.ident =3D "Schneider SCL142ALM",
+		.matches =3D {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SCHNEIDER"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SCL142ALM"),
+		},
+		.driver_data =3D (void *)&sipodev_desc
+	},
 	{ }	/* Terminate list */
 };

=2D-
2.26.2

