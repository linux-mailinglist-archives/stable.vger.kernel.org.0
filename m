Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C351B7078
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgDXJPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgDXJPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 05:15:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E8720724;
        Fri, 24 Apr 2020 09:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587719750;
        bh=Os7Ur8cfAP5hU7DSZuFmSY6LWpq2lwVmQhz5vHDKFGE=;
        h=Date:From:To:Cc:Subject:From;
        b=sd8AOL0Vum1+JEu5pXJITx+0JH7YBFppmGhCKwecuD9Pv1cpUP3OJjkj0+UAge9Vs
         +L066XyUvtzUYoYORbiDkqwtcyrthc926DxS8hHZk9Inw6svLlWrqsrlWU047ZBZ2s
         0RZsQoyuPoz0EHiuaaYmZ4M/UDEbcGFm6fA6mZlI=
Date:   Fri, 24 Apr 2020 11:15:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.6.7
Message-ID: <20200424091547.GA360024@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.6.7 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                |    2=20
 Documentation/devicetree/bindings/pci/nvidia,tegra194-pcie.txt |    2=20
 Documentation/devicetree/bindings/thermal/qcom-tsens.yaml      |    9=20
 Makefile                                                       |    2=20
 arch/arm/boot/dts/imx6qdl.dtsi                                 |    5=20
 arch/arm/boot/dts/imx6qp.dtsi                                  |    1=20
 arch/arm/boot/dts/rk3188-bqedison2qc.dts                       |   29 -
 arch/arm/boot/dts/sun8i-a83t.dtsi                              |    2=20
 arch/arm/boot/dts/sun8i-r40.dtsi                               |    2=20
 arch/arm/boot/dts/sun8i-v3s.dtsi                               |    2=20
 arch/arm/boot/dts/sunxi-h3-h5.dtsi                             |    2=20
 arch/arm/net/bpf_jit_32.c                                      |   52 +--
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi                  |    2=20
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi       |    6=20
 arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts     |    1=20
 arch/arm64/boot/dts/marvell/armada-ap807-quad.dtsi             |    8=20
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                       |  111 ++++=
++
 arch/csky/abiv1/inc/abi/entry.h                                |    5=20
 arch/csky/abiv2/fpu.c                                          |    5=20
 arch/csky/abiv2/inc/abi/entry.h                                |    7=20
 arch/csky/abiv2/inc/abi/fpu.h                                  |    3=20
 arch/csky/include/asm/processor.h                              |    1=20
 arch/csky/kernel/head.S                                        |    5=20
 arch/csky/kernel/setup.c                                       |   63 ---
 arch/csky/kernel/smp.c                                         |    6=20
 arch/csky/kernel/traps.c                                       |   11=20
 arch/csky/mm/fault.c                                           |    7=20
 arch/mips/boot/dts/ingenic/ci20.dts                            |    5=20
 arch/powerpc/kernel/prom_init.c                                |    3=20
 arch/powerpc/kvm/book3s_hv.c                                   |    1=20
 arch/powerpc/platforms/maple/setup.c                           |   34 -
 arch/s390/crypto/aes_s390.c                                    |    3=20
 arch/s390/kernel/perf_cpum_sf.c                                |    4=20
 arch/s390/kernel/processor.c                                   |    5=20
 arch/s390/mm/gmap.c                                            |    1=20
 arch/um/drivers/ubd_kern.c                                     |    4=20
 arch/um/os-Linux/file.c                                        |    1=20
 arch/x86/hyperv/hv_init.c                                      |    6=20
 arch/x86/kernel/acpi/cstate.c                                  |    3=20
 arch/x86/kernel/cpu/mshyperv.c                                 |   10=20
 arch/x86/xen/xen-head.S                                        |    8=20
 block/bfq-cgroup.c                                             |   73 ++--
 block/bfq-iosched.c                                            |    2=20
 block/bfq-iosched.h                                            |    1=20
 drivers/acpi/acpica/acnamesp.h                                 |    2=20
 drivers/acpi/acpica/dbinput.c                                  |   16=20
 drivers/acpi/acpica/dswexec.c                                  |   33 +
 drivers/acpi/acpica/dswload.c                                  |    2=20
 drivers/acpi/acpica/dswload2.c                                 |   35 ++
 drivers/acpi/acpica/nsnames.c                                  |    6=20
 drivers/acpi/acpica/utdelete.c                                 |    9=20
 drivers/acpi/device_pm.c                                       |    2=20
 drivers/acpi/dptf/dptf_power.c                                 |    2=20
 drivers/acpi/dptf/int340x_thermal.c                            |    8=20
 drivers/acpi/processor_throttling.c                            |    7=20
 drivers/block/rbd.c                                            |   27 +
 drivers/clk/at91/clk-usb.c                                     |    3=20
 drivers/clk/clk.c                                              |   48 +-
 drivers/clk/imx/clk-pll14xx.c                                  |    2=20
 drivers/clk/tegra/clk-tegra-pmc.c                              |   12=20
 drivers/crypto/qce/dma.c                                       |   11=20
 drivers/crypto/qce/dma.h                                       |    2=20
 drivers/crypto/qce/skcipher.c                                  |    5=20
 drivers/dma/idxd/device.c                                      |    4=20
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                        |    4=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c         |    8=20
 drivers/gpu/drm/nouveau/nouveau_drm.c                          |   63 +++
 drivers/gpu/drm/nouveau/nouveau_drv.h                          |    2=20
 drivers/gpu/drm/nouveau/nouveau_svm.c                          |    6=20
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c                 |   26 +
 drivers/gpu/drm/ttm/ttm_bo.c                                   |    4=20
 drivers/gpu/drm/vc4/vc4_hdmi.c                                 |   20 -
 drivers/hv/channel_mgmt.c                                      |    3=20
 drivers/hv/vmbus_drv.c                                         |   62 ++-
 drivers/iio/common/st_sensors/st_sensors_core.c                |    4=20
 drivers/iio/light/si1133.c                                     |   37 +-
 drivers/iommu/Kconfig                                          |    1=20
 drivers/iommu/amd_iommu_types.h                                |    2=20
 drivers/iommu/intel-iommu.c                                    |    3=20
 drivers/iommu/intel-svm.c                                      |    9=20
 drivers/iommu/virtio-iommu.c                                   |   16=20
 drivers/irqchip/irq-mbigen.c                                   |    8=20
 drivers/leds/led-class.c                                       |    2=20
 drivers/memory/tegra/tegra124-emc.c                            |    5=20
 drivers/memory/tegra/tegra20-emc.c                             |    5=20
 drivers/memory/tegra/tegra30-emc.c                             |    5=20
 drivers/mfd/cros_ec_dev.c                                      |    2=20
 drivers/mtd/devices/phram.c                                    |   15=20
 drivers/mtd/lpddr/lpddr_cmds.c                                 |    1=20
 drivers/mtd/nand/raw/nand_base.c                               |    2=20
 drivers/mtd/nand/spi/core.c                                    |    1=20
 drivers/net/dsa/bcm_sf2_cfp.c                                  |    9=20
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c           |    4=20
 drivers/net/macsec.c                                           |    3=20
 drivers/nvdimm/bus.c                                           |    6=20
 drivers/of/overlay.c                                           |    2=20
 drivers/of/unittest.c                                          |   16=20
 drivers/phy/socionext/phy-uniphier-usb3ss.c                    |    4=20
 drivers/platform/chrome/cros_ec.c                              |   30 +
 drivers/platform/x86/intel-hid.c                               |    2=20
 drivers/power/supply/axp288_fuel_gauge.c                       |    4=20
 drivers/power/supply/bq27xxx_battery.c                         |    5=20
 drivers/rtc/rtc-88pm860x.c                                     |   14=20
 drivers/scsi/sg.c                                              |    4=20
 drivers/soc/imx/gpc.c                                          |   24 -
 drivers/thermal/Kconfig                                        |    1=20
 drivers/thermal/cpufreq_cooling.c                              |    6=20
 drivers/thermal/qcom/tsens-common.c                            |    6=20
 drivers/tty/ehv_bytechan.c                                     |   21 +
 drivers/video/fbdev/core/fbmem.c                               |   38 +-
 drivers/virtio/virtio_balloon.c                                |  107 ++--=
