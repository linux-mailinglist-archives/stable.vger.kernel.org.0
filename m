Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0D14A61AA
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 17:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbiBAQ46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 11:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241300AbiBAQ4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 11:56:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFFFC06173D;
        Tue,  1 Feb 2022 08:56:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7929F60C15;
        Tue,  1 Feb 2022 16:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86515C340EB;
        Tue,  1 Feb 2022 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643734610;
        bh=exH1m1t+KbG+5HYMWOzXGNgdlCWTQle6kCBIXdPfGUE=;
        h=From:To:Cc:Subject:Date:From;
        b=t10wv8BL1DUj7fWdi070C4V8Jz7OfVr08lHuLMKWSD5BFYW7BDQjaPyAvJp4yABwt
         vSnBDAYhQTZLuBjXQTFDr5QJfQUqtB4jmH31U6DQ9uEuafzrFtzGjH2wegp6Za899m
         0B+Fq29bwXDCeuD3QDaIJri35KdMSEwFJBy7v4/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.96
Date:   Tue,  1 Feb 2022 17:56:42 +0100
Message-Id: <164373460220625@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.96 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/can/tcan4x5x.txt    |    2 
 Makefile                                                  |    2 
 arch/arm64/kernel/process.c                               |   39 --
 arch/powerpc/include/asm/book3s/32/mmu-hash.h             |    2 
 arch/powerpc/include/asm/ppc-opcode.h                     |    1 
 arch/powerpc/kernel/Makefile                              |    1 
 arch/powerpc/lib/Makefile                                 |    3 
 arch/powerpc/mm/book3s32/mmu.c                            |   15 
 arch/powerpc/mm/kasan/book3s_32.c                         |   59 +--
 arch/powerpc/net/bpf_jit_comp64.c                         |   22 -
 arch/powerpc/perf/core-book3s.c                           |   17 
 arch/s390/hypfs/hypfs_vm.c                                |    6 
 arch/s390/kernel/module.c                                 |   37 +-
 arch/x86/events/intel/uncore_snbep.c                      |    2 
 arch/x86/kernel/cpu/mce/amd.c                             |    2 
 arch/x86/kvm/svm/svm.c                                    |    7 
 arch/x86/kvm/x86.c                                        |    1 
 block/bio.c                                               |    3 
 drivers/firmware/efi/efi.c                                |    7 
 drivers/firmware/efi/libstub/arm64-stub.c                 |    6 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c              |    4 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c               |   11 
 drivers/gpu/drm/msm/dsi/dsi.c                             |    7 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c                     |    4 
 drivers/gpu/drm/msm/hdmi/hdmi.c                           |    7 
 drivers/gpu/drm/msm/msm_drv.c                             |    2 
 drivers/hwmon/lm90.c                                      |    7 
 drivers/media/platform/qcom/venus/core.c                  |    2 
 drivers/mtd/nand/raw/mpc5121_nfc.c                        |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |    3 
 drivers/net/ethernet/ibm/ibmvnic.c                        |  112 +++---
 drivers/net/ethernet/intel/i40e/i40e.h                    |    9 
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c            |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c               |   44 +-
 drivers/net/ethernet/intel/i40e/i40e_register.h           |    3 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c        |  103 +++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h        |    1 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c      |    7 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |   20 -
 drivers/net/ethernet/ti/cpsw_priv.c                       |    2 
 drivers/net/hamradio/yam.c                                |    4 
 drivers/net/phy/broadcom.c                                |    1 
 drivers/net/phy/phy_device.c                              |    6 
 drivers/net/phy/sfp-bus.c                                 |    5 
 drivers/rpmsg/rpmsg_char.c                                |   22 -
 drivers/s390/scsi/zfcp_fc.c                               |   13 
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                         |   20 -
 drivers/tty/n_gsm.c                                       |    4 
 drivers/tty/serial/8250/8250_of.c                         |   11 
 drivers/tty/serial/8250/8250_pci.c                        |  100 +++++
 drivers/tty/serial/stm32-usart.c                          |    2 
 drivers/usb/common/ulpi.c                                 |    7 
 drivers/usb/core/hcd.c                                    |   14 
 drivers/usb/core/urb.c                                    |   12 
 drivers/usb/gadget/function/f_sourcesink.c                |    1 
 drivers/usb/host/xhci-plat.c                              |    3 
 drivers/usb/storage/unusual_devs.h                        |   10 
 drivers/usb/typec/tcpm/tcpm.c                             |    3 
 drivers/usb/typec/ucsi/ucsi_ccg.c                         |    2 
 drivers/video/fbdev/hyperv_fb.c                           |   16 
 fs/btrfs/ioctl.c                                          |    6 
 fs/ceph/file.c                                            |    9 
 fs/configfs/dir.c                                         |    6 
 fs/devpts/inode.c                                         |    2 
 fs/jbd2/journal.c                                         |    2 
 fs/namei.c                                                |   10 
 fs/nfs/dir.c                                              |   22 +
 fs/nfsd/nfsctl.c                                          |    5 
 fs/ocfs2/suballoc.c                                       |   25 -
 fs/udf/inode.c                                            |    9 
 include/linux/fsnotify.h                                  |   48 ++
 include/linux/netdevice.h                                 |    1 
 include/linux/perf_event.h                                |   15 
 include/linux/usb/role.h                                  |    6 
 include/net/addrconf.h                                    |    2 
 include/net/ip.h                                          |   21 -
 include/net/ip6_fib.h                                     |    2 
 include/net/route.h                                       |    2 
 kernel/bpf/stackmap.c                                     |    5 
 kernel/events/core.c                                      |  252 ++++++++------
 kernel/events/uprobes.c                                   |    2 
 kernel/locking/rtmutex.c                                  |    4 
 kernel/locking/rwsem.c                                    |    2 
 kernel/locking/semaphore.c                                |    2 
 kernel/power/wakelock.c                                   |   11 
 kernel/sched/fair.c                                       |   18 -
 kernel/sched/membarrier.c                                 |   11 
 kernel/sched/pelt.h                                       |    4 
 kernel/trace/trace.c                                      |    3 
 kernel/trace/trace_events_hist.c                          |    1 
 net/bluetooth/hci_event.c                                 |   10 
 net/bridge/br_vlan.c                                      |    9 
 net/core/net-procfs.c                                     |   38 +-
 net/ipv4/ip_output.c                                      |   41 +-
 net/ipv4/ping.c                                           |    3 
 net/ipv4/raw.c                                            |    5 
 net/ipv6/addrconf.c                                       |   27 +
 net/ipv6/ip6_fib.c                                        |   23 -
 net/ipv6/ip6_tunnel.c                                     |    8 
 net/ipv6/route.c                                          |    2 
 net/netfilter/nf_conntrack_core.c                         |    8 
 net/netfilter/nft_payload.c                               |    3 
 net/packet/af_packet.c                                    |    2 
 net/rxrpc/call_event.c                                    |    8 
 net/rxrpc/output.c                                        |    2 
 net/sunrpc/rpc_pipe.c                                     |    4 
 usr/include/Makefile                                      |    1 
 virt/kvm/kvm_main.c                                       |    1 
 108 files changed, 1014 insertions(+), 530 deletions(-)

