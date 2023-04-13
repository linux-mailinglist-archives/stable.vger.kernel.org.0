Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978416E05B5
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 06:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDMEH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 00:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDMEHY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 00:07:24 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AAC5B88;
        Wed, 12 Apr 2023 21:07:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id c10-20020a17090abf0a00b0023d1bbd9f9eso16933737pjs.0;
        Wed, 12 Apr 2023 21:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681358843; x=1683950843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PO+vdvsIJNOaWSleJ6Y04GDPWKMtg3yaaz87ocesbmM=;
        b=FDADdNbB8g5KFVSWjjoPntbHQk+UV8Hhw+3P3aGQbJWLqA3np5d+LEp2SI3ExlJvNC
         MIENsd01RUW3NVrtIHjIfARMjLywWUqTNk2+Yp0bh62eZn9edzUFC4kX9AmX0pyADJ/c
         NMEbV4zEVI0dq/dRJrbeCZIBtfr93VwWDq5vzA5Pu43ylhL+eMbgHEM60EzkGiOppogF
         UomSrOZs2MvJQV7aLdtAfa+V11anglEMn1EbkYKi/Copb5OxSEHId1hcIR1+c8na4Lnq
         8WAIzc/V9nRUhmadNjMlHD646noj7J14ztmC6M5ju1XWKg8rvvYFplhEz3oi7lU3qR7K
         uPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681358843; x=1683950843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PO+vdvsIJNOaWSleJ6Y04GDPWKMtg3yaaz87ocesbmM=;
        b=NFXX5gV0gTNQX6Nebet2O1FSrJ6vgI2p6OLnzJe1UM6Lp1zMcLyooyfZrHsqvH3rKn
         yQIN4MQfP4Wc1JZnRddwdjDTlb8OwDTqSl1mdOb2irZqESBvDUNHot6OXD71IPiEWHZn
         P+TWJgZR1qN9bRzkx542KbfP0B5L2fPyLv9nllTU1q0dGzXkwChYS7JljlnI+NNIUTz/
         EbZIxpFiNdkX3R5AmBJRixgHKI39CNsyz0Yn8CFeCZRX4JuLjF87Gi7aZJaey7TFvgPJ
         d4wZzYqiJBe9uVmzElQaKcFGkeJoUGtxf5HjunQANroxebgjV+MEttd/ypFJaHUHmBXz
         9KjQ==
X-Gm-Message-State: AAQBX9fzb3N7kyZlFy6/7NbZezo6aBPU+2cOYXiLWZw5D8Oe82o75wAl
        A675elzJQ7echH8DGokWNjU=
X-Google-Smtp-Source: AKy350a4BPiDFFLqA6Z2k5yhYxWCmS2S5JDKkXycfKyuzADWf1WaDNcmu/oS6W4w88/4uCRN5UWrOw==
X-Received: by 2002:a05:6a20:e94:b0:c2:b6cf:96db with SMTP id fk20-20020a056a200e9400b000c2b6cf96dbmr752512pzb.39.1681358843069;
        Wed, 12 Apr 2023 21:07:23 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-66.three.co.id. [180.214.233.66])
        by smtp.gmail.com with ESMTPSA id v6-20020aa78506000000b006227c3d5e29sm272859pfn.16.2023.04.12.21.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 21:07:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id D8D6D10681D; Thu, 13 Apr 2023 11:07:18 +0700 (WIB)
Date:   Thu, 13 Apr 2023 11:07:18 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Message-ID: <ZDd/9j+H8C1rBo87@debian.me>
References: <20230412082838.125271466@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yRolHaZ1TJc5Bwrm"
Content-Disposition: inline
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yRolHaZ1TJc5Bwrm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 10:32:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--yRolHaZ1TJc5Bwrm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZDd/8gAKCRD2uYlJVVFO
o6GBAQCcDE8+tD7AojGenlulHtVV7sbZE7pU6bf7sNjRuirv5QD/fw6Ma87ZMybJ
tF3p305nGASkudNazE4iPxsdL5cR2QY=
=OkXz
-----END PGP SIGNATURE-----

--yRolHaZ1TJc5Bwrm--
