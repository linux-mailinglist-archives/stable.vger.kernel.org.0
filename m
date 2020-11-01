Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B092A1DA6
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 12:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgKALoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 06:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgKALoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 06:44:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B78952084C;
        Sun,  1 Nov 2020 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604231056;
        bh=jmpQOf07cbza+nXlnWFb2FMcUubuLDfVHDkFOAGlhis=;
        h=From:To:Cc:Subject:Date:From;
        b=jwGUW22/UqdCNuDKzpPhsAD3X4Mv3ZfsxvkimeHA03SXZH0CMHzBJj9ZIDB+dHOsN
         uHxRyruhZlduXrJ4lcsbZWEmSLn+SJIGHPZeGnTAy9i1Ix9L6PjgBO6iH8sY/UtI2d
         +mpa7/RCIToi7pHvjMHKDKgP41v8fCGi1ja1wsPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.74
Date:   Sun,  1 Nov 2020 12:44:58 +0100
Message-Id: <160423109766120@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.74 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 arch/arm64/Makefile                                       |    4 -
 arch/arm64/kernel/cpu_errata.c                            |   15 +++
 arch/openrisc/include/asm/uaccess.h                       |   35 +++++---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S                 |    2 
 arch/x86/events/amd/ibs.c                                 |   15 +++
 arch/x86/pci/intel_mid_pci.c                              |    1 
 arch/x86/xen/enlighten_pv.c                               |    9 ++
 drivers/ata/ahci.h                                        |    2 
 drivers/ata/ahci_mvebu.c                                  |    2 
 drivers/ata/libahci_platform.c                            |    2 
 drivers/ata/sata_rcar.c                                   |    2 
 drivers/crypto/chelsio/chtls/chtls_cm.c                   |   29 +++----
 drivers/crypto/chelsio/chtls/chtls_io.c                   |    7 +
 drivers/infiniband/core/addr.c                            |   11 +-
 drivers/misc/cardreader/rtsx_pcr.c                        |    4 -
 drivers/misc/cxl/pci.c                                    |    4 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 |   45 +++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                 |    1 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c         |   56 ++++++--------
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h               |    4 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |    2 
 drivers/net/ethernet/ibm/ibmvnic.c                        |    8 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c                |    2 
 drivers/net/ethernet/realtek/r8169_main.c                 |    4 -
 drivers/net/ethernet/renesas/ravb_main.c                  |   10 +-
 drivers/net/gtp.c                                         |   16 ++--
 drivers/net/wireless/intersil/p54/p54pci.c                |    4 -
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c              |   14 ++-
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c              |   14 ++-
 drivers/tty/serial/amba-pl011.c                           |   11 +-
 drivers/tty/serial/qcom_geni_serial.c                     |    2 
 drivers/xen/gntdev.c                                      |   17 +++-
 fs/efivarfs/super.c                                       |    3 
 fs/erofs/xattr.c                                          |    2 
 fs/fuse/dev.c                                             |   28 ++++---
 include/linux/mtd/pfow.h                                  |    2 
 include/linux/pm.h                                        |    2 
 include/linux/qcom-geni-se.h                              |    3 
 include/net/netfilter/nf_tables.h                         |    6 +
 include/uapi/linux/bpf.h                                  |    4 -
 net/core/sock.c                                           |    1 
 net/ipv4/tcp.c                                            |    2 
 net/ipv4/tcp_input.c                                      |    3 
 net/netfilter/nf_tables_api.c                             |    6 -
 net/netfilter/nf_tables_offload.c                         |    4 -
 net/sched/act_mpls.c                                      |    1 
 net/sched/sch_netem.c                                     |    9 ++
 net/tipc/msg.c                                            |    5 -
 scripts/setlocalversion                                   |   21 ++++-
 security/integrity/evm/evm_main.c                         |    6 +
 tools/include/uapi/linux/bpf.h                            |    4 -
 tools/objtool/orc_gen.c                                   |   33 ++++++--
 53 files changed, 330 insertions(+), 171 deletions(-)

Aleksandr Nogikh (1):
      netem: fix zero division in tabledist

Andrew Gabbasov (1):
      ravb: Fix bit fields checking in ravb_hwtstamp_get()

