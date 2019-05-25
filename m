Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B5A2A59D
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 19:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfEYRAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 13:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbfEYRAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 May 2019 13:00:43 -0400
Received: from localhost (unknown [62.129.28.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5390C20879;
        Sat, 25 May 2019 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558803641;
        bh=WyQUvrTSOsXvi0X0CipJRGRqzb4YeLzKsAvVPhZ+Tg0=;
        h=Date:From:To:Cc:Subject:From;
        b=huUPGFp0RZU5Qv9uiG93NgqMh0ooAX6bGwXyqp7gxxcLt7X11o7K7TPwiHlyWVWgL
         MH5DNnpsU68+EqBpexPlzfH7kSRZfYuwD3g9480IwgTYdS3BZivyOC+CckDFUFLMpg
         MV0TgRxxwvKlDi442t1JvZODW8+du8qd3gNWmd3U=
Date:   Sat, 25 May 2019 19:00:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.46
Message-ID: <20190525170039.GA7476@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.46 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/filesystems/porting                       |    5=20
 Makefile                                                |    2=20
 arch/mips/kernel/perf_event_mipsxx.c                    |   21 -
 arch/parisc/boot/compressed/head.S                      |    6=20
 arch/parisc/include/asm/assembly.h                      |    6=20
 arch/parisc/kernel/head.S                               |    4=20
 arch/parisc/kernel/process.c                            |    1=20
 arch/parisc/kernel/syscall.S                            |    2=20
 arch/x86/entry/entry_64.S                               |   18 +
 arch/x86/events/intel/core.c                            |   10=20
 arch/x86/include/asm/text-patching.h                    |   28 +
 arch/x86/kernel/ftrace.c                                |   32 +-
 arch/x86/kvm/hyperv.c                                   |   11=20
 arch/x86/lib/Makefile                                   |   12=20
 drivers/base/dd.c                                       |    5=20
 drivers/block/brd.c                                     |    7=20
 drivers/clk/hisilicon/clk-hi3660.c                      |    6=20
 drivers/clk/mediatek/clk-pll.c                          |   48 ++-
 drivers/clk/rockchip/clk-rk3328.c                       |   18 -
 drivers/clk/sunxi-ng/ccu_nkmp.c                         |   18 -
 drivers/clk/tegra/clk-pll.c                             |    4=20
 drivers/hwtracing/intel_th/msu.c                        |   35 ++
 drivers/hwtracing/stm/core.c                            |    9=20
 drivers/iommu/tegra-smmu.c                              |   25 +
 drivers/md/dm-cache-metadata.c                          |    9=20
 drivers/md/dm-delay.c                                   |    3=20
 drivers/md/dm-integrity.c                               |    4=20
 drivers/md/dm-mpath.c                                   |    2=20
 drivers/md/dm-zoned-metadata.c                          |    5=20
 drivers/md/md.c                                         |  182 ++++-------
 drivers/md/md.h                                         |   25 -
 drivers/md/raid5.c                                      |   29 +
 drivers/media/i2c/ov6650.c                              |    2=20
 drivers/memory/tegra/mc.c                               |    2=20
 drivers/net/Makefile                                    |    2=20
 drivers/net/ethernet/mellanox/mlx4/mcg.c                |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig         |    1=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c    |   18 +
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c |   17 -
 drivers/net/ieee802154/mcr20a.c                         |    6=20
 drivers/net/ppp/ppp_deflate.c                           |   20 -
 drivers/net/usb/qmi_wwan.c                              |   12=20
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c           |   28 +
 drivers/net/wireless/intersil/p54/p54pci.c              |    3=20
 drivers/parisc/led.c                                    |    3=20
 drivers/pci/controller/pcie-rcar.c                      |   21 +
 drivers/pci/pci.c                                       |   19 +
 drivers/pci/pci.h                                       |    2=20
 drivers/pci/pcie/aspm.c                                 |   49 ++-
 drivers/pci/probe.c                                     |   23 -
 drivers/pci/quirks.c                                    |   19 +
 drivers/phy/ti/phy-ti-pipe3.c                           |    2=20
 drivers/power/supply/cpcap-battery.c                    |    3=20
 drivers/power/supply/power_supply_sysfs.c               |    6=20
 drivers/staging/media/imx/imx-media-csi.c               |   18 -
 drivers/staging/media/imx/imx-media-of.c                |   15=20
 drivers/video/fbdev/efifb.c                             |    8=20
 drivers/video/fbdev/sm712.h                             |   12=20
 drivers/video/fbdev/sm712fb.c                           |  243 +++++++++++=
+----
 drivers/video/fbdev/udlfb.c                             |  114 +++++--
 fs/ceph/super.c                                         |    7=20
 fs/cifs/smb2ops.c                                       |   14=20
 fs/dcache.c                                             |   24 -
 fs/fuse/file.c                                          |   13=20
 fs/nfs/filelayout/filelayout.c                          |    2=20
 fs/nfs/nfs4state.c                                      |    4=20
 fs/nsfs.c                                               |    3=20
 fs/overlayfs/copy_up.c                                  |    6=20
 fs/overlayfs/file.c                                     |    5=20
 fs/overlayfs/overlayfs.h                                |    2=20
 fs/proc/base.c                                          |    5=20
 fs/ufs/util.h                                           |    2=20
 include/linux/bpf.h                                     |    3=20
 include/linux/dcache.h                                  |    2=20
 include/linux/of.h                                      |    4=20
 include/linux/pci.h                                     |    2=20
 include/linux/skbuff.h                                  |    9=20
 include/net/ip6_fib.h                                   |    3=20
 include/net/xfrm.h                                      |   20 +
 include/uapi/linux/fuse.h                               |    2=20
 include/video/udlfb.h                                   |    7=20
 kernel/bpf/hashtab.c                                    |   23 +
 kernel/bpf/inode.c                                      |    2=20
 kernel/bpf/syscall.c                                    |    5=20
 kernel/sched/cpufreq_schedutil.c                        |    1=20
 kernel/trace/trace_events.c                             |    3=20
 lib/Makefile                                            |   11=20
 net/core/dev.c                                          |    2=20
 net/core/rtnetlink.c                                    |   16 -
 net/ipv4/esp4.c                                         |   20 -
 net/ipv4/ip_vti.c                                       |    5=20
 net/ipv4/xfrm4_policy.c                                 |   24 -
 net/ipv6/ip6_fib.c                                      |   12=20
 net/ipv6/route.c                                        |   58 ++-
 net/ipv6/xfrm6_tunnel.c                                 |    6=20
 net/key/af_key.c                                        |    4=20
 net/mac80211/iface.c                                    |    3=20
 net/tipc/core.c                                         |   14=20
 net/vmw_vsock/virtio_transport.c                        |   13=20
 net/vmw_vsock/virtio_transport_common.c                 |    7=20
 net/xfrm/xfrm_interface.c                               |   17 -
 net/xfrm/xfrm_policy.c                                  |    2=20
 net/xfrm/xfrm_state.c                                   |    2=20
 net/xfrm/xfrm_user.c                                    |   16 -
 security/apparmor/apparmorfs.c                          |   13=20
 security/inode.c                                        |   13=20
 tools/objtool/Makefile                                  |    3=20
 tools/perf/bench/numa.c                                 |    4=20
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c     |   31 +-
 tools/testing/selftests/bpf/test_verifier.c             |    9=20
 virt/kvm/arm/arm.c                                      |   11=20
 111 files changed, 1215 insertions(+), 536 deletions(-)

Adrian Hunter (3):
      perf intel-pt: Fix instructions sampling rate
      perf intel-pt: Fix improved sample timestamp
      perf intel-pt: Fix sample timestamp wrt non-taken branches

Al Viro (4):
      dcache: sort the freeing-without-RCU-delay mess for good.
      securityfs: fix use-after-free on symlink traversal
      apparmorfs: fix use-after-free on symlink traversal
      ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour

Alexander Shishkin (2):
      stm class: Fix channel bitmap on 32-bit systems
      intel_th: msu: Fix single mode with IOMMU

Amir Goldstein (1):
      ovl: fix missing upper fs freeze protection on copy up for ioctl

Andrew Jones (1):
      KVM: arm/arm64: Ensure vcpu target is unset on reset failure

Andrey Smirnov (1):
      power: supply: sysfs: prevent endless uevent loop with CONFIG_POWER_S=
UPPLY_DEBUG

Ard Biesheuvel (1):
      fbdev/efifb: Ignore framebuffer memmap entries that lack any memory t=
ypes

Arnaldo Carvalho de Melo (1):
      perf bench numa: Add define for RUSAGE_THREAD if not present

Bhagavathi Perumal S (1):
      mac80211: Fix kernel panic due to use of txq after free

Bj=F8rn Mork (1):
      qmi_wwan: new Wistron, ZTE and D-Link devices

Chenbo Feng (1):
      bpf: relax inode permission check for retrieving bpf program

Christoph Probst (1):
      cifs: fix strcat buffer overflow and reduce raciness in smb21_set_opl=
ock_level()

Colin Ian King (1):
      phy: ti-pipe3: fix missing bit-wise or operator when assigning val

Cong Wang (1):
      xfrm: clean up xfrm protocol checks

Damien Le Moal (1):
      dm zoned: Fix zone report handling

Daniel Borkmann (2):
      bpf: add map_lookup_elem_sys_only for lookups from syscall side
      bpf, lru: avoid messing with eviction heuristics upon syscall lookup

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions

Dmitry Osipenko (3):
      clk: tegra: Fix PLLM programming on Tegra124+ when PMC overrides divi=
der
      iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114
      memory: tegra: Fix integer overflow on tick value calculation

Elazar Leibovich (1):
      tracing: Fix partial reading of trace event's id file

Eric Dumazet (2):
      ipv6: prevent possible fib6 leaks
      net: avoid weird emergency message

Florian Fainelli (2):
      net: Always descend into dsa/
      MIPS: perf: Fix build with CONFIG_CPU_BMIPS5000 enabled

Gary Hook (1):
      x86/mm/mem_encrypt: Disable all instrumentation for early SME setup

Greg Kroah-Hartman (2):
      Revert "selftests/bpf: skip verifier tests for unsupported program ty=
pes"
      Linux 4.19.46

Helge Deller (4):
      parisc: Export running_on_qemu symbol for modules
      parisc: Skip registering LED when running in QEMU
      parisc: Use PA_ASM_LEVEL in boot code
      parisc: Rename LEVEL to PA_ASM_LEVEL to avoid name clash with DRBD co=
de

Hou Tao (1):
      brd: re-enable __GFP_HIGHMEM in brd_insert_page()

James Prestwood (1):
      PCI: Mark Atheros AR9462 to avoid bus reset

Janusz Krzysztofik (1):
      media: ov6650: Fix sensor possibly not detected on probe

Jean-Philippe Brucker (1):
      PCI: Init PCIe feature bits for managed host bridge alloc

Jeff Layton (1):
      ceph: flush dirty inodes before proceeding with remount

Jeremy Sowden (1):
      vti4: ipip tunnel deregistration fixes.

Jernej Skrabec (1):
      clk: sunxi-ng: nkmp: Avoid GENMASK(-1, 0)

Jiri Olsa (1):
      perf/x86/intel: Fix race in intel_pmu_disable_event()

Jisheng Zhang (1):
      PCI/AER: Change pci_aer_init() stub to return void

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

Kangjie Lu (1):
      net: ieee802154: fix missing checks for regmap_update_bits

Kazufumi Ikeda (1):
      PCI: rcar: Add the initialization of PCIe link in resume_noirq()

Kirill Smelkov (1):
      fuse: Add FOPEN_STREAM to use stream_open()

Leo Yan (1):
      clk: hi3660: Mark clk_gate_ufs_subsys as critical

Liu Bo (1):
      fuse: honor RLIMIT_FSIZE in fuse_file_fallocate

Logan Gunthorpe (1):
      PCI: Fix issue with "pci=3Ddisable_acs_redir" parameter being ignored

Luca Coelho (1):
      iwlwifi: mvm: check for length correctness in iwl_mvm_create_skb()

Martin Wilck (1):
      dm mpath: always free attached_handler_name in parse_path()

Martin Willi (1):
      xfrm: Honor original L3 slave device in xfrmi policy lookup

Miklos Szeredi (1):
      fuse: fix writepages on 32bit

Mikulas Patocka (5):
      udlfb: delete the unused parameter for dlfb_handle_damage
      udlfb: fix sleeping inside spinlock
      udlfb: introduce a rendering mutex
      dm delay: fix a crash when invalid device is specified
      dm integrity: correctly calculate the size of metadata area

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

Peter Zijlstra (3):
      x86_64: Allow breakpoints to emulate call instructions
      ftrace/x86_64: Emulate call function while updating in breakpoint han=
dler
      bpf: Fix preempt_enable_no_resched() abuse

Phong Tran (1):
      of: fix clang -Wunsequenced for be32_to_cpu()

Pieter Jansen van Vuuren (1):
      nfp: flower: add rcu locks when accessing netdev for tunnels

Sabrina Dubroca (2):
      rtnetlink: always put IFLA_LINK for links with a link-netnsid
      esp4: add length check for UDP encapsulation

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

Steffen Klassert (1):
      xfrm4: Fix uninitialized memory read in _decode_session4

Steve Longerbeam (2):
      media: imx: csi: Allow unknown nearest upstream entities
      media: imx: Clear fwnode link struct for each endpoint iteration

Su Yanjun (1):
      xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module

Tingwei Zhang (1):
      stm class: Fix channel free in stm output free path

Tobin C. Harding (1):
      sched/cpufreq: Fix kobject memleak

Tony Lindgren (1):
      power: supply: cpcap-battery: Fix division by zero

Vitaly Kuznetsov (1):
      x86: kvm: hyper-v: deal with buggy TLB flush requests from WS2012

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

YueHaibing (2):
      ppp: deflate: Fix possible crash in deflate_init
      xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink

Yufen Yu (1):
      md: add mddev->pers to avoid potential NULL pointer dereference

Yunjian Wang (1):
      net/mlx4_core: Change the error print to info print

ZhangXiaoxu (1):
      NFS4: Fix v4.0 client state corruption when mount


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzpdLcACgkQONu9yGCS
aT5QGw/8C4t8XnoLQ65Kvb1xWdW16jgmrOi0cpm4C2WlMI5gpsWd1jDbK7xH9qs2
z5uOfSN1+A+a7JKFFPcSdWPdU9eutAoLcJ6YGUd/7wTKN+QfBV4G0kw2uJMm3Poy
gmGHMWtwEA0+IRpmxy0zv5NmsR/4CPdwtMMoqrhGi8A/JG7W0W7nqnAE99Woh42Q
CgXI2r+DtY9NE7shRXbCmoVoRMekZW9jz230fEffwRNVR5PAYKu+RBAxGlAVKpbX
oYqHSsETsdI9NvOJOEwU98oY4luUWByGHyNq0Q3qW7Jqb7svFDGi4Icmu25NC6VY
qO7tMWMcDkkrTWlbDtuaZjnIR/ujbJkevWn+SGmd55vLpEYmukOO7367aDGSHill
J4FLRRu5p+6uKZu/c+WYtWQy2fhG4ztYODRVwhK3hunHWXPbt13ar4HSiyobnNG3
K1I0KJsT8Awvacz09EBtvJrTgHAF0U7x0ACOf14FxSI606cyVss9JSj+T72HUyDj
FpvgrunGFvKhARbvh9WERc6n7gsKaFCPp7HtUYKH2qMwGBfsNR1YoWrgkBYjV32l
0nygg/IWBjJaLwzlg+UL+5Ga78QAJIOPftgp90/WmNTtPL1jDFZKDkS2ruUCQWj4
95K8ojEImae3QNJJUixB8JxD8GaW1jBS2Z4JBtoZCTRyDv7GcZo=
=wfO1
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
