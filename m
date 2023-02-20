Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0641369CCE7
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjBTNoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjBTNoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:44:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78A51D919;
        Mon, 20 Feb 2023 05:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58911B80B96;
        Mon, 20 Feb 2023 13:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7171FC433EF;
        Mon, 20 Feb 2023 13:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900645;
        bh=e2ddb2vLO6eG9RI0FSaNcK7u83eFlDbbkBEYfDQeoAE=;
        h=From:To:Cc:Subject:Date:From;
        b=hwamO6oDZYmgT8BqSadomEZj4AZ8yngOuj9Th2QnUs/OVhvp/JIV95x4moaz6l3m/
         Yhel0BGaCxfvzzaYVNo0hlK3rupvWVTnJiXiv6cde7b3jeOOgDUsNjm+vj0SkIh4xO
         KboWBpyAOsmZSOGmBlMiEFpTy7IC5EnN7pcUpIXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 000/156] 5.4.232-rc1 review
Date:   Mon, 20 Feb 2023 14:34:04 +0100
Message-Id: <20230220133602.515342638@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.232-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.232-rc1
X-KernelTest-Deadline: 2023-02-22T13:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.232 release.
There are 156 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.232-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.232-rc1

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Pass gfp flags to iommu_map_page() in amd_iommu_map()

Dan Carpenter <error27@gmail.com>
    net: sched: sch: Fix off by one in htb_activate_prios()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: fix possible stream_tag leak

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix underflow in second superblock position calculations

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kvm: initialize all of the kvm_debugregs structure before sending it to userspace

Natalia Petrova <n.petrova@fintech.ru>
    i40e: Add checking for null for nlmsg_find_attr()

Guillaume Nault <gnault@redhat.com>
    ipv6: Fix tcp socket connection with DSCP.

Guillaume Nault <gnault@redhat.com>
    ipv6: Fix datagram socket connection with DSCP.

Jason Xing <kernelxing@tencent.com>
    ixgbe: add double of VLAN header when computing the max MTU

Jakub Kicinski <kuba@kernel.org>
    net: mpls: fix stale pointer if allocation fails during device rename

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    net: stmmac: Restrict warning on disabling DMA store and fwd mode

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix mqprio and XDP ring checking logic

Johannes Zink <j.zink@pengutronix.de>
    net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence

Miko Larsson <mikoxyzzz@gmail.com>
    net/usb: kalmia: Don't pass act_len in usb_bulk_msg error path

Kuniyuki Iwashima <kuniyu@amazon.com>
    dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.

Pietro Borrello <borrello@diag.uniroma1.it>
    sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list

Rafał Miłecki <rafal@milecki.pl>
    net: bgmac: fix BCM5358 support by setting correct flags

Jason Xing <kernelxing@tencent.com>
    i40e: add double of VLAN header when computing the max MTU

Jason Xing <kernelxing@tencent.com>
    ixgbe: allow to increase MTU to 3K with XDP enabled

Andrew Morton <akpm@linux-foundation.org>
    revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"

Felix Riemann <felix.riemann@sma.de>
    net: Fix unwanted sign extension in netdev_stats_to_stats64()

Aaron Thompson <dev@aaront.org>
    Revert "mm: Always release pages to the buddy allocator in memblock_free_late()."

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: check for undefined shift on 32 bit architectures

Munehisa Kamata <kamatam@amazon.com>
    sched/psi: Fix use-after-free in ep_remove_wait_queue()

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - fixed wrong gpio assigned

Bo Liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: add a new hda codec SN6180

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mmc_spi: fix error handling in mmc_spi_probe()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: sdio: fix possible resource leaks in some error paths

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect route flushing when source address is deleted

Shaoying Xu <shaoyi@amazon.com>
    Revert "ipv4: Fix incorrect route flushing when source address is deleted"

Brian Foster <bfoster@redhat.com>
    xfs: sync lazy sb accounting on quiesce of read-only mounts

