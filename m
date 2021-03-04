Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5B832D626
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 16:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhCDPKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 10:10:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:55732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234201AbhCDPKM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 10:10:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 07974AAC5;
        Thu,  4 Mar 2021 15:09:31 +0000 (UTC)
Message-ID: <827b317d7f5da6e048806922098291faacdb19f9.camel@suse.de>
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>, catalin.marinas@arm.com,
        will@kernel.org, akpm@linux-foundation.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, rppt@kernel.org, lorenzo.pieralisi@arm.com,
        guohanjun@huawei.com, sudeep.holla@arm.com, rjw@rjwysocki.net,
        lenb@kernel.org, song.bao.hua@hisilicon.com, ardb@kernel.org,
        anshuman.khandual@arm.com, bhelgaas@google.com, guro@fb.com,
        robh+dt@kernel.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, frowand.list@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        wangkefeng.wang@huawei.com
Date:   Thu, 04 Mar 2021 16:09:28 +0100
In-Reply-To: <YEDr/lYZHew88/Ip@kroah.com>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
         <YEDkmj6cchMPAq2h@kroah.com>
         <9bc396116372de5b538d71d8f9ae9c3259f1002e.camel@suse.de>
         <YEDr/lYZHew88/Ip@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MTEftY67Mi99IToWhxLf"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-MTEftY67Mi99IToWhxLf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-04 at 15:17 +0100, Greg KH wrote:
> On Thu, Mar 04, 2021 at 03:05:32PM +0100, Nicolas Saenz Julienne wrote:
> > Hi Greg.
> >=20
> > On Thu, 2021-03-04 at 14:46 +0100, Greg KH wrote:
> > > On Wed, Mar 03, 2021 at 03:33:12PM +0800, Jing Xiangfeng wrote:
> > > > Using two distinct DMA zones turned out to be problematic. Here's a=
n
> > > > attempt go back to a saner default.
> > >=20
> > > What problem does this solve?  How does this fit into the stable kern=
el
> > > rules?
> >=20
> > We changed the way we setup memory zones in arm64 in order to cater for
> > Raspberry Pi 4's weird DMA constraints: ZONE_DMA spans the lower 1GB of=
 memory
> > and ZONE_DMA32 the rest of the 32bit address space. Since you can't all=
ocate
> > memory that crosses zone boundaries, this broke crashkernel allocations=
 on big
> > machines. This series fixes all this by parsing the HW description and =
checking
> > for DMA constrained buses. When not found, the unnecessary zone creatio=
n is
> > skipped.
>=20
> What kernel/commit caused this "breakage"?

1a8e1cef7603 arm64: use both ZONE_DMA and ZONE_DMA32

Regards,
Nicolas


--=-MTEftY67Mi99IToWhxLf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAmBA+CgACgkQlfZmHno8
x/5JVgf/eqHD1C2EmaD/V/HHrBczhUaM9DPc5otgTDC5gKnYF8FgdBOH4oJyh2Hb
l9M2tznHD8hHoxowOw0BcxY+WOGYwZXRx8R5pNPb/NKZqFDCQ3Dgw1eMt8uYNg+5
oPS7JE5ldh3siUgaLV32wueyIqbx3A8WbSLouwSPz0TVK2DqVKd+SkLAS68qwTc4
QO9ikKdB7rg7RXvm6YOaP2uzWMn/PJgAEX/LMwv/CjfU+DVUE3uyqyXdsRby8nE8
tzXJi5AvfsGaUXsqQShCqdAAGuuQ6raG/r0oKfvUfAypKd4d46JFfdGlJ5iT7w8s
NlfFKZ2ZWHdwif+tNt2Lipct8pelxw==
=RW7q
-----END PGP SIGNATURE-----

--=-MTEftY67Mi99IToWhxLf--

