Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572192700A6
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 17:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIRPOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 11:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRPOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 11:14:53 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 695E923888;
        Fri, 18 Sep 2020 15:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600442092;
        bh=GTnoDvRhosB6M9n5DeI9RwSSY6SLlfLNaP1xWTamya8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ypvTmK/o6q0B/i64U0gB3eUytNeMfNb4a+P4glHntN7VGXTapb/Cf7anZM7ocI75W
         HKIrOw4gGdSG3YAOjXt0BJXYVeYOGCcGromtT2RX/Q2HvwwI4PPkwSLvHdIVvRrVTh
         eyMg6Z8G8heb+KycsCRBZdqf1F0MvbSxTp0xCxTQ=
Date:   Fri, 18 Sep 2020 16:14:02 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        alsa-devel@alsa-project.org, tiwai@suse.de,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3/7] ASoC: SOF: intel: hda: support also devices with 1
 and 3 dmics
Message-ID: <20200918151402.GI5703@sirena.org.uk>
References: <20200825235040.1586478-1-ranjani.sridharan@linux.intel.com>
 <20200825235040.1586478-4-ranjani.sridharan@linux.intel.com>
 <b799ec66-356d-865e-a30b-ca28d5046326@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rCb8EA+9TsBVtA92"
Content-Disposition: inline
In-Reply-To: <b799ec66-356d-865e-a30b-ca28d5046326@linux.intel.com>
X-Cookie: Beware of geeks bearing graft.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 18, 2020 at 10:10:24AM -0500, Pierre-Louis Bossart wrote:

> This patch should be applied to -stable versions all the way to 5.6. It
> would be desirable for 5.5 and 5.4 as well but it will not apply cleanly.
> It's be trivial to provide a modified patch for these earlier kernel
> versions but I don't know what the process might be here?

Send a backport to Greg & stable with a note explaining what's going on.

--rCb8EA+9TsBVtA92
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl9kzrkACgkQJNaLcl1U
h9BVwgf/cd3uXGMTdtaCbmsdnMIANhBu/Kq1gtff3zbzw9xziVWX4YF8BJ7C04bP
UeByQZhatukiEHMz9Kxw6KMtMBA53m50LrcWWqvyxAYe3iEcpqgegkaldq/14JL9
Hw/Vy6qOhRTUKyZEeSif0qrne5b734HZHs5bXIo6eIywtu+gEUNNXMoswsP8Kb5u
yPqvaW2rYRKcu2T+VPaehE1K7cBqy9Y5fFINBVtXPmeXxn8VIHN7JTriRY2gqtEh
Yeg25FIi+c3QKZ4jXrv2RnxicekgQq/ekregaQZogrqM5EHg5iS789nIiRcbguuM
RgQO6Imcpd0Jw6uEiLK4XcFBywpbFw==
=IvC1
-----END PGP SIGNATURE-----

--rCb8EA+9TsBVtA92--
