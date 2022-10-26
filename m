Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E522B60DFBC
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiJZLjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiJZLi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:38:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA29D77F9;
        Wed, 26 Oct 2022 04:38:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54967B821D0;
        Wed, 26 Oct 2022 11:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733D2C433C1;
        Wed, 26 Oct 2022 11:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784284;
        bh=JhY/BOmzyOOWFUnzr/FX8mYOEbPL8a2DAYdvlEQmKUA=;
        h=From:To:Cc:Subject:Date:From;
        b=KejIKFEcMFJK2iypYCv0o6Gc0K8thz/+kG8Gq/0LS/UZ+e3mwzD36mO81WI2Lp9ah
         3Pl0CRCV/1FrTejBEGXp4/frXBOaPyB/fDGrYWVpKfK+xotDDl85fCVsX8pKSdu0QI
         JycaJWw2XenHDoDmOwkJSivcL66Lu7cJ/l0pr1WY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.220
Date:   Wed, 26 Oct 2022 13:38:00 +0200
Message-Id: <1666784280133215@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.220 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio                  |    2 
 Makefile                                                 |    2 
 arch/arm/Kconfig                                         |    1 
 arch/arm/boot/dts/armada-385-turris-omnia.dts            |    4 
 arch/arm/boot/dts/exynos4412-midas.dtsi                  |    2 
 arch/arm/boot/dts/exynos4412-origen.dts                  |    2 
 arch/arm/boot/dts/imx6dl.dtsi                            |    3 
 arch/arm/boot/dts/imx6q.dtsi                             |    3 
 arch/arm/boot/dts/imx6qp.dtsi                            |    6 
 arch/arm/boot/dts/imx6sl.dtsi                            |    3 
 arch/arm/boot/dts/imx6sll.dtsi                           |    3 
 arch/arm/boot/dts/imx6sx.dtsi                            |    6 
 arch/arm/boot/dts/imx7d-sdb.dts                          |    7 
 arch/arm/boot/dts/kirkwood-lsxl.dtsi                     |   16 
 arch/arm/mm/mmu.c                                        |    4 
 arch/mips/bcm47xx/prom.c                                 |    4 
 arch/powerpc/Makefile                                    |    2 
 arch/powerpc/boot/Makefile                               |    1 
 arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi          |   51 ++
 arch/powerpc/boot/dts/fsl/mpc8540ads.dts                 |    2 
 arch/powerpc/boot/dts/fsl/mpc8541cds.dts                 |    2 
 arch/powerpc/boot/dts/fsl/mpc8555cds.dts                 |    2 
 arch/powerpc/boot/dts/fsl/mpc8560ads.dts                 |    2 
 arch/powerpc/kernel/pci_dn.c                             |    1 
 arch/powerpc/math-emu/math_efp.c                         |    1 
 arch/powerpc/platforms/powernv/opal.c                    |    1 
 arch/powerpc/sysdev/fsl_msi.c                            |    2 
 arch/riscv/Makefile                                      |    2 
 arch/riscv/include/asm/io.h                              |   16 
 arch/riscv/kernel/sys_riscv.c                            |    3 
 arch/sh/include/asm/sections.h                           |    2 
 arch/sh/kernel/machvec.c                                 |   10 
 arch/um/kernel/um_arch.c                                 |    2 
 arch/x86/include/asm/hyperv-tlfs.h                       |    4 
 arch/x86/include/asm/microcode.h                         |    1 
 arch/x86/kernel/cpu/microcode/amd.c                      |    3 
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c                |   12 
 arch/x86/kvm/emulate.c                                   |    2 
 arch/x86/kvm/vmx/nested.c                                |   30 +
 arch/x86/kvm/vmx/vmx.c                                   |   12 
 crypto/akcipher.c                                        |    8 
 drivers/acpi/acpi_video.c                                |   16 
 drivers/ata/libahci_platform.c                           |   14 
 drivers/block/nbd.c                                      |    6 
 drivers/clk/bcm/clk-bcm2835.c                            |    8 
 drivers/clk/berlin/bg2.c                                 |    5 
 drivers/clk/berlin/bg2q.c                                |    6 
 drivers/clk/clk-ast2600.c                                |    2 
 drivers/clk/clk-oxnas.c                                  |    6 
 drivers/clk/mediatek/clk-mt8183-mfgcfg.c                 |    6 
 drivers/clk/meson/meson-aoclk.c                          |    5 
 drivers/clk/meson/meson-eeclk.c                          |    5 
 drivers/clk/meson/meson8b.c                              |    5 
 drivers/clk/tegra/clk-tegra114.c                         |    1 
 drivers/clk/tegra/clk-tegra20.c                          |    1 
 drivers/clk/tegra/clk-tegra210.c                         |    1 
 drivers/clk/ti/clk-dra7-atl.c                            |    9 
 drivers/clk/zynqmp/clkc.c                                |    7 
 drivers/clk/zynqmp/pll.c                                 |   31 -
 drivers/crypto/cavium/cpt/cptpf_main.c                   |    6 
 drivers/crypto/ccp/ccp-dmaengine.c                       |    6 
 drivers/dma/ioat/dma.c                                   |    6 
 drivers/firmware/efi/libstub/fdt.c                       |    8 
 drivers/firmware/google/gsmi.c                           |    9 
 drivers/fsi/fsi-core.c                                   |    3 
 drivers/gpu/drm/Kconfig                                  |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c           |    7 
 drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c          |    6 
 drivers/gpu/drm/bridge/adv7511/adv7511.h                 |    5 
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c             |    4 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c |    4 
 drivers/gpu/drm/drm_ioctl.c                              |    8 
 drivers/gpu/drm/drm_mipi_dsi.c                           |    1 
 drivers/gpu/drm/drm_panel_orientation_quirks.c           |    6 
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c                  |   12 
 drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c                 |   29 -
 drivers/gpu/drm/nouveau/nouveau_bo.c                     |    4 
 drivers/gpu/drm/nouveau/nouveau_prime.c                  |    1 
 drivers/gpu/drm/omapdrm/dss/dss.c                        |    3 
 drivers/gpu/drm/vc4/vc4_vec.c                            |    4 
 drivers/hid/hid-multitouch.c                             |    8 
 drivers/hid/hid-roccat.c                                 |    4 
 drivers/hsi/controllers/omap_ssi_core.c                  |    1 
 drivers/hsi/controllers/omap_ssi_port.c                  |    8 
 drivers/iio/adc/at91-sama5d2_adc.c                       |   14 
 drivers/iio/dac/ad5593r.c                                |   46 +-
 drivers/iio/inkern.c                                     |    6 
 drivers/iio/pressure/dps310.c                            |  262 +++++++++------
 drivers/infiniband/sw/rxe/rxe_qp.c                       |   10 
 drivers/infiniband/sw/siw/siw_qp_rx.c                    |   27 -
 drivers/iommu/omap-iommu-debug.c                         |    6 
 drivers/isdn/mISDN/l1oip.h                               |    1 
 drivers/isdn/mISDN/l1oip_core.c                          |   13 
 drivers/mailbox/bcm-flexrm-mailbox.c                     |    8 
 drivers/md/bcache/writeback.c                            |   73 ++--
 drivers/md/raid0.c                                       |    4 
 drivers/md/raid5.c                                       |   14 
 drivers/media/pci/cx88/cx88-vbi.c                        |    9 
 drivers/media/pci/cx88/cx88-video.c                      |   43 +-
 drivers/media/platform/exynos4-is/fimc-is.c              |    1 
 drivers/media/platform/xilinx/xilinx-vipp.c              |    9 
 drivers/memory/of_memory.c                               |    1 
 drivers/memory/pl353-smc.c                               |    1 
 drivers/mfd/fsl-imx25-tsadc.c                            |   34 +
 drivers/mfd/intel_soc_pmic_core.c                        |    1 
 drivers/mfd/lp8788-irq.c                                 |    3 
 drivers/mfd/lp8788.c                                     |   12 
 drivers/mfd/sm501.c                                      |    7 
 drivers/misc/ocxl/file.c                                 |    2 
 drivers/mmc/host/au1xmmc.c                               |    3 
 drivers/mmc/host/sdhci-msm.c                             |    1 
 drivers/mmc/host/sdhci-sprd.c                            |    2 
 drivers/mmc/host/wmt-sdmmc.c                             |    5 
 drivers/mtd/devices/docg3.c                              |    7 
 drivers/mtd/nand/raw/atmel/nand-controller.c             |    1 
 drivers/mtd/nand/raw/meson_nand.c                        |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h              |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c         |    3 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c        |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c         |   79 ++++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c          |    1 
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c         |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h               |    1 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c       |   10 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c          |   13 
 drivers/net/usb/r8152.c                                  |    4 
 drivers/net/wireless/ath/ath10k/mac.c                    |   54 +--
 drivers/net/wireless/ath/ath9k/htc_hst.c                 |   43 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c  |    3 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c   |   12 
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c           |   34 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    |   21 -
 drivers/nvme/host/core.c                                 |    3 
 drivers/nvme/target/tcp.c                                |   11 
 drivers/pci/setup-res.c                                  |   11 
 drivers/phy/qualcomm/phy-qcom-usb-hsic.c                 |    6 
 drivers/platform/chrome/chromeos_laptop.c                |   24 -
 drivers/platform/chrome/cros_ec_chardev.c                |    3 
 drivers/platform/x86/msi-laptop.c                        |   14 
 drivers/power/supply/adp5061.c                           |    6 
 drivers/powercap/intel_rapl_common.c                     |    3 
 drivers/regulator/qcom_rpm-regulator.c                   |   24 -
 drivers/scsi/3w-9xxx.c                                   |    2 
 drivers/scsi/libsas/sas_expander.c                       |    2 
 drivers/soc/qcom/smem_state.c                            |    3 
 drivers/soc/qcom/smsm.c                                  |   20 -
 drivers/spi/spi-omap-100k.c                              |    1 
 drivers/spi/spi-qup.c                                    |   21 -
 drivers/spi/spi-s3c64xx.c                                |    9 
 drivers/spmi/spmi-pmic-arb.c                             |   13 
 drivers/staging/media/sunxi/cedrus/cedrus.c              |    4 
 drivers/staging/rtl8723bs/core/rtw_cmd.c                 |   16 
 drivers/staging/vt6655/device_main.c                     |    8 
 drivers/thermal/intel/intel_powerclamp.c                 |    4 
 drivers/tty/serial/8250/8250_port.c                      |    7 
 drivers/tty/serial/fsl_lpuart.c                          |    2 
 drivers/tty/serial/jsm/jsm_driver.c                      |    3 
 drivers/tty/serial/xilinx_uartps.c                       |    2 
 drivers/usb/core/quirks.c                                |    4 
 drivers/usb/gadget/function/f_printer.c                  |   12 
 drivers/usb/host/xhci-mem.c                              |    7 
 drivers/usb/host/xhci.c                                  |    3 
 drivers/usb/misc/idmouse.c                               |    8 
 drivers/usb/musb/musb_gadget.c                           |    3 
 drivers/usb/storage/unusual_devs.h                       |    6 
 drivers/vhost/vsock.c                                    |    2 
 drivers/video/fbdev/smscufx.c                            |   14 
 drivers/video/fbdev/stifb.c                              |    2 
 fs/btrfs/qgroup.c                                        |   15 
 fs/btrfs/scrub.c                                         |   36 ++
 fs/cifs/file.c                                           |    9 
 fs/cifs/smb2pdu.c                                        |    4 
 fs/dlm/ast.c                                             |    6 
 fs/dlm/lock.c                                            |   16 
 fs/ext4/file.c                                           |    6 
 fs/ext4/inode.c                                          |    7 
 fs/ext4/resize.c                                         |    2 
 fs/ext4/super.c                                          |    3 
 fs/f2fs/checkpoint.c                                     |   10 
 fs/f2fs/extent_cache.c                                   |    3 
 fs/f2fs/f2fs.h                                           |    4 
 fs/f2fs/gc.c                                             |   10 
 fs/f2fs/recovery.c                                       |   23 +
 fs/f2fs/super.c                                          |    4 
 fs/io_uring.c                                            |    1 
 fs/jbd2/commit.c                                         |    2 
 fs/jbd2/transaction.c                                    |    6 
 fs/nfsd/nfs4recover.c                                    |    4 
 fs/nfsd/nfs4xdr.c                                        |    2 
 fs/nilfs2/inode.c                                        |   18 -
 fs/quota/quota_tree.c                                    |   38 ++
 fs/userfaultfd.c                                         |    4 
 include/linux/ata.h                                      |   39 +-
 include/linux/dynamic_debug.h                            |    2 
 include/linux/iova.h                                     |    2 
 include/linux/once.h                                     |   28 +
 include/linux/skbuff.h                                   |    2 
 include/linux/tcp.h                                      |    2 
 include/net/ieee802154_netdev.h                          |   12 
 include/net/sock.h                                       |    2 
 include/net/tcp.h                                        |    5 
 kernel/bpf/btf.c                                         |    2 
 kernel/bpf/syscall.c                                     |    2 
 kernel/cgroup/cpuset.c                                   |   18 -
 kernel/gcov/gcc_4_7.c                                    |   18 -
 kernel/livepatch/transition.c                            |   18 -
 kernel/trace/ftrace.c                                    |    8 
 kernel/trace/ring_buffer.c                               |   48 ++
 kernel/trace/trace.c                                     |   22 +
 lib/dynamic_debug.c                                      |   11 
 lib/once.c                                               |   30 +
 net/bluetooth/hci_sysfs.c                                |    3 
 net/bluetooth/l2cap_core.c                               |   17 
 net/can/bcm.c                                            |    7 
 net/core/stream.c                                        |    3 
 net/ieee802154/socket.c                                  |    4 
 net/ipv4/af_inet.c                                       |    2 
 net/ipv4/inet_hashtables.c                               |    4 
 net/ipv4/netfilter/nft_fib_ipv4.c                        |    3 
 net/ipv4/tcp.c                                           |   19 -
 net/ipv4/tcp_input.c                                     |    2 
 net/ipv4/tcp_ipv4.c                                      |   11 
 net/ipv4/tcp_output.c                                    |   19 -
 net/ipv4/udp.c                                           |    6 
 net/ipv6/netfilter/nft_fib_ipv6.c                        |    6 
 net/ipv6/tcp_ipv6.c                                      |   11 
 net/ipv6/udp.c                                           |    4 
 net/mac80211/cfg.c                                       |    3 
 net/openvswitch/datapath.c                               |   18 -
 net/rds/tcp.c                                            |    2 
 net/sctp/auth.c                                          |   18 -
 net/unix/garbage.c                                       |   20 +
 net/vmw_vsock/virtio_transport_common.c                  |    2 
 net/xfrm/xfrm_ipcomp.c                                   |    1 
 scripts/Kbuild.include                                   |   23 +
 scripts/selinux/install_policy.sh                        |    2 
 sound/core/pcm_dmaengine.c                               |    8 
 sound/core/rawmidi.c                                     |    2 
 sound/core/sound_oss.c                                   |   13 
 sound/pci/hda/hda_beep.c                                 |   15 
 sound/pci/hda/hda_beep.h                                 |    1 
 sound/pci/hda/patch_hdmi.c                               |    6 
 sound/pci/hda/patch_realtek.c                            |   11 
 sound/pci/hda/patch_sigmatel.c                           |   25 -
 sound/soc/codecs/wcd9335.c                               |    2 
 sound/soc/codecs/wm5102.c                                |    6 
 sound/soc/codecs/wm5110.c                                |    6 
 sound/soc/codecs/wm8997.c                                |    6 
 sound/soc/fsl/eukrea-tlv320.c                            |    8 
 sound/soc/sh/rcar/ctu.c                                  |    6 
 sound/soc/sh/rcar/dvc.c                                  |    6 
 sound/soc/sh/rcar/mix.c                                  |    6 
 sound/soc/sh/rcar/src.c                                  |    5 
 sound/soc/sh/rcar/ssi.c                                  |    4 
 sound/usb/endpoint.c                                     |    6 
 tools/bpf/bpftool/btf_dumper.c                           |    2 
 tools/bpf/bpftool/main.c                                 |   10 
 tools/perf/util/intel-pt.c                               |    9 
 258 files changed, 1846 insertions(+), 758 deletions(-)

