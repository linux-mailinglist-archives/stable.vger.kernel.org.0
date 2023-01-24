Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F4767948B
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 10:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjAXJwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 04:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjAXJwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 04:52:30 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DE0126C4
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 01:52:28 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id b81so7334751vkf.1
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 01:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUnO5OKgozAy5X6l5i6B7toBQVUiHuETYBImO6P1cR0=;
        b=GWIP0r/LpbICnhOVkC6C6ilC5acuMD6p39p8Arl5yGEI21bun8UtqaN5EB1WSSlfnr
         gFJCaYKSYFKEZnxuWNaoeXw+SxH4r/TxECE1SNgG4Y+klS8ub3lFXyiuAwIKs9niBwR3
         sr3EM92nCp3YYqcgZaf2J6k94ezHhlT+YSoe7pY9K4b3z1/8xlgUiQG77MElt4tXRlsM
         boqB6p6FEWGBJHAHMFpwm/wauSfrm/gU+JShEfiDbFBH7+1xb4rthBLVUidxoNayMphf
         hSMmh4+vr1bWxmSDZSg6reeEtTkpR7y99Oqkyjl3HiFMp20NDHYfqtaFhnkWJug+wm/q
         ODVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rUnO5OKgozAy5X6l5i6B7toBQVUiHuETYBImO6P1cR0=;
        b=iTAPGogtdFEdmmUAzBhv7qZ07mfgzi4lrDgThjK2quJa6c8FIlV95K950JSCuhv5oB
         mgEYESd4WZ7dvAMMkPHs2+UzjbKmkT59cV0z5auyiqIlvV9SNqvD5Ja2NkpaBx6Wz+0g
         Os66X23yxDOM11NUQijuph6GtxJTQc/NCzeg7gKIV86uMRONF3TQvSt9/3WKyrSt3ykO
         SReoWRMp43189Zb77WBAjveqP0OwM9TB/dzxrN8uUFyxb01YpXwOyPBd4gBBL7Nm1X+k
         R0t1wuuew/YNWprqgpQM2G2unRCA4VR7I3Jdc3Jb0/0nrYejL8GloXhUpiyFb/gFG2QC
         gjmw==
X-Gm-Message-State: AFqh2kofmJnjqJXcOYQ/cb6isCNgtBU6cbHQv6ZYkb8fJjTE3B7rvd9O
        SbSKd6y0XjTdngsw6+If7hJz0s61JTVTA1AkyeEyGg==
X-Google-Smtp-Source: AMrXdXtFQ2MkrzXbgoItDsdaklNfubkbqRXTcX1E9AsP9u4MIaQkpEM4KRFY1Ts1EH2WqOxZl+Hxkeyp+lOQU3nolwk=
X-Received: by 2002:ac5:c76d:0:b0:3d9:98d3:3902 with SMTP id
 c13-20020ac5c76d000000b003d998d33902mr3460713vkn.39.1674553947319; Tue, 24
 Jan 2023 01:52:27 -0800 (PST)
MIME-Version: 1.0
References: <20230123094914.748265495@linuxfoundation.org>
In-Reply-To: <20230123094914.748265495@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Jan 2023 15:22:16 +0530
Message-ID: <CA+G9fYvgEEOkatUJB1p_DQuL1BcDyk9mq-3d-iUjgxhP+pONTw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 Jan 2023 at 15:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.165-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
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

We are in a process to bisect this problem and there are updates coming
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
