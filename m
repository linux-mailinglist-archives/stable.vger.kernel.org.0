Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4BD551B6C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345548AbiFTNjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347094AbiFTNhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:37:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1E12872C;
        Mon, 20 Jun 2022 06:14:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 056E16154E;
        Mon, 20 Jun 2022 13:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6088C3411B;
        Mon, 20 Jun 2022 13:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730395;
        bh=3PmEe733b5iYOuewY3oJxv5K3qq7n7lGxbUsPEAKLFw=;
        h=From:To:Cc:Subject:Date:From;
        b=nsgrH1ZXzq8suOY239PV9Okrze69H5TkneTBoCfyj3UYHljFAoKV32BrxRvBxncy1
         C29qXjJ5vOmPADcjufEDI0U0ru1prRsvgSHhzXtBur6QtRysAueBtLum3isosPceEG
         kqeNKUyXxE7ZEmYeZqMz6FViTuboDlutw+Tzmxpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/106] 5.15.49-rc1 review
Date:   Mon, 20 Jun 2022 14:50:19 +0200
Message-Id: <20220620124724.380838401@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.49-rc1
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

This is the start of the stable review cycle for the 5.15.49 release.
There are 106 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.49-rc1

Peng Fan <peng.fan@nxp.com>
    clk: imx8mp: fix usb_root_clk parent

Masahiro Yamada <masahiroy@kernel.org>
    powerpc/book3e: get rid of #include <generated/compile.h>

Murilo Opsfelder Araujo <muriloo@linux.ibm.com>
    virtio-pci: Remove wrong address verification in vp_del_vqs()

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP machine

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't read a HW interrupt pending state in user context

Zhang Yi <yi.zhang@huawei.com>
    ext4: add reserved GDT blocks check

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ext4: make variable "count" signed

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on ext4_mb_use_inode_pa

Ye Bin <yebin10@huawei.com>
    ext4: fix super block checksum incorrect after mount

Sami Tolvanen <samitolvanen@google.com>
    cfi: Fix __cfi_slowpath_diag RCU usage with cpuidle

Roman Li <roman.li@amd.com>
    drm/amd/display: Cap OLED brightness per max frame-average luminance

Mikulas Patocka <mpatocka@redhat.com>
    dm mirror log: round up region bitmap size to BITS_PER_LONG

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

Jing Leng <jleng@ambarella.com>
    usb: cdnsp: Fixed setting last_trb incorrectly

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc2: Fix memory leak in dwc2_hcd_init

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
    irqchip/gic/realview: Fix refcount leak in realview_gic_of_init

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    i2c: npcm7xx: Add check for platform_driver_register

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: bgmac: Fix an erroneous kfree() in bgmac_remove()

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum_cnt: Reorder counter pools

Thomas Weißschuh <linux@weissschuh.net>
    nvme: add device name to warning in uuid_show()

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix tm port shapping of fibre port is incorrect after driver initialization

Jian Shen <shenjian15@huawei.com>
    net: hns3: don't push link state to VF if unalive

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: set port base vlan tbl_sta to false before removing old vlan

Jian Shen <shenjian15@huawei.com>
    net: hns3: split function hclge_update_port_base_vlan_cfg()

Alan Previn <alan.previn.teres.alexis@intel.com>
    drm/i915/reset: Fix error_state_read ptr + offset use

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix races with buffer table unregister

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix races with file table unregister

Miaoqian Lin <linmq006@gmail.com>
    misc: atmel-ssc: Fix IRQ check in ssc_probe

Vincent Whitchurch <vincent.whitchurch@axis.com>
    tty: goldfish: Fix free_irq() on remove

Saurabh Sengar <ssengar@linux.microsoft.com>
    Drivers: hv: vmbus: Release cpu lock in error case

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

Gustavo A. R. Silva <gustavoars@kernel.org>
    staging: r8188eu: Use zeroing allocator in wpa_set_encryption()

Phillip Potter <phil@philpotter.co.uk>
    staging: r8188eu: fix rtw_alloc_hwxmits error detection for now

Duke Lee <krnhotwings@gmail.com>
    platform/x86/intel: hid: Add Surface Go to VGBS allow list

August Wikerfors <git@augustwikerfors.se>
    platform/x86: gigabyte-wmi: Add support for B450M DS3H-CF

Piotr Chmura <chmooreck@gmail.com>
    platform/x86: gigabyte-wmi: Add Z690M AORUS ELITE AX DDR4 support

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    gpio: dwapb: Don't print error on -EPROBE_DEFER

Jason A. Donenfeld <Jason@zx2c4.com>
    random: credit cpu and bootloader seeds by default

Yupeng Li <liyupeng@zbhlos.com>
    MIPS: Loongson-3: fix compile mips cpu_hwmon as module build error.

Linus Torvalds <torvalds@linux-foundation.org>
    netfs: gcc-12: temporarily disable '-Wattribute-warning' for now

Linus Torvalds <torvalds@linux-foundation.org>
    mellanox: mlx5: avoid uninitialized variable warning with gcc-12

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-12: disable '-Wdangling-pointer' warning for now

Chen Lin <chen45464546@163.com>
    net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag

Wang Yufen <wangyufen@huawei.com>
    ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg

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

Rob Clark <robdclark@chromium.org>
    dma-debug: make things less spammy under memory pressure

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Use mmget_not_zero in MMU notifier

