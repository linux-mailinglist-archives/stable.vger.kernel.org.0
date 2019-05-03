Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F42126E4
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 06:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbfECEei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 00:34:38 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:46952 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfECEei (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 00:34:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ajr35B0OPmYp0uksnhPeXTb1xq5aJvRQAQZCo3Hnvqc=; b=GjpsXnCfliyL5USC5eNrbk0+o
        z8VfBbhpBwFeU5JNq1JkwWuTcjA15f+9GN5XbnPHOIPoWD2vwiwWC/Lv0+pfScgiYDMQKOdNAaDn/
        qTFSnDQ1yfsf3DoVw1VCHIOOhFnKs+PY8XxE8wTlki+9B15LVGE14dO+C7BKcqELpQRy4=;
Received: from [42.29.24.106] (helo=finisterre.ee.mobilebroadband)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hMPts-0000MQ-Io; Fri, 03 May 2019 04:34:21 +0000
Received: by finisterre.ee.mobilebroadband (Postfix, from userid 1000)
        id EAA20441D3C; Fri,  3 May 2019 05:34:06 +0100 (BST)
Date:   Fri, 3 May 2019 13:34:06 +0900
From:   Mark Brown <broonie@kernel.org>
To:     Ross Zwisler <zwisler@chromium.org>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Jie Yang <yang.jie@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ASoC: Intel: avoid Oops if DMA setup fails
Message-ID: <20190503043406.GZ14916@sirena.org.uk>
References: <0b030b85-00c8-2e35-3064-bb764aaff0f6@linux.intel.com>
 <20190429182517.210909-1-zwisler@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="p+/4B2pcxE3X6xU6"
Content-Disposition: inline
In-Reply-To: <20190429182517.210909-1-zwisler@google.com>
X-Cookie: -- I have seen the FUN --
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--p+/4B2pcxE3X6xU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 29, 2019 at 12:25:17PM -0600, Ross Zwisler wrote:
> Currently in sst_dsp_new() if we get an error return from sst_dma_new()
> we just print an error message and then still complete the function
> successfully.  This means that we are trying to run without sst->dma

Please don't bury patches in the replies to existing threads, it makes
it harder to spot them.

--p+/4B2pcxE3X6xU6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlzLxL4ACgkQJNaLcl1U
h9Bf5gf/b4Rd4TJAVsVpVmu3GoujrMqNu/jOVgDjPKDNLE70Cj/x4nvuVMvV6YAA
1W93C0kngsJWKhAgw3gvDsW2iIBGRLOCxB0JaHXntb5bO1ruAMKvyDfy1E09038c
RvoJg8367XfDLvnJKgoaktPKu+d4yPf73shGOVgEpSEvT5vs4bl5/zV1tB3NNHMG
U5QkmT8AoRhkDRWOrIETSfPaZJwk01VI7qjp9UxSqszBvbcxhwMbuDPyCcr5reXn
Q5aYlCH8a1mZoW4Az6NHsykSi8NyqPt1rvKYStPQn4WsasuXkV406EddfJL98bI1
I/gMNH5m5xTM4wPel4/Bi8jxQQ+V5w==
=A4ke
-----END PGP SIGNATURE-----

--p+/4B2pcxE3X6xU6--
