Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DAF698112
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 17:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBOQkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 11:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBOQkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 11:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF9832CE7;
        Wed, 15 Feb 2023 08:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E2AAB8225E;
        Wed, 15 Feb 2023 16:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25D5C433A4;
        Wed, 15 Feb 2023 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676479216;
        bh=QRahJIcXNZI05KVcavUTNI3DlQnBTOk0AKkh1vDHb6c=;
        h=From:To:Cc:Subject:Date:From;
        b=A2NPEYSu5l9blttxkpMq3vFMaSHnj/Sk909l6AzjocQPK9TqO0jSUF6dDfXnqdJy0
         mXo+HilyR8W9NzJAAoy6ka87k4h1TxMdrPRTgUFwuMXPMGTKAxwdYpPePIjZ4mG+Rn
         zZFb/rSqILW6qOu6AzPut36iPhj8NiJLv1OR7QSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.168
Date:   Wed, 15 Feb 2023 17:40:12 +0100
Message-Id: <1676479212139127@kroah.com>
X-Mailer: git-send-email 2.39.1
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

I'm announcing the release of the 5.10.168 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                  |    4 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi           |    6 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                   |    6 
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h              |    2 
 arch/parisc/kernel/firmware.c                               |    5 
 arch/parisc/kernel/ptrace.c                                 |   15 
 arch/powerpc/perf/imc-pmu.c                                 |   14 
 arch/riscv/Makefile                                         |    3 
 arch/riscv/mm/cacheflush.c                                  |    4 
 arch/x86/include/asm/debugreg.h                             |   26 
 drivers/ata/libata-core.c                                   |    2 
 drivers/bus/sunxi-rsb.c                                     |    8 
 drivers/firewire/core-cdev.c                                |    4 
 drivers/firmware/efi/efi.c                                  |    2 
 drivers/firmware/efi/memattr.c                              |    2 
 drivers/fpga/stratix10-soc.c                                |    4 
 drivers/fsi/fsi-sbefifo.c                                   |    6 
 drivers/gpu/drm/i915/gem/i915_gem_tiling.c                  |    9 
 drivers/gpu/drm/vc4/vc4_hdmi.c                              |    3 
 drivers/i2c/busses/i2c-mxs.c                                |    4 
 drivers/i2c/busses/i2c-rk3x.c                               |   44 
 drivers/iio/accel/hid-sensor-accel-3d.c                     |    1 
 drivers/iio/adc/berlin2-adc.c                               |    4 
 drivers/iio/adc/stm32-dfsdm-adc.c                           |    1 
 drivers/iio/adc/twl6030-gpadc.c                             |   32 
 drivers/iio/imu/fxos8700_core.c                             |  111 -
 drivers/infiniband/hw/hfi1/file_ops.c                       |    7 
 drivers/infiniband/hw/usnic/usnic_uiom.c                    |    8 
 drivers/infiniband/ulp/ipoib/ipoib_main.c                   |    8 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                      |    2 
 drivers/input/serio/i8042-x86ia64io.h                       | 1188 +++++++-----
 drivers/net/bonding/bond_debugfs.c                          |    2 
 drivers/net/ethernet/intel/ice/ice_main.c                   |    2 
 drivers/net/ethernet/intel/igc/igc_ptp.c                    |   14 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c    |    3 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c     |   13 
 drivers/net/ethernet/mscc/ocelot_flower.c                   |   24 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c             |   15 
 drivers/net/ethernet/qlogic/qede/qede_fp.c                  |   10 
 drivers/net/ethernet/sfc/efx.c                              |    5 
 drivers/net/phy/dp83822.c                                   |    6 
 drivers/net/phy/meson-gxl.c                                 |    4 
 drivers/net/usb/plusb.c                                     |    4 
 drivers/net/virtio_net.c                                    |    8 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |   17 
 drivers/nvmem/core.c                                        |    8 
 drivers/nvmem/qcom-spmi-sdam.c                              |    1 
 drivers/of/address.c                                        |   21 
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                     |    2 
 drivers/pinctrl/intel/pinctrl-intel.c                       |   16 
 drivers/pinctrl/pinctrl-single.c                            |    2 
 drivers/platform/x86/dell-wmi.c                             |    3 
 drivers/scsi/iscsi_tcp.c                                    |    9 
 drivers/scsi/scsi_scan.c                                    |    7 
 drivers/spi/spi-dw-core.c                                   |    2 
 drivers/target/target_core_file.c                           |    4 
 drivers/target/target_core_tmr.c                            |    4 
 drivers/tty/serial/8250/8250_dma.c                          |   26 
 drivers/tty/vt/vc_screen.c                                  |    9 
 drivers/usb/core/quirks.c                                   |    3 
 drivers/usb/dwc3/dwc3-qcom.c                                |   10 
 drivers/usb/gadget/function/f_fs.c                          |    4 
 drivers/usb/typec/altmodes/displayport.c                    |    8 
 drivers/vhost/net.c                                         |    3 
 drivers/vhost/vhost.c                                       |    3 
 drivers/vhost/vhost.h                                       |    1 
 drivers/video/fbdev/core/fbcon.c                            |    7 
 drivers/video/fbdev/smscufx.c                               |   46 
 drivers/watchdog/diag288_wdt.c                              |   15 
 drivers/xen/pvcalls-back.c                                  |    8 
 fs/btrfs/volumes.c                                          |   22 
 fs/btrfs/zlib.c                                             |    2 
 fs/ceph/mds_client.c                                        |    6 
 fs/cifs/file.c                                              |    4 
 fs/f2fs/gc.c                                                |   18 
 fs/proc/task_mmu.c                                          |    4 
 fs/squashfs/squashfs_fs.h                                   |    2 
 fs/squashfs/squashfs_fs_sb.h                                |    2 
 fs/squashfs/xattr.h                                         |    4 
 fs/squashfs/xattr_id.c                                      |    4 
 include/linux/hugetlb.h                                     |   19 
 include/linux/nvmem-provider.h                              |    4 
 include/linux/util_macros.h                                 |   12 
 include/uapi/linux/ip.h                                     |    1 
 include/uapi/linux/ipv6.h                                   |    1 
 kernel/bpf/verifier.c                                       |  102 -
 kernel/trace/bpf_trace.c                                    |    3 
 kernel/trace/trace.c                                        |    3 
 mm/gup.c                                                    |    2 
 mm/hugetlb.c                                                |    6 
 mm/memory-failure.c                                         |    2 
 mm/memory_hotplug.c                                         |    2 
 mm/mempolicy.c                                              |    5 
 mm/migrate.c                                                |    7 
 mm/page_alloc.c                                             |    5 
 mm/swapfile.c                                               |    1 
 net/bridge/br_netfilter_hooks.c                             |    1 
 net/can/j1939/address-claim.c                               |   40 
 net/can/j1939/transport.c                                   |    4 
 net/ipv4/tcp_bpf.c                                          |    4 
 net/netrom/af_netrom.c                                      |    5 
 net/openvswitch/datapath.c                                  |   12 
 net/qrtr/ns.c                                               |    5 
 net/rds/message.c                                           |    6 
 net/x25/af_x25.c                                            |    6 
 net/xfrm/xfrm_compat.c                                      |    4 
 net/xfrm/xfrm_input.c                                       |    3 
 sound/pci/hda/patch_realtek.c                               |    3 
 sound/pci/hda/patch_via.c                                   |    3 
 sound/pci/lx6464es/lx_core.c                                |   11 
 sound/synth/emux/emux_nrpn.c                                |    3 
 tools/testing/selftests/net/forwarding/lib.sh               |    4 
 tools/testing/selftests/net/udpgso_bench.sh                 |   24 
 tools/testing/selftests/net/udpgso_bench_rx.c               |    4 
 tools/testing/selftests/net/udpgso_bench_tx.c               |   36 
 116 files changed, 1510 insertions(+), 797 deletions(-)

