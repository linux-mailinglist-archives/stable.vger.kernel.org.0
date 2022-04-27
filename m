Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75EA5115A9
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 13:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiD0Lbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbiD0Lbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:31:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C904369E0;
        Wed, 27 Apr 2022 04:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9A3DCE24A5;
        Wed, 27 Apr 2022 11:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44862C385AA;
        Wed, 27 Apr 2022 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651058918;
        bh=KYefxwE8muQLfB8/GFKsQOVVnH3tuDDSR5Dacx6IqFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lWFbA7TJ+gjyCugQoD38Y0xsuqPTvrv8+avXuCmzuu6EgBxKT+FdpwlkksGjrBHSw
         F9oZe5C5XZ9sqPYqv+K+VNwynOTDmy6XL0eRHdREmkioTQfBs+7wdsvxfLzQELuxzw
         IuMquBUy9l5Lc71+7HSsRifiBaia3rspjVwZ10FPud+NC8OS4DDjvkaXpUO/X/Js4j
         ZclsUJZ/vJBxM9KDKmHATc2P/roRYljSHl72LnHzrhfuRHnGkpYSUUOCBd5Q6O8DaL
         rhS1ZKKckKHiumBELoSkqNzcFwaV8KYxxV7FV/tDhWzPHl26vUMkyNECfTDEtobYi0
         PvmCe40MAKZbA==
Date:   Wed, 27 Apr 2022 12:28:32 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        cezary.rojewski@intel.com, liam.r.girdwood@linux.intel.com,
        yang.jie@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        peter.ujfalusi@linux.intel.com, yung-chuan.liao@linux.intel.com,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.17 06/22] ASoC: Intel: sof_es8336: Add a quirk
 for Huawei Matebook D15
Message-ID: <Ymko4F24MvbGJUXp@sirena.org.uk>
References: <20220426190145.2351135-1-sashal@kernel.org>
 <20220426190145.2351135-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3g8d3iEzGGy4GnO+"
Content-Disposition: inline
In-Reply-To: <20220426190145.2351135-6-sashal@kernel.org>
X-Cookie: Buckle up!
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3g8d3iEzGGy4GnO+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 26, 2022 at 03:01:29PM -0400, Sasha Levin wrote:
> From: Mauro Carvalho Chehab <mchehab@kernel.org>
>=20
> [ Upstream commit c7cb4717f641db68e8117635bfcf62a9c27dc8d3 ]
>=20
> Based on experimental tests, Huawei Matebook D15 actually uses
> both gpio0 and gpio1: the first one controls the speaker, while
> the other one controls the headphone.

Are you sure this doesn't need the rest of the series it came along
with?

--3g8d3iEzGGy4GnO+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJpKOAACgkQJNaLcl1U
h9C2BQf9FuQSxz6S1uzeAKSRzxsY/5aEfiqZExmG3uWEF1KKk8OnUC8AxhiH4mYk
FkxMONPvC/RyJlltvesFObLOloFwZpxybS0npgw8EzJ69lrTrcIMFnrhlKCofWuJ
857AGRyGbmipP4oSDs++oTTjmBQYd5o5GXoBJ/sUyfO2bxMYyAhYXpZ/x5+nuMyQ
6SII3rwtTk3GTQumxiYInwmyEzR5zq/ae4cPAG7fImWA3130lVM7Aa/HwP2HkxYB
mzS1dP2Yjl944mqBCwq3jQC4SeCSx0zCZbCxGIWDKuRzZVL2KDHsfBvrIX/1EnQ4
MDVnIs3Nv+dkG5Yj+ZszbK1mTFAf1g==
=59WY
-----END PGP SIGNATURE-----

--3g8d3iEzGGy4GnO+--
