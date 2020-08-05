Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D984823C983
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 11:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgHEJs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 05:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727921AbgHEJqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 05:46:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6EBE22CA0;
        Wed,  5 Aug 2020 09:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596620767;
        bh=Rt7eYIa5nqA060iw0KPsbwAS08mkHFpq96WWubi30Og=;
        h=From:To:Cc:Subject:Date:From;
        b=R8tK82CJUB7yGIS9jVAUO9eDNKOiAo2q3w8xMvY4hYdIawe+F0Jlmrpz6RBMZjDZe
         tRyhN/L3Th1o+etKjqBb6u7lUKfdIEoTbqdeiwjHoX5riiSXBMfO+XdJ5E7EbYCTrD
         Ua09WmoFYGK1q4loYcU+/S2bZ+zkpuoXOJDEaObc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.56
Date:   Wed,  5 Aug 2020 11:46:15 +0200
Message-Id: <1596620775133125@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.56 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    2 
 arch/arm/boot/dts/armada-38x.dtsi                             |    3 
 arch/arm/boot/dts/imx6qdl-icore.dtsi                          |    3 
 arch/arm/boot/dts/imx6sx-sabreauto.dts                        |    2 
 arch/arm/boot/dts/imx6sx-sdb.dtsi                             |    2 
 arch/arm/boot/dts/sun4i-a10.dtsi                              |    2 
 arch/arm/boot/dts/sun5i.dtsi                                  |    2 
 arch/arm/boot/dts/sun7i-a20.dtsi                              |    2 
 arch/arm/kernel/hw_breakpoint.c                               |   27 +++-
 arch/arm64/include/asm/alternative.h                          |    4 
 arch/arm64/include/asm/checksum.h                             |    5 
 arch/parisc/include/asm/cmpxchg.h                             |    2 
 arch/parisc/lib/bitops.c                                      |   12 +
 arch/riscv/mm/init.c                                          |    2 
 arch/sh/include/asm/pgalloc.h                                 |   10 -
 arch/sh/kernel/entry-common.S                                 |    6 
 arch/x86/kernel/i8259.c                                       |    2 
 arch/x86/kernel/stacktrace.c                                  |    5 
 arch/x86/kernel/unwind_orc.c                                  |    8 -
 arch/x86/kvm/lapic.c                                          |    2 
 drivers/crypto/ccp/ccp-ops.c                                  |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                       |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                        |    9 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c             |   36 ++++-
 drivers/gpu/drm/drm_gem.c                                     |   10 -
 drivers/gpu/drm/drm_mipi_dbi.c                                |    2 
 drivers/i2c/busses/i2c-cadence.c                              |    9 -
 drivers/infiniband/sw/rdmavt/qp.c                             |   33 -----
 drivers/infiniband/sw/rdmavt/rc.c                             |    4 
 drivers/media/pci/cx23885/cx23888-ir.c                        |    5 
 drivers/net/ethernet/chelsio/cxgb4/sge.c                      |    1 
 drivers/net/ethernet/cortina/gemini.c                         |    5 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c               |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c       |   28 ++--
 drivers/net/ethernet/ibm/ibmvnic.c                            |    2 
 drivers/net/ethernet/mellanox/mlx4/main.c                     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c             |   31 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c             |   23 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c           |   23 +++
 drivers/net/ethernet/mellanox/mlxsw/core.c                    |    8 -
 drivers/net/ethernet/ni/nixge.c                               |    8 -
 drivers/net/ethernet/qlogic/qed/qed_int.c                     |    3 
 drivers/net/ethernet/renesas/ravb_main.c                      |   26 +++-
 drivers/net/usb/hso.c                                         |    5 
 drivers/net/usb/lan78xx.c                                     |    6 
 drivers/net/vxlan.c                                           |    6 
 drivers/net/wan/hdlc_x25.c                                    |    4 
 drivers/net/wan/lapbether.c                                   |    8 -
 drivers/net/wireless/ath/ath10k/hw.c                          |    1 
 drivers/net/xen-netfront.c                                    |   64 ++++++----
 drivers/nfc/s3fwrn5/core.c                                    |    1 
 drivers/nvme/host/tcp.c                                       |    3 
 drivers/pci/quirks.c                                          |   13 ++
 drivers/scsi/scsi_lib.c                                       |   16 +-
 drivers/vhost/scsi.c                                          |    2 
 drivers/virtio/virtio_balloon.c                               |    6 
 include/linux/mlx5/mlx5_ifc.h                                 |    1 
 include/linux/rhashtable.h                                    |   25 ++-
 include/net/xfrm.h                                            |   15 +-
 include/rdma/rdmavt_qp.h                                      |   19 ++
 include/uapi/linux/wireless.h                                 |    5 
 kernel/bpf/hashtab.c                                          |   12 +
 mm/filemap.c                                                  |    2 
 net/9p/trans_fd.c                                             |   15 ++
 net/bluetooth/hci_event.c                                     |   26 ++--
 net/key/af_key.c                                              |    4 
 net/mac80211/cfg.c                                            |    1 
 net/mac80211/mesh_pathtbl.c                                   |    1 
 net/rds/recv.c                                                |    3 
 net/sunrpc/sunrpc.h                                           |    1 
 net/sunrpc/sunrpc_syms.c                                      |    2 
 net/sunrpc/svcauth.c                                          |   27 ++++
 net/x25/x25_subr.c                                            |    6 
 net/xfrm/xfrm_policy.c                                        |   39 ++----
 net/xfrm/xfrm_user.c                                          |   18 +-
 sound/pci/hda/patch_hdmi.c                                    |    2 
 sound/pci/hda/patch_realtek.c                                 |   36 ++++-
 sound/usb/pcm.c                                               |    1 
 tools/lib/traceevent/plugins/Makefile                         |    2 
 tools/perf/arch/arm/util/auxtrace.c                           |    8 -
 tools/perf/bench/bench.h                                      |    4 
 tools/perf/bench/epoll-ctl.c                                  |    7 -
 tools/perf/bench/epoll-wait.c                                 |   11 -
 tools/perf/bench/futex-hash.c                                 |   12 -
 tools/perf/bench/futex-lock-pi.c                              |   11 -
 tools/perf/tests/bp_account.c                                 |    2 
 tools/perf/util/env.c                                         |    4 
 tools/testing/selftests/net/fib_nexthop_multiprefix.sh        |    2 
 tools/testing/selftests/net/ip_defrag.sh                      |    2 
 tools/testing/selftests/net/psock_fanout.c                    |    3 
 tools/testing/selftests/net/so_txtime.c                       |    2 
 tools/testing/selftests/networking/timestamping/rxtimestamp.c |    3 
 virt/kvm/arm/mmu.c                                            |   11 -
 95 files changed, 575 insertions(+), 288 deletions(-)

