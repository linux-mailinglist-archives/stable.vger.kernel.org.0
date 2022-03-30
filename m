Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805574EC317
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344768AbiC3MLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347625AbiC3MHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:07:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BEDFF3;
        Wed, 30 Mar 2022 05:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C06A61798;
        Wed, 30 Mar 2022 12:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB921C340EE;
        Wed, 30 Mar 2022 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641931;
        bh=jc8kMXIBKp9TnaxWPUYRTe23rEECejIQK8a9f9YdQnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RAnlztVwfzZCrWDFKdF8tDhpUxQDMrM3Iiw0gMAkNSBiQOQwLLFefTUDutqw5Zj3a
         bGWmZkL4LZMnAADSfWa/4D7if6k7yymEgKiiT15aNqIGBl6agGOVLtuLASGqI06zQ5
         FZ86jW0b0h9LBIU1vCDc15PYyVWz0nRMbjBf5kRrk0IDwpBip8L2U5KrgAjpz/plwt
         ofap8qFZfYN2uFjeSXwI8Rc3NRdhD2WSJY1Vr0QHA5Mt5hl7g9XU2ipNOyJD6VPm/4
         Cpf5RV4jn5f6pcvqImdzg2WbGiSMc7YHAWJBLN2O10h0+D4UaacOZJVRkT6cCApJmS
         tIgJBF+RM/U9A==
Date:   Wed, 30 Mar 2022 13:05:26 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.17 64/66] ASoC: ak4642: Use
 of_device_get_match_data()
Message-ID: <YkRHhksDIqDpHoCz@sirena.org.uk>
References: <20220330114646.1669334-1-sashal@kernel.org>
 <20220330114646.1669334-64-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wY49DEhnV+VGZ3C0"
Content-Disposition: inline
In-Reply-To: <20220330114646.1669334-64-sashal@kernel.org>
X-Cookie: Two is company, three is an orgy.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wY49DEhnV+VGZ3C0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 30, 2022 at 07:46:43AM -0400, Sasha Levin wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
>=20
> [ Upstream commit 835ca59799f5c60b4b54bdc7aa785c99552f63e4 ]
>=20
> Use of_device_get_match_data() to simplify the code.

This is just a random code style improvement, I can't see why we'd
backport it to stable?

--wY49DEhnV+VGZ3C0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJER4UACgkQJNaLcl1U
h9DEKQf/UkrC0gTTDsQeNN8/3QnuRX6+/uuqssECa7EsnrhZO6vGmSimjxhC+YVU
5ycvzD3REZCYQN0dVxku+ecC1u8LM761uY6UJLlPkEZM3lPy8LXhk7zxxFNxJt3X
7jtYlsj1f29ouXj22xjCGYIc91srPZUApnb5xYqZUEo4XIX0/JNQwlnVO1bNGSzv
qREppIDOzV2gSTS9RrjrIZF5+GjxHHD+0j1xti13tzcfikT0+hTNgqhCVfgqhtmG
1/MUncVvmL6W/NNgWNPtPGlId6Db5xMgKA+r4p8IjSACCX6P2lXXSQuTfHf+U1+X
nyh+U7Dr/rm2ZkrKuI2AuU4pIP8CUA==
=NIEe
-----END PGP SIGNATURE-----

--wY49DEhnV+VGZ3C0--
