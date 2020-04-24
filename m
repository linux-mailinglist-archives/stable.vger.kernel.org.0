Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FB11B706F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgDXJP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDXJP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 05:15:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 020D820724;
        Fri, 24 Apr 2020 09:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587719727;
        bh=gQNFLcV+pcs7VKm0ktvoQFJMUm7dLUKyQmOdYZ7x3mA=;
        h=Date:From:To:Cc:Subject:From;
        b=UNxOa2na+wHEiz5s7RUXCOwM03vx0fvfD8/fEW1JM5DCzwV0+AhkTunzH7XZFCpTP
         Uv5vrNwxjBfggzIJHtC1ViARvvtQi1xYJSCRLs2ErQ9Ke3w3ZxAMyi+L5bEDCfchqP
         zw7q4FnuWJfRzPtGxEa28Fq7sNtVBLYyx0WPuxfw=
Date:   Fri, 24 Apr 2020 11:15:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.35
Message-ID: <20200424091525.GA359915@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.35 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                |    2=20
 Documentation/devicetree/bindings/pci/nvidia,tegra194-pcie.txt |    2=20
 Makefile                                                       |    2=20
 arch/arm/boot/dts/imx6qdl.dtsi                                 |    5=20
 arch/arm/boot/dts/imx6qp.dtsi                                  |    1=20
 arch/arm/boot/dts/rk3188-bqedison2qc.dts                       |   29 +-
 arch/arm/boot/dts/sun8i-a83t.dtsi                              |    2=20
 arch/arm/boot/dts/sun8i-r40.dtsi                               |    2=20
 arch/arm/boot/dts/sun8i-v3s.dtsi                               |    2=20
 arch/arm/boot/dts/sunxi-h3-h5.dtsi                             |    2=20
 arch/arm/net/bpf_jit_32.c                                      |   52 +++-
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi                  |    2=20
 arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts     |    1=20
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                       |  111 ++++=
+++++-
 arch/csky/abiv1/inc/abi/entry.h                                |    5=20
 arch/csky/abiv2/fpu.c                                          |    5=20
 arch/csky/abiv2/inc/abi/entry.h                                |    7=20
 arch/csky/abiv2/inc/abi/fpu.h                                  |    3=20
 arch/csky/include/asm/processor.h                              |    1=20
 arch/csky/kernel/head.S                                        |    5=20
 arch/csky/kernel/setup.c                                       |   63 +----
 arch/csky/kernel/smp.c                                         |    6=20
 arch/csky/kernel/traps.c                                       |   11=20
 arch/csky/mm/fault.c                                           |    7=20
 arch/powerpc/kernel/prom_init.c                                |    3=20
 arch/powerpc/kvm/book3s_hv.c                                   |    1=20
 arch/powerpc/platforms/maple/setup.c                           |   34 +--
 arch/s390/kernel/perf_cpum_sf.c                                |    1=20
 arch/s390/kernel/processor.c                                   |    5=20
 arch/s390/mm/gmap.c                                            |    1=20
 arch/um/drivers/ubd_kern.c                                     |    4=20
 arch/um/os-Linux/file.c                                        |    1=20
 arch/x86/hyperv/hv_init.c                                      |    6=20
 arch/x86/kernel/acpi/cstate.c                                  |    3=20
 arch/x86/kernel/cpu/mshyperv.c                                 |   10=20
 block/bfq-cgroup.c                                             |   73 ++++=
