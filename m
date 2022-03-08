Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8DD4D1B3A
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbiCHPBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbiCHPBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:01:34 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C41D22B39
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 07:00:37 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2d07ae0b1c0so204489647b3.2
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 07:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bUAHLDNYY/+Ebc3An1BLC3odr9+JTNXOzln9KVkcwC4=;
        b=Eb3zbDhhDYtoW8uyKUivQ/i8vSSO0MdTyoWQlgp+XfDgA1DqWLekEmlE8HR6tcELtV
         LKhQMH5CaWrCDEuogqdg/KcWm7SqCb4/Uerj5X5G4U4x84mY0djCafEAZ8y9odXW0C3j
         KMwd2nUaJBLnmUq+P9Y/1znGiFexfGYSuQWGIlGwm39HDt40d04lo8tH37NHUGLBh2dO
         U9XLzwZhKJlD7j0So6/5nr4zi+06BGgkdWyaOQSfPLuBjk8gBxKXd3tyfD2pZm37VCg7
         CF2b0xvJ7xOZdhC0cTOblxzMibi03eU3y5B00LBTHjgaIeSlofyNGbYRxB9DoY+5xsyP
         Kfiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bUAHLDNYY/+Ebc3An1BLC3odr9+JTNXOzln9KVkcwC4=;
        b=ufw3QaXUYh7uPZSkxofnpRuC6gkWxdzIbS/nFJ8ppALriAemYRr48kqhSIS8bUPNpX
         soCah/O7qtWzHZUwWy239jIQn28oXQgWbllTx4VfjzW8bzHCgjMQxDBiGnwEeZR0NVXt
         xQ9ulG3Kf26dctM34CgwCC/QN27sAjIqeCzvIwoSb+abT2yzKVHe80qBCiw0t0qLW6Gj
         j38ZiaMZQqBVQyGME4GvAglCjlyug+MfeQFJq9IUPxuhGDLWb7xrMTa8EagE+wzt5Z18
         8LOcZorPqq6N2lG9/0Eyt5ht3m3UNzevbm90xDdcoqk3gfWkg1WD0+v5Zom7BUg/9MUH
         HkCA==
X-Gm-Message-State: AOAM532hMY5RkA9CKuFu14aSU9cWBEmMtZZUscXvFaljHgNrneywvVyl
        SEaevUE3ET1OeNxA37/JKgTJ7MutzNUQmXlaM//7ZQ==
X-Google-Smtp-Source: ABdhPJy87nQQG7zs9dOWibvH3Jiaah4Z2Ljz2NusteJs1/GunN3/XSWECuKUwcLUMf1UcKQA14DAjh0lBZy2A+zMl1Y=
X-Received: by 2002:a0d:e608:0:b0:2dc:1f5d:8c8f with SMTP id
 p8-20020a0de608000000b002dc1f5d8c8fmr13544364ywe.143.1646751636630; Tue, 08
 Mar 2022 07:00:36 -0800 (PST)
MIME-Version: 1.0
References: <20220307091636.988950823@linuxfoundation.org>
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Tue, 8 Mar 2022 10:00:00 -0500
Message-ID: <CAG=yYw=v7cN-JCDUtiXRzoVSkAqGQXU1_Y+84jQSXWiNQt=cOg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/51] 4.19.233-rc1 review
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

On Mon, Mar 7, 2022 at 4:29 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.233 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.233-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
hello,

Compiled and booted  4.19.233-rc1+  on ...

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
rajagiri school of engineering and technology   -  autonomous
