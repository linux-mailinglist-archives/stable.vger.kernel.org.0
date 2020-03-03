Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C84D1780F9
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387681AbgCCR74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387675AbgCCR7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:59:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3878E206D5;
        Tue,  3 Mar 2020 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258393;
        bh=no6iwhVq7SjdWMPP6BQe79vLeEa6eP9/d0cuX8TR6mE=;
        h=From:To:Cc:Subject:Date:From;
        b=ztO9WMI55yfcFaAErGIQ4B3hDddjIKhgTI0d+yD4snTNvR4PnXsYYqK6Ma3AhhtKX
         4iUdabrEqdAovK0+uHE95o5AurmCISTYHljg33tmOPaTgeYRM2WilakgvHBmotDUg4
         0OzKRJHOdzKATa7jsNkRXoyteTNnYoR363nUwbGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/87] 4.19.108-stable review
Date:   Tue,  3 Mar 2020 18:42:51 +0100
Message-Id: <20200303174349.075101355@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.108-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.108-rc1
X-KernelTest-Deadline: 2020-03-05T17:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.108 release.
There are 87 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Mar 2020 17:43:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.108-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.108-rc1

David Rientjes <rientjes@google.com>
    mm, thp: fix defrag setting if newline is not used

Wei Yang <richardw.yang@linux.intel.com>
    mm/huge_memory.c: use head to check huge zero page

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: always acquire cpu_hotplug_lock before pinst->lock

Matteo Croce <mcroce@redhat.com>
    netfilter: nf_flowtable: fix documentation

Xin Long <lucien.xin@gmail.com>
    netfilter: nft_tunnel: no need to call htons() when dumping ports

Florian Fainelli <f.fainelli@gmail.com>
    thermal: brcmstb_thermal: Do not use DT coefficients

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Remove spurious clearing of async #PF MSR

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Remove spurious kvm_mmu_unload() from vcpu destruction path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hists browser: Restore ESC as "Zoom out" of DSO/thread/etc

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: omap-dmtimer: put_device() after of_find_device_by_node()

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Set unoptimized flag after unoptimizing code

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drivers: net: xgene: Fix the order of the arguments of 'alloc_etherdev_mqs()'

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    perf stat: Fix shadow stats for clock events

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    perf stat: Use perf_evsel__is_clocki() for clock events

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix O(nr_cgroups) in the load balancing path

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Optimize update_blocked_averages()

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Check for a bad hva before dropping into the ghc slow path

Tom Lendacky <thomas.lendacky@amd.com>
    KVM: SVM: Override default MMIO mask if memory encryption is enabled

Brian Norris <briannorris@chromium.org>
    mwifiex: delete unused mwifiex_get_intf_num()

Brian Norris <briannorris@chromium.org>
    mwifiex: drop most magic numbers from mwifiex_process_tdls_action_frame()

Aleksa Sarai <cyphar@cyphar.com>
    namei: only return -ECHILD from follow_dotdot_rcu()

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: no peer ID in CLC decline for SMCD

Pavel Belous <pbelous@marvell.com>
    net: atlantic: fix potential error handling

Pavel Belous <pbelous@marvell.com>
    net: atlantic: fix use after free kasan warn

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: netlink: cap max groups which will be considered in netlink_bind()

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: vnicc Fix EOPNOTSUPP precedence

Peter Chen <peter.chen@nxp.com>
    usb: charger: assign specific number for enum value

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix unwanted wakeup in netvsc_attach()

Tina Zhang <tina.zhang@intel.com>
    drm/i915/gvt: Separate display reset from ALL_ENGINES reset

Tina Zhang <tina.zhang@intel.com>
    drm/i915/gvt: Fix orphan vgpu dmabuf_objs' lifetime

Wolfram Sang <wsa@the-dreams.de>
    i2c: jz4780: silence log flood on txabrt

Gustavo A. R. Silva <gustavo@embeddedor.com>
    i2c: altera: Fix potential integer overflow

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'

dan.carpenter@oracle.com <dan.carpenter@oracle.com>
    HID: hiddev: Fix race in in hiddev_disconnect()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    HID: alps: Fix an error handling path in 'alps_input_configured()'

Eugenio Pérez <eperezma@redhat.com>
    vhost: Check docket sk_family instead of call getname

Shirish S <shirish.s@amd.com>
    amdgpu/gmc_v9: save/restore sdpif regs during S3

Orson Zhai <orson.unisoc@gmail.com>
    Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Disable trace_printk() on post poned tests

Wolfram Sang <wsa@the-dreams.de>
    macintosh: therm_windtunnel: fix regression when instantiating devices

Johan Korsnes <jkorsnes@cisco.com>
    HID: core: increase HID report buffer size to 8KiB

