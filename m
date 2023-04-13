Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF686E10E9
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 17:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjDMPUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 11:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjDMPUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 11:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD55AAF28;
        Thu, 13 Apr 2023 08:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 250F063F9F;
        Thu, 13 Apr 2023 15:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BABC433EF;
        Thu, 13 Apr 2023 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681399195;
        bh=kBCReL655OMc4cl4kbNu+wUGF2s3g4AbwKoVA6U6V5k=;
        h=From:To:Cc:Subject:Date:From;
        b=Fm/Y63ofI37WFZK5pswFqrwXmxj2sUAHrKTQLCnDYAtUKMz8FlQLmwIe6U5KQAo94
         wMUoC2zNRGAbLafiKYhohe0SYyY/QDNQbvIzSjEwx7s33sIVZMUpax6Gh4DxsC5sFf
         ohM2v9Z1U+RN27Kd+pyLx9rYliI/zc9L3pmqcJnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.2.11
Date:   Thu, 13 Apr 2023 17:19:41 +0200
Message-Id: <2023041342-violet-chasing-fef8@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
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

I'm announcing the release of the 6.2.11 kernel.

All users of the 6.2 kernel series must upgrade.

The updated 6.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/serial/renesas,scif.yaml |    4 
 Documentation/mm/zsmalloc.rst                              |    2 
 Makefile                                                   |    2 
 arch/arm64/kernel/compat_alignment.c                       |   32 -
 arch/s390/kvm/intercept.c                                  |   32 -
 arch/x86/kernel/acpi/boot.c                                |    9 
 arch/x86/kvm/kvm_onhyperv.h                                |    5 
 arch/x86/kvm/svm/svm.c                                     |   37 +
 arch/x86/kvm/svm/svm_onhyperv.h                            |   15 
 arch/x86/kvm/vmx/nested.c                                  |    7 
 arch/x86/kvm/x86.c                                         |   11 
 block/blk-mq.c                                             |    4 
 block/genhd.c                                              |    8 
 drivers/acpi/acpi_video.c                                  |   15 
 drivers/acpi/video_detect.c                                |   58 +
 drivers/block/ublk_drv.c                                   |   26 
 drivers/counter/104-quad-8.c                               |   31 -
 drivers/cxl/core/pci.c                                     |   38 -
 drivers/cxl/cxlpci.h                                       |   14 
 drivers/gpio/Kconfig                                       |    2 
 drivers/gpio/gpio-davinci.c                                |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                 |   18 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c          |    2 
 drivers/gpu/drm/bridge/lontium-lt9611.c                    |    1 
 drivers/gpu/drm/i915/display/intel_color.c                 |   23 
 drivers/gpu/drm/i915/display/intel_color.h                 |    3 
 drivers/gpu/drm/i915/display/intel_display.c               |   28 
 drivers/gpu/drm/i915/display/intel_display.h               |    8 
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c       |   12 
 drivers/gpu/drm/i915/gt/uc/intel_huc.c                     |    7 
 drivers/gpu/drm/i915/gt/uc/intel_huc.h                     |    7 
 drivers/gpu/drm/i915/i915_perf.c                           |    6 
 drivers/gpu/drm/nouveau/dispnv50/disp.c                    |   32 +
 drivers/gpu/drm/nouveau/nouveau_dp.c                       |    8 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                    |    1 
 drivers/hv/connection.c                                    |    4 
 drivers/hwtracing/coresight/coresight-etm4x-core.c         |   24 
 drivers/hwtracing/coresight/coresight-etm4x.h              |   20 
 drivers/iio/accel/kionix-kx022a.c                          |    2 
 drivers/iio/adc/ad7791.c                                   |    2 
 drivers/iio/adc/ltc2497.c                                  |    6 
 drivers/iio/adc/max11410.c                                 |   22 
 drivers/iio/adc/qcom-spmi-adc5.c                           |   10 
 drivers/iio/adc/ti-ads7950.c                               |    1 
 drivers/iio/dac/cio-dac.c                                  |    4 
 drivers/iio/imu/Kconfig                                    |    1 
 drivers/iio/industrialio-buffer.c                          |   21 
 drivers/iio/light/cm32181.c                                |   12 
 drivers/iio/light/vcnl4000.c                               |    3 
 drivers/iommu/iommufd/pages.c                              |   16 
 drivers/md/dm-bio-prison-v1.c                              |   10 
 drivers/md/dm-bio-prison-v2.c                              |   12 
 drivers/md/dm-bio-prison-v2.h                              |   10 
 drivers/md/dm-bufio.c                                      |   58 -
 drivers/md/dm-cache-background-tracker.c                   |    8 
 drivers/md/dm-cache-background-tracker.h                   |   46 +
 drivers/md/dm-cache-metadata.c                             |   40 -
 drivers/md/dm-cache-metadata.h                             |    4 
 drivers/md/dm-cache-policy-internal.h                      |   10 
 drivers/md/dm-cache-policy-smq.c                           |  163 ++---
 drivers/md/dm-cache-policy.c                               |    2 
 drivers/md/dm-cache-policy.h                               |    4 
 drivers/md/dm-cache-target.c                               |   50 -
 drivers/md/dm-core.h                                       |    6 
 drivers/md/dm-crypt.c                                      |   48 -
 drivers/md/dm-delay.c                                      |    6 
 drivers/md/dm-ebs-target.c                                 |    2 
 drivers/md/dm-era-target.c                                 |   32 -
 drivers/md/dm-exception-store.c                            |    6 
 drivers/md/dm-exception-store.h                            |   18 
 drivers/md/dm-flakey.c                                     |   22 
 drivers/md/dm-integrity.c                                  |  328 +++++------
 drivers/md/dm-io-rewind.c                                  |    4 
 drivers/md/dm-io.c                                         |   32 -
 drivers/md/dm-ioctl.c                                      |   18 
 drivers/md/dm-kcopyd.c                                     |   30 -
 drivers/md/dm-linear.c                                     |    2 
 drivers/md/dm-log-userspace-base.c                         |    6 
 drivers/md/dm-log-userspace-transfer.c                     |    2 
 drivers/md/dm-log-writes.c                                 |   10 
 drivers/md/dm-log.c                                        |   10 
 drivers/md/dm-mpath.c                                      |   46 -
 drivers/md/dm-mpath.h                                      |    2 
 drivers/md/dm-path-selector.h                              |    2 
 drivers/md/dm-ps-io-affinity.c                             |    4 
 drivers/md/dm-ps-queue-length.c                            |   10 
 drivers/md/dm-ps-round-robin.c                             |    6 
 drivers/md/dm-ps-service-time.c                            |   14 
 drivers/md/dm-raid.c                                       |    2 
 drivers/md/dm-raid1.c                                      |   22 
 drivers/md/dm-region-hash.c                                |   22 
 drivers/md/dm-rq.c                                         |   16 
 drivers/md/dm-rq.h                                         |    2 
 drivers/md/dm-snap-persistent.c                            |    8 
 drivers/md/dm-snap-transient.c                             |    6 
 drivers/md/dm-snap.c                                       |   34 -
 drivers/md/dm-stats.c                                      |   74 +-
 drivers/md/dm-stats.h                                      |    6 
 drivers/md/dm-stripe.c                                     |   10 
 drivers/md/dm-switch.c                                     |   46 -
 drivers/md/dm-table.c                                      |   25 
 drivers/md/dm-thin-metadata.c                              |   24 
 drivers/md/dm-thin.c                                       |   46 -
 drivers/md/dm-uevent.c                                     |    4 
 drivers/md/dm-uevent.h                                     |    4 
 drivers/md/dm-verity-fec.c                                 |   30 -
 drivers/md/dm-verity-fec.h                                 |   18 
 drivers/md/dm-verity-target.c                              |   30 -
 drivers/md/dm-verity.h                                     |    8 
 drivers/md/dm-writecache.c                                 |   80 +-
 drivers/md/dm.c                                            |   55 -
 drivers/md/dm.h                                            |    4 
 drivers/md/persistent-data/dm-array.c                      |   69 +-
 drivers/md/persistent-data/dm-array.h                      |    2 
 drivers/md/persistent-data/dm-bitset.c                     |   12 
 drivers/md/persistent-data/dm-block-manager.c              |   16 
 drivers/md/persistent-data/dm-block-manager.h              |    6 
 drivers/md/persistent-data/dm-btree-remove.c               |   46 -
 drivers/md/persistent-data/dm-btree-spine.c                |    4 
 drivers/md/persistent-data/dm-btree.c                      |   98 +--
 drivers/md/persistent-data/dm-btree.h                      |   12 
 drivers/md/persistent-data/dm-persistent-data-internal.h   |    6 
 drivers/md/persistent-data/dm-space-map-common.c           |   28 
 drivers/md/persistent-data/dm-space-map-metadata.c         |   20 
 drivers/md/persistent-data/dm-transaction-manager.c        |   16 
 drivers/md/persistent-data/dm-transaction-manager.h        |    2 
 drivers/net/dsa/mv88e6xxx/chip.c                           |    2 
 drivers/net/dsa/mv88e6xxx/global2.c                        |   20 
 drivers/net/dsa/mv88e6xxx/global2.h                        |    1 
 drivers/net/ethernet/google/gve/gve.h                      |    2 
 drivers/net/ethernet/google/gve/gve_tx.c                   |   12 
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c         |   23 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c          |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |   21 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                   |    6 
 drivers/net/phy/phylink.c                                  |   19 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   36 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h    |    2 
 drivers/net/wireless/mediatek/mt76/mt7603/main.c           |   10 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c            |   70 --
 drivers/net/wireless/mediatek/mt76/mt7615/main.c           |   15 
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h         |    6 
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c          |   18 
 drivers/net/wireless/mediatek/mt76/mt7915/main.c           |   13 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c           |   13 
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c            |    2 
 drivers/net/wireless/mediatek/mt76/mt7996/main.c           |   13 
 drivers/nvme/host/core.c                                   |    6 
 drivers/pci/doe.c                                          |   30 -
 drivers/platform/x86/think-lmi.c                           |   20 
 drivers/pwm/pwm-cros-ec.c                                  |    1 
 drivers/pwm/pwm-hibvt.c                                    |    1 
 drivers/pwm/pwm-iqs620a.c                                  |    1 
 drivers/pwm/pwm-meson.c                                    |    8 
 drivers/pwm/pwm-sprd.c                                     |    1 
 drivers/scsi/iscsi_tcp.c                                   |    3 
 drivers/scsi/qla2xxx/qla_os.c                              |    1 
 drivers/tty/serial/8250/8250_port.c                        |   11 
 drivers/tty/serial/fsl_lpuart.c                            |   10 
 drivers/tty/serial/sh-sci.c                                |   10 
 drivers/usb/cdns3/cdnsp-ep0.c                              |    3 
 drivers/usb/dwc3/dwc3-pci.c                                |    4 
 drivers/usb/host/xhci-pci.c                                |    7 
 drivers/usb/host/xhci-tegra.c                              |    6 
 drivers/usb/host/xhci.c                                    |    7 
 drivers/usb/serial/cp210x.c                                |    1 
 drivers/usb/serial/option.c                                |   10 
 drivers/usb/typec/altmodes/displayport.c                   |    6 
 fs/cifs/fs_context.c                                       |   13 
 fs/cifs/fs_context.h                                       |    3 
 fs/cifs/misc.c                                             |    2 
 fs/dax.c                                                   |   52 +
 fs/ksmbd/connection.c                                      |    5 
 fs/ksmbd/server.c                                          |    5 
 fs/ksmbd/smb2pdu.c                                         |    3 
 fs/ksmbd/smb_common.c                                      |  138 +++-
 fs/ksmbd/smb_common.h                                      |    2 
 fs/namespace.c                                             |    2 
 fs/nfsd/blocklayout.c                                      |    1 
 fs/nfsd/nfs4callback.c                                     |    4 
 fs/nfsd/nfs4xdr.c                                          |   15 
 fs/nilfs2/segment.c                                        |    3 
 fs/nilfs2/super.c                                          |    2 
 fs/nilfs2/the_nilfs.c                                      |   12 
 include/acpi/video.h                                       |   15 
 include/linux/device-mapper.h                              |   38 -
 include/linux/dm-bufio.h                                   |   12 
 include/linux/dm-dirty-log.h                               |    6 
 include/linux/dm-io.h                                      |    8 
 include/linux/dm-kcopyd.h                                  |   22 
 include/linux/dm-region-hash.h                             |    2 
 include/linux/ftrace.h                                     |    2 
 include/linux/mm_types.h                                   |    3 
 include/linux/pci-doe.h                                    |    8 
 include/linux/phylink.h                                    |    1 
 include/net/raw.h                                          |   15 
 io_uring/io_uring.c                                        |    2 
 io_uring/kbuf.c                                            |    7 
 kernel/events/core.c                                       |   14 
 kernel/fork.c                                              |    3 
 kernel/trace/ftrace.c                                      |   15 
 kernel/trace/ring_buffer.c                                 |   13 
 kernel/trace/trace.c                                       |    1 
 kernel/trace/trace_events_synth.c                          |   19 
 kernel/trace/trace_osnoise.c                               |    4 
 lib/maple_tree.c                                           |  383 ++++++++-----
 mm/hugetlb.c                                               |   14 
 mm/kfence/core.c                                           |   32 -
 mm/memory.c                                                |   16 
 mm/mmap.c                                                  |    3 
 mm/swapfile.c                                              |    3 
 mm/vmalloc.c                                               |    8 
 net/can/isotp.c                                            |   74 +-
 net/can/j1939/transport.c                                  |    5 
 net/core/netpoll.c                                         |   19 
 net/ethtool/linkmodes.c                                    |    7 
 net/ipv4/icmp.c                                            |    5 
 net/ipv4/ping.c                                            |    8 
 net/ipv4/raw.c                                             |   49 -
 net/ipv4/raw_diag.c                                        |   10 
 net/ipv6/ip6_output.c                                      |    7 
 net/ipv6/raw.c                                             |   14 
 net/l2tp/l2tp_ip.c                                         |    8 
 net/l2tp/l2tp_ip6.c                                        |    8 
 net/mac80211/sta_info.c                                    |    3 
 net/mac80211/util.c                                        |    2 
 net/netlink/af_netlink.c                                   |   15 
 net/qrtr/af_qrtr.c                                         |    2 
 net/qrtr/ns.c                                              |   15 
 net/sctp/socket.c                                          |    4 
 net/sunrpc/svcauth_unix.c                                  |   17 
 sound/pci/hda/patch_hdmi.c                                 |   11 
 sound/pci/hda/patch_realtek.c                              |    2 
 sound/soc/codecs/hdac_hdmi.c                               |   17 
 sound/soc/codecs/lpass-rx-macro.c                          |    4 
 sound/soc/codecs/lpass-tx-macro.c                          |    4 
 sound/soc/codecs/lpass-wsa-macro.c                         |    4 
 sound/soc/sof/ipc4-topology.c                              |    8 
 sound/soc/sof/ipc4.c                                       |    8 
 tools/testing/radix-tree/maple.c                           |   18 
 241 files changed, 2636 insertions(+), 1756 deletions(-)

