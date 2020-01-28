Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03EF414B91D
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732980AbgA1O1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733255AbgA1O1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7326321739;
        Tue, 28 Jan 2020 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221627;
        bh=ku1Yxbod8jXR4hgAXQj5MxhFqJCq1c28zjhEu20kkMQ=;
        h=From:To:Cc:Subject:Date:From;
        b=bpARTKKhS557A1WXl7Anh/9rJc4+fO2N46sH+BQdWgF2PcFnFlpgUlsu5tTooGJ5I
         gkFWSteU3UDVxg9RGhzzp1KRcGmaPMoTX3FmEn1jGBQgokOMwqpaaaAeJJg4BLB5OA
         lxyec4faez1fzKGzPxFD/TkRsIiAlk+FQSo+wACY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/92] 4.19.100-stable review
Date:   Tue, 28 Jan 2020 15:07:28 +0100
Message-Id: <20200128135809.344954797@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.100-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.100-rc1
X-KernelTest-Deadline: 2020-01-30T13:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.100 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.100-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.100-rc1

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: shrink zones when offlining memory

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: fix try_offline_node()

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/memunmap: don't access uninitialized memmap in memunmap_pages()

David Hildenbrand <david@redhat.com>
    drivers/base/node.c: simplify unregister_memory_block_under_nodes()

Dan Williams <dan.j.williams@intel.com>
    mm/hotplug: kill is_dev_zone() usage in __remove_pages()

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: remove "zone" parameter from sparse_remove_one_section

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: make unregister_memory_block_under_nodes() never fail

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: remove memory block devices before arch_remove_memory()

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: create memory block devices after arch_add_memory()

David Hildenbrand <david@redhat.com>
    drivers/base/memory: pass a block_id to init_memory_block()

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: allow arch_remove_memory() without CONFIG_MEMORY_HOTREMOVE

David Hildenbrand <david@redhat.com>
    s390x/mm: implement arch_remove_memory()

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: make __remove_pages() and arch_remove_memory() never fail

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm: Fix section mismatch warning

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: make __remove_section() never fail

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: make unregister_memory_section() never fail

Dan Carpenter <dan.carpenter@oracle.com>
    mm, memory_hotplug: update a comment in unregister_memory()

Baoquan He <bhe@redhat.com>
    drivers/base/memory.c: clean up relics in function parameters

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: release memory resource after arch_remove_memory()

Oscar Salvador <osalvador@suse.com>
    mm, memory_hotplug: add nid parameter to arch_remove_memory

Wei Yang <richard.weiyang@gmail.com>
    drivers/base/memory.c: remove an unnecessary check on NR_MEM_SECTIONS

Wei Yang <richard.weiyang@gmail.com>
    mm, sparse: pass nid instead of pgdat to sparse_add_one_section()

Wei Yang <richard.weiyang@gmail.com>
    mm, sparse: drop pgdat_resize_lock in sparse_add/remove_one_section()

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: make remove_memory() take the device_hotplug_lock

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix nonblocking connect

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: add __nft_chain_type_get()

Kadlecsik József <kadlec@blackhole.kfki.hu>
    netfilter: ipset: use bitmap infrastructure completely

Bo Wu <wubo40@huawei.com>
    scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ioctl.c: zero reserved fields for S/TRY_FMT

Wen Huang <huangwenabc@gmail.com>
    libertas: Fix two buffer overflows at parsing bss descriptor

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc-etf: Do not call smp_processor_id from preemptible

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etb10: Do not call smp_processor_id from preemptible

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: geode-aes - switch to skcipher for cbc(aes) fallback

Masato Suzuki <masato.suzuki@wdc.com>
    sd: Fix REQ_OP_ZONE_REPORT completion handling

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix histogram code when expression has same var as value

Tom Zanussi <tom.zanussi@linux.intel.com>
    tracing: Remove open-coding of hist trigger var_ref management

Tom Zanussi <tom.zanussi@linux.intel.com>
    tracing: Use hist trigger's var_ref array to destroy var_refs

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Prevent tx watchdog timeout

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Fix CAM initialization

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Fix command register usage

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Quiesce SONIC before re-initializing descriptor memory

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Fix receive buffer replenishment

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Improve receive descriptor status flag check

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Avoid needless receive descriptor EOL flag updates

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Fix receive buffer handling

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Fix interface error stats collection

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Use MMIO accessors

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Clear interrupt flags immediately

