Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D6B551977
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243074AbiFTMzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243212AbiFTMys (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:54:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C81F19008;
        Mon, 20 Jun 2022 05:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1300AB811AE;
        Mon, 20 Jun 2022 12:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7061C3411C;
        Mon, 20 Jun 2022 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729658;
        bh=9TxzUr5MGuCsv44rFSJ6WF5U5BVE71WhNq827ko9wAs=;
        h=From:To:Cc:Subject:Date:From;
        b=pBe8/5JtZ5ZmfdQIwEAfiklmoStLwRkfrXVyqP4uZLVKnZjZ0mBlq9Aey2Cd5lhNW
         Rk0qSx+8q8T6QTtAps1d4ze3jHZclO+jwFtgr9AKcsxiEKapfGG+yHvF8foFVzxnP8
         Kzwh8ke7Sbi7Vdf93cRmfxeC8LLOc2h4JUvZ1TPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 000/141] 5.18.6-rc1 review
Date:   Mon, 20 Jun 2022 14:48:58 +0200
Message-Id: <20220620124729.509745706@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.6-rc1
X-KernelTest-Deadline: 2022-06-22T12:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.18.6 release.
There are 141 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.6-rc1

Peng Fan <peng.fan@nxp.com>
    clk: imx8mp: fix usb_root_clk parent

Christoph Hellwig <hch@lst.de>
    dm: fix bio_set allocation

Mauro Carvalho Chehab <mchehab@kernel.org>
    dt-bindings: interrupt-controller: update brcm,l2-intc.yaml reference

Mauro Carvalho Chehab <mchehab@kernel.org>
    dt-bindings: mfd: bd9571mwv: update rohm,bd9571mwv.yaml reference

Masahiro Yamada <masahiroy@kernel.org>
    powerpc/book3e: get rid of #include <generated/compile.h>

Dan Carpenter <dan.carpenter@oracle.com>
    bpf: Use safer kvmalloc_array() where possible

Jani Nikula <jani.nikula@intel.com>
    drm/i915/uc: remove accidental static from a local variable

David Howells <dhowells@redhat.com>
    netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context

Murilo Opsfelder Araujo <muriloo@linux.ibm.com>
    virtio-pci: Remove wrong address verification in vp_del_vqs()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't read a HW interrupt pending state in user context

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Always start with clearing SVE flag on load

Zhang Yi <yi.zhang@huawei.com>
    ext4: add reserved GDT blocks check

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ext4: make variable "count" signed

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on ext4_mb_use_inode_pa

Ye Bin <yebin10@huawei.com>
    ext4: fix super block checksum incorrect after mount

Christian Göttsche <cgzones@googlemail.com>
    selinux: free contexts previously transferred in selinux_add_opt()

Christian Brauner <brauner@kernel.org>
    fs: account for group membership

Sami Tolvanen <samitolvanen@google.com>
    cfi: Fix __cfi_slowpath_diag RCU usage with cpuidle

Christian Göttsche <cgzones@googlemail.com>
    audit: free module name

Roman Li <roman.li@amd.com>
    drm/amd/display: Cap OLED brightness per max frame-average luminance

Michel Dänzer <mdaenzer@redhat.com>
    drm/amdgpu: Fix GTT size reporting in amdgpu_ioctl

Mikulas Patocka <mpatocka@redhat.com>
    dm mirror log: round up region bitmap size to BITS_PER_LONG

Benjamin Marzinski <bmarzins@redhat.com>
    dm: fix race in dm_start_io_acct

Logan Gunthorpe <logang@deltatee.com>
    md/raid5-ppl: Fix argument order in bio_alloc_bioset()

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    bus: fsl-mc-bus: fix KASAN use-after-free in fsl_mc_bus_remove()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Store to lsr_save_flags after lsr read

Tony Lindgren <tony@atomide.com>
    tty: n_gsm: Debug output allocation must use GFP_ATOMIC

Linyu Yuan <quic_linyyuan@quicinc.com>
    usb: gadget: f_fs: change ep->ep safe in ffs_epfile_io()

Linyu Yuan <quic_linyyuan@quicinc.com>
    usb: gadget: f_fs: change ep->status safe in ffs_epfile_io()

Miaoqian Lin <linmq006@gmail.com>
    usb: gadget: lpc32xx_udc: Fix refcount leak in lpc32xx_udc_probe

Marian Postevca <posteuca@mutex.one>
    usb: gadget: u_ether: fix regression in setting fixed MAC address

