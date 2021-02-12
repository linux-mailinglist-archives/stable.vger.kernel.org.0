Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62218319CAB
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 11:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhBLKak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 05:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhBLKah (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 05:30:37 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E919C061786
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 02:29:54 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jj19so14726189ejc.4
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 02:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tElWc1UCcSA6sC4diH5VQEMjksELtbi/V6+pA6CaRK8=;
        b=ZoY/2L3RfsSEstvRgrWC+sug0LFqKHy/+dENSeYAdh6tPLDOZOt+/iFR6+XQBQ+fde
         H/x7GG++Ch71x+GmgDXZAc0HSugtD1Qsf112t4TIuw0tFSe1VUEJCgvpkB7W47HoJ10K
         BsNs9luUUPKxBZaH7xVVDK1CUAQaffXPmImaF4OuJc8IWLj5Iqk5ituNMYDaUmAE5a0I
         CDrLOULV0qTKntF/rVpJQrrw/GNzs+JSsnTZFa4JNII4Pe6Vbowlc6kYu1bbDMHyDtK/
         8QP5rjm1doxVpX8y9gi6uKrSTBBoN44IjVh1jtSMNjWOD9CpE8lxYF6QG0oYSz0B3nwo
         LuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tElWc1UCcSA6sC4diH5VQEMjksELtbi/V6+pA6CaRK8=;
        b=ZTdSevxdxz1OzkYYK9ZcwuiIMIRfYPM7415qcO3w+BDYjVUSZvMa0Yd5BeFCznMK0M
         v/bN4pNHN6Xxzknp//a93hjMbdtmJUx+fB9xiSGhNe32h6UtLEM8crx4TLAP7Y5gFmh0
         qLeJV79cCC5JGAPyiPydJBQ+KhYV26J+HA4IJTWmAhbcKWXHQIehr934AYdIUbPOll3k
         vDi79bZY4OyDq3VqFVNaU/w8OWI29SsiymTCR/LNiWJ0jnnQvsFjkC7VpPeVISEl24PL
         aeXWfOyXabu/yTxQ8gUvF7II+2lCzFNwvSEYp+OWR4ExlLKJsZR8hWsFFXlODpb19qLm
         N2gA==
X-Gm-Message-State: AOAM533ZioYQlp9gkL1kRqQlhJVBwAT5DxapaqIseXru918rl9M99Ire
        gAmJon4kuSi0u7U/O7Fbmpt+8CTYYrQD7tpuUOj2tw==
X-Google-Smtp-Source: ABdhPJzf22R9Qwf3odmlRaj1ioPO2red6KcR6BZ3O4YHyw4E4noigIcyBjopTJNAldBsRx1+DtFps21yX7fGDWIPH5o=
X-Received: by 2002:a17:906:d8ca:: with SMTP id re10mr2356020ejb.18.1613125793136;
 Fri, 12 Feb 2021 02:29:53 -0800 (PST)
MIME-Version: 1.0
References: <20210211150147.743660073@linuxfoundation.org> <CA+G9fYugE5n1qsudwP7XntBvvNcEquxQkMEskWvxJAZdZX5Fng@mail.gmail.com>
 <YCYxSEwzNGfMoLbb@kroah.com>
In-Reply-To: <YCYxSEwzNGfMoLbb@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 12 Feb 2021 15:59:41 +0530
Message-ID: <CA+G9fYugMr_Qat6KJ2-HeF_qMBYtcYXx2EEMZqQ6a8AavEFPTQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/24] 4.19.176-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Collins <collinsd@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Feb 2021 at 13:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 12, 2021 at 10:16:11AM +0530, Naresh Kamboju wrote:
> > On Thu, 11 Feb 2021 at 20:36, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.19.176 release.
> > > There are 24 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.176-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The following lockdep noticed on the arm beaglebone x15 device.
> > I have not bisected this problem yet.
> > Suspecting this patch,
> >
> > > David Collins <collinsd@codeaurora.org>
> > >     regulator: core: avoid regulator_resolve_supply() race condition
>
> Sasha queued up a fix for this, let me push out a -rc2 with that in
> there to see if this resolves the issue.

The reported issue is fixed on 4.19.176-rc2.

- Naresh
