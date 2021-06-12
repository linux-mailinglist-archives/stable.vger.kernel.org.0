Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA36A3A4DB9
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 10:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhFLIkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Jun 2021 04:40:11 -0400
Received: from mout.gmx.net ([212.227.17.22]:51745 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhFLIkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Jun 2021 04:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1623487077;
        bh=v82NF7idhXxEKXd9ZGewx8q+PKbcni0kN/gmoD4PD48=;
        h=X-UI-Sender-Class:Date:From:To:cc:Subject:In-Reply-To:References;
        b=dHQWyxLDyIKMkboznMFYOzxhJqyz6/N7Gap01w7aGUQz9oC9WwadaD106SdlRoO99
         HY3SLuxNYwBpZmcGCjkPr4fP2U37lEZPydi4EJWhQ4Ld+z10hYiu2W7x2Yv0M1pJF7
         KVkO0Wpl7vmxBIreylmz7vNzmOxK0i1FstGOLdzM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mu408.grange ([89.0.161.150]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MWASY-1lqDmQ42he-00XezM; Sat, 12
 Jun 2021 10:37:57 +0200
Received: by mu408.grange (Postfix, from userid 1000)
        id A38DB1D80261; Sat, 12 Jun 2021 10:37:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mu408.grange (Postfix) with ESMTP id A0C6D1D80064;
        Sat, 12 Jun 2021 10:37:53 +0200 (CEST)
Date:   Sat, 12 Jun 2021 10:37:53 +0200 (CEST)
From:   Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To:     Leo Li <leoyang.li@nxp.com>
cc:     Arnd Bergmann <arnd@arndb.de>, Fabio Estevam <festevam@gmail.com>,
        gregkh <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>, Joel Stanley <joel@jms.id.au>,
        kbuild test robot <lkp@intel.com>,
        Peter Chen <peter.chen@nxp.com>, Ran Wang <ran.wang_1@nxp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Shawn Guo <shawnguo@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Marek Vasut <marex@denx.de>
Subject: RE: patch "Revert "usb: gadget: fsl: Re-enable driver for ARM SoCs""
 added to usb-linus
In-Reply-To: <VI1PR04MB4478C3FD8C6600ED9A36AAD58F349@VI1PR04MB4478.eurprd04.prod.outlook.com>
Message-ID: <c6c0efda-d84f-7a-48d-9cc2c5a6ba63@gmx.de>
References: <1623396129105150@kroah.com> <CAK8P3a1Y2g+-tKy=zD3yKhxjhVuWdMQvuP_MRbxzdeQFvAB-pQ@mail.gmail.com> <CAOMZO5DMQJ6GG+jfKO1a_HmfN_hwuL3De=KEV=g9WN7ejmMK6A@mail.gmail.com> <CAK8P3a1R0xNRLYrC9oKgjUDQj2GwBKrcE1FfDqfryLBeg-X7dg@mail.gmail.com>
 <VI1PR04MB4478C3FD8C6600ED9A36AAD58F349@VI1PR04MB4478.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V03:K1:/B5KaKAP8dHe/7p1zmYxQk1JZN/gpa45D3fNx4ME0kWw3wJfZoP
 X9dmIFyyTktI3LolaL0g3iQ45twi36u5vb+oUQpk7PAdn6Xtqw/a04Akam34PECl67852/b
 Zc0W3lb3VzL+Ca9JmW0My5MFAx4spbQtB7Tuz9U1brGsMU0BTSy2apjJZMK1BHRdIFDNRpn
 rt5NpbHYs0fjY+sgZ1kkQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5DxqYFvM/W8=:hbHDct8hshVfVAIWWm2sty
 vuKy5h7fb2YeuGPaKDTixZV6uZA4cSG0MIvIpOl0bP70KHXesQz03RNWp7ld1WkAIECRJ6k8o
 8b5trTQ/UHyAOO9zxd2Y06kOnjG3WSdaIIWMsPJMDOKIoqxpMleHCTNfsKZ3uLUU2PKDjBMM8
 8Eb+k3wENIK3Wf+RppZpLhBz4iU3lrmIx7GvkSDD3YIx+nkZGRUKRWe1ZyZoYuEHWAKV0jHIJ
 le9oSaqSutTcUitcFtw4bbSWYxpqC3NZfvO4CKcMjcmKE4w0CX4bHQ6FxJsqpH08tY5Do6p1G
 wUhJpogaR0hi6S4UAzGP9v01eEwkYaR/7vx6WV57teDDf6IBfai23o9kZhYp3j0Iwa3T4mSaF
 QjdNYHoG4AIwIU/xp2lq3q1rUxw7+BQfJB2a6Es0it45kgBkygcl9opcb+oK2dG5bTcO1XD1q
 E8iHDoTk4FjY+5l1E9H82y2dqeJEqLK02L5xtfnnv8xBrAJ0Fp7iMqe2e9Ga10QQZuLqveHrh
 MMEdvNNqXW0i8Ob0RiEAJ+J/KzNWiOL9BadYvEUG7PzpgbbROL89rJ7ujjRN64z6jAOIitMfX
 4Sv2L5CzoOQlz0CPwTV+qW/MCFKQmrkMdXBkhu5apmy+eUgszsLnZBfc1L1mUaHSeqDj5mvUf
 79Z/aYzYfUCt+VXoWPIlejUGWwG7JN7m9dwPafk3XblYlXGzRy7jGMi847cvtJUtHggm5urDz
 HFWkPg2rVotiZ5QX5OU6UYr9IXR6lWxzixpLGxqVUUdw7C1gjEvDWNY1eoeaZoWaF92l1YQ04
 yyKkD3ZSoU6EsbvgvBx2mUAzu5q8Q+QGRRdyN2SeVQ+nnC9+Q+R8DZATRphEzAer3/5BhDxsi
 Qlq9U3wT+oaTJsvzK33yti223E1nnVzfZODGYiCXg3Ghj7rAacB2gPkpMSo9g8LXMuPhW5P3u
 uIbvDgiCdOLyEC7qKs8JfFZaZoQZFY6ssiHHN40M+UcJVfIYvvyaqMPEk3C9jypmnOf1LHqpD
 SfFa/QZe5fMd2xM+pL15I64XvWfka2/jaA8d1v4g9rhNiaSvMdDboCw4/+2kz2kK+9ZvKnp0E
 oq/3FFrSYxX+dIyV1ds1xeJqhUCwVOAg1HhtNNmEvpTdQ/zDuJ5ksv4Xw==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The fsl_mxc_udc driver was originally developed as a part of a DENX
project, adding Marek to CC to have them check internally what their
preferences and requirements might be.

Thanks
Guennadi

On Fri, 11 Jun 2021, Leo Li wrote:

> > -----Original Message-----
> > From: Arnd Bergmann <arnd@arndb.de>
> > Sent: Friday, June 11, 2021 10:43 AM
> > To: Fabio Estevam <festevam@gmail.com>
> > Cc: gregkh <gregkh@linuxfoundation.org>; Felipe Balbi <balbi@kernel.or=
g>;
> > Joel Stanley <joel@jms.id.au>; Leo Li <leoyang.li@nxp.com>; kbuild tes=
t
> > robot <lkp@intel.com>; Peter Chen <peter.chen@nxp.com>; Ran Wang
> > <ran.wang_1@nxp.com>; Stephen Rothwell <sfr@canb.auug.org.au>;
> > Shawn Guo <shawnguo@kernel.org>; # 3.4.x <stable@vger.kernel.org>;
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Subject: Re: patch "Revert "usb: gadget: fsl: Re-enable driver for ARM=
 SoCs""
> > added to usb-linus
> >
> > On Fri, Jun 11, 2021 at 4:51 PM Fabio Estevam <festevam@gmail.com> wro=
te:
> > > On Fri, Jun 11, 2021 at 5:30 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > > Adding Fabio and Guennadi to Cc.
> > > >
> > > > I can see that the missing symbols were in a driver that got remov=
ed
> > > > in commit a390bef7db1f ("usb: gadget: fsl_mxc_udc: Remove the driv=
er").
> > > >
> > > > If CONFIG_ARCH_MXC is disabled, these are stubbed out in the heade=
r
> > file.
> > > > These were added a long time ago by Guennadi Liakhovetski
> > > > 54e4026b64a9
> > > > ("USB: gadget: Add i.MX3x support to the fsl_usb2_udc driver"). I
> > > > also see that this patch added  a few #ifdef CONFIG_ARCH_MXC check=
s
> > > > to the driver that still remain today. This is clearly broken as i=
t
> > > > must be possible to use the same driver module on both SOC_LS1021A
> > > > and i.MX using a runtime check.
> > > >
> > > > I also don't see any i.MX variant actually using this driver, but
> > > > instead see the dts files declaring fsl,imx27-usb devices, which
> > > > bind to the drivers/usb/chipidea/ci_hdrc_imx.c driver. Is this one
> > > > of those cases where we have two separate drivers for the same
> > > > hardware, or is this for a different device?
> > >
> > > Exactly. The USB IP on several i.MX devices comes from ChipIdea.
> > >
> > > Prior to using devicetree, we had the fsl_mxc_udc driver to handle t=
he
> > > gadget side.
> > >
> > > Since i.MX has been converted to a DT-only platform, we no longer ne=
ed
> > > fsl_mxc_udc, as drivers/usb/chipidea is used nowadays.
> >
> > Ok, good, so the simples solution I suppose is to remove the remaining=
 bits
> > that Guennadi added when he wrote the removed driver in 54e4026b64a9,
> > and then re-apply Joel's patch.
>
> I can provide a patch for this.
>
> >
> > Alternatively, it might be possible change the chipidea driver to work=
 on
> > ls1021a and ls1012a, assuming that they use the same hardware block as=
 i.MX.
>
> It is also used on many legacy FSL PowerPC SoCs.  I agree with the direc=
tion, but it does require some effort to make sure it works on all these l=
egacy platforms.  I think Ran Wang had tried to do that, but not completed=
 due to bandwidth issue.
>
> >
> > Either way, it would be good to test the changes on at least one of th=
ese two
> > platforms.
> >
> >         Arnd
>