Stephan Gerhold <stephan@gerhold.net>
    usb: dwc3: pci: Restore line lost in merge conflict resolution

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Fix IN endpoint max packet size allocation

Jing Leng <jleng@ambarella.com>
    usb: cdnsp: Fixed setting last_trb incorrectly

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc2: Fix memory leak in dwc2_hcd_init

Will Deacon <will@kernel.org>
    arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer

Robert Eckelmann <longnoserob@gmail.com>
    USB: serial: io_ti: add Agilent E5805A support

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Cinterion MV31 with new baseline

Jason A. Donenfeld <Jason@zx2c4.com>
    crypto: memneq - move into lib/

Ian Abbott <abbotti@mev.co.uk>
    comedi: vmk80xx: fix expression for tx buffer size

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add raptor lake point S DID

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: hbm: drop capability response on early shutdown

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: mediatek: Fix an error handling path in mtk_i2c_probe()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    i2c: designware: Use standard optional ref clock implementation

Peter Zijlstra <peterz@infradead.org>
    sched: Fix balance_push() vs __sched_setscheduler()

Miaoqian Lin <linmq006@gmail.com>
    irqchip/realtek-rtl: Fix refcount leak in map_interrupts

Miaoqian Lin <linmq006@gmail.com>
    irqchip/gic-v3: Fix refcount leak in gic_populate_ppi_partitions

Miaoqian Lin <linmq006@gmail.com>
    irqchip/gic-v3: Fix error handling in gic_populate_ppi_partitions

Miaoqian Lin <linmq006@gmail.com>
    irqchip/apple-aic: Fix refcount leak in aic_of_ic_init

Miaoqian Lin <linmq006@gmail.com>
    irqchip/apple-aic: Fix refcount leak in build_fiq_affinity

Miaoqian Lin <linmq006@gmail.com>
    irqchip/gic/realview: Fix refcount leak in realview_gic_of_init

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    i2c: npcm7xx: Add check for platform_driver_register

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/ftrace: Remove OBJECT_FILES_NON_STANDARD usage

Josh Poimboeuf <jpoimboe@kernel.org>
    faddr2line: Fix overlapping text section failures, the sequel

Bart Van Assche <bvanassche@acm.org>
    block: Fix handling of offline queues in blk_mq_alloc_request_hctx()

Jan Kara <jack@suse.cz>
    init: Initialize noop_backing_dev_info early

Masahiro Yamada <masahiroy@kernel.org>
    certs/blacklist_hashes.c: fix const confusion in certs blacklist

Mark Rutland <mark.rutland@arm.com>
    arm64: ftrace: consistently handle PLTs.

Mark Rutland <mark.rutland@arm.com>
    arm64: ftrace: fix branch range checks

Duoming Zhou <duoming@zju.edu.cn>
    net: ax25: Fix deadlock caused by skb_recv_datagram in ax25_recvmsg

Oliver Hartkopp <socketcan@hartkopp.net>
    net: remove noblock parameter from skb_recv_datagram()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: bgmac: Fix an erroneous kfree() in bgmac_remove()

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    ice: Fix memory corruption in VF driver

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    ice: Fix queue config fail handling

Roman Storozhenko <roman.storozhenko@intel.com>
    ice: Sync VLAN filtering features for DVM

Michal Michalik <michal.michalik@intel.com>
    ice: Fix PTP TX timestamp offset calculation

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum_cnt: Reorder counter pools

Thomas Weißschuh <linux@weissschuh.net>
    nvme: add device name to warning in uuid_show()

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix tm port shapping of fibre port is incorrect after driver initialization

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix PF rss size initialization bug

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: restore tm priority/qset to default settings when tc disabled

Jian Shen <shenjian15@huawei.com>
    net: hns3: don't push link state to VF if unalive

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: set port base vlan tbl_sta to false before removing old vlan

Alan Previn <alan.previn.teres.alexis@intel.com>
    drm/i915/reset: Fix error_state_read ptr + offset use

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix races with buffer table unregister

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix races with file table unregister

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: re-add pdma to mpfs device tree

Miaoqian Lin <linmq006@gmail.com>
    misc: atmel-ssc: Fix IRQ check in ssc_probe

Vincent Whitchurch <vincent.whitchurch@axis.com>
    tty: goldfish: Fix free_irq() on remove

Saurabh Sengar <ssengar@linux.microsoft.com>
    Drivers: hv: vmbus: Release cpu lock in error case

