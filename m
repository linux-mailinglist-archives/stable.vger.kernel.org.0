Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD72E8ED85
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 15:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732587AbfHON7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 09:59:09 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33220 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732586AbfHON7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 09:59:09 -0400
Received: by mail-lf1-f66.google.com with SMTP id x3so1733635lfc.0
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 06:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NEN7OlO6PsmXIW/8TrDuJXInacqxCs2vYJzFBFiDd3o=;
        b=C/Vg5PbbwVSUgAlnGNV6yX4Zg9x9BM3xaD1rxzbpZmrIyqRMncGMNTVQRTdTQGgV9w
         dj5jGqs13lpnytnccCDjOlXFdmaOODYchUzdsYNOrMvgmEXtlsR+3DUVmyLR8UFZ2OnJ
         JotNTYd+N+t+1PlL6ofleNDWk2+QGEAnrwa9p1vI2Ib4gucIi6Jc8enCv5oFHgnnAR52
         JSJcPDIDUXcS1arLfC3ygMWORHpkaT24alEGmB8V29N/gr6OklMCi6cVV+275NS51/Mn
         bJ13iGDF4AL1WquY0z3PL3cU2zppjqEhd09MAIopifw8sZG3e/xIhowTJqtFnyIK2McL
         +y1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NEN7OlO6PsmXIW/8TrDuJXInacqxCs2vYJzFBFiDd3o=;
        b=lay8MAxhKxmfmmtr/VJytPVlLBVtMfCx8rKAgo2e98muCjtnsVtLEWQoIc1+F5xym6
         /SlWmm0pdDuBi64S099Wn8b+aTuj9VXHeUvHWBWHVLC1iTJalVsIXFEni9ETU9t7Dv9P
         HNoX2reF3opS4MI5DKJzDmpMK0kzC2RhDcnTPgTtvFDcZyfgsMh0XSiaxN6ie1cQg9b8
         mFO25TLoGyh/jsV46lIouQE9+tHF16MtLPw2WwuzY+gGDfTkmAluCoxNqTDnytddf3iC
         iwnD/NFcNqrO6rwD/FfGRnIz7M71fGKQxpNyAAOero4n8jqR3dS5Iin/QdBAeHJ0JRtM
         1iPA==
X-Gm-Message-State: APjAAAVnRFS5DOTmtUo564NMQe47WBuhPxhV6QZIalckVfWqPLFjMHJG
        bLOjekppz0JRPBZ0YZmQxbKZf7+8MhyQKm/XUYI0Ew==
X-Google-Smtp-Source: APXvYqzFZlMCZYJMKEX4UEYuYtAvcf7l/nZHdtCVXRR7a/KQaTx5HhKk5gCqP72LtFfVhYWlQwu9uHpau60MorzUfDc=
X-Received: by 2002:a19:6707:: with SMTP id b7mr2477107lfc.16.1565877546927;
 Thu, 15 Aug 2019 06:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190814165748.991235624@linuxfoundation.org> <aa683926-3df0-6f60-841a-7ea5a5e3566d@roeck-us.net>
In-Reply-To: <aa683926-3df0-6f60-841a-7ea5a5e3566d@roeck-us.net>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Thu, 15 Aug 2019 08:58:55 -0500
Message-ID: <CAEUSe78A6Cvt2irKzysfRSHubVxDaEGUVaLf2UF5EHzTeiOVOw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Thu, 15 Aug 2019 at 08:29, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 8/14/19 10:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.67 release.
> > There are 91 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > Anything received after that time might be too late.
> >
>
> Building x86_64:tools/perf ... failed
> --------------
> Error log:
> Warning: arch/x86/include/asm/cpufeatures.h differs from kernel
> Warning: arch/x86/include/uapi/asm/kvm.h differs from kernel
>    PERF_VERSION =3D 4.9.189.ge000f87
> util/machine.c: In function =E2=80=98machine__create_module=E2=80=99:
> util/machine.c:1088:43: error: =E2=80=98size=E2=80=99 undeclared (first u=
se in this function); did you mean =E2=80=98die=E2=80=99?
>    if (arch__fix_module_text_start(&start, &size, name) < 0)
>                                             ^~~~
>                                             die
> util/machine.c:1088:43: note: each undeclared identifier is reported only=
 once for each function it appears in

We noticed this exact failure but not on 4.19. For us, 4.19's perf builds f=
ine.

On 4.9, perf failed with the error you described, as it looks like
it's missing 9ad4652b66f1 ("perf record: Fix wrong size in
perf_record_mmap for last kernel module"), though I have not verified
yet.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
