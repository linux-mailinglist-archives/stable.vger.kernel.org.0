Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281A76B4A59
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbjCJPV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbjCJPVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:21:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06DD146914;
        Fri, 10 Mar 2023 07:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 932B461A41;
        Fri, 10 Mar 2023 15:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34938C4339B;
        Fri, 10 Mar 2023 15:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461119;
        bh=GZQX1bLhhMt+tQpWtUTNoU1kYxnIG11DQBZNqOOfm+k=;
        h=From:To:Cc:Subject:Date:From;
        b=UEC1VzEY/+tVbEiwpq9mz4bpp1/WYPdRUF6wGxZt1nmgKvWY81norqtHEUPhusSUX
         5zXLZ7P3sPilALKCD/dUL9336FHzsUIO1AoIGn79BlPNzFwn4t6eHIABUqAbHf/rjG
         UNjnoYmyGSdILNi4SrzeC2Od1jTwHsfFzmRurv4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/136] 5.15.100-rc1 review
Date:   Fri, 10 Mar 2023 14:42:02 +0100
Message-Id: <20230310133706.811226272@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.100-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.100-rc1
X-KernelTest-Deadline: 2023-03-12T13:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.100 release.
There are 136 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.100-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.100-rc1

Yang Yingliang <yangyingliang@huawei.com>
    usb: gadget: uvc: fix missing mutex_unlock() if kstrtou8() fails

Miaoqian Lin <linmq006@gmail.com>
    malidp: Fix NULL vs IS_ERR() checking

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Remove usage of dma_get_required_mask() API

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: re-do lost mpt3sas DMA mask fix

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Don't change DMA mask while reallocating pools

Salvatore Bonaccorso <carnil@debian.org>
    Revert "scsi: mpt3sas: Fix return value check of dma_get_required_mask()"

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    drm/virtio: Fix error code in virtio_gpu_object_shmem_init()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix race condition with usb_kill_urb

Nguyen Dinh Phi <phind.uet@gmail.com>
    Bluetooth: hci_sock: purge socket queues in the destruct() callback

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Fix down message handling after a packet reception error

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Fix down/up message handling after sink disconnect

Linus Torvalds <torvalds@linux-foundation.org>
    x86/resctl: fix scheduler confusion with 'current'

Jakub Kicinski <kuba@kernel.org>
    net: tls: avoid hanging tasks on the tx_lock

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Drain the RX FIFO after an IO timeout

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Remove wasted space in response_buf

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    phy: rockchip-typec: Fix unsigned comparison with less than zero

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
    USB: chipidea: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: dwc3: fix memory leak with using debugfs_lookup()

Huacai Chen <chenhuacai@kernel.org>
    PCI: loongson: Prevent LS7A MRRS increases

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: bus_type: Avoid lockdep assert in sdw_drv_probe()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_config_word()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: accel: mma9551_core: Prevent uninitialized variable in mma9551_read_status_word()

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

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix error handling for pdev_pri_ats_enable()

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

Randy Dunlap <rdunlap@infradead.org>
    thermal: intel: BXT_PMIC: select REGMAP instead of depending on it

Dan Carpenter <error27@gmail.com>
    thermal: intel: quark_dts: fix error pointer dereference

Trevor Wu <trevor.wu@mediatek.com>
    ASoC: mediatek: mt8195: add missing initialization

Arnd Bergmann <arnd@arndb.de>
    ASoC: zl38060 add gpiolib dependency

Mark Brown <broonie@kernel.org>
    ASoC: zl38060: Remove spurious gpiolib select

Nuno Sá <nuno.sa@analog.com>
    ASoC: adau7118: don't disable regulators on device unbind

Zhong Jinghua <zhongjinghua@huawei.com>
    loop: loop_set_status_from_info() check before assignment

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: allow rtc_read_alarm without read_alarm callback

Arnd Bergmann <arnd@arndb.de>
    scsi: ipr: Work around fortify-string warning