Darrick J. Wong <djwong@kernel.org>
    xfs: prevent UAF in xfs_log_item_in_current_chkpt

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: ensure inobt record walks always make forward progress

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix missing CoW blocks writeback conversion retry

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: only relog deferred intent items if free space in the log gets low

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: expose the log push threshold

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: periodically relog deferred intent items

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: change the order in which child and parent defer ops are finished

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix an incore inode UAF in xfs_bui_recover

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: clean up bmap intent item recovery checking

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: xfs_defer_capture should absorb remaining transaction reservation

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: xfs_defer_capture should absorb remaining block reservations

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: proper replay of deferred ops queued during log recovery

Dave Chinner <dchinner@redhat.com>
    xfs: fix finobt btree block recovery ordering

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: log new intent items created as part of finishing recovered intent items

Christoph Hellwig <hch@lst.de>
    xfs: refactor xfs_defer_finish_noroll

Christoph Hellwig <hch@lst.de>
    xfs: turn dfp_intent into a xfs_log_item

Christoph Hellwig <hch@lst.de>
    xfs: merge the ->diff_items defer op into ->create_intent

Christoph Hellwig <hch@lst.de>
    xfs: merge the ->log_item defer op into ->create_intent

Christoph Hellwig <hch@lst.de>
    xfs: factor out a xfs_defer_create_intent helper

Christoph Hellwig <hch@lst.de>
    xfs: remove the xfs_inode_log_item_t typedef

Christoph Hellwig <hch@lst.de>
    xfs: remove the xfs_efd_log_item_t typedef

Christoph Hellwig <hch@lst.de>
    xfs: remove the xfs_efi_log_item_t typedef

Florian Westphal <fw@strlen.de>
    netfilter: nft_tproxy: restrict to prerouting hook

Anand Jain <anand.jain@oracle.com>
    btrfs: free device in btrfs_close_devices for a single device filesystem

Seth Jenkins <sethjenkins@google.com>
    aio: fix mremap after fork null-deref

Amit Engel <Amit.Engel@dell.com>
    nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association

Vasily Gorbik <gor@linux.ibm.com>
    s390/decompressor: specify __decompress() buf len to avoid overflow

Kees Cook <keescook@chromium.org>
    net: sched: sch: Bounds check priority

Andrey Konovalov <andrey.konovalov@linaro.org>
    net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC

Hyunwoo Kim <v4bel@theori.io>
    net/rose: Fix to not accept on connected socket

Shunsuke Mie <mie@igel.co.jp>
    tools/virtio: fix the vringh test for virtio ring changes

Arnd Bergmann <arnd@arndb.de>
    ASoC: cs42l56: fix DT probe

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Verify copy_register_state() preserves parent/live fields

Mike Kravetz <mike.kravetz@oracle.com>
    migrate: hugetlb: check for hugetlb shared PMD in node migration

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Always return target ifindex in bpf_fib_lookup

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    nvme-pci: Move enumeration by class to be last in the table

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-axg: Make mmc host controller interrupts level-sensitive

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-g12-common: Make mmc host controller interrupts level-sensitive

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive

Guo Ren <guoren@linux.alibaba.com>
    riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte

Xiubo Li <xiubli@redhat.com>
    ceph: flush cap releases when the session is flushed

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Fix probe pin assign check

Mark Pearson <mpearson-lenovo@squebb.ca>
    usb: core: add quirk for Alcor Link AK9563 smartcard reader

Alan Stern <stern@rowland.harvard.edu>
    net: USB: Fix wrong-direction WARNING in plusb.c

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Restore the pins that used to be in Direct IRQ mode

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    pinctrl: single: fix potential NULL dereference

Joel Stanley <joel@jms.id.au>
    pinctrl: aspeed: Fix confusing types in return value

Dan Carpenter <error27@gmail.com>
    ALSA: pci: lx6464es: fix a debug loop

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: lib: quote the sysctl values

Pietro Borrello <borrello@diag.uniroma1.it>
    rds: rds_rm_zerocopy_callback() use list_first_entry()

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Neel Patel <neel.patel@amd.com>
    ionic: clean interrupt before enabling queue to avoid credit race

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY

Qi Zheng <zhengqi.arch@bytedance.com>
    bonding: fix error checking in bond_debug_reregister()