Adrian Hunter (1):
      perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc

Albert Briscoe (1):
      usb: gadget: function: fix dangling pnp_string in f_printer.c

Alexander Aring (4):
      fs: dlm: fix race between test_bit() and queue_work()
      fs: dlm: handle -EBUSY first in lock arg validation
      net: ieee802154: return -EINVAL for unknown addr type
      Revert "net/ieee802154: reject zero-sized raw_sendmsg()"

Alexander Coffin (1):
      wifi: brcmfmac: fix use-after-free bug in brcmf_netdev_start_xmit()

Alexander Stein (6):
      ARM: dts: imx6q: add missing properties for sram
      ARM: dts: imx6dl: add missing properties for sram
      ARM: dts: imx6qp: add missing properties for sram
      ARM: dts: imx6sl: add missing properties for sram
      ARM: dts: imx6sll: add missing properties for sram
      ARM: dts: imx6sx: add missing properties for sram

Alvin Šipraga (1):
      drm: bridge: adv7511: fix CEC power down control register offset

Andreas Pape (1):
      ALSA: dmaengine: increment buffer pointer atomically

Andrew Bresticker (1):
      riscv: Allow PROT_WRITE-only mmap()

Andrew Gaul (1):
      r8152: Rate limit overflow messages

Andrew Perepechko (1):
      jbd2: wake up journal waiters in FIFO order, not LIFO

