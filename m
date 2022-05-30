Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F765375AA
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbiE3Hmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 03:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiE3Hm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 03:42:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4C422506;
        Mon, 30 May 2022 00:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3276760DBD;
        Mon, 30 May 2022 07:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9C6C385B8;
        Mon, 30 May 2022 07:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653896546;
        bh=4V3Dxg4XGka/xIkbvprYI40nHE/rzIqt3qY2VBICIu8=;
        h=From:To:Cc:Subject:Date:From;
        b=kRnNvp4WqTGe28eYnfdJypKjD7lJjXN6QuAWEuHddgqu4EJQd4Me0Z6YwsLIcMF2e
         lpOqk9LHLfm1dosU9AkvP1qh8+pA9QqZUrnoFjrqOnpieIBiFw6tspof+D9B+u7Dai
         HDcoNHj5GOhRXhETbJUlXsM7kYkbWstzhvbwGIjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.17.12
Date:   Mon, 30 May 2022 09:42:18 +0200
Message-Id: <165389653923247@kroah.com>
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

I'm announcing the release of the 5.17.12 kernel.

All users of the 5.17 kernel series must upgrade.

The updated 5.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.17.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt |    6 
 Documentation/admin-guide/sysctl/kernel.rst     |   22 
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
 arch/x86/include/asm/timex.h                    |    9 
 arch/x86/include/asm/tsc.h                      |    7 
 arch/x86/kvm/mmu/mmu.c                          |    6 
 arch/xtensa/include/asm/timex.h                 |    6 
 drivers/acpi/sysfs.c                            |   25 
 drivers/char/Kconfig                            |    3 
 drivers/char/hw_random/core.c                   |    1 
 drivers/char/random.c                           | 2868 +++++++++---------------
 drivers/hid/amd-sfh-hid/amd_sfh_client.c        |   11 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c          |    7 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h          |    4 
 include/linux/cpuhotplug.h                      |    2 
 include/linux/hw_random.h                       |    2 
 include/linux/mm.h                              |    1 
 include/linux/prandom.h                         |   23 
 include/linux/random.h                          |  100 
 include/linux/siphash.h                         |   28 
 include/linux/timex.h                           |   10 
 include/trace/events/random.h                   |  233 -
 init/main.c                                     |   13 
 kernel/cpu.c                                    |   11 
 kernel/time/timekeeping.c                       |   15 
 lib/Kconfig.debug                               |    3 
 lib/random32.c                                  |   14 
 lib/siphash.c                                   |   32 
 lib/vsprintf.c                                  |   10 
 mm/util.c                                       |   32 
 sound/pci/ctxfi/ctatc.c                         |    2 
 sound/pci/ctxfi/cthardware.h                    |    3 
 44 files changed, 1364 insertions(+), 2192 deletions(-)

Basavaraj Natikar (1):
      HID: amd_sfh: Add support for sensor discovery

Dominik Brodowski (2):
      random: fix locking in crng_fast_load()
      random: fix locking for crng_init in crng_reseed()

Edward Matijevic (1):
      ALSA: ctxfi: Add SB046x PCI ID

Eric Biggers (1):
      random: remove use_input_pool parameter from crng_reseed()

Greg Kroah-Hartman (1):
      Linux 5.17.12

Jan Varho (1):
      random: do not split fast init input in add_hwgenerator_randomness()

Jann Horn (1):
      random: check for signal_pending() outside of need_resched() check

Jason A. Donenfeld (99):
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

Paolo Bonzini (1):
      KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID

