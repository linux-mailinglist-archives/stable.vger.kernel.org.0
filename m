Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EC855853F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbiFWRyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbiFWRxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:53:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FD09E718;
        Thu, 23 Jun 2022 10:14:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C3746159B;
        Thu, 23 Jun 2022 17:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F41C341C4;
        Thu, 23 Jun 2022 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004448;
        bh=37yKsWAAbbyjzPY/gK06bQvzm4BZy8/xiXDPAf4e2sE=;
        h=From:To:Cc:Subject:Date:From;
        b=YFs0DLGUZnvp35k5MNHyIlwmU7BgeMA2Yq2jBdLv5em+f9JUF0SEIDcrNiI0FnZvl
         wcUd6jNhUDtbSAGDwuPnCGetM6f0cwjl8kEbHQOJfL8/xT4x/cHUakDBD72DwU7Is1
         xlxo2ZyI2RmOCpg+/43yR4hILcBdK9Ju217sXvAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 000/234] 4.19.249-rc1 review
Date:   Thu, 23 Jun 2022 18:41:07 +0200
Message-Id: <20220623164343.042598055@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.249-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.249-rc1
X-KernelTest-Deadline: 2022-06-25T16:43+00:00
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

This is the start of the stable review cycle for the 4.19.249 release.
There are 234 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.249-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.249-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "hwmon: Make chip parameter for with_info API mandatory"

Willy Tarreau <w@1wt.eu>
    tcp: drop the hash_32() part from the index calculation

Willy Tarreau <w@1wt.eu>
    tcp: increase source port perturb table to 2^16

Willy Tarreau <w@1wt.eu>
    tcp: dynamically allocate the perturb table used by source ports

Willy Tarreau <w@1wt.eu>
    tcp: add small random increments to the source port

Willy Tarreau <w@1wt.eu>
    tcp: use different parts of the port_offset for index and offset

Eric Dumazet <edumazet@google.com>
    tcp: add some entropy in __inet_hash_connect()

Colin Ian King <colin.king@canonical.com>
    xprtrdma: fix incorrect header size calculations

Marian Postevca <posteuca@mutex.one>
    usb: gadget: u_ether: fix regression in setting fixed MAC address

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/mm: use non-quiescing sske for KVM switch to keyed guest

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/mm: Switch obsolete dssall to .long

Randy Dunlap <rdunlap@infradead.org>
    RISC-V: fix barrier() use in <vdso/processor.h>

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix leak of nested actions

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix misuse of the cached connection on tuple changes

Murilo Opsfelder Araujo <muriloo@linux.ibm.com>
    virtio-pci: Remove wrong address verification in vp_del_vqs()

Zhang Yi <yi.zhang@huawei.com>
    ext4: add reserved GDT blocks check

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ext4: make variable "count" signed

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on ext4_mb_use_inode_pa

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Store to lsr_save_flags after lsr read

Miaoqian Lin <linmq006@gmail.com>
    usb: gadget: lpc32xx_udc: Fix refcount leak in lpc32xx_udc_probe

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc2: Fix memory leak in dwc2_hcd_init

Robert Eckelmann <longnoserob@gmail.com>
    USB: serial: io_ti: add Agilent E5805A support

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Cinterion MV31 with new baseline

Ian Abbott <abbotti@mev.co.uk>
    comedi: vmk80xx: fix expression for tx buffer size

Miaoqian Lin <linmq006@gmail.com>
    irqchip/gic-v3: Fix refcount leak in gic_populate_ppi_partitions

Miaoqian Lin <linmq006@gmail.com>
    irqchip/gic/realview: Fix refcount leak in realview_gic_of_init

Josh Poimboeuf <jpoimboe@kernel.org>
    faddr2line: Fix overlapping text section failures, the sequel

Masahiro Yamada <masahiroy@kernel.org>
    certs/blacklist_hashes.c: fix const confusion in certs blacklist

