Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE02929C55F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824767AbgJ0SFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757274AbgJ0ORX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:17:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE26206F7;
        Tue, 27 Oct 2020 14:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808240;
        bh=PcsFNsZwPWpeXieTHO5F9mFDWF9FdMzugPrGrtNf7OQ=;
        h=From:To:Cc:Subject:Date:From;
        b=d5ETC/RUeClQ5neeKXLmkCayty2lI3XSyLEAk5hE0WLuPneqM9An2UWkBXtxRx/59
         cdfNpYTYRgy5hu3/zQZC1xMrFRkTOTdSw9HcgOz9cdvc5VqDifetyADL4nByaghVj4
         ojTPsBNq9FSJ2TmpoS/drhowRbt/GaZ0JEIZqKBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 000/264] 4.19.153-rc1 review
Date:   Tue, 27 Oct 2020 14:50:58 +0100
Message-Id: <20201027135430.632029009@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.153-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.153-rc1
X-KernelTest-Deadline: 2020-10-29T13:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.153 release.
There are 264 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.153-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.153-rc1

Lorenzo Colitti <lorenzo@google.com>
    usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.

Christian Eggers <ceggers@arri.de>
    eeprom: at25: set minimum read/write access stride to 1

Oliver Neukum <oneukum@suse.com>
    USB: cdc-wdm: Make wdm_flush() interruptible and add wdm_fsync().

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

Peng Fan <peng.fan@nxp.com>
    tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net: korina: cast KSEG0 address to pointer in kfree

Zekun Shen <bruceshenzk@gmail.com>
    ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

Can Guo <cang@codeaurora.org>
    scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()

Eli Billauer <eli.billauer@gmail.com>
    usb: core: Solve race condition in anchor cleanup functions

Wang Yufen <wangyufen@huawei.com>
    brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mwifiex: don't call del_timer_sync() on uninitialized timer

Jan Kara <jack@suse.cz>
    reiserfs: Fix memory leak in reiserfs_parse_options()

Peilin Ye <yepeilin.cs@gmail.com>
    ipvs: Fix uninit-value in do_ip_vs_set_ctl()

Tong Zhang <ztong0001@gmail.com>
    tty: ipwireless: fix error handling

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Fix list_del corruption while removing active I/O

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Protect active command list to avoid list corruption

Doug Horn <doughorn@google.com>
    Fix use after free in get_capset_info callback.

Chris Chiu <chiu@endlessm.com>
    rtl8xxxu: prevent potential memory leak

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: ibmvfc: Fix error return in ibmvfc_probe()

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: Only mark socket zapped after unlocking

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    usb: ohci: Default to per-port over-current protection

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: make sure the rt allocator doesn't run off the end

Eric Biggers <ebiggers@google.com>
    reiserfs: only call unlock_new_inode() if I_NEW

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    misc: rtsx: Fix memory leak in rtsx_pci_probe

Brooke Basile <brookebasile@gmail.com>
    ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: flexcan_chip_stop(): add error handling and propagate error value

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    usb: dwc3: simple: add support for Hikey 970

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: handle broken union descriptors

Jan Kara <jack@suse.cz>
    udf: Avoid accessing uninitialized data on failed inode read

Jan Kara <jack@suse.cz>
    udf: Limit sparing table size

Zqiang <qiang.zhang@windriver.com>
    usb: gadget: function: printer: fix use-after-free in __lock_acquire

Sherry Sun <sherry.sun@nxp.com>
    misc: vop: add round_up(x,4) for vring_size to avoid kernel panic

Sherry Sun <sherry.sun@nxp.com>
    mic: vop: copy data to kernel space then write to io memory

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: target: core: Add CONTROL field for trace events

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: mvumi: Fix error return in mvumi_io_attach()

Christoph Hellwig <hch@lst.de>
    PM: hibernate: remove the bogus call to get_gendisk() in software_resume()

Thomas Pedersen <thomas@adapt-ip.com>
    mac80211: handle lack of sband->bitrates in rates

Cong Wang <xiyou.wangcong@gmail.com>
    ip_gre: set dev->hard_header_len and dev->needed_headroom properly

Rustam Kovhaev <rkovhaev@gmail.com>
    ntfs: add check for mft record size in superblock

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: venus: core: Fix runtime PM imbalance in venus_probe

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix configfs memory leak

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: saa7134: avoid a shift overflow

Pali Rohár <pali@kernel.org>
    mmc: sdio: Check for CISTPL_VERS_1 buffer size

Adam Goode <agoode@google.com>
    media: uvcvideo: Ensure all probed info is returned to v4l2

Xiaolong Huang <butterflyhuangxx@gmail.com>
    media: media/pci: prevent memory leak in bttv_probe

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: bdisp: Fix runtime PM imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: platform: sti: hva: Fix runtime PM imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: platform: s3c-camif: Fix runtime PM imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: vsp1: Fix runtime PM imbalance on error

