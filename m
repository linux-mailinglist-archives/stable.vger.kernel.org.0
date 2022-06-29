Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EA555F8B4
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 09:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiF2HRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 03:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiF2HRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 03:17:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73291340E5;
        Wed, 29 Jun 2022 00:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0081461B53;
        Wed, 29 Jun 2022 07:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF425C3411E;
        Wed, 29 Jun 2022 07:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656487043;
        bh=ywxlciWiQblJ4kOvZ0D/QsXZj7RU+AId7bng3cNxmUc=;
        h=From:To:Cc:Subject:Date:From;
        b=Cm6qbuyPwjfjS4gcokhcFjHfnT2GiBsmCWP1mOHsg+nD1Lx4legnYznZCit/R3KWw
         iiMdN993xneY/V8qTKlDzCcp3BTpE3DDX2l/xTa4P/lur79Xltq23mW61+rSeTP9Cf
         s95ZpdKUN/t1XVT8THkJiG9Mw6i6po9MBNIoSnIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.8
Date:   Wed, 29 Jun 2022 09:17:08 +0200
Message-Id: <165648702810072@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.18.8 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio-vf610               |    2 
 Documentation/devicetree/bindings/usb/generic-ehci.yaml     |    3 
 Documentation/devicetree/bindings/usb/generic-ohci.yaml     |    3 
 Documentation/vm/hwpoison.rst                               |    3 
 MAINTAINERS                                                 |   11 
 Makefile                                                    |    4 
 arch/arm/boot/dts/bcm2711-rpi-400.dts                       |    6 
 arch/arm/boot/dts/imx6qdl.dtsi                              |    2 
 arch/arm/boot/dts/imx7s.dtsi                                |    2 
 arch/arm/kernel/crash_dump.c                                |   27 --
 arch/arm/mach-axxia/platsmp.c                               |    1 
 arch/arm/mach-cns3xxx/core.c                                |    2 
 arch/arm/mach-exynos/exynos.c                               |    1 
 arch/arm64/boot/dts/exynos/exynos7885.dtsi                  |   12 
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi                    |    2 
 arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi                  |    2 
 arch/arm64/kernel/crash_dump.c                              |   29 --
 arch/arm64/kvm/arm.c                                        |    6 
 arch/ia64/kernel/crash_dump.c                               |   32 --
 arch/mips/kernel/crash_dump.c                               |   27 --
 arch/mips/vr41xx/common/icu.c                               |    2 
 arch/parisc/Kconfig                                         |    1 
 arch/parisc/include/asm/fb.h                                |    2 
 arch/parisc/kernel/cache.c                                  |    5 
 arch/powerpc/kernel/crash_dump.c                            |   35 --
 arch/powerpc/kernel/process.c                               |    2 
 arch/powerpc/kernel/rtas.c                                  |   11 
 arch/powerpc/platforms/microwatt/microwatt.h                |    7 
 arch/powerpc/platforms/microwatt/rng.c                      |   10 
 arch/powerpc/platforms/microwatt/setup.c                    |    8 
 arch/powerpc/platforms/powernv/powernv.h                    |    2 
 arch/powerpc/platforms/powernv/rng.c                        |   52 ++-
 arch/powerpc/platforms/powernv/setup.c                      |    2 
 arch/powerpc/platforms/pseries/pseries.h                    |    2 
 arch/powerpc/platforms/pseries/rng.c                        |   11 
 arch/powerpc/platforms/pseries/setup.c                      |    2 
 arch/riscv/kernel/crash_dump.c                              |   26 -
 arch/s390/kernel/crash_dump.c                               |   23 +
 arch/s390/kernel/perf_cpum_cf.c                             |   22 +
 arch/sh/kernel/crash_dump.c                                 |   29 --
 arch/x86/kernel/crash_dump_32.c                             |   29 --
 arch/x86/kernel/crash_dump_64.c                             |   41 ---
 arch/x86/kvm/svm/sev.c                                      |   68 +++--
 arch/x86/kvm/svm/svm.c                                      |   11 
 arch/x86/kvm/svm/svm.h                                      |    2 
 arch/x86/net/bpf_jit_comp.c                                 |    3 
 arch/xtensa/kernel/time.c                                   |    1 
 arch/xtensa/platforms/xtfpga/setup.c                        |    1 
 block/blk-core.c                                            |   13 
 block/blk-mq.c                                              |   11 
 block/genhd.c                                               |   39 --
 drivers/base/memory.c                                       |    2 
 drivers/base/regmap/regmap-irq.c                            |    8 
 drivers/block/xen-blkfront.c                                |   19 -
 drivers/char/random.c                                       |    6 
 drivers/dma-buf/udmabuf.c                                   |    5 
 drivers/gpio/gpio-vr41xx.c                                  |    2 
 drivers/gpio/gpio-winbond.c                                 |    7 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c            |    2 
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c |   24 -
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c            |    3 
 drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c          |    3 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c            |    3 
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c               |    4 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c                     |    3 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c                    |    2 
 drivers/gpu/drm/msm/dp/dp_ctrl.c                            |   33 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.h                            |    2 
 drivers/gpu/drm/msm/dp/dp_display.c                         |   16 -
 drivers/gpu/drm/msm/msm_drv.c                               |    2 
 drivers/gpu/drm/msm/msm_drv.h                               |    1 
 drivers/gpu/drm/msm/msm_gem_prime.c                         |   15 +
 drivers/gpu/drm/msm/msm_gpu.c                               |    3 
 drivers/gpu/drm/msm/msm_iommu.c                             |    2 
 drivers/gpu/drm/sun4i/sun4i_drv.c                           |    4 
 drivers/iio/accel/bma180.c                                  |    3 
 drivers/iio/accel/kxcjk-1013.c                              |    4 
 drivers/iio/accel/mma8452.c                                 |   22 +
 drivers/iio/accel/mxc4005.c                                 |    4 
 drivers/iio/adc/adi-axi-adc.c                               |    3 
 drivers/iio/adc/aspeed_adc.c                                |    1 
 drivers/iio/adc/axp288_adc.c                                |    8 
 drivers/iio/adc/rzg2l_adc.c                                 |    8 
 drivers/iio/adc/stm32-adc-core.c                            |    9 
 drivers/iio/adc/stm32-adc.c                                 |   37 +-
 drivers/iio/adc/ti-ads131e08.c                              |   10 
 drivers/iio/adc/xilinx-ams.c                                |    2 
 drivers/iio/afe/iio-rescale.c                               |    2 
 drivers/iio/chemical/ccs811.c                               |    4 
 drivers/iio/gyro/mpu3050-core.c                             |    1 
 drivers/iio/humidity/hts221_buffer.c                        |    5 
 drivers/iio/imu/inv_icm42600/inv_icm42600.h                 |    1 
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c            |    2 
 drivers/iio/magnetometer/yamaha-yas530.c                    |    2 
 drivers/iio/proximity/sx9324.c                              |    3 
 drivers/iio/test/Kconfig                                    |    2 
 drivers/iio/test/Makefile                                   |    2 
 drivers/iio/trigger/iio-trig-sysfs.c                        |    1 
 drivers/iommu/ipmmu-vmsa.c                                  |    2 
 drivers/md/dm-era-target.c                                  |    8 
 drivers/md/dm-log.c                                         |    2 
 drivers/md/dm.c                                             |    4 
 drivers/memory/mtk-smi.c                                    |    5 
 drivers/memory/samsung/exynos5422-dmc.c                     |   29 +-
 drivers/mmc/host/mtk-sd.c                                   |   20 -
 drivers/mmc/host/sdhci-pci-o2micro.c                        |    2 
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c                  |    2 
 drivers/net/bonding/bond_main.c                             |    4 
 drivers/net/dsa/qca8k.h                                     |    2 
 drivers/net/ethernet/intel/ice/ice_ethtool.c                |   49 +++
 drivers/net/ethernet/intel/ice/ice_lib.c                    |   42 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c                 |    5 
 drivers/net/ethernet/intel/igb/igb_main.c                   |   19 -
 drivers/net/phy/aquantia_main.c                             |   15 +
 drivers/net/phy/at803x.c                                    |    6 
 drivers/net/veth.c                                          |    4 
 drivers/net/virtio_net.c                                    |   25 -
 drivers/nvme/host/core.c                                    |   14 +
 drivers/nvme/host/pci.c                                     |    4 
 drivers/scsi/ibmvscsi/ibmvfc.c                              |   82 ++++--
 drivers/scsi/ibmvscsi/ibmvfc.h                              |    2 
 drivers/scsi/scsi_debug.c                                   |   22 +
 drivers/scsi/scsi_transport_iscsi.c                         |    7 
 drivers/scsi/storvsc_drv.c                                  |   27 +-
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                         |    1 
 drivers/usb/chipidea/udc.c                                  |    3 
 drivers/usb/gadget/function/uvc_video.c                     |    3 
 drivers/usb/gadget/legacy/raw_gadget.c                      |   63 +++-
 drivers/usb/host/xhci-hub.c                                 |    2 
 drivers/usb/host/xhci-pci.c                                 |    6 
 drivers/usb/host/xhci.c                                     |   15 -
 drivers/usb/host/xhci.h                                     |    2 
 drivers/usb/serial/option.c                                 |    6 
 drivers/usb/serial/pl2303.c                                 |   29 +-
 drivers/usb/typec/tcpm/Kconfig                              |    1 
 drivers/video/console/sticore.c                             |    2 
 drivers/xen/features.c                                      |    2 
 drivers/xen/gntdev-common.h                                 |    7 
 drivers/xen/gntdev.c                                        |  157 ++++++++----
 fs/9p/fid.c                                                 |   22 -
 fs/9p/vfs_addr.c                                            |   13 
 fs/9p/vfs_inode.c                                           |    8 
 fs/9p/vfs_inode_dotl.c                                      |    3 
 fs/afs/inode.c                                              |    3 
 fs/btrfs/disk-io.c                                          |   13 
 fs/btrfs/file.c                                             |   67 +++--
 fs/btrfs/locking.c                                          |    3 
 fs/btrfs/reflink.c                                          |   15 -
 fs/btrfs/super.c                                            |   47 +++
 fs/cifs/smb2pdu.c                                           |   21 +
 fs/f2fs/iostat.c                                            |   31 +-
 fs/f2fs/namei.c                                             |   17 -
 fs/f2fs/node.c                                              |    4 
 fs/io_uring.c                                               |   20 +
 fs/proc/vmcore.c                                            |   54 ++--
 include/linux/crash_dump.h                                  |    9 
 include/linux/mm.h                                          |    1 
 include/linux/ratelimit_types.h                             |   12 
 include/net/inet_sock.h                                     |    5 
 include/trace/events/libata.h                               |    1 
 kernel/dma/direct.c                                         |    5 
 kernel/trace/rethook.c                                      |    9 
 kernel/trace/trace_kprobe.c                                 |   11 
 mm/filemap.c                                                |    2 
 mm/hwpoison-inject.c                                        |    2 
 mm/madvise.c                                                |    2 
 mm/memory-failure.c                                         |   12 
 mm/readahead.c                                              |    2 
 mm/slub.c                                                   |    2 
 mm/swap.c                                                   |    2 
 net/core/dev.c                                              |   25 +
 net/core/filter.c                                           |   34 ++
 net/core/net-sysfs.c                                        |    1 
 net/core/skmsg.c                                            |    5 
 net/ethtool/eeprom.c                                        |    2 
 net/ipv4/ip_gre.c                                           |   15 -
 net/ipv4/ping.c                                             |   10 
 net/ipv4/tcp_bpf.c                                          |    3 
 net/ipv6/ip6_gre.c                                          |   15 -
 net/netfilter/nf_dup_netdev.c                               |   25 +
 net/netfilter/nft_meta.c                                    |   13 
 net/netfilter/nft_numgen.c                                  |   12 
 net/openvswitch/flow.c                                      |    2 
 net/sched/sch_netem.c                                       |    4 
 net/tipc/core.c                                             |    3 
 net/tls/tls_main.c                                          |    2 
 net/xdp/xsk.c                                               |   16 -
 scripts/mod/modpost.c                                       |    2 
 sound/core/memalloc.c                                       |   23 -
 sound/hda/hdac_i915.c                                       |   15 -
 sound/pci/hda/hda_auto_parser.c                             |    7 
 sound/pci/hda/hda_local.h                                   |    1 
 sound/pci/hda/patch_conexant.c                              |    4 
 sound/pci/hda/patch_realtek.c                               |   36 ++
 sound/pci/hda/patch_via.c                                   |    4 
 tools/perf/tests/shell/test_arm_callgraph_fp.sh             |    2 
 tools/perf/tests/topology.c                                 |    2 
 tools/perf/util/arm-spe.c                                   |   22 -
 tools/perf/util/build-id.c                                  |   28 ++
 tools/testing/selftests/dma/Makefile                        |    1 
 tools/testing/selftests/dma/dma_map_benchmark.c             |    2 
 tools/testing/selftests/net/fcnal-test.sh                   |   61 ++++
 tools/testing/selftests/netfilter/nft_concat_range.sh       |    2 
 203 files changed, 1557 insertions(+), 919 deletions(-)

