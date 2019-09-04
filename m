Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B439A8E11
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732995AbfIDRz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732878AbfIDRzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:55:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 206BD2339D;
        Wed,  4 Sep 2019 17:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619753;
        bh=JKHzinxG2gfTsdiNFEQmrlf9dwMXEcgy0K4k3/GhKak=;
        h=From:To:Cc:Subject:Date:From;
        b=xZgwI8RBmgkvG5ajvOjcYnyyaiWj/ZojuBiysWQlV6988v8pug+8XmkRcsPs0l6v+
         0uHoisSI5MdGtzrjzt1m6yjeI479UBc7xS6rYYBQZVqV0/s27pQeNoSxTzdkMPfvXQ
         m757ACFX7L8WR82VNCGtb3ef8stdIzvkdP/la9VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/77] 4.4.191-stable review
Date:   Wed,  4 Sep 2019 19:52:47 +0200
Message-Id: <20190904175303.317468926@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.191-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.191-rc1
X-KernelTest-Deadline: 2019-09-06T17:53+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.191 release.
There are 77 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.191-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.191-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    x86/ptrace: fix up botched merge of spectrev1 fix

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix possible sta leak

Hodaszi, Robert <Robert.Hodaszi@digi.com>
    Revert "cfg80211: fix processing world regdomain when non modular"

Nadav Amit <namit@vmware.com>
    VMCI: Release resource if the work is already queued

Ding Xiang <dingxiang@cmss.chinamobile.com>
    stm class: Fix a double free of stm_source_device

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Fix init of SD cards reporting an invalid VDD range

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: add quirk for broken HS200

Sebastian Mayr <me@sam.st>
    uprobes/x86: Fix detection of 32-bit user mode

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    ptrace,x86: Make user_64bit_mode() available to 32-bit builds

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: storage: ums-realtek: Whitelist auto-delink support

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: storage: ums-realtek: Update module parameter description for auto_delink_en

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: host: ohci: fix a race condition between shutdown and irq

Oliver Neukum <oneukum@suse.com>
    USB: cdc-wdm: fix race between write and disconnect due to flag abuse

Henk van der Laan <opensource@henkvdlaan.com>
    usb-storage: Add new JMS567 revision to unusual_devs

Bandan Das <bsd@redhat.com>
    x86/apic: Include the LDR when clearing out APIC registers

Bandan Das <bsd@redhat.com>
    x86/apic: Do not initialize LDR and DFR for bigsmp

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Don't update RIP or do single-step on faulting emulation

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix potential concurrent access to the deleted pool

Eric Dumazet <edumazet@google.com>
    tcp: make sure EPOLLOUT wont be missed

Hui Peng <benquike@gmail.com>
    ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit

Hui Peng <benquike@gmail.com>
    ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term

Tim Froidcoeur <tim.froidcoeur@tessares.net>
    tcp: fix tcp_rtx_queue_tail in case of empty retransmit queue

Stefan Wahren <wahrenst@gmx.net>
    watchdog: bcm2835_wdt: Fix module autoload

Adrian Vladu <avladu@cloudbasesolutions.com>
    tools: hv: fix KVP and VSS daemons exit code

Hans Ulli Kroll <ulli.kroll@googlemail.com>
    usb: host: fotg2: restart hcd after port reset

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    usb: gadget: composite: Clear "suspended" on reset/disconnect

Arnd Bergmann <arnd@arndb.de>
    dmaengine: ste_dma40: fix unneeded variable warning

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()

Tom Lendacky <thomas.lendacky@amd.com>
    x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

Chen Yu <yu.c.chen@intel.com>
    x86/pm: Introduce quirk framework to save/restore extra MSR registers around suspend/resume

Sasha Levin <sashal@kernel.org>
    Revert "perf test 6: Fix missing kvm module load for s390"

Dirk Morris <dmorris@metaloft.com>
    netfilter: conntrack: Use consistent ct id hash calculation

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: don't use conntrack/expect object addresses as id

Eric Dumazet <edumazet@google.com>
    inet: switch IP ID generator to siphash

Jason A. Donenfeld <Jason@zx2c4.com>
    siphash: implement HalfSipHash1-3 for hash tables

Jason A. Donenfeld <Jason@zx2c4.com>
    siphash: add cryptographically secure PRF

Jason Wang <jasowang@redhat.com>
    vhost: scsi: add weight support

Jason Wang <jasowang@redhat.com>
    vhost_net: fix possible infinite loop

Jason Wang <jasowang@redhat.com>
    vhost: introduce vhost_exceeds_weight()

Jason Wang <jasowang@redhat.com>
    vhost_net: introduce vhost_exceeds_weight()

Paolo Abeni <pabeni@redhat.com>
    vhost_net: use packet weight for rx handler, too

haibinzhang(张海斌) <haibinzhang@tencent.com>
    vhost-net: set packet weight of tx polling to 2 * vq size

Alexander Kochetkov <al.kochet@gmail.com>
    net: arc_emac: fix koops caused by sk_buff free

Bob Peterson <rpeterso@redhat.com>
    GFS2: don't set rgrp gl_object until it's inserted into rgrp tree

Daniel Bristot de Oliveira <bristot@redhat.com>
    cgroup: Disable IRQs while holding css_set_lock

Mikulas Patocka <mpatocka@redhat.com>
    dm table: fix invalid memory accesses with too high sector number

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    dm space map metadata: fix missing store of apply_bops() return value

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    dm btree: fix order of block initialization in btree_split_beneath

John Hubbard <jhubbard@nvidia.com>
    x86/boot: Fix boot regression caused by bootparam sanitizing

John Hubbard <jhubbard@nvidia.com>
    x86/boot: Save fields explicitly, zero out everything else

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Handle missing global clockevent gracefully

Sean Christopherson <sean.j.christopherson@intel.com>
    x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386

Oleg Nesterov <oleg@redhat.com>
    userfaultfd_release: always remove uffd flags and clear vm_userfaultfd_ctx

Mikulas Patocka <mpatocka@redhat.com>
    Revert "dm bufio: fix deadlock with loop device"

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: correct misreported EKR ring values

Naresh Kamboju <naresh.kamboju () linaro ! org>
    selftests: kvm: Adding config fragments

Jens Axboe <axboe@kernel.dk>
    libata: add SG safety checks in SFF pio transfers

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix dma_map_single failed on arm64

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: fix hip04-xmit never return TX_BUSY

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: make hip04_tx_reclaim non-reentrant

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()

Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
    can: peak_usb: force the string buffer NULL-terminated

Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
    can: sja1000: force the string buffer NULL-terminated

Jiri Olsa <jolsa@kernel.org>
    perf bench numa: Fix cpu0 binding

Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
    isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on the stack

Jia-Ju Bai <baijiaju1990@gmail.com>
    isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start_isoc_chain()

Bob Ham <bob.ham@puri.sm>
    net: usb: qmi_wwan: Add the BroadMobi BM818 card

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: ti: davinci-mcasp: Correct slot_width posed constraint

Navid Emamdoost <navid.emamdoost@gmail.com>
    st_nci_hci_connectivity_event_received: null check the allocation

Navid Emamdoost <navid.emamdoost@gmail.com>
    st21nfca_connectivity_event_received: null check the allocation

Ricard Wanderlof <ricard.wanderlof@axis.com>
    ASoC: Fail card instantiation if DAI format setup fails

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    can: dev: call netif_carrier_off() in register_candev()

Thomas Falcon <tlfalcon@linux.ibm.com>
    bonding: Force slave speed check after link state recovery for 802.3ad

Wenwen Wang <wenwen@cs.uga.edu>
    netfilter: ebtables: fix a memory leak bug in compat

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: kernel: only use i8253 clocksource with periodic clockevent

Ilya Trukhanov <lahvuun@gmail.com>
    HID: Add 044f:b320 ThrustMaster, Inc. 2 in 1 DT


-------------