Andri Yngvason (1):
      HID: multitouch: Add memory barriers

Anna Schumaker (1):
      NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data

Anssi Hannula (4):
      can: kvaser_usb: Fix use of uninitialized completion
      can: kvaser_usb_leaf: Fix overread with an invalid command
      can: kvaser_usb_leaf: Fix TX queue out of sync after restart
      can: kvaser_usb_leaf: Fix CAN state after restart

Ard Biesheuvel (1):
      efi: libstub: drop pointless get_memory_map() call

Arvid Norlander (1):
      ACPI: video: Add Toshiba Satellite/Portege Z830 quirk

Baokun Li (1):
      ext4: fix null-ptr-deref in ext4_write_info

Bernard Metzler (1):
      RDMA/siw: Always consume all skbuf data in sk_data_ready() upcall.

Bitterblue Smith (2):
      wifi: rtl8xxxu: Fix skb misuse in TX queue selection
      wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration

Callum Osmotherly (1):
      ALSA: hda/realtek: remove ALC289_FIXUP_DUAL_SPK for Dell 5530

Chao Qin (1):
      powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue

Chao Yu (2):
      f2fs: fix to do sanity check on destination blkaddr during recovery
      f2fs: fix to do sanity check on summary info

Chen-Yu Tsai (1):
      clk: mediatek: mt8183: mfgcfg: Propagate rate changes to parent

