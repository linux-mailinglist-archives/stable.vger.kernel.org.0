Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5614FE76F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 19:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346542AbiDLRtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 13:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiDLRtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 13:49:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6055D5CE;
        Tue, 12 Apr 2022 10:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5364861AA0;
        Tue, 12 Apr 2022 17:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53C2C385A5;
        Tue, 12 Apr 2022 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649785616;
        bh=HSBUqf+fuqmtis9phYqTH1OM4s/XNYQdPZAZ33DN9a0=;
        h=From:To:Cc:Subject:Date:From;
        b=lgW4ScwvGBb/OheYOol/mr34fMLVqCcEEFIlIpb4D2/a69ZgfvaqvOK3ZOC8xsn+i
         FNjKMJ1rf1grgaDTOA/sjZBvKnIVON9g22QUA7TaF0hHqeEdODUdUKvC3IXrq57jtP
         9N2Ul2BULLX9q0dDRL7MkcuAtI6bcgF3tkcblt2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/170] 5.10.111-rc2 review
Date:   Tue, 12 Apr 2022 19:46:52 +0200
Message-Id: <20220412173819.234884577@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.111-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.111-rc2
X-KernelTest-Deadline: 2022-04-14T17:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.111 release.
There are 170 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Apr 2022 17:37:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.111-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.111-rc2

Kefeng Wang <wangkefeng.wang@huawei.com>
    powerpc: Fix virt_addr_valid() for 64-bit Book3E & 32-bit

Waiman Long <longman@redhat.com>
    mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

Andre Przywara <andre.przywara@arm.com>
    irqchip/gic, gic-v3: Prevent GSI to SGI translations

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    Drivers: hv: vmbus: Replace smp_store_mb() with virt_store_mb()

Fangrui Song <maskray@google.com>
    arm64: module: remove (NOLOAD) from linker script

Tejun Heo <tj@kernel.org>
    selftests: cgroup: Test open-time cgroup namespace usage for migration checks

Tejun Heo <tj@kernel.org>
    selftests: cgroup: Test open-time credential usage for migration checks

Tejun Heo <tj@kernel.org>
    selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644

Sachin Sant <sachinp@linux.vnet.ibm.com>
    selftests/cgroup: Fix build on older distros

Tejun Heo <tj@kernel.org>
    cgroup: Use open-time credentials for process migraton perm checks

Peter Xu <peterx@redhat.com>
    mm: don't skip swap entry even if zap_details specified

Kees Cook <keescook@chromium.org>
    ubsan: remove CONFIG_UBSAN_OBJECT_SIZE

Vinod Koul <vkoul@kernel.org>
    dmaengine: Revert "dmaengine: shdma: Fix runtime PM imbalance on error"

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Use $(shell ) instead of `` to get embedded libperl's ccopts

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Filter out options and warnings not supported by clang

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Fix probing for some clang command line options

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Don't use -ffat-lto-objects in the python feature test when building with clang-13

Lee Jones <lee.jones@linaro.org>
    drm/amdkfd: Create file descriptor after client is added to smi_clients list

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/pmu: Add missing callbacks for Tegra devices

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu10: fix SoC/fclk units in auto mode

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3: Fix GICR_CTLR.RWP polling

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    perf: qcom_l2_pmu: fix an incorrect NULL check on list iterator

Christian Lamparter <chunkeey@gmail.com>
    ata: sata_dwc_460ex: Fix crash due to OOB write

Shreeya Patel <shreeya.patel@collabora.com>
    gpio: Restrict usage of GPIO chip irq members before initialization

Douglas Miller <doug.miller@cornelisnetworks.com>
    RDMA/hfi1: Fix use-after-free bug for mm struct

Guo Ren <guoren@linux.alibaba.com>
    arm64: patch_text: Fixup last cpu should be master

Kaiwen Hu <kevinhu@synology.com>
    btrfs: prevent subvol with swapfile from being deleted