Qiushi Wu <wu000273@umn.edu>
    media: exynos4-is: Fix a reference count leak

Qiushi Wu <wu000273@umn.edu>
    media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync

Qiushi Wu <wu000273@umn.edu>
    media: exynos4-is: Fix several reference count leaks due to pm_runtime_get_sync

Qiushi Wu <wu000273@umn.edu>
    media: sti: Fix reference count leaks

Aditya Pakki <pakki001@umn.edu>
    media: st-delta: Fix reference count leak in delta_run_work

Oliver Neukum <oneukum@suse.com>
    media: ati_remote: sanity check for both endpoints

Pavel Machek <pavel@ucw.cz>
    media: firewire: fix memory leak

Pavel Machek <pavel@denx.de>
    crypto: ccp - fix error handling

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    block: ratelimit handle_bad_sector() message

Hans de Goede <hdegoede@redhat.com>
    i2c: core: Restore acpi_walk_dep_device_list() getting called after registering the ACPI i2c devs

Al Grant <al.grant@foss.arm.com>
    perf: correct SNOOPX field offset

Juri Lelli <juri.lelli@redhat.com>
    sched/features: Fix !CONFIG_JUMP_LABEL case

Kaige Li <likaige@loongson.cn>
    NTB: hw: amd: fix an issue about leak system resources

zhenwei pi <pizhenwei@bytedance.com>
    nvmet: fix uninitialized work for zero kato

Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
    powerpc/powernv/dump: Fix race while processing OPAL dump

Michal Simek <michal.simek@xilinx.com>
    arm64: dts: zynqmp: Remove additional compatible string for i2c IPs

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    ARM: dts: owl-s500: Fix incorrect PPI interrupt specifiers

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Fix MDP/DSI interrupts

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: pm8916: Remove invalid reg size from wcd_codec

Krzysztof Kozlowski <krzk@kernel.org>
    memory: fsl-corenet-cf: Fix handling of platform_get_irq() error

YueHaibing <yuehaibing@huawei.com>
    memory: omap-gpmc: Fix build error without CONFIG_OF

Dan Carpenter <dan.carpenter@oracle.com>
    memory: omap-gpmc: Fix a couple off by ones

Jernej Skrabec <jernej.skrabec@siol.net>
    ARM: dts: sun8i: r40: bananapi-m2-ultra: Fix dcdc1 regulator

Horia Geantă <horia.geanta@nxp.com>
    ARM: dts: imx6sl: fix rng node

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_fwd_netdev: clear timestamp in forwarding path

Francesco Ruggeri <fruggeri@arista.com>
    netfilter: conntrack: connection timeout after re-register

Robert Hoo <robert.hu@linux.intel.com>
    KVM: x86: emulating RDPID failure shall return #UD rather than #GP

Krzysztof Kozlowski <krzk@kernel.org>
    Input: sun4i-ps2 - fix handling of platform_get_irq() error

Krzysztof Kozlowski <krzk@kernel.org>
    Input: twl4030_keypad - fix handling of platform_get_irq() error

Krzysztof Kozlowski <krzk@kernel.org>
    Input: omap4-keypad - fix handling of platform_get_irq() error

Krzysztof Kozlowski <krzk@kernel.org>
    Input: ep93xx_keypad - fix handling of platform_get_irq() error

YueHaibing <yuehaibing@huawei.com>
    Input: stmfts - fix a & vs && typo

Dan Carpenter <dan.carpenter@oracle.com>
    Input: imx6ul_tsc - clean up some errors in imx6ul_tsc_resume()

Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
    SUNRPC: fix copying of multiple pages in gss_read_proxy_verf()

Xiaoyang Xu <xuxiaoyang2@huawei.com>
    vfio iommu type1: Fix memory leak in vfio_iommu_type1_pin_pages

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Clear token on bypass registration failure

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: limit entries returned when counting fsmap records

Dan Aloni <dan@kernelim.com>
    svcrdma: fix bounce buffers for unaligned offsets and multiple pages

Guenter Roeck <linux@roeck-us.net>
    watchdog: sp5100: Fix definition of EFCH_PM_DECODEEN3

Dinghao Liu <dinghao.liu@zju.edu.cn>
    watchdog: Use put_device on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    watchdog: Fix memleak in watchdog_cdev_register

Navid Emamdoost <navid.emamdoost@gmail.com>
    clk: bcm2835: add missing release if devm_clk_hw_register fails

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: clk-main: update key before writing AT91_CKGR_MOR

Stephen Boyd <sboyd@kernel.org>
    clk: rockchip: Initialize hw to error to avoid undefined behavior

Hauke Mehrtens <hauke@hauke-m.de>
    pwm: img: Fix null pointer access in probe