--
 drivers/watchdog/sp805_wdt.c                                   |    4=20
 fs/afs/dir.c                                                   |  108 +++-=
--
 fs/afs/dir_silly.c                                             |   22 -
 fs/afs/fsclient.c                                              |   27 -
 fs/afs/yfsclient.c                                             |   20 -
 fs/block_dev.c                                                 |    4=20
 fs/btrfs/block-group.c                                         |    2=20
 fs/buffer.c                                                    |   11=20
 fs/ceph/file.c                                                 |  173 ++++=
+-----
 fs/cifs/smb2misc.c                                             |   14=20
 fs/cifs/transport.c                                            |   28 -
 fs/ext2/xattr.c                                                |    8=20
 fs/ext4/inode.c                                                |    2=20
 fs/ext4/super.c                                                |    5=20
 fs/f2fs/checkpoint.c                                           |   24 -
 fs/f2fs/compress.c                                             |   63 ++-
 fs/f2fs/data.c                                                 |   35 +-
 fs/f2fs/f2fs.h                                                 |  102 ++---
 fs/f2fs/file.c                                                 |   13=20
 fs/f2fs/gc.c                                                   |   27 +
 fs/f2fs/inode.c                                                |    2=20
 fs/f2fs/node.c                                                 |    7=20
 fs/f2fs/super.c                                                |   14=20
 fs/gfs2/log.c                                                  |   17=20
 fs/nfs/callback_proc.c                                         |    2=20
 fs/nfs/direct.c                                                |    2=20
 fs/nfs/inode.c                                                 |   10=20
 fs/nfs/nfs4file.c                                              |    3=20
 fs/nfs/nfsroot.c                                               |    2=20
 fs/nfs/pagelist.c                                              |   17=20
 fs/xfs/libxfs/xfs_alloc.c                                      |    2=20
 fs/xfs/xfs_attr_inactive.c                                     |    2=20
 fs/xfs/xfs_dir2_readdir.c                                      |   12=20
 fs/xfs/xfs_log.c                                               |   13=20
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
 include/linux/platform_data/cros_ec_proto.h                    |    4=20
 include/linux/swapops.h                                        |    3=20
 include/trace/bpf_probe.h                                      |   18 -
 kernel/bpf/syscall.c                                           |   16=20
 kernel/bpf/verifier.c                                          |   45 +-
 kernel/dma/coherent.c                                          |   13=20
 kernel/dma/debug.c                                             |    9=20
 kernel/locking/locktorture.c                                   |    8=20
 lib/Kconfig.debug                                              |    2=20
 net/dns_resolver/dns_key.c                                     |    2=20
 net/netfilter/nf_tables_api.c                                  |    4=20
 net/netfilter/nft_set_rbtree.c                                 |   23 -
 net/rxrpc/key.c                                                |   27 -
 net/sunrpc/auth_gss/auth_gss.c                                 |   80 +++-
 net/xdp/xdp_umem.c                                             |    5=20
 net/xdp/xsk.c                                                  |    5=20
 security/keys/big_key.c                                        |   11=20
 security/keys/encrypted-keys/encrypted.c                       |    7=20
 security/keys/keyctl.c                                         |   73 +++-
 security/keys/keyring.c                                        |    6=20
 security/keys/request_key_auth.c                               |    7=20
 security/keys/trusted-keys/trusted_tpm1.c                      |   14=20
 security/keys/user_defined.c                                   |    5=20
 sound/pci/hda/hda_intel.c                                      |   23 -
 tools/lib/bpf/netlink.c                                        |    2=20
 tools/objtool/check.c                                          |    5=20
 tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c      |    5=20
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp_err.c   |   26 +
 tools/testing/selftests/bpf/verifier/bpf_get_stack.c           |    8=20
 184 files changed, 1754 insertions(+), 923 deletions(-)