Christophe JAILLET (7):
      nfsd: Fix a memory leak in an error handling path
      mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()
      mmc: wmt-sdmmc: Fix an error handling path in wmt_mci_probe()
      mfd: intel_soc_pmic: Fix an error handling path in intel_soc_pmic_i2c_probe()
      mfd: fsl-imx25: Fix an error handling path in mx25_tsadc_setup_irq()
      mfd: lp8788: Fix an error handling path in lp8788_probe()
      mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()

Claudiu Beznea (3):
      iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX
      iio: adc: at91-sama5d2_adc: check return status for pressure and touch
      iio: adc: at91-sama5d2_adc: lock around oversampling and sample freq

Coly Li (1):
      bcache: fix set_at_max_writeback_rate() for multiple attached devices

Dan Carpenter (7):
      wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()
      platform/chrome: fix memory corruption in ioctl
      mtd: rawnand: meson: fix bit map use in meson_nfc_ecc_correct()
      drivers: serial: jsm: fix some leaks in probe
      mfd: fsl-imx25: Fix check for platform_get_irq() errors
      iommu/omap: Fix buffer overflow in debugfs
      crypto: cavium - prevent integer overflow loading firmware

Daniel Golle (5):
      wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620
      wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620
      wifi: rt2x00: set VGC gain for both chains of MT7620
      wifi: rt2x00: set SoC wmac clock register
      wifi: rt2x00: correctly set BBP register 86 for MT7620