Christian Hopps <chopps@chopps.org>
    xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Yang Yingliang <yangyingliang@huawei.com>
    RDMA/usnic: use iommu_map_atomic() under spin_lock()

Tom Murphy <murphyt7@tcd.ie>
    iommu: Add gfp parameter to iommu_ops::map

Dragos Tatulea <dtatulea@nvidia.com>
    IB/IPoIB: Fix legacy IPoIB due to wrong number of queues

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Restore allocated resources on failed copyout

Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
    can: j1939: do not wait 250 ms if the same addr was already claimed

Shiju Jose <shiju.jose@huawei.com>
    tracing: Fix poll() and select() do not work on per_cpu trace_pipe and trace_pipe_raw

Artemii Karasev <karasev@ispras.ru>
    ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()

Alexander Potapenko <glider@google.com>
    btrfs: zlib: zero-initialize zlib workspace

Josef Bacik <josef@toxicpanda.com>
    btrfs: limit device extents to the device size

Andreas Kemnade <andreas@kemnade.info>
    iio:adc:twl6030: Enable measurement of VAC

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: brcmfmac: Check the count value of channel spec to prevent out-of-bounds reads

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on i_extra_isize in is_alive()

Dongliang Mu <dzm91@hust.edu.cn>
    fbdev: smscufx: fix error handling code in ufx_usb_probe

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/imc-pmu: Revert nest_init_lock to being a mutex

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx rearm race

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx completion race

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()

Andrea Righi <andrea.righi@canonical.com>
    mm: swap: properly update readahead statistics in unuse_pte_range()

Michael Walle <michael@walle.cc>
    nvmem: core: fix cell removal on error

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix handling and sanity checking of xattr_ids count

Longlong Xia <xialonglong1@huawei.com>
    mm/swapfile: add cond_resched() in get_swap_pages()

Zheng Yongjun <zhengyongjun3@huawei.com>
    fpga: stratix10-soc: Fix return value check in s10_ops_write_init()

Mike Kravetz <mike.kravetz@oracle.com>
    mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps

Andreas Schwab <schwab@suse.de>
    riscv: disable generation of unwind tables

Helge Deller <deller@gmx.de>
    parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case

Helge Deller <deller@gmx.de>
    parisc: Fix return code of pdc_iodc_print()

Andreas Kemnade <andreas@kemnade.info>
    iio:adc:twl6030: Enable measurements of VUSB, VBAT and others

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iio: adc: berlin2-adc: Add missing of_node_put() in error path

Dmitry Perchanov <dmitry.perchanov@intel.com>
    iio: hid: fix the retval in accel_3d_capture_sample

Ard Biesheuvel <ardb@kernel.org>
    efi: Accept version 2 of memory attributes table

Alexander Egorenkov <egorenar@linux.ibm.com>
    watchdog: diag288_wdt: fix __diag288() inline assembly

Alexander Egorenkov <egorenar@linux.ibm.com>
    watchdog: diag288_wdt: do not use stack buffers for hardware data

Samuel Thibault <samuel.thibault@ens-lyon.org>
    fbcon: Check font dimension limits

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add Clevo PCX0DX to i8042 quirk table

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add TUXEDO devices to i8042 quirk tables

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - merge quirk tables

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - move __initconst to fix code styling warning

George Kennedy <george.kennedy@oracle.com>
    vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait

Neil Armstrong <neil.armstrong@linaro.org>
    usb: dwc3: qcom: enable vbus override when in OTG dr-mode

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: dwc3-qcom: Fix typo in the dwc3 vbus override API

Olivier Moysan <olivier.moysan@foss.st.com>
    iio: adc: stm32-dfsdm: fill module aliases

Hyunwoo Kim <v4bel@theori.io>
    net/x25: Fix to not accept on connected socket

Randy Dunlap <rdunlap@infradead.org>
    i2c: rk3x: fix a bunch of kernel-doc warnings

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Fix warning on RT kernels

Anton Gusev <aagusev@ispras.ru>
    efi: fix potential NULL deref in efi_mem_reserve_persistent

Fedor Pchelkin <pchelkin@ispras.ru>
    net: openvswitch: fix flow memory leak in ovs_flow_cmd_new

