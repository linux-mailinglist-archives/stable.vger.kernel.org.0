Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDE93914E2
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 12:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhEZK3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 06:29:37 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:55554 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbhEZK3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 06:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cZwwLrwCegHrLx5GKTnmoyVo0Tv+Y7Dud5Ty5poKbYU=; b=kmeIv1LGbHDCxb8Mjo2hY0snwo
        sEDrTwLDila2cu+dT0o8E009Z2OaWRYWAKhZxQVPDmY9tB2h+FnTg0lOXCcRMGi00dnZXkrIhxc5k
        MrUSK5Y9EAAG97ePlsUdCfk0bcyo+J/zeadqYYEwmJ5Wi6JN5yRi3/XdGsqaKq4y6Viw=;
Received: from 94.196.90.140.threembb.co.uk ([94.196.90.140] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <broonie@sirena.org.uk>)
        id 1llqla-005xcI-Qm; Wed, 26 May 2021 10:27:58 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 75837D00386; Wed, 26 May 2021 11:28:33 +0100 (BST)
Date:   Wed, 26 May 2021 11:28:33 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.10 30/62] ASoC: rt5645: add error checking to
 rt5645_probe function
Message-ID: <YK4i0e6M6lEIP6rj@sirena.org.uk>
References: <20210524144744.2497894-1-sashal@kernel.org>
 <20210524144744.2497894-30-sashal@kernel.org>
 <YK1w+H70aqLGDaDl@sirena.org.uk>
 <YK129caVtNBthNDG@equinox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cHefsDBJIH1f4L8H"
Content-Disposition: inline
In-Reply-To: <YK129caVtNBthNDG@equinox>
X-Cookie: Ahead warp factor one, Mr. Sulu.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cHefsDBJIH1f4L8H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 25, 2021 at 11:15:17PM +0100, Phillip Potter wrote:
> On Tue, May 25, 2021 at 10:49:44PM +0100, Mark Brown wrote:

> > Now I've looked at the patch I don't think it's appropriate for
> > stable, it's essentially equivalent to a patch that adds -Werror

> So I frankly don't have the experience to disagree with you :-) Your
> reasoning certainly seems sound to me. My original motivation for the
> patch (after discussion with others within the mentorship process) was
> that some other sound SoC drivers do this, an example being the Ux500. I
> defer to the decision of the community as a whole of course, and am
> happy with whatever is decided.

Right, so there's multiple bits here - there's checking at all,
there's adding the checks to mainline and there's backporting
them to stable.  For stable we want to be fairly conservative
about what we're backporting since we want people to be able to
just update without worrying about things breaking on them so
something that increases the severity of existing checks is
particularly risky, if the code were already there and people
would've seen any issues it causes when integrating the kernel
it's a different story since the risks are different.

--cHefsDBJIH1f4L8H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCuIs0ACgkQJNaLcl1U
h9ANlgf/YvtO5pFfMXUqJYLeaHKLC1Xsohk8h5NtPTRN/fESqo0ZfEQdP/M2ejpN
7oDLiALRDp5c4f9ygaJT9QpG/EJE5WaGqUGXXxeVYzGPabt02h/vi0i5ezzAE2W4
sje35kkEZp+i/jWIhumEyaTi/agjBUMxKNvqMFi0iBxB0KMvU2sDAkIhOtWF+J6y
J8xSFDr2JX+S/6Ce/VPfsXk78gK6KIbTGC6m69Yztu/tmmyXFP0y61ZyoumBsLYo
7JU0tzNiF83jQ0WwqMJGtlTrqDTx/jQX7SE1J/edA9YxgkPPMGswTGTXb9Tstitn
+B7giMv5oQf05+amDyayED62WKtgHQ==
=Rqpb
-----END PGP SIGNATURE-----

--cHefsDBJIH1f4L8H--