--
 block/bfq-iosched.c                                            |    2=20
 block/bfq-iosched.h                                            |    1=20
 drivers/acpi/acpica/acnamesp.h                                 |    2=20
 drivers/acpi/acpica/dbinput.c                                  |   16 -
 drivers/acpi/acpica/dswexec.c                                  |   33 ++
 drivers/acpi/acpica/dswload.c                                  |    2=20
 drivers/acpi/acpica/dswload2.c                                 |   35 +++
 drivers/acpi/acpica/nsnames.c                                  |    6=20
 drivers/acpi/acpica/utdelete.c                                 |    9=20
 drivers/acpi/processor_throttling.c                            |    7=20
 drivers/block/rbd.c                                            |   25 +-
 drivers/clk/at91/clk-usb.c                                     |    3=20
 drivers/clk/clk.c                                              |   48 ++--
 drivers/clk/tegra/clk-tegra-pmc.c                              |   12 -
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                        |    4=20
 drivers/gpu/drm/nouveau/nouveau_drm.c                          |   63 +++++
 drivers/gpu/drm/nouveau/nouveau_drv.h                          |    2=20
 drivers/gpu/drm/nouveau/nouveau_svm.c                          |    6=20
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c                 |   26 ++
 drivers/gpu/drm/ttm/ttm_bo.c                                   |    4=20
 drivers/gpu/drm/vc4/vc4_hdmi.c                                 |   20 +
 drivers/hv/channel_mgmt.c                                      |    3=20
 drivers/hv/vmbus_drv.c                                         |   62 +++--
 drivers/iio/light/si1133.c                                     |   37 ++-
 drivers/iommu/amd_iommu_types.h                                |    2=20
 drivers/iommu/intel-iommu.c                                    |    3=20
 drivers/iommu/intel-svm.c                                      |    9=20
 drivers/iommu/virtio-iommu.c                                   |   16 -
 drivers/irqchip/irq-mbigen.c                                   |    8=20
 drivers/leds/led-class.c                                       |    2=20
 drivers/mtd/devices/phram.c                                    |   15 -
 drivers/mtd/lpddr/lpddr_cmds.c                                 |    1=20
 drivers/mtd/nand/raw/nand_base.c                               |    2=20
 drivers/mtd/nand/spi/core.c                                    |    1=20
 drivers/net/dsa/bcm_sf2_cfp.c                                  |    9=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c           |    4=20
 drivers/nvdimm/bus.c                                           |    6=20
 drivers/of/overlay.c                                           |    2=20
 drivers/of/unittest.c                                          |   16 +
 drivers/phy/socionext/phy-uniphier-usb3ss.c                    |    4=20
 drivers/power/supply/axp288_fuel_gauge.c                       |    4=20
 drivers/power/supply/bq27xxx_battery.c                         |    5=20
 drivers/rtc/rtc-88pm860x.c                                     |   14 -
 drivers/scsi/sg.c                                              |    4=20
 drivers/soc/imx/gpc.c                                          |   24 +-
 drivers/tty/ehv_bytechan.c                                     |   21 +
 drivers/video/fbdev/core/fbmem.c                               |   38 +--
 drivers/watchdog/sp805_wdt.c                                   |    4=20
 fs/afs/dir.c                                                   |  108 ++++=
++---
 fs/afs/dir_silly.c                                             |   22 +
 fs/afs/fsclient.c                                              |   27 +-
 fs/afs/yfsclient.c                                             |   20 -
 fs/block_dev.c                                                 |    4=20
 fs/btrfs/block-group.c                                         |    2=20
 fs/buffer.c                                                    |   11=20
 fs/cifs/transport.c                                            |   28 +-
 fs/ext2/xattr.c                                                |    8=20
 fs/ext4/inode.c                                                |    2=20
 fs/ext4/super.c                                                |    5=20
 fs/f2fs/checkpoint.c                                           |   24 +-
 fs/f2fs/f2fs.h                                                 |    3=20
 fs/f2fs/gc.c                                                   |    6=20
 fs/f2fs/node.c                                                 |    7=20
 fs/f2fs/super.c                                                |   14 -
 fs/nfs/callback_proc.c                                         |    2=20
 fs/nfs/direct.c                                                |    2=20
 fs/nfs/inode.c                                                 |   10=20
 fs/nfs/nfs4file.c                                              |    3=20
 fs/nfs/pagelist.c                                              |   17 -
 include/acpi/processor.h                                       |    8=20
 include/asm-generic/mshyperv.h                                 |    2=20
 include/keys/big_key-type.h                                    |    2=20
 include/keys/user-type.h                                       |    3=20
 include/linux/buffer_head.h                                    |    8=20
 include/linux/compiler.h                                       |    2=20
 include/linux/f2fs_fs.h                                        |    1=20
 include/linux/hugetlb.h                                        |   19 -
 include/linux/key-type.h                                       |    2=20
 include/linux/percpu_counter.h                                 |    4=20
 include/linux/swapops.h                                        |    3=20
 kernel/bpf/verifier.c                                          |   45 +++-
 kernel/dma/coherent.c                                          |   13 -
 kernel/dma/debug.c                                             |    9=20
 kernel/locking/locktorture.c                                   |    8=20
 lib/Kconfig.debug                                              |    2=20
 net/dns_resolver/dns_key.c                                     |    2=20
 net/netfilter/nf_tables_api.c                                  |    4=20
 net/rxrpc/key.c                                                |   27 --
 net/sunrpc/auth_gss/auth_gss.c                                 |   80 ++++=