Samuel Holland <samuel@sholland.org>
    genirq: Add and use an irq_data_update_affinity helper

Samuel Holland <samuel@sholland.org>
    genirq: Refactor accessors to use irq_data_get_affinity_mask

Samuel Holland <samuel@sholland.org>
    rtc: sun6i: Always export the internal oscillator

George Kennedy <george.kennedy@oracle.com>
    vc_screen: modify vcs_size() handling in vcs_read()

Eric Dumazet <edumazet@google.com>
    tcp: tcp_check_req() can be called from process context

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: spear320-hmi: correct STMPE GPIO compatible

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

Maor Dickman <maord@nvidia.com>
    net/mlx5: Geneve, Fix handling of Geneve object id as error code

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Verify flow_source cap before using it

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

Lu Wei <luwei32@huawei.com>
    ipv6: Add lwtunnel encap size of all siblings in nexthop calculation

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    netfilter: x_tables: fix percpu counter block leak on error path when creating new netns

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: fix table blob use-after-free

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

Eric Biggers <ebiggers@google.com>
    ext4: use ext4_fc_tl_mem in fast-commit replay path

Yangtao Li <frank.li@vivo.com>
    f2fs: fix to avoid potential memory corruption in __update_iostat_latency()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Fix UAF wear-leveling entry in eraseblk_count_seq_show()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix missed fm_anchor PEB in wear-leveling after disabling fastmap

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

Li Hua <hucool.lihua@huawei.com>
    ubifs: Fix build errors as symbol undefined

George Kennedy <george.kennedy@oracle.com>
    ubi: ensure that VID header offset + VID header size <= alloc, size

Xiang Yang <xiangyang3@huawei.com>
    um: vector: Fix memory leak in vector_config

Yangtao Li <frank.li@vivo.com>
    f2fs: allow set compression option of files without blocks

Alexander Potapenko <glider@google.com>
    fs: f2fs: initialize fsdata in pagecache_write()

Eric Biggers <ebiggers@google.com>
    f2fs: use memcpy_{to,from}_page() where possible

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    pwm: stm32-lp: fix the check on arr and cmp registers update

Emil Renner Berthing <emil.renner.berthing@canonical.com>
    pwm: sifive: Always let the first pwm_apply_state succeed

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Reduce time the controller lock is held

Miaoqian Lin <linmq006@gmail.com>
    objtool: Fix memory leak in create_static_call_sections()

Liu Shixin via Jfs-discussion <jfs-discussion@lists.sourceforge.net>
    fs/jfs: fix shift exponent db_agl2size negative

Jianglei Nie <niejianglei2021@163.com>
    auxdisplay: hd44780: Fix potential memory leak in hd44780_remove()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Retire tcindex classifier


-------------