Ethan Lien <ethanlien@synology.com>
    btrfs: fix qgroup reserve overflow the qgroup limit

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Restore speculation related MSRs during S3 resume

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/pm: Save the MSR validity status at context setup

Jens Axboe <axboe@kernel.dk>
    io_uring: fix race between timeout flush and removal

Miaohe Lin <linmiaohe@huawei.com>
    mm/mempolicy: fix mpol_new leak in shared_policy_replace

Paolo Bonzini <pbonzini@redhat.com>
    mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

Guo Xuenan <guoxuenan@huawei.com>
    lz4: fix LZ4_decompress_safe_partial read out of bound

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: don't overwrite TAP settings when HS400 tuning is complete

Yann Gautier <yann.gautier@foss.st.com>
    mmc: mmci: stm32: correctly check all elements of sg list

Pali Rohár <pali@kernel.org>
    Revert "mmc: sdhci-xenon: fix annoying 1.8V regulator warning"

Chanho Park <chanho61.park@samsung.com>
    arm64: Add part number for Arm Cortex-A78AE

Denis Nikitin <denik@chromium.org>
    perf session: Remap buf if there is no space for event

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix perf's libperf_print callback

James Clark <james.clark@arm.com>
    perf: arm-spe: Fix perf report --mem-mode

Tony Lindgren <tony@atomide.com>
    iommu/omap: Fix regression in probe for NULL pointer dereference

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: svc_tcp_sendmsg() should handle errors from xdr_alloc_bvec()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Handle low memory situations in call_status()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Handle ENOMEM in call_transmit_status()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't touch scm_fp_list after queueing skb

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    drbd: Fix five use after free bugs in get_initial_state

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Support dual-stack sockets in bpf_tcp_check_syncookie

Kamal Dasu <kdasu.kdev@gmail.com>
    spi: bcm-qspi: fix MSPI only access with bcm_qspi_exec_mem_op()

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    qede: confirm skb is allocated before using

Michael Walle <michael@walle.cc>
    net: phy: mscc-miim: reject clause 45 register accesses

Eric Dumazet <edumazet@google.com>
    rxrpc: fix a race in rxrpc_exit_net()

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix leak of nested actions

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: don't send internal clone attribute to the userspace.

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: synchronize_rcu() when terminating rings

David Ahern <dsahern@kernel.org>
    ipv6: Fix stats accounting in ip6_pkt_drop

Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
    ice: Do not skip not enabled queues in ice_vc_dis_qs_msg

Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
    ice: Set txq_teid to ICE_INVAL_TEID on ring creation

Miaoqian Lin <linmq006@gmail.com>
    dpaa2-ptp: Fix refcount leak in dpaa2_ptp_probe

Niels Dossche <dossche.niels@gmail.com>
    IB/rdmavt: add lock to call to rvt_error_qp to prevent a race condition

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Don't remove cache MRs when a delay is needed

Martin Habets <habetsm.xilinx@gmail.com>
    sfc: Do not free an empty page_ring

Andy Gospodarek <gospo@broadcom.com>
    bnxt_en: reserve space inside receive page for skb_shared_info

José Expósito <jose.exposito89@gmail.com>
    drm/imx: Fix memory leak in imx_pd_connector_get_modes

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/imx: imx-ldb: Check for null pointer after calling kmemdup

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: Fix unset max_speed difference between DT and non-DT platforms

Nikolay Aleksandrov <razor@blackwall.org>
    net: ipv4: fix route with nexthop object delete warning

Ivan Vecera <ivecera@redhat.com>
    ice: Clear default forwarding VSI during VSI release

Ziyang Xuan <william.xuanziyang@huawei.com>
    net/tls: fix slab-out-of-bounds bug in decrypt_internal

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()

ChenXiaoSong <chenxiaosong2@huawei.com>
    NFSv4: fix open failure with O_ACCMODE flag

ChenXiaoSong <chenxiaosong2@huawei.com>
    Revert "NFSv4: Handle the special Linux file open access mode"