Dave Jiang (1):
      dmaengine: ioat: stop mod_timer from resurrecting deleted timer in __cleanup()

David Collins (1):
      spmi: pmic-arb: correct duplicate APID to PPID mapping logic

David Gow (1):
      drm/amd/display: fix overflow on MIN_I64 definition

Dmitry Baryshkov (1):
      drm/msm/dpu: index dpu_kms->hw_vbif using vbif_idx

Dmitry Osipenko (1):
      media: cedrus: Set the platform driver data earlier

Dmitry Torokhov (2):
      ARM: dts: exynos: correct s5k6a3 reset polarity on Midas family
      ARM: dts: exynos: fix polarity of VBUS GPIO of Origen

Dongliang Mu (2):
      phy: qualcomm: call clk_disable_unprepare in the error handling
      usb: idmouse: fix an uninit-value in idmouse_open

Duoming Zhou (2):
      mISDN: fix use-after-free bugs in l1oip timer handlers
      scsi: libsas: Fix use-after-free bug in smp_execute_task_sg()

Eddie James (2):
      iio: pressure: dps310: Refactor startup procedure
      iio: pressure: dps310: Reset chip after timeout

Eric Dumazet (3):
      once: add DO_ONCE_SLOW() for sleepable contexts
      tcp: annotate data-race around tcp_md5sig_pool_populated
      inet: fully convert sk->sk_rx_dst to RCU rules

Fangrui Song (1):
      riscv: Pass -mno-relax only on lld < 15.0.0

Filipe Manana (1):
      btrfs: fix race between quota enable and quota rescan ioctl

Geert Uytterhoeven (1):
      ARM: Drop CMDLINE_* dependency on ATAGS

Greg Kroah-Hartman (2):
      selinux: use "grep -E" instead of "egrep"
      Linux 5.4.220

Guilherme G. Piccoli (1):
      firmware: google: Test spinlock on panic path to avoid lockups

Haibo Chen (1):
      ARM: dts: imx7d-sdb: config the max pressure for tsc2046

