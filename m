Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3A0660E5C
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 12:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjAGLlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 06:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjAGLlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 06:41:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20358B52D;
        Sat,  7 Jan 2023 03:40:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22AC660BC8;
        Sat,  7 Jan 2023 11:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A0AC433D2;
        Sat,  7 Jan 2023 11:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673091645;
        bh=uWyISor/hZojdmAjfn7EFctB5Vy3ZKUzWWSSfl3UD+w=;
        h=From:To:Cc:Subject:Date:From;
        b=BWmovR2RQG+CRK7sC5sBBFwdZGpyc5bI92dUZcjj1zSKzZXSf8vLJBgOK4ejU/JLU
         a38N3nZGLhCvV60U0diqGC5uB27WJkTfZTG6AD3Lsp6OdHvzxp3WPkh/CX4QM016Rn
         /fEsBIZCyEtKaKbFmEtS1A5f5q9OfFc5R/AgR1Kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.337
Date:   Sat,  7 Jan 2023 12:40:41 +0100
Message-Id: <167309164122758@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.337 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/alpha/kernel/entry.S                                   |    4 
 arch/arm/boot/dts/armada-370.dtsi                           |    2 
 arch/arm/boot/dts/armada-375.dtsi                           |    2 
 arch/arm/boot/dts/armada-380.dtsi                           |    4 
 arch/arm/boot/dts/armada-385.dtsi                           |    6 
 arch/arm/boot/dts/armada-39x.dtsi                           |    6 
 arch/arm/boot/dts/armada-xp-mv78230.dtsi                    |    8 -
 arch/arm/boot/dts/armada-xp-mv78260.dtsi                    |   16 +-
 arch/arm/boot/dts/dove.dtsi                                 |    2 
 arch/arm/boot/dts/spear600.dtsi                             |    2 
 arch/arm/mach-mmp/time.c                                    |   11 +
 arch/arm/nwfpe/Makefile                                     |    6 
 arch/mips/bcm63xx/clk.c                                     |    2 
 arch/mips/kernel/vpe-cmp.c                                  |    4 
 arch/mips/kernel/vpe-mt.c                                   |    4 
 arch/powerpc/kernel/rtas.c                                  |    7 -
 arch/powerpc/perf/callchain.c                               |    1 
 arch/powerpc/perf/hv-gpci-requests.h                        |    4 
 arch/powerpc/perf/hv-gpci.c                                 |   33 ++++
 arch/powerpc/perf/hv-gpci.h                                 |    1 
 arch/powerpc/perf/req-gen/perf.h                            |   20 ++
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c               |    1 
 arch/powerpc/platforms/83xx/mpc832x_rdb.c                   |    2 
 arch/x86/kernel/uprobes.c                                   |    4 
 arch/x86/xen/spinlock.c                                     |    6 
 block/blk-mq-sysfs.c                                        |   11 +
 block/partition-generic.c                                   |    6 
 drivers/acpi/acpica/dsmethod.c                              |   10 +
 drivers/acpi/acpica/utcopy.c                                |    7 -
 drivers/bluetooth/btusb.c                                   |    6 
 drivers/bluetooth/hci_bcsp.c                                |    2 
 drivers/bluetooth/hci_h5.c                                  |    2 
 drivers/bluetooth/hci_qca.c                                 |    2 
 drivers/char/hw_random/amd-rng.c                            |   18 +-
 drivers/char/hw_random/geode-rng.c                          |   36 ++++-
 drivers/char/ipmi/ipmi_msghandler.c                         |    8 -
 drivers/clk/rockchip/clk-pll.c                              |    1 
 drivers/clk/st/clkgen-fsyn.c                                |    5 
 drivers/cpuidle/dt_idle_states.c                            |    2 
 drivers/crypto/img-hash.c                                   |    8 -
 drivers/crypto/n2_core.c                                    |    6 
 drivers/dio/dio.c                                           |    8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c                    |    1 
 drivers/gpu/drm/drm_connector.c                             |    3 
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c                   |    5 
 drivers/gpu/drm/radeon/radeon_bios.c                        |    1 
 drivers/gpu/drm/sti/sti_dvo.c                               |    7 -
 drivers/gpu/drm/sti/sti_hda.c                               |    7 -
 drivers/gpu/drm/sti/sti_hdmi.c                              |    7 -
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                         |    3 
 drivers/hid/hid-ids.h                                       |    3 
 drivers/hid/hid-plantronics.c                               |    9 +
 drivers/hid/hid-sensor-custom.c                             |    2 
 drivers/hid/wacom_sys.c                                     |    8 +
 drivers/hid/wacom_wac.c                                     |    4 
 drivers/hid/wacom_wac.h                                     |    1 
 drivers/hsi/controllers/omap_ssi_core.c                     |   14 +-
 drivers/i2c/busses/i2c-ismt.c                               |    3 
 drivers/i2c/busses/i2c-pxa-pci.c                            |   10 -
 drivers/iio/adc/ad_sigma_delta.c                            |    8 -
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c                |    7 +
 drivers/input/touchscreen/elants_i2c.c                      |    9 -
 drivers/iommu/amd_iommu_init.c                              |    7 +
 drivers/iommu/fsl_pamu.c                                    |    2 
 drivers/irqchip/irq-gic-pm.c                                |    2 
 drivers/isdn/hardware/mISDN/hfcmulti.c                      |   19 +-
 drivers/isdn/hardware/mISDN/hfcpci.c                        |   13 +
 drivers/isdn/hardware/mISDN/hfcsusb.c                       |   12 +
 drivers/macintosh/macio-adb.c                               |    4 
 drivers/macintosh/macio_asic.c                              |    2 
 drivers/mcb/mcb-core.c                                      |    4 
 drivers/mcb/mcb-parse.c                                     |    2 
 drivers/md/dm-cache-metadata.c                              |   55 ++++++-
 drivers/md/dm-cache-target.c                                |   11 -
 drivers/md/dm-thin-metadata.c                               |    9 +
 drivers/md/dm-thin.c                                        |    2 
 drivers/md/md.c                                             |    9 -
 drivers/md/raid1.c                                          |    1 
 drivers/media/dvb-core/dvbdev.c                             |    1 
 drivers/media/dvb-frontends/bcm3510.c                       |    1 
 drivers/media/dvb-frontends/stv0288.c                       |    5 
 drivers/media/i2c/ad5820.c                                  |   10 -
 drivers/media/pci/saa7164/saa7164-core.c                    |    4 
 drivers/media/pci/solo6x10/solo6x10-core.c                  |    1 
 drivers/media/platform/coda/coda-bit.c                      |   14 +-
 drivers/media/platform/exynos4-is/fimc-core.c               |    2 
 drivers/media/platform/exynos4-is/media-dev.c               |    6 
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c       |    1 
 drivers/media/platform/vivid/vivid-vid-cap.c                |    1 
 drivers/media/radio/si470x/radio-si470x-usb.c               |    4 
 drivers/media/rc/imon.c                                     |    6 
 drivers/media/usb/dvb-usb/az6027.c                          |    4 
 drivers/media/usb/dvb-usb/dvb-usb-init.c                    |    4 
 drivers/misc/cxl/guest.c                                    |   24 ++-
 drivers/misc/cxl/pci.c                                      |   20 +-
 drivers/misc/sgi-gru/grufault.c                             |   13 +
 drivers/misc/sgi-gru/grumain.c                              |   22 ++-
 drivers/misc/sgi-gru/grutables.h                            |    2 
 drivers/misc/tifm_7xx1.c                                    |    2 
 drivers/mmc/host/mmci.c                                     |    4 
 drivers/mmc/host/moxart-mmc.c                               |    4 
 drivers/mmc/host/mxcmmc.c                                   |    4 
 drivers/mmc/host/rtsx_usb_sdmmc.c                           |   11 +
 drivers/mmc/host/sdhci_f_sdh30.c                            |    3 
 drivers/mmc/host/toshsd.c                                   |    6 
 drivers/mmc/host/via-sdmmc.c                                |    4 
 drivers/mmc/host/vub300.c                                   |   13 +
 drivers/mmc/host/wbsd.c                                     |   12 +
 drivers/mtd/lpddr/lpddr2_nvm.c                              |    2 
 drivers/mtd/maps/pxa2xx-flash.c                             |    2 
 drivers/mtd/mtdcore.c                                       |    4 
 drivers/net/bonding/bond_main.c                             |    2 
 drivers/net/ethernet/amd/atarilance.c                       |    2 
 drivers/net/ethernet/amd/lance.c                            |    2 
 drivers/net/ethernet/apple/bmac.c                           |    2 
 drivers/net/ethernet/apple/mace.c                           |    2 
 drivers/net/ethernet/dnet.c                                 |    4 
 drivers/net/ethernet/intel/igb/igb_main.c                   |    8 -
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c            |    1 
 drivers/net/ethernet/neterion/s2io.c                        |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c    |    2 
 drivers/net/ethernet/rdc/r6040.c                            |    5 
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c       |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h            |    2 
 drivers/net/ethernet/ti/netcp_core.c                        |    2 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c               |    2 
 drivers/net/fddi/defxx.c                                    |   22 ++-
 drivers/net/hamradio/baycom_epp.c                           |    2 
 drivers/net/hamradio/scc.c                                  |    6 
 drivers/net/loopback.c                                      |    2 
 drivers/net/ntb_netdev.c                                    |    4 
 drivers/net/ppp/ppp_generic.c                               |    2 
 drivers/net/wan/farsync.c                                   |    2 
 drivers/net/wireless/ath/ar5523/ar5523.c                    |    6 
 drivers/net/wireless/ath/ath10k/pci.c                       |   20 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c                    |   46 ++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c |    5 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c     |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     |    1 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h            |    2 
 drivers/nfc/pn533/pn533.c                                   |    4 
 drivers/parisc/led.c                                        |    3 
 drivers/pci/pci-sysfs.c                                     |   13 +
 drivers/pinctrl/pinconf-generic.c                           |    4 
 drivers/pnp/core.c                                          |    4 
 drivers/power/avs/smartreflex.c                             |    1 
 drivers/power/supply/power_supply_core.c                    |    2 
 drivers/rapidio/devices/rio_mport_cdev.c                    |   15 +-
 drivers/rapidio/rio-scan.c                                  |    8 -
 drivers/rapidio/rio.c                                       |    9 +
 drivers/regulator/core.c                                    |    2 
 drivers/rtc/rtc-snvs.c                                      |   16 ++
 drivers/rtc/rtc-st-lpc.c                                    |    1 
 drivers/s390/net/ctcm_main.c                                |   11 -
 drivers/s390/net/lcs.c                                      |    8 -
 drivers/s390/net/netiucv.c                                  |    9 -
 drivers/scsi/fcoe/fcoe.c                                    |    1 
 drivers/scsi/fcoe/fcoe_sysfs.c                              |   19 +-
 drivers/scsi/hpsa.c                                         |    7 -
 drivers/scsi/ipr.c                                          |   10 +
 drivers/scsi/snic/snic_disc.c                               |    3 
 drivers/soc/ti/knav_qmss_queue.c                            |    2 
 drivers/soc/ux500/ux500-soc-id.c                            |   10 -
 drivers/staging/rtl8192e/rtllib_rx.c                        |    2 
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c           |    4 
 drivers/tty/serial/amba-pl011.c                             |    3 
 drivers/tty/serial/pch_uart.c                               |    4 
 drivers/tty/serial/sunsab.c                                 |    8 +
 drivers/uio/uio_dmem_genirq.c                               |   13 +
 drivers/usb/gadget/function/f_uvc.c                         |    5 
 drivers/usb/gadget/udc/fotg210-udc.c                        |   12 -
 drivers/usb/serial/cp210x.c                                 |    2 
 drivers/usb/storage/alauda.c                                |    2 
 drivers/vfio/platform/vfio_platform_common.c                |    3 
 drivers/video/fbdev/Kconfig                                 |    1 
 drivers/video/fbdev/pm2fb.c                                 |    9 +
 drivers/video/fbdev/uvesafb.c                               |    1 
 drivers/video/fbdev/vermilion/vermilion.c                   |    4 
 drivers/video/fbdev/via/via-core.c                          |    9 +
 drivers/vme/bridges/vme_fake.c                              |    2 
 drivers/vme/bridges/vme_tsi148.c                            |    1 
 fs/binfmt_misc.c                                            |    8 -
 fs/char_dev.c                                               |    2 
 fs/cifs/connect.c                                           |    4 
 fs/ext4/ext4.h                                              |    2 
 fs/ext4/indirect.c                                          |    9 +
 fs/ext4/inode.c                                             |   10 +
 fs/ext4/ioctl.c                                             |   10 -
 fs/ext4/namei.c                                             |    3 
 fs/ext4/xattr.c                                             |    8 -
 fs/hfs/inode.c                                              |    2 
 fs/hfs/trans.c                                              |    2 
 fs/hfsplus/hfsplus_fs.h                                     |    2 
 fs/hfsplus/inode.c                                          |    4 
 fs/hfsplus/options.c                                        |    4 
 fs/jfs/jfs_dmap.c                                           |   27 +++
 fs/libfs.c                                                  |   22 ++-
 fs/nfs/nfs4proc.c                                           |   19 +-
 fs/nfs/nfs4xdr.c                                            |   10 -
 fs/nfsd/nfs4callback.c                                      |    4 
 fs/nilfs2/the_nilfs.c                                       |   31 +++-
 fs/ocfs2/stackglue.c                                        |    8 +
 fs/orangefs/orangefs-debugfs.c                              |    3 
 fs/orangefs/orangefs-mod.c                                  |    8 -
 fs/pnode.c                                                  |    2 
 fs/pstore/ram_core.c                                        |    6 
 fs/reiserfs/namei.c                                         |    4 
 fs/reiserfs/xattr_security.c                                |    2 
 fs/sysv/itree.c                                             |    2 
 fs/udf/balloc.c                                             |    5 
 fs/udf/inode.c                                              |   84 +++++-------
 fs/udf/namei.c                                              |    8 -
 fs/udf/truncate.c                                           |   48 ++----
 fs/udf/udfdecl.h                                            |    3 
 fs/xattr.c                                                  |    2 
 include/asm-generic/tlb.h                                   |    6 
 include/linux/can/platform/sja1000.h                        |    2 
 include/linux/eventfd.h                                     |    2 
 include/linux/fs.h                                          |   12 +
 include/linux/timerqueue.h                                  |    2 
 include/net/mrp.h                                           |    1 
 include/uapi/linux/swab.h                                   |    2 
 include/uapi/sound/asequencer.h                             |    8 -
 kernel/acct.c                                               |    2 
 kernel/events/core.c                                        |    8 -
 kernel/gcov/gcc_4_7.c                                       |    5 
 kernel/power/snapshot.c                                     |    4 
 kernel/trace/blktrace.c                                     |    3 
 kernel/trace/trace.c                                        |   15 ++
 lib/notifier-error-inject.c                                 |    2 
 mm/khugepaged.c                                             |   24 +++
 mm/memory.c                                                 |    5 
 net/802/mrp.c                                               |   18 +-
 net/bluetooth/hci_core.c                                    |    2 
 net/bluetooth/l2cap_core.c                                  |    3 
 net/core/skbuff.c                                           |    3 
 net/core/stream.c                                           |    6 
 net/ipv4/udp_tunnel.c                                       |    1 
 net/openvswitch/datapath.c                                  |   25 ++-
 net/sched/ematch.c                                          |    2 
 net/sunrpc/clnt.c                                           |    2 
 net/vmw_vsock/vmci_transport.c                              |    6 
 security/device_cgroup.c                                    |   33 ++++
 security/integrity/ima/ima_template.c                       |    4 
 sound/drivers/mts64.c                                       |    3 
 sound/pci/asihpi/hpioctl.c                                  |    2 
 sound/soc/codecs/pcm512x.c                                  |    8 -
 sound/soc/codecs/rt5670.c                                   |    2 
 sound/soc/codecs/wm8994.c                                   |    5 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c            |    7 -
 sound/soc/pxa/mmp-pcm.c                                     |    2 
 sound/soc/rockchip/rockchip_spdif.c                         |    1 
 sound/soc/soc-ops.c                                         |    9 +
 sound/usb/line6/driver.c                                    |    3 
 sound/usb/line6/midi.c                                      |    6 
 sound/usb/line6/midibuf.c                                   |   25 ++-
 sound/usb/line6/midibuf.h                                   |    5 
 sound/usb/line6/pod.c                                       |    3 
 tools/testing/ktest/ktest.pl                                |    3 
 tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c      |    5 
 261 files changed, 1296 insertions(+), 559 deletions(-)

