Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3016B6C294F
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 05:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCUEvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 00:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCUEvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 00:51:19 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB0532512;
        Mon, 20 Mar 2023 21:51:18 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id le6so14830829plb.12;
        Mon, 20 Mar 2023 21:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679374278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AII7onvNh0XTKeparTJKT1aBkAQlRV5EfnYZkxUIGPI=;
        b=QoRHphEL8ZIwfgoYH/NGmU3kYdjTIO5xFzzu/YNEtRfE7M0mSwhy9UIZQeqz02M8oy
         1ViZyf3tOspGHBNELlcIKN1PlTE9Rg4wI34/EXumUC21vCkqG2QGg4TQcpL7HwtmURHY
         l87jTlVz8brLLQOTd9cFDFvBp2b/LXfWqYR0R8SQINTPDeSBeesT5FsuEKn/yBp0x/A0
         s3npnN+dwyygxwibr7e2t1mklBx+969P8HyqlBq0Xmw4J8ikfePObWN+XuRoxCWqvtwC
         ApMLmyGXMExQmLslXPeHllKV9VFthJAla3VS1l+DkQTSDekj/Q1wbsriNn7IZtDrt/1Y
         8r4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679374278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AII7onvNh0XTKeparTJKT1aBkAQlRV5EfnYZkxUIGPI=;
        b=lIISk5kROpjfJuDzSMbLftnGywfSDkfEfHjpp5qtI/BwUOSGA30ID68olm/LG5xGg6
         6Omi7NlvQ2Rda9r62pZqfKbdqVpePBQ+Vkc+1NhRV/ujTP2k0wVqEDRafzNZah8XIEHN
         gTzxByJVp9bxM4OtKdralLYlJACEuu5JzQyisux3aNWI1e3w5cZaZ074a/U8XFzkkQdN
         2QhLjMDT8xZitInoM1X8syjx5Q9aXEcYR/JoZSMh0ufpBrLlyQ3UL0pLoB5GdvC0E1YE
         cEmBFOiwgtxfrDQNrjgNuEmSR7uSkP7xjm2CCulg7NvN8azT6uknb9vOBh2csXfoaXYY
         alpA==
X-Gm-Message-State: AO0yUKUVoBfa3fBJUi1nAamXF0reW2hIG5gsGvGGNhgcdUYEWhUwcHmk
        hrMGn3MQXdtQWYvvHn6gyBU=
X-Google-Smtp-Source: AK7set9SuLai7Lg6fyJzhgDANa+f/KtBjfTcPdjnsx6UKECjqZ/rLR/F3yTENeBP5hru1Twt+1R9ew==
X-Received: by 2002:a17:903:124c:b0:1a0:65ae:df32 with SMTP id u12-20020a170903124c00b001a065aedf32mr1120468plh.37.1679374277737;
        Mon, 20 Mar 2023 21:51:17 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-8.three.co.id. [180.214.233.8])
        by smtp.gmail.com with ESMTPSA id y10-20020a1709029b8a00b0019a7bb18f98sm7601920plp.48.2023.03.20.21.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 21:51:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id A8485106617; Tue, 21 Mar 2023 11:51:14 +0700 (WIB)
Date:   Tue, 21 Mar 2023 11:51:14 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
Message-ID: <ZBk3wibPN5dSe7cG@debian.me>
References: <20230320145513.305686421@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oCLL87y0E6lcm2MM"
Content-Disposition: inline
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oCLL87y0E6lcm2MM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 03:52:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--oCLL87y0E6lcm2MM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBk3wgAKCRD2uYlJVVFO
o2lVAQCxBh7e94urOdOwu6CU4EuNbxNQKnVgCpIIOKMb1Q4YMwD9FVoWukVZYmCv
PNQl+oC3J7Xqqe5ZhcWOQa2eFZk6QQs=
=wkZA
-----END PGP SIGNATURE-----

--oCLL87y0E6lcm2MM--
