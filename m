Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A523C7352
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 17:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhGMPfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 11:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236969AbhGMPfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 11:35:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24650C0613E9
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 08:32:29 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l1so11937481edr.11
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 08:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t5TojjWrRBsIs06i7+P4LW8furiBuJJWbJ4iVN8Q5zU=;
        b=mlQxxp9EfXr5aItbTmmQ0FP9K2knh+UKzG6qniVQXogxGFsBR7xTTUYytPs6CiE4l6
         4Ho5o80fgXcAP3FsKZMD2099008Bkf/kjrftHtHQDiSVL+LhJSY0aBI9Ia79KaWyhlr4
         2YlaAWpRMdB5rDX48BjbbUZWseSwSkvUgyxajpiEg4s/FaGrLIQ88Znap+zWu5kdKMxQ
         dEHI4KByMeaedBUL1/SSK8Ya0pjdVAmxV8cJOxiuVZ5T1O2XXlsa3gh8xc5wgDQ5jgI7
         3aLd8/VzaQpoLXpm6zsXMbkgJ8yH5tXn6UUN92CUuFbH/AFh8uGf17TDSRRO+x7zAPDH
         T/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t5TojjWrRBsIs06i7+P4LW8furiBuJJWbJ4iVN8Q5zU=;
        b=n35EUcahNYU8VqvBr61sUVg+soWcvCZQauVT6+d+MtsD2mFxqEaKT06JMvaUs4IJ6L
         XWFWxBDyTWRjNyYOAaRFYKj2aezWwrapKeoXs7sriTsTECKjK5Cgr6C4yHZ0R21nU9q4
         3SMxn8HMqPZDcJF1CoL9pihx2mLrHDotO5nu0FDCZKJdwubfjEhfQMaLEh03aoW4ARrQ
         JbzXXov2whv8KOgXmp1vIOL1JZQmhvqofY2PgwMTUe4uQQXnAExBPKR5WBt5ZwFIV/fe
         iZTLKc9tMHBdbmhKtlNH7w+qs+e9uhvO0e/eCuEZNH7DDgKRR3+BohlJ6qY9XClUgYsC
         qRRw==
X-Gm-Message-State: AOAM532IJmt1cPgiisByIUi8jBv4cffSZWQX951gxF9RQf8uLJbfUaAQ
        B2ErMHS2F5F4eMVLGX/xmpD2UiU78GsuFn/JVlT/4g==
X-Google-Smtp-Source: ABdhPJx7BFiZukYc1OKQ43hzuOJtKSnIcPy4tciKGjhl9VBmnERkzb4cpRhd9T79CljqGYihGUH+rdRHgOcuLo1UOjg=
X-Received: by 2002:aa7:db94:: with SMTP id u20mr6543698edt.381.1626190347701;
 Tue, 13 Jul 2021 08:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYubOg+Pu8N3LYFKn-eL3f=gn4ceK9Asj1RdBDntU_A2ng@mail.gmail.com>
 <YO2upa4SZWS59KeB@kroah.com>
In-Reply-To: <YO2upa4SZWS59KeB@kroah.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 13 Jul 2021 17:32:17 +0200
Message-ID: <CADYN=9+vr=xHsY8yinyWUTN+xyEG=v8-xf4y2psDarFKWDU6xA@mail.gmail.com>
Subject: Re: perf: bench/sched-messaging.c:73:13: error: 'dummy' may be used uninitialized
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        perf-users <perf-users@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, Leo Yan <leo.yan@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Jul 2021 at 17:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jul 13, 2021 at 08:40:28PM +0530, Naresh Kamboju wrote:
> > LKFT have noticed these warnings / errors when we have updated gcc version from
> > gcc-9 to gcc-11 on stable-rc linux-5.4.y branch. I have provided the steps to
> > reproduce in this email below.
> >
> > Following perf builds failed with gcc-11 with linux-5.4.y branch.
> > - build-arm-gcc-11-perf
> > - build-arm64-gcc-11-perf
> > - build-i386-gcc-11-perf
> > - build-x86-gcc-11-perf
> >
> > Build error log:
> > --------------------
>
> <snip>
>
> I imagine this is fixed in newer kernel versions, so if you could
> provide the git ids of the patches needed to fix this up in 5.4, that
> would be great!

You were correct, I did a bisect [1] and found
d493720581a6 ("perf bench: Fix 2 memory sanitizer warnings").

commit d2c73501a767514b6c85c7feff9457a165d51057 upstream.

Cherry picked it and I was able to build it on arm64 and x86.

Cheers,
Anders
[1] http://ix.io/3sS6
