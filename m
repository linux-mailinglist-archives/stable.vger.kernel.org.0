Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D90177EB3
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgCCRqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731067AbgCCRqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:46:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD494214D8;
        Tue,  3 Mar 2020 17:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257568;
        bh=7GZRg0KD5PYoKdF1zEgz8TmufWcXYrqlsCcoynhqkXg=;
        h=From:To:Cc:Subject:Date:From;
        b=xw55xIYtSQsaVNTrWXgqNmvsAd6pKjZPi3Zr/7IPXffmvFVHv88lYMWgLfiGA+vT+
         l8EvBOGCwFbo4KU2Ui6iPUG66kaRRI+sLBtJ8HZnxipQzItOfXTPCGmGbMrdiq5rG9
         qMlS4x4b8T4xJJE8XwP4+nDm9vQoa7Yh62FLBDcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 000/176] 5.5.8-stable review
Date:   Tue,  3 Mar 2020 18:41:04 +0100
Message-Id: <20200303174304.593872177@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.8-rc1
X-KernelTest-Deadline: 2020-03-05T17:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.8 release.
There are 176 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Mar 2020 17:42:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.8-rc1

Jim Mattson <jmattson@google.com>
    kvm: nVMX: VMWRITE checks unsupported field before read-only field

Jim Mattson <jmattson@google.com>
    kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field

David Rientjes <rientjes@google.com>
    mm, thp: fix defrag setting if newline is not used

Wei Yang <richardw.yang@linux.intel.com>
    mm/huge_memory.c: use head to check huge zero page

John Hubbard <jhubbard@nvidia.com>
    mm/gup: allow FOLL_FORCE for get_user_pages_fast()

Vlastimil Babka <vbabka@suse.cz>
    mm/debug.c: always print flags in dump_page()

Waiman Long <longman@redhat.com>
    locking/lockdep: Fix lockdep_stats indentation problem

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: always acquire cpu_hotplug_lock before pinst->lock

Christoph Hellwig <hch@lst.de>
    xfs: clear kernel only flags in XFS_IOC_ATTRMULTI_BY_HANDLE

Bjorn Andersson <bjorn.andersson@linaro.org>
    clk: qcom: rpmh: Sort OF match table

Sameer Pujar <spujar@nvidia.com>
    bus: tegra-aconnect: Remove PM_CLK dependency

Matteo Croce <mcroce@redhat.com>
    netfilter: nf_flowtable: fix documentation

Xin Long <lucien.xin@gmail.com>
    netfilter: nft_tunnel: no need to call htons() when dumping ports

Florian Fainelli <f.fainelli@gmail.com>
    thermal: brcmstb_thermal: Do not use DT coefficients

Linus Walleij <linus.walleij@linaro.org>
    thermal: db8500: Depromote debug print

Geert Uytterhoeven <geert@linux-m68k.org>
    ubifs: Fix ino_t format warnings in orphan_delete()

Neeraj Upadhyay <neeraju@codeaurora.org>
    rcu: Allow only one expedited GP to run concurrently with wakeups

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Remove spurious clearing of async #PF MSR

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Remove spurious kvm_mmu_unload() from vcpu destruction path

Peter Xu <peterx@redhat.com>
    KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Check monitoring static key in the MBM overflow handler

Cengiz Can <cengiz@kernel.wtf>
    perf maps: Add missing unlock to maps__insert() error case

Jiri Olsa <jolsa@kernel.org>
    perf ui gtk: Add missing zalloc object

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf hists browser: Restore ESC as "Zoom out" of DSO/thread/etc

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: omap-dmtimer: put_device() after of_find_device_by_node()

Thomas Gleixner <tglx@linutronix.de>
    lib/vdso: Update coarse timekeeper unconditionally

Thomas Gleixner <tglx@linutronix.de>
    lib/vdso: Make __arch_update_vdso_data() logic understandable

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Set unoptimized flag after unoptimizing code

Janne Karhunen <janne.karhunen@gmail.com>
    ima: ima/lsm policy rule loading logic bug fixes

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drivers: net: xgene: Fix the order of the arguments of 'alloc_etherdev_mqs()'

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Bugfix for posting a wqe with sge

Yixian Liu <liuyixian@huawei.com>
    RDMA/hns: Simplify the calculation and usage of wqe idx for post verbs

Chao Yu <chao@kernel.org>
    f2fs: fix to add swap extent correctly