Guilherme G. Piccoli <gpiccoli@igalia.com>
    Drivers: hv: vmbus: Fix potential crash on module unload

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amdgpu: fix off by one in amdgpu_gfx_kiq_acquire()

Sasha Levin <sashal@kernel.org>
    Revert "hv: utils: add PTP_1588_CLOCK to Kconfig to fix build"

Mauricio Faria de Oliveira <mfo@canonical.com>
    mm: fix race between MADV_FREE reclaim and blkdev direct IO read

John David Anglin <dave.anglin@bell.net>
    parisc: Fix patch code locking and flushing

Helge Deller <deller@gmx.de>
    parisc: Fix CPU affinity for Lasi, WAX and Dino chips

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Avoid writeback threads getting stuck in mempool_alloc()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfsiod should not block forever in mempool_alloc()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix socket waits for write buffer space

Haimin Zhang <tcs_kernel@tencent.com>
    jfs: prevent NULL deref in diFree

Randy Dunlap <rdunlap@infradead.org>
    virtio_console: eliminate anonymous module_init & module_exit

Jiri Slaby <jirislaby@kernel.org>
    serial: samsung_tty: do not unlock port->lock for uart_write_wakeup()

Nathan Chancellor <nathan@kernel.org>
    x86/Kconfig: Do not allow CONFIG_X86_X32_ABI=y with llvm-objcopy

NeilBrown <neilb@suse.de>
    NFS: swap-out must always use STABLE writes.

NeilBrown <neilb@suse.de>
    NFS: swap IO handling is slightly different for O_DIRECT IO

NeilBrown <neilb@suse.de>
    SUNRPC: remove scheduling boost for "SWAPPER" tasks.

NeilBrown <neilb@suse.de>
    SUNRPC/xprt: async tasks mustn't block waiting for memory

NeilBrown <neilb@suse.de>
    SUNRPC/call_alloc: async tasks mustn't block waiting for memory

Maxime Ripard <maxime@cerno.tech>
    clk: Enforce that disjoints limits are invalid

Tony Lindgren <tony@atomide.com>
    clk: ti: Preserve node in ti_dt_clocks_register()

Dongli Zhang <dongli.zhang@oracle.com>
    xen: delay xen_hvm_init_time_ops() if kdump is boot on vcpu>=32

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Protect the state recovery thread against direct reclaim

Xin Xiong <xiongx18@fudan.edu.cn>
    NFSv4.2: fix reference count leaks in _nfs42_proc_copy_notify()

Lucas Denefle <lucas.denefle@converge.io>
    w1: w1_therm: fixes w1_seq for ds28ea00 sensors

Xiaoke Wang <xkernel.wang@foxmail.com>
    staging: wfx: fix an error handling in wfx_init_common()

Amjad Ouled-Ameur <aouledameur@baylibre.com>
    phy: amlogic: meson8b-usb2: Use dev_err_probe()

Stefan Wahren <stefan.wahren@i2se.com>
    staging: vchiq_core: handle NULL result of find_service_by_handle

Adam Wujek <dev_public@wujek.eu>
    clk: si5341: fix reported clk_rate when output divider is 2

Qinghua Jin <qhjin.dev@gmail.com>
    minix: fix bug when opening a file with O_DIRECT

Randy Dunlap <rdunlap@infradead.org>
    init/main.c: return 1 from handled __setup() functions

Xiubo Li <xiubli@redhat.com>
    ceph: fix memory leak in ceph_readdir when note_last_dentry returns error

Wang Yufen <wangyufen@huawei.com>
    netlabel: fix out-of-bounds memory accesses

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix use after free in hci_send_acl

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    MIPS: ingenic: correct unit node address

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix DTC warning unit_address_format

H. Nikolaus Schaller <hns@goldelico.com>
    usb: dwc3: omap: fix "unbalanced disables for smps10_out1" on omap5evm

Michael Walle <michael@walle.cc>
    net: sfp: add 2500base-X quirk for Lantech SFP module

