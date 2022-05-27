Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A7535C00
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 10:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349578AbiE0IwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350051AbiE0Ivs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:51:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C178950468;
        Fri, 27 May 2022 01:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3292D61C01;
        Fri, 27 May 2022 08:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABF8C34100;
        Fri, 27 May 2022 08:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641492;
        bh=q3CWuzWMjRg/iU34qkqz18uueCNJC3z0Imc5Ott3hP8=;
        h=From:To:Cc:Subject:Date:From;
        b=m9bPqocIjfHxE8H0o6IkggVrJPbIxskyALZqVo1DERjpAhAzgOoZzaezrP/Wjo5MV
         DufEuBjipv7J4eqEBwUT+W46+IWJczJlgjr4nRNeYJ0lQGEQTOSdmnjM/Ktvq6hlJg
         RjHZjkqit5sauU21J1h0NwSKQzbR8IgKMGQ9JJS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/145] 5.15.44-rc1 review
Date:   Fri, 27 May 2022 10:48:21 +0200
Message-Id: <20220527084850.364560116@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.44-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.44-rc1
X-KernelTest-Deadline: 2022-05-29T08:49+00:00
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

This is the start of the stable review cycle for the 5.15.44 release.
There are 145 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 29 May 2022 08:46:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.44-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.44-rc1

Edward Matijevic <motolav@gmail.com>
    ALSA: ctxfi: Add SB046x PCI ID

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

Jason A. Donenfeld <Jason@zx2c4.com>
    random: document crng_fast_key_erasure() destination possibility

Jason A. Donenfeld <Jason@zx2c4.com>
    random: make random_get_entropy() return an unsigned long

Jason A. Donenfeld <Jason@zx2c4.com>
    random: allow partial reads if later user copies fail

Jason A. Donenfeld <Jason@zx2c4.com>
    random: check for signals every PAGE_SIZE chunk of /dev/[u]random

Jann Horn <jannh@google.com>
    random: check for signal_pending() outside of need_resched() check

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not allow user to keep crng key around on stack

Jan Varho <jan.varho@gmail.com>
    random: do not split fast init input in add_hwgenerator_randomness()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: mix build-time latent entropy into pool at init

Jason A. Donenfeld <Jason@zx2c4.com>
    random: re-add removed comment about get_random_{u32,u64} reseeding

Jason A. Donenfeld <Jason@zx2c4.com>
    random: treat bootloader trust toggle the same way as cpu trust toggle

Jason A. Donenfeld <Jason@zx2c4.com>
    random: skip fast_init if hwrng provides large chunk of entropy

Jason A. Donenfeld <Jason@zx2c4.com>
    random: check for signal and try earlier when generating entropy

Jason A. Donenfeld <Jason@zx2c4.com>
    random: reseed more often immediately after booting

Jason A. Donenfeld <Jason@zx2c4.com>
    random: make consistent usage of crng_ready()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use SipHash as interrupt entropy accumulator

Jason A. Donenfeld <Jason@zx2c4.com>
    random: replace custom notifier chain with standard one

Jason A. Donenfeld <Jason@zx2c4.com>
    random: don't let 644 read-only sysctls be written to

Jason A. Donenfeld <Jason@zx2c4.com>
    random: give sysctl_random_min_urandom_seed a more sensible value

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do crng pre-init loading in worker rather than irq

Jason A. Donenfeld <Jason@zx2c4.com>
    random: unify cycles_t and jiffies usage and types

Jason A. Donenfeld <Jason@zx2c4.com>
    random: cleanup UUID handling

Jason A. Donenfeld <Jason@zx2c4.com>
    random: only wake up writers after zap if threshold was passed

Jason A. Donenfeld <Jason@zx2c4.com>
    random: round-robin registers as ulong, not u32

Jason A. Donenfeld <Jason@zx2c4.com>
    random: clear fast pool, crng, and batches in cpuhp bring up

Jason A. Donenfeld <Jason@zx2c4.com>
    random: pull add_hwgenerator_randomness() declaration into random.h

Jason A. Donenfeld <Jason@zx2c4.com>
    random: check for crng_init == 0 in add_device_randomness()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: unify early init crng load accounting

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not take pool spinlock at boot

Jason A. Donenfeld <Jason@zx2c4.com>
    random: defer fast pool mixing to worker

Jason A. Donenfeld <Jason@zx2c4.com>
    random: rewrite header introductory comment

Jason A. Donenfeld <Jason@zx2c4.com>
    random: group sysctl functions

Jason A. Donenfeld <Jason@zx2c4.com>
    random: group userspace read/write functions

Jason A. Donenfeld <Jason@zx2c4.com>
    random: group entropy collection functions

Jason A. Donenfeld <Jason@zx2c4.com>
    random: group entropy extraction functions

