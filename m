Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1142064638
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 14:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbfGJMde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 08:33:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52454 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbfGJMdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 08:33:31 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hlBmp-0002UN-93; Wed, 10 Jul 2019 13:33:27 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hlBmp-0002JF-1H; Wed, 10 Jul 2019 13:33:27 +0100
Message-ID: <fa23bc9ae987b43592ed5320ecbf2066b029570f.camel@decadent.org.uk>
Subject: Linux 3.16.70
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Date:   Wed, 10 Jul 2019 13:33:26 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-VOH9hFEr9JV7UJXRSCBE"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-VOH9hFEr9JV7UJXRSCBE
Content-Type: multipart/mixed; boundary="=-3m69Fjx7Me5M+9wRXjoi"


--=-3m69Fjx7Me5M+9wRXjoi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.70 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.gi=
t

The diff from 3.16.69 is attached to this message.

Ben.

------------

 Makefile                                           |   2 +-
 arch/arm/mach-imx/clk-imx6q.c                      |   1 +
 arch/arm/mach-imx/clk-imx6sx.c                     |   1 +
 arch/arm/mach-imx/clk-vf610.c                      |   1 +
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c            |   8 +-
 arch/arm64/crypto/aes-ce-ccm-core.S                |   5 +-
 arch/m68k/Makefile                                 |   5 +-
 arch/powerpc/kernel/entry_32.S                     |   9 +
 arch/powerpc/kernel/irq.c                          |   5 -
 arch/powerpc/mm/slice.c                            |  10 +-
 arch/powerpc/platforms/83xx/suspend-asm.S          |  34 +-
 arch/powerpc/platforms/embedded6xx/wii.c           |   4 +
 arch/powerpc/platforms/powernv/opal-msglog.c       |   2 +-
 arch/x86/kvm/x86.h                                 |   7 +-
 crypto/ahash.c                                     |  42 ++-
 crypto/pcbc.c                                      |  14 +-
 crypto/shash.c                                     |  18 +-
 crypto/testmgr.c                                   |  14 +-
 crypto/tgr192.c                                    |   6 +-
 drivers/char/applicom.c                            |  35 +-
 drivers/char/hpet.c                                |   2 +-
 drivers/char/tpm/tpm_eventlog.c                    |  10 +-
 drivers/char/tpm/tpm_i2c_atmel.c                   |   9 +-
 drivers/clk/clk-highbank.c                         |   1 +
 drivers/clk/mvebu/armada-370.c                     |   4 +-
 drivers/clk/mvebu/armada-xp.c                      |   4 +-
 drivers/clk/mvebu/dove.c                           |   4 +-
 drivers/clk/mvebu/kirkwood.c                       |   5 +-
 drivers/clk/samsung/clk-exynos4.c                  |   1 +
 drivers/clk/socfpga/clk-pll.c                      |   1 +
 drivers/clocksource/exynos_mct.c                   |  14 +-
 drivers/cpufreq/pxa2xx-cpufreq.c                   |   4 +-
 drivers/firmware/iscsi_ibft.c                      |   1 +
 drivers/gpu/drm/drm_context.c                      |  15 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   2 +-
 drivers/irqchip/irq-brcmstb-l2.c                   |  10 +-
 drivers/leds/leds-lp55xx-common.c                  |   4 +-
 drivers/md/bcache/extents.c                        |  13 +-
 drivers/md/bcache/writeback.h                      |   3 +
 drivers/md/raid10.c                                |   3 +-
 drivers/md/raid5.c                                 |   2 +
 drivers/media/i2c/ov7670.c                         |  16 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  21 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  14 +-
 drivers/media/usb/uvc/uvc_video.c                  |   8 +
 drivers/mmc/host/omap.c                            |   2 +-
 drivers/mtd/devices/docg3.c                        |  18 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   8 +
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   6 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   6 +-
 drivers/net/ppp/pptp.c                             |   1 +
 drivers/net/vxlan.c                                |  10 +
 drivers/net/wireless/libertas_tf/if_usb.c          |   2 -
 drivers/net/wireless/mwifiex/ie.c                  |  30 +-
 drivers/net/wireless/mwifiex/scan.c                |  19 ++
 drivers/parport/parport_pc.c                       |   2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |   6 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               |   2 +-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |   3 +-
 drivers/regulator/wm831x-dcdc.c                    |   4 +-
 drivers/rtc/rtc-88pm80x.c                          |  21 +-
 drivers/rtc/rtc-88pm860x.c                         |  21 +-
 drivers/rtc/rtc-ds1672.c                           |   3 +-
 drivers/rtc/rtc-pm8xxx.c                           |   6 +-
 drivers/s390/kvm/virtio_ccw.c                      |   4 +-
 drivers/scsi/virtio_scsi.c                         |   2 -
 drivers/staging/android/ashmem.c                   |  42 ++-
 drivers/staging/android/binder.c                   |  28 +-
 drivers/staging/iio/addac/adt7316.c                |  55 ++--
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/tty/ipwireless/hardware.c                  |   2 +
 drivers/tty/serial/8250/8250_pci.c                 | 141 +++++++-
 drivers/tty/serial/of_serial.c                     |   4 +
 drivers/usb/class/cdc-wdm.c                        |   2 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   6 +
 drivers/xen/cpu_hotplug.c                          |   2 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
 fs/9p/v9fs_vfs.h                                   |  23 +-
 fs/9p/vfs_file.c                                   |   6 +-
 fs/9p/vfs_inode.c                                  |  23 +-
 fs/9p/vfs_inode_dotl.c                             |  27 +-
 fs/9p/vfs_super.c                                  |   4 +-
 fs/btrfs/extent_io.c                               |   4 +-
 fs/btrfs/scrub.c                                   |   2 +-
 fs/cifs/file.c                                     |  12 +-
 fs/cifs/smb2misc.c                                 |  17 +-
 fs/cifs/smb2ops.c                                  |  13 +-
 fs/ext2/super.c                                    |  39 ++-
 fs/ext4/ext4.h                                     |   3 +
 fs/ext4/ioctl.c                                    |  84 +++--
 fs/ext4/resize.c                                   |   3 +-
 fs/fuse/file.c                                     |   4 +-
 fs/jbd2/transaction.c                              |  17 +-
 fs/nfs/nfs4proc.c                                  |  15 +-
 fs/nfs/super.c                                     |   2 +-
 fs/nfsd/nfs3proc.c                                 |  16 +-
 fs/nfsd/nfs3xdr.c                                  |   1 +
 fs/open.c                                          |  18 +
 fs/pipe.c                                          |  14 +
 fs/read_write.c                                    |   5 +-
 fs/splice.c                                        |   4 +
 include/linux/fs.h                                 |   4 +
 include/linux/pipe_fs_i.h                          |   1 +
 include/linux/swap.h                               |   1 +
 include/net/gro_cells.h                            |  12 +-
 include/net/net_namespace.h                        |   2 +
 include/net/netns/hash.h                           |  17 +-
 include/uapi/linux/fuse.h                          |   2 +
 kernel/rcu/tree.c                                  |  20 +-
 kernel/sysctl.c                                    |  11 +-
 lib/devres.c                                       |   4 +-
 lib/div64.c                                        |   4 +-
 mm/swapfile.c                                      |  83 ++---
 mm/vmalloc.c                                       |   2 +-
 net/core/net-sysfs.c                               |   3 +
 net/core/net_namespace.c                           |   1 +
 net/hsr/hsr_device.c                               |  14 +-
 net/ipv4/route.c                                   |   4 +
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/ip6mr.c                                   |   8 +-
 net/l2tp/l2tp_ip6.c                                |   4 +-
 scripts/coccinelle/api/stream_open.cocci           | 363 +++++++++++++++++=
++++
 security/selinux/avc.c                             |  44 ++-
 security/selinux/hooks.c                           |   6 +-
 security/selinux/include/avc.h                     |  10 +-
 sound/firewire/bebob/bebob.c                       |  14 +-
 sound/soc/fsl/fsl_esai.c                           |   7 +-
 sound/soc/fsl/fsl_ssi.c                            |   5 +-
 sound/soc/fsl/imx-sgtl5000.c                       |   3 +-
 tools/lib/traceevent/event-parse.c                 |   2 +-
 tools/perf/util/header.c                           |   2 +-
 135 files changed, 1417 insertions(+), 458 deletions(-)

Aaro Koskinen (1):
      mmc: omap: fix the maximum timeout setting

Aditya Pakki (1):
      md: Fix failed allocation of md_register_thread

Alistair Strachan (1):
      media: uvcvideo: Fix 'type' check leading to overflow

Aneesh Kumar K.V (1):
      powerpc/mm/hash: Handle mmap_min_addr correctly in get_unmapped_area =
topdown search

Ard Biesheuvel (1):
      crypto: arm64/aes-ccm - fix logical bug in AAD MAC handling

Arnd Bergmann (1):
      cpufreq: pxa2xx: remove incorrect __init annotation

Axel Lin (1):
      regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA

Bart Van Assche (1):
      scsi: target/iscsi: Avoid iscsit_release_commands_from_conn() deadloc=
k

Ben Hutchings (2):
      binder: Replace "%p" with "%pK" for stable
      Linux 3.16.70

Buland Singh (1):
      hpet: Fix missing '=3D' character in the __setup() code of hpet_mmap_=
enable

Christophe Leroy (4):
      powerpc/irq: drop arch_early_irq_init()
      powerpc/83xx: Also save/restore SPRG4-7 during suspend
      powerpc/wii: properly disable use of BATs when requested.
      powerpc/32: Clear on-stack exception marker upon exception return

Colin Ian King (4):
      rtc: ds1672: fix unintended sign extension
      rtc: 88pm860x: fix unintended sign extension
      rtc: 88pm80x: fix unintended sign extension
      rtc: pm8xxx: fix unintended sign extension

Dan Carpenter (1):
      xen, cpu_hotplug: Prevent an out of bounds access

Dan Robertson (1):
      btrfs: init csum_list before possible free

Daniel Axtens (1):
      bcache: never writeback a discard operation

Daniel Jordan (1):
      mm, swap: bounds check swap_info array accesses to avoid NULL derefs

Doug Berger (1):
      irqchip/brcmstb-l2: Use _irqsave locking variants in non-interrupt co=
de

Eric Biggers (5):
      crypto: pcbc - remove bogus memcpy()s with src =3D=3D dest
      crypto: hash - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
      crypto: tgr192 - fix unaligned memory access
      crypto: testmgr - skip crc32c context test for ahash algorithms
      crypto: ahash - fix another early termination in hash walk

Eric Dumazet (6):
      net/hsr: fix possible crash in add_timer()
      vxlan: test dev->flags & IFF_UP before calling gro_cells_receive()
      gro_cells: make sure device is up in gro_cells_receive()
      l2tp: fix infoleak in l2tp_ip6_recvmsg()
      tcp: refine memory limit test in tcp_fragment()
      netns: provide pure entropy for net_hash_mix()

Eric W. Biederman (1):
      fs/nfs: Fix nfs_parse_devname to not modify it's argument

Felipe Franciosi (1):
      scsi: virtio_scsi: don't send sc payload with tmfs

Filipe Manana (1):
      Btrfs: fix corruption reading shared and compressed extents after hol=
e punching

Finn Thain (1):
      m68k: Add -ffreestanding to CFLAGS

Gal Pressman (2):
      IB/usnic: Fix out of bounds index check in query pkey
      RDMA/ocrdma: Fix out of bounds index check in query pkey

Geert Uytterhoeven (3):
      pinctrl: sh-pfc: r8a7778: Fix HSPI pin numbers and names
      pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
      pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups

Gustavo A. R. Silva (4):
      ARM: s3c24xx: Fix boolean expressions in osiris_dvs_notify
      applicom: Fix potential Spectre v1 vulnerabilities
      iscsi_ibft: Fix missing break in switch statement
      drm/radeon/evergreen_cs: fix missing break in switch statement

Halil Pasic (1):
      s390/virtio: handle find on invalid queue gracefully

Hou Tao (1):
      9p: use inode->i_lock to protect i_size_write() under 32-bit

Hugh Dickins (1):
      mm: fix potential data race in SyS_swapon

Ido Schimmel (1):
      ip6mr: Do not call __IP6_INC_STATS() from preemptible context

Ivan Mironov (1):
      USB: serial: cp210x: add ID for Ingenico 3070

Jack Morgenstein (2):
      net/mlx4_core: Fix locking in SRIOV mode when switching between event=
s and polling
      net/mlx4_core: Fix qp mtt size calculation

Jacopo Mondi (1):
      media: v4l2: i2c: ov7670: Fix PLL bypass register values

Jan Kara (2):
      ext2: Fix underflow in ext2_max_size()
      ext4: fix crash during online resizing

Jann Horn (1):
      splice: don't merge into linked buffers

Jarkko Sakkinen (1):
      tpm/tpm_i2c_atmel: Return -E2BIG when the transfer is incomplete

Jay Dolan (2):
      serial: 8250_pci: Fix number of ports for ACCES serial cards
      serial: 8250_pci: Have ACCES cards that use the four port Pericom PI7=
C9X7954 chip use the pci_pericom_setup()

Jeremy Fertic (7):
      staging: iio: adt7316: fix register and bit definitions
      staging: iio: adt7316: invert the logic of the check for an ldac pin
      staging: iio: adt7316: allow adt751x to use internal vref for all dac=
s
      staging: iio: adt7316: fix dac_bits assignment
      staging: iio: adt7316: fix handling of dac high resolution option
      staging: iio: adt7316: fix the dac read calculation
      staging: iio: adt7316: fix the dac write calculation

Jia Zhang (1):
      tpm: Fix off-by-one when reading binary_bios_measurements

Jiri Olsa (1):
      perf header: Fix wrong node write in NUMA_TOPOLOGY feature

Jordan Niethe (1):
      powerpc/powernv: Make opal log only readable by root

Kangjie Lu (1):
      net: sh_eth: fix a missing check of of_get_phy_mode

Kirill Smelkov (2):
      fs: stream_open - opener for stream-like files so that read and write=
 can run simultaneously without deadlock
      fuse: Add FOPEN_STREAM to use stream_open()

Lubomir Rintel (2):
      libertas_tf: don't set URB_ZERO_PACKET on IN USB transfer
      serial: 8250_of: assume reg-shift of 2 for mrvl,mmp-uart

Mans Rullgard (1):
      USB: serial: ftdi_sio: add ID for Hjelmslund Electronics USB485

Marek Szyprowski (1):
      clocksource/drivers/exynos_mct: Fix error path in timer resources ini=
tialization

Michal Kazior (1):
      leds: lp55xx: fix null deref on firmware load failure

NeilBrown (2):
      security/selinux: pass 'flags' arg to avc_audit() and avc_has_perm_fl=
ags()
      nfsd: fix memory corruption caused by readdir

Pavel Shilovsky (2):
      CIFS: Do not reset lease state to NONE on lease break
      CIFS: Fix read after write for files with read caching

Pawe? Chmiel (2):
      media: s5p-jpeg: Check for fmt_ver_flag when doing fmt enumeration
      media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTAR=
T_INTERVAL

QiaoChong (1):
      parport_pc: fix find_superio io compare code, should use equal test.

Richard Weinberger (2):
      mtd: docg3: Don't leak docg3->bbt in error path
      mtd: docg3: Fix kasprintf() usage

Roman Penyaev (1):
      mm/vmalloc: fix size check for remap_vmalloc_range_partial()

S.j. Wang (1):
      ASoC: fsl_esai: fix register setting issue in RIGHT_J mode

Sakari Ailus (1):
      media: uvcvideo: Avoid NULL pointer dereference at the end of streami=
ng

Sean Christopherson (1):
      KVM: x86/mmu: Do not cache MMIO accesses while memslots are in flux

Sergei Shtylyov (1):
      devres: always use dev_name() in devm_ioremap_resource()

Stanislaw Gruszka (1):
      lib/div64.c: off by one in shift

Stefan Agner (1):
      ASoC: imx-sgtl5000: put of nodes if finding codec fails

Stephen Smalley (1):
      selinux: avoid silent denials in permissive mode under RCU walk

Takashi Iwai (4):
      ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()
      mwifiex: Fix possible buffer overflows at parsing bss descriptor
      mwifiex: Abort at too short BSS descriptor element
      mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()

Takashi Sakamoto (1):
      ALSA: bebob: use more identical mod_alias for Saffire Pro 10 I/O agai=
nst Liquid Saffire 56

Tang Junhui (1):
      bcache: treat stale && dirty keys as bad keys

Tetsuo Handa (1):
      staging: android: ashmem: Avoid range_alloc() allocation with ashmem_=
mutex held.

Tony Jones (1):
      tools lib traceevent: Fix buffer overflow in arg_eval

Trond Myklebust (1):
      NFSv4.1: Reinitialise sequence results before retransmitting a reques=
t

Xiao Ni (1):
      It's wrong to add len to sector_nr in raid10 reshape twice

Xin Long (2):
      route: set the deleted fnhe fnhe_daddr to 0 in ip_del_fnhe to fix a r=
ace
      pptp: dst_release sk_dst_cache in pptp_sock_destruct

Yangtao Li (10):
      clk: highbank: fix refcount leak in hb_clk_init()
      clk: socfpga: fix refcount leak
      clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()
      clk: imx6q: fix refcount leak in imx6q_clocks_init()
      clk: imx6sx: fix refcount leak in imx6sx_clocks_init()
      clk: vf610: fix refcount leak in vf610_clocks_init()
      clk: armada-370: fix refcount leak in a370_clk_init()
      clk: kirkwood: fix refcount leak in kirkwood_clk_init()
      clk: armada-xp: fix refcount leak in axp_clk_init()
      clk: dove: fix refcount leak in dove_clk_init()

YueHaibing (5):
      drm: Fix error handling in drm_legacy_addctx
      mtd: docg3: Fix passing zero to 'PTR_ERR' warning in doc_probe_device
      tty: ipwireless: Fix potential NULL pointer dereference
      cdc-wdm: pass return value of recover_from_urb_loss
      net-sysfs: Fix mem leak in netdev_register_kobject

Zev Weiss (1):
      kernel/sysctl.c: add missing range check in do_proc_dointvec_minmax_c=
onv

Zhang, Jun (1):
      rcu: Do RCU GP kthread self-wakeup from softirq and interrupt

yangerkun (3):
      ext4: fix check of inode in swap_inode_boot_loader
      ext4: update quota information while swapping boot loader inode
      ext4: add mask of ext4 flags to swap

zhangyi (F) (1):
      jbd2: clear dirty flag when revoking a buffer from an older transacti=
on

--=20
Ben Hutchings
For every complex problem
there is a solution that is simple, neat, and wrong.



--=-3m69Fjx7Me5M+9wRXjoi
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.16.70.patch"
Content-Disposition: attachment; filename="linux-3.16.70.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index e9a1864ac58e..9e2a3acb26cf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 69
+SUBLEVEL =3D 70
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 032d1b958889..213351ac5e38 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -157,6 +157,7 @@ static void __init imx6q_clocks_init(struct device_node=
 *ccm_node)
 	np =3D of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
 	base =3D of_iomap(np, 0);
 	WARN_ON(!base);
