Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F11814BBA8
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgA1OB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbgA1OB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:01:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5762224683;
        Tue, 28 Jan 2020 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220086;
        bh=D1Dt3QHZlOI8fFwlMs5GZcvGI2q8qsihHHcHjG5bHeg=;
        h=From:To:Cc:Subject:Date:From;
        b=kuzFE/gIH+kdJVC6uVpMooVfWjukyT6HHBSzDOnJ9+a3N5NerRDlCu/tZiiiiNWGa
         vxLkAqyfAqIuhNr9TazXYnS8G4lA9yYtg8iy1j3uK+/hAvuXTNqaETaKbNf0eo4JgQ
         /jo3VlZYFwYL6dAQI3HPn//psVGhDBG0S/acaobg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/104] 5.4.16-stable review
Date:   Tue, 28 Jan 2020 14:59:21 +0100
Message-Id: <20200128135817.238524998@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.16-rc1
X-KernelTest-Deadline: 2020-01-30T13:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.16 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.16-rc1

Martin Schiller <ms@dev.tdt.de>
    net/x25: fix nonblocking connect

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: autoload modules from the abort path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: add __nft_chain_type_get()

Kadlecsik József <kadlec@blackhole.kfki.hu>
    netfilter: ipset: use bitmap infrastructure completely

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ioctl.c: zero reserved fields for S/TRY_FMT

Wen Huang <huangwenabc@gmail.com>
    libertas: Fix two buffer overflows at parsing bss descriptor

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

Linus Torvalds <torvalds@linux-foundation.org>
    readdir: be more conservative with directory entry names

Al Viro <viro@zeniv.linux.org.uk>
    do_last(): fetch directory ->i_mode and ->i_uid before it's too late

Jakub Sitnicki <jakub@cloudflare.com>
    net, sk_msg: Don't check if sock is locked when tearing down psock

Ulrich Weber <ulrich.weber@gmail.com>
    xfrm: support output_mark for offload ESP packets

Matthew Auld <matthew.auld@intel.com>
    drm/i915/userptr: fix size calculation

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix potential SKB leak on TXQ TX

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix SKB leak on invalid queue

Changbin Du <changbin.du@intel.com>
    tracing: xen: Ordered comparison of function pointers

Bart Van Assche <bvanassche@acm.org>
    scsi: RDMA/isert: Fix a recently introduced regression related to logout

Gilles Buloz <gilles.buloz@kontron.com>
    hwmon: (nct7802) Fix non-working alarm on voltages

Gilles Buloz <gilles.buloz@kontron.com>
    hwmon: (nct7802) Fix voltage limits to wrong registers

xiaofeng.yan <yanxiaofeng7@jd.com>
    hsr: Fix a compilation error

Jacek Anaszewski <jacek.anaszewski@gmail.com>
    leds: gpio: Fix uninitialized gpio label for fwnode based probe

Linus Torvalds <torvalds@linux-foundation.org>
    readdir: make user_access_begin() use the real access range

Shuah Khan <skhan@linuxfoundation.org>
    iommu/amd: Fix IOMMU perf counter clobbering during init

Christophe Leroy <christophe.leroy@c-s.fr>
    lib: Reduce user_access_begin() boundaries in strncpy_from_user() and strnlen_user()

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

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: fix async operation

Ido Schimmel <idosch@mellanox.com>
    mlxsw: switchx2: Do not modify cloned SKBs during xmit

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci_am654: Reset Command and Data line after tuning

Faiz Abbas <faiz_abbas@ti.com>
    mmc: sdhci_am654: Remove Inverted Write Protect flag

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

Jerry Snitselaar <jsnitsel@redhat.com>
    iommu/vt-d: Call __dmar_remove_one_dev_info with valid pointer

Boyan Ding <boyan.j.ding@gmail.com>
    pinctrl: sunrisepoint: Add missing Interrupt Status register offset

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix xas_find returning too many entries

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix xa_find_after with multi-index entries

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix infinite loop with entry at ULONG_MAX

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues

Mehmet Akif Tasova <makiftasova@gmail.com>
    Revert "iwlwifi: mvm: fix scan config command size"

Frederic Barrat <fbarrat@linux.ibm.com>
    powerpc/xive: Discard ESB load value when interrupt is invalid

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/hash: Fix sharing context ids between kernel & userspace

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix histogram code when expression has same var as value