Finn Thain <fthain@telegraphics.com.au>
    net/sonic: Add mutual exclusion for accessing shared state

Al Viro <viro@zeniv.linux.org.uk>
    do_last(): fetch directory ->i_mode and ->i_uid before it's too late

Changbin Du <changbin.du@gmail.com>
    tracing: xen: Ordered comparison of function pointers

Bart Van Assche <bvanassche@acm.org>
    scsi: RDMA/isert: Fix a recently introduced regression related to logout

Gilles Buloz <gilles.buloz@kontron.com>
    hwmon: (nct7802) Fix voltage limits to wrong registers

Florian Westphal <fw@strlen.de>
    netfilter: nft_osf: add missing check for DREG attribute

Chuhong Yuan <hslester96@gmail.com>
    Input: sun4i-ts - add a check for devm_thermal_zone_of_sensor_register

Johan Hovold <johan@kernel.org>
    Input: pegasus_notetaker - fix endpoint sanity check

Johan Hovold <johan@kernel.org>
    Input: aiptek - fix endpoint sanity check

Johan Hovold <johan@kernel.org>
    Input: gtco - fix endpoint sanity check

Johan Hovold <johan@kernel.org>
    Input: sur40 - fix interface sanity checks

Stephan Gerhold <stephan@gerhold.net>
    Input: pm8xxx-vib - fix handling of separate enable register

Jeremy Linton <jeremy.linton@arm.com>
    Documentation: Document arm64 kpti control

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: sdhci: fix minimum clock rate for v3 controller

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: tegra: fix SDR50 tuning override

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 8950/1: ftrace/recordmcount: filter relocation types

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Revert "Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers"

Johan Hovold <johan@kernel.org>
    Input: keyspan-remote - fix control-message timeouts

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: trigger: Replace unneeded RCU-list traversals

Alex Deucher <alexander.deucher@amd.com>
    PCI: Mark AMD Navi14 GPU rev 0xc5 ATS as broken

Guenter Roeck <linux@roeck-us.net>
    hwmon: (core) Do not use device managed functions for memory allocations

Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
    hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

David Howells <dhowells@redhat.com>
    afs: Fix characters allowed into cell names

Eric Dumazet <edumazet@google.com>
    tun: add mutex_unlock() call and napi.skb clearing in tun_get_user()

Eric Dumazet <edumazet@google.com>
    tcp: do not leave dangling pointers in tp->highest_sack

Wen Yang <wenyang@linux.alibaba.com>
    tcp_bbr: improve arithmetic division in bbr_update_bw()

Paolo Abeni <pabeni@redhat.com>
    Revert "udp: do rmem bulk free even if the rx sk queue is empty"

James Hughes <james.hughes@raspberrypi.org>
    net: usb: lan78xx: Add .ndo_features_check

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Fix reference count leak

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Call dev_hold always in rx_queue_add_kobject

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Call dev_hold always in netdev_queue_add_kobject

Eric Dumazet <edumazet@google.com>
    net-sysfs: fix netdev_queue_add_kobject() breakage

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix datalen for ematch

Eric Dumazet <edumazet@google.com>
    net: rtnetlink: validate IFLA_MTU attribute in rtnl_create_link()

William Dauchy <w.dauchy@criteo.com>
    net, ip_tunnel: fix namespaces move

William Dauchy <w.dauchy@criteo.com>
    net, ip6_tunnel: fix namespaces move

Niko Kortstrom <niko.kortstrom@nokia.com>
    net: ip6_gre: fix moving ip6gre between namespaces

Michael Ellerman <mpe@ellerman.id.au>
    net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Use netif_tx_napi_add() for TX NAPI

Yuki Taguchi <tagyounit@gmail.com>
    ipv6: sr: remove SKB_GSO_IPXIP6 on End.D* actions

Eric Dumazet <edumazet@google.com>
    gtp: make sure only SOCK_DGRAM UDP sockets are accepted

Wenwen Wang <wenwen@cs.uga.edu>
    firestream: fix memory leaks

