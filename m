Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0710D5B9ABA
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 14:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiIOM1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 08:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiIOM05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 08:26:57 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0674A7330F;
        Thu, 15 Sep 2022 05:26:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id r18so41745552eja.11;
        Thu, 15 Sep 2022 05:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=aR/TVUdwHIPzAaxWw0iWUIDp2ZfBjzwdD4OGWOrKPSg=;
        b=N+OZBUQRAy8ERgfOyb/A8InxxFRhcZQGI1QTE6mLjPbRXp8robGv/FeQQN2XcgQztM
         iyF4VBaSvr/SE2UnQX3xOxAZrGJ3ZmN2uhYxKpXH+M6hsfpy1NntfGFjRdqWgvirgj95
         BGG3ltPEeKiSPCBMKs5vbIWl54TT6OGGrNiEXLFtru66mYAdtuw50NBlKU79jNxnY6Un
         yg7hir2/ZRxKLC68v29j3r90PnLKIrxMOZo6IAGjC3eyoNTEaLqzXmd5oqVoU2t/no8G
         Bpe55N3RhMJM6Fe/NyCeR8y4VOCSXVHcP9d2/uZ0td9vrwFZO7Ya3cav6EfSSdMkdmp6
         0BUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=aR/TVUdwHIPzAaxWw0iWUIDp2ZfBjzwdD4OGWOrKPSg=;
        b=WnaBVV6FfrwWfZQOH9+Z5FWRAuVaYNzrlOclyldP38J9Uquo4FJpttErlOSVuz9K1h
         3WI2bKr/IMENzSwHGOaRg+MzIoDWkwWL6s0RN8+cSn7sCWEagPTsY7zEiDYHZ2vEGNMR
         aRdeICXFNRuESHlhfP51NxHta51tIz0vuz1Xle/Te3G6DwSXSp4voCJfJXmxugajpcN6
         PlzmAuW2vQWmSTlgrF3NEAknMUt0N/tGX06uPKVqPjNpkx7WAIoTy7zlpWSuuaQhFQsS
         9n75QRAQ7ftctMN+poaqIKooMtBd767fe/12pMMv8QNHXdHz6GTD84qI3o81d3ysST+Y
         S8hg==
X-Gm-Message-State: ACgBeo1aoCOlSndCh4wXB0/xnpVLjcEoFdNPniZpF7dXRKI/A7F0rsn5
        /fXomSoBU4jBHim8xeybNVs=
X-Google-Smtp-Source: AA6agR76TjVbfbFtlHg9VX5H/RA3hDYS1ufkF7r7sE4ozGLDLsAhD9y7Kz2cV1XdrYo4NpM/PUM92A==
X-Received: by 2002:a17:906:db03:b0:741:337e:3600 with SMTP id xj3-20020a170906db0300b00741337e3600mr29730591ejb.343.1663244811531;
        Thu, 15 Sep 2022 05:26:51 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id l1-20020a1709063d2100b00771cb506149sm9178971ejf.59.2022.09.15.05.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 05:26:50 -0700 (PDT)
Date:   Thu, 15 Sep 2022 14:26:48 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2 3/3] serial: tegra-tcu: Use uart_xmit_advance(), fixes
 icount.tx accounting
Message-ID: <YyMaCLW1XnA9wkNA@orome>
References: <20220830131343.25968-1-ilpo.jarvinen@linux.intel.com>
 <20220830131343.25968-4-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eNaICd2lN+1PNicZ"
Content-Disposition: inline
In-Reply-To: <20220830131343.25968-4-ilpo.jarvinen@linux.intel.com>
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


--eNaICd2lN+1PNicZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2022 at 04:13:43PM +0300, Ilpo J=C3=A4rvinen wrote:
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

Acked-by: Thierry Reding <treding@nvidia.com>

--eNaICd2lN+1PNicZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmMjGggACgkQ3SOs138+
s6HnLQ/+JIq8JNthAHC3qZ4LcmqWDJ90S0qUBCj7xEQqhrwyLpGz1XHDGLZV6Lvi
M+F7zjIarM9b0Dx7jtauYKca2GWrXtlJ9mTOwzEc21NCM0uClW3qczsY6EQlnn1J
8JB3ILKdofZLspiJ2pZKFkkog7X7W7tCVR6RY5taaAIiE57NyXDs9vLaBlzlski8
B1+wR2faAbioJWIOqwQG1tSDTdHXPrXip9xkrjdqxEp3ZULetaBC4iyTm9KmVnZe
06RN2eLB9zw9LxbmboJiPfLOBpyTGFJ0aZlMaMkQL9tloNDkSprB8GckwIA4yif8
JgLfC8UX8OWIBiBeQ0EuKkbP5E6wI0iDg+BMcnEhUt+y6nUbO4dP1EZcWR7FuUVc
slfrCLbqjNTbfsY44HEG8Gi31Y4pIQ1wTfvhW5DrxRiobH3zr/zQdaOYW7942tVJ
Haw2ljoaRmXxu6rVSsnkOsUZIFce/Tyj0IyB5iR3nNITzB72e8dYDj19yPI5sFEs
2lZo5mDlqpKQ8DqdDoUOHSdCIlEw7bEv10OMvMi1e8myDHDhXobilx3ZtpMEgOje
LhkBbSss1MQRdgJ4Uz46G5DdJzo7DGfE267L5b/spi0JBiAAZOJWZCFJitTQmRB3
AGjBRRf9ukvmVx01mfxO0LrTlyt5ZQQw9XdubwpjsVg41WIEdz8=
=Ir80
-----END PGP SIGNATURE-----

--eNaICd2lN+1PNicZ--
