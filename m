Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B14FB864A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733246AbfISWTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733261AbfISWTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:19:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBA0F21920;
        Thu, 19 Sep 2019 22:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931589;
        bh=XFLyvk3X7L/rk8aX1CDa4wvtbM9wlKahjxAZFKTesKk=;
        h=From:To:Cc:Subject:Date:From;
        b=x6cOKHnCRtz4p/Wd0UaNAdJ1Ad8vj0+Ym+92d5bolgnRbwAsYy3A1UA3irUbSSsxh
         p4Gtv3wNZcZO6smOlVZImQrkwdt+BZJxwWXsTPXMeBcmpNO0elAYWKmnoQd6Y/kc1z
         LB0AFMMSgJlWRl507SMEP5Dn7fzizN80dRGX6DAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/74] 4.9.194-stable review
Date:   Fri, 20 Sep 2019 00:03:13 +0200
Message-Id: <20190919214800.519074117@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.194-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.194-rc1
X-KernelTest-Deadline: 2019-09-21T21:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.194 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.194-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.194-rc1

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    ARC: export "abort" for modules

Sean Young <sean@mess.org>
    media: technisat-usb2: break out of loop at end of buffer

Jann Horn <jannh@google.com>
    floppy: fix usercopy direction

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix race in increase_address_space()

Hillf Danton <hdanton@sina.com>
    keys: Fix missing null pointer check in request_key_auth_describe()

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

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops

Josh Hunt <johunt@akamai.com>
    perf/x86/intel: Restrict period on Nehalem

Takashi Iwai <tiwai@suse.de>
    sky2: Disable MSI on yet another ASUS boards (P6Xxxx)

zhaoyang <huangzhaoyang@gmail.com>
    ARM: 8901/1: add a criteria for pfn_valid of arm

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: Use kzfree() to zero out the password

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: set domainName when a domain-key is used in multiuser

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
    NFSv4: Fix return values for nfs4_file_open()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: use 32-bit index for tail calls

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix omap4 errata warning on other SoCs

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: fix lcgr instruction encoding

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix missing SYSC_HAS_RESET_STATUS for dra7 epwmss

Wen Huang <huangwenabc@gmail.com>
    mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_settings

Razvan Stefanescu <razvan.stefanescu@microchip.com>
    tty/serial: atmel: reschedule TX after RX was started

Chunyan Zhang <chunyan.zhang@unisoc.com>
    serial: sprd: correct the wrong sequence of arguments

Matt Delco <delco@chromium.org>
    KVM: coalesced_mmio: add bounds checking

Dongli Zhang <dongli.zhang@oracle.com>
    xen-netfront: do not assume sk_buff_head list is empty in error handling

Corey Minyard <cminyard@mvista.com>
    x86/boot: Add missing bootparam that breaks boot on some platforms

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/radix: Use the right page size for vmemmap mapping

Sean Young <sean@mess.org>
    media: tm6000: double free if usb disconnect while streaming

Alan Stern <stern@rowland.harvard.edu>
    USB: usbcore: Fix slab-out-of-bounds bug during device reset

Linus Torvalds <torvalds@linux-foundation.org>
    x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to silence GCC9 build warning

Jean Delvare <jdelvare@suse.de>
    nvmem: Use the same permissions for eeprom as for nvmem

Nishka Dasgupta <nishkadg.linux@gmail.com>
    drm/mediatek: mtk_drm_drv.c: Add of_node_put() before goto

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - HMAC SNOOP NO AFEU mode requires SW icv checking.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - Do not modify req->cryptlen on decryption.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix ECB algs ivsize

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - check data blocksize in ablkcipher.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix CTR alg blocksize

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - check AES key size

Muchun Song <smuchun@gmail.com>
    driver core: Fix use-after-free and double free on glue directory

Xiaolei Li <xiaolei.li@mediatek.com>
    mtd: rawnand: mtk: Fix wrongly assigned OOB buffer pointer issue

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: Don't yell about bad mmc phases when getting

Paul Burton <paul.burton@mips.com>
    MIPS: VDSO: Use same -m%-float cflag as the kernel proper

Paul Burton <paul.burton@mips.com>
    MIPS: VDSO: Prevent use of smp_processor_id()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: handle page fault in vmread

Fuqian Huang <huangfq.daxian@gmail.com>
    KVM: x86: work around leak of uninitialized stack contents

Thomas Huth <thuth@redhat.com>
    KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT ioctl

Yunfeng Ye <yeyunfeng@huawei.com>
    genirq: Prevent NULL pointer dereference in resend_irqs()

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix assertion failure during fsync and use of stale transaction

Kent Gibson <warthog618@gmail.com>
    gpio: fix line flag validation in lineevent_create

Kent Gibson <warthog618@gmail.com>
    gpio: fix line flag validation in linehandle_create

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "MIPS: SiByte: Enable swiotlb for SWARM, LittleSur and BigSur"

Yang Yingliang <yangyingliang@huawei.com>
    tun: fix use-after-free when register netdev failed

Xin Long <lucien.xin@gmail.com>
    tipc: add NULL pointer check before calling kfree_rcu

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR

Xin Long <lucien.xin@gmail.com>
    sctp: use transport pf_retrans in sctp_do_8_2_transport_strike

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero

Shmulik Ladkani <shmulik@metanetworks.com>
    net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    net: Fix null de-reference of device refcount

Eric Biggers <ebiggers@google.com>
    isdn/capi: check message length in capi_write()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ipv6: Fix the link time qualifier of 'ping_v6_proc_exit_net()'

Bjørn Mork <bjorn@mork.no>
    cdc_ether: fix rndis support for Mediatek based smartphones

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    bridge/mdb: remove wrong use of NLM_F_MULTI


-------------

Diffstat:

 Makefile                                       |  4 +-
 arch/arc/kernel/traps.c                        |  1 +
 arch/arm/mach-omap2/omap4-common.c             |  3 ++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c      |  3 +-
 arch/arm/mm/init.c                             |  8 ++-
 arch/mips/Kconfig                              |  3 --
 arch/mips/include/asm/smp.h                    | 12 ++++-
 arch/mips/sibyte/common/Makefile               |  1 -
 arch/mips/sibyte/common/dma.c                  | 14 ------
 arch/mips/vdso/Makefile                        |  4 +-
 arch/powerpc/mm/pgtable-radix.c                | 16 +++---
 arch/s390/kvm/interrupt.c                      | 10 ++++
 arch/s390/kvm/kvm-s390.c                       |  2 +-
 arch/s390/net/bpf_jit_comp.c                   | 12 +++--
 arch/x86/Makefile                              |  1 +
 arch/x86/events/amd/ibs.c                      | 13 +++--
 arch/x86/events/intel/core.c                   |  6 +++
 arch/x86/include/asm/bootparam_utils.h         |  1 +
 arch/x86/include/asm/perf_event.h              | 12 +++--
 arch/x86/include/asm/uaccess.h                 |  4 +-
 arch/x86/kernel/apic/io_apic.c                 |  8 ++-
 arch/x86/kvm/vmx.c                             |  7 ++-
 arch/x86/kvm/x86.c                             |  7 +++
 drivers/atm/Kconfig                            |  2 +-
 drivers/base/core.c                            | 53 +++++++++++++++++++-
 drivers/block/floppy.c                         |  4 +-
 drivers/clk/rockchip/clk-mmc-phase.c           |  4 +-
 drivers/crypto/talitos.c                       | 67 +++++++++++++++++++-------
 drivers/dma/omap-dma.c                         |  4 +-
 drivers/dma/ti-dma-crossbar.c                  |  4 +-
 drivers/gpio/gpiolib.c                         | 20 +++++---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c         |  5 +-
 drivers/iommu/amd_iommu.c                      | 16 ++++--
 drivers/isdn/capi/capi.c                       | 10 +++-
 drivers/media/usb/dvb-usb/technisat-usb2.c     | 22 ++++-----
 drivers/media/usb/tm6000/tm6000-dvb.c          |  3 ++
 drivers/mtd/nand/mtk_nand.c                    | 21 ++++----
 drivers/net/ethernet/marvell/sky2.c            |  7 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c     |  4 +-
 drivers/net/ethernet/seeq/sgiseeq.c            |  7 +--
 drivers/net/tun.c                              | 16 ++++--
 drivers/net/usb/cdc_ether.c                    | 13 +++--
 drivers/net/usb/r8152.c                        |  5 +-
 drivers/net/wireless/marvell/mwifiex/ie.c      |  3 ++
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c |  9 +++-
 drivers/net/xen-netfront.c                     |  2 +-
 drivers/nvmem/core.c                           | 15 ++++--
 drivers/tty/serial/atmel_serial.c              |  1 -
 drivers/tty/serial/sprd_serial.c               |  2 +-
 drivers/usb/core/config.c                      | 12 +++--
 fs/btrfs/tree-log.c                            |  8 +--
 fs/cifs/connect.c                              | 22 +++++++++
 fs/nfs/nfs4file.c                              | 12 ++---
 fs/nfs/pagelist.c                              |  2 +-
 fs/nfs/proc.c                                  |  7 ++-
 include/uapi/linux/isdn/capicmd.h              |  1 +
 kernel/irq/resend.c                            |  2 +
 net/batman-adv/bat_v_ogm.c                     | 18 ++++---
 net/bridge/br_mdb.c                            |  2 +-
 net/core/dev.c                                 |  2 +
 net/core/skbuff.c                              | 19 ++++++++
 net/ipv4/tcp_input.c                           |  2 +-
 net/ipv6/ping.c                                |  2 +-
 net/netfilter/nf_conntrack_ftp.c               |  2 +-
 net/sched/sch_hhf.c                            |  2 +-
 net/sctp/protocol.c                            |  2 +-
 net/sctp/sm_sideeffect.c                       |  2 +-
 net/tipc/name_distr.c                          |  3 +-
 security/keys/request_key_auth.c               |  6 +++
 tools/power/x86/turbostat/turbostat.c          |  2 +-
 virt/kvm/coalesced_mmio.c                      | 17 ++++---
 71 files changed, 446 insertions(+), 172 deletions(-)


