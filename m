Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CB02A7BE
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 05:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfEZDsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 23:48:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45853 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfEZDsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 23:48:41 -0400
Received: by mail-pf1-f194.google.com with SMTP id s11so7596215pfm.12;
        Sat, 25 May 2019 20:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/CsXyu6NfQ69Qwq5Q23mC7f7AfXpAmSwPJRPARRzWTE=;
        b=dDTDcyo4aRculQiyunakgnQlZrumqE600uaM3VKeXUGVx3HIussXJJJrIZZFDHsOUG
         hdY4I5YpjqdLHooTdQ9ci98i6O06UJclTnlwzY4cigg4vyvbSXlN5VWMoNtFOk0OM+Am
         ImD4vQhsHitdC3OQuNOSsNS+yYJsPVSz+XVeA9NhLBUJo7xmmHt+AXddjXlm4k5AcxAa
         OF+KAiMcH/Ivmk7yD+iyW3Lv2LbSOGUktneO3v0MtrK+b+xsVNR2L04IPfOQyTT8SUgI
         I8Fhe+VYe1Y31Gt9C1QL1B+3/tpG08y62457buaV4Vj3uXpYmuMMljsvCbswgVCu3A/5
         Xwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/CsXyu6NfQ69Qwq5Q23mC7f7AfXpAmSwPJRPARRzWTE=;
        b=AoE3UvgT699bCgNaWfaM2FTmHNE73ioASieDQ1AqWOe/YzL0j4wS5+5H/YVXKz9IzU
         TuEIOndNvZmHcqVpNOgwTKJ2rLZH6amKLkjByMqJhLg2exK6W6fZU/YMGap4Sk12IsqL
         RfpkEid8lpIDU4Kg3IIwp0z0f1PECo+aYWtaIsJCat+cxJZHKe1F6F0rsEWVVRlYa3gF
         g5VXTW2DHlUg0K94LHNZYFRV6ohhuVt0jQzshUIZlJfmv8i4wKh51o+CmcjUUc+Qd3YX
         vEMFk6odhSvbDAsixxE6WTk3kzOKrbadC7U1P3H+QuYIuyDFj6VclY7eJzOgCCI2IMTo
         4Mrg==
X-Gm-Message-State: APjAAAVCWFddc3CdSlKbGv1poaaKgUUjVaaPlXhRg90J/3V+dNaxgy83
        ti0wlnlLbaz7JipZi4n3ExQlpx23hP145g==
X-Google-Smtp-Source: APXvYqyFbVNHMQ/IAaAvDhGaGpD5YhaSGtoigyFIPI2djihrSWALJhN925Q61KL6ZEWfwPflgZxwDg==
X-Received: by 2002:a62:1692:: with SMTP id 140mr102005864pfw.166.1558842519882;
        Sat, 25 May 2019 20:48:39 -0700 (PDT)
Received: from ArchLinux ([103.231.90.173])
        by smtp.gmail.com with ESMTPSA id c14sm6249260pgl.43.2019.05.25.20.48.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 May 2019 20:48:38 -0700 (PDT)
Date:   Sun, 26 May 2019 09:18:25 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.5
Message-ID: <20190526034825.GA30496@ArchLinux>
References: <20190525165840.GA7034@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20190525165840.GA7034@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Thanks, a bunch Greg!