Aashish Sharma (1):
      iio:proximity:sx9324: Check ret value of device_property_read_u32_array()

Adrian Hunter (1):
      perf build-id: Fix caching files with a wrong build ID

Aidan MacDonald (2):
      regmap-irq: Fix a bug in regmap_irq_enable() for type_in_mask chips
      regmap-irq: Fix offset/index mismatch in read_sub_irq_data()

Alan Stern (2):
      usb: gadget: Fix non-unique driver names in raw-gadget driver
      USB: gadget: Fix double-free bug in raw_gadget driver

Alexander Gordeev (2):
      s390/crash: add missing iterator advance in copy_oldmem_page()
      s390/crash: make copy_oldmem_page() return number of bytes copied

Alexander Stein (1):
      ARM: dts: imx7: Move hsic_phy power domain to HSIC PHY node

Alistair Popple (1):
      filemap: Fix serialization adding transparent huge pages to page cache

Anatolii Gerasymenko (2):
      ice: ethtool: advertise 1000M speeds properly
      ice: ethtool: Prohibit improper channel config for DCB

Andrew Donnellan (1):
      powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address

Andy Shevchenko (1):
      usb: typec: wcove: Drop wrong dependency to INTEL_SOC_PMIC

Aswath Govindraju (1):
      arm64: dts: ti: k3-am64-main: Remove support for HS400 speed mode