Cheng Jian <cj.chengjian@huawei.com>
    sched/fair: Optimize select_idle_cpu

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Check for a bad hva before dropping into the ghc slow path

Tom Lendacky <thomas.lendacky@amd.com>
    KVM: SVM: Override default MMIO mask if memory encryption is enabled

Jin Yao <yao.jin@linux.intel.com>
    perf report: Fix no libunwind compiled warning break s390 issue

Brian Norris <briannorris@chromium.org>
    mwifiex: delete unused mwifiex_get_intf_num()

Brian Norris <briannorris@chromium.org>
    mwifiex: drop most magic numbers from mwifiex_process_tdls_action_frame()

Aleksa Sarai <cyphar@cyphar.com>
    namei: only return -ECHILD from follow_dotdot_rcu()

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix successful connect() but timed out

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: no peer ID in CLC decline for SMCD

Michael Ellerman <mpe@ellerman.id.au>
    selftests: Install settings files to fix TIMEOUT failures

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: atlantic: fix out of range usage of active_vlans array

Pavel Belous <pbelous@marvell.com>
    net: atlantic: possible fault in transition to hibernation

Pavel Belous <pbelous@marvell.com>
    net: atlantic: fix potential error handling

Pavel Belous <pbelous@marvell.com>
    net: atlantic: fix use after free kasan warn

Nikita Danilov <ndanilov@marvell.com>
    net: atlantic: better loopback mode handling

Dmitry Bezrukov <dbezrukov@marvell.com>
    net: atlantic: checksum compat issue

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: netlink: cap max groups which will be considered in netlink_bind()

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix off-by-one in RX copybreak check

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: vnicc Fix EOPNOTSUPP precedence

Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
    nvme-pci: Hold cq_poll_lock while completing CQEs

Peter Chen <peter.chen@nxp.com>
    usb: charger: assign specific number for enum value

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix unwanted wakeup in netvsc_attach()

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix DT binding schema rule to detect command line changes

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    mac80211: Remove a redundant mutex unlock

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix potential leak in AP start

Tina Zhang <tina.zhang@intel.com>
    drm/i915/gvt: Separate display reset from ALL_ENGINES reset

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Avoid recursing onto active vma from the shrinker

Tina Zhang <tina.zhang@intel.com>
    drm/i915/gvt: Fix orphan vgpu dmabuf_objs' lifetime

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    MIPS: cavium_octeon: Fix syncw generation.

Wolfram Sang <wsa@the-dreams.de>
    i2c: jz4780: silence log flood on txabrt

Gustavo A. R. Silva <gustavo@embeddedor.com>
    i2c: altera: Fix potential integer overflow

Oliver Upton <oupton@google.com>
    KVM: nVMX: Emulate MTF when performing instruction emulation

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'

Anup Patel <anup.patel@wdc.com>
    RISC-V: Don't enable all interrupts in trap_init()

dan.carpenter@oracle.com <dan.carpenter@oracle.com>
    HID: hiddev: Fix race in in hiddev_disconnect()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    HID: alps: Fix an error handling path in 'alps_input_configured()'

Cong Wang <xiyou.wangcong@gmail.com>
    netfilter: xt_hashlimit: reduce hashlimit_mutex scope for htable_put()

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix forceadd evaluation path

Eugenio Pérez <eperezma@redhat.com>
    vhost: Check docket sk_family instead of call getname

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: transfer fasync_list in case of fallback

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports

Jens Axboe <axboe@kernel.dk>
    io_uring: fix 32-bit compatability with sendmsg/recvmsg

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Fix policy initialization for internal governor drivers

Shirish S <shirish.s@amd.com>
    amdgpu/gmc_v9: save/restore sdpif regs during S3

Orson Zhai <orson.unisoc@gmail.com>
    Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Disable trace_printk() on post poned tests

Jan Kara <jack@suse.cz>
    blktrace: Protect q->blk_trace with RCU

Wolfram Sang <wsa@the-dreams.de>
    macintosh: therm_windtunnel: fix regression when instantiating devices

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/radeon: Inline drm_get_pci_dev

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/amdgpu: Drop DRIVER_USE_AGP

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
    audit: always check the netlink payload length in audit_receive_msg()

Paul Moore <paul@paul-moore.com>
    audit: fix error handling in audit_data_to_entry()

Dan Carpenter <dan.carpenter@oracle.com>
    ext4: potential crash on allocation error in ext4_alloc_flex_bg_array()

