Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0D2679CC5
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 15:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbjAXO7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 09:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbjAXO7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 09:59:41 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37296A251
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 06:59:39 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id t2so7717311vkk.9
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 06:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4GoPS4Aeds8tZZhSejmCWg7O+ACNSi1EvJNuvd9WxYQ=;
        b=wNsgcjBhoP95pgywTzWhN3KqvGMg3XtrWsqwbie+CAmVDDRAq+MESV5Gu8yhPkj+PM
         23CptZACzgbq47XPdZG/CZqBKNU8MYTgOoaSHrHfrWn7h6NWyszWzIkwXIgn+oM7y1Y4
         9Ov2OxP3CpjtYhA0zXPCmtOBFaTpZy+dWK8DhMSBaBqUnXPH4OhdBE4biWO35V8gPNco
         danKwwi2hS1bL+AMFxGdYBNWdBE80yVvUeDTkYVEK75fxRqDxakEXvK1NAXME1n5qept
         Ivw+8IgycTHeQKIo64nZPS24CV4fX2DDniX6SjR+FRCjBNnb0mMNoHwGEPiBYEdhnaZg
         U5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4GoPS4Aeds8tZZhSejmCWg7O+ACNSi1EvJNuvd9WxYQ=;
        b=lYSbTeeHn5jHCu2bmEeuVck0cL21IBhnMJW/7TALOvMQTrS93hrZveM/ITVdXrg8we
         YFld1hiIHnX3C468/GtoNTaVUQpOZXAVnuwjlpOVh/4uO/ZZVl/TE6YOqdHLCd1E/Kfu
         0Z9S1/Ut/1Wpv9qvcnDoFxwfPyRqJZL3/lRMqnz3U3SWOoHyhJYmxFO5IiC5AToZNNUD
         MpzsTtZMrPhfoGSeLIS7aD80rdqH3HQ417HN7KBrk/KbfnKWTaDTh0RfBIjuzutDkRVb
         Dk/r9G/ZZxgNJhieqPPi+e/O6/vpTEFyynMEEtVFawk7fCZlmWSWkFRAIXiXQ/4w0Xwr
         z/eg==
X-Gm-Message-State: AFqh2krMUDJ4FFsGxGMJ7bnsG/VYY5vr6RWlcOHx/YyNuz+ZqgBsmyQl
        QJQCUAQS0+alwnVil8QqW+vlxZxaBYqoCXmZ0UUZrA==
X-Google-Smtp-Source: AMrXdXsVwbutwRk83sRzOJV+IaKPbXEjBgN7J+qLJFf9WjIDQgi5n6pP26sB4A+DYIGMt3dlf1V6tfEhLEC6cZ5JjDw=
X-Received: by 2002:a1f:ab92:0:b0:3d5:63ee:dae1 with SMTP id
 u140-20020a1fab92000000b003d563eedae1mr3786731vke.9.1674572378050; Tue, 24
 Jan 2023 06:59:38 -0800 (PST)
MIME-Version: 1.0
References: <20230123094918.977276664@linuxfoundation.org> <CA+G9fYuH9vUTHjtByq184N2dNuquT1Z02JDRh2GYFR96weZcFA@mail.gmail.com>
 <433e41da-5965-ccf0-c3de-79bd696806f7@roeck-us.net>
In-Reply-To: <433e41da-5965-ccf0-c3de-79bd696806f7@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Jan 2023 20:29:26 +0530
Message-ID: <CA+G9fYteVRnsGRZh8iLe_W5gFY3_rdSVHb3MyLynBhgYwAwu+A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 24 Jan 2023 at 18:28, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 1/24/23 01:52, Naresh Kamboju wrote:
> > On Mon, 23 Jan 2023 at 15:22, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>
> >> This is the start of the stable review cycle for the 5.15.90 release.
> >> There are 117 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, pleas=
e
> >> let me know.
> >>
> >> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.15.90-rc2.gz
> >> or in the git tree and branch at:
> >>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.15.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> >
> >
> > Results from Linaro=E2=80=99s test farm.
> > Regressions found on arm64 for both 5.15.90-rc2 and 5.10.165-rc2.
> >
>
> Didn't you send an earlier e-mail suggesting no regressions ?

