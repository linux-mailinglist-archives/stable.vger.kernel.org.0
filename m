Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9BD2FAAAF
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390339AbhARTyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390291AbhARLh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:37:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EFC022573;
        Mon, 18 Jan 2021 11:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969779;
        bh=Jhs7F8l0cBWSsGOEYLeYPggOejCASdUtwVIRY+xjVXo=;
        h=From:To:Cc:Subject:Date:From;
        b=XnqJIr47T1lCS2h70VGOXHAj9B2ZZS6c5GNkdggHbQ/7E2KWpqFaitZnnCU6hJzJ2
         17RqNf1dFEJZt1AkZICJXsjw8kANWWWPuEN4YR7oAwU2r9LuRSpBJTx15jl/Jsl01e
         oKF2u+ceLL9Rq+9awQafC7GUcXBEjwtb6ul1e2gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/43] 4.19.169-rc1 review
Date:   Mon, 18 Jan 2021 12:34:23 +0100
Message-Id: <20210118113334.966227881@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.169-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.169-rc1
X-KernelTest-Deadline: 2021-01-20T11:33+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.169 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.169-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.169-rc1

Olaf Hering <olaf@aepfle.de>
    kbuild: enforce -Werror=return-type

Dinghao Liu <dinghao.liu@zju.edu.cn>
    netfilter: nf_nat: Fix memleak in nf_nat_init

Jesper Dangaard Brouer <brouer@redhat.com>
    netfilter: conntrack: fix reading nf_conntrack_buckets

Geert Uytterhoeven <geert+renesas@glider.be>
    ALSA: fireface: Fix integer overflow in transmit_midi_msg()

Geert Uytterhoeven <geert+renesas@glider.be>
    ALSA: firewire-tascam: Fix integer overflow in midi_port_work()

Mike Snitzer <snitzer@redhat.com>
    dm: eliminate potential source of excessive kernel log noise

j.nixdorf@avm.de <j.nixdorf@avm.de>
    net: sunrpc: interpret the return value of kstrtou32 correctly

Jann Horn <jannh@google.com>
    mm, slub: consider rest of partial list if acquire_slab() fails

Mark Bloch <mbloch@nvidia.com>
    RDMA/mlx5: Fix wrong free of blue flame register on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp

Jan Kara <jack@suse.cz>
    ext4: fix superblock checksum failure when setting password salt

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_igrab_and_active must first reference the superblock

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/pNFS: Fix a leak of the layout 'plh_outstanding' counter

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Mark layout for return if return-on-close was not sent

Dave Wysochanski <dwysocha@redhat.com>
    NFS4: Fix use-after-free in trace_event_raw_event_nfs4_set_lock

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: Intel: fix error code cnl_set_dsp_D0()

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm-interface: fix loopback

Al Viro <viro@zeniv.linux.org.uk>
    dump_common_audit_data(): fix racy accesses to ->d_name

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Remove __init annotation from ima_pcrread()

Arnd Bergmann <arnd@arndb.de>
    ARM: picoxcell: fix missing interrupt-parent properties

Craig Tatlor <ctatlor97@gmail.com>
    drm/msm: Call msm_init_vram before binding the gpu

Shawn Guo <shawn.guo@linaro.org>
    ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI

Michael Ellerman <mpe@ellerman.id.au>
    net: ethernet: fs_enet: Add missing MODULE_LICENSE

Arnd Bergmann <arnd@arndb.de>
    misdn: dsp: select CONFIG_BITREVERSE

Randy Dunlap <rdunlap@infradead.org>
    arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC

Jan Kara <jack@suse.cz>
    bfq: Fix computation of shallow depth

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction leak and crash after RO remount caused by qgroup rescan

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: add boot_targets to PHONY

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: add uImage.lzma to the top-level target

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: remove non-existing bootpImage from KBUILD_IMAGE

yangerkun <yangerkun@huawei.com>
    ext4: fix bug for rename with RENAME_WHITEOUT

