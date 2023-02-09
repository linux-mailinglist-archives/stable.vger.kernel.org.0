Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5146904C5
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 11:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBIKas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 05:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBIKaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 05:30:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D0840F6;
        Thu,  9 Feb 2023 02:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D5DA619AB;
        Thu,  9 Feb 2023 10:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA4EC433EF;
        Thu,  9 Feb 2023 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675938610;
        bh=srBoyYSA476J5uA9xTGxQ1oZLkXhVuwkoRQQczPtFfw=;
        h=From:To:Cc:Subject:Date:From;
        b=OQhFqxE74OrlNx7Q+TVrf/HzuCBohJ+wDBOUfSQP0dRDH+dFoeFSg1kcdOyhwjCUU
         VixVKYh3ZlYyoegrwpLxgS20C4HHOFUZwzbpuX8/CIZDP2LesZVItLvOCw/KJOFm9O
         +fSzDytsLiuedVltGON36j5/SvZFKHf2C2lDFlro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.93
Date:   Thu,  9 Feb 2023 11:30:02 +0100
Message-Id: <1675938602227205@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.93 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h              |    2 
 arch/parisc/kernel/firmware.c                               |    5 
 arch/parisc/kernel/ptrace.c                                 |   15 +
 arch/powerpc/perf/imc-pmu.c                                 |   14 -
 arch/riscv/Makefile                                         |    3 
 arch/riscv/kernel/probes/kprobes.c                          |   18 +
 arch/x86/events/intel/core.c                                |    1 
 arch/x86/include/asm/debugreg.h                             |   26 ++
 block/bfq-cgroup.c                                          |    8 
 block/bfq-iosched.c                                         |   10 -
 drivers/ata/libata-core.c                                   |    2 
 drivers/bus/sunxi-rsb.c                                     |    8 
 drivers/firewire/core-cdev.c                                |    4 
 drivers/firmware/efi/efi.c                                  |    2 
 drivers/firmware/efi/memattr.c                              |    2 
 drivers/fpga/stratix10-soc.c                                |    4 
 drivers/fsi/fsi-sbefifo.c                                   |    6 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    7 
 drivers/gpu/drm/i915/display/intel_cdclk.c                  |    2 
 drivers/gpu/drm/i915/gem/i915_gem_tiling.c                  |    9 
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c           |   10 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                              |    3 
 drivers/i2c/busses/i2c-designware-pcidrv.c                  |    2 
 drivers/i2c/busses/i2c-mxs.c                                |    4 
 drivers/i2c/busses/i2c-rk3x.c                               |   44 ++--
 drivers/iio/accel/hid-sensor-accel-3d.c                     |    1 
 drivers/iio/adc/berlin2-adc.c                               |    4 
 drivers/iio/adc/stm32-dfsdm-adc.c                           |    1 
 drivers/iio/adc/twl6030-gpadc.c                             |   32 +++
 drivers/iio/gyro/hid-sensor-gyro-3d.c                       |    1 
 drivers/iio/imu/fxos8700_core.c                             |  111 +++++++++---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                      |    2 
 drivers/input/serio/i8042-x86ia64io.h                       |    7 
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c              |    6 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c            |    9 
 drivers/net/ethernet/intel/ice/ice.h                        |    2 
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c                |   23 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h                |    4 
 drivers/net/ethernet/intel/ice/ice_ethtool.c                |   28 ++-
 drivers/net/ethernet/intel/ice/ice_main.c                   |    5 
 drivers/net/ethernet/intel/igc/igc_ptp.c                    |   14 -
 drivers/net/ethernet/qlogic/qede/qede_fp.c                  |    7 
 drivers/net/ethernet/sfc/efx.c                              |    5 
 drivers/net/phy/dp83822.c                                   |    6 
 drivers/net/phy/meson-gxl.c                                 |    2 
 drivers/net/virtio_net.c                                    |    8 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |   17 +
 drivers/nvmem/core.c                                        |   10 -
 drivers/nvmem/qcom-spmi-sdam.c                              |    1 
 drivers/phy/qualcomm/phy-qcom-qmp.c                         |   89 ++++++---
 drivers/platform/x86/dell/dell-wmi-base.c                   |    3 
 drivers/platform/x86/gigabyte-wmi.c                         |    1 
 drivers/scsi/iscsi_tcp.c                                    |   20 +-
 drivers/scsi/libiscsi.c                                     |   38 +++-
 drivers/scsi/scsi_scan.c                                    |    7 
 drivers/target/target_core_file.c                           |    4 
 drivers/target/target_core_tmr.c                            |    4 
 drivers/tty/serial/8250/8250_dma.c                          |   26 ++
 drivers/tty/vt/vc_screen.c                                  |    9 
 drivers/usb/dwc3/dwc3-qcom.c                                |    2 
 drivers/usb/gadget/function/f_fs.c                          |    4 
 drivers/usb/gadget/function/f_uac2.c                        |    1 
 drivers/vhost/net.c                                         |    3 
 drivers/vhost/vhost.c                                       |    3 
 drivers/vhost/vhost.h                                       |    1 
 drivers/video/fbdev/core/fbcon.c                            |    7 
 drivers/video/fbdev/smscufx.c                               |   46 +++-
 drivers/watchdog/diag288_wdt.c                              |   15 +
 drivers/xen/pvcalls-back.c                                  |    8 
 fs/f2fs/gc.c                                                |   18 +
 fs/gfs2/aops.c                                              |    2 
 fs/gfs2/bmap.c                                              |    3 
 fs/gfs2/glops.c                                             |   44 ++--
 fs/gfs2/super.c                                             |   27 +-
 fs/ntfs3/inode.c                                            |    7 
 fs/overlayfs/export.c                                       |    2 
 fs/overlayfs/overlayfs.h                                    |    2 
 fs/proc/task_mmu.c                                          |    4 
 fs/squashfs/squashfs_fs.h                                   |    2 
 fs/squashfs/squashfs_fs_sb.h                                |    2 
 fs/squashfs/xattr.h                                         |    4 
 fs/squashfs/xattr_id.c                                      |    4 
 include/linux/highmem-internal.h                            |    4 
 include/linux/hugetlb.h                                     |   13 +
 include/linux/nvmem-provider.h                              |    2 
 include/linux/util_macros.h                                 |   12 +
 include/scsi/libiscsi.h                                     |    2 
 kernel/bpf/verifier.c                                       |  108 ++++++++---
 kernel/irq/irqdomain.c                                      |    2 
 kernel/trace/bpf_trace.c                                    |    3 
 mm/swapfile.c                                               |    1 
 net/bridge/br_netfilter_hooks.c                             |    1 
 net/can/j1939/transport.c                                   |    4 
 net/ipv4/tcp_bpf.c                                          |    4 
 net/ipv6/addrconf.c                                         |   59 +++---
 net/netrom/af_netrom.c                                      |    5 
 net/openvswitch/datapath.c                                  |   12 -
 net/qrtr/ns.c                                               |    5 
 net/x25/af_x25.c                                            |    6 
 sound/pci/hda/patch_realtek.c                               |    1 
 sound/pci/hda/patch_via.c                                   |    3 
 sound/soc/intel/boards/bdw-rt5650.c                         |    2 
 sound/soc/intel/boards/bdw-rt5677.c                         |    2 
 sound/soc/intel/boards/broadwell.c                          |    2 
 sound/soc/intel/boards/bxt_da7219_max98357a.c               |    2 
 sound/soc/intel/boards/bxt_rt298.c                          |    2 
 sound/soc/intel/boards/bytcht_cx2072x.c                     |    2 
 sound/soc/intel/boards/bytcht_da7213.c                      |    2 
 sound/soc/intel/boards/bytcht_es8316.c                      |   24 +-
 sound/soc/intel/boards/bytcr_rt5640.c                       |   14 -
 sound/soc/intel/boards/bytcr_rt5651.c                       |    4 
 sound/soc/intel/boards/bytcr_wm5102.c                       |    2 
 sound/soc/intel/boards/cht_bsw_max98090_ti.c                |    4 
 sound/soc/intel/boards/cht_bsw_nau8824.c                    |    4 
 sound/soc/intel/boards/cht_bsw_rt5645.c                     |    2 
 sound/soc/intel/boards/cht_bsw_rt5672.c                     |    2 
 sound/soc/intel/boards/glk_rt5682_max98357a.c               |    2 
 sound/soc/intel/boards/haswell.c                            |    2 
 tools/testing/selftests/net/udpgso_bench.sh                 |   24 ++
 tools/testing/selftests/net/udpgso_bench_rx.c               |    4 
 tools/testing/selftests/net/udpgso_bench_tx.c               |   36 +++
 122 files changed, 922 insertions(+), 394 deletions(-)