Aditya Garg (1):
      hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount

Akinobu Mita (2):
      libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value
      lib/notifier-error-inject: fix error when writing -errno to debugfs file

Al Viro (1):
      alpha: fix syscall entry in !AUDUT_SYSCALL case

Anastasia Belova (1):
      MIPS: BCM63xx: Add check for NULL for clk in clk_enable

Andy Shevchenko (1):
      fbdev: ssd1307fb: Drop optional dependency

Artem Chernyshev (1):
      net: vmw_vsock: vmci: Check memcpy_from_msg()

Artem Egorkine (2):
      ALSA: line6: correct midi status byte when receiving data from podxt
      ALSA: line6: fix stack overflow in line6_midi_transmit

Baisong Zhong (2):
      ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT
      media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()

Baokun Li (2):
      ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop
      ext4: fix bug_on in __es_tree_search caused by bad boot loader inode

Barnabás Pőcze (1):
      timerqueue: Use rb_entry_safe() in timerqueue_getnext()

Bitterblue Smith (1):
      wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h

Bruno Thomsen (1):
      USB: serial: cp210x: add Kamstrup RF sniffer PIDs

Cai Xinchen (1):
      rapidio: devices: fix missing put_device in mport_cdev_open

Charles Keepax (1):
      ASoC: ops: Correct bounds check for second channel on SX controls