Alan Stern (2):
      usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge
      USB: core: Fix hang in usb_kill_urb by adding memory barriers

Amir Goldstein (2):
      fsnotify: fix fsnotify hooks in pseudo filesystems
      fsnotify: invalidate dcache before IN_DELETE event

Ard Biesheuvel (1):
      efi: runtime: avoid EFIv2 runtime services on Apple x86 machines

Athira Rajeev (1):
      powerpc/perf: Fix power_pmu_disable to call clear_pmi_irq_pending only if PMI is pending

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Do not disconnect while receiving VBUS off

Brian Gix (1):
      Bluetooth: refactor malicious adv data check

Cameron Williams (1):
      tty: Add support for Brainboxes UC cards.

Christophe Leroy (3):
      powerpc/32s: Allocate one 256k IBAT instead of two consecutives 128k IBATs
      powerpc/32s: Fix kasan_init_region() for KASAN
      powerpc/32: Fix boot failure with GCC latent entropy plugin

Congyu Liu (1):
      net: fix information leakage in /proc/net/ptype

D Scott Phillips (1):
      arm64: errata: Fix exec handling in erratum 1418040 workaround

David Howells (1):
      rxrpc: Adjust retransmission backoff

Dmitry V. Levin (1):
      usr/include/Makefile: add linux/nfc.h to the compile-test coverage