Athira Rajeev (1):
      perf test topology: Use !strncmp(right platform) to fix guest PPC comparision check

Baruch Siach (1):
      iio: adc: vf610: fix conversion mode sysfs node name

Carlo Lobrano (1):
      USB: serial: option: add Telit LE910Cx 0x1250 composition

Chevron Li (1):
      mmc: sdhci-pci-o2micro: Fix card detect by dealing with debouncing

Christian Marangi (1):
      net: dsa: qca8k: reduce mgmt ethernet timeout

Christoph Hellwig (3):
      block: disable the elevator int del_gendisk
      nvme: move the Samsung X5 quirk entry to the core quirks
      io_uring: make apoll_events a __poll_t

Ciara Loftus (1):
      xsk: Fix generic transmit when completion queue reservation fails

Claudiu Manoil (1):
      phy: aquantia: Fix AN when higher speeds than 1G are not advertised

Daeho Jeong (1):
      f2fs: fix iostat related lock protection

Damien Le Moal (1):
      scsi: scsi_debug: Fix zone transition to full condition

Dan Carpenter (1):
      gpio: winbond: Fix error code in winbond_gpio_get()

Dan Vacura (1):
      usb: gadget: uvc: fix list double add in uvcg_video_pump

David Howells (1):
      afs: Fix dynamic root getattr