Johan Korsnes <jkorsnes@cisco.com>
    HID: core: fix off-by-one memset in hid_report_raw_event()

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Only bind to keyboard USB interface on Acer SW5-012 keyboard dock

Oliver Upton <oupton@google.com>
    KVM: VMX: check descriptor table exits on instruction emulation

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI: watchdog: Fix gas->access_width usage

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPICA: Introduce ACPI_ACCESS_BYTE_WIDTH() macro

Paul Moore <paul@paul-moore.com>
    audit: fix error handling in audit_data_to_entry()

Dan Carpenter <dan.carpenter@oracle.com>
    ext4: potential crash on allocation error in ext4_alloc_flex_bg_array()

Rohit Maheshwari <rohitm@chelsio.com>
    net/tls: Fix to avoid gettig invalid tls record

Michal Kalderon <michal.kalderon@marvell.com>
    qede: Fix race between rdma destroy workqueue and link change event

Benjamin Poirier <bpoirier@cumulusnetworks.com>
    ipv6: Fix nlmsg_flags when splitting a multipath route

Benjamin Poirier <bpoirier@cumulusnetworks.com>
    ipv6: Fix route replacement with dev-only route

Xin Long <lucien.xin@gmail.com>
    sctp: move the format error check out of __sctp_sf_do_9_1_abort

Dmitry Osipenko <digetx@gmail.com>
    nfc: pn544: Fix occasional HW initialization failure

Jason Baron <jbaron@akamai.com>
    net: sched: correct flower port blocking

Arun Parameswaran <arun.parameswaran@broadcom.com>
    net: phy: restore mdio regs in the iproc mdio driver

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: mscc: fix in frame extraction

Jethro Beekman <jethro@fortanix.com>
    net: fib_rules: Correctly set table field when table number exceeds 8 bits

Petr Mladek <pmladek@suse.com>
    sysrq: Remove duplicated sysrq message

Petr Mladek <pmladek@suse.com>
    sysrq: Restore original console_loglevel when sysrq disabled

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Coly Li <colyli@suse.de>
    bcache: ignore pending signals when creating gc and allocator thread

Frank Sorenson <sorenson@redhat.com>
    cifs: Fix mode output in debugging statements

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: ena-com.c: prevent NULL pointer dereference

Sameeh Jubran <sameehj@amazon.com>
    net: ena: ethtool: use correct value for crc32 hash

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix incorrectly saving queue numbers when setting RSS indirection table

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: rss: store hash function as values and not bits

Sameeh Jubran <sameehj@amazon.com>
    net: ena: rss: fix failure to get indirection table

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix incorrect default RSS key

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: add missing ethtool TX timestamping indication

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix uses of round_jiffies()

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix potential crash when rxfh key is NULL

Thierry Reding <treding@nvidia.com>
    soc/tegra: fuse: Fix build with Tegra194 configuration

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ARM: dts: sti: fixup sound frame-inversion for stihxxx-b2120.dtsi

Peter Zijlstra <peterz@infradead.org>
    arm/ftrace: Fix BE text poking

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: unconditionally reject 2 ep interfaces

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: re-add DW5821e pre-production variant

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: fix card and queue total counter wrap

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    cfg80211: check wiphy driver existence for drvinfo report

Johannes Berg <johannes.berg@intel.com>
    mac80211: consider more elements in parsing CRC

Jeff Moyer <jmoyer@redhat.com>
    dax: pass NOWAIT flag to iomap_apply

Scott Wood <swood@redhat.com>
    sched/core: Don't skip remote tick for idle CPUs

Sean Paul <seanpaul@chromium.org>
    drm/msm: Set dma maximum segment size for mdss

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Handle a possible NULL pointer reference

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix rb_allocator workqueue allocation

Joe Perches <joe@perches.com>
    irqchip/gic-v3-its: Fix misuse of GENMASK macro


-------------