+	of_node_put(np);
=20
 	/* Audio/video PLL post dividers do not work on i.MX6q revision 1.0 */
 	if (cpu_is_imx6q() && imx_get_soc_revision() =3D=3D IMX_CHIP_REVISION_1_0=
) {
diff --git a/arch/arm/mach-imx/clk-imx6sx.c b/arch/arm/mach-imx/clk-imx6sx.=
c
index ac8ea72f28ab..fe45c1917ce8 100644
--- a/arch/arm/mach-imx/clk-imx6sx.c
+++ b/arch/arm/mach-imx/clk-imx6sx.c
@@ -143,6 +143,7 @@ static void __init imx6sx_clocks_init(struct device_nod=
e *ccm_node)
 	np =3D of_find_compatible_node(NULL, NULL, "fsl,imx6sx-anatop");
 	base =3D of_iomap(np, 0);
 	WARN_ON(!base);
+	of_node_put(np);
=20
 	/*                                              type               name  =
           parent_name   base         div_mask */
 	clks[IMX6SX_CLK_PLL1_SYS]       =3D imx_clk_pllv3(IMX_PLLV3_SYS,     "pll=
1_sys",      "osc",        base,        0x7f);
diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index 22dc3ee21fd4..d701e039996f 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -117,6 +117,7 @@ static void __init vf610_clocks_init(struct device_node=
 *ccm_node)
 	np =3D of_find_compatible_node(NULL, NULL, "fsl,vf610-anatop");
 	anatop_base =3D of_iomap(np, 0);
 	BUG_ON(!anatop_base);
+	of_node_put(np);
=20
 	np =3D ccm_node;
 	ccm_base =3D of_iomap(np, 0);
diff --git a/arch/arm/mach-s3c24xx/mach-osiris-dvs.c b/arch/arm/mach-s3c24x=
x/mach-osiris-dvs.c
index 33afb9190091..f6264958bd4f 100644
--- a/arch/arm/mach-s3c24xx/mach-osiris-dvs.c
+++ b/arch/arm/mach-s3c24xx/mach-osiris-dvs.c
@@ -70,16 +70,16 @@ static int osiris_dvs_notify(struct notifier_block *nb,
=20
 	switch (val) {
 	case CPUFREQ_PRECHANGE:
-		if (old_dvs & !new_dvs ||
-		    cur_dvs & !new_dvs) {
+		if ((old_dvs && !new_dvs) ||
+		    (cur_dvs && !new_dvs)) {
 			pr_debug("%s: exiting dvs\n", __func__);
 			cur_dvs =3D false;
 			gpio_set_value(OSIRIS_GPIO_DVS, 1);
 		}
 		break;
 	case CPUFREQ_POSTCHANGE:
-		if (!old_dvs & new_dvs ||
-		    !cur_dvs & new_dvs) {
+		if ((!old_dvs && new_dvs) ||
+		    (!cur_dvs && new_dvs)) {
 			pr_debug("entering dvs\n");
 			cur_dvs =3D true;
 			gpio_set_value(OSIRIS_GPIO_DVS, 0);
diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce=
-ccm-core.S
index d04eb27746d2..ed5dc54198c0 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -74,12 +74,13 @@ ENTRY(ce_aes_ccm_auth_data)
 	beq	10f
 	ext	v0.16b, v0.16b, v0.16b, #1	/* rotate out the mac bytes */
 	b	7b
-8:	mov	w7, w8
+8:	cbz	w8, 91f
+	mov	w7, w8
 	add	w8, w8, #16
 9:	ext	v1.16b, v1.16b, v1.16b, #1
 	adds	w7, w7, #1
 	bne	9b
-	eor	v0.16b, v0.16b, v1.16b
+91:	eor	v0.16b, v0.16b, v1.16b
 	st1	{v0.16b}, [x0]
 10:	str	w8, [x3]
 	ret
diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index 7f7830f2c5bc..aab46830f0b9 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -59,7 +59,10 @@ cpuflags-$(CONFIG_M5206e)	:=3D $(call cc-option,-mcpu=3D=
5206e,-m5200)
 cpuflags-$(CONFIG_M5206)	:=3D $(call cc-option,-mcpu=3D5206,-m5200)
=20
 KBUILD_AFLAGS +=3D $(cpuflags-y)
-KBUILD_CFLAGS +=3D $(cpuflags-y) -pipe
+KBUILD_CFLAGS +=3D $(cpuflags-y)
+
+KBUILD_CFLAGS +=3D -pipe -ffreestanding
+
 ifdef CONFIG_MMU
 # without -fno-strength-reduce the 53c7xx.c driver fails ;-(
 KBUILD_CFLAGS +=3D -fno-strength-reduce -ffixed-a2
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.=
S
index 22b45a4955cd..db5575c69792 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -757,6 +757,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_SPE)
 	mtcr	r10
 	lwz	r10,_LINK(r11)
 	mtlr	r10
+	/* Clear the exception_marker on the stack to avoid confusing stacktrace =
*/
+	li	r10, 0
+	stw	r10, 8(r11)
 	REST_GPR(10, r11)
 	mtspr	SPRN_SRR1,r9
 	mtspr	SPRN_SRR0,r12
@@ -987,6 +990,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_NEED_PAIRED_STWCX)
 	mtcrf	0xFF,r10
 	mtlr	r11
=20
+	/* Clear the exception_marker on the stack to avoid confusing stacktrace =
*/
+	li	r10, 0
+	stw	r10, 8(r1)
 	/*
 	 * Once we put values in SRR0 and SRR1, we are in a state
 	 * where exceptions are not recoverable, since taking an
@@ -1024,6 +1030,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_NEED_PAIRED_STWCX)
 	mtlr	r11
 	lwz	r10,_CCR(r1)
 	mtcrf	0xff,r10
+	/* Clear the exception_marker on the stack to avoid confusing stacktrace =
*/
+	li	r10, 0
+	stw	r10, 8(r1)
 	REST_2GPRS(9, r1)
 	.globl exc_exit_restart
 exc_exit_restart:
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 248ee7e5bebd..856a6cac5c3e 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -662,11 +662,6 @@ int irq_choose_cpu(const struct cpumask *mask)
 }
 #endif
=20
-int arch_early_irq_init(void)
-{
-	return 0;
-}
-
 #ifdef CONFIG_PPC64
 static int __init setup_noirqdistrib(char *str)
 {
diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index 7477de0e6e3c..2753fe609bcb 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -30,6 +30,7 @@
 #include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/export.h>
+#include <linux/security.h>
 #include <asm/mman.h>
 #include <asm/mmu.h>
 #include <asm/spu.h>
@@ -313,6 +314,7 @@ static unsigned long slice_find_area_topdown(struct mm_=
struct *mm,
 	int pshift =3D max_t(int, mmu_psize_defs[psize].shift, PAGE_SHIFT);
 	unsigned long addr, found, prev;
 	struct vm_unmapped_area_info info;
+	unsigned long min_addr =3D max(PAGE_SIZE, mmap_min_addr);
=20
 	info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
 	info.length =3D len;
@@ -320,7 +322,7 @@ static unsigned long slice_find_area_topdown(struct mm_=
struct *mm,
 	info.align_offset =3D 0;
=20
 	addr =3D mm->mmap_base;
-	while (addr > PAGE_SIZE) {
+	while (addr > min_addr) {
 		info.high_limit =3D addr;
 		if (!slice_scan_available(addr - 1, available, 0, &addr))
 			continue;
@@ -332,8 +334,8 @@ static unsigned long slice_find_area_topdown(struct mm_=
struct *mm,
 		 * Check if we need to reduce the range, or if we can
 		 * extend it to cover the previous available slice.
 		 */
-		if (addr < PAGE_SIZE)
-			addr =3D PAGE_SIZE;
+		if (addr < min_addr)
+			addr =3D min_addr;
 		else if (slice_scan_available(addr - 1, available, 0, &prev)) {
 			addr =3D prev;
 			goto prev_slice;
@@ -415,7 +417,7 @@ unsigned long slice_get_unmapped_area(unsigned long add=
r, unsigned long len,
 		addr =3D _ALIGN_UP(addr, 1ul << pshift);
 		slice_dbg(" aligned addr=3D%lx\n", addr);
 		/* Ignore hint if it's too large or overlaps a VMA */
-		if (addr > mm->task_size - len ||
+		if (addr > mm->task_size - len || addr < mmap_min_addr ||
 		    !slice_area_is_free(mm, addr, len))
 			addr =3D 0;
 	}
diff --git a/arch/powerpc/platforms/83xx/suspend-asm.S b/arch/powerpc/platf=
orms/83xx/suspend-asm.S
index 3d1ecd211776..8137f77abad5 100644
--- a/arch/powerpc/platforms/83xx/suspend-asm.S
+++ b/arch/powerpc/platforms/83xx/suspend-asm.S
@@ -26,13 +26,13 @@
 #define SS_MSR		0x74
 #define SS_SDR1		0x78
 #define SS_LR		0x7c
-#define SS_SPRG		0x80 /* 4 SPRGs */
-#define SS_DBAT		0x90 /* 8 DBATs */
-#define SS_IBAT		0xd0 /* 8 IBATs */
-#define SS_TB		0x110
-#define SS_CR		0x118
-#define SS_GPREG	0x11c /* r12-r31 */
-#define STATE_SAVE_SIZE 0x16c
+#define SS_SPRG		0x80 /* 8 SPRGs */
+#define SS_DBAT		0xa0 /* 8 DBATs */
+#define SS_IBAT		0xe0 /* 8 IBATs */
+#define SS_TB		0x120
+#define SS_CR		0x128
+#define SS_GPREG	0x12c /* r12-r31 */
+#define STATE_SAVE_SIZE 0x17c
=20
 	.section .data
 	.align	5
@@ -103,6 +103,16 @@ _GLOBAL(mpc83xx_enter_deep_sleep)
 	stw	r7, SS_SPRG+12(r3)
 	stw	r8, SS_SDR1(r3)
=20
+	mfspr	r4, SPRN_SPRG4
+	mfspr	r5, SPRN_SPRG5
+	mfspr	r6, SPRN_SPRG6
+	mfspr	r7, SPRN_SPRG7
+
+	stw	r4, SS_SPRG+16(r3)
+	stw	r5, SS_SPRG+20(r3)
+	stw	r6, SS_SPRG+24(r3)
+	stw	r7, SS_SPRG+28(r3)
+
 	mfspr	r4, SPRN_DBAT0U
 	mfspr	r5, SPRN_DBAT0L
 	mfspr	r6, SPRN_DBAT1U
@@ -493,6 +503,16 @@ _GLOBAL(mpc83xx_enter_deep_sleep)
 	mtspr	SPRN_IBAT7U, r6
 	mtspr	SPRN_IBAT7L, r7
=20
+	lwz	r4, SS_SPRG+16(r3)
+	lwz	r5, SS_SPRG+20(r3)
+	lwz	r6, SS_SPRG+24(r3)
+	lwz	r7, SS_SPRG+28(r3)
+
+	mtspr	SPRN_SPRG4, r4
+	mtspr	SPRN_SPRG5, r5
+	mtspr	SPRN_SPRG6, r6
+	mtspr	SPRN_SPRG7, r7
+
 	lwz	r4, SS_SPRG+0(r3)
 	lwz	r5, SS_SPRG+4(r3)
 	lwz	r6, SS_SPRG+8(r3)
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platfo=
rms/embedded6xx/wii.c
index 6d8dadf19f0b..545affadae05 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -104,6 +104,10 @@ unsigned long __init wii_mmu_mapin_mem2(unsigned long =
top)
 	/* MEM2 64MB@0x10000000 */
 	delta =3D wii_hole_start + wii_hole_size;
 	size =3D top - delta;
+
+	if (__map_without_bats)
+		return delta;
+
 	for (bl =3D 128<<10; bl < max_size; bl <<=3D 1) {
 		if (bl * 2 > size)
 			break;
diff --git a/arch/powerpc/platforms/powernv/opal-msglog.c b/arch/powerpc/pl=
atforms/powernv/opal-msglog.c
index 44ed78af1a0d..9021b7272889 100644
--- a/arch/powerpc/platforms/powernv/opal-msglog.c
+++ b/arch/powerpc/platforms/powernv/opal-msglog.c
@@ -92,7 +92,7 @@ static ssize_t opal_msglog_read(struct file *file, struct=
 kobject *kobj,
 }
=20
 static struct bin_attribute opal_msglog_attr =3D {
-	.attr =3D {.name =3D "msglog", .mode =3D 0444},
+	.attr =3D {.name =3D "msglog", .mode =3D 0400},
 	.read =3D opal_msglog_read
 };
=20
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6453f936540a..30a3ebd06f6c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -75,10 +75,15 @@ static inline u32 bit(int bitno)
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 					gva_t gva, gfn_t gfn, unsigned access)
 {
+	u64 gen =3D kvm_memslots(vcpu->kvm)->generation;
+
+	if (unlikely(gen & 1))
+		return;
+
 	vcpu->arch.mmio_gva =3D gva & PAGE_MASK;
 	vcpu->arch.access =3D access;
 	vcpu->arch.mmio_gfn =3D gfn;
-	vcpu->arch.mmio_gen =3D kvm_memslots(vcpu->kvm)->generation;
+	vcpu->arch.mmio_gen =3D gen;
 }
=20
 static inline bool vcpu_match_mmio_gen(struct kvm_vcpu *vcpu)
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 8ed4d42f9de5..5e8fff4fd522 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -84,17 +84,17 @@ static int hash_walk_new_entry(struct crypto_hash_walk =
*walk)
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 {
 	unsigned int alignmask =3D walk->alignmask;
-	unsigned int nbytes =3D walk->entrylen;
=20
 	walk->data -=3D walk->offset;
=20
-	if (nbytes && walk->offset & alignmask && !err) {
-		walk->offset =3D ALIGN(walk->offset, alignmask + 1);
-		nbytes =3D min(nbytes,
-			     ((unsigned int)(PAGE_SIZE)) - walk->offset);
-		walk->entrylen -=3D nbytes;
+	if (walk->entrylen && (walk->offset & alignmask) && !err) {
+		unsigned int nbytes;
=20
+		walk->offset =3D ALIGN(walk->offset, alignmask + 1);
+		nbytes =3D min(walk->entrylen,
+			     (unsigned int)(PAGE_SIZE - walk->offset));
 		if (nbytes) {
+			walk->entrylen -=3D nbytes;
 			walk->data +=3D walk->offset;
 			return nbytes;
 		}
@@ -114,7 +114,7 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk=
, int err)
 	if (err)
 		return err;
=20
-	if (nbytes) {
+	if (walk->entrylen) {
 		walk->offset =3D 0;
 		walk->pg++;
 		return hash_walk_next(walk);
@@ -200,6 +200,21 @@ static int ahash_setkey_unaligned(struct crypto_ahash =
*tfm, const u8 *key,
 	return ret;
 }
=20
+static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
+			  unsigned int keylen)
+{
+	return -ENOSYS;
+}
+
+static void ahash_set_needkey(struct crypto_ahash *tfm)
+{
+	const struct hash_alg_common *alg =3D crypto_hash_alg_common(tfm);
+
+	if (tfm->setkey !=3D ahash_nosetkey &&
+	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
+		crypto_ahash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
+}
+
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
@@ -211,20 +226,16 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, con=
st u8 *key,
 	else
 		err =3D tfm->setkey(tfm, key, keylen);
=20
-	if (err)
+	if (unlikely(err)) {
+		ahash_set_needkey(tfm);
 		return err;
+	}
=20
 	crypto_ahash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
=20
-static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
-			  unsigned int keylen)
-{
-	return -ENOSYS;
-}
-
 static inline unsigned int ahash_align_buffer_size(unsigned len,
 						   unsigned long mask)
 {
@@ -493,8 +504,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm=
)
=20
 	if (alg->setkey) {
 		hash->setkey =3D alg->setkey;
-		if (!(alg->halg.base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
-			crypto_ahash_set_flags(hash, CRYPTO_TFM_NEED_KEY);
+		ahash_set_needkey(hash);
 	}
 	if (alg->export)
 		hash->export =3D alg->export;
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index f654965f0933..de81f716cf26 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -52,7 +52,7 @@ static int crypto_pcbc_encrypt_segment(struct blkcipher_d=
esc *desc,
 	unsigned int nbytes =3D walk->nbytes;
 	u8 *src =3D walk->src.virt.addr;
 	u8 *dst =3D walk->dst.virt.addr;
-	u8 *iv =3D walk->iv;
+	u8 * const iv =3D walk->iv;
=20
 	do {
 		crypto_xor(iv, src, bsize);
@@ -76,7 +76,7 @@ static int crypto_pcbc_encrypt_inplace(struct blkcipher_d=
esc *desc,
 	int bsize =3D crypto_cipher_blocksize(tfm);
 	unsigned int nbytes =3D walk->nbytes;
 	u8 *src =3D walk->src.virt.addr;
-	u8 *iv =3D walk->iv;
+	u8 * const iv =3D walk->iv;
 	u8 tmpbuf[bsize];
=20
 	do {
@@ -89,8 +89,6 @@ static int crypto_pcbc_encrypt_inplace(struct blkcipher_d=
esc *desc,
 		src +=3D bsize;
 	} while ((nbytes -=3D bsize) >=3D bsize);
=20
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
=20
@@ -130,7 +128,7 @@ static int crypto_pcbc_decrypt_segment(struct blkcipher=
_desc *desc,
 	unsigned int nbytes =3D walk->nbytes;
 	u8 *src =3D walk->src.virt.addr;
 	u8 *dst =3D walk->dst.virt.addr;
-	u8 *iv =3D walk->iv;
+	u8 * const iv =3D walk->iv;
=20
 	do {
 		fn(crypto_cipher_tfm(tfm), dst, src);
@@ -142,8 +140,6 @@ static int crypto_pcbc_decrypt_segment(struct blkcipher=
_desc *desc,
 		dst +=3D bsize;
 	} while ((nbytes -=3D bsize) >=3D bsize);
=20
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
=20
@@ -156,7 +152,7 @@ static int crypto_pcbc_decrypt_inplace(struct blkcipher=
_desc *desc,
 	int bsize =3D crypto_cipher_blocksize(tfm);
 	unsigned int nbytes =3D walk->nbytes;
 	u8 *src =3D walk->src.virt.addr;
-	u8 *iv =3D walk->iv;
+	u8 * const iv =3D walk->iv;
 	u8 tmpbuf[bsize];
=20
 	do {
@@ -169,8 +165,6 @@ static int crypto_pcbc_decrypt_inplace(struct blkcipher=
_desc *desc,
 		src +=3D bsize;
 	} while ((nbytes -=3D bsize) >=3D bsize);
=20
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
=20
diff --git a/crypto/shash.c b/crypto/shash.c
index 194f7b1ff5cb..00d004c38696 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -52,6 +52,13 @@ static int shash_setkey_unaligned(struct crypto_shash *t=
fm, const u8 *key,
 	return err;
 }
=20
+static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *=
alg)
+{
+	if (crypto_shash_alg_has_setkey(alg) &&
+	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
+}
+
 int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 			unsigned int keylen)
 {
@@ -64,8 +71,10 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const =
u8 *key,
 	else
 		err =3D shash->setkey(tfm, key, keylen);
=20
-	if (err)
+	if (unlikely(err)) {
+		shash_set_needkey(tfm, shash);
 		return err;
+	}
=20
 	crypto_shash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
@@ -367,7 +376,8 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	crt->final =3D shash_async_final;
 	crt->finup =3D shash_async_finup;
 	crt->digest =3D shash_async_digest;
-	crt->setkey =3D shash_async_setkey;
+	if (crypto_shash_alg_has_setkey(alg))
+		crt->setkey =3D shash_async_setkey;
=20
 	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
 				    CRYPTO_TFM_NEED_KEY);
@@ -534,9 +544,7 @@ static int crypto_shash_init_tfm(struct crypto_tfm *tfm=
)
=20
 	hash->descsize =3D alg->descsize;
=20
-	if (crypto_shash_alg_has_setkey(alg) &&
-	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
-		crypto_shash_set_flags(hash, CRYPTO_TFM_NEED_KEY);
+	shash_set_needkey(hash, alg);
=20
 	return 0;
 }
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 498649ac1953..81d3e1b87035 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1655,14 +1655,21 @@ static int alg_test_crc32c(const struct alg_test_de=
sc *desc,
=20
 	err =3D alg_test_hash(desc, driver, type, mask);
 	if (err)
-		goto out;
+		return err;
=20
 	tfm =3D crypto_alloc_shash(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) =3D=3D -ENOENT) {
+			/*
+			 * This crc32c implementation is only available through
+			 * ahash API, not the shash API, so the remaining part
+			 * of the test is not applicable to it.
+			 */
+			return 0;
+		}
 		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
-		err =3D PTR_ERR(tfm);
-		goto out;
+		return PTR_ERR(tfm);
 	}
=20
 	do {
@@ -1691,7 +1698,6 @@ static int alg_test_crc32c(const struct alg_test_desc=
 *desc,
=20
 	crypto_free_shash(tfm);
=20
-out:
 	return err;
 }
=20
diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index 321bc6ff2a9d..904c8444aa0a 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -25,8 +25,9 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/byteorder.h>
 #include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
=20
 #define TGR192_DIGEST_SIZE 24
 #define TGR160_DIGEST_SIZE 20
@@ -468,10 +469,9 @@ static void tgr192_transform(struct tgr192_ctx *tctx, =
const u8 * data)
 	u64 a, b, c, aa, bb, cc;
 	u64 x[8];
 	int i;
-	const __le64 *ptr =3D (const __le64 *)data;
=20
 	for (i =3D 0; i < 8; i++)
-		x[i] =3D le64_to_cpu(ptr[i]);
+		x[i] =3D get_unaligned_le64(data + i * sizeof(__le64));
=20
 	/* save */
 	a =3D aa =3D tctx->a;
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 14790304b84b..9fcd51095d13 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -32,6 +32,7 @@
 #include <linux/wait.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/nospec.h>
=20
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -386,7 +387,11 @@ static ssize_t ac_write(struct file *file, const char =
__user *buf, size_t count,
 	TicCard =3D st_loc.tic_des_from_pc;	/* tic number to send            */
 	IndexCard =3D NumCard - 1;
=20
-	if((NumCard < 1) || (NumCard > MAX_BOARD) || !apbs[IndexCard].RamIO)
+	if (IndexCard >=3D MAX_BOARD)
+		return -EINVAL;
+	IndexCard =3D array_index_nospec(IndexCard, MAX_BOARD);
+
+	if (!apbs[IndexCard].RamIO)
 		return -EINVAL;
=20
 #ifdef DEBUG
@@ -697,6 +702,7 @@ static long ac_ioctl(struct file *file, unsigned int cm=
d, unsigned long arg)
 	unsigned char IndexCard;
 	void __iomem *pmem;
 	int ret =3D 0;
+	static int warncount =3D 10;
 	volatile unsigned char byte_reset_it;
 	struct st_ram_io *adgl;
 	void __user *argp =3D (void __user *)arg;
@@ -711,16 +717,12 @@ static long ac_ioctl(struct file *file, unsigned int =
cmd, unsigned long arg)
 	mutex_lock(&ac_mutex);=09
 	IndexCard =3D adgl->num_card-1;
 	=20
-	if(cmd !=3D 6 && ((IndexCard >=3D MAX_BOARD) || !apbs[IndexCard].RamIO)) =
{
-		static int warncount =3D 10;
-		if (warncount) {
-			printk( KERN_WARNING "APPLICOM driver IOCTL, bad board number %d\n",(in=
t)IndexCard+1);
-			warncount--;
-		}
-		kfree(adgl);
-		mutex_unlock(&ac_mutex);
-		return -EINVAL;
-	}
+	if (cmd !=3D 6 && IndexCard >=3D MAX_BOARD)
+		goto err;
+	IndexCard =3D array_index_nospec(IndexCard, MAX_BOARD);
+
+	if (cmd !=3D 6 && !apbs[IndexCard].RamIO)
+		goto err;
=20
 	switch (cmd) {
 	=09
@@ -838,5 +840,16 @@ static long ac_ioctl(struct file *file, unsigned int c=
md, unsigned long arg)
 	kfree(adgl);
 	mutex_unlock(&ac_mutex);
 	return 0;
+
+err:
+	if (warncount) {
+		pr_warn("APPLICOM driver IOCTL, bad board number %d\n",
+			(int)IndexCard + 1);
+		warncount--;
+	}
+	kfree(adgl);
+	mutex_unlock(&ac_mutex);
+	return -EINVAL;
+
 }
=20
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index d5d4cd82b9f7..978a782f5e30 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -377,7 +377,7 @@ static __init int hpet_mmap_enable(char *str)
 	pr_info("HPET mmap %s\n", hpet_mmap_enabled ? "enabled" : "disabled");
 	return 1;
 }
-__setup("hpet_mmap", hpet_mmap_enable);
+__setup("hpet_mmap=3D", hpet_mmap_enable);
=20
 static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 {
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlo=
g.c
index 59f7cb28260b..0dddf3299628 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -81,7 +81,7 @@ static void *tpm_bios_measurements_start(struct seq_file =
*m, loff_t *pos)
 	for (i =3D 0; i < *pos; i++) {
 		event =3D addr;
=20
-		if ((addr + sizeof(struct tcpa_event)) < limit) {
+		if ((addr + sizeof(struct tcpa_event)) <=3D limit) {
 			if (event->event_type =3D=3D 0 && event->event_size =3D=3D 0)
 				return NULL;
 			addr +=3D sizeof(struct tcpa_event) + event->event_size;
@@ -89,13 +89,13 @@ static void *tpm_bios_measurements_start(struct seq_fil=
e *m, loff_t *pos)
 	}
=20
 	/* now check if current entry is valid */
-	if ((addr + sizeof(struct tcpa_event)) >=3D limit)
+	if ((addr + sizeof(struct tcpa_event)) > limit)
 		return NULL;
=20
 	event =3D addr;
=20
 	if ((event->event_type =3D=3D 0 && event->event_size =3D=3D 0) ||
-	    ((addr + sizeof(struct tcpa_event) + event->event_size) >=3D limit))
+	    ((addr + sizeof(struct tcpa_event) + event->event_size) > limit))
 		return NULL;
=20
 	return addr;
@@ -111,7 +111,7 @@ static void *tpm_bios_measurements_next(struct seq_file=
 *m, void *v,
 	v +=3D sizeof(struct tcpa_event) + event->event_size;
=20
 	/* now check if current entry is valid */
-	if ((v + sizeof(struct tcpa_event)) >=3D limit)
+	if ((v + sizeof(struct tcpa_event)) > limit)
 		return NULL;
=20
 	event =3D v;
@@ -120,7 +120,7 @@ static void *tpm_bios_measurements_next(struct seq_file=
 *m, void *v,
 		return NULL;
=20
 	if ((event->event_type =3D=3D 0 && event->event_size =3D=3D 0) ||
-	    ((v + sizeof(struct tcpa_event) + event->event_size) >=3D limit))
+	    ((v + sizeof(struct tcpa_event) + event->event_size) > limit))
 		return NULL;
=20
 	(*pos)++;
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_at=
mel.c
index 503a85ae176c..66c4efa7fca1 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -65,7 +65,14 @@ static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf=
, size_t len)
 	dev_dbg(chip->dev,
 		"%s(buf=3D%*ph len=3D%0zx) -> sts=3D%d\n", __func__,
 		(int)min_t(size_t, 64, len), buf, len, status);
-	return status;
+	if (status < 0)
+		return status;
+
+	/* The upper layer does not support incomplete sends. */
+	if (status !=3D len)
+		return -E2BIG;
+
+	return 0;
 }
=20
 static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 2e7e9d9798cb..d320f8ae5e64 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -293,6 +293,7 @@ static __init struct clk *hb_clk_init(struct device_nod=
e *node, const struct clk
 	/* Map system registers */
 	srnp =3D of_find_compatible_node(NULL, NULL, "calxeda,hb-sregs");
 	hb_clk->reg =3D of_iomap(srnp, 0);
+	of_node_put(srnp);
 	BUG_ON(!hb_clk->reg);
 	hb_clk->reg +=3D reg;
=20
diff --git a/drivers/clk/mvebu/armada-370.c b/drivers/clk/mvebu/armada-370.=
c
index bef198a83863..f9679a4f973a 100644
--- a/drivers/clk/mvebu/armada-370.c
+++ b/drivers/clk/mvebu/armada-370.c
@@ -168,8 +168,10 @@ static void __init a370_clk_init(struct device_node *n=
p)
=20
 	mvebu_coreclk_setup(np, &a370_coreclks);
=20
-	if (cgnp)
+	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, a370_gating_desc);
+		of_node_put(cgnp);
+	}
 }
 CLK_OF_DECLARE(a370_clk, "marvell,armada-370-core-clock", a370_clk_init);
=20
diff --git a/drivers/clk/mvebu/armada-xp.c b/drivers/clk/mvebu/armada-xp.c
index b3094315a3c0..2fa15a274719 100644
--- a/drivers/clk/mvebu/armada-xp.c
+++ b/drivers/clk/mvebu/armada-xp.c
@@ -202,7 +202,9 @@ static void __init axp_clk_init(struct device_node *np)
=20
 	mvebu_coreclk_setup(np, &axp_coreclks);
=20
-	if (cgnp)
+	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, axp_gating_desc);
+		of_node_put(cgnp);
+	}
 }
 CLK_OF_DECLARE(axp_clk, "marvell,armada-xp-core-clock", axp_clk_init);
diff --git a/drivers/clk/mvebu/dove.c b/drivers/clk/mvebu/dove.c
index b8c2424ac926..1320020ca381 100644
--- a/drivers/clk/mvebu/dove.c
+++ b/drivers/clk/mvebu/dove.c
@@ -187,7 +187,9 @@ static void __init dove_clk_init(struct device_node *np=
)
=20
 	mvebu_coreclk_setup(np, &dove_coreclks);
=20
-	if (cgnp)
+	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, dove_gating_desc);
+		of_node_put(cgnp);
+	}
 }
 CLK_OF_DECLARE(dove_clk, "marvell,dove-core-clock", dove_clk_init);
diff --git a/drivers/clk/mvebu/kirkwood.c b/drivers/clk/mvebu/kirkwood.c
index ddb666a86500..8457b48f1395 100644
--- a/drivers/clk/mvebu/kirkwood.c
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -236,8 +236,11 @@ static void __init kirkwood_clk_init(struct device_nod=
e *np)
 	else
 		mvebu_coreclk_setup(np, &kirkwood_coreclks);
=20
-	if (cgnp)
+	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, kirkwood_gating_desc);
+
+		of_node_put(cgnp);
+	}
 }
 CLK_OF_DECLARE(kirkwood_clk, "marvell,kirkwood-core-clock",
 	       kirkwood_clk_init);
diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-ex=
ynos4.c
index 1a2e2c915f35..672da2916228 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1032,6 +1032,7 @@ static unsigned long exynos4_get_xom(void)
 			xom =3D readl(chipid_base + 8);
=20
 		iounmap(chipid_base);
+		of_node_put(np);
 	}
=20
 	return xom;
diff --git a/drivers/clk/socfpga/clk-pll.c b/drivers/clk/socfpga/clk-pll.c
index de6da957a09d..f091cb1707a3 100644
--- a/drivers/clk/socfpga/clk-pll.c
+++ b/drivers/clk/socfpga/clk-pll.c
@@ -102,6 +102,7 @@ static __init struct clk *__socfpga_pll_init(struct dev=
ice_node *node,
=20
 	clkmgr_np =3D of_find_compatible_node(NULL, NULL, "altr,clk-mgr");
 	clk_mgr_base_addr =3D of_iomap(clkmgr_np, 0);
+	of_node_put(clkmgr_np);
 	BUG_ON(!clk_mgr_base_addr);
 	pll_clk->hw.reg =3D clk_mgr_base_addr + reg;
=20
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_=
mct.c
index 2163a5145518..650ddc984253 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -558,7 +558,19 @@ static void __init exynos4_timer_resources(struct devi=
ce_node *np, void __iomem
 	return;
=20
 out_irq:
-	free_percpu_irq(mct_irqs[MCT_L0_IRQ], &percpu_mct_tick);
+	if (mct_int_type =3D=3D MCT_INT_PPI) {
+		free_percpu_irq(mct_irqs[MCT_L0_IRQ], &percpu_mct_tick);
+	} else {
+		for_each_possible_cpu(cpu) {
+			struct mct_clock_event_device *pcpu_mevt =3D
+				per_cpu_ptr(&percpu_mct_tick, cpu);
+
+			if (pcpu_mevt->evt.irq !=3D -1) {
+				free_irq(pcpu_mevt->evt.irq, pcpu_mevt);
+				pcpu_mevt->evt.irq =3D -1;
+			}
+		}
+	}
 }
=20
 void __init mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l=
1)
diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpuf=
req.c
index e24269ab4e9b..aab0d8ff5032 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -191,7 +191,7 @@ static int pxa_cpufreq_change_voltage(pxa_freqs_t *pxa_=
freq)
 	return ret;
 }
=20
-static void __init pxa_cpufreq_init_voltages(void)
+static void pxa_cpufreq_init_voltages(void)
 {
 	vcc_core =3D regulator_get(NULL, "vcc_core");
 	if (IS_ERR(vcc_core)) {
@@ -207,7 +207,7 @@ static int pxa_cpufreq_change_voltage(pxa_freqs_t *pxa_=
freq)
 	return 0;
 }
=20
-static void __init pxa_cpufreq_init_voltages(void) { }
+static void pxa_cpufreq_init_voltages(void) { }
 #endif
=20
 static void find_freq_tables(struct cpufreq_frequency_table **freq_table,
diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 071c2c969eec..8f6762bdc315 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -503,6 +503,7 @@ static umode_t __init ibft_check_tgt_for(void *data, in=
t type)
 	case ISCSI_BOOT_TGT_NIC_ASSOC:
 	case ISCSI_BOOT_TGT_CHAP_TYPE:
 		rc =3D S_IRUGO;
+		break;
 	case ISCSI_BOOT_TGT_NAME:
 		if (tgt->tgt_name_len)
 			rc =3D S_IRUGO;
diff --git a/drivers/gpu/drm/drm_context.c b/drivers/gpu/drm/drm_context.c
index d2376911c541..6e1a8420b3fc 100644
--- a/drivers/gpu/drm/drm_context.c
+++ b/drivers/gpu/drm/drm_context.c
@@ -309,19 +309,22 @@ int drm_addctx(struct drm_device *dev, void *data,
 {
 	struct drm_ctx_list *ctx_entry;
 	struct drm_ctx *ctx =3D data;
+	int tmp_handle;
=20
-	ctx->handle =3D drm_ctxbitmap_next(dev);
-	if (ctx->handle =3D=3D DRM_KERNEL_CONTEXT) {
+	tmp_handle =3D drm_ctxbitmap_next(dev);
+	if (tmp_handle =3D=3D DRM_KERNEL_CONTEXT) {
 		/* Skip kernel's context and get a new one. */
-		ctx->handle =3D drm_ctxbitmap_next(dev);
+		tmp_handle =3D drm_ctxbitmap_next(dev);
 	}
-	DRM_DEBUG("%d\n", ctx->handle);
-	if (ctx->handle < 0) {
+	DRM_DEBUG("%d\n", tmp_handle);
+	if (tmp_handle < 0) {
 		DRM_DEBUG("Not enough free contexts.\n");
 		/* Should this return -EBUSY instead? */
-		return -ENOMEM;
+		return tmp_handle;
 	}
=20
+	ctx->handle =3D tmp_handle;
+
 	ctx_entry =3D kmalloc(sizeof(*ctx_entry), GFP_KERNEL);
 	if (!ctx_entry) {
 		DRM_DEBUG("out of memory\n");
diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon=
/evergreen_cs.c
index 5c8b358f9fba..d3d8167c6f80 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -1318,6 +1318,7 @@ static int evergreen_cs_check_reg(struct radeon_cs_pa=
rser *p, u32 reg, u32 idx)
 			return -EINVAL;
 		}
 		ib[idx] +=3D (u32)((reloc->gpu_offset >> 8) & 0xffffffff);
+		break;
 	case CB_TARGET_MASK:
 		track->cb_target_mask =3D radeon_get_ib_value(p, idx);
 		track->cb_dirty =3D true;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniba=
nd/hw/ocrdma/ocrdma_verbs.c
index 43e6f0572717..fd003efcf9b6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -39,7 +39,7 @@
=20
 int ocrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pk=
ey)
 {
-	if (index > 1)
+	if (index > 0)
 		return -EINVAL;
=20
 	*pkey =3D 0xffff;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infinib=
and/hw/usnic/usnic_ib_verbs.c
index 806432ad21bf..b97e123826a1 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -410,7 +410,7 @@ int usnic_ib_query_gid(struct ib_device *ibdev, u8 port=
, int index,
 int usnic_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 				u16 *pkey)
 {
-	if (index > 1)
+	if (index > 0)
 		return -EINVAL;
=20
 	*pkey =3D 0xffff;
diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb=
-l2.c
index 94a15ae52212..de5c57d23b92 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -82,8 +82,9 @@ static void brcmstb_l2_intc_suspend(struct irq_data *d)
 {
 	struct irq_chip_generic *gc =3D irq_data_get_irq_chip_data(d);
 	struct brcmstb_l2_intc_data *b =3D gc->private;
+	unsigned long flags;
=20
-	irq_gc_lock(gc);
+	irq_gc_lock_irqsave(gc, flags);
 	/* Save the current mask */
 	b->saved_mask =3D __raw_readl(b->base + CPU_MASK_STATUS);
=20
@@ -92,22 +93,23 @@ static void brcmstb_l2_intc_suspend(struct irq_data *d)
 		__raw_writel(~gc->wake_active, b->base + CPU_MASK_SET);
 		__raw_writel(gc->wake_active, b->base + CPU_MASK_CLEAR);
 	}
-	irq_gc_unlock(gc);
+	irq_gc_unlock_irqrestore(gc, flags);
 }
=20
 static void brcmstb_l2_intc_resume(struct irq_data *d)
 {
 	struct irq_chip_generic *gc =3D irq_data_get_irq_chip_data(d);
 	struct brcmstb_l2_intc_data *b =3D gc->private;
+	unsigned long flags;
=20
-	irq_gc_lock(gc);
+	irq_gc_lock_irqsave(gc, flags);
 	/* Clear unmasked non-wakeup interrupts */
 	__raw_writel(~b->saved_mask & ~gc->wake_active, b->base + CPU_CLEAR);
=20
 	/* Restore the saved mask */
 	__raw_writel(b->saved_mask, b->base + CPU_MASK_SET);
 	__raw_writel(~b->saved_mask, b->base + CPU_MASK_CLEAR);
-	irq_gc_unlock(gc);
+	irq_gc_unlock_irqrestore(gc, flags);
 }
=20
 int __init brcmstb_l2_intc_of_init(struct device_node *np,
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-c=
ommon.c
index 88317b4f7bf3..53be8ac31eed 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -214,7 +214,7 @@ static void lp55xx_firmware_loaded(const struct firmwar=
e *fw, void *context)
=20
 	if (!fw) {
 		dev_err(dev, "firmware request failed\n");
-		goto out;
+		return;
 	}
=20
 	/* handling firmware data is chip dependent */
@@ -227,9 +227,9 @@ static void lp55xx_firmware_loaded(const struct firmwar=
e *fw, void *context)
=20
 	mutex_unlock(&chip->lock);
=20
-out:
 	/* firmware should be released for other channel use */
 	release_firmware(chip->fw);
+	chip->fw =3D NULL;
 }
=20
 static int lp55xx_request_firmware(struct lp55xx_chip *chip)
diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index 3a0de4cf9771..9d3ccf1bb749 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -530,6 +530,7 @@ static bool bch_extent_bad(struct btree_keys *bk, const=
 struct bkey *k)
 	struct btree *b =3D container_of(bk, struct btree, keys);
 	struct bucket *g;
 	unsigned i, stale;
+	char buf[80];
=20
 	if (!KEY_PTRS(k) ||
 	    bch_extent_invalid(bk, k))
@@ -539,20 +540,20 @@ static bool bch_extent_bad(struct btree_keys *bk, con=
st struct bkey *k)
 		if (!ptr_available(b->c, k, i))
 			return true;
=20
-	if (!expensive_debug_checks(b->c) && KEY_DIRTY(k))
-		return false;
-
 	for (i =3D 0; i < KEY_PTRS(k); i++) {
 		g =3D PTR_BUCKET(b->c, k, i);
 		stale =3D ptr_stale(b->c, k, i);
=20
+		if (stale && KEY_DIRTY(k)) {
+			bch_extent_to_text(buf, sizeof(buf), k);
+			pr_info("stale dirty pointer, stale %u, key: %s",
+				stale, buf);
+		}
+
 		btree_bug_on(stale > 96, b,
 			     "key too stale: %i, need_gc %u",
 			     stale, b->c->need_gc);
=20
-		btree_bug_on(stale && KEY_DIRTY(k) && KEY_SIZE(k),
-			     b, "stale dirty pointer");
-
 		if (stale)
 			return true;
=20
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index d1ff56aeaeb3..ea0d006414ac 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -68,6 +68,9 @@ static inline bool should_writeback(struct cached_dev *dc=
, struct bio *bio,
 	    in_use > CUTOFF_WRITEBACK_SYNC)
 		return false;
=20
+	if (bio->bi_rw & REQ_DISCARD)
+		return false;
+
 	if (dc->partial_stripes_expensive &&
 	    bcache_dev_stripe_dirty(dc, bio->bi_iter.bi_sector,
 				    bio_sectors(bio)))
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 18b0c80fc447..cbe36396c371 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3820,6 +3820,8 @@ static int run(struct mddev *mddev)
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread =3D md_register_thread(md_do_sync, mddev,
 							"reshape");
+		if (!mddev->sync_thread)
+			goto out_free_conf;
 	}
=20
 	return 0;
@@ -4506,7 +4508,6 @@ static sector_t reshape_request(struct mddev *mddev, =
sector_t sector_nr,
 	atomic_inc(&r10_bio->remaining);
 	read_bio->bi_next =3D NULL;
 	generic_make_request(read_bio);
-	sector_nr +=3D nr_sectors;
 	sectors_done +=3D nr_sectors;
 	if (sector_nr <=3D last)
 		goto read_more;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index affe5d3e768b..1dae2b025159 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6180,6 +6180,8 @@ static int run(struct mddev *mddev)
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread =3D md_register_thread(md_do_sync, mddev,
 							"reshape");
+		if (!mddev->sync_thread)
+			goto abort;
 	}
=20
=20
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index cdd7c1b7259b..a94db59c238c 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -167,10 +167,10 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 #define REG_GFIX	0x69	/* Fix gain control */
=20
 #define REG_DBLV	0x6b	/* PLL control an debugging */
-#define   DBLV_BYPASS	  0x00	  /* Bypass PLL */
-#define   DBLV_X4	  0x01	  /* clock x4 */
-#define   DBLV_X6	  0x10	  /* clock x6 */
-#define   DBLV_X8	  0x11	  /* clock x8 */
+#define   DBLV_BYPASS	  0x0a	  /* Bypass PLL */
+#define   DBLV_X4	  0x4a	  /* clock x4 */
+#define   DBLV_X6	  0x8a	  /* clock x6 */
+#define   DBLV_X8	  0xca	  /* clock x8 */
=20
 #define REG_REG76	0x76	/* OV's name */
 #define   R76_BLKPCOR	  0x80	  /* Black pixel correction enable */
@@ -845,7 +845,7 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
 	if (ret < 0)
 		return ret;
=20
-	return ov7670_write(sd, REG_DBLV, DBLV_X4);
+	return 0;
 }
=20
 static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
@@ -1552,11 +1552,7 @@ static int ov7670_probe(struct i2c_client *client,
 		if (config->clock_speed)
 			info->clock_speed =3D config->clock_speed;
=20
-		/*
-		 * It should be allowed for ov7670 too when it is migrated to
-		 * the new frame rate formula.
-		 */
-		if (config->pll_bypass && id->driver_data !=3D MODEL_OV7670)
+		if (config->pll_bypass)
 			info->pll_bypass =3D true;
=20
 		if (config->pclk_hb_disable)
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/pl=
atform/s5p-jpeg/jpeg-core.c
index 0dcb796ecad9..78f923ed32f0 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -859,13 +859,16 @@ static int s5p_jpeg_querycap(struct file *file, void =
*priv,
 	return 0;
 }
=20
-static int enum_fmt(struct s5p_jpeg_fmt *sjpeg_formats, int n,
+static int enum_fmt(struct s5p_jpeg_ctx *ctx,
+		    struct s5p_jpeg_fmt *sjpeg_formats, int n,
 		    struct v4l2_fmtdesc *f, u32 type)
 {
 	int i, num =3D 0;
+	unsigned int fmt_ver_flag =3D ctx->jpeg->variant->fmt_ver_flag;
=20
 	for (i =3D 0; i < n; ++i) {
-		if (sjpeg_formats[i].flags & type) {
+		if (sjpeg_formats[i].flags & type &&
+		    sjpeg_formats[i].flags & fmt_ver_flag) {
 			/* index-th format of type type found ? */
 			if (num =3D=3D f->index)
 				break;
@@ -891,11 +894,11 @@ static int s5p_jpeg_enum_fmt_vid_cap(struct file *fil=
e, void *priv,
 	struct s5p_jpeg_ctx *ctx =3D fh_to_ctx(priv);
=20
 	if (ctx->mode =3D=3D S5P_JPEG_ENCODE)
-		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 				SJPEG_FMT_FLAG_ENC_CAPTURE);
=20
-	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
-					SJPEG_FMT_FLAG_DEC_CAPTURE);
+	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
+			SJPEG_FMT_FLAG_DEC_CAPTURE);
 }
=20
 static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
@@ -904,11 +907,11 @@ static int s5p_jpeg_enum_fmt_vid_out(struct file *fil=
e, void *priv,
 	struct s5p_jpeg_ctx *ctx =3D fh_to_ctx(priv);
=20
 	if (ctx->mode =3D=3D S5P_JPEG_ENCODE)
-		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 				SJPEG_FMT_FLAG_ENC_OUTPUT);
=20
-	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
-					SJPEG_FMT_FLAG_DEC_OUTPUT);
+	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
+			SJPEG_FMT_FLAG_DEC_OUTPUT);
 }
=20
 static struct s5p_jpeg_q_data *get_q_data(struct s5p_jpeg_ctx *ctx,
@@ -1360,7 +1363,7 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_c=
tx *ctx)
=20
 		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
 				  V4L2_CID_JPEG_RESTART_INTERVAL,
-				  0, 3, 0xffff, 0);
+				  0, 0xffff, 1, 0);
 		if (ctx->jpeg->variant->version =3D=3D SJPEG_S5P)
 			mask =3D ~0x06; /* 422, 420 */
 	}
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc=
_driver.c
index bb002b9120de..3b5f73ffe17a 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -977,11 +977,19 @@ static int uvc_parse_standard_control(struct uvc_devi=
ce *dev,
 			return -EINVAL;
 		}
=20
-		/* Make sure the terminal type MSB is not null, otherwise it
-		 * could be confused with a unit.
+		/*
+		 * Reject invalid terminal types that would cause issues:
+		 *
+		 * - The high byte must be non-zero, otherwise it would be
+		 *   confused with a unit.
+		 *
+		 * - Bit 15 must be 0, as we use it internally as a terminal
+		 *   direction flag.
+		 *
+		 * Other unknown types are accepted.
 		 */
 		type =3D get_unaligned_le16(&buffer[4]);
-		if ((type & 0xff00) =3D=3D 0) {
+		if ((type & 0x7f00) =3D=3D 0 || (type & 0x8000) !=3D 0) {
 			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
 				"interface %d INPUT_TERMINAL %d has invalid "
 				"type 0x%04x, skipping\n", udev->devnum,
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_=
video.c
index 983c24a70ff5..0e2a9d732c2d 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -627,6 +627,14 @@ void uvc_video_clock_update(struct uvc_streaming *stre=
am,
 	u32 rem;
 	u64 y;
=20
+	/*
+	 * We will get called from __vb2_queue_cancel() if there are buffers
+	 * done but not dequeued by the user, but the sample array has already
+	 * been released at that time. Just bail out in that case.
+	 */
+	if (!clock->samples)
+		return;
+
 	spin_lock_irqsave(&clock->lock, flags);
=20
 	if (clock->count < clock->size)
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 1996467481e9..40e57398ad56 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -921,7 +921,7 @@ static inline void set_cmd_timeout(struct mmc_omap_host=
 *host, struct mmc_reques
 	reg &=3D ~(1 << 5);
 	OMAP_MMC_WRITE(host, SDIO, reg);
 	/* Set maximum timeout */
-	OMAP_MMC_WRITE(host, CTO, 0xff);
+	OMAP_MMC_WRITE(host, CTO, 0xfd);
 }
=20
 static inline void set_data_timeout(struct mmc_omap_host *host, struct mmc=
_request *req)
diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 91a169c44b39..a202cf556993 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1822,7 +1822,7 @@ static void __exit doc_dbg_unregister(struct docg3 *d=
ocg3)
  * @chip_id: The chip ID of the supported chip
  * @mtd: The structure to fill
  */
-static void __init doc_set_driver_info(int chip_id, struct mtd_info *mtd)
+static int __init doc_set_driver_info(int chip_id, struct mtd_info *mtd)
 {
 	struct docg3 *docg3 =3D mtd->priv;
 	int cfg;
@@ -1835,6 +1835,8 @@ static void __init doc_set_driver_info(int chip_id, s=
truct mtd_info *mtd)
 	case DOC_CHIPID_G3:
 		mtd->name =3D kasprintf(GFP_KERNEL, "docg3.%d",
 				      docg3->device_id);
+		if (!mtd->name)
+			return -ENOMEM;
 		docg3->max_block =3D 2047;
 		break;
 	}
@@ -1857,6 +1859,8 @@ static void __init doc_set_driver_info(int chip_id, s=
truct mtd_info *mtd)
 	mtd->_block_isbad =3D doc_block_isbad;
 	mtd->ecclayout =3D &docg3_oobinfo;
 	mtd->ecc_strength =3D DOC_ECC_BCH_T;
+
+	return 0;
 }
=20
 /**
@@ -1907,7 +1911,7 @@ doc_probe_device(struct docg3_cascade *cascade, int f=
loor, struct device *dev)
=20
 	ret =3D 0;
 	if (chip_id !=3D (u16)(~chip_id_inv)) {
-		goto nomem3;
+		goto nomem4;
 	}
=20
 	switch (chip_id) {
@@ -1917,21 +1921,25 @@ doc_probe_device(struct docg3_cascade *cascade, int=
 floor, struct device *dev)
 		break;
 	default:
 		doc_err("Chip id %04x is not a DiskOnChip G3 chip\n", chip_id);
-		goto nomem3;
+		goto nomem4;
 	}
=20
-	doc_set_driver_info(chip_id, mtd);
+	ret =3D doc_set_driver_info(chip_id, mtd);
+	if (ret)
+		goto nomem4;
=20
 	doc_hamming_ecc_init(docg3, DOC_LAYOUT_OOB_PAGEINFO_SZ);
 	doc_reload_bbt(docg3);
 	return mtd;
=20
+nomem4:
+	kfree(docg3->bbt);
 nomem3:
 	kfree(mtd);
 nomem2:
 	kfree(docg3);
 nomem1:
-	return ERR_PTR(ret);
+	return ret ? ERR_PTR(ret) : NULL;
 }
=20
 /**
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/etherne=
t/mellanox/mlx4/cmd.c
index d38572de8946..e080fd1d927a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2196,6 +2196,8 @@ int mlx4_cmd_use_events(struct mlx4_dev *dev)
 	if (!priv->cmd.context)
 		return -ENOMEM;
=20
+	if (mlx4_is_mfunc(dev))
+		mutex_lock(&priv->cmd.slave_cmd_mutex);
 	down_write(&priv->cmd.switch_sem);
 	for (i =3D 0; i < priv->cmd.max_cmds; ++i) {
 		priv->cmd.context[i].token =3D i;
@@ -2217,6 +2219,8 @@ int mlx4_cmd_use_events(struct mlx4_dev *dev)
 	down(&priv->cmd.poll_sem);
 	priv->cmd.use_events =3D 1;
 	up_write(&priv->cmd.switch_sem);
+	if (mlx4_is_mfunc(dev))
+		mutex_unlock(&priv->cmd.slave_cmd_mutex);
=20
 	return err;
 }
@@ -2229,6 +2233,8 @@ void mlx4_cmd_use_polling(struct mlx4_dev *dev)
 	struct mlx4_priv *priv =3D mlx4_priv(dev);
 	int i;
=20
+	if (mlx4_is_mfunc(dev))
+		mutex_lock(&priv->cmd.slave_cmd_mutex);
 	down_write(&priv->cmd.switch_sem);
 	priv->cmd.use_events =3D 0;
=20
@@ -2239,6 +2245,8 @@ void mlx4_cmd_use_polling(struct mlx4_dev *dev)
=20
 	up(&priv->cmd.poll_sem);
 	up_write(&priv->cmd.switch_sem);
+	if (mlx4_is_mfunc(dev))
+		mutex_unlock(&priv->cmd.slave_cmd_mutex);
 }
=20
 struct mlx4_cmd_mailbox *mlx4_alloc_cmd_mailbox(struct mlx4_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/driver=
s/net/ethernet/mellanox/mlx4/resource_tracker.c
index 338c09beecc8..6130dd76e50d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -2460,13 +2460,13 @@ static int qp_get_mtt_size(struct mlx4_qp_context *=
qpc)
 	int total_pages;
 	int total_mem;
 	int page_offset =3D (be32_to_cpu(qpc->params2) >> 6) & 0x3f;
+	int tot;
=20
 	sq_size =3D 1 << (log_sq_size + log_sq_sride + 4);
 	rq_size =3D (srq|rss|xrc) ? 0 : (1 << (log_rq_size + log_rq_stride + 4));
 	total_mem =3D sq_size + rq_size;
-	total_pages =3D
-		roundup_pow_of_two((total_mem + (page_offset << 6)) >>
-				   page_shift);
+	tot =3D (total_mem + (page_offset << 6)) >> page_shift;
+	total_pages =3D !tot ? 1 : roundup_pow_of_two(tot);
=20
 	return total_pages;
 }
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/r=
enesas/sh_eth.c
index b62545b93f3f..07ef09579730 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2712,12 +2712,16 @@ static struct sh_eth_plat_data *sh_eth_parse_dt(str=
uct device *dev)
 	struct device_node *np =3D dev->of_node;
 	struct sh_eth_plat_data *pdata;
 	const char *mac_addr;
+	int ret;
=20
 	pdata =3D devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return NULL;
=20
-	pdata->phy_interface =3D of_get_phy_mode(np);
+	ret =3D of_get_phy_mode(np);
+	if (ret < 0)
+		return NULL;
+	pdata->phy_interface =3D ret;
=20
 	mac_addr =3D of_get_mac_address(np);
 	if (mac_addr)
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index bb1ab1ffbc8b..5dd0fe1635b9 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -579,6 +579,7 @@ static void pptp_sock_destruct(struct sock *sk)
 		pppox_unbind_sock(sk);
 	}
 	skb_queue_purge(&sk->sk_receive_queue);
+	dst_release(rcu_dereference_protected(sk->sk_dst_cache, 1));
 }
=20
 static int pptp_create(struct net *net, struct socket *sock)
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index d7e4f83f8bf3..73874090cf42 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1280,6 +1280,14 @@ static void vxlan_rcv(struct vxlan_sock *vs,
 		}
 	}
=20
+	rcu_read_lock();
+
+	if (unlikely(!(vxlan->dev->flags & IFF_UP))) {
+		rcu_read_unlock();
+		atomic_long_inc(&vxlan->dev->rx_dropped);
+		goto drop;
+	}
+
 	stats =3D this_cpu_ptr(vxlan->dev->tstats);
 	u64_stats_update_begin(&stats->syncp);
 	stats->rx_packets++;
@@ -1288,6 +1296,8 @@ static void vxlan_rcv(struct vxlan_sock *vs,
=20
 	netif_rx(skb);
=20
+	rcu_read_unlock();
+
 	return;
 drop:
 	/* Consume bad packet */
diff --git a/drivers/net/wireless/libertas_tf/if_usb.c b/drivers/net/wirele=
ss/libertas_tf/if_usb.c
index cdb1afca58b6..eb9bed7edd37 100644
--- a/drivers/net/wireless/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/libertas_tf/if_usb.c
@@ -440,8 +440,6 @@ static int __if_usb_submit_rx_urb(struct if_usb_card *c=
ardp,
 			  skb_tail_pointer(skb),
 			  MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn, cardp);
=20
-	cardp->rx_urb->transfer_flags |=3D URB_ZERO_PACKET;
-
 	lbtf_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n",
 		cardp->rx_urb);
 	ret =3D usb_submit_urb(cardp->rx_urb, GFP_ATOMIC);
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifi=
ex/ie.c
index 3bf3d58bbc02..69827b5f96b5 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -328,6 +328,8 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 	struct ieee_types_header *rsn_ie, *wpa_ie =3D NULL;
 	u16 rsn_idx =3D MWIFIEX_AUTO_IDX_MASK, ie_len =3D 0;
 	const u8 *vendor_ie;
+	unsigned int token_len;
+	int err =3D 0;
=20
 	if (info->tail && info->tail_len) {
 		gen_ie =3D kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
@@ -341,8 +343,13 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 		rsn_ie =3D (void *)cfg80211_find_ie(WLAN_EID_RSN,
 						  info->tail, info->tail_len);
 		if (rsn_ie) {
-			memcpy(gen_ie->ie_buffer, rsn_ie, rsn_ie->len + 2);
-			ie_len =3D rsn_ie->len + 2;
+			token_len =3D rsn_ie->len + 2;
+			if (ie_len + token_len > IEEE_MAX_IE_SIZE) {
+				err =3D -EINVAL;
+				goto out;
+			}
+			memcpy(gen_ie->ie_buffer + ie_len, rsn_ie, token_len);
+			ie_len +=3D token_len;
 			gen_ie->ie_length =3D cpu_to_le16(ie_len);
 		}
=20
@@ -352,9 +359,15 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 						    info->tail_len);
 		if (vendor_ie) {
 			wpa_ie =3D (struct ieee_types_header *)vendor_ie;
-			memcpy(gen_ie->ie_buffer + ie_len,
-			       wpa_ie, wpa_ie->len + 2);
-			ie_len +=3D wpa_ie->len + 2;
+			token_len =3D wpa_ie->len + 2;
+			if (token_len >
+			    info->tail + info->tail_len - (u8 *)wpa_ie ||
+			    ie_len + token_len > IEEE_MAX_IE_SIZE) {
+				err =3D -EINVAL;
+				goto out;
+			}
+			memcpy(gen_ie->ie_buffer + ie_len, wpa_ie, token_len);
+			ie_len +=3D token_len;
 			gen_ie->ie_length =3D cpu_to_le16(ie_len);
 		}
=20
@@ -362,13 +375,16 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv=
,
 			if (mwifiex_update_uap_custom_ie(priv, gen_ie, &rsn_idx,
 							 NULL, NULL,
 							 NULL, NULL)) {
-				kfree(gen_ie);
-				return -1;
+				err =3D -EINVAL;
+				goto out;
 			}
 			priv->rsn_idx =3D rsn_idx;
 		}
=20
+	out:
 		kfree(gen_ie);
+		if (err)
+			return err;
 	}
=20
 	return mwifiex_set_mgmt_beacon_data_ies(priv, info);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwi=
fiex/scan.c
index 45c5b3450cf5..6d50ecc18839 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1171,6 +1171,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_ad=
apter *adapter,
 		}
 		switch (element_id) {
 		case WLAN_EID_SSID:
+			if (element_len > IEEE80211_MAX_SSID_LEN)
+				return -EINVAL;
 			bss_entry->ssid.ssid_len =3D element_len;
 			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
 			       element_len);
@@ -1180,6 +1182,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_ad=
apter *adapter,
 			break;
=20
 		case WLAN_EID_SUPP_RATES:
+			if (element_len > MWIFIEX_SUPPORTED_RATES)
+				return -EINVAL;
 			memcpy(bss_entry->data_rates, current_ptr + 2,
 			       element_len);
 			memcpy(bss_entry->supported_rates, current_ptr + 2,
@@ -1189,6 +1193,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_ad=
apter *adapter,
 			break;
=20
 		case WLAN_EID_FH_PARAMS:
+			if (element_len + 2 < sizeof(*fh_param_set))
+				return -EINVAL;
 			fh_param_set =3D
 				(struct ieee_types_fh_param_set *) current_ptr;
 			memcpy(&bss_entry->phy_param_set.fh_param_set,
@@ -1197,6 +1203,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_ad=
apter *adapter,
 			break;
=20
 		case WLAN_EID_DS_PARAMS:
+			if (element_len + 2 < sizeof(*ds_param_set))
+				return -EINVAL;
 			ds_param_set =3D
 				(struct ieee_types_ds_param_set *) current_ptr;
=20
@@ -1208,6 +1216,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_ad=
apter *adapter,
 			break;
=20
 		case WLAN_EID_CF_PARAMS:
+			if (element_len + 2 < sizeof(*cf_param_set))
+				return -EINVAL;
 			cf_param_set =3D
 				(struct ieee_types_cf_param_set *) current_ptr;
 			memcpy(&bss_entry->ss_param_set.cf_param_set,
@@ -1216,6 +1226,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_ad=
apter *adapter,
 			break;
=20
 		case WLAN_EID_IBSS_PARAMS:
+			if (element_len + 2 < sizeof(*ibss_param_set))
+				return -EINVAL;
 			ibss_param_set =3D
 				(struct ieee_types_ibss_param_set *)
 				current_ptr;
@@ -1225,10 +1237,14 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_=
adapter *adapter,
 			break;
=20
 		case WLAN_EID_ERP_INFO:
+			if (!element_len)
+				return -EINVAL;
 			bss_entry->erp_flags =3D *(current_ptr + 2);
 			break;
=20
 		case WLAN_EID_PWR_CONSTRAINT:
+			if (!element_len)
+				return -EINVAL;
 			bss_entry->local_constraint =3D *(current_ptr + 2);
 			bss_entry->sensed_11h =3D true;
 			break;
@@ -1268,6 +1284,9 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_ad=
apter *adapter,
 			break;
=20
 		case WLAN_EID_VENDOR_SPECIFIC:
+			if (element_len + 2 < sizeof(vendor_ie->vend_hdr))
+				return -EINVAL;
+
 			vendor_ie =3D (struct ieee_types_vendor_specific *)
 					current_ptr;
=20
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 6b9737d392e2..5b6e0e951a85 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -1377,7 +1377,7 @@ static struct superio_struct *find_superio(struct par=
port *p)
 {
 	int i;
 	for (i =3D 0; i < NR_SUPERIOS; i++)
-		if (superios[i].io !=3D p->base)
+		if (superios[i].io =3D=3D p->base)
 			return &superios[i];
 	return NULL;
 }
diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7778.c b/drivers/pinctrl/sh-pfc/=
pfc-r8a7778.c
index c7d610d1f3ef..da13a48065cd 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7778.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7778.c
@@ -1265,8 +1265,8 @@ static const struct sh_pfc_pin pinmux_pins[] =3D {
=20
 	/* Pins not associated with a GPIO port */
 	SH_PFC_PIN_NAMED(3, 20, C20),
-	SH_PFC_PIN_NAMED(20, 1, T1),
-	SH_PFC_PIN_NAMED(25, 2, Y2),
+	SH_PFC_PIN_NAMED(1, 20, A20),
+	SH_PFC_PIN_NAMED(2, 25, B25),
 };
=20
 /* - macro */
@@ -1401,7 +1401,7 @@ HSPI_PFC_DAT(hspi1_a,	HSPI_CLK1_A,		HSPI_CS1_A,
 			HSPI_RX1_A,		HSPI_TX1_A);
=20
 HSPI_PFC_PIN(hspi1_b,	RCAR_GP_PIN(0, 27),	RCAR_GP_PIN(0, 26),
-			PIN_NUMBER(20, 1),	PIN_NUMBER(25, 2));
+			PIN_NUMBER(1, 20),	PIN_NUMBER(2, 25));
 HSPI_PFC_DAT(hspi1_b,	HSPI_CLK1_B,		HSPI_CS1_B,
 			HSPI_RX1_B,		HSPI_TX1_B);
=20
diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c b/drivers/pinctrl/sh-pfc/=
pfc-r8a7791.c
index 601a349f9cab..642f94ae39a3 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
@@ -4433,7 +4433,7 @@ static const char * const scifb2_groups[] =3D {
 	"scifb2_data_b",
 	"scifb2_clk_b",
 	"scifb2_ctrl_b",
-	"scifb0_data_c",
+	"scifb2_data_c",
 	"scifb2_clk_c",
 	"scifb2_data_d",
 };
diff --git a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c b/drivers/pinctrl/sh-pfc/p=
fc-sh73a0.c
index 29b7c79915f6..b5743b701ec6 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
@@ -2899,7 +2899,8 @@ static const char * const fsic_groups[] =3D {
 	"fsic_sclk_out",
 	"fsic_data_in",
 	"fsic_data_out",
-	"fsic_spdif",
+	"fsic_spdif_0",
+	"fsic_spdif_1",
 };
=20
 static const char * const fsid_groups[] =3D {
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcd=
c.c
index 0d88a82ab2a2..544ea6ed465e 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -327,8 +327,8 @@ static int wm831x_buckv_get_voltage_sel(struct regulato=
r_dev *rdev)
 }
=20
 /* Current limit options */
-static u16 wm831x_dcdc_ilim[] =3D {
-	125, 250, 375, 500, 625, 750, 875, 1000
+static const unsigned int wm831x_dcdc_ilim[] =3D {
+	125000, 250000, 375000, 500000, 625000, 750000, 875000, 1000000
 };
=20
 static int wm831x_buckv_set_current_limit(struct regulator_dev *rdev,
diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index 0916089c7c3e..0302626bee60 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -116,12 +116,14 @@ static int pm80x_rtc_read_time(struct device *dev, st=
ruct rtc_time *tm)
 	unsigned char buf[4];
 	unsigned long ticks, base, data;
 	regmap_raw_read(info->map, PM800_RTC_EXPIRE2_1, buf, 4);
-	base =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	base =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	dev_dbg(info->dev, "%x-%x-%x-%x\n", buf[0], buf[1], buf[2], buf[3]);
=20
 	/* load 32-bit read-only counter */
 	regmap_raw_read(info->map, PM800_RTC_COUNTER1, buf, 4);
-	data =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks =3D base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -144,7 +146,8 @@ static int pm80x_rtc_set_time(struct device *dev, struc=
t rtc_time *tm)
=20
 	/* load 32-bit read-only counter */
 	regmap_raw_read(info->map, PM800_RTC_COUNTER1, buf, 4);
-	data =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	base =3D ticks - data;
 	dev_dbg(info->dev, "set base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -165,11 +168,13 @@ static int pm80x_rtc_read_alarm(struct device *dev, s=
truct rtc_wkalrm *alrm)
 	int ret;
=20
 	regmap_raw_read(info->map, PM800_RTC_EXPIRE2_1, buf, 4);
-	base =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	base =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	dev_dbg(info->dev, "%x-%x-%x-%x\n", buf[0], buf[1], buf[2], buf[3]);
=20
 	regmap_raw_read(info->map, PM800_RTC_EXPIRE1_1, buf, 4);
-	data =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks =3D base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -192,12 +197,14 @@ static int pm80x_rtc_set_alarm(struct device *dev, st=
ruct rtc_wkalrm *alrm)
 	regmap_update_bits(info->map, PM800_RTC_CONTROL, PM800_ALARM1_EN, 0);
=20
 	regmap_raw_read(info->map, PM800_RTC_EXPIRE2_1, buf, 4);
-	base =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	base =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	dev_dbg(info->dev, "%x-%x-%x-%x\n", buf[0], buf[1], buf[2], buf[3]);
=20
 	/* load 32-bit read-only counter */
 	regmap_raw_read(info->map, PM800_RTC_COUNTER1, buf, 4);
-	data =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks =3D base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 0c6add1a38dc..bb07a9eb0923 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -115,11 +115,13 @@ static int pm860x_rtc_read_time(struct device *dev, s=
truct rtc_time *tm)
 	pm860x_page_bulk_read(info->i2c, REG0_ADDR, 8, buf);
 	dev_dbg(info->dev, "%x-%x-%x-%x-%x-%x-%x-%x\n", buf[0], buf[1],
 		buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
-	base =3D (buf[1] << 24) | (buf[3] << 16) | (buf[5] << 8) | buf[7];
+	base =3D ((unsigned long)buf[1] << 24) | (buf[3] << 16) |
+		(buf[5] << 8) | buf[7];
=20
 	/* load 32-bit read-only counter */
 	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
-	data =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks =3D base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -145,7 +147,8 @@ static int pm860x_rtc_set_time(struct device *dev, stru=
ct rtc_time *tm)
=20
 	/* load 32-bit read-only counter */
 	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
-	data =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	base =3D ticks - data;
 	dev_dbg(info->dev, "set base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -170,10 +173,12 @@ static int pm860x_rtc_read_alarm(struct device *dev, =
struct rtc_wkalrm *alrm)
 	pm860x_page_bulk_read(info->i2c, REG0_ADDR, 8, buf);
 	dev_dbg(info->dev, "%x-%x-%x-%x-%x-%x-%x-%x\n", buf[0], buf[1],
 		buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
-	base =3D (buf[1] << 24) | (buf[3] << 16) | (buf[5] << 8) | buf[7];
+	base =3D ((unsigned long)buf[1] << 24) | (buf[3] << 16) |
+		(buf[5] << 8) | buf[7];
=20
 	pm860x_bulk_read(info->i2c, PM8607_RTC_EXPIRE1, 4, buf);
-	data =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks =3D base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
@@ -198,11 +203,13 @@ static int pm860x_rtc_set_alarm(struct device *dev, s=
truct rtc_wkalrm *alrm)
 	pm860x_page_bulk_read(info->i2c, REG0_ADDR, 8, buf);
 	dev_dbg(info->dev, "%x-%x-%x-%x-%x-%x-%x-%x\n", buf[0], buf[1],
 		buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
-	base =3D (buf[1] << 24) | (buf[3] << 16) | (buf[5] << 8) | buf[7];
+	base =3D ((unsigned long)buf[1] << 24) | (buf[3] << 16) |
+		(buf[5] << 8) | buf[7];
=20
 	/* load 32-bit read-only counter */
 	pm860x_bulk_read(info->i2c, PM8607_RTC_COUNTER1, 4, buf);
-	data =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	data =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+		(buf[1] << 8) | buf[0];
 	ticks =3D base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
index a4888dbca2e1..3215869fedbc 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -60,7 +60,8 @@ static int ds1672_get_datetime(struct i2c_client *client,=
 struct rtc_time *tm)
 		"%s: raw read data - counters=3D%02x,%02x,%02x,%02x\n",
 		__func__, buf[0], buf[1], buf[2], buf[3]);
=20
-	time =3D (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	time =3D ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+	       (buf[1] << 8) | buf[0];
=20
 	rtc_time_to_tm(time, tm);
=20
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 197699f358c7..f72459e4fce8 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -175,7 +175,8 @@ static int pm8xxx_rtc_read_time(struct device *dev, str=
uct rtc_time *tm)
 		}
 	}
=20
-	secs =3D value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24)=
;
+	secs =3D value[0] | (value[1] << 8) | (value[2] << 16) |
+	       ((unsigned long)value[3] << 24);
=20
 	rtc_time_to_tm(secs, tm);
=20
@@ -253,7 +254,8 @@ static int pm8xxx_rtc_read_alarm(struct device *dev, st=
ruct rtc_wkalrm *alarm)
 		return rc;
 	}
=20
-	secs =3D value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24)=
;
+	secs =3D value[0] | (value[1] << 8) | (value[2] << 16) |
+	       ((unsigned long)value[3] << 24);
=20
 	rtc_time_to_tm(secs, &alarm->time);
=20
diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index bf6cab931472..85d1ced4ab0e 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -258,6 +258,8 @@ static void virtio_ccw_drop_indicators(struct virtio_cc=
w_device *vcdev)
 {
 	struct virtio_ccw_vq_info *info;
=20
+	if (!vcdev->airq_info)
+		return;
 	list_for_each_entry(info, &vcdev->virtqueues, node)
 		drop_airq_indicator(info->vq, vcdev->airq_info);
 }
@@ -386,7 +388,7 @@ static int virtio_ccw_read_vq_conf(struct virtio_ccw_de=
vice *vcdev,
 	ccw->count =3D sizeof(struct vq_config_block);
 	ccw->cda =3D (__u32)(unsigned long)(vcdev->config_block);
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_VQ_CONF);
-	return vcdev->config_block->num;
+	return vcdev->config_block->num ?: -ENOENT;
 }
=20
 static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b8d67f9f9077..b756d671adae 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -631,7 +631,6 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
 		return FAILED;
=20
 	memset(cmd, 0, sizeof(*cmd));
-	cmd->sc =3D sc;
 	cmd->req.tmf =3D (struct virtio_scsi_ctrl_tmf_req){
 		.type =3D VIRTIO_SCSI_T_TMF,
 		.subtype =3D VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET,
@@ -654,7 +653,6 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 		return FAILED;
=20
 	memset(cmd, 0, sizeof(*cmd));
-	cmd->sc =3D sc;
 	cmd->req.tmf =3D (struct virtio_scsi_ctrl_tmf_req){
 		.type =3D VIRTIO_SCSI_T_TMF,
 		.subtype =3D VIRTIO_SCSI_T_TMF_ABORT_TASK,
diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ash=
mem.c
index fbca97248f37..031fbd59876b 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -158,19 +158,15 @@ static inline void lru_del(struct ashmem_range *range=
)
  * @end:	   The ending page (inclusive)
  *
  * This function is protected by ashmem_mutex.
- *
- * Return: 0 if successful, or -ENOMEM if there is an error
  */
-static int range_alloc(struct ashmem_area *asma,
-		       struct ashmem_range *prev_range, unsigned int purged,
-		       size_t start, size_t end)
+static void range_alloc(struct ashmem_area *asma,
+			struct ashmem_range *prev_range, unsigned int purged,
+			size_t start, size_t end,
+			struct ashmem_range **new_range)
 {
-	struct ashmem_range *range;
-
-	range =3D kmem_cache_zalloc(ashmem_range_cachep, GFP_KERNEL);
-	if (unlikely(!range))
-		return -ENOMEM;
+	struct ashmem_range *range =3D *new_range;
=20
+	*new_range =3D NULL;
 	range->asma =3D asma;
 	range->pgstart =3D start;
 	range->pgend =3D end;
@@ -180,8 +176,6 @@ static int range_alloc(struct ashmem_area *asma,
=20
 	if (range_on_lru(range))
 		lru_add(range);
-
-	return 0;
 }
=20
 /**
@@ -576,7 +570,8 @@ static int get_name(struct ashmem_area *asma, void __us=
er *name)
  *
  * Caller must hold ashmem_mutex.
  */
-static int ashmem_pin(struct ashmem_area *asma, size_t pgstart, size_t pge=
nd)
+static int ashmem_pin(struct ashmem_area *asma, size_t pgstart, size_t pge=
nd,
+		      struct ashmem_range **new_range)
 {
 	struct ashmem_range *range, *next;
 	int ret =3D ASHMEM_NOT_PURGED;
@@ -628,7 +623,7 @@ static int ashmem_pin(struct ashmem_area *asma, size_t =
pgstart, size_t pgend)
 			 * second half and adjust the first chunk's endpoint.
 			 */
 			range_alloc(asma, range, range->purged,
-				    pgend + 1, range->pgend);
+				    pgend + 1, range->pgend, new_range);
 			range_shrink(range, range->pgstart, pgstart - 1);
 			break;
 		}
@@ -642,7 +637,8 @@ static int ashmem_pin(struct ashmem_area *asma, size_t =
pgstart, size_t pgend)
  *
  * Caller must hold ashmem_mutex.
  */
-static int ashmem_unpin(struct ashmem_area *asma, size_t pgstart, size_t p=
gend)
+static int ashmem_unpin(struct ashmem_area *asma, size_t pgstart, size_t p=
gend,
+			struct ashmem_range **new_range)
 {
 	struct ashmem_range *range, *next;
 	unsigned int purged =3D ASHMEM_NOT_PURGED;
@@ -668,7 +664,8 @@ static int ashmem_unpin(struct ashmem_area *asma, size_=
t pgstart, size_t pgend)
 		}
 	}
=20
-	return range_alloc(asma, range, purged, pgstart, pgend);
+	range_alloc(asma, range, purged, pgstart, pgend, new_range);
+	return 0;
 }
=20
 /*
@@ -701,10 +698,17 @@ static int ashmem_pin_unpin(struct ashmem_area *asma,=
 unsigned long cmd,
 	struct ashmem_pin pin;
 	size_t pgstart, pgend;
 	int ret =3D -EINVAL;
+	struct ashmem_range *range =3D NULL;
=20
 	if (unlikely(copy_from_user(&pin, p, sizeof(pin))))
 		return -EFAULT;
=20
+	if (cmd =3D=3D ASHMEM_PIN || cmd =3D=3D ASHMEM_UNPIN) {
+		range =3D kmem_cache_zalloc(ashmem_range_cachep, GFP_KERNEL);
+		if (!range)
+			return -ENOMEM;
+	}
+
 	mutex_lock(&ashmem_mutex);
=20
 	if (unlikely(!asma->file))
@@ -728,10 +732,10 @@ static int ashmem_pin_unpin(struct ashmem_area *asma,=
 unsigned long cmd,
=20
 	switch (cmd) {
 	case ASHMEM_PIN:
-		ret =3D ashmem_pin(asma, pgstart, pgend);
+		ret =3D ashmem_pin(asma, pgstart, pgend, &range);
 		break;
 	case ASHMEM_UNPIN:
-		ret =3D ashmem_unpin(asma, pgstart, pgend);
+		ret =3D ashmem_unpin(asma, pgstart, pgend, &range);
 		break;
 	case ASHMEM_GET_PIN_STATUS:
 		ret =3D ashmem_get_pin_status(asma, pgstart, pgend);
@@ -740,6 +744,8 @@ static int ashmem_pin_unpin(struct ashmem_area *asma, u=
nsigned long cmd,
=20
 out_unlock:
 	mutex_unlock(&ashmem_mutex);
+	if (range)
+		kmem_cache_free(ashmem_range_cachep, range);
=20
 	return ret;
 }
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/bin=
der.c
index 892b91054914..06fbf0b0a3cb 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -473,7 +473,7 @@ static void binder_insert_free_buffer(struct binder_pro=
c *proc,
 	new_buffer_size =3D binder_buffer_size(proc, new_buffer);
=20
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: add free buffer, size %zd, at %p\n",
+		     "%d: add free buffer, size %zd, at %pK\n",
 		      proc->pid, new_buffer_size, new_buffer);
=20
 	while (*p) {
@@ -552,7 +552,7 @@ static int binder_update_page_range(struct binder_proc =
*proc, int allocate,
 	struct mm_struct *mm;
=20
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: %s pages %p-%p\n", proc->pid,
+		     "%d: %s pages %pK-%pK\n", proc->pid,
 		     allocate ? "allocate" : "free", start, end);
=20
 	if (end <=3D start)
@@ -593,7 +593,7 @@ static int binder_update_page_range(struct binder_proc =
*proc, int allocate,
 		BUG_ON(*page);
 		*page =3D alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
 		if (*page =3D=3D NULL) {
-			pr_err("%d: binder_alloc_buf failed for page at %p\n",
+			pr_err("%d: binder_alloc_buf failed for page at %pK\n",
 				proc->pid, page_addr);
 			goto err_alloc_page_failed;
 		}
@@ -602,7 +602,7 @@ static int binder_update_page_range(struct binder_proc =
*proc, int allocate,
 		page_array_ptr =3D page;
 		ret =3D map_vm_area(&tmp_area, PAGE_KERNEL, &page_array_ptr);
 		if (ret) {
-			pr_err("%d: binder_alloc_buf failed to map page at %p in kernel\n",
+			pr_err("%d: binder_alloc_buf failed to map page at %pK in kernel\n",
 			       proc->pid, page_addr);
 			goto err_map_kernel_failed;
 		}
@@ -706,7 +706,7 @@ static struct binder_buffer *binder_alloc_buf(struct bi=
nder_proc *proc,
 	}
=20
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got buffer %p size %zd\n",
+		     "%d: binder_alloc_buf size %zd got buffer %pK size %zd\n",
 		      proc->pid, size, buffer, buffer_size);
=20
 	has_page_addr =3D
@@ -736,7 +736,7 @@ static struct binder_buffer *binder_alloc_buf(struct bi=
nder_proc *proc,
 		binder_insert_free_buffer(proc, new_buffer);
 	}
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_alloc_buf size %zd got %p\n",
+		     "%d: binder_alloc_buf size %zd got %pK\n",
 		      proc->pid, size, buffer);
 	buffer->data_size =3D data_size;
 	buffer->offsets_size =3D offsets_size;
@@ -776,7 +776,7 @@ static void binder_delete_free_buffer(struct binder_pro=
c *proc,
 		if (buffer_end_page(prev) =3D=3D buffer_end_page(buffer))
 			free_page_end =3D 0;
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "%d: merge free, buffer %p share page with %p\n",
+			     "%d: merge free, buffer %pK share page with %pK\n",
 			      proc->pid, buffer, prev);
 	}
=20
@@ -789,14 +789,14 @@ static void binder_delete_free_buffer(struct binder_p=
roc *proc,
 			    buffer_start_page(buffer))
 				free_page_start =3D 0;
 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				     "%d: merge free, buffer %p share page with %p\n",
+				     "%d: merge free, buffer %pK share page with %pK\n",
 				      proc->pid, buffer, prev);
 		}
 	}
 	list_del(&buffer->entry);
 	if (free_page_start || free_page_end) {
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "%d: merge free, buffer %p do not share page%s%s with %p or %p\n",
+			     "%d: merge free, buffer %pK do not share page%s%s with %pK or %pK\=
n",
 			     proc->pid, buffer, free_page_start ? "" : " end",
 			     free_page_end ? "" : " start", prev, next);
 		binder_update_page_range(proc, 0, free_page_start ?
@@ -817,7 +817,7 @@ static void binder_free_buf(struct binder_proc *proc,
 		ALIGN(buffer->offsets_size, sizeof(void *));
=20
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "%d: binder_free_buf %p size %zd buffer_size %zd\n",
+		     "%d: binder_free_buf %pK size %zd buffer_size %zd\n",
 		      proc->pid, buffer, size, buffer_size);
=20
 	BUG_ON(buffer->free);
@@ -2825,7 +2825,7 @@ static int binder_mmap(struct file *filp, struct vm_a=
rea_struct *vma)
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
 		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
-			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid, v=
ma->vm_start, vma->vm_end, proc->buffer);
+			pr_info("binder_mmap: %d %lx-%lx maps %pK bad alignment\n", proc->pid, =
vma->vm_start, vma->vm_end, proc->buffer);
 			vma->vm_start +=3D PAGE_SIZE;
 		}
 	}
@@ -3083,7 +3083,7 @@ static void binder_deferred_release(struct binder_pro=
c *proc)
=20
 			page_addr =3D proc->buffer + i * PAGE_SIZE;
 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				     "%s: %d: page %d at %p not freed\n",
+				     "%s: %d: page %d at %pK not freed\n",
 				     __func__, proc->pid, i, page_addr);
 			unmap_kernel_range((unsigned long)page_addr, PAGE_SIZE);
 			__free_page(proc->pages[i]);
@@ -3184,7 +3184,7 @@ static void print_binder_transaction(struct seq_file =
*m, const char *prefix,
 static void print_binder_buffer(struct seq_file *m, const char *prefix,
 				struct binder_buffer *buffer)
 {
-	seq_printf(m, "%s %d: %p size %zd:%zd %s\n",
+	seq_printf(m, "%s %d: %pK size %zd:%zd %s\n",
 		   prefix, buffer->debug_id, buffer->data,
 		   buffer->data_size, buffer->offsets_size,
 		   buffer->transaction ? "active" : "delivered");
@@ -3287,7 +3287,7 @@ static void print_binder_node(struct seq_file *m, str=
uct binder_node *node)
=20
 static void print_binder_ref(struct seq_file *m, struct binder_ref *ref)
 {
-	seq_printf(m, "  ref %d: desc %d %snode %d s %d w %d d %p\n",
+	seq_printf(m, "  ref %d: desc %d %snode %d s %d w %d d %pK\n",
 		   ref->debug_id, ref->desc, ref->node->proc ? "" : "dead ",
 		   ref->node->debug_id, ref->strong, ref->weak, ref->death);
 }
diff --git a/drivers/staging/iio/addac/adt7316.c b/drivers/staging/iio/adda=
c/adt7316.c
index 5f1770e6f6c3..f548c1cc0022 100644
--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -47,6 +47,8 @@
 #define ADT7516_MSB_AIN3		0xA
 #define ADT7516_MSB_AIN4		0xB
 #define ADT7316_DA_DATA_BASE		0x10
+#define ADT7316_DA_10_BIT_LSB_SHIFT	6
+#define ADT7316_DA_12_BIT_LSB_SHIFT	4
 #define ADT7316_DA_MSB_DATA_REGS	4
 #define ADT7316_LSB_DAC_A		0x10
 #define ADT7316_MSB_DAC_A		0x11
@@ -59,8 +61,8 @@
 #define ADT7316_CONFIG1			0x18
 #define ADT7316_CONFIG2			0x19
 #define ADT7316_CONFIG3			0x1A
-#define ADT7316_LDAC_CONFIG		0x1B
-#define ADT7316_DAC_CONFIG		0x1C
+#define ADT7316_DAC_CONFIG		0x1B
+#define ADT7316_LDAC_CONFIG		0x1C
 #define ADT7316_INT_MASK1		0x1D
 #define ADT7316_INT_MASK2		0x1E
 #define ADT7316_IN_TEMP_OFFSET		0x1F
@@ -117,7 +119,7 @@
  */
 #define ADT7316_ADCLK_22_5		0x1
 #define ADT7316_DA_HIGH_RESOLUTION	0x2
-#define ADT7316_DA_EN_VIA_DAC_LDCA	0x4
+#define ADT7316_DA_EN_VIA_DAC_LDCA	0x8
 #define ADT7516_AIN_IN_VREF		0x10
 #define ADT7316_EN_IN_TEMP_PROP_DACA	0x20
 #define ADT7316_EN_EX_TEMP_PROP_DACB	0x40
@@ -635,9 +637,7 @@ static ssize_t adt7316_show_da_high_resolution(struct d=
evice *dev,
 	struct adt7316_chip_info *chip =3D iio_priv(dev_info);
=20
 	if (chip->config3 & ADT7316_DA_HIGH_RESOLUTION) {
-		if (chip->id =3D=3D ID_ADT7316 || chip->id =3D=3D ID_ADT7516)
-			return sprintf(buf, "1 (12 bits)\n");
-		else if (chip->id =3D=3D ID_ADT7317 || chip->id =3D=3D ID_ADT7517)
+		if (chip->id !=3D ID_ADT7318 && chip->id !=3D ID_ADT7519)
 			return sprintf(buf, "1 (10 bits)\n");
 	}
=20
@@ -654,16 +654,12 @@ static ssize_t adt7316_store_da_high_resolution(struc=
t device *dev,
 	u8 config3;
 	int ret;
=20
-	chip->dac_bits =3D 8;
+	if (chip->id =3D=3D ID_ADT7318 || chip->id =3D=3D ID_ADT7519)
+		return -EPERM;
=20
-	if (buf[0] =3D=3D '1') {
-		config3 =3D chip->config3 | ADT7316_DA_HIGH_RESOLUTION;
-		if (chip->id =3D=3D ID_ADT7316 || chip->id =3D=3D ID_ADT7516)
-			chip->dac_bits =3D 12;
-		else if (chip->id =3D=3D ID_ADT7317 || chip->id =3D=3D ID_ADT7517)
-			chip->dac_bits =3D 10;
-	} else
-		config3 =3D chip->config3 & (~ADT7316_DA_HIGH_RESOLUTION);
+	config3 =3D chip->config3 & (~ADT7316_DA_HIGH_RESOLUTION);
+	if (buf[0] =3D=3D '1')
+		config3 |=3D ADT7316_DA_HIGH_RESOLUTION;
=20
 	ret =3D chip->bus.write(chip->bus.client, ADT7316_CONFIG3, config3);
 	if (ret)
@@ -1093,7 +1089,7 @@ static ssize_t adt7316_store_DAC_internal_Vref(struct=
 device *dev,
 		ldac_config =3D chip->ldac_config & (~ADT7516_DAC_IN_VREF_MASK);
 		if (data & 0x1)
 			ldac_config |=3D ADT7516_DAC_AB_IN_VREF;
-		else if (data & 0x2)
+		if (data & 0x2)
 			ldac_config |=3D ADT7516_DAC_CD_IN_VREF;
 	} else {
 		ret =3D kstrtou8(buf, 16, &data);
@@ -1415,7 +1411,7 @@ static IIO_DEVICE_ATTR(ex_analog_temp_offset, S_IRUGO=
 | S_IWUSR,
 static ssize_t adt7316_show_DAC(struct adt7316_chip_info *chip,
 		int channel, char *buf)
 {
-	u16 data;
+	u16 data =3D 0;
 	u8 msb, lsb, offset;
 	int ret;
=20
@@ -1440,7 +1436,11 @@ static ssize_t adt7316_show_DAC(struct adt7316_chip_=
info *chip,
 	if (ret)
 		return -EIO;
=20
-	data =3D (msb << offset) + (lsb & ((1 << offset) - 1));
+	if (chip->dac_bits =3D=3D 12)
+		data =3D lsb >> ADT7316_DA_12_BIT_LSB_SHIFT;
+	else if (chip->dac_bits =3D=3D 10)
+		data =3D lsb >> ADT7316_DA_10_BIT_LSB_SHIFT;
+	data |=3D msb << offset;
=20
 	return sprintf(buf, "%d\n", data);
 }
@@ -1448,7 +1448,7 @@ static ssize_t adt7316_show_DAC(struct adt7316_chip_i=
nfo *chip,
 static ssize_t adt7316_store_DAC(struct adt7316_chip_info *chip,
 		int channel, const char *buf, size_t len)
 {
-	u8 msb, lsb, offset;
+	u8 msb, lsb, lsb_reg, offset;
 	u16 data;
 	int ret;
=20
@@ -1466,9 +1466,13 @@ static ssize_t adt7316_store_DAC(struct adt7316_chip=
_info *chip,
 		return -EINVAL;
=20
 	if (chip->dac_bits > 8) {
-		lsb =3D data & (1 << offset);
+		lsb =3D data & ((1 << offset) - 1);
+		if (chip->dac_bits =3D=3D 12)
+			lsb_reg =3D lsb << ADT7316_DA_12_BIT_LSB_SHIFT;
+		else
+			lsb_reg =3D lsb << ADT7316_DA_10_BIT_LSB_SHIFT;
 		ret =3D chip->bus.write(chip->bus.client,
-			ADT7316_DA_DATA_BASE + channel * 2, lsb);
+			ADT7316_DA_DATA_BASE + channel * 2, lsb_reg);
 		if (ret)
 			return -EIO;
 	}
@@ -2129,8 +2133,15 @@ int adt7316_probe(struct device *dev, struct adt7316=
_bus *bus,
 	else
 		return -ENODEV;
=20
+	if (chip->id =3D=3D ID_ADT7316 || chip->id =3D=3D ID_ADT7516)
+		chip->dac_bits =3D 12;
+	else if (chip->id =3D=3D ID_ADT7317 || chip->id =3D=3D ID_ADT7517)
+		chip->dac_bits =3D 10;
+	else
+		chip->dac_bits =3D 8;
+
 	chip->ldac_pin =3D adt7316_platform_data[1];
-	if (chip->ldac_pin) {
+	if (!chip->ldac_pin) {
 		chip->config3 |=3D ADT7316_DA_EN_VIA_DAC_LDCA;
 		if ((chip->id & ID_FAMILY_MASK) =3D=3D ID_ADT75XX)
 			chip->config1 |=3D ADT7516_SEL_AIN3;
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index f7eab402cd4f..5322dde70448 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4201,9 +4201,9 @@ static void iscsit_release_commands_from_conn(struct =
iscsi_conn *conn)
 		struct se_cmd *se_cmd =3D &cmd->se_cmd;
=20
 		if (se_cmd->se_tfo !=3D NULL) {
-			spin_lock(&se_cmd->t_state_lock);
+			spin_lock_irq(&se_cmd->t_state_lock);
 			se_cmd->transport_state |=3D CMD_T_FABRIC_STOP;
-			spin_unlock(&se_cmd->t_state_lock);
+			spin_unlock_irq(&se_cmd->t_state_lock);
 		}
 	}
 	spin_unlock_bh(&conn->cmd_lock);
diff --git a/drivers/tty/ipwireless/hardware.c b/drivers/tty/ipwireless/har=
dware.c
index 2c14842541dd..9d15fb5b038b 100644
--- a/drivers/tty/ipwireless/hardware.c
+++ b/drivers/tty/ipwireless/hardware.c
@@ -1515,6 +1515,8 @@ static void ipw_send_setup_packet(struct ipw_hardware=
 *hw)
 			sizeof(struct ipw_setup_get_version_query_packet),
 			ADDR_SETUP_PROT, TL_PROTOCOLID_SETUP,
 			TL_SETUP_SIGNO_GET_VERSION_QRY);
+	if (!ver_packet)
+		return;
 	ver_packet->header.length =3D sizeof(struct tl_setup_get_version_qry);
=20
 	/*
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8=
250_pci.c
index 6ad273e68005..c8f6b57da60a 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2183,6 +2183,111 @@ static struct pci_serial_quirk pci_serial_quirks[] =
__refdata =3D {
 		.setup		=3D pci_default_setup,
 		.exit		=3D pci_plx9050_exit,
 	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_PCIE_COM_4SDB,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_MPCIE_COM_4S,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_PCIE_COM232_4DB,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_MPCIE_COM232_4,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_PCIE_COM_4SMDB,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_MPCIE_COM_4SM,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_MPCIE_ICM422_4,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_MPCIE_ICM485_4,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4S,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_PCIE_ICM232_4,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_MPCIE_ICM232_4,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_PCIE_COM422_4,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_PCIE_COM485_4,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_PCIE_COM232_4,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_PCIE_COM_4SM,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
+	{
+		.vendor     =3D PCI_VENDOR_ID_ACCESIO,
+		.device     =3D PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4SM,
+		.subvendor  =3D PCI_ANY_ID,
+		.subdevice  =3D PCI_ANY_ID,
+		.setup      =3D pci_pericom_setup,
+	},
 	/*
 	 * SBS Technologies, Inc., PMC-OCTALPRO 232
 	 */
@@ -4943,10 +5048,10 @@ static struct pci_device_id serial_pci_tbl[] =3D {
 	 */
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM_2SDB,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_MPCIE_COM_2S,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM_4SDB,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_pericom_PI7C9X7954 },
@@ -4955,10 +5060,10 @@ static struct pci_device_id serial_pci_tbl[] =3D {
 		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM232_2DB,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_MPCIE_COM232_2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM232_4DB,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_pericom_PI7C9X7954 },
@@ -4967,10 +5072,10 @@ static struct pci_device_id serial_pci_tbl[] =3D {
 		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM_2SMDB,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_MPCIE_COM_2SM,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM_4SMDB,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_pericom_PI7C9X7954 },
@@ -4979,13 +5084,13 @@ static struct pci_device_id serial_pci_tbl[] =3D {
 		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_MPCIE_ICM485_1,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7951 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_MPCIE_ICM422_2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_MPCIE_ICM485_2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_MPCIE_ICM422_4,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_pericom_PI7C9X7954 },
@@ -4994,16 +5099,16 @@ static struct pci_device_id serial_pci_tbl[] =3D {
 		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_ICM_2S,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4S,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_ICM232_2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_MPCIE_ICM232_2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_ICM232_4,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_pericom_PI7C9X7954 },
@@ -5012,13 +5117,13 @@ static struct pci_device_id serial_pci_tbl[] =3D {
 		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_ICM_2SM,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7954 },
+		pbn_pericom_PI7C9X7952 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM422_4,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7958 },
+		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM485_4,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7958 },
+		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM422_8,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_pericom_PI7C9X7958 },
@@ -5027,19 +5132,19 @@ static struct pci_device_id serial_pci_tbl[] =3D {
 		pbn_pericom_PI7C9X7958 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM232_4,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7958 },
+		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM232_8,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_pericom_PI7C9X7958 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM_4SM,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7958 },
+		pbn_pericom_PI7C9X7954 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_COM_8SM,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_pericom_PI7C9X7958 },
 	{	PCI_VENDOR_ID_ACCESIO, PCI_DEVICE_ID_ACCESIO_PCIE_ICM_4SM,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_pericom_PI7C9X7958 },
+		pbn_pericom_PI7C9X7954 },
 	/*
 	 * Topic TP560 Data/Fax/Voice 56k modem (reported by Evan Clarke)
 	 */
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.=
c
index 3197872f307b..0052e4fe09a8 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -93,6 +93,10 @@ static int of_platform_serial_setup(struct platform_devi=
ce *ofdev,
 	if (of_property_read_u32(np, "reg-offset", &prop) =3D=3D 0)
 		port->mapbase +=3D prop;
=20
+	/* Compatibility with the deprecated pxa driver and 8250_pxa drivers. */
+	if (of_device_is_compatible(np, "mrvl,mmp-uart"))
+		port->regshift =3D 2;
+
 	/* Check for registers offset within the devices address range */
 	if (of_property_read_u32(np, "reg-shift", &prop) =3D=3D 0)
 		port->regshift =3D prop;
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index a81f9dd7ee97..cd53568e6e3f 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -1089,7 +1089,7 @@ static int wdm_post_reset(struct usb_interface *intf)
 	rv =3D recover_from_urb_loss(desc);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
-	return 0;
+	return rv;
 }
=20
 static struct usb_driver wdm_driver =3D {
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 3fd36d115f3a..b60dac48587c 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -57,6 +57,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartca=
rd reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC D=
evice */
 	{ USB_DEVICE(0x0908, 0x01FF) }, /* Siemens RUGGEDCOM USB Serial Console *=
/
+	{ USB_DEVICE(0x0B00, 0x3070) }, /* Ingenico 3070 */
 	{ USB_DEVICE(0x0BED, 0x1100) }, /* MEI (TM) Cashflow-SC Bill/Voucher Acce=
ptor */
 	{ USB_DEVICE(0x0BED, 0x1101) }, /* MEI series 2000 Combo Acceptor */
 	{ USB_DEVICE(0x0FCF, 0x1003) }, /* Dynastream ANT development board */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d9d4175e01df..aa2bec8687fd 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1033,6 +1033,8 @@ static const struct usb_device_id id_table_combined[]=
 =3D {
 	{ USB_DEVICE(CYPRESS_VID, CYPRESS_WICED_BT_USB_PID) },
 	{ USB_DEVICE(CYPRESS_VID, CYPRESS_WICED_WL_USB_PID) },
 	{ USB_DEVICE(AIRBUS_DS_VID, AIRBUS_DS_P8GR) },
+	/* EZPrototypes devices */
+	{ USB_DEVICE(EZPROTOTYPES_VID, HJELMSLUND_USB485_ISO_PID) },
 	{ }					/* Terminating entry */
 };
=20
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index 69db398b352e..ecc2424eb8e0 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1307,6 +1307,12 @@
 #define IONICS_VID			0x1c0c
 #define IONICS_PLUGCOMPUTER_PID		0x0102
=20
+/*
+ * EZPrototypes (PID reseller)
+ */
+#define EZPROTOTYPES_VID		0x1c40
+#define HJELMSLUND_USB485_ISO_PID	0x0477
+
 /*
  * Dresden Elektronik Sensor Terminal Board
  */
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index cc6513a176b0..3a69af6f0718 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -47,7 +47,7 @@ static int vcpu_online(unsigned int cpu)
 }
 static void vcpu_hotplug(unsigned int cpu)
 {
-	if (!cpu_possible(cpu))
+	if (cpu >=3D nr_cpu_ids || !cpu_possible(cpu))
 		return;
=20
 	switch (vcpu_online(cpu)) {
diff --git a/drivers/xen/xenbus/xenbus_dev_frontend.c b/drivers/xen/xenbus/=
xenbus_dev_frontend.c
index 6bd06f9d737d..3126bcafb555 100644
--- a/drivers/xen/xenbus/xenbus_dev_frontend.c
+++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
@@ -533,7 +533,7 @@ static int xenbus_file_open(struct inode *inode, struct=
 file *filp)
 	if (xen_store_evtchn =3D=3D 0)
 		return -ENOENT;
=20
-	nonseekable_open(inode, filp);
+	stream_open(inode, filp);
=20
 	u =3D kzalloc(sizeof(*u), GFP_KERNEL);
 	if (u =3D=3D NULL)
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index b83ebfbf3fdc..92e67bc5b211 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -40,6 +40,9 @@
  */
 #define P9_LOCK_TIMEOUT (30*HZ)
=20
+/* flags for v9fs_stat2inode() & v9fs_stat2inode_dotl() */
+#define V9FS_STAT2INODE_KEEP_ISIZE 1
+
 extern struct file_system_type v9fs_fs_type;
 extern const struct address_space_operations v9fs_addr_operations;
 extern const struct file_operations v9fs_file_operations;
@@ -61,8 +64,10 @@ int v9fs_init_inode(struct v9fs_session_info *v9ses,
 		    struct inode *inode, umode_t mode, dev_t);
 void v9fs_evict_inode(struct inode *inode);
 ino_t v9fs_qid2ino(struct p9_qid *qid);
-void v9fs_stat2inode(struct p9_wstat *, struct inode *, struct super_block=
 *);
-void v9fs_stat2inode_dotl(struct p9_stat_dotl *, struct inode *);
+void v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
+		      struct super_block *sb, unsigned int flags);
+void v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode,
+			   unsigned int flags);
 int v9fs_dir_release(struct inode *inode, struct file *filp);
 int v9fs_file_open(struct inode *inode, struct file *file);
 void v9fs_inode2stat(struct inode *inode, struct p9_wstat *stat);
@@ -87,4 +92,18 @@ static inline void v9fs_invalidate_inode_attr(struct ino=
de *inode)
 }
=20
 int v9fs_open_to_dotl_flags(int flags);
+
+static inline void v9fs_i_size_write(struct inode *inode, loff_t i_size)
+{
+	/*
+	 * 32-bit need the lock, concurrent updates could break the
+	 * sequences and make i_size_read() loop forever.
+	 * 64-bit updates are atomic and can skip the locking.
+	 */
+	if (sizeof(i_size) > sizeof(long))
+		spin_lock(&inode->i_lock);
+	i_size_write(inode, i_size);
+	if (sizeof(i_size) > sizeof(long))
+		spin_unlock(&inode->i_lock);
+}
 #endif
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 92580bd45474..71c895bb2a60 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -484,7 +484,11 @@ v9fs_file_write_internal(struct inode *inode, struct p=
9_fid *fid,
 		i_size =3D i_size_read(inode);
 		if (*offset > i_size) {
 			inode_add_bytes(inode, *offset - i_size);
-			i_size_write(inode, *offset);
+			/*
+			 * Need to serialize against i_size_write() in
+			 * v9fs_stat2inode()
+			 */
+			v9fs_i_size_write(inode, *offset);
 		}
 	}
 	if (n < 0)
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e1f366fa59a2..7a9a71d487bd 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -538,7 +538,7 @@ static struct inode *v9fs_qid_iget(struct super_block *=
sb,
 	if (retval)
 		goto error;
=20
-	v9fs_stat2inode(st, inode, sb);
+	v9fs_stat2inode(st, inode, sb, 0);
 	v9fs_cache_inode_get_cookie(inode);
 	unlock_new_inode(inode);
 	return inode;
@@ -1074,7 +1074,7 @@ v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry =
*dentry,
 	if (IS_ERR(st))
 		return PTR_ERR(st);
=20
-	v9fs_stat2inode(st, dentry->d_inode, dentry->d_inode->i_sb);
+	v9fs_stat2inode(st, dentry->d_inode, dentry->d_inode->i_sb, 0);
 	generic_fillattr(dentry->d_inode, stat);
=20
 	p9stat_free(st);
@@ -1152,12 +1152,13 @@ static int v9fs_vfs_setattr(struct dentry *dentry, =
struct iattr *iattr)
  * @stat: Plan 9 metadata (mistat) structure
  * @inode: inode to populate
  * @sb: superblock of filesystem
+ * @flags: control flags (e.g. V9FS_STAT2INODE_KEEP_ISIZE)
  *
  */
=20
 void
 v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
-	struct super_block *sb)
+		 struct super_block *sb, unsigned int flags)
 {
 	umode_t mode;
 	char ext[32];
@@ -1198,10 +1199,11 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode=
 *inode,
 	mode =3D p9mode2perm(v9ses, stat);
 	mode |=3D inode->i_mode & ~S_IALLUGO;
 	inode->i_mode =3D mode;
-	i_size_write(inode, stat->length);
=20
+	if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE))
+		v9fs_i_size_write(inode, stat->length);
 	/* not real number of blocks, but 512 byte ones ... */
-	inode->i_blocks =3D (i_size_read(inode) + 512 - 1) >> 9;
+	inode->i_blocks =3D (stat->length + 512 - 1) >> 9;
 	v9inode->cache_validity &=3D ~V9FS_INO_INVALID_ATTR;
 }
=20
@@ -1465,9 +1467,9 @@ int v9fs_refresh_inode(struct p9_fid *fid, struct ino=
de *inode)
 {
 	int umode;
 	dev_t rdev;
-	loff_t i_size;
 	struct p9_wstat *st;
 	struct v9fs_session_info *v9ses;
+	unsigned int flags;
=20
 	v9ses =3D v9fs_inode2v9ses(inode);
 	st =3D p9_client_stat(fid);
@@ -1480,16 +1482,13 @@ int v9fs_refresh_inode(struct p9_fid *fid, struct i=
node *inode)
 	if ((inode->i_mode & S_IFMT) !=3D (umode & S_IFMT))
 		goto out;
=20
-	spin_lock(&inode->i_lock);
 	/*
 	 * We don't want to refresh inode->i_size,
 	 * because we may have cached data
 	 */
-	i_size =3D inode->i_size;
-	v9fs_stat2inode(st, inode, inode->i_sb);
-	if (v9ses->cache =3D=3D CACHE_LOOSE || v9ses->cache =3D=3D CACHE_FSCACHE)
-		inode->i_size =3D i_size;
-	spin_unlock(&inode->i_lock);
+	flags =3D (v9ses->cache =3D=3D CACHE_LOOSE || v9ses->cache =3D=3D CACHE_F=
SCACHE) ?
+		V9FS_STAT2INODE_KEEP_ISIZE : 0;
+	v9fs_stat2inode(st, inode, inode->i_sb, flags);
 out:
 	p9stat_free(st);
 	kfree(st);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 84b611ff4b65..357fa24e35ef 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -143,7 +143,7 @@ static struct inode *v9fs_qid_iget_dotl(struct super_bl=
ock *sb,
 	if (retval)
 		goto error;
=20
-	v9fs_stat2inode_dotl(st, inode);
+	v9fs_stat2inode_dotl(st, inode, 0);
 	v9fs_cache_inode_get_cookie(inode);
 	retval =3D v9fs_get_acl(inode, fid);
 	if (retval)
@@ -498,7 +498,7 @@ v9fs_vfs_getattr_dotl(struct vfsmount *mnt, struct dent=
ry *dentry,
 	if (IS_ERR(st))
 		return PTR_ERR(st);
=20
-	v9fs_stat2inode_dotl(st, dentry->d_inode);
+	v9fs_stat2inode_dotl(st, dentry->d_inode, 0);
 	generic_fillattr(dentry->d_inode, stat);
 	/* Change block size to what the server returned */
 	stat->blksize =3D st->st_blksize;
@@ -609,11 +609,13 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, stru=
ct iattr *iattr)
  * v9fs_stat2inode_dotl - populate an inode structure with stat info
  * @stat: stat structure
  * @inode: inode to populate
+ * @flags: ctrl flags (e.g. V9FS_STAT2INODE_KEEP_ISIZE)
  *
  */
=20
 void
-v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
+v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode,
+		      unsigned int flags)
 {
 	umode_t mode;
 	struct v9fs_inode *v9inode =3D V9FS_I(inode);
@@ -633,7 +635,8 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct =
inode *inode)
 		mode |=3D inode->i_mode & ~S_IALLUGO;
 		inode->i_mode =3D mode;
=20
-		i_size_write(inode, stat->st_size);
+		if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE))
+			v9fs_i_size_write(inode, stat->st_size);
 		inode->i_blocks =3D stat->st_blocks;
 	} else {
 		if (stat->st_result_mask & P9_STATS_ATIME) {
@@ -663,8 +666,9 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct =
inode *inode)
 		}
 		if (stat->st_result_mask & P9_STATS_RDEV)
 			inode->i_rdev =3D new_decode_dev(stat->st_rdev);
-		if (stat->st_result_mask & P9_STATS_SIZE)
-			i_size_write(inode, stat->st_size);
+		if (!(flags & V9FS_STAT2INODE_KEEP_ISIZE) &&
+		    stat->st_result_mask & P9_STATS_SIZE)
+			v9fs_i_size_write(inode, stat->st_size);
 		if (stat->st_result_mask & P9_STATS_BLOCKS)
 			inode->i_blocks =3D stat->st_blocks;
 	}
@@ -946,9 +950,9 @@ v9fs_vfs_follow_link_dotl(struct dentry *dentry, struct=
 nameidata *nd)
=20
 int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode)
 {
-	loff_t i_size;
 	struct p9_stat_dotl *st;
 	struct v9fs_session_info *v9ses;
+	unsigned int flags;
=20
 	v9ses =3D v9fs_inode2v9ses(inode);
 	st =3D p9_client_getattr_dotl(fid, P9_STATS_ALL);
@@ -960,16 +964,13 @@ int v9fs_refresh_inode_dotl(struct p9_fid *fid, struc=
t inode *inode)
 	if ((inode->i_mode & S_IFMT) !=3D (st->st_mode & S_IFMT))
 		goto out;
=20
-	spin_lock(&inode->i_lock);
 	/*
 	 * We don't want to refresh inode->i_size,
 	 * because we may have cached data
 	 */
-	i_size =3D inode->i_size;
-	v9fs_stat2inode_dotl(st, inode);
-	if (v9ses->cache =3D=3D CACHE_LOOSE || v9ses->cache =3D=3D CACHE_FSCACHE)
-		inode->i_size =3D i_size;
-	spin_unlock(&inode->i_lock);
+	flags =3D (v9ses->cache =3D=3D CACHE_LOOSE || v9ses->cache =3D=3D CACHE_F=
SCACHE) ?
+		V9FS_STAT2INODE_KEEP_ISIZE : 0;
+	v9fs_stat2inode_dotl(st, inode, flags);
 out:
 	kfree(st);
 	return 0;
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 0afd0382822b..975c3c1eb000 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -169,7 +169,7 @@ static struct dentry *v9fs_mount(struct file_system_typ=
e *fs_type, int flags,
 			goto release_sb;
 		}
 		root->d_inode->i_ino =3D v9fs_qid2ino(&st->qid);
-		v9fs_stat2inode_dotl(st, root->d_inode);
+		v9fs_stat2inode_dotl(st, root->d_inode, 0);
 		kfree(st);
 	} else {
 		struct p9_wstat *st =3D NULL;
@@ -180,7 +180,7 @@ static struct dentry *v9fs_mount(struct file_system_typ=
e *fs_type, int flags,
 		}
=20
 		root->d_inode->i_ino =3D v9fs_qid2ino(&st->qid);
-		v9fs_stat2inode(st, root->d_inode, sb);
+		v9fs_stat2inode(st, root->d_inode, sb, 0);
=20
 		p9stat_free(st);
 		kfree(st);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e987c0d56fd1..604d31e85c82 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2936,11 +2936,11 @@ static int __do_readpage(struct extent_io_tree *tre=
e,
 		 */
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) &&
 		    prev_em_start && *prev_em_start !=3D (u64)-1 &&
-		    *prev_em_start !=3D em->orig_start)
+		    *prev_em_start !=3D em->start)
 			force_bio_submit =3D true;
=20
 		if (prev_em_start)
-			*prev_em_start =3D em->orig_start;
+			*prev_em_start =3D em->start;
=20
 		free_extent_map(em);
 		em =3D NULL;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 8dddedcfa961..70edd60db654 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -417,6 +417,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *=
dev, int is_dev_replace)
 	sctx->pages_per_rd_bio =3D pages_per_rd_bio;
 	sctx->curr =3D -1;
 	sctx->dev_root =3D dev->dev_root;
+	INIT_LIST_HEAD(&sctx->csum_list);
 	for (i =3D 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
=20
@@ -444,7 +445,6 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *=
dev, int is_dev_replace)
 	atomic_set(&sctx->workers_pending, 0);
 	atomic_set(&sctx->cancel_req, 0);
 	sctx->csum_size =3D btrfs_super_csum_size(fs_info->super_copy);
-	INIT_LIST_HEAD(&sctx->csum_list);
=20
 	spin_lock_init(&sctx->list_lock);
 	spin_lock_init(&sctx->stat_lock);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 50c5e3955786..4b8870f889e3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2661,14 +2661,16 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_i=
ter *from)
 	 * these pages but not on the region from pos to ppos+len-1.
 	 */
 	written =3D cifs_user_writev(iocb, from);
-	if (written > 0 && CIFS_CACHE_READ(cinode)) {
+	if (CIFS_CACHE_READ(cinode)) {
 		/*
-		 * Windows 7 server can delay breaking level2 oplock if a write
-		 * request comes - break it on the client to prevent reading
-		 * an old data.
+		 * We have read level caching and we have just sent a write
+		 * request to the server thus making data in the cache stale.
+		 * Zap the cache and set oplock/lease level to NONE to avoid
+		 * reading stale data from the cache. All subsequent read
+		 * operations will read new data from the server.
 		 */
 		cifs_zap_mapping(inode);
-		cifs_dbg(FYI, "Set no oplock for inode=3D%p after a write operation\n",
+		cifs_dbg(FYI, "Set Oplock/Lease to NONE for inode=3D%p after write\n",
 			 inode);
 		cinode->oplock =3D 0;
 	}
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index ed976a94791c..1485ab8c2d65 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -420,7 +420,6 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2=
_lease_break *rsp,
 	__u8 lease_state;
 	struct list_head *tmp;
 	struct cifsFileInfo *cfile;
-	struct TCP_Server_Info *server =3D tcon->ses->server;
 	struct cifs_pending_open *open;
 	struct cifsInodeInfo *cinode;
 	int ack_req =3D le32_to_cpu(rsp->Flags &
@@ -440,13 +439,25 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct sm=
b2_lease_break *rsp,
 		cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
 			 le32_to_cpu(rsp->NewLeaseState));
=20
-		server->ops->set_oplock_level(cinode, lease_state, 0, NULL);
-
 		if (ack_req)
 			cfile->oplock_break_cancelled =3D false;
 		else
 			cfile->oplock_break_cancelled =3D true;
=20
+		set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
+
+		/*
+		 * Set or clear flags depending on the lease state being READ.
+		 * HANDLE caching flag should be added when the client starts
+		 * to defer closing remote file handles with HANDLE leases.
+		 */
+		if (lease_state & SMB2_LEASE_READ_CACHING_HE)
+			set_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
+				&cinode->flags);
+		else
+			clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
+				  &cinode->flags);
+
 		queue_work(cifsoplockd_wq, &cfile->oplock_break);
 		kfree(lw);
 		return true;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 46bea6c44ec8..376ccd96127f 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -961,6 +961,15 @@ smb2_downgrade_oplock(struct TCP_Server_Info *server,
 		server->ops->set_oplock_level(cinode, 0, 0, NULL);
 }
=20
+static void
+smb21_downgrade_oplock(struct TCP_Server_Info *server,
+		       struct cifsInodeInfo *cinode, bool set_level2)
+{
+	server->ops->set_oplock_level(cinode,
+				      set_level2 ? SMB2_LEASE_READ_CACHING_HE :
+				      0, 0, NULL);
+}
+
 static void
 smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 		      unsigned int epoch, bool *purge_cache)
@@ -1253,7 +1262,7 @@ struct smb_version_operations smb21_operations =3D {
 	.print_stats =3D smb2_print_stats,
 	.is_oplock_break =3D smb2_is_valid_oplock_break,
 	.handle_cancelled_mid =3D smb2_handle_cancelled_mid,
-	.downgrade_oplock =3D smb2_downgrade_oplock,
+	.downgrade_oplock =3D smb21_downgrade_oplock,
 	.need_neg =3D smb2_need_neg,
 	.negotiate =3D smb2_negotiate,
 	.negotiate_wsize =3D smb2_negotiate_wsize,
@@ -1331,7 +1340,7 @@ struct smb_version_operations smb30_operations =3D {
 	.dump_share_caps =3D smb2_dump_share_caps,
 	.is_oplock_break =3D smb2_is_valid_oplock_break,
 	.handle_cancelled_mid =3D smb2_handle_cancelled_mid,
-	.downgrade_oplock =3D smb2_downgrade_oplock,
+	.downgrade_oplock =3D smb21_downgrade_oplock,
 	.need_neg =3D smb2_need_neg,
 	.negotiate =3D smb2_negotiate,
 	.negotiate_wsize =3D smb2_negotiate_wsize,
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 3750031cfa2f..ea8c31bb8bcd 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -701,7 +701,8 @@ static loff_t ext2_max_size(int bits)
 {
 	loff_t res =3D EXT2_NDIR_BLOCKS;
 	int meta_blocks;
-	loff_t upper_limit;
+	unsigned int upper_limit;
+	unsigned int ppb =3D 1 << (bits-2);
=20
 	/* This is calculated to be the largest file size for a
 	 * dense, file such that the total number of
@@ -715,24 +716,34 @@ static loff_t ext2_max_size(int bits)
 	/* total blocks in file system block size */
 	upper_limit >>=3D (bits - 9);
=20
+	/* Compute how many blocks we can address by block tree */
+	res +=3D 1LL << (bits-2);
+	res +=3D 1LL << (2*(bits-2));
+	res +=3D 1LL << (3*(bits-2));
+	/* Does block tree limit file size? */
+	if (res < upper_limit)
+		goto check_lfs;
=20
+	res =3D upper_limit;
+	/* How many metadata blocks are needed for addressing upper_limit? */
+	upper_limit -=3D EXT2_NDIR_BLOCKS;
 	/* indirect blocks */
 	meta_blocks =3D 1;
+	upper_limit -=3D ppb;
 	/* double indirect blocks */
-	meta_blocks +=3D 1 + (1LL << (bits-2));
-	/* tripple indirect blocks */
-	meta_blocks +=3D 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
-
-	upper_limit -=3D meta_blocks;
-	upper_limit <<=3D bits;
-
-	res +=3D 1LL << (bits-2);
-	res +=3D 1LL << (2*(bits-2));
-	res +=3D 1LL << (3*(bits-2));
+	if (upper_limit < ppb * ppb) {
+		meta_blocks +=3D 1 + DIV_ROUND_UP(upper_limit, ppb);
+		res -=3D meta_blocks;
+		goto check_lfs;
+	}
+	meta_blocks +=3D 1 + ppb;
+	upper_limit -=3D ppb * ppb;
+	/* tripple indirect blocks for the rest */
+	meta_blocks +=3D 1 + DIV_ROUND_UP(upper_limit, ppb) +
+		DIV_ROUND_UP(upper_limit, ppb*ppb);
+	res -=3D meta_blocks;
+check_lfs:
 	res <<=3D bits;
-	if (res > upper_limit)
-		res =3D upper_limit;
-
 	if (res > MAX_LFS_FILESIZE)
 		res =3D MAX_LFS_FILESIZE;
=20
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index aa2da07ee7fb..550a1bfe98d1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -405,6 +405,9 @@ struct flex_groups {
 /* Flags that are appropriate for non-directories/regular files. */
 #define EXT4_OTHER_FLMASK (EXT4_NODUMP_FL | EXT4_NOATIME_FL)
=20
+/* The only flags that should be swapped */
+#define EXT4_FL_SHOULD_SWAP (EXT4_HUGE_FILE_FL | EXT4_EXTENTS_FL)
+
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
 {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a77035ec6a4d..99bfe22f2a71 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -14,6 +14,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/file.h>
+#include <linux/quotaops.h>
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
@@ -60,20 +61,21 @@ static void swap_inode_data(struct inode *inode1, struc=
t inode *inode2)
 	loff_t isize;
 	struct ext4_inode_info *ei1;
 	struct ext4_inode_info *ei2;
+	unsigned long tmp;
=20
 	ei1 =3D EXT4_I(inode1);
 	ei2 =3D EXT4_I(inode2);
=20
 	memswap(&inode1->i_version, &inode2->i_version,
 		  sizeof(inode1->i_version));
-	memswap(&inode1->i_blocks, &inode2->i_blocks,
-		  sizeof(inode1->i_blocks));
-	memswap(&inode1->i_bytes, &inode2->i_bytes, sizeof(inode1->i_bytes));
 	memswap(&inode1->i_atime, &inode2->i_atime, sizeof(inode1->i_atime));
 	memswap(&inode1->i_mtime, &inode2->i_mtime, sizeof(inode1->i_mtime));
=20
 	memswap(ei1->i_data, ei2->i_data, sizeof(ei1->i_data));
-	memswap(&ei1->i_flags, &ei2->i_flags, sizeof(ei1->i_flags));
+	tmp =3D ei1->i_flags & EXT4_FL_SHOULD_SWAP;
+	ei1->i_flags =3D (ei2->i_flags & EXT4_FL_SHOULD_SWAP) |
+		(ei1->i_flags & ~EXT4_FL_SHOULD_SWAP);
+	ei2->i_flags =3D tmp | (ei2->i_flags & ~EXT4_FL_SHOULD_SWAP);
 	memswap(&ei1->i_disksize, &ei2->i_disksize, sizeof(ei1->i_disksize));
 	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
 	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);
@@ -117,15 +119,9 @@ static long swap_inode_boot_loader(struct super_block =
*sb,
 	struct inode *inode_bl;
 	struct ext4_inode_info *ei_bl;
 	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
-
-	if (inode->i_nlink !=3D 1 || !S_ISREG(inode->i_mode) ||
-	    IS_SWAPFILE(inode) ||
-	    ext4_has_inline_data(inode))
-		return -EINVAL;
-
-	if (IS_RDONLY(inode) || IS_APPEND(inode) || IS_IMMUTABLE(inode) ||
-	    !inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	qsize_t size, size_bl, diff;
+	blkcnt_t blocks;
+	unsigned short bytes;
=20
 	inode_bl =3D ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
 	if (IS_ERR(inode_bl))
@@ -139,6 +135,19 @@ static long swap_inode_boot_loader(struct super_block =
*sb,
 	 * that only 1 swap_inode_boot_loader is running. */
 	lock_two_nondirectories(inode, inode_bl);
=20
+	if (inode->i_nlink !=3D 1 || !S_ISREG(inode->i_mode) ||
+	    IS_SWAPFILE(inode) ||
+	    ext4_has_inline_data(inode)) {
+		err =3D -EINVAL;
+		goto journal_err_out;
+	}
+
+	if (IS_RDONLY(inode) || IS_APPEND(inode) || IS_IMMUTABLE(inode) ||
+	    !inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN)) {
+		err =3D -EPERM;
+		goto journal_err_out;
+	}
+
 	/* Wait for all existing dio workers */
 	ext4_inode_block_unlocked_dio(inode);
 	ext4_inode_block_unlocked_dio(inode_bl);
@@ -175,6 +184,11 @@ static long swap_inode_boot_loader(struct super_block =
*sb,
 			memset(ei_bl->i_data, 0, sizeof(ei_bl->i_data));
 	}
=20
+	dquot_initialize(inode);
+
+	size =3D (qsize_t)(inode->i_blocks) * (1 << 9) + inode->i_bytes;
+	size_bl =3D (qsize_t)(inode_bl->i_blocks) * (1 << 9) + inode_bl->i_bytes;
+	diff =3D size - size_bl;
 	swap_inode_data(inode, inode_bl);
=20
 	inode->i_ctime =3D inode_bl->i_ctime =3D ext4_current_time(inode);
@@ -190,24 +204,46 @@ static long swap_inode_boot_loader(struct super_block=
 *sb,
=20
 	err =3D ext4_mark_inode_dirty(handle, inode);
 	if (err < 0) {
+		/* No need to update quota information. */
 		ext4_warning(inode->i_sb,
 			"couldn't mark inode #%lu dirty (err %d)",
 			inode->i_ino, err);
 		/* Revert all changes: */
 		swap_inode_data(inode, inode_bl);
 		ext4_mark_inode_dirty(handle, inode);
-	} else {
-		err =3D ext4_mark_inode_dirty(handle, inode_bl);
-		if (err < 0) {
-			ext4_warning(inode_bl->i_sb,
-				"couldn't mark inode #%lu dirty (err %d)",
-				inode_bl->i_ino, err);
-			/* Revert all changes: */
-			swap_inode_data(inode, inode_bl);
-			ext4_mark_inode_dirty(handle, inode);
-			ext4_mark_inode_dirty(handle, inode_bl);
-		}
+		goto err_out1;
+	}
+
+	blocks =3D inode_bl->i_blocks;
+	bytes =3D inode_bl->i_bytes;
+	inode_bl->i_blocks =3D inode->i_blocks;
+	inode_bl->i_bytes =3D inode->i_bytes;
+	err =3D ext4_mark_inode_dirty(handle, inode_bl);
+	if (err < 0) {
+		/* No need to update quota information. */
+		ext4_warning(inode_bl->i_sb,
+			"couldn't mark inode #%lu dirty (err %d)",
+			inode_bl->i_ino, err);
+		goto revert;
 	}
+
+	/* Bootloader inode should not be counted into quota information. */
+	if (diff > 0)
+		dquot_free_space(inode, diff);
+	else
+		err =3D dquot_alloc_space(inode, -1 * diff);
+
+	if (err < 0) {
+revert:
+		/* Revert all changes: */
+		inode_bl->i_blocks =3D blocks;
+		inode_bl->i_bytes =3D bytes;
+		swap_inode_data(inode, inode_bl);
+		ext4_mark_inode_dirty(handle, inode);
+		ext4_mark_inode_dirty(handle, inode_bl);
+	}
+
+err_out1:
 	ext4_journal_stop(handle);
 	ext4_double_up_write_data_sem(inode, inode_bl);
=20
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index b9d35d52889c..80c3f1ed1afa 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1931,7 +1931,8 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk=
_t n_blocks_count)
 				le16_to_cpu(es->s_reserved_gdt_blocks);
 			n_group =3D n_desc_blocks * EXT4_DESC_PER_BLOCK(sb);
 			n_blocks_count =3D (ext4_fsblk_t)n_group *
-				EXT4_BLOCKS_PER_GROUP(sb);
+				EXT4_BLOCKS_PER_GROUP(sb) +
+				le32_to_cpu(es->s_first_data_block);
 			n_group--; /* set to last group number */
 		}
=20
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bc8f5de48fd9..69e471b042a6 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -214,7 +214,9 @@ void fuse_finish_open(struct inode *inode, struct file =
*file)
 		file->f_op =3D &fuse_direct_io_file_operations;
 	if (!(ff->open_flags & FOPEN_KEEP_CACHE))
 		invalidate_inode_pages2(inode->i_mapping);
-	if (ff->open_flags & FOPEN_NONSEEKABLE)
+	if (ff->open_flags & FOPEN_STREAM)
+		stream_open(inode, file);
+	else if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
 	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
 		struct fuse_inode *fi =3D get_fuse_inode(inode);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 398565726b92..9e02c00cc223 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1479,14 +1479,21 @@ int jbd2_journal_forget (handle_t *handle, struct b=
uffer_head *bh)
 		/* However, if the buffer is still owned by a prior
 		 * (committing) transaction, we can't drop it yet... */
 		JBUFFER_TRACE(jh, "belongs to older transaction");
-		/* ... but we CAN drop it from the new transaction if we
-		 * have also modified it since the original commit. */
+		/* ... but we CAN drop it from the new transaction through
+		 * marking the buffer as freed and set j_next_transaction to
+		 * the new transaction, so that not only the commit code
+		 * knows it should clear dirty bits when it is done with the
+		 * buffer, but also the buffer can be checkpointed only
+		 * after the new transaction commits. */
=20
-		if (jh->b_next_transaction) {
-			J_ASSERT(jh->b_next_transaction =3D=3D transaction);
+		set_buffer_freed(bh);
+
+		if (!jh->b_next_transaction) {
 			spin_lock(&journal->j_list_lock);
-			jh->b_next_transaction =3D NULL;
+			jh->b_next_transaction =3D transaction;
 			spin_unlock(&journal->j_list_lock);
+		} else {
+			J_ASSERT(jh->b_next_transaction =3D=3D transaction);
=20
 			/*
 			 * only drop a reference if this transaction modified
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7f9b6f799aa2..c5168c77479a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -694,6 +694,13 @@ static int nfs4_sequence_done(struct rpc_task *task,
 	return nfs41_sequence_done(task, res);
 }
=20
+static void nfs41_sequence_res_init(struct nfs4_sequence_res *res)
+{
+	res->sr_timestamp =3D jiffies;
+	res->sr_status_flags =3D 0;
+	res->sr_status =3D 1;
+}
+
 int nfs41_setup_sequence(struct nfs4_session *session,
 				struct nfs4_sequence_args *args,
 				struct nfs4_sequence_res *res,
@@ -735,15 +742,9 @@ int nfs41_setup_sequence(struct nfs4_session *session,
 			slot->slot_nr, slot->seq_nr);
=20
 	res->sr_slot =3D slot;
-	res->sr_timestamp =3D jiffies;
-	res->sr_status_flags =3D 0;
-	/*
-	 * sr_status is only set in decode_sequence, and so will remain
-	 * set to 1 if an rpc level failure occurs.
-	 */
-	res->sr_status =3D 1;
 	trace_nfs4_setup_sequence(session, args);
 out_success:
+	nfs41_sequence_res_init(res);
 	rpc_call_start(task);
 	return 0;
 out_sleep:
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 29ec54a58361..f941584a8111 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1893,7 +1893,7 @@ static int nfs_parse_devname(const char *dev_name,
 		/* kill possible hostname list: not supported */
 		comma =3D strchr(dev_name, ',');
 		if (comma !=3D NULL && comma < end)
-			*comma =3D 0;
+			len =3D comma - dev_name;
 	}
=20
 	if (len > maxnamlen)
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 401289913130..207d112b984b 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -440,8 +440,19 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp, struct nfsd=
3_readdirargs *argp,
 					&resp->common, nfs3svc_encode_entry);
 	memcpy(resp->verf, argp->verf, 8);
 	resp->count =3D resp->buffer - argp->buffer;
-	if (resp->offset)
-		xdr_encode_hyper(resp->offset, argp->cookie);
+	if (resp->offset) {
+		loff_t offset =3D argp->cookie;
+
+		if (unlikely(resp->offset1)) {
+			/* we ended up with offset on a page boundary */
+			*resp->offset =3D htonl(offset >> 32);
+			*resp->offset1 =3D htonl(offset & 0xffffffff);
+			resp->offset1 =3D NULL;
+		} else {
+			xdr_encode_hyper(resp->offset, offset);
+		}
+		resp->offset =3D NULL;
+	}
=20
 	RETURN_STATUS(nfserr);
 }
@@ -501,6 +512,7 @@ nfsd3_proc_readdirplus(struct svc_rqst *rqstp, struct n=
fsd3_readdirargs *argp,
 		} else {
 			xdr_encode_hyper(resp->offset, offset);
 		}
+		resp->offset =3D NULL;
 	}
=20
 	RETURN_STATUS(nfserr);
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index d9fa85ebc8ac..68d7b7a0e2a3 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -909,6 +909,7 @@ encode_entry(struct readdir_cd *ccd, const char *name, =
int namlen,
 		} else {
 			xdr_encode_hyper(cd->offset, offset64);
 		}
+		cd->offset =3D NULL;
 	}
=20
 	/*
diff --git a/fs/open.c b/fs/open.c
index fc44237e4a2e..c4949a39726a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1104,3 +1104,21 @@ int nonseekable_open(struct inode *inode, struct fil=
e *filp)
 }
=20
 EXPORT_SYMBOL(nonseekable_open);
+
+/*
+ * stream_open is used by subsystems that want stream-like file descriptor=
s.
+ * Such file descriptors are not seekable and don't have notion of positio=
n
+ * (file.f_pos is always 0). Contrary to file descriptors of other regular
+ * files, .read() and .write() can run simultaneously.
+ *
+ * stream_open never fails and is marked to return int so that it could be
+ * directly used as file_operations.open .
+ */
+int stream_open(struct inode *inode, struct file *filp)
+{
+	filp->f_mode &=3D ~(FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE | FMODE_ATOM=
IC_POS);
+	filp->f_mode |=3D FMODE_STREAM;
+	return 0;
+}
+
+EXPORT_SYMBOL(stream_open);
diff --git a/fs/pipe.c b/fs/pipe.c
index 4de213b5854f..f723b5e99917 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -219,6 +219,14 @@ static const struct pipe_buf_operations anon_pipe_buf_=
ops =3D {
 	.get =3D generic_pipe_buf_get,
 };
=20
+static const struct pipe_buf_operations anon_pipe_buf_nomerge_ops =3D {
+	.can_merge =3D 0,
+	.confirm =3D generic_pipe_buf_confirm,
+	.release =3D anon_pipe_buf_release,
+	.steal =3D generic_pipe_buf_steal,
+	.get =3D generic_pipe_buf_get,
+};
+
 static const struct pipe_buf_operations packet_pipe_buf_ops =3D {
 	.can_merge =3D 0,
 	.confirm =3D generic_pipe_buf_confirm,
@@ -227,6 +235,12 @@ static const struct pipe_buf_operations packet_pipe_bu=
f_ops =3D {
 	.get =3D generic_pipe_buf_get,
 };
=20
+void pipe_buf_mark_unmergeable(struct pipe_buffer *buf)
+{
+	if (buf->ops =3D=3D &anon_pipe_buf_ops)
+		buf->ops =3D &anon_pipe_buf_nomerge_ops;
+}
+
 static ssize_t
 pipe_read(struct kiocb *iocb, struct iov_iter *to)
 {
diff --git a/fs/read_write.c b/fs/read_write.c
index 07053752c148..c3b99ff5da0d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -549,12 +549,13 @@ EXPORT_SYMBOL(vfs_write);
=20
 static inline loff_t file_pos_read(struct file *file)
 {
-	return file->f_pos;
+	return file->f_mode & FMODE_STREAM ? 0 : file->f_pos;
 }
=20
 static inline void file_pos_write(struct file *file, loff_t pos)
 {
-	file->f_pos =3D pos;
+	if ((file->f_mode & FMODE_STREAM) =3D=3D 0)
+		file->f_pos =3D pos;
 }
=20
 SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
diff --git a/fs/splice.c b/fs/splice.c
index 41f10ce929dd..82577ca2ecf9 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1901,6 +1901,8 @@ static int splice_pipe_to_pipe(struct pipe_inode_info=
 *ipipe,
 			 */
 			obuf->flags &=3D ~PIPE_BUF_FLAG_GIFT;
=20
+			pipe_buf_mark_unmergeable(obuf);
+
 			obuf->len =3D len;
 			opipe->nrbufs++;
 			ibuf->offset +=3D obuf->len;
@@ -1975,6 +1977,8 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 		 */
 		obuf->flags &=3D ~PIPE_BUF_FLAG_GIFT;
=20
+		pipe_buf_mark_unmergeable(obuf);
+
 		if (obuf->len > len)
 			obuf->len =3D len;
=20
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 461e82373ebd..49ca7649e5b5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -133,6 +133,9 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t =
offset,
 /* Has write method(s) */
 #define FMODE_CAN_WRITE         ((__force fmode_t)0x40000)
=20
+/* File is stream-like */
+#define FMODE_STREAM		((__force fmode_t)0x200000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
=20
@@ -2472,6 +2475,7 @@ extern loff_t fixed_size_llseek(struct file *file, lo=
ff_t offset,
 		int whence, loff_t size);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
+extern int stream_open(struct inode * inode, struct file * filp);
=20
 #ifdef CONFIG_FS_XIP
 extern ssize_t xip_file_read(struct file *filp, char __user *buf, size_t l=
en,
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index eed87a0fdc5c..394fb4b71a8d 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -140,6 +140,7 @@ void generic_pipe_buf_get(struct pipe_inode_info *, str=
uct pipe_buffer *);
 int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer =
*);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *)=
;
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer=
 *);
+void pipe_buf_mark_unmergeable(struct pipe_buffer *buf);
=20
 extern const struct pipe_buf_operations nosteal_pipe_buf_ops;
=20
diff --git a/include/linux/swap.h b/include/linux/swap.h
index c28e936c8116..7f0a39d83b5d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -451,6 +451,7 @@ extern sector_t map_swap_page(struct page *, struct blo=
ck_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
 extern struct swap_info_struct *page_swap_info(struct page *);
+extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
diff --git a/include/net/gro_cells.h b/include/net/gro_cells.h
index 734d9b5f577a..4927c208ec5c 100644
--- a/include/net/gro_cells.h
+++ b/include/net/gro_cells.h
@@ -20,18 +20,23 @@ static inline void gro_cells_receive(struct gro_cells *=
gcells, struct sk_buff *s
 	struct gro_cell *cell =3D gcells->cells;
 	struct net_device *dev =3D skb->dev;
=20
+	rcu_read_lock();
+	if (unlikely(!(dev->flags & IFF_UP)))
+		goto drop;
+
 	if (!cell || skb_cloned(skb) || !(dev->features & NETIF_F_GRO)) {
 		netif_rx(skb);
-		return;
+		goto unlock;
 	}
=20
 	if (skb_rx_queue_recorded(skb))
 		cell +=3D skb_get_rx_queue(skb) & gcells->gro_cells_mask;
=20
 	if (skb_queue_len(&cell->napi_skbs) > netdev_max_backlog) {
+drop:
 		atomic_long_inc(&dev->rx_dropped);
 		kfree_skb(skb);
-		return;
+		goto unlock;
 	}
=20
 	/* We run in BH context */
@@ -42,6 +47,9 @@ static inline void gro_cells_receive(struct gro_cells *gc=
ells, struct sk_buff *s
 		napi_schedule(&cell->napi);
=20
 	spin_unlock(&cell->napi_skbs.lock);
+
+unlock:
+	rcu_read_unlock();
 }
=20
 /* called unser BH context */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index f772dab65474..b3358ba51504 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -54,6 +54,8 @@ struct net {
 #endif
 	spinlock_t		rules_mod_lock;
=20
+	u32			hash_mix;
+
 	struct list_head	list;		/* list of network namespaces */
 	struct list_head	cleanup_list;	/* namespaces on death row */
 	struct list_head	exit_list;	/* Use only net_mutex */
diff --git a/include/net/netns/hash.h b/include/net/netns/hash.h
index c06ac58ca107..a347b2f9e748 100644
--- a/include/net/netns/hash.h
+++ b/include/net/netns/hash.h
@@ -1,21 +1,10 @@
 #ifndef __NET_NS_HASH_H__
 #define __NET_NS_HASH_H__
=20
-#include <asm/cache.h>
+#include <net/net_namespace.h>
=20
-struct net;
-
-static inline unsigned int net_hash_mix(struct net *net)
+static inline u32 net_hash_mix(const struct net *net)
 {
-#ifdef CONFIG_NET_NS
-	/*
-	 * shift this right to eliminate bits, that are
-	 * always zeroed
-	 */
-
-	return (unsigned)(((unsigned long)net) >> L1_CACHE_SHIFT);
-#else
-	return 0;
-#endif
+	return net->hash_mix;
 }
 #endif
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 25084a052a1e..cff91b018953 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -205,10 +205,12 @@ struct fuse_file_lock {
  * FOPEN_DIRECT_IO: bypass page cache for this open file
  * FOPEN_KEEP_CACHE: don't invalidate the data cache on open
  * FOPEN_NONSEEKABLE: the file is not seekable
+ * FOPEN_STREAM: the file is stream-like (no file position at all)
  */
 #define FOPEN_DIRECT_IO		(1 << 0)
 #define FOPEN_KEEP_CACHE	(1 << 1)
 #define FOPEN_NONSEEKABLE	(1 << 2)
+#define FOPEN_STREAM		(1 << 4)
=20
 /**
  * INIT request/reply flags
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 627180d3bed4..608747155bda 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1384,15 +1384,23 @@ static int rcu_future_gp_cleanup(struct rcu_state *=
rsp, struct rcu_node *rnp)
 }
=20
 /*
- * Awaken the grace-period kthread for the specified flavor of RCU.
- * Don't do a self-awaken, and don't bother awakening when there is
- * nothing for the grace-period kthread to do (as in several CPUs
- * raced to awaken, and we lost), and finally don't try to awaken
- * a kthread that has not yet been created.
+ * Awaken the grace-period kthread.  Don't do a self-awaken (unless in
+ * an interrupt or softirq handler), and don't bother awakening when there
+ * is nothing for the grace-period kthread to do (as in several CPUs raced
+ * to awaken, and we lost), and finally don't try to awaken a kthread that
+ * has not yet been created.  If all those checks are passed, track some
+ * debug information and awaken.
+ *
+ * So why do the self-wakeup when in an interrupt or softirq handler
+ * in the grace-period kthread's context?  Because the kthread might have
+ * been interrupted just as it was going to sleep, and just after the fina=
l
+ * pre-sleep check of the awaken condition.  In this case, a wakeup really
+ * is required, and is therefore supplied.
  */
 static void rcu_gp_kthread_wake(struct rcu_state *rsp)
 {
-	if (current =3D=3D rsp->gp_kthread ||
+	if ((current =3D=3D rsp->gp_kthread &&
+	     !in_interrupt() && !in_serving_softirq()) ||
 	    !ACCESS_ONCE(rsp->gp_flags) ||
 	    !rsp->gp_kthread)
 		return;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e714622b6fa9..6f4e876162f5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2179,7 +2179,16 @@ static int do_proc_dointvec_minmax_conv(bool *negp, =
unsigned long *lvalp,
 {
 	struct do_proc_dointvec_minmax_conv_param *param =3D data;
 	if (write) {
-		int val =3D *negp ? -*lvalp : *lvalp;
+		int val;
+		if (*negp) {
+			if (*lvalp > (unsigned long) INT_MAX + 1)
+				return -EINVAL;
+			val =3D -*lvalp;
+		} else {
+			if (*lvalp > (unsigned long) INT_MAX)
+				return -EINVAL;
+			val =3D *lvalp;
+		}
 		if ((param->min && *param->min > val) ||
 		    (param->max && *param->max < val))
 			return -EINVAL;
diff --git a/lib/devres.c b/lib/devres.c
index eaa04de41e42..6fa604a28b04 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -109,7 +109,6 @@ EXPORT_SYMBOL(devm_iounmap);
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *r=
es)
 {
 	resource_size_t size;
-	const char *name;
 	void __iomem *dest_ptr;
=20
 	BUG_ON(!dev);
@@ -120,9 +119,8 @@ void __iomem *devm_ioremap_resource(struct device *dev,=
 struct resource *res)
 	}
=20
 	size =3D resource_size(res);
-	name =3D res->name ?: dev_name(dev);
=20
-	if (!devm_request_mem_region(dev, res->start, size, name)) {
+	if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
 		dev_err(dev, "can't request region for resource %pR\n", res);
 		return IOMEM_ERR_PTR(-EBUSY);
 	}
diff --git a/lib/div64.c b/lib/div64.c
index 4382ad77777e..ce76dc3d674e 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -100,7 +100,7 @@ u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remai=
nder)
 		quot =3D div_u64_rem(dividend, divisor, &rem32);
 		*remainder =3D rem32;
 	} else {
-		int n =3D 1 + fls(high);
+		int n =3D fls(high);
 		quot =3D div_u64(dividend >> n, divisor >> n);
=20
 		if (quot !=3D 0)
@@ -138,7 +138,7 @@ u64 div64_u64(u64 dividend, u64 divisor)
 	if (high =3D=3D 0) {
 		quot =3D div_u64(dividend, divisor);
 	} else {
-		int n =3D 1 + fls(high);
+		int n =3D fls(high);
 		quot =3D div_u64(dividend >> n, divisor >> n);
=20
 		if (quot !=3D 0)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5ee24d70eeca..1fc2d536e2df 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -86,6 +86,15 @@ static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
 /* Activity counter to indicate that a swapon or swapoff has occurred */
 static atomic_t proc_poll_event =3D ATOMIC_INIT(0);
=20
+static struct swap_info_struct *swap_type_to_swap_info(int type)
+{
+	if (type >=3D ACCESS_ONCE(nr_swapfiles))
+		return NULL;
+
+	smp_rmb();	/* Pairs with smp_wmb in alloc_swap_info. */
+	return ACCESS_ONCE(swap_info[type]);
+}
+
 static inline unsigned char swap_count(unsigned char ent)
 {
 	return ent & ~SWAP_HAS_CACHE;	/* may include COUNT_CONTINUED flag */
@@ -703,12 +712,14 @@ swp_entry_t get_swap_page(void)
 /* The only caller of this function is now suspend routine */
 swp_entry_t get_swap_page_of_type(int type)
 {
-	struct swap_info_struct *si;
+	struct swap_info_struct *si =3D swap_type_to_swap_info(type);
 	pgoff_t offset;
=20
-	si =3D swap_info[type];
+	if (!si)
+		goto fail;
+
 	spin_lock(&si->lock);
-	if (si && (si->flags & SWP_WRITEOK)) {
+	if (si->flags & SWP_WRITEOK) {
 		atomic_long_dec(&nr_swap_pages);
 		/* This is called for allocating swap entry, not cache */
 		offset =3D scan_swap_map(si, 1);
@@ -719,6 +730,7 @@ swp_entry_t get_swap_page_of_type(int type)
 		atomic_long_inc(&nr_swap_pages);
 	}
 	spin_unlock(&si->lock);
+fail:
 	return (swp_entry_t) {0};
 }
=20
@@ -730,9 +742,9 @@ static struct swap_info_struct *swap_info_get(swp_entry=
_t entry)
 	if (!entry.val)
 		goto out;
 	type =3D swp_type(entry);
-	if (type >=3D nr_swapfiles)
+	p =3D swap_type_to_swap_info(type);
+	if (!p)
 		goto bad_nofile;
-	p =3D swap_info[type];
 	if (!(p->flags & SWP_USED))
 		goto bad_device;
 	offset =3D swp_offset(entry);
@@ -1037,10 +1049,9 @@ int swap_type_of(dev_t device, sector_t offset, stru=
ct block_device **bdev_p)
 sector_t swapdev_block(int type, pgoff_t offset)
 {
 	struct block_device *bdev;
+	struct swap_info_struct *si =3D swap_type_to_swap_info(type);
=20
-	if ((unsigned int)type >=3D nr_swapfiles)
-		return 0;
-	if (!(swap_info[type]->flags & SWP_WRITEOK))
+	if (!si || !(si->flags & SWP_WRITEOK))
 		return 0;
 	return map_swap_entry(swp_entry(type, offset), &bdev);
 }
@@ -1584,7 +1595,7 @@ static sector_t map_swap_entry(swp_entry_t entry, str=
uct block_device **bdev)
 	struct swap_extent *se;
 	pgoff_t offset;
=20
-	sis =3D swap_info[swp_type(entry)];
+	sis =3D swp_swap_info(entry);
 	*bdev =3D sis->bdev;
=20
 	offset =3D swp_offset(entry);
@@ -1982,9 +1993,7 @@ static void *swap_start(struct seq_file *swap, loff_t=
 *pos)
 	if (!l)
 		return SEQ_START_TOKEN;
=20
-	for (type =3D 0; type < nr_swapfiles; type++) {
-		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
-		si =3D swap_info[type];
+	for (type =3D 0; (si =3D swap_type_to_swap_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		if (!--l)
@@ -2004,9 +2013,7 @@ static void *swap_next(struct seq_file *swap, void *v=
, loff_t *pos)
 	else
 		type =3D si->type + 1;
=20
-	for (; type < nr_swapfiles; type++) {
-		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
-		si =3D swap_info[type];
+	for (; (si =3D swap_type_to_swap_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		++*pos;
@@ -2111,14 +2118,14 @@ static struct swap_info_struct *alloc_swap_info(voi=
d)
 	}
 	if (type >=3D nr_swapfiles) {
 		p->type =3D type;
-		swap_info[type] =3D p;
+		ACCESS_ONCE(swap_info[type]) =3D p;
 		/*
 		 * Write swap_info[type] before nr_swapfiles, in case a
 		 * racing procfs swap_start() or swap_next() is reading them.
 		 * (We never shrink nr_swapfiles, we never free this entry.)
 		 */
 		smp_wmb();
-		nr_swapfiles++;
+		ACCESS_ONCE(nr_swapfiles) =3D nr_swapfiles + 1;
 	} else {
 		kfree(p);
 		p =3D swap_info[type];
@@ -2144,11 +2151,10 @@ static int claim_swapfile(struct swap_info_struct *=
p, struct inode *inode)
 	if (S_ISBLK(inode->i_mode)) {
 		p->bdev =3D bdgrab(I_BDEV(inode));
 		error =3D blkdev_get(p->bdev,
-				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-				   sys_swapon);
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL, p);
 		if (error < 0) {
 			p->bdev =3D NULL;
-			return -EINVAL;
+			return error;
 		}
 		p->old_block_size =3D block_size(p->bdev);
 		error =3D set_blocksize(p->bdev, PAGE_SIZE);
@@ -2365,7 +2371,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialf=
ile, int, swap_flags)
 	struct filename *name;
 	struct file *swap_file =3D NULL;
 	struct address_space *mapping;
-	int i;
 	int prio;
 	int error;
 	union swap_header *swap_header;
@@ -2405,19 +2410,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, special=
file, int, swap_flags)
=20
 	p->swap_file =3D swap_file;
 	mapping =3D swap_file->f_mapping;
-
-	for (i =3D 0; i < nr_swapfiles; i++) {
-		struct swap_info_struct *q =3D swap_info[i];
-
-		if (q =3D=3D p || !q->swap_file)
-			continue;
-		if (mapping =3D=3D q->swap_file->f_mapping) {
-			error =3D -EBUSY;
-			goto bad_swap;
-		}
-	}
-
 	inode =3D mapping->host;
+
 	/* If S_ISREG(inode->i_mode) will do mutex_lock(&inode->i_mutex); */
 	error =3D claim_swapfile(p, inode);
 	if (unlikely(error))
@@ -2450,6 +2444,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialf=
ile, int, swap_flags)
 		goto bad_swap;
 	}
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
+		int cpu;
+
 		p->flags |=3D SWP_SOLIDSTATE;
 		/*
 		 * select a random position to start with to help wear leveling
@@ -2468,9 +2464,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialf=
ile, int, swap_flags)
 			error =3D -ENOMEM;
 			goto bad_swap;
 		}
-		for_each_possible_cpu(i) {
+		for_each_possible_cpu(cpu) {
 			struct percpu_cluster *cluster;
-			cluster =3D per_cpu_ptr(p->percpu_cluster, i);
+			cluster =3D per_cpu_ptr(p->percpu_cluster, cpu);
 			cluster_set_null(&cluster->index);
 		}
 	}
@@ -2609,7 +2605,7 @@ void si_swapinfo(struct sysinfo *val)
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage)
 {
 	struct swap_info_struct *p;
-	unsigned long offset, type;
+	unsigned long offset;
 	unsigned char count;
 	unsigned char has_cache;
 	int err =3D -EINVAL;
@@ -2617,10 +2613,10 @@ static int __swap_duplicate(swp_entry_t entry, unsi=
gned char usage)
 	if (non_swap_entry(entry))
 		goto out;
=20
-	type =3D swp_type(entry);
-	if (type >=3D nr_swapfiles)
+	p =3D swp_swap_info(entry);
+	if (!p)
 		goto bad_file;
-	p =3D swap_info[type];
+
 	offset =3D swp_offset(entry);
=20
 	spin_lock(&p->lock);
@@ -2715,11 +2711,16 @@ int swapcache_prepare(swp_entry_t entry)
 	return __swap_duplicate(entry, SWAP_HAS_CACHE);
 }
=20
+struct swap_info_struct *swp_swap_info(swp_entry_t entry)
+{
+	return swap_type_to_swap_info(swp_type(entry));
+}
+
 struct swap_info_struct *page_swap_info(struct page *page)
 {
-	swp_entry_t swap =3D { .val =3D page_private(page) };
+	swp_entry_t entry =3D { .val =3D page_private(page) };
 	BUG_ON(!PageSwapCache(page));
-	return swap_info[swp_type(swap)];
+	return swp_swap_info(entry);
 }
=20
 /*
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f64632b67196..b9296d0b325c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2141,7 +2141,7 @@ int remap_vmalloc_range_partial(struct vm_area_struct=
 *vma, unsigned long uaddr,
 	if (!(area->flags & VM_USERMAP))
 		return -EINVAL;
=20
-	if (kaddr + size > area->addr + area->size)
+	if (kaddr + size > area->addr + get_vm_area_size(area))
 		return -EINVAL;
=20
 	do {
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 777ac525ef27..cd332d0fa930 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1219,6 +1219,9 @@ static int register_queue_kobjects(struct net_device =
*net)
 error:
 	netdev_queue_update_kobjects(net, txq, 0);
 	net_rx_queue_update_kobjects(net, rxq, 0);
+#ifdef CONFIG_SYSFS
+	kset_unregister(net->queues_kset);
+#endif
 	return error;
 }
=20
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 85b62691f4f2..45ebcc039a68 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -156,6 +156,7 @@ static __net_init int setup_net(struct net *net, struct=
 user_namespace *user_ns)
=20
 	atomic_set(&net->count, 1);
 	atomic_set(&net->passive, 1);
+	get_random_bytes(&net->hash_mix, sizeof(u32));
 	net->dev_base_seq =3D 1;
 	net->user_ns =3D user_ns;
=20
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index e5302b7f7ca9..1701afc0530f 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -78,9 +78,8 @@ void hsr_check_announce(struct net_device *hsr_dev, int o=
ld_operstate)
 	if ((hsr_dev->operstate =3D=3D IF_OPER_UP) && (old_operstate !=3D IF_OPER=
_UP)) {
 		/* Went up */
 		hsr_priv->announce_count =3D 0;
-		hsr_priv->announce_timer.expires =3D jiffies +
-				msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
-		add_timer(&hsr_priv->announce_timer);
+		mod_timer(&hsr_priv->announce_timer,
+			  jiffies + msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL));
 	}
=20
 	if ((hsr_dev->operstate !=3D IF_OPER_UP) && (old_operstate =3D=3D IF_OPER=
_UP))
@@ -361,6 +360,7 @@ static void send_hsr_supervision_frame(struct net_devic=
e *hsr_dev, u8 type)
 static void hsr_announce(unsigned long data)
 {
 	struct hsr_priv *hsr_priv;
+	unsigned long interval;
=20
 	hsr_priv =3D (struct hsr_priv *) data;
=20
@@ -372,14 +372,12 @@ static void hsr_announce(unsigned long data)
 	}
=20
 	if (hsr_priv->announce_count < 3)
-		hsr_priv->announce_timer.expires =3D jiffies +
-				msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
+		interval =3D msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL);
 	else
-		hsr_priv->announce_timer.expires =3D jiffies +
-				msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
+		interval =3D msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
=20
 	if (is_admin_up(hsr_priv->dev))
-		add_timer(&hsr_priv->announce_timer);
+		mod_timer(&hsr_priv->announce_timer, jiffies + interval);
 }
=20
=20
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e0d59ff394b2..660848116761 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1279,6 +1279,10 @@ static void ip_del_fnhe(struct fib_nh *nh, __be32 da=
ddr)
 		if (fnhe->fnhe_daddr =3D=3D daddr) {
 			rcu_assign_pointer(*fnhe_p, rcu_dereference_protected(
 				fnhe->fnhe_next, lockdep_is_held(&fnhe_lock)));
+			/* set fnhe_daddr to 0 to ensure it won't bind with
+			 * new dsts in rt_bind_exception().
+			 */
+			fnhe->fnhe_daddr =3D 0;
 			fnhe_flush_routes(fnhe);
 			kfree_rcu(fnhe, rcu);
 			break;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 4a64bebd360d..f3e3c36368db 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1091,7 +1091,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb=
, u32 len,
 	if (nsize < 0)
 		nsize =3D 0;
=20
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf + 0x20000)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index c99860ee0394..42978998534c 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1984,10 +1984,10 @@ int ip6mr_compat_ioctl(struct sock *sk, unsigned in=
t cmd, void __user *arg)
=20
 static inline int ip6mr_forward2_finish(struct sk_buff *skb)
 {
-	IP6_INC_STATS_BH(dev_net(skb_dst(skb)->dev), ip6_dst_idev(skb_dst(skb)),
-			 IPSTATS_MIB_OUTFORWDATAGRAMS);
-	IP6_ADD_STATS_BH(dev_net(skb_dst(skb)->dev), ip6_dst_idev(skb_dst(skb)),
-			 IPSTATS_MIB_OUTOCTETS, skb->len);
+	IP6_INC_STATS(dev_net(skb_dst(skb)->dev), ip6_dst_idev(skb_dst(skb)),
+		      IPSTATS_MIB_OUTFORWDATAGRAMS);
+	IP6_ADD_STATS(dev_net(skb_dst(skb)->dev), ip6_dst_idev(skb_dst(skb)),
+		      IPSTATS_MIB_OUTOCTETS, skb->len);
 	return dst_output(skb);
 }
=20
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index c966305cf46c..099c8fe5c8cf 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -664,9 +664,6 @@ static int l2tp_ip6_recvmsg(struct kiocb *iocb, struct =
sock *sk,
 	if (flags & MSG_OOB)
 		goto out;
=20
-	if (addr_len)
-		*addr_len =3D sizeof(*lsa);
-
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
=20
@@ -696,6 +693,7 @@ static int l2tp_ip6_recvmsg(struct kiocb *iocb, struct =
sock *sk,
 		lsa->l2tp_conn_id =3D 0;
 		if (ipv6_addr_type(&lsa->l2tp_addr) & IPV6_ADDR_LINKLOCAL)
 			lsa->l2tp_scope_id =3D IP6CB(skb)->iif;
+		*addr_len =3D sizeof(*lsa);
 	}
=20
 	if (np->rxopt.all)
diff --git a/scripts/coccinelle/api/stream_open.cocci b/scripts/coccinelle/=
api/stream_open.cocci
new file mode 100644
index 000000000000..350145da7669
--- /dev/null
+++ b/scripts/coccinelle/api/stream_open.cocci
@@ -0,0 +1,363 @@
+// SPDX-License-Identifier: GPL-2.0
+// Author: Kirill Smelkov (kirr@nexedi.com)
+//
+// Search for stream-like files that are using nonseekable_open and conver=
t
+// them to stream_open. A stream-like file is a file that does not use ppo=
s in
+// its read and write. Rationale for the conversion is to avoid deadlock i=
n
+// between read and write.
+
+virtual report
+virtual patch
+virtual explain  // explain decisions in the patch (SPFLAGS=3D"-D explain"=
)
+
+// stream-like reader & writer - ones that do not depend on f_pos.
+@ stream_reader @
+identifier readstream, ppos;
+identifier f, buf, len;
+type loff_t;
+@@
+  ssize_t readstream(struct file *f, char *buf, size_t len, loff_t *ppos)
+  {
+    ... when !=3D ppos
+  }
+
+@ stream_writer @
+identifier writestream, ppos;
+identifier f, buf, len;
+type loff_t;
+@@
+  ssize_t writestream(struct file *f, const char *buf, size_t len, loff_t =
*ppos)
+  {
+    ... when !=3D ppos
+  }
+
+
+// a function that blocks
+@ blocks @
+identifier block_f;
+identifier wait_event =3D~ "^wait_event_.*";
+@@
+  block_f(...) {
+    ... when exists
+    wait_event(...)
+    ... when exists
+  }
+
+// stream_reader that can block inside.
+//
+// XXX wait_* can be called not directly from current function (e.g. func =
-> f -> g -> wait())
+// XXX currently reader_blocks supports only direct and 1-level indirect c=
ases.
+@ reader_blocks_direct @
+identifier stream_reader.readstream;
+identifier wait_event =3D~ "^wait_event_.*";
+@@
+  readstream(...)
+  {
+    ... when exists
+    wait_event(...)
+    ... when exists
+  }
+
+@ reader_blocks_1 @
+identifier stream_reader.readstream;
+identifier blocks.block_f;
+@@
+  readstream(...)
+  {
+    ... when exists
+    block_f(...)
+    ... when exists
+  }
+
+@ reader_blocks depends on reader_blocks_direct || reader_blocks_1 @
+identifier stream_reader.readstream;
+@@
+  readstream(...) {
+    ...
+  }
+
+
+// file_operations + whether they have _any_ .read, .write, .llseek ... at=
 all.
+//
+// XXX add support for file_operations xxx[N] =3D ...	(sound/core/pcm_nati=
ve.c)
+@ fops0 @
+identifier fops;
+@@
+  struct file_operations fops =3D {
+    ...
+  };
+
+@ has_read @
+identifier fops0.fops;
+identifier read_f;
+@@
+  struct file_operations fops =3D {
+    .read =3D read_f,
+  };
+
+@ has_read_iter @
+identifier fops0.fops;
+identifier read_iter_f;
+@@
+  struct file_operations fops =3D {
+    .read_iter =3D read_iter_f,
+  };
+
+@ has_write @
+identifier fops0.fops;
+identifier write_f;
+@@
+  struct file_operations fops =3D {
+    .write =3D write_f,
+  };
+
+@ has_write_iter @
+identifier fops0.fops;
+identifier write_iter_f;
+@@
+  struct file_operations fops =3D {
+    .write_iter =3D write_iter_f,
+  };
+
+@ has_llseek @
+identifier fops0.fops;
+identifier llseek_f;
+@@
+  struct file_operations fops =3D {
+    .llseek =3D llseek_f,
+  };
+
+@ has_no_llseek @
+identifier fops0.fops;
+@@
+  struct file_operations fops =3D {
+    .llseek =3D no_llseek,
+  };
+
+@ has_mmap @
+identifier fops0.fops;
+identifier mmap_f;
+@@
+  struct file_operations fops =3D {
+    .mmap =3D mmap_f,
+  };
+
+@ has_copy_file_range @
+identifier fops0.fops;
+identifier copy_file_range_f;
+@@
+  struct file_operations fops =3D {
+    .copy_file_range =3D copy_file_range_f,
+  };
+
+@ has_remap_file_range @
+identifier fops0.fops;
+identifier remap_file_range_f;
+@@
+  struct file_operations fops =3D {
+    .remap_file_range =3D remap_file_range_f,
+  };
+
+@ has_splice_read @
+identifier fops0.fops;
+identifier splice_read_f;
+@@
+  struct file_operations fops =3D {
+    .splice_read =3D splice_read_f,
+  };
+
+@ has_splice_write @
+identifier fops0.fops;
+identifier splice_write_f;
+@@
+  struct file_operations fops =3D {
+    .splice_write =3D splice_write_f,
+  };
+
+
+// file_operations that is candidate for stream_open conversion - it does =
not
+// use mmap and other methods that assume @offset access to file.
+//
+// XXX for simplicity require no .{read/write}_iter and no .splice_{read/w=
rite} for now.
+// XXX maybe_steam.fops cannot be used in other rules - it gives "bad rule=
 maybe_stream or bad variable fops".
+@ maybe_stream depends on (!has_llseek || has_no_llseek) && !has_mmap && !=
has_copy_file_range && !has_remap_file_range && !has_read_iter && !has_writ=
e_iter && !has_splice_read && !has_splice_write @
+identifier fops0.fops;
+@@
+  struct file_operations fops =3D {
+  };
+
+
+// ---- conversions ----
+
+// XXX .open =3D nonseekable_open -> .open =3D stream_open
+// XXX .open =3D func -> openfunc -> nonseekable_open
+
+// read & write
+//
+// if both are used in the same file_operations together with an opener -
+// under that conditions we can use stream_open instead of nonseekable_ope=
n.
+@ fops_rw depends on maybe_stream @
+identifier fops0.fops, openfunc;
+identifier stream_reader.readstream;
+identifier stream_writer.writestream;
+@@
+  struct file_operations fops =3D {
+      .open  =3D openfunc,
+      .read  =3D readstream,
+      .write =3D writestream,
+  };
+
+@ report_rw depends on report @
+identifier fops_rw.openfunc;
+position p1;
+@@
+  openfunc(...) {
+    <...
+     nonseekable_open@p1
+    ...>
+  }
+
+@ script:python depends on report && reader_blocks @
+fops << fops0.fops;
+p << report_rw.p1;
+@@
+coccilib.report.print_report(p[0],
+  "ERROR: %s: .read() can deadlock .write(); change nonseekable_open -> st=
ream_open to fix." % (fops,))
+
+@ script:python depends on report && !reader_blocks @
+fops << fops0.fops;
+p << report_rw.p1;
+@@
+coccilib.report.print_report(p[0],
+  "WARNING: %s: .read() and .write() have stream semantic; safe to change =
nonseekable_open -> stream_open." % (fops,))
+
+
+@ explain_rw_deadlocked depends on explain && reader_blocks @
+identifier fops_rw.openfunc;
+@@
+  openfunc(...) {
+    <...
+-    nonseekable_open
++    nonseekable_open /* read & write (was deadlock) */
+    ...>
+  }
+
+
+@ explain_rw_nodeadlock depends on explain && !reader_blocks @
+identifier fops_rw.openfunc;
+@@
+  openfunc(...) {
+    <...
+-    nonseekable_open
++    nonseekable_open /* read & write (no direct deadlock) */
+    ...>
+  }
+
+@ patch_rw depends on patch @
+identifier fops_rw.openfunc;
+@@
+  openfunc(...) {
+    <...
+-   nonseekable_open
++   stream_open
+    ...>
+  }
+
+
+// read, but not write
+@ fops_r depends on maybe_stream && !has_write @
+identifier fops0.fops, openfunc;
+identifier stream_reader.readstream;
+@@
+  struct file_operations fops =3D {
+      .open  =3D openfunc,
+      .read  =3D readstream,
+  };
+
+@ report_r depends on report @
+identifier fops_r.openfunc;
+position p1;
+@@
+  openfunc(...) {
+    <...
+    nonseekable_open@p1
+    ...>
+  }
+
+@ script:python depends on report @
+fops << fops0.fops;
+p << report_r.p1;
+@@
+coccilib.report.print_report(p[0],
+  "WARNING: %s: .read() has stream semantic; safe to change nonseekable_op=
en -> stream_open." % (fops,))
+
+@ explain_r depends on explain @
+identifier fops_r.openfunc;
+@@
+  openfunc(...) {
+    <...
+-   nonseekable_open
++   nonseekable_open /* read only */
+    ...>
+  }
+
+@ patch_r depends on patch @
+identifier fops_r.openfunc;
+@@
+  openfunc(...) {
+    <...
+-   nonseekable_open
++   stream_open
+    ...>
+  }
+
+
+// write, but not read
+@ fops_w depends on maybe_stream && !has_read @
+identifier fops0.fops, openfunc;
+identifier stream_writer.writestream;
+@@
+  struct file_operations fops =3D {
+      .open  =3D openfunc,
+      .write =3D writestream,
+  };
+
+@ report_w depends on report @
+identifier fops_w.openfunc;
+position p1;
+@@
+  openfunc(...) {
+    <...
+    nonseekable_open@p1
+    ...>
+  }
+
+@ script:python depends on report @
+fops << fops0.fops;
+p << report_w.p1;
+@@
+coccilib.report.print_report(p[0],
+  "WARNING: %s: .write() has stream semantic; safe to change nonseekable_o=
pen -> stream_open." % (fops,))
+
+@ explain_w depends on explain @
+identifier fops_w.openfunc;
+@@
+  openfunc(...) {
+    <...
+-   nonseekable_open
++   nonseekable_open /* write only */
+    ...>
+  }
+
+@ patch_w depends on patch @
+identifier fops_w.openfunc;
+@@
+  openfunc(...) {
+    <...
+-   nonseekable_open
++   stream_open
+    ...>
+  }
+
+
+// no read, no write - don't change anything
diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index a18f1fa6440b..e0ae18b8df50 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -528,6 +528,7 @@ static inline int avc_sidcmp(u32 x, u32 y)
  * @perms : Permission mask bits
  * @ssid,@tsid,@tclass : identifier of an AVC entry
  * @seqno : sequence number when decision was made
+ * @flags: the AVC_* flags, e.g. AVC_NONBLOCKING, AVC_EXTENDED_PERMS, or 0=
.
  *
  * if a valid AVC entry doesn't exist,this function returns -ENOENT.
  * if kmalloc() called internal returns NULL, this function returns -ENOME=
M.
@@ -535,7 +536,7 @@ static inline int avc_sidcmp(u32 x, u32 y)
  * will release later by RCU.
  */
 static int avc_update_node(u32 event, u32 perms, u32 ssid, u32 tsid, u16 t=
class,
-			   u32 seqno)
+			   u32 seqno, unsigned int flags)
 {
 	int hvalue, rc =3D 0;
 	unsigned long flag;
@@ -543,6 +544,23 @@ static int avc_update_node(u32 event, u32 perms, u32 s=
sid, u32 tsid, u16 tclass,
 	struct hlist_head *head;
 	spinlock_t *lock;
=20
+	/*
+	 * If we are in a non-blocking code path, e.g. VFS RCU walk,
+	 * then we must not add permissions to a cache entry
+	 * because we cannot safely audit the denial.  Otherwise,
+	 * during the subsequent blocking retry (e.g. VFS ref walk), we
+	 * will find the permissions already granted in the cache entry
+	 * and won't audit anything at all, leading to silent denials in
+	 * permissive mode that only appear when in enforcing mode.
+	 *
+	 * See the corresponding handling in slow_avc_audit(), and the
+	 * logic in selinux_inode_follow_link and selinux_inode_permission
+	 * for the VFS MAY_NOT_BLOCK flag, which is transliterated into
+	 * AVC_NONBLOCKING for avc_has_perm_noaudit().
+	 */
+	if (flags & AVC_NONBLOCKING)
+		return 0;
+
 	node =3D avc_alloc_node();
 	if (!node) {
 		rc =3D -ENOMEM;
@@ -690,7 +708,7 @@ static noinline int avc_denied(u32 ssid, u32 tsid,
 		return -EACCES;
=20
 	avc_update_node(AVC_CALLBACK_GRANT, requested, ssid,
-				tsid, tclass, avd->seqno);
+			tsid, tclass, avd->seqno, flags);
 	return 0;
 }
=20
@@ -701,7 +719,7 @@ static noinline int avc_denied(u32 ssid, u32 tsid,
  * @tsid: target security identifier
  * @tclass: target security class
  * @requested: requested permissions, interpreted based on @tclass
- * @flags:  AVC_STRICT or 0
+ * @flags:  AVC_STRICT, AVC_NONBLOCKING, or 0
  * @avd: access vector decisions
  *
  * Check the AVC to determine whether the @requested permissions are grant=
ed
@@ -768,7 +786,25 @@ int avc_has_perm(u32 ssid, u32 tsid, u16 tclass,
=20
 	rc =3D avc_has_perm_noaudit(ssid, tsid, tclass, requested, 0, &avd);
=20
-	rc2 =3D avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata);
+	rc2 =3D avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata, 0);
+	if (rc2)
+		return rc2;
+	return rc;
+}
+
+int avc_has_perm_flags(u32 ssid, u32 tsid, u16 tclass,
+		       u32 requested, struct common_audit_data *auditdata,
+		       int flags)
+{
+	struct av_decision avd;
+	int rc, rc2;
+
+	rc =3D avc_has_perm_noaudit(ssid, tsid, tclass, requested,
+				  (flags & MAY_NOT_BLOCK) ? AVC_NONBLOCKING : 0,
+				  &avd);
+
+	rc2 =3D avc_audit(ssid, tsid, tclass, requested, &avd, rc,
+			auditdata, flags);
 	if (rc2)
 		return rc2;
 	return rc;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index df42cb7a1bbf..60d50812900f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1569,7 +1569,7 @@ static int cred_has_capability(const struct cred *cre=
d,
=20
 	rc =3D avc_has_perm_noaudit(sid, sid, sclass, av, 0, &avd);
 	if (audit =3D=3D SECURITY_CAP_AUDIT) {
-		int rc2 =3D avc_audit(sid, sid, sclass, av, &avd, rc, &ad);
+		int rc2 =3D avc_audit(sid, sid, sclass, av, &avd, rc, &ad, 0);
 		if (rc2)
 			return rc2;
 	}
@@ -2818,7 +2818,9 @@ static int selinux_inode_permission(struct inode *ino=
de, int mask)
 	sid =3D cred_sid(cred);
 	isec =3D inode->i_security;
=20
-	rc =3D avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd)=
;
+	rc =3D avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms,
+				  (flags & MAY_NOT_BLOCK) ? AVC_NONBLOCKING : 0,
+				  &avd);
 	audited =3D avc_audit_required(perms, &avd, rc,
 				     from_access ? FILE__AUDIT_ACCESS : 0,
 				     &denied);
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.=
h
index ddf8eec03f21..d86577934270 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -130,7 +130,8 @@ static inline int avc_audit(u32 ssid, u32 tsid,
 			    u16 tclass, u32 requested,
 			    struct av_decision *avd,
 			    int result,
-			    struct common_audit_data *a)
+			    struct common_audit_data *a,
+			    int flags)
 {
 	u32 audited, denied;
 	audited =3D avc_audit_required(requested, avd, result, 0, &denied);
@@ -138,10 +139,11 @@ static inline int avc_audit(u32 ssid, u32 tsid,
 		return 0;
 	return slow_avc_audit(ssid, tsid, tclass,
 			      requested, audited, denied, result,
-			      a, 0);
+			      a, flags);
 }
=20
 #define AVC_STRICT 1 /* Ignore permissive mode. */
+#define AVC_NONBLOCKING    4	/* non blocking */
 int avc_has_perm_noaudit(u32 ssid, u32 tsid,
 			 u16 tclass, u32 requested,
 			 unsigned flags,
@@ -150,6 +152,10 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
 int avc_has_perm(u32 ssid, u32 tsid,
 		 u16 tclass, u32 requested,
 		 struct common_audit_data *auditdata);
+int avc_has_perm_flags(u32 ssid, u32 tsid,
+		       u16 tclass, u32 requested,
+		       struct common_audit_data *auditdata,
+		       int flags);
=20
 u32 avc_policy_seqno(void);
=20
diff --git a/sound/firewire/bebob/bebob.c b/sound/firewire/bebob/bebob.c
index fc19c99654aa..16ff4e633bf2 100644
--- a/sound/firewire/bebob/bebob.c
+++ b/sound/firewire/bebob/bebob.c
@@ -396,7 +396,19 @@ static const struct ieee1394_device_id bebob_id_table[=
] =3D {
 	/* Focusrite, SaffirePro 26 I/O */
 	SND_BEBOB_DEV_ENTRY(VEN_FOCUSRITE, 0x00000003, &saffirepro_26_spec),
 	/* Focusrite, SaffirePro 10 I/O */
-	SND_BEBOB_DEV_ENTRY(VEN_FOCUSRITE, 0x00000006, &saffirepro_10_spec),
+	{
+		// The combination of vendor_id and model_id is the same as the
+		// same as the one of Liquid Saffire 56.
+		.match_flags	=3D IEEE1394_MATCH_VENDOR_ID |
+				  IEEE1394_MATCH_MODEL_ID |
+				  IEEE1394_MATCH_SPECIFIER_ID |
+				  IEEE1394_MATCH_VERSION,
+		.vendor_id	=3D VEN_FOCUSRITE,
+		.model_id	=3D 0x000006,
+		.specifier_id	=3D 0x00a02d,
+		.version	=3D 0x010001,
+		.driver_data	=3D (kernel_ulong_t)&saffirepro_10_spec,
+	},
 	/* Focusrite, Saffire(no label and LE) */
 	SND_BEBOB_DEV_ENTRY(VEN_FOCUSRITE, MODEL_FOCUSRITE_SAFFIRE_BOTH,
 			    &saffire_spec),
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index cd326bbf9c62..8acac5fd084c 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -392,7 +392,8 @@ static int fsl_esai_set_dai_fmt(struct snd_soc_dai *dai=
, unsigned int fmt)
 		break;
 	case SND_SOC_DAIFMT_RIGHT_J:
 		/* Data on rising edge of bclk, frame high, right aligned */
-		xccr |=3D ESAI_xCCR_xCKP | ESAI_xCCR_xHCKP | ESAI_xCR_xWA;
+		xccr |=3D ESAI_xCCR_xCKP | ESAI_xCCR_xHCKP;
+		xcr  |=3D ESAI_xCR_xWA;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
 		/* Data on rising edge of bclk, frame high, 1clk before data */
@@ -449,12 +450,12 @@ static int fsl_esai_set_dai_fmt(struct snd_soc_dai *d=
ai, unsigned int fmt)
 		return -EINVAL;
 	}
=20
-	mask =3D ESAI_xCR_xFSL | ESAI_xCR_xFSR;
+	mask =3D ESAI_xCR_xFSL | ESAI_xCR_xFSR | ESAI_xCR_xWA;
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_TCR, mask, xcr);
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_RCR, mask, xcr);
=20
 	mask =3D ESAI_xCCR_xCKP | ESAI_xCCR_xHCKP | ESAI_xCCR_xFSP |
-		ESAI_xCCR_xFSD | ESAI_xCCR_xCKD | ESAI_xCR_xWA;
+		ESAI_xCCR_xFSD | ESAI_xCCR_xCKD;
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_TCCR, mask, xccr);
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_RCCR, mask, xccr);
=20
diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 335e1518be8c..f149c5eb57b3 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1229,6 +1229,7 @@ static int fsl_ssi_probe(struct platform_device *pdev=
)
 	struct fsl_ssi_private *ssi_private;
 	int ret =3D 0;
 	struct device_node *np =3D pdev->dev.of_node;
+	struct device_node *root;
 	const struct of_device_id *of_id;
 	const char *p, *sprop;
 	const uint32_t *iprop;
@@ -1373,7 +1374,9 @@ static int fsl_ssi_probe(struct platform_device *pdev=
)
 	 * device tree.  We also pass the address of the CPU DAI driver
 	 * structure.
 	 */
-	sprop =3D of_get_property(of_find_node_by_path("/"), "compatible", NULL);
+	root =3D of_find_node_by_path("/");
+	sprop =3D of_get_property(root, "compatible", NULL);
+	of_node_put(root);
 	/* Sometimes the compatible name has a "fsl," prefix, so we strip it. */
 	p =3D strrchr(sprop, ',');
 	if (p)
diff --git a/sound/soc/fsl/imx-sgtl5000.c b/sound/soc/fsl/imx-sgtl5000.c
index 1cb22dd034eb..be14200293fc 100644
--- a/sound/soc/fsl/imx-sgtl5000.c
+++ b/sound/soc/fsl/imx-sgtl5000.c
@@ -118,7 +118,8 @@ static int imx_sgtl5000_probe(struct platform_device *p=
dev)
 	codec_dev =3D of_find_i2c_device_by_node(codec_np);
 	if (!codec_dev) {
 		dev_err(&pdev->dev, "failed to find codec platform device\n");
-		return -EPROBE_DEFER;
+		ret =3D -EPROBE_DEFER;
+		goto fail;
 	}
=20
 	data =3D devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 6b8769a40acb..95b2df232d71 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2283,7 +2283,7 @@ static int arg_num_eval(struct print_arg *arg, long l=
ong *val)
 static char *arg_eval (struct print_arg *arg)
 {
 	long long val;
-	static char buf[20];
+	static char buf[24];
=20
 	switch (arg->type) {
 	case PRINT_ATOM:
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 96592f7bfa9f..dc78aba5182e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1009,7 +1009,7 @@ static int write_numa_topology(int fd, struct perf_he=
ader *h __maybe_unused,
 		if (ret < 0)
 			break;
=20
-		ret =3D write_topo_node(fd, i);
+		ret =3D write_topo_node(fd, j);
 		if (ret < 0)
 			break;
 	}
=0D
--=-3m69Fjx7Me5M+9wRXjoi--

--=-VOH9hFEr9JV7UJXRSCBE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl0l2xYACgkQ57/I7JWG
EQmRSQ/9HzENXQj8kiFHZO42vBwBMrBc3+/lRGDJC9iB738iiGLx7EMWf7XY0p0/
kRqjI1S+D3Dq72OpekLmHbrbqO6IkOQj0wQ7nxnCd6SbNNUeg2DohxQerPpmUM6N
iZgksTl6E+xzyYkn7Lh3gxA1GKAWU+pVgdT5Kt50MlkUbVqu94CYsnJSGZdpDO+T
Obw81JyHG08hikg42b12F9HWdIxtW+vB13vZ+5E4CI7TRx6h9Q3MuQOuBYhxLxnK
lkuunw08bm+GE2x+rMyrQwNjmWFBFJhv2uqLqqhwpk5DipGwiNsBxQRIDzMomD6i
zTyhbJa9rF4EQYH4idXxCKN6ErSU2ZjnOsilncxIIXwlrH031+oTzqPbdcuRDI1c
ETtSQYZSJUHc4g/oaODnSw90TuIZNSt3AvWxDQ66GQ4cDj/uNoewTCTRcstQFpcM
mH8U60u/+lSq3utuxWr4POr7oSmBPeWtvpEDXHDDRHhfxZjPv4w8AINiNOh3knt8
ENxMWmp5sy3i7TKUAiRlDe/zUuKIE+zGvw2WFOKo9x8Ujj6MPvaDnzqRb6QXYuPa
jtTnFj2rWO8wpLYDgMLvh1M36UiEsG9FQNrCrySP8EJfxa2sFjCxU0uIm83ML95v
tZCfXvm4gdtabT+aZhVK7i81En7rRn6JGgUAlzWsGZ/QU9/h+a4=
=Ji4W
-----END PGP SIGNATURE-----

--=-VOH9hFEr9JV7UJXRSCBE--
