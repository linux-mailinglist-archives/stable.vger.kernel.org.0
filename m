Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9937C554A23
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiFVMhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 08:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242186AbiFVMhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 08:37:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A78D39B81;
        Wed, 22 Jun 2022 05:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B854A6199C;
        Wed, 22 Jun 2022 12:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B96C34114;
        Wed, 22 Jun 2022 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655901440;
        bh=UB4tTHs2srU07dZtqTR00LmMVAqfemHlW1pwbvJSvSE=;
        h=From:To:Cc:Subject:Date:From;
        b=0X11mBVNWLQUrfu35uquzFZPjAuobtkwsU08XGYtDefco39PB6Y9XagOppmEKW0PQ
         BbrsEFpQkz0+rvGw5Yxl9Q0vQogaebfc+fTqd1pL9rsHwDzJnwFg32ZkBUDuzlxupY
         34d3qbJufgUMLe2VSFRFu6LADRH85Ycnk65rGoRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.200
Date:   Wed, 22 Jun 2022 14:37:15 +0200
Message-Id: <16559014367142@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

I'm announcing the release of the 5.4.200 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt    |    6 
 Documentation/admin-guide/sysctl/kernel.rst        |   35 
 MAINTAINERS                                        |    1 
 Makefile                                           |    2 
 arch/alpha/include/asm/timex.h                     |    1 
 arch/arm/include/asm/timex.h                       |    1 
 arch/arm64/include/asm/brk-imm.h                   |    2 
 arch/arm64/include/asm/debug-monitors.h            |    1 
 arch/arm64/include/asm/kprobes.h                   |    2 
 arch/arm64/kernel/ftrace.c                         |    4 
 arch/arm64/kernel/probes/kprobes.c                 |   69 
 arch/ia64/include/asm/timex.h                      |    1 
 arch/m68k/include/asm/timex.h                      |    2 
 arch/mips/include/asm/timex.h                      |   17 
 arch/nios2/include/asm/timex.h                     |    3 
 arch/parisc/include/asm/timex.h                    |    3 
 arch/powerpc/include/asm/archrandom.h              |   27 
 arch/powerpc/include/asm/ppc-opcode.h              |    2 
 arch/powerpc/include/asm/timex.h                   |    1 
 arch/powerpc/kernel/idle_6xx.S                     |    2 
 arch/powerpc/kernel/l2cr_6xx.S                     |    6 
 arch/powerpc/kernel/process.c                      |    4 
 arch/powerpc/kernel/swsusp_32.S                    |    2 
 arch/powerpc/kernel/swsusp_asm64.S                 |    2 
 arch/powerpc/mm/mmu_context.c                      |    2 
 arch/powerpc/platforms/powermac/cache.S            |    4 
 arch/riscv/include/asm/asm-prototypes.h            |    4 
 arch/riscv/include/asm/processor.h                 |    2 
 arch/riscv/lib/tishift.S                           |   75 
 arch/s390/include/asm/archrandom.h                 |   12 
 arch/s390/include/asm/timex.h                      |    1 
 arch/sparc/include/asm/timex_32.h                  |    4 
 arch/um/include/asm/timex.h                        |    9 
 arch/x86/include/asm/archrandom.h                  |   12 
 arch/x86/include/asm/timex.h                       |    9 
 arch/x86/include/asm/tsc.h                         |    7 
 arch/x86/kernel/cpu/mshyperv.c                     |    2 
 arch/xtensa/include/asm/timex.h                    |    6 
 certs/blacklist_hashes.c                           |    2 
 crypto/drbg.c                                      |  135 
 drivers/ata/libata-core.c                          |    4 
 drivers/char/Kconfig                               |   53 
 drivers/char/hw_random/core.c                      |    1 
 drivers/char/random.c                              | 3213 +++++++--------------
 drivers/clocksource/hyperv_timer.c                 |    1 
 drivers/hv/vmbus_drv.c                             |    2 
 drivers/i2c/busses/i2c-designware-common.c         |    3 
 drivers/i2c/busses/i2c-designware-platdrv.c        |   13 
 drivers/irqchip/irq-gic-realview.c                 |    1 
 drivers/irqchip/irq-gic-v3.c                       |    7 
 drivers/md/dm-log.c                                |    3 
 drivers/misc/atmel-ssc.c                           |    4 
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   25 
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    5 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   21 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h |    2 
 drivers/nfc/nfcmrvl/usb.c                          |   16 
 drivers/nfc/st21nfca/se.c                          |   61 
 drivers/scsi/ipr.c                                 |    4 
 drivers/scsi/lpfc/lpfc_hw4.h                       |    3 
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |    3 
 drivers/scsi/lpfc/lpfc_nvme.c                      |   11 
 drivers/scsi/pmcraid.c                             |    2 
 drivers/scsi/vmw_pvscsi.h                          |    4 
 drivers/staging/comedi/drivers/vmk80xx.c           |    2 
 drivers/tty/goldfish.c                             |    2 
 drivers/tty/serial/8250/8250_port.c                |    2 
 drivers/usb/dwc2/hcd.c                             |    2 
 drivers/usb/gadget/udc/lpc32xx_udc.c               |    1 
 drivers/usb/serial/io_ti.c                         |    2 
 drivers/usb/serial/io_usbvend.h                    |    1 
 drivers/usb/serial/option.c                        |    6 
 drivers/virtio/virtio_mmio.c                       |    1 
 drivers/virtio/virtio_pci_common.c                 |    3 
 fs/9p/vfs_inode_dotl.c                             |   10 
 fs/compat_ioctl.c                                  |    7 
 fs/ext4/mballoc.c                                  |    9 
 fs/ext4/namei.c                                    |    3 
 fs/ext4/resize.c                                   |   10 
 fs/nfs/pnfs.c                                      |    6 
 include/crypto/blake2s.h                           |  102 
 include/crypto/chacha.h                            |   15 
 include/crypto/drbg.h                              |   16 
 include/crypto/internal/blake2s.h                  |   19 
 include/linux/cpuhotplug.h                         |    2 
 include/linux/hw_random.h                          |    2 
 include/linux/mm.h                                 |    1 
 include/linux/prandom.h                            |   23 
 include/linux/random.h                             |  122 
 include/linux/siphash.h                            |   28 
 include/linux/timex.h                              |   10 
 include/trace/events/random.h                      |  313 --
 include/uapi/linux/random.h                        |    4 
 init/main.c                                        |   13 
 kernel/bpf/stackmap.c                              |    3 
 kernel/cpu.c                                       |   11 
 kernel/dma/debug.c                                 |    2 
 kernel/irq/handle.c                                |    2 
 kernel/time/timekeeping.c                          |   15 
 lib/Kconfig.debug                                  |    3 
 lib/crypto/Makefile                                |    6 
 lib/crypto/blake2s-generic.c                       |  111 
 lib/crypto/blake2s-selftest.c                      |  591 +++
 lib/crypto/blake2s.c                               |   78 
 lib/random32.c                                     |   15 
 lib/sha1.c                                         |   95 
 lib/siphash.c                                      |   32 
 lib/vsprintf.c                                     |   10 
 mm/util.c                                          |   32 
 net/l2tp/l2tp_ip6.c                                |    5 
 net/openvswitch/actions.c                          |    6 
 net/openvswitch/conntrack.c                        |    3 
 net/openvswitch/flow_netlink.c                     |   80 
 net/sched/act_police.c                             |   16 
 scripts/faddr2line                                 |   45 
 sound/hda/hdac_device.c                            |    1 
 sound/pci/hda/patch_realtek.c                      |   27 
 sound/soc/codecs/cs35l36.c                         |    3 
 sound/soc/codecs/cs42l52.c                         |    8 
 sound/soc/codecs/cs42l56.c                         |    4 
 sound/soc/codecs/cs53l30.c                         |   16 
 sound/soc/codecs/es8328.c                          |    5 
 sound/soc/codecs/nau8822.c                         |    4 
 sound/soc/codecs/nau8822.h                         |    3 
 sound/soc/codecs/wm8962.c                          |    1 
 sound/soc/codecs/wm_adsp.c                         |    2 
 128 files changed, 2907 insertions(+), 3012 deletions(-)

Adam Ford (1):
      ASoC: wm8962: Fix suspend while playing music

Al Viro (1):
      9p: missing chunk of "fs/9p: Don't update file type when updating file attributes"

Aleksandr Loktionov (1):
      i40e: Fix call trace in setup_tx_descriptors

Alexey Kardashevskiy (1):
      powerpc/mm: Switch obsolete dssall to .long

Andy Chi (1):
      ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP machine

Andy Lutomirski (8):
      random: Don't wake crng_init_wait when crng_init == 1
      random: Add a urandom_read_nowait() for random APIs that don't warn
      random: add GRND_INSECURE to return best-effort non-cryptographic bytes
      random: ignore GRND_RANDOM in getentropy(2)
      random: make /dev/random be almost like /dev/urandom
      random: remove the blocking pool
      random: delete code to pull data into pools
      random: remove kernel.random.read_wakeup_threshold

Ard Biesheuvel (1):
      random: avoid arch_get_random_seed_long() when collecting IRQ randomness

Arnd Bergmann (1):
      compat_ioctl: remove /dev/random commands

Baokun Li (1):
      ext4: fix bug_on ext4_mb_use_inode_pa

Charles Keepax (5):
      ASoC: cs42l52: Fix TLV scales for mixer controls
      ASoC: cs35l36: Update digital volume TLV
      ASoC: cs53l30: Correct number of volume levels on SX controls
      ASoC: cs42l52: Correct TLV for Bypass Volume
      ASoC: cs42l56: Correct typo in minimum level for SX volume controls