Mark Rutland <mark.rutland@arm.com>
    arm64: ftrace: fix branch range checks

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: bgmac: Fix an erroneous kfree() in bgmac_remove()

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum_cnt: Reorder counter pools

Miaoqian Lin <linmq006@gmail.com>
    misc: atmel-ssc: Fix IRQ check in ssc_probe

Vincent Whitchurch <vincent.whitchurch@axis.com>
    tty: goldfish: Fix free_irq() on remove

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: Fix call trace in setup_tx_descriptors

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    i40e: Fix adding ADQ filter to TC0

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Don't keep retrying if the server replied NFS4ERR_LAYOUTUNAVAILABLE

Jason A. Donenfeld <Jason@zx2c4.com>
    random: credit cpu and bootloader seeds by default

Chen Lin <chen45464546@163.com>
    net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag

Wang Yufen <wangyufen@huawei.com>
    ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg

Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
    nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred

chengkaitao <pilgrimtao@gmail.com>
    virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed

Chengguang Xu <cgxu519@mykernel.net>
    scsi: pmcraid: Fix missing resource cleanup in error case

Chengguang Xu <cgxu519@mykernel.net>
    scsi: ipr: Fix missing/incorrect resource cleanup in error case

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix port stuck in bypassed state after LIP in PT2PT topology

Wentao Wang <wwentao@vmware.com>
    scsi: vmw_pvscsi: Expand vcpuHint to 16 bits

Mark Brown <broonie@kernel.org>
    ASoC: wm_adsp: Fix event generation for wm_adsp_fw_put()

Mark Brown <broonie@kernel.org>
    ASoC: es8328: Fix event generation for deemphasis control

Adam Ford <aford173@gmail.com>
    ASoC: wm8962: Fix suspend while playing music

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: libata-core: fix NULL pointer deref in ata_host_alloc_pinfo()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l56: Correct typo in minimum level for SX volume controls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l52: Correct TLV for Bypass Volume

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs53l30: Correct number of volume levels on SX controls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l52: Fix TLV scales for mixer controls

He Ying <heying24@huawei.com>
    powerpc/kasan: Silence KASAN warnings in __get_wchan()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: account for arch randomness in bits

Jason A. Donenfeld <Jason@zx2c4.com>
    random: mark bootloader randomness code as __init

Jason A. Donenfeld <Jason@zx2c4.com>
    random: avoid checking crng_ready() twice in random_init()

Nicolai Stange <nstange@suse.de>
    crypto: drbg - make reseeding from get_random_bytes() synchronous

Stephan Müller <smueller@chronox.de>
    crypto: drbg - always try to free Jitter RNG instance

Nicolai Stange <nstange@suse.de>
    crypto: drbg - move dynamic ->reseed_threshold adjustments to __drbg_seed()

Nicolai Stange <nstange@suse.de>
    crypto: drbg - track whether DRBG was seeded with !rng_is_initialized()

Nicolai Stange <nstange@suse.de>
    crypto: drbg - prepare for more fine-grained tracking of seeding state

Stephan Müller <smueller@chronox.de>
    crypto: drbg - always seeded with SP800-90B compliant noise source

Stephan Mueller <smueller@chronox.de>
    crypto: drbg - add FIPS 140-2 CTRNG for noise source

Jason A. Donenfeld <Jason@zx2c4.com>
    Revert "random: use static branch for crng_ready()"

Jason A. Donenfeld <Jason@zx2c4.com>
    random: check for signals after page of pool writes

Jens Axboe <axboe@kernel.dk>
    random: wire up fops->splice_{read,write}_iter()

Jens Axboe <axboe@kernel.dk>
    random: convert to using fops->write_iter()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: move randomize_page() into mm where it belongs

Jason A. Donenfeld <Jason@zx2c4.com>
    random: move initialization functions out of hot pages

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

Jason A. Donenfeld <Jason@zx2c4.com>
    random: zero buffer after reading entropy from userspace

Jason A. Donenfeld <Jason@zx2c4.com>
    random: remove outdated INT_MAX >> 6 check in urandom_read()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use hash function for crng_slow_load()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: absorb fast pool into input pool after fast load

