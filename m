Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133835B9AB0
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 14:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiIOM0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 08:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIOM0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 08:26:24 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA084BA75;
        Thu, 15 Sep 2022 05:26:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x94so9390613ede.11;
        Thu, 15 Sep 2022 05:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=uGRL5yQLbY3ElF+aziAWDQcKmM/TufAgwc3RyqfUbOA=;
        b=TZjkJcXRVux+bToBLPHAd5K6Hh2IjWPCCLb+L4D7PThzlh/RFAnwSF2DRlC1kJeQLE
         DjGAyz+irYMIQS682A1kCt8mPme+WersR1DNk2BpprQslAGwOYcRqVxXYWzlAiqU7Fb9
         yWWIzYkgizbuPw6IrkdOWqFyeaCQRSg+s07IRcw+dtxbe/juYPJOwhAA3RsAY3bBEo6e
         LU8fgRLFw3xNN2JgrPORZYvF2KBT6+rcuTyMGF0p0xV2oDR9zTeube5y3R8eKc4Ed/Hs
         qjawQUCdKuoZjHcq2oCRJ+5lDQexyWkvVr7a+NMXDvr0xKLYReiPCOSpDBXx23G2prYP
         FbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=uGRL5yQLbY3ElF+aziAWDQcKmM/TufAgwc3RyqfUbOA=;
        b=cgKOBRQ4Kl6xIeKQiV1FvfjbTI3fN6UdEyBZBNF7VVTJYfFk8xjapXU80Vdf4a/X+T
         jnp7i46V5HvT918tQU/KrcuDGsPyr7iF4OHhNqxU8RJmW4If1bj/dQW2Vs3QphmMiApn
         7L7VfO8+2emv+L5SE64eu6HhKrs76ukpAhbrvM1CpWZfWGlCJChbyFv8gd5xj+BF+xp8
         57bYjLlv2ttIfL181PYYBPpgIfyFN+VyrEZQYlU7P7uBrf6vt5TZvXIV8quk2xArLme/
         iNM9gQ3gNbE2r8O4QM/8sk+HCc2kVQzNmxD3LFrdMf40vUC8Z1MFIis2ltA2ZSVI3mh6
         wWmg==
X-Gm-Message-State: ACgBeo17URDJu0xFOqXy8OY4DTH+Q2MHpVW3vFdrcxvzv79ToIwLPpJ5
        Liv4bVX+8S9tPL65T/XYGqo=
X-Google-Smtp-Source: AA6agR4YiRZmdLeUOPMY62dN48Kv59p5JJcRsxunUip1RF1UqEA5VDaKI4olBMaG1V1Gf6/zGQQNSA==
X-Received: by 2002:a05:6402:40cb:b0:451:2b71:9940 with SMTP id z11-20020a05640240cb00b004512b719940mr23915246edb.237.1663244781806;
        Thu, 15 Sep 2022 05:26:21 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id q16-20020a170906541000b0073d7b876621sm8981674ejo.205.2022.09.15.05.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 05:26:20 -0700 (PDT)
Date:   Thu, 15 Sep 2022 14:26:18 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2 RESEND 3/3] serial: tegra-tcu: Use
 uart_xmit_advance(), fixes icount.tx accounting
Message-ID: <YyMZ6g+7mVPilDSP@orome>
References: <20220901143934.8850-1-ilpo.jarvinen@linux.intel.com>
 <20220901143934.8850-4-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JYX55bxPpJGogj/9"
Content-Disposition: inline
In-Reply-To: <20220901143934.8850-4-ilpo.jarvinen@linux.intel.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JYX55bxPpJGogj/9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 01, 2022 at 05:39:34PM +0300, Ilpo J=C3=A4rvinen wrote:
> Tx'ing does not correctly account Tx'ed characters into icount.tx.
> Using uart_xmit_advance() fixes the problem.
>=20
> Cc: <stable@vger.kernel.org> # serial: Create uart_xmit_advance()
> Fixes: 2d908b38d409 ("serial: Add Tegra Combined UART driver")
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> ---
>  drivers/tty/serial/tegra-tcu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Difficult to review without a copy of the first patch in my inbox. I was
able to find it on lore, though and this does seem to do the right
thing, so:

Acked-by: Thierry Reding <treding@nvidia.com>

--JYX55bxPpJGogj/9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmMjGeoACgkQ3SOs138+
s6HXkBAAlZGnHov9LOsy51mQEjgF33NARgWHCqPek6PaHIXE5mcpHyJN2Scsf2YS
B/CkGnOL+BmUfQib/zn93OigRjoYTuWshbOGRv8ZulaO0xq7uOqNz/XDb3McmGVN
seoqrEfKn3GHl5SOenWo+yDSGlUCm7ObcZB+G0A02QhdK2mbv+/0+7Vui+FZ8lt+
N87Tv6/dfAtp/MpDcC1Qtl283B+1XpSOVXM3bAJtWtRViuTK9bWdiVFCc7Mlkt4U
IwKyEc41YwPxIghrdwzPaQ0LBrtPvZuBACx5PTwp1R+cmMzZvMoRqWoibutlQb9l
3b8wHE1CghyF32L9C0yqEDEg6c/fNqMukREUUbgaVOoKqZ5D3XdfMf/mTrBJ9LAj
E3Cvii+RadRPjNb+fR/hMItht/iYrKPFdBs72W+MmBrieFUAnvfxwqE/8dFSWVdb
Gxpiq11HhV665GTm3mFBeKidmAPQGWk1JEte7XVcmecAKi5YRviZQgjrN66to5Gc
cV8edOjmkE39hcAftBOyewfzym6A/3VmenmftxLOfGa+1XitZ7pOkdnNT/BXhgBE
+Ua8GXGtRWV/E4q1o8+4Gu6s0kNK8YAdub5IWZc86i4z9rKQ3BaZpYEO3/NRqQLW
Hwb5X7MBDqZLkZjKnPRC0Z965cICrCOkljkb1Rbretbu+0CbFPI=
=foZk
-----END PGP SIGNATURE-----

--JYX55bxPpJGogj/9--