Diffstat:

 Documentation/ABI/testing/configfs-usb-gadget-uvc  |   2 +-
 Makefile                                           |   4 +-
 arch/alpha/kernel/irq.c                            |   2 +-
 arch/arm/boot/dts/spear320-hmi.dts                 |   2 +-
 arch/ia64/kernel/iosapic.c                         |   2 +-
 arch/ia64/kernel/irq.c                             |   4 +-
 arch/ia64/kernel/msi_ia64.c                        |   4 +-
 arch/parisc/kernel/irq.c                           |   2 +-
 arch/um/drivers/vector_kern.c                      |   1 +
 arch/um/drivers/virt-pci.c                         |  26 +-
 arch/um/drivers/virtio_uml.c                       |  18 +-
 arch/x86/include/asm/resctrl.h                     |  12 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   4 +-
 arch/x86/kernel/process_32.c                       |   2 +-
 arch/x86/kernel/process_64.c                       |   2 +-
 arch/x86/um/vdso/um_vdso.c                         |  12 +-
 drivers/auxdisplay/hd44780.c                       |   2 +
 drivers/base/component.c                           |   2 +-
 drivers/base/dd.c                                  |   2 +-
 drivers/block/loop.c                               |   8 +-
 drivers/firmware/efi/sysfb_efi.c                   |   8 +
 drivers/gpu/drm/arm/malidp_planes.c                |   2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   5 +-
 drivers/gpu/drm/virtio/virtgpu_object.c            |   3 +-
 drivers/iio/accel/mma9551_core.c                   |  10 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  59 +-
 drivers/iommu/amd/iommu.c                          |  12 +-
 drivers/irqchip/irq-bcm6345-l1.c                   |   4 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   5 +
 drivers/media/usb/uvc/uvc_driver.c                 |  90 ++-
 drivers/media/usb/uvc/uvc_entity.c                 |   2 +-
 drivers/media/usb/uvc/uvc_status.c                 |  37 +
 drivers/media/usb/uvc/uvc_v4l2.c                   |   2 -
 drivers/media/usb/uvc/uvc_video.c                  |  15 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   4 +-
 drivers/mfd/arizona-core.c                         |   2 +-
 drivers/misc/mei/bus-fixup.c                       |   8 +-
 drivers/misc/vmw_balloon.c                         |   2 +-
 drivers/mtd/ubi/build.c                            |   7 +
 drivers/mtd/ubi/fastmap-wl.c                       |  12 +-
 drivers/mtd/ubi/vmt.c                              |  18 +-
 drivers/mtd/ubi/wl.c                               |  25 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   3 +-
 .../net/ethernet/mellanox/mlx5/core/lib/geneve.c   |   1 +
 drivers/nfc/st-nci/se.c                            |   6 +
 drivers/nfc/st21nfca/se.c                          |   6 +
 drivers/parisc/iosapic.c                           |   2 +-
 drivers/pci/controller/pci-loongson.c              |  71 +-
 drivers/pci/pci.c                                  |  10 +
 drivers/pci/quirks.c                               |  22 +
 drivers/pci/setup-bus.c                            | 179 +++--
 drivers/phy/rockchip/phy-rockchip-typec.c          |   3 +-
 drivers/pwm/pwm-sifive.c                           |  16 +-
 drivers/pwm/pwm-stm32-lp.c                         |   2 +-
 drivers/rtc/interface.c                            |   2 +-
 drivers/rtc/rtc-sun6i.c                            |  16 +-
 drivers/scsi/ipr.c                                 |  41 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  20 +-
 drivers/sh/intc/chip.c                             |   2 +-
 drivers/soundwire/bus_type.c                       |   9 +-
 drivers/soundwire/cadence_master.c                 |  43 +-
 drivers/soundwire/cadence_master.h                 |  13 +-
 drivers/staging/emxx_udc/emxx_udc.c                |   7 +-
 drivers/thermal/intel/Kconfig                      |   3 +-
 drivers/thermal/intel/intel_quark_dts_thermal.c    |  12 +-
 drivers/tty/serial/fsl_lpuart.c                    |  24 +-
 drivers/tty/serial/pch_uart.c                      |   2 +-
 drivers/tty/serial/sc16is7xx.c                     |  51 +-
 drivers/tty/tty_io.c                               |   8 +-
 drivers/tty/vt/vc_screen.c                         |   4 +-
 drivers/usb/chipidea/debug.c                       |   2 +-
 drivers/usb/core/usb.c                             |   2 +-
 drivers/usb/dwc3/core.h                            |   2 +
 drivers/usb/dwc3/debug.h                           |   3 +
 drivers/usb/dwc3/debugfs.c                         |  19 +-
 drivers/usb/dwc3/gadget.c                          |   4 +-
 drivers/usb/gadget/function/uvc_configfs.c         |  59 +-
 drivers/usb/gadget/udc/bcm63xx_udc.c               |   2 +-
 drivers/usb/gadget/udc/gr_udc.c                    |   2 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   2 +-
 drivers/usb/gadget/udc/pxa25x_udc.c                |   2 +-
 drivers/usb/gadget/udc/pxa27x_udc.c                |   2 +-
 drivers/usb/host/fotg210-hcd.c                     |   2 +-
 drivers/usb/host/isp116x-hcd.c                     |   2 +-
 drivers/usb/host/isp1362-hcd.c                     |   2 +-
 drivers/usb/host/sl811-hcd.c                       |   2 +-
 drivers/usb/host/uhci-hcd.c                        |   6 +-
 drivers/usb/host/xhci-mvebu.c                      |   2 +-
 drivers/usb/storage/ene_ub6250.c                   |   2 +-
 drivers/watchdog/at91sam9_wdt.c                    |   7 +-
 drivers/watchdog/pcwd_usb.c                        |   6 +-
 drivers/watchdog/sbsa_gwdt.c                       |   1 +
 drivers/watchdog/watchdog_dev.c                    |   2 +-
 drivers/xen/events/events_base.c                   |   7 +-
 fs/ext4/fast_commit.c                              |  44 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/f2fs/inline.c                                   |  15 +-
 fs/f2fs/iostat.c                                   |   6 +-
 fs/f2fs/super.c                                    |  11 +-
 fs/f2fs/verity.c                                   |  12 +-
 fs/jfs/jfs_dmap.c                                  |   3 +-
 fs/ubifs/budget.c                                  |   9 +-
 fs/ubifs/dir.c                                     |   9 +-
 fs/ubifs/file.c                                    |  12 +-
 fs/ubifs/super.c                                   |  17 +-
 fs/ubifs/tnc.c                                     |  24 +-
 fs/ubifs/ubifs.h                                   |   5 +
 include/linux/bootconfig.h                         |   2 +-
 include/linux/irq.h                                |  18 +-
 include/linux/pci.h                                |   1 +
 include/linux/pci_ids.h                            |   2 +
 include/net/sctp/structs.h                         |   1 +
 include/net/tc_act/tc_pedit.h                      |  81 ++-
 include/uapi/linux/usb/video.h                     |  30 +
 include/uapi/linux/uvcvideo.h                      |   2 +-
 kernel/fail_function.c                             |   5 +-
 kernel/printk/index.c                              |   2 +-
 kernel/trace/ring_buffer.c                         |   7 +-
 net/9p/trans_rdma.c                                |  15 +-
 net/9p/trans_xen.c                                 |  48 +-
 net/bluetooth/hci_sock.c                           |  11 +-
 net/bridge/netfilter/ebtables.c                    |   2 +-
 net/core/dev.c                                     |   4 +-
 net/ipv4/netfilter/arp_tables.c                    |   4 +
 net/ipv4/netfilter/ip_tables.c                     |   7 +-
 net/ipv4/tcp_minisocks.c                           |   7 +-
 net/ipv6/netfilter/ip6_tables.c                    |   7 +-
 net/ipv6/route.c                                   |  11 +-
 net/netfilter/nf_conntrack_netlink.c               |   5 +-
 net/netfilter/nf_tables_api.c                      |   2 +-
 net/nfc/netlink.c                                  |   4 +
 net/sched/Kconfig                                  |  11 -
 net/sched/Makefile                                 |   1 -
 net/sched/act_mpls.c                               |  66 +-
 net/sched/act_pedit.c                              | 178 +++--
 net/sched/act_sample.c                             |  11 +-
 net/sched/cls_tcindex.c                            | 756 ---------------------
 net/sctp/stream_sched_prio.c                       |  52 +-
 net/tls/tls_sw.c                                   |  26 +-
 sound/soc/codecs/Kconfig                           |   2 +-
 sound/soc/codecs/adau7118.c                        |  19 +-
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c        |   3 +
 tools/iio/iio_utils.c                              |  23 +-
 tools/objtool/check.c                              |   2 +
 145 files changed, 1268 insertions(+), 1496 deletions(-)


