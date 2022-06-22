Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5662C554A30
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiFVMin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 08:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbiFVMim (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 08:38:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A15A393FA;
        Wed, 22 Jun 2022 05:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF17B61991;
        Wed, 22 Jun 2022 12:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE07EC341C5;
        Wed, 22 Jun 2022 12:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655901465;
        bh=stDqD6GXqfYkFUdMHCpyor8oCOBPobc63zMfsbfzQaU=;
        h=From:To:Cc:Subject:Date:From;
        b=0YuN04KAx0d/7T/kESsMvwJTL0U6whQU5+Tmg3svydwWCHnL0y6SOz1Xln0A/bYlI
         5+ImVoMIHPnFJgBDPsjXz5xR/03CNG0EwwcuRQP971dn/v0r/b1fb2XStftMva+zXN
         GyUZXIu6okg5AcfEd6M5fqrZqShAM9nRvFBJTNCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.124
Date:   Wed, 22 Jun 2022 14:37:30 +0200
Message-Id: <1655901451109119@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

I'm announcing the release of the 5.10.124 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi |    3 
 arch/arm64/kernel/ftrace.c                                 |  137 +++++-----
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                         |    4 
 arch/arm64/kvm/vgic/vgic-mmio.c                            |   19 +
 arch/arm64/kvm/vgic/vgic-mmio.h                            |    3 
 arch/powerpc/kernel/process.c                              |    4 
 arch/powerpc/mm/nohash/kaslr_booke.c                       |    8 
 arch/x86/kvm/svm/nested.c                                  |    4 
 arch/x86/kvm/svm/sev.c                                     |    4 
 arch/x86/kvm/vmx/vmx.c                                     |    2 
 block/blk-mq.c                                             |    2 
 certs/blacklist_hashes.c                                   |    2 
 crypto/Kconfig                                             |    1 
 crypto/Makefile                                            |    2 
 crypto/memneq.c                                            |  168 -------------
 drivers/ata/libata-core.c                                  |    4 
 drivers/char/Kconfig                                       |   54 ++--
 drivers/clk/imx/clk-imx8mp.c                               |    2 
 drivers/clocksource/hyperv_timer.c                         |    1 
 drivers/gpio/gpio-dwapb.c                                  |    7 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c          |    8 
 drivers/gpu/drm/i915/i915_sysfs.c                          |   15 -
 drivers/hv/channel_mgmt.c                                  |    1 
 drivers/i2c/busses/i2c-designware-common.c                 |    3 
 drivers/i2c/busses/i2c-designware-platdrv.c                |   13 -
 drivers/i2c/busses/i2c-npcm7xx.c                           |    3 
 drivers/input/misc/soc_button_array.c                      |    4 
 drivers/irqchip/irq-gic-realview.c                         |    1 
 drivers/irqchip/irq-gic-v3.c                               |    7 
 drivers/md/dm-log.c                                        |    3 
 drivers/misc/atmel-ssc.c                                   |    4 
 drivers/misc/mei/hw-me-regs.h                              |    2 
 drivers/misc/mei/pci-me.c                                  |    2 
 drivers/net/ethernet/broadcom/bgmac-bcma.c                 |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c             |   25 +
 drivers/net/ethernet/intel/i40e/i40e_main.c                |    5 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c         |    2 
 drivers/net/ethernet/intel/igc/igc_main.c                  |    5 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                |   21 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c              |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h         |    2 
 drivers/nfc/nfcmrvl/usb.c                                  |   16 +
 drivers/nvme/host/core.c                                   |   44 +--
 drivers/nvme/host/multipath.c                              |    8 
 drivers/pci/pci.h                                          |    3 
 drivers/platform/mips/Kconfig                              |    2 
 drivers/scsi/ipr.c                                         |    4 
 drivers/scsi/lpfc/lpfc_hw4.h                               |    3 
 drivers/scsi/lpfc/lpfc_nportdisc.c                         |    3 
 drivers/scsi/lpfc/lpfc_nvme.c                              |   11 
 drivers/scsi/pmcraid.c                                     |    2 
 drivers/scsi/vmw_pvscsi.h                                  |    4 
 drivers/staging/comedi/drivers/vmk80xx.c                   |    2 
 drivers/tty/goldfish.c                                     |    2 
 drivers/tty/serial/8250/8250_port.c                        |    2 
 drivers/usb/dwc2/hcd.c                                     |    2 
 drivers/usb/gadget/udc/lpc32xx_udc.c                       |    1 
 drivers/usb/serial/io_ti.c                                 |    2 
 drivers/usb/serial/io_usbvend.h                            |    1 
 drivers/usb/serial/option.c                                |    6 
 drivers/virtio/virtio_mmio.c                               |    1 
 drivers/virtio/virtio_pci_common.c                         |    3 
 fs/9p/vfs_inode_dotl.c                                     |   10 
 fs/ext4/mballoc.c                                          |    9 
 fs/ext4/namei.c                                            |    3 
 fs/ext4/resize.c                                           |   10 
 fs/nfs/callback_proc.c                                     |    1 
 fs/nfs/pnfs.c                                              |   21 +
 fs/nfs/pnfs.h                                              |    1 
 fs/nfsd/filecache.c                                        |    1 
 fs/nfsd/filecache.h                                        |    1 
 fs/nfsd/nfs4proc.c                                         |    7 
 fs/nfsd/vfs.c                                              |   40 +--
 fs/quota/dquot.c                                           |   10 
 include/linux/pci.h                                        |    7 
 kernel/bpf/stackmap.c                                      |    3 
 kernel/dma/debug.c                                         |    2 
 kernel/dma/direct.c                                        |   16 -
 lib/Kconfig                                                |    3 
 lib/Makefile                                               |    1 
 lib/crypto/Kconfig                                         |    1 
 lib/memneq.c                                               |  168 +++++++++++++
 net/ax25/af_ax25.c                                         |   34 ++
 net/l2tp/l2tp_ip6.c                                        |    5 
 net/openvswitch/actions.c                                  |    6 
 net/openvswitch/conntrack.c                                |    3 
 net/sched/act_police.c                                     |   16 +
 scripts/faddr2line                                         |   45 ++-
 sound/hda/hdac_device.c                                    |    1 
 sound/pci/hda/patch_realtek.c                              |   15 +
 sound/soc/codecs/cs35l36.c                                 |    3 
 sound/soc/codecs/cs42l51.c                                 |    2 
 sound/soc/codecs/cs42l52.c                                 |    8 
 sound/soc/codecs/cs42l56.c                                 |    4 
 sound/soc/codecs/cs53l30.c                                 |   16 -
 sound/soc/codecs/es8328.c                                  |    5 
 sound/soc/codecs/nau8822.c                                 |    4 
 sound/soc/codecs/nau8822.h                                 |    3 
 sound/soc/codecs/wm8962.c                                  |    1 
 sound/soc/codecs/wm_adsp.c                                 |    2 
 tools/testing/selftests/net/forwarding/tc_police.sh        |   52 ++++
 102 files changed, 760 insertions(+), 464 deletions(-)

Adam Ford (2):
      arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3
      ASoC: wm8962: Fix suspend while playing music

Al Viro (1):
      9p: missing chunk of "fs/9p: Don't update file type when updating file attributes"

Alan Previn (1):
      drm/i915/reset: Fix error_state_read ptr + offset use

Aleksandr Loktionov (1):
      i40e: Fix call trace in setup_tx_descriptors

Alexander Usyskin (1):
      mei: me: add raptor lake point S DID

Andy Chi (1):
      ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP machine

Ashish Kalra (1):
      KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel data leak

Baokun Li (1):
      ext4: fix bug_on ext4_mb_use_inode_pa

Bart Van Assche (1):
      block: Fix handling of offline queues in blk_mq_alloc_request_hctx()

Charles Keepax (6):
      ASoC: cs42l52: Fix TLV scales for mixer controls
      ASoC: cs35l36: Update digital volume TLV
      ASoC: cs53l30: Correct number of volume levels on SX controls
      ASoC: cs42l52: Correct TLV for Bypass Volume
      ASoC: cs42l56: Correct typo in minimum level for SX volume controls
      ASoC: cs42l51: Correct minimum value for SX volume control

Chen Lin (1):
      net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag

Chengguang Xu (2):
      scsi: ipr: Fix missing/incorrect resource cleanup in error case
      scsi: pmcraid: Fix missing resource cleanup in error case

Christophe JAILLET (1):
      net: bgmac: Fix an erroneous kfree() in bgmac_remove()

Daniel Wagner (1):
      nvme: use sysfs_emit instead of sprintf

Davide Caratti (1):
      net/sched: act_police: more accurate MTU policing

Ding Xiang (1):
      ext4: make variable "count" signed

Duoming Zhou (1):
      net: ax25: Fix deadlock caused by skb_recv_datagram in ax25_recvmsg

Greg Kroah-Hartman (1):
      Linux 5.10.124

Grzegorz Szczurek (2):
      i40e: Fix adding ADQ filter to TC0
      i40e: Fix calculating the number of queue pairs

He Ying (1):
      powerpc/kasan: Silence KASAN warnings in __get_wchan()

Hui Wang (1):
      ASoC: nau8822: Add operation for internal PLL off and on

Ian Abbott (1):
      comedi: vmk80xx: fix expression for tx buffer size

Ilpo Järvinen (1):
      serial: 8250: Store to lsr_save_flags after lsr read

Ilya Maximets (1):
      net: openvswitch: fix misuse of the cached connection on tuple changes

James Smart (2):
      scsi: lpfc: Fix port stuck in bypassed state after LIP in PT2PT topology
      scsi: lpfc: Allow reduced polling rate for nvme_admin_async_event cmd completion

Jason A. Donenfeld (2):
      random: credit cpu and bootloader seeds by default
      crypto: memneq - move into lib/

Jiasheng Jiang (1):
      i2c: npcm7xx: Add check for platform_driver_register

Josh Poimboeuf (1):
      faddr2line: Fix overlapping text section failures, the sequel

Linus Torvalds (1):
      mellanox: mlx5: avoid uninitialized variable warning with gcc-12

Marc Zyngier (1):
      KVM: arm64: Don't read a HW interrupt pending state in user context

Marius Hoch (1):
      Input: soc_button_array - also add Lenovo Yoga Tablet2 1051F to dmi_use_low_level_irq

Mark Brown (2):
      ASoC: es8328: Fix event generation for deemphasis control
      ASoC: wm_adsp: Fix event generation for wm_adsp_fw_put()

Mark Rutland (2):
      arm64: ftrace: fix branch range checks
      arm64: ftrace: consistently handle PLTs.

Masahiro Yamada (3):
      clocksource: hyper-v: unexport __init-annotated hv_init_clocksource()
      certs/blacklist_hashes.c: fix const confusion in certs blacklist
      powerpc/book3e: get rid of #include <generated/compile.h>

Matthew Wilcox (Oracle) (1):
      quota: Prevent memory allocation recursion while holding dq_lock

Miaoqian Lin (6):
      misc: atmel-ssc: Fix IRQ check in ssc_probe
      irqchip/gic/realview: Fix refcount leak in realview_gic_of_init
      irqchip/gic-v3: Fix error handling in gic_populate_ppi_partitions
      irqchip/gic-v3: Fix refcount leak in gic_populate_ppi_partitions
      usb: dwc2: Fix memory leak in dwc2_hcd_init
      usb: gadget: lpc32xx_udc: Fix refcount leak in lpc32xx_udc_probe

Mikulas Patocka (1):
      dm mirror log: round up region bitmap size to BITS_PER_LONG

Murilo Opsfelder Araujo (1):
      virtio-pci: Remove wrong address verification in vp_del_vqs()

Peng Fan (1):
      clk: imx8mp: fix usb_root_clk parent

Petr Machata (1):
      mlxsw: spectrum_cnt: Reorder counter pools

Rob Clark (1):
      dma-debug: make things less spammy under memory pressure

Robert Eckelmann (1):
      USB: serial: io_ti: add Agilent E5805A support

Robin Murphy (1):
      dma-direct: don't over-decrypt memory

Roman Li (1):
      drm/amd/display: Cap OLED brightness per max frame-average luminance

Saurabh Sengar (1):
      Drivers: hv: vmbus: Release cpu lock in error case

Sean Christopherson (1):
      KVM: x86: Account a variety of miscellaneous allocations

Serge Semin (2):
      gpio: dwapb: Don't print error on -EPROBE_DEFER
      i2c: designware: Use standard optional ref clock implementation

Sergey Shtylyov (1):
      ata: libata-core: fix NULL pointer deref in ata_host_alloc_pinfo()

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV31 with new baseline

Thomas Weißschuh (1):
      nvme: add device name to warning in uuid_show()

Trond Myklebust (3):
      nfsd: Replace use of rwsem with errseq_t
      pNFS: Don't keep retrying if the server replied NFS4ERR_LAYOUTUNAVAILABLE
      pNFS: Avoid a live lock condition in pnfs_update_layout()

Vincent Whitchurch (1):
      tty: goldfish: Fix free_irq() on remove

Vinicius Costa Gomes (2):
      Revert "PCI: Make pci_enable_ptm() private"
      igc: Enable PCIe PTM

Wang Yufen (1):
      ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg

Wentao Wang (1):
      scsi: vmw_pvscsi: Expand vcpuHint to 16 bits

Xiaohui Zhang (1):
      nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred

Yuntao Wang (1):
      bpf: Fix incorrect memory charge cost calculation in stack_map_alloc()

Yupeng Li (1):
      MIPS: Loongson-3: fix compile mips cpu_hwmon as module build error.

Zhang Yi (1):
      ext4: add reserved GDT blocks check

chengkaitao (1):
      virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed

huangwenhui (1):
      ALSA: hda/realtek - Add HW8326 support

