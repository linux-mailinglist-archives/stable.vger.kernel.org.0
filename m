Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 888EBB8684
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406422AbfISWRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406408AbfISWRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFA5720678;
        Thu, 19 Sep 2019 22:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931420;
        bh=KjtcPokF5YfGudXOW3voBAbB/UHjc6USXjI9lbi+fe4=;
        h=From:To:Cc:Subject:Date:From;
        b=HgEmDKVGaxF3t5H4aVVZSJmPDY0FlAdxD2j08qeB/gyFyjpN/NmKDWl7SN8+U8i0p
         hJ/icgQoWgaPMCJ8hz+k30SRHVNvNWA1lA8e6yFoo2/SfLhdwbNZmu0a0+HPvijzIk
         awj/EzGfogLpy5ub2beMq6+WmUu7NH+O0U3SmFIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/59] 4.14.146-stable review
Date:   Fri, 20 Sep 2019 00:03:15 +0200
Message-Id: <20190919214755.852282682@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.146-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.146-rc1
X-KernelTest-Deadline: 2019-09-21T21:48+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.146 release.
There are 59 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.146-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.146-rc1

Sean Young <sean@mess.org>
    media: technisat-usb2: break out of loop at end of buffer

Christoph Paasch <cpaasch@apple.com>
    tcp: Don't dequeue SYN/FIN-segments from write-queue

Christoph Paasch <cpaasch@apple.com>
    tcp: Reset send_head when removing skb from write-queue

Kees Cook <keescook@chromium.org>
    binfmt_elf: move brk out of mmap when doing direct loader exec

Jann Horn <jannh@google.com>
    floppy: fix usercopy direction

Nathan Chancellor <natechancellor@gmail.com>
    PCI: kirin: Fix section mismatch warning

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix race in increase_address_space()

Stuart Hayes <stuart.w.hayes@gmail.com>
    iommu/amd: Flush old domains in kdump kernel

Hillf Danton <hdanton@sina.com>
    keys: Fix missing null pointer check in request_key_auth_describe()

Tianyu Lan <Tianyu.Lan@microsoft.com>
    x86/hyper-v: Fix overflow bug in fill_gva_list()

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess: Don't leak the AC flags into __get_user() argument evaluation

Wenwen Wang <wenwen@cs.uga.edu>
    dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()

Wenwen Wang <wenwen@cs.uga.edu>
    dmaengine: ti: dma-crossbar: Fix a memory leak bug

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: seeq: Fix the function used to release some memory in an error handling path

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    tools/power turbostat: fix buffer overrun

Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
    tools/power x86_energy_perf_policy: Fix argument parsing

Ben Hutchings <ben@decadent.org.uk>
    tools/power x86_energy_perf_policy: Fix "uninitialized variable" warnings at -O2

YueHaibing <yuehaibing@huawei.com>
    amd-xgbe: Fix error path in xgbe_mod_init()

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops

Josh Hunt <johunt@akamai.com>
    perf/x86/intel: Restrict period on Nehalem

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: designware: Synchronize IRQs when unregistering slave client

Takashi Iwai <tiwai@suse.de>
    sky2: Disable MSI on yet another ASUS boards (P6Xxxx)

zhaoyang <huangzhaoyang@gmail.com>
    ARM: 8901/1: add a criteria for pfn_valid of arm

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: Use kzfree() to zero out the password

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: set domainName when a domain-key is used in multiuser

Marc Zyngier <maz@kernel.org>
    kallsyms: Don't let kallsyms_lookup_size_offset() fail on retrieving the first symbol

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2: Fix write regression

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2: Fix eof handling

Thomas Jarosch <thomas.jarosch@intra2net.com>
    netfilter: nf_conntrack_ftp: Fix debug output

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines

Prashant Malani <pmalani@chromium.org>
    r8152: Set memory to all 0xFFs on failed reg reads

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only read OGM2 tvlv_len after buffer len check

Doug Berger <opendmb@gmail.com>
    ARM: 8874/1: mm: only adjust sections of valid mm structures

Wenwen Wang <wenwen@cs.uga.edu>
    qed: Add cleanup in qed_slowpath_start()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Kconfig: Fix the reference to the IDT77105 Phy driver in the description of ATM_NICSTAR_USE_IDT77105

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix initialisation of I/O result struct in nfs_pgio_rpcsetup

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix return value in nfs_finish_open()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix return values for nfs4_file_open()

Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
    netfilter: xt_nfacct: Fix alignment mismatch in xt_nfacct_match_info

Phil Reid <preid@electromag.com.au>
    fpga: altera-ps-spi: Fix getting of optional confd gpio

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: use 32-bit index for tail calls

Faiz Abbas <faiz_abbas@ti.com>
    ARM: dts: dra74x: Fix iodelay configuration for mmc3

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix omap4 errata warning on other SoCs

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: fix lcgr instruction encoding

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix missing SYSC_HAS_RESET_STATUS for dra7 epwmss