Abdun Nihaal (1):
      fs/ntfs3: Validate attribute data and valid sizes

Al Viro (4):
      WRITE is "data source", not destination...
      READ is "data destination", not source...
      fix iov_iter_bvec() "direction" argument
      fix "direction" argument of iov_iter_kvec()

Alexander Egorenkov (2):
      watchdog: diag288_wdt: do not use stack buffers for hardware data
      watchdog: diag288_wdt: fix __diag288() inline assembly

Andre Kalb (1):
      net: phy: dp83822: Fix null pointer access on DP83825/DP83826 devices

Andreas Gruenbacher (2):
      gfs2: Cosmetic gfs2_dinode_{in,out} cleanup
      gfs2: Always check inode size of inline inodes

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

Andy Shevchenko (4):
      ASoC: Intel: bytcht_es8316: Drop reference count of ACPI device after use
      ASoC: Intel: bytcr_rt5651: Drop reference count of ACPI device after use
      ASoC: Intel: bytcr_rt5640: Drop reference count of ACPI device after use
      ASoC: Intel: bytcr_wm5102: Drop reference count of ACPI device after use

Anton Gusev (1):
      efi: fix potential NULL deref in efi_mem_reserve_persistent

Ard Biesheuvel (1):
      efi: Accept version 2 of memory attributes table