Sherry Wang <YAO.WANG1@amd.com>
    drm/amd/display: Read Golden Settings Table from VBIOS

Hui Wang <hui.wang@canonical.com>
    ASoC: nau8822: Add operation for internal PLL off and on

He Ying <heying24@huawei.com>
    powerpc/kasan: Silence KASAN warnings in __get_wchan()

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Enable RTS-CTS on UART3

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Replace use of rwsem with errseq_t

Stylon Wang <stylon.wang@amd.com>
    Revert "drm/amd/display: Fix DCN3 B0 DP Alt Mapping"


-------------

Diffstat:

 Makefile                                           |   7 +-
 .../dts/freescale/imx8mm-beacon-baseboard.dtsi     |   3 +
 .../dts/freescale/imx8mn-beacon-baseboard.dtsi     |   3 +
 arch/arm64/kernel/ftrace.c                         | 137 ++++++++++-----------
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   4 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  19 ++-
 arch/arm64/kvm/vgic/vgic-mmio.h                    |   3 +
 arch/powerpc/kernel/process.c                      |   4 +-
 arch/powerpc/mm/nohash/kaslr_booke.c               |   8 +-
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
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   3 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   8 +-
 .../amd/display/dc/dcn31/dcn31_dio_link_encoder.c  |   4 +-
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |   6 -
 drivers/gpu/drm/i915/i915_sysfs.c                  |  15 ++-
 drivers/hv/channel_mgmt.c                          |   1 +
 drivers/i2c/busses/i2c-designware-common.c         |   3 -
 drivers/i2c/busses/i2c-designware-platdrv.c        |  13 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |   3 +-
 drivers/input/misc/soc_button_array.c              |   4 +-
 drivers/irqchip/irq-gic-realview.c                 |   1 +
 drivers/irqchip/irq-gic-v3.c                       |   7 +-
 drivers/irqchip/irq-realtek-rtl.c                  |   2 +-
 drivers/md/dm-log.c                                |   3 +-
 drivers/misc/atmel-ssc.c                           |   4 +-
 drivers/misc/mei/hbm.c                             |   3 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |   1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  87 +++++++------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  25 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  21 +++-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h |   2 +-
 drivers/nfc/nfcmrvl/usb.c                          |  16 ++-
 drivers/nvme/host/core.c                           |   4 +-
 drivers/platform/mips/Kconfig                      |   2 +-
 drivers/platform/x86/gigabyte-wmi.c                |   2 +
 drivers/platform/x86/intel/hid.c                   |   6 +
 drivers/scsi/ipr.c                                 |   4 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  18 +--
 drivers/scsi/lpfc/lpfc_hw4.h                       |   3 +
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   3 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  11 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  23 ++--
 drivers/scsi/pmcraid.c                             |   2 +-
 drivers/scsi/vmw_pvscsi.h                          |   4 +-
 drivers/staging/r8188eu/core/rtw_xmit.c            |  20 +--
 drivers/staging/r8188eu/os_dep/ioctl_linux.c       |   5 +-
 drivers/tty/goldfish.c                             |   2 +-
 drivers/tty/n_gsm.c                                |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   2 +
 drivers/usb/cdns3/cdnsp-ring.c                     |  19 +--
 drivers/usb/dwc2/hcd.c                             |   2 +-
 drivers/usb/gadget/function/f_fs.c                 |  40 +++---
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   1 +
 drivers/usb/serial/io_ti.c                         |   2 +
 drivers/usb/serial/io_usbvend.h                    |   1 +
 drivers/usb/serial/option.c                        |   6 +
 drivers/virtio/virtio_mmio.c                       |   1 +
 drivers/virtio/virtio_pci_common.c                 |   3 +-
 fs/afs/inode.c                                     |   3 +
 fs/ceph/inode.c                                    |   3 +
 fs/ext4/mballoc.c                                  |   9 ++
 fs/ext4/namei.c                                    |   3 +-
 fs/ext4/resize.c                                   |  10 ++
 fs/ext4/super.c                                    |  16 +--
 fs/io_uring.c                                      |  15 +++
 fs/nfs/callback_proc.c                             |   1 +
 fs/nfs/pnfs.c                                      |  21 +++-
 fs/nfs/pnfs.h                                      |   1 +
 fs/nfsd/filecache.c                                |   1 -
 fs/nfsd/filecache.h                                |   1 -
 fs/nfsd/nfs4proc.c                                 |  16 +--
 fs/nfsd/vfs.c                                      |  40 +++---
 fs/quota/dquot.c                                   |  10 ++
 include/linux/backing-dev.h                        |   2 +
 kernel/cfi.c                                       |  22 +++-
 kernel/dma/debug.c                                 |   2 +-
 kernel/sched/core.c                                |  36 +++++-
 kernel/sched/sched.h                               |   5 +
 lib/Kconfig                                        |   3 +
 lib/Makefile                                       |   1 +
 lib/crypto/Kconfig                                 |   1 +
 {crypto => lib}/memneq.c                           |   0
 mm/backing-dev.c                                   |  11 +-
 net/ax25/af_ax25.c                                 |  34 ++++-
 net/l2tp/l2tp_ip6.c                                |   5 +-
 net/sunrpc/clnt.c                                  |   1 +
 scripts/faddr2line                                 |  45 +++++--
 sound/hda/hdac_device.c                            |   1 +
 sound/pci/hda/patch_realtek.c                      |  15 +++
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
 118 files changed, 707 insertions(+), 393 deletions(-)


