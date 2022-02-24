Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9CE4C2CA5
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 14:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiBXNF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 08:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbiBXNF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 08:05:28 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5629937B5A2;
        Thu, 24 Feb 2022 05:04:58 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p4so1073878wmg.1;
        Thu, 24 Feb 2022 05:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DhUAP0/TlSc+D9QAmPdkmtU23TxAiQaKS0sYg0POhyc=;
        b=PaThR9YqKLLRo1Q1q9KhQsac9ZwlrkNWwwbsrTpOurWNHpRk/NTdH78WKwLg0O+BXa
         vGMW7fW6wFF13BB+ealzGeyaNN2A4Ulg5qIToffhObh96D5MkrEzfnJD90BIMxqO/AaE
         fyyScSHEN8EPxpWcFhfTY0PkCU1JHfSrKClJKyGuaA1cGoXJD4bds/Nq55KuG7R9EGh0
         dXgIPY8ML1WinA5tWU1qf5Ea8dChHunNDmQ0+vNS4giE6RbFfznqLHF9tUeZnqgo0bgE
         nO1bcYUn4EfW1ZwTTo8vnnWqjpE0t52vnDnLUgSUbethh9uv3NKHkZsr+FcaP8Xh6B9F
         kLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DhUAP0/TlSc+D9QAmPdkmtU23TxAiQaKS0sYg0POhyc=;
        b=Z8kYB2TqQ58wV0q6MZ+1zvEeQIvHT0idfsYgD36nAdVq2d45xFxaDObAumZB0AxXj/
         4uESflj/2s4zCJmf7l7SUsmPV2B0BWbPVDh3vTHcm1HFYPG8c/dDvHz7MlMlLpD3zB4A
         WzxdAIQGgFx6ufyi6LcO6jisXYcntH7OIVIay2XcJItNwucymELCSjXYwnOyXmKoMnwP
         +qLvwByi7XQzqwnaWgjJPT6pYHQDORceoR9lCczNc0fDp/aJvcE9juVm5ju2SXQj3csI
         WMViYJNf9UA2O3lpQND5ePIkN03ToaYXtN4OCDnOLsfR0JXjXfMJKsyb8D+uHFO3pMiQ
         nqcg==
X-Gm-Message-State: AOAM532KEOCNFUZCIYZ3cxZ2/QLq8535mVn1Prsp6AGLjyp4E0ML+oHK
        0fVeu1xxwQK5o5lZD8Nf2b8=
X-Google-Smtp-Source: ABdhPJyFMPao0YZNvFVF81tba30SWNxwVtHCcA+peq4piZl0uSnPfrab2zhlNtzNvSBHnxpGwSqU1A==
X-Received: by 2002:a1c:f616:0:b0:37d:1e1c:f90a with SMTP id w22-20020a1cf616000000b0037d1e1cf90amr11231450wmc.148.1645707896770;
        Thu, 24 Feb 2022 05:04:56 -0800 (PST)
Received: from orome ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id y17sm842932wrt.70.2022.02.24.05.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 05:04:55 -0800 (PST)
Date:   Thu, 24 Feb 2022 14:04:23 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Max Kellermann <max.kellermann@gmail.com>,
        linux-pwm@vger.kernel.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, andrey@lebedev.lt,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm-sun4i: convert "next_period" to local variable
Message-ID: <YheCV0RKJcB/ppCn@orome>
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
 <20220125143158.qbelqvr5mjq33zay@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oXm9NdrQPALqwUuS"
Content-Disposition: inline
In-Reply-To: <20220125143158.qbelqvr5mjq33zay@pengutronix.de>
User-Agent: Mutt/2.2.1 (c8109e14) (2022-02-19)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oXm9NdrQPALqwUuS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 25, 2022 at 03:31:58PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> Hello,
>=20
> On Tue, Jan 25, 2022 at 01:34:27PM +0100, Max Kellermann wrote:
> > Its value is calculated in sun4i_pwm_apply() and is used only there.
> >=20
> > Cc: stable@vger.kernel.org
>=20
> I think I'd drop this. This isn't a fix worth on it's own to be
> backported and if this is needed for one of the next patches, the stable
> maintainers will notice themselves (and it might be worth to shuffle
> this series to make the fixes come first).
>=20
> > Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
>=20
> Other than that, LGTM:
>=20
> Reviewed-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>

Does that apply to patches 2 & 3 as well?

Thierry

--oXm9NdrQPALqwUuS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmIXglcACgkQ3SOs138+
s6FRUxAAtonf5XYehYX3vdyH6c8zXEQ/GgFz0rxBJuNObVjlIq3SBQHvelEF6ktU
QJP6sJJYZ61WmZN8a7t8sij5lJa2GxBqE2msLOV/bk1i3V83isTtEWC063LSSQc1
A6U6H2O5HaOIKDIAW1c3vRAPRITCv+u0Rvkyv5XXom5A3VpiBsQX3g+qgZwwsFI7
RQDH7x9ns7Sii4hs171bZsL3fCfSWSei+JRct6JW0cwWOT6ub0JOntAMnkO7L3X4
lpXQ7+/j+gvS3n8mkIRCicn0G3d92AQm+8wnJjEe5JFxbu4cmCeMq2mIWNJGqeNy
5U4Cf6dcs8oh/hjKTqVMuzVVz8Q4N3nfk48n+4PqlWseeRTVKYxxjQuzZA/SN8hc
xaO2ljnhlQkO5KQl0w+yF8yGq0xSx8K5s04OwoYbikLBGmAPcGoj0wv1pekz+Dcx
y3542cK9+ATjJWM1cyMVFDrHYHSHwkZO9W/vTpXb3cEYjqDcEOZwGaCMfYlyYRoy
EEN0vijgw4JWzRfQJL6092HGsK6/Rslf02Kpt/KCIzJi4oqnLRVKZcvznFe93cQZ
kHI0ATv1nlFByUPDUrs24LqzWCLWOp9+Xwkwh+mCfFRBpZo0fHD6EU22gK8bft3d
ZwJnESFb+4Mt9t1NqXcaC5fgtCz1/pHyynnDD6LTKeqNtby1FjM=
=YE6f
-----END PGP SIGNATURE-----

--oXm9NdrQPALqwUuS--
