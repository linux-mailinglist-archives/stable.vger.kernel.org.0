Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5CA1C23BF
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 09:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgEBHOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 03:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgEBHOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 03:14:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E83208DB;
        Sat,  2 May 2020 07:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588403690;
        bh=X2Lbv6AewvM62sSPpnagu6zR8Nf32any34i5WtABNTg=;
        h=Date:From:To:Cc:Subject:From;
        b=uPTkvlrKMZxTYgcYIDTDDYwQQT5aOVgnnSJhz8d/CdudTgwBbaErOtDwZysA5BayO
         hEs/lxcuqIGYadPMUcP+rNJ0Y+lY6gy3onDGnN4leLPKA8XK2uaWoAVwx4L6t8GaV6
         r8h0zuHKUnhRYCBzIx9fFlJh78B+Db/RybOdae9E=
Date:   Sat, 2 May 2020 09:14:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.37
Message-ID: <20200502071448.GA2593371@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.37 kernel.

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

 Makefile                                                 |    2=20
 arch/arm/boot/dts/bcm283x.dtsi                           |    1=20
 arch/arm64/include/asm/sysreg.h                          |    4=20
 arch/s390/kernel/diag.c                                  |    2=20
 arch/s390/kernel/smp.c                                   |    4=20
 arch/s390/kernel/trace.c                                 |    2=20
 arch/s390/pci/pci_irq.c                                  |    5=20
 arch/um/Makefile                                         |    1=20
 arch/x86/kernel/cpu/mshyperv.c                           |    4=20
 arch/x86/net/bpf_jit_comp.c                              |   18 +
 arch/x86/net/bpf_jit_comp32.c                            |   28 +-
 block/blk-iocost.c                                       |    4=20
 block/blk-mq.c                                           |    4=20
 drivers/base/power/main.c                                |    2=20
 drivers/counter/104-quad-8.c                             |  194 ++++++++++=
