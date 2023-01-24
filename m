Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E58367948D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 10:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbjAXJw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 04:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjAXJwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 04:52:55 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC363AAA
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 01:52:48 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id i188so15857022vsi.8
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 01:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8BB+Mr1YyupdL/5z3B/lkYmn99GXR1QXWMQn3D/xn4=;
        b=iWZvxL5ps2NPyyh2UuYMy8zM59kuLd7mqLCJc9Z3GGMNkaMHevffve3dzn2Ab/gO5K
         /JgKsux/mPVYIbnKGHAzRcU+JW/CSwoRFc+jcealKFZgBm9WZfy9sOk1AK1Qk+PEm1JL
         QQxpIGHKzbp3k+tWxUp4T/YR7fK30h39d1MNKD4Wfj8CpbZU7sGSsRe3q5YJN+r2C0r6
         9Nd1koBNEdmQUjXm+QkBW/qf7C57O3AnKDWZYEBJtfDqdV2nsTKo971jzjgAcX/Hnb+X
         a9EnLhNhdIv+pREjn4I0iPh9h3+JAE0aKemr1+O2g361TSjQAgksnWKAsy0iXxh/72zU
         nCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a8BB+Mr1YyupdL/5z3B/lkYmn99GXR1QXWMQn3D/xn4=;
        b=2jTbG7LYFYi2V7SUOrvkfem9XZm/EUL/xSrB+iIf61UFIYG6eGQX2PjghAydzExkre
         s/dI0kIeDsRy+K5q74tH1MEyVj6w38/mKpkrK/DjPsfIPaBBERQWbg8ZH3poWzuaStsr
         jRO8M57DiXKBTTbm1UFT0slei7HBjGJlzOYk6tNlMgL6tlFZZlr5OyF1eyxrO37ECveF
         7L94fMIyQIUe1Pkgd4+GIDqcN5HecM+OcxOgDkhXbBsmfJSo9PBd155SzX1mUmjh/fm7
         pLgZ2NA5t9Bo3Ee3hHz5ypjGE5DGZm5Jas5ggtmTfI0gynqy+jesZLCIRUVauob2E+6Z
         1/CA==
X-Gm-Message-State: AFqh2koFxYqGnwDfGKRmtpukQp53c0DvjcKU9hw5HTFuhv7KNvjFfWjW
        b7ivJIv9Tk1ZPYPVoVcARbcOoBNUQd+u7lPC9Uvjlw==
X-Google-Smtp-Source: AMrXdXs1Dt3Y8mDPY1t3AKO/K/9NNQwbFr4c9mRLc8barvrc1wy2swCK1MeUTrQfCXWOwHrdPPMpW/WBscKT0RCrhxQ=
X-Received: by 2002:a67:b102:0:b0:3d3:dd2d:88d1 with SMTP id
 w2-20020a67b102000000b003d3dd2d88d1mr3487254vsl.83.1674553966972; Tue, 24 Jan
 2023 01:52:46 -0800 (PST)
MIME-Version: 1.0
References: <20230123094918.977276664@linuxfoundation.org>
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Jan 2023 15:22:35 +0530
Message-ID: <CA+G9fYuH9vUTHjtByq184N2dNuquT1Z02JDRh2GYFR96weZcFA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
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

On Mon, 23 Jan 2023 at 15:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.90-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions found on arm64 for both 5.15.90-rc2 and 5.10.165-rc2.

* qemu-arm64-mte, kselftest-arm64
  - arm64_check_buffer_fill
  - arm64_check_child_memory
  - arm64_check_ksm_options
  - arm64_check_mmap_options
  - arm64_check_tags_inclusion

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

We are in a process to bisecting this problem and there are updates coming
from kselftest rootfs.

Test logs,
# selftests: arm64: check_buffer_fill
# 1..20
# ok 1 Check buffer correctness by byte with sync err mode and mmap memory
# ok 2 Check buffer correctness by byte with async err mode and mmap memory
# ok 3 Check buffer correctness by byte with sync err mode and
mmap/mprotect memory
# ok 4 Check buffer correctness by byte with async err mode and
mmap/mprotect memory
# not ok 5 Check buffer write underflow by byte with sync mode and mmap mem=
ory
# not ok 6 Check buffer write underflow by byte with async mode and mmap me=
mory
# ok 7 Check buffer write underflow by byte with tag check fault
ignore and mmap memory
# ok 8 Check buffer write underflow by byte with sync mode and mmap memory
# ok 9 Check buffer write underflow by byte with async mode and mmap memory
# ok 10 Check buffer write underflow by byte with tag check fault
ignore and mmap memory
# not ok 11 Check buffer write overflow by byte with sync mode and mmap mem=
ory
# not ok 12 Check buffer write overflow by byte with async mode and mmap me=
mory
# ok 13 Check buffer write overflow by byte with tag fault ignore mode
and mmap memory
# not ok 14 Check buffer write correctness by block with sync mode and
mmap memory
# not ok 15 Check buffer write correctness by block with async mode
and mmap memory
# ok 16 Check buffer write correctness by block with tag fault ignore
and mmap memory
# ok 17 Check initial tags with private mapping, sync error mode and mmap m=
emory
# ok 18 Check initial tags with private mapping, sync error mode and
mmap/mprotect memory
# ok 19 Check initial tags with shared mapping, sync error mode and mmap me=
mory
# ok 20 Check initial tags with shared mapping, sync error mode and
mmap/mprotect memory
# # Totals: pass:14 fail:6 xfail:0 xpass:0 skip:0 error:0
not ok 34 selftests: arm64: check_buffer_fill # exit=3D1


