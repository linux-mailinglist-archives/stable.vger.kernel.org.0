Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425186B5825
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 05:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjCKENJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 23:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCKENH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 23:13:07 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CC02D6C;
        Fri, 10 Mar 2023 20:12:57 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v11so7681290plz.8;
        Fri, 10 Mar 2023 20:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678507977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vLTThIkYcoCngH56pYkNsVkm23MjZJswdqWOSvqOZqw=;
        b=qAeuVIiCbuIpx5nHJ0kTuIriVwPVSi6qkQSiVZkG4jIJn/EMXD10NIoaczL228Gl2f
         dVBjYXSlekcXPcFnGSeT8Yl05u6cT783WDt/RCIFPnwv8O/9NkWIBMDAaZka+kke0i3x
         YuQch68NfL2BqZMPaCRs8guJ8+l2n+UVEcqYJkLFZTAMZBa0Xc5bChskBw8EjdyqjNRJ
         2M8+lUeTmgHvl+vX4PcK1JgrJDbTFwb2UKNNIXZ+PdwcnsB5gYtcRwzord4Vm/GY1/ia
         ucp/EkRauu3G3GpOmSaw/FcbyDaMcflK9QDwk2ijcsTvCFqiKiLVeiCtTXgr/SVfxJm8
         QlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678507977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLTThIkYcoCngH56pYkNsVkm23MjZJswdqWOSvqOZqw=;
        b=yeAVWHyKkD/hCIT3SYyYeYYSxKoXu02D7qKhnd7hkS8OIZAPp9A5FELRXpXeaMWdIw
         nWF3ql3ZTLHtNWLUzUpHR2ly6WCIZVJiXSrN35XSVxDLkhFOi18icHELkSPfjnlPHMgI
         iZWVF4MZNI224nvaqM9mozDed8APNyXgY8k00CxJq1yL67FGKD47VjyddrWfYzJm0/v3
         qZxiwBnH3rP28HFhEfTE+LV8oB7JgPy+SFuDylwKMytpU9lGWJIZ+r1IX4T1KT4tPiW9
         HfP/Fe2umQaicCsJHlhoY/9jfQWgXWixFabl5wHZARZxmhfMXIc7b5hC8OJaSOw1F0rf
         V2/g==
X-Gm-Message-State: AO0yUKVxQsgxueiUzZXLinD1v3Kad6dV9aevdmodUTvTR28w0U1vGFzg
        9zBNYPYtMRDTJKkMEEb/llc=
X-Google-Smtp-Source: AK7set/TcWYDhnSmSlBMjMQk8GLLDzeoMqHWQleedhh7GVW9nOLjhWBW1itL6T4yBuVSpdBgIFJsQA==
X-Received: by 2002:a17:90b:4f8e:b0:237:f925:f46 with SMTP id qe14-20020a17090b4f8e00b00237f9250f46mr28348790pjb.24.1678507977382;
        Fri, 10 Mar 2023 20:12:57 -0800 (PST)
Received: from debian.me (subs28-116-206-12-51.three.co.id. [116.206.12.51])
        by smtp.gmail.com with ESMTPSA id bv17-20020a17090af19100b002342ccc8280sm693609pjb.6.2023.03.10.20.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 20:12:56 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 041E5106670; Sat, 11 Mar 2023 11:12:53 +0700 (WIB)
Date:   Sat, 11 Mar 2023 11:12:53 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/136] 5.15.100-rc1 review
Message-ID: <ZAv/xZGpPjUjC6XT@debian.me>
References: <20230310133706.811226272@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8fumRTGUtjhB1icP"
Content-Disposition: inline
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8fumRTGUtjhB1icP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 02:42:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.100 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--8fumRTGUtjhB1icP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAv/vAAKCRD2uYlJVVFO
o6qCAP4yciaKajRkIqbm7u/IljbNNsaY2VU2t8xmetbpeD9WVAEAglkaI79rveqq
rMEB46DIkdjqPTbdbZa6QkRcw8a53AE=
=ccXS
-----END PGP SIGNATURE-----

--8fumRTGUtjhB1icP--