+--
 net/xdp/xdp_umem.c                                             |    5=20
 net/xdp/xsk.c                                                  |    5=20
 security/keys/big_key.c                                        |   11=20
 security/keys/encrypted-keys/encrypted.c                       |    7=20
 security/keys/keyctl.c                                         |   73 ++++=
+-
 security/keys/keyring.c                                        |    6=20
 security/keys/request_key_auth.c                               |    7=20
 security/keys/trusted.c                                        |   14 -
 security/keys/user_defined.c                                   |    5=20
 sound/pci/hda/hda_intel.c                                      |   23 --
 tools/objtool/check.c                                          |    5=20
 tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c      |    5=20
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c   |   26 ++
 tools/testing/selftests/bpf/verifier/bpf_get_stack.c           |    8=20
 139 files changed, 1262 insertions(+), 619 deletions(-)

Adrian Huang (1):
      iommu/amd: Fix the configuration of GCR3 table root pointer

Alan Maguire (1):
      um: falloc.h needs to be directly included for older libc

Alexander Gordeev (1):
      s390/cpuinfo: fix wrong output when CPU0 is offline

Alexandre Belloni (1):
      rtc: 88pm860x: fix possible race condition

Alexey Kardashevskiy (1):
      powerpc/prom_init: Pass the "os-term" message to hypervisor

Aya Levin (1):
      net/mlx5e: Enforce setting of a single FEC mode

Ben Skeggs (1):
      drm/nouveau/gr/gp107,gp108: implement workaround for HW hanging durin=
g init

Bob Moore (1):
      ACPICA: Fixes for acpiExec namespace init file

Chao Yu (3):
      f2fs: fix to show norecovery mount option
      f2fs: fix NULL pointer dereference in f2fs_write_begin()
      f2fs: fix to wait all node page writeback

Christophe Kerello (1):
      mtd: rawnand: free the nand_device object

Christophe Leroy (1):
      mm/hugetlb: fix build failure with HUGETLB_PAGE but not HUGEBTLBFS

Chuck Lever (1):
      sunrpc: Fix gss_unwrap_resp_integ() again

Claudiu Beznea (1):
      clk: at91: usb: continue if clk_hw_round_rate() return zero

Dan Carpenter (3):
      libnvdimm: Out of bounds read in __nd_ioctl()
      fbdev: potential information leak in do_fb_ioctl()
      mtd: lpddr: Fix a double free in probe()

Daniel Borkmann (2):
      bpf: fix buggy r0 retval refinement for tracing helpers
      bpf, test_verifier: switch bpf_get_stack's 0 s> r8 test

David Hildenbrand (1):
      KVM: s390: vsie: Fix possible race when shadowing region 3 tables

David Howells (5):
      afs: Fix missing XDR advance in xdr_decode_{AFS,YFS}FSFetchStatus()
      afs: Fix decoding of inline abort codes from version 1 status records
      afs: Fix rename operation status delivery
      afs: Fix afs_d_validate() to set the right directory version
      afs: Fix race between post-modification dir edit and readdir/d_revali=
date

Dmitry Osipenko (1):
      power: supply: bq27xxx_battery: Silence deferred-probe error

Domenico Andreoli (1):
      hibernate: Allow uswsusp to write to swap

Eric Sandeen (1):
      ext4: do not commit super on read-only bdev

Florian Fainelli (1):
      net: dsa: bcm_sf2: Fix overflow checks

Frank Rowand (4):
      of: unittest: kmemleak on changeset destroy
      of: unittest: kmemleak in of_unittest_platform_populate()
      of: unittest: kmemleak in of_unittest_overlay_high_level()
      of: overlay: kmemleak in dup_and_fixup_symbol_prop()

Frieder Schrempf (1):
      mtd: spinand: Explicitly use MTD_OPS_RAW to write the bad block marke=
r to OOB

Gabriel Krisman Bertazi (1):
      um: ubd: Prevent buffer overrun on command completion

Greg Kroah-Hartman (1):
      Linux 5.4.35

Grygorii Strashko (1):
      dma-debug: fix displaying of dma allocation type