Kees Cook <keescook@chromium.org>
    docs: Fix empty parallelism argument

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: fix wrong data and display format of SFP+ temperature

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: sd_sbc: Fix sd_zbc_report_zones()

Keith Busch <kbusch@kernel.org>
    nvme/pci: move cqe check after device shutdown

Nigel Kirkland <nigel.kirkland@broadcom.com>
    nvme: prevent warning triggered by nvme_stop_keep_alive

Anton Eidelman <anton@lightbitslabs.com>
    nvme/tcp: fix bug on double requeue when send fails

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix a copying IPv6 address error in hclge_fd_get_flow_tuples()

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix VF bandwidth does not take effect in some case

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: add management table after IMP reset

Shay Bar <shay.bar@celeno.com>
    mac80211: fix wrong 160/80+80 MHz setting

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Coly Li <colyli@suse.de>
    bcache: ignore pending signals when creating gc and allocator thread

Frank Sorenson <sorenson@redhat.com>
    cifs: Fix mode output in debugging statements

Jens Axboe <axboe@kernel.dk>
    io-wq: don't call kXalloc_node() with non-online node

Ben Shelton <benjamin.h.shelton@intel.com>
    ice: Use correct netif error function

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Use ice_pf_to_dev

Bruce Allan <bruce.w.allan@intel.com>
    ice: update Unit Load Status bitmask to check after reset

Bruce Allan <bruce.w.allan@intel.com>
    ice: fix and consolidate logging of NVM/firmware version information

Brett Creeley <brett.creeley@intel.com>
    ice: Don't allow same value for Rx tail to be written twice

Dave Ertman <david.m.ertman@intel.com>
    ice: Fix switch between FW and SW LLDP

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: ena-com.c: prevent NULL pointer dereference

Sameeh Jubran <sameehj@amazon.com>
    net: ena: ethtool: use correct value for crc32 hash

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix corruption of dev_idx_to_host_tbl

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix incorrectly saving queue numbers when setting RSS indirection table

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: rss: store hash function as values and not bits

Sameeh Jubran <sameehj@amazon.com>
    net: ena: rss: fix failure to get indirection table

Sameeh Jubran <sameehj@amazon.com>
    net: ena: rss: do not allocate key when not supported

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix incorrect default RSS key

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: add missing ethtool TX timestamping indication

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix uses of round_jiffies()

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix potential crash when rxfh key is NULL

Brett Creeley <brett.creeley@intel.com>
    i40e: Fix the conditional for i40e_vc_validate_vqs_bitmaps

Thierry Reding <treding@nvidia.com>
    soc/tegra: fuse: Fix build with Tegra194 configuration

Daniel Kolesa <daniel@octaforge.org>
    amdgpu: Prevent build errors regarding soft/hard-float FP ABI tags

Isabel Zhang <isabel.zhang@amd.com>
    drm/amd/display: Add initialitions for PLL2 clock source

Yongqiang Sun <yongqiang.sun@amd.com>
    drm/amd/display: Limit minimum DPPCLK to 100MHz.

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Check engine is not NULL before acquiring

Krishnamraju Eraparaju <krishna2@chelsio.com>
    RDMA/siw: Remove unwanted WARN_ON in siw_cm_llp_data_ready()

Sung Lee <sung.lee@amd.com>
    drm/amd/display: Do not set optimized_require to false after plane disable

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ARM: dts: sti: fixup sound frame-inversion for stihxxx-b2120.dtsi

Xiubo Li <xiubli@redhat.com>
    ceph: do not execute direct write in parallel if O_APPEND is specified

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/msr: Add Tremont support

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/cstate: Add Tremont support

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add Elkhart Lake support

Peter Zijlstra <peterz@infradead.org>
    arm/ftrace: Fix BE text poking

John Garry <john.garry@huawei.com>
    perf/smmuv3: Use platform_get_irq_optional() for wired interrupt

Trond Myklebust <trondmy@gmail.com>
    NFSv4: Fix races between open and dentry revalidation

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: unconditionally reject 2 ep interfaces

Bjørn Mork <bjorn@mork.no>
    qmi_wwan: re-add DW5821e pre-production variant

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: fix card and queue total counter wrap

Stefano Garzarella <sgarzare@redhat.com>
    io_uring: flush overflowed CQ events in the io_uring_poll()

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    cfg80211: check wiphy driver existence for drvinfo report

