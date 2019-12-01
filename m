Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CBE10E3F5
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 00:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfLAXtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 18:49:15 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:56622 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfLAXtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Dec 2019 18:49:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LQDdCTsWHRA4ZretgJXx0msy4MDgZvvkhcgKOBqu1qQ=; b=sKsz595kkpRJbxYVC7pvr4NZf
        eG9oWOCiKP3GFwAgjCYrOQ1tts9LnfboO4de8O1lAaK6k+ei2A1Ya1kWT0DIBltJ4XbmByOuvoDVc
        fMTLFXuhfAgYvTp0CBwkZocAMnkQ75JoQ6lmwI3N1NGDMC5dwOKabgZE1GnHwHnaHQwDc=;
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1ibYxk-0000Ed-GX; Sun, 01 Dec 2019 23:49:12 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 36395D02F8B; Sun,  1 Dec 2019 23:49:11 +0000 (GMT)
Date:   Sun, 1 Dec 2019 23:49:11 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: Defer init completion for a while after
 late_initcall
Message-ID: <20191201234911.GC1998@sirena.org.uk>
References: <20190904124250.25844-1-broonie@kernel.org>
 <20191116125233.GA5570@lst.de>
 <20191118124654.GD9761@sirena.org.uk>
 <20191118164101.GA7894@lst.de>
 <20191118165651.GK9761@sirena.org.uk>
 <20191118194012.GB7894@lst.de>
 <20191118202949.GD43585@sirena.org.uk>
 <20191130152700.GA14121@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
In-Reply-To: <20191130152700.GA14121@lst.de>
X-Cookie: Cleanliness is next to impossible.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 30, 2019 at 04:27:00PM +0100, Torsten Duwe wrote:

> Well, actually the 4 lines above give a good hint :) of_get_regulator()
> will look for "dvdd25-supply-supply". I'm fairly relieved that even you
> didn't spot this right away. The fix just went to dri-devel, you're Cc'ed.
> Unfortunately the documentation for this is buried in the git commit log.

Glad you got to the bottom of this!  Like I said in reply to your
fix (which I saw first) this is covered in the DT binding
documentation for the regultaor API.

> For the record: I'm still convinced that the original change can uncover
> bugs unexpectedly, and is not suited for -stable.

Yeah, it's definitely at the upper limit of what I consider safe
for stable but it seems to fit the risk profile of what stable
wants to include these days and there was demand for it from
people working on DT based laptops and desktops.

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl3kUXYACgkQJNaLcl1U
h9A7Cwf+Ka4ElFEbzAcM1kQ2TqPeE4GdhgoP6Ky0e++Md4T0Eqfukz4PDkb3FnlR
+6qyEXTeYDUdWTR0SS8dGzIeplhy13DNBBvKMVKZTt8FMKpdpeqYsNKISxw7kIfN
HEy/CSA1B4b5E7cLJlxu+lxno4O/cT5NXwwbXWVjOnIQ68HByQJ7U3rtdbX1yIE3
0pbXlVo0VoffJbjdwuCswgoqwc8JzwN+1tZWaj8CmFGQxF3IJBGZyNqMvJuXqL5e
D1joW+R1yEakuVJ7xyY4tXSMoHfaDdxlx3cF63c4i40uHmxboQMtbp4wVZkgsFOZ
h16BNH+wpM6CNYcAgmz7ECnJ2dp0Vg==
=lMGi
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
