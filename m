Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D301A0C9E
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 13:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgDGLNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 07:13:06 -0400
Received: from sauhun.de ([88.99.104.3]:52042 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbgDGLNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 07:13:06 -0400
Received: from localhost (p54B3320F.dip0.t-ipconnect.de [84.179.50.15])
        by pokefinder.org (Postfix) with ESMTPSA id E3CFD2C07CD;
        Tue,  7 Apr 2020 13:13:03 +0200 (CEST)
Date:   Tue, 7 Apr 2020 13:13:01 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martin Volf <martin.volf.42@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.5 42/46] i2c: i801: Do not add ICH_RES_IO_SMI for the
 iTCO_wdt device
Message-ID: <20200407111301.GA1928@ninjato>
References: <20200407101459.502593074@linuxfoundation.org>
 <20200407101503.858623897@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20200407101503.858623897@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

> Fixes: 9424693035a5 ("i2c: i801: Create iTCO device on newer Intel PCHs")
> [wsa: complete fix needs all of http://patchwork.ozlabs.org/project/linux-i2c/list/?series=160959&state=*]

Did you pick these others, too, this time?

All the  best,

   Wolfram


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl6MYDkACgkQFA3kzBSg
KbaEgg//cyLUYHfeQlAmqDmjH4MEtoK6Skye8nnj/KuqDHJJj4YjlWW31XUwb7LA
S2o/6X99kLBUTlvZ4h53j0NV2xXRjDe7etUykB8TduXjUGKe3RyamU/v9wN5iFY8
TPIEPL9U9aaYPimz28aVucE24ZY6txKdttfoH5Dq7X5nA07bqFugy8JObHu9MdRj
Eo+71Zn253oG6g6/FTeceW6nT8foxe0QjhJKmEkPE1GG3qpb5W+E2beLP2yhAv8f
eHPeJuqcOC8yrHFn6m8vs+ymZ/JYuA4zOvuz5VidHMujcrZlC2LjLSN/lMo4dFbs
HAzJ214EpNW2itH16iv8cjAdombRq9IuQDCTwtVnpb39n+FA7XCHcXRlLrU7KvIb
s2rWq0NGhU70F5hV+0cxrx7GOED0yOtAu4Ox7hv9Nw3Ydkg7umd9rwNhfbV5aZT5
lRBtjM/789DPTI4pQf7a+w8yPqzWeEDIFf0tLN5BxmLcdEXpGDfhQOV3Bp9w+xVS
z631G4C7o6vKVrhLFQlzVh1kVtRJGBTF3hNV0/CEWkhDd/zAIN6pWEo4Kshg2zWT
7weoUlcCmibjAcBD3h3dzRBK6VPZ2+6Oz03LyqOPQuQbMtbpuRgy1ISgfx0VJdW4
PPlyshcNCfN5aTMt1oQ/F5WS1tiTL1fBu3n1hemn5eFH+mbp0BM=
=rzgb
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