Parav Pandit <parav@nvidia.com>
    virtio-net: Keep stop() to follow mirror sequence of open()

Andrei Gherzan <andrei.gherzan@canonical.com>
    selftests: net: udpgso_bench_tx: Cater for pending datagrams zerocopy benchmarking

Andrei Gherzan <andrei.gherzan@canonical.com>
    selftests: net: udpgso_bench: Fix racing bug between the rx/tx programs

Andrei Gherzan <andrei.gherzan@canonical.com>
    selftests: net: udpgso_bench_rx/tx: Stop when wrong CLI args are provided

Andrei Gherzan <andrei.gherzan@canonical.com>
    selftests: net: udpgso_bench_rx: Fix 'used uninitialized' compiler warning

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata: Fix sata_down_spd_limit() when no link speed is reported

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

Chris Healy <healych@amazon.com>
    net: phy: meson-gxl: Add generic dummy stubs for MMD register access

Fedor Pchelkin <pchelkin@ispras.ru>
    squashfs: harden sanity check in squashfs_read_xattr_id_table

Florian Westphal <fw@strlen.de>
    netfilter: br_netfilter: disable sabotage_in hook after first suppression

Hyunwoo Kim <v4bel@theori.io>
    netrom: Fix use-after-free caused by accept on already connected socket

Al Viro <viro@zeniv.linux.org.uk>
    fix "direction" argument of iov_iter_kvec()

Al Viro <viro@zeniv.linux.org.uk>
    fix iov_iter_bvec() "direction" argument

Al Viro <viro@zeniv.linux.org.uk>
    WRITE is "data source", not destination...

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: Revert "scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT"

Pierluigi Passaro <pierluigi.p@variscite.com>
    arm64: dts: imx8mm: Fix pad control for UART1_DTE_RX

Artemii Karasev <karasev@ispras.ru>
    ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: bytcr_rt5651: Drop reference count of ACPI device after use

Yuan Can <yuancan@huawei.com>
    bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region


-------------