Eric Dumazet (5):
      ipv4: avoid using shared IP generator for connected sockets
      ipv6: annotate accesses to fn->fn_sernum
      ipv4: raw: lock the socket in raw_bind()
      ipv4: tcp: send zero IPID in SYNACK messages
      ipv4: remove sparse error in ip_neigh_gw4()

Florian Westphal (1):
      netfilter: conntrack: don't increment invalid counter on NF_REPEAT

Frank Li (1):
      usb: xhci-plat: fix crash when suspend if remote wake enable

Geert Uytterhoeven (1):
      mtd: rawnand: mpc5121: Remove unused variable in ads5121_select_chip()

Greg Kroah-Hartman (2):
      PM: wakeup: simplify the output logic of pm_show_wakelocks()
      Linux 5.10.96

Guenter Roeck (4):
      hwmon: (lm90) Mark alert as broken for MAX6646/6647/6649
      hwmon: (lm90) Mark alert as broken for MAX6680
      hwmon: (lm90) Reduce maximum conversion rate for G781
      hwmon: (lm90) Mark alert as broken for MAX6654

Guillaume Nault (1):
      Revert "ipv6: Honor all IPv6 PIO Valid Lifetime values"

Hangyu Hua (1):
      yam: fix a memory leak in yam_siocdevprivate()

Ido Schimmel (1):
      ipv6_tunnel: Rate limit warning messages

Ilya Leoshkevich (1):
      s390/module: fix loading modules with a lot of relocations

Jakub Kicinski (1):
      ipv4: fix ip option filtering for locally generated fragments

Jan Kara (2):
      udf: Restore i_lenAlloc when inode expansion fails
      udf: Fix NULL ptr deref when converting from inline format

Jedrzej Jagielski (2):
      i40e: Increase delay to 1 s after global EMP reset
      i40e: Fix issue when maximum queues is exceeded

Jeff Layton (2):
      ceph: properly put ceph_string reference after async create attempt
      ceph: set pool_ns in new inode layout for async creates

Jianguo Wu (1):
      net-procfs: show net devices bound packet types

Joe Damato (1):
      i40e: fix unsigned stat widths

John Meneghini (1):
      scsi: bnx2fc: Flush destroy_work queue before calling bnx2fc_interface_put()

Jon Hunter (1):
      usb: common: ulpi: Fix crash in ulpi_match()

Joseph Qi (2):
      jbd2: export jbd2_journal_[grab|put]_journal_head
      ocfs2: fix a deadlock when commit trans

José Expósito (2):
      drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable
      drm/msm/dpu: invalid parameter check in dpu_setup_dspp_pcc

Karen Sornek (1):
      i40e: Fix for failed to init adminq while VF reset

Like Xu (1):
      KVM: x86: Update vCPU's runtime CPUID on write to MSR_IA32_XSS

Linyu Yuan (1):
      usb: roles: fix include/linux/usb/role.h compile issue

Lucas Stach (1):
      drm/etnaviv: relax submit size limits

Marc Kleine-Budde (1):
      dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config

Marek Behún (2):
      net: sfp: ignore disabled SFP node
      phylib: fix potential use-after-free

