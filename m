Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01B127CFAE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 15:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgI2Nok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 09:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729532AbgI2Nok (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 09:44:40 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA45C0613D0
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 06:44:40 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id j3so2963334vsm.0
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 06:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cy4qcXyjvg/+Dx3IJ/YAv85ZXWLFUEJZrSSjlCMTA60=;
        b=ZO2N0dQk5xyyp+tAn4+UTwHk/CwZNYcujPqNrRk7noBZpSnWF6H4kZ1feRkc+4VOnR
         279D85yv3hvSlQ+K6++wsRncZ0lcKt/qR8F4BRGYJd80jv6/N5ORRHb1nkmetqhWg6iK
         YooVIqGkeGm0OFHkyz0TCRsHV6nirHFzQahEEKjV0gV/bfHojgLKQDXe/kMloAVpB9sh
         R4pAekPrj25OHCsZhkrVeg5yer6W8WnCMc1D1KqITzLSygLi7dH7F+RJL2XwnEj7UOHW
         YtDdhsvQggTDRuvfYhCgME0EH/nqdtZlm3PBby+Q2oPQMtv/r6Ks9ysFT0dMB21VTw3q
         4diw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cy4qcXyjvg/+Dx3IJ/YAv85ZXWLFUEJZrSSjlCMTA60=;
        b=IPEz2kJV6ppVw5qaszmVEdH7a2XZFXZcHSQvPekr2QY9ZVBklkBFgr8Vg7i8AXuUH3
         qLvnMojj+Wj5ad02oWK53tsV0eSKOeG/gIf6u17Uf8Kdib62UPTkqNqkq1A+A+zVb8tV
         OSp2fjEBGHbNx+k3+rXDrmF7d+4MsNNq2T0UZPkExUP0aVJr1nU9hUZUDmlQpV4gVVSr
         MDBQ2fp25KDSj2iUMNM8cEM4xIUhuTf8pNb9yT1K3Krx6n5WVbAl21Cnr2N7JOCRxOx5
         qVCQHQqhmdXu4nSCQpwuI1a8kwKChci57HEuUWrV30b9ttJ/AlzBlYp27156+UDmClZ1
         h0Fg==
X-Gm-Message-State: AOAM531p5dkgq+lqiqjKk/SbH5inBS8wcCK12HWEzxPhpbLGVLUeA6cL
        zNWagI4tGg25lHLpoRcC1ut836ckLqSEi58z8EPbqg==
X-Google-Smtp-Source: ABdhPJznuae83ClNpbBMBoFUiCv/sta2s5ycrw5al0myMnOJJZ+IPm3k7VveReCAeDTJIWFvQB3gWXuW8MFGTsdvl0Y=
X-Received: by 2002:a67:bd12:: with SMTP id y18mr2883840vsq.45.1601387079632;
 Tue, 29 Sep 2020 06:44:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200929105946.978650816@linuxfoundation.org>
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Sep 2020 19:14:28 +0530
Message-ID: <CA+G9fYsMyseOo3ntS_7o4qibCHEPGr0w5AQYweXjjBTyJN0DYA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/245] 4.19.149-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 at 16:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.149 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.149-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

<trim>

>
> Stephane Eranian <eranian@google.com>
>     perf stat: Force error in fallback on :k events

perf failed on stable rc branch 4.19 on all devices.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

In file included from util/evlist.h:15:0,
                 from util/evsel.c:30:
util/evsel.c: In function 'perf_evsel__exit':
util/util.h:25:28: warning: passing argument 1 of 'free' discards
'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
 #define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
                            ^
util/evsel.c:1293:2: note: in expansion of macro 'zfree'
  zfree(&evsel->pmu_name);
  ^~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work/intel_corei7_64-linaro-linux/perf/1.0-r9/perf-1.0/tools/perf/arch/x86/include/perf_regs.h:5:0,
                 from util/perf_regs.h:27,
                 from util/event.h:11,
                 from util/callchain.h:8,
                 from util/evsel.c:26:
perf/1.0-r9/recipe-sysroot/usr/include/stdlib.h:563:13: note: expected
'void *' but argument is of type 'const char *'
 extern void free (void *__ptr) __THROW;
             ^~~~
util/evsel.c: In function 'perf_evsel__fallback':
util/evsel.c:2802:14: error: 'struct perf_evsel' has no member named
'core'; did you mean 'node'?
   if (evsel->core.attr.exclude_user)
              ^~~~
              node



-- 
Linaro LKFT
https://lkft.linaro.org
