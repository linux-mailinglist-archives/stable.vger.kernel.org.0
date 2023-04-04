Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04566D575B
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 05:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjDDD5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 23:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDD5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 23:57:51 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D91170D;
        Mon,  3 Apr 2023 20:57:50 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o11so30124516ple.1;
        Mon, 03 Apr 2023 20:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680580670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X83KCjdEK4T1hTeVfZLCAmpcMx+WY5WGo1yjmpuoFY0=;
        b=oq3XFCwGZiXf34KBortg9bkf70ZMlaDht0ktfRbBRS7y0qjhlChdfbhkO9hd0zbS0r
         zNeoDd5Z9dbGGUndflQDKNsvuy6GO4sApUa5PcOFu785whnRHzDX4y2ECwLY7MUqo9Od
         SGDMcJu9IfBHmyrCCbkEajT67JHRKuuQMu3bLM5HVxHXZ2jKkgfAn8OvDblBkRr1SE+E
         P1ihcE03PtUmOw2g/RAc0Lzm7tttFYbNMa2x9RhgiojB41KPFfdD2moXblejwcaR4MK4
         VeTG6PlWbZHRDnHdnTvfahag1UAzasfmxd68DxdBajUiVHE6lwKUW/MMjEWpuZioJeg0
         j1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680580670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X83KCjdEK4T1hTeVfZLCAmpcMx+WY5WGo1yjmpuoFY0=;
        b=S9GDePtq+uj74/K6UzRrSdVoBCMVYrbYYAwavhdU8toxcfT9H2VMWEj8PKlqC/RKUL
         Kuj/Pd30inrMIJpRdOBeKWwRyD1la9Fkx2Fmsdvog1qzVWy7Ox/EB4Jeg6yK9qGe1+3/
         pxY9I8ZKxdo9V59DgTQX9JosssYMlsLD6BR56LBGGIIS5yMs+Ua+/lzw1pv/ezdars50
         4kL17TF4kLeLOZQfRREgLLDpuHNHyCmXcf3dZPecRtBDJ+yFOEW4GzB8Up2KAHB7sWLD
         ReyH+mzIDNV/Q1ZQBZhzkVTvn2N0izLVD/lAfaLhEIETp1yLCHF9wvMULSQy4U4p+oym
         0o9A==
X-Gm-Message-State: AAQBX9eGZUXXY/sIwCF/mDGdzF1gPrTEE/63bL91QFrQ9XS+ak9o28cK
        eufXiw9chtX+e0K8mJh5qow=
X-Google-Smtp-Source: AKy350aA0gIOmG7NVFgGWhbVMzrwLDGJv2GOkUP/HnQ0c/JDE6vsHoRKeJF8b9596TgF/7xSOCYJJQ==
X-Received: by 2002:a17:90b:4a50:b0:239:ea16:5b13 with SMTP id lb16-20020a17090b4a5000b00239ea165b13mr1371109pjb.14.1680580670314;
        Mon, 03 Apr 2023 20:57:50 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-87.three.co.id. [180.214.233.87])
        by smtp.gmail.com with ESMTPSA id kr15-20020a170903080f00b001a1ca6dc38csm7308518plb.118.2023.04.03.20.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 20:57:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id A43A7106782; Tue,  4 Apr 2023 10:57:46 +0700 (WIB)
Date:   Tue, 4 Apr 2023 10:57:46 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Message-ID: <ZCugOvsPTEg9A0nO@debian.me>
References: <20230403140416.015323160@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5SJdshfoX489i1R0"
Content-Disposition: inline
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5SJdshfoX489i1R0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 04:07:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--5SJdshfoX489i1R0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCugNQAKCRD2uYlJVVFO
oxJXAQClKhOw1JlBz0nW4dpboPW5D5LZD5B0B5gkzM7vLQOEtgD/S6Y7Zdqp/PVq
qqML2XTrdIrdrjKeQa2IpHEeFyrFzgc=
=7dUL
-----END PGP SIGNATURE-----

--5SJdshfoX489i1R0--