Artemii Karasev (1):
      ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()

Aurabindo Pillai (1):
      drm/amd/display: Fix timing not changning when freesync video is enabled

Basavaraj Natikar (1):
      i2c: designware-pci: Add new PCI IDs for AMD NAVI GPU

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

Chaitanya Kumar Borah (1):
      drm/i915/adlp: Fix typo for reference clock

Chao Yu (1):
      f2fs: fix to do sanity check on i_extra_isize in is_alive()

Chris Healy (1):
      net: phy: meson-gxl: Add generic dummy stubs for MMD register access

Damien Le Moal (1):
      ata: libata: Fix sata_down_spd_limit() when no link speed is reported

Dave Ertman (1):
      ice: Prevent set_channel from changing queues while RDMA active

Dmitry Perchanov (2):
      iio: hid: fix the retval in accel_3d_capture_sample
      iio: hid: fix the retval in gyro_3d_capture_sample

Dongliang Mu (1):
      fbdev: smscufx: fix error handling code in ufx_usb_probe

Eduard Zingerman (1):
      bpf: Fix to preserve reg parent/live fields when copying range info

Eric Auger (1):
      vhost/net: Clear the pending messages when the backend is removed

Fedor Pchelkin (2):
      squashfs: harden sanity check in squashfs_read_xattr_id_table
      net: openvswitch: fix flow memory leak in ovs_flow_cmd_new

Florian Westphal (1):
      netfilter: br_netfilter: disable sabotage_in hook after first suppression

George Kennedy (1):
      vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF

Greg Kroah-Hartman (2):
      kernel/irq/irqdomain.c: fix memory leak with using debugfs_lookup()
      Linux 5.15.93

Guo Ren (1):
      riscv: kprobe: Fixup kernel panic when probing an illegal position

Hans Verkuil (1):
      drm/vc4: hdmi: make CEC adapter name unique

Hao Sun (1):
      bpf: Skip invalid kfunc call in backtrack_insn

Helge Deller (2):
      parisc: Fix return code of pdc_iodc_print()
      parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case

Hyunwoo Kim (2):
      netrom: Fix use-after-free caused by accept on already connected socket
      net/x25: Fix to not accept on connected socket

Ilpo Järvinen (2):
      serial: 8250_dma: Fix DMA Rx completion race
      serial: 8250_dma: Fix DMA Rx rearm race

Jakub Sitnicki (1):
      bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener

Joerg Roedel (1):
      x86/debug: Fix stack recursion caused by wrongly ordered DR7 accesses

Johan Hovold (6):
      nvmem: qcom-spmi-sdam: fix module autoloading
      phy: qcom-qmp-combo: disable runtime PM on unbind
      phy: qcom-qmp-combo: fix memleak on probe deferral
      phy: qcom-qmp-usb: fix memleak on probe deferral
      phy: qcom-qmp-combo: fix broken power on
      phy: qcom-qmp-combo: fix runtime suspend

