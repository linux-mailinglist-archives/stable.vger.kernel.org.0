Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFDA5375D0
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbiE3HsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 03:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiE3HsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 03:48:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA3A71D8B;
        Mon, 30 May 2022 00:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A0E060DF6;
        Mon, 30 May 2022 07:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721C8C385B8;
        Mon, 30 May 2022 07:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653896898;
        bh=ot8RSXY3LkZoLuZYtf8fmVq4D1Hc+uwtOXvjNEh/DhQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Wnj2llm7uuWhzgymdtTS14NE591yhQJNEGaC0rLfGdaHBbRp0TJRMbr8MilOfCRRI
         vVaFyI2zzYblxdLMTQ49MKCLhFRxhPVPfBPjs5l7Wz652Vyz9WQPhXcBpS5QzOjMOH
         Lp5l8gH5Hhm7MNWDDuxkup04JAK9MhZWVuxvCq3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.119
Date:   Mon, 30 May 2022 09:48:14 +0200
Message-Id: <165389689496142@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.119 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt |    6 
 Documentation/admin-guide/sysctl/kernel.rst     |   22 
 MAINTAINERS                                     |    2 
 Makefile                                        |    2 
 arch/alpha/include/asm/timex.h                  |    1 
 arch/arm/include/asm/timex.h                    |    1 
 arch/ia64/include/asm/timex.h                   |    1 
 arch/m68k/include/asm/timex.h                   |    2 
 arch/mips/include/asm/timex.h                   |   17 
 arch/nios2/include/asm/timex.h                  |    3 
 arch/parisc/include/asm/timex.h                 |    3 
 arch/powerpc/include/asm/timex.h                |    1 
 arch/riscv/include/asm/timex.h                  |    2 
 arch/s390/include/asm/timex.h                   |    1 
 arch/sparc/include/asm/timex_32.h               |    4 
 arch/um/include/asm/timex.h                     |    9 
 arch/x86/crypto/Makefile                        |    4 
 arch/x86/crypto/blake2s-glue.c                  |  166 -
 arch/x86/crypto/blake2s-shash.c                 |   77 
 arch/x86/include/asm/timex.h                    |    9 
 arch/x86/include/asm/tsc.h                      |    7 
 arch/x86/kernel/cpu/mshyperv.c                  |    2 
 arch/x86/kvm/lapic.c                            |    6 
 arch/x86/kvm/mmu/mmu.c                          |    6 
 arch/x86/kvm/x86.c                              |    2 
 arch/xtensa/include/asm/timex.h                 |    6 
 crypto/Kconfig                                  |    3 
 crypto/blake2s_generic.c                        |  158 -
 crypto/drbg.c                                   |   17 
 drivers/acpi/sysfs.c                            |   23 
 drivers/char/Kconfig                            |    3 
 drivers/char/hw_random/core.c                   |    1 
 drivers/char/random.c                           | 3035 ++++++++----------------
 drivers/hv/vmbus_drv.c                          |    2 
 drivers/media/test-drivers/vim2m.c              |   22 
 drivers/net/Kconfig                             |    1 
 drivers/net/wireguard/noise.c                   |   45 
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c  |    6 
 include/crypto/blake2s.h                        |   66 
 include/crypto/chacha.h                         |   15 
 include/crypto/drbg.h                           |    2 
 include/crypto/internal/blake2s.h               |  123 
 include/linux/cpuhotplug.h                      |    2 
 include/linux/hw_random.h                       |    2 
 include/linux/mm.h                              |    1 
 include/linux/prandom.h                         |   23 
 include/linux/random.h                          |  100 
 include/linux/security.h                        |    2 
 include/linux/siphash.h                         |   28 
 include/linux/timex.h                           |   10 
 include/net/inet_hashtables.h                   |    2 
 include/net/secure_seq.h                        |    4 
 include/trace/events/random.h                   |  330 --
 init/main.c                                     |   13 
 kernel/cpu.c                                    |   11 
 kernel/debug/debug_core.c                       |   24 
 kernel/debug/kdb/kdb_main.c                     |   62 
 kernel/irq/handle.c                             |    2 
 kernel/time/timekeeping.c                       |   15 
 lib/Kconfig.debug                               |    3 
 lib/crypto/Kconfig                              |   23 
 lib/crypto/Makefile                             |    9 
 lib/crypto/blake2s-generic.c                    |    6 
 lib/crypto/blake2s-selftest.c                   |   33 
 lib/crypto/blake2s.c                            |   81 
 lib/random32.c                                  |   16 
 lib/sha1.c                                      |   95 
 lib/siphash.c                                   |   32 
 lib/vsprintf.c                                  |   10 
 mm/util.c                                       |   32 
 net/core/secure_seq.c                           |    4 
 net/ipv4/inet_hashtables.c                      |   28 
 net/ipv6/inet6_hashtables.c                     |    4 
 security/security.c                             |    2 
 sound/pci/ctxfi/ctatc.c                         |    2 
 sound/pci/ctxfi/cthardware.h                    |    3 
 76 files changed, 1864 insertions(+), 3034 deletions(-)