Jason A. Donenfeld <Jason@zx2c4.com>
    random: do not xor RDRAND when writing into /dev/random

Jason A. Donenfeld <Jason@zx2c4.com>
    random: ensure early RDSEED goes through mixer on init

Jason A. Donenfeld <Jason@zx2c4.com>
    random: inline leaves of rand_initialize()

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

Eric Biggers <ebiggers@google.com>
    random: initialize ChaCha20 constants with correct endianness

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

Eric Biggers <ebiggers@google.com>
    crypto: blake2s - adjust include guard naming

Eric Biggers <ebiggers@google.com>
    crypto: blake2s - include <linux/bug.h> instead of <asm/bug.h>

Jason A. Donenfeld <Jason@zx2c4.com>
    MAINTAINERS: co-maintain random.c

Eric Biggers <ebiggers@google.com>
    random: remove dead code left over from blocking pool

Ard Biesheuvel <ardb@kernel.org>
    random: avoid arch_get_random_seed_long() when collecting IRQ randomness

Mark Rutland <mark.rutland@arm.com>
    random: add arch_get_random_*long_early()

Richard Henderson <richard.henderson@linaro.org>
    powerpc: Use bool in archrandom.h

Richard Henderson <richard.henderson@linaro.org>
    linux/random.h: Mark CONFIG_ARCH_RANDOM functions __must_check

Richard Henderson <richard.henderson@linaro.org>
    linux/random.h: Use false with bool

Richard Henderson <richard.henderson@linaro.org>
    linux/random.h: Remove arch_has_random, arch_has_random_seed

Richard Henderson <richard.henderson@linaro.org>
    s390: Remove arch_has_random, arch_has_random_seed

Richard Henderson <richard.henderson@linaro.org>
    powerpc: Remove arch_has_random, arch_has_random_seed

Richard Henderson <richard.henderson@linaro.org>
    x86: Remove arch_has_random, arch_has_random_seed

Mark Rutland <mark.rutland@arm.com>
    random: avoid warnings for !CONFIG_NUMA builds

Mark Rutland <mark.rutland@arm.com>
    random: split primary/secondary crng init paths

Yangtao Li <tiny.windzz@gmail.com>
    random: remove some dead code of poolinfo

Yangtao Li <tiny.windzz@gmail.com>
    random: fix typo in add_timer_randomness()

Yangtao Li <tiny.windzz@gmail.com>
    random: Add and use pr_fmt()

Yangtao Li <tiny.windzz@gmail.com>
    random: convert to ENTROPY_BITS for better code readability

Yangtao Li <tiny.windzz@gmail.com>
    random: remove unnecessary unlikely()

Andy Lutomirski <luto@kernel.org>
    random: remove kernel.random.read_wakeup_threshold

Andy Lutomirski <luto@kernel.org>
    random: delete code to pull data into pools

Andy Lutomirski <luto@kernel.org>
    random: remove the blocking pool

Dominik Brodowski <linux@dominikbrodowski.net>
    random: fix crash on multiple early calls to add_bootloader_randomness()

Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
    char/random: silence a lockdep splat with printk()

Andy Lutomirski <luto@kernel.org>
    random: make /dev/random be almost like /dev/urandom

Andy Lutomirski <luto@kernel.org>
    random: ignore GRND_RANDOM in getentropy(2)

Andy Lutomirski <luto@kernel.org>
    random: add GRND_INSECURE to return best-effort non-cryptographic bytes

Andy Lutomirski <luto@kernel.org>
    random: Add a urandom_read_nowait() for random APIs that don't warn

Andy Lutomirski <luto@kernel.org>
    random: Don't wake crng_init_wait when crng_init == 1

Jason A. Donenfeld <Jason@zx2c4.com>
    lib/crypto: sha1: re-roll loops to reduce code size

Jason A. Donenfeld <Jason@zx2c4.com>
    lib/crypto: blake2s: move hmac construction into wireguard