Dan Carpenter <dan.carpenter@oracle.com>
    rpmsg: smd: Fix a kobj leak in in qcom_smd_parse_edge()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    PCI: iproc: Set affinity mask on MSI interrupts

Dirk Behme <dirk.behme@de.bosch.com>
    i2c: rcar: Auto select RESET_CONTROLLER

Jassi Brar <jaswinder.singh@linaro.org>
    mailbox: avoid timer start from callback

Jing Xiangfeng <jingxiangfeng@huawei.com>
    rapidio: fix the missed put_device() for rio_mport_add_riodev

Souptick Joarder <jrdr.linux@gmail.com>
    rapidio: fix error handling path

Matthew Wilcox (Oracle) <willy@infradead.org>
    ramfs: fix nommu mmap with gaps in the page cache

Tobias Jordan <kernel@cdqe.de>
    lib/crc32.c: fix trivial typo in preprocessor condition

Jamie Iles <jamie@nuviainc.com>
    f2fs: wait for sysfs kobject removal before freeing f2fs_sb_info

Colin Ian King <colin.king@canonical.com>
    IB/rdmavt: Fix sizeof mismatch

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_reboot_notifier

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf/hv-gpci: Fix starting index value

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Exclude pmc5/6 from the irrelevant PMU group constraints

Leon Romanovsky <leonro@nvidia.com>
    overflow: Include header file with SIZE_MAX declaration

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix pager search for multi-line strings

Weihang Li <liweihang@huawei.com>
    RDMA/hns: Fix missing sq_sig_type when querying QP

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Set the unsupported wr opcode

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix "context_switch event has no tid" error

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/cma: Consolidate the destruction of a cma_multicast in one place

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/cma: Remove dead code for kernel rdmacm multicast

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/radix: Fix mm_cpumask trimming race vs kthread_use_mm

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Disable TAU between measurements

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Check processor type before enabling TAU interrupt

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Remove duplicated set_thresholds() call

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Convert from timer to workqueue

Finn Thain <fthain@telegraphics.com.au>
    powerpc/tau: Use appropriate temperature sample interval

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix inline size returned for iWARP

Michal Kalderon <michal.kalderon@marvell.com>
    RDMA/qedr: Fix use of uninitialized field

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix high key handling in the rt allocator's query_range function

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: limit entries returned when counting fsmap records

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    arc: plat-hsdk: fix kconfig dependency warning when !RESET_CONTROLLER

Guillaume Tucker <guillaume.tucker@collabora.com>
    ARM: 9007/1: l2c: fix prefetch bits init in L2X0_AUX_CTRL using DT values

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    mtd: mtdoops: Don't write panic data twice

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: explicitly reschedule during drmem_lmb list traversal

Arnd Bergmann <arnd@arndb.de>
    mtd: lpddr: fix excessive stack usage with clang

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/ucma: Add missing locking around rdma_leave_multicast()

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/ucma: Fix locking for ctx->events_reported

Nicholas Mc Guire <hofrat@osadl.org>
    powerpc/icp-hv: Fix missing of_node_put() in success path

Nicholas Mc Guire <hofrat@osadl.org>
    powerpc/pseries: Fix missing of_node_put() in rng_init()

Håkon Bugge <haakon.bugge@oracle.com>
    IB/mlx4: Adjust delayed work when a dup is observed

Håkon Bugge <haakon.bugge@oracle.com>
    IB/mlx4: Fix starvation in paravirt mux/demux

Suren Baghdasaryan <surenb@google.com>
    mm, oom_adj: don't loop through tasks in __set_oom_adj when not necessary

Ralph Campbell <rcampbell@nvidia.com>
    mm/memcg: fix device private memcg accounting

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_log: missing vlan offload tag and proto

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net: korina: fix kfree of rx/tx descriptor array

Julian Anastasov <ja@ssi.bg>
    ipvs: clear skb->tstamp in forwarding path

Tom Rix <trix@redhat.com>
    mwifiex: fix double free

Vadim Pasternak <vadimp@nvidia.com>
    platform/x86: mlx-platform: Remove PSU EEPROM configuration

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()

John Donnelly <john.p.donnelly@oracle.com>
    scsi: target: tcmu: Fix warning: 'page' may be used uninitialized

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: Fix INTR OUT transfers in DDMA mode.

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix non-split wiphy information

Lorenzo Colitti <lorenzo@google.com>
    usb: gadget: u_ether: enable qmult on SuperSpeed Plus as well

Lorenzo Colitti <lorenzo@google.com>
    usb: gadget: f_ncm: fix ncm_bitrate for SuperSpeed and above.

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: split a print to avoid a WARNING in ROC

Dan Carpenter <dan.carpenter@oracle.com>
    mfd: sm501: Fix leaks in probe()

Thomas Gleixner <tglx@linutronix.de>
    net: enic: Cure the enic api locking trainwreck

Colin Ian King <colin.king@canonical.com>
    qtnfmac: fix resource leaks on unsupported iftype error return path

