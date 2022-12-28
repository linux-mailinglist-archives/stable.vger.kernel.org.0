Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDD06586CD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 21:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiL1Um5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 15:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiL1Umx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 15:42:53 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4A0A455
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 12:42:52 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id m4so17057681pls.4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 12:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vMsaXK9Beaf56plb9rYlZa5RR76GtIlbV0IfKq/Pvrg=;
        b=tikSzuwx222LNN9UwQqm6TaLNsTzJ/hxxiUqQHkf37vFAp8iiMXLmQuirC9lh+z6KI
         L8b6QgRaN0N/IHSmAlMedkiyrSjYOwxYaqXH0PW2ibuk+Wi2hP1Es4K/qWRzVKtyqCMX
         AqgI4v6PWQk17OM8Z/0vpHO0mx5wVD2Zm8Kb01VFQpv6SuyeHTw/gkmAwJVp3jBgwbEI
         M7eim09dhJmVEdbcbTKSSUvzq4M0LZQzJ4P86XJWshIiv6Rq0+MmTz0Nq+/1re6s6Cc+
         v4Srm2Aa8puDlWZQhS49/AXGNZW1HzYhuud0IHMwFvD9/KMj6Q7Te6rcd17NveQRKDO9
         T8Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vMsaXK9Beaf56plb9rYlZa5RR76GtIlbV0IfKq/Pvrg=;
        b=DtTwCXPk0i1HweWoLOFaReQ2e4fBveyzTDX4fIT/dOKCv5MOi5Qp+czqBE3oy5KZZf
         Xr/wp2byBWdlw0CJvTvlonXCBlwcC1fFe3bLQXS/T5VwL6Qy2fAEn6p/KtMVKpn1pbM0
         rU/k1Z0HSLVS3/16k0/Lnm8rr6j38tUCP90X0brOIKKZ2msaapeItWX2r5CxT4biYJEY
         iJOi89dXLgzHPT0Nodi/3GMuUr4dvQdc6l9n6gjCsYJipzFHauvf7ZiMgPp0epyQ8JGf
         tolRNQlv7JXCovBQD21otUvT9J4FseMp7sqHhcHFwkpoJPpJ4rLDvKXfEYX82nKNLhrj
         lC2A==
X-Gm-Message-State: AFqh2kqqi1L6WM9riczSRawHFMkx9tjNn/P7QsMP8qIAwqd1+dd4oOca
        DYh0wGCoj/xRhL3ZhWtHg8MEt3midZMB75upjW8FFQ==
X-Google-Smtp-Source: AMrXdXtOKe9vay3WmDDbJM/w4sMxGaPGMLz3qsGF1bCBXxFqMMzfTQW44PhLBO6+McFoJnLoh+1r2AkV6Ha4u9Cf8J4=
X-Received: by 2002:a17:902:d592:b0:187:2790:9bc2 with SMTP id
 k18-20020a170902d59200b0018727909bc2mr1547907plh.61.1672260171889; Wed, 28
 Dec 2022 12:42:51 -0800 (PST)
MIME-Version: 1.0
References: <20221228144256.536395940@linuxfoundation.org>
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Wed, 28 Dec 2022 15:42:40 -0500
Message-ID: <CA+pv=HPhmb+JtYvn45C7xdLcy+GfAiR5WeAB-NXp7wOadm-13g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 9:44 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.

Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