Jason A. Donenfeld <Jason@zx2c4.com>
    random: group crng functions

Jason A. Donenfeld <Jason@zx2c4.com>
    random: group initialization wait functions

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove whitespace and reorder includes

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove useless header comment

Jason A. Donenfeld <Jason@zx2c4.com>
    random: introduce drain_entropy() helper to declutter crng_reseed()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: deobfuscate irq u32/u64 contributions

Jason A. Donenfeld <Jason@zx2c4.com>
    random: add proper SPDX header

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove unused tracepoints

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove ifdef'd out interrupt bench

Jason A. Donenfeld <Jason@zx2c4.com>
    random: tie batched entropy generation to base_crng generation

Dominik Brodowski <linux@dominikbrodowski.net>
    random: fix locking for crng_init in crng_reseed()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: zero buffer after reading entropy from userspace

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove outdated INT_MAX >> 6 check in urandom_read()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: make more consistent use of integer types

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use hash function for crng_slow_load()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use simpler fast key erasure flow on per-cpu keys

Jason A. Donenfeld <Jason@zx2c4.com>
    random: absorb fast pool into input pool after fast load

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not xor RDRAND when writing into /dev/random

Jason A. Donenfeld <Jason@zx2c4.com>
    random: ensure early RDSEED goes through mixer on init

Jason A. Donenfeld <Jason@zx2c4.com>
    random: inline leaves of rand_initialize()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: get rid of secondary crngs

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use RDSEED instead of RDRAND in entropy extraction

Dominik Brodowski <linux@dominikbrodowski.net>
    random: fix locking in crng_fast_load()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove batched entropy locking

Eric Biggers <ebiggers@google.com>
    random: remove use_input_pool parameter from crng_reseed()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: make credit_entropy_bits() always safe

Jason A. Donenfeld <Jason@zx2c4.com>
    random: always wake up entropy writers after extraction

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use linear min-entropy accumulation crediting

Jason A. Donenfeld <Jason@zx2c4.com>
    random: simplify entropy debiting

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use computational hash for entropy extraction

Dominik Brodowski <linux@dominikbrodowski.net>
    random: only call crng_finalize_init() for primary_crng

Dominik Brodowski <linux@dominikbrodowski.net>
    random: access primary_pool directly rather than through pointer

Dominik Brodowski <linux@dominikbrodowski.net>
    random: continually use hwgenerator randomness

Jason A. Donenfeld <Jason@zx2c4.com>
    random: simplify arithmetic function flow in account()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: selectively clang-format where it makes sense

Jason A. Donenfeld <Jason@zx2c4.com>
    random: access input_pool_data directly rather than through pointer

Jason A. Donenfeld <Jason@zx2c4.com>
    random: cleanup fractional entropy shift constants

Jason A. Donenfeld <Jason@zx2c4.com>
    random: prepend remaining pool constants with POOL_

Jason A. Donenfeld <Jason@zx2c4.com>
    random: de-duplicate INPUT_POOL constants

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove unused OUTPUT_POOL constants

Jason A. Donenfeld <Jason@zx2c4.com>
    random: rather than entropy_store abstraction, use global

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove unused extract_entropy() reserved argument

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove incomplete last_data logic

Jason A. Donenfeld <Jason@zx2c4.com>
    random: cleanup integer types

Jason A. Donenfeld <Jason@zx2c4.com>
    random: cleanup poolinfo abstraction

Schspa Shi <schspa@gmail.com>
    random: fix typo in comments

Jann Horn <jannh@google.com>
    random: don't reset crng_init_cnt on urandom_read()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: avoid superfluous call to RDRAND in CRNG extraction

Dominik Brodowski <linux@dominikbrodowski.net>
    random: early initialization of ChaCha constants

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use IS_ENABLED(CONFIG_NUMA) instead of ifdefs

Dominik Brodowski <linux@dominikbrodowski.net>
    random: harmonize "crng init done" messages

Jason A. Donenfeld <Jason@zx2c4.com>
    random: mix bootloader randomness into pool

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not re-init if crng_reseed completes before primary init

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not sign extend bytes for rotation when mixing

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use BLAKE2s instead of SHA1 in extraction

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    random: remove unused irq_flags argument from add_interrupt_randomness()

Mark Brown <broonie@kernel.org>
    random: document add_hwgenerator_randomness() with other input functions

Jason A. Donenfeld <Jason@zx2c4.com>
    lib/crypto: blake2s: avoid indirect calls to compression function for Clang CFI

Jason A. Donenfeld <Jason@zx2c4.com>
    lib/crypto: sha1: re-roll loops to reduce code size

Jason A. Donenfeld <Jason@zx2c4.com>
    lib/crypto: blake2s: move hmac construction into wireguard

