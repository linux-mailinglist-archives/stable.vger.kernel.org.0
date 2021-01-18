Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120152FA9DA
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437072AbhARTOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:14:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390495AbhARLiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF81722C9E;
        Mon, 18 Jan 2021 11:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969901;
        bh=wTnl8cf4hqaqIdGa1qx0ao9ofSsFXP9dyHM7QhcXslg=;
        h=From:To:Cc:Subject:Date:From;
        b=f4Mw1Nt9pSa7jfUlWmxDA8ltgey70LMd6AxOKSiC3EW7zRkO9m8MWizcOY1HEjL4b
         Qx25mSD0ch1cCz0Um72O6FCyroYEOGJ2hfAsvIuBqG9IFUKIA269p9w1ZDOcZ1JasQ
         o1xdi1AFTRQMv6rpqKJ8f8MohJW1IHgpu/22LiiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/76] 5.4.91-rc1 review
Date:   Mon, 18 Jan 2021 12:34:00 +0100
Message-Id: <20210118113340.984217512@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.91-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.91-rc1
X-KernelTest-Deadline: 2021-01-20T11:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.91 release.
There are 76 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.91-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.91-rc1

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: remove flush counter optimization

Dinghao Liu <dinghao.liu@zju.edu.cn>
    netfilter: nf_nat: Fix memleak in nf_nat_init

Jesper Dangaard Brouer <brouer@redhat.com>
    netfilter: conntrack: fix reading nf_conntrack_buckets

Geert Uytterhoeven <geert+renesas@glider.be>
    ALSA: firewire-tascam: Fix integer overflow in midi_port_work()

Geert Uytterhoeven <geert+renesas@glider.be>
    ALSA: fireface: Fix integer overflow in transmit_midi_msg()

Mike Snitzer <snitzer@redhat.com>
    dm: eliminate potential source of excessive kernel log noise

j.nixdorf@avm.de <j.nixdorf@avm.de>
    net: sunrpc: interpret the return value of kstrtou32 correctly

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix unaligned addresses for intel_flush_svm_range_dev()

Jann Horn <jannh@google.com>
    mm, slub: consider rest of partial list if acquire_slab() fails

Hans de Goede <hdegoede@redhat.com>
    drm/i915/dsi: Use unconditional msleep for the panel_on_delay when there is no reset-deassert MIPI-sequence

Parav Pandit <parav@nvidia.com>
    IB/mlx5: Fix error unwinding when set_has_smi_cap fails

Mark Bloch <mbloch@nvidia.com>
    RDMA/mlx5: Fix wrong free of blue flame register on error

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve stats context resource accounting with RDMA driver loaded.

Dinghao Liu <dinghao.liu@zju.edu.cn>
    RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp

Leon Romanovsky <leonro@nvidia.com>
    RDMA/restrack: Don't treat as an error allocation ID wrapping

Jan Kara <jack@suse.cz>
    ext4: fix superblock checksum failure when setting password salt

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_igrab_and_active must first reference the superblock

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/pNFS: Fix a leak of the layout 'plh_outstanding' counter

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Stricter ordering of layoutget and layoutreturn

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Mark layout for return if return-on-close was not sent

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: We want return-on-close to complete when evicting the inode

Dave Wysochanski <dwysocha@redhat.com>
    NFS4: Fix use-after-free in trace_event_raw_event_nfs4_set_lock

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible data corruption with bio merges

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: Intel: fix error code cnl_set_dsp_D0()

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdmin: fix axg skew offset

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm-interface: fix loopback

Al Viro <viro@zeniv.linux.org.uk>
    dump_common_audit_data(): fix racy accesses to ->d_name

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix 'CPU too large' error

Arnd Bergmann <arnd@arndb.de>
    ARM: picoxcell: fix missing interrupt-parent properties

Craig Tatlor <ctatlor97@gmail.com>
    drm/msm: Call msm_init_vram before binding the gpu

Shawn Guo <shawn.guo@linaro.org>
    ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI

Peter Robinson <pbrobinson@gmail.com>
    usb: typec: Fix copy paste error for NVIDIA alt-mode description

Dennis Li <Dennis.Li@amd.com>
    drm/amdgpu: fix a GPU hang issue when remove device

Israel Rukshin <israelr@nvidia.com>
    nvmet-rdma: Fix list_del corruption on queue establishment failure

