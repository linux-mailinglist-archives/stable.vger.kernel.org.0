Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641D51026C0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 15:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfKSObT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 09:31:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46002 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727809AbfKSObS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 09:31:18 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX4XB-0004XU-Og; Tue, 19 Nov 2019 14:31:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX4XB-0000p5-0o; Tue, 19 Nov 2019 14:31:13 +0000
Message-ID: <f63d4cd6578e297ebbfbaa81842f89410d495587.camel@decadent.org.uk>
Subject: Re: stable request: PCI: tegra: Enable Relaxed Ordering only for
 Tegra20 & Tegra30
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Vidya Sagar <vidyas@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Manikanta Maddireddy <mmaddireddy@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
Date:   Tue, 19 Nov 2019 14:31:07 +0000
In-Reply-To: <cd787fce-3675-a2d1-90a7-5fa0c4b3f946@nvidia.com>
References: <11251eb0-5675-9d3d-d15f-c346781e2bff@nvidia.com>
         <20191111130908.GA448544@kroah.com>
         <9d7871e7-f8aa-1ed5-dc2e-37ba6f218a2f@nvidia.com>
         <cd787fce-3675-a2d1-90a7-5fa0c4b3f946@nvidia.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-yOTlUY5S14af4uD5tUGl"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-yOTlUY5S14af4uD5tUGl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-11-18 at 12:05 +0530, Vidya Sagar wrote:
> On 11/11/2019 8:52 PM, Vidya Sagar wrote:
> > On 11/11/2019 6:39 PM, Greg Kroah-Hartman wrote:
> > > On Mon, Nov 11, 2019 at 06:24:53PM +0530, Vidya Sagar wrote:
> > > > Hi Greg,
> > > > We noticed that the Tegra PCIe host controller driver enabled
> > > > "Relaxed Ordering" bit in the PCIe configuration space for "all"
> > > > devices erroneously. We pushed a fix for this through the
> > > > commit: 7be142caabc4780b13a522c485abc806de5c4114 and it has been
> > > > soaking in main line for the last four months.
> > > > Based on the discussion we had @ http://patchwork.ozlabs.org/patch/=
1127604/
> > > > we would now like to push it to the following stable kernels
> > > > 4.19                  : Applies cleanly
> > > > 3.16, 4.4, 4.9 & 4.14 : Following equivalent patch needs to be used=
 as the
> > > >                          file was at drivers/pci/host/pci-tegra.c e=
arlier
> > > >                          (and moved to drivers/pci/controller/pci-t=
egra.c starting 4.19)
> > >=20
> > > All now queued up (except for 3.16, that's Ben's tree, he will get to=
 it
> > > soon.)
> > >=20
> Hi Ben,
> Could you please queue this up for 3.16 as well?

OK, I've added it to my queue.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice - John Levine



--=-yOTlUY5S14af4uD5tUGl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3T/KsACgkQ57/I7JWG
EQlzgA/9HSBWVRxCNVz6064NnclJbdt4zirsCIAgkuJ1Mu2LrlPeaXsoRgvnE09o
VQOWeMfc+gwb7SdUWDv/SD3WlNUpf/D+7VTWfkgW9jQjXLvCjiJPnmKuJhRwESJm
isLT2ZphyIynNXjzfRlIC4eU98DvPxjHjAx1XjhLg8+zOB45HsxJgAlLUjGVYgU8
KUOMM4Fi4Ph/rEyPAPqIxmGyzoosoe0p90hkt1b0ZrgMsuNjF6JK3PJtmIxsWRNt
gSh/1kNuAjsL3k5FpsGZNPFJzyHxp1Ha3lYtBm+cHljK3537tL9zDzywZ13Fe9WY
2uz0rCi7shPz8PzXkHD8htJaNy2XHYyesm12gA3XNpGzg0PmS2ylvI1siwOdXRFD
mxxrdMYmBnNnHZLL/omU8SMDXTW/nNgUTHY9t6Vy7cNpe43bNHAggu0kWMqHbLmD
hVRClI7HVqUiZU1Jc9ByofJBiBFOULWvdssoCaYi6n7453jfPDKzoTTYoiqclzVI
PgHUOxji33+tN+ZSxlrb+NBfbvg59C2rOBOOi2eG5QdtfFoTgDx1j6at3NWFdj0k
S0iWHXvjiHbh3rmQ9AAAmsJPTyNs24Ro4TjhijXIomaDHvs/8B4gg4LpcoGWwEiA
rYTkKNcODmJeiaVij5s6yLr+jTpMpJFG2Dp1dfFWGAcMdKR+pgA=
=Vxdh
-----END PGP SIGNATURE-----

--=-yOTlUY5S14af4uD5tUGl--