Abhishek Ambure (1):
      ath10k: enable transmit data ack RSSI for QCA9884

Alaa Hleihel (1):
      net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev

Alain Michaud (1):
      Bluetooth: fix kernel oops in store_pending_adv_report

Alex Deucher (1):
      Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs handlers"

Andrea Righi (1):
      xen-netfront: fix potential deadlock in xennet_remove()

Andrii Nakryiko (1):
      bpf: Fix map leak in HASH_OF_MAPS map

Armas Spann (2):
      ALSA: hda/realtek: enable headset mic of ASUS ROG Zephyrus G15(GA502) series with ALC289
      ALSA: hda/realtek: typo_fix: enable headset mic of ASUS ROG Zephyrus G14(GA401) series with ALC289

Arnaldo Carvalho de Melo (3):
      perf tests bp_account: Make global variable static
      perf env: Do not return pointers to local variables
      perf bench: Share some global variables to fix build with gcc 10

Atish Patra (1):
      RISC-V: Set maximum number of mapped pages correctly

Aya Levin (1):
      net/mlx5e: Fix error path of device attach

Ben Hutchings (1):
      libtraceevent: Fix build with binutils 2.35

Eran Ben Elisha (1):
      net/mlx5: Verify Hardware supports requested ptp function on a given pin

Fabio Estevam (2):
      ARM: dts: imx6sx-sabreauto: Fix the phy-mode on fec2
      ARM: dts: imx6sx-sdb: Fix the phy-mode on fec2

Geert Uytterhoeven (1):
      usb: hso: Fix debug compile warning on sparc32

Greg Kroah-Hartman (1):
      Linux 5.4.56

Guojia Liao (1):
      net: hns3: fix aRFS FD rules leftover after add a user FD rule

Herbert Xu (1):
      rhashtable: Fix unprotected RCU dereference in __rht_ptr

Ido Schimmel (2):
      mlxsw: core: Increase scope of RCU read-side critical section
      mlxsw: core: Free EMAD transactions using kfree_rcu()

Jakub Kicinski (1):
      mlx4: disable device on shutdown

Jan Kara (1):
      mm/filemap.c: don't bother dropping mmap_sem for zero size readahead

Johan Hovold (2):
      net: lan78xx: add missing endpoint sanity check
      net: lan78xx: fix transfer-buffer memory leak

Josh Poimboeuf (2):
      x86/unwind/orc: Fix ORC for newly forked tasks
      x86/stacktrace: Fix reliable check for empty user task stacks

Kailang Yang (1):
      ALSA: hda/realtek - Fixed HP right speaker no sound

Laurence Oberman (1):
      qed: Disable "MFW indication via attention" SPAM every 5 minutes

Laurence Tratt (1):
      ALSA: usb-audio: Add implicit feedback quirk for SSL2

