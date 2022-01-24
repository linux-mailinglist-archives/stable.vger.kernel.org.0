Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E73B49806D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbiAXNGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:06:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59340 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239858AbiAXNGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:06:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0477AB80FA1;
        Mon, 24 Jan 2022 13:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2623FC340E1;
        Mon, 24 Jan 2022 13:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643029563;
        bh=ZZlC6yQ77rHhWqT90zMzi6f0dEybPN6YRh/LW1Urf94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P+TENVuV7lmGzdRXU4BUSm11c8Bu1VVM0xsTH49CzeMToFuHV817eElQhM2vFtbh7
         yE7k1WoH603Y5/DwotdoalGYgjdvI7vpESAnDabtZmRG9CBGjX3tVyXDy0OBKDdv1z
         q5ivrk+LfaO4PQNE1AAB3SC2KvL3Uk13PaUD/nxBqZkPuHkGTvlVCVkMxOgyAoGFiW
         knVyrlsRaXA7YxurgJq4cBd++KGPcGmJg8bzpv5Qf7dSNd99Xv6gYTGpRiTMWh4CP+
         xCEjFYbBhRh1fR4BtObItbJhO+sEWsbEZSgCs9aUyQ8G5yhD1bk+aU21+hvcYmcIAi
         vfquP4sf4ONdw==
Date:   Mon, 24 Jan 2022 13:05:59 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL
Message-ID: <Ye6kNwFisZw2MwV1@sirena.org.uk>
References: <164301227374.1433152.12808232644267107415.stgit@devnote2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hx2tYzScFFysvo5H"
Content-Disposition: inline
In-Reply-To: <164301227374.1433152.12808232644267107415.stgit@devnote2>
X-Cookie: The second best policy is dishonesty.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hx2tYzScFFysvo5H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 24, 2022 at 05:17:54PM +0900, Masami Hiramatsu wrote:
> Mark the start_backtrace() as notrace and NOKPROBE_SYMBOL
> because this function is called from ftrace and lockdep to
> get the caller address via return_address(). The lockdep
> is used in kprobes, it should also be NOKPROBE_SYMBOL.

Reviwed-by: Mark Brown <broonie@kernel.org>

--hx2tYzScFFysvo5H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHupDYACgkQJNaLcl1U
h9B6QQf+Khb96INwt1OmQe3AFIwjSxmvqgljU+eJKeBzrXfqfXT3HO/7YxGieiCG
igbQ3qNwp8sUW3Hb7D8lcH8ZpG+SY5ayREJLcy4Ki3OuUCSz5rpUcFYyqmka6B3o
u25eygoSoVL0pKGeumj++jS0zy0fiSRWF1SY7f9u96bwmAWEtG2Wpt03m0lUXRNC
KkzrkCTBAqbJdC19KZQyF75cEgdik98btQRtKO6fFADS9nCOOvsRbsfIcjl+fffV
54z1TM60Rf+PYby4nrkHsQgJ/UK9+ytBnQHO8/p1A/bdGrh0cI2X2l9KjLGQx8MD
WKlX/TN8G2qV49YAks+3s+mKfGnhQw==
=MfQj
-----END PGP SIGNATURE-----

--hx2tYzScFFysvo5H--