Richard Palethorpe <rpalethorpe@suse.com>
    can, slip: Protect tty->disc_data in write_wakeup and close with RCU


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt |   6 +
 Makefile                                        |   4 +-
 arch/ia64/mm/init.c                             |  15 +-
 arch/powerpc/mm/mem.c                           |  25 +-
 arch/powerpc/platforms/powernv/memtrace.c       |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c |   6 +-
 arch/s390/mm/init.c                             |  16 +-
 arch/sh/mm/init.c                               |  15 +-
 arch/x86/mm/init_32.c                           |   9 +-
 arch/x86/mm/init_64.c                           |  17 +-
 drivers/acpi/acpi_memhotplug.c                  |   2 +-
 drivers/atm/firestream.c                        |   3 +
 drivers/base/memory.c                           | 203 ++++++++-----
 drivers/base/node.c                             |  52 ++--
 drivers/crypto/geode-aes.c                      |  57 ++--
 drivers/crypto/geode-aes.h                      |   2 +-
 drivers/hwmon/adt7475.c                         |   5 +-
 drivers/hwmon/hwmon.c                           |  68 +++--
 drivers/hwmon/nct7802.c                         |   4 +-
 drivers/hwtracing/coresight/coresight-etb10.c   |   4 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c |   4 +-
 drivers/infiniband/ulp/isert/ib_isert.c         |  12 -
 drivers/input/misc/keyspan_remote.c             |   9 +-
 drivers/input/misc/pm8xxx-vibrator.c            |   2 +-
 drivers/input/rmi4/rmi_smbus.c                  |   2 +
 drivers/input/tablet/aiptek.c                   |   6 +-
 drivers/input/tablet/gtco.c                     |  10 +-
 drivers/input/tablet/pegasus_notetaker.c        |   2 +-
 drivers/input/touchscreen/sun4i-ts.c            |   6 +-
 drivers/input/touchscreen/sur40.c               |   2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c            |  24 +-
 drivers/mmc/host/sdhci-tegra.c                  |   2 +-
 drivers/mmc/host/sdhci.c                        |  10 +-
 drivers/net/can/slcan.c                         |  12 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c  |   4 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |   2 +
 drivers/net/ethernet/natsemi/sonic.c            | 380 ++++++++++++++----------
 drivers/net/ethernet/natsemi/sonic.h            |  44 ++-
 drivers/net/gtp.c                               |  10 +-
 drivers/net/slip/slip.c                         |  12 +-
 drivers/net/tun.c                               |   4 +
 drivers/net/usb/lan78xx.c                       |  15 +
 drivers/net/wireless/marvell/libertas/cfg.c     |  16 +-
 drivers/pci/quirks.c                            |  19 +-
 drivers/scsi/scsi_transport_iscsi.c             |   7 +
 drivers/scsi/sd.c                               |   8 +-
 drivers/target/iscsi/iscsi_target.c             |   6 +-
 fs/afs/cell.c                                   |  11 +-
 fs/namei.c                                      |  17 +-
 include/linux/memory.h                          |   8 +-
 include/linux/memory_hotplug.h                  |  22 +-
 include/linux/mmzone.h                          |   3 +-
 include/linux/netdevice.h                       |   2 +
 include/linux/netfilter/ipset/ip_set.h          |   7 -
 include/linux/node.h                            |   7 +-
 include/trace/events/xen.h                      |   6 +-
 kernel/memremap.c                               |  12 +-
 kernel/trace/trace_events_hist.c                | 177 +++++++++--
 kernel/trace/trace_events_trigger.c             |  20 +-
 mm/hmm.c                                        |   8 +-
 mm/memory_hotplug.c                             | 166 ++++++-----
 mm/sparse.c                                     |  27 +-
 net/core/dev.c                                  |  33 +-
 net/core/net-sysfs.c                            |  39 ++-
 net/core/rtnetlink.c                            |  13 +-
 net/ipv4/ip_tunnel.c                            |   4 +-
 net/ipv4/tcp.c                                  |   1 +
 net/ipv4/tcp_bbr.c                              |   3 +-
 net/ipv4/tcp_input.c                            |   1 +
 net/ipv4/tcp_output.c                           |   1 +
 net/ipv4/udp.c                                  |   3 +-
 net/ipv6/ip6_gre.c                              |   3 -
 net/ipv6/ip6_tunnel.c                           |   4 +-
 net/ipv6/seg6_local.c                           |   4 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h         |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c          |   6 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c       |   6 +-
 net/netfilter/ipset/ip_set_bitmap_port.c        |   6 +-
 net/netfilter/nf_tables_api.c                   |  29 +-
 net/netfilter/nft_osf.c                         |   3 +
 net/sched/ematch.c                              |   2 +-
 net/x25/af_x25.c                                |   6 +-
 scripts/recordmcount.c                          |  17 ++
 83 files changed, 1102 insertions(+), 722 deletions(-)