Mathieu Desnoyers (1):
      sched/membarrier: Fix membarrier-rseq fence command missing from query bitmask

Matthias Kaehlcke (1):
      rpmsg: char: Fix race between the release of rpmsg_eptdev and cdev

Miaoqian Lin (2):
      drm/msm/dsi: Fix missing put_device() call in dsi_get_phy
      drm/msm/hdmi: Fix missing put_device() call in msm_hdmi_get_phy

Michael Kelley (1):
      video: hyperv_fb: Fix validation of screen resolution

Mihai Carabas (1):
      efi/libstub: arm64: Fix image check alignment at entry

Mohammad Athari Bin Ismail (1):
      net: stmmac: skip only stmmac_ptp_register when resume from suspend

Naveen N. Rao (2):
      bpf: Guard against accessing NULL pt_regs in bpf_get_task_stack()
      powerpc64/bpf: Limit 'ldbrx' to processors compliant with ISA v2.06

Nikolay Aleksandrov (1):
      net: bridge: vlan: fix single net device option dumping

OGAWA Hirofumi (1):
      block: Fix wrong offset in bio_truncate()

Pablo Neira Ayuso (1):
      netfilter: nft_payload: do not update layer 4 checksum when mangling fragments

Pavankumar Kondeti (1):
      usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS

Peter Zijlstra (1):
      perf: Fix perf_event_read_local() time

Randy Dunlap (1):
      kernel: delete repeated words in comments

Robert Hancock (2):
      serial: 8250: of: Fix mapped region size when using reg-offset property
      net: phy: broadcom: hook up soft_reset for BCM54616S

Sean Christopherson (1):
      Revert "KVM: SVM: avoid infinite loop on NPF from bad address"

Sing-Han Chen (1):
      ucsi_ccg: Check DEV_INT bit only when starting CCG4

Stanimir Varbanov (1):
      media: venus: core: Drop second v4l2 device unregister

Steffen Maier (1):
      scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices

Subbaraya Sundeep (1):
      octeontx2-pf: Forward error codes to VF

Sujit Kautkar (1):
      rpmsg: char: Fix race between the release of rpmsg_ctrldev and cdev

Sukadev Bhattiprolu (2):
      ibmvnic: init ->running_cap_crqs early
      ibmvnic: don't spin in tasklet

Sylwester Dziedziuch (1):
      i40e: Fix queues reservation for XDP

Tim Yi (1):
      net: bridge: vlan: fix memory leak in __allowed_ingress

Toke Høiland-Jørgensen (1):
      net: cpsw: Properly initialise struct page_pool_params

Tom Zanussi (1):
      tracing: Don't inc err_log entry count if entry allocation fails

Trond Myklebust (4):
      NFSv4: Handle case where the lookup of a directory fails
      NFSv4: nfs_atomic_open() can race when looking up a non-regular file
      NFS: Ensure the server has an up to date ctime before hardlinking
      NFS: Ensure the server has an up to date ctime before renaming

Valentin Caron (1):
      serial: stm32: fix software flow control transfer

Vasily Gorbik (1):
      s390/hypfs: include z/VM guests with access control group set

Vincent Guittot (1):
      sched/pelt: Relax the sync of util_sum with util_avg

Xianting Tian (1):
      drm/msm: Fix wrong size calculation

Xiaoke Wang (1):
      tracing/histogram: Fix a potential memory leak for kstrdup()

Xin Long (1):
      ping: fix the sk_bound_dev_if match in ping_lookup

Yajun Deng (2):
      net: ipv4: Move ip_options_fragment() out of loop
      net: ipv4: Fix the warning for dereference

Yazen Ghannam (1):
      x86/MCE/AMD: Allow thresholding interface updates after init

Yufeng Mo (1):
      net: hns3: handle empty unknown interrupt for VF

Zhengjun Xing (1):
      perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX

daniel.starke@siemens.com (1):
      tty: n_gsm: fix SW flow control encoding/handling

