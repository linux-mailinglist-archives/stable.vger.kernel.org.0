Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108B03C85B5
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 16:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhGNOCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 10:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbhGNOCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 10:02:30 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5077C061760
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 06:59:38 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id w127so2312374oig.12
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 06:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MoeOURTbosH7NKRSKk2RFpZ07l20VBkJQlKIXN2X07Q=;
        b=hvfXbGFOJ3fiDpmEUCCvPP2JIB0B8Q+eZ65ehQExbq0WZIvPVoTG+1fkMcDb5AA9/4
         PdkPh8Yin4PLu8VATiw0Isi+oTQhXiZx+oOFB4SlzJhQ97GdTAhSAR9AWrCbtZluDMOs
         kiTuL/mvyqfUkOqPcsDicRBrQXxZrwfjUTFy21qsgCDB8OEIQzUNw4ktkvr/Vb/ngggV
         9aQo63envdA0/rKn71u1ziOAs0Hq+qXxGxww8AD9Ju5BUiuiZqq647ECpvGD6zL7N5yb
         U8dYJVjNM534fHh7SjiBnC+3ivwGBMIL00tFaqZQlO67GoZikx+gdYSfe+2TU7ggMNoX
         im2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MoeOURTbosH7NKRSKk2RFpZ07l20VBkJQlKIXN2X07Q=;
        b=Ng1DYt61D37jTxO5v6jv8DK7vrCzBUxuaD3UN9F0XUyggM0YDsV43pipe2btGFG+Q+
         V8YI606luUr3vEVgEBGnDHZ2wKKNHaGytBCce1r2NqBykz5I0MBus+Z3gdjBp7ff4szL
         l1x9DbuySzQ4Qk3ChYSBuA+aGB1TU9jyH0i2sIOapYuPALi31w5q8+FItEqNaV4xMF/X
         YgoqWc8TRxhH4sPIbNY53zYAfQCPisn1+FBYv3HaV/sfbm6daUUJiDNBvyyH5VO30t7y
         swmBWEy0S22g4Ihf1e5S0CEJMfbfuTsjeea5NnDAb5Apc8zzdNzBI00jhKmSXMEXae+X
         hjaw==
X-Gm-Message-State: AOAM533OkJfMtXgoy3jFEA/LIsEf1m87pzS7O4dIiUCYF6JfyX2uC0o/
        wf6tvEW+FvLVqq4p1AwYX+hg0NSGh7B6MBzXaVYfWA==
X-Google-Smtp-Source: ABdhPJwCPWqO6fJFtg2J2lL2fQgBE8vc42O0iKo8yKuuRtTayDlHUa5YjbKu1Jvk4/YJKrOpSs79NIGrjfXl2xgRvcw=
X-Received: by 2002:a05:6808:144c:: with SMTP id x12mr7336900oiv.167.1626271178205;
 Wed, 14 Jul 2021 06:59:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210712060912.995381202@linuxfoundation.org> <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
 <YO56HTE3k95JLeje@kroah.com> <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
 <df63b875-f140-606a-862a-73b102345cd@praktifix.dwd.de> <YO7nHhW2t4wEiI9G@kroah.com>
 <CA+G9fYuhbE6sY3ykoiyqZqYSG=+V0r3z0TiaVL8LptbXWw=duQ@mail.gmail.com>
In-Reply-To: <CA+G9fYuhbE6sY3ykoiyqZqYSG=+V0r3z0TiaVL8LptbXWw=duQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Jul 2021 19:29:26 +0530
Message-ID: <CA+G9fYtWkOLVVKB0xYfAXWS57G1C2xV-Zbtp5i4dAJDJqwLQhg@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Holger Kiehl <Holger.Kiehl@dwd.de>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Jul 2021 at 19:22, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Wed, 14 Jul 2021 at 19:01, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >

<trim>

> My two cents,
> While running ssuite long running stress testing we have noticed deadlock.
>
> > So if you drop that, all works well?  I'll go drop that from the queues
> > now.
>
> Let me drop that patch and test it again.
>
> Crash log,
>
> [ 1957.278399] ============================================
> [ 1957.283717] WARNING: possible recursive locking detected
> [ 1957.289031] 5.13.2-rc1 #1 Not tainted
> [ 1957.292703] --------------------------------------------
> [ 1957.298016] kworker/u8:7/236 is trying to acquire lock:
> [ 1957.303241] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
> bfq_finish_requeue_request+0x55/0x500 [bfq]
> [ 1957.312643]
> [ 1957.312643] but task is already holding lock:
> [ 1957.318467] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
> bfq_insert_requests+0x81/0x1750 [bfq]
> [ 1957.327334]
> [ 1957.327334] other info that might help us debug this:
> [ 1957.333852]  Possible unsafe locking scenario:
> [ 1957.333852]
> [ 1957.339762]        CPU0
> [ 1957.342206]        ----
> [ 1957.344651]   lock(&bfqd->lock);
> [ 1957.347873]   lock(&bfqd->lock);
> [ 1957.351097]
> [ 1957.351097]  *** DEADLOCK ***
> [ 1957.351097]

Also noticed on stable-rc 5.12.17-rc1.

> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ref:
> https://lkft.validation.linaro.org/scheduler/job/3058868#L2922

ref:
https://lkft.validation.linaro.org/scheduler/job/3058423#L3125


- Naresh