Adrian Huang (1):
      iommu/amd: Fix the configuration of GCR3 table root pointer

Alan Maguire (1):
      um: falloc.h needs to be directly included for older libc

Alex Smith (1):
      MIPS: DTS: CI20: add DT node for IR sensor

Alexander Gordeev (1):
      s390/cpuinfo: fix wrong output when CPU0 is offline

Alexandre Belloni (1):
      rtc: 88pm860x: fix possible race condition

Alexey Kardashevskiy (1):
      powerpc/prom_init: Pass the "os-term" message to hypervisor

Amit Kucheria (2):
      arm64: dts: marvell: Fix cpu compatible for AP807-quad
      drivers: thermal: tsens: Release device in success path

Andrey Ignatov (1):
      libbpf: Fix bpf_get_link_xdp_id flags handling

Andrii Nakryiko (2):
      bpf: Prevent re-mmap()'ing BPF map as writable for initially r/o mapp=
ing
      bpf: Reliably preserve btf_trace_xxx types

Anson Huang (1):
      clk: imx: pll14xx: Add new frequency entries for pll1443x table

Aurelien Aptel (1):
      cifs: ignore cached share root handle closing errors

Aya Levin (1):
      net/mlx5e: Enforce setting of a single FEC mode

Ben Skeggs (1):
      drm/nouveau/gr/gp107,gp108: implement workaround for HW hanging durin=
