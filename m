Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230175FF82A
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 05:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJODXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 23:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiJODXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 23:23:08 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCFC1A805;
        Fri, 14 Oct 2022 20:23:06 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso8928430pjq.1;
        Fri, 14 Oct 2022 20:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d0WSZd7zeL76VFqOY0WlXDd/+w2TRxIJDZEoQKNPTU0=;
        b=UfkGyKEj1ITEu95IBDJDNnF/JMyEShMCmonQrlep5gtAKXp6GJ9FHElkZWaY5sYxRb
         tAtrezKsm7pjGIhdK4YN4NTQb25MNa0/Ov+Gt8+iWSWn0RYTiEEyjr16JcVitRkZlTtx
         cIO9AmpvGx6KPm4nbwYUInVvhAAGtygOJuFGKIebv5B4sKT8b2nuRsMJLXcWX23VeBno
         4RQ6gh3vyDG5gUt4x3xEGb3BzMJOiPOOVU/LVbkwIjJKkQ5grNAeG/xfdIo/LnGif8CK
         ZgcjrytQu8sVFSnW3OZ1dU11pU0mfuGPCGdnzt2LlNKXUlNshuzSPkKsZbdGQVdEvYt3
         ZqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0WSZd7zeL76VFqOY0WlXDd/+w2TRxIJDZEoQKNPTU0=;
        b=evzk4nQXHiuzIpJcCifjwLGm+xTvGBxkO5nRKsMlbyn+ttEZGdU6SWceN7YJHzDNae
         Ljwi289RLqyZUL22XuQL/TjOzQTiPreBQVBgp3oLUx8Eg/fwaVERJPujx2jsb+jeNBQX
         0TL2axdc4oejXIIcqaohKuZvYnnD07eUIhYibksj9WTeXRz6hub6Bg/1PNLLHbxiEOWk
         45ocdnbZdKahdDGNQdyfJMrG7ir71JCRimXIkUIin2yjsFgWqB6ZXBg2x7jRnB20Z+fW
         itdtbsx9NnTXeQEMeIyChe4k0P+UtWDnWRT5mc3DS1jFwFjQ6DQx7Zf9HQvVQvHOpicb
         4kqg==
X-Gm-Message-State: ACrzQf2ZrkSAkiSZRs60wB3z+f/91IQVmBAue4K38wLxYfCe3n/KL63t
        eyjHPKMRBR4m0qouocqD3EQ=
X-Google-Smtp-Source: AMsMyM4/t5hglW4RGjUiGaXomz9fB/RdFhyjSIwdtm116Hn7laD1qh+L/gkxljHYAsqn2mfJye8fhA==
X-Received: by 2002:a17:90a:cc7:b0:200:3b3e:4e00 with SMTP id 7-20020a17090a0cc700b002003b3e4e00mr20510678pjt.201.1665804186482;
        Fri, 14 Oct 2022 20:23:06 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-28.three.co.id. [116.206.28.28])
        by smtp.gmail.com with ESMTPSA id a6-20020a170902710600b0016d773aae60sm2383333pll.19.2022.10.14.20.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 20:23:05 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7EF8B103A91; Sat, 15 Oct 2022 10:23:00 +0700 (WIB)
Date:   Sat, 15 Oct 2022 10:23:00 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/33] 5.15.74-rc2 review
Message-ID: <Y0onlAviu7tQBcel@debian.me>
References: <20221014082515.704103805@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zBVSDlXME+y2Rr1I"
Content-Disposition: inline
In-Reply-To: <20221014082515.704103805@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zBVSDlXME+y2Rr1I
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2022 at 10:26:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--zBVSDlXME+y2Rr1I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY0oniAAKCRD2uYlJVVFO
o6dzAQD70prL8CdPsjhwRJGoKD5fFVhpfIRwZQaRPxoUiqxPnwD+OHRUYqKUTqWi
4nABSQGTZF1e0ZCwf2F/logkstzhUwE=
=ONCy
-----END PGP SIGNATURE-----

--zBVSDlXME+y2Rr1I--