Andy Shevchenko (1):
      ACPI: sysfs: Make sparse happy about address space in use

Ard Biesheuvel (1):
      random: avoid arch_get_random_seed_long() when collecting IRQ randomness

Daniel Thompson (1):
      lockdown: also lock down previous kgdb use

Denis Efremov (Oracle) (1):
      staging: rtl8723bs: prevent ->Ssid overflow in rtw_wx_set_scan()

Dominik Brodowski (7):
      random: harmonize "crng init done" messages
      random: early initialization of ChaCha constants
      random: continually use hwgenerator randomness
      random: access primary_pool directly rather than through pointer
      random: only call crng_finalize_init() for primary_crng
      random: fix locking in crng_fast_load()
      random: fix locking for crng_init in crng_reseed()

Edward Matijevic (1):
      ALSA: ctxfi: Add SB046x PCI ID

Eric Biggers (11):
      random: remove dead code left over from blocking pool
      crypto: blake2s - define shash_alg structs using macros
      crypto: x86/blake2s - define shash_alg structs using macros
      crypto: blake2s - remove unneeded includes
      crypto: blake2s - move update and final logic to internal/blake2s.h
      crypto: blake2s - share the "shash" API boilerplate code
      crypto: blake2s - optimize blake2s initialization
      crypto: blake2s - add comment for blake2s_state fields
      crypto: blake2s - adjust include guard naming
      crypto: blake2s - include <linux/bug.h> instead of <asm/bug.h>
      random: remove use_input_pool parameter from crng_reseed()

Eric Dumazet (1):
      tcp: change source port randomizarion at connect() time

Greg Kroah-Hartman (1):
      Linux 5.10.119

Hans Verkuil (1):
      media: vim2m: initialize the media device earlier

Herbert Xu (1):
      crypto: lib/blake2s - Move selftest prototype into header file

Jan Varho (1):
      random: do not split fast init input in add_hwgenerator_randomness()

Jann Horn (2):
      random: don't reset crng_init_cnt on urandom_read()
      random: check for signal_pending() outside of need_resched() check

