Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D475E4215A6
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 19:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhJDR54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 13:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhJDR54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 13:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F5F761207;
        Mon,  4 Oct 2021 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633370166;
        bh=iihWtpxgSsYd4yX5WcJ7ebWvE0XP2NH1ko0MEkDEqI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QxeiIafKt8gaBHAQ5/ukADuqigQu0UGFqrzNQh2bxpXyDJ+O1T3tpxgEIpqDc7or1
         fZXJjmvKTB5KCXNNeVwnctypruPuQsTKOPVh53mC1EGOGq8gSrBT39JIhRbEGQ4P8l
         ZRNDkjKMlKsmyehoFJdnZllqYKlfkqdK+juxkuoh4y3ECNyLvNYbEfFqDq6Nzi46iF
         9hmBp3/mt5KdKiGo4sI453c9w4VO9Fn+qWj43TY1KDQ65Oew46MqBfZDSxeHMXudjs
         0KJlToErN3yp8IUNvrEFSk7r3wb7HPnX4HeDRIVWbOuJnuN8Y38SCpye1SecygvhMb
         ICOT+2tg2IT7A==
Date:   Mon, 4 Oct 2021 18:56:04 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenz@kernel.org, linux-spi@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
Message-ID: <YVtANKEp3DVZPgsp@sirena.org.uk>
References: <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk>
 <20211004154436.GY3544071@ziepe.ca>
 <YVssWYaxuQDi8jI5@sirena.org.uk>
 <e68b04ab-831b-0ed5-074a-0879194569f9@gmail.com>
 <20211004165127.GZ3544071@ziepe.ca>
 <f481f7cc-6734-59b3-6432-5c2049cd87ea@gmail.com>
 <20211004171301.GA3544071@ziepe.ca>
 <YVs5gT1rj9HiAW5p@sirena.org.uk>
 <8513334a-1de4-bc9c-0157-e792e8ff4871@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tDeEGRM3Etvfc3kD"
Content-Disposition: inline
In-Reply-To: <8513334a-1de4-bc9c-0157-e792e8ff4871@gmail.com>
X-Cookie: If it heals good, say it.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tDeEGRM3Etvfc3kD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 04, 2021 at 10:44:34AM -0700, Florian Fainelli wrote:

> Anyway, we are divergin slightly here, how do we go about fixing
> .shutdown here?

Implement something in the core which will stop any new operations being
requested and flush existing ones then update the driver to just do
whatever is needed to turn off the hardware.

--tDeEGRM3Etvfc3kD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFbQDMACgkQJNaLcl1U
h9B02gf8DMJ9GV0eTB6jdz3mzbfIDKFWtRDU0DAiDmtHoX71kYjzVqPBjrSgej+h
FePNNGAjbv3Vw5i/aPtJjdScC0CcsDDqdYqjRD3hALn2RmnKdHfzIc4TbAfH0Bhy
DtobtvArYdFNdP5lG/SHmHi7b8+ObIfV/bj1SsyxmrPd9xTY17smH7WYgKCeTZRC
XLldyg+mn+wV0fGrSOCwpAAoEifV2mq1stJTg9TLI7nNbXEGqBJlMfVEdhlrSix6
j1yoSqXz3FdLyHySBogmAuPcREHpPkUh601cCiK3lqlFy7O3lCckyt4VCruNaZCB
dTPjFsh5QBjcK9BZU4cX5gG9WnFifA==
=9ZgA
-----END PGP SIGNATURE-----

--tDeEGRM3Etvfc3kD--