Alex Deucher (1):
      drm/amdgpu: for S0ix, skip SDMA 5.x+ suspend/resume

Alistair Popple (1):
      mm: take a page reference when removing device exclusive entries

Andrea Righi (1):
      l2tp: generate correct module alias strings

Andy Chi (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Andy Roulin (1):
      ethtool: reset #lanes when lanes is omitted

Andy Shevchenko (1):
      iio: adc: qcom-spmi-adc5: Fix the channel name

Ard Biesheuvel (1):
      arm64: compat: Work around uninitialized variable warning

Armin Wolf (1):
      platform/x86: think-lmi: Fix memory leak when showing current settings

Arnd Bergmann (1):
      iio: adis16480: select CONFIG_CRC32

Biju Das (2):
      tty: serial: sh-sci: Fix transmit end interrupt handler
      tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Bjørn Mork (1):
      USB: serial: option: add Quectel RM500U-CN modem

Boris Brezillon (1):
      drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path

Christian Brauner (1):
      fs: drop peer group ids under namespace lock

Chuck Lever (1):
      NFSD: Avoid calling OPDESC() with ops->opnum == OP_ILLEGAL

Corinna Vinschen (1):
      net: stmmac: fix up RX flow hash indirection table when setting channels

D Scott Phillips (1):
      xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu

Dai Ngo (1):
      NFSD: callback request does not use correct credential for AUTH_SYS

Daniel Bristot de Oliveira (2):
      tracing/timerlat: Notify new max thread latency
      tracing/osnoise: Fix notify new tracing_max_latency

Daniele Ceraolo Spurio (1):
      drm/i915/huc: Cancel HuC delayed load timer on reset.

Dhruva Gole (2):
      gpio: davinci: Do not clear the bank intr enable bit in save_context
      gpio: davinci: Add irq chip flag to skip set wake

Enrico Sau (1):
      USB: serial: option: add Telit FE990 compositions

Eric DeVolder (1):
      x86/acpi/boot: Correct acpi_is_processor_usable() check

Eric Dumazet (3):
      icmp: guard against too small mtu
      raw: use net_hash_mix() in hash function
      netlink: annotate lockless accesses to nlk->max_recvmsg_len

Felix Fietkau (3):
      wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta
      net: ethernet: mtk_eth_soc: fix remaining throughput regression
      wifi: mt76: ignore key disable commands

Geert Uytterhoeven (1):
      dt-bindings: serial: renesas,scif: Fix 4th IRQ for 4-IRQ SCIFs

Greg Kroah-Hartman (1):
      Linux 6.2.11

Guennadi Liakhovetski (1):
      ASoC: SOF: avoid a NULL dereference with unsupported widgets

Gustav Ekelund (1):
      net: dsa: mv88e6xxx: Reset mv88e6393x force WD event bit

Hans de Goede (5):
      wifi: brcmfmac: Fix SDIO suspend/resume regression
      ACPI: video: Add auto_detect arg to __acpi_video_get_backlight_type()
      ACPI: video: Make acpi_backlight=video work independent from GPU driver
      ACPI: video: Add acpi_backlight=video quirk for Apple iMac14,1 and iMac14,2
      ACPI: video: Add acpi_backlight=video quirk for Lenovo ThinkPad W530

Heikki Krogerus (1):
      usb: dwc3: pci: add support for the Intel Meteor Lake-S

Heinz Mauelshagen (1):
      dm: change "unsigned" to "unsigned int"

Ian Ray (1):
      drivers: iio: adc: ltc2497: fix LSB shift

Ilpo Järvinen (1):
      serial: 8250: Prevent starting up DMA Rx on THRI interrupt

Jakub Kicinski (1):
      net: don't let netpoll invoke NAPI if in xmit context

Jason Gunthorpe (3):
      iommufd: Check for uptr overflow
      iommufd: Fix unpinning of pages when an access is present
      iommufd: Do not corrupt the pfn list when doing batch carry

Jason Montleon (1):
      ASoC: hdac_hdmi: use set_stream() instead of set_tdm_slots()

Jeff Layton (2):
      nfsd: call op_release, even when op_func returns an error
      sunrpc: only free unix grouplist after RCU settles

Jens Axboe (1):
      ublk: read any SQE values upfront

Jeremi Piotrowski (1):
      KVM: SVM: Flush Hyper-V TLB when required

Jeremy Soller (1):
      ALSA: hda/realtek: Add quirk for Clevo X370SNW

Jiapeng Chong (1):
      dm integrity: Remove bi_sector that's only used by commented debug code

Joe Thornber (1):
      dm cache: Add some documentation to dm-cache-background-tracker.h

John Keeping (1):
      ftrace: Mark get_lock_parent_ip() __always_inline

Kai-Heng Feng (1):
      iio: light: cm32181: Unregister second I2C client if present

Kan Liang (1):
      perf/core: Fix the same task check in perf_event_set_output

Karol Herbst (1):
      drm/nouveau/disp: Support more modes by checking with lower bpc

Kees Jan Koster (1):
      USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

Keith Busch (2):
      blk-mq: directly poll requests
      nvme: fix discard support without oncs

Kuniyuki Iwashima (2):
      raw: Fix NULL deref in raw_get_next().
      ping: Fix potentail NULL deref for /proc/net/icmp.

Lars-Peter Clausen (1):
      iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

Li Zetao (1):
      scsi: qla2xxx: Fix memory leak in qla2x00_probe_one()

Liam R. Howlett (13):
      maple_tree: remove GFP_ZERO from kmem_cache_alloc() and kmem_cache_alloc_bulk()
      maple_tree: fix potential rcu issue
      maple_tree: reduce user error potential
      maple_tree: fix handle of invalidated state in mas_wr_store_setup()
      maple_tree: fix mas_prev() and mas_find() state handling
      maple_tree: be more cautious about dead nodes
      maple_tree: refine ma_state init from mas_start()
      maple_tree: detect dead nodes in mas_start()
      maple_tree: fix freeing of nodes in rcu mode
      maple_tree: remove extra smp_wmb() from mas_dead_leaves()
      maple_tree: add smp_rmb() to dead node detection
      maple_tree: add RCU lock checking to rcu callback functions
      mm: enable maple tree RCU mode by default.

Lingyu Liu (1):
      ice: Reset FDIR counter in FDIR init stage

Lorenzo Bianconi (1):
      wifi: mt76: mt7921: fix fw used for offload check for mt7922

Lukas Wunner (6):
      cxl/pci: Fix CDAT retrieval on big endian
      cxl/pci: Handle truncated CDAT header
      cxl/pci: Handle truncated CDAT entries
      cxl/pci: Handle excessive CDAT length
      PCI/DOE: Silence WARN splat with CONFIG_DEBUG_OBJECTS=y
      PCI/DOE: Fix memory leak with CONFIG_DEBUG_OBJECTS=y

Mario Limonciello (1):
      x86/ACPI/boot: Use FADT version to check support for online capable

Marios Makassikis (1):
      ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN

Mark Pearson (2):
      platform/x86: think-lmi: Fix memory leaks when parsing ThinkStation WMI strings
      platform/x86: think-lmi: Clean up display of current_value on Thinkstation

Mathias Nyman (2):
      Revert "usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS"
      xhci: Free the command allocated for setting LPM if we return early

Mehdi Djait (1):
      iio: accel: kionix-kx022a: Get the timestamp from the driver's private data in the trigger_handler

Michael Sit Wei Hong (4):
      net: phylink: add phylink_expects_phy() method
      net: stmmac: check if MAC needs to attach to a PHY
      net: stmmac: remove redundant fixup to support fixed-link mode
      net: stmmac: check fwnode for phy device before scanning for phy

Michal Sojka (1):
      can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events

Mike Snitzer (1):
      dm: fix improper splitting for abnormal bios

Min Li (1):
      drm/i915: fix race condition UAF in i915_perf_add_config_ioctl

Ming Lei (1):
      block: ublk: make sure that block size is set correctly

Mohammed Gamal (1):
      Drivers: vmbus: Check for channel allocation before looking up relids

Muchun Song (2):
      mm: kfence: fix PG_slab and memcg_data clearing
      mm: kfence: fix handling discontiguous page

Mårten Lindahl (1):
      iio: light: vcnl4000: Fix WARN_ON on uninitialized lock

Namjae Jeon (1):
      ksmbd: fix slab-out-of-bounds in init_smb2_rsp_hdr

Nico Boehr (1):
      KVM: s390: pv: fix external interruption loop not always detected

Nuno Sá (4):
      iio: adc: max11410: fix read_poll_timeout() usage
      iio: buffer: correctly return bytes written in output buffers
      iio: buffer: make sure O_NONBLOCK is respected
      iio: adc: ad7791: fix IRQ flags

Oleksij Rempel (1):
      can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

Oliver Hartkopp (2):
      can: isotp: fix race between isotp_sendsmg() and isotp_release()
      can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos

Pawel Laszczak (1):
      usb: cdnsp: Fixes error: uninitialized symbol 'len'

Peng Zhang (2):
      maple_tree: fix get wrong data_end in mtree_lookup_walk()
      maple_tree: fix a potential concurrency bug in RCU mode

Peter Xu (1):
      mm/hugetlb: fix uffd wr-protection for CoW optimization path

Peter Zijlstra (1):
      perf: Optimize perf_pmu_migrate_context()

RD Babiera (1):
      usb: typec: altmodes/displayport: Fix configure initial pin assignment

Randy Dunlap (1):
      gpio: GPIO_REGMAP: select REGMAP instead of depending on it

Ranjani Sridharan (1):
      ASoC: SOF: ipc4: Ensure DSP is in D0I0 during sof_ipc4_set_get_data()

Robert Foss (1):
      drm/bridge: lt9611: Fix PLL being unable to lock

Roman Li (1):
      drm/amd/display: Clear MST topology if it fails to resume

Rongwei Wang (1):
      mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Ryder Lee (1):
      wifi: mac80211: fix the size calculation of ieee80211_ie_len_eht_cap()

Ryusuke Konishi (2):
      nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
      nilfs2: fix sysfs interface lifetime

Sean Christopherson (2):
      KVM: x86: Clear "has_error_code", not "error_code", for RM exception injection
      KVM: nVMX: Do not report error code when synthesizing VM-Exit from Real Mode

Sergey Senozhatsky (1):
      zsmalloc: document freeable stats

Shailend Chand (1):
      gve: Secure enough bytes in the first TX desc for all TCP pkts

Sherry Sun (2):
      tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty
      tty: serial: fsl_lpuart: fix crash in lpuart_uport_is_active

Shiyang Ruan (3):
      fsdax: dedupe should compare the min of two iters' length
      fsdax: unshare: zero destination if srcmap is HOLE or UNWRITTEN
      fsdax: force clear dirty mark if CoW

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe

Simei Su (1):
      ice: fix wrong fallback logic for FDIR

Song Yoong Siang (1):
      net: stmmac: Add queue reset into stmmac_xdp_open() function

Sricharan Ramabadhran (1):
      net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT

Srinivas Kandagatla (1):
      ASoC: codecs: lpass: fix the order or clks turn off during suspend

Steve Clevenger (1):
      coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

Steven Rostedt (Google) (2):
      tracing: Free error logs of tracing instances
      tracing/synthetic: Make lastcmd_mutex static

Suzuki K Poulose (1):
      coresight: etm4x: Do not access TRCIDR1 for identification

Takashi Iwai (1):
      ALSA: hda/hdmi: Preserve the previous PCM device upon re-enablement

Thiago Rafael Becker (1):
      cifs: sanitize paths in cifs_update_super_prepath.

Tim Huang (1):
      drm/amdgpu: skip psp suspend for IMU enabled ASICs mode2 reset

Tvrtko Ursulin (1):
      drm/i915: Fix context runtime accounting

Tze-nan Wu (1):
      tracing/synthetic: Fix races on freeing last_cmd

Uwe Kleine-König (5):
      pwm: hibvt: Explicitly set .polarity in .get_state()
      pwm: cros-ec: Explicitly set .polarity in .get_state()
      pwm: iqs620a: Explicitly set .polarity in .get_state()
      pwm: sprd: Explicitly set .polarity in .get_state()
      pwm: meson: Explicitly set .polarity in .get_state()

Ville Syrjälä (2):
      drm/i915: Move the DSB setup/cleaup into the color code
      drm/i915: Add a .color_post_update() hook

Wayne Chang (1):
      usb: xhci: tegra: fix sleep in atomic call

William Breathitt Gray (3):
      iio: dac: cio-dac: Fix max DAC write value check for 12-bit
      counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
      counter: 104-quad-8: Fix Synapse action reported for Index signals

Wojciech Lukowicz (2):
      io_uring: fix return value when removing provided buffers
      io_uring: fix memory leak when removing provided buffers

Xin Long (1):
      sctp: check send stream number after wait_for_sndbuf

Yafang Shao (1):
      mm: vmalloc: avoid warn_alloc noise caused by fatal signal

Yu Kuai (1):
      block: don't set GD_NEED_PART_SCAN if scan partition failed

Zheng Yejian (2):
      ftrace: Fix issue that 'direct->addr' not restored in modify_ftrace_direct()
      ring-buffer: Fix race while reader and writer are on the same page

Zhong Jinghua (1):
      scsi: iscsi_tcp: Check that sock is valid before iscsi_set_param()

Ziyang Xuan (2):
      net: qrtr: Fix a refcount bug in qrtr_recvmsg()
      ipv6: Fix an uninit variable access bug in __ip6_make_skb()

