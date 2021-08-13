Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E4A3EBC8E
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 21:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhHMTc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 15:32:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50446 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhHMTc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 15:32:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5D3001C0B76; Fri, 13 Aug 2021 21:31:58 +0200 (CEST)
Date:   Fri, 13 Aug 2021 21:31:58 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 5.10 12/19] vboxsf: Make vboxsf_dir_create() return the
 handle for the created file
Message-ID: <20210813193158.GA21328@duo.ucw.cz>
References: <20210813150522.623322501@linuxfoundation.org>
 <20210813150523.032839314@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20210813150523.032839314@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit ab0c29687bc7a890d1a86ac376b0b0fd78b2d9b6 upstream
>=20
> Make vboxsf_dir_create() optionally return the vboxsf-handle for
> the created file. This is a preparation patch for adding atomic_open
> support.

Follow up commits using this functionality are in 5.13 but not in
5.10, so I believe we don't need this in 5.10, either?

(Plus someone familiar with the code should check if we need "vboxsf:
Honor excl flag to the dir-inode create op" in 5.10; it may have same
problem).

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRbIrgAKCRAw5/Bqldv6
8lSvAJwNVKgSQbq8Vr6gWudFsKZroshL3QCglfu1ww6X525AF0v/THpbAit9WyI=
=pdv/
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