Chen Lin (1):
      net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag

Chengguang Xu (2):
      scsi: ipr: Fix missing/incorrect resource cleanup in error case
      scsi: pmcraid: Fix missing resource cleanup in error case

Christophe JAILLET (1):
      net: bgmac: Fix an erroneous kfree() in bgmac_remove()

Davide Caratti (1):
      net/sched: act_police: more accurate MTU policing

Ding Xiang (1):
      ext4: make variable "count" signed

Dominik Brodowski (7):
      random: harmonize "crng init done" messages
      random: early initialization of ChaCha constants
      random: continually use hwgenerator randomness
      random: access primary_pool directly rather than through pointer
      random: only call crng_finalize_init() for primary_crng
      random: fix locking in crng_fast_load()
      random: fix locking for crng_init in crng_reseed()

Eric Biggers (5):
      random: remove dead code left over from blocking pool
      crypto: blake2s - include <linux/bug.h> instead of <asm/bug.h>
      crypto: blake2s - adjust include guard naming
      random: initialize ChaCha20 constants with correct endianness
      random: remove use_input_pool parameter from crng_reseed()

Greg Kroah-Hartman (1):
      Linux 5.4.200

Grzegorz Szczurek (2):
      i40e: Fix adding ADQ filter to TC0
      i40e: Fix calculating the number of queue pairs

He Ying (1):
      powerpc/kasan: Silence KASAN warnings in __get_wchan()

Hui Wang (1):
      ASoC: nau8822: Add operation for internal PLL off and on

Ian Abbott (1):
      comedi: vmk80xx: fix expression for tx buffer size

Ilpo Järvinen (1):
      serial: 8250: Store to lsr_save_flags after lsr read

Ilya Maximets (2):
      net: openvswitch: fix misuse of the cached connection on tuple changes
      net: openvswitch: fix leak of nested actions

James Smart (2):
      scsi: lpfc: Fix port stuck in bypassed state after LIP in PT2PT topology
      scsi: lpfc: Allow reduced polling rate for nvme_admin_async_event cmd completion

Jan Varho (1):
      random: do not split fast init input in add_hwgenerator_randomness()

Jann Horn (2):
      random: don't reset crng_init_cnt on urandom_read()
      random: check for signal_pending() outside of need_resched() check

Jason A. Donenfeld (126):
      crypto: blake2s - generic C library implementation and selftest
      lib/crypto: blake2s: move hmac construction into wireguard
      lib/crypto: sha1: re-roll loops to reduce code size
      random: don't forget compat_ioctl on urandom
      MAINTAINERS: co-maintain random.c
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
      Revert "random: use static branch for crng_ready()"
      random: avoid checking crng_ready() twice in random_init()
      random: mark bootloader randomness code as __init
      random: account for arch randomness in bits
      random: credit cpu and bootloader seeds by default

Jean-Philippe Brucker (1):
      arm64: kprobes: Use BRK instead of single-step when executing instructions out-of-line

Jens Axboe (3):
      random: convert to using fops->read_iter()
      random: convert to using fops->write_iter()
      random: wire up fops->splice_{read,write}_iter()

