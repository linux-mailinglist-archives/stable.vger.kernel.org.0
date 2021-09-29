Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F5F41C128
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 10:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244890AbhI2JAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 05:00:12 -0400
Received: from mout.gmx.net ([212.227.15.19]:57751 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244764AbhI2JAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 05:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632905905;
        bh=0LEmnNPhcWdihF2RjF95YJlRjy/VpEvhtUCClVkra3E=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=NoQ22YzDXYVc3sXRvJUxxZbTH7Tlh7bOQtkkk6SIFFsMXEXH0IU7OllhYyN/9nbAo
         9z2naBmrgWWlrfEZjYAhIOsQZXKD+oejMQLhCaMM9qRQPw3a0tuHeHq4uKo+8obxkK
         gkMOtNf+RSWaM3fhYbSoBpYFMS1a69TPSz/4kRNc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.130.101.138] ([87.130.101.138]) by web-mail.gmx.net
 (3c-app-gmx-bs21.server.lan [172.19.170.73]) (via HTTP); Wed, 29 Sep 2021
 10:58:25 +0200
MIME-Version: 1.0
Message-ID: <trinity-04f4aedd-514d-47bc-8622-cf6b1a264d52-1632905905528@3c-app-gmx-bs21>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, peterhuewe@gmx.de,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Re: [PATCH] tpm: fix potential NULL pointer access in
 tpm_del_char_device()
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 29 Sep 2021 10:58:25 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210924142032.GY3544071@ziepe.ca>
References: <20210910180451.19314-1-LinoSanfilippo@gmx.de>
 <204a438b6db54060d03689389d6663b0d4ca815d.camel@kernel.org>
 <trinity-27f56ffd-504a-4c34-9cda-0953ccc459a3-1631566430623@3c-app-gmx-bs69>
 <c22d2878f9816000c33f5349e7256cadae22b400.camel@kernel.org>
 <50bd6224-0f01-ca50-af0e-f79b933e7998@gmx.de>
 <20210924133321.GX3544071@ziepe.ca>
 <b49f4b52-44c4-8cb8-a102-689e9f788177@gmx.de>
 <20210924142032.GY3544071@ziepe.ca>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:jxiYz/CfHteSo64qsJl+OFqt2ZEi7cgLLlu3QlsURDEaRf1qcf2836+rv8hUCuZubEcXY
 IOXBufYQQSASmDArS0/i4E2Npm5wTfyBbLtF8c7fHYKE2HnyuDG3BSBfjEsQtVyn5m9DwhEz+GKR
 VL37F+2X/7FRBU37VzZKlp2kUXmu9L7cnXSeT3uCScmv+QzWJbEVyUKYjbGnU3YfMYN29otDNmEl
 pZw+FfU1OI4uZYyOe8C/qGmaoPU4y7HeUOitF7lV0o6nkSaQ7bunYlUz4gSH1j9rkm9yoNY3r0cw
 Uw=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yQoCdAJcWJM=:pi5fuWIg9BPlVs+WOjM1Gi
 tRqUOlzFucYaLb8HvycKb40Lwear0svHybX7xRzYidSwelXeuxOatMaruV5mO1RfdPTyvuW8F
 c+GeHzXaSvTvdZnznqurSABvSnY1DJVBKDKzefeK47IED2VTNyGO8Mkgs/4FVNPQkNqPKbA4H
 CEQ5X/ADltCCDP3O8h6pg4VLzvEL9BylgfhKfR1wttX2fk2PoBfFNHMj7bSdxEGGbcFF1dyGo
 NbxtqDBPr0t8xgPBKV2s8KKRZhr69cAILvgMAW0Zz7uaG0r5JVa2c3Fl1X2a1yTaiyZK9Zq27
 cJAIbSyOFw6y/ZEUbmUu8uJLBAHGmWCOLFqv798Z0Mbp3B46i86aD3Tbv3/nSf8a0E9fbvCc8
 fGmBw506xZhbP01CF9OrUMaA0DI8xBZjaHhZQ+6N0sQiUu+MwICfeaUB3aTYL/PWceT09Gq2A
 Y/n491oRRQ9Zcxpf3U4EmOgFGlaM8S9ep5nE0sBwioNqSKA1aZ55PlzmLNSKdducUszns0CTd
 PfmN4FLgIVDgpjfHlKEjRmleZC4/fOKIs+XswuXhw8kJbErFZotC9Wbr3HvK4GgDpBX/jJcOG
 OrKMzD9xDZ4FAuD9SzJLVxSxL7JgueTRANN61t4CA9ghivBKufxt0qC89Unf+1wwg+xMvgK6k
 cNzHMv6qaD0hrKEb5dkZ47XNUy3dWit0jZmrS4vdZEgn1ayKJJb4yradQVg4e6lSO6OZrULwo
 tDjRnbrqOvdRP9jj0xOT+7qxi+A1Y7N3FA4iiaPGLHpq/Q9+h8Ij1yEvtXgdphyfPN6p24+YW
 n40VELY
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> Gesendet: Freitag, 24. September 2021 um 16:20 Uhr
> Von: "Jason Gunthorpe" <jgg@ziepe.ca>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> Cc: "Jarkko Sakkinen" <jarkko@kernel.org>, peterhuewe@gmx.de, p.rosenber=
ger@kunbus.com, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.=
org, stable@vger.kernel.org
> Betreff: Re: [PATCH] tpm: fix potential NULL pointer access in tpm_del_c=
har_device()
>
> On Fri, Sep 24, 2021 at 04:17:52PM +0200, Lino Sanfilippo wrote:
> > On 24.09.21 at 15:33, Jason Gunthorpe wrote:
> > > On Fri, Sep 24, 2021 at 03:29:46PM +0200, Lino Sanfilippo wrote:
> > >
> > >> So this bug is triggered when the bcm2835 drivers shutdown() functi=
on is called since this
> > >> driver does something quite unusual: it unregisters the spi control=
ler in its shutdown()
> > >> handler.
> > >
> > > This seems wrong
> > >
> > > Jason
> > >
> >
> >
> > Unregistering the SPI controller during shutdown is only a side-effect=
 of calling
> > bcm2835_spi_remove() in the shutdown handler:
> >
> > static void bcm2835_spi_shutdown(struct platform_device *pdev)
> > {
> > 	int ret;
> >
> > 	ret =3D bcm2835_spi_remove(pdev);
> > 	if (ret)
> > 		dev_err(&pdev->dev, "failed to shutdown\n");
> > }
>
> That's wrong, the shutdown handler is only supposed to make the HW
> stop doing DMA and interrupts so we can have a clean transition to
> kexec/etc
>
> It should not be manipulating other state.


I created another patch that fixes the issue in the BCM2835 driver instead
(see https://marc.info/?l=3Dlinux-spi&m=3D163285906725366&w=3D2).

However I still think that the fix I proposed for TPM is valueable, becaus=
e
it saves us from any SPI controller driver that does not know/care about t=
he
issue that is caused in TPM by unregistering the controller in the shutdow=
n
handler. Note that the freescale DSPI driver is another candidate that beh=
aves
errorneous in this way.

Regards,
Lino