Michal Wilczynski <michal.wilczynski@intel.com>
    iavf: Fix issue with MAC address of VF shown as zero

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: Fix call trace in setup_tx_descriptors

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    i40e: Fix calculating the number of queue pairs

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    i40e: Fix adding ADQ filter to TC0

Masahiro Yamada <masahiroy@kernel.org>
    clocksource: hyper-v: unexport __init-annotated hv_init_clocksource()

Scott Mayhew <smayhew@redhat.com>
    sunrpc: set cl_max_connect when cloning an rpc_clnt

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Avoid a live lock condition in pnfs_update_layout()

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Don't keep retrying if the server replied NFS4ERR_LAYOUTUNAVAILABLE

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8188eu: Fix warning of array overflow in ioctl_linux.c

Phillip Potter <phil@philpotter.co.uk>
    staging: r8188eu: fix rtw_alloc_hwxmits error detection for now

Duke Lee <krnhotwings@gmail.com>
    platform/x86/intel: hid: Add Surface Go to VGBS allow list

August Wikerfors <git@augustwikerfors.se>
    platform/x86: gigabyte-wmi: Add support for B450M DS3H-CF

Piotr Chmura <chmooreck@gmail.com>
    platform/x86: gigabyte-wmi: Add Z690M AORUS ELITE AX DDR4 support

George D Sworo <george.d.sworo@intel.com>
    platform/x86/intel: pmc: Support Intel Raptorlake P

David Arcari <darcari@redhat.com>
    platform/x86/intel: Fix pmt_crashlog array reference

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    gpio: dwapb: Don't print error on -EPROBE_DEFER

Jason A. Donenfeld <Jason@zx2c4.com>
    random: credit cpu and bootloader seeds by default

Yupeng Li <liyupeng@zbhlos.com>
    MIPS: Loongson-3: fix compile mips cpu_hwmon as module build error.

Linus Torvalds <torvalds@linux-foundation.org>
    netfs: gcc-12: temporarily disable '-Wattribute-warning' for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-12: disable '-Warray-bounds' universally for now

Linus Torvalds <torvalds@linux-foundation.org>
    mellanox: mlx5: avoid uninitialized variable warning with gcc-12

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-12: disable '-Wdangling-pointer' warning for now

Chen Lin <chen45464546@163.com>
    net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag

Wang Yufen <wangyufen@huawei.com>
    ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg

Wang Yufen <wangyufen@huawei.com>
    ipv6: Fix signed integer overflow in __ip6_append_data

Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
    nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred

chengkaitao <pilgrimtao@gmail.com>
    virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/realtek - Add HW8326 support

Chengguang Xu <cgxu519@mykernel.net>
    scsi: pmcraid: Fix missing resource cleanup in error case

Chengguang Xu <cgxu519@mykernel.net>
    scsi: ipr: Fix missing/incorrect resource cleanup in error case

Helge Deller <deller@gmx.de>
    scsi: mpt3sas: Fix out-of-bounds compiler warning

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Allow reduced polling rate for nvme_admin_async_event cmd completion

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix port stuck in bypassed state after LIP in PT2PT topology

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Resolve NULL ptr dereference after an ELS LOGO is aborted

Wentao Wang <wwentao@vmware.com>
    scsi: vmw_pvscsi: Expand vcpuHint to 16 bits

Marius Hoch <mail@mariushoch.de>
    Input: soc_button_array - also add Lenovo Yoga Tablet2 1051F to dmi_use_low_level_irq

Yong Zhi <yong.zhi@intel.com>
    ALSA: hda: MTL: add HD Audio PCI ID and HDMI codec vendor ID

Mark Brown <broonie@kernel.org>
    ASoC: wm_adsp: Fix event generation for wm_adsp_fw_put()

Mark Brown <broonie@kernel.org>
    ASoC: es8328: Fix event generation for deemphasis control

Adam Ford <aford173@gmail.com>
    ASoC: wm8962: Fix suspend while playing music

Matthew Wilcox (Oracle) <willy@infradead.org>
    quota: Prevent memory allocation recursion while holding dq_lock

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: libata-core: fix NULL pointer deref in ata_host_alloc_pinfo()

Lang Yu <Lang.Yu@amd.com>
    drm/amdkfd: add pinned BOs to kfd_bo_list

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l51: Correct minimum value for SX volume control

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l56: Correct typo in minimum level for SX volume controls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l52: Correct TLV for Bypass Volume

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs53l30: Correct number of volume levels on SX controls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs35l36: Update digital volume TLV

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l52: Fix TLV scales for mixer controls