Arjun Roy (1):
      tcp: Prevent low rmem stalls with SO_RCVLOWAT.

Arnd Bergmann (1):
      crypto: x86/crc32c - fix building with clang ias

Christian Eggers (1):
      socket: don't clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled

Frederic Barrat (1):
      cxl: Rework error message for incompatible slots

Gao Xiang (1):
      erofs: avoid duplicated permission check for "trusted." xattrs

Geert Uytterhoeven (1):
      ata: sata_rcar: Fix DMA boundary mask

Greg Kroah-Hartman (1):
      Linux 5.4.74

Grygorii Strashko (1):
      PM: runtime: Fix timer_expires data type on 32-bit arches

Guillaume Nault (1):
      net/sched: act_mpls: Add softdep on mpls_gso.ko

Gustavo A. R. Silva (1):
      mtd: lpddr: Fix bad logic in print_drs_error

Heiner Kallweit (1):
      r8169: fix issue with forced threading in combination with shared interrupts

Ido Schimmel (1):
      mlxsw: core: Fix memory leak on module removal

Jason Gunthorpe (1):
      RDMA/addr: Fix race with netevent_callback()/rdma_addr_cancel()

Jia-Ju Bai (1):
      p54: avoid accessing the data mapped to streaming DMA

Josh Poimboeuf (1):
      objtool: Support Clang non-section symbols in ORC generation

Juergen Gross (1):
      x86/xen: disable Firmware First mode for correctable memory errors

Kim Phillips (1):
      arch/x86/amd/ibs: Fix re-arming IBS Fetch

Lijun Pan (1):
      ibmvnic: fix ibmvnic_set_mac

Marc Zyngier (2):
      arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs
      arm64: Run ARCH_WORKAROUND_2 enabling code on all CPUs

Masahiro Fujiwara (1):
      gtp: fix an use-before-init in gtp_newlink()

Michael Chan (1):
      bnxt_en: Check abort error state in bnxt_open_nic().

Michael Schaller (1):
      efivarfs: Replace invalid slashes with exclamation marks in dentries.

Miklos Szeredi (1):
      fuse: fix page dereference after free

Nick Desaulniers (1):
      arm64: link with -z norelro regardless of CONFIG_RELOCATABLE

Pali Rohár (2):
      ata: ahci: mvebu: Make SATA PHY optional for Armada 3720
      phy: marvell: comphy: Convert internal SMCC firmware return codes to errno

Paras Sharma (1):
      serial: qcom_geni_serial: To correct QUP Version detection logic

Peter Zijlstra (1):
      serial: pl011: Fix lockdep splat when handling magic-sysrq interrupt

Raju Rangoju (1):
      cxgb4: set up filter action after rewrites

Randy Dunlap (1):
      x86/PCI: Fix intel_mid_pci.c build error when ACPI is not enabled

Rasmus Villemoes (1):
      scripts/setlocalversion: make git describe output more reliable

Ricky Wu (1):
      misc: rtsx: do not setting OC_POWER_DOWN reg in rtsx_pci_init_ocp()

Roberto Sassu (1):
      evm: Check size of security.evm before using it

Saeed Mirzamohammadi (1):
      netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create

Song Liu (1):
      bpf: Fix comment for helper bpf_current_task_under_cgroup()

Souptick Joarder (1):
      xen/gntdev.c: Mark pages as dirty

Stafford Horne (1):
      openrisc: Fix issue with get_user for 64-bit values

Tung Nguyen (1):
      tipc: fix memory leak caused by tipc_buf_append()

Vasundhara Volam (4):
      bnxt_en: Send HWRM_FUNC_RESET fw command unconditionally.
      bnxt_en: Re-write PCI BARs after PCI fatal error.
      bnxt_en: Fix regression in workqueue cleanup logic in bnxt_remove_one().
      bnxt_en: Invoke cancel_delayed_work_sync() for PFs also.

Vinay Kumar Yadav (3):
      chelsio/chtls: fix deadlock issue
      chelsio/chtls: fix memory leaks in CPL handlers
      chelsio/chtls: fix tls record info to user

Zenghui Yu (1):
      net: hns3: Clear the CMDQ registers before unmapping BAR region