Diffstat:

 Makefile                                           |    4 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |    4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |    6 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |    6 +-
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h     |    2 +-
 arch/parisc/kernel/firmware.c                      |    5 +-
 arch/parisc/kernel/ptrace.c                        |   15 +-
 arch/powerpc/perf/imc-pmu.c                        |   14 +-
 arch/riscv/Makefile                                |    3 +
 arch/riscv/mm/cacheflush.c                         |    4 +-
 arch/s390/boot/compressed/decompressor.c           |    2 +-
 arch/x86/kvm/x86.c                                 |    3 +-
 drivers/ata/libata-core.c                          |    2 +-
 drivers/bus/sunxi-rsb.c                            |    8 +-
 drivers/firewire/core-cdev.c                       |    4 +-
 drivers/firmware/efi/efi.c                         |    2 +
 drivers/firmware/efi/memattr.c                     |    2 +-
 drivers/fpga/stratix10-soc.c                       |    4 +-
 drivers/fsi/fsi-sbefifo.c                          |    6 +-
 drivers/i2c/busses/i2c-rk3x.c                      |   44 +-
 drivers/iio/accel/hid-sensor-accel-3d.c            |    1 +
 drivers/iio/adc/berlin2-adc.c                      |    4 +-
 drivers/iio/adc/stm32-dfsdm-adc.c                  |    1 +
 drivers/iio/adc/twl6030-gpadc.c                    |   32 +
 drivers/infiniband/hw/hfi1/file_ops.c              |    7 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    8 +
 drivers/input/serio/i8042-x86ia64io.h              | 1188 ++++++++------
 drivers/iommu/amd_iommu.c                          |    5 +-
 drivers/iommu/arm-smmu-v3.c                        |    2 +-
 drivers/iommu/arm-smmu.c                           |    2 +-
 drivers/iommu/dma-iommu.c                          |    6 +-
 drivers/iommu/exynos-iommu.c                       |    2 +-
 drivers/iommu/intel-iommu.c                        |    2 +-
 drivers/iommu/iommu.c                              |   43 +-
 drivers/iommu/ipmmu-vmsa.c                         |    2 +-
 drivers/iommu/msm_iommu.c                          |    2 +-
 drivers/iommu/mtk_iommu.c                          |    2 +-
 drivers/iommu/mtk_iommu_v1.c                       |    2 +-
 drivers/iommu/omap-iommu.c                         |    2 +-
 drivers/iommu/qcom_iommu.c                         |    2 +-
 drivers/iommu/rockchip-iommu.c                     |    2 +-
 drivers/iommu/s390-iommu.c                         |    2 +-
 drivers/iommu/tegra-gart.c                         |    2 +-
 drivers/iommu/tegra-smmu.c                         |    2 +-
 drivers/iommu/virtio-iommu.c                       |    2 +-
 drivers/mmc/core/sdio_bus.c                        |   17 +-
 drivers/mmc/core/sdio_cis.c                        |   12 -
 drivers/mmc/host/mmc_spi.c                         |    8 +-
 drivers/net/bonding/bond_debugfs.c                 |    2 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |    6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    4 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   28 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   15 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |    2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |    3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    2 +-
 drivers/net/phy/meson-gxl.c                        |    4 +
 drivers/net/usb/kalmia.c                           |    8 +-
 drivers/net/usb/plusb.c                            |    4 +-
 drivers/net/virtio_net.c                           |    2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   17 +
 drivers/nvme/host/pci.c                            |    3 +-
 drivers/nvme/target/fc.c                           |    4 +-
 drivers/nvmem/core.c                               |    3 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |    2 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |   16 +-
 drivers/pinctrl/pinctrl-single.c                   |    2 +
 drivers/scsi/iscsi_tcp.c                           |    9 +-
 drivers/scsi/scsi_scan.c                           |    7 +-
 drivers/target/target_core_file.c                  |    4 +-
 drivers/target/target_core_tmr.c                   |    4 +-
 drivers/tty/serial/8250/8250_dma.c                 |   26 +-
 drivers/tty/vt/vc_screen.c                         |    9 +-
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/dwc3/dwc3-qcom.c                       |   10 +-
 drivers/usb/gadget/function/f_fs.c                 |    4 +-
 drivers/usb/typec/altmodes/displayport.c           |    8 +-
 drivers/video/fbdev/core/fbcon.c                   |    7 +-
 drivers/video/fbdev/smscufx.c                      |   46 +-
 drivers/watchdog/diag288_wdt.c                     |   15 +-
 drivers/xen/pvcalls-back.c                         |    8 +-
 fs/aio.c                                           |    4 +
 fs/btrfs/volumes.c                                 |   18 +-
 fs/btrfs/zlib.c                                    |    2 +-
 fs/ceph/mds_client.c                               |    6 +
 fs/f2fs/gc.c                                       |   18 +-
 fs/nilfs2/ioctl.c                                  |    7 +
 fs/nilfs2/super.c                                  |    9 +
 fs/nilfs2/the_nilfs.c                              |    8 +-
 fs/proc/task_mmu.c                                 |    4 +-
 fs/squashfs/squashfs_fs.h                          |    2 +-
 fs/squashfs/squashfs_fs_sb.h                       |    2 +-
 fs/squashfs/xattr.h                                |    4 +-
 fs/squashfs/xattr_id.c                             |    2 +-
 fs/xfs/libxfs/xfs_defer.c                          |  358 +++-
 fs/xfs/libxfs/xfs_defer.h                          |   49 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |    2 +-
 fs/xfs/libxfs/xfs_trans_inode.c                    |    2 +-
 fs/xfs/xfs_aops.c                                  |    4 +-
 fs/xfs/xfs_bmap_item.c                             |  238 +--
 fs/xfs/xfs_bmap_item.h                             |    3 +-
 fs/xfs/xfs_extfree_item.c                          |  175 +-
 fs/xfs/xfs_extfree_item.h                          |   18 +-
 fs/xfs/xfs_icreate_item.c                          |    1 +
 fs/xfs/xfs_inode.c                                 |    4 +-
 fs/xfs/xfs_inode_item.c                            |    2 +-
 fs/xfs/xfs_inode_item.h                            |    4 +-
 fs/xfs/xfs_iwalk.c                                 |   27 +-
 fs/xfs/xfs_log.c                                   |   68 +-
 fs/xfs/xfs_log.h                                   |    3 +
 fs/xfs/xfs_log_cil.c                               |    8 +-
 fs/xfs/xfs_log_recover.c                           |  160 +-
 fs/xfs/xfs_mount.c                                 |    3 +-
 fs/xfs/xfs_refcount_item.c                         |  173 +-
 fs/xfs/xfs_refcount_item.h                         |    3 +-
 fs/xfs/xfs_rmap_item.c                             |  161 +-
 fs/xfs/xfs_rmap_item.h                             |    3 +-
 fs/xfs/xfs_stats.c                                 |    4 +
 fs/xfs/xfs_stats.h                                 |    1 +
 fs/xfs/xfs_super.c                                 |    8 +-
 fs/xfs/xfs_trace.h                                 |    1 +
 fs/xfs/xfs_trans.h                                 |   10 +
 include/linux/hugetlb.h                            |   18 +-
 include/linux/iommu.h                              |   21 +-
 include/linux/stmmac.h                             |    1 +
 include/net/sock.h                                 |   13 +
 kernel/sched/psi.c                                 |    7 +-
 kernel/trace/trace.c                               |    3 -
 mm/memblock.c                                      |    8 +-
 mm/mempolicy.c                                     |    3 +-
 mm/swapfile.c                                      |   13 +-
 net/bridge/br_netfilter_hooks.c                    |    1 +
 net/can/j1939/address-claim.c                      |   40 +
 net/can/j1939/transport.c                          |    4 -
 net/core/dev.c                                     |    2 +-
 net/core/filter.c                                  |    3 +-
 net/dccp/ipv6.c                                    |    7 +-
 net/ipv6/datagram.c                                |    2 +-
 net/ipv6/tcp_ipv6.c                                |   11 +-
 net/mpls/af_mpls.c                                 |    4 +
 net/netfilter/nft_tproxy.c                         |    8 +
 net/netrom/af_netrom.c                             |    5 +
 net/openvswitch/datapath.c                         |   12 +-
 net/rds/message.c                                  |    6 +-
 net/rose/af_rose.c                                 |    8 +
 net/sched/sch_htb.c                                |    5 +-
 net/sctp/diag.c                                    |    4 +-
 net/sunrpc/xprtrdma/verbs.c                        |    4 +-
 net/x25/af_x25.c                                   |    6 +
 net/xfrm/xfrm_input.c                              |    3 +-
 sound/pci/hda/patch_conexant.c                     |    1 +
 sound/pci/hda/patch_realtek.c                      |    2 +-
 sound/pci/hda/patch_via.c                          |    3 +
 sound/pci/lx6464es/lx_core.c                       |   11 +-
 sound/soc/codecs/cs42l56.c                         |    6 -
 sound/soc/intel/boards/bytcr_rt5651.c              |    2 +-
 sound/soc/sof/intel/hda-dai.c                      |    8 +-
 sound/synth/emux/emux_nrpn.c                       |    3 +
 .../selftests/bpf/verifier/search_pruning.c        |   36 +
 tools/testing/selftests/net/fib_tests.sh           | 1727 ++++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh      |    4 +-
 tools/testing/selftests/net/udpgso_bench.sh        |   24 +-
 tools/testing/selftests/net/udpgso_bench_rx.c      |    4 +-
 tools/testing/selftests/net/udpgso_bench_tx.c      |   36 +-
 tools/virtio/linux/bug.h                           |    8 +-
 tools/virtio/linux/build_bug.h                     |    7 +
 tools/virtio/linux/cpumask.h                       |    7 +
 tools/virtio/linux/gfp.h                           |    7 +
 tools/virtio/linux/kernel.h                        |    1 +
 tools/virtio/linux/kmsan.h                         |   12 +
 tools/virtio/linux/scatterlist.h                   |    1 +
 tools/virtio/linux/topology.h                      |    7 +
 177 files changed, 4190 insertions(+), 1340 deletions(-)


