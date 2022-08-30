Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEF25A5A92
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 06:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiH3EPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 00:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiH3EPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 00:15:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D375FD9;
        Mon, 29 Aug 2022 21:14:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so6249963pjq.3;
        Mon, 29 Aug 2022 21:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=mEDeep3eaBiDjR2GVynIS1tU5uA7irV+7CKnosukC40=;
        b=pYLJVVLoh6vi47e47N/1kLMdIpzEiAZ6T+GwbM82+8mmIUAAibFEPqaVPIDVaROLXP
         dWnEf5eGxbQih/Eb+u8u8tw599Wy9r++dtxUwg4xdt4ftt6MRpXE5QIp6noZhwIbwihK
         o+KsO+AWWDO/K3C8ojL0gKm4GPqXqYUsR8oiaXkRyD/yylX4QkzvzyUg6mON2Jz1BjMY
         PKNBToIyYgBUsVy2I8SBegB63HKDj2UH9NfLcg4mhPiiOwoKmxKzL9AWWmoP2DydhvHo
         iw7lqbfaxzLHCwP2hNBVoPJAaAEQLRBX+6YKU+VX3j9ORsl7uajR6VADDCDNLkUEmPro
         gU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=mEDeep3eaBiDjR2GVynIS1tU5uA7irV+7CKnosukC40=;
        b=jz+07IpAn8TQVossk9wTaTn9AxD6sgUPex0FFw5H06gev3PkqVhJRZPstMMLfbxCKf
         bsxrbpbcbYbmo2C7sZkO/N1COxOBx1KpI83Luu0LysAZfyG2IUWl3oQvG1MSHspUqU3D
         JP9X7UYdSK6NRzM0CckStym4Q4SfGYKalF+wxgLmRsiZrxtW6tFiQ6ec3nc05GzCn0zZ
         w3svIujF6WCbh6Gspgfv6hPtIHYjt9pZeI7SQ/mO+kf3Rgunz88CvDfK7RXPkXy/Hozs
         Fxtz74rtmWklBXKo5cy1SCv7Fl3iunfrVBvdUmWVhrUJocAGWzp2R+WGAYjA/znkKxlv
         /zrg==
X-Gm-Message-State: ACgBeo3Hc+l78ysRKz0qJwrPEKA4WjBBjUPLkDGFFX3fycNwQfb5rHZA
        rUF12xGi8awazhYtMh6VAKoslA0CKfgZTA==
X-Google-Smtp-Source: AA6agR782NlN3iXtZU4KjlROQ7axfqcfCTlOzkMyTnm4MhFzuMRnJrYulhOYLNk0ejizvQ6fxP32aQ==
X-Received: by 2002:a17:902:904b:b0:170:a3e6:9d98 with SMTP id w11-20020a170902904b00b00170a3e69d98mr19297445plz.50.1661832898727;
        Mon, 29 Aug 2022 21:14:58 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-22.three.co.id. [180.214.233.22])
        by smtp.gmail.com with ESMTPSA id l15-20020a170903120f00b00174a8d357b7sm4253373plh.20.2022.08.29.21.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 21:14:58 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 85EEC108176; Tue, 30 Aug 2022 11:14:54 +0700 (WIB)
Date:   Tue, 30 Aug 2022 11:14:54 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
Message-ID: <Yw2Ovjv2BcHCayWD@debian.me>
References: <20220829105804.609007228@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aSqdN414gnjNK7Gm"
Content-Disposition: inline
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aSqdN414gnjNK7Gm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 29, 2022 at 12:57:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.64 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--aSqdN414gnjNK7Gm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYw2OuQAKCRD2uYlJVVFO
o3wGAQC69Cj2yAWMLhqi4QdML0F6rGgRvVvoS8vD4lO6TczEXQEAjPrHzdW7kFTK
2tf6t/Z2nKriKZCWcBBAM9ug59sM2A8=
=E+vZ
-----END PGP SIGNATURE-----

--aSqdN414gnjNK7Gm--