Masami Ichikawa <masami256@gmail.com>
    tracing: Do not set trace clock if tracefs lockdown is in effect

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/uprobe: Fix double perf_event linking on multiprobe uprobe

Masami Hiramatsu <mhiramat@kernel.org>
    tracing: trigger: Replace unneeded RCU-list traversals

Alexander Potapenko <glider@google.com>
    PM: hibernate: fix crashes with init_on_free=1

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Align engine->uabi_class/instance with i915_drm.h

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Add the panfrost_gem_mapping concept

Alex Deucher <alexander.deucher@amd.com>
    PCI: Mark AMD Navi14 GPU rev 0xc5 ATS as broken

Jeff Layton <jlayton@kernel.org>
    ceph: hold extra reference to r_parent over life of request

Guenter Roeck <linux@roeck-us.net>
    hwmon: (core) Do not use device managed functions for memory allocations

Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
    hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

David Howells <dhowells@redhat.com>
    afs: Fix characters allowed into cell names

Jens Axboe <axboe@kernel.dk>
    Revert "io_uring: only allow submit from owning task"

David Ahern <dsahern@gmail.com>
    ipv4: Detect rollover in specific fib table dump

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5e: kTLS, Do not send decrypted-marked SKBs via non-accel path

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5e: kTLS, Remove redundant posts in TX resync flow

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5e: kTLS, Fix corner-case checks in TX resync flow

Erez Shitrit <erezsh@mellanox.com>
    net/mlx5: DR, use non preemptible call to get the current cpu number

Eli Cohen <eli@mellanox.com>
    net/mlx5: E-Switch, Prevent ingress rate configuration of uplink rep

Erez Shitrit <erezsh@mellanox.com>
    net/mlx5: DR, Enable counter on non-fwd-dest objects

Meir Lichtinger <meirl@mellanox.com>
    net/mlx5: Update the list of the PCI supported devices

Paul Blakey <paulb@mellanox.com>
    net/mlx5: Fix lowest FDB pool size

Maxim Mikityanskiy <maximmi@mellanox.com>
    net: Fix packet reordering caused by GRO and listified RX cooperation

Kristian Evensen <kristian.evensen@gmail.com>
    fou: Fix IPv6 netlink policy

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_acl: Fix use-after-free during reload

Michael Ellerman <mpe@ellerman.id.au>
    airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE

Michael Ellerman <mpe@ellerman.id.au>
    airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE

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

