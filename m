Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7A37B072
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 23:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEKVF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 17:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhEKVF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 17:05:27 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D636C06174A
        for <stable@vger.kernel.org>; Tue, 11 May 2021 14:04:20 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z17so2399785wrq.7
        for <stable@vger.kernel.org>; Tue, 11 May 2021 14:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UAz7SZxg1EiMj8MPMMpKdaA1DXterUsKEbt3TioJwwc=;
        b=apxT21xHlDNwKH/iXSaHXhNwUqpcSWq8kGqUQxwwSDwUdZ8g80a6xhTq3H1BefG067
         p4nJPtAS/erVVBcnamsPfdazDSVyq0iwaCdcDOFj9XFls3/YD9vVZH00cHxJ2MkJ3ZuD
         a6c7l4f6W0ZKlDVxb4FqnmAprQ3dSCZhy5Ozc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UAz7SZxg1EiMj8MPMMpKdaA1DXterUsKEbt3TioJwwc=;
        b=KFbcb5IFitemNQK47CcFSGvHb7zn67Ml/wxD7IQehrF/udxC0fi5S/qiQqiMuasNnK
         DZNJGENNlAg0ivZUUN2tzg7kzCEiSF2ddw55QYYDJABubzMFb0ukESVD8lAUrbEnrQr6
         BN/l+r33u3LRT7vtf2MZXXbSlnJxFtxEtuAqorTmjEHBTuIwZBlJiYjCg2VUDHYqylYx
         O92La2om1rLomf9ZMIm2NuzayZgfreBl8Unr7ZsDNzuKbHHIQvA/Zsn1yf14rclHXcJk
         OnD55CcN1Qr7Nsyg02fIeV5qH15i4CuVwwPUO9jTGbuC1s8quQP1aPtvRdhjgHSjrcnY
         11Ng==
X-Gm-Message-State: AOAM531Vpq8j6kqFpNhADShvMfinY9PNQ8rTnOZELF81H3XB6CjfJQCi
        mg+hdaOu0kXL3th0cVXg3EcwakPZ7wRsWwdSrK+kmQ==
X-Google-Smtp-Source: ABdhPJxPH8PX+jGSu+VhI7aemEZkfJsBx5LjFbybXsZBRuUCI3dNSKe9Vdav1Xo8HITrToUisnJF1Ta/kz8h2vcAf38=
X-Received: by 2002:a5d:6752:: with SMTP id l18mr39422003wrw.422.1620767058628;
 Tue, 11 May 2021 14:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210510102010.096403571@linuxfoundation.org> <396382a7-9a50-7ea1-53a9-8898bf640c46@linuxfoundation.org>
 <YJqIOajso0EyqgjO@kroah.com> <3244bd40-3afa-8386-3378-220ff2e2527d@linuxfoundation.org>
 <YJq0yCirpEV+bgC/@kroah.com>
In-Reply-To: <YJq0yCirpEV+bgC/@kroah.com>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 11 May 2021 16:04:07 -0500
Message-ID: <CAFxkdArDSNDxWKLVVjYDnZ_Wuu3ceik6cCoyBJ5ibCXZdQDX2Q@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/342] 5.11.20-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 11, 2021 at 11:46 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, May 11, 2021 at 10:16:00AM -0600, Shuah Khan wrote:
> > On 5/11/21 7:35 AM, Greg Kroah-Hartman wrote:
> > > On Mon, May 10, 2021 at 04:48:01PM -0600, Shuah Khan wrote:
> > > > On 5/10/21 4:16 AM, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 5.11.20 release.
> > > > > There are 342 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.20-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > > >
> > > >
> > > > Compiled and doesn't boot. Dies in kmem_cache_alloc_node() called
> > > > from alloc_skb_with_frags()
> > > >
> > > > I will start bisect.
> > > >
> > > > Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> > >
> > > It might be due to 79fcd446e7e1 ("drm/amdgpu: Fix memory leak") which I
> > > have reverted from 5.12 and 5.11 queues now and pushed out a -rc2.  If
> > > you could test those to verify this or not, that would be great.
> > >
> >
> > I am seeing other display issues as well. This might be it.
> >
> > I couldn't find rc2. Checking out
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > linux-5.11.y
>
> Ah, sorry, pushed the -rc2 patch out now, but the -rc git tree has it as
> well.
>

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
