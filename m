Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D200157EB2C
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 04:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiGWCCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 22:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiGWCCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 22:02:50 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3169893686;
        Fri, 22 Jul 2022 19:02:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q41-20020a17090a1b2c00b001f2043c727aso5593699pjq.1;
        Fri, 22 Jul 2022 19:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ek1SzPkAXS42Q3/IOFn5jB3zoKWDZtzhhUuRvVoEm30=;
        b=Gd+mk2zFqv5iyshofxPowfW57ze/ypL272p/04zo4zRoWqd5+pYNRkYXRGvUwR1Aps
         4ak+P8rvaAF5VW8wKxYCwoGq0pk7fAnyWp1zNEltd1oGLc0ghra4tLEx7Qen9GoQvzGz
         f5NAWW2t15RScKZEbExVYZTgWa+Lb+esZFk8A0liRmncuHMtnN6bt0AO9HDPNELI/zWU
         pur+TqxsZS0Uiq0NhQW//5TbRade9H+vyG2riLaz0hVzM6m+mt1iK0wbhF646uQKNn8D
         L0j8F1+MK2s3JNWmQ3A+LA0L5PPYNllwnz/dCLIShMOethCXv4oXtgJ3iqgAZPexCWQD
         klww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ek1SzPkAXS42Q3/IOFn5jB3zoKWDZtzhhUuRvVoEm30=;
        b=Wa5oZZ4+gxHHRPAH78/8uZf1Yav+diP4dRSJP0C7J1y3h8K9tGNxuxNRcvNvuUaDSx
         ggzTec/oTUKuH47w3Q74g2Bod55cTgilc/r1iGSGqDHFSUGMyCnN7WaoUwthBFvLFIp8
         tft+SGl3DTh8/tPwPem/72qTFhfyjl65JVNJSrQHI6E7iYtlT9fq5ybzwfIWNZzXOOEK
         P0vJ+QxgfNO7WGMnSg2zX2hccyVhfSoGvkc1SzI0XKuaUOSitLWbeEN22tHlIp+FFQc0
         8t7HzJK43R5EDF7Vq/ZEzmbzt5gy0xBLMqNkc2Kk1/MYOlpibonTmxqzAEW+f8chF3Aw
         NKhA==
X-Gm-Message-State: AJIora8T2/OsM9ft21oNIJWaFLwYJbVoJrhg28DoUEJLgRIjgr0jwrqd
        bJV0gTisGbAfBMwetOuFolE=
X-Google-Smtp-Source: AGRyM1uderMRoC/wD4wwPZ5KskePnbaIuldIaxrQa4fcRbY+N38PrtddF3hqjlkIJCHaApuPyppE7g==
X-Received: by 2002:a17:90a:4402:b0:1f2:3507:5f96 with SMTP id s2-20020a17090a440200b001f235075f96mr2611599pjg.22.1658541767473;
        Fri, 22 Jul 2022 19:02:47 -0700 (PDT)
Received: from debian.me (subs09a-223-255-225-70.three.co.id. [223.255.225.70])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79574000000b0052ac5e304d0sm4674355pfq.179.2022.07.22.19.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 19:02:47 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 774E91048EE; Sat, 23 Jul 2022 09:02:43 +0700 (WIB)
Date:   Sat, 23 Jul 2022 09:02:42 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/70] 5.18.14-rc1 review
Message-ID: <YttWwtesMEUs3BOZ@debian.me>
References: <20220722090650.665513668@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 22, 2022 at 11:06:55AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.14 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
