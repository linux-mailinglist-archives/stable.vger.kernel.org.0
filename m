Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAF51E839A
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 18:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgE2Q05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 12:26:57 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35096 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2Q04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 12:26:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 213C61C0385; Fri, 29 May 2020 18:26:55 +0200 (CEST)
Date:   Fri, 29 May 2020 18:26:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Klaus Doth <kdlnx@doth.eu>
Subject: Re: [PATCH 4.19 69/81] misc: rtsx: Add short delay after exit from
 ASPM
Message-ID: <20200529162654.GA3514@amd>
References: <20200526183923.108515292@linuxfoundation.org>
 <20200526183934.709077655@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20200526183934.709077655@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Signed-off-by: Klaus Doth <kdlnx@doth.eu>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/4434eaa7-2ee3-a560-faee-6cee63ebd6d4@doth=
=2Eeu
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

> +++ b/drivers/misc/cardreader/rtsx_pcr.c
> @@ -155,6 +155,9 @@ static void rtsx_comm_pm_full_on(struct
> =20
>  	rtsx_disable_aspm(pcr);
> =20
> +	/* Fixes DMA transfer timout issue after disabling ASPM on RTS5260 */
> +	msleep(1);
> +

There's typo in comment, should be "timeout".

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7RN84ACgkQMOfwapXb+vL9xQCgsrjzv8sX6z9xnypLWQx7Kyy+
dmUAn2SB9ssW0iQHhKxYuOcPf/T3EUYe
=bMdv
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
