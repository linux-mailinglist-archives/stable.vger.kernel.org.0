Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9CD46207F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 20:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238478AbhK2Tc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 14:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhK2Ta5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 14:30:57 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07ACC061799
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 07:47:31 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y13so73710254edd.13
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 07:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6g50yMG/1omcJlm0BcWdAgQTVtFHbwnLlUdAfvNo04=;
        b=zsxTUePSdP1mP9GKvIUtm3eug9zrqHOdRP6ODS2E+5PZynoYDvucViEFbBkdlywFwa
         hccTQkzLxfJSLG602+GzYfHRHEkyO8WD7icrJrL4CVkE5yrY3/HMfl20MsuWOYIp+eKk
         F6YbbSKzZfwbsv0PrXBhH5YeWPUKwp2YikdcLp6Ru7ri3Lb05SZcT8PnWcoz5kU268JD
         tBZhMx9DXoSqm2JsYu8TgO7Eni7DG3KKDM269leP5KR9sPxxhF0aFNFwyJCZpn+QZjEj
         aHJxQwDzJazq5Z0mBlZvWP5rjnbkt7XSakRZXjv9EhhPjlqkgOM33jg+5RY52/yhWYrk
         xOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6g50yMG/1omcJlm0BcWdAgQTVtFHbwnLlUdAfvNo04=;
        b=ag+TROOa0iwA1ZidX5sP4eopQASXuiNJtCDN7wx6nbSN9+Nm2GFmDCwFUc7/ZZJU0I
         cxxSsnOLRqXda1Rgix0GSsLXwepLJSz71kk3nHnk2qUDP2wxRrVwqXK5s1ZxdgVcihS4
         HVp86eqvY6/tmXtyLfEX1+MMZ4W0XYxAAkli444RTMCpdWgpqzOYWmgLzMyBhtmk04Qt
         51X0c5TpN7TRwtozuNdr5yVL5JmJB2nB4+9pUyu1cxdUSK3XQgLyjFiEewbtP8vVL/bN
         CXr01F1NSVc+YhNHSwI4vnzzAnURcB5qtYYxD7LK+TGq7XVyT7PBZpP1VLB/6PvP7JLs
         IU7Q==
X-Gm-Message-State: AOAM530vW1A90w02Nc6al7KnIoaJrgKF+H90hFTCHwGs0jLVWJuc3b/H
        Cp9ImwHCywg3GB2vouBiplTBbB9TB/V290WFJJUCAg==
X-Google-Smtp-Source: ABdhPJwUAgVVsyVr5litLo45IS6OFKaPGye855sme0yFRscxgxypkG4QPymN0fIX25G3gH3RLUorv5ZrxEwFi7C0rGc=
X-Received: by 2002:a05:6402:4312:: with SMTP id m18mr73833303edc.273.1638200849924;
 Mon, 29 Nov 2021 07:47:29 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYuzzknDMdu3q8ARyVHqd-cLYD_tsMLMH-ig-k-WVeTPAg@mail.gmail.com>
 <YaTkwsWycenqZHN9@kroah.com>
In-Reply-To: <YaTkwsWycenqZHN9@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 29 Nov 2021 21:17:18 +0530
Message-ID: <CA+G9fYu_aWr-S77rD39Bx-oMGAwbkYPQJzUH8mz_ea++VYNk-Q@mail.gmail.com>
Subject: Re: Doesn't build 32 bit vDSO for arm64
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Antonio Terceiro <antonio.terceiro@linaro.org>,
        Vishal Bhoj <vishal.bhoj@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Daniel

On Mon, 29 Nov 2021 at 20:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Nov 29, 2021 at 07:42:07PM +0530, Naresh Kamboju wrote:
> > Hi Greg and Antonio,
> >
> > The stable-rc 5.4 build is failing.
> > ( 5.10 and 5.15 builds pass )
> > because new build getting these two extra configs.
> >
> > CONFIG_GENERIC_COMPAT_VDSO=y
> > CONFIG_COMPAT_VDSO=y
> >
> > These two configs are getting added by extra build variable
> >
> > CROSS_COMPILE_COMPAT=arm-linux-gnueabihf-
> >
> > This extra variable is coming from new tuxmake tool.
> >
> > Doesn't build 32 bit vDSO for arm64
> > https://gitlab.com/Linaro/tuxmake/-/issues/160
> >
> > ref:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/
> >
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Has this ever worked on 5.4 for this configuration?
>
> Or is this a new problem with the current 5.4.y queue?

It did not worked on 5.4 with CROSS_COMPILE_COMPAT=arm-linux-gnueabihf-

OTOH, Since 5.10 and above builds pass with this ^.
We are investigating and trying to find the missing patch on 5.4.

- Naresh
