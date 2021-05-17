Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617B1382B4C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhEQLjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:39:53 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:54616 "EHLO
        manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236785AbhEQLjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 07:39:53 -0400
Date:   Mon, 17 May 2021 13:38:34 +0200
From:   Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config
 does
Message-ID: <1621251453@msgid.manchmal.in-ulm.de>
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
 <1621180418@msgid.manchmal.in-ulm.de>
 <YKI/D64ODBUEHO9M@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="J4XPiPrVK1ev6Sgr"
Content-Disposition: inline
In-Reply-To: <YKI/D64ODBUEHO9M@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J4XPiPrVK1ev6Sgr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greg KH wrote...

> Hopefully now fixed in the stable queue, I'll push out new -rc releases
> today for people to test.

Thanks for taking care, unfortunately no improvement with 5.10.38-rc1 here.

    Christoph

--J4XPiPrVK1ev6Sgr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEWXMI+726A12MfJXdxCxY61kUkv0FAmCiVbYACgkQxCxY61kU
kv2smhAAmfKyCeeaObBs/F7thAoETcMiUOfExtfi8AfknYFcvkOUFrB9CrcVAfkN
aqXZA83d2Yg5P1ypA8iJTTffbqKpgUQBN3wiCUtV5xqHOf8JzUiUMM+ZNbFQgool
8R3xBoG/WEAeSjfMVjc19ZqoS9Ak81ii6Yn542UFuv6VRSHflYfGIVabJp7oQ+DW
Pz6CLvmiAWWNefoAmYBmWACILPRVXiuSevQct4kMes8izPFMnHkNBlvHmROCNFwS
i8M6r2uy3tCkjxnM+ZQnpe4c/27cG7wcLfOY1EjmdV71K4AST9qh1bMoyEHKNOrY
vDoL8Zre56v7gLJc9L7G4ds/AdG9cr6IfJu5evHBVhU+pQsfqA0NwFm56x2w5T1V
YKJPjV0IMJFqpV3Tc6/44ofr9jm+Vfe0ll1DifWsjdIr+GKvgrJ1PmKdZmo5OWZc
8yj4sU8lXLFpRx+ryurGkkn0l6NlM3E2Z0anIY7bkAnMWyvs1if4NknUJ1ivi5gF
7tbMnW9eSa/aGnidcGTHVF8Wl6sY6vDk5opqt2QcsJ86R8E5S1bUb369o5BTvVQ/
Zwx6aC1ZMvd6DccdTeumpr/U3XlrtUBdBQiv9qJZ3Xmoc2w7atkb1qzpUMAjzM8J
JmXsY9/RYrZ/8REw1va+pNcD7WYt8JFJPk4wz+wP/egZ1mVes98=
=a1qY
-----END PGP SIGNATURE-----

--J4XPiPrVK1ev6Sgr--