Guo Ren (3):
      csky: Fixup cpu speculative execution to IO area
      csky: Fixup get wrong psr value from phyical reg
      csky: Fixup init_fpu compile warning with __init

Ilya Dryomov (2):
      rbd: avoid a deadlock on header_rwsem when flushing notifies
      rbd: call rbd_dev_unprobe() after unwatching and flushing notifies

Jack Zhang (1):
      drm/amdkfd: kfree the wrong pointer

Jacob Pan (2):
      iommu/vt-d: Fix mm reference leak
      iommu/vt-d: Fix page request descriptor size

Jan Kara (1):
      ext2: fix debug reference to ext2_xattr_cache

Jean-Philippe Brucker (1):
      iommu/virtio: Fix freeing of incomplete domains

Jeffery Miller (1):
      power: supply: axp288_fuel_gauge: Broaden vendor check for Intel Comp=
ute Sticks.

Jernej Skrabec (2):
      arm64: dts: allwinner: a64: Fix display clock register range
      ARM: dts: sunxi: Fix DE2 clocks register range

Johan Jonker (2):
      ARM: dts: rockchip: fix vqmmc-supply property name for rk3188-bqediso=
n2qc
      ARM: dts: rockchip: fix lvds-encoder ports subnode for rk3188-bqediso=
n2qc

John Fastabend (2):
      bpf: Test_verifier, bpf_get_stack return value add <0
      bpf: Test_progs, add test to catch retval refine error handling

Jon Hunter (1):
      arm64: tegra: Fix Tegra194 PCIe compatible string

Jonathan Neusch=E4fer (1):
      docs: Fix path to MTD command line partition parser

Josh Poimboeuf (1):
      objtool: Fix switch table detection in .text.unlikely

Karol Herbst (1):
      drm/nouveau: workaround runpm fail by disabling PCI power management =
on certain intel bridges

Kevin Grandemange (1):
      dma-coherent: fix integer overflow in the reserved-memory dma allocat=
ion

Kunihiko Hayashi (1):
      phy: uniphier-usb3ss: Add Pro5 support

Li Bin (1):
      scsi: sg: add sg_remove_request in sg_common_write

Li RongQing (1):
      xsk: Fix out of boundary write in __xsk_rcv_memcpy

Long Li (1):
      cifs: Allocate encryption header through kmalloc

Lucas Stach (1):
      soc: imx: gpc: fix power up sequencing

Luke Nelson (2):
      arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0
      arm, bpf: Fix offset overflow for BPF_MEM BPF_DW

Madhuparna Bhowmik (1):
      btrfs: add RCU locks around block group initialization

Magnus Karlsson (1):
      xsk: Add missing check on user supplied headroom size

Martin Fuzzey (1):
      ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on L=
AN.

Maxime Roussin-B=E9langer (1):
      iio: si1133: read 24-bit signed integer for measurement

Michael Roth (1):
      KVM: PPC: Book3S HV: Fix H_CEDE return code for nested guests

Michael Walle (1):
      watchdog: sp805: fix restart handler

Misono Tomohiro (1):
      NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Murphy Zhou (1):
      NFSv4.2: error out when relink swapfile

Nathan Chancellor (2):
      powerpc/maple: Fix declaration made after definition
      fbmem: Adjust indentation in fb_prepare_logo and fb_blank

Nicolas Saenz Julienne (1):
      drm/vc4: Fix HDMI mode validation

Olga Kornievskaia (1):
      SUNRPC: fix krb5p mount to provide large enough buffer in rq_rcvsize

Pablo Neira Ayuso (1):
      netfilter: nf_tables: report EOPNOTSUPP on unsupported flags/object t=
ype

Paolo Valente (3):
      block, bfq: turn put_queue into release_process_ref in __bfq_bic_chan=
ge_cgroup
      block, bfq: make reparent_leaf_entity actually work only on leaf enti=
ties
      block, bfq: invoke flush_idle_tree after reparent_active_queues in pd=
_offline

Paul E. McKenney (1):
      locktorture: Print ratio of acquisitions, not failures

Qian Cai (3):
      percpu_counter: fix a data race at vm_committed_as
      x86: ACPI: fix CPU hotplug deadlock
      iommu/vt-d: Silence RCU-list debugging warning in dmar_find_atsr()

Ralph Campbell (2):
      drm/nouveau/svm: check for SVM initialized before migrating
      drm/nouveau/svm: fix vma range check for migration

