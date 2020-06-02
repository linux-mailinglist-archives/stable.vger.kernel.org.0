Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA6D1EBBE1
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgFBMkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 08:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgFBMkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 08:40:49 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00308C061A0E;
        Tue,  2 Jun 2020 05:40:48 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id x1so12572357ejd.8;
        Tue, 02 Jun 2020 05:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=niT9jOzFuN2NCfZ/IUmRYMI3ZZ7HW1svqTzOyKem/GY=;
        b=Sa6V5cmom+EpKHaXLrGQ3G9oDNXjY7kjwghMmGcidLLrX9Nlei2ZPspqTL3y6DRlRd
         //STw6jNoNcLyfU7V+pU7jFL70EMOqltF7ZB4WBZ+39UgExPcCjkaLUdlPff8dQA4JlK
         +PMexbmuiaGMRobAI0fbErMxQJ9izCV7rymAtQhnBEsPjSweK4z/NkfJqlfPzrYRdAxn
         RZHFqWH82+Dh1GfMs1cXGlsLOb1O+cFGD6nUv1bsKnkbfRkinwNsnMUTxHBdNEBpTG0K
         fANURxqU3KYa2tF+artQcL47ZXH//f3wn9NJFqdt+wGfQTS/WbEDIfTBr/FvoJmvwi+C
         JLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=niT9jOzFuN2NCfZ/IUmRYMI3ZZ7HW1svqTzOyKem/GY=;
        b=uEgpNBqs+E5Ouz6Pue+5cWn4V/0BuKNa36fIBUICpRE+XZcz5oJFFMCvcXfnX+9YCY
         i7x+a/Edn61JXeJMfjTwSxrz3910sei5ZvmSczHqJv4JhmQEeMZ/whPpiBycI3s9EgUf
         uNkjKRaBv0ztOHIvVTUh7EQ566Bd+WH1BR5HIYHHAPkeeCQ5YqNK56a6b8oCxykQuvQ/
         zp0uk4dbSJwGgXdwkVQHL9smouhwXUAstT/vWGMfVLCiggkadaBmgwZKre3RjOJ36SZU
         nxN5L25Q5pEE1jXcau8HEgoA4MFjfrxXf5Y2lfa1K7U9HE/feX/PyUu06dx8B3fTkZtL
         3Ylg==
X-Gm-Message-State: AOAM532U79gu3v2NUabJ734nbXaew24qZUd1U2nzWIgBk4Bk94MPOXWt
        6D5BoXJuZEbWyGMsHJ2FYrg=
X-Google-Smtp-Source: ABdhPJzBbhcNiGzmplFsbJ8iJ8Dkkme6+Cro2wO3XrtzvMNtp+XeDCtwuUl8d2UMk4gI27laekECAQ==
X-Received: by 2002:a17:906:7746:: with SMTP id o6mr9012036ejn.75.1591101647750;
        Tue, 02 Jun 2020 05:40:47 -0700 (PDT)
Received: from localhost (pd9e51079.dip0.t-ipconnect.de. [217.229.16.121])
        by smtp.gmail.com with ESMTPSA id ch14sm1499331edb.33.2020.06.02.05.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 05:40:46 -0700 (PDT)
Date:   Tue, 2 Jun 2020 14:40:45 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-pwm@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pwm: lpss: Fix get_state runtime-pm reference handling
Message-ID: <20200602124045.GC3360525@ulmo>
References: <20200512110044.95984-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <20200512110044.95984-1-hdegoede@redhat.com>
User-Agent: Mutt/1.13.1 (2019-12-14)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2020 at 01:00:44PM +0200, Hans de Goede wrote:
> Before commit cfc4c189bc70 ("pwm: Read initial hardware state at request
> time"), a driver's get_state callback would get called once per PWM from
> pwmchip_add().
>=20
> pwm-lpss' runtime-pm code was relying on this, getting a runtime-pm ref f=
or
> PWMs which are enabled at probe time from within its get_state callback,
> before enabling runtime-pm.
>=20
> The change to calling get_state at request time causes a number of
> problems:
>=20
> 1. PWMs enabled at probe time may get runtime suspended before they are
> requested, causing e.g. a LCD backlight controlled by the PWM to turn off.
>=20
> 2. When the request happens when the PWM has been runtime suspended, the
> ctrl register will read all 1 / 0xffffffff, causing get_state to store
> bogus values in the pwm_state.
>=20
> 3. get_state was using an async pm_runtime_get() call, because it assumed
> that runtime-pm has not been enabled yet. If shortly after the request an
> apply call is made, then the pwm_lpss_is_updating() check may trigger
> because the resume triggered by the pm_runtime_get() call is not complete
> yet, so the ctrl register still reads all 1 / 0xffffffff.
>=20
> This commit fixes these issues by moving the initial pm_runtime_get() call
> for PWMs which are enabled at probe time to the pwm_lpss_probe() function;
> and by making get_state take a runtime-pm ref before reading the ctrl reg.
>=20
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1828927
> Fixes: cfc4c189bc70 ("pwm: Read initial hardware state at request time")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/pwm/pwm-lpss.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)

Applied, thanks.

Thierry

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl7WSM0ACgkQ3SOs138+
s6FhRRAAuvaWzzTcka9pbQE9E0+InpTkaaM4jW+gV5eJAwbFAH/ggDepZsNJpRRy
H1c3PubRZFR3XPJFMcrJKDOvCAZC2pkChaeTqjtwBBForNIt+AoRhF3hgmr3bhMZ
Q7S3rahk9eDABzTNXWemesQfoyoNjnYAKqqRvPHG+rDIewOVBc6zY8lnQ3SS6Dy/
HY1oQopujNaub1T2aKfufdLGlPzCzIG/ZxuMmx5i2hG7SMVnS/Z//tKNhLrIPxt4
6fOun1F+2GgScUyjRz6tNIflHJ0B9emCZH6sc8J5vWtnXNtQ3XHft0YT7EQRpu7n
h6A9434xaPSblA/FLXTGxdW2qwPvrxFQ4ZAA43CdGYka9Ibd8A7T3jQMYdQs6vr0
r7z1s6dSVTQ+ai2+jds7GwU6v6TfQvlFb21nXz2cAbJBh0ZM9WrpFdaiXG//odXt
HNGNn6O3XcsSThigBk+j+RmJ2MSeGsUiTVD9w3TBknyrpPOdaMikeVtDjaD6dnbA
De9cIubENvTmEdsOp1MN2meImbPx9IrKYr/dPo+PSx01L6U550PiYg7L05rsulB1
15qEC0FRjtxypAjDXKcu1ovYM8749OnXskMmW4Ybq1aEvJROwYXfQiiBbU6RrwWZ
FBf5LQdD9ELqscfR70bcE/S0hrEgQ+jLAEdsr3OtpIXqrJuxN1s=
=oZB2
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