Jason A. Donenfeld <Jason@zx2c4.com>
    lib/crypto: blake2s: include as built-in

Jason A. Donenfeld <Jason@zx2c4.com>
    MAINTAINERS: add git tree for random.c

Jason A. Donenfeld <Jason@zx2c4.com>
    MAINTAINERS: co-maintain random.c

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    ACPI: sysfs: Fix BERT error region memory mapping

Magnus Karlsson <magnus.karlsson@intel.com>
    ice: fix crash at allocation failure

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Add support for sensor discovery


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt |    6 +
 Documentation/admin-guide/sysctl/kernel.rst     |   22 +-
 MAINTAINERS                                     |    2 +
 Makefile                                        |    4 +-
 arch/alpha/include/asm/timex.h                  |    1 +
 arch/arm/crypto/Makefile                        |    4 +-
 arch/arm/crypto/blake2s-core.S                  |    8 +-
 arch/arm/crypto/blake2s-glue.c                  |   73 +-
 arch/arm/crypto/blake2s-shash.c                 |   75 +
 arch/arm/include/asm/timex.h                    |    1 +
 arch/ia64/include/asm/timex.h                   |    1 +
 arch/m68k/include/asm/timex.h                   |    2 +-
 arch/mips/include/asm/timex.h                   |   17 +-
 arch/nios2/include/asm/timex.h                  |    3 +
 arch/parisc/include/asm/timex.h                 |    3 +-
 arch/powerpc/include/asm/timex.h                |    1 +
 arch/riscv/include/asm/timex.h                  |    2 +-
 arch/s390/include/asm/timex.h                   |    1 +
 arch/sparc/include/asm/timex_32.h               |    4 +-
 arch/um/include/asm/timex.h                     |    9 +-
 arch/x86/crypto/Makefile                        |    4 +-
 arch/x86/crypto/blake2s-glue.c                  |   68 +-
 arch/x86/crypto/blake2s-shash.c                 |   77 +
 arch/x86/include/asm/timex.h                    |    9 +
 arch/x86/include/asm/tsc.h                      |    7 +-
 arch/x86/kernel/cpu/mshyperv.c                  |    2 +-
 arch/x86/kvm/mmu/mmu.c                          |    6 +-
 arch/xtensa/include/asm/timex.h                 |    6 +-
 crypto/Kconfig                                  |    3 +-
 crypto/blake2s_generic.c                        |    4 +-
 crypto/drbg.c                                   |   17 +-
 drivers/acpi/sysfs.c                            |   25 +-
 drivers/char/Kconfig                            |    3 +-
 drivers/char/hw_random/core.c                   |    1 +
 drivers/char/random.c                           | 3011 +++++++++--------------
 drivers/hid/amd-sfh-hid/amd_sfh_client.c        |   11 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c          |    7 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h          |    4 +
 drivers/hv/vmbus_drv.c                          |    2 +-
 drivers/net/Kconfig                             |    1 -
 drivers/net/ethernet/intel/ice/ice_xsk.c        |    2 +-
 drivers/net/wireguard/noise.c                   |   45 +-
 include/crypto/blake2s.h                        |    3 -
 include/crypto/chacha.h                         |   15 +-
 include/crypto/drbg.h                           |    2 +-
 include/crypto/internal/blake2s.h               |   46 +-
 include/linux/cpuhotplug.h                      |    2 +
 include/linux/hw_random.h                       |    2 -
 include/linux/mm.h                              |    1 +
 include/linux/prandom.h                         |   23 +-
 include/linux/random.h                          |  100 +-
 include/linux/siphash.h                         |   28 +
 include/linux/timex.h                           |   10 +-
 include/trace/events/random.h                   |  247 --
 init/main.c                                     |   13 +-
 kernel/cpu.c                                    |   11 +
 kernel/irq/handle.c                             |    2 +-
 kernel/time/timekeeping.c                       |   15 +
 lib/Kconfig.debug                               |    3 +-
 lib/crypto/Kconfig                              |   23 +-
 lib/crypto/Makefile                             |    9 +-
 lib/crypto/blake2s-generic.c                    |    6 +-
 lib/crypto/blake2s-selftest.c                   |   31 -
 lib/crypto/blake2s.c                            |   47 +-
 lib/random32.c                                  |   16 +-
 lib/sha1.c                                      |   95 +-
 lib/siphash.c                                   |   32 +-
 lib/vsprintf.c                                  |   10 +-
 mm/util.c                                       |   32 +
 sound/pci/ctxfi/ctatc.c                         |    2 +
 sound/pci/ctxfi/cthardware.h                    |    3 +-
 71 files changed, 1683 insertions(+), 2700 deletions(-)


