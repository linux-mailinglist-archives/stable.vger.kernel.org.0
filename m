Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0527C551BA9
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245157AbiFTNK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343586AbiFTNJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361801A382;
        Mon, 20 Jun 2022 06:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 961ABB811C4;
        Mon, 20 Jun 2022 13:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5D5C341C5;
        Mon, 20 Jun 2022 13:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730081;
        bh=zVnRGXyHjVsrZiX638mfE40/6ZbBht8or0Bnmu3+frA=;
        h=From:To:Cc:Subject:Date:From;
        b=ZKpwfl9SPDciWmQJJs65n+/RF+O8aS3jz0oKxfBIED0fkqQjW63VeCBJfLHvgIzx5
         P+mwa3hGZz/KhuRfucmVuDX0UGPWahPGNPAqu7dtZdJbviWWrrti/2bNX8DMtDO9ht
         ICh5gSoLQjrXOSpel1Zsqxmq/8IKXV7FC1owcYfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/84] 5.10.124-rc1 review
Date:   Mon, 20 Jun 2022 14:50:23 +0200
Message-Id: <20220620124720.882450983@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.124-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.124-rc1
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

This is the start of the stable review cycle for the 5.10.124 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.124-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.124-rc1

Peng Fan <peng.fan@nxp.com>
    clk: imx8mp: fix usb_root_clk parent

Masahiro Yamada <masahiroy@kernel.org>
    powerpc/book3e: get rid of #include <generated/compile.h>

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Enable PCIe PTM

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    Revert "PCI: Make pci_enable_ptm() private"

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix misuse of the cached connection on tuple changes

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_police: more accurate MTU policing

Robin Murphy <robin.murphy@arm.com>
    dma-direct: don't over-decrypt memory

Murilo Opsfelder Araujo <muriloo@linux.ibm.com>
    virtio-pci: Remove wrong address verification in vp_del_vqs()

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP machine

Ashish Kalra <ashish.kalra@amd.com>
    KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel data leak

Sean Christopherson <seanjc@google.com>
    KVM: x86: Account a variety of miscellaneous allocations

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't read a HW interrupt pending state in user context

Zhang Yi <yi.zhang@huawei.com>
    ext4: add reserved GDT blocks check

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ext4: make variable "count" signed

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on ext4_mb_use_inode_pa

Roman Li <roman.li@amd.com>
    drm/amd/display: Cap OLED brightness per max frame-average luminance

Mikulas Patocka <mpatocka@redhat.com>
    dm mirror log: round up region bitmap size to BITS_PER_LONG

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Store to lsr_save_flags after lsr read

Miaoqian Lin <linmq006@gmail.com>
    usb: gadget: lpc32xx_udc: Fix refcount leak in lpc32xx_udc_probe

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

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    i2c: designware: Use standard optional ref clock implementation

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

Daniel Wagner <dwagner@suse.de>
    nvme: use sysfs_emit instead of sprintf

Alan Previn <alan.previn.teres.alexis@intel.com>
    drm/i915/reset: Fix error_state_read ptr + offset use

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

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Avoid a live lock condition in pnfs_update_layout()

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS: Don't keep retrying if the server replied NFS4ERR_LAYOUTUNAVAILABLE

Jason A. Donenfeld <Jason@zx2c4.com>
    random: credit cpu and bootloader seeds by default

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    gpio: dwapb: Don't print error on -EPROBE_DEFER

Yupeng Li <liyupeng@zbhlos.com>
    MIPS: Loongson-3: fix compile mips cpu_hwmon as module build error.

Linus Torvalds <torvalds@linux-foundation.org>
    netfs: gcc-12: temporarily disable '-Wattribute-warning' for now

Linus Torvalds <torvalds@linux-foundation.org>
    mellanox: mlx5: avoid uninitialized variable warning with gcc-12

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

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Allow reduced polling rate for nvme_admin_async_event cmd completion

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix port stuck in bypassed state after LIP in PT2PT topology

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

Hui Wang <hui.wang@canonical.com>
    ASoC: nau8822: Add operation for internal PLL off and on

He Ying <heying24@huawei.com>
    powerpc/kasan: Silence KASAN warnings in __get_wchan()

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3

Yuntao Wang <ytcoode@gmail.com>
    bpf: Fix incorrect memory charge cost calculation in stack_map_alloc()

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Replace use of rwsem with errseq_t

Al Viro <viro@zeniv.linux.org.uk>
    9p: missing chunk of "fs/9p: Don't update file type when updating file attributes"


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../dts/freescale/imx8mm-beacon-baseboard.dtsi     |   3 +
 arch/arm64/kernel/ftrace.c                         | 137 ++++++++++-----------
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   4 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  19 ++-
 arch/arm64/kvm/vgic/vgic-mmio.h                    |   3 +
 arch/powerpc/kernel/process.c                      |   4 +-
 arch/powerpc/mm/nohash/kaslr_booke.c               |   8 +-
 arch/x86/kvm/svm/nested.c                          |   4 +-
 arch/x86/kvm/svm/sev.c                             |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 block/blk-mq.c                                     |   2 +
 certs/blacklist_hashes.c                           |   2 +-
 crypto/Kconfig                                     |   1 +
 crypto/Makefile                                    |   2 +-
 drivers/ata/libata-core.c                          |   4 +-
 drivers/char/Kconfig                               |  54 ++++----
 drivers/clk/imx/clk-imx8mp.c                       |   2 +-
 drivers/clocksource/hyperv_timer.c                 |   1 -
 drivers/gpio/gpio-dwapb.c                          |   7 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   8 +-
 drivers/gpu/drm/i915/i915_sysfs.c                  |  15 ++-
 drivers/hv/channel_mgmt.c                          |   1 +
 drivers/i2c/busses/i2c-designware-common.c         |   3 -
 drivers/i2c/busses/i2c-designware-platdrv.c        |  13 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |   3 +-
 drivers/input/misc/soc_button_array.c              |   4 +-
 drivers/irqchip/irq-gic-realview.c                 |   1 +
 drivers/irqchip/irq-gic-v3.c                       |   7 +-
 drivers/md/dm-log.c                                |   3 +-
 drivers/misc/atmel-ssc.c                           |   4 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |   1 -
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  25 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   5 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  21 +++-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h |   2 +-
 drivers/nfc/nfcmrvl/usb.c                          |  16 ++-
 drivers/nvme/host/core.c                           |  44 +++----
 drivers/nvme/host/multipath.c                      |   8 +-
 drivers/pci/pci.h                                  |   3 -
 drivers/platform/mips/Kconfig                      |   2 +-
 drivers/scsi/ipr.c                                 |   4 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   3 +
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   3 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  11 +-
 drivers/scsi/pmcraid.c                             |   2 +-
 drivers/scsi/vmw_pvscsi.h                          |   4 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |   2 +-
 drivers/tty/goldfish.c                             |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   2 +
 drivers/usb/dwc2/hcd.c                             |   2 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   1 +
 drivers/usb/serial/io_ti.c                         |   2 +
 drivers/usb/serial/io_usbvend.h                    |   1 +
 drivers/usb/serial/option.c                        |   6 +
 drivers/virtio/virtio_mmio.c                       |   1 +
 drivers/virtio/virtio_pci_common.c                 |   3 +-
 fs/9p/vfs_inode_dotl.c                             |  10 +-
 fs/afs/inode.c                                     |   3 +
 fs/ceph/inode.c                                    |   3 +
 fs/ext4/mballoc.c                                  |   9 ++
 fs/ext4/namei.c                                    |   3 +-
 fs/ext4/resize.c                                   |  10 ++
 fs/nfs/callback_proc.c                             |   1 +
 fs/nfs/pnfs.c                                      |  21 +++-
 fs/nfs/pnfs.h                                      |   1 +
 fs/nfsd/filecache.c                                |   1 -
 fs/nfsd/filecache.h                                |   1 -
 fs/nfsd/nfs4proc.c                                 |   7 +-
 fs/nfsd/vfs.c                                      |  40 +++---
 fs/quota/dquot.c                                   |  10 ++
 include/linux/pci.h                                |   7 ++
 kernel/bpf/stackmap.c                              |   3 +-
 kernel/dma/debug.c                                 |   2 +-
 kernel/dma/direct.c                                |  16 +--
 lib/Kconfig                                        |   3 +
 lib/Makefile                                       |   1 +
 lib/crypto/Kconfig                                 |   1 +
 {crypto => lib}/memneq.c                           |   0
 net/ax25/af_ax25.c                                 |  34 ++++-
 net/l2tp/l2tp_ip6.c                                |   5 +-
 net/openvswitch/actions.c                          |   6 +
 net/openvswitch/conntrack.c                        |   3 +-
 net/sched/act_police.c                             |  16 ++-
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
 .../testing/selftests/net/forwarding/tc_police.sh  |  52 ++++++++
 103 files changed, 599 insertions(+), 297 deletions(-)