Chen Jiahao (1):
      drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Chen Zhongjin (4):
      perf: Fix possible memleak in pmu_dev_alloc()
      fs: sysv: Fix sysv_nblocks() returns wrong value
      scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails
      vme: Fix error not catched in fake_init()

Christian Brauner (1):
      pnode: terminate at peers of source

Christophe JAILLET (3):
      fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()
      powerpc/52xx: Fix a resource leak in an error handling path
      myri10ge: Fix an error handling path in myri10ge_probe()

Cong Wang (1):
      net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Corentin Labbe (1):
      crypto: n2 - add missing hash statesize

Dan Aloni (1):
      nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Dan Carpenter (2):
      bonding: uninitialized variable in bond_miimon_inspect()
      staging: rtl8192u: Fix use after free in ieee80211_rx()

Deren Wu (1):
      mmc: vub300: fix warning - do not call blocking ops when !TASK_RUNNING

Dongliang Mu (1):
      fs: jfs: fix shift-out-of-bounds in dbAllocAG

Doug Brown (1):
      ARM: mmp: fix timer_read delay

Douglas Anderson (1):
      Input: elants_i2c - properly handle the reset GPIO when power is off

Dragos Tatulea (1):
      IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces

Eelco Chaudron (1):
      openvswitch: Fix flow lookup to use unmasked key

