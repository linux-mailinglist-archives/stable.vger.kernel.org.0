Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4655A8FE
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 12:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiFYKiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 06:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbiFYKid (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 06:38:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908CE13F90;
        Sat, 25 Jun 2022 03:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2523B804A4;
        Sat, 25 Jun 2022 10:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23936C3411C;
        Sat, 25 Jun 2022 10:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656153508;
        bh=QOqzyhun7qV9+WA9Tgj5hOuvR53a8Hra3dhOXCwCH4A=;
        h=From:To:Cc:Subject:Date:From;
        b=QeNCsXJOBV0N1zag7hBQ/IlcvzMAJL1I6Ddqho/vkLtdDYFHgfOMj0aCArmpKQkZ0
         OA0LVEwlBabv5prh9Hh1SH+yhk8awTci/25L2hpcos/BW7OeIYTi6EJL0vxdEnWCp3
         7cHF18jGY2rUR2d9JP8Jbr/aKKkONx5+bXhQ3s+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.285
Date:   Sat, 25 Jun 2022 12:38:19 +0200
Message-Id: <1656153499137139@kroah.com>
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

I'm announcing the release of the 4.14.285 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt |   12 
 Documentation/sysctl/kernel.txt                 |   35 
 MAINTAINERS                                     |    1 
 Makefile                                        |    2 
 arch/alpha/include/asm/timex.h                  |    1 
 arch/arm/include/asm/timex.h                    |    1 
 arch/arm64/kernel/ftrace.c                      |    4 
 arch/ia64/include/asm/timex.h                   |    1 
 arch/m68k/include/asm/timex.h                   |    2 
 arch/mips/include/asm/timex.h                   |   17 
 arch/nios2/include/asm/timex.h                  |    3 
 arch/parisc/include/asm/timex.h                 |    3 
 arch/powerpc/include/asm/archrandom.h           |   27 
 arch/powerpc/include/asm/timex.h                |    1 
 arch/s390/include/asm/archrandom.h              |   12 
 arch/s390/include/asm/timex.h                   |    1 
 arch/s390/mm/pgtable.c                          |    2 
 arch/sparc/include/asm/timex_32.h               |    4 
 arch/um/include/asm/timex.h                     |    9 
 arch/x86/include/asm/archrandom.h               |   12 
 arch/x86/include/asm/timex.h                    |    9 
 arch/x86/include/asm/tsc.h                      |    7 
 arch/xtensa/include/asm/timex.h                 |    6 
 certs/blacklist_hashes.c                        |    2 
 crypto/chacha20_generic.c                       |    3 
 crypto/drbg.c                                   |  220 +
 crypto/md4.c                                    |   17 
 crypto/md5.c                                    |   17 
 drivers/ata/libata-core.c                       |    4 
 drivers/char/Kconfig                            |   38 
 drivers/char/hw_random/core.c                   |    1 
 drivers/char/random.c                           | 3032 ++++++++----------------
 drivers/hv/vmbus_drv.c                          |    2 
 drivers/irqchip/irq-gic-realview.c              |    1 
 drivers/misc/atmel-ssc.c                        |    4 
 drivers/net/ethernet/broadcom/bgmac-bcma.c      |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c  |   25 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c     |   21 
 drivers/nfc/nfcmrvl/usb.c                       |   16 
 drivers/of/fdt.c                                |   14 
 drivers/scsi/ipr.c                              |    4 
 drivers/scsi/lpfc/lpfc_nportdisc.c              |    3 
 drivers/scsi/pmcraid.c                          |    2 
 drivers/scsi/vmw_pvscsi.h                       |    4 
 drivers/staging/comedi/drivers/vmk80xx.c        |    2 
 drivers/tty/goldfish.c                          |    2 
 drivers/tty/serial/8250/8250_port.c             |    2 
 drivers/usb/dwc2/hcd.c                          |    2 
 drivers/usb/gadget/function/u_ether.c           |   11 
 drivers/usb/gadget/udc/lpc32xx_udc.c            |    1 
 drivers/usb/serial/io_ti.c                      |    2 
 drivers/usb/serial/io_usbvend.h                 |    1 
 drivers/usb/serial/option.c                     |    6 
 drivers/virtio/virtio_mmio.c                    |    1 
 drivers/virtio/virtio_pci_common.c              |    3 
 fs/9p/vfs_inode_dotl.c                          |   10 
 fs/ext4/mballoc.c                               |    9 
 fs/ext4/namei.c                                 |    3 
 fs/ext4/resize.c                                |   10 
 fs/nfs/pnfs.c                                   |    6 
 include/crypto/blake2s.h                        |  102 
 include/crypto/chacha20.h                       |   17 
 include/crypto/drbg.h                           |   18 
 include/crypto/internal/blake2s.h               |   19 
 include/linux/byteorder/generic.h               |   17 
 include/linux/cpuhotplug.h                      |    2 
 include/linux/hw_random.h                       |    2 
 include/linux/mm.h                              |    2 
 include/linux/prandom.h                         |   23 
 include/linux/random.h                          |  125 
 include/linux/siphash.h                         |   28 
 include/linux/timex.h                           |   10 
 include/trace/events/random.h                   |  316 --
 include/uapi/linux/random.h                     |    4 
 init/main.c                                     |   18 
 kernel/cpu.c                                    |   11 
 kernel/irq/handle.c                             |    2 
 kernel/time/timekeeping.c                       |   16 
 lib/Kconfig.debug                               |    5 
 lib/Makefile                                    |    2 
 lib/chacha20.c                                  |    6 
 lib/crypto/Makefile                             |    7 
 lib/crypto/blake2s-generic.c                    |  111 
 lib/crypto/blake2s-selftest.c                   |  591 ++++
 lib/crypto/blake2s.c                            |   78 
 lib/random32.c                                  |   15 
 lib/sha1.c                                      |   95 
 lib/siphash.c                                   |   32 
 mm/util.c                                       |   33 
 net/ipv4/inet_hashtables.c                      |   34 
 net/l2tp/l2tp_ip6.c                             |    5 
 net/l2tp/l2tp_ppp.c                             |   60 
 net/sunrpc/xprtrdma/rpc_rdma.c                  |    4 
 sound/soc/codecs/cs42l52.c                      |    8 
 sound/soc/codecs/cs42l56.c                      |    4 
 sound/soc/codecs/cs53l30.c                      |   16 
 sound/soc/codecs/wm8962.c                       |    1 
 97 files changed, 2775 insertions(+), 2738 deletions(-)

Adam Ford (1):
      ASoC: wm8962: Fix suspend while playing music

Al Viro (1):
      9p: missing chunk of "fs/9p: Don't update file type when updating file attributes"

Aleksandr Loktionov (1):
      i40e: Fix call trace in setup_tx_descriptors

Andi Kleen (1):
      random: optimize add_interrupt_randomness

Andy Lutomirski (8):
      random: Don't wake crng_init_wait when crng_init == 1
      random: Add a urandom_read_nowait() for random APIs that don't warn
      random: add GRND_INSECURE to return best-effort non-cryptographic bytes
      random: ignore GRND_RANDOM in getentropy(2)
      random: make /dev/random be almost like /dev/urandom
      random: remove the blocking pool
      random: delete code to pull data into pools
      random: remove kernel.random.read_wakeup_threshold

Andy Shevchenko (1):
      crypto: Deduplicate le32_to_cpu_array() and cpu_to_le32_array()

Ard Biesheuvel (1):
      random: avoid arch_get_random_seed_long() when collecting IRQ randomness

Baokun Li (1):
      ext4: fix bug_on ext4_mb_use_inode_pa

Borislav Petkov (1):
      char/random: Add a newline at the end of the file

Charles Keepax (4):
      ASoC: cs42l52: Fix TLV scales for mixer controls
      ASoC: cs53l30: Correct number of volume levels on SX controls
      ASoC: cs42l52: Correct TLV for Bypass Volume
      ASoC: cs42l56: Correct typo in minimum level for SX volume controls

Chen Lin (1):
      net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag

Chengguang Xu (2):
      scsi: ipr: Fix missing/incorrect resource cleanup in error case
      scsi: pmcraid: Fix missing resource cleanup in error case

Christian Borntraeger (1):
      s390/mm: use non-quiescing sske for KVM switch to keyed guest

Christophe JAILLET (1):
      net: bgmac: Fix an erroneous kfree() in bgmac_remove()

Colin Ian King (1):
      xprtrdma: fix incorrect header size calculations

Ding Xiang (1):
      ext4: make variable "count" signed

Dominik Brodowski (7):
      random: fix crash on multiple early calls to add_bootloader_randomness()
      random: harmonize "crng init done" messages
      random: early initialization of ChaCha constants
      random: continually use hwgenerator randomness
      random: access primary_pool directly rather than through pointer
      random: only call crng_finalize_init() for primary_crng
      random: fix locking in crng_fast_load()

Eric Biggers (7):
      crypto: chacha20 - Fix keystream alignment for chacha20_block()
      random: remove dead code left over from blocking pool
      crypto: blake2s - include <linux/bug.h> instead of <asm/bug.h>
      crypto: blake2s - adjust include guard naming
      random: initialize ChaCha20 constants with correct endianness
      crypto: chacha20 - Fix chacha20_block() keystream alignment (again)
      random: remove use_input_pool parameter from crng_reseed()

Eric Dumazet (1):
      tcp: add some entropy in __inet_hash_connect()

George Spelvin (1):
      random: document get_random_int() family

Greg Kroah-Hartman (1):
      Linux 4.14.285

Herbert Xu (1):
      Revert "hwrng: core - Freeze khwrng thread during suspend"

Hsin-Yi Wang (1):
      fdt: add support for rng-seed

Ian Abbott (1):
      comedi: vmk80xx: fix expression for tx buffer size

Ilpo Järvinen (1):
      serial: 8250: Store to lsr_save_flags after lsr read

Ingo Molnar (1):
      random: remove preempt disabled region

James Chapman (2):
      l2tp: don't use inet_shutdown on ppp session destroy
      l2tp: fix race in pppol2tp_release with session object destroy

James Smart (1):
      scsi: lpfc: Fix port stuck in bypassed state after LIP in PT2PT topology

Jan Varho (1):
      random: do not split fast init input in add_hwgenerator_randomness()

Jann Horn (2):
      random: don't reset crng_init_cnt on urandom_read()
      random: check for signal_pending() outside of need_resched() check

Jason A. Donenfeld (117):
      random: always fill buffer in get_random_bytes_wait
      random: Make crng state queryable
      crypto: blake2s - generic C library implementation and selftest
      lib/crypto: blake2s: move hmac construction into wireguard
      lib/crypto: sha1: re-roll loops to reduce code size
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
      random: simplify arithmetic function flow in account()
      random: use computational hash for entropy extraction
      random: simplify entropy debiting
      random: use linear min-entropy accumulation crediting
      random: always wake up entropy writers after extraction
      random: make credit_entropy_bits() always safe
      random: remove batched entropy locking
      random: use RDSEED instead of RDRAND in entropy extraction
      random: inline leaves of rand_initialize()
      random: ensure early RDSEED goes through mixer on init
      random: do not xor RDRAND when writing into /dev/random
      random: absorb fast pool into input pool after fast load
      random: use hash function for crng_slow_load()
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
      random: do not pretend to handle premature next security model
      random: order timer entropy functions below interrupt functions
      random: do not use input pool from hard IRQs
      random: help compiler out with fast_mix() by using simpler arguments
      siphash: use one source of truth for siphash permutations
      random: use symbolic constants for crng_init states
      random: avoid initializing twice in credit race
      random: remove ratelimiting for in-kernel unseeded randomness
      random: use proper jiffies comparison macro
      random: handle latent entropy and command line from random_init()
      random: credit architectural init the exact amount
      random: use static branch for crng_ready()
      random: remove extern from functions in header
      random: use proper return types on get_random_{int,long}_wait()
      random: move initialization functions out of hot pages
      random: move randomize_page() into mm where it belongs
      random: check for signals after page of pool writes
      Revert "random: use static branch for crng_ready()"
      random: avoid checking crng_ready() twice in random_init()
      random: mark bootloader randomness code as __init
      random: account for arch randomness in bits
      random: credit cpu and bootloader seeds by default

Jens Axboe (2):
      random: convert to using fops->write_iter()
      random: wire up fops->splice_{read,write}_iter()

Kees Cook (2):
      random: make CPU trust a boot parameter
      random: move rand_initialize() earlier

Linus Torvalds (1):
      random: try to actively add entropy rather than passively wait for it

Marian Postevca (1):
      usb: gadget: u_ether: fix regression in setting fixed MAC address

Mark Brown (1):
      random: document add_hwgenerator_randomness() with other input functions

Mark Rutland (4):
      random: split primary/secondary crng init paths
      random: avoid warnings for !CONFIG_NUMA builds
      random: add arch_get_random_*long_early()
      arm64: ftrace: fix branch range checks

Masahiro Yamada (1):
      certs/blacklist_hashes.c: fix const confusion in certs blacklist

Miaoqian Lin (4):
      misc: atmel-ssc: Fix IRQ check in ssc_probe
      irqchip/gic/realview: Fix refcount leak in realview_gic_of_init
      usb: dwc2: Fix memory leak in dwc2_hcd_init
      usb: gadget: lpc32xx_udc: Fix refcount leak in lpc32xx_udc_probe

Murilo Opsfelder Araujo (1):
      virtio-pci: Remove wrong address verification in vp_del_vqs()

Nicolai Stange (4):
      crypto: drbg - prepare for more fine-grained tracking of seeding state
      crypto: drbg - track whether DRBG was seeded with !rng_is_initialized()
      crypto: drbg - move dynamic ->reseed_threshold adjustments to __drbg_seed()
      crypto: drbg - make reseeding from get_random_bytes() synchronous

Rasmus Villemoes (4):
      drivers/char/random.c: remove unused dont_count_entropy
      drivers/char/random.c: constify poolinfo_table
      drivers/char/random.c: remove unused stuct poolinfo::poolbits
      drivers/char/random.c: make primary_crng static

Richard Henderson (7):
      x86: Remove arch_has_random, arch_has_random_seed
      powerpc: Remove arch_has_random, arch_has_random_seed
      s390: Remove arch_has_random, arch_has_random_seed
      linux/random.h: Remove arch_has_random, arch_has_random_seed
      linux/random.h: Use false with bool
      linux/random.h: Mark CONFIG_ARCH_RANDOM functions __must_check
      powerpc: Use bool in archrandom.h

Robert Eckelmann (1):
      USB: serial: io_ti: add Agilent E5805A support

Schspa Shi (1):
      random: fix typo in comments

Sebastian Andrzej Siewior (1):
      random: remove unused irq_flags argument from add_interrupt_randomness()

Sergey Senozhatsky (1):
      char/random: silence a lockdep splat with printk()

Sergey Shtylyov (1):
      ata: libata-core: fix NULL pointer deref in ata_host_alloc_pinfo()

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV31 with new baseline

Stephan Mueller (1):
      crypto: drbg - add FIPS 140-2 CTRNG for noise source

Stephan Müller (2):
      crypto: drbg - always seeded with SP800-90B compliant noise source
      crypto: drbg - always try to free Jitter RNG instance

Stephen Boyd (2):
      random: Support freezable kthreads in add_hwgenerator_randomness()
      random: Use wait_event_freezable() in add_hwgenerator_randomness()

Theodore Ts'o (3):
      random: add a config option to trust the CPU's hwrng
      random: only read from /dev/random after its pool has received 128 bits
      random: fix soft lockup when trying to read from an uninitialized blocking pool

Tobin C. Harding (2):
      random: Fix whitespace pre random-bytes work
      random: Return nbytes filled from hw RNG

Trond Myklebust (1):
      pNFS: Don't keep retrying if the server replied NFS4ERR_LAYOUTUNAVAILABLE

Vasily Gorbik (1):
      latent_entropy: avoid build error when plugin cflags are not set

Vincent Whitchurch (1):
      tty: goldfish: Fix free_irq() on remove

Wang Yufen (1):
      ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg

Wentao Wang (1):
      scsi: vmw_pvscsi: Expand vcpuHint to 16 bits

Willy Tarreau (5):
      tcp: use different parts of the port_offset for index and offset
      tcp: add small random increments to the source port
      tcp: dynamically allocate the perturb table used by source ports
      tcp: increase source port perturb table to 2^16
      tcp: drop the hash_32() part from the index calculation

Xiaohui Zhang (1):
      nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred

Yangtao Li (5):
      random: remove unnecessary unlikely()
      random: convert to ENTROPY_BITS for better code readability
      random: Add and use pr_fmt()
      random: fix typo in add_timer_randomness()
      random: remove some dead code of poolinfo

Zhang Yi (1):
      ext4: add reserved GDT blocks check

chengkaitao (1):
      virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed

