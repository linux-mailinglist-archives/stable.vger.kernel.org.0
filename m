Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54846B419B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjCJNyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjCJNyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:54:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D64610FBA0;
        Fri, 10 Mar 2023 05:54:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D17F61771;
        Fri, 10 Mar 2023 13:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BE9C433D2;
        Fri, 10 Mar 2023 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456479;
        bh=gpQg90FwOrx+Eh01CLBjp5lQ4EWD8cbkW7WEs43YfaM=;
        h=From:To:Cc:Subject:Date:From;
        b=g4F83ennF7CYAYoeQqB/pZiDfIHZQX68sTIM9iKQ4uOcjLAyoHgjcfZ9t8z9K6sXH
         JiuxzI2su+NfilKHg8Y69Zi7rZthc3eVM20YZSc/bk2/TCtUpeI2BuFGFMQcokNXxP
         mahbMtC5PI8GoNeKyzFDxR9AWwZLjZ2SeSV6JJnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.2 000/211] 6.2.4-rc1 review
Date:   Fri, 10 Mar 2023 14:36:20 +0100
Message-Id: <20230310133718.689332661@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.2.4-rc1
X-KernelTest-Deadline: 2023-03-12T13:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.2.4 release.
There are 211 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.2.4-rc1

Yang Yingliang <yangyingliang@huawei.com>
    usb: gadget: uvc: fix missing mutex_unlock() if kstrtou8() fails

Pierre Gondois <pierre.gondois@arm.com>
    arm64: efi: Make efi_rt_lock a raw_spinlock

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix race condition with usb_kill_urb

Imre Deak <imre.deak@intel.com>
    drm/i915: Fix system suspend without fbdev being initialized

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Fix payload removal during output disabling

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Handle old/new payload states in drm_dp_remove_payload()

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Add the MST topology state for modesetted CRTCs

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Fix payload addition on a disconnected sink

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Fix down message handling after a packet reception error

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Fix down/up message handling after sink disconnect

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Add drm_atomic_get_old_mst_topology_state()

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: allocate the adapter in dev_add()

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: manage ifcvf_hw in the mgmt_dev

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: ifcvf_request_irq works on ifcvf_hw

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: decouple config/dev IRQ requester and vectors allocator from the adapter

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: decouple vq irq requester from the adapter

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: decouple config IRQ releaser from the adapter

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: decouple vq IRQ releasers from the adapter

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: alloc the mgmt_dev before the adapter

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: decouple config space ops from the adapter

Zhu Lingshan <lingshan.zhu@intel.com>
    vDPA/ifcvf: decouple hw features manipulators from the adapter

Linus Torvalds <torvalds@linux-foundation.org>
    x86/resctl: fix scheduler confusion with 'current'

Jakub Kicinski <kuba@kernel.org>
    net: tls: avoid hanging tasks on the tx_lock

Jakub Kicinski <kuba@kernel.org>
    eth: fealnx: bring back this old driver

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Drain the RX FIFO after an IO timeout

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Remove wasted space in response_buf

Kees Cook <keescook@chromium.org>
    RDMA/cma: Distinguish between sockaddr_in and sockaddr_in6 by size

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    phy: rockchip-typec: Fix unsigned comparison with less than zero

Manivannan Sadhasivam <mani@kernel.org>
    PCI: pciehp: Add Qualcomm quirk for Command Completed erratum

Mengyuan Lou <mengyuanlou@net-swift.com>
    PCI: Add ACS quirk for Wangxun NICs

Huacai Chen <chenhuacai@kernel.org>
    PCI: loongson: Add more devices that need MRRS quirk

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kernel/fail_function: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drivers: base: dd: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drivers: base: component: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    misc: vmw_balloon: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    tty: pcn_uart: fix memory leak with using debugfs_lookup()

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Distribute available resources for root buses, too

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Take other bus devices into account when distributing resources

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Align extra resources for hotplug bridges properly

Daniel Scally <dan.scally@ideasonboard.com>
    usb: gadget: uvc: Make bSourceID read/write

Daniel Scally <dan.scally@ideasonboard.com>
    usb: uvc: Enumerate valid values for color matching

Kees Cook <keescook@chromium.org>
    USB: ene_usb6250: Allocate enough memory for full object

Kees Cook <keescook@chromium.org>
    usb: host: xhci: mvebu: Iterate over array indexes instead of using pointer math

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: pxa27x_udc: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: pxa25x_udc: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: lpc32xx_udc: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: bcm63xx_udc: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: gr_udc: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: isp1362: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: isp116x: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: fotg210: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: sl811: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: uhci: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: ULPI: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: chipidea: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: dwc3: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: pi433: fix memory leak with using debugfs_lookup()

Huacai Chen <chenhuacai@kernel.org>
    PCI: loongson: Prevent LS7A MRRS increases

Huacai Chen <chenhuacai@kernel.org>
    PCI/portdrv: Prevent LS7A Bus Master clearing on shutdown

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: bus_type: Avoid lockdep assert in sdw_drv_probe()

Marek Vasut <marex@denx.de>
    media: uvcvideo: Add GUID for BGRA/X 8:8:8:8

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Fix the debug message for MHI_PKT_TYPE_RESET_CHAN_CMD cmd

Yulong Zhang <yulong.zhang@metoak.net>
    tools/iio/iio_utils:fix memory leak

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus-fixup:upon error print return values of send and receive

Isaac True <isaac.true@canonical.com>
    serial: sc16is7xx: setup GPIO controller later in probe

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: disable the CTS when send break signal

Sven Schnelle <svens@linux.ibm.com>
    tty: fix out-of-bounds access in tty_driver_lookup_tty()

Yuan Can <yuancan@huawei.com>
    staging: emxx_udc: Add checks for dma_alloc_coherent()

Anand Moon <linux.amoon@gmail.com>
    dt-bindings: usb: Add device id for Genesys Logic hub controller

Linus Walleij <linus.walleij@linaro.org>
    usb: fotg210: List different variants

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    cacheinfo: Fix shared_cpu_map to handle shared caches at different levels

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: fix memory leak with using debugfs_lookup()

Kees Cook <keescook@chromium.org>
    media: uvcvideo: Silence memcpy() run-time false positive warnings

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Quirk for autosuspend in Logitech B910 and C910

Guenter Roeck <linux@roeck-us.net>
    media: uvcvideo: Handle errors from calls to usb_string

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Handle cameras with invalid descriptors

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Remove format descriptions

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/ACPI: Account for _S0W of the target bridge in acpi_pci_bridge_d3()

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Remove deferred attach check from __iommu_detach_device()

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Update RMT size calculation

Liang He <windhl@126.com>
    mfd: arizona: Use pm_runtime_resume_and_get() to prevent refcnt leak

Souradeep Chowdhury <quic_schowdhu@quicinc.com>
    bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support

Darrell Kavanagh <darrell.kavanagh@gmail.com>
    firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kernel/printk/index.c: fix memory leak with using debugfs_lookup()

Jia-Ju Bai <baijiaju1990@gmail.com>
    tracing: Add NULL checks for buffer in ring_buffer_free_read_page()

Dan Carpenter <error27@gmail.com>
    cpufreq: apple-soc: Fix an IS_ERR() vs NULL check

Randy Dunlap <rdunlap@infradead.org>
    thermal: intel: BXT_PMIC: select REGMAP instead of depending on it

Dan Carpenter <error27@gmail.com>
    thermal: intel: quark_dts: fix error pointer dereference

Trevor Wu <trevor.wu@mediatek.com>
    ASoC: mediatek: mt8195: add missing initialization

Arnd Bergmann <arnd@arndb.de>
    ASoC: zl38060 add gpiolib dependency

Daniel Wagner <dwagner@suse.de>
    nvme-fabrics: show well known discovery name

Akinobu Mita <akinobu.mita@gmail.com>
    nvme-tcp: don't access released socket during error recovery

Christoph Hellwig <hch@lst.de>
    nvme: bring back auto-removal of deleted namespaces during sequential scan

Martin Povišer <povik+lin@cutebit.org>
    ASoC: apple: mca: Improve handling of unavailable DMA channels

Martin Povišer <povik+lin@cutebit.org>
    ASoC: apple: mca: Fix SERDES reset sequence

Martin Povišer <povik+lin@cutebit.org>
    ASoC: apple: mca: Fix final status read on SERDES reset

Nuno Sá <nuno.sa@analog.com>
    ASoC: adau7118: don't disable regulators on device unbind

Zhong Jinghua <zhongjinghua@huawei.com>
    loop: loop_set_status_from_info() check before assignment

Wojciech Lukowicz <wlukowicz01@gmail.com>
    io_uring: fix size calculation when registering buf ring

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: allow rtc_read_alarm without read_alarm callback

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: mpi3mr: Use number of bits to manage bitmap sizes

Tomas Henzl <thenzl@redhat.com>
    scsi: mpi3mr: Fix an issue found by KASAN

Arnd Bergmann <arnd@arndb.de>
    scsi: ipr: Work around fortify-string warning

Sergey Shtylyov <s.shtylyov@omp.ru>
    genirq/ipi: Fix NULL pointer deref in irq_data_get_affinity_mask()

Samuel Holland <samuel@sholland.org>
    rtc: sun6i: Always export the internal oscillator

Krishna Yarlagadda <kyarlagadda@nvidia.com>
    spi: tegra210-quad: Fix iterator outside loop

George Kennedy <george.kennedy@oracle.com>
    vc_screen: modify vcs_size() handling in vcs_read()

Eric Dumazet <edumazet@google.com>
    tcp: tcp_check_req() can be called from process context

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: spear320-hmi: correct STMPE GPIO compatible

Eddie James <eajames@linux.ibm.com>
    ARM: dts: aspeed: p10bmc: Update battery node name

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix internal MDIO controller resource length

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: seville: ignore mscc-miim read errors from Lynx PCS

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_sample: fix action bind logic

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_mpls: fix action bind logic

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_pedit: fix action bind logic

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: transition act_pedit to rcu and percpu stats

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: fix memory leak of se_io context in nfc_genl_se_io

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix incorrect options show of original mount_opt and extend mount_opt2

Maor Dickman <maord@nvidia.com>
    net/mlx5: Geneve, Fix handling of Geneve object id as error code

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Verify flow_source cap before using it

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: ECPF, wait for VF pages only after disabling host PFs

Vadim Fedorenko <vadfed@meta.com>
    mlx5: fix possible ptp queue fifo use-after-free

Vadim Fedorenko <vadfed@meta.com>
    mlx5: fix skb leak while fifo resync and push

Krishna Yarlagadda <kyarlagadda@nvidia.com>
    spi: tegra210-quad: Fix validate combined sequence

Zhengchao Shao <shaozhengchao@huawei.com>
    9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()

Juergen Gross <jgross@suse.com>
    9p/xen: fix connection sequence

Juergen Gross <jgross@suse.com>
    9p/xen: fix version parsing

Eric Dumazet <edumazet@google.com>
    net: fix __dev_kfree_skb_any() vs drop monitor

Deepak R Varma <drv@mailo.com>
    octeontx2-pf: Use correct struct reference in test condition

Xin Long <lucien.xin@gmail.com>
    sctp: add a refcnt in sctp_stream_priorities to avoid a nested loop

Sean Anderson <seanga2@gmail.com>
    net: sunhme: Fix region request

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Recalculate UDP checksum for ptp 1-step sync packet

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/xelpmp: Consider GSI offset when doing MCR lookups

Lu Wei <luwei32@huawei.com>
    ipv6: Add lwtunnel encap size of all siblings in nexthop calculation

Randy Dunlap <rdunlap@infradead.org>
    drm/i915: move a Kconfig symbol to unbreak the menu presentation

Íñigo Huguet <ihuguet@redhat.com>
    ptp: vclock: use mutex to fix "sleep on atomic" bug

Randy Dunlap <rdunlap@infradead.org>
    swiotlb: mark swiotlb_memblock_alloc() as __init

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    netfilter: x_tables: fix percpu counter block leak on error path when creating new netns

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: make event listener tracking global

Xin Long <lucien.xin@gmail.com>
    netfilter: xt_length: use skb len to match in length_mt6

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: fix table blob use-after-free

Phil Sutter <phil@nwl.cc>
    netfilter: ip6t_rpfilter: Fix regression with VRF interfaces

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: fix rmmod double-free race

Hangyu Hua <hbh25y@gmail.com>
    netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()

George Cherian <george.cherian@marvell.com>
    watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

Li Hua <hucool.lihua@huawei.com>
    watchdog: pcwd_usb: Fix attempting to access uninitialized memory

Chen Jun <chenjun102@huawei.com>
    watchdog: Fix kmemleak in watchdog_cdev_register

ruanjinjie <ruanjinjie@huawei.com>
    watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    watchdog: rzg2l_wdt: Handle TYPE-B reset for RZ/V2M

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    watchdog: rzg2l_wdt: Issue a reset before we put the PM clocks

Daeho Jeong <daehojeong@google.com>
    f2fs: synchronize atomic write aborts

Benjamin Berg <benjamin.berg@intel.com>
    um: virt-pci: properly remove PCI device from bus

Benjamin Berg <benjamin.berg@intel.com>
    um: virtio_uml: move device breaking into workqueue

Benjamin Berg <benjamin.berg@intel.com>
    um: virtio_uml: mark device as unregistered when breaking it

Benjamin Berg <benjamin.berg@intel.com>
    um: virtio_uml: free command if adding to virtqueue failed

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    x86: um: vdso: Add '%rcx' and '%r11' to the syscall clobber list

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: allow to fetch set elements when table has an owner

Wang Jianjian <wangjianjian3@huawei.com>
    ext4: don't show commit interval if it is zero

Eric Biggers <ebiggers@google.com>
    ext4: use ext4_fc_tl_mem in fast-commit replay path

Yangtao Li <frank.li@vivo.com>
    f2fs: fix to set ipu policy

Yangtao Li <frank.li@vivo.com>
    f2fs: introduce IS_F2FS_IPU_* macro

Stephen Boyd <swboyd@chromium.org>
    soc: qcom: stats: Populate all subsystem debugfs files

Chao Yu <chao@kernel.org>
    f2fs: fix to update age extent in f2fs_do_zero_range()

Chao Yu <chao@kernel.org>
    f2fs: fix to update age extent correctly during truncation

Yangtao Li <frank.li@vivo.com>
    f2fs: fix to avoid potential memory corruption in __update_iostat_latency()

Chao Yu <chao@kernel.org>
    f2fs: fix to handle F2FS_IOC_START_ATOMIC_REPLACE in f2fs_compat_ioctl()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix missed fm_anchor PEB in wear-leveling after disabling fastmap

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: ubifs_releasepage: Remove ubifs_assert(0) to valid this process

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: ubifs_writepage: Mark page dirty after writing inode failed

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: dirty_cow_znode: Fix memleak in error handling path

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Re-statistic cleaned znode count if commit failed

Yang Yingliang <yangyingliang@huawei.com>
    ubi: Fix possible null-ptr-deref in ubi_free_volume()

Li Zetao <lizetao1@huawei.com>
    ubifs: Fix memory leak in alloc_wbufs()

Li Zetao <lizetao1@huawei.com>
    ubi: Fix unreferenced object reported by kmemleak in ubi_resize_volume()

Li Zetao <lizetao1@huawei.com>
    ubi: Fix use-after-free when volume resizing failed

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Reserve one leb for each journal head while doing budget

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: do_rename: Fix wrong space budget when target inode's nlink > 1

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix wrong dirty space budget for dirty inode

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Rectify space budget for ubifs_xrename()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Rectify space budget for ubifs_symlink() if symlink is encrypted

Liu Shixin <liushixin2@huawei.com>
    ubifs: Fix memory leak in ubifs_sysfs_init()

Li Hua <hucool.lihua@huawei.com>
    ubifs: Fix build errors as symbol undefined

George Kennedy <george.kennedy@oracle.com>
    ubi: ensure that VID header offset + VID header size <= alloc, size

Xiang Yang <xiangyang3@huawei.com>
    um: vector: Fix memory leak in vector_config

Chao Yu <chao@kernel.org>
    f2fs: fix to abort atomic write only during do_exist()

Yangtao Li <frank.li@vivo.com>
    f2fs: allow set compression option of files without blocks

Alexander Potapenko <glider@google.com>
    fs: f2fs: initialize fsdata in pagecache_write()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on extent cache correctly

Shang XiaoJing <shangxiaojing@huawei.com>
    soc: mediatek: mtk-svs: Use pm_runtime_resume_and_get() in svs_init01()

Roger Lu <roger.lu@mediatek.com>
    soc: mediatek: mtk-svs: reset svs when svs_resume() fail

Roger Lu <roger.lu@mediatek.com>
    soc: mediatek: mtk-svs: restore default voltages when svs_init02() fail

Chao Yu <chao@kernel.org>
    f2fs: clear atomic_write_task in f2fs_abort_atomic_write()

Chao Yu <chao@kernel.org>
    f2fs: introduce trace_f2fs_replace_atomic_write_block

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    pwm: stm32-lp: fix the check on arr and cmp registers update

Emil Renner Berthing <emil.renner.berthing@canonical.com>
    pwm: sifive: Always let the first pwm_apply_state succeed

Ricardo Ribalda <ribalda@chromium.org>
    soc: mediatek: mtk-svs: Enable the IRQ later

Geert Uytterhoeven <geert+renesas@glider.be>
    memory: renesas-rpc-if: Move resource acquisition to .probe()

Geert Uytterhoeven <geert+renesas@glider.be>
    memory: renesas-rpc-if: Split-off private data from struct rpcif

Stephan Gerhold <stephan@gerhold.net>
    soc: qcom: socinfo: Fix soc_id order

Tinghan Shen <tinghan.shen@mediatek.com>
    soc: mediatek: mtk-pm-domains: Allow mt8186 ADSP default power on

Miaoqian Lin <linmq006@gmail.com>
    objtool: Fix memory leak in create_static_call_sections()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadlock

Christoph Hellwig <hch@lst.de>
    f2fs: don't rely on F2FS_MAP_* in f2fs_iomap_begin

Gaosheng Cui <cuigaosheng1@huawei.com>
    driver: soc: xilinx: fix memory leak in xlnx_add_cb_for_notify_event()

Liu Shixin via Jfs-discussion <jfs-discussion@lists.sourceforge.net>
    fs/jfs: fix shift exponent db_agl2size negative

Jianglei Nie <niejianglei2021@163.com>
    auxdisplay: hd44780: Fix potential memory leak in hd44780_remove()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Retire tcindex classifier


-------------