Liam Beguin (1):
      parisc: add support for cmpxchg on u8 pointers

Lu Wei (1):
      net: nixge: fix potential memory leak in nixge_probe()

Maxime Ripard (1):
      ARM: dts sunxi: Relax a bit the CMA pool allocation range

Mazin Rezk (1):
      drm/amd/display: Clear dm_state for fast updates

Michael Karcher (1):
      sh: Fix validation of system call number

Michael S. Tsirkin (2):
      vhost/scsi: fix up req type endian-ness
      virtio_balloon: fix up endian-ness for free cmd id

Michael Trimarchi (1):
      ARM: dts: imx6qdl-icore: Fix OTG_ID pin and sdcard detect

Mike Marciniszyn (1):
      IB/rdmavt: Fix RQ counting issues causing use of an invalid RWQE

Ming Lei (1):
      scsi: core: Run queue in case of I/O resource contention failure

Navid Emamdoost (4):
      crypto: ccp - Release all allocated memory if sha type is invalid
      media: rc: prevent memory leak in cx23888_ir_probe
      nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame
      cxgb4: add missing release on skb in uld_send()

Paolo Pisati (2):
      selftests: fib_nexthop_multiprefix: fix cleanup() netns deletion
      selftests: net: ip_defrag: modprobe missing nf_defrag_ipv6 support

Parav Pandit (1):
      net/mlx5: E-switch, Destroy TSAR when fail to enable the mode

Paul Cercueil (1):
      drm/dbi: Fix SPI Type 1 (9-bit) transfer

PeiSen Hou (1):
      ALSA: hda/realtek: Fix add a "ultra_low_power" function for intel reference board (alc256)

Peilin Ye (2):
      drm/amdgpu: Prevent kernel-infoleak in amdgpu_info_ioctl()
      rds: Prevent kernel-infoleak in rds_notify_queue_get()

Peter Zijlstra (1):
      sh/tlb: Fix PGTABLE_LEVELS > 2

Pi-Hsun Shih (1):
      wireless: Use offsetof instead of custom macro.

Raviteja Narayanam (1):
      Revert "i2c: cadence: Fix the hold bit setting"

Remi Pommarel (2):
      mac80211: mesh: Free ie data when leaving mesh
      mac80211: mesh: Free pending skb when destroying a mpath

Robert Hancock (1):
      PCI/ASPM: Disable ASPM on ASMedia ASM1083/1085 PCIe-to-PCI bridge

Robin Murphy (1):
      arm64: csum: Fix handling of bad packets

Ron Diskin (1):
      net/mlx5e: Modify uplink state on interface up/down

Russell King (1):
      ARM: dts: armada-38x: fix NETA lockup when repeatedly switching speeds

Sagi Grimberg (1):
      nvme-tcp: fix possible hang waiting for icresp response

Sami Tolvanen (1):
      arm64/alternatives: move length validation inside the subsection

Sasha Levin (1):
      sunrpc: check that domain table is empty at module unload.

Steffen Klassert (1):
      xfrm: Fix crash when the hold queue is used.

Steve Cohen (1):
      drm: hold gem reference until object is no longer accessed

Taehee Yoo (1):
      vxlan: fix memleak of fdb

Takashi Iwai (1):
      ALSA: hda/hdmi: Fix keep_power assignment for non-component devices

Tanner Love (3):
      selftests/net: rxtimestamp: fix clang issues for target arch PowerPC
      selftests/net: psock_fanout: fix clang issues for target arch PowerPC
      selftests/net: so_txtime: fix clang issues for target arch PowerPC

Thomas Falcon (1):
      ibmvnic: Fix IRQ mapping disposal in error path

Thomas Gleixner (1):
      x86/i8259: Use printk_deferred() to prevent deadlock

Wang Hai (2):
      9p/trans_fd: Fix concurrency del of req_list in p9_fd_cancelled/p9_read_work
      net: gemini: Fix missing clk_disable_unprepare() in error path of gemini_ethernet_port_probe()

Wanpeng Li (1):
      KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled

Wei Li (1):
      perf tools: Fix record failure when mixed with ARM SPE event

Will Deacon (2):
      ARM: 8986/1: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints
      KVM: arm64: Don't inherit exec permission across page-table levels

Xie He (1):
      drivers/net/wan: lapb: Corrected the usage of skb_cow

Xin Long (1):
      xfrm: policy: match with both mark and mask on user interfaces

Xin Xiong (1):
      net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq

Xiyu Yang (1):
      net/x25: Fix x25_neigh refcnt leak when x25 disconnect

Yonglong Liu (1):
      net: hns3: fix a TX timeout issue

Yoshihiro Shimoda (1):
      net: ethernet: ravb: exit if re-initialization fails in tx timeout

YueHaibing (1):
      net/x25: Fix null-ptr-deref in x25_disconnect