# selftests: arm64: check_child_memory
# 1..12
# not ok 1 Check child anonymous memory with private mapping, precise
mode and mmap memory
# not ok 2 Check child anonymous memory with shared mapping, precise
mode and mmap memory
# not ok 3 Check child anonymous memory with private mapping,
imprecise mode and mmap memory
# not ok 4 Check child anonymous memory with shared mapping, imprecise
mode and mmap memory
# not ok 5 Check child anonymous memory with private mapping, precise
mode and mmap/mprotect memory
# not ok 6 Check child anonymous memory with shared mapping, precise
mode and mmap/mprotect memory
# not ok 7 Check child file memory with private mapping, precise mode
and mmap memory
# not ok 8 Check child file memory with shared mapping, precise mode
and mmap memory
# not ok 9 Check child file memory with private mapping, imprecise
mode and mmap memory
# not ok 10 Check child file memory with shared mapping, imprecise
mode and mmap memory
# not ok 11 Check child file memory with private mapping, precise mode
and mmap/mprotect memory
# not ok 12 Check child file memory with shared mapping, precise mode
and mmap/mprotect memory
# # Totals: pass:0 fail:12 xfail:0 xpass:0 skip:0 error:0
not ok 35 selftests: arm64: check_child_memory # exit=3D1

# selftests: arm64: check_ksm_options
# 1..4
# # Invalid MTE synchronous exception caught!
not ok 37 selftests: arm64: check_ksm_options # exit=3D1


# selftests: arm64: check_mmap_options
# 1..22
# ok 1 Check anonymous memory with private mapping, sync error mode,
mmap memory and tag check off
# ok 2 Check file memory with private mapping, sync error mode,
mmap/mprotect memory and tag check off
# ok 3 Check anonymous memory with private mapping, no error mode,
mmap memory and tag check off
# ok 4 Check file memory with private mapping, no error mode,
mmap/mprotect memory and tag check off
# not ok 5 Check anonymous memory with private mapping, sync error
mode, mmap memory and tag check on
# not ok 6 Check anonymous memory with private mapping, sync error
mode, mmap/mprotect memory and tag check on
# not ok 7 Check anonymous memory with shared mapping, sync error
mode, mmap memory and tag check on
# not ok 8 Check anonymous memory with shared mapping, sync error
mode, mmap/mprotect memory and tag check on
# not ok 9 Check anonymous memory with private mapping, async error
mode, mmap memory and tag check on
# not ok 10 Check anonymous memory with private mapping, async error
mode, mmap/mprotect memory and tag check on
# not ok 11 Check anonymous memory with shared mapping, async error
mode, mmap memory and tag check on
# not ok 12 Check anonymous memory with shared mapping, async error
mode, mmap/mprotect memory and tag check on
# not ok 13 Check file memory with private mapping, sync error mode,
mmap memory and tag check on
# not ok 14 Check file memory with private mapping, sync error mode,
mmap/mprotect memory and tag check on
# not ok 15 Check file memory with shared mapping, sync error mode,
mmap memory and tag check on
# not ok 16 Check file memory with shared mapping, sync error mode,
mmap/mprotect memory and tag check on
# not ok 17 Check file memory with private mapping, async error mode,
mmap memory and tag check on
# not ok 18 Check file memory with private mapping, async error mode,
mmap/mprotect memory and tag check on
# not ok 19 Check file memory with shared mapping, async error mode,
mmap memory and tag check on
# not ok 20 Check file memory with shared mapping, async error mode,
mmap/mprotect memory and tag check on
# not ok 21 Check clear PROT_MTE flags with private mapping, sync
error mode and mmap memory
# not ok 22 Check clear PROT_MTE flags with private mapping and sync
error mode and mmap/mprotect memory
# # Totals: pass:4 fail:18 xfail:0 xpass:0 skip:0 error:0
not ok 38 selftests: arm64: check_mmap_options # exit=3D1


# selftests: arm64: check_tags_inclusion
# 1..4
# # No valid fault recorded for 0x500ffffb8b27000 in mode 1
# not ok 1 Check an included tag value with sync mode
# # No valid fault recorded for 0x400ffffb8b27000 in mode 1
# not ok 2 Check different included tags value with sync mode
# ok 3 Check none included tags value with sync mode
# # No valid fault recorded for 0xa00ffffb8b27000 in mode 1
# not ok 4 Check all included tags value with sync mode
# # Totals: pass:1 fail:3 xfail:0 xpass:0 skip:0 error:0
not ok 40 selftests: arm64: check_tags_inclusion # exit=3D1

Test logs,
https://lkft.validation.linaro.org/scheduler/job/6087664#L4865
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.162-951-g9096aabfe9e0/testrun/14329777/suite/kselftest-arm64/test/arm64_ch=
eck_tags_inclusion/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.162-951-g9096aabfe9e0/testrun/14329777/suite/kselftest-arm64/tests/
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.87-219-g60931c95bb6d/testrun/14329656/suite/kselftest-arm64/tests/

--
Linaro LKFT
https://lkft.linaro.org