Eric Dumazet (1):
      net: stream: purge sk_error_queue in sk_stream_kill_queues()

Eric Pilmore (1):
      ntb_netdev: Use dev_kfree_skb_any() in interrupt context

Fedor Pchelkin (3):
      wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()
      wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
      wifi: ath9k: verify the expected usb_endpoints are present

Gaosheng Cui (6):
      ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt
      scsi: snic: Fix possible UAF in snic_tgt_create()
      crypto: img-hash - Fix variable dereferenced before check 'hdev->req'
      staging: vme_user: Fix possible UAF in tsi148_dma_list_add
      rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()
      ext4: fix undefined behavior in bit shift for ext4_check_flag_values

Gautam Menghani (1):
      media: imon: fix a race condition in send_packet()

Greg Kroah-Hartman (1):
      Linux 4.9.337

Hangbin Liu (1):
      net/tunnel: wait until all sk_user_data reader finish before releasing the sock

Hans de Goede (1):
      ASoC: rt5670: Remove unbalanced pm_runtime_put()

Heiko Schocher (1):
      can: sja1000: fix size of OCR_MODE_MASK define

Hoi Pok Wu (1):
      fs: jfs: fix shift-out-of-bounds in dbDiscardAG

Hui Tang (2):
      mtd: lpddr2_nvm: Fix possible null-ptr-deref
      i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe

Jan Kara (7):
      udf: Discard preallocation before extending file with a hole
      udf: Drop unused arguments of udf_delete_aext()
      udf: Fix preallocation discarding at indirect extent boundary
      udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size
      udf: Fix extending file within last block
      ext4: avoid BUG_ON when creating xattrs
      ext4: initialize quota before expanding inode in setproject ioctl

Jann Horn (2):
      mm/khugepaged: fix GUP-fast interaction by sending IPI
      mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths

Jason A. Donenfeld (2):
      media: stv0288: use explicitly signed char
      ARM: ux500: do not directly dereference __iomem

Jason Gerecke (1):
      HID: wacom: Ensure bootloader PID is usable in hidraw mode

Jiamei Xie (1):
      serial: amba-pl011: avoid SBSA UART accessing DMACR register

Jiang Li (1):
      md/raid1: stop mdx_raid1 thread when raid1 array run failed

Jiasheng Jiang (3):
      media: coda: Add check for dcoda_iram_alloc
      media: coda: Add check for kmalloc
      usb: storage: Add check for kcalloc

Kajol Jain (1):
      powerpc/hv-gpci: Fix hv_gpci event list

Kees Cook (1):
      igb: Do not free q_vector unless new one was allocated

Keita Suzuki (1):
      media: dvb-core: Fix double free in dvb_register_device()

