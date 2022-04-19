Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2B0506934
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 12:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242394AbiDSLAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 07:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242403AbiDSLAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 07:00:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3B618376
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 03:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28739CE176D
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DC1C385A7;
        Tue, 19 Apr 2022 10:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650365850;
        bh=QmakAlgYzbO33E8PQxxvJSmaiTWpTxz1j5RJWtgWLQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qcFDjroVvHeZZmkbtARE/ecx1DXyR8QO9D0FkEqLdTk4k6y7xr9Ad1w9PnKBTet1q
         odluExfEUJQvVLAlvujaXsn1OjMvtFz07481rACegvBs9y+gjAtruLZfORvMwXmdx+
         JmjFh5icBU5G7auIypsCkxdQwXR7L8rb9iR+cTB6x4EZ69hGykHjPBLtzObr4wJXJ2
         4jRiZNFOiWe7W9SaEzZ6Xq95bw50eloRoocTdJGVF7G0zQoaR+jaA3xCaJB9ujfN7L
         6kEWIurCYGReyholrAcx9X92f0N8JxaqjF5hxkj/m+3kC7rfamrzI+MZJJ2JTAS8Fy
         pAlCWMhKrubEA==
Date:   Tue, 19 Apr 2022 11:57:26 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 2/4] ASoC: ops: Fix stereo change notifications in
 snd_soc_put_volsw_sx()
Message-ID: <Yl6Vljzvc9nTowEq@sirena.org.uk>
References: <20220201155629.120510-1-broonie@kernel.org>
 <20220201155629.120510-3-broonie@kernel.org>
 <c77d892f-4ff3-f7ad-482f-c9673a3cd86f@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yqWp3QezW/osOzvz"
Content-Disposition: inline
In-Reply-To: <c77d892f-4ff3-f7ad-482f-c9673a3cd86f@linux.intel.com>
X-Cookie: That's what she said.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yqWp3QezW/osOzvz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 18, 2022 at 04:33:21PM -0500, Pierre-Louis Bossart wrote:
> > +		if (ret == 0 || err < 0) {
> > +			ret = err;
> > +		}
> >  	}
> >  	return err;

> cppcheck flags a warning on this patch, I believe we should use "return ret;" here, as done in the other patches of this series?

Yes, I think so.

--yqWp3QezW/osOzvz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJelZUACgkQJNaLcl1U
h9BXRwf/fz+Hu2QOnKw7xwTmsNMx/E9uc9Q7hkK+Hhbe1/ZBMPhZac8Eo0Pvrlc8
h9jFg+SjlhxEuBYLpgHNCOOO9+ZJFx7nBLkz91SEV8w90CqBMG2tUvi4qz0P0pnd
0BvLTNh0+IJD2p5ADe5ZkTlRn015ZEwh8dyJY1HJ4SXKY5UXlrINJu7lg3BjS5mb
ziNj4ZibTTdubwpOk7uTPb2fWby2jGOcmpNJ5RbmVgQxMoMwRX57rCBMLpZnDgCn
qb1vxhvhAsSz/I6kWC5bZndLIT4dXaCniyXGSmr7PwkobjEldm+PVa/vhUYrYTGK
3Ban5PJZg1l7LOsOaBJAZDNKmNbFNA==
=80pR
-----END PGP SIGNATURE-----

--yqWp3QezW/osOzvz--