John Harrison (1):
      drm/i915/guc: Fix locking when searching for a hung request

Kan Liang (1):
      perf/x86/intel: Add Emerald Rapids

Kees Cook (1):
      ovl: Use "buf" flexible array for memcpy() destination

Kevin Kuriakose (1):
      platform/x86: gigabyte-wmi: add support for B450M DS3H WIFI-CF

Koba Ko (1):
      platform/x86: dell-wmi: Add a keymap for KEY_MUTE in type 0x0010 table

Longlong Xia (1):
      mm/swapfile: add cond_resched() in get_swap_pages()

Magnus Karlsson (4):
      qede: execute xdp_do_flush() before napi_complete_done()
      virtio-net: execute xdp_do_flush() before napi_complete_done()
      dpaa_eth: execute xdp_do_flush() before napi_complete_done()
      dpaa2-eth: execute xdp_do_flush() before napi_complete_done()

Martin K. Petersen (1):
      scsi: Revert "scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT"

Martin KaFai Lau (2):
      bpf: Support <8-byte scalar spill and refill
      bpf: Do not reject when the stack read size is different from the tracked scalar size

Matthew Wilcox (Oracle) (1):
      highmem: round down the address passed to kunmap_flush_on_unmap()

Maurizio Lombardi (1):
      scsi: target: core: Fix warning on RT kernels

Michael Ellerman (1):
      powerpc/imc-pmu: Revert nest_init_lock to being a mutex

Michael Walle (1):
      nvmem: core: fix cell removal on error

Mike Christie (2):
      scsi: iscsi_tcp: Fix UAF during logout when accessing the shost ipaddress
      scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress

Mike Kravetz (1):
      mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps

Minsuk Kang (1):
      wifi: brcmfmac: Check the count value of channel spec to prevent out-of-bounds reads

Natalia Petrova (1):
      net: qrtr: free memory on error path in radix_tree_insert()

Neil Armstrong (1):
      usb: dwc3: qcom: enable vbus override when in OTG dr-mode

NeilBrown (1):
      block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"

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

Pierre-Louis Bossart (2):
      ASoC: Intel: boards: fix spelling in comments
      ASoC: Intel: bytcht_es8316: move comment to the right place

Pratham Pratap (1):
      usb: gadget: f_uac2: Fix incorrect increment of bNumEndpoints

Randy Dunlap (1):
      i2c: rk3x: fix a bunch of kernel-doc warnings

Rob Clark (1):
      drm/i915: Fix potential bit_17 double-free

Russell King (Oracle) (2):
      nvmem: core: initialise nvmem->id early
      nvmem: core: remove nvmem_config wp_gpio

Samuel Thibault (1):
      fbcon: Check font dimension limits

Stefan Wahren (1):
      i2c: mxs: suppress probe-deferral error message

Takashi Sakamoto (1):
      firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region

Thomas Winter (2):
      ip/ip6_gre: Fix changing addr gen mode not generating IPv6 link local address
      ip/ip6_gre: Fix non-point-to-point tunnel not generating IPv6 link local address

Tom Rix (1):
      igc: return an error if the mac type is unknown in igc_ptp_systim_to_hwtstamp()

Udipto Goswami (1):
      usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait

Victor Shyba (1):
      ALSA: hda/realtek: Add Acer Predator PH315-54

Werner Sembach (1):
      Input: i8042 - add Clevo PCX0DX to i8042 quirk table

Xiongfeng Wang (1):
      iio: adc: berlin2-adc: Add missing of_node_put() in error path

Yonghong Song (1):
      bpf: Fix a possible task gone issue with bpf_send_signal[_thread]() helpers

Yu Kuai (2):
      block, bfq: replace 0/1 with false/true in bic apis
      block, bfq: fix uaf for bfqq in bic_set_bfqq()

Yuan Can (1):
      bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()

Zheng Yongjun (1):
      fpga: stratix10-soc: Fix return value check in s10_ops_write_init()

Ziyang Xuan (1):
      can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

Íñigo Huguet (1):
      sfc: correctly advertise tunneled IPv6 segmentation