++---
 drivers/crypto/chelsio/chcr_core.c                       |    2=20
 drivers/hwmon/jc42.c                                     |    2=20
 drivers/i2c/busses/i2c-altera.c                          |    9=20
 drivers/iio/adc/ad7793.c                                 |    2=20
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c               |    2=20
 drivers/net/ethernet/freescale/fec.h                     |    7=20
 drivers/net/ethernet/freescale/fec_main.c                |  149 +++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |    6=20
 drivers/net/ethernet/mellanox/mlx5/core/en.h             |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c      |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |    7=20
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c          |    8=20
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c        |    6=20
 drivers/net/ethernet/qlogic/qed/qed_dev.c                |   38 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c               |   13 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c      |    2=20
 drivers/pci/quirks.c                                     |  143 ++++++++---
 drivers/remoteproc/remoteproc_core.c                     |    2=20
 drivers/soc/xilinx/Kconfig                               |    4=20
 drivers/staging/gasket/apex_driver.c                     |    7=20
 drivers/target/target_core_fabric_lib.c                  |    2=20
 drivers/target/target_core_user.c                        |    1=20
 drivers/usb/dwc3/gadget.c                                |    8=20
 drivers/usb/gadget/udc/atmel_usba_udc.c                  |    4=20
 drivers/usb/gadget/udc/bdc/bdc_ep.c                      |    2=20
 drivers/xen/xenbus/xenbus_client.c                       |    9=20
 fs/afs/cmservice.c                                       |    2=20
 fs/afs/internal.h                                        |    2=20
 fs/afs/rotate.c                                          |    6=20
 fs/afs/server.c                                          |    7=20
 fs/afs/volume.c                                          |    8=20
 fs/afs/yfsclient.c                                       |    6=20
 fs/ext4/ialloc.c                                         |    2=20
 fs/ext4/inode.c                                          |    2=20
 fs/ext4/mballoc.c                                        |    6=20
 fs/ext4/super.c                                          |    3=20
 fs/nfsd/nfs4state.c                                      |    2=20
 fs/pnode.c                                               |    9=20
 fs/ubifs/orphan.c                                        |    4=20
 fs/xfs/xfs_icache.c                                      |   10=20
 fs/xfs/xfs_ioctl.c                                       |    5=20
 fs/xfs/xfs_reflink.c                                     |    1=20
 fs/xfs/xfs_trans_ail.c                                   |    4=20
 include/linux/pci_ids.h                                  |    2=20
 include/linux/printk.h                                   |    5=20
 include/linux/qed/qed_chain.h                            |   24 +
 include/linux/sunrpc/svc_rdma.h                          |    1=20
 include/sound/soc.h                                      |    1=20
 include/trace/events/iocost.h                            |    6=20
 include/trace/events/rpcrdma.h                           |   50 ++-
 include/uapi/linux/pkt_sched.h                           |    4=20
 init/main.c                                              |    1=20
 kernel/bpf/cpumap.c                                      |    2=20
 kernel/bpf/verifier.c                                    |   28 +-
 kernel/events/core.c                                     |   13 -
 kernel/printk/internal.h                                 |    5=20
 kernel/printk/printk.c                                   |   34 ++
 kernel/printk/printk_safe.c                              |   11=20
 kernel/sched/core.c                                      |    9=20
 kernel/signal.c                                          |    6=20
 mm/shmem.c                                               |    4=20
 net/core/datagram.c                                      |   14 -
 net/mac80211/mesh.c                                      |   11=20
 net/netfilter/nf_nat_proto.c                             |    4=20
 net/rxrpc/local_object.c                                 |    9=20
 net/rxrpc/output.c                                       |   44 ---
 net/sunrpc/svc_xprt.c                                    |    3=20
 net/sunrpc/svcsock.c                                     |    4=20
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c                  |   22 +
 net/sunrpc/xprtrdma/svc_rdma_rw.c                        |    3=20
 net/sunrpc/xprtrdma/svc_rdma_sendto.c                    |   29 --
 net/sunrpc/xprtrdma/svc_rdma_transport.c                 |    5=20
 scripts/Makefile.lib                                     |    2=20
 sound/pci/hda/hda_intel.c                                |   46 ++-
 sound/pci/hda/hda_intel.h                                |    1=20
 sound/soc/codecs/tas571x.c                               |   20 +
 sound/soc/codecs/wm8960.c                                |    3=20
 sound/soc/meson/axg-card.c                               |    4=20
 sound/soc/qcom/qdsp6/q6afe-dai.c                         |   16 +
 sound/soc/soc-core.c                                     |   28 +-
 sound/soc/stm/stm32_sai_sub.c                            |   12=20
 sound/soc/stm/stm32_spdifrx.c                            |    2=20
 tools/lib/bpf/netlink.c                                  |    4=20
 tools/objtool/check.c                                    |   17 +
 tools/objtool/orc_dump.c                                 |   44 ++-
 tools/testing/selftests/bpf/verifier/value_illegal_alu.c |    1=20
 101 files changed, 916 insertions(+), 433 deletions(-)

Al Viro (1):
      propagate_one(): mnt_set_mountpoint() needs mount_lock

Arnd Bergmann (1):
      drivers: soc: xilinx: fix firmware driver Kconfig dependency

Atsushi Nemoto (1):
      net: stmmac: socfpga: Allow all RGMII modes

Ayush Sawal (1):
      Crypto: chelsio - Fixes a hang issue during driver registration

Bjorn Helgaas (3):
      PCI: Make ACS quirk implementations more uniform
      PCI: Unify ACS quirk desired vs provided checking
      PCI: Move Apex Edge TPU class quirk to fix BAR assignment

Bodo Stroesser (2):
      scsi: target: fix PR IN / READ FULL STATUS for FC
      scsi: target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN

Brian Foster (1):
      xfs: acquire superblock freeze protection on eofblocks scans

Chuck Lever (2):
      svcrdma: Fix trace point use-after-free race
      svcrdma: Fix leak of svc_rdma_recv_ctxt objects

Clement Leger (1):
      remoteproc: Fix wrong rvring index computation

Cristian Birsan (1):
      usb: gadget: udc: atmel: Fix vbus disconnect handling