Jason A. Donenfeld <Jason@zx2c4.com>
    crypto: blake2s - generic C library implementation and selftest

Herbert Xu <herbert@gondor.apana.org.au>
    Revert "hwrng: core - Freeze khwrng thread during suspend"

Borislav Petkov <bp@alien8.de>
    char/random: Add a newline at the end of the file

Stephen Boyd <swboyd@chromium.org>
    random: Use wait_event_freezable() in add_hwgenerator_randomness()

Hsin-Yi Wang <hsinyi@chromium.org>
    fdt: add support for rng-seed

Stephen Boyd <swboyd@chromium.org>
    random: Support freezable kthreads in add_hwgenerator_randomness()

Theodore Ts'o <tytso@mit.edu>
    random: fix soft lockup when trying to read from an uninitialized blocking pool

Vasily Gorbik <gor@linux.ibm.com>
    latent_entropy: avoid build error when plugin cflags are not set

George Spelvin <lkml@sdf.org>
    random: document get_random_int() family

Kees Cook <keescook@chromium.org>
    random: move rand_initialize() earlier

Theodore Ts'o <tytso@mit.edu>
    random: only read from /dev/random after its pool has received 128 bits

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    drivers/char/random.c: make primary_crng static

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    drivers/char/random.c: remove unused stuct poolinfo::poolbits

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    drivers/char/random.c: constify poolinfo_table