Johannes Berg <johannes.berg@intel.com>
    mac80211: consider more elements in parsing CRC

Jeff Moyer <jmoyer@redhat.com>
    dax: pass NOWAIT flag to iomap_apply

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Prevent unlimited runtime on throttled group

Peter Zijlstra (Intel) <peterz@infradead.org>
    timers/nohz: Update NOHZ load in remote tick

Scott Wood <swood@redhat.com>
    sched/core: Don't skip remote tick for idle CPUs

Sean Paul <seanpaul@chromium.org>
    drm/msm: Set dma maximum segment size for mdss

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Handle a possible NULL pointer reference

Eric Dumazet <edumazet@google.com>
    net: rtnetlink: fix bugs in rtnl_alt_ifname()

Alexandre Belloni <alexandre.belloni@bootlin.com>
    net: macb: Properly handle phylink on at91rm9200

Eric Dumazet <edumazet@google.com>
    net: add strict checks in netdev_name_node_alt_destroy()

Shannon Nelson <snelson@pensando.io>
    ionic: fix fw_status read

Benjamin Poirier <bpoirier@cumulusnetworks.com>
    ipv6: Fix nlmsg_flags when splitting a multipath route

Benjamin Poirier <bpoirier@cumulusnetworks.com>
    ipv6: Fix route replacement with dev-only route

Taehee Yoo <ap420073@gmail.com>
    bonding: fix lockdep warning in bond_get_stats()

Taehee Yoo <ap420073@gmail.com>
    net: export netdev_next_lower_dev_rcu()

Taehee Yoo <ap420073@gmail.com>
    bonding: add missing netdev_update_lockdep_key()

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Improve device shutdown method.

Xin Long <lucien.xin@gmail.com>
    sctp: move the format error check out of __sctp_sf_do_9_1_abort

Willem de Bruijn <willemb@google.com>
    udp: rehash on disconnect

Paolo Abeni <pabeni@redhat.com>
    Revert "net: dev: introduce support for sch BYPASS for lockless qdisc"

Michal Kalderon <michal.kalderon@marvell.com>
    qede: Fix race between rdma destroy workqueue and link change event

Dmitry Osipenko <digetx@gmail.com>
    nfc: pn544: Fix occasional HW initialization failure

Rohit Maheshwari <rohitm@chelsio.com>
    net/tls: Fix to avoid gettig invalid tls record

Jason Baron <jbaron@akamai.com>
    net: sched: correct flower port blocking

Arun Parameswaran <arun.parameswaran@broadcom.com>
    net: phy: restore mdio regs in the iproc mdio driver

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: mscc: fix in frame extraction

Alexandre Belloni <alexandre.belloni@bootlin.com>
    net: macb: ensure interface is not suspended on at91rm9200

Jethro Beekman <jethro@fortanix.com>
    net: fib_rules: Correctly set table field when table number exceeds 8 bits

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Ensure the default VID is untagged

Aristeu Rozanski <aris@redhat.com>
    EDAC: skx_common: downgrade message importance on missing PCI device


-------------

