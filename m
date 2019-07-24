Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC0D73334
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 17:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387443AbfGXP5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 11:57:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:33522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387438AbfGXP47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 11:56:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B71A7AF1D;
        Wed, 24 Jul 2019 15:56:58 +0000 (UTC)
Message-ID: <58cc8008ef359f6c31e1a7156d20ccf10c5b4d0d.camel@suse.de>
Subject: Re: FAILED: patch "[PATCH] xhci: Fix immediate data transfer if
 buffer is already DMA" failed to apply to 5.2-stable tree
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>,
        mathias.nyman@linux.intel.com, m.szyprowski@samsung.com
Cc:     stable@vger.kernel.org
Date:   Wed, 24 Jul 2019 17:56:57 +0200
In-Reply-To: <20190724155321.GA5571@kroah.com>
References: <1563983027111159@kroah.com> <20190724155321.GA5571@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-5rGZKkRc+VGnXX/VF1ZA"
User-Agent: Evolution 3.32.3 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-5rGZKkRc+VGnXX/VF1ZA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-07-24 at 17:53 +0200, Greg KH wrote:
> On Wed, Jul 24, 2019 at 05:43:47PM +0200, gregkh@linuxfoundation.org wrot=
e:
> > The patch below does not apply to the 5.2-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >=20
> > thanks,
> >=20
> > greg k-h
> >=20
> > ------------------ original commit in Linus's tree ------------------
> >=20
> > > From 13b82b746310b51b064bc855993a1c84bf862726 Mon Sep 17 00:00:00 200=
1
> > From: Mathias Nyman <mathias.nyman@linux.intel.com>
> > Date: Wed, 22 May 2019 14:34:00 +0300
> > Subject: [PATCH] xhci: Fix immediate data transfer if buffer is already=
 DMA
> >  mapped
> >=20
> > xhci immediate data transfer (IDT) support in 5.2-rc1 caused regression
> > on various Samsung Exynos boards with ASIX USB 2.0 ethernet dongle.
> >=20
> > If the transfer buffer in the URB is already DMA mapped then IDT should
> > not be used. urb->transfer_dma will already contain a valid dma address=
,
> > and there is no guarantee the data in urb->transfer_buffer is valid.
> >=20
> > The IDT support patch used urb->transfer_dma as a temporary storage,
> > copying data from urb->transfer_buffer into it.
> >=20
> > Issue was solved by preventing IDT if transfer buffer is already dma
> > mapped, and by not using urb->transfer_dma as temporary storage.
> >=20
> > Fixes: 33e39350ebd2 ("usb: xhci: add Immediate Data Transfer support")
> > Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > CC: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> Oh nevermind, this should be a 5.2-only thing.

You're right, I reacted too fast.

Regards,
Nicolas


--=-5rGZKkRc+VGnXX/VF1ZA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl04f8kACgkQlfZmHno8
x/4Kagf+Ib/zLxs9tv4gxfT4bg2g8+Jsc6PFnZNNXaNj6XtdXbU6c66U8wrNzpvS
eM4oVEYuJTBha1MxbYCl2IZ0QhmpP9YDVoCyLjrTfmVvso9yucxRf/J6fzVo+Qgp
oDPE2daYZT6mWWDw9EbFVCQ2mNDCJ8rlH3res0/8yrn/FHECElsYK3OxuZt0Rw3Y
zNMPXNs3rdibTYw+M6SPCGk45kl5IlMzLfkelRAQPaRoOBWARFLx7FD8Vsm6a82y
/3E7tvCzYf6VI+m1WSwEgbYjIQOVFxXPEeT9PnernN7sQ6GXcNzofB8VDb6E/NR4
S/smI+mTXxwVxRR7Rp7X7/NrxlZddQ==
=uBd4
-----END PGP SIGNATURE-----

--=-5rGZKkRc+VGnXX/VF1ZA--