Darrick J. Wong (1):
      xfs: fix partially uninitialized structure in xfs_reflink_remap_extent

David Howells (4):
      afs: Make record checking use TASK_UNINTERRUPTIBLE when appropriate
      afs: Fix to actually set AFS_SERVER_FL_HAVE_EPOCH
      rxrpc: Fix DATA Tx to disable nofrag for UDP on AF_INET6 socket
      afs: Fix length of dump of bad YFSFetchStatus record

Eric Biggers (1):
      xfs: clear PF_MEMALLOC before exiting xfsaild thread

Eric Dumazet (1):
      net: use indirect call wrappers for skb_copy_datagram_iter()

Eugene Syromiatnikov (1):
      taprio: do not use BIT() in TCA_TAPRIO_ATTR_FLAG_* definitions

Fangrui Song (1):
      arm64: Delete the space separator in __emit_inst

Greg Kroah-Hartman (1):
      Linux 5.4.37

Hillf Danton (1):
      netfilter: nat: fix error handling upon registering inet hook

Hui Wang (1):
      ALSA: hda: call runtime_allow() for all hda controllers

Ian Rogers (1):
      perf/core: fix parent pid/tid in task exit events

Jann Horn (1):
      bpf: Forbid XADD on spilled pointers for unprivileged users

Jason Gunthorpe (1):
      net/cxgb4: Check the return from t4_query_params properly

Jeremy Cline (1):
      libbpf: Initialize *nl_pid so gcc 10 is happy

Jerome Brunet (1):
      ASoC: meson: axg-card: fix codec-to-codec link setup

John Garry (1):
      blk-mq: Put driver tag in blk_mq_dispatch_rq_list() when no budget

Josh Poimboeuf (2):
      objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings
      objtool: Support Clang non-section symbols in ORC dump

Juergen Gross (1):
      xen/xenbus: ensure xenbus_map_ring_valloc() returns proper grant stat=
us

Kai-Heng Feng (2):
      PCI: Avoid ASMedia XHCI USB PME# from D0 defect
      PM: sleep: core: Switch back to async_schedule_dev()

Luke Nelson (3):
      bpf, x86_32: Fix incorrect encoding in BPF_LDX zero-extension
      bpf, x86_32: Fix clobbering of dst for BPF_JSET
      bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B

Martin Fuzzey (1):
      net: fec: set GPR bit on suspend by DT configuration.

Masahiro Yamada (1):
      kbuild: fix DT binding schema rule again to avoid needless rebuilds

Maxim Mikityanskiy (1):
      net/mlx5e: Don't trigger IRQ multiple times on XSK wakeup to avoid WQ=
 overruns

Nathan Chancellor (1):
      usb: gadget: udc: bdc: Remove unnecessary NULL checks in bdc_req_comp=
lete

Nicolas Saenz Julienne (1):
      ARM: dts: bcm283x: Disable dsi0 node

Niklas Schnelle (2):
      s390/pci: do not set affinity for floating irqs
      net/mlx5: Fix failing fw tracer allocation on s390

Olaf Hering (1):
      x86: hyperv: report value of misc_features

Olivier Moysan (2):
      ASoC: stm32: sai: fix sai probe
      ASoC: stm32: spdifrx: fix regmap status check

Philipp Puschmann (1):
      ASoC: tas571x: disable regulators on failed probe

Philipp Rudo (1):
      s390/ftrace: fix potential crashes when switching tracers

Pierre-Louis Bossart (1):
      ASoC: soc-core: disable route checks for legacy devices

Quentin Perret (1):
      sched/core: Fix reset-on-fork from RT with uclamp

Raymond Pang (3):
      PCI: Add ACS quirk for Zhaoxin multi-function devices
      PCI: Add Zhaoxin Vendor ID
      PCI: Add ACS quirk for Zhaoxin Root/Downstream Ports

Richard Weinberger (1):
      ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans()

Ritesh Harjani (1):
      ext4: check for non-zero journal inum in ext4_calculate_overhead

Roy Spliet (1):
      ALSA: hda: Explicitly permit using autosuspend if runtime PM is suppo=