Masashi Honma <masashi.honma@gmail.com>
    nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds

Wen Huang <huangwenabc@gmail.com>
    mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_settings

Razvan Stefanescu <razvan.stefanescu@microchip.com>
    tty/serial: atmel: reschedule TX after RX was started

Chunyan Zhang <chunyan.zhang@unisoc.com>
    serial: sprd: correct the wrong sequence of arguments

Hung-Te Lin <hungte@chromium.org>
    firmware: google: check if size is valid when decoding VPD data

Matt Delco <delco@chromium.org>
    KVM: coalesced_mmio: add bounds checking

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: let qdisc_put() accept NULL pointer

Dongli Zhang <dongli.zhang@oracle.com>
    xen-netfront: do not assume sk_buff_head list is empty in error handling

Sean Young <sean@mess.org>
    media: tm6000: double free if usb disconnect while streaming

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current

Alan Stern <stern@rowland.harvard.edu>
    USB: usbcore: Fix slab-out-of-bounds bug during device reset

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/radix: Use the right page size for vmemmap mapping

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Input: elan_i2c - remove Lenovo Legion Y7000 PnpID

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi          | 50 ++++++++++----------
 arch/arm/mach-omap2/omap4-common.c                 |  3 ++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  3 +-
 arch/arm/mm/init.c                                 |  8 +++-
 arch/powerpc/mm/pgtable-radix.c                    | 16 +++----
 arch/s390/net/bpf_jit_comp.c                       | 12 +++--
 arch/x86/events/amd/ibs.c                          | 13 +++--
 arch/x86/events/intel/core.c                       |  6 +++
 arch/x86/hyperv/mmu.c                              |  8 ++--
 arch/x86/include/asm/perf_event.h                  | 12 +++--
 arch/x86/include/asm/uaccess.h                     |  4 +-
 arch/x86/kernel/apic/io_apic.c                     |  8 +++-
 drivers/atm/Kconfig                                |  2 +-
 drivers/block/floppy.c                             |  4 +-
 drivers/dma/omap-dma.c                             |  4 +-
 drivers/dma/ti-dma-crossbar.c                      |  4 +-
 drivers/firmware/google/vpd.c                      |  4 +-
 drivers/firmware/google/vpd_decode.c               | 55 +++++++++++++---------
 drivers/firmware/google/vpd_decode.h               |  6 +--
 drivers/fpga/altera-ps-spi.c                       | 11 +++--
 drivers/hid/wacom_sys.c                            | 10 ++--
 drivers/hid/wacom_wac.c                            |  4 ++
 drivers/i2c/busses/i2c-designware-slave.c          |  1 +
 drivers/input/mouse/elan_i2c_core.c                |  2 +-
 drivers/iommu/amd_iommu.c                          | 40 ++++++++++++++--
 drivers/media/usb/dvb-usb/technisat-usb2.c         | 22 ++++-----
 drivers/media/usb/tm6000/tm6000-dvb.c              |  3 ++
 drivers/net/ethernet/amd/xgbe/xgbe-main.c          | 10 +++-
 drivers/net/ethernet/marvell/sky2.c                |  7 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  4 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |  7 +--
 drivers/net/usb/r8152.c                            |  5 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |  3 ++
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |  9 +++-
 drivers/net/xen-netfront.c                         |  2 +-
 drivers/pci/dwc/pcie-kirin.c                       |  4 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  2 +
 drivers/tty/serial/atmel_serial.c                  |  1 -
 drivers/tty/serial/sprd_serial.c                   |  2 +-
 drivers/usb/core/config.c                          | 12 +++--
 fs/binfmt_elf.c                                    | 11 +++++
 fs/cifs/connect.c                                  | 22 +++++++++
 fs/nfs/dir.c                                       |  2 +-
 fs/nfs/nfs4file.c                                  | 12 ++---
 fs/nfs/pagelist.c                                  |  2 +-
 fs/nfs/proc.c                                      |  7 ++-
 include/uapi/linux/netfilter/xt_nfacct.h           |  5 ++
 kernel/kallsyms.c                                  |  6 ++-
 net/batman-adv/bat_v_ogm.c                         | 18 ++++---
 net/ipv4/tcp.c                                     |  6 +--
 net/netfilter/nf_conntrack_ftp.c                   |  2 +-
 net/netfilter/xt_nfacct.c                          | 36 +++++++++-----
 net/sched/sch_generic.c                            |  3 ++
 net/wireless/nl80211.c                             |  4 +-
 security/keys/request_key_auth.c                   |  6 +++
 tools/power/x86/turbostat/turbostat.c              |  2 +-
 .../x86_energy_perf_policy.c                       | 28 ++++++-----
 virt/kvm/coalesced_mmio.c                          | 17 ++++---
 59 files changed, 391 insertions(+), 185 deletions(-)