Al Viro (4):
      WRITE is "data source", not destination...
      READ is "data destination", not source...
      fix iov_iter_bvec() "direction" argument
      fix "direction" argument of iov_iter_kvec()

Alan Stern (1):
      net: USB: Fix wrong-direction WARNING in plusb.c

Alexander Egorenkov (2):
      watchdog: diag288_wdt: do not use stack buffers for hardware data
      watchdog: diag288_wdt: fix __diag288() inline assembly

Alexander Potapenko (1):
      btrfs: zlib: zero-initialize zlib workspace

Anand Jain (1):
      btrfs: free device in btrfs_close_devices for a single device filesystem

Anastasia Belova (1):
      xfrm: compat: change expression for switch in xfrm_xlate64

Andre Kalb (1):
      net: phy: dp83822: Fix null pointer access on DP83825/DP83826 devices

Andreas Kemnade (2):
      iio:adc:twl6030: Enable measurements of VUSB, VBAT and others
      iio:adc:twl6030: Enable measurement of VAC

Andreas Schwab (1):
      riscv: disable generation of unwind tables

Andrei Gherzan (4):
      selftests: net: udpgso_bench_rx: Fix 'used uninitialized' compiler warning
      selftests: net: udpgso_bench_rx/tx: Stop when wrong CLI args are provided
      selftests: net: udpgso_bench: Fix racing bug between the rx/tx programs
      selftests: net: udpgso_bench_tx: Cater for pending datagrams zerocopy benchmarking

