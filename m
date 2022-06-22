Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135EA554A35
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346969AbiFVMis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 08:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349544AbiFVMin (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 08:38:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BB910F;
        Wed, 22 Jun 2022 05:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AABD4B81E84;
        Wed, 22 Jun 2022 12:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF9FC3411B;
        Wed, 22 Jun 2022 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655901468;
        bh=UTOPK2M5r4gZRUtABxrNu52mqXDlXGbFMKllZQiANRw=;
        h=From:To:Cc:Subject:Date:From;
        b=0qEWLSp/AKui68a+/WOkBV5hxX9UeiIYg8guaFeusFtTiHcVRR35NFIY061ji3+pQ
         +61QOXLOfoXPY7GrW2sm3Ta2iTXPBnCKJIYP9hTd5DomxCkMU3KbEXvsPgyhfRE5yl
         2ntCptPKTgmyevH6b8u3CYctsU8yqPvZ0GmAtgOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.6
Date:   Wed, 22 Jun 2022 14:37:36 +0200
Message-Id: <1655901456161120@kroah.com>
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

I'm announcing the release of the 5.18.6 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator          |    2 
 Documentation/devicetree/bindings/cpufreq/brcm,stb-avs-cpu-freq.txt |    2 
 Documentation/filesystems/netfs_library.rst                         |   37 +-
 Makefile                                                            |    6 
 arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi          |    3 
 arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi          |    3 
 arch/arm64/kernel/ftrace.c                                          |  137 +++----
 arch/arm64/kvm/fpsimd.c                                             |    1 
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                                  |    4 
 arch/arm64/kvm/vgic/vgic-mmio.c                                     |   19 -
 arch/arm64/kvm/vgic/vgic-mmio.h                                     |    3 
 arch/arm64/mm/cache.S                                               |    2 
 arch/powerpc/kernel/process.c                                       |    4 
 arch/powerpc/mm/nohash/kaslr_booke.c                                |    8 
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi                   |    9 
 arch/s390/Kconfig                                                   |    1 
 arch/s390/Makefile                                                  |   10 
 arch/x86/kernel/Makefile                                            |    4 
 arch/x86/kernel/ftrace_64.S                                         |   11 
 block/blk-mq.c                                                      |    2 
 certs/blacklist_hashes.c                                            |    2 
 crypto/Kconfig                                                      |    1 
 crypto/Makefile                                                     |    2 
 crypto/memneq.c                                                     |  176 ----------
 drivers/ata/libata-core.c                                           |    4 
 drivers/base/init.c                                                 |    2 
 drivers/bus/fsl-mc/fsl-mc-bus.c                                     |    6 
 drivers/char/Kconfig                                                |   50 +-
 drivers/clk/imx/clk-imx8mp.c                                        |    2 
 drivers/clocksource/hyperv_timer.c                                  |    1 
 drivers/comedi/drivers/vmk80xx.c                                    |    2 
 drivers/gpio/gpio-dwapb.c                                           |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                    |   13 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                             |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                             |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c                             |   27 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c                                |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |    8 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c       |    4 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c               |    6 
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c                            |    2 
 drivers/gpu/drm/i915/i915_sysfs.c                                   |   15 
 drivers/hv/channel_mgmt.c                                           |    1 
 drivers/i2c/busses/i2c-designware-common.c                          |    3 
 drivers/i2c/busses/i2c-designware-platdrv.c                         |   13 
 drivers/i2c/busses/i2c-mt65xx.c                                     |    9 
 drivers/i2c/busses/i2c-npcm7xx.c                                    |    3 
 drivers/input/misc/soc_button_array.c                               |    4 
 drivers/irqchip/irq-apple-aic.c                                     |    2 
 drivers/irqchip/irq-gic-realview.c                                  |    1 
 drivers/irqchip/irq-gic-v3.c                                        |    7 
 drivers/irqchip/irq-realtek-rtl.c                                   |    2 
 drivers/isdn/mISDN/socket.c                                         |    2 
 drivers/md/dm-core.h                                                |   11 
 drivers/md/dm-log.c                                                 |    3 
 drivers/md/dm-rq.c                                                  |    2 
 drivers/md/dm-table.c                                               |   11 
 drivers/md/dm.c                                                     |   87 +---
 drivers/md/dm.h                                                     |    2 
 drivers/md/raid5-ppl.c                                              |    4 
 drivers/misc/atmel-ssc.c                                            |    4 
 drivers/misc/mei/hbm.c                                              |    3 
 drivers/misc/mei/hw-me-regs.h                                       |    2 
 drivers/misc/mei/pci-me.c                                           |    2 
 drivers/net/ethernet/broadcom/bgmac-bcma.c                          |    1 
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                         |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c             |   18 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c               |  101 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h               |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                      |   25 -
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |    5 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                  |    2 
 drivers/net/ethernet/intel/iavf/iavf_main.c                         |    2 
 drivers/net/ethernet/intel/ice/ice_main.c                           |   49 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c                            |    2 
 drivers/net/ethernet/intel/ice/ice_ptp.h                            |   31 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c                         |    5 
 drivers/net/ethernet/intel/ice/ice_virtchnl.c                       |   53 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                         |   21 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c                   |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h                  |    2 
 drivers/net/ppp/pppoe.c                                             |    3 
 drivers/nfc/nfcmrvl/usb.c                                           |   16 
 drivers/nvme/host/core.c                                            |    4 
 drivers/platform/mips/Kconfig                                       |    2 
 drivers/platform/x86/gigabyte-wmi.c                                 |    2 
 drivers/platform/x86/intel/hid.c                                    |    6 
 drivers/platform/x86/intel/pmc/core.c                               |    1 
 drivers/platform/x86/intel/pmt/crashlog.c                           |    2 
 drivers/scsi/ipr.c                                                  |    4 
 drivers/scsi/lpfc/lpfc_els.c                                        |   18 -
 drivers/scsi/lpfc/lpfc_hw4.h                                        |    3 
 drivers/scsi/lpfc/lpfc_nportdisc.c                                  |    3 
 drivers/scsi/lpfc/lpfc_nvme.c                                       |   11 
 drivers/scsi/mpt3sas/mpt3sas_base.c                                 |   23 -
 drivers/scsi/pmcraid.c                                              |    2 
 drivers/scsi/vmw_pvscsi.h                                           |    4 
 drivers/staging/r8188eu/core/rtw_xmit.c                             |   20 -
 drivers/staging/r8188eu/os_dep/ioctl_linux.c                        |    2 
 drivers/tty/goldfish.c                                              |    2 
 drivers/tty/n_gsm.c                                                 |    2 
 drivers/tty/serial/8250/8250_port.c                                 |    2 
 drivers/usb/cdns3/cdnsp-ring.c                                      |   19 -
 drivers/usb/dwc2/hcd.c                                              |    2 
 drivers/usb/dwc3/dwc3-pci.c                                         |    1 
 drivers/usb/dwc3/gadget.c                                           |   26 -
 drivers/usb/gadget/function/f_fs.c                                  |   40 +-
 drivers/usb/gadget/function/u_ether.c                               |   12 
 drivers/usb/gadget/udc/lpc32xx_udc.c                                |    1 
 drivers/usb/serial/io_ti.c                                          |    2 
 drivers/usb/serial/io_usbvend.h                                     |    1 
 drivers/usb/serial/option.c                                         |    6 
 drivers/virtio/virtio_mmio.c                                        |    1 
 drivers/virtio/virtio_pci_common.c                                  |    3 
 fs/9p/cache.c                                                       |    4 
 fs/9p/v9fs.c                                                        |    2 
 fs/9p/v9fs.h                                                        |   10 
 fs/9p/vfs_addr.c                                                    |    2 
 fs/9p/vfs_inode.c                                                   |    4 
 fs/afs/callback.c                                                   |    2 
 fs/afs/dir.c                                                        |   32 -
 fs/afs/dir_edit.c                                                   |   10 
 fs/afs/dir_silly.c                                                  |    4 
 fs/afs/dynroot.c                                                    |    2 
 fs/afs/file.c                                                       |    4 
 fs/afs/fs_operation.c                                               |    6 
 fs/afs/inode.c                                                      |   38 +-
 fs/afs/internal.h                                                   |   23 -
 fs/afs/super.c                                                      |    6 
 fs/afs/write.c                                                      |   21 -
 fs/attr.c                                                           |   26 +
 fs/ceph/addr.c                                                      |    4 
 fs/ceph/cache.c                                                     |    4 
 fs/ceph/cache.h                                                     |    2 
 fs/ceph/caps.c                                                      |  104 ++---
 fs/ceph/file.c                                                      |    2 
 fs/ceph/inode.c                                                     |   10 
 fs/ceph/mds_client.c                                                |    4 
 fs/ceph/snap.c                                                      |    8 
 fs/ceph/super.c                                                     |    2 
 fs/ceph/super.h                                                     |   10 
 fs/ceph/xattr.c                                                     |   14 
 fs/cifs/cifsfs.c                                                    |    8 
 fs/cifs/cifsglob.h                                                  |   12 
 fs/cifs/file.c                                                      |    8 
 fs/cifs/fscache.c                                                   |    8 
 fs/cifs/fscache.h                                                   |    8 
 fs/cifs/inode.c                                                     |    4 
 fs/cifs/misc.c                                                      |    4 
 fs/cifs/smb2ops.c                                                   |    8 
 fs/ext4/mballoc.c                                                   |    9 
 fs/ext4/namei.c                                                     |    3 
 fs/ext4/resize.c                                                    |   10 
 fs/ext4/super.c                                                     |   16 
 fs/io_uring.c                                                       |   97 ++++-
 fs/netfs/buffered_read.c                                            |    6 
 fs/netfs/internal.h                                                 |    2 
 fs/netfs/objects.c                                                  |    2 
 fs/nfs/callback_proc.c                                              |    1 
 fs/nfs/pnfs.c                                                       |   21 -
 fs/nfs/pnfs.h                                                       |    1 
 fs/quota/dquot.c                                                    |   10 
 include/linux/backing-dev.h                                         |    2 
 include/linux/netfs.h                                               |   41 --
 include/linux/objtool.h                                             |    6 
 include/linux/skbuff.h                                              |    3 
 include/net/ipv6.h                                                  |    4 
 init/Kconfig                                                        |    9 
 kernel/auditsc.c                                                    |    2 
 kernel/cfi.c                                                        |   22 -
 kernel/dma/debug.c                                                  |    2 
 kernel/sched/core.c                                                 |   36 +-
 kernel/sched/sched.h                                                |    5 
 kernel/trace/bpf_trace.c                                            |    4 
 lib/Kconfig                                                         |    3 
 lib/Makefile                                                        |    1 
 lib/crypto/Kconfig                                                  |    1 
 lib/memneq.c                                                        |  176 ++++++++++
 mm/backing-dev.c                                                    |   11 
 net/appletalk/ddp.c                                                 |    3 
 net/atm/common.c                                                    |    2 
 net/ax25/af_ax25.c                                                  |   34 +
 net/bluetooth/af_bluetooth.c                                        |    3 
 net/bluetooth/hci_sock.c                                            |    3 
 net/caif/caif_socket.c                                              |    2 
 net/can/bcm.c                                                       |    5 
 net/can/isotp.c                                                     |    4 
 net/can/j1939/socket.c                                              |    2 
 net/can/raw.c                                                       |    6 
 net/core/datagram.c                                                 |    5 
 net/ieee802154/socket.c                                             |    6 
 net/ipv4/ping.c                                                     |    3 
 net/ipv4/raw.c                                                      |    3 
 net/ipv6/ip6_output.c                                               |    6 
 net/ipv6/raw.c                                                      |    3 
 net/iucv/af_iucv.c                                                  |    3 
 net/key/af_key.c                                                    |    2 
 net/l2tp/l2tp_ip.c                                                  |    3 
 net/l2tp/l2tp_ip6.c                                                 |    8 
 net/l2tp/l2tp_ppp.c                                                 |    3 
 net/mctp/af_mctp.c                                                  |    2 
 net/mctp/test/route-test.c                                          |    8 
 net/netlink/af_netlink.c                                            |    3 
 net/netrom/af_netrom.c                                              |    3 
 net/nfc/llcp_sock.c                                                 |    3 
 net/nfc/rawsock.c                                                   |    3 
 net/packet/af_packet.c                                              |    2 
 net/phonet/datagram.c                                               |    3 
 net/phonet/pep.c                                                    |    6 
 net/qrtr/af_qrtr.c                                                  |    3 
 net/rose/af_rose.c                                                  |    3 
 net/sunrpc/clnt.c                                                   |    1 
 net/unix/af_unix.c                                                  |    5 
 net/vmw_vsock/vmci_transport.c                                      |    5 
 net/x25/af_x25.c                                                    |    3 
 scripts/faddr2line                                                  |   45 +-
 security/selinux/hooks.c                                            |   11 
 sound/hda/hdac_device.c                                             |    1 
 sound/pci/hda/hda_intel.c                                           |    3 
 sound/pci/hda/patch_hdmi.c                                          |    1 
 sound/pci/hda/patch_realtek.c                                       |   14 
 sound/soc/codecs/cs35l36.c                                          |    3 
 sound/soc/codecs/cs42l51.c                                          |    2 
 sound/soc/codecs/cs42l52.c                                          |    8 
 sound/soc/codecs/cs42l56.c                                          |    4 
 sound/soc/codecs/cs53l30.c                                          |   16 
 sound/soc/codecs/es8328.c                                           |    5 
 sound/soc/codecs/nau8822.c                                          |    4 
 sound/soc/codecs/nau8822.h                                          |    3 
 sound/soc/codecs/wm8962.c                                           |    1 
 sound/soc/codecs/wm_adsp.c                                          |    2 
 sound/soc/intel/boards/sof_cirrus_common.c                          |   40 ++
 sound/soc/qcom/lpass-platform.c                                     |    2 
 tools/include/linux/objtool.h                                       |    6 
 234 files changed, 1539 insertions(+), 1077 deletions(-)

Adam Ford (3):
      arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3
      arm64: dts: imx8mn-beacon: Enable RTS-CTS on UART3
      ASoC: wm8962: Fix suspend while playing music

Alan Previn (1):
      drm/i915/reset: Fix error_state_read ptr + offset use

Aleksandr Loktionov (1):
      i40e: Fix call trace in setup_tx_descriptors

Alexander Usyskin (2):
      mei: hbm: drop capability response on early shutdown
      mei: me: add raptor lake point S DID

August Wikerfors (1):
      platform/x86: gigabyte-wmi: Add support for B450M DS3H-CF

Baokun Li (1):
      ext4: fix bug_on ext4_mb_use_inode_pa

Bart Van Assche (1):
      block: Fix handling of offline queues in blk_mq_alloc_request_hctx()

Benjamin Marzinski (1):
      dm: fix race in dm_start_io_acct

Candice Li (1):
      drm/amdgpu: Resolve RAS GFX error count issue after cold boot on Arcturus

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

Christian Brauner (1):
      fs: account for group membership

Christian Göttsche (2):
      audit: free module name
      selinux: free contexts previously transferred in selinux_add_opt()

Christoph Hellwig (1):
      dm: fix bio_set allocation

Christophe JAILLET (2):
      net: bgmac: Fix an erroneous kfree() in bgmac_remove()
      i2c: mediatek: Fix an error handling path in mtk_i2c_probe()

Conor Dooley (1):
      riscv: dts: microchip: re-add pdma to mpfs device tree

Dan Carpenter (1):
      bpf: Use safer kvmalloc_array() where possible

David Arcari (1):
      platform/x86/intel: Fix pmt_crashlog array reference

David Howells (1):
      netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context

Ding Xiang (1):
      ext4: make variable "count" signed

Duke Lee (1):
      platform/x86/intel: hid: Add Surface Go to VGBS allow list

Duoming Zhou (1):
      net: ax25: Fix deadlock caused by skb_recv_datagram in ax25_recvmsg

George D Sworo (1):
      platform/x86/intel: pmc: Support Intel Raptorlake P

Greg Kroah-Hartman (1):
      Linux 5.18.6

Grzegorz Szczurek (2):
      i40e: Fix adding ADQ filter to TC0
      i40e: Fix calculating the number of queue pairs

Guangbin Huang (3):
      net: hns3: set port base vlan tbl_sta to false before removing old vlan
      net: hns3: restore tm priority/qset to default settings when tc disabled
      net: hns3: fix tm port shapping of fibre port is incorrect after driver initialization

He Ying (1):
      powerpc/kasan: Silence KASAN warnings in __get_wchan()

Helge Deller (1):
      scsi: mpt3sas: Fix out-of-bounds compiler warning

Hui Wang (1):
      ASoC: nau8822: Add operation for internal PLL off and on

Ian Abbott (1):
      comedi: vmk80xx: fix expression for tx buffer size

Ilpo Järvinen (1):
      serial: 8250: Store to lsr_save_flags after lsr read

James Smart (3):
      scsi: lpfc: Resolve NULL ptr dereference after an ELS LOGO is aborted
      scsi: lpfc: Fix port stuck in bypassed state after LIP in PT2PT topology
      scsi: lpfc: Allow reduced polling rate for nvme_admin_async_event cmd completion

Jan Kara (1):
      init: Initialize noop_backing_dev_info early

Jani Nikula (1):
      drm/i915/uc: remove accidental static from a local variable

Jason A. Donenfeld (2):
      random: credit cpu and bootloader seeds by default
      crypto: memneq - move into lib/

Jens Axboe (1):
      io_uring: reinstate the inflight tracking

Jian Shen (1):
      net: hns3: don't push link state to VF if unalive

Jiasheng Jiang (1):
      i2c: npcm7xx: Add check for platform_driver_register

Jie Wang (1):
      net: hns3: fix PF rss size initialization bug

Jing Leng (1):
      usb: cdnsp: Fixed setting last_trb incorrectly

Josh Poimboeuf (2):
      faddr2line: Fix overlapping text section failures, the sequel
      x86/ftrace: Remove OBJECT_FILES_NON_STANDARD usage

Lang Yu (1):
      drm/amdkfd: add pinned BOs to kfd_bo_list

Larry Finger (1):
      staging: r8188eu: Fix warning of array overflow in ioctl_linux.c

Linus Torvalds (4):
      gcc-12: disable '-Wdangling-pointer' warning for now
      mellanox: mlx5: avoid uninitialized variable warning with gcc-12
      gcc-12: disable '-Warray-bounds' universally for now
      netfs: gcc-12: temporarily disable '-Wattribute-warning' for now

Linyu Yuan (2):
      usb: gadget: f_fs: change ep->status safe in ffs_epfile_io()
      usb: gadget: f_fs: change ep->ep safe in ffs_epfile_io()

Logan Gunthorpe (1):
      md/raid5-ppl: Fix argument order in bio_alloc_bioset()

Marc Zyngier (2):
      KVM: arm64: Always start with clearing SVE flag on load
      KVM: arm64: Don't read a HW interrupt pending state in user context

Marian Postevca (1):
      usb: gadget: u_ether: fix regression in setting fixed MAC address

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

Mauro Carvalho Chehab (2):
      dt-bindings: mfd: bd9571mwv: update rohm,bd9571mwv.yaml reference
      dt-bindings: interrupt-controller: update brcm,l2-intc.yaml reference

Miaoqian Lin (9):
      misc: atmel-ssc: Fix IRQ check in ssc_probe
      irqchip/gic/realview: Fix refcount leak in realview_gic_of_init
      irqchip/apple-aic: Fix refcount leak in build_fiq_affinity
      irqchip/apple-aic: Fix refcount leak in aic_of_ic_init
      irqchip/gic-v3: Fix error handling in gic_populate_ppi_partitions
      irqchip/gic-v3: Fix refcount leak in gic_populate_ppi_partitions
      irqchip/realtek-rtl: Fix refcount leak in map_interrupts
      usb: dwc2: Fix memory leak in dwc2_hcd_init
      usb: gadget: lpc32xx_udc: Fix refcount leak in lpc32xx_udc_probe

Michal Michalik (1):
      ice: Fix PTP TX timestamp offset calculation

Michal Wilczynski (1):
      iavf: Fix issue with MAC address of VF shown as zero

Michel Dänzer (1):
      drm/amdgpu: Fix GTT size reporting in amdgpu_ioctl

Mikulas Patocka (1):
      dm mirror log: round up region bitmap size to BITS_PER_LONG

Murilo Opsfelder Araujo (1):
      virtio-pci: Remove wrong address verification in vp_del_vqs()

Oliver Hartkopp (1):
      net: remove noblock parameter from skb_recv_datagram()

Pavel Begunkov (2):
      io_uring: fix races with file table unregister
      io_uring: fix races with buffer table unregister

Peng Fan (1):
      clk: imx8mp: fix usb_root_clk parent

Peter Zijlstra (1):
      sched: Fix balance_push() vs __sched_setscheduler()

Petr Machata (1):
      mlxsw: spectrum_cnt: Reorder counter pools

Philip Yang (1):
      drm/amdkfd: Use mmget_not_zero in MMU notifier

Phillip Potter (1):
      staging: r8188eu: fix rtw_alloc_hwxmits error detection for now

Piotr Chmura (1):
      platform/x86: gigabyte-wmi: Add Z690M AORUS ELITE AX DDR4 support

Przemyslaw Patynowski (2):
      ice: Fix queue config fail handling
      ice: Fix memory corruption in VF driver

Rob Clark (1):
      dma-debug: make things less spammy under memory pressure

Robert Eckelmann (1):
      USB: serial: io_ti: add Agilent E5805A support

Roman Li (1):
      drm/amd/display: Cap OLED brightness per max frame-average luminance

Roman Storozhenko (1):
      ice: Sync VLAN filtering features for DVM

Sami Tolvanen (1):
      cfi: Fix __cfi_slowpath_diag RCU usage with cpuidle

Saurabh Sengar (1):
      Drivers: hv: vmbus: Release cpu lock in error case

Scott Mayhew (1):
      sunrpc: set cl_max_connect when cloning an rpc_clnt

Serge Semin (2):
      gpio: dwapb: Don't print error on -EPROBE_DEFER
      i2c: designware: Use standard optional ref clock implementation

Sergey Shtylyov (1):
      ata: libata-core: fix NULL pointer deref in ata_host_alloc_pinfo()

Sherry Wang (1):
      drm/amd/display: Read Golden Settings Table from VBIOS

Shin'ichiro Kawasaki (1):
      bus: fsl-mc-bus: fix KASAN use-after-free in fsl_mc_bus_remove()

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV31 with new baseline

Srinivasa Rao Mandadapu (1):
      ASoC: qcom: lpass-platform: Update VMA access permissions in mmap callback

Stephan Gerhold (1):
      usb: dwc3: pci: Restore line lost in merge conflict resolution

Stylon Wang (1):
      Revert "drm/amd/display: Fix DCN3 B0 DP Alt Mapping"

Thomas Weißschuh (1):
      nvme: add device name to warning in uuid_show()

Tony Lindgren (1):
      tty: n_gsm: Debug output allocation must use GFP_ATOMIC

Trond Myklebust (2):
      pNFS: Don't keep retrying if the server replied NFS4ERR_LAYOUTUNAVAILABLE
      pNFS: Avoid a live lock condition in pnfs_update_layout()

Vincent Whitchurch (1):
      tty: goldfish: Fix free_irq() on remove

Wang Yufen (2):
      ipv6: Fix signed integer overflow in __ip6_append_data
      ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg

Wentao Wang (1):
      scsi: vmw_pvscsi: Expand vcpuHint to 16 bits

Wesley Cheng (1):
      usb: dwc3: gadget: Fix IN endpoint max packet size allocation

Will Deacon (1):
      arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer

Xiaohui Zhang (1):
      nfc: nfcmrvl: Fix memory leak in nfcmrvl_play_deferred

Ye Bin (1):
      ext4: fix super block checksum incorrect after mount

Yong Zhi (1):
      ALSA: hda: MTL: add HD Audio PCI ID and HDMI codec vendor ID

Yupeng Li (1):
      MIPS: Loongson-3: fix compile mips cpu_hwmon as module build error.

Zhang Yi (1):
      ext4: add reserved GDT blocks check

chengkaitao (1):
      virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed

huangwenhui (1):
      ALSA: hda/realtek - Add HW8326 support

xliu (1):
      ASoC: Intel: cirrus-common: fix incorrect channel mapping

