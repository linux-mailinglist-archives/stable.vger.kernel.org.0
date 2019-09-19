Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC8DB80E3
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 20:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392133AbfISSeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 14:34:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57524 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392106AbfISSeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 14:34:13 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iB1Fr-0006bW-QR; Thu, 19 Sep 2019 19:34:11 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iB1Fr-00022x-5Z; Thu, 19 Sep 2019 19:34:11 +0100
Message-ID: <0fdc0610cadf0c55bb9c836b61bae9d4682e7263.camel@decadent.org.uk>
Subject: Re: [PATCH stable 3.15 to 3.18] staging: comedi: dt282x: fix a null
 pointer deref on interrupt
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Ian Abbott <abbotti@mev.co.uk>, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Date:   Thu, 19 Sep 2019 19:34:06 +0100
In-Reply-To: <20190712140237.15847-1-abbotti@mev.co.uk>
References: <20190712140237.15847-1-abbotti@mev.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-d8byAqH5ScqeDuETxvXV"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-d8byAqH5ScqeDuETxvXV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-07-12 at 15:02 +0100, Ian Abbott wrote:
> commit b8336be66dec06bef518030a0df9847122053ec5 upstream.
>=20
> The interrupt handler `dt282x_interrupt()` causes a null pointer
> dereference for those supported boards that have no analog output
> support.  For these boards, `dev->write_subdev` will be `NULL` and
> therefore the `s_ao` subdevice pointer variable will be `NULL`.  In that
> case, the following call near the end of the interrupt handler results
> in a null pointer dereference:
[...]

Thanks; I've queued this up for 3.16.  Sorry for the delay.

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.



--=-d8byAqH5ScqeDuETxvXV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2Dyh4ACgkQ57/I7JWG
EQnMlxAAvPix6m9d4YTnqNY2qAeh9cIbsprutIvaaKFNXb1ILhwVUXNEHKtNEcD0
tRK1fu2qMC9CnE3XKSFFkP9nYUOpL/a/G8Iz+8Pu0jW896YqDv84i69Hik7BvsRN
FecLub5HvVkscDHiwDo+VLYqLvKVBUipCEobynkVAY6Ws6f5hF12gQ/gBufUnDaA
R/cMjYv21v34DtYBTwyztzG4ewvaT3oaS5mAobiTzEly2DqZC9HMAR8vZNQmi45t
z0zStaem+PzvNDUFdqjBB47w3NTxE/LwkxcoEAQGE1uzNedsXXPaugAwmv1fO1Qu
+lPtJz7HfOlQZvPsZXR8XRV3oJqUM3b2UO7lAkLVEikaoBzSy489EP2P552bWdyA
lZqkd7XlHMrD4KRw0lFih15Ivba2QBiAbx7sf0Uokg01JJnhdtt1WAv0ZeZvM/YW
QR8H2fSTT8TFocqBdkj0QrwvUiFDr4YW+AHjluiM9+R0HzmVWWjlWYI7WUCcSQtF
kx2duAV3Iswy7WHi/t3+h9Sx0an1X26Rj8SJw7duenqltJKd7rCrC1BxSZFzmEgc
UfY9i/M86I+imTEe9se9d2SnjNx1yhMEgw3sxr6kqxCgcjOlr7Tx4JeXp4EJ9ezk
uVkJfnWiBfuSgwWieByixfDTlXAxwn3AQp2dwMaHLYsd1YdUn8c=
=5GgE
-----END PGP SIGNATURE-----

--=-d8byAqH5ScqeDuETxvXV--