Kim Phillips (1):
      iommu/amd: Fix ivrs_acpihid cmdline parsing code

Kory Maincent (1):
      arm: dts: spear600: Fix clcd interrupt

Kunihiko Hayashi (1):
      mmc: f-sdh30: Add quirks for broken timeout clock capability

Li Zetao (3):
      ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()
      net: farsync: Fix kmemleak when rmmods farsync
      r6040: Fix kmemleak in probe and remove

Liang He (1):
      media: c8sectpfe: Add of_node_put() when breaking out of loop

Linus Walleij (1):
      usb: fotg210-udc: Fix ages old endianness issues

Liu Shixin (4):
      media: vivid: fix compose size exceed boundary
      ALSA: asihpi: fix missing pci_disable_device()
      media: saa7164: fix missing pci_disable_device()
      binfmt_misc: fix shift-out-of-bounds in check_special_flags

Luo Meng (2):
      dm thin: Fix UAF in run_timer_softirq()
      dm cache: Fix UAF in destroy()

Luís Henriques (1):
      ext4: fix error code return to user-space in ext4_get_branch()

Marcus Folkesson (1):
      HID: hid-sensor-custom: set fixed size for custom attributes

Marek Szyprowski (1):
      ASoC: wm8994: Fix potential deadlock

Mark Brown (1):
      ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()

Matt Redfearn (1):
      include/uapi/linux/swab: Fix potentially missing __always_inline

Mazin Al Haddad (1):
      media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Miaoqian Lin (1):
      selftests/powerpc: Fix resource leaks

Mike Snitzer (2):
      dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort
      dm cache: set needs_check flag after aborting metadata

Mikulas Patocka (1):
      md: fix a crash in mempool_free

Ming Lei (1):
      block: unhash blkdev part inode when the part is deleted

Minsuk Kang (2):
      nfc: pn533: Clear nfc_target before being used
      wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()

Nathan Chancellor (7):
      net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
      hamradio: baycom_epp: Fix return type of baycom_send_packet()
      s390/ctcm: Fix return type of ctc{mp,}m_tx()
      s390/netiucv: Fix return type of netiucv_tx()
      s390/lcs: Fix return type of lcs_start_xmit()
      drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
      drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

Nathan Lynch (1):
      powerpc/rtas: avoid scheduling in rtas_os_term()