Hangyu Hua (1):
      misc: ocxl: fix possible refcount leak in afu_ioctl()

Hans de Goede (3):
      platform/x86: msi-laptop: Fix old-ec check for backlight registering
      platform/x86: msi-laptop: Fix resource cleanup
      platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading

Hari Chandrakanthan (1):
      wifi: mac80211: allow bw change during channel switch in mesh

Helge Deller (1):
      parisc: fbdev/stifb: Align graphics memory size to 4MB

Huacai Chen (1):
      UM: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Hyunwoo Kim (2):
      fbdev: smscufx: Fix use-after-free in ufx_ops_open()
      HID: roccat: Fix use-after-free in roccat_read()

Ian Nam (1):
      clk: zynqmp: Fix stack-out-of-bounds in strncpy`

Ignat Korchagin (1):
      crypto: akcipher - default implementation for setting a private key

Jack Wang (2):
      HSI: omap_ssi_port: Fix dma_map_sg error check
      mailbox: bcm-ferxrm-mailbox: Fix error check for dma_map_sg

Jaegeuk Kim (1):
      f2fs: increase the limit for reserve_root

Jan Kara (1):
      ext4: avoid crash when inline data creation follows DIO write

Javier Martinez Canillas (2):
      drm: Use size_t type for len variable in drm_copy_field()
      drm: Prevent drm_copy_field() to attempt copying a NULL pointer

Jean-Francois Le Fillatre (1):
      usb: add quirks for Lenovo OneLink+ Dock

Jerry Lee 李修賢 (1):
      ext4: continue to expand file system when the target size doesn't reach

Jianglei Nie (4):
      drm/nouveau: fix a use-after-free in nouveau_gem_prime_import_sg_table()
      bnx2x: fix potential memory leak in bnx2x_tpa_stop()
      drm/nouveau/nouveau_bo: fix potential memory leak in nouveau_bo_alloc()
      usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()

Jiasheng Jiang (3):
      ASoC: rsnd: Add check for rsnd_mod_power_on
      fsi: core: Check error number after calling ida_simple_get
      mfd: sm501: Add check for platform_driver_register()

Jim Cromie (2):
      dyndbg: fix module.dyndbg handling
      dyndbg: let query-modname override actual module name

Jinke Han (1):
      ext4: place buffer head allocation before handle start

Joel Stanley (1):
      clk: ast2600: BCLK comes from EPLL

Jonathan Cameron (1):
      iio: ABI: Fix wrong format of differential capacitance channel ABI.

Junichi Uekawa (1):
      vhost/vsock: Use kvmalloc/kvfree for larger packets.

Kees Cook (3):
      sh: machvec: Use char[] for section boundaries
      x86/microcode/AMD: Track patch allocation size explicitly
      MIPS: BCM47XX: Cast memcmp() of function to (void *)

Keith Busch (1):
      nvme: copy firmware_rev on each init

Khalid Masum (1):
      xfrm: Update ipcomp_scratches with NULL when freed

Koba Ko (1):
      crypto: ccp - Release dma channels before dmaengine unrgister

Kohei Tarumizu (1):
      x86/resctrl: Fix to restore to original value when re-enabling hardware prefetch register

Krzysztof Kozlowski (1):
      ASoC: wcd9335: fix order of Slimbus unprepare/disable

Lalith Rajendran (1):
      ext4: make ext4_lazyinit_thread freezable

Lam Thai (1):
      bpftool: Fix a wrong type cast in btf_dumper_int

Lee Jones (1):
      bpf: Ensure correct locking around vulnerable function find_vpid()

Letu Ren (1):
      scsi: 3w-9xxx: Avoid disabling device if failing to enable it

Liang He (12):
      drm/omap: dss: Fix refcount leak bugs
      ASoC: eureka-tlv320: Hold reference returned from of_find_xxx API
      memory: pl353-smc: Fix refcount leak bug in pl353_smc_probe()
      memory: of: Fix refcount leak bug in of_get_ddr_timings()
      soc: qcom: smsm: Fix refcount leak bugs in qcom_smsm_probe()
      soc: qcom: smem_state: Add refcounting for the 'state->of_node'
      clk: meson: Hold reference returned by of_get_parent()
      clk: oxnas: Hold reference returned by of_get_parent()
      clk: berlin: Add of_node_put() for of_get_parent()
      media: exynos4-is: fimc-is: Add of_node_put() when breaking out of loop
      powerpc/sysdev/fsl_msi: Add missing of_node_put()
      powerpc/pci_dn: Add missing of_node_put()

Linus Walleij (1):
      regulator: qcom_rpm: Fix circular deferral regression

Liu Jian (1):
      net: If sock is dead don't access sock's sk_wq in sk_stream_wait_memory

Logan Gunthorpe (2):
      md/raid5: Ensure stripe_fill happens on non-read IO with journal
      md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d

Lorenz Bauer (1):
      bpf: btf: fix truncated last_member_type_id in btf_struct_resolve

Luiz Augusto von Dentz (2):
      Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
      Bluetooth: L2CAP: Fix user-after-free

Luke D. Jones (2):
      ALSA: hda/realtek: Correct pin configs for ASUS G533Z
      ALSA: hda/realtek: Add quirk for ASUS GV601R laptop

Maciej W. Rozycki (2):
      RISC-V: Make port I/O string accessors actually work
      PCI: Sanitise firmware BAR assignments behind a PCI-PCI bridge

Marek Behún (1):
      ARM: dts: turris-omnia: Fix mpp26 pin name and comment

Mario Limonciello (1):
      xhci: Don't show warning for reinit on known broken suspend

Martin Liska (1):
      gcov: support GCC 12.1 and newer compilers

Masahiro Yamada (1):
      kbuild: remove the target in signal traps when interrupted

Mateusz Kwiatkowski (1):
      drm/vc4: vec: Fix timings for VEC modes

Maxime Ripard (2):
      drm/mipi-dsi: Detach devices when removing the host
      clk: bcm2835: Make peripheral PLLC critical

Maya Matuszczyk (1):
      drm: panel-orientation-quirks: Add quirk for Anbernic Win600

Miaoqian Lin (6):
      clk: tegra: Fix refcount leak in tegra210_clock_init
      clk: tegra: Fix refcount leak in tegra114_clock_init
      clk: tegra20: Fix refcount leak in tegra20_clock_init
      HSI: omap_ssi: Fix refcount leak in ssi_probe
      media: xilinx: vipp: Fix refcount leak in xvip_graph_dma_init
      clk: ti: dra7-atl: Fix reference leak in of_dra7_atl_clk_probe

Michael Hennerich (1):
      iio: dac: ad5593r: Fix i2c read protocol requirements

Michael Walle (2):
      ARM: dts: kirkwood: lsxl: fix serial line
      ARM: dts: kirkwood: lsxl: remove first ethernet port

Michal Luczaj (1):
      KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Mike Pattrick (2):
      openvswitch: Fix double reporting of drops in dropwatch
      openvswitch: Fix overreporting of drops in dropwatch

Nam Cao (2):
      staging: vt6655: fix some erroneous memory clean-up loops
      staging: vt6655: fix potential memory leak

Nathan Chancellor (1):
      powerpc/math_emu/efp: Include module.h

Neal Cardwell (1):
      tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited

Nicholas Piggin (1):
      powerpc/64s: Fix GENERIC_CPU build flags for PPC970 / G5

Niklas Cassel (4):
      ata: fix ata_id_sense_reporting_enabled() and ata_id_has_sense_reporting()
      ata: fix ata_id_has_devslp()
      ata: fix ata_id_has_ncq_autosense()
      ata: fix ata_id_has_dipm()

Nuno Sá (1):
      iio: inkern: only release the device node when done with it

Ondrej Mosnacek (1):
      userfaultfd: open userfaultfds with O_RDONLY

Pali Rohár (3):
      powerpc/boot: Explicitly disable usage of SPE instructions
      serial: 8250: Fix restoring termios speed after suspend
      powerpc: Fix SPE Power ISA properties for e500v1 platforms

Pavel Begunkov (1):
      io_uring/af_unix: defer registered files gc to io_uring release

Phil Sutter (1):
      netfilter: nft_fib: Fix for rpath check with VRF devices

Qu Wenruo (1):
      btrfs: scrub: try to fix super block errors

Quanyang Wang (1):
      clk: zynqmp: pll: rectify rate rounding in zynqmp_pll_round_rate

Quentin Monnet (1):
      bpftool: Clear errno after libcap's checks

Rafael J. Wysocki (1):
      thermal: intel_powerclamp: Use first online CPU as control_cpu

Randy Dunlap (1):
      drm: fix drm_mipi_dbi build errors

Richard Acayan (1):
      mmc: sdhci-msm: add compatible string check for sdm670

Rik van Riel (1):
      livepatch: fix race between fork and KLP transition

Robin Guo (1):
      usb: musb: Fix musb_gadget.c rxstate overflow bug

Robin Murphy (1):
      iommu/iova: Fix module config properly

Ronnie Sahlberg (1):
      cifs: destage dirty pages before re-reading them for cache=none

Russell King (Oracle) (1):
      net: mvpp2: fix mvpp2 debugfs leak

Rustam Subkhankulov (1):
      platform/chrome: fix double-free in chromeos_laptop_prepare()

Ryusuke Konishi (1):
      nilfs2: fix use-after-free bug of struct nilfs_root

Saranya Gopal (1):
      ALSA: hda/realtek: Add Intel Reference SSID to support headset keys

Saurabh Sengar (1):
      md: Replace snprintf with scnprintf

Sean Christopherson (2):
      KVM: nVMX: Unconditionally purge queued/injected events on nested "exit"
      KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS

Serge Semin (1):
      ata: libahci_platform: Sanity check the DT child nodes number

Sherry Sun (1):
      tty: serial: fsl_lpuart: disable dma rx/tx use flags in lpuart_dma_shutdown

Shigeru Yoshida (1):
      nbd: Fix hung when signal interrupts nbd_start_device_ioctl()

Shubhrajyoti Datta (1):
      tty: xilinx_uartps: Fix the ignore_status

Srinivas Pandruvada (1):
      thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash

Stefan Wahren (1):
      clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration

Steven Rostedt (Google) (4):
      ring-buffer: Allow splice to read previous partially read pages
      ring-buffer: Have the shortest_full queue be the shortest not longest
      ring-buffer: Check pending waiters when doing wake ups as well
      ring-buffer: Fix race between reset page and reading page

Takashi Iwai (6):
      ALSA: oss: Fix potential deadlock at unregistration
      ALSA: rawmidi: Drop register_mutex in snd_rawmidi_free()
      ALSA: usb-audio: Fix potential memory leaks
      ALSA: usb-audio: Fix NULL dererence at error path
      ALSA: hda: beep: Simplify keep-power-at-enable behavior
      ALSA: hda/hdmi: Don't skip notification handling during PM operation

Tetsuo Handa (5):
      net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()
      net/ieee802154: reject zero-sized raw_sendmsg()
      wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()
      Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()
      net/ieee802154: don't warn zero-sized raw_sendmsg()

Tudor Ambarus (1):
      mtd: rawnand: atmel: Unmap streaming DMA mappings

Varun Prakash (1):
      nvmet-tcp: add bounds check on Transfer Tag

Vincent Whitchurch (1):
      spi: s3c64xx: Fix large transfers with DMA

Vitaly Kuznetsov (1):
      x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition

Waiman Long (2):
      tracing: Disable interrupt or preemption before acquiring arch_spinlock_t
      cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset

Wang Kefeng (1):
      ARM: 9247/1: mm: set readonly for MT_MEMORY_RO with ARM_LPAE

Wei Yongjun (1):
      power: supply: adp5061: fix out-of-bounds read in adp5061_get_chg_type()

Wen Gong (1):
      wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()

Wenchao Chen (1):
      mmc: sdhci-sprd: Fix minimum clock limit

William Dean (1):
      mtd: devices: docg3: check the return value of devm_ioremap() in the probe

Wright Feng (1):
      wifi: brcmfmac: fix invalid address access when enabling SCAN log level

Xiaoke Wang (1):
      staging: rtl8723bs: fix a potential memory leak in rtw_init_cmd_priv()

Xin Long (1):
      sctp: handle the error returned from sctp_auth_asoc_init_active_key

Xu Qiang (2):
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()
      spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()

Zhang Qilong (5):
      spi/omap100k:Fix PM disable depth imbalance in omap1_spi100k_probe
      ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe
      ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe
      ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe
      f2fs: fix race condition on setting FI_NO_EXTENT flag

Zhang Xiaoxu (1):
      cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message

Zheng Yejian (1):
      ftrace: Properly unset FTRACE_HASH_FL_MOD

Zheng Yongjun (2):
      net: fs_enet: Fix wrong check in do_pd_setup
      powerpc/powernv: add missing of_node_put() in opal_export_attrs()

Zheyu Ma (2):
      drm/bridge: megachips: Fix a null pointer dereference bug
      media: cx88: Fix a null-ptr-deref bug in buffer_prepare()

Zhihao Cheng (1):
      quota: Check next/prev free block number after reading from quota file

Zhu Yanjun (2):
      RDMA/rxe: Fix "kernel NULL pointer dereference" error
      RDMA/rxe: Fix the error caused by qp->sk

Ziyang Xuan (1):
      can: bcm: check the result of can_send() in bcm_can_tx()

hongao (1):
      drm/amdgpu: fix initial connector audio value

sunghwan jung (1):
      Revert "usb: storage: Add quirk for Samsung Fit flash"

