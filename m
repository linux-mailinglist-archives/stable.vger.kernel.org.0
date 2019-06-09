Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344083A736
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbfFIQrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730828AbfFIQrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:47:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 450E52081C;
        Sun,  9 Jun 2019 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098840;
        bh=CCJpbEIbDQzvqld1EhPRm4yUD1uUdz1WufL156QyRDA=;
        h=From:To:Cc:Subject:Date:From;
        b=2hsZ2UeV4Vhj7mpllPdRIjx2jP/lRMZN0d1PzCh08hZdTZqNSknx8Vge2B7kSu2iF
         kTmfdKpfZpwkVG5AaSx34H0qhMbKbjTc1YDhnOrpZgpnJgUZ6OsMhF7qlmp/O3nVJX
         G2AsZNRi2iuQHTYew7nBLjMJfrMO3tdHT981ZoH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/51] 4.19.50-stable review
Date:   Sun,  9 Jun 2019 18:41:41 +0200
Message-Id: <20190609164127.123076536@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.50-rc1
X-KernelTest-Deadline: 2019-06-11T16:41+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.50 release.
There are 51 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 11 Jun 2019 04:40:08 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.50-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.50-rc1

Jiri Slaby <jslaby@suse.cz>
    TTY: serial_core, add ->install

Tina Zhang <tina.zhang@intel.com>
    drm/i915/gvt: Initialize intel_gvt_gtt_entry in stack

Helen Koike <helen.koike@collabora.com>
    drm: don't block fb changes for async plane updates

Jonathan Corbet <corbet@lwn.net>
    drm/i915: Maintain consistent documentation subsection ordering

Daniel Drake <drake@endlessm.com>
    drm/i915/fbc: disable framebuffer compression on GeminiLake

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/soc15: skip reset on init

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix I915_EXEC_RING_MASK

Aaron Liu <aaron.liu@amd.com>
    drm/amdgpu: remove ATPX_DGPU_REQ_POWER_FOR_DISPLAYS check when hotplug-in

Christian König <christian.koenig@amd.com>
    drm/radeon: prefer lower reference dividers

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/psp: move psp version specific function pointers to early_init

Ryan Pavlik <ryan.pavlik@collabora.com>
    drm: add non-desktop quirks to Sensics and OSVR headsets.

Dave Airlie <airlied@redhat.com>
    drm/nouveau: add kconfig option to turn off nouveau legacy contexts. (v3)

Andres Rodriguez <andresx7@gmail.com>
    drm: add non-desktop quirk for Valve HMDs

Helen Koike <helen.koike@collabora.com>
    drm/msm: fix fb references in async update

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500/cdv: Check vbt config bits when detecting lvds panels

Dan Carpenter <dan.carpenter@oracle.com>
    test_firmware: Use correct snprintf() limit

Dan Carpenter <dan.carpenter@oracle.com>
    genwqe: Prevent an integer overflow in the ioctl

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "MIPS: perf: ath79: Fix perfcount IRQ assignment"

Paul Burton <paul.burton@mips.com>
    MIPS: pistachio: Build uImage.gz by default

Paul Burton <paul.burton@mips.com>
    MIPS: Bounds check virt_addr_valid

Roger Pau Monne <roger.pau@citrix.com>
    xen-blkfront: switch kcalloc to kvcalloc for large array allocation

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: fix address space detection in exception handling

Robert Hancock <hancock@sedsystems.ca>
    i2c: xiic: Add max_read_len quirk

Jann Horn <jannh@google.com>
    x86/insn-eval: Fix use-after-free access to LDT entry

Jiri Kosina <jkosina@suse.cz>
    x86/power: Fix 'nosmt' vs hibernation triple fault during resume

Kees Cook <keescook@chromium.org>
    pstore/ram: Run without kernel crash dump region

Pi-Hsun Shih <pihsun@chromium.org>
    pstore: Set tfm to NULL on free_buf_for_compression

Kees Cook <keescook@chromium.org>
    pstore: Convert buf_lock to semaphore

Kees Cook <keescook@chromium.org>
    pstore: Remove needless lock during console writes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fallocate: fix return with locked inode

Yihao Wu <wuyihao@linux.alibaba.com>
    NFSv4.1: Fix bug only first CB_NOTIFY_LOCK is handled

Yihao Wu <wuyihao@linux.alibaba.com>
    NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails to wake a waiter

John David Anglin <dave.anglin@bell.net>
    parisc: Use implicit space register selection for loading the coherence index of I/O pdirs

Linus Torvalds <torvalds@linux-foundation.org>
    rcu: locking and unlocking need to always be at least barriers

Emil Lenngren <emil.lenngren@gmail.com>
    mtd: spinand: macronix: Fix ECC Status Read

Olivier Matz <olivier.matz@6wind.com>
    ipv6: fix EFAULT on sendto with icmpv6 and hdrincl

Olivier Matz <olivier.matz@6wind.com>
    ipv6: use READ_ONCE() for inet->hdrincl as in ipv4

Hangbin Liu <liuhangbin@gmail.com>
    Revert "fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied"

Paolo Abeni <pabeni@redhat.com>
    pktgen: do not sleep with the thread lock held.