Nicholas Piggin (1):
      powerpc/perf: callchain validate kernel stack pointer bounds

Nick Desaulniers (1):
      ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod

Nuno Sá (1):
      iio: adc: ad_sigma_delta: do not use internal iio_dev lock

Oleg Nesterov (1):
      uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix

Ondrej Mosnacek (1):
      fs: don't audit the capability check in simple_xattr_list()

Pali Rohár (6):
      ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-370: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-xp: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-375: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-38x: Fix assigned-addresses for every PCIe Root Port
      ARM: dts: armada-39x: Fix assigned-addresses for every PCIe Root Port

Paulo Alcantara (1):
      cifs: fix confusing debug message

Piergiorgio Beruto (1):
      stmmac: fix potential division by 0

Rafael J. Wysocki (1):
      ACPICA: Fix error code path in acpi_ds_call_control_method()

Rafael Mendonca (3):
      vfio: platform: Do not pass return buffer to ACPI _RST method
      uio: uio_dmem_genirq: Fix missing unlock in irq configuration
      uio: uio_dmem_genirq: Fix deadlock between irq config and handling

Rasmus Villemoes (1):
      net: loopback: use NET_NAME_PREDICTABLE for name_assign_type

Ricardo Ribalda (1):
      media: i2c: ad5820: Fix error path

Rickard x Andersson (1):
      gcov: add support for checksum field

Roberto Sassu (1):
      reiserfs: Add missing calls to reiserfs_security_free()

Ryusuke Konishi (1):
      nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()

Sascha Hauer (1):
      PCI/sysfs: Fix double free in error path

Schspa Shi (1):
      mrp: introduce active flags to prevent UAF when applicant uninit

Shang XiaoJing (5):
      ocfs2: fix memory leak in ocfs2_stack_glue_init()
      irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()
      scsi: ipr: Fix WARNING in ipr_init()
      fbdev: via: Fix error in via_core_init()
      parisc: led: Fix potential null-ptr-deref in start_task()

Shigeru Yoshida (3):
      udf: Avoid double brelse() in udf_rename()
      wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out
      media: si470x: Fix use-after-free in si470x_int_in_callback()

Simon Ser (1):
      drm/connector: send hotplug uevent on connector cleanup

Stanislav Fomichev (1):
      ppp: associate skb with a device at tx

Stefan Eichenberger (1):
      rtc: snvs: Allow a time difference on clock register read

Stephen Boyd (1):
      pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP

Steven Rostedt (1):
      ktest.pl minconfig: Unset configs instead of just removing them

Subash Abhinov Kasiviswanathan (1):
      skbuff: Account for tail adjustment during pull operations

Sungwoo Kim (1):
      Bluetooth: L2CAP: Fix u8 overflow

Szymon Heidrich (1):
      usb: gadget: uvc: Prevent buffer overflow in setup handler

Terry Junge (1):
      HID: plantronics: Additional PIDs for double volume key presses quirk

Trond Myklebust (2):
      NFSv4.2: Fix a memory stomp in decode_attr_security_label
      NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn

Ulf Hansson (1):
      cpuidle: dt: Return the correct numbers of parsed idle states

Ville Syrjälä (1):
      drm/sti: Use drm_mode_copy()

Wang Jingjin (1):
      ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()

Wang ShaoBo (1):
      SUNRPC: Fix missing release socket in rpc_sockname()

Wang Weiyang (2):
      rapidio: fix possible UAF when kfifo_alloc() fails
      device_cgroup: Roll back to original exceptions after copy failure

Wang Yufen (2):
      wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
      ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()

Xie Shaowen (1):
      macintosh/macio-adb: check the return value of ioremap()

Xiongfeng Wang (6):
      drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()
      drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()
      hwrng: amd - Fix PCI device refcount leak
      hwrng: geode - Fix PCI device refcount leak
      serial: pch: Fix PCI device refcount leak in pch_request_dma()
      fbdev: vermilion: decrease reference count in error path

Xiu Jianfeng (5):
      x86/xen: Fix memory leak in xen_init_lock_cpu()
      ima: Fix misuse of dereference of pointer in template_desc_init_fields()
      wifi: ath10k: Fix return value in ath10k_pci_init()
      clk: rockchip: Fix memory leak in rockchip_clk_register_pll()
      clk: st: Fix memory leak in st_of_quadfs_setup()

