Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FEB195869
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 14:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgC0N4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 09:56:01 -0400
Received: from mickerik.phytec.de ([195.145.39.210]:57974 "EHLO
        mickerik.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0N4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 09:56:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=phytec.de; s=a1; c=relaxed/simple;
        q=dns/txt; i=@phytec.de; t=1585317359; x=1587909359;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=w/C/DGhy+XVpgJUliLirqFOfdwQNqUxARZ0xfZPOw/o=;
        b=pRjFjC2CT1BOCxtWhQ4WqoOP4CBfGpVeLYqIaZyBlStdd/+spbrCGKi5HyjPKmKq
        sPIRh1pgqBNREXH7K0jdkSkeP+HbdNWTH41OTsRygUi8lPPJHlmCgKMz4Q8rCJqA
        N+8XsnO7Fg52sGiSRPO0x76jzHQb2/76VdEu/W7+j6M=;
X-AuditID: c39127d2-583ff70000001db9-08-5e7e05efcfcf
Received: from idefix.phytec.de (Unknown_Domain [172.16.0.10])
        by mickerik.phytec.de (PHYTEC Mail Gateway) with SMTP id A0.83.07609.FE50E7E5; Fri, 27 Mar 2020 14:55:59 +0100 (CET)
MIME-Version: 1.0
X-Disclaimed: 1
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
In-Reply-To: <20200327133624.26160-1-festevam@gmail.com>
References: <20200327133624.26160-1-festevam@gmail.com>
Subject: Antwort: [PATCH] ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl
 entries
From:   =?ISO-8859-1?Q?Stefan_Riedm=FCller?= <S.Riedmueller@phytec.de>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     shawnguo@kernel.org, kernel@pengutronix.de,
        Christian Hemp <C.Hemp@phytec.de>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Message-ID: <OF690DE83F.5FD7A3A3-ONC1258538.004C346E-C1258538.004C8958@phytec.de>
Date:   Fri, 27 Mar 2020 14:55:58 +0100
X-Mailer: Lotus Domino Web Server Release 9.0.1FP7 August  17, 2016
X-MIMETrack: Serialize by HTTP Server on Idefix/Phytec(Release 9.0.1FP7|August  17, 2016) at
 27.03.2020 14:55:58,
        Serialize complete at 27.03.2020 14:55:59,
        Itemize by HTTP Server on Idefix/Phytec(Release 9.0.1FP7|August  17, 2016) at
 27.03.2020 14:55:59,
        Serialize by Router on Idefix/Phytec(Release 9.0.1FP7|August  17, 2016) at
 27.03.2020 14:55:59
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
        charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRoCBS/c9a12cwbwdHBYPr/pbrJq6k8Vi
        0+NrrBYvtohbLNj4iNGB1WPnrLvsHptWdbJ5bF5S79H/18Dj8ya5ANYoLpuU1JzMstQifbsE
        rozlh64zFRzlr7j/YCpzA+Mm3i5GTg4JAROJGz1vmboYuTiEBLYySjxZN5EFJMErIChxcuYT
        FogifolPf1rZQGxhAV6JTW9nM4LYnAJCEh1XO1khasQkJqz7xdzFyAEUt5BoOCUIEhYSMJf4
        f38rO0RrnETHxE4wm03ARaK5axs7SLmIgJrE6Xn6ICcwC0xnlDj+9BITxAmBEmd3bgFbyyKg
        KnHw+ksmiFXOEov/XGABaZAQeMUk0da/F+wGZgFtiWULXzND2HoS/3+eYpzAKDwLyTuzkJTN
        QlK2gJF5FaNQbmZydmpRZrZeQUZlSWqyXkrqJkZgLByeqH5pB2PfHI9DjEwcjIcYJTiYlUR4
        n0bWxAnxpiRWVqUW5ccXleakFh9ilOZgURLn3cBbEiYkkJ5YkpqdmlqQWgSTZeLglGpgFP0/
        pZa5JXBWZaLnGY5/C05lJe/PSnuz2c3uxvl0RqX5/IzWay+zbmNNrb6x5EtCppOc36fZXYtT
        BJQXqmw9ZGM58cXBaK/9b3lqZYLU/zK+crq/JZ/PUfjOQbVLlpf879cxJP2pE7RIjG0/dmBr
        csgGlvLsHPWZH/2nT8+3Zo6V7hM//+O3EktxRqKhFnNRcSIANlITtnMCAAA=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Fabio,

-----Fabio Estevam <festevam@gmail.com> schrieb: -----

>An: shawnguo@kernel.org
>Von: Fabio Estevam <festevam@gmail.com>
>Datum: 27.03.2020 14:36
>Kopie: kernel@pengutronix.de, c.hemp@phytec.de,
>s.riedmueller@phytec.de, linux-arm-kernel@lists.infradead.org, Fabio
>Estevam <festevam@gmail.com>, stable@vger.kernel.org
>Betreff: [PATCH] ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1
>pinctrl entries
>
>The I2C2 pins are already used and the following errors are seen:
>
>imx27-pinctrl 10015000.iomuxc: pin MX27=5FPAD=5FI2C2=5FSDA already
>requested by 10012000.i2c; cannot claim for 1001d000.i2c
>imx27-pinctrl 10015000.iomuxc: pin-69 (1001d000.i2c) status -22
>imx27-pinctrl 10015000.iomuxc: could not request pin 69
>(MX27=5FPAD=5FI2C2=5FSDA) from group i2c2grp  on device 10015000.iomuxc
>imx-i2c 1001d000.i2c: Error applying setting, reverse things back
>imx-i2c: probe of 1001d000.i2c failed with error -22
>
>Fix it by adding the correct I2C1 IOMUX entries for the pinctrl=5Fi2c1
>group.
>
>Cc: <stable@vger.kernel.org>=20
>Fixes: 61664d0b432a ("ARM: dts: imx27 phyCARD-S pinctrl")
>Signed-off-by: Fabio Estevam <festevam@gmail.com>
>---
> arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
>b/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
>index 0cd75dadf292..188639738dc3 100644
>--- a/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
>+++ b/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
>@@ -75,8 +75,8 @@
>  imx27-phycard-s-rdk {
> 		pinctrl=5Fi2c1: i2c1grp {
> 			fsl,pins =3D <
>-				MX27=5FPAD=5FI2C2=5FSDA=5F=5FI2C2=5FSDA 0x0
>-				MX27=5FPAD=5FI2C2=5FSCL=5F=5FI2C2=5FSCL 0x0
>+				MX27=5FPAD=5FI2C=5FDATA=5F=5FI2C=5FDATA 0x0
>+				MX27=5FPAD=5FI2C=5FCLK=5F=5FI2C=5FCLK 0x0
> 			>;
> 		};
>=20
>--

Reviewed-by: Stefan Riedmueller <s.riedmueller@phytec.de>
=20
>2.17.1
>
>