Willem de Bruijn <willemb@google.com>
    packet: unconditionally free po->rollover

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: replace the sleeping lock around RX resync with a bit lock

Russell King <rmk+kernel@armlinux.org.uk>
    net: sfp: read eeprom in maximum 16 byte increments

Zhu Yanjun <yanjun.zhu@oracle.com>
    net: rds: fix memory leak in rds_ib_flush_mr_pool

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvpp2: Use strscpy to handle stat strings

Erez Alfasi <ereza@mellanox.com>
    net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
    net: ethernet: ti: cpsw_ethtool: fix ethtool ring param set

David Ahern <dsahern@gmail.com>
    neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit

Xin Long <lucien.xin@gmail.com>
    ipv6: fix the check before getting the cookie in rt6_get_cookie

Xin Long <lucien.xin@gmail.com>
    ipv4: not do cache for local delivery if bc_forwarding is enabled

Neil Horman <nhorman@tuxdriver.com>
    Fix memory leak in sctp_process_init

Vivien Didelot <vivien.didelot@gmail.com>
    ethtool: fix potential userspace buffer overflow


-------------

Diffstat:

 Makefile                                        |  4 +-
 arch/mips/ath79/setup.c                         |  6 ++
 arch/mips/mm/mmap.c                             |  5 ++
 arch/mips/pistachio/Platform                    |  1 +
 arch/powerpc/kernel/nvram_64.c                  |  2 -
 arch/s390/mm/fault.c                            |  5 +-
 arch/x86/lib/insn-eval.c                        | 47 ++++++++-------
 arch/x86/power/cpu.c                            | 10 ++++
 arch/x86/power/hibernate_64.c                   | 33 ++++++++++
 drivers/acpi/apei/erst.c                        |  1 -
 drivers/block/xen-blkfront.c                    | 38 ++++++------
 drivers/firmware/efi/efi-pstore.c               |  4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c        |  3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c         | 19 +++---
 drivers/gpu/drm/amd/amdgpu/soc15.c              |  5 ++
 drivers/gpu/drm/drm_atomic_helper.c             | 22 +++----
 drivers/gpu/drm/drm_edid.c                      | 25 ++++++++
 drivers/gpu/drm/gma500/cdv_intel_lvds.c         |  3 +
 drivers/gpu/drm/gma500/intel_bios.c             |  3 +
 drivers/gpu/drm/gma500/psb_drv.h                |  1 +
 drivers/gpu/drm/i915/gvt/gtt.c                  |  6 +-
 drivers/gpu/drm/i915/i915_reg.h                 |  6 +-
 drivers/gpu/drm/i915/intel_fbc.c                |  4 ++
 drivers/gpu/drm/i915/intel_workarounds.c        |  2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c      |  4 ++
 drivers/gpu/drm/nouveau/Kconfig                 | 13 +++-
 drivers/gpu/drm/nouveau/nouveau_drm.c           |  7 ++-
 drivers/gpu/drm/radeon/radeon_display.c         |  4 +-
 drivers/i2c/busses/i2c-xiic.c                   |  5 ++
 drivers/irqchip/irq-ath79-misc.c                | 11 ----
 drivers/misc/genwqe/card_dev.c                  |  2 +
 drivers/misc/genwqe/card_utils.c                |  4 ++
 drivers/mtd/nand/spi/macronix.c                 |  8 ++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  4 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |  4 +-
 drivers/net/ethernet/mellanox/mlx4/port.c       |  5 --
 drivers/net/ethernet/ti/cpsw.c                  |  2 +-
 drivers/net/phy/sfp.c                           | 24 ++++++--
 drivers/parisc/ccio-dma.c                       |  4 +-
 drivers/parisc/sba_iommu.c                      |  3 +-
 drivers/tty/serial/serial_core.c                | 24 ++++----
 fs/fuse/file.c                                  |  2 +-
 fs/nfs/nfs4proc.c                               | 32 ++++------
 fs/pstore/platform.c                            | 80 +++++++++++--------------
 fs/pstore/ram.c                                 | 37 +++++++-----
 include/drm/drm_modeset_helper_vtables.h        |  8 +++
 include/linux/cpu.h                             |  4 ++
 include/linux/pstore.h                          |  7 +--
 include/linux/rcupdate.h                        |  6 +-
 include/net/ip6_fib.h                           |  3 +-
 include/net/tls.h                               |  4 ++
 include/uapi/drm/i915_drm.h                     |  2 +-
 kernel/cpu.c                                    |  4 +-
 kernel/power/hibernate.c                        |  9 +++
 lib/test_firmware.c                             | 14 ++---
 net/core/ethtool.c                              |  5 +-
 net/core/fib_rules.c                            |  6 +-
 net/core/neighbour.c                            |  9 ++-
 net/core/pktgen.c                               | 11 ++++
 net/ipv4/route.c                                | 22 +++----
 net/ipv6/raw.c                                  | 25 +++++---
 net/packet/af_packet.c                          |  2 +-
 net/rds/ib_rdma.c                               | 10 ++--
 net/sctp/sm_make_chunk.c                        | 13 +---
 net/sctp/sm_sideeffect.c                        |  5 ++
 net/tls/tls_device.c                            | 27 +++++++--
 66 files changed, 461 insertions(+), 269 deletions(-)