Diffstat:

 Documentation/ABI/testing/configfs-usb-gadget-uvc  |    2 +-
 .../devicetree/bindings/usb/genesys,gl850g.yaml    |    1 +
 Makefile                                           |    4 +-
 arch/arm/boot/dts/aspeed-bmc-ibm-bonnell.dts       |    2 +-
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts       |    2 +-
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts       |    2 +-
 arch/arm/boot/dts/spear320-hmi.dts                 |    2 +-
 arch/arm64/include/asm/efi.h                       |    6 +-
 arch/arm64/kernel/efi.c                            |    2 +-
 arch/mips/configs/mtx1_defconfig                   |    1 +
 arch/powerpc/configs/ppc6xx_defconfig              |    1 +
 arch/um/drivers/vector_kern.c                      |    1 +
 arch/um/drivers/virt-pci.c                         |   26 +-
 arch/um/drivers/virtio_uml.c                       |   18 +-
 arch/x86/include/asm/resctrl.h                     |   12 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |    4 +-
 arch/x86/kernel/process_32.c                       |    2 +-
 arch/x86/kernel/process_64.c                       |    2 +-
 arch/x86/um/vdso/um_vdso.c                         |   12 +-
 drivers/acpi/device_pm.c                           |   19 +
 drivers/auxdisplay/hd44780.c                       |    2 +
 drivers/base/cacheinfo.c                           |   27 +-
 drivers/base/component.c                           |    2 +-
 drivers/base/dd.c                                  |    2 +-
 drivers/block/loop.c                               |    8 +-
 drivers/bus/mhi/ep/main.c                          |    2 +-
 drivers/cpufreq/apple-soc-cpufreq.c                |    4 +-
 drivers/firmware/efi/sysfb_efi.c                   |    8 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |    2 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   71 +-
 drivers/gpu/drm/i915/Kconfig                       |    6 +-
 drivers/gpu/drm/i915/display/intel_display.c       |    4 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |   75 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.h        |    4 +
 drivers/gpu/drm/i915/display/intel_fbdev.c         |    8 +-
 drivers/gpu/drm/i915/gt/intel_gt_mcr.c             |    5 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |    2 +-
 drivers/iio/accel/mma9551_core.c                   |   10 +-
 drivers/infiniband/core/cma.c                      |   17 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   59 +-
 drivers/iommu/iommu.c                              |   70 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |    5 +
 drivers/media/usb/uvc/uvc_driver.c                 |   90 +-
 drivers/media/usb/uvc/uvc_entity.c                 |    2 +-
 drivers/media/usb/uvc/uvc_status.c                 |   37 +
 drivers/media/usb/uvc/uvc_v4l2.c                   |    2 -
 drivers/media/usb/uvc/uvc_video.c                  |   15 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    4 +-
 drivers/memory/renesas-rpc-if.c                    |  120 +-
 drivers/mfd/arizona-core.c                         |    2 +-
 drivers/misc/mei/bus-fixup.c                       |    8 +-
 drivers/misc/vmw_balloon.c                         |    2 +-
 drivers/mtd/ubi/build.c                            |    7 +
 drivers/mtd/ubi/fastmap-wl.c                       |   12 +-
 drivers/mtd/ubi/vmt.c                              |   18 +-
 drivers/mtd/ubi/wl.c                               |   25 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |    2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |    4 +-
 drivers/net/ethernet/Kconfig                       |   10 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/fealnx.c                      | 1953 ++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |    2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   76 +-
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |    4 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   25 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |    3 +-
 .../net/ethernet/mellanox/mlx5/core/lib/geneve.c   |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |    4 +
 drivers/net/ethernet/sun/sunhme.c                  |    6 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |    9 +-
 drivers/nfc/st-nci/se.c                            |    6 +
 drivers/nfc/st21nfca/se.c                          |    6 +
 drivers/nvme/host/core.c                           |   35 +-
 drivers/nvme/host/fabrics.h                        |    3 +-
 drivers/nvme/host/tcp.c                            |    6 +
 drivers/pci/controller/pci-loongson.c              |   71 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |    2 +
 drivers/pci/pci-acpi.c                             |   45 +-
 drivers/pci/pci.c                                  |   10 +
 drivers/pci/pcie/portdrv.c                         |   16 +-
 drivers/pci/quirks.c                               |   22 +
 drivers/pci/setup-bus.c                            |  236 ++-
 drivers/phy/rockchip/phy-rockchip-typec.c          |    3 +-
 drivers/ptp/ptp_private.h                          |    2 +-
 drivers/ptp/ptp_vclock.c                           |   44 +-
 drivers/pwm/pwm-sifive.c                           |    8 +-
 drivers/pwm/pwm-stm32-lp.c                         |    2 +-
 drivers/rtc/interface.c                            |    2 +-
 drivers/rtc/rtc-sun6i.c                            |   16 +-
 drivers/scsi/ipr.c                                 |   41 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   10 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   75 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |    2 +-
 drivers/soc/mediatek/mt8186-pm-domains.h           |    4 +-
 drivers/soc/mediatek/mtk-svs.c                     |   48 +-
 drivers/soc/qcom/qcom_stats.c                      |   10 +-
 drivers/soc/qcom/socinfo.c                         |    6 +-
 drivers/soc/xilinx/xlnx_event_manager.c            |    4 +-
 drivers/soundwire/bus_type.c                       |    9 +-
 drivers/soundwire/cadence_master.c                 |   43 +-
 drivers/soundwire/cadence_master.h                 |   13 +-
 drivers/spi/spi-tegra210-quad.c                    |   14 +-
 drivers/staging/emxx_udc/emxx_udc.c                |    7 +-
 drivers/staging/pi433/pi433_if.c                   |   11 +-
 drivers/thermal/intel/Kconfig                      |    3 +-
 drivers/thermal/intel/intel_quark_dts_thermal.c    |   12 +-
 drivers/tty/serial/fsl_lpuart.c                    |   24 +-
 drivers/tty/serial/pch_uart.c                      |    2 +-
 drivers/tty/serial/sc16is7xx.c                     |   51 +-
 drivers/tty/tty_io.c                               |    8 +-
 drivers/tty/vt/vc_screen.c                         |    4 +-
 drivers/usb/chipidea/debug.c                       |    2 +-
 drivers/usb/common/ulpi.c                          |   14 +-
 drivers/usb/core/usb.c                             |    2 +-
 drivers/usb/dwc3/core.h                            |    2 +
 drivers/usb/dwc3/debug.h                           |    3 +
 drivers/usb/dwc3/debugfs.c                         |   19 +-
 drivers/usb/dwc3/gadget.c                          |    4 +-
 drivers/usb/fotg210/fotg210-core.c                 |    2 +
 drivers/usb/fotg210/fotg210-hcd.c                  |    2 +-
 drivers/usb/gadget/function/uvc_configfs.c         |   59 +-
 drivers/usb/gadget/udc/bcm63xx_udc.c               |    2 +-
 drivers/usb/gadget/udc/gr_udc.c                    |    2 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |    2 +-
 drivers/usb/gadget/udc/pxa25x_udc.c                |    2 +-
 drivers/usb/gadget/udc/pxa27x_udc.c                |    2 +-
 drivers/usb/host/isp116x-hcd.c                     |    2 +-
 drivers/usb/host/isp1362-hcd.c                     |    2 +-
 drivers/usb/host/sl811-hcd.c                       |    2 +-
 drivers/usb/host/uhci-hcd.c                        |    6 +-
 drivers/usb/host/xhci-mvebu.c                      |    2 +-
 drivers/usb/storage/ene_ub6250.c                   |    2 +-
 drivers/vdpa/ifcvf/ifcvf_base.c                    |   30 +-
 drivers/vdpa/ifcvf/ifcvf_base.h                    |    6 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |  139 +-
 drivers/watchdog/at91sam9_wdt.c                    |    7 +-
 drivers/watchdog/pcwd_usb.c                        |    6 +-
 drivers/watchdog/rzg2l_wdt.c                       |   45 +-
 drivers/watchdog/sbsa_gwdt.c                       |    1 +
 drivers/watchdog/watchdog_dev.c                    |    2 +-
 fs/ext4/ext4.h                                     |    1 +
 fs/ext4/fast_commit.c                              |   44 +-
 fs/ext4/super.c                                    |   30 +-
 fs/f2fs/data.c                                     |   49 +-
 fs/f2fs/file.c                                     |   60 +-
 fs/f2fs/inode.c                                    |   23 +-
 fs/f2fs/iostat.c                                   |    6 +-
 fs/f2fs/segment.c                                  |   13 +-
 fs/f2fs/segment.h                                  |   23 +
 fs/f2fs/super.c                                    |   17 +-
 fs/f2fs/sysfs.c                                    |    9 +
 fs/f2fs/verity.c                                   |    2 +-
 fs/jfs/jfs_dmap.c                                  |    3 +-
 fs/ubifs/budget.c                                  |    9 +-
 fs/ubifs/dir.c                                     |    9 +-
 fs/ubifs/file.c                                    |   31 +-
 fs/ubifs/super.c                                   |   17 +-
 fs/ubifs/sysfs.c                                   |    2 +
 fs/ubifs/tnc.c                                     |   24 +-
 fs/ubifs/ubifs.h                                   |    5 +
 include/acpi/acpi_bus.h                            |    1 +
 include/drm/display/drm_dp_mst_helper.h            |    6 +-
 include/linux/bootconfig.h                         |    2 +-
 include/linux/iommu.h                              |    2 +
 include/linux/mdio/mdio-mscc-miim.h                |    2 +-
 include/linux/netfilter.h                          |    5 +
 include/linux/pci.h                                |    1 +
 include/linux/pci_ids.h                            |    2 +
 include/media/v4l2-uvc.h                           |    8 +
 include/memory/renesas-rpc-if.h                    |   16 -
 include/net/netns/conntrack.h                      |    1 -
 include/net/sctp/structs.h                         |    1 +
 include/net/tc_act/tc_pedit.h                      |   81 +-
 include/net/tc_wrapper.h                           |    5 -
 include/trace/events/f2fs.h                        |   37 +
 include/uapi/linux/usb/video.h                     |   30 +
 include/uapi/linux/uvcvideo.h                      |    2 +-
 io_uring/kbuf.c                                    |    2 +-
 kernel/dma/swiotlb.c                               |    3 +-
 kernel/fail_function.c                             |    5 +-
 kernel/irq/ipi.c                                   |    8 +-
 kernel/printk/index.c                              |    2 +-
 kernel/trace/ring_buffer.c                         |    7 +-
 net/9p/trans_rdma.c                                |   15 +-
 net/9p/trans_xen.c                                 |   48 +-
 net/bridge/netfilter/ebtables.c                    |    2 +-
 net/core/dev.c                                     |    4 +-
 net/ipv4/netfilter/arp_tables.c                    |    4 +
 net/ipv4/netfilter/ip_tables.c                     |    7 +-
 net/ipv4/tcp_minisocks.c                           |    7 +-
 net/ipv6/netfilter/ip6_tables.c                    |    7 +-
 net/ipv6/netfilter/ip6t_rpfilter.c                 |    4 +-
 net/ipv6/route.c                                   |   11 +-
 net/netfilter/core.c                               |    3 +
 net/netfilter/nf_conntrack_bpf.c                   |    1 -
 net/netfilter/nf_conntrack_core.c                  |   25 +-
 net/netfilter/nf_conntrack_ecache.c                |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |    8 +-
 net/netfilter/nf_tables_api.c                      |    2 +-
 net/netfilter/nfnetlink.c                          |    9 +-
 net/netfilter/xt_length.c                          |    3 +-
 net/nfc/netlink.c                                  |    4 +
 net/sched/Kconfig                                  |   11 -
 net/sched/Makefile                                 |    1 -
 net/sched/act_mpls.c                               |   66 +-
 net/sched/act_pedit.c                              |  178 +-
 net/sched/act_sample.c                             |   11 +-
 net/sched/cls_tcindex.c                            |  742 --------
 net/sctp/stream_sched_prio.c                       |   52 +-
 net/tls/tls_sw.c                                   |   26 +-
 sound/soc/apple/mca.c                              |   31 +-
 sound/soc/codecs/Kconfig                           |    1 +
 sound/soc/codecs/adau7118.c                        |   19 +-
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c        |    3 +
 tools/iio/iio_utils.c                              |   23 +-
 tools/objtool/check.c                              |    2 +
 tools/testing/selftests/netfilter/rpath.sh         |   32 +-
 .../tc-testing/tc-tests/filters/tcindex.json       |  227 ---
 221 files changed, 4262 insertions(+), 2206 deletions(-)