Jakub Kicinski <kuba@kernel.org>
    net: limit altnames to 64k total

Jakub Kicinski <kuba@kernel.org>
    net: account alternate interface name memory

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: set default value for N_As to 50 micro seconds

Jianglei Nie <niejianglei2021@163.com>
    scsi: libfc: Fix use after free in fc_exch_abts_resp()

Hangyu Hua <hbh25y@gmail.com>
    powerpc/secvar: fix refcount leak in format_show()

Alexander Lobakin <alobakin@pm.me>
    MIPS: fix fortify panic when copying asm exception handlers

Li Chen <lchen@ambarella.com>
    PCI: endpoint: Fix misused goto label

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Eliminate unintended link toggle during FW reset

Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
    Bluetooth: use memset avoid memory leaks

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix not checking for valid hdev on bt_dev_{info,warn,err,dbg}

Harold Huang <baymaxhuang@gmail.com>
    tuntap: add sanity checks about msg_controllen in sendmsg

Sven Eckelmann <sven@narfation.org>
    macvtap: advertise link netns via netlink

Hangyu Hua <hbh25y@gmail.com>
    mips: ralink: fix a refcount leak in ill_acc_of_setup()

Dust Li <dust.li@linux.alibaba.com>
    net/smc: correct settings of RMB window update limit

Qi Liu <liuqi115@huawei.com>
    scsi: hisi_sas: Free irq vectors in order for v3 HW

Randy Dunlap <rdunlap@infradead.org>
    scsi: aha152x: Fix aha152x_setup() __setup handler return value

Yang Li <yang.lee@linux.alibaba.com>
    mt76: mt7615: Fix assigning negative values to unsigned variable

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix memory leak in pm8001_chip_fw_flash_update_req()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix tag leaks on error

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix task leak in pm8001_send_abort_all()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix pm8001_mpi_task_abort_resp()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix pm80xx_pci_mem_copy() interface

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: make CRAT table missing message informational only

Mike Snitzer <snitzer@redhat.com>
    dm: requeue IO if mapping table not yet available

Jordy Zomer <jordy@jordyzomer.github.io>
    dm ioctl: prevent potential spectre v1 gadget

Ido Schimmel <idosch@nvidia.com>
    ipv4: Invalidate neighbour for broadcast address upon address addition

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Correctly set fragmented EBS

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288-charger: Set Vhold to 4.4V

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: pciehp: Add Qualcomm quirk for Command Completed erratum

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    tcp: Don't acquire inet_listen_hashbucket::lock with disabled BH.

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: endpoint: Fix alignment fault error in copy tests

Neal Liu <neal_liu@aspeedtech.com>
    usb: ehci: add pci device support for Aspeed platforms

Zhou Guanghui <zhouguanghui1@huawei.com>
    iommu/arm-smmu-v3: fix event handling soft lockup

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for MSI interrupts

Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
    drm/amdgpu: Fix recursive locking warning

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc: Set crashkernel offset to mid of RMA region

Eric Dumazet <edumazet@google.com>
    ipv6: make mc_forwarding atomic

Yonghong Song <yhs@fb.com>
    libbpf: Fix build issue with llvm-readelf

Avraham Stern <avraham.stern@intel.com>
    cfg80211: don't add non transmitted BSS to 6GHz scanned channels

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: initialize skip_unmap in mt76_dma_rx_fill

Evgeny Boger <boger@wirenboard.com>
    power: supply: axp20x_battery: properly report current when discharging

Yang Guang <yang.guang5@zte.com.cn>
    scsi: bfa: Replace snprintf() with sysfs_emit()

Yang Guang <yang.guang5@zte.com.cn>
    scsi: mvsas: Replace snprintf() with sysfs_emit()

Jakub Sitnicki <jakub@cloudflare.com>
    bpf: Make dst_port field in struct bpf_sock 16-bit wide

Kalle Valo <quic_kvalo@quicinc.com>
    ath11k: mhi: use mhi_sync_power_up()