Jeremy Szu (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP 440 G8

Josh Poimboeuf (1):
      faddr2line: Fix overlapping text section failures, the sequel

Mark Brown (3):
      random: document add_hwgenerator_randomness() with other input functions
      ASoC: es8328: Fix event generation for deemphasis control
      ASoC: wm_adsp: Fix event generation for wm_adsp_fw_put()

Mark Rutland (4):
      random: split primary/secondary crng init paths
      random: avoid warnings for !CONFIG_NUMA builds
      random: add arch_get_random_*long_early()
      arm64: ftrace: fix branch range checks

Martin Faltesek (1):
      nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

Masahiro Yamada (2):
      clocksource: hyper-v: unexport __init-annotated hv_init_clocksource()
      certs/blacklist_hashes.c: fix const confusion in certs blacklist

Miaoqian Lin (6):
      misc: atmel-ssc: Fix IRQ check in ssc_probe
      irqchip/gic/realview: Fix refcount leak in realview_gic_of_init
      irqchip/gic-v3: Fix error handling in gic_populate_ppi_partitions
      irqchip/gic-v3: Fix refcount leak in gic_populate_ppi_partitions
      usb: dwc2: Fix memory leak in dwc2_hcd_init
      usb: gadget: lpc32xx_udc: Fix refcount leak in lpc32xx_udc_probe

Mikulas Patocka (1):
      dm mirror log: round up region bitmap size to BITS_PER_LONG

Murilo Opsfelder Araujo (1):
      virtio-pci: Remove wrong address verification in vp_del_vqs()

Nicolai Stange (4):
      crypto: drbg - prepare for more fine-grained tracking of seeding state
      crypto: drbg - track whether DRBG was seeded with !rng_is_initialized()
      crypto: drbg - move dynamic ->reseed_threshold adjustments to __drbg_seed()
      crypto: drbg - make reseeding from get_random_bytes() synchronous

Olof Johansson (1):
      riscv: Less inefficient gcc tishift helpers (and export their symbols)

Petr Machata (1):
      mlxsw: spectrum_cnt: Reorder counter pools

Randy Dunlap (1):
      RISC-V: fix barrier() use in <vdso/processor.h>

Richard Henderson (7):
      x86: Remove arch_has_random, arch_has_random_seed
      powerpc: Remove arch_has_random, arch_has_random_seed
      s390: Remove arch_has_random, arch_has_random_seed
      linux/random.h: Remove arch_has_random, arch_has_random_seed
      linux/random.h: Use false with bool
      linux/random.h: Mark CONFIG_ARCH_RANDOM functions __must_check
      powerpc: Use bool in archrandom.h

Rob Clark (1):
      dma-debug: make things less spammy under memory pressure

Robert Eckelmann (1):
      USB: serial: io_ti: add Agilent E5805A support

Schspa Shi (1):
      random: fix typo in comments

Sebastian Andrzej Siewior (1):
      random: remove unused irq_flags argument from add_interrupt_randomness()

Serge Semin (1):
      i2c: designware: Use standard optional ref clock implementation

Sergey Shtylyov (1):
      ata: libata-core: fix NULL pointer deref in ata_host_alloc_pinfo()

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV31 with new baseline

Stephan Müller (2):
      crypto: drbg - always seeded with SP800-90B compliant noise source
      crypto: drbg - always try to free Jitter RNG instance

Trond Myklebust (1):
      pNFS: Don't keep retrying if the server replied NFS4ERR_LAYOUTUNAVAILABLE

Vincent Whitchurch (1):
      tty: goldfish: Fix free_irq() on remove

Wang Yufen (1):
      ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg

Wentao Wang (1):
      scsi: vmw_pvscsi: Expand vcpuHint to 16 bits

Xiaohui Zhang (1):
      nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred

Yangtao Li (5):
      random: remove unnecessary unlikely()
      random: convert to ENTROPY_BITS for better code readability
      random: Add and use pr_fmt()
      random: fix typo in add_timer_randomness()
      random: remove some dead code of poolinfo

Yuntao Wang (1):
      bpf: Fix incorrect memory charge cost calculation in stack_map_alloc()

Zhang Yi (1):
      ext4: add reserved GDT blocks check

chengkaitao (1):
      virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed

huangwenhui (1):
      ALSA: hda/realtek - Add HW8326 support