Andy Shevchenko (1):
      pinctrl: intel: Restore the pins that used to be in Direct IRQ mode

Anirudh Venkataramanan (1):
      ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Anton Gusev (1):
      efi: fix potential NULL deref in efi_mem_reserve_persistent

Ard Biesheuvel (1):
      efi: Accept version 2 of memory attributes table

Artemii Karasev (2):
      ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()
      ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()

Bhaskar Upadhaya (1):
      qede: add netpoll support for qede driver

Carlos Song (9):
      iio: imu: fxos8700: fix ACCEL measurement range selection
      iio: imu: fxos8700: fix incomplete ACCEL and MAGN channels readback
      iio: imu: fxos8700: fix IMU data bits returned to user space
      iio: imu: fxos8700: fix map label of channel type to MAGN sensor
      iio: imu: fxos8700: fix swapped ACCEL and MAGN channels readback
      iio: imu: fxos8700: fix incorrect ODR mode readback
      iio: imu: fxos8700: fix failed initialization ODR mode assignment
      iio: imu: fxos8700: remove definition FXOS8700_CTRL_ODR_MIN
      iio: imu: fxos8700: fix MAGN sensor scale and unit

Chao Yu (1):
      f2fs: fix to do sanity check on i_extra_isize in is_alive()

Chris Healy (1):
      net: phy: meson-gxl: Add generic dummy stubs for MMD register access

Christian Hopps (1):
      xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Christophe Kerello (1):
      nvmem: core: Fix a conflict between MTD and NVMEM on wp-gpios property

Damien Le Moal (1):
      ata: libata: Fix sata_down_spd_limit() when no link speed is reported

Dan Carpenter (1):
      ALSA: pci: lx6464es: fix a debug loop

David Chen (1):
      Fix page corruption caused by racy check in __free_pages

Dean Luick (1):
      IB/hfi1: Restore allocated resources on failed copyout

Devid Antonio Filoni (1):
      can: j1939: do not wait 250 ms if the same addr was already claimed

Dmitry Perchanov (1):
      iio: hid: fix the retval in accel_3d_capture_sample

Dongliang Mu (1):
      fbdev: smscufx: fix error handling code in ufx_usb_probe

Dragos Tatulea (2):
      IB/IPoIB: Fix legacy IPoIB due to wrong number of queues
      net/mlx5e: IPoIB, Show unknown speed instead of error

Edson Juliano Drosdeck (1):
      ALSA: hda/realtek: Add Positivo N14KP6-TG

Eduard Zingerman (1):
      bpf: Fix to preserve reg parent/live fields when copying range info

Eric Auger (1):
      vhost/net: Clear the pending messages when the backend is removed

Eric Dumazet (1):
      xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()

Fedor Pchelkin (2):
      squashfs: harden sanity check in squashfs_read_xattr_id_table
      net: openvswitch: fix flow memory leak in ovs_flow_cmd_new

Florian Westphal (1):
      netfilter: br_netfilter: disable sabotage_in hook after first suppression

George Kennedy (1):
      vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF

Greg Kroah-Hartman (1):
      Linux 5.10.168

Guillaume Pinot (1):
      ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro 360

Guo Ren (1):
      riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte

Hangbin Liu (1):
      selftests: forwarding: lib: quote the sysctl values

Hans Verkuil (1):
      drm/vc4: hdmi: make CEC adapter name unique

Heiner Kallweit (4):
      net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY
      arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive
      arm64: dts: meson-g12-common: Make mmc host controller interrupts level-sensitive
      arm64: dts: meson-axg: Make mmc host controller interrupts level-sensitive

Helge Deller (2):
      parisc: Fix return code of pdc_iodc_print()
      parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case

Herton R. Krzesinski (1):
      uapi: add missing ip/ipv6 header dependencies for linux/stddef.h

Hyunwoo Kim (2):
      netrom: Fix use-after-free caused by accept on already connected socket
      net/x25: Fix to not accept on connected socket

Ilpo Järvinen (2):
      serial: 8250_dma: Fix DMA Rx completion race
      serial: 8250_dma: Fix DMA Rx rearm race

Jakub Sitnicki (1):
      bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener

Joel Stanley (1):
      pinctrl: aspeed: Fix confusing types in return value

Joerg Roedel (1):
      x86/debug: Fix stack recursion caused by wrongly ordered DR7 accesses

Johan Hovold (1):
      nvmem: qcom-spmi-sdam: fix module autoloading

Josef Bacik (1):
      btrfs: limit device extents to the device size

Koba Ko (1):
      platform/x86: dell-wmi: Add a keymap for KEY_MUTE in type 0x0010 table