Al Viro <viro@zeniv.linux.org.uk>
    9p: missing chunk of "fs/9p: Don't update file type when updating file attributes"


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |    6 +
 Documentation/hwmon/hwmon-kernel-api.txt           |    2 +-
 Documentation/sysctl/kernel.txt                    |   35 +-
 MAINTAINERS                                        |    1 +
 Makefile                                           |    4 +-
 arch/alpha/include/asm/timex.h                     |    1 +
 arch/arm/include/asm/timex.h                       |    1 +
 arch/arm64/kernel/ftrace.c                         |    4 +-
 arch/ia64/include/asm/timex.h                      |    1 +
 arch/m68k/include/asm/timex.h                      |    2 +-
 arch/mips/include/asm/timex.h                      |   17 +-
 arch/nios2/include/asm/timex.h                     |    3 +
 arch/parisc/include/asm/timex.h                    |    3 +-
 arch/powerpc/include/asm/archrandom.h              |   27 +-
 arch/powerpc/include/asm/ppc-opcode.h              |    2 +
 arch/powerpc/include/asm/timex.h                   |    1 +
 arch/powerpc/kernel/idle_6xx.S                     |    2 +-
 arch/powerpc/kernel/l2cr_6xx.S                     |    6 +-
 arch/powerpc/kernel/process.c                      |    4 +-
 arch/powerpc/kernel/swsusp_32.S                    |    2 +-
 arch/powerpc/kernel/swsusp_asm64.S                 |    2 +-
 arch/powerpc/mm/mmu_context.c                      |    2 +-
 arch/powerpc/platforms/powermac/cache.S            |    4 +-
 arch/riscv/include/asm/processor.h                 |    2 +
 arch/s390/include/asm/archrandom.h                 |   12 -
 arch/s390/include/asm/timex.h                      |    1 +
 arch/s390/mm/pgtable.c                             |    2 +-
 arch/sparc/include/asm/timex_32.h                  |    4 +-
 arch/um/include/asm/timex.h                        |    9 +-
 arch/x86/include/asm/archrandom.h                  |   12 +-
 arch/x86/include/asm/timex.h                       |    9 +
 arch/x86/include/asm/tsc.h                         |    7 +-
 arch/xtensa/include/asm/timex.h                    |    6 +-
 certs/blacklist_hashes.c                           |    2 +-
 crypto/drbg.c                                      |  220 +-
 drivers/ata/libata-core.c                          |    4 +-
 drivers/char/Kconfig                               |   50 +-
 drivers/char/hw_random/core.c                      |    1 +
 drivers/char/random.c                              | 3079 +++++++-------------
 drivers/hv/hv.c                                    |    2 +-
 drivers/hv/vmbus_drv.c                             |    2 +-
 drivers/hwmon/hwmon.c                              |   16 +-
 drivers/irqchip/irq-gic-realview.c                 |    1 +
 drivers/irqchip/irq-gic-v3.c                       |    5 +-
 drivers/misc/atmel-ssc.c                           |    4 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |    1 -
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   25 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    5 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   21 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h |    2 +-
 drivers/nfc/nfcmrvl/usb.c                          |   16 +-
 drivers/of/fdt.c                                   |   14 +-
 drivers/scsi/ipr.c                                 |    4 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |    3 +-
 drivers/scsi/pmcraid.c                             |    2 +-
 drivers/scsi/vmw_pvscsi.h                          |    4 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |    2 +-
 drivers/tty/goldfish.c                             |    2 +-
 drivers/tty/serial/8250/8250_port.c                |    2 +
 drivers/usb/dwc2/hcd.c                             |    2 +-
 drivers/usb/gadget/function/u_ether.c              |   11 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |    1 +
 drivers/usb/serial/io_ti.c                         |    2 +
 drivers/usb/serial/io_usbvend.h                    |    1 +
 drivers/usb/serial/option.c                        |    6 +
 drivers/virtio/virtio_mmio.c                       |    1 +
 drivers/virtio/virtio_pci_common.c                 |    3 +-
 fs/9p/vfs_inode_dotl.c                             |   10 +-
 fs/ext4/mballoc.c                                  |    9 +
 fs/ext4/namei.c                                    |    3 +-
 fs/ext4/resize.c                                   |   10 +
 fs/nfs/pnfs.c                                      |    6 +
 include/crypto/blake2s.h                           |  102 +
 include/crypto/chacha20.h                          |   15 +
 include/crypto/drbg.h                              |   18 +-
 include/crypto/internal/blake2s.h                  |   19 +
 include/linux/cpuhotplug.h                         |    2 +
 include/linux/hw_random.h                          |    2 -
 include/linux/mm.h                                 |    2 +
 include/linux/prandom.h                            |   23 +-
 include/linux/random.h                             |  122 +-
 include/linux/siphash.h                            |   28 +
 include/linux/timex.h                              |   10 +-
 include/trace/events/random.h                      |  316 --
 include/uapi/linux/random.h                        |    4 +-
 init/main.c                                        |   18 +-
 kernel/cpu.c                                       |   11 +
 kernel/irq/handle.c                                |    2 +-
 kernel/time/timekeeping.c                          |   15 +
 lib/Kconfig.debug                                  |    3 +-
 lib/Makefile                                       |    2 +
 lib/crypto/Makefile                                |    7 +
 lib/crypto/blake2s-generic.c                       |  111 +
 lib/crypto/blake2s-selftest.c                      |  591 ++++
 lib/crypto/blake2s.c                               |   78 +
 lib/random32.c                                     |   15 +-
 lib/sha1.c                                         |   95 +-
 lib/siphash.c                                      |   32 +-
 lib/vsprintf.c                                     |   10 +-
 mm/util.c                                          |   33 +
 net/ipv4/inet_hashtables.c                         |   31 +-
 net/l2tp/l2tp_ip6.c                                |    5 +-
 net/openvswitch/actions.c                          |    6 +
 net/openvswitch/conntrack.c                        |    3 +-
 net/openvswitch/flow_netlink.c                     |   61 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |    4 +-
 scripts/faddr2line                                 |   45 +-
 sound/soc/codecs/cs42l52.c                         |    8 +-
 sound/soc/codecs/cs42l56.c                         |    4 +-
 sound/soc/codecs/cs53l30.c                         |   16 +-
 sound/soc/codecs/es8328.c                          |    5 +-
 sound/soc/codecs/wm8962.c                          |    1 +
 sound/soc/codecs/wm_adsp.c                         |    2 +-
 113 files changed, 2839 insertions(+), 2788 deletions(-)