Gopal Tiwari <gtiwari@redhat.com>
    nvme-pci: mark Samsung PM1725a as IGNORE_DEV_SUBNQN

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: fix the return value for UDP GRO test

Michael Ellerman <mpe@ellerman.id.au>
    net: ethernet: fs_enet: Add missing MODULE_LICENSE

Arnd Bergmann <arnd@arndb.de>
    misdn: dsp: select CONFIG_BITREVERSE

Randy Dunlap <rdunlap@infradead.org>
    arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC

Jan Kara <jack@suse.cz>
    bfq: Fix computation of shallow depth

John Millikin <john@john-millikin.com>
    lib/raid6: Let $(UNROLL) rules work with macOS userland

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    hwmon: (pwm-fan) Ensure that calculation doesn't discard big period values

Dinghao Liu <dinghao.liu@zju.edu.cn>
    habanalabs: Fix memleak in hl_device_reset

Oded Gabbay <ogabbay@kernel.org>
    habanalabs: register to pci shutdown callback

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram

Guido Günther <agx@sigxcpu.org>
    regulator: bd718x7: Add enable times

Filipe Manana <fdmanana@suse.com>
    btrfs: fix transaction leak and crash after RO remount caused by qgroup rescan

Vasily Averin <vvs@virtuozzo.com>
    netfilter: ipset: fixes possible oops in mtype_resize

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: move symlink creation to arch/arc/Makefile to avoid race

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: add boot_targets to PHONY

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: add uImage.lzma to the top-level target

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: remove non-existing bootpImage from KBUILD_IMAGE

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix flush with external metadata device

Paulo Alcantara <pc@cjr.nz>
    cifs: fix interrupted close commands

Steve French <stfrench@microsoft.com>
    smb3: remove unused flag passed into close functions

Theodore Ts'o <tytso@mit.edu>
    ext4: don't leak old mountpoint samples

yangerkun <yangerkun@huawei.com>
    ext4: fix bug for rename with RENAME_WHITEOUT

Jani Nikula <jani.nikula@intel.com>
    drm/i915/backlight: fix CPU mode backlight takeover on LPT

Su Yue <l@damenly.su>
    btrfs: tree-checker: check if chunk item end overflows

Leon Schuermann <leon@is.currently.online>
    r8152: Add Lenovo Powered USB-C Travel Hub

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix the maximum number of arguments

Akilesh Kailash <akailash@google.com>
    dm snapshot: flush merged data before committing metadata

Mike Snitzer <snitzer@redhat.com>
    dm raid: fix discard limits for raid1

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix potential missing huge page size info

Dexuan Cui <decui@microsoft.com>
    ACPI: scan: Harden acpi_device_add() against device ID overflows

Tom Rix <trix@redhat.com>
    RDMA/ocrdma: Fix use after free in ocrdma_dealloc_ucontext_pd()

Alexander Lobakin <alobakin@pm.me>
    MIPS: relocatable: fix possible boot hangup with KASLR enabled

Al Viro <viro@zeniv.linux.org.uk>
    MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps

Paul Cercueil <paul@crapouillou.net>
    MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB

Anders Roxell <anders.roxell@linaro.org>
    mips: lib: uncached: fix non-standard usage of variable 'sp'

Anders Roxell <anders.roxell@linaro.org>
    mips: fix Section mismatch in reference

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/kprobes: Do the notrace functions check without kprobes on ftrace

Wei Liu <wei.liu@kernel.org>
    x86/hyperv: check cpu mask after interrupt has been disabled

Thomas Hebb <tommyhebb@gmail.com>
    ASoC: dapm: remove widget from dirty list on free

Su Yue <l@damenly.su>
    btrfs: prevent NULL pointer dereference in extent_io_tree_panic

Olaf Hering <olaf@aepfle.de>
    kbuild: enforce -Werror=return-type


-------------