Eric Dumazet <edumazet@google.com>
    net_sched: use validated TCA_KIND attribute in tc_new_tfilter()

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

 Makefile                                           |   4 +-
 arch/powerpc/include/asm/book3s/64/mmu-hash.h      |   5 +-
 arch/powerpc/include/asm/xive-regs.h               |   1 +
 arch/powerpc/sysdev/xive/common.c                  |  15 +-
 drivers/atm/firestream.c                           |   3 +
 drivers/gpu/drm/i915/gem/i915_gem_busy.c           |  12 +-
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c        |   9 +-
 drivers/gpu/drm/i915/gt/intel_engine_types.h       |   4 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   2 +
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  91 ++++-
 drivers/gpu/drm/panfrost/panfrost_gem.c            | 124 ++++++-
 drivers/gpu/drm/panfrost/panfrost_gem.h            |  41 ++-
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c   |   3 +-
 drivers/gpu/drm/panfrost/panfrost_job.c            |  13 +-
 drivers/gpu/drm/panfrost/panfrost_job.h            |   1 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |  61 ++--
 drivers/gpu/drm/panfrost/panfrost_mmu.h            |   6 +-
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c        |  34 +-
 drivers/hwmon/adt7475.c                            |   5 +-
 drivers/hwmon/hwmon.c                              |  68 ++--
 drivers/hwmon/nct7802.c                            |  75 +++-
 drivers/infiniband/ulp/isert/ib_isert.c            |  12 -
 drivers/input/misc/keyspan_remote.c                |   9 +-
 drivers/input/misc/pm8xxx-vibrator.c               |   2 +-
 drivers/input/rmi4/rmi_smbus.c                     |   2 +
 drivers/input/tablet/aiptek.c                      |   6 +-
 drivers/input/tablet/gtco.c                        |  10 +-
 drivers/input/tablet/pegasus_notetaker.c           |   2 +-
 drivers/input/touchscreen/sun4i-ts.c               |   6 +-
 drivers/input/touchscreen/sur40.c                  |   2 +-
 drivers/iommu/amd_iommu_init.c                     |  24 +-
 drivers/iommu/intel-iommu.c                        |   3 +-
 drivers/leds/leds-gpio.c                           |  10 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  24 +-
 drivers/mmc/host/sdhci-tegra.c                     |   2 +-
 drivers/mmc/host/sdhci.c                           |  10 +-
 drivers/mmc/host/sdhci_am654.c                     |  27 +-
 drivers/net/can/slcan.c                            |  12 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   2 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  49 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   9 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   3 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  42 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |  16 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c     |  17 +-
 drivers/net/ethernet/natsemi/sonic.c               | 380 +++++++++++++--------
 drivers/net/ethernet/natsemi/sonic.h               |  44 ++-
 drivers/net/gtp.c                                  |  10 +-
 drivers/net/slip/slip.c                            |  12 +-
 drivers/net/tun.c                                  |   4 +
 drivers/net/usb/lan78xx.c                          |  15 +
 drivers/net/wireless/cisco/airo.c                  |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  28 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   4 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |  16 +-
 drivers/pci/quirks.c                               |  19 +-
 drivers/pinctrl/intel/pinctrl-sunrisepoint.c       |   1 +
 drivers/target/iscsi/iscsi_target.c                |   6 +-
 fs/afs/cell.c                                      |  11 +-
 fs/ceph/mds_client.c                               |   8 +-
 fs/io_uring.c                                      |   6 -
 fs/namei.c                                         |  17 +-
 fs/readdir.c                                       |  79 ++---
 include/linux/netdevice.h                          |   2 +
 include/linux/netfilter/ipset/ip_set.h             |   7 -
 include/linux/netfilter/nfnetlink.h                |   2 +-
 include/net/netns/nftables.h                       |   1 +
 include/trace/events/xen.h                         |   6 +-
 kernel/power/snapshot.c                            |  20 +-
 kernel/trace/trace.c                               |   5 +
 kernel/trace/trace_events_hist.c                   |  63 +++-
 kernel/trace/trace_events_trigger.c                |  20 +-
 kernel/trace/trace_kprobe.c                        |   2 +-
 kernel/trace/trace_probe.c                         |   5 +-
 kernel/trace/trace_probe.h                         |   3 +-
 kernel/trace/trace_uprobe.c                        | 124 ++++---
 lib/strncpy_from_user.c                            |  14 +-
 lib/strnlen_user.c                                 |  14 +-
 lib/test_xarray.c                                  |  56 ++-
 lib/xarray.c                                       |  33 +-
 net/core/dev.c                                     |  97 +++---
 net/core/rtnetlink.c                               |  13 +-
 net/core/skmsg.c                                   |   2 -
 net/hsr/hsr_main.h                                 |   2 +-
 net/ipv4/esp4_offload.c                            |   2 +
 net/ipv4/fib_trie.c                                |   6 +
 net/ipv4/fou.c                                     |   4 +-
 net/ipv4/ip_tunnel.c                               |   4 +-
 net/ipv4/tcp.c                                     |   1 +
 net/ipv4/tcp_bbr.c                                 |   3 +-
 net/ipv4/tcp_input.c                               |   1 +
 net/ipv4/tcp_output.c                              |   1 +
 net/ipv4/udp.c                                     |   3 +-
 net/ipv6/esp6_offload.c                            |   2 +
 net/ipv6/ip6_gre.c                                 |   3 -
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/ipv6/seg6_local.c                              |   4 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   6 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   6 +-
 net/netfilter/ipset/ip_set_bitmap_port.c           |   6 +-
 net/netfilter/nf_tables_api.c                      | 155 ++++++---
 net/netfilter/nfnetlink.c                          |   6 +-
 net/netfilter/nft_osf.c                            |   3 +
 net/sched/cls_api.c                                |   5 +-
 net/sched/ematch.c                                 |   2 +-
 net/tls/tls_sw.c                                   |   4 +-
 net/x25/af_x25.c                                   |   6 +-
 scripts/recordmcount.c                             |  17 +
 117 files changed, 1577 insertions(+), 767 deletions(-)