Jason A. Donenfeld (123):
      MAINTAINERS: co-maintain random.c
      MAINTAINERS: add git tree for random.c
      lib/crypto: blake2s: include as built-in
      lib/crypto: blake2s: move hmac construction into wireguard
      lib/crypto: sha1: re-roll loops to reduce code size
      lib/crypto: blake2s: avoid indirect calls to compression function for Clang CFI
      random: use BLAKE2s instead of SHA1 in extraction
      random: do not sign extend bytes for rotation when mixing
      random: do not re-init if crng_reseed completes before primary init
      random: mix bootloader randomness into pool
      random: use IS_ENABLED(CONFIG_NUMA) instead of ifdefs
      random: avoid superfluous call to RDRAND in CRNG extraction
      random: cleanup poolinfo abstraction
      random: cleanup integer types
      random: remove incomplete last_data logic
      random: remove unused extract_entropy() reserved argument
      random: rather than entropy_store abstraction, use global
      random: remove unused OUTPUT_POOL constants
      random: de-duplicate INPUT_POOL constants
      random: prepend remaining pool constants with POOL_
      random: cleanup fractional entropy shift constants
      random: access input_pool_data directly rather than through pointer
      random: selectively clang-format where it makes sense
      random: simplify arithmetic function flow in account()
      random: use computational hash for entropy extraction
      random: simplify entropy debiting
      random: use linear min-entropy accumulation crediting
      random: always wake up entropy writers after extraction
      random: make credit_entropy_bits() always safe
      random: remove batched entropy locking
      random: use RDSEED instead of RDRAND in entropy extraction
      random: get rid of secondary crngs
      random: inline leaves of rand_initialize()
      random: ensure early RDSEED goes through mixer on init
      random: do not xor RDRAND when writing into /dev/random
      random: absorb fast pool into input pool after fast load
      random: use simpler fast key erasure flow on per-cpu keys
      random: use hash function for crng_slow_load()
      random: make more consistent use of integer types
      random: remove outdated INT_MAX >> 6 check in urandom_read()
      random: zero buffer after reading entropy from userspace
      random: tie batched entropy generation to base_crng generation
      random: remove ifdef'd out interrupt bench
      random: remove unused tracepoints
      random: add proper SPDX header
      random: deobfuscate irq u32/u64 contributions
      random: introduce drain_entropy() helper to declutter crng_reseed()
      random: remove useless header comment
      random: remove whitespace and reorder includes
      random: group initialization wait functions
      random: group crng functions
      random: group entropy extraction functions
      random: group entropy collection functions
      random: group userspace read/write functions
      random: group sysctl functions
      random: rewrite header introductory comment
      random: defer fast pool mixing to worker
      random: do not take pool spinlock at boot
      random: unify early init crng load accounting
      random: check for crng_init == 0 in add_device_randomness()
      random: pull add_hwgenerator_randomness() declaration into random.h
      random: clear fast pool, crng, and batches in cpuhp bring up
      random: round-robin registers as ulong, not u32
      random: only wake up writers after zap if threshold was passed
      random: cleanup UUID handling
      random: unify cycles_t and jiffies usage and types
      random: do crng pre-init loading in worker rather than irq
      random: give sysctl_random_min_urandom_seed a more sensible value
      random: don't let 644 read-only sysctls be written to
      random: replace custom notifier chain with standard one
      random: use SipHash as interrupt entropy accumulator
      random: make consistent usage of crng_ready()
      random: reseed more often immediately after booting
      random: check for signal and try earlier when generating entropy
      random: skip fast_init if hwrng provides large chunk of entropy
      random: treat bootloader trust toggle the same way as cpu trust toggle
      random: re-add removed comment about get_random_{u32,u64} reseeding
      random: mix build-time latent entropy into pool at init
      random: do not allow user to keep crng key around on stack
      random: check for signals every PAGE_SIZE chunk of /dev/[u]random
      random: allow partial reads if later user copies fail
      random: make random_get_entropy() return an unsigned long
      random: document crng_fast_key_erasure() destination possibility
      random: fix sysctl documentation nits
      init: call time_init() before rand_initialize()
      ia64: define get_cycles macro for arch-override
      s390: define get_cycles macro for arch-override
      parisc: define get_cycles macro for arch-override
      alpha: define get_cycles macro for arch-override
      powerpc: define get_cycles macro for arch-override
      timekeeping: Add raw clock fallback for random_get_entropy()
      m68k: use fallback for random_get_entropy() instead of zero
      riscv: use fallback for random_get_entropy() instead of zero
      mips: use fallback for random_get_entropy() instead of just c0 random
      arm: use fallback for random_get_entropy() instead of zero
      nios2: use fallback for random_get_entropy() instead of zero
      x86/tsc: Use fallback for random_get_entropy() instead of zero
      um: use fallback for random_get_entropy() instead of zero
      sparc: use fallback for random_get_entropy() instead of zero
      xtensa: use fallback for random_get_entropy() instead of zero
      random: insist on random_get_entropy() existing in order to simplify
      random: do not use batches when !crng_ready()
      random: use first 128 bits of input as fast init
      random: do not pretend to handle premature next security model
      random: order timer entropy functions below interrupt functions
      random: do not use input pool from hard IRQs
      random: help compiler out with fast_mix() by using simpler arguments
      siphash: use one source of truth for siphash permutations
      random: use symbolic constants for crng_init states
      random: avoid initializing twice in credit race
      random: move initialization out of reseeding hot path
      random: remove ratelimiting for in-kernel unseeded randomness
      random: use proper jiffies comparison macro
      random: handle latent entropy and command line from random_init()
      random: credit architectural init the exact amount
      random: use static branch for crng_ready()
      random: remove extern from functions in header
      random: use proper return types on get_random_{int,long}_wait()
      random: make consistent use of buf and len
      random: move initialization functions out of hot pages
      random: move randomize_page() into mm where it belongs
      random: unify batched entropy implementations
      random: check for signals after page of pool writes

Jens Axboe (3):
      random: convert to using fops->read_iter()
      random: convert to using fops->write_iter()
      random: wire up fops->splice_{read,write}_iter()

Lorenzo Pieralisi (1):
      ACPI: sysfs: Fix BERT error region memory mapping

Mark Brown (1):
      random: document add_hwgenerator_randomness() with other input functions

Paolo Bonzini (1):
      KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID

Sakari Ailus (1):
      media: vim2m: Register video device after setting up internals

Schspa Shi (1):
      random: fix typo in comments

Sebastian Andrzej Siewior (1):
      random: remove unused irq_flags argument from add_interrupt_randomness()

Vitaly Kuznetsov (1):
      KVM: x86: Properly handle APF vs disabled LAPIC situation

Willy Tarreau (1):
      secure_seq: use the 64 bits of the siphash for port offset calculation

