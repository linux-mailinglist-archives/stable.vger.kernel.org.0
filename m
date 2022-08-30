Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3915A62F6
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 14:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiH3MNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 08:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiH3MNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 08:13:33 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7177155A4A;
        Tue, 30 Aug 2022 05:13:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id z3-20020a17090abd8300b001fd803e34f1so9120737pjr.1;
        Tue, 30 Aug 2022 05:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=d5FW/aTr1oAV0rKefcF9Fhqa6ci97Qr4hxAph5ajFrQ=;
        b=m0a0EOWiIyO8U1hNa7X8n7UmQ2oFRfn4/oteKtv0hFMsz36odNp5M8dyu+KdzvHF5Z
         qjqtm5JIcHONWpq/A+j8o6TwTv+Wt+g06sBAvHkPe3v20Up7WpERzhoUt6kL2ytUdPLJ
         w7c7rQBDNhRCItNLmoMrxNjlwjnAiWdW8x8+Rv55OmHQKp/ywMcbC7Pi6YuBvekk0tvo
         MYo2ve74S/t/Wt/UENxRpLNI2z+SeSUifVuIIN4iTZrm0Jd4OvsQ5EUNgcldNIbrXRgv
         rYacO5DNUV3Ita8+cpzkz0T6+Nuu0JKTMaOOqo+9L4kV2QzfxwW5p1XReQoRTZrHZ7SX
         mNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=d5FW/aTr1oAV0rKefcF9Fhqa6ci97Qr4hxAph5ajFrQ=;
        b=i10jjEf31fCo6OmOB8HW+IkYmOK89YfdOM19bWLbaWjpkQAxY8gqT2q67/0b8c3Z3L
         +2SVL3dXrJ6Zcjp5SJgK4Pts9H0h9BT5qV8EIDKN8kEKsf1cmCPDnAbSbBEEdWV2+GRX
         xk9+bFf3myzgSG5qq92HvaikOI9oDk7jZz5YZXLs5w2T7hqs5z6KlOzUzg7rXcqsthAl
         K88vRAxdk59RGIEXL4dv6C0Ccl7qBg0R2bDk4OBdKzksgLVP1Ixa9TGwIuFiYUdNwsCL
         OQ4sBAPOkTxG4bERI+dENmo/runVmLJmg7xtjBEI2bdAY+1jZFdPaWHyXXjs1i9P/N3R
         mfeA==
X-Gm-Message-State: ACgBeo0YEInmr21L4yLNpm4uN+ek9XgERuG9qesDmYZbjqNQgVS1UCZx
        PHRkwymP3NiqoxsBfFGUwK4=
X-Google-Smtp-Source: AA6agR4bAtdRX9G6Y6NbKHJ0/3hPX/7Jx4RzkERqcmLkcPC5egGCeffFReXPhM2aQRQ8cIOzHFNmYg==
X-Received: by 2002:a17:90a:ec05:b0:1fd:9368:2c8 with SMTP id l5-20020a17090aec0500b001fd936802c8mr15947935pjy.183.1661861608355;
        Tue, 30 Aug 2022 05:13:28 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-68.three.co.id. [180.214.233.68])
        by smtp.gmail.com with ESMTPSA id p22-20020a170902a41600b00172c8b5df10sm9493351plq.208.2022.08.30.05.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 05:13:27 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 1D10D103CCA; Tue, 30 Aug 2022 19:04:39 +0700 (WIB)
Date:   Tue, 30 Aug 2022 19:04:39 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Message-ID: <Yw3814fjiyWeLZD7@debian.me>
References: <20220829105808.828227973@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="K4O7naYT0neF4lNP"
Content-Disposition: inline
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--K4O7naYT0neF4lNP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 29, 2022 at 12:57:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.6 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20
--=20
An old man doll... just what I always wanted! - Clara

--K4O7naYT0neF4lNP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYw380wAKCRD2uYlJVVFO
oy41AP9dppT09Um7CAsZkcCU39jZajtFd9dPH2poYlhE7IccpAD/YyQUi8MtyXTc
Q716vHqxNEx3Im4k+WigvilVMpQDlQU=
=NkP2
-----END PGP SIGNATURE-----

--K4O7naYT0neF4lNP--