xliu <xiang.liu@cirrus.com>
    ASoC: Intel: cirrus-common: fix incorrect channel mapping

Rob Clark <robdclark@chromium.org>
    dma-debug: make things less spammy under memory pressure

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Use mmget_not_zero in MMU notifier

Candice Li <candice.li@amd.com>
    drm/amdgpu: Resolve RAS GFX error count issue after cold boot on Arcturus

Sherry Wang <YAO.WANG1@amd.com>
    drm/amd/display: Read Golden Settings Table from VBIOS

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: qcom: lpass-platform: Update VMA access permissions in mmap callback

Hui Wang <hui.wang@canonical.com>
    ASoC: nau8822: Add operation for internal PLL off and on

He Ying <heying24@huawei.com>
    powerpc/kasan: Silence KASAN warnings in __get_wchan()

Jens Axboe <axboe@kernel.dk>
    io_uring: reinstate the inflight tracking

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Enable RTS-CTS on UART3

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3

Stylon Wang <stylon.wang@amd.com>
    Revert "drm/amd/display: Fix DCN3 B0 DP Alt Mapping"


-------------

Diffstat:

 .../ABI/testing/sysfs-driver-bd9571mwv-regulator   |   2 +-
 .../bindings/cpufreq/brcm,stb-avs-cpu-freq.txt     |   2 +-
 Documentation/filesystems/netfs_library.rst        |  37 +++---
 Makefile                                           |   8 +-
 .../dts/freescale/imx8mm-beacon-baseboard.dtsi     |   3 +
 .../dts/freescale/imx8mn-beacon-baseboard.dtsi     |   3 +
 arch/arm64/kernel/ftrace.c                         | 137 ++++++++++-----------
 arch/arm64/kvm/fpsimd.c                            |   1 +
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   4 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  19 ++-
 arch/arm64/kvm/vgic/vgic-mmio.h                    |   3 +
 arch/arm64/mm/cache.S                              |   2 -
 arch/powerpc/kernel/process.c                      |   4 +-
 arch/powerpc/mm/nohash/kaslr_booke.c               |   8 +-
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi  |   9 ++
 arch/s390/Kconfig                                  |   1 +
 arch/s390/Makefile                                 |  10 +-
 arch/x86/kernel/Makefile                           |   4 -
 arch/x86/kernel/ftrace_64.S                        |  11 +-
 block/blk-mq.c                                     |   2 +
 certs/blacklist_hashes.c                           |   2 +-
 crypto/Kconfig                                     |   1 +
 crypto/Makefile                                    |   2 +-
 drivers/ata/libata-core.c                          |   4 +-
 drivers/base/init.c                                |   2 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   6 +-
 drivers/char/Kconfig                               |  50 +++++---
 drivers/clk/imx/clk-imx8mp.c                       |   2 +-
 drivers/clocksource/hyperv_timer.c                 |   1 -
 drivers/comedi/drivers/vmk80xx.c                   |   2 +-
 drivers/gpio/gpio-dwapb.c                          |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  27 +++-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   3 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   8 +-
 .../amd/display/dc/dcn31/dcn31_dio_link_encoder.c  |   4 +-
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |   6 -
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c           |   2 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |  15 ++-
 drivers/hv/channel_mgmt.c                          |   1 +
 drivers/i2c/busses/i2c-designware-common.c         |   3 -
 drivers/i2c/busses/i2c-designware-platdrv.c        |  13 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   9 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |   3 +-
 drivers/input/misc/soc_button_array.c              |   4 +-
 drivers/irqchip/irq-apple-aic.c                    |   2 +
 drivers/irqchip/irq-gic-realview.c                 |   1 +
 drivers/irqchip/irq-gic-v3.c                       |   7 +-
 drivers/irqchip/irq-realtek-rtl.c                  |   2 +-
 drivers/isdn/mISDN/socket.c                        |   2 +-
 drivers/md/dm-core.h                               |  11 +-
 drivers/md/dm-log.c                                |   3 +-
 drivers/md/dm-rq.c                                 |   2 +-
 drivers/md/dm-table.c                              |  11 --
 drivers/md/dm.c                                    |  87 +++++--------
 drivers/md/dm.h                                    |   2 -
 drivers/md/raid5-ppl.c                             |   4 +-
 drivers/misc/atmel-ssc.c                           |   4 +-
 drivers/misc/mei/hbm.c                             |   3 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |   1 -
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  18 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 101 ++++++++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  25 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  49 +++++---
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |  31 +++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   5 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  53 ++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  21 +++-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h |   2 +-
 drivers/net/ppp/pppoe.c                            |   3 +-
 drivers/nfc/nfcmrvl/usb.c                          |  16 ++-
 drivers/nvme/host/core.c                           |   4 +-
 drivers/platform/mips/Kconfig                      |   2 +-
 drivers/platform/x86/gigabyte-wmi.c                |   2 +
 drivers/platform/x86/intel/hid.c                   |   6 +
 drivers/platform/x86/intel/pmc/core.c              |   1 +
 drivers/platform/x86/intel/pmt/crashlog.c          |   2 +-
 drivers/scsi/ipr.c                                 |   4 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  18 +--
 drivers/scsi/lpfc/lpfc_hw4.h                       |   3 +
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   3 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  11 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  23 ++--
 drivers/scsi/pmcraid.c                             |   2 +-
 drivers/scsi/vmw_pvscsi.h                          |   4 +-
 drivers/staging/r8188eu/core/rtw_xmit.c            |  20 +--
 drivers/staging/r8188eu/os_dep/ioctl_linux.c       |   2 +-
 drivers/tty/goldfish.c                             |   2 +-
 drivers/tty/n_gsm.c                                |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   2 +
 drivers/usb/cdns3/cdnsp-ring.c                     |  19 +--
 drivers/usb/dwc2/hcd.c                             |   2 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   1 +
 drivers/usb/dwc3/gadget.c                          |  26 ++--
 drivers/usb/gadget/function/f_fs.c                 |  40 +++---
 drivers/usb/gadget/function/u_ether.c              |  12 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   1 +
 drivers/usb/serial/io_ti.c                         |   2 +
 drivers/usb/serial/io_usbvend.h                    |   1 +
 drivers/usb/serial/option.c                        |   6 +
 drivers/virtio/virtio_mmio.c                       |   1 +
 drivers/virtio/virtio_pci_common.c                 |   3 +-
 fs/9p/cache.c                                      |   4 +-
 fs/9p/v9fs.c                                       |   2 +-
 fs/9p/v9fs.h                                       |  10 +-
 fs/9p/vfs_addr.c                                   |   2 +-
 fs/9p/vfs_inode.c                                  |   4 +-
 fs/afs/callback.c                                  |   2 +-
 fs/afs/dir.c                                       |  32 ++---
 fs/afs/dir_edit.c                                  |  10 +-
 fs/afs/dir_silly.c                                 |   4 +-
 fs/afs/dynroot.c                                   |   2 +-
 fs/afs/file.c                                      |   4 +-
 fs/afs/fs_operation.c                              |   6 +-
 fs/afs/inode.c                                     |  38 +++---
 fs/afs/internal.h                                  |  23 ++--
 fs/afs/super.c                                     |   6 +-
 fs/afs/write.c                                     |  21 ++--
 fs/attr.c                                          |  26 +++-
 fs/ceph/addr.c                                     |   4 +-
 fs/ceph/cache.c                                    |   4 +-
 fs/ceph/cache.h                                    |   2 +-
 fs/ceph/caps.c                                     | 104 ++++++++--------
 fs/ceph/file.c                                     |   2 +-
 fs/ceph/inode.c                                    |  10 +-
 fs/ceph/mds_client.c                               |   4 +-
 fs/ceph/snap.c                                     |   8 +-
 fs/ceph/super.c                                    |   2 +-
 fs/ceph/super.h                                    |  10 +-
 fs/ceph/xattr.c                                    |  14 +--
 fs/cifs/cifsfs.c                                   |   8 +-
 fs/cifs/cifsglob.h                                 |  12 +-
 fs/cifs/file.c                                     |   8 +-
 fs/cifs/fscache.c                                  |   8 +-
 fs/cifs/fscache.h                                  |   8 +-
 fs/cifs/inode.c                                    |   4 +-
 fs/cifs/misc.c                                     |   4 +-
 fs/cifs/smb2ops.c                                  |   8 +-
 fs/ext4/mballoc.c                                  |   9 ++
 fs/ext4/namei.c                                    |   3 +-
 fs/ext4/resize.c                                   |  10 ++
 fs/ext4/super.c                                    |  16 +--
 fs/io_uring.c                                      |  97 +++++++++++----
 fs/netfs/buffered_read.c                           |   6 +-
 fs/netfs/internal.h                                |   2 +-
 fs/netfs/objects.c                                 |   2 +-
 fs/nfs/callback_proc.c                             |   1 +
 fs/nfs/pnfs.c                                      |  21 +++-
 fs/nfs/pnfs.h                                      |   1 +
 fs/quota/dquot.c                                   |  10 ++
 include/linux/backing-dev.h                        |   2 +
 include/linux/netfs.h                              |  41 +++---
 include/linux/objtool.h                            |   6 +
 include/linux/skbuff.h                             |   3 +-
 include/net/ipv6.h                                 |   4 +-
 init/Kconfig                                       |   9 ++
 kernel/auditsc.c                                   |   2 +-
 kernel/cfi.c                                       |  22 +++-
 kernel/dma/debug.c                                 |   2 +-
 kernel/sched/core.c                                |  36 +++++-
 kernel/sched/sched.h                               |   5 +
 kernel/trace/bpf_trace.c                           |   4 +-
 lib/Kconfig                                        |   3 +
 lib/Makefile                                       |   1 +
 lib/crypto/Kconfig                                 |   1 +
 {crypto => lib}/memneq.c                           |   0
 mm/backing-dev.c                                   |  11 +-
 net/appletalk/ddp.c                                |   3 +-
 net/atm/common.c                                   |   2 +-
 net/ax25/af_ax25.c                                 |  34 ++++-
 net/bluetooth/af_bluetooth.c                       |   3 +-
 net/bluetooth/hci_sock.c                           |   3 +-
 net/caif/caif_socket.c                             |   2 +-
 net/can/bcm.c                                      |   5 +-
 net/can/isotp.c                                    |   4 +-
 net/can/j1939/socket.c                             |   2 +-
 net/can/raw.c                                      |   6 +-
 net/core/datagram.c                                |   5 +-
 net/ieee802154/socket.c                            |   6 +-
 net/ipv4/ping.c                                    |   3 +-
 net/ipv4/raw.c                                     |   3 +-
 net/ipv6/ip6_output.c                              |   6 +-
 net/ipv6/raw.c                                     |   3 +-
 net/iucv/af_iucv.c                                 |   3 +-
 net/key/af_key.c                                   |   2 +-
 net/l2tp/l2tp_ip.c                                 |   3 +-
 net/l2tp/l2tp_ip6.c                                |   8 +-
 net/l2tp/l2tp_ppp.c                                |   3 +-
 net/mctp/af_mctp.c                                 |   2 +-
 net/mctp/test/route-test.c                         |   8 +-
 net/netlink/af_netlink.c                           |   3 +-
 net/netrom/af_netrom.c                             |   3 +-
 net/nfc/llcp_sock.c                                |   3 +-
 net/nfc/rawsock.c                                  |   3 +-
 net/packet/af_packet.c                             |   2 +-
 net/phonet/datagram.c                              |   3 +-
 net/phonet/pep.c                                   |   6 +-
 net/qrtr/af_qrtr.c                                 |   3 +-
 net/rose/af_rose.c                                 |   3 +-
 net/sunrpc/clnt.c                                  |   1 +
 net/unix/af_unix.c                                 |   5 +-
 net/vmw_vsock/vmci_transport.c                     |   5 +-
 net/x25/af_x25.c                                   |   3 +-
 scripts/faddr2line                                 |  45 +++++--
 security/selinux/hooks.c                           |  11 +-
 sound/hda/hdac_device.c                            |   1 +
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |  14 +++
 sound/soc/codecs/cs35l36.c                         |   3 +-
 sound/soc/codecs/cs42l51.c                         |   2 +-
 sound/soc/codecs/cs42l52.c                         |   8 +-
 sound/soc/codecs/cs42l56.c                         |   4 +-
 sound/soc/codecs/cs53l30.c                         |  16 +--
 sound/soc/codecs/es8328.c                          |   5 +-
 sound/soc/codecs/nau8822.c                         |   4 +
 sound/soc/codecs/nau8822.h                         |   3 +
 sound/soc/codecs/wm8962.c                          |   1 +
 sound/soc/codecs/wm_adsp.c                         |   2 +-
 sound/soc/intel/boards/sof_cirrus_common.c         |  40 +++++-
 sound/soc/qcom/lpass-platform.c                    |   2 +-
 tools/include/linux/objtool.h                      |   6 +
 233 files changed, 1364 insertions(+), 902 deletions(-)