It took a while for me to generate a report and find this
selftest: arm64 regressions.

> > * qemu-arm64-mte, kselftest-arm64
> >    - arm64_check_buffer_fill
> >    - arm64_check_child_memory
> >    - arm64_check_ksm_options
> >    - arm64_check_mmap_options
> >    - arm64_check_tags_inclusion
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > We are in a process to bisecting this problem and there are updates com=
ing
> > from kselftest rootfs.
> >
> > Test logs,
> > # selftests: arm64: check_buffer_fill
> > # 1..20
> > # ok 1 Check buffer correctness by byte with sync err mode and mmap mem=
ory
> > # ok 2 Check buffer correctness by byte with async err mode and mmap me=
mory
> > # ok 3 Check buffer correctness by byte with sync err mode and
> > mmap/mprotect memory
> > # ok 4 Check buffer correctness by byte with async err mode and
> > mmap/mprotect memory
> > # not ok 5 Check buffer write underflow by byte with sync mode and mmap=
 memory
> > # not ok 6 Check buffer write underflow by byte with async mode and mma=
p memory
> > # ok 7 Check buffer write underflow by byte with tag check fault
> > ignore and mmap memory
> > # ok 8 Check buffer write underflow by byte with sync mode and mmap mem=
ory
> > # ok 9 Check buffer write underflow by byte with async mode and mmap me=
mory
> > # ok 10 Check buffer write underflow by byte with tag check fault
> > ignore and mmap memory
> > # not ok 11 Check buffer write overflow by byte with sync mode and mmap=
 memory