Venkateswara Naralasetty <quic_vnaralas@quicinc.com>
    ath11k: fix kernel panic during unload/load ath11k modules

Maxim Kiselev <bigunclemax@gmail.com>
    powerpc: dts: t104xrdb: fix phy type for FMAN 4/5

Yang Guang <yang.guang5@zte.com.cn>
    ptp: replace snprintf with sysfs_emit

Wayne Chang <waynec@nvidia.com>
    usb: gadget: tegra-xudc: Fix control endpoint's definitions

Wayne Chang <waynec@nvidia.com>
    usb: gadget: tegra-xudc: Do not program SPARAM

Xin Xiong <xiongx18@fudan.edu.cn>
    drm/amd/amdgpu/amdgpu_cs: fix refcount leak of a dma_fence obj

Dale Zhao <dale.zhao@amd.com>
    drm/amd/display: Add signal type check when verify stream backends same

Zekun Shen <bruceshenzk@gmail.com>
    ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

Anisse Astier <anisse@astier.eu>
    drm: Add orientation quirk for GPD Win Max

Hou Wenlong <houwenlong.hwl@antgroup.com>
    KVM: x86/emulator: Emulate RDPID only if it is enabled in guest

Jim Mattson <jmattson@google.com>
    KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    rtc: wm8350: Handle error for wm8350_register_irq

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: gfs2_setattr_size error path fix

