Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF4029D695
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgJ1WQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731418AbgJ1WQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:16:28 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E64C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:16:28 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id f140so509180ybg.3
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZfGMZOlyIfrdtI2jObKxuhMFXzNJJxLtmREdUxwtXKw=;
        b=EdC0Mv/ASSEdQM3X6sJVE8rFSpsKbK7PLyUYMW7WSIlrz7YGcePkN80k0JI1DTpdTK
         WH8a5SzYR8gM79U7+KNUxKb+S4tsKC5f0lF2nudFV1z5SdmHrcy5cZvlFh5UejJMFh3f
         wHeTpuxJuRTERLkLou5CHK257CUl37duB0/D4qQkhWqgCqXuh8kd/DVE1Sw1wpgHkrXm
         AqhpoREfLnBDL1/wOwkqCatJt4KWc57AwBNG6hvTQGDiErPASfzLPKU6j7kTI3S/oZgn
         Ar+rrDm7WTDu4kzNqhLyRdOgW8ppqY9QRtdB5nOTR1XfcdV6IvMLZG1PO6B4+IBeyjvN
         R6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZfGMZOlyIfrdtI2jObKxuhMFXzNJJxLtmREdUxwtXKw=;
        b=Wj0p8Z1ePhgVzyomWdBM9BVmo/VywnoY5VJgTSIMjIPn+mcCWPsqNOQF57Nnt2qz5x
         sh1prAckanH2laP0mJqgLc+RRUVcxoddtr4BgosY///2NGVa7BjhyQAyY3wFq80CEWFN
         z4ng/JdCK53uSo8Xc08/kFFOdS/ZeyJjv46UuF0UCw44q0GMUT/gVVz4JLXldCbON9n3
         jKrGVL5hNSf0ebD5HCTyOQyuQ0hbHmkksBdXJ7Y+fCoi7tQ6kVvDhCypgjOyNWrAV0Hq
         3HxoYtCQrJ0T9yUbTYUIcY+e8Cztv2aIQsX/1/cv+159X6CMZwwJ1nCf7L/OnC4germ2
         wAZw==
X-Gm-Message-State: AOAM532s3zHM7oSuZLvHYy08pF8RhE3ZXFkr86cnWFgTPorNJzBwHZL1
        P/84jjhHuLr9bZ8VbAcXJJHuF1p4supRaJZI5d+BcyBRDX4=
X-Google-Smtp-Source: ABdhPJwUKJsKFZwQaM/RozJpF8Q4x1PJAKTkqCFAMSwGdiV8T611A75j+X+2fe6elkjpDptOFONkttXWUw1kMZS5eY0=
X-Received: by 2002:a4a:d0a4:: with SMTP id t4mr585141oor.21.1603917226627;
 Wed, 28 Oct 2020 13:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201027134900.532249571@linuxfoundation.org> <20201028170621.GA118534@roeck-us.net>
 <20201028194647.GA124690@roeck-us.net>
In-Reply-To: <20201028194647.GA124690@roeck-us.net>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Wed, 28 Oct 2020 14:33:35 -0600
Message-ID: <CAEUSe7_72XC=Dz=yy6UrHLrgAQbHzP9V2UfmWXbwmeUSeVzgJA@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/112] 4.4.241-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, patches@kernelci.org,
        linux- stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Wed, 28 Oct 2020 at 13:46, Guenter Roeck <linux@roeck-us.net> wrote:
> On Wed, Oct 28, 2020 at 10:06:21AM -0700, Guenter Roeck wrote:
> > On Tue, Oct 27, 2020 at 02:48:30PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.4.241 release.
> > > There are 112 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> > > Anything received after that time might be too late.
> > >
> >
> > Build results:
> >       total: 165 pass: 165 fail: 0
> > Qemu test results:
> >       total: 332 pass: 332 fail: 0
> >
>
> Did anyone receive the original e-mail ? Looks like I have been tagged as
> spammer, and I am having trouble sending e-mails.

If the original is from 3.5 hours ago, yeah, we got it. I'm not seeing
lore updated, but that's probably another issue.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