David Sterba (1):
      btrfs: add error messages to all unrecognized mount options

David Virag (1):
      arm64: dts: exynos: Correct UART clocks on Exynos7885

Demi Marie Obenour (1):
      xen/gntdev: Avoid blocking in unmap_grant_pages()

Dexuan Cui (1):
      dma-direct: use the correct size for dma_set_encrypted()

Dmitry Rokosov (5):
      iio:humidity:hts221: rearrange iio trigger get and register
      iio:chemical:ccs811: rearrange iio trigger get and register
      iio:accel:kxcjk-1013: rearrange iio trigger get and register
      iio:accel:bma180: rearrange iio trigger get and register
      iio:accel:mxc4005: rearrange iio trigger get and register

Dominique Martinet (3):
      9p: fix fid refcount leak in v9fs_vfs_atomic_open_dotl
      9p: fix fid refcount leak in v9fs_vfs_get_link
      9p: fix EBADF errors in cached mode

Edward Wu (1):
      ata: libata: add qc->flags in ata_qc_complete_template tracepoint

Eric Dumazet (2):
      net: fix data-race in dev_isalive()
      erspan: do not assume transport header is always set

Filipe Manana (2):
      btrfs: fix hang during unmount when block group reclaim task is running
      btrfs: fix race between reflinking and ordered extent completion