Yan Lei (1):
      media: dvb-frontends: fix leak of memory fw

Yang Jihong (2):
      blktrace: Fix output non-blktrace event when blk_classic option enabled
      tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Yang Yingliang (44):
      MIPS: vpe-mt: fix possible memory leak while module exiting
      MIPS: vpe-cmp: fix possible memory leak while module exiting
      PNP: fix name memory leak in pnp_alloc_dev()
      rapidio: fix possible name leaks when rio_add_device() fails
      rapidio: rio: fix possible name leak in rio_register_mport()
      regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()
      media: solo6x10: fix possible memory leak in solo_sysfs_init()
      regulator: core: fix module refcount leak in set_supply()
      mmc: moxart: fix return value check of mmc_add_host()
      mmc: mxcmmc: fix return value check of mmc_add_host()
      mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()
      mmc: toshsd: fix return value check of mmc_add_host()
      mmc: vub300: fix return value check of mmc_add_host()
      mmc: via-sdmmc: fix return value check of mmc_add_host()
      mmc: wbsd: fix return value check of mmc_add_host()
      mmc: mmci: fix return value check of mmc_add_host()
      ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: ethernet: dnet: don't call dev_kfree_skb() under spin_lock_irqsave()
      hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()
      Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_h5: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_bcsp: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_core: don't call kfree_skb() under spin_lock_irqsave()
      scsi: hpsa: Fix error handling in hpsa_add_sas_host()
      scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()
      scsi: fcoe: Fix possible name leak when device_register() fails
      drivers: dio: fix possible memory leak in dio_init()
      cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()
      cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()
      mcb: mcb-parse: fix error handing in chameleon_parse_gdd()
      chardev: fix error handling in cdev_device_add()
      fbdev: pm2fb: fix missing pci_disable_device()
      HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()
      HSI: omap_ssi_core: fix possible memory leak in ssi_probe()
      macintosh: fix possible memory leak in macio_add_one_device()
      powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()
      mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Ye Bin (2):
      blk-mq: fix possible memleak when register 'hctx' failed
      ext4: init quota for 'old.inode' in 'ext4_rename'

Yongqiang Liu (1):
      net: defxx: Fix missing err handling in dfx_init()

Yuan Can (5):
      media: platform: exynos4-is: Fix error handling in fimc_md_init()
      drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
      serial: sunsab: Fix error handling in sunsab_init()
      HSI: omap_ssi_core: Fix error handling in ssi_init()
      iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()

YueHaibing (1):
      staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()

Zack Rusin (1):
      drm/vmwgfx: Validate the box size for the snooped cursor

Zeng Heng (2):
      ASoC: pxa: fix null-pointer dereference in filter()
      power: supply: fix residue sysfs file in error handle route of __power_supply_register()

Zhang Qilong (3):
      soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe
      eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
      ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe

Zhang Xiaoxu (3):
      mtd: Fix device name leak when register device failed in add_mtd_device()
      orangefs: Fix sysfs not cleanup when dev init failed
      orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()

Zhang Yuchen (1):
      ipmi: fix memleak when unload ipmi driver

ZhangPeng (3):
      hfs: Fix OOB Write in hfs_asc2mac
      pinctrl: pinconf-generic: add missing of_node_put()
      hfs: fix OOB Read in __hfs_brec_find

Zheng Wang (1):
      misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os

Zheng Yejian (1):
      acct: fix potential integer overflow in encode_comp_t()

Zheng Yongjun (1):
      mtd: maps: pxa2xx-flash: fix memory leak in probe

Zhengchao Shao (1):
      drivers: mcb: fix resource leak in mcb_probe()

Zheyu Ma (1):
      i2c: ismt: Fix an out-of-bounds bug in ismt_access()

Zhihao Cheng (1):
      dm thin: Use last transaction's pmd->root when commit failed

ruanjinjie (1):
      misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()

xiongxin (1):
      PM: hibernate: Fix mistake in kerneldoc comment

