Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A12535C21
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 10:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349975AbiE0Iv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349987AbiE0IvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:51:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22452AC53;
        Fri, 27 May 2022 01:51:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8D87CCE234D;
        Fri, 27 May 2022 08:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FB6C385A9;
        Fri, 27 May 2022 08:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641474;
        bh=IGOsXSlnt3oTDeRyqlMES/yY6b1S4ruEp2zGgq9n+5Q=;
        h=From:To:Cc:Subject:Date:From;
        b=OimFunxxkQm0fLeLFAsRw86vPPDm7sQLd5Un48LXmCVYOT4rsR0db0nes3WHfjKfH
         exT9O76GCbDT7lvhPkyQRFo+M59jCSpXZEZptOLgayk+AF7TTf3HeHwU8IZutqu28p
         h1zYoKQUz1Oz7Pi7f/GNcMr070xTG2zxLaojyP/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 00/47] 5.18.1-rc1 review
Date:   Fri, 27 May 2022 10:49:40 +0200
Message-Id: <20220527084801.223648383@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.1-rc1
X-KernelTest-Deadline: 2022-05-29T08:48+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.18.1 release.
There are 47 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 29 May 2022 08:46:45 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.1-rc1

Edward Matijevic <motolav@gmail.com>
    ALSA: ctxfi: Add SB046x PCI ID

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    ACPI: sysfs: Fix BERT error region memory mapping

Jason A. Donenfeld <Jason@zx2c4.com>
    random: check for signals after page of pool writes

Jens Axboe <axboe@kernel.dk>
    random: wire up fops->splice_{read,write}_iter()

Jens Axboe <axboe@kernel.dk>
    random: convert to using fops->write_iter()

Jens Axboe <axboe@kernel.dk>
    random: convert to using fops->read_iter()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: unify batched entropy implementations

Jason A. Donenfeld <Jason@zx2c4.com>
    random: move randomize_page() into mm where it belongs

Jason A. Donenfeld <Jason@zx2c4.com>
    random: move initialization functions out of hot pages

Jason A. Donenfeld <Jason@zx2c4.com>
    random: make consistent use of buf and len

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use proper return types on get_random_{int,long}_wait()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove extern from functions in header

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use static branch for crng_ready()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: credit architectural init the exact amount

Jason A. Donenfeld <Jason@zx2c4.com>
    random: handle latent entropy and command line from random_init()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use proper jiffies comparison macro

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove ratelimiting for in-kernel unseeded randomness

Jason A. Donenfeld <Jason@zx2c4.com>
    random: move initialization out of reseeding hot path

Jason A. Donenfeld <Jason@zx2c4.com>
    random: avoid initializing twice in credit race

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use symbolic constants for crng_init states

Jason A. Donenfeld <Jason@zx2c4.com>
    siphash: use one source of truth for siphash permutations

Jason A. Donenfeld <Jason@zx2c4.com>
    random: help compiler out with fast_mix() by using simpler arguments

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not use input pool from hard IRQs

Jason A. Donenfeld <Jason@zx2c4.com>
    random: order timer entropy functions below interrupt functions

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not pretend to handle premature next security model

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use first 128 bits of input as fast init

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not use batches when !crng_ready()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: insist on random_get_entropy() existing in order to simplify

Jason A. Donenfeld <Jason@zx2c4.com>
    xtensa: use fallback for random_get_entropy() instead of zero

Jason A. Donenfeld <Jason@zx2c4.com>
    sparc: use fallback for random_get_entropy() instead of zero

Jason A. Donenfeld <Jason@zx2c4.com>
    um: use fallback for random_get_entropy() instead of zero

Jason A. Donenfeld <Jason@zx2c4.com>
    x86/tsc: Use fallback for random_get_entropy() instead of zero

Jason A. Donenfeld <Jason@zx2c4.com>
    nios2: use fallback for random_get_entropy() instead of zero

Jason A. Donenfeld <Jason@zx2c4.com>
    arm: use fallback for random_get_entropy() instead of zero

Jason A. Donenfeld <Jason@zx2c4.com>
    mips: use fallback for random_get_entropy() instead of just c0 random

Jason A. Donenfeld <Jason@zx2c4.com>
    riscv: use fallback for random_get_entropy() instead of zero

Jason A. Donenfeld <Jason@zx2c4.com>
    m68k: use fallback for random_get_entropy() instead of zero

Jason A. Donenfeld <Jason@zx2c4.com>
    timekeeping: Add raw clock fallback for random_get_entropy()

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc: define get_cycles macro for arch-override

Jason A. Donenfeld <Jason@zx2c4.com>
    alpha: define get_cycles macro for arch-override

Jason A. Donenfeld <Jason@zx2c4.com>
    parisc: define get_cycles macro for arch-override

Jason A. Donenfeld <Jason@zx2c4.com>
    s390: define get_cycles macro for arch-override

Jason A. Donenfeld <Jason@zx2c4.com>
    ia64: define get_cycles macro for arch-override

Jason A. Donenfeld <Jason@zx2c4.com>
    init: call time_init() before rand_initialize()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: fix sysctl documentation nits

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Add support for sensor discovery

Daniel Thompson <daniel.thompson@linaro.org>
    lockdown: also lock down previous kgdb use


-------------

Diffstat:

 Documentation/admin-guide/sysctl/kernel.rst |    8 +-
 Makefile                                    |    4 +-
 arch/alpha/include/asm/timex.h              |    1 +
 arch/arm/include/asm/timex.h                |    1 +
 arch/ia64/include/asm/timex.h               |    1 +
 arch/m68k/include/asm/timex.h               |    2 +-
 arch/mips/include/asm/timex.h               |   17 +-
 arch/nios2/include/asm/timex.h              |    3 +
 arch/parisc/include/asm/timex.h             |    3 +-
 arch/powerpc/include/asm/timex.h            |    1 +
 arch/riscv/include/asm/timex.h              |    2 +-
 arch/s390/include/asm/timex.h               |    1 +
 arch/sparc/include/asm/timex_32.h           |    4 +-
 arch/um/include/asm/timex.h                 |    9 +-
 arch/x86/include/asm/timex.h                |    9 +
 arch/x86/include/asm/tsc.h                  |    7 +-
 arch/xtensa/include/asm/timex.h             |    6 +-
 drivers/acpi/sysfs.c                        |   25 +-
 drivers/char/random.c                       | 1213 +++++++++++----------------
 drivers/hid/amd-sfh-hid/amd_sfh_client.c    |   11 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c      |    7 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h      |    4 +
 include/linux/mm.h                          |    1 +
 include/linux/prandom.h                     |   23 +-
 include/linux/random.h                      |   92 +-
 include/linux/security.h                    |    2 +
 include/linux/siphash.h                     |   28 +
 include/linux/timex.h                       |    8 +
 init/main.c                                 |   13 +-
 kernel/debug/debug_core.c                   |   24 +
 kernel/debug/kdb/kdb_main.c                 |   62 +-
 kernel/time/timekeeping.c                   |   15 +
 lib/Kconfig.debug                           |    3 +-
 lib/siphash.c                               |   32 +-
 mm/util.c                                   |   32 +
 security/security.c                         |    2 +
 sound/pci/ctxfi/ctatc.c                     |    2 +
 sound/pci/ctxfi/cthardware.h                |    3 +-
 38 files changed, 821 insertions(+), 860 deletions(-)