Bob Peterson <rpeterso@redhat.com>
    gfs2: Fix gfs2_release for non-writers regression

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Check for active reservation in gfs2_release

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Rectify space amount budget for mkdir/tmpfile operations


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/module.lds.h                |   6 +-
 arch/arm64/kernel/insn.c                           |   4 +-
 arch/arm64/kernel/proton-pack.c                    |   1 +
 arch/mips/boot/dts/ingenic/jz4780.dtsi             |   2 +-
 arch/mips/include/asm/setup.h                      |   2 +-
 arch/mips/kernel/traps.c                           |  22 +--
 arch/mips/ralink/ill_acc.c                         |   1 +
 arch/parisc/kernel/patch.c                         |  25 ++--
 arch/powerpc/boot/dts/fsl/t104xrdb.dtsi            |   4 +-
 arch/powerpc/include/asm/page.h                    |   6 +-
 arch/powerpc/kernel/rtas.c                         |   6 +
 arch/powerpc/kernel/secvar-sysfs.c                 |   9 +-
 arch/powerpc/kexec/core.c                          |  15 +-
 arch/x86/Kconfig                                   |   5 +
 arch/x86/kvm/emulate.c                             |   4 +-
 arch/x86/kvm/kvm_emulate.h                         |   1 +
 arch/x86/kvm/svm/pmu.c                             |   8 +-
 arch/x86/kvm/x86.c                                 |   6 +
 arch/x86/power/cpu.c                               |  21 ++-
 arch/x86/xen/smp_hvm.c                             |   6 +
 arch/x86/xen/time.c                                |  24 ++-
 arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi        |   8 +-
 arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi         |   8 +-
 arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi          |   4 +-
 drivers/ata/sata_dwc_460ex.c                       |   6 +-
 drivers/block/drbd/drbd_int.h                      |   8 +-
 drivers/block/drbd/drbd_nl.c                       |  41 +++--
 drivers/block/drbd/drbd_state.c                    |  18 +--
 drivers/block/drbd/drbd_state_change.h             |   8 +-
 drivers/char/virtio_console.c                      |   8 +-
 drivers/clk/clk-si5341.c                           |  16 +-
 drivers/clk/clk.c                                  |  24 +++
 drivers/clk/ti/clk.c                               |  13 +-
 drivers/dma/sh/shdma-base.c                        |   4 +-
 drivers/gpio/gpiolib.c                             |  19 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c        |  24 +--
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   3 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c   |   8 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/imx/imx-ldb.c                      |   2 +
 drivers/gpu/drm/imx/parallel-display.c             |   4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c    |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c    |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h     |   1 +
 drivers/hv/Kconfig                                 |   1 -
 drivers/hv/channel_mgmt.c                          |   6 +-
 drivers/hv/vmbus_drv.c                             |   9 +-
 drivers/infiniband/hw/hfi1/mmu_rb.c                |   6 +
 drivers/infiniband/hw/mlx5/mr.c                    |   4 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   6 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   1 +
 drivers/iommu/omap-iommu.c                         |   2 +-
 drivers/irqchip/irq-gic-v3.c                       |  14 +-
 drivers/irqchip/irq-gic.c                          |   6 +
 drivers/md/dm-ioctl.c                              |   2 +
 drivers/md/dm-rq.c                                 |   7 +-
 drivers/md/dm.c                                    |  11 +-
 drivers/mmc/host/mmci_stm32_sdmmc.c                |   6 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   4 +-
 drivers/mmc/host/sdhci-xenon.c                     |  10 --
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   4 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   3 +
 drivers/net/ethernet/sfc/rx_common.c               |   3 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   3 +-
 drivers/net/macvtap.c                              |   6 +
 drivers/net/mdio/mdio-mscc-miim.c                  |   6 +
 drivers/net/phy/sfp-bus.c                          |   6 +
 drivers/net/tap.c                                  |   3 +-
 drivers/net/tun.c                                  |   3 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   2 +
 drivers/net/wireless/ath/ath11k/mhi.c              |   2 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   5 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   2 +-
 drivers/parisc/dino.c                              |  41 ++++-
 drivers/parisc/gsc.c                               |  31 ++++
 drivers/parisc/gsc.h                               |   1 +
 drivers/parisc/lasi.c                              |   7 +-
 drivers/parisc/wax.c                               |   7 +-
 drivers/pci/controller/pci-aardvark.c              |  16 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |  14 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   2 +
 drivers/perf/qcom_l2_pmu.c                         |   6 +-
 drivers/phy/amlogic/phy-meson8b-usb2.c             |   5 +-
 drivers/power/supply/axp20x_battery.c              |  13 +-
 drivers/power/supply/axp288_charger.c              |  14 +-
 drivers/ptp/ptp_sysfs.c                            |   4 +-
 drivers/rtc/rtc-wm8350.c                           |  11 +-
 drivers/scsi/aha152x.c                             |   6 +-
 drivers/scsi/bfa/bfad_attr.c                       |  26 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  16 +-
 drivers/scsi/libfc/fc_exch.c                       |   1 +
 drivers/scsi/mvsas/mv_init.c                       |   4 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  27 +++-
 drivers/scsi/pm8001/pm8001_sas.c                   |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  17 ++-
 drivers/scsi/zorro7xx.c                            |   2 +
 drivers/spi/spi-bcm-qspi.c                         |   4 +-
 .../vc04_services/interface/vchiq_arm/vchiq_core.c |   6 +
 drivers/staging/wfx/main.c                         |   7 +-
 drivers/tty/serial/samsung_tty.c                   |   5 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   2 +-
 drivers/usb/gadget/udc/tegra-xudc.c                |  20 +--
 drivers/usb/host/ehci-pci.c                        |   9 ++
 drivers/vhost/net.c                                |   1 +
 drivers/w1/slaves/w1_therm.c                       |   8 +-
 fs/btrfs/extent_io.h                               |   2 +-
 fs/btrfs/inode.c                                   |  22 +++
 fs/ceph/dir.c                                      |  11 +-
 fs/gfs2/bmap.c                                     |   2 +-
 fs/gfs2/file.c                                     |   3 +-
 fs/gfs2/inode.c                                    |   2 +-
 fs/gfs2/rgrp.c                                     |   7 +-
 fs/gfs2/rgrp.h                                     |   2 +-
 fs/gfs2/super.c                                    |   2 +-
 fs/io_uring.c                                      |  23 +--
 fs/jfs/inode.c                                     |   3 +-
 fs/minix/inode.c                                   |   3 +-
 fs/nfs/dir.c                                       |  10 --
 fs/nfs/direct.c                                    |  48 ++++--
 fs/nfs/file.c                                      |   4 +-
 fs/nfs/inode.c                                     |   1 -
 fs/nfs/internal.h                                  |  17 +++
 fs/nfs/nfs42proc.c                                 |   9 +-
 fs/nfs/nfs4file.c                                  |   6 +-
 fs/nfs/nfs4state.c                                 |  12 ++
 fs/nfs/pagelist.c                                  |  10 +-
 fs/nfs/pnfs_nfs.c                                  |   8 +-
 fs/nfs/write.c                                     |  34 ++---
 fs/ubifs/dir.c                                     |  12 +-
 include/linux/gpio/driver.h                        |   9 ++
 include/linux/ipv6.h                               |   2 +-
 include/linux/mmzone.h                             |  11 +-
 include/linux/nfs_fs.h                             |  10 +-
 include/net/arp.h                                  |   1 +
 include/net/bluetooth/bluetooth.h                  |  14 +-
 include/uapi/linux/bpf.h                           |   3 +-
 include/uapi/linux/can/isotp.h                     |  28 +++-
 init/main.c                                        |   6 +-
 kernel/cgroup/cgroup-v1.c                          |   7 +-
 kernel/cgroup/cgroup.c                             |  17 ++-
 lib/lz4/lz4_decompress.c                           |   8 +-
 lib/test_ubsan.c                                   |  11 --
 mm/memory.c                                        |  25 +++-
 mm/mempolicy.c                                     |   1 +
 mm/mremap.c                                        |   3 +
 mm/rmap.c                                          |  25 +++-
 net/batman-adv/multicast.c                         |   2 +-
 net/bluetooth/hci_event.c                          |   3 +-
 net/bluetooth/l2cap_core.c                         |   1 +
 net/can/isotp.c                                    |  12 +-
 net/core/filter.c                                  |  27 +++-
 net/core/rtnetlink.c                               |  13 +-
 net/ipv4/arp.c                                     |   9 +-
 net/ipv4/fib_frontend.c                            |   5 +-
 net/ipv4/fib_semantics.c                           |   7 +-
 net/ipv4/inet_hashtables.c                         |  53 ++++---
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/inet6_hashtables.c                        |   5 +-
 net/ipv6/ip6_input.c                               |   2 +-
 net/ipv6/ip6mr.c                                   |   8 +-
 net/ipv6/route.c                                   |   2 +-
 net/netlabel/netlabel_kapi.c                       |   2 +
 net/openvswitch/actions.c                          |   2 +-
 net/openvswitch/flow_netlink.c                     |  99 ++++++++++++-
 net/rxrpc/net_ns.c                                 |   2 +-
 net/smc/smc_core.c                                 |   2 +-
 net/sunrpc/clnt.c                                  |   7 +
 net/sunrpc/sched.c                                 |  11 +-
 net/sunrpc/svcsock.c                               |   4 +-
 net/sunrpc/xprt.c                                  |  16 +-
 net/sunrpc/xprtrdma/transport.c                    |   6 +-
 net/sunrpc/xprtsock.c                              |  54 +++++--
 net/tls/tls_sw.c                                   |   2 +-
 net/wireless/scan.c                                |   9 +-
 scripts/Makefile.ubsan                             |   1 -
 tools/build/feature/Makefile                       |   9 +-
 tools/lib/bpf/Makefile                             |   4 +-
 tools/perf/Makefile.config                         |   6 +
 tools/perf/arch/arm64/util/arm-spe.c               |   6 +
 tools/perf/perf.c                                  |   2 +-
 tools/perf/util/session.c                          |  15 +-
 tools/perf/util/setup.py                           |   8 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |   6 +-
 tools/testing/selftests/cgroup/test_core.c         | 165 +++++++++++++++++++++
 200 files changed, 1426 insertions(+), 534 deletions(-)


