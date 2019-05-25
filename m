Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E562A591
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 18:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfEYQ6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 12:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbfEYQ6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 May 2019 12:58:44 -0400
Received: from localhost (unknown [62.129.28.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19ACB20879;
        Sat, 25 May 2019 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558803522;
        bh=uVfgFATFH/5XTQPK6CtZRWfL1Qfhj2dJrDMoOohWJBA=;
        h=Date:From:To:Cc:Subject:From;
        b=u0/YjbM8zVSuNbKpyt2iZsxB+Nsf6tS7ldbdU4k+6lqGCn7mGJ2E6hcYeo+f3ovif
         jbk9XeQBn/EcmKT2axxonOQNp+nMJAiY7VIUYoziICsz9qN6Os4i757wLswzjdtxqK
         gJLnnkZk9p3Zbs9sHgbTTH0aewio1rIlmfTw1f1I=
Date:   Sat, 25 May 2019 18:58:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.5
Message-ID: <20190525165840.GA7034@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.5 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/filesystems/porting                       |    5=20
 Makefile                                                |    2=20
 arch/Kconfig                                            |    2=20
 arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi           |    2=20
 arch/mips/kernel/perf_event_mipsxx.c                    |   21 -
 arch/parisc/boot/compressed/head.S                      |    6=20
 arch/parisc/include/asm/assembly.h                      |    6=20
 arch/parisc/include/asm/cache.h                         |   10=20
 arch/parisc/kernel/head.S                               |    4=20
 arch/parisc/kernel/process.c                            |    1=20
 arch/parisc/kernel/syscall.S                            |    2=20
 arch/parisc/mm/init.c                                   |    2=20
 arch/powerpc/include/asm/mmu_context.h                  |    1=20
 arch/um/include/asm/mmu_context.h                       |    1=20
 arch/unicore32/include/asm/mmu_context.h                |    1=20
 arch/x86/entry/entry_64.S                               |   18 +
 arch/x86/include/asm/mmu_context.h                      |    6=20
 arch/x86/include/asm/mpx.h                              |   15=20
 arch/x86/include/asm/text-patching.h                    |   28 +
 arch/x86/kernel/ftrace.c                                |   32 +-
 arch/x86/mm/mpx.c                                       |   10=20
 block/blk-core.c                                        |    2=20
 block/blk-mq-sysfs.c                                    |    6=20
 block/blk-mq.c                                          |    8=20
 block/blk-mq.h                                          |    2=20
 drivers/base/dd.c                                       |    5=20
 drivers/block/brd.c                                     |    7=20
 drivers/clk/hisilicon/clk-hi3660.c                      |    6=20
 drivers/clk/mediatek/clk-pll.c                          |   48 ++-
 drivers/clk/rockchip/clk-rk3328.c                       |   18 -
 drivers/clk/tegra/clk-pll.c                             |    4=20
 drivers/dma/imx-sdma.c                                  |   15=20
 drivers/hwtracing/intel_th/msu.c                        |   35 ++
 drivers/hwtracing/stm/core.c                            |    9=20
 drivers/infiniband/hw/mlx5/main.c                       |    5=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c               |   13=20
 drivers/iommu/tegra-smmu.c                              |   25 +
 drivers/md/dm-cache-metadata.c                          |    9=20
 drivers/md/dm-crypt.c                                   |    9=20
 drivers/md/dm-delay.c                                   |    3=20
 drivers/md/dm-init.c                                    |    8=20
 drivers/md/dm-integrity.c                               |    4=20
 drivers/md/dm-ioctl.c                                   |    6=20
 drivers/md/dm-mpath.c                                   |    2=20
 drivers/md/dm-zoned-metadata.c                          |    5=20
 drivers/md/dm.c                                         |    4=20
 drivers/md/md.c                                         |  180 +++++------
 drivers/md/md.h                                         |   25 -
 drivers/md/raid5.c                                      |   29 +
 drivers/media/i2c/ov6650.c                              |    2=20
 drivers/media/platform/Kconfig                          |    2=20
 drivers/memory/tegra/mc.c                               |    2=20
 drivers/net/Makefile                                    |    2=20
 drivers/net/ethernet/mellanox/mlx4/mcg.c                |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig         |    1=20
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c          |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c    |   18 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c        |   19 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c         |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c       |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c     |   30 -
 drivers/net/ethernet/mellanox/mlxsw/core.c              |    6=20
 drivers/net/ethernet/mellanox/mlxsw/core.h              |    2=20
 drivers/net/ethernet/mellanox/mlxsw/core_env.c          |   18 +
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c        |    3=20
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c      |    6=20
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c |   17 -
 drivers/net/ppp/ppp_deflate.c                           |   20 -
 drivers/net/usb/qmi_wwan.c                              |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c  |   26 +
 drivers/net/wireless/intersil/p54/p54pci.c              |    3=20
 drivers/parisc/led.c                                    |    3=20
 drivers/pci/controller/pcie-rcar.c                      |   21 +
 drivers/pci/pci.h                                       |    2=20
 drivers/pci/pcie/aspm.c                                 |   49 ++-
 drivers/pci/probe.c                                     |   23 -
 drivers/pci/quirks.c                                    |   77 +++++
 drivers/phy/ti/phy-ti-pipe3.c                           |    2=20
 drivers/regulator/core.c                                |   11=20
 drivers/staging/media/imx/imx-ic-common.c               |    2=20
 drivers/staging/media/imx/imx-media-csi.c               |   18 -
 drivers/staging/media/imx/imx-media-dev.c               |   11=20
 drivers/staging/media/imx/imx-media-internal-sd.c       |   32 --
 drivers/staging/media/imx/imx-media-of.c                |   73 +++-
 drivers/staging/media/imx/imx-media-vdic.c              |    2=20
 drivers/staging/media/imx/imx-media.h                   |    7=20
 drivers/staging/media/imx/imx7-media-csi.c              |    2=20
 drivers/video/fbdev/efifb.c                             |    8=20
 drivers/video/fbdev/sm712.h                             |   12=20
 drivers/video/fbdev/sm712fb.c                           |  243 +++++++++++=
+----
 drivers/video/fbdev/udlfb.c                             |  114 +++++--
 fs/btrfs/relocation.c                                   |   12=20
 fs/ceph/super.c                                         |    7=20
 fs/cifs/cifsglob.h                                      |    1=20
 fs/cifs/cifssmb.c                                       |    2=20
 fs/cifs/smb2ops.c                                       |   14=20
 fs/cifs/transport.c                                     |   10=20
 fs/dcache.c                                             |   24 -
 fs/fuse/file.c                                          |   13=20
 fs/nfs/filelayout/filelayout.c                          |    2=20
 fs/nfs/nfs4state.c                                      |    4=20
 fs/notify/fsnotify.c                                    |   41 ++
 fs/nsfs.c                                               |    3=20
 fs/overlayfs/copy_up.c                                  |    6=20
 fs/overlayfs/file.c                                     |    5=20
 fs/overlayfs/overlayfs.h                                |    2=20
 fs/proc/base.c                                          |    5=20
 include/asm-generic/mm_hooks.h                          |    1=20
 include/linux/bpf.h                                     |    1=20
 include/linux/dcache.h                                  |    2=20
 include/linux/fsnotify.h                                |   33 --
 include/linux/fsnotify_backend.h                        |    4=20
 include/linux/mlx5/driver.h                             |    1=20
 include/linux/of.h                                      |    4=20
 include/linux/pci.h                                     |    2=20
 include/linux/skbuff.h                                  |    9=20
 include/net/flow_offload.h                              |    2=20
 include/net/ip6_fib.h                                   |    3=20
 include/uapi/linux/fuse.h                               |    2=20
 include/video/udlfb.h                                   |    7=20
 kernel/bpf/hashtab.c                                    |   23 +
 kernel/bpf/inode.c                                      |    2=20
 kernel/bpf/syscall.c                                    |    5=20
 kernel/trace/trace_events.c                             |    3=20
 kernel/trace/trace_probe.c                              |   13=20
 mm/mmap.c                                               |   15=20
 net/core/dev.c                                          |    2=20
 net/core/flow_offload.c                                 |    7=20
 net/core/rtnetlink.c                                    |   16 -
 net/ipv6/ip6_fib.c                                      |   12=20
 net/ipv6/route.c                                        |   58 ++-
 net/tipc/core.c                                         |   14=20
 net/vmw_vsock/virtio_transport.c                        |   13=20
 net/vmw_vsock/virtio_transport_common.c                 |    7=20
 scripts/gcc-plugins/arm_ssp_per_task_plugin.c           |    2=20
 tools/objtool/Makefile                                  |    3=20
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c     |   31 +-
 137 files changed, 1366 insertions(+), 648 deletions(-)

Adam Ford (2):
      ARM: dts: imx6q-logicpd: Reduce inrush current on USBH1
      ARM: dts: imx6q-logicpd: Reduce inrush current on start

Adrian Hunter (3):
      perf intel-pt: Fix instructions sampling rate
      perf intel-pt: Fix improved sample timestamp
      perf intel-pt: Fix sample timestamp wrt non-taken branches

Al Viro (1):
      dcache: sort the freeing-without-RCU-delay mess for good.

Alexander Shishkin (2):
      stm class: Fix channel bitmap on 32-bit systems
      intel_th: msu: Fix single mode with IOMMU

Amir Goldstein (2):
      ovl: fix missing upper fs freeze protection on copy up for ioctl
      fsnotify: fix unlink performance regression

Angus Ainslie (Purism) (1):
      dmaengine: imx-sdma: Only check ratio on parts that support 1:1

Ard Biesheuvel (1):
      fbdev/efifb: Ignore framebuffer memmap entries that lack any memory t=
ypes

Arnd Bergmann (2):
      media: seco-cec: fix building with RC_CORE=3Dm
      y2038: Make CONFIG_64BIT_TIME unconditional

Bodong Wang (1):
      net/mlx5: Fix peer pf disable hca command

Chenbo Feng (1):
      bpf: relax inode permission check for retrieving bpf program

Chris Packham (1):
      gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC < 6

Christoph Hellwig (1):
      md: add a missing endianness conversion in check_sb_changes

Christoph Probst (1):
      cifs: fix strcat buffer overflow and reduce raciness in smb21_set_opl=
ock_level()

Colin Ian King (1):
      phy: ti-pipe3: fix missing bit-wise or operator when assigning val

Damien Le Moal (1):
      dm zoned: Fix zone report handling

Daniel Borkmann (2):
      bpf: add map_lookup_elem_sys_only for lookups from syscall side
      bpf, lru: avoid messing with eviction heuristics upon syscall lookup

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions

Dave Hansen (1):
      x86/mpx, mm/core: Fix recursive munmap() corruption

Dmitry Osipenko (3):
      clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divi=
der
      iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114
      memory: tegra: Fix integer overflow on tick value calculation

Dmytro Linkin (2):
      net/mlx5e: Add missing ethtool driver info for representors
      net/mlx5e: Additional check for flow destination comparison

Edward Cree (1):
      flow_offload: support CVLAN match

Elazar Leibovich (1):
      tracing: Fix partial reading of trace event's id file

Eric Dumazet (2):
      ipv6: prevent possible fib6 leaks
      net: avoid weird emergency message

Florian Fainelli (2):
      net: Always descend into dsa/
      MIPS: perf: Fix build with CONFIG_CPU_BMIPS5000 enabled

Greg Kroah-Hartman (1):
      Linux 5.1.5

Hans de Goede (1):
      brcmfmac: Add DMI nvram filename quirk for ACEPC T8 and T11 mini PCs

Helen Koike (2):
      dm init: fix max devices/targets checks
      dm ioctl: fix hang in early create error condition

Helge Deller (6):
      parisc: Export running_on_qemu symbol for modules
      parisc: Skip registering LED when running in QEMU
      parisc: Add memory barrier to asm pdc and sync instructions
      parisc: Allow live-patching of __meminit functions
      parisc: Use PA_ASM_LEVEL in boot code
      parisc: Rename LEVEL to PA_ASM_LEVEL to avoid name clash with DRBD co=
de

Hou Tao (1):
      brd: re-enable __GFP_HIGHMEM in brd_insert_page()

James Prestwood (1):
      PCI: Mark Atheros AR9462 to avoid bus reset

Janusz Krzysztofik (1):
      media: ov6650: Fix sensor possibly not detected on probe

Jason Gunthorpe (1):
      RDMA/mlx5: Use get_zeroed_page() for clock_info

Jean-Philippe Brucker (1):
      PCI: Init PCIe feature bits for managed host bridge alloc

Jeff Layton (1):
      ceph: flush dirty inodes before proceeding with remount

Jianbo Liu (1):
      net/mlx5e: Fix calling wrong function to get inner vlan key and mask

Jisheng Zhang (1):
      PCI/AER: Change pci_aer_init() stub to return void

John David Anglin (1):
      parisc: Add memory clobber to TLB purges

John Garry (1):
      driver core: Postpone DMA tear-down until after devres release for pr=
obe failure

Jonas Karlman (1):
      clk: rockchip: fix wrong clock definitions for rk3328

Jorge E. Moreira (1):
      vsock/virtio: Initialize core virtio vsock before registering the dri=
ver

Josh Poimboeuf (1):
      x86_64: Add gap to int3 to allow for call emulation

Junwei Hu (2):
      tipc: switch order of device registration to fix a crash
      tipc: fix modprobe tipc failed after switch order of device registrat=
ion

Kazufumi Ikeda (1):
      PCI: rcar: Add the initialization of PCIe link in resume_noirq()

Kirill Smelkov (1):
      fuse: Add FOPEN_STREAM to use stream_open()

Leo Yan (1):
      clk: hi3660: Mark clk_gate_ufs_subsys as critical

Leon Romanovsky (1):
      RDMA/ipoib: Allow user space differentiate between valid dev_port

Liu Bo (1):
      fuse: honor RLIMIT_FSIZE in fuse_file_fallocate

Lyude Paul (1):
      PCI: Reset Lenovo ThinkPad P50 nvgpu at boot if necessary

Martin Wilck (1):
      dm mpath: always free attached_handler_name in parse_path()

Masami Hiramatsu (1):
      tracing: probeevent: Fix to make the type of $comm string

Michael Lass (1):
      dm: make sure to obey max_io_len_target_boundary

Miklos Szeredi (1):
      fuse: fix writepages on 32bit

Mikulas Patocka (5):
      udlfb: delete the unused parameter for dlfb_handle_damage
      udlfb: fix sleeping inside spinlock
      udlfb: introduce a rendering mutex
      dm delay: fix a crash when invalid device is specified
      dm integrity: correctly calculate the size of metadata area

Milan Broz (1):
      dm crypt: move detailed message into debug level

Ming Lei (1):
      blk-mq: free hw queue's resource in hctx's release handler

Nathan Chancellor (1):
      objtool: Allow AR to be overridden with HOSTAR

NeilBrown (2):
      Revert "MD: fix lock contention for flush bios"
      md: batch flush requests.

Nigel Croxon (1):
      md/raid: raid5 preserve the writeback action after the parity check

Nikolai Kostrigin (1):
      PCI: Mark AMD Stoney Radeon R7 GPU ATS as broken

Nikos Tsironis (1):
      dm cache metadata: Fix loading discard bitset

Olga Kornievskaia (1):
      PNFS fallback to MDS if no deviceid found

Owen Chen (1):
      clk: mediatek: Disable tuner_en before change PLL rate

Pan Bian (1):
      p54: drop device reference count if fails to enable device

Paul Moore (1):
      proc: prevent changes to overridden credentials

Peter Zijlstra (2):
      x86_64: Allow breakpoints to emulate call instructions
      ftrace/x86_64: Emulate call function while updating in breakpoint han=
dler

Phong Tran (1):
      of: fix clang -Wunsequenced for be32_to_cpu()

Pieter Jansen van Vuuren (1):
      nfp: flower: add rcu locks when accessing netdev for tunnels

Qu Wenruo (1):
      btrfs: reloc: Fix NULL pointer dereference due to expanded reloc_root=
 lifespan

Ronnie Sahlberg (1):
      cifs: fix credits leak for SMB1 oplock breaks

Sabrina Dubroca (1):
      rtnetlink: always put IFLA_LINK for links with a link-netnsid

Saeed Mahameed (2):
      net/mlx5: Imply MLXFW in mlx5_core
      net/mlx5e: Fix ethtool rxfh commands when CONFIG_MLX5_EN_RXNFC is dis=
abled

Song Liu (1):
      Revert "Don't jump to compute_result state from check_result state"

Stefan M=E4tje (2):
      PCI: Factor out pcie_retrain_link() function
      PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum

Stefano Garzarella (1):
      vsock/virtio: free packets during the socket release

Steve Longerbeam (4):
      media: imx: csi: Allow unknown nearest upstream entities
      media: imx: Clear fwnode link struct for each endpoint iteration
      media: imx: Rename functions that add IPU-internal subdevs
      media: imx: Don't register IPU subdevs/links if CSI port missing

Steve Twiss (1):
      regulator: core: fix error path for regulator_set_voltage_unlocked

Tingwei Zhang (1):
      stm class: Fix channel free in stm output free path

Vadim Pasternak (2):
      mlxsw: core: Prevent QSFP module initialization for old hardware
      mlxsw: core: Prevent reading unsupported slave address from SFP EEPROM

Wei Wang (1):
      ipv6: fix src addr routing with the exception table

Willem de Bruijn (1):
      net: test nouarg before dereferencing zerocopy pointers

Yifeng Li (9):
      fbdev: sm712fb: fix brightness control on reboot, don't set SR30
      fbdev: sm712fb: fix VRAM detection, don't set SR70/71/74/75
      fbdev: sm712fb: fix white screen of death on reboot, don't set CR3B-C=
R3F
      fbdev: sm712fb: fix boot screen glitch when sm712fb replaces VGA
      fbdev: sm712fb: fix crashes during framebuffer writes by correctly ma=
pping VRAM
      fbdev: sm712fb: fix support for 1024x768-16 mode
      fbdev: sm712fb: use 1024x768 by default on non-MIPS, fix garbled disp=
lay
      fbdev: sm712fb: fix crashes and garbled display during DPMS modesetti=
ng
      fbdev: sm712fb: fix memory frequency by avoiding a switch/case fallth=
rough

YueHaibing (1):
      ppp: deflate: Fix possible crash in deflate_init

Yufen Yu (1):
      md: add mddev->pers to avoid potential NULL pointer dereference

Yunjian Wang (1):
      net/mlx4_core: Change the error print to info print

ZhangXiaoxu (1):
      NFS4: Fix v4.0 client state corruption when mount


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzpdD0ACgkQONu9yGCS
aT4gQRAAt1aSfEimYR/8JXEwviawBAcgmEC0IiNHzkMKNWkUdot2p/1vdrfJ5sJV
WbOoNSE1EYXMfQ2j5SAyfI+o/uKMhJOBip8miFDQeITyE+eFhWKs5LAXscgRXfvU
ZXXnAtscr2qgZY7Lyv/uXkA4rjJDQDdXsiGiQtnC/N8gTE35AuCef7nSrPAV7K5w
kXnYKEmRjkOJZEPI8Mk449zgNzPf6bUvV6e1cRs6xSfCY5HVWnNiKLWIU1TJBGB7
cTqkEDAV41WxPbYbrje/1xlDNMXYtvyhmHlrSqwDfzU8m0iaM6WY9CwI+o4gIbQU
xNofk7+5PRCc7D/wdxJWIgoPvOd1ExojsqmbYkhHNMwpUCN64p+B42TP2qmFxpK8
CkdUgBa/v/ansGdXHHxDW/ZYsOrJzVyeGVK0oTUy1NptUHmmrcScGvISzfl7nIQr
jljVTWMF+F7+DcY3lJWoRfkILv9q82Fds3xYOpYS85wQqSpi5xEdePkWH2Cu/WL6
6wc5HUMF8gAvrARKQF9vyo+i5fSNcpnWjSU9KP5haU98Lh1IgonRz78dqgu2RVCG
klR8cT/3ZdthxTBTb8bn1YlONGr9tePUpjYY+Rjz4BU4uBqBeO7RlIa1v8CazDY0
3K1ccZ73I17QYovWU9bF/DLhUfnIAZEApT3nBJgGLXnKpIuQ43w=
=pppN
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