Florian Westphal (3):
      netfilter: use get_random_u32 instead of prandom
      netfilter: nf_dup_netdev: do not push mac header a second time
      netfilter: nf_dup_netdev: add and use recursion counter

Geert Uytterhoeven (2):
      dt-bindings: usb: ohci: Increase the number of PHYs
      dt-bindings: usb: ehci: Increase the number of PHYs

George Shen (1):
      drm/amd/display: Fix typo in override_lane_settings

Gerd Hoffmann (1):
      udmabuf: add back sanity check

Greg Kroah-Hartman (1):
      Linux 5.18.8

Haibo Chen (2):
      iio: mma8452: fix probe fail when device tree compatible is used.
      iio: accel: mma8452: ignore the return value of reset operation

Hans de Goede (1):
      iio: adc: axp288: Override TS pin bias current for some models

Helge Deller (2):
      parisc/stifb: Fix fb_is_primary_device() only available with CONFIG_FB_STI
      parisc: Enable ARCH_HAS_STRICT_MODULE_RWX

Hoang Le (1):
      tipc: fix use-after-free Read in tipc_named_reinit

Ivan Vecera (1):
      ethtool: Fix get module eeprom fallback

Jaegeuk Kim (2):
      f2fs: attach inline_data after setting compression
      f2fs: do not count ENOENT for error case

Jakub Kicinski (2):
      Revert "net/tls: fix tls_sk_proto_close executed repeatedly"
      sock: redo the psock vs ULP protection check

Jakub Sitnicki (1):
      bpf, x86: Fix tail call count offset calculation on bpf2bpf call

Jann Horn (1):
      mm/slub: add missing TID updates on slab deactivation

Jason A. Donenfeld (6):
      random: schedule mix_interrupt_randomness() less often
      random: quiet urandom warning ratelimit suppression message
      powerpc/microwatt: wire up rng during setup_arch()
      powerpc/powernv: wire up rng during setup_arch
      random: update comment from copy_to_user() -> copy_to_iter()
      powerpc/pseries: wire up rng during setup_arch()

Jason Andryuk (1):
      xen-blkfront: Handle NULL gendisk

Jay Vosburgh (2):
      veth: Add updating of trans_start
      bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers

Jean-Baptiste Maneyrol (1):
      iio: imu: inv_icm42600: Fix broken icm42600 (chip id 0 value)

Jens Axboe (1):
      block: pop cached rq before potentially blocking rq_qos_throttle()

Jialin Zhang (2):
      iio: adc: rzg2l_adc: add missing fwnode_handle_put() in rzg2l_adc_parse_properties()
      iio: adc: ti-ads131e08: add missing fwnode_handle_put() in ads131e08_alloc_channels()

Jie2x Zhou (1):
      selftests: netfilter: correct PKTGEN_SCRIPT_PATHS in nft_concat_range.sh

Joerg Roedel (1):
      MAINTAINERS: Add new IOMMU development mailing list

Johan Hovold (1):
      USB: serial: pl2303: add support for more HXN (G) types

John David Anglin (1):
      parisc: Fix flush_anon_page on PA8800/PA8900

Jon Maxwell (1):
      bpf: Fix request_sock leak in sk lookup helpers

Jonathan Marek (1):
      drm/msm: use for_each_sgtable_sg to iterate over scatterlist

Josef Bacik (1):
      btrfs: fix deadlock with fsync+fiemap+transaction commit

Joshua Ashton (1):
      amd/display/dc: Fix COLOR_ENCODING and COLOR_RANGE doing nothing for DCN20+