On 18:58 Sat 25 May , Greg KH wrote:
>I'm announcing the release of the 5.1.5 kernel.
>
>All users of the 5.1 kernel series must upgrade.
>
>The updated 5.1.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.1.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Documentation/filesystems/porting                       |    5
> Makefile                                                |    2
> arch/Kconfig                                            |    2
> arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi           |    2
> arch/mips/kernel/perf_event_mipsxx.c                    |   21 -
> arch/parisc/boot/compressed/head.S                      |    6
> arch/parisc/include/asm/assembly.h                      |    6
> arch/parisc/include/asm/cache.h                         |   10
> arch/parisc/kernel/head.S                               |    4
> arch/parisc/kernel/process.c                            |    1
> arch/parisc/kernel/syscall.S                            |    2
> arch/parisc/mm/init.c                                   |    2
> arch/powerpc/include/asm/mmu_context.h                  |    1
> arch/um/include/asm/mmu_context.h                       |    1
> arch/unicore32/include/asm/mmu_context.h                |    1
> arch/x86/entry/entry_64.S                               |   18 +
> arch/x86/include/asm/mmu_context.h                      |    6
> arch/x86/include/asm/mpx.h                              |   15
> arch/x86/include/asm/text-patching.h                    |   28 +
> arch/x86/kernel/ftrace.c                                |   32 +-
> arch/x86/mm/mpx.c                                       |   10
> block/blk-core.c                                        |    2
> block/blk-mq-sysfs.c                                    |    6
> block/blk-mq.c                                          |    8
> block/blk-mq.h                                          |    2
> drivers/base/dd.c                                       |    5
> drivers/block/brd.c                                     |    7
> drivers/clk/hisilicon/clk-hi3660.c                      |    6
> drivers/clk/mediatek/clk-pll.c                          |   48 ++-
> drivers/clk/rockchip/clk-rk3328.c                       |   18 -
> drivers/clk/tegra/clk-pll.c                             |    4
> drivers/dma/imx-sdma.c                                  |   15
> drivers/hwtracing/intel_th/msu.c                        |   35 ++
> drivers/hwtracing/stm/core.c                            |    9
> drivers/infiniband/hw/mlx5/main.c                       |    5
> drivers/infiniband/ulp/ipoib/ipoib_main.c               |   13
> drivers/iommu/tegra-smmu.c                              |   25 +
> drivers/md/dm-cache-metadata.c                          |    9
> drivers/md/dm-crypt.c                                   |    9
> drivers/md/dm-delay.c                                   |    3
> drivers/md/dm-init.c                                    |    8
> drivers/md/dm-integrity.c                               |    4
> drivers/md/dm-ioctl.c                                   |    6
> drivers/md/dm-mpath.c                                   |    2
> drivers/md/dm-zoned-metadata.c                          |    5
> drivers/md/dm.c                                         |    4
> drivers/md/md.c                                         |  180 +++++------
> drivers/md/md.h                                         |   25 -
> drivers/md/raid5.c                                      |   29 +
> drivers/media/i2c/ov6650.c                              |    2
> drivers/media/platform/Kconfig                          |    2
> drivers/memory/tegra/mc.c                               |    2
> drivers/net/Makefile                                    |    2
> drivers/net/ethernet/mellanox/mlx4/mcg.c                |    2
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig         |    1
> drivers/net/ethernet/mellanox/mlx5/core/ecpf.c          |    2
> drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c    |   18 +
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c        |   19 +
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c         |    2
> drivers/net/ethernet/mellanox/mlx5/core/fs_core.c       |    2
> drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c     |   30 -
> drivers/net/ethernet/mellanox/mlxsw/core.c              |    6
> drivers/net/ethernet/mellanox/mlxsw/core.h              |    2
> drivers/net/ethernet/mellanox/mlxsw/core_env.c          |   18 +
> drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c        |    3
> drivers/net/ethernet/mellanox/mlxsw/core_thermal.c      |    6
> drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c |   17 -
> drivers/net/ppp/ppp_deflate.c                           |   20 -
> drivers/net/usb/qmi_wwan.c                              |    2
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c  |   26 +
> drivers/net/wireless/intersil/p54/p54pci.c              |    3
> drivers/parisc/led.c                                    |    3
> drivers/pci/controller/pcie-rcar.c                      |   21 +
> drivers/pci/pci.h                                       |    2
> drivers/pci/pcie/aspm.c                                 |   49 ++-
> drivers/pci/probe.c                                     |   23 -
> drivers/pci/quirks.c                                    |   77 +++++
> drivers/phy/ti/phy-ti-pipe3.c                           |    2
> drivers/regulator/core.c                                |   11
> drivers/staging/media/imx/imx-ic-common.c               |    2
> drivers/staging/media/imx/imx-media-csi.c               |   18 -
> drivers/staging/media/imx/imx-media-dev.c               |   11
> drivers/staging/media/imx/imx-media-internal-sd.c       |   32 --
> drivers/staging/media/imx/imx-media-of.c                |   73 +++-
> drivers/staging/media/imx/imx-media-vdic.c              |    2
> drivers/staging/media/imx/imx-media.h                   |    7
> drivers/staging/media/imx/imx7-media-csi.c              |    2
> drivers/video/fbdev/efifb.c                             |    8
> drivers/video/fbdev/sm712.h                             |   12
> drivers/video/fbdev/sm712fb.c                           |  243 ++++++++++=
++----
> drivers/video/fbdev/udlfb.c                             |  114 +++++--
> fs/btrfs/relocation.c                                   |   12
> fs/ceph/super.c                                         |    7
> fs/cifs/cifsglob.h                                      |    1
> fs/cifs/cifssmb.c                                       |    2
> fs/cifs/smb2ops.c                                       |   14
> fs/cifs/transport.c                                     |   10
> fs/dcache.c                                             |   24 -
> fs/fuse/file.c                                          |   13
> fs/nfs/filelayout/filelayout.c                          |    2
> fs/nfs/nfs4state.c                                      |    4
> fs/notify/fsnotify.c                                    |   41 ++
> fs/nsfs.c                                               |    3
> fs/overlayfs/copy_up.c                                  |    6
> fs/overlayfs/file.c                                     |    5
> fs/overlayfs/overlayfs.h                                |    2
> fs/proc/base.c                                          |    5
> include/asm-generic/mm_hooks.h                          |    1
> include/linux/bpf.h                                     |    1
> include/linux/dcache.h                                  |    2
> include/linux/fsnotify.h                                |   33 --
> include/linux/fsnotify_backend.h                        |    4
> include/linux/mlx5/driver.h                             |    1
> include/linux/of.h                                      |    4
> include/linux/pci.h                                     |    2
> include/linux/skbuff.h                                  |    9
> include/net/flow_offload.h                              |    2
> include/net/ip6_fib.h                                   |    3
> include/uapi/linux/fuse.h                               |    2
> include/video/udlfb.h                                   |    7
> kernel/bpf/hashtab.c                                    |   23 +
> kernel/bpf/inode.c                                      |    2
> kernel/bpf/syscall.c                                    |    5
> kernel/trace/trace_events.c                             |    3
> kernel/trace/trace_probe.c                              |   13
> mm/mmap.c                                               |   15
> net/core/dev.c                                          |    2
> net/core/flow_offload.c                                 |    7
> net/core/rtnetlink.c                                    |   16 -
> net/ipv6/ip6_fib.c                                      |   12
> net/ipv6/route.c                                        |   58 ++-
> net/tipc/core.c                                         |   14
> net/vmw_vsock/virtio_transport.c                        |   13
> net/vmw_vsock/virtio_transport_common.c                 |    7
> scripts/gcc-plugins/arm_ssp_per_task_plugin.c           |    2
> tools/objtool/Makefile                                  |    3
> tools/perf/util/intel-pt-decoder/intel-pt-decoder.c     |   31 +-
> 137 files changed, 1366 insertions(+), 648 deletions(-)
>
>Adam Ford (2):
>      ARM: dts: imx6q-logicpd: Reduce inrush current on USBH1
>      ARM: dts: imx6q-logicpd: Reduce inrush current on start
>
>Adrian Hunter (3):
>      perf intel-pt: Fix instructions sampling rate
>      perf intel-pt: Fix improved sample timestamp
>      perf intel-pt: Fix sample timestamp wrt non-taken branches
>
>Al Viro (1):
>      dcache: sort the freeing-without-RCU-delay mess for good.
>
>Alexander Shishkin (2):
>      stm class: Fix channel bitmap on 32-bit systems
>      intel_th: msu: Fix single mode with IOMMU
>
>Amir Goldstein (2):
>      ovl: fix missing upper fs freeze protection on copy up for ioctl
>      fsnotify: fix unlink performance regression
>
>Angus Ainslie (Purism) (1):
>      dmaengine: imx-sdma: Only check ratio on parts that support 1:1
>
>Ard Biesheuvel (1):
>      fbdev/efifb: Ignore framebuffer memmap entries that lack any memory =
types
>
>Arnd Bergmann (2):
>      media: seco-cec: fix building with RC_CORE=3Dm
>      y2038: Make CONFIG_64BIT_TIME unconditional
>
>Bodong Wang (1):
>      net/mlx5: Fix peer pf disable hca command
>
>Chenbo Feng (1):
>      bpf: relax inode permission check for retrieving bpf program
>
>Chris Packham (1):
>      gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC < 6
>
>Christoph Hellwig (1):
>      md: add a missing endianness conversion in check_sb_changes
>
>Christoph Probst (1):
>      cifs: fix strcat buffer overflow and reduce raciness in smb21_set_op=
lock_level()
>
>Colin Ian King (1):
>      phy: ti-pipe3: fix missing bit-wise or operator when assigning val
>
>Damien Le Moal (1):
>      dm zoned: Fix zone report handling
>
>Daniel Borkmann (2):
>      bpf: add map_lookup_elem_sys_only for lookups from syscall side
>      bpf, lru: avoid messing with eviction heuristics upon syscall lookup
>
>Daniele Palmas (1):
>      net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions
>
>Dave Hansen (1):
>      x86/mpx, mm/core: Fix recursive munmap() corruption
>
>Dmitry Osipenko (3):
>      clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides div=
ider
>      iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114
>      memory: tegra: Fix integer overflow on tick value calculation
>
>Dmytro Linkin (2):
>      net/mlx5e: Add missing ethtool driver info for representors
>      net/mlx5e: Additional check for flow destination comparison
>
>Edward Cree (1):
>      flow_offload: support CVLAN match
>
>Elazar Leibovich (1):
>      tracing: Fix partial reading of trace event's id file
>
>Eric Dumazet (2):
>      ipv6: prevent possible fib6 leaks
>      net: avoid weird emergency message
>
>Florian Fainelli (2):
>      net: Always descend into dsa/
>      MIPS: perf: Fix build with CONFIG_CPU_BMIPS5000 enabled
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.5
>
>Hans de Goede (1):
>      brcmfmac: Add DMI nvram filename quirk for ACEPC T8 and T11 mini PCs
>
>Helen Koike (2):
>      dm init: fix max devices/targets checks
>      dm ioctl: fix hang in early create error condition
>
>Helge Deller (6):
>      parisc: Export running_on_qemu symbol for modules
>      parisc: Skip registering LED when running in QEMU
>      parisc: Add memory barrier to asm pdc and sync instructions
>      parisc: Allow live-patching of __meminit functions
>      parisc: Use PA_ASM_LEVEL in boot code
>      parisc: Rename LEVEL to PA_ASM_LEVEL to avoid name clash with DRBD c=
ode
>
>Hou Tao (1):
>      brd: re-enable __GFP_HIGHMEM in brd_insert_page()
>
>James Prestwood (1):
>      PCI: Mark Atheros AR9462 to avoid bus reset
>
>Janusz Krzysztofik (1):
>      media: ov6650: Fix sensor possibly not detected on probe
>
>Jason Gunthorpe (1):
>      RDMA/mlx5: Use get_zeroed_page() for clock_info
>
>Jean-Philippe Brucker (1):
>      PCI: Init PCIe feature bits for managed host bridge alloc
>
>Jeff Layton (1):
>      ceph: flush dirty inodes before proceeding with remount
>
>Jianbo Liu (1):
>      net/mlx5e: Fix calling wrong function to get inner vlan key and mask
>
>Jisheng Zhang (1):
>      PCI/AER: Change pci_aer_init() stub to return void
>
>John David Anglin (1):
>      parisc: Add memory clobber to TLB purges
>
>John Garry (1):
>      driver core: Postpone DMA tear-down until after devres release for p=
robe failure
>
>Jonas Karlman (1):
>      clk: rockchip: fix wrong clock definitions for rk3328
>
>Jorge E. Moreira (1):
>      vsock/virtio: Initialize core virtio vsock before registering the dr=
iver
>
>Josh Poimboeuf (1):
>      x86_64: Add gap to int3 to allow for call emulation
>
>Junwei Hu (2):
>      tipc: switch order of device registration to fix a crash
>      tipc: fix modprobe tipc failed after switch order of device registra=
tion
>
>Kazufumi Ikeda (1):
>      PCI: rcar: Add the initialization of PCIe link in resume_noirq()
>
>Kirill Smelkov (1):
>      fuse: Add FOPEN_STREAM to use stream_open()
>
>Leo Yan (1):
>      clk: hi3660: Mark clk_gate_ufs_subsys as critical
>
>Leon Romanovsky (1):
>      RDMA/ipoib: Allow user space differentiate between valid dev_port
>
>Liu Bo (1):
>      fuse: honor RLIMIT_FSIZE in fuse_file_fallocate
>
>Lyude Paul (1):
>      PCI: Reset Lenovo ThinkPad P50 nvgpu at boot if necessary
>
>Martin Wilck (1):
>      dm mpath: always free attached_handler_name in parse_path()
>
>Masami Hiramatsu (1):
>      tracing: probeevent: Fix to make the type of $comm string
>
>Michael Lass (1):
>      dm: make sure to obey max_io_len_target_boundary
>
>Miklos Szeredi (1):
>      fuse: fix writepages on 32bit
>
>Mikulas Patocka (5):
>      udlfb: delete the unused parameter for dlfb_handle_damage
>      udlfb: fix sleeping inside spinlock
>      udlfb: introduce a rendering mutex
>      dm delay: fix a crash when invalid device is specified
>      dm integrity: correctly calculate the size of metadata area
>
>Milan Broz (1):
>      dm crypt: move detailed message into debug level
>
>Ming Lei (1):
>      blk-mq: free hw queue's resource in hctx's release handler
>
>Nathan Chancellor (1):
>      objtool: Allow AR to be overridden with HOSTAR
>
>NeilBrown (2):
>      Revert "MD: fix lock contention for flush bios"
>      md: batch flush requests.
>
>Nigel Croxon (1):
>      md/raid: raid5 preserve the writeback action after the parity check
>
>Nikolai Kostrigin (1):
>      PCI: Mark AMD Stoney Radeon R7 GPU ATS as broken
>
>Nikos Tsironis (1):
>      dm cache metadata: Fix loading discard bitset
>
>Olga Kornievskaia (1):
>      PNFS fallback to MDS if no deviceid found
>
>Owen Chen (1):
>      clk: mediatek: Disable tuner_en before change PLL rate
>
>Pan Bian (1):
>      p54: drop device reference count if fails to enable device
>
>Paul Moore (1):
>      proc: prevent changes to overridden credentials
>
>Peter Zijlstra (2):
>      x86_64: Allow breakpoints to emulate call instructions
>      ftrace/x86_64: Emulate call function while updating in breakpoint ha=
ndler
>
>Phong Tran (1):
>      of: fix clang -Wunsequenced for be32_to_cpu()
>
>Pieter Jansen van Vuuren (1):
>      nfp: flower: add rcu locks when accessing netdev for tunnels
>
>Qu Wenruo (1):
>      btrfs: reloc: Fix NULL pointer dereference due to expanded reloc_roo=
t lifespan
>
>Ronnie Sahlberg (1):
>      cifs: fix credits leak for SMB1 oplock breaks
>
>Sabrina Dubroca (1):
>      rtnetlink: always put IFLA_LINK for links with a link-netnsid
>
>Saeed Mahameed (2):
>      net/mlx5: Imply MLXFW in mlx5_core
>      net/mlx5e: Fix ethtool rxfh commands when CONFIG_MLX5_EN_RXNFC is di=
sabled
>
>Song Liu (1):
>      Revert "Don't jump to compute_result state from check_result state"
>
>Stefan M=E4tje (2):
>      PCI: Factor out pcie_retrain_link() function
>      PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum
>
>Stefano Garzarella (1):
>      vsock/virtio: free packets during the socket release
>
>Steve Longerbeam (4):
>      media: imx: csi: Allow unknown nearest upstream entities
>      media: imx: Clear fwnode link struct for each endpoint iteration
>      media: imx: Rename functions that add IPU-internal subdevs
>      media: imx: Don't register IPU subdevs/links if CSI port missing
>
>Steve Twiss (1):
>      regulator: core: fix error path for regulator_set_voltage_unlocked
>
>Tingwei Zhang (1):
>      stm class: Fix channel free in stm output free path
>
>Vadim Pasternak (2):
>      mlxsw: core: Prevent QSFP module initialization for old hardware
>      mlxsw: core: Prevent reading unsupported slave address from SFP EEPR=
OM
>
>Wei Wang (1):
>      ipv6: fix src addr routing with the exception table
>
>Willem de Bruijn (1):
>      net: test nouarg before dereferencing zerocopy pointers
>
>Yifeng Li (9):
>      fbdev: sm712fb: fix brightness control on reboot, don't set SR30
>      fbdev: sm712fb: fix VRAM detection, don't set SR70/71/74/75
>      fbdev: sm712fb: fix white screen of death on reboot, don't set CR3B-=
CR3F
>      fbdev: sm712fb: fix boot screen glitch when sm712fb replaces VGA
>      fbdev: sm712fb: fix crashes during framebuffer writes by correctly m=
apping VRAM
>      fbdev: sm712fb: fix support for 1024x768-16 mode
>      fbdev: sm712fb: use 1024x768 by default on non-MIPS, fix garbled dis=
play
>      fbdev: sm712fb: fix crashes and garbled display during DPMS modesett=
ing
>      fbdev: sm712fb: fix memory frequency by avoiding a switch/case fallt=
hrough
>
>YueHaibing (1):
>      ppp: deflate: Fix possible crash in deflate_init
>
>Yufen Yu (1):
>      md: add mddev->pers to avoid potential NULL pointer dereference
>
>Yunjian Wang (1):
>      net/mlx4_core: Change the error print to info print
>
>ZhangXiaoxu (1):
>      NFS4: Fix v4.0 client state corruption when mount
>



--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlzqDIAACgkQsjqdtxFL
KRU3sQf/XLH8HAnar6d35iBhSoSeKGR4+QRelJNX2Fi4y7waAXeifjLc7Guabgy7
N65uLmtlqqRMa82Gb7esMK/fswNFQQhpt0B2lrxzmg7jFCJoMRtCdsuYy1wAia+k
VASgZxuKUG87xQB2A5LExjxBXWhqIQqewUvMHQwVJMPkXgeXrFib+1VEc4aqywGJ
cyYBEUNzV2uF0FSx3i6eQ5jZLMT8USIeLZllsFmMY/Q8eZ8VSAiH49CWx6UJzogC
fEskj5UN5ysyz0DJKPIChYckTiWRe7M94QY8FVjLUXxWFmOkoGTUxquSWVr4kkLf
yVi58t7qDJk6r6fa++zi8wlUxr9Yhg==
=/uDV
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