Diffstat:

 Documentation/networking/nf_flowtable.txt          |   2 +-
 Documentation/sphinx/parallel-wrapper.sh           |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/stihxxx-b2120.dtsi               |   2 +-
 arch/arm/include/asm/vdso/vsyscall.h               |   4 +-
 arch/arm/kernel/ftrace.c                           |   7 +-
 arch/mips/include/asm/sync.h                       |   4 +-
 arch/mips/kernel/vpe.c                             |   2 +-
 arch/riscv/kernel/traps.c                          |   4 +-
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/events/intel/cstate.c                     |  22 +-
 arch/x86/events/msr.c                              |   3 +-
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/include/uapi/asm/kvm.h                    |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h             |   1 +
 arch/x86/kernel/cpu/resctrl/monitor.c              |   4 +-
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/svm.c                                 |  44 ++
 arch/x86/kvm/vmx/nested.c                          | 105 ++--
 arch/x86/kvm/vmx/nested.h                          |   5 +
 arch/x86/kvm/vmx/vmx.c                             |  52 +-
 arch/x86/kvm/vmx/vmx.h                             |   3 +
 arch/x86/kvm/x86.c                                 |   8 +-
 drivers/acpi/acpi_watchdog.c                       |   3 +-
 drivers/bus/Kconfig                                |   1 -
 drivers/char/ipmi/ipmi_ssif.c                      |  10 +-
 drivers/clk/qcom/clk-rpmh.c                        |   2 +-
 drivers/cpufreq/cpufreq.c                          |  12 +-
 drivers/devfreq/devfreq.c                          |   4 +-
 drivers/edac/skx_common.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  37 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile    |   6 +
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |   6 +
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c       |   2 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   1 -
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   6 +
 .../drm/amd/include/asic_reg/dce/dce_12_0_offset.h |   2 +
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c       |   4 +-
 drivers/gpu/drm/i915/gvt/dmabuf.c                  |   2 +-
 drivers/gpu/drm/i915/gvt/vgpu.c                    |   2 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   8 +
 drivers/gpu/drm/radeon/radeon_drv.c                |  43 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   6 +
 drivers/hid/hid-alps.c                             |   2 +-
 drivers/hid/hid-core.c                             |   4 +-
 drivers/hid/hid-ite.c                              |   5 +-
 drivers/hid/usbhid/hiddev.c                        |   2 +-
 drivers/i2c/busses/i2c-altera.c                    |   2 +-
 drivers/i2c/busses/i2c-jz4780.c                    |  36 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |  37 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  80 +--
 drivers/infiniband/sw/siw/siw_cm.c                 |   5 +-
 drivers/macintosh/therm_windtunnel.c               |  52 +-
 drivers/md/bcache/alloc.c                          |  18 +-
 drivers/md/bcache/btree.c                          |  13 +
 drivers/net/bonding/bond_main.c                    |  55 +-
 drivers/net/bonding/bond_options.c                 |   2 +
 drivers/net/dsa/b53/b53_common.c                   |   3 +
 drivers/net/ethernet/amazon/ena/ena_com.c          |  96 ++--
 drivers/net/ethernet/amazon/ena/ena_com.h          |   9 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |  46 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |   2 +
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |   5 +
 .../net/ethernet/aquantia/atlantic/aq_filters.c    |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   8 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  13 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  10 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h   |   3 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |  18 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  12 +-
 drivers/net/ethernet/cadence/macb.h                |   1 +
 drivers/net/ethernet/cadence/macb_main.c           |  66 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  22 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  12 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |  17 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c        |  12 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  17 +-
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |   6 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |  33 +-
 drivers/net/ethernet/intel/ice/ice_lib.h           |   2 -
 drivers/net/ethernet/intel/ice/ice_main.c          |  23 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |   8 +-
 drivers/net/ethernet/mscc/ocelot_board.c           |   8 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |  11 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |   1 +
 drivers/net/ethernet/qlogic/qede/qede.h            |   2 +
 drivers/net/ethernet/qlogic/qede/qede_rdma.c       |  29 +-
 drivers/net/hyperv/netvsc.c                        |   2 +-
 drivers/net/hyperv/netvsc_drv.c                    |   3 +
 drivers/net/phy/mdio-bcm-iproc.c                   |  20 +
 drivers/net/usb/qmi_wwan.c                         |  43 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |  13 -
 drivers/net/wireless/marvell/mwifiex/tdls.c        |  75 +--
 drivers/nfc/pn544/i2c.c                            |   1 +
 drivers/nvme/host/core.c                           |  10 +-
 drivers/nvme/host/pci.c                            |  25 +-
 drivers/nvme/host/rdma.c                           |   2 +-
 drivers/nvme/host/tcp.c                            |   9 +-
 drivers/perf/arm_smmuv3_pmu.c                      |   2 +-
 drivers/pwm/pwm-omap-dmtimer.c                     |  21 +-
 drivers/s390/crypto/ap_bus.h                       |   4 +-
 drivers/s390/crypto/ap_card.c                      |   8 +-
 drivers/s390/crypto/ap_queue.c                     |   6 +-
 drivers/s390/crypto/zcrypt_api.c                   |  16 +-
 drivers/s390/net/qeth_core_main.c                  |   2 +-
 drivers/s390/net/qeth_l2_main.c                    |  29 +-
 drivers/s390/scsi/zfcp_fsf.h                       |   2 +-
 drivers/s390/scsi/zfcp_sysfs.c                     |   2 +-
 drivers/scsi/sd_zbc.c                              |   7 +-
 drivers/soc/tegra/fuse/fuse-tegra30.c              |   3 +-
 drivers/thermal/broadcom/brcmstb_thermal.c         |  31 +-
 drivers/thermal/db8500_thermal.c                   |   4 +-
 drivers/vhost/net.c                                |  10 +-
 drivers/watchdog/wdat_wdt.c                        |   2 +-
 fs/ceph/file.c                                     |  17 +-
 fs/cifs/cifsacl.c                                  |   4 +-
 fs/cifs/connect.c                                  |   2 +-
 fs/cifs/inode.c                                    |   2 +-
 fs/dax.c                                           |   3 +
 fs/ext4/super.c                                    |   6 +-
 fs/f2fs/data.c                                     |  32 +-
 fs/io-wq.c                                         |  22 +-
 fs/io_uring.c                                      |  12 +-
 fs/namei.c                                         |   2 +-
 fs/nfs/nfs4file.c                                  |   1 -
 fs/nfs/nfs4proc.c                                  |  18 +-
 fs/ubifs/orphan.c                                  |   4 +-
 fs/xfs/libxfs/xfs_attr.h                           |   7 +-
 fs/xfs/xfs_ioctl.c                                 |   2 +
 fs/xfs/xfs_ioctl32.c                               |   2 +
 include/acpi/actypes.h                             |   3 +-
 include/asm-generic/vdso/vsyscall.h                |   4 +-
 include/linux/blkdev.h                             |   2 +-
 include/linux/blktrace_api.h                       |  18 +-
 include/linux/hid.h                                |   2 +-
 include/linux/netdevice.h                          |   7 +-
 include/linux/netfilter/ipset/ip_set.h             |  11 +-
 include/linux/sched/nohz.h                         |   2 +
 include/net/flow_dissector.h                       |   9 +
 include/uapi/linux/usb/charger.h                   |  16 +-
 kernel/audit.c                                     |  40 +-
 kernel/auditfilter.c                               |  71 +--
 kernel/kprobes.c                                   |   4 +-
 kernel/locking/lockdep_proc.c                      |   4 +-
 kernel/padata.c                                    |   4 +-
 kernel/rcu/tree_exp.h                              |  11 +-
 kernel/sched/core.c                                |  31 +-
 kernel/sched/fair.c                                |   7 +-
 kernel/sched/loadavg.c                             |  33 +-
 kernel/time/vsyscall.c                             |  37 +-
 kernel/trace/blktrace.c                            | 114 +++-
 kernel/trace/trace.c                               |   2 +
 mm/debug.c                                         |   8 +-
 mm/gup.c                                           |   3 +-
 mm/huge_memory.c                                   |  26 +-
 net/core/dev.c                                     |  34 +-
 net/core/fib_rules.c                               |   2 +-
 net/core/rtnetlink.c                               |  26 +-
 net/ipv4/udp.c                                     |   6 +-
 net/ipv6/ip6_fib.c                                 |   7 +-
 net/ipv6/route.c                                   |   1 +
 net/mac80211/mlme.c                                |   6 +-
 net/mac80211/util.c                                |  34 +-
 net/netfilter/ipset/ip_set_core.c                  |  34 +-
 net/netfilter/ipset/ip_set_hash_gen.h              | 635 ++++++++++++++-------
 net/netfilter/nft_tunnel.c                         |   4 +-
 net/netfilter/xt_hashlimit.c                       |  12 +-
 net/netlink/af_netlink.c                           |   5 +-
 net/sched/cls_flower.c                             |   1 +
 net/sctp/sm_statefuns.c                            |  29 +-
 net/smc/af_smc.c                                   |   2 +
 net/smc/smc_clc.c                                  |   4 +-
 net/tipc/socket.c                                  |   2 +
 net/tls/tls_device.c                               |  20 +-
 net/wireless/ethtool.c                             |   8 +-
 net/wireless/nl80211.c                             |   5 +-
 scripts/Makefile.lib                               |   4 +-
 security/integrity/ima/ima_policy.c                |  44 +-
 tools/perf/builtin-report.c                        |   6 +-
 tools/perf/ui/browsers/hists.c                     |   1 +
 tools/perf/ui/gtk/Build                            |   5 +
 tools/perf/util/map.c                              |   1 +
 tools/testing/selftests/ftrace/Makefile            |   2 +-
 tools/testing/selftests/livepatch/Makefile         |   2 +
 tools/testing/selftests/net/fib_tests.sh           |   6 +
 tools/testing/selftests/rseq/Makefile              |   2 +
 tools/testing/selftests/rtc/Makefile               |   2 +
 virt/kvm/kvm_main.c                                |  12 +-
 196 files changed, 2077 insertions(+), 1118 deletions(-)