Diffstat:

 Documentation/kernel-parameters.txt                |   7 +
 Documentation/siphash.txt                          | 175 +++++++
 MAINTAINERS                                        |   7 +
 Makefile                                           |   4 +-
 arch/mips/kernel/i8253.c                           |   3 +-
 arch/x86/include/asm/bootparam_utils.h             |  60 ++-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/include/asm/msr.h                         |  10 +
 arch/x86/include/asm/nospec-branch.h               |   2 +-
 arch/x86/include/asm/ptrace.h                      |   6 +-
 arch/x86/include/asm/suspend_32.h                  |   1 +
 arch/x86/include/asm/suspend_64.h                  |   1 +
 arch/x86/kernel/apic/apic.c                        |  72 ++-
 arch/x86/kernel/apic/bigsmp_32.c                   |  24 +-
 arch/x86/kernel/cpu/amd.c                          |  66 +++
 arch/x86/kernel/ptrace.c                           |   3 +-
 arch/x86/kernel/uprobes.c                          |  17 +-
 arch/x86/kvm/x86.c                                 |   9 +-
 arch/x86/power/cpu.c                               | 152 ++++++
 drivers/ata/libata-sff.c                           |   6 +
 drivers/dma/ste_dma40.c                            |   4 +-
 drivers/hid/hid-tmff.c                             |  12 +
 drivers/hid/wacom_wac.c                            |   2 +-
 drivers/hwtracing/stm/core.c                       |   1 -
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  13 +-
 drivers/md/dm-bufio.c                              |   4 +-
 drivers/md/dm-table.c                              |   5 +-
 drivers/md/persistent-data/dm-btree.c              |  31 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   2 +-
 drivers/misc/vmw_vmci/vmci_doorbell.c              |   6 +-
 drivers/mmc/core/sd.c                              |   6 +
 drivers/mmc/host/sdhci-of-at91.c                   |   3 +
 drivers/net/bonding/bond_main.c                    |   9 +
 drivers/net/can/dev.c                              |   2 +
 drivers/net/can/sja1000/peak_pcmcia.c              |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/ethernet/arc/emac_main.c               |   9 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   5 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  28 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/nfc/st-nci/se.c                            |   2 +
 drivers/nfc/st21nfca/se.c                          |   2 +
 drivers/scsi/ufs/ufshcd.c                          |   3 +
 drivers/usb/class/cdc-wdm.c                        |  16 +-
 drivers/usb/gadget/composite.c                     |   1 +
 drivers/usb/host/fotg210-hcd.c                     |   4 +
 drivers/usb/host/ohci-hcd.c                        |  15 +-
 drivers/usb/storage/realtek_cr.c                   |  15 +-
 drivers/usb/storage/unusual_devs.h                 |   2 +-
 drivers/vhost/net.c                                |  31 +-
 drivers/vhost/scsi.c                               |  15 +-
 drivers/vhost/vhost.c                              |  20 +-
 drivers/vhost/vhost.h                              |   6 +-
 drivers/watchdog/bcm2835_wdt.c                     |   1 +
 fs/gfs2/rgrp.c                                     |  13 +-
 fs/nfs/nfs4_fs.h                                   |   3 +-
 fs/nfs/nfs4client.c                                |   5 +-
 fs/nfs/nfs4state.c                                 |  27 +-
 fs/userfaultfd.c                                   |  25 +-
 include/linux/siphash.h                            | 145 ++++++
 include/net/netfilter/nf_conntrack.h               |   2 +
 include/net/netns/ipv4.h                           |   2 +
 include/net/tcp.h                                  |   4 +
 kernel/cgroup.c                                    | 122 ++---
 lib/Kconfig.debug                                  |  10 +
 lib/Makefile                                       |   3 +-
 lib/siphash.c                                      | 551 +++++++++++++++++++++
 lib/test_siphash.c                                 | 223 +++++++++
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/core/stream.c                                  |  16 +-
 net/ipv4/route.c                                   |  12 +-
 net/ipv6/output_core.c                             |  30 +-
 net/mac80211/cfg.c                                 |   9 +-
 net/netfilter/nf_conntrack_core.c                  |  35 ++
 net/netfilter/nf_conntrack_netlink.c               |  34 +-
 net/wireless/reg.c                                 |   2 +-
 sound/core/seq/seq_clientmgr.c                     |   3 +-
 sound/core/seq/seq_fifo.c                          |  17 +
 sound/core/seq/seq_fifo.h                          |   2 +
 sound/soc/davinci/davinci-mcasp.c                  |  43 +-
 sound/soc/soc-core.c                               |   7 +-
 sound/usb/mixer.c                                  |  30 +-
 tools/hv/hv_kvp_daemon.c                           |   2 +
 tools/hv/hv_vss_daemon.c                           |   2 +
 tools/perf/bench/numa.c                            |   6 +-
 tools/perf/tests/parse-events.c                    |  27 -
 tools/testing/selftests/kvm/config                 |   3 +
 87 files changed, 2015 insertions(+), 310 deletions(-)


