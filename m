Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5D74C92F0
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 19:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiCASY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 13:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbiCASYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 13:24:25 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1375576B
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 10:23:44 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2d07ae0b1bfso154257687b3.6
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 10:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yTHHKQovfQyXZSyPGRNosPkbnk8Q+C9W9kz0hDaMkEg=;
        b=KZ//JzezX5BKb7IX1RotWLv8WcmMMqw/+MYBQ5q39jgpS6ylvffS6YRdKPpwRoCHff
         OIZzzrOKvtNc66ldg8haDpPI0igUKJFe4ZzJMbAkJY3V+NVqd7eHT+7OeJyW8eQFpK1k
         4xLzE9qivmOrkcDnYLvgDWUgfKW1qyeSku37YtG3xDcaZop0em/v6KVfk0vdHhSSGXVl
         4emXY2d2NYgNrKYZllvaJAm1My9qdRr+DgMlCT/DaYjzZmyPlH45oO5XrYsmAAD9RZVc
         OfnGk0f3ZK71Vzc0eG2Nb/3F/+kRXC4Ovmt5zABC/Z7crlqR97nbsxV3dHhe2v0HyfV/
         FxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yTHHKQovfQyXZSyPGRNosPkbnk8Q+C9W9kz0hDaMkEg=;
        b=p+1/bBkXApmUMHqqvVSdH3T6dRkMhEHs25B+iNjz8AxzsWj01jz8DAeL4xhzUoc5dH
         b4tPgJEM5mF/W5w/mgW1pihMOSnTcR0nxXSl3/s7d4IUKS9w0LY/Usw0+iywRHAuajK4
         qXmfUuNe+hk3v7pjtC7PjEvkBWbt9WVoKCN1tXZhJeuaoJNFoi3L1UWzOgrIUhSl0jJM
         /2q9ODV5hQqF9/mHK9iS1lVQcfdWhFmaqdcDc0gy6cjP8VtvRfhyyb+CKx3pjpN5wgRh
         k+r76ECjyJY+LiRrC/xOepXQMeeu0AYe5pgHvhO6F3lbjCbiwf6Fplb2+NEeUnPkRN01
         T55A==
X-Gm-Message-State: AOAM533pg9F25SphvKfC80y3RrDveNSkyyRQvQ33M+eMrDBgrdhoFf17
        dyGwOYdlMYzlgCZ9hlUyyh7IAfFZsjcvMUMe5Yz8lg==
X-Google-Smtp-Source: ABdhPJz53Y+fJhAqfVGN7KtrXEUvrN8JrDFGA3TS9jhQB7hmTs7LKUsMJHqm+tSpf1DfJ5zA8UFWLqvlLcTMkC+cukI=
X-Received: by 2002:a0d:e853:0:b0:2d4:b6f:4ba8 with SMTP id
 r80-20020a0de853000000b002d40b6f4ba8mr26662196ywe.143.1646159023508; Tue, 01
 Mar 2022 10:23:43 -0800 (PST)
MIME-Version: 1.0
References: <20220228172207.090703467@linuxfoundation.org>
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Tue, 1 Mar 2022 13:23:07 -0500
Message-ID: <CAG=yYwn_4G+RZa64vF4g10kmKq1dMSN38RFGmcMTGtvwun7OLg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/34] 4.19.232-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 12:33 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.232 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.232-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
hello,

Compiled and booted 4.19.232-rc1+ on ..
Processor Information
    Socket Designation: FM2
    Type: Central Processor
    Family: A-Series
    Manufacturer: AuthenticAMD
    ID: 31 0F 61 00 FF FB 8B 17
    Signature: Family 21, Model 19, Stepping 1

NO new regression or regressions from dmesg.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology  -  autonomous