rted

Sascha Hauer (1):
      hwmon: (jc42) Fix name to have no illegal characters

Sergey Senozhatsky (1):
      printk: queue wake_up_klogd irq_work only if per-CPU areas are ready

Shengjiu Wang (1):
      ASoC: wm8960: Fix wrong clock after suspend & resume

Stephan Gerhold (1):
      ASoC: q6dsp6: q6afe-dai: add missing channels to MI2S DAIs

Syed Nayyar Waris (1):
      counter: 104-quad-8: Add lock guards - generic interface

Takashi Iwai (2):
      ALSA: hda: Release resources at error in delayed probe
      ALSA: hda: Keep the controller initialization even if no codecs found

Tamizh chelvam (1):
      mac80211: fix channel switch trigger from unknown mesh peer

Theodore Ts'o (2):
      ext4: increase wait time needed before reuse of deleted inode numbers
      ext4: convert BUG_ON's to WARN_ON's in mballoc.c

Thinh Nguyen (1):
      usb: dwc3: gadget: Do link recovery for SS and SSP

Toke H=F8iland-J=F8rgensen (1):
      cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS is enabled

Vasily Averin (1):
      nfsd: memory corruption in nfsd4_lock()

Vitor Massaru Iha (1):
      um: ensure `make ARCH=3Dum mrproper` removes arch/$(SUBARCH)/include/=
generated/

Waiman Long (1):
      blk-iocost: Fix error on iocost_ioc_vrate_adj

Wang YanQing (1):
      bpf, x86_32: Fix logic error in BPF_LDX zero-extension

Wolfram Sang (1):
      i2c: altera: use proper variable to hold errno

Yang Shi (1):
      mm: shmem: disable interrupt when acquiring info->lock in userfaultfd=
_copy path

YueHaibing (1):
      iio:ad7797: Use correct attribute_group

Yuval Basson (2):
      qed: Fix race condition between scheduling and destroying the slowpat=
h workqueue
      qed: Fix use after free in qed_chain_free

Zhiqiang Liu (1):
      signal: check sig before setting info in kill_pid_usb_asyncio

Zhu Yanjun (1):
      net/mlx5e: Get the latest values from counters in switchdev mode

yangerkun (1):
      ext4: use matching invalidatepage in ext4_writepage


--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6tHeUACgkQONu9yGCS
aT4sOw/8D/DVcgrHprePqMqdJl8Yv4OZD6ZFRR1HTNlX8UHH2ZkDgaxbEbnUKut/
tp2euI9caJ3+i2p4nwjskrU/5xpfCplkfTmb6VP6x75A/ANH99gqdiuimpXtvPo4
U9egOYYVf3/ZSfWJ5AmM1UpAmEPqjDsKc1jVz62K45FjY49lBD5eFX1RLFsQMfsy
53aKtgXGGUdsvUrcazCck47E0M4GhTlH7+TAaiSWBHXD5J+yg+hAIWmUhyRwr/vV
Nhsslx9JSNEfmP5SsffRNUNXh4m+2ykYNhx5L/46A1JSxTRtgDur6GK5rT/QjQNy
5mB4NXWZg4TUtXwTGYYD0ilHsV1Qe1SRDyHczcRkVBC5YwHr5CZz9DPFNtfypbTQ
/eEggBkKvNEDgHIx5q+wD0hiQvYSq+kdKZfTfXv1sgRZOsSLkoBcBDZIaCttNO/g
nxKYyZZ22Gi6ySpWrcm5ajKNd2oROwYY9Dxag6A/EV89mf/7dWz0z2qy2qvkuBQ8
gUOI6Z3QPSeMH3QgPUNQjWH73STGEUJ0K5slpWxGz/sWu69yqb/OVBnoIJhCqWcv
4irtyEhwGf8FFbhkatNiZFdPa19gSs4xRBpqx/FZDRWUTQ5pyqQjiKgITb39FWhq
WliiYvW2CS/huA9PXi/Va2XlfVsNB7PNz+LQbeaCiAguk86ydr8=
=AzwM
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
