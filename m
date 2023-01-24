Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C936790E2
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 07:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjAXG36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 01:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjAXG33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 01:29:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC913D917;
        Mon, 23 Jan 2023 22:29:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00131611FC;
        Tue, 24 Jan 2023 06:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A553C433D2;
        Tue, 24 Jan 2023 06:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674541743;
        bh=hYWwooTIJR2O53X2nv8EhM4D/qDOi06smEzH3PiX7eU=;
        h=From:To:Cc:Subject:Date:From;
        b=b+rZndr9Haydtjt95VK1hUQe77L/UjlQ+A8iS00xGvOMydT9FIAnrwI3mAUpKD0Do
         e8Nae45mNt0mKntPIX1XtsmD4DPqs2Otssw5mARFiwu5Ql5M5VxphyF5Frp2IP0Wd5
         yX0tQMLCgureFdfAmdawqzzIpxMdJgHiQYBDKALY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.90
Date:   Tue, 24 Jan 2023 07:28:48 +0100
Message-Id: <167454172977219@kroah.com>
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

I'm announcing the release of the 5.15.90 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml            |   78 +++
 Documentation/devicetree/bindings/phy/amlogic,g12a-usb3-pcie-phy.yaml       |   59 ++
 Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml      |   78 ---
 Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml |   59 --
 Makefile                                                                    |    2 
 arch/arm64/include/asm/efi.h                                                |    3 
 arch/arm64/kernel/efi-rt-wrapper.S                                          |   14 
 arch/arm64/kernel/efi.c                                                     |   27 +
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi                                  |    2 
 arch/x86/events/rapl.c                                                      |    2 
 arch/x86/kernel/fpu/init.c                                                  |    7 
 arch/x86/lib/iomap_copy_64.S                                                |    2 
 block/mq-deadline.c                                                         |    4 
 drivers/accessibility/speakup/spk_ttyio.c                                   |    3 
 drivers/acpi/prmt.c                                                         |   10 
 drivers/bluetooth/hci_qca.c                                                 |    7 
 drivers/comedi/drivers/adv_pci1760.c                                        |    2 
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c                              |    6 
 drivers/dma/idxd/device.c                                                   |    3 
 drivers/dma/lgm/lgm-dma.c                                                   |   10 
 drivers/dma/tegra210-adma.c                                                 |    2 
 drivers/firmware/efi/runtime-wrappers.c                                     |    1 
 drivers/firmware/google/gsmi.c                                              |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                                  |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                                     |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                                     |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                                  |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                           |    8 
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c                       |    4 
 drivers/gpu/drm/i915/display/skl_universal_plane.c                          |    2 
 drivers/gpu/drm/i915/i915_pci.c                                             |    3 
 drivers/infiniband/ulp/srp/ib_srp.h                                         |    8 
 drivers/misc/fastrpc.c                                                      |   26 -
 drivers/misc/mei/hw-me-regs.h                                               |    2 
 drivers/misc/mei/pci-me.c                                                   |    2 
 drivers/mmc/host/sdhci-esdhc-imx.c                                          |   22 
 drivers/mmc/host/sunxi-mmc.c                                                |    8 
 drivers/net/ethernet/mellanox/mlx5/core/health.c                            |    1 
 drivers/net/ethernet/realtek/r8169_main.c                                   |   44 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c                     |    2 
 drivers/soc/qcom/apr.c                                                      |    3 
 drivers/staging/mt7621-dts/mt7621.dtsi                                      |   12 
 drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h             |    2 
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h               |    4 
 drivers/thunderbolt/tunnel.c                                                |    2 
 drivers/tty/serial/amba-pl011.c                                             |    8 
 drivers/tty/serial/atmel_serial.c                                           |    8 
 drivers/tty/serial/pch_uart.c                                               |    2 
 drivers/tty/serial/qcom_geni_serial.c                                       |   18 
 drivers/usb/cdns3/cdns3-gadget.c                                            |   12 
 drivers/usb/core/hub.c                                                      |   13 
 drivers/usb/core/usb-acpi.c                                                 |   65 ++
 drivers/usb/gadget/function/f_ncm.c                                         |    4 
 drivers/usb/gadget/legacy/inode.c                                           |   28 -
 drivers/usb/gadget/legacy/webcam.c                                          |    3 
 drivers/usb/host/ehci-fsl.c                                                 |    2 
 drivers/usb/host/xhci-pci.c                                                 |   45 +
 drivers/usb/host/xhci-ring.c                                                |    5 
 drivers/usb/host/xhci.c                                                     |   18 
 drivers/usb/host/xhci.h                                                     |    5 
 drivers/usb/misc/iowarrior.c                                                |    2 
 drivers/usb/serial/cp210x.c                                                 |    1 
 drivers/usb/serial/option.c                                                 |   17 
 drivers/usb/storage/uas-detect.h                                            |   13 
 drivers/usb/storage/unusual_uas.h                                           |    7 
 drivers/usb/typec/altmodes/displayport.c                                    |   22 
 drivers/usb/typec/tcpm/tcpm.c                                               |    7 
 drivers/vdpa/vdpa_user/vduse_dev.c                                          |    3 
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c                                  |   28 -
 drivers/virtio/virtio_pci_modern.c                                          |    2 
 fs/btrfs/disk-io.c                                                          |    9 
 fs/btrfs/extent-tree.c                                                      |    7 
 fs/btrfs/qgroup.c                                                           |   25 -
 fs/btrfs/tree-log.c                                                         |    2 
 fs/cifs/smb2pdu.c                                                           |   15 
 fs/eventfd.c                                                                |   37 -
 fs/eventpoll.c                                                              |   18 
 fs/f2fs/extent_cache.c                                                      |    3 
 fs/nfs/filelayout/filelayout.c                                              |    8 
 fs/nilfs2/btree.c                                                           |   15 
 fs/ntfs3/attrib.c                                                           |    2 
 fs/zonefs/super.c                                                           |   22 
 include/linux/eventfd.h                                                     |    7 
 include/linux/usb.h                                                         |    3 
 include/trace/events/btrfs.h                                                |    2 
 include/trace/trace_events.h                                                |    2 
 include/uapi/linux/eventpoll.h                                              |    6 
 io_uring/io-wq.c                                                            |    2 
 io_uring/io_uring.c                                                         |  248 +++++++---
 kernel/bpf/offload.c                                                        |    3 
 kernel/bpf/syscall.c                                                        |    6 
 kernel/sys.c                                                                |    2 
 mm/hugetlb.c                                                                |   44 +
 mm/khugepaged.c                                                             |   14 
 net/ethtool/ioctl.c                                                         |    3 
 net/ipv4/tcp_ulp.c                                                          |    2 
 net/mac80211/agg-tx.c                                                       |    6 
 net/mac80211/driver-ops.c                                                   |    3 
 net/mac80211/iface.c                                                        |    1 
 sound/pci/hda/patch_realtek.c                                               |    3 
 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c                 |    9 
 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c                 |   42 +
 tools/virtio/vringh_test.c                                                  |    2 
 103 files changed, 1058 insertions(+), 435 deletions(-)