> > # not ok 12 Check buffer write overflow by byte with async mode and mma=
p memory
> > # ok 13 Check buffer write overflow by byte with tag fault ignore mode
> > and mmap memory
> > # not ok 14 Check buffer write correctness by block with sync mode and
> > mmap memory
> > # not ok 15 Check buffer write correctness by block with async mode
> > and mmap memory
> > # ok 16 Check buffer write correctness by block with tag fault ignore
> > and mmap memory
> > # ok 17 Check initial tags with private mapping, sync error mode and mm=
ap memory
> > # ok 18 Check initial tags with private mapping, sync error mode and
> > mmap/mprotect memory
> > # ok 19 Check initial tags with shared mapping, sync error mode and mma=
p memory
> > # ok 20 Check initial tags with shared mapping, sync error mode and
> > mmap/mprotect memory
> > # # Totals: pass:14 fail:6 xfail:0 xpass:0 skip:0 error:0
> > not ok 34 selftests: arm64: check_buffer_fill # exit=3D1
> >
> >
> > # selftests: arm64: check_child_memory
> > # 1..12
> > # not ok 1 Check child anonymous memory with private mapping, precise
> > mode and mmap memory
> > # not ok 2 Check child anonymous memory with shared mapping, precise
> > mode and mmap memory
> > # not ok 3 Check child anonymous memory with private mapping,
> > imprecise mode and mmap memory
> > # not ok 4 Check child anonymous memory with shared mapping, imprecise
> > mode and mmap memory
> > # not ok 5 Check child anonymous memory with private mapping, precise
> > mode and mmap/mprotect memory
> > # not ok 6 Check child anonymous memory with shared mapping, precise
> > mode and mmap/mprotect memory
> > # not ok 7 Check child file memory with private mapping, precise mode
> > and mmap memory
> > # not ok 8 Check child file memory with shared mapping, precise mode
> > and mmap memory
> > # not ok 9 Check child file memory with private mapping, imprecise
> > mode and mmap memory
> > # not ok 10 Check child file memory with shared mapping, imprecise
> > mode and mmap memory
> > # not ok 11 Check child file memory with private mapping, precise mode
> > and mmap/mprotect memory
> > # not ok 12 Check child file memory with shared mapping, precise mode
> > and mmap/mprotect memory
> > # # Totals: pass:0 fail:12 xfail:0 xpass:0 skip:0 error:0
> > not ok 35 selftests: arm64: check_child_memory # exit=3D1
> >
> > # selftests: arm64: check_ksm_options
> > # 1..4
> > # # Invalid MTE synchronous exception caught!
> > not ok 37 selftests: arm64: check_ksm_options # exit=3D1
> >
> >
> > # selftests: arm64: check_mmap_options
> > # 1..22
> > # ok 1 Check anonymous memory with private mapping, sync error mode,
> > mmap memory and tag check off
> > # ok 2 Check file memory with private mapping, sync error mode,
> > mmap/mprotect memory and tag check off
> > # ok 3 Check anonymous memory with private mapping, no error mode,
> > mmap memory and tag check off
> > # ok 4 Check file memory with private mapping, no error mode,
> > mmap/mprotect memory and tag check off
> > # not ok 5 Check anonymous memory with private mapping, sync error
> > mode, mmap memory and tag check on
> > # not ok 6 Check anonymous memory with private mapping, sync error
> > mode, mmap/mprotect memory and tag check on
> > # not ok 7 Check anonymous memory with shared mapping, sync error
> > mode, mmap memory and tag check on
> > # not ok 8 Check anonymous memory with shared mapping, sync error
> > mode, mmap/mprotect memory and tag check on
> > # not ok 9 Check anonymous memory with private mapping, async error
> > mode, mmap memory and tag check on
> > # not ok 10 Check anonymous memory with private mapping, async error
> > mode, mmap/mprotect memory and tag check on
> > # not ok 11 Check anonymous memory with shared mapping, async error
> > mode, mmap memory and tag check on
> > # not ok 12 Check anonymous memory with shared mapping, async error
> > mode, mmap/mprotect memory and tag check on
> > # not ok 13 Check file memory with private mapping, sync error mode,
> > mmap memory and tag check on
> > # not ok 14 Check file memory with private mapping, sync error mode,
> > mmap/mprotect memory and tag check on
> > # not ok 15 Check file memory with shared mapping, sync error mode,
> > mmap memory and tag check on
> > # not ok 16 Check file memory with shared mapping, sync error mode,
> > mmap/mprotect memory and tag check on
> > # not ok 17 Check file memory with private mapping, async error mode,
> > mmap memory and tag check on
> > # not ok 18 Check file memory with private mapping, async error mode,
> > mmap/mprotect memory and tag check on
> > # not ok 19 Check file memory with shared mapping, async error mode,
> > mmap memory and tag check on
> > # not ok 20 Check file memory with shared mapping, async error mode,
> > mmap/mprotect memory and tag check on
> > # not ok 21 Check clear PROT_MTE flags with private mapping, sync
> > error mode and mmap memory
> > # not ok 22 Check clear PROT_MTE flags with private mapping and sync
> > error mode and mmap/mprotect memory
> > # # Totals: pass:4 fail:18 xfail:0 xpass:0 skip:0 error:0
> > not ok 38 selftests: arm64: check_mmap_options # exit=3D1
> >
> >
> > # selftests: arm64: check_tags_inclusion
> > # 1..4
> > # # No valid fault recorded for 0x500ffffb8b27000 in mode 1
> > # not ok 1 Check an included tag value with sync mode
> > # # No valid fault recorded for 0x400ffffb8b27000 in mode 1
> > # not ok 2 Check different included tags value with sync mode
> > # ok 3 Check none included tags value with sync mode
> > # # No valid fault recorded for 0xa00ffffb8b27000 in mode 1
> > # not ok 4 Check all included tags value with sync mode
> > # # Totals: pass:1 fail:3 xfail:0 xpass:0 skip:0 error:0
> > not ok 40 selftests: arm64: check_tags_inclusion # exit=3D1
> >
> > Test logs,
> > https://lkft.validation.linaro.org/scheduler/job/6087664#L4865
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v=
5.10.162-951-g9096aabfe9e0/testrun/14329777/suite/kselftest-arm64/test/arm6=
4_check_tags_inclusion/log
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v=
5.10.162-951-g9096aabfe9e0/testrun/14329777/suite/kselftest-arm64/tests/
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v=
5.15.87-219-g60931c95bb6d/testrun/14329656/suite/kselftest-arm64/tests/
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
>