Vadym Kochan <vadym.kochan@plvision.eu>
    nvmem: core: fix possibly memleak when use nvmem_cell_info_to_nvmem_cell()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: fix stylus battery reporting

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: qcom-ngd-ctrl: disable ngd in qmi server down callback

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: core: do not enter to clock pause mode in core

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: core: check get_addr before removing laddr ida

Eric Dumazet <edumazet@google.com>
    quota: clear padding in v2r1_mem2diskdqb()

Nathan Chancellor <natechancellor@gmail.com>
    usb: dwc2: Fix parameter type in function pointer prototype

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Avoid mutex lock for a long-time ioctl

Souptick Joarder <jrdr.linux@gmail.com>
    misc: mic: scif: Fix error handling path

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstream_cmd()

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366rb: Support all 4096 VLANs

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Skip PVID setting if not requested

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Refactor VLAN/PVID init

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Check validity of passed VLANs

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Add missing MODULE_DEVICE_TABLE

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: use netif_tx_start|stop_all_queues() function

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Don't call timecounter cyc2time directly from 1PPS flow

Thomas Preston <thomas.preston@codethink.co.uk>
    pinctrl: mcp23s08: Fix mcp23x17 precious range

Thomas Preston <thomas.preston@codethink.co.uk>
    pinctrl: mcp23s08: Fix mcp23x17_regmap initialiser

Dan Carpenter <dan.carpenter@oracle.com>
    HID: roccat: add bounds checking in kone_sysfs_write_settings()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    video: fbdev: radeon: Fix memleak in radeonfb_pci_register

Tom Rix <trix@redhat.com>
    video: fbdev: sis: fix null ptr dereference

Colin Ian King <colin.king@canonical.com>
    video: fbdev: vga16fb: fix setting of pixclock because a pass-by-value error

Souptick Joarder <jrdr.linux@gmail.com>
    drivers/virt/fsl_hypervisor: Fix error handling path

Hans de Goede <hdegoede@redhat.com>
    pwm: lpss: Add range limit check for the base_unit register value

Hans de Goede <hdegoede@redhat.com>
    pwm: lpss: Fix off by one error in base_unit math in pwm_lpss_prepare()

Artem Savkov <asavkov@redhat.com>
    pty: do tty_flip_buffer_push without port->lock in pty_write

Tyrel Datwyler <tyreld@linux.ibm.com>
    tty: hvcs: Don't NULL tty->driver_data until hvcs_cleanup()

Tong Zhang <ztong0001@gmail.com>
    tty: serial: earlycon dependency

Alex Dewar <alex.dewar90@gmail.com>
    VMCI: check return value of get_user_pages_fast() for errors

dinghao.liu@zju.edu.cn <dinghao.liu@zju.edu.cn>
    backlight: sky81452-backlight: Fix refcount imbalance on error

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    scsi: qla2xxx: Fix wrong return value in qla_nvme_register_hba()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'

Tom Rix <trix@redhat.com>
    drm/gma500: fix error check

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: rtl8192u: Do not use GFP_KERNEL in atomic context

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mwifiex: Do not use GFP_KERNEL in atomic context

Tom Rix <trix@redhat.com>
    brcmfmac: check ndev pointer

Rohit kumar <rohitkr@codeaurora.org>
    ASoC: qcom: lpass-cpu: fix concurrency issue

Rohit kumar <rohitkr@codeaurora.org>
    ASoC: qcom: lpass-platform: fix memory leak

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ath10k: Fix the size used in a 'dma_free_coherent()' call in an error handling path

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: prevent potential array overflow in ath6kl_add_new_sta()

Samuel Holland <samuel@sholland.org>
    Bluetooth: hci_uart: Cancel init work before unregistering

Venkateswara Naralasetty <vnaralas@codeaurora.org>
    ath10k: provide survey info as accumulated data

Łukasz Stelmach <l.stelmach@samsung.com>
    spi: spi-s3c64xx: Check return values

Łukasz Stelmach <l.stelmach@samsung.com>
    spi: spi-s3c64xx: swap s3c64xx_spi_set_cs() and s3c64xx_enable_datapath()

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    pinctrl: bcm: fix kconfig dependency warning when !GPIOLIB

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: resolve supply after creating regulator

Qiushi Wu <wu000273@umn.edu>
    media: ti-vpe: Fix a missing check and reference count leak

Qiushi Wu <wu000273@umn.edu>
    media: stm32-dcmi: Fix a reference count leak

Qiushi Wu <wu000273@umn.edu>
    media: s5p-mfc: Fix a reference count leak

Qiushi Wu <wu000273@umn.edu>
    media: camss: Fix a reference count leak.

Qiushi Wu <wu000273@umn.edu>
    media: platform: fcp: Fix a reference count leak.

Qiushi Wu <wu000273@umn.edu>
    media: rockchip/rga: Fix a reference count leak.

Qiushi Wu <wu000273@umn.edu>
    media: rcar-vin: Fix a reference count leak.

Tom Rix <trix@redhat.com>
    media: tc358743: cleanup tc358743_cec_isr

Tom Rix <trix@redhat.com>
    media: tc358743: initialize variable

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: mx2_emmaprp: Fix memleak in emmaprp_probe

Xiaoliang Pang <dawning.pang@gmail.com>
    cypto: mediatek - fix leaks in mtk_desc_ring_alloc

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/max34440) Fix status register reads for MAX344{51,60,61}

Tero Kristo <t-kristo@ti.com>
    crypto: omap-sham - fix digcnt register handling with export/import

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: omap3isp: Fix memleak in isp_probe

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Silence shift-out-of-bounds warning

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Set media controller entity functions

Tom Rix <trix@redhat.com>
    media: m5mols: Check function pointer in m5mols_sensor_power

Sylwester Nawrocki <s.nawrocki@samsung.com>
    media: Revert "media: exynos4-is: Add missed check for pinctrl_lookup_state()"

Tom Rix <trix@redhat.com>
    media: tuner-simple: fix regression in simple_set_radio_freq

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    crypto: picoxcell - Fix potential race condition bug

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: ixp4xx - Fix the size used in a 'dma_free_coherent()' call

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_skcipher - EBUSY on aio should be an error

Colin Ian King <colin.king@canonical.com>
    x86/events/amd/iommu: Fix sizeof mismatch

Libing Zhou <libing.zhou@nokia-sbell.com>
    x86/nmi: Fix nmi_handle() duration miscalculation

Mark Salter <msalter@redhat.com>
    drivers/perf: xgene_pmu: Fix uninitialized resource struct

Arvind Sankar <nivedita@alum.mit.edu>
    x86/fpu: Allow multiple bits in clearcpuid= parameter

Krzysztof Kozlowski <krzk@kernel.org>
    EDAC/ti: Fix handling of platform_get_irq() error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    EDAC/i5100: Fix error handling order in i5100_init_one()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_aead - Do not set MAY_BACKLOG on the async path

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Don't ignore errors from crypto_shash_update()

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    KVM: SVM: Initialize prev_ga_tag before use

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Commit zap of remaining invalid pages when recovering lpages

Shyam Prasad N <sprasad@microsoft.com>
    cifs: Return the error from crypt_message when enc/dec key not found.

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: remove bogus debug code

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable audio jacks of ASUS D700SA with ALC887

Eric Dumazet <edumazet@google.com>
    icmp: randomize the global rate limiter

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix operation under forced interrupt threading

Neal Cardwell <ncardwell@google.com>
    tcp: fix to update snd_wl1 in bulk receiver fast path

Defang Bo <bodefang@126.com>
    nfc: Ensure presence of NFC_ATTR_FIRMWARE_NAME attribute in nfc_genl_fw_download()

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_tunnel_key: fix OOB write in case of IPv6 ERSPAN tunnels

Xie He <xie.he.0141@gmail.com>
    net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling ether_setup

Xie He <xie.he.0141@gmail.com>
    net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: correct function return and return type

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: correct netdevice for vlan interface

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix socket lock

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: bebob: potential info leak in hwdep_read()

Todd Kjos <tkjos@google.com>
    binder: fix UAF when releasing todo list

Rohit Maheshwari <rohitm@chelsio.com>
    net/tls: sendfile fails with ktls offload

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix data corruption issue on RTL8402

Maciej Żenczykowski <maze@google.com>
    net/ipv4: always honour route mtu during forwarding

Cong Wang <xiyou.wangcong@gmail.com>
    tipc: fix the skb_unshare() in tipc_buf_append()

Wilken Gottwalt <wilken.gottwalt@mailbox.org>
    net: usb: qmi_wwan: add Cellient MPL200 card

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: fix valid DMBE buffer sizes

Yonghong Song <yhs@fb.com>
    net: fix pos incrementment in ipv6_route_seq_next

Marek Vasut <marex@denx.de>
    net: fec: Fix PHY init after phy_reset_after_clk_enable()

Marek Vasut <marex@denx.de>
    net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()

Jonathan Lemon <bsd@fb.com>
    mlx4: handle non-napi callers to napi_poll

David Ahern <dsahern@kernel.org>
    ipv4: Restore flowi4_oif update before call to xfrm_lookup_route

David Wilder <dwilder@us.ibm.com>
    ibmveth: Identify ingress large send packets.

