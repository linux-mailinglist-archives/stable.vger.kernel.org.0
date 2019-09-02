Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A91A507E
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 09:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfIBH7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 03:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbfIBH7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 03:59:44 -0400
Received: from earth.universe (dyndsl-091-096-044-124.ewe-ip-backbone.de [91.96.44.124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C28A022CF7;
        Mon,  2 Sep 2019 07:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567411182;
        bh=GjwmwKzURWQlyOOmKM2+qoYjiZfogOXfEh8/6H3ndVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R1SYeQl2kRAg3UcGoRSgrjKKHloVq2t+5/ENNvNqxXP/oiASEbck/rSjNCsLJ2Zsh
         yUw+L1esOby2OKmsIPcaeW6wDDpwZuFBrA32sRDLFHxgAwN4xPYZ6LDohAsaBuoGy6
         +6DcphO78RIQphXh6dWKdslcMd5ZiqnEJ7YWUDtM=
Received: by earth.universe (Postfix, from userid 1000)
        id E8C493C0B7F; Mon,  2 Sep 2019 09:59:40 +0200 (CEST)
Date:   Mon, 2 Sep 2019 09:59:40 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Michael Nosthoff <committed@heine.so>
Cc:     linux-pm@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] power: supply: sbs-battery: use correct flags field
Message-ID: <20190902075940.fawqc2obq4bq35gm@earth.universe>
References: <20190816073742.26866-1-committed@heine.so>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dn52uxvouw7dbvkr"
Content-Disposition: inline
In-Reply-To: <20190816073742.26866-1-committed@heine.so>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dn52uxvouw7dbvkr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 16, 2019 at 09:37:42AM +0200, Michael Nosthoff wrote:
> the type flag is stored in the chip->flags field not in the
> client->flags field. This currently leads to never using the ti
> specific health function as client->flags doesn't use that bit.
> So it's always falling back to the general one.
>=20
> Fixes: 76b16f4cdfb8 ("power: supply: sbs-battery: don't assume
> MANUFACTURER_DATA formats")
>=20
> Signed-off-by: Michael Nosthoff <committed@heine.so>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Cc: <stable@vger.kernel.org>
> ---

Thanks, queued.

-- Sebastian

> Changes since v1:
> * Changed comment according to Brian's suggestions
> * Added Fixes tag
> * Added reviewed and cc stable
>=20
>  drivers/power/supply/sbs-battery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sb=
s-battery.c
> index 048d205d7074..2e86cc1e0e35 100644
> --- a/drivers/power/supply/sbs-battery.c
> +++ b/drivers/power/supply/sbs-battery.c
> @@ -620,7 +620,7 @@ static int sbs_get_property(struct power_supply *psy,
>  	switch (psp) {
>  	case POWER_SUPPLY_PROP_PRESENT:
>  	case POWER_SUPPLY_PROP_HEALTH:
> -		if (client->flags & SBS_FLAGS_TI_BQ20Z75)
> +		if (chip->flags & SBS_FLAGS_TI_BQ20Z75)
>  			ret =3D sbs_get_ti_battery_presence_and_health(client,
>  								     psp, val);
>  		else
> --=20
> 2.20.1
>=20

--dn52uxvouw7dbvkr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl1sy+wACgkQ2O7X88g7
+pq94g//UI5/sH7Za6ygQYXPOe5x30DV82fpdWCXx6h1u9qSUyuoQeW9aha0HgLJ
8enkkNpOPJv9AFvWUKS7IkEp599X48KBW/7L8s6g6pnuUnFxomxN5F80tluLOXG3
pgr4VRQ7yrgdsk9iM87pXjybObDwsLQ4iJaqV0jIY93/BdQvPqk2Xf6LiSYWD+RW
i+3IYvs3Z9Hw62wi994fBP8++25nTk74sjDwq55CLkY/c0o/3YeENewuCRQZsjP9
7uz433NZtNEjD3M7XrUhEFfmo0R7MlyHmrsoIVhBw7BHwt749zsiBS6Yrku3RHU+
6x0DNKZ9/tLM1L5H18L0YFwkz4kycdvyYM7E8yOIgtWoSKL2qhscNMSjEhQXhEUz
f72q4kGqdLnuYDNh8roKK3YGpfnxfngfChmyZwt7SJrrDGjf1h2CzxddJtKysVE8
1P2Y2NMYLmbleicj7xDazwIWCp+Fq6i2z888y63QLlfzwbdm7Mchedvz6M+emD46
8a984ji2lxNEngDKgotagsYC5dcoZ1AMzLB4OyzCbv+x1spY0fwF+BPRGnUz1r0E
JeUaGM39lE6aQiL6Ug92ifowkpD14A3RRfLp32SmRGSrRul9FuKBpAdwfaTWF3SF
5iOkMdaHRGc6LlsZtNAHRH01MO+EW4MTQGwpN7g1VdDbw5Gu7Wg=
=Rm5p
-----END PGP SIGNATURE-----

--dn52uxvouw7dbvkr--