Leon Schuermann <leon@is.currently.online>
    r8152: Add Lenovo Powered USB-C Travel Hub

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix the maximum number of arguments

Akilesh Kailash <akailash@google.com>
    dm snapshot: flush merged data before committing metadata

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix potential missing huge page size info

Dexuan Cui <decui@microsoft.com>
    ACPI: scan: Harden acpi_device_add() against device ID overflows

Alexander Lobakin <alobakin@pm.me>
    MIPS: relocatable: fix possible boot hangup with KASLR enabled

Al Viro <viro@zeniv.linux.org.uk>
    MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps

Paul Cercueil <paul@crapouillou.net>
    MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/kprobes: Do the notrace functions check without kprobes on ftrace

Wei Liu <wei.liu@kernel.org>
    x86/hyperv: check cpu mask after interrupt has been disabled

Thomas Hebb <tommyhebb@gmail.com>
    ASoC: dapm: remove widget from dirty list on free


-------------

Diffstat:

 Makefile                                           |  6 +++---
 arch/arc/Makefile                                  |  9 ++------
 arch/arc/include/asm/page.h                        |  1 +
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi             |  4 ++++
 arch/mips/boot/compressed/decompress.c             |  3 ++-
 arch/mips/kernel/binfmt_elfn32.c                   |  7 +++++++
 arch/mips/kernel/binfmt_elfo32.c                   |  7 +++++++
 arch/mips/kernel/relocate.c                        | 10 +++++++--
 arch/x86/hyperv/mmu.c                              | 12 ++++++++---
 block/bfq-iosched.c                                |  8 ++++----
 drivers/acpi/internal.h                            |  2 +-
 drivers/acpi/scan.c                                | 15 +++++++++++++-
 drivers/gpu/drm/msm/msm_drv.c                      |  8 ++++----
 drivers/infiniband/hw/mlx5/main.c                  |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |  3 +++
 drivers/isdn/mISDN/Kconfig                         |  1 +
 drivers/md/dm-integrity.c                          |  2 +-
 drivers/md/dm-snap.c                               | 24 ++++++++++++++++++++++
 drivers/md/dm.c                                    |  2 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |  1 +
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |  1 +
 drivers/net/ethernet/freescale/ucc_geth.h          |  9 +++++++-
 drivers/net/usb/cdc_ether.c                        |  7 +++++++
 drivers/net/usb/r8152.c                            |  1 +
 fs/btrfs/qgroup.c                                  | 13 +++++++++---
 fs/btrfs/super.c                                   |  8 ++++++++
 fs/ext4/ioctl.c                                    |  3 +++
 fs/ext4/namei.c                                    | 16 ++++++++-------
 fs/nfs/internal.h                                  | 12 ++++++-----
 fs/nfs/nfs4proc.c                                  |  2 +-
 fs/nfs/pnfs.c                                      |  7 +++++++
 include/linux/acpi.h                               |  7 +++++++
 kernel/trace/Kconfig                               |  2 +-
 kernel/trace/trace_kprobe.c                        |  2 +-
 mm/hugetlb.c                                       |  2 +-
 mm/slub.c                                          |  2 +-
 net/netfilter/nf_conntrack_standalone.c            |  3 +++
 net/netfilter/nf_nat_core.c                        |  1 +
 net/sunrpc/addr.c                                  |  2 +-
 security/integrity/ima/ima_crypto.c                |  2 +-
 security/lsm_audit.c                               |  7 +++++--
 sound/firewire/fireface/ff-transaction.c           |  2 +-
 sound/firewire/tascam/tascam-transaction.c         |  2 +-
 sound/soc/intel/skylake/cnl-sst.c                  |  1 +
 sound/soc/meson/axg-tdm-interface.c                | 14 ++++++++++++-
 sound/soc/soc-dapm.c                               |  1 +
 46 files changed, 199 insertions(+), 57 deletions(-)