David Wilder <dwilder@us.ibm.com>
    ibmveth: Switch order of ibmveth_helper calls.


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +-
 Documentation/networking/ip-sysctl.txt             |   4 +-
 Makefile                                           |   4 +-
 arch/arc/plat-hsdk/Kconfig                         |   1 +
 arch/arm/boot/dts/imx6sl.dtsi                      |   2 +
 arch/arm/boot/dts/owl-s500.dtsi                    |   6 +-
 arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts  |  10 +-
 arch/arm/mm/cache-l2x0.c                           |  16 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   4 +-
 arch/arm64/boot/dts/qcom/pm8916.dtsi               |   2 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +-
 arch/powerpc/include/asm/drmem.h                   |  18 +-
 arch/powerpc/include/asm/reg.h                     |   2 +-
 arch/powerpc/include/asm/tlb.h                     |  13 -
 arch/powerpc/kernel/tau_6xx.c                      | 147 +++++------
 arch/powerpc/mm/tlb-radix.c                        |  23 +-
 arch/powerpc/perf/hv-gpci-requests.h               |   6 +-
 arch/powerpc/perf/isa207-common.c                  |  10 +
 arch/powerpc/platforms/Kconfig                     |  14 +-
 arch/powerpc/platforms/powernv/opal-dump.c         |  41 ++-
 arch/powerpc/platforms/pseries/rng.c               |   1 +
 arch/powerpc/sysdev/xics/icp-hv.c                  |   1 +
 arch/x86/events/amd/iommu.c                        |   2 +-
 arch/x86/kernel/fpu/init.c                         |  30 ++-
 arch/x86/kernel/nmi.c                              |   5 +-
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/kvm/mmu.c                                 |   1 +
 arch/x86/kvm/svm.c                                 |   1 +
 block/blk-core.c                                   |   9 +-
 crypto/algif_aead.c                                |   7 +-
 crypto/algif_skcipher.c                            |   2 +-
 drivers/android/binder.c                           |  35 +--
 drivers/bluetooth/hci_ldisc.c                      |   1 +
 drivers/bluetooth/hci_serdev.c                     |   2 +
 drivers/clk/at91/clk-main.c                        |  11 +-
 drivers/clk/bcm/clk-bcm2835.c                      |   4 +-
 drivers/clk/rockchip/clk-half-divider.c            |   2 +-
 drivers/cpufreq/armada-37xx-cpufreq.c              |   6 +
 drivers/cpufreq/powernv-cpufreq.c                  |   9 +-
 drivers/crypto/ccp/ccp-ops.c                       |   2 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |   3 +
 drivers/crypto/chelsio/chtls/chtls_io.c            |   5 +-
 drivers/crypto/ixp4xx_crypto.c                     |   2 +-
 drivers/crypto/mediatek/mtk-platform.c             |   8 +-
 drivers/crypto/omap-sham.c                         |   3 +
 drivers/crypto/picoxcell_crypto.c                  |   9 +-
 drivers/edac/i5100_edac.c                          |  11 +-
 drivers/edac/ti_edac.c                             |   3 +-
 drivers/gpu/drm/gma500/cdv_intel_dp.c              |   2 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c               |   2 +
 drivers/gpu/drm/virtio/virtgpu_vq.c                |  10 +-
 drivers/hid/hid-input.c                            |   4 +-
 drivers/hid/hid-roccat-kone.c                      |  23 +-
 drivers/hwmon/pmbus/max34440.c                     |   3 -
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/i2c-core-acpi.c                        |  11 +-
 drivers/infiniband/core/cma.c                      |  84 +++----
 drivers/infiniband/core/ucma.c                     |   6 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   1 +
 drivers/infiniband/hw/mlx4/cm.c                    |   3 +
 drivers/infiniband/hw/mlx4/mad.c                   |  34 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   2 +
 drivers/infiniband/hw/qedr/main.c                  |   2 +-
 drivers/infiniband/hw/qedr/verbs.c                 |   2 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |   4 +-
 drivers/input/keyboard/ep93xx_keypad.c             |   4 +-
 drivers/input/keyboard/omap4-keypad.c              |   6 +-
 drivers/input/keyboard/twl4030_keypad.c            |   8 +-
 drivers/input/serio/sun4i-ps2.c                    |   9 +-
 drivers/input/touchscreen/imx6ul_tsc.c             |  27 +-
 drivers/input/touchscreen/stmfts.c                 |   2 +-
 drivers/mailbox/mailbox.c                          |  12 +-
 drivers/media/firewire/firedtv-fw.c                |   6 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   3 +-
 drivers/media/i2c/tc358743.c                       |  14 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |  13 +-
 drivers/media/pci/saa7134/saa7134-tvaudio.c        |   3 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   8 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   4 +-
 drivers/media/platform/mx2_emmaprp.c               |   7 +-
 drivers/media/platform/omap3isp/isp.c              |   6 +-
 drivers/media/platform/qcom/camss/camss-csiphy.c   |   4 +-
 drivers/media/platform/qcom/venus/core.c           |   5 +-
 drivers/media/platform/rcar-fcp.c                  |   4 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |   4 +-
 drivers/media/platform/rockchip/rga/rga-buf.c      |   1 +
 drivers/media/platform/s3c-camif/camif-core.c      |   5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |   4 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   3 +-
 drivers/media/platform/sti/delta/delta-v4l2.c      |   4 +-
 drivers/media/platform/sti/hva/hva-hw.c            |   4 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |   4 +-
 drivers/media/platform/ti-vpe/vpe.c                |   2 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  11 +-
 drivers/media/rc/ati_remote.c                      |   4 +
 drivers/media/tuners/tuner-simple.c                |   5 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   6 +-
 drivers/media/usb/uvc/uvc_entity.c                 |  35 +++
 drivers/media/usb/uvc/uvc_v4l2.c                   |  30 +++
 drivers/memory/fsl-corenet-cf.c                    |   6 +-
 drivers/memory/omap-gpmc.c                         |   8 +-
 drivers/mfd/sm501.c                                |   8 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   4 +-
 drivers/misc/eeprom/at25.c                         |   2 +-
 drivers/misc/mic/scif/scif_rma.c                   |   4 +-
 drivers/misc/mic/vop/vop_main.c                    |   2 +-
 drivers/misc/mic/vop/vop_vringh.c                  |  24 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |  10 +-
 drivers/mmc/core/sdio_cis.c                        |   3 +
 drivers/mtd/lpddr/lpddr2_nvm.c                     |  35 +--
 drivers/mtd/mtdoops.c                              |  11 +-
 drivers/net/can/flexcan.c                          |  34 ++-
 drivers/net/dsa/realtek-smi.h                      |   4 +-
 drivers/net/dsa/rtl8366.c                          | 280 +++++++++++----------
 drivers/net/dsa/rtl8366rb.c                        |   2 +-
 drivers/net/ethernet/cisco/enic/enic.h             |   1 +
 drivers/net/ethernet/cisco/enic/enic_api.c         |   6 +
 drivers/net/ethernet/cisco/enic/enic_main.c        |  27 +-
 drivers/net/ethernet/freescale/fec_main.c          |  35 ++-
 drivers/net/ethernet/ibm/ibmveth.c                 |  19 +-
 drivers/net/ethernet/korina.c                      |   3 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   5 +-
 drivers/net/ethernet/realtek/r8169.c               |  54 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  33 +--
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wan/hdlc.c                             |  10 +-
 drivers/net/wan/hdlc_raw_eth.c                     |   1 +
 drivers/net/wireless/ath/ath10k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   8 +
 drivers/net/wireless/ath/ath10k/mac.c              |   2 +-
 drivers/net/wireless/ath/ath6kl/main.c             |   3 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   5 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  19 ++
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   2 +
 drivers/net/wireless/ath/wcn36xx/main.c            |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   2 +
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   9 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +
 drivers/net/wireless/marvell/mwifiex/usb.c         |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  10 +-
 drivers/ntb/hw/amd/ntb_hw_amd.c                    |   1 +
 drivers/nvme/target/core.c                         |   3 +-
 drivers/nvmem/core.c                               |  29 ++-
 drivers/pci/controller/pcie-iproc-msi.c            |  13 +-
 drivers/perf/xgene_pmu.c                           |  32 +--
 drivers/pinctrl/bcm/Kconfig                        |   1 +
 drivers/pinctrl/pinctrl-mcp23s08.c                 |  24 +-
 drivers/platform/x86/mlx-platform.c                |  15 +-
 drivers/pwm/pwm-img.c                              |   3 +-
 drivers/pwm/pwm-lpss.c                             |   7 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  18 +-
 drivers/regulator/core.c                           |  21 +-
 drivers/rpmsg/qcom_smd.c                           |  32 ++-
 drivers/scsi/be2iscsi/be_main.c                    |   4 +-
 drivers/scsi/csiostor/csio_hw.c                    |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   1 +
 drivers/scsi/mvumi.c                               |   1 +
 drivers/scsi/qedi/qedi_fw.c                        |  23 +-
 drivers/scsi/qedi/qedi_iscsi.c                     |   2 +
 drivers/scsi/qla2xxx/qla_nvme.c                    |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +-
 drivers/scsi/ufs/ufs-qcom.c                        |   5 -
 drivers/slimbus/core.c                             |   6 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |   4 +
 drivers/spi/spi-s3c64xx.c                          |  52 +++-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   2 +-
 drivers/target/target_core_user.c                  |   2 +-
 drivers/tty/hvc/hvcs.c                             |  14 +-
 drivers/tty/ipwireless/network.c                   |   4 +-
 drivers/tty/ipwireless/tty.c                       |   2 +-
 drivers/tty/pty.c                                  |   2 +-
 drivers/tty/serial/Kconfig                         |   1 +
 drivers/tty/serial/fsl_lpuart.c                    |   2 +-
 drivers/usb/class/cdc-acm.c                        |  23 ++
 drivers/usb/class/cdc-wdm.c                        |  72 ++++--
 drivers/usb/core/urb.c                             |  89 ++++---
 drivers/usb/dwc2/gadget.c                          |  40 ++-
 drivers/usb/dwc2/params.c                          |   2 +-
 drivers/usb/dwc3/dwc3-of-simple.c                  |   1 +
 drivers/usb/gadget/function/f_ncm.c                |   8 +-
 drivers/usb/gadget/function/f_printer.c            |  16 +-
 drivers/usb/gadget/function/u_ether.c              |   2 +-
 drivers/usb/host/ohci-hcd.c                        |  16 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   4 +-
 drivers/vfio/vfio_iommu_type1.c                    |   3 +-
 drivers/video/backlight/sky81452-backlight.c       |   1 +
 drivers/video/fbdev/aty/radeon_base.c              |   2 +-
 drivers/video/fbdev/sis/init.c                     |  11 +-
 drivers/video/fbdev/vga16fb.c                      |  14 +-
 drivers/virt/fsl_hypervisor.c                      |  17 +-
 drivers/watchdog/sp5100_tco.h                      |   2 +-
 drivers/watchdog/watchdog_dev.c                    |   6 +-
 fs/cifs/asn1.c                                     |  16 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/dlm/config.c                                    |   3 +
 fs/ext4/fsmap.c                                    |   3 +
 fs/f2fs/sysfs.c                                    |   1 +
 fs/ntfs/inode.c                                    |   6 +
 fs/proc/base.c                                     |   3 +-
 fs/quota/quota_v2.c                                |   1 +
 fs/ramfs/file-nommu.c                              |   2 +-
 fs/reiserfs/inode.c                                |   3 +-
 fs/reiserfs/super.c                                |   8 +-
 fs/udf/inode.c                                     |  25 +-
 fs/udf/super.c                                     |   6 +
 fs/xfs/libxfs/xfs_rtbitmap.c                       |  11 +-
 fs/xfs/xfs_fsmap.c                                 |   3 +
 fs/xfs/xfs_rtalloc.c                               |  11 +
 include/linux/oom.h                                |   1 +
 include/linux/overflow.h                           |   1 +
 include/linux/sched/coredump.h                     |   1 +
 include/net/ip.h                                   |   6 +
 include/net/netfilter/nf_log.h                     |   1 +
 include/scsi/scsi_common.h                         |   7 +
 include/trace/events/target.h                      |  12 +-
 include/uapi/linux/perf_event.h                    |   2 +-
 kernel/debug/kdb/kdb_io.c                          |   8 +-
 kernel/fork.c                                      |  21 ++
 kernel/power/hibernate.c                           |  11 -
 kernel/sched/core.c                                |   2 +-
 kernel/sched/sched.h                               |  13 +-
 lib/crc32.c                                        |   2 +-
 mm/memcontrol.c                                    |   5 +-
 mm/oom_kill.c                                      |   2 +
 net/bluetooth/l2cap_sock.c                         |   7 +-
 net/ipv4/icmp.c                                    |   7 +-
 net/ipv4/ip_gre.c                                  |  15 +-
 net/ipv4/netfilter/nf_log_arp.c                    |  19 +-
 net/ipv4/netfilter/nf_log_ipv4.c                   |   6 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/ipv6/ip6_fib.c                                 |   4 +-
 net/ipv6/netfilter/nf_log_ipv6.c                   |   8 +-
 net/mac80211/cfg.c                                 |   3 +-
 net/mac80211/sta_info.c                            |   4 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   7 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   6 +
 net/netfilter/nf_conntrack_proto_tcp.c             |  19 +-
 net/netfilter/nf_dup_netdev.c                      |   1 +
 net/netfilter/nf_log_common.c                      |  12 +
 net/netfilter/nft_fwd_netdev.c                     |   1 +
 net/nfc/netlink.c                                  |   2 +-
 net/sched/act_tunnel_key.c                         |   2 +-
 net/smc/smc_core.c                                 |   2 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  27 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |   3 +-
 net/tipc/msg.c                                     |   3 +-
 net/tls/tls_device.c                               |  11 +-
 net/wireless/nl80211.c                             |   5 +-
 samples/mic/mpssd/mpssd.c                          |   4 +-
 security/integrity/ima/ima_crypto.c                |   2 +
 sound/core/seq/oss/seq_oss.c                       |   7 +-
 sound/firewire/bebob/bebob_hwdep.c                 |   3 +-
 sound/pci/hda/patch_realtek.c                      |  42 ++++
 sound/soc/qcom/lpass-cpu.c                         |  16 --
 sound/soc/qcom/lpass-platform.c                    |   3 +-
 tools/perf/util/intel-pt.c                         |   8 +-
 266 files changed, 1797 insertions(+), 1018 deletions(-)


