Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F5D2146E8
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 17:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgGDPdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jul 2020 11:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbgGDPdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jul 2020 11:33:35 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F26D20747;
        Sat,  4 Jul 2020 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593876814;
        bh=Cf8jYvmEMjlkd5Kh2lEDejZXr1RcS80lVl4jJtD+NU8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TFKWC4yz+ixS0dy03DWb5vFl2OYdhXbpaAxlI8r/e1EcrUy/7J2mX6Lo2iMjAIuF5
         umqiQwDc5HWU7ppHbY+OlHe7VqtpzQKuQvUpMJ0gizUmJBWUxzw+2F5j7ozccLqyUF
         PjubUYNwMVADJRtg5GZdsF6sfX7N1lUbgLWUQLrI=
Date:   Sat, 4 Jul 2020 16:33:30 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh+dt@kernel.org>, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: iio: bmc150_magn: Document missing
 compatibles
Message-ID: <20200704163330.5d5973b1@archlinux>
In-Reply-To: <20200629064925.GA5879@kozik-lap>
References: <20200617101259.12525-1-krzk@kernel.org>
        <20200620164049.5aa91365@archlinux>
        <20200622051940.GA4021@kozik-lap>
        <20200627155714.15478f60@archlinux>
        <20200629064925.GA5879@kozik-lap>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020 08:49:25 +0200
Krzysztof Kozlowski <krzk@kernel.org> wrote:

> On Sat, Jun 27, 2020 at 03:57:14PM +0100, Jonathan Cameron wrote:
> > On Mon, 22 Jun 2020 07:19:40 +0200
> > Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >  =20
> > > On Sat, Jun 20, 2020 at 04:40:49PM +0100, Jonathan Cameron wrote: =20
> > > > On Wed, 17 Jun 2020 12:12:59 +0200
> > > > Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > >    =20
> > > > > The driver supports also BMC156B and BMM150B so document the comp=
atibles
> > > > > for these devices.
> > > > >=20
> > > > > Fixes: 9d75db36df14 ("iio: magn: Add support for BMM150 magnetome=
ter")
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > >=20
> > > > > ---
> > > > >=20
> > > > > The fixes tag is not accurate but at least offer some backporting=
.   =20
> > > >=20
> > > > I'm not sure we generally bother backporting a missing section of b=
inding
> > > > documentation. Particularly as this doc isn't in yaml yet so it's n=
ot
> > > > as though any automated checking is likely to be occurring.
> > > >=20
> > > > Rob, any views on backporting this sort of missing id addition?
> > > >=20
> > > > One side comment here is that the devices that are magnetometers on=
ly
> > > > should never have had the _magn prefix in their compatibles. We only
> > > > do that for devices in incorporating several sensors in one package
> > > > (like the bmc150) where we have multiple drivers for the different
> > > > sensors incorporated. We are too late to fix that now though.  It
> > > > may make sense to mark the _magn variants deprecated though and
> > > > add the ones without the _magn postfix.   =20
> > >=20
> > > I can add proper compatibles and mark these as deprecated but actually
> > > the driver should not have additional compatibles in first place - all
> > > devices are just compatible with bosch,bmc150. =20
> >=20
> > Why not?  Whilst the devices may be compatible in theory, it's not unus=
ual
> > for subtle differences to emerge later.   As such we tend to at least
> > support the most specific compatible possible for a part - though we
> > can use fallback compatibles. =20
>=20
> It does not strictly harm but have in mind that adding is always
> possible (when you spot the difference between devices). But it is
> entirely different with removal - it takes time to deprecate one and to
> remove it.
>=20
> There is just no benefit for adding new compatibles for really
> compatible devices. The module device table just grows. It makes sense
> however to document in bindings that given compatible serves family of
> devices.
>=20
> Somehow driver developers got impression that they need to make a commit
> like "Add support for xyz123 device" adding only compatible, to bring
> support for new device. But the support was already there so just
> document that xyz001 is compatible with xyz123.

Whilst I agree the compatible is not really necessary, it is often
non trivial to establish two parts are actual compatible. Manufacturers
have an annoying habit of not actually saying so on their datasheets.
So it is useful to add documentation for the support so that a grep
will identify the driver supports it.

I don't have a problem with people adding the ID particularly as they
are often not entirely sure the parts are compatible.  I'm not fussed
if they don't do so of course.

Ideal in my view is to list multiple compatibles in the dts files
in this case to allow us to support any differences if any turn up
in the future.=20

=46rom a purely practical basis, if I'm writing a DTS I'd much rather
it matched up with my BOM rather than having to 'know' that two parts
are compatible.

Jonathan

>=20
> Best regards,
> Krzysztof
>=20

