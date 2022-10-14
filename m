Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320795FE9EA
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 09:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiJNH5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 03:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJNH5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 03:57:51 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADDB1B94F4;
        Fri, 14 Oct 2022 00:57:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d7-20020a17090a2a4700b0020d268b1f02so7202519pjg.1;
        Fri, 14 Oct 2022 00:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wLneJUpM1nhm+EaO9DlelTa6ysSFyvLK+KcF8aO6i4w=;
        b=ID9m6IJRnyqYwMKtDX/wIEOaf81cQEz1qL0vbQVUtkXE3mL1qagMAb2Tllm8mFm9/9
         WF1bNW1wPSS9x1YtKjSvy+xEY9jCIbEgJzG136bukHyDwR/lG9gw8I3JZpt95T23wvn+
         NBXqI0r2gbN95umPrp46cNMDKCNDfgT4PLqudEzSm07LzxH+ve2W9RQJ0qmzxkRgi+qa
         0KFGvCd+usLSQ9nRT+FSTawfEK+lwiqEEuKmlBN+6kujZ98dtTuAAgrrAiEUOEgIHBXB
         wznp08+nIp0q9e7W9iwrWOhWJrltMZqqtD92Mw0hXC1AEVhGxmUQ2DQaexEqSQWNqrBk
         oCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLneJUpM1nhm+EaO9DlelTa6ysSFyvLK+KcF8aO6i4w=;
        b=On3mbKcpM+h0IZ3uzp97XAad48Y9m4RUAWs08QHGQ04e+kZkfYMhML5qGI6ToXqBT2
         fqk+lafkycQCWQ+QI769p4hhsEO6skpAWpUdijUe3md124rOcdcXenuo8xaYYIxLK+uE
         v1p8KVpyFSWLDLmxh9LVGeTBIFsLPm3NH3EM09Z62wONt3ViZ6vRtvJLJZoqRwVlq30j
         D4gTpSvTYPf4dIsoqR7+k+GEMTcL1hmDu7Grq9XegnY/z9Z9zh127PiowhT6RcK8S6lB
         6w6qM87Hv0ShvQz0jZiziRiUta91PnC+nxMCMjDW8y5ehPuOcmbDsEf4LCkDTWVe59aO
         RqYA==
X-Gm-Message-State: ACrzQf13zlaajbXW8wxUlw8W3xGBiYlKFGsgcQsfkRWEgIUTrJ3pis2e
        Lj5R04iWQfh+2GM2YXmbmGc=
X-Google-Smtp-Source: AMsMyM5fze6JL2VxBBTRZPCPFqQZbyF01vHuypQtvDG+SmfolYWRFCkhswPbVWyR4tOE8Nh5LpIDMg==
X-Received: by 2002:a17:90b:4b4b:b0:20a:926f:3c2e with SMTP id mi11-20020a17090b4b4b00b0020a926f3c2emr4247039pjb.87.1665734269786;
        Fri, 14 Oct 2022 00:57:49 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-79.three.co.id. [180.214.232.79])
        by smtp.gmail.com with ESMTPSA id z11-20020a170903018b00b00172ea8ff334sm1111042plg.7.2022.10.14.00.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 00:57:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id D1708104023; Fri, 14 Oct 2022 14:57:46 +0700 (WIB)
Date:   Fri, 14 Oct 2022 14:57:46 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
Message-ID: <Y0kWett3COfWUycz@debian.me>
References: <20221013175146.507746257@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZezhoY3zInJdkVi0"
Content-Disposition: inline
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZezhoY3zInJdkVi0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13, 2022 at 07:52:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--ZezhoY3zInJdkVi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY0kWegAKCRD2uYlJVVFO
o0l6AQCScfsqW1jha7Cgd2J7S5gAbqXoz8Yapu0zLNBTXSzn+gD/WAr8zy9DbeTN
PUfY2UrRuHWTcAIGgP72JHSbW4z4KAE=
=o0lf
-----END PGP SIGNATURE-----

--ZezhoY3zInJdkVi0--