Randy Dunlap (1):
      ext2: fix empty body warnings when -Wextra is used

Ricardo Ribalda Delgado (1):
      leds: core: Fix warning message when init_data

Roman Gushchin (1):
      ext4: use non-movable memory for superblock readahead

Russell King (1):
      arm64: dts: clearfog-gt-8k: set gigabit PHY reset deassert delay

Sahitya Tummala (3):
      f2fs: fix the panic in do_checkpoint()
      f2fs: Fix mount failure due to SPO after a successful online resize FS
      f2fs: Add a new CP flag to help fsck fix resize SPO issues

Slava Bacherikov (1):
      kbuild, btf: Fix dependencies for DEBUG_INFO_BTF

Sowjanya Komatineni (1):
      clk: tegra: Fix Tegra PMC clock out parents

Stephen Boyd (1):
      clk: Don't cache errors from clk_ops::get_phase()

Stephen Rothwell (1):
      tty: evh_bytechan: Fix out of bounds accesses

Steven Price (1):
      include/linux/swapops.h: correct guards for non_swap_entry()

Takashi Iwai (2):
      ALSA: hda: Honor PM disablement in PM freeze and thaw_noirq ops
      ALSA: hda: Don't release card at firmware loading error

Thomas Richter (1):
      s390/cpum_sf: Fix wrong page count in error message

Tianyu Lan (6):
      x86/Hyper-V: Unload vmbus channel in hv panic callback
      x86/Hyper-V: Trigger crash enlightenment only once during system cras=
h.
      x86/Hyper-V: Report crash register data or kmsg before running crash =
kernel
      x86/Hyper-V: Report crash register data when sysctl_record_panic_msg =
is not set
      x86/Hyper-V: Report crash data in die() when panic_on_oops is set
      x86/Hyper-V: Free hv_panic_page when fail to register kmsg dump

Trond Myklebust (3):
      NFS: alloc_nfs_open_context() must use the file cred when available
      NFSv4/pnfs: Return valid stateids in nfs_layout_find_inode_by_stateid=
()
      NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

Vegard Nossum (1):
      compiler.h: fix error in BUILD_BUG_ON() reporting

Vidya Sagar (1):
      arm64: tegra: Add PCIe endpoint controllers nodes for Tegra194

Waiman Long (1):
      KEYS: Don't write out to userspace while holding key semaphore

Wen Yang (1):
      mtd: phram: fix a double free issue in error path

Zenghui Yu (1):
      irqchip/mbigen: Free msi_desc on device teardown

xinhui pan (1):
      drm/ttm: flush the fence on the bo after we individualize the reserva=
tion object


--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6iri0ACgkQONu9yGCS
aT6u1g//eUbrq7qIDlzzZtHRuy827f6r4MRF239qVm1eSNeNn7YX/txSXEWHGG06
4PbhfKZ2Zjx9RYszZWtfIWKYPK68vIqgjKqIprxbtxty8/0xjCwmz10hYM6PR7b6
HXAUKeX7t1DtLSEuArHqVgcKvSylzci4Kjyr86A3Nh2ZpOx/Q+Gx+LPkZu4vp8nN
pp/hxwWzFQ0m3OxJc4Ztvt+u8kYdEIZg7206J6nA5LjxadrgADhTxZ7eAb+zTSNg
mQwBoP7+uCjVX/CtG/cXvWIzEaec/kL/75U/DY3swmQc9akq0NST+oiZhSoKeS+Z
GrBIuNhF/foT+yQz+Va3Af8ghPea5DwilZjACxygyiS5z1tlmJ76B9T2+z8ctuLw
nyS6S0I4wAC32LLlu/4r8yiKR4DHBEoRcHKYhhtGt9IfA43GUoZs3bFFo0DkTXp4
ltZfqO1KdInZ+7mjC/p+kz6BlgNA04InkZa34KeRg+XVKCTWy0lzPIaYYfe3cEub
02s2q3aI9aPiYSlZsF9P/7vnPaQ68jiNrZWKs0EHR9qjYpCNUwQS2lVOF+dd33Nm
zgiELSCvr5GXCPme8ljDuIVBvBuwp0jXBu35YdUKCfIB94BpuBcXPRykMLjrvLaU
qKmDZteEdzBYaZ568//K/Bg1XLsFmkJMF9h3wJazEfdujI2K/E0=
=hD3T
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
