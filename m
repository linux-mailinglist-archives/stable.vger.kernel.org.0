Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD6949B56D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 14:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385377AbiAYNzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 08:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577642AbiAYNs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 08:48:29 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A856C06173D
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 05:48:28 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id g14so61757683ybs.8
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 05:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=uH3eHj0HKrfTCBUHJOWRiZR8mF89gAKzpQ6InYBLGJ0=;
        b=eO4SbeMCjL39OobADkb4wTnFeU6ettJyvcCsd6s848zh2BUOoxxsbyIU9SiVSBPaBP
         mmbSd117Sr8Z80WweaKAblMWN4dW53KxY893mugB+u04Jx66Iyun31PpwDIg6rLLlCJF
         ytuo079KWwL4QjKinHnBajklTXReEsaN1MOH6mKWFymy4Stj9Kid4vZLn+kHo40O8MDU
         uB8Hu+zAeYXIMc9m97jS9HiupPUY0XuDeirhfXd4CkxvhMTlIg8EIYtz9jStEGjtoL1t
         IuE8RivBEkAqgoon6hOdGmG9SKs+X1CnPJ3en4NqJ5yS8jmjjeuByByxh1eNaQPKi2vy
         lZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=uH3eHj0HKrfTCBUHJOWRiZR8mF89gAKzpQ6InYBLGJ0=;
        b=NuYMBaHk5zBssMzHG43NDuc2o44IX56XlXBWVTZMEo6YNIdxZgMzmcXFC3FgngULTn
         Fzd8R2exPpZtCYQOpRu6Y6cw4NblZJkCrl2gGThZzM7m3yE9+uFUvtDdEhmR8mkZdGHh
         GmDk8bBAfBEeMgxfaRT0TqImGvLOX4E4Iikbj6ZKAw2AOa90UmI0F0V1C5szqYZT1HQY
         RrcERpA7oAsA7/95j9GmEvT8Tz71Zs7upOyl7x2V+60Ru4hnpnZtbLHmBp7bHqUey+3O
         c4BqbxaiSi4TqbbrQZk1Mhcs/ERdTjSCcBVvFJGHxr7tj4r7fqqyTPhCzmKj8/fSjf6t
         HmuQ==
X-Gm-Message-State: AOAM531alrHyBwvvCgdIu7isJ3gaLpsomB6KQog52YtNVFCwDbt9hfDw
        1tViRbStk5+zPmNHlvnTWVzC9eiIpN3h25bnYB12zQ==
X-Google-Smtp-Source: ABdhPJzWJLRhy1k1mrB93HLFnph/H/yEdWdaRRjwMPmU0tgvn8BgYfXNvLvDv37t0TVwje9oHntj7BGzuPujZCC0wLQ=
X-Received: by 2002:a25:ada2:: with SMTP id z34mr22624463ybi.684.1643118507278;
 Tue, 25 Jan 2022 05:48:27 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Jan 2022 19:18:16 +0530
Message-ID: <CA+G9fYuxkfKF=+xebi5z8VodYoXa2G-Agxw49ftz9vck7MxP+Q@mail.gmail.com>
Subject: stable-rc 5.4 queue riscv tinyconfig build failed
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     lkft-triage@lists.linaro.org, linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Regression found on
stable-rc 5.4 queue riscv tinyconfig build failed.

Not sure which patch is causing build failures.
We will bisect and get back to you.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current LLVM_IAS=1 ARCH=riscv
CROSS_COMPILE=riscv64-linux-gnu- HOSTCC=clang CC=clang

In file included from /builds/linux/kernel/dma/mapping.c:8:
In file included from /builds/linux/include/linux/memblock.h:13:
In file included from /builds/linux/include/linux/mm.h:10:
In file included from /builds/linux/include/linux/gfp.h:6:
In file included from /builds/linux/include/linux/mmzone.h:8:
In file included from /builds/linux/include/linux/spinlock.h:51:
In file included from /builds/linux/include/linux/preempt.h:78:
In file included from ./arch/riscv/include/generated/asm/preempt.h:1:
In file included from /builds/linux/include/asm-generic/preempt.h:5:
In file included from /builds/linux/include/linux/thread_info.h:22:
/builds/linux/arch/riscv/include/asm/current.h:30:9: warning: variable
'tp' is uninitialized when used here [-Wuninitialized]
        return tp;
               ^~
/builds/linux/arch/riscv/include/asm/current.h:29:33: note: initialize
the variable 'tp' to silence this warning
        register struct task_struct *tp __asm__("tp");
                                       ^
                                        = NULL
clang: warning: argument unused during compilation: '-no-pie'
[-Wunused-command-line-argument]
In file included from /builds/linux/arch/riscv/kernel/cpu.c:7:
In file included from /builds/linux/include/linux/seq_file.h:8:
In file included from /builds/linux/include/linux/mutex.h:14:
/builds/linux/arch/riscv/include/asm/current.h:30:9: warning: variable
'tp' is uninitialized when used here [-Wuninitialized]
        return tp;
               ^~
/builds/linux/arch/riscv/include/asm/current.h:29:33: note: initialize
the variable 'tp' to silence this warning
        register struct task_struct *tp __asm__("tp");
                                       ^
                                        = NULL
1 warning generated.
1 warning generated.
1 warning generated.
1 warning generated.
<instantiation>:1:1: error: unrecognized instruction mnemonic
LOCAL _restore_kernel_tpsp
^
/builds/linux/arch/riscv/kernel/entry.S:163:2: note: while in macro
instantiation
 SAVE_ALL
 ^
<instantiation>:2:2: error: unrecognized instruction mnemonic
 LOCAL _save_context
 ^

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


--
Linaro LKFT
https://lkft.linaro.org
