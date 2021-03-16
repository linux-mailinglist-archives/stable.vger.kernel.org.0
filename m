Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DC333D15C
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 11:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhCPKFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 06:05:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54372 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbhCPKFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 06:05:05 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DD45A1C0B8B; Tue, 16 Mar 2021 11:05:02 +0100 (CET)
Date:   Tue, 16 Mar 2021 11:05:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 154/290] PCI/LINK: Remove bandwidth notification
Message-ID: <20210316100501.GD12946@amd>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135547.125914951@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
In-Reply-To: <20210315135547.125914951@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> From: Bjorn Helgaas <bhelgaas@google.com>

Dup.

> Remove the bandwidth change notifications for now.  Hopefully we can add
> this back when we have a better understanding of why this happens and how
> we can make the messages useful instead of overwhelming.

This is stable, and even for mainline, I'd expect "depends on BROKEN"
in Kconfig, or something like that, so people can still work on fixing
it and so that we don't have huge changes floating around.

Best regards,
								Pavel
							=09
> diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
> index 3946555a6042..45a2ef702b45 100644
> --- a/drivers/pci/pcie/Kconfig
> +++ b/drivers/pci/pcie/Kconfig
> @@ -133,14 +133,6 @@ config PCIE_PTM
>  	  This is only useful if you have devices that support PTM, but it
>  	  is safe to enable even if you don't.
> =20
> -config PCIE_BW
> -	bool "PCI Express Bandwidth Change Notification"
> -	depends on PCIEPORTBUS
> -	help
> -	  This enables PCI Express Bandwidth Change Notification.  If
> -	  you know link width or rate changes occur only to correct
> -	  unreliable links, you may answer Y.

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBQgs0ACgkQMOfwapXb+vLOxgCeN+MQeHtq+scAXlKbL20uT5Sm
qYQAoKQTFYLSuLvuwE9dRNkfvaN1iRhj
=9jjp
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--
