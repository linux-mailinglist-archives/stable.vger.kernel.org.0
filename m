Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BC13E148B
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 14:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbhHEMRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 08:17:25 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40572 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239778AbhHEMRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 08:17:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6067B1C0B7C; Thu,  5 Aug 2021 14:17:10 +0200 (CEST)
Date:   Thu, 5 Aug 2021 14:17:09 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 14/17] nvme: fix nvme_setup_command metadata
 trace event
Message-ID: <20210805121709.GA20159@amd>
References: <20210727131938.834920-1-sashal@kernel.org>
 <20210727131938.834920-14-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20210727131938.834920-14-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The metadata address is set after the trace event, so the trace is not
> capturing anything useful. Rather than logging the memory address, it's
> useful to know if the command carries a metadata payload, so change the
> trace event to log that true/false state instead.

I see this makes sense for mainline, but I'm not sure if it is
severe-enough bug for -stable.

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEL1sUACgkQMOfwapXb+vKKkgCgu2gVX0pMthBnrewv9t4Iivam
+RkAn3pZLe940bLmbmZkDD2Wdjw3Twbt
=qbOu
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
