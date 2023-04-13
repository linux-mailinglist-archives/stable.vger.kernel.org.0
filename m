Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AB06E03F1
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDMCDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDMCDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:03:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568925599;
        Wed, 12 Apr 2023 19:03:34 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id cm18-20020a17090afa1200b0024713adf69dso1134891pjb.3;
        Wed, 12 Apr 2023 19:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681351414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=txKXh4wrdWgZPXoWJyQNrYSeqmxrC6VLhn9OwDe5xzI=;
        b=c8XnjtGZdkmKrJPY85IPYQxCp/coLXG4/EPy3q8A8w6qGL+W/X5WlkSlxLcxNxFrg5
         XZtyZklnRfovwB1SgtBUiHCpKYdtVbNMMcFHv5ME6PtdwsRRBVaabUKc1f844PcFbMpq
         ncLgCfbkBXN5gdi991MCI6B7AH9GNB23xRCj1QR/+58iKP6fkEjIsBwAN2/9l6PxlKYc
         KDu1Y92ZRuI+/bJmfXFQc07+P6iGqIuC3P/4Lnrzp0raum5QCamKsogZxD2Lld61g43O
         SRV8rqYKx2+J0infozLmC+m0K/Hh2WMsR/oF0CmQqZP27HOD/MD0fLPAZWIr3s7ezClG
         mfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681351414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txKXh4wrdWgZPXoWJyQNrYSeqmxrC6VLhn9OwDe5xzI=;
        b=UdhPp19Gyqo7kv3tcRycLWIBWKnIj00+r5V1yAHbrTUOgPDvs/bvNurkJIZv+eYWyt
         T502WXfO9OE1SdLxWI1q7ayhCRnKzwqVqOQUfShlNkEBk5boa3du67Bgh7d6OkLnRoLp
         l5VXKPE+96XUGQKN35iAbSSsp2gS5bhqQWafJ3kXcq2Brl0W8JL613x/3+yHDCaS4vgT
         eNSeZzfsYiP6LKdWWbS+v8xsOmzV8Fusxq2REF3hsVMVOGKsC7VUsIzOvGSIiP5GcKNA
         dMWyUv4S4hYLU4lsG7MS31/VgSrjnkSzzhtWMtjpRkPZm/2GvRZF0csGf1Grju7WwzSr
         YVNg==
X-Gm-Message-State: AAQBX9f84HmxivKYGgOBaG7EaRxWl6OIafKRZeLWi/B6r++2YWmPog1m
        JK78Ma182TaHq9f1Us2Is2c=
X-Google-Smtp-Source: AKy350auSXqCVk+faIi1r+2x0Tjq68wARrPpXKccPY6IJ41zfANEUiTGSME/ILJ3z1Zs4abUNQ422w==
X-Received: by 2002:a17:903:2449:b0:1a2:c05b:151c with SMTP id l9-20020a170903244900b001a2c05b151cmr490202pls.34.1681351413734;
        Wed, 12 Apr 2023 19:03:33 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-2.three.co.id. [180.214.232.2])
        by smtp.gmail.com with ESMTPSA id je13-20020a170903264d00b001a1b808c1d8sm222317plb.245.2023.04.12.19.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 19:03:33 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 08E8E106823; Thu, 13 Apr 2023 09:03:24 +0700 (WIB)
Date:   Thu, 13 Apr 2023 09:03:24 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Message-ID: <ZDdi7JVDytc8nOi8@debian.me>
References: <20230412082836.695875037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7o9GAVR9jzCLmd38"
Content-Disposition: inline
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7o9GAVR9jzCLmd38
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 10:32:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--7o9GAVR9jzCLmd38
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZDdi5wAKCRD2uYlJVVFO
o2iqAP0WnutWnNBVz4DDXjKsMQ2GVRUSAFg8ckAdcmFuJnL/0QD+KOTIZrSE0FvW
B/RmZX8TnNXesrVJRxHdIGVEfpEC3w4=
=Q+aH
-----END PGP SIGNATURE-----

--7o9GAVR9jzCLmd38--