Diffstat:

 Makefile                                           |  6 +--
 arch/arc/Makefile                                  | 20 +++++---
 arch/arc/boot/Makefile                             | 11 +---
 arch/arc/include/asm/page.h                        |  1 +
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi             |  4 ++
 arch/mips/boot/compressed/decompress.c             |  3 +-
 arch/mips/kernel/binfmt_elfn32.c                   |  7 +++
 arch/mips/kernel/binfmt_elfo32.c                   |  7 +++
 arch/mips/kernel/relocate.c                        | 10 +++-
 arch/mips/lib/uncached.c                           |  4 +-
 arch/mips/mm/c-r4k.c                               |  2 +-
 arch/mips/mm/sc-mips.c                             |  4 +-
 arch/x86/hyperv/mmu.c                              | 12 +++--
 block/bfq-iosched.c                                |  8 +--
 drivers/acpi/internal.h                            |  2 +-
 drivers/acpi/scan.c                                | 15 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  4 +-
 drivers/gpu/drm/i915/display/intel_panel.c         |  9 ++--
 drivers/gpu/drm/i915/display/vlv_dsi.c             | 16 ++++--
 drivers/gpu/drm/msm/msm_drv.c                      |  8 +--
 drivers/hwmon/pwm-fan.c                            | 12 ++++-
 drivers/infiniband/core/restrack.c                 |  1 +
 drivers/infiniband/hw/mlx5/main.c                  |  4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |  3 ++
 drivers/iommu/intel-svm.c                          | 22 +++++++-
 drivers/isdn/mISDN/Kconfig                         |  1 +
 drivers/md/dm-bufio.c                              |  6 +++
 drivers/md/dm-integrity.c                          | 58 ++++++++++++++++++----
 drivers/md/dm-raid.c                               |  6 +--
 drivers/md/dm-snap.c                               | 24 +++++++++
 drivers/md/dm.c                                    |  2 +-
 drivers/misc/habanalabs/device.c                   |  2 +
 drivers/misc/habanalabs/habanalabs_drv.c           |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |  8 ++-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |  1 +
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |  1 +
 drivers/net/ethernet/freescale/ucc_geth.h          |  9 +++-
 drivers/net/usb/cdc_ether.c                        |  7 +++
 drivers/net/usb/r8152.c                            |  1 +
 drivers/nvme/host/pci.c                            |  3 +-
 drivers/nvme/host/tcp.c                            |  2 +-
 drivers/nvme/target/rdma.c                         | 10 ++++
 drivers/regulator/bd718x7-regulator.c              | 57 +++++++++++++++++++++
 drivers/usb/typec/altmodes/Kconfig                 |  2 +-
 fs/btrfs/extent_io.c                               |  4 +-
 fs/btrfs/qgroup.c                                  | 13 +++--
 fs/btrfs/super.c                                   |  8 +++
 fs/btrfs/tree-checker.c                            |  7 +++
 fs/cifs/smb2pdu.c                                  | 21 +++-----
 fs/cifs/smb2proto.h                                |  2 -
 fs/ext4/file.c                                     |  2 +-
 fs/ext4/ioctl.c                                    |  3 ++
 fs/ext4/namei.c                                    | 16 +++---
 fs/nfs/internal.h                                  | 12 +++--
 fs/nfs/nfs4proc.c                                  | 28 ++++-------
 fs/nfs/pnfs.c                                      | 58 ++++++++++++----------
 fs/nfs/pnfs.h                                      |  8 ++-
 include/linux/acpi.h                               |  7 +++
 include/linux/dm-bufio.h                           |  1 +
 kernel/trace/Kconfig                               |  2 +-
 kernel/trace/trace_kprobe.c                        |  2 +-
 lib/raid6/Makefile                                 |  2 +-
 mm/hugetlb.c                                       |  2 +-
 mm/slub.c                                          |  2 +-
 net/netfilter/ipset/ip_set_hash_gen.h              | 22 ++++----
 net/netfilter/nf_conntrack_standalone.c            |  3 ++
 net/netfilter/nf_nat_core.c                        |  1 +
 net/netfilter/nft_compat.c                         | 37 ++++++--------
 net/sunrpc/addr.c                                  |  2 +-
 security/lsm_audit.c                               |  7 ++-
 sound/firewire/fireface/ff-transaction.c           |  2 +-
 sound/firewire/tascam/tascam-transaction.c         |  2 +-
 sound/soc/intel/skylake/cnl-sst.c                  |  1 +
 sound/soc/meson/axg-tdm-interface.c                | 14 +++++-
 sound/soc/meson/axg-tdmin.c                        | 13 +----
 sound/soc/soc-dapm.c                               |  1 +
 tools/perf/util/machine.c                          |  4 +-
 tools/perf/util/session.c                          |  2 +-
 tools/testing/selftests/net/udpgro.sh              | 34 +++++++++++++
 80 files changed, 527 insertions(+), 216 deletions(-)


