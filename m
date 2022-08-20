Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF49159AD43
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 12:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243781AbiHTKdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 06:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiHTKdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 06:33:17 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4FAE02;
        Sat, 20 Aug 2022 03:33:12 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-32a09b909f6so180397357b3.0;
        Sat, 20 Aug 2022 03:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ve0n1w3kzyJAGJEiL8GecuTvIN08M6/zNuRXzJI9upw=;
        b=ZHrNFumtSorlNh9Z21cJJT2OKOmUZd45341FIAy6XJyE0muPlUJKeKEpDdcnJ0T07b
         b1skxz+pDZrXvkjnYlHlGTye9JskB6RiHhFndxZu0wqX+V3My/bBma/GxWrGu+24YoV6
         qKeM8xse0hEAzcZmcNR5mAKp+GxzB4Z6wloLKpiPcGhD5DlGCNl8vdjgeYpQxBL7v9j0
         MXZso8d+cjlijbqJw4ARlNqz2R+dW30y7AVcVZUmei1C+4sOe2+mvwXgQ6HjzWS8NMYT
         TJ7nYEpcOZFvODagwWoq7hNUOKCG6iNhLDG1DEMLfHRtDfFe5+ejC9pIiEUgAm8nY0Jz
         6Beg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ve0n1w3kzyJAGJEiL8GecuTvIN08M6/zNuRXzJI9upw=;
        b=F6YYCj3Ny/UZD54du99uK/rHANvfdkmTPLphKcx9tYMd1RoRQQ75GzDXZewwJSUNU9
         YA/PRDKr0vFQ+nadCtSMoYtf4ijpGauDRchdpJfUVgz7x2ftCyNvAGXYbY94Y/2m9PaG
         71Z7Ekc5nR+ulCzsNhK1jcQwmwxTPdDyZ2YM9W3tAaTdy6q/fvbw6M6fwriU12WfpSsc
         AhxZzfCEbmtf29zwMj7CCIqC/x9SmJPe17i7sgCmMUT1VcRvAoBmsP56Y5rB3eB3YefU
         1KtwWZxSm1p0Kocb3K3Z8c+uIyHrHqQMmiV8bwdfzigsEKmasSjbArQ6rRZQv6Uuhebl
         Xymg==
X-Gm-Message-State: ACgBeo2eCvO0PHxiJDfnMfjqXxSsPrsCYFCjrrx6HM/pAz4/jMEZkcFA
        S13MFbST5gsv/4SEkdcvaaaBLAUzruEBPjDThz8=
X-Google-Smtp-Source: AA6agR63TCpu+LjMQcifnIYNA7SWk4NKGNGJSQ652+hfUcdI11uMlZmavk2P6hkAFKNHmwhkZ5admhi2BDMjmvwLF6k=
X-Received: by 2002:a0d:f543:0:b0:336:4863:3923 with SMTP id
 e64-20020a0df543000000b0033648633923mr11408995ywf.361.1660991592115; Sat, 20
 Aug 2022 03:33:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153710.430046927@linuxfoundation.org> <YwCxc5gwpmGRBUL1@debian>
In-Reply-To: <YwCxc5gwpmGRBUL1@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sat, 20 Aug 2022 11:32:36 +0100
Message-ID: <CADVatmM_xDmAORG8J0KgrCOwmEyVKd7kc8VGQRHPaLZzifivhg@mail.gmail.com>
Subject: Re: [PATCH 5.18 0/6] 5.18.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 20, 2022 at 11:03 AM Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Fri, Aug 19, 2022 at 05:40:12PM +0200, Greg Kroah-Hartman wrote:
> > -------------------
> > NOTE, this is the LAST 5.18.y stable release.  This tree will be
> > end-of-life after this one.  Please move to 5.19.y at this point in time
> > or let us know why that is not possible.
> > -------------------
> >
> > This is the start of the stable review cycle for the 5.18.19 release.
> > There are 6 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> > Anything received after that time might be too late.
>

<snip>

>
> powerpc failure is not seen in mainline. Same error as csky and mips.
>
> In function 'memcmp',
>     inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:302:9,
>     inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2002:15:
> ./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>    44 | #define __underlying_memcmp     __builtin_memcmp
>       |                                 ^
> ./include/linux/fortify-string.h:404:16: note: in expansion of macro '__underlying_memcmp'
>   404 |         return __underlying_memcmp(p, q, size);
>       |                ^~~~~~~~~~~~~~~~~~~
> In function 'memcmp',
>     inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:302:9,
>     inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2003:15:
> ./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>    44 | #define __underlying_memcmp     __builtin_memcmp
>       |                                 ^
> ./include/linux/fortify-string.h:404:16: note: in expansion of macro '__underlying_memcmp'
>   404 |         return __underlying_memcmp(p, q, size);
>       |                ^~~~~~~~~~~~~~~~~~~
>
> I am bisecting now to find out what caused it.

Introduced in v5.18.18 due to 11e008e59970 ("Bluetooth: L2CAP: Fix
l2cap_global_chan_by_psm regression").
But v5.19.y and mainline does not show the build failure as they also
have 41b7a347bf14 ("powerpc: Book3S 64-bit outline-only KASAN
support").


-- 
Regards
Sudip
