Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8AF2A1711
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgJaLuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbgJaLuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:50:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C9132065D;
        Sat, 31 Oct 2020 11:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604145017;
        bh=W7tFnHV1bs8QssURgsPFFaR/AI6ebPkvTvqciVOcqUk=;
        h=From:To:Cc:Subject:Date:From;
        b=VA5SgrI3ULlJhmGdHByU0AOh/oquLowj3e1QF/Sd3J7KCIdxh810XjuejuqJXxDvv
         2JX/ZCw+c9cxx9eo9+97vtHyexq8XCh8Emaazkxs65JsE1akyq8iBdw8VLm2DVUX+A
         HcF46lESfevbYWRPcWpQLx0YSBnI8CmIsiFUpMOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/48] 5.4.74-rc2 review
Date:   Sat, 31 Oct 2020 12:51:00 +0100
Message-Id: <20201031114242.348422479@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.74-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.74-rc2
X-KernelTest-Deadline: 2020-11-02T11:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.74 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 02 Nov 2020 11:42:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.74-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.74-rc2

Pali Rohár <pali@kernel.org>
    phy: marvell: comphy: Convert internal SMCC firmware return codes to errno

Ricky Wu <ricky_wu@realtek.com>
    misc: rtsx: do not setting OC_POWER_DOWN reg in rtsx_pci_init_ocp()

Stafford Horne <shorne@gmail.com>
    openrisc: Fix issue with get_user for 64-bit values

Arnd Bergmann <arnd@arndb.de>
    crypto: x86/crc32c - fix building with clang ias

Souptick Joarder <jrdr.linux@gmail.com>
    xen/gntdev.c: Mark pages as dirty

Geert Uytterhoeven <geert+renesas@glider.be>
    ata: sata_rcar: Fix DMA boundary mask

Grygorii Strashko <grygorii.strashko@ti.com>
    PM: runtime: Fix timer_expires data type on 32-bit arches

Peter Zijlstra <peterz@infradead.org>
    serial: pl011: Fix lockdep splat when handling magic-sysrq interrupt

Paras Sharma <parashar@codeaurora.org>
    serial: qcom_geni_serial: To correct QUP Version detection logic

Gustavo A. R. Silva <gustavo@embeddedor.com>
    mtd: lpddr: Fix bad logic in print_drs_error

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/addr: Fix race with netevent_callback()/rdma_addr_cancel()

Frederic Barrat <fbarrat@linux.ibm.com>
    cxl: Rework error message for incompatible slots

Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
    p54: avoid accessing the data mapped to streaming DMA

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Check size of security.evm before using it

Song Liu <songliubraving@fb.com>
    bpf: Fix comment for helper bpf_current_task_under_cgroup()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix page dereference after free

Pali Rohár <pali@kernel.org>
    ata: ahci: mvebu: Make SATA PHY optional for Armada 3720

Juergen Gross <jgross@suse.com>
    x86/xen: disable Firmware First mode for correctable memory errors

Kim Phillips <kim.phillips@amd.com>
    arch/x86/amd/ibs: Fix re-arming IBS Fetch

Gao Xiang <hsiangkao@redhat.com>
    erofs: avoid duplicated permission check for "trusted." xattrs

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Invoke cancel_delayed_work_sync() for PFs also.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix regression in workqueue cleanup logic in bnxt_remove_one().

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Re-write PCI BARs after PCI fatal error.

Zenghui Yu <yuzenghui@huawei.com>
    net: hns3: Clear the CMDQ registers before unmapping BAR region

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix memory leak caused by tipc_buf_append()

Arjun Roy <arjunroy@google.com>
    tcp: Prevent low rmem stalls with SO_RCVLOWAT.

Andrew Gabbasov <andrew_gabbasov@mentor.com>
    ravb: Fix bit fields checking in ravb_hwtstamp_get()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix issue with forced threading in combination with shared interrupts

Guillaume Nault <gnault@redhat.com>
    net/sched: act_mpls: Add softdep on mpls_gso.ko

Aleksandr Nogikh <nogikh@google.com>
    netem: fix zero division in tabledist