Longlong Xia (1):
      mm/swapfile: add cond_resched() in get_swap_pages()

Magnus Karlsson (2):
      virtio-net: execute xdp_do_flush() before napi_complete_done()
      qede: execute xdp_do_flush() before napi_complete_done()

Mark Brown (1):
      of/address: Return an error when no valid dma-ranges are found

Mark Pearson (1):
      usb: core: add quirk for Alcor Link AK9563 smartcard reader

Martin K. Petersen (1):
      scsi: Revert "scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT"

Martin KaFai Lau (2):
      bpf: Support <8-byte scalar spill and refill
      bpf: Do not reject when the stack read size is different from the tracked scalar size

Maurizio Lombardi (1):
      scsi: target: core: Fix warning on RT kernels

Maxim Korotkov (1):
      pinctrl: single: fix potential NULL dereference

Miaohe Lin (1):
      mm/migration: return errno when isolate_huge_page failed

Michael Ellerman (1):
      powerpc/imc-pmu: Revert nest_init_lock to being a mutex

Michael Walle (1):
      nvmem: core: fix cell removal on error

Mike Christie (1):
      scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress

Mike Kravetz (2):
      mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps
      migrate: hugetlb: check for hugetlb shared PMD in node migration

Minsuk Kang (1):
      wifi: brcmfmac: Check the count value of channel spec to prevent out-of-bounds reads

Natalia Petrova (1):
      net: qrtr: free memory on error path in radix_tree_insert()

Neel Patel (1):
      ionic: clean interrupt before enabling queue to avoid credit race

Neil Armstrong (1):
      usb: dwc3: qcom: enable vbus override when in OTG dr-mode

Olivier Moysan (1):
      iio: adc: stm32-dfsdm: fill module aliases

Parav Pandit (1):
      virtio-net: Keep stop() to follow mirror sequence of open()

Paul Chaignon (1):
      bpf: Fix incorrect state pruning for <8B spill/fill

Phillip Lougher (1):
      Squashfs: fix handling and sanity checking of xattr_ids count

Pierluigi Passaro (1):
      arm64: dts: imx8mm: Fix pad control for UART1_DTE_RX

Pietro Borrello (1):
      rds: rds_rm_zerocopy_callback() use list_first_entry()

Prashant Malani (1):
      usb: typec: altmodes/displayport: Fix probe pin assign check

Qi Zheng (1):
      bonding: fix error checking in bond_debug_reregister()

Randy Dunlap (1):
      i2c: rk3x: fix a bunch of kernel-doc warnings

Rob Clark (1):
      drm/i915: Fix potential bit_17 double-free

Russell King (Oracle) (1):
      nvmem: core: initialise nvmem->id early

Samuel Thibault (1):
      fbcon: Check font dimension limits

Serge Semin (1):
      spi: dw: Fix wrong FIFO level setting for long xfers

Shay Drory (2):
      net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
      net/mlx5: fw_tracer, Zero consumer index when reloading the tracer

Shiju Jose (1):
      tracing: Fix poll() and select() do not work on per_cpu trace_pipe and trace_pipe_raw

Stefan Wahren (1):
      i2c: mxs: suppress probe-deferral error message

Takashi Sakamoto (1):
      firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region

Tom Rix (1):
      igc: return an error if the mac type is unknown in igc_ptp_systim_to_hwtstamp()

Udipto Goswami (1):
      usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait

Victor Shyba (1):
      ALSA: hda/realtek: Add Acer Predator PH315-54

Vladimir Oltean (1):
      net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"

Werner Sembach (4):
      Input: i8042 - move __initconst to fix code styling warning
      Input: i8042 - merge quirk tables
      Input: i8042 - add TUXEDO devices to i8042 quirk tables
      Input: i8042 - add Clevo PCX0DX to i8042 quirk table

Wesley Cheng (1):
      usb: dwc3: dwc3-qcom: Fix typo in the dwc3 vbus override API

Xiongfeng Wang (1):
      iio: adc: berlin2-adc: Add missing of_node_put() in error path

Xiubo Li (1):
      ceph: flush cap releases when the session is flushed

Yang Yingliang (1):
      RDMA/usnic: use iommu_map_atomic() under spin_lock()

Yonghong Song (1):
      bpf: Fix a possible task gone issue with bpf_send_signal[_thread]() helpers

Yuan Can (1):
      bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()

ZhaoLong Wang (1):
      cifs: Fix use-after-free in rdata->read_into_pages()

Zheng Yongjun (1):
      fpga: stratix10-soc: Fix return value check in s10_ops_write_init()

Ziyang Xuan (1):
      can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

Íñigo Huguet (1):
      sfc: correctly advertise tunneled IPv6 segmentation

