Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B468B5F3D38
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 09:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiJDH1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 03:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJDH1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 03:27:52 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8F93ED73;
        Tue,  4 Oct 2022 00:27:51 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 3so12021532pga.1;
        Tue, 04 Oct 2022 00:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YjdpnRuPLxv9NsvHD3laOJY4GSCrKx/CQqLFkB7R8UU=;
        b=H2jcPOVmsVXmwfFfOBt45yxNJ9dwC1qR2jWgCSdBW9RRNHTrBxRam6FQuZDDYCe/DR
         Q952zf2R7N3FaireTB89cpfCvzoCNCevhg0jpm4A72whI70aFZyOa4rLHKXcfaapI3to
         G6cA6yHkeQi6LaQkJK/2+8T+udb3r4jAm/+T4S7DW1H9R6zG6rww+6GStQHpwaVB5oIf
         UKMj6qBSaZH6NamRJVhRjhFQFmvTNkki0V1VK784sp4phrMi9XDcpJt5RW+kf6RmlI+g
         HnTAbPAMoP/AnsKzKKKBEQA9FH6rJtUwXm7R+PAk9jYSFVZqGI8Lkd7n8U8cChilhdWN
         OCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjdpnRuPLxv9NsvHD3laOJY4GSCrKx/CQqLFkB7R8UU=;
        b=KP/6wR3xkj5/KOKTWtHM2NjyZ4gpALbc2Ml7JgIEsjbqF2B8eLszBRYhmn0RgnsBiN
         qyNhe9KMlyRollJ7fPgAfI6PjnxdwRCsW1daS3BM8E8k6uWMC+z4fIy88WVk6FIgY5s+
         hQwNHHhmYMsmdXRyVhAiqRMJ5ChBsLGTKYhw36vbmckvkp7YNU04SF9HVwLWM2FGiCm4
         rgFeY6hdqev8mzsb7cRdDoDzo5FmXvTHi27rja4rZzp/GG249ufxf5vwQ7f2hKN3dCdX
         xA7TwOjTxf0Opwg6yff9csE3WqAxO452576/Nc9QYdjdT2kD9opS4VUn5eZBkPbonEJ5
         Ak4w==
X-Gm-Message-State: ACrzQf0xE1L8n28pqtEOnw8q8GPlkDAedWUxJbSnX2VVzornrQ7CYDZE
        0SWxnElJcDJow7VErL1V3RU=
X-Google-Smtp-Source: AMsMyM7W+p7yj58+vw5ZdoP+BIyyqlEjykt7kqxKa6BDLd+9osuHWRMXZqtCdBVFwM/YW5bO1ilj2g==
X-Received: by 2002:a63:d314:0:b0:452:598a:cc5a with SMTP id b20-20020a63d314000000b00452598acc5amr5006109pgg.299.1664868470803;
        Tue, 04 Oct 2022 00:27:50 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-2.three.co.id. [180.214.232.2])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090a804500b00205e1f77472sm7480691pjw.28.2022.10.04.00.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 00:27:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 9D00F1039C3; Tue,  4 Oct 2022 14:27:44 +0700 (WIB)
Date:   Tue, 4 Oct 2022 14:27:44 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 000/101] 5.19.13-rc1 review
Message-ID: <YzvgcCZpoFREUi7k@debian.me>
References: <20221003070724.490989164@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IyeRsl+fVmnMgmMX"
Content-Disposition: inline
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IyeRsl+fVmnMgmMX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 03, 2022 at 09:09:56AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.13 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--IyeRsl+fVmnMgmMX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYzvgagAKCRD2uYlJVVFO
o0eDAPoCBwDtywh9NtOpvR8lrZpMFGHWR8ISHM74MmqW4FUd4QD9E8U2uNzaWgu+
EyUmAGc80k0KJWlXos7511SJjGRa0gY=
=Y++3
-----END PGP SIGNATURE-----

--IyeRsl+fVmnMgmMX--