Julien Grall (1):
      x86/xen: Remove undefined behavior in setup_features()

Kai-Heng Feng (1):
      igb: Make DMA faster when CPU is active on the PCIe link

Kailang Yang (1):
      ALSA: hda/realtek - ALC897 headset MIC no sound

Kuogee Hsieh (2):
      drm/msm/dp: check core_initialized before disable interrupts at dp_display_unbind()
      drm/msm/dp: force link training for display resolution change

Leo Yan (1):
      perf arm-spe: Don't set data source if it's not a memory operation

Liam Beguin (1):
      iio: test: fix missing MODULE_LICENSE for IIO_RESCALE=m

Liang He (2):
      xtensa: xtfpga: Fix refcount leak bug in setup
      xtensa: Fix refcount leak bug in time.c

Linus Walleij (2):
      iio: magnetometer: yas530: Fix memchr_inv() misuse
      iio: afe: rescale: Fix boolean logic bug

Lorenzo Bianconi (1):
      igb: fix a use-after-free issue in igb_clean_tx_ring

Lucas Stach (1):
      ARM: dts: imx6qdl: correct PU regulator ramp delay

Lv Ruyi (1):
      iio: adc: xilinx-ams: fix return error variable

Macpaul Lin (1):
      USB: serial: option: add Quectel RM500K module support

Marcelo Tosatti (1):
      mm: lru_cache_disable: use synchronize_rcu_expedited

Marcin Szycik (1):
      ice: ignore protocol field in GTP offload

Mario Limonciello (1):
      drm/amd: Revert "drm/amd/display: keep eDP Vdd on when eDP stream is already enabled"

Masahiro Yamada (2):
      modpost: fix section mismatch check for exported init/exit sections
      kbuild: link vmlinux only once for CONFIG_TRIM_UNUSED_KSYMS (2nd attempt)

Masami Hiramatsu (Google) (2):
      tracing/kprobes: Check whether get_kretprobe() returns NULL in kretprobe_dispatcher()
      rethook: Reject getting a rethook if RCU is not watching

Mathias Nyman (1):
      xhci: turn off port power in shutdown

Matt Ranostay (1):
      arm64: dts: ti: k3-j721s2: Fix overlapping GICD memory region

Matthew Wilcox (Oracle) (2):
      filemap: Handle sibling entries in filemap_get_read_batch()
      vmcore: convert copy_oldmem_page() to take an iov_iter

Maximilian Luz (1):
      drm/msm: Fix double pm_runtime_disable() call

Mengqi Zhang (1):
      mmc: mediatek: wait dma stop bit reset to 0

Miaoqian Lin (9):
      drm/msm/mdp4: Fix refcount leak in mdp4_modeset_init_intf
      iio: adc: aspeed: Fix refcount leak in aspeed_adc_set_trim_data
      iio: adc: adi-axi-adc: Fix refcount leak in adi_axi_adc_attach_client
      ARM: exynos: Fix refcount leak in exynos_map_pmu
      soc: bcm: brcmstb: pm: pm-arm: Fix refcount leak in brcmstb_pm_probe
      ARM: Fix refcount leak in axxia_boot_secondary
      memory: mtk-smi: add missing put_device() call in mtk_smi_device_link_common
      memory: samsung: exynos5422-dmc: Fix refcount leak in of_get_dram_timings
      ARM: cns3xxx: Fix refcount leak in cns3xxx_init

Michael Petlan (1):
      perf test: Record only user callchains on the "Check Arm64 callgraphs are complete in fp mode" test

Mike Snitzer (1):
      dm: do not return early from dm_io_complete if BLK_STS_AGAIN without polling

Mikulas Patocka (1):
      dm mirror log: clear log bits up to BITS_PER_LONG boundary

Naveen N. Rao (1):
      powerpc: Enable execve syscall exit tracepoint

Nikos Tsironis (1):
      dm era: commit metadata in postsuspend after worker stops

Oleksij Rempel (1):
      net: phy: at803x: fix NULL pointer dereference on AR9331 PHY

Olivier Moysan (2):
      iio: adc: stm32: fix maximum clock rate for stm32mp15x
      iio: adc: stm32: fix vrefint wrong calibration value handling