Diffstat:

 Documentation/networking/nf_flowtable.txt          |  2 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/stihxxx-b2120.dtsi               |  2 +-
 arch/arm/kernel/ftrace.c                           |  7 +-
 arch/mips/kernel/vpe.c                             |  2 +-
 arch/x86/kvm/svm.c                                 | 43 +++++++++++++
 arch/x86/kvm/vmx.c                                 | 15 +++++
 arch/x86/kvm/x86.c                                 |  6 --
 drivers/acpi/acpi_watchdog.c                       |  3 +-
 drivers/char/ipmi/ipmi_ssif.c                      | 10 ++-
 drivers/devfreq/devfreq.c                          |  4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.h            |  1 +
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              | 37 ++++++++++-
 .../drm/amd/include/asic_reg/dce/dce_12_0_offset.h |  2 +
 drivers/gpu/drm/i915/gvt/dmabuf.c                  |  2 +-
 drivers/gpu/drm/i915/gvt/vgpu.c                    |  2 +-
 drivers/gpu/drm/msm/msm_drv.c                      |  8 +++
 drivers/hid/hid-alps.c                             |  2 +-
 drivers/hid/hid-core.c                             |  4 +-
 drivers/hid/hid-ite.c                              |  5 +-
 drivers/hid/usbhid/hiddev.c                        |  2 +-
 drivers/i2c/busses/i2c-altera.c                    |  2 +-
 drivers/i2c/busses/i2c-jz4780.c                    | 36 +----------
 drivers/irqchip/irq-gic-v3-its.c                   |  2 +-
 drivers/macintosh/therm_windtunnel.c               | 52 +++++++++------
 drivers/md/bcache/alloc.c                          | 18 +++++-
 drivers/md/bcache/btree.c                          | 13 ++++
 drivers/net/ethernet/amazon/ena/ena_com.c          | 48 +++++++++++---
 drivers/net/ethernet/amazon/ena/ena_com.h          |  9 +++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      | 46 ++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |  2 +
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |  2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  8 +--
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  7 +-
 drivers/net/ethernet/mscc/ocelot_board.c           |  8 +++
 drivers/net/ethernet/qlogic/qede/qede.h            |  2 +
 drivers/net/ethernet/qlogic/qede/qede_rdma.c       | 29 ++++++++-
 drivers/net/hyperv/netvsc.c                        |  2 +-
 drivers/net/hyperv/netvsc_drv.c                    |  3 +
 drivers/net/phy/mdio-bcm-iproc.c                   | 20 ++++++
 drivers/net/usb/qmi_wwan.c                         | 43 +++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 15 +++--
 drivers/net/wireless/marvell/mwifiex/main.h        | 13 ----
 drivers/net/wireless/marvell/mwifiex/tdls.c        | 75 ++++++++--------------
 drivers/nfc/pn544/i2c.c                            |  1 +
 drivers/pwm/pwm-omap-dmtimer.c                     | 21 ++++--
 drivers/s390/crypto/ap_bus.h                       |  4 +-
 drivers/s390/crypto/ap_card.c                      |  8 +--
 drivers/s390/crypto/ap_queue.c                     |  6 +-
 drivers/s390/crypto/zcrypt_api.c                   | 16 +++--
 drivers/s390/net/qeth_l2_main.c                    | 29 ++++-----
 drivers/soc/tegra/fuse/fuse-tegra30.c              |  3 +-
 drivers/thermal/broadcom/brcmstb_thermal.c         | 31 +++------
 drivers/tty/sysrq.c                                |  8 +--
 drivers/vhost/net.c                                | 10 +--
 drivers/watchdog/wdat_wdt.c                        |  2 +-
 fs/cifs/cifsacl.c                                  |  4 +-
 fs/cifs/connect.c                                  |  2 +-
 fs/cifs/inode.c                                    |  2 +-
 fs/dax.c                                           |  3 +
 fs/ext4/super.c                                    |  6 +-
 fs/namei.c                                         |  2 +-
 include/acpi/actypes.h                             |  3 +-
 include/linux/hid.h                                |  2 +-
 include/net/flow_dissector.h                       |  9 +++
 include/uapi/linux/usb/charger.h                   | 16 ++---
 kernel/auditfilter.c                               | 71 +++++++++++---------
 kernel/kprobes.c                                   |  4 +-
 kernel/padata.c                                    |  4 +-
 kernel/sched/core.c                                | 18 +++---
 kernel/sched/fair.c                                | 69 ++++++++++++++++----
 kernel/trace/trace.c                               |  2 +
 mm/huge_memory.c                                   | 26 +++-----
 net/core/fib_rules.c                               |  2 +-
 net/ipv6/ip6_fib.c                                 |  7 +-
 net/ipv6/route.c                                   |  1 +
 net/mac80211/util.c                                | 18 ++++--
 net/netfilter/nft_tunnel.c                         |  4 +-
 net/netlink/af_netlink.c                           |  5 +-
 net/sched/cls_flower.c                             |  1 +
 net/sctp/sm_statefuns.c                            | 29 ++++++---
 net/smc/smc_clc.c                                  |  4 +-
 net/tls/tls_device.c                               | 21 +++++-
 net/wireless/ethtool.c                             |  8 ++-
 net/wireless/nl80211.c                             |  1 +
 tools/perf/ui/browsers/hists.c                     |  1 +
 tools/perf/util/stat-shadow.c                      |  6 +-
 tools/testing/selftests/net/fib_tests.sh           |  6 ++
 virt/kvm/kvm_main.c                                | 12 ++--
 90 files changed, 722 insertions(+), 410 deletions(-)


