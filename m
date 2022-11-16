Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A9962B1FD
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 05:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiKPEAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 23:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKPEAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 23:00:11 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99891CB1F;
        Tue, 15 Nov 2022 20:00:10 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id b185so16272889pfb.9;
        Tue, 15 Nov 2022 20:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=636+W0eI2tQLj88G1y9xJ1MUm1p0RSuNiUGbqqjBohQ=;
        b=KE7leJ0Uz3prbgKSTiG9YV1cKCjWZ8VBEovgWpDZYu/wZabtoAozr8v4iSB2+zv898
         6/RX6eRPPnc6f4xZCiRGUNsKVw5h2xYUgazIxgs7Xl9pibdOAAVKWEOHvNBlhO+mUQlu
         pCp3vxbDMBmGtEpQWnoVC9qcEczoifuuErcBnUsXhJaC+HArgazRmT1VfFn+iSFMjfPL
         DN4dlQKL3AojOaOxh0S5Gc2sQG7/MBQsaidc8Nl8k8FXiMcROz+6E+e9RONDOO5E1LIh
         y8J+xlam/orU+iaIplIedgyEQWvkOBgYd5lq8+f1jFphLw1Zpip8cnLj+Jk8GkOgQzw3
         01kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=636+W0eI2tQLj88G1y9xJ1MUm1p0RSuNiUGbqqjBohQ=;
        b=7FM0/Ntc0P5Pm6qnzUtNTqXzbfUPmh9jD0bAV0f0gkIFHv/696bHBxi9a+gFMo/wkc
         VBo/gILRDlcI949m5iVzpS7E/wbgqi2PG7rYrfclVMYuVlPNzeCDHi0TMhk2mcSyK0nh
         FP22JgLRxN5SYNg1qdpfEuL8njS+EXH3GWZgMJfwrNgfPU+tuB/IjCWBQsWMHpdqWbL1
         uCaxgqugPSLWoN5bRfeYzsqJ/ffTTQHdgOJeRmCV60sqZNlBdrimfDWw2JofsHhs7e4F
         i3ZNgw1DZlfP81bH+wF4sANQmaSpsQ5yjvs0Pe1xskqU+9oi094q0FQfZUFZ0y8ykRMc
         I/eg==
X-Gm-Message-State: ANoB5pkeIOG8q3hUfnTIvhf5fwMxhAme/M2onyCsVlbEYOBbYFz59yP6
        VlHIHqf7DheG0uVAqz7hdz8=
X-Google-Smtp-Source: AA0mqf5NgfbsNJwE2wpIqhUmA3w1BsOVZLvpn8CGkutsjZG1eAKyT7LmzNFKNAIkqD6oizXgWyZnyg==
X-Received: by 2002:a05:6a00:4211:b0:56b:6936:ddfb with SMTP id cd17-20020a056a00421100b0056b6936ddfbmr21554023pfb.15.1668571210288;
        Tue, 15 Nov 2022 20:00:10 -0800 (PST)
Received: from debian.me (subs03-180-214-233-88.three.co.id. [180.214.233.88])
        by smtp.gmail.com with ESMTPSA id s5-20020a170903200500b00179c9219195sm10735808pla.16.2022.11.15.20.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 20:00:09 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 1BF0B10417B; Wed, 16 Nov 2022 11:00:05 +0700 (WIB)
Date:   Wed, 16 Nov 2022 11:00:05 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
Message-ID: <Y3RgRQtpdRcYkmyv@debian.me>
References: <20221115140300.534663914@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M9cFiUmnwINFl6Jo"
Content-Disposition: inline
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--M9cFiUmnwINFl6Jo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2022 at 03:04:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20
--=20
An old man doll... just what I always wanted! - Clara

--M9cFiUmnwINFl6Jo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY3RgPAAKCRD2uYlJVVFO
o/rVAQD7zavBgudoB1bmapSnYKeH2LX9yLVqpVO2gJ20+sa0HQD7BpZr2n0mRtIu
+xsAUVEzbFPC/ok18Mc+KZDY6pjW7gU=
=tAps
-----END PGP SIGNATURE-----

--M9cFiUmnwINFl6Jo--