g init

Bhawanpreet Lakha (1):
      drm/amd/display: Don't try hdcp1.4 when content_type is set to type1

Bob Moore (1):
      ACPICA: Fixes for acpiExec namespace init file

Bob Peterson (1):
      gfs2: clear ail1 list when gfs2 withdraws

Brian Foster (1):
      xfs: fix iclog release error check race with shutdown

Chao Yu (11):
      f2fs: fix to avoid potential deadlock
      f2fs: fix to avoid use-after-free in f2fs_write_multi_pages()
      f2fs: fix to show norecovery mount option
      f2fs: fix to update f2fs_super_block fields under sb_lock
      f2fs: compress: fix to call missing destroy_compress_ctx()
      f2fs: fix potential .flags overflow on 32bit architecture
      f2fs: fix NULL pointer dereference in f2fs_verity_work()
      f2fs: fix NULL pointer dereference in f2fs_write_begin()
      f2fs: fix potential deadlock on compressed quota file
      f2fs: fix to account compressed blocks in f2fs_compressed_blocks()
      f2fs: fix to wait all node page writeback

Christophe Kerello (1):
      mtd: rawnand: free the nand_device object

Christophe Leroy (1):
      mm/hugetlb: fix build failure with HUGETLB_PAGE but not HUGEBTLBFS

Chuck Lever (1):
      sunrpc: Fix gss_unwrap_resp_integ() again

Claudiu Beznea (1):
      clk: at91: usb: continue if clk_hw_round_rate() return zero

Colin Ian King (1):
      iio: st_sensors: handle memory allocation failure to fix null pointer=
 dereference

Dan Carpenter (3):
      libnvdimm: Out of bounds read in __nd_ioctl()
      fbdev: potential information leak in do_fb_ioctl()
      mtd: lpddr: Fix a double free in probe()

Daniel Borkmann (2):
      bpf: fix buggy r0 retval refinement for tracing helpers
      bpf, test_verifier: switch bpf_get_stack's 0 s> r8 test

Darrick J. Wong (2):
      xfs: fix use-after-free when aborting corrupt attr inactivation
      xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock

Dave Jiang (1):
      dmaengine: idxd: reflect shadow copy of traffic class programming

David Hildenbrand (2):
      KVM: s390: vsie: Fix possible race when shadowing region 3 tables
      virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLA=
TE_ON_OOM

David Howells (5):
      afs: Fix missing XDR advance in xdr_decode_{AFS,YFS}FSFetchStatus()
      afs: Fix decoding of inline abort codes from version 1 status records
      afs: Fix rename operation status delivery
      afs: Fix afs_d_validate() to set the right directory version
      afs: Fix race between post-modification dir edit and readdir/d_revali=
date

Davide Caratti (1):
      macsec: fix NULL dereference in macsec_upd_offload()

Dmitry Osipenko (4):
      memory: tegra: Correct debugfs clk rate-range on Tegra20
      memory: tegra: Correct debugfs clk rate-range on Tegra30
      memory: tegra: Correct debugfs clk rate-range on Tegra124
      power: supply: bq27xxx_battery: Silence deferred-probe error

Domenico Andreoli (1):
      hibernate: Allow uswsusp to write to swap

Eneas U de Queiroz (1):
      crypto: qce - use cryptlen when adding extra sgl

Eric Biggers (1):
      f2fs: fix leaking uninitialized memory in compressed clusters

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

Gayatri Kammela (2):
      platform/x86: intel-hid: fix: Update Tiger Lake ACPI device ID
      ACPI: Update Tiger Lake ACPI device IDs

Greg Kroah-Hartman (1):
      Linux 5.6.7

Grygorii Strashko (1):
      dma-debug: fix displaying of dma allocation type

Guo Ren (3):
      csky: Fixup cpu speculative execution to IO area
      csky: Fixup get wrong psr value from phyical reg
      csky: Fixup init_fpu compile warning with __init

Ilya Dryomov (3):
      rbd: avoid a deadlock on header_rwsem when flushing notifies
      rbd: call rbd_dev_unprobe() after unwatching and flushing notifies
      rbd: don't test rbd_dev->opts in rbd_dev_image_release()

