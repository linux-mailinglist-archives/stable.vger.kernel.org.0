Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC1C41C0C5
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 10:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244685AbhI2Ikb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 04:40:31 -0400
Received: from mout.gmx.net ([212.227.15.19]:58697 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244459AbhI2Ikb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 04:40:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632904717;
        bh=69pRpa6l2Y08HczbwXoeIQeKFHMhbQLtr9C6GLFurWc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=A9H+y8imr9orFbW6XtLfjHN39XTK2JNwDkvLn6vuSkUrWhXW2qtrH0CA/1iPqeNnf
         qP3BRmG3eiJyctp1bVdBzDGW5FUrPsS+J0OFJIjeRoWX4y4CQ0dTvlvEVCHWZp9wws
         uPYhHLtq3uHBZGu4QU+4ZtLGsdC+XqmYUTLJ8lLQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.130.101.138] ([87.130.101.138]) by web-mail.gmx.net
 (3c-app-gmx-bs21.server.lan [172.19.170.73]) (via HTTP); Wed, 29 Sep 2021
 10:38:37 +0200
MIME-Version: 1.0
Message-ID: <trinity-4f6dfbb9-adbe-4569-a1de-1e6502eea309-1632904717666@3c-app-gmx-bs21>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Mark Brown <broonie@kernel.org>
Cc:     f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, nsaenz@kernel.org,
        linux-spi@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Aw: Re: [PATCH] spi: bcm2835: do not unregister controller in
 shutdown handler
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 29 Sep 2021 10:38:37 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210928200843.GM4199@sirena.org.uk>
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20210928200843.GM4199@sirena.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:b8hgkS5jXCfvegurMfbZnwGpqsyAAk/k9HKW4mOlU5AC0UBZUo9OkoB/WCdb6WkVevUY0
 Ydyfk11n5YxknZnEGRxqV4qq+CUVg9k9jHjgUOIAJS6eiPDRuVxTbNmhJZBdZ70FbLZjgWqE+BTG
 OeAbjUaKCmXBWjA+1K7H+KQ7+CJ7EjqOI9eZZNs0qEZhGS50N9qZp0JZk8T9i8zj/+k12IpKSRM/
 JhkcAeegsUKui93HHopQtydG8mZhgkmqro1qcnilIZ2FO2AZefArxu9WMO0OtVdwj1kouxibqf0Q
 /0=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0CB2d6rUfk4=:nNGEIyKajqtJJj6uXiCAXv
 huiclZoRqXFelSqItT/tQ+jqyU1sOyyYoogxhYg/P3sL65KAg3b8cbziaUOZe7lmpKsoNBIn9
 ENmYQjFlm3RQAxRmwUK4YleMjEy1yNfS199WCV9CyMX08WI/3A+aFGca+bbXPZbPu4pXGSHm4
 IuoZY5k+LorE5kU6kIUc1HgJo3fd6oCky4ByVmUv0b9hDuH4viz4SD/5j4dI7pGBURLHB/UGw
 TkqrkIKEsWOaiEXxxbzBf3IlfbmJOFLwhbhlpZLSuyxXuuMdAJ5QOLNpAFqO5ht/364+bMDdb
 D/iTFbkYZQ9VGrnetBRqWsVsZHRCLNaluLcHbwpuFU7kbiV5mLaNtj18fVmr/32JJpthc64oS
 GBQaSu0owx624wq/p4gMGWIPQtnc1nni0bSMRFZ0MTEHMPDnl/Lzlvh5sw6lcg3fgS2010kWL
 mQiCtVeFvGhjm5J03l52UIt2GSEtiM+RuHaFqMhyDQQ2ZGuYBiQABfpAIIAhBmP2nadpBDINr
 L0sWrK1VEpIAnGh/era1ytcVl2NuXJHvscg5spKJj5B5+kQu67YASEL3hB181Rsh+O/ZFi7+I
 3PojC8gvkzp0psq2weQuPZUUSRIhuPpBc3flxRnzctd5tEp1/6VgiIiV8yzh0nsPCVjiBLzzk
 17NmEJa0BBcHm/oh8tThWojofc+0ZOz1b1bwYAEYNVV+mUVwOm4D4l2fK2e9ZfYLNnUmGu314
 krs9qJGZ7ZkQ7Zzp/6lEI5fx41ZqHhUe4FxpmCeZpd7KviZKPgzmCsM5k+vNIgVXyRJpU/kGE
 nUUXupI
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

> Gesendet: Dienstag, 28. September 2021 um 22:08 Uhr
> Von: "Mark Brown" <broonie@kernel.org>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> Cc: f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com, bcm-=
kernel-feedback-list@broadcom.com, nsaenz@kernel.org, linux-spi@vger.kerne=
l.org, linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infrad=
ead.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca, p.rosenberger@kunbus.=
com, linux-integrity@vger.kernel.org, stable@vger.kernel.org
> Betreff: Re: [PATCH] spi: bcm2835: do not unregister controller in shutd=
own handler
>
> On Tue, Sep 28, 2021 at 09:56:57PM +0200, Lino Sanfilippo wrote:
> > Do not unregister the SPI controller in the shutdown handler. The reas=
on
> > to avoid this is that controller unregistration results in the slave
> > devices remove() handler being called which may be unexpected for slav=
e
> > drivers at system shutdown.
> >
> > One example is if the BCM2835 driver is used together with the TPM SPI
> > driver:
> > At system shutdown first the TPM chip devices (pre) shutdown handler
> > (tpm_class_shutdown) is called, stopping the chip and setting an opera=
tions
> > pointer to NULL.
> > Then since the BCM2835 shutdown handler unregisters the SPI controller=
 the
> > TPM SPI remove function (tpm_tis_spi_remove) is also called. In case o=
f
> > TPM 2 this function accesses the now nullified operations pointer,
> > resulting in the following NULL pointer access:
> >
> > [  174.078277] 8<--- cut here ---
> > [  174.078288] Unable to handle kernel NULL pointer dereference at vir=
tual address 00000034
> > [  174.078293] pgd =3D 557a5fc9
> > [  174.078300] [00000034] *pgd=3D031cf003, *pmd=3D00000000
> > [  174.078317] Internal error: Oops: 206 [#1] SMP ARM
> > [  174.078323] Modules linked in: tpm_tis_spi tpm_tis_core tpm spidev =
gpio_pca953x mcp320x rtc_pcf2127 industrialio regmap_i2c regmap_spi 8021q =
garp stp llc ftdi_sio6
>
> Please think hard before including complete backtraces in upstream
> reports, they are very large and contain almost no useful information
> relative to their size so often obscure the relevant content in your
> message. If part of the backtrace is usefully illustrative (it often is
> for search engines if nothing else) then it's usually better to pull out
> the relevant sections.
>

Thank you for the feedback, I will omit the stack trace in the next versio=
n.

Regards,
Lino