Ido Schimmel <idosch@nvidia.com>
    mlxsw: core: Fix memory leak on module removal

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix ibmvnic_set_mac

Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
    gtp: fix an use-before-init in gtp_newlink()

Raju Rangoju <rajur@chelsio.com>
    cxgb4: set up filter action after rewrites

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix tls record info to user

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix memory leaks in CPL handlers

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix deadlock issue

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Send HWRM_FUNC_RESET fw command unconditionally.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Check abort error state in bnxt_open_nic().

Michael Schaller <misch@google.com>
    efivarfs: Replace invalid slashes with exclamation marks in dentries.

Randy Dunlap <rdunlap@infradead.org>
    x86/PCI: Fix intel_mid_pci.c build error when ACPI is not enabled

Nick Desaulniers <ndesaulniers@google.com>
    arm64: link with -z norelro regardless of CONFIG_RELOCATABLE

Marc Zyngier <maz@kernel.org>
    arm64: Run ARCH_WORKAROUND_2 enabling code on all CPUs

Marc Zyngier <maz@kernel.org>
    arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    scripts/setlocalversion: make git describe output more reliable

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support Clang non-section symbols in ORC generation

Christian Eggers <ceggers@arri.de>
    socket: don't clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled

Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
    netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/Makefile                                |  4 +-
 arch/arm64/kernel/cpu_errata.c                     | 15 ++++++
 arch/openrisc/include/asm/uaccess.h                | 35 +++++++++-----
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |  2 +-
 arch/x86/events/amd/ibs.c                          | 15 +++++-
 arch/x86/pci/intel_mid_pci.c                       |  1 +
 arch/x86/xen/enlighten_pv.c                        |  9 ++++
 drivers/ata/ahci.h                                 |  2 +
 drivers/ata/ahci_mvebu.c                           |  2 +-
 drivers/ata/libahci_platform.c                     |  2 +-
 drivers/ata/sata_rcar.c                            |  2 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            | 29 +++++------
 drivers/crypto/chelsio/chtls/chtls_io.c            |  7 ++-
 drivers/infiniband/core/addr.c                     | 11 ++---
 drivers/misc/cardreader/rtsx_pcr.c                 |  4 --
 drivers/misc/cxl/pci.c                             |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 45 ++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  | 56 +++++++++++-----------
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h        |  4 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  8 +++-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  2 +
 drivers/net/ethernet/realtek/r8169_main.c          |  4 +-
 drivers/net/ethernet/renesas/ravb_main.c           | 10 ++--
 drivers/net/gtp.c                                  | 16 +++----
 drivers/net/wireless/intersil/p54/p54pci.c         |  4 +-
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c       | 14 ++++--
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c       | 14 ++++--
 drivers/tty/serial/amba-pl011.c                    | 11 +++--
 drivers/tty/serial/qcom_geni_serial.c              |  2 +-
 drivers/xen/gntdev.c                               | 17 +++++--
 fs/efivarfs/super.c                                |  3 ++
 fs/erofs/xattr.c                                   |  2 -
 fs/fuse/dev.c                                      | 28 +++++++----
 include/linux/mtd/pfow.h                           |  2 +-
 include/linux/pm.h                                 |  2 +-
 include/linux/qcom-geni-se.h                       |  3 ++
 include/net/netfilter/nf_tables.h                  |  6 +++
 include/uapi/linux/bpf.h                           |  4 +-
 net/core/sock.c                                    |  1 -
 net/ipv4/tcp.c                                     |  2 +
 net/ipv4/tcp_input.c                               |  3 +-
 net/netfilter/nf_tables_api.c                      |  6 +--
 net/netfilter/nf_tables_offload.c                  |  4 +-
 net/sched/act_mpls.c                               |  1 +
 net/sched/sch_netem.c                              |  9 +++-
 net/tipc/msg.c                                     |  5 +-
 scripts/setlocalversion                            | 21 ++++++--
 security/integrity/evm/evm_main.c                  |  6 +++
 tools/include/uapi/linux/bpf.h                     |  4 +-
 tools/objtool/orc_gen.c                            | 33 ++++++++++---
 53 files changed, 331 insertions(+), 172 deletions(-)