Abel Vesa (1):
      misc: fastrpc: Don't remove map on creater_process and device_release

Alan Stern (1):
      USB: gadgetfs: Fix race between mounting and unmounting

Alex Deucher (2):
      drm/amdgpu: drop experimental flag on aldebaran
      Revert "drm/amdgpu: make display pinning more flexible (v2)"

Alexander Stein (1):
      usb: host: ehci-fsl: Fix module alias

Alexander Usyskin (1):
      mei: me: add meteor lake point M DID

Alexander Wetzel (1):
      wifi: mac80211: sdata can be NULL during AMPDU start

Ali Mirghasemi (1):
      USB: serial: option: add Quectel EC200U modem

Alon Zahavi (1):
      fs/ntfs3: Fix attr_punch_hole() null pointer derenference

Alviro Iskandar Setiawan (1):
      io_uring: Clean up a false-positive warning from GCC 9.3.0

Andy Chi (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Angus Chen (1):
      virtio_pci: modify ENOENT to EINVAL

Ard Biesheuvel (3):
      ACPI: PRM: Check whether EFI runtime is available
      arm64: efi: Execute runtime services from a dedicated stack
      efi: rt-wrapper: Add missing include

Arend van Spriel (1):
      wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices

Arnd Bergmann (2):
      fbdev: omapfb: avoid stack overflow warning
      staging: vchiq_arm: fix enum vchiq_status return types

Ben Dooks (1):
      riscv: dts: sifive: fu740: fix size of pcie 32bit memory

ChiYuan Huang (1):
      usb: typec: tcpm: Fix altmode re-registration causes sysfs create fail

Chris Wilson (1):
      perf/x86/rapl: Treat Tigerlake like Icelake

Chunhao Lin (1):
      r8169: move rtl_wol_enable_rx() and rtl_prepare_power_down()

Damien Le Moal (2):
      zonefs: Detect append writes at invalid locations
      block: mq-deadline: Rename deadline_is_seq_writes()

Daniel Scally (1):
      usb: gadget: g_webcam: Send color matching descriptor per frame

Daniil Tatianin (1):
      net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats

Ding Hui (1):
      efi: fix userspace infinite retry read efivars after EFI runtime services page fault

Drew Davenport (1):
      drm/i915/display: Check source height is > 0

Duke Xin(辛安文) (5):
      USB: serial: option: add Quectel EM05-G (GR) modem
      USB: serial: option: add Quectel EM05-G (CS) modem
      USB: serial: option: add Quectel EM05-G (RS) modem
      USB: serial: option: add Quectel EM05CN (SG) modem
      USB: serial: option: add Quectel EM05CN modem

Dylan Yudaken (4):
      io_uring: fix async accept on O_NONBLOCK sockets
      io_uring: remove duplicated calls to io_kiocb_ppos
      io_uring: update kiocb->ki_pos at execution time
      io_uring: do not recalculate ppos unnecessarily

Enzo Matsumiya (1):
      cifs: do not include page data when checking signature

Eric Dumazet (1):
      Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()"

Filipe Manana (2):
      btrfs: do not abort transaction on failure to write log tree when syncing log
      btrfs: fix race between quota rescan and disable leading to NULL pointer deref

Flavio Suligoi (1):
      usb: core: hub: disable autosuspend for TI TUSB8041

Gaosheng Cui (1):
      tty: fix possible null-ptr-defer in spk_ttyio_release

Greg Kroah-Hartman (3):
      prlimit: do_prlimit needs to have a speculation check
      USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100
      Linux 5.15.90

Guchun Chen (1):
      drm/amdgpu: disable runtime pm on several sienna cichlid cards(v2)

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting

Hao Sun (1):
      selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID

Harshit Mogalapalli (1):
      vduse: Validate vq_num in vduse_validate_config()

Heiner Kallweit (2):
      dt-bindings: phy: g12a-usb2-phy: fix compatible string documentation
      dt-bindings: phy: g12a-usb3-pcie-phy: fix compatible string documentation

Hugh Dickins (1):
      mm/khugepaged: fix collapse_pte_mapped_thp() to allow anon_vma

Ian Abbott (1):
      comedi: adv_pci1760: Fix PWM instruction handling

Ilpo Järvinen (1):
      serial: pch_uart: Pass correct sg to dma_unmap_sg()

Jaegeuk Kim (1):
      f2fs: let's avoid panic if extent_tree is not created

James Houghton (1):
      hugetlb: unshare some PMDs when splitting VMAs

Jens Axboe (13):
      io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL
      eventpoll: add EPOLL_URING_WAKE poll wakeup flag
      eventfd: provide a eventfd_signal_mask() helper
      io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups
      io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly
      io_uring: add flag for disabling provided buffer recycling
      io_uring: support MSG_WAITALL for IORING_OP_SEND(MSG)
      io_uring: allow re-poll if we made progress
      io_uring: ensure that cached task references are always put on exit
      io_uring/rw: defer fsnotify calls to task context
      io_uring: io_kiocb_update_pos() should not touch file for non -1 offset
      io_uring/rw: ensure kiocb_end_write() is always called
      io_uring/rw: remove leftover debug statement

Jeremy Szu (1):
      ALSA: hda/realtek: fix mute/micmute LEDs don't work for a HP platform

Jimmy Hu (1):
      usb: xhci: Check endpoint is valid before dereferencing it

Jiri Slaby (SUSE) (1):
      RDMA/srp: Move large values to a new enum for gcc13

Joshua Ashton (2):
      drm/amd/display: Calculate output_color_space after pixel encoding adjustment
      drm/amd/display: Fix COLOR_SPACE_YCBCR2020_TYPE matrix

Juhyung Park (1):
      usb-storage: apply IGNORE_UAS only for HIKSEMI MD202 on RTL9210

Khazhismel Kumykov (1):
      gsmi: fix null-deref in gsmi_get_variable

Krzysztof Kozlowski (2):
      Bluetooth: hci_qca: Fix driver shutdown on closed serdev
      tty: serial: qcom-geni-serial: fix slab-out-of-bounds on RX FIFO buffer

Lino Sanfilippo (1):
      serial: amba-pl011: fix high priority character transmission in rs486 mode

Maciej Żenczykowski (1):
      usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()

Mathias Nyman (5):
      xhci: Fix null pointer dereference when host dies
      xhci: Add update_hub_device override for PCI xHCI hosts
      xhci: Add a flag to disable USB3 lpm on a xhci root port level.
      usb: acpi: add helper to check port lpm capability using acpi _DSM
      xhci: Detect lpm incapable xHC USB3 roothub ports from ACPI tables

Michael Adler (1):
      USB: serial: cp210x: add SCALANCE LPE-9000 device id

Mika Westerberg (1):
      thunderbolt: Use correct function to calculate maximum USB3 link rate

Mikulas Patocka (1):
      x86/asm: Fix an assembler warning with current binutils

Mohan Kumar (1):
      dmaengine: tegra210-adma: fix global intr clear

Naohiro Aota (1):
      btrfs: fix trace event name typo for FLUSH_DELAYED_REFS

Ola Jeppsson (1):
      misc: fastrpc: Fix use-after-free race condition for maps

Olga Kornievskaia (1):
      pNFS/filelayout: Fix coalescing test for single DS

Paolo Abeni (1):
      net/ulp: use consistent error code when blocking ULP

Paul Moore (1):
      bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and PERF_BPF_EVENT_PROG_UNLOAD

Pavel Begunkov (2):
      io_uring: improve send/recv error handling
      io_uring: fix double poll leak on repolling

Pawel Laszczak (1):
      usb: cdns3: remove fetched trb from cache before dequeuing

Peter Harliman Liem (1):
      dmaengine: lgm: Move DT parsing after initialization

Prashant Malani (2):
      usb: typec: altmodes/displayport: Add pin assignment helper
      usb: typec: altmodes/displayport: Fix pin assignment calculation

Qu Wenruo (1):
      btrfs: always report error in run_one_delayed_ref()

Reinette Chatre (1):
      dmaengine: idxd: Let probe fail when workqueue cannot be enabled

Ricardo Cañuelo (1):
      tools/virtio: initialize spinlocks in vring_test.c

Ricardo Ribalda (1):
      xhci-pci: set the dma max_seg_size

Ryusuke Konishi (1):
      nilfs2: fix general protection fault in nilfs_btree_insert()

Samuel Holland (1):
      mmc: sunxi-mmc: Fix clock refcount imbalance during unbind

Sasa Dragic (1):
      drm/i915: re-disable RC6p on Sandy Bridge

Sasha Levin (1):
      drm/amd: Delay removal of the firmware framebuffer

Sergio Paracuellos (1):
      staging: mt7621-dts: change some node hex addresses to lower case

Shawn.Shao (1):
      Add exception protection processing for vd in axi_chan_handle_err function

Stefan Metzmacher (1):
      io_uring/net: fix fast_iov assignment in io_setup_async_msg()

Stephan Gerhold (1):
      soc: qcom: apr: Make qcom,protection-domain optional again

Steven Rostedt (Google) (1):
      tracing: Use alignof__(struct {type b;}) instead of offsetof()

Tobias Schramm (1):
      serial: atmel: fix incorrect baudrate setup

Yang Yingliang (1):
      net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()

YingChi Long (1):
      x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN

hongao (1):
      drm/amd/display: Fix set scaling doesn's work