Jack Zhang (1):
      drm/amdkfd: kfree the wrong pointer

Jacob Pan (3):
      iommu/vt-d: Add build dependency on IOASID
      iommu/vt-d: Fix mm reference leak
      iommu/vt-d: Fix page request descriptor size

Jaegeuk Kim (2):
      f2fs: fix wrong check on F2FS_IOC_FSSETXATTR
      f2fs: skip GC when section is full

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

Juergen Gross (1):
      x86/xen: fix booting 32-bit pv guest

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

Liwei Song (1):
      nfsroot: set tcp as the default transport protocol

Long Li (1):
      cifs: Allocate encryption header through kmalloc

Lucas Stach (1):
      soc: imx: gpc: fix power up sequencing

Luis Henriques (1):
      ceph: re-org copy_file_range and fix some error paths

Luke Nelson (2):
      arm, bpf: Fix offset overflow for BPF_MEM BPF_DW
      arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0

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

Miroslav Benes (1):
      x86/xen: Make the boot CPU idle task reliable

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

Prashant Malani (1):
      mfd: cros_ec: Check DT node for usbpd-notify add

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

Rob Herring (1):
      dt-bindings: thermal: tsens: Fix nvmem-cell-names schema

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

Stefano Brivio (1):
      netfilter: nft_set_rbtree: Drop spurious condition for overlap detect=
ion on insertion

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
      x86/Hyper-V: Free hv_panic_page when fail to register kmsg dump
      x86/Hyper-V: Trigger crash enlightenment only once during system cras=
h.
      x86/Hyper-V: Report crash register data or kmsg before running crash =
kernel
      x86/Hyper-V: Report crash register data when sysctl_record_panic_msg =
is not set
      x86/Hyper-V: Report crash data in die() when panic_on_oops is set

Tomasz Maciej Nowak (1):
      arm64: dts: marvell: espressobin: add ethernet alias

Tommi Rantala (1):
      xfs: fix regression in "cleanup xfs_dir2_block_getdents"

Torsten Duwe (1):
      s390/crypto: explicitly memzero stack key material in aes_s390.c

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

Willy Wolff (1):
      thermal/drivers/cpufreq_cooling: Fix return of cpufreq_set_cur_state

Yicheng Li (1):
      platform/chrome: cros_ec: Query EC protocol version if EC transitions=
 between RO/RW

Yuantian Tang (1):
      thermal: qoriq: Fix a compiling issue

Zenghui Yu (1):
      irqchip/mbigen: Free msi_desc on device teardown

xinhui pan (1):
      drm/ttm: flush the fence on the bo after we individualize the reserva=
tion object


--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6irkMACgkQONu9yGCS
aT4heRAApgMsVwgnvROsoAwEDz59Hz87YjGiB6KAviFsCt4LnnIJe0DoM6G9cmGG
Qy6OpCXsyu4IproXFzwhjutImnPtMVyIVYB3ZC7KS7t2SXY5mVqXhkNagB0ze/7e
weS56pdhw5FmREROKnxcCiZqymb3HhJ/kGfjhaWUnFFVAW1Q4fuEdBWZ7KirFV1H
9D+VoLdtkYJI+jUiF0rsvWswoh+uZSBEH6lV24KcgGagu54tFmtLc8RCYky+INsO
LF+4fvzsTvvh1HCYDWDa2TCtSS6Sng3nzMXXyicPwBVt2hYjcuQK3QSvIh/GlkBW
Fv4g9qGRTBDsK3yXpVMha6rdsru1qhrpL7AuQYmto2o+ijSV4zMd3eNHR3YcuJ8u
Jii8r49wl4m0krIUhDubG2QD1s0m2C4cbPLhFbY584rG1VN5ua633Ms3K/KWh/w9
SIOrAbxKtxyheBPz2JxQzaQE1+hAM/w3aAj2MC63Ms0AXAz7Wr+5DE7GUYLdjURq
RXDRQMbYcOXZtGCBzGB3b+0JMD6Xa6NknF+diknP+T0c15YQLzArgF3KF8N/Yx+u
c+hF2aL7H0txIWeT6O9lBresBXhCmmyUsRsd2rvH4TZNay9NgxhdNFqYzsVc3T+M
3iM5eRkScVkvk1Is2ktowX+QyQhVa/s4LuMjZPjN7RqO7rcJWMw=
=lIrm
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