Pavel Begunkov (3):
      io_uring: fail links when poll fails
      io_uring: fix req->apoll_events
      io_uring: fix wrong arm_poll error handling

Peilin Ye (1):
      net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms

Peter Gonda (1):
      KVM: SEV: Init target VMCBs in sev_migrate_from

Qu Wenruo (1):
      btrfs: prevent remounting to v1 space cache for subpage mount

Quentin Perret (1):
      KVM: arm64: Prevent kmemleak from accessing pKVM memory

Riccardo Paolo Bestetti (2):
      ipv4: ping: fix bind address validity check
      ipv4: fix bind address validity regression tests

Rob Clark (2):
      drm/msm: Ensure mmap offset is initialized
      drm/msm: Switch ordering of runpm put vs devfreq_idle

Rosemarie O'Riorden (1):
      net: openvswitch: fix parsing of nw_proto for IPv6 fragments

Samuel Holland (1):
      drm/sun4i: Fix crash during suspend after component bind failure

Sascha Hauer (1):
      mtd: rawnand: gpmi: Fix setting busy timeout setting

Saurabh Sengar (1):
      scsi: storvsc: Correct reporting of Hyper-V I/O size limits

Sergey Gorenko (1):
      scsi: iscsi: Exclude zero from the endpoint ID range

Shyam Prasad N (1):
      smb3: use netname when available on secondary channels

Soham Sen (1):
      ALSA: hda/realtek: Add mute LED quirk for HP Omen laptop

Stefan Wahren (1):
      ARM: dts: bcm2711-rpi-400: Fix GPIO line names

Stephan Gerhold (1):
      virtio_net: fix xdp_rxq_info bug after suspend/resume

Steve French (1):
      smb3: fix empty netname context on secondary channels

Takashi Iwai (5):
      ALSA: memalloc: Drop x86-specific hack for WC allocations
      ALSA: hda/via: Fix missing beep setup
      ALSA: hda: Fix discovery of i915 graphics PCI device
      ALSA: hda/conexant: Fix missing beep setup
      ALSA: hda/realtek: Apply fixup for Lenovo Yoga Duet 7 properly

Tanveer Alam (1):
      xhci-pci: Allow host runtime PM as default for Intel Raptor Lake xHCI

Thomas Richter (1):
      s390/cpumf: Handle events cycles and instructions identical

Tim Crawford (2):
      ALSA: hda/realtek: Add quirk for Clevo PD70PNT
      ALSA: hda/realtek: Add quirk for Clevo NS50PU

Tyler Hicks (1):
      9p: Fix refcounting during full path walks for fid lookups

Tyrel Datwyler (2):
      scsi: ibmvfc: Store vhost pointer during subcrq allocation
      scsi: ibmvfc: Allocate/free queue resource only during probe/remove

Utkarsh Patel (1):
      xhci-pci: Allow host runtime PM as default for Intel Meteor Lake xHCI

Ville Syrjälä (1):
      drm/i915: Implement w/a 22010492432 for adl-s

Vincent Whitchurch (1):
      iio: trigger: sysfs: fix use-after-free on remove

Wojciech Drewek (1):
      ice: Fix switchdev rules book keeping

Xu Yang (1):
      usb: chipidea: udc: check request status before setting device address

Yannick Brosseau (2):
      iio: adc: stm32: Fix ADCs iteration in irq handler
      iio: adc: stm32: Fix IRQs on STM32F4 by removing custom spurious IRQs message

Yonglin Tan (1):
      USB: serial: option: add Quectel EM05-G modem

Yoshihiro Shimoda (1):
      iommu/ipmmu-vmsa: Fix compatible for rcar-gen4

Yu Liao (1):
      selftests dma: fix compile error for dma_map_benchmark

Zheyu Ma (1):
      iio: gyro: mpu3050: Fix the error handling in mpu3050_power_up()

Ziyang Xuan (1):
      net/tls: fix tls_sk_proto_close executed repeatedly

Zygo Blaxell (1):
      btrfs: don't set lock_owner when locking extent buffer for reading

huhai (1):
      MIPS: Remove repetitive increase irq_err_count

zhenwei pi (1):
      mm/memory-failure: disable unpoison once hw error happens

