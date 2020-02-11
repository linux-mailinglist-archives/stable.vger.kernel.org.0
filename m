Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C535159CD6
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 00:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgBKXIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 18:08:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbgBKXIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Feb 2020 18:08:13 -0500
Received: from localhost (unknown [104.133.9.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 664F8206DB;
        Tue, 11 Feb 2020 23:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581462491;
        bh=oMdCMQSEt9FgSWFb4udtjdZefT2htUGoEeNXL/PJlgU=;
        h=Date:From:To:Cc:Subject:From;
        b=B/PwqtIm86g2tAYOd8RdAI0CkGLJzHfoSRWTfrHKGP0mFVxfsLCvJKcLbJrk6OMz3
         +OQTQc1nJ651HoxQ+wnBviD63pES2Ao9w7XhKp2jWDgCfRuY7TqsxD/Sz3mdsVGgUX
         iTTSwiIpBGRZ1Gls+1SQ+KWl5AU9ZiwNjplMBtcU=
Date:   Tue, 11 Feb 2020 15:08:10 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.103
Message-ID: <20200211230810.GA2257541@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.103 kernel.

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

 Makefile                                                  |    2=20
 arch/arm/include/asm/kvm_emulate.h                        |   22=20
 arch/arm/include/asm/kvm_mmio.h                           |    2=20
 arch/arm/mach-tegra/sleep-tegra30.S                       |   11=20
 arch/arm64/include/asm/kvm_emulate.h                      |   37=20
 arch/arm64/include/asm/kvm_mmio.h                         |    6=20
 arch/arm64/include/asm/ptrace.h                           |    1=20
 arch/arm64/include/uapi/asm/ptrace.h                      |    1=20
 arch/arm64/kvm/inject_fault.c                             |   70=20
 arch/mips/Makefile.postlink                               |    2=20
 arch/mips/boot/Makefile                                   |    2=20
 arch/powerpc/Kconfig                                      |    1=20
 arch/powerpc/boot/4xx.c                                   |    2=20
 arch/powerpc/kvm/book3s_hv.c                              |    4=20
 arch/powerpc/kvm/book3s_pr.c                              |    4=20
 arch/powerpc/platforms/pseries/hotplug-memory.c           |    4=20
 arch/powerpc/xmon/xmon.c                                  |    9=20
 arch/s390/include/asm/page.h                              |    2=20
 arch/s390/kvm/kvm-s390.c                                  |    6=20
 arch/s390/mm/hugetlbpage.c                                |  100=20
 arch/sparc/include/uapi/asm/ipcbuf.h                      |   22=20
 arch/x86/include/asm/apic.h                               |    8=20
 arch/x86/include/asm/kvm_host.h                           |    8=20
 arch/x86/kernel/apic/msi.c                                |  128=20
 arch/x86/kernel/cpu/tsx.c                                 |   13=20
 arch/x86/kvm/emulate.c                                    |   27=20
 arch/x86/kvm/hyperv.c                                     |   10=20
 arch/x86/kvm/i8259.c                                      |    6=20
 arch/x86/kvm/ioapic.c                                     |   15=20
 arch/x86/kvm/lapic.c                                      |   13=20
 arch/x86/kvm/mmu.c                                        |   78=20
 arch/x86/kvm/mmutrace.h                                   |   12=20
 arch/x86/kvm/mtrr.c                                       |    8=20
 arch/x86/kvm/paging_tmpl.h                                |   25=20
 arch/x86/kvm/pmu.h                                        |   18=20
 arch/x86/kvm/pmu_intel.c                                  |   24=20
 arch/x86/kvm/vmx.c                                        |    4=20
 arch/x86/kvm/vmx/vmx.c                                    | 8033 +++++++++=
+++++
 arch/x86/kvm/x86.c                                        |  101=20
 arch/x86/kvm/x86.h                                        |    2=20
 crypto/algapi.c                                           |   22=20
 crypto/api.c                                              |    3=20
 crypto/internal.h                                         |    1=20
 crypto/pcrypt.c                                           |    1=20
 drivers/acpi/battery.c                                    |   75=20
 drivers/acpi/video_detect.c                               |   13=20
 drivers/base/power/main.c                                 |   42=20
 drivers/clk/tegra/clk-tegra-periph.c                      |    6=20
 drivers/crypto/atmel-aes.c                                |   37=20
 drivers/crypto/ccp/ccp-dev-v3.c                           |    1=20
 drivers/crypto/ccree/cc_driver.h                          |    1=20
 drivers/crypto/ccree/cc_pm.c                              |   30=20
 drivers/crypto/ccree/cc_request_mgr.c                     |   51=20
 drivers/crypto/ccree/cc_request_mgr.h                     |    8=20
 drivers/crypto/geode-aes.c                                |  442=20
 drivers/crypto/geode-aes.h                                |   15=20
 drivers/crypto/picoxcell_crypto.c                         |   15=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |   13=20
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c            |    8=20
 drivers/gpu/drm/drm_dp_mst_topology.c                     |   12=20
 drivers/gpu/drm/drm_rect.c                                |    7=20
 drivers/gpu/drm/msm/disp/mdp4/mdp4_dsi_encoder.c          |    2=20
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                    |    3=20
 drivers/hv/hv_balloon.c                                   |   13=20
 drivers/infiniband/core/umem_odp.c                        |    2=20
 drivers/infiniband/hw/mlx5/gsi.c                          |    3=20
 drivers/md/bcache/bcache.h                                |    3=20
 drivers/md/bcache/request.c                               |   17=20
 drivers/md/bcache/sysfs.c                                 |   22=20
 drivers/md/dm-crypt.c                                     |   10=20
 drivers/md/dm-writecache.c                                |   41=20
 drivers/md/dm-zoned-metadata.c                            |   23=20
 drivers/md/dm.c                                           |    9=20
 drivers/md/persistent-data/dm-space-map-common.c          |   27=20
 drivers/md/persistent-data/dm-space-map-common.h          |    2=20
 drivers/md/persistent-data/dm-space-map-disk.c            |    6=20
 drivers/md/persistent-data/dm-space-map-metadata.c        |    5=20
 drivers/media/rc/iguanair.c                               |    2=20
 drivers/media/rc/rc-main.c                                |   27=20
 drivers/media/usb/uvc/uvc_driver.c                        |   12=20
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c             |  148=20
 drivers/media/v4l2-core/videobuf-dma-sg.c                 |    5=20
 drivers/mfd/axp20x.c                                      |    2=20
 drivers/mfd/da9062-core.c                                 |    2=20
 drivers/mfd/dln2.c                                        |   13=20
 drivers/mfd/rn5t618.c                                     |    1=20
 drivers/mmc/host/mmc_spi.c                                |   11=20
 drivers/mmc/host/sdhci-of-at91.c                          |    9=20
 drivers/mtd/ubi/fastmap.c                                 |   23=20
 drivers/net/bonding/bond_alb.c                            |   44=20
 drivers/net/dsa/b53/b53_common.c                          |    2=20
 drivers/net/dsa/bcm_sf2.c                                 |    4=20
 drivers/net/ethernet/broadcom/bcmsysport.c                |    3=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 |    2=20
 drivers/net/ethernet/cadence/macb_main.c                  |   14=20
 drivers/net/ethernet/dec/tulip/dmfe.c                     |    7=20
 drivers/net/ethernet/dec/tulip/uli526x.c                  |    4=20
 drivers/net/ethernet/marvell/mvneta.c                     |   27=20
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c      |    3=20
 drivers/net/ethernet/smsc/smc911x.c                       |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |    4=20
 drivers/net/gtp.c                                         |    4=20
 drivers/net/ppp/ppp_async.c                               |   18=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c    |    1=20
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c              |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c              |   10=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c          |    1=20
 drivers/nfc/pn544/pn544.c                                 |    2=20
 drivers/of/Kconfig                                        |    4=20
 drivers/of/address.c                                      |    6=20
 drivers/pci/controller/dwc/pci-keystone-dw.c              |    2=20
 drivers/pci/controller/pci-tegra.c                        |    2=20
 drivers/phy/qualcomm/phy-qcom-apq8064-sata.c              |    2=20
 drivers/platform/x86/intel_scu_ipc.c                      |   21=20
 drivers/power/supply/ltc2941-battery-gauge.c              |    2=20
 drivers/scsi/csiostor/csio_scsi.c                         |    2=20
 drivers/scsi/qla2xxx/qla_dbg.c                            |    6=20
 drivers/scsi/qla2xxx/qla_dbg.h                            |    6=20
 drivers/scsi/qla2xxx/qla_isr.c                            |   12=20
 drivers/scsi/qla2xxx/qla_mbx.c                            |    3=20
 drivers/scsi/qla2xxx/qla_nx.c                             |    7=20
 drivers/scsi/qla4xxx/ql4_os.c                             |    2=20
 drivers/scsi/ufs/ufshcd.c                                 |    3=20
 drivers/usb/gadget/function/f_ecm.c                       |   16=20
 drivers/usb/gadget/function/f_ncm.c                       |   17=20
 drivers/usb/gadget/legacy/cdc2.c                          |    2=20
 drivers/usb/gadget/legacy/g_ffs.c                         |    2=20
 drivers/usb/gadget/legacy/multi.c                         |    2=20
 drivers/usb/gadget/legacy/ncm.c                           |    2=20
 drivers/usb/typec/tcpci.c                                 |    6=20
 drivers/watchdog/watchdog_core.c                          |   35=20
 drivers/watchdog/watchdog_dev.c                           |   36=20
 drivers/xen/xen-balloon.c                                 |    2=20
 fs/aio.c                                                  |   20=20
 fs/btrfs/ctree.c                                          |    8=20
 fs/btrfs/ctree.h                                          |    6=20
 fs/btrfs/delayed-ref.c                                    |    8=20
 fs/btrfs/disk-io.c                                        |   22=20
 fs/btrfs/extent_io.c                                      |    8=20
 fs/btrfs/tests/btrfs-tests.c                              |    1=20
 fs/btrfs/transaction.c                                    |    8=20
 fs/btrfs/tree-log.c                                       |  388=20
 fs/cifs/smb2pdu.c                                         |   14=20
 fs/eventfd.c                                              |   15=20
 fs/ext2/super.c                                           |    6=20
 fs/ext4/page-io.c                                         |   19=20
 fs/f2fs/super.c                                           |   14=20
 fs/gfs2/file.c                                            |   72=20
 fs/jbd2/journal.c                                         |    1=20
 fs/nfs/dir.c                                              |   47=20
 fs/nfsd/nfs4layouts.c                                     |    2=20
 fs/nfsd/nfs4state.c                                       |    2=20
 fs/nfsd/state.h                                           |    2=20
 fs/nfsd/vfs.c                                             |    1=20
 fs/ocfs2/file.c                                           |   14=20
 fs/overlayfs/file.c                                       |    2=20
 fs/overlayfs/readdir.c                                    |    8=20
 fs/ubifs/dir.c                                            |    2=20
 fs/ubifs/file.c                                           |    4=20
 fs/ubifs/ioctl.c                                          |   11=20
 fs/udf/super.c                                            |    1=20
 include/linux/eventfd.h                                   |   14=20
 include/linux/irq.h                                       |   18=20
 include/linux/irqdomain.h                                 |    7=20
 include/linux/kvm_host.h                                  |    8=20
 include/linux/memblock.h                                  |   15=20
 include/linux/percpu-defs.h                               |    3=20
 include/media/v4l2-rect.h                                 |    8=20
 include/net/ipx.h                                         |    5=20
 ipc/msg.c                                                 |   19=20
 kernel/events/core.c                                      |   10=20
 kernel/irq/debugfs.c                                      |    1=20
 kernel/irq/irqdomain.c                                    |    1=20
 kernel/irq/msi.c                                          |    5=20
 kernel/module.c                                           |    2=20
 kernel/padata.c                                           |   46=20
 kernel/printk/printk.c                                    |    4=20
 kernel/rcu/tree_plugin.h                                  |   11=20
 kernel/time/alarmtimer.c                                  |    8=20
 kernel/time/clocksource.c                                 |   11=20
 kernel/trace/ftrace.c                                     |   15=20
 kernel/trace/trace.h                                      |   29=20
 kernel/trace/trace_sched_switch.c                         |    4=20
 lib/test_kasan.c                                          |    1=20
 mm/memory_hotplug.c                                       |    9=20
 mm/migrate.c                                              |   25=20
 mm/page_alloc.c                                           |   64=20
 net/hsr/hsr_slave.c                                       |    2=20
 net/ipv4/tcp.c                                            |    6=20
 net/l2tp/l2tp_core.c                                      |    7=20
 net/rxrpc/af_rxrpc.c                                      |    2=20
 net/rxrpc/ar-internal.h                                   |   11=20
 net/rxrpc/call_object.c                                   |    4=20
 net/rxrpc/conn_client.c                                   |    3=20
 net/rxrpc/conn_event.c                                    |   31=20
 net/rxrpc/conn_object.c                                   |    3=20
 net/rxrpc/input.c                                         |    6=20
 net/rxrpc/local_object.c                                  |   23=20
 net/rxrpc/output.c                                        |   27=20
 net/rxrpc/peer_event.c                                    |   42=20
 net/sched/cls_rsvp.h                                      |    6=20
 net/sched/cls_tcindex.c                                   |   43=20
 net/sunrpc/auth_gss/svcauth_gss.c                         |    4=20
 samples/bpf/Makefile                                      |    2=20
 scripts/find-unused-docs.sh                               |    2=20
 sound/drivers/dummy.c                                     |    2=20
 sound/pci/hda/hda_intel.c                                 |    2=20
 sound/usb/validate.c                                      |    6=20
 tools/kvm/kvm_stat/kvm_stat                               |    8=20
 virt/kvm/arm/aarch32.c                                    |  117=20
 virt/kvm/arm/mmio.c                                       |    6=20
 virt/kvm/async_pf.c                                       |   10=20
 virt/kvm/kvm_main.c                                       |    4=20
 213 files changed, 10302 insertions(+), 1569 deletions(-)

Alexander Lobakin (2):
      MIPS: fix indentation of the 'RELOCS' message
      MIPS: boot: fix typo in 'vmlinux.lzma.its' target

Amir Goldstein (1):
      ovl: fix wrong WARN_ON() in ovl_cache_update_ino()

Amol Grover (2):
      tracing: Annotate ftrace_graph_hash pointer with __rcu
      tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu

Anand Jain (1):
      btrfs: use bool argument in free_root_pointers()

Andreas Gruenbacher (1):
      gfs2: fix O_SYNC write handling

Andreas Kemnade (1):
      mfd: rn5t618: Mark ADC control register volatile

Ard Biesheuvel (1):
      crypto: ccp - set max RSA modulus size for v3 platform devices as well

Arnd Bergmann (4):
      sparc32: fix struct ipc64_perm type definition
      media: v4l2-core: compat: ignore native command codes
      nfsd: fix delay timer on 32-bit architectures
      nfsd: fix jiffies/time_t mixup in LRU list

Arun Easi (1):
      scsi: qla2xxx: Fix unbound NVME response length

Asutosh Das (1):
      scsi: ufs: Recheck bkops level if bkops is disabled

Bart Van Assche (1):
      scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return=
 type

Boris Ostrovsky (1):
      x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit

Brian Norris (1):
      mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Bryan O'Donoghue (2):
      usb: gadget: f_ncm: Use atomic_t to track in-flight request
      usb: gadget: f_ecm: Use atomic_t to track in-flight request

Chengguang Xu (3):
      f2fs: choose hardlimit when softlimit is larger than hardlimit in f2f=
s_statfs_project()
      f2fs: fix miscounted block limit in f2fs_statfs_project()
      f2fs: code cleanup for f2fs_statfs_project()

Christian Borntraeger (1):
      KVM: s390: do not clobber registers during guest reset/store status

Christoffer Dall (1):
      KVM: arm64: Only sign-extend MMIO up to register width

Christoph Hellwig (1):
      gfs2: move setting current->backing_dev_info

Chuhong Yuan (1):
      crypto: picoxcell - adjust the position of tasklet_init and fix misse=
d tasklet_kill

Claudiu Beznea (1):
      drm: atmel-hlcdc: enable clock before configuring timing engine

Coly Li (1):
      bcache: add readahead cache policy options via sysfs interface

Cong Wang (2):
      net_sched: fix an OOB access in cls_tcindex
      net_sched: fix a resource leak in tcindex_set_parms()

Dan Carpenter (1):
      ubi: Fix an error pointer dereference in error handling code

Dan Williams (1):
      mm/memory_hotplug: fix remove_memory() lockdep splat

David Engraf (1):
      PCI: tegra: Fix return value check of pm_runtime_get_sync()

David Hildenbrand (1):
      mm/page_alloc.c: fix uninitialized memmaps on a partially populated l=
ast section

David Howells (5):
      rxrpc: Fix use-after-free in rxrpc_put_local()
      rxrpc: Fix insufficient receive notification generation
      rxrpc: Fix missing active use pinning of rxrpc_local object
      rxrpc: Fix NULL pointer deref due to call->conn being cleared on disc=
onnect
      rxrpc: Fix service call disconnection

Dmitry Fomichev (1):
      dm zoned: support zone sizes smaller than 128MiB

Erdem Aktas (1):
      percpu: Separate decrypted varaibles anytime encryption can be enabled

Eric Biggers (4):
      ubifs: don't trigger assertion on invalid no-key filename
      ubifs: Fix FS_IOC_SETFLAGS unexpectedly clearing encrypt flag
      crypto: geode-aes - convert to skcipher API and make thread-safe
      ext4: fix deadlock allocating crypto bounce page from mempool

Eric Dumazet (8):
      cls_rsvp: fix rsvp_policy
      net: hsr: fix possible NULL deref in hsr_handle_frame()
      tcp: clear tp->total_retrans in tcp_disconnect()
      tcp: clear tp->delivered in tcp_disconnect()
      tcp: clear tp->data_segs{in|out} in tcp_disconnect()
      tcp: clear tp->segs_{in|out} in tcp_disconnect()
      rcu: Avoid data-race in rcu_gp_fqs_check_wake()
      bonding/alb: properly access headers in bond_alb_xmit()

Filipe Manana (2):
      Btrfs: fix missing hole after hole punching and fsync when using NO_H=
OLES
      Btrfs: fix race between adding and putting tree mod seq elements and =
nodes

Florian Fainelli (3):
      net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port
      net: systemport: Avoid RBUF stuck in Wake-on-LAN mode
      net: dsa: b53: Always use dev->vlan_enabled in b53_configure_vlan()

Gang He (1):
      ocfs2: fix oops when writing cloned file

Gavin Shan (1):
      tools/kvm_stat: Fix kvm_exit filter name

Geert Uytterhoeven (1):
      scripts/find-unused-docs: Fix massive false positives

Gerald Schaefer (1):
      s390/mm: fix dynamic pagetable upgrade for hugetlbfs

Gilad Ben-Yossef (3):
      crypto: ccree - fix backlog memory leak
      crypto: ccree - fix pm wrongful error reporting
      crypto: ccree - fix PM race condition

Greg Kroah-Hartman (1):
      Linux 4.19.103

Gustavo A. R. Silva (1):
      lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()

Hans de Goede (5):
      ALSA: hda: Add Clevo W65_67SB the power_save blacklist
      ACPI: video: Do not export a non working backlight interface on MSI M=
S-7721 boards
      ACPI / battery: Deal with design or full capacity being reported as -1
      ACPI / battery: Use design-cap for capacity calculations if full-cap =
is not available
      ACPI / battery: Deal better with neither design nor full capacity not=
 being reported

Harini Katakam (2):
      net: macb: Remove unnecessary alignment check for TSO
      net: macb: Limit maximum GEM TX length in TSO

Helen Koike (1):
      media: v4l2-rect.h: fix v4l2_rect_map_inside() top/left adjustments

Herbert Xu (4):
      crypto: api - Check spawn->alg under lock in crypto_drop_spawn
      padata: Remove broken queue flushing
      crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
      crypto: api - Fix race condition in crypto_spawn_alg

Hou Tao (1):
      ubifs: Reject unsupported ioctl flags explicitly

Icenowy Zheng (1):
      Revert "drm/sun4i: dsi: Change the start delay calculation"

Jan Kara (1):
      udf: Allow writing to 'Rewritable' partitions

Jens Axboe (2):
      eventfd: track eventfd_signal() recursion depth
      aio: prevent potential eventfd recursion on poll

Joe Thornber (1):
      dm space map common: fix to ensure new block isn't already in use

Johan Hovold (1):
      media: iguanair: fix endpoint sanity check

John Hubbard (1):
      media/v4l2-core: set pages dirty upon releasing DMA buffers

John Ogness (1):
      printk: fix exclusive_console replaying

Josef Bacik (3):
      btrfs: set trans->drity in btrfs_commit_transaction
      btrfs: free block groups after free'ing fs trees
      btrfs: flush write bio if we loop in extent_write_cache_pages

Juergen Gross (1):
      xen/balloon: Support xend-based toolstack take two

Jun Li (1):
      usb: typec: tcpci: mask event interrupts when remove driver

Kevin Hao (1):
      irqdomain: Fix a memory leak in irq_domain_push_irq()

Konstantin Khlebnikov (1):
      clocksource: Prevent double add_timer_on() for watchdog_timer

Linus Walleij (1):
      mmc: spi: Toggle SPI polarity, do not hardcode it

Lorenzo Bianconi (1):
      net: mvneta: move rx_dropped and rx_errors in per-cpu stats

Lu Shuaibing (1):
      ipc/msg.c: consolidate all xxxctl_down() functions

Luca Coelho (2):
      iwlwifi: mvm: fix NVM check for 3168 devices
      iwlwifi: don't throw error when trying to remove IGTK

Lyude Paul (1):
      drm/amd/dm/mst: Ignore payload update failures

Marco Felsch (1):
      mfd: da9062: Fix watchdog compatible string

Marios Pomonis (12):
      KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
      KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks
      KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks
      KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF at=
tacks
      KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks
      KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-v1/L=
1TF attacks
      KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-=
v1/L1TF attacks
      KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF a=
ttacks in x86.c
      KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
      KVM: x86: Protect MSR-based index computations in fixed_msr_to_seg_un=
it() from Spectre-v1/L1TF attacks

Mark Rutland (3):
      KVM: arm64: Correct PSTATE on exception entry
      KVM: arm/arm64: Correct CPSR on exception entry
      KVM: arm/arm64: Correct AArch32 SPSR on exception entry

Mathieu Desnoyers (1):
      tracing: Fix sched switch start/stop refcount racy updates

Miaohe Lin (1):
      KVM: nVMX: vmread should not set rflags to specify success in case of=
 #PF

Michael Chan (1):
      bnxt_en: Fix TC queue mapping.

Michael Ellerman (1):
      of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc

Micha=C5=82 Miros=C5=82aw (1):
      mmc: sdhci-of-at91: fix memleak on clk_get failure

Mika Westerberg (1):
      platform/x86: intel_scu_ipc: Fix interrupt support

Mike Snitzer (1):
      dm: fix potential for q->make_request_fn NULL pointer

Miklos Szeredi (1):
      ovl: fix lseek overflow on 32bit

Mikulas Patocka (1):
      dm writecache: fix incorrect flush sequence when doing SSD mode commit

Milan Broz (1):
      dm crypt: fix benbi IV constructor crash if used in authenticated mode

Naoya Horiguchi (1):
      mm: zero remaining unavailable struct pages

Nathan Chancellor (10):
      scsi: csiostor: Adjust indentation in csio_device_reset
      scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
      phy: qualcomm: Adjust indentation in read_poll_timeout
      ext2: Adjust indentation in ext2_fill_super
      powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize
      drm: msm: mdp4: Adjust indentation in mdp4_dsi_encoder_enable
      NFC: pn544: Adjust indentation in pn544_hci_check_presence
      ppp: Adjust indentation into ppp_async_input
      net: smc911x: Adjust indentation in smc911x_phy_configure
      net: tulip: Adjust indentation in {dmfe, uli526x}_init_module

Navid Emamdoost (1):
      brcmfmac: Fix memory leak in brcmf_usbdev_qinit

Nicolin Chen (1):
      net: stmmac: Delete txtimer in suspend()

Oliver Neukum (1):
      mfd: dln2: More sanity checking for endpoints

Pavel Tatashin (1):
      mm: return zero_resv_unavail optimization

Pawan Gupta (1):
      x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR

Pingfan Liu (1):
      powerpc/pseries: Advance pfn if section is not present in lmb_is_remo=
vable()

Prabhath Sajeepa (1):
      IB/mlx5: Fix outstanding_pi index for GSI qps

Quinn Tran (1):
      scsi: qla2xxx: Fix mtcp dump collection failure

Raed Salem (2):
      net/mlx5: IPsec, Fix esp modify function attribute
      net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx

Rafael J. Wysocki (1):
      PM: core: Fix handling of devices deleted during system-wide resume

Ridge Kennedy (1):
      l2tp: Allow duplicate session creation with UDP

Roberto Bergantinos Corpas (1):
      sunrpc: expiry_time should be seconds not timeval

Roger Quadros (1):
      usb: gadget: legacy: set max_speed to super-speed

Ronnie Sahlberg (1):
      cifs: fail i/o on soft mounts if sessionsetup errors out

Samuel Holland (1):
      mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as volatile

Sascha Hauer (1):
      ubi: fastmap: Fix inverted logic in seen selfcheck

Sean Christopherson (10):
      KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX platform
      KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
      KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
      KVM: x86: Don't let userspace set host-reserved cr4 bits
      KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
      KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM
      KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM
      KVM: VMX: Add non-canonical check on writes to RTIT address MSRs
      KVM: Use vcpu-specific gva->hva translation when querying host page s=
ize
      KVM: Play nice with read-only memslots when querying host page size

Sean Young (1):
      media: rc: ensure lirc is initialized before registering input device

Song Liu (1):
      perf/core: Fix mlock accounting in perf_mmap()

Stephen Boyd (1):
      alarmtimer: Unregister wakeup source when module get fails

Stephen Warren (2):
      ARM: tegra: Enable PLLP bypass during Tegra124 LP1
      clk: tegra: Mark fuse clock as critical

Steve French (1):
      smb3: fix signing verification of large reads

Steven Rostedt (VMware) (2):
      ftrace: Add comment to why rcu_dereference_sched() is open coded
      ftrace: Protect ftrace_graph_hash with ftrace_sync

Sukadev Bhattiprolu (1):
      powerpc/xmon: don't access ASDR in VMs

Sven Van Asbroeck (1):
      power: supply: ltc2941-battery-gauge: fix use-after-free

Taehee Yoo (1):
      gtp: use __GFP_NOWARN to avoid memalloc warning

Takashi Iwai (2):
      ALSA: usb-audio: Fix endianess in descriptor validation
      ALSA: dummy: Fix PCM format loop in proc output

Thomas Gleixner (1):
      x86/apic/msi: Plug non-maskable MSI affinity race

Tianyu Lan (1):
      hv_balloon: Balloon up according to request page number

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      samples/bpf: Don't try to remove user's homedir on clean

Trond Myklebust (3):
      NFS: Fix memory leaks and corruption in readdir
      NFS: Directory page cache pages need to be locked when read
      nfsd: Return the correct number of bytes written to the file

Tudor Ambarus (1):
      crypto: atmel-aes - Fix counter overflow in CTR mode

Vasily Averin (1):
      jbd2_seq_info_next should increase position index

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/rect: Avoid division by zero

Vladis Dronov (1):
      watchdog: fix UAF in reboot notifier handling in watchdog core code

Wayne Lin (1):
      drm/dp_mst: Remove VCPI while disabling topology mgr

Will Deacon (1):
      media: uvcvideo: Avoid cyclic entity chains due to malformed USB desc=
riptors

Yang Shi (1):
      mm: move_pages: report the number of non-attempted pages

Yishai Hadas (1):
      IB/core: Fix ODP get user pages flow

YueHaibing (1):
      kernel/module: Fix memleak in module_add_modinfo_attrs()

Yurii Monakov (1):
      PCI: keystone: Fix link training retries initiation

Zhihao Cheng (1):
      ubifs: Fix deadlock in concurrent bulk-read and writepage


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5DM9cACgkQONu9yGCS
aT62FQ/+Kauqc22ocaXvWISyGzGcwXRHUEvFPTdXkKyJoyK511BpbC5v8QhCc71J
WPq5iXhyZb4F0pOtDSlOriAYF0wJWWI63adZOvpDID9ux2MeyVNq863h0VJ27iIQ
PM5Mvha/zouhOm+x0eemO8vqVE3Jl8k2/Lvr/tNYTuM8bsI7tlgD+P1kP9Oiwhkw
G180klQ0MJmAHVua80izqBPEk5h0lNOFdj+T6F+Li2ZLNVjgbS8v6xhSweOT3Ghq
4RA9EHTxK3DuVFX4r1i3pEIWh++bQDtOIXCUEtJs3TG4BK7JG3denEyXzrsqWVHV
o1vZ+eMF+bQcZJviu2d1XuQbpBRwqAiWOH+uxwyAyIjFOcYxwKCU+ugdVAipFC7h
X4B3OGauf68kD45Ou9beBjNsmfVAy0u2kxW3lIjRl+a+oG6CXR+6ZfRAPmHnySs7
wB9Hy+Q0Y7eY/BdWxsfhp9Yz1y1oOvSVFOSAzkl7oKovjJi7C8sZstD+jcxo576z
rs94bfwk/rWyB6c8Gzw0zbM+Wvrx7VwhNkXvrQTmygpaGvVgYzUYU/nZFwlxmn0m
WLGarG4d4ZudvjEwTzXMln8bnY/WSILm6VRcBwE5Q4JLsQbBKJGW8nl3ipyGfGg7
7U0NpS/Otn+JCcaOXkBeczNz8gr7O5xLIhL0HJUoUA/nVBJj+ag=
=CK/R
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
