Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A165421527
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 19:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhJDR3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 13:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234027AbhJDR3U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 13:29:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1106F61407;
        Mon,  4 Oct 2021 17:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633368451;
        bh=dJcTojdyTEwddc1tq3Mz5/yx6tuByGJte5YbwxOJ/qE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u38j+M9Z0NMyTSe/vkk5YR+NuuIOq2/cDqp7pa+47ihZpEHk9bQKf//Sk0b9TSFkh
         wX7bFjVWFsYAn0tokHPxZ9WnMys59Pqs4izW0l33ueQ6pQMtM58hRBIM8MTQ0fYoIH
         xnQ6aujAjtcPVvHFwHpa+7Y6fh0UEXx/1uMnvW39K+l8ZHpAcwWmtdBQWVdTI0SSw6
         H2fZcWOL99uBzPdjt/ZnHr7/UEY62dwPXxDYMBGVj5ZBs7XMdH+oq/SRK2zn+1v2+q
         s5gQc22UyPe+WkL653WAONpaABIGREEMv+sa7dFHBu5Z8/J886UvUXODvVcLQsPxsA
         SnfuuWLD20P9g==
Date:   Mon, 4 Oct 2021 18:27:29 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenz@kernel.org, linux-spi@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
Message-ID: <YVs5gT1rj9HiAW5p@sirena.org.uk>
References: <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk>
 <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk>
 <20211004154436.GY3544071@ziepe.ca>
 <YVssWYaxuQDi8jI5@sirena.org.uk>
 <e68b04ab-831b-0ed5-074a-0879194569f9@gmail.com>
 <20211004165127.GZ3544071@ziepe.ca>
 <f481f7cc-6734-59b3-6432-5c2049cd87ea@gmail.com>
 <20211004171301.GA3544071@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OBXRwq2dYySOzdLn"
Content-Disposition: inline
In-Reply-To: <20211004171301.GA3544071@ziepe.ca>
X-Cookie: If it heals good, say it.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OBXRwq2dYySOzdLn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 04, 2021 at 02:13:01PM -0300, Jason Gunthorpe wrote:

> I'm kind of surprised a scheme like this didn't involve a FW call
> after Linux is done with the CPUs to quiet all the HW and let it
> sleep, I've built things that way before at least.

That's a *lot* of code to put in firmware if you can't physically power
most of the system down.

--OBXRwq2dYySOzdLn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFbOYAACgkQJNaLcl1U
h9BBOgf/cS+47jW34sQ7ZOwD7+zAxLV9SSEFG1hnk4nASvAyLh6auA2lINf4TVaX
e6o249sP3XJY3GoHcVGJePFR5Ocrchw/JbeGwu4//rhoHQtKpvnt9DHiqkzLlKXC
OltBTHIF7Yg+lSG9bQsVXKN8hXP/KHV26P20aS1srEqk6DqSd/AHvtbZ6kSQowoV
z6aVUeI2bUll0phJOzpmdhtISswUKJxeK3eOqGZgqnXIyunBuz1s5eVpFxNcPAZW
x/PF7XQtncpM8lPcaEVDV9p12WN7dUeqY8iPoeL5bVTOrktO45sOPM/ASx9QUyZT
OeIJEqCS3C0E5oIj0eiYDqGUmRB6mw==
=QdhR
-----END PGP SIGNATURE-----

--OBXRwq2dYySOzdLn--
