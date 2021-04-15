Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B08D360C61
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhDOOue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233885AbhDOOuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:50:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99F2161029;
        Thu, 15 Apr 2021 14:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498192;
        bh=On8gxsRNXG+M/Bo2bTgICwAH/A7/BTLFkEcNVJ+9V8Y=;
        h=From:To:Cc:Subject:Date:From;
        b=T6WxdbrHS8wd6JTbxIEQGcc3tmLqC9yRJe0RVfM7+Z2O5xz3sEZa4h3BX6Rgs6zL4
         JhdGywf0oaYY9UZG8TIWHDqrIhcKMgRVc0QAHYLsASidWe/TzZkMvE164RlaLwUwZH
         nSwQiM7pqYjKX3sUscsXSUoeqCfIrzry5WjvKl2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/38] 4.4.267-rc1 review
Date:   Thu, 15 Apr 2021 16:46:54 +0200
Message-Id: <20210415144413.352638802@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.267-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.267-rc1
X-KernelTest-Deadline: 2021-04-17T14:44+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.267 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.267-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.267-rc1

Juergen Gross <jgross@suse.com>
    xen/events: fix setting irq affinity

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: fix compat match/target pad out-of-bound write

Arnd Bergmann <arnd@arndb.de>
    drm/imx: imx-ldb: fix out of bounds array access warning

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec params for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for del llsec seclevel

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for set llsec params

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec devkey

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 add llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec dev

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: nl-mac: fix check on panid

Pavel Skripkin <paskripkin@gmail.com>
    net: mac802154: Fix general protection fault

Pavel Skripkin <paskripkin@gmail.com>
    drivers: net: fix memory leak in peak_usb_create_dev

Pavel Skripkin <paskripkin@gmail.com>
    drivers: net: fix memory leak in atusb_probe

Phillip Potter <phil@philpotter.co.uk>
    net: tun: set tun->dev->addr_len during TUNSETLINK processing

Du Cheng <ducheng2@gmail.com>
    cfg80211: remove WARN_ON() in cfg80211_sme_connect

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    clk: socfpga: fix iomem pointer cast on 64-bit

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/cxgb4: check for ipv6 address properly while destroying listener

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/cpcmd: fix inline assembly register clobbering

Zqiang <qiang.zhang@windriver.com>
    workqueue: Move the position of debug_work_activate() in __queue_work()

Lukasz Bartosik <lb@semihalf.com>
    clk: fix invalid usage of list cursor in unregister

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:tipc: Fix a double free in tipc_sk_mcast_rcv

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Handle error code at MAC address change

Eric Dumazet <edumazet@google.com>
    sch_red: fix off-by-one checks in red_check_params()

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    net: sched: sch_teql: fix null-pointer dereference

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field

Helge Deller <deller@gmx.de>
    parisc: parisc-agp requires SBA IOMMU driver

Jack Qiu <jack.qiu@huawei.com>
    fs: direct-io: fix missing sdio->boundary

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix user_stack_pointer() for ptrace()

Muhammad Usama Anjum <musamaanjum@gmail.com>
    net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh

Luca Fancellu <luca.fancellu@arm.com>
    xen/evtchn: Change irq_info lock to raw_spinlock_t

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: Avoid endless loops caused by repeated llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix memory leak in llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix refcount leak in llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix refcount leak in llcp_sock_bind()

Jonas Holmberg <jonashg@axis.com>
    ALSA: aloop: Fix initialization of controls

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-prox: Fix scale not correct issue


-------------

Diffstat:

 Makefile                                     |  4 +--
 arch/ia64/include/asm/ptrace.h               |  8 +----
 arch/s390/kernel/cpcmd.c                     |  6 ++--
 drivers/char/agp/Kconfig                     |  2 +-
 drivers/clk/clk.c                            | 30 ++++++++---------
 drivers/clk/socfpga/clk-gate.c               |  2 +-
 drivers/gpu/drm/imx/imx-ldb.c                | 10 ++++++
 drivers/iio/light/hid-sensor-prox.c          | 14 ++++++--
 drivers/infiniband/hw/cxgb4/cm.c             |  3 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |  6 +++-
 drivers/net/ethernet/freescale/gianfar.c     |  6 +++-
 drivers/net/ieee802154/atusb.c               |  1 +
 drivers/net/tun.c                            | 48 ++++++++++++++++++++++++++++
 drivers/xen/events/events_base.c             | 14 ++++----
 drivers/xen/events/events_internal.h         |  2 +-
 fs/direct-io.c                               |  5 +--
 include/net/red.h                            |  4 +--
 kernel/workqueue.c                           |  2 +-
 net/batman-adv/translation-table.c           |  1 +
 net/ieee802154/nl-mac.c                      |  7 ++--
 net/ieee802154/nl802154.c                    | 23 ++++++++++---
 net/ipv4/netfilter/arp_tables.c              |  2 ++
 net/ipv4/netfilter/ip_tables.c               |  2 ++
 net/ipv6/netfilter/ip6_tables.c              |  2 ++
 net/ipv6/route.c                             |  8 +++--
 net/mac802154/llsec.c                        |  2 +-
 net/netfilter/x_tables.c                     | 10 ++----
 net/nfc/llcp_sock.c                          | 10 ++++++
 net/sched/sch_teql.c                         |  3 ++
 net/tipc/socket.c                            |  2 +-
 net/wireless/sme.c                           |  2 +-
 sound/drivers/aloop.c                        | 11 +++++--
 tools/perf/util/map.c                        |  7 ++--
 33 files changed, 183 insertions(+), 76 deletions(-)


