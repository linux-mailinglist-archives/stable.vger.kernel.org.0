Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1558A252159
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 21:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgHYT4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 15:56:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48858 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYT4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 15:56:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1BFCD1C0BB9; Tue, 25 Aug 2020 21:56:21 +0200 (CEST)
Date:   Tue, 25 Aug 2020 21:56:20 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4.19 65/71] powerpc/pseries: Do not initiate shutdown
 when system is running on UPS
Message-ID: <20200825195620.GB27453@duo.ucw.cz>
References: <20200824082355.848475917@linuxfoundation.org>
 <20200824082359.202438041@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <20200824082359.202438041@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> We have a user space tool (rtas_errd) on LPAR to monitor for
> EPOW_SHUTDOWN_ON_UPS. Once it gets an event it initiates shutdown
> after predefined time. It also starts monitoring for any new EPOW

Yeah, so there's userspace tool, and currently systems _with_ that
tool work poorly with UPS.

So you have fixed that, and now, systems _without_ that tool will work
poorly.

That's not a fix for serious bug, that's behaviour change. You are
fixing one set of systems and breaking another.

I don't believe it is suitable for stable.

								Pavel

> @@ -118,7 +118,6 @@ static void handle_system_shutdown(char
>  	case EPOW_SHUTDOWN_ON_UPS:
>  		pr_emerg("Loss of system power detected. System is running on"
>  			 " UPS/battery. Check RTAS error log for details\n");
> -		orderly_poweroff(true);
>  		break;
> =20
>  	case EPOW_SHUTDOWN_LOSS_OF_CRITICAL_FUNCTIONS:
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX0Vs5AAKCRAw5/Bqldv6
8lOOAJ4n0Ishqs/WgvEdZcbqzcFgzjVtbQCfTrF16PSpZ4y473rFXdbzTTGTELw=
=yuvK
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
