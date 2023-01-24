Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AC26790F1
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 07:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjAXGap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 01:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbjAXG36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 01:29:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363AD3CE03;
        Mon, 23 Jan 2023 22:29:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2932061203;
        Tue, 24 Jan 2023 06:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12DEC4339B;
        Tue, 24 Jan 2023 06:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674541752;
        bh=J/9CKG2hWvxfyd4T4U1DX49SVb1uEG82Buj0ex0aNN4=;
        h=From:To:Cc:Subject:Date:From;
        b=AhYA8NUluWHT8U5EBR2eZ67Zeeoykg54i9MOLGw32W3PUp/9jHyavuSdaxaVn+q7y
         nbeoL4cks/VCG9/r0TnzVcv1RBXFPSJJ90AFIi5E/gm+N3rFaLDHsldl6bjqCubgPc
         dJhdBvChB4mxbCRcOsIV/qmZ0nDm93wTmNN943BU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.8
Date:   Tue, 24 Jan 2023 07:28:57 +0100
Message-Id: <1674541737240193@kroah.com>
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

I'm announcing the release of the 6.1.8 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-kernel-oops_count                           |    6 
 Documentation/ABI/testing/sysfs-kernel-warn_count                           |    6 
 Documentation/admin-guide/sysctl/kernel.rst                                 |   19 
 Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml            |   78 +++
 Documentation/devicetree/bindings/phy/amlogic,g12a-usb3-pcie-phy.yaml       |   59 ++
 Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml      |   78 ---
 Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml |   59 --
 MAINTAINERS                                                                 |    2 
 Makefile                                                                    |    2 
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts                                  |   20 
 arch/arm/boot/dts/qcom-apq8084.dtsi                                         |    4 
 arch/arm/mach-omap1/Kconfig                                                 |    5 
 arch/arm/mach-omap1/Makefile                                                |    4 
 arch/arm/mach-omap1/io.c                                                    |   32 -
 arch/arm/mach-omap1/mcbsp.c                                                 |   21 
 arch/arm/mach-omap1/pm.h                                                    |    7 
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                                   |   12 
 arch/arm64/include/asm/efi.h                                                |    3 
 arch/arm64/kernel/efi-rt-wrapper.S                                          |   14 
 arch/arm64/kernel/efi.c                                                     |   27 +
 arch/loongarch/kernel/cpu-probe.c                                           |    2 
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi                                  |    2 
 arch/x86/events/rapl.c                                                      |    5 
 arch/x86/kernel/fpu/init.c                                                  |    7 
 arch/x86/lib/iomap_copy_64.S                                                |    2 
 block/mq-deadline.c                                                         |    4 
 drivers/accessibility/speakup/spk_ttyio.c                                   |    3 
 drivers/acpi/prmt.c                                                         |   10 
 drivers/block/pktcdvd.c                                                     |    2 
 drivers/bluetooth/hci_qca.c                                                 |    7 
 drivers/comedi/drivers/adv_pci1760.c                                        |    2 
 drivers/dma-buf/dma-buf-sysfs-stats.c                                       |    7 
 drivers/dma-buf/dma-buf-sysfs-stats.h                                       |    4 
 drivers/dma-buf/dma-buf.c                                                   |   84 +--
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c                              |    6 
 drivers/dma/idxd/device.c                                                   |   16 
 drivers/dma/lgm/lgm-dma.c                                                   |   10 
 drivers/dma/tegra210-adma.c                                                 |    2 
 drivers/firmware/google/gsmi.c                                              |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c                               |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                                     |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c                                     |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c                                     |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                                     |    1 
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c                                      |   22 
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c                                      |    1 
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c                                      |    3 
 drivers/gpu/drm/amd/amdgpu/soc21.c                                          |   19 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                           |   10 
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c                       |    4 
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c                                   |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c                             |    7 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                              |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c                        |   17 
 drivers/gpu/drm/i915/display/skl_universal_plane.c                          |    2 
 drivers/gpu/drm/i915/i915_driver.c                                          |    5 
 drivers/gpu/drm/i915/i915_pci.c                                             |    3 
 drivers/gpu/drm/i915/i915_switcheroo.c                                      |    6 
 drivers/infiniband/ulp/srp/ib_srp.h                                         |    8 
 drivers/misc/fastrpc.c                                                      |   67 +--
 drivers/misc/mei/bus.c                                                      |   12 
 drivers/misc/mei/hw-me-regs.h                                               |    2 
 drivers/misc/mei/pci-me.c                                                   |    2 
 drivers/misc/vmw_vmci/vmci_guest.c                                          |   49 --
 drivers/mmc/host/sdhci-esdhc-imx.c                                          |   22 
 drivers/mmc/host/sunxi-mmc.c                                                |    8 
 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c                      |    2 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c                    |   11 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h                    |    2 
 drivers/net/ethernet/mellanox/mlx5/core/health.c                            |    1 
 drivers/net/ethernet/realtek/r8169_main.c                                   |   58 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c                     |    2 
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c                                |    5 
 drivers/of/fdt.c                                                            |   28 -
 drivers/soc/qcom/apr.c                                                      |    3 
 drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h             |    2 
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h               |    4 
 drivers/thunderbolt/retimer.c                                               |   20 
 drivers/thunderbolt/tb.c                                                    |   20 
 drivers/thunderbolt/tunnel.c                                                |    2 
 drivers/thunderbolt/xdomain.c                                               |   17 
 drivers/tty/serial/8250/8250_exar.c                                         |   14 
 drivers/tty/serial/amba-pl011.c                                             |    8 
 drivers/tty/serial/atmel_serial.c                                           |    8 
 drivers/tty/serial/pch_uart.c                                               |    2 
 drivers/tty/serial/qcom_geni_serial.c                                       |   18 
 drivers/usb/cdns3/cdns3-gadget.c                                            |   12 
 drivers/usb/core/hub.c                                                      |   13 
 drivers/usb/core/usb-acpi.c                                                 |   65 ++
 drivers/usb/gadget/configfs.c                                               |   12 
 drivers/usb/gadget/function/f_ncm.c                                         |    4 
 drivers/usb/gadget/legacy/inode.c                                           |   28 -
 drivers/usb/gadget/legacy/webcam.c                                          |    3 
 drivers/usb/host/ehci-fsl.c                                                 |    2 
 drivers/usb/host/xhci-pci.c                                                 |   45 ++
 drivers/usb/host/xhci-ring.c                                                |    5 
 drivers/usb/host/xhci.c                                                     |   18 
 drivers/usb/host/xhci.h                                                     |    5 
 drivers/usb/misc/iowarrior.c                                                |    2 
 drivers/usb/misc/onboard_usb_hub.c                                          |   18 
 drivers/usb/musb/omap2430.c                                                 |    4 
 drivers/usb/serial/cp210x.c                                                 |    1 
 drivers/usb/serial/option.c                                                 |   17 
 drivers/usb/storage/uas-detect.h                                            |   13 
 drivers/usb/storage/unusual_uas.h                                           |    7 
 drivers/usb/typec/altmodes/displayport.c                                    |   22 
 drivers/usb/typec/tcpm/tcpm.c                                               |    7 
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                                          |    5 
 drivers/vdpa/mlx5/core/mr.c                                                 |   44 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                           |   68 ---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c                                        |    3 
 drivers/vdpa/vdpa_user/vduse_dev.c                                          |    3 
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c                                  |   28 -
 drivers/virtio/virtio_pci_modern.c                                          |    2 
 fs/btrfs/disk-io.c                                                          |    9 
 fs/btrfs/extent-tree.c                                                      |    7 
 fs/btrfs/file.c                                                             |   13 
 fs/btrfs/qgroup.c                                                           |   39 +
 fs/btrfs/tree-log.c                                                         |   47 +-
 fs/btrfs/volumes.c                                                          |   11 
 fs/cifs/connect.c                                                           |   16 
 fs/cifs/inode.c                                                             |    6 
 fs/cifs/misc.c                                                              |   45 --
 fs/cifs/smb2inode.c                                                         |   45 +-
 fs/cifs/smb2ops.c                                                           |   28 +
 fs/cifs/smb2pdu.c                                                           |   26 -
 fs/f2fs/extent_cache.c                                                      |    3 
 fs/nfs/filelayout/filelayout.c                                              |    8 
 fs/nilfs2/btree.c                                                           |   15 
 fs/ntfs3/attrib.c                                                           |    2 
 fs/userfaultfd.c                                                            |   28 -
 fs/zonefs/super.c                                                           |   22 
 include/linux/panic.h                                                       |    1 
 include/linux/soc/ti/omap1-io.h                                             |    4 
 include/linux/usb.h                                                         |    3 
 include/trace/events/btrfs.h                                                |    2 
 io_uring/poll.c                                                             |    6 
 kernel/bpf/offload.c                                                        |    3 
 kernel/bpf/syscall.c                                                        |    6 
 kernel/bpf/task_iter.c                                                      |   39 +
 kernel/exit.c                                                               |   62 ++
 kernel/kcsan/report.c                                                       |    3 
 kernel/panic.c                                                              |   48 ++
 kernel/sched/core.c                                                         |    3 
 kernel/sys.c                                                                |    2 
 lib/ubsan.c                                                                 |    3 
 mm/hugetlb.c                                                                |   95 ++--
 mm/kasan/report.c                                                           |    4 
 mm/kfence/report.c                                                          |    3 
 mm/khugepaged.c                                                             |   16 
 mm/mmap.c                                                                   |    4 
 mm/nommu.c                                                                  |    9 
 mm/shmem.c                                                                  |    6 
 net/bluetooth/hci_sync.c                                                    |    6 
 net/ethtool/ioctl.c                                                         |    3 
 net/ipv4/tcp_ulp.c                                                          |    2 
 net/mac80211/agg-tx.c                                                       |    6 
 net/mac80211/cfg.c                                                          |    7 
 net/mac80211/driver-ops.c                                                   |    3 
 net/mac80211/iface.c                                                        |    5 
 net/mac80211/rx.c                                                           |  222 ++++------
 net/mptcp/pm.c                                                              |   25 +
 net/mptcp/pm_userspace.c                                                    |    7 
 net/mptcp/protocol.c                                                        |    2 
 net/mptcp/protocol.h                                                        |    6 
 net/mptcp/subflow.c                                                         |    9 
 tools/testing/memblock/.gitignore                                           |    1 
 tools/testing/memblock/Makefile                                             |    3 
 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c                 |    9 
 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c                 |   42 +
 tools/testing/selftests/net/cmsg_sender.c                                   |    2 
 tools/testing/selftests/net/mptcp/userspace_pm.sh                           |   47 ++
 tools/testing/selftests/proc/proc-empty-vm.c                                |   12 
 tools/testing/selftests/proc/proc-pid-vm.c                                  |    9 
 tools/virtio/vringh_test.c                                                  |    2 
 175 files changed, 1761 insertions(+), 982 deletions(-)

Aaron Thompson (1):
      memblock tests: Fix compilation error.

Abel Vesa (2):
      misc: fastrpc: Fix use-after-free and race in fastrpc_map_find
      misc: fastrpc: Don't remove map on creater_process and device_release

Alan Stern (1):
      USB: gadgetfs: Fix race between mounting and unmounting

Alex Deucher (2):
      drm/amd/display: disable S/G display on DCN 3.1.5
      drm/amd/display: disable S/G display on DCN 3.1.4

Alexander Stein (1):
      usb: host: ehci-fsl: Fix module alias

Alexander Usyskin (2):
      mei: bus: fix unlink on bus in error path
      mei: me: add meteor lake point M DID

Alexander Wetzel (1):
      wifi: mac80211: sdata can be NULL during AMPDU start

Alexey Dobriyan (1):
      proc: fix PIE proc-empty-vm, proc-pid-vm tests

Ali Mirghasemi (1):
      USB: serial: option: add Quectel EC200U modem

Aloka Dixit (1):
      wifi: mac80211: reset multiple BSSID options in stop_ap()

Alon Zahavi (1):
      fs/ntfs3: Fix attr_punch_hole() null pointer derenference

Angus Chen (1):
      virtio_pci: modify ENOENT to EINVAL

Anuradha Weeraman (1):
      net: ethernet: marvell: octeontx2: Fix uninitialized variable warning

Ard Biesheuvel (3):
      ACPI: PRM: Check whether EFI runtime is available
      arm64: efi: Execute runtime services from a dedicated stack
      efi: rt-wrapper: Add missing include

Arend van Spriel (1):
      wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices

Arnd Bergmann (3):
      fbdev: omapfb: avoid stack overflow warning
      staging: vchiq_arm: fix enum vchiq_status return types
      ARM: omap1: fix !ARCH_OMAP1_ANY link failures

Ben Dooks (1):
      riscv: dts: sifive: fu740: fix size of pcie 32bit memory

Chanh Nguyen (1):
      USB: gadget: Add ID numbers to configfs-gadget driver names

ChiYuan Huang (1):
      usb: typec: tcpm: Fix altmode re-registration causes sysfs create fail

Chris Wilson (1):
      perf/x86/rapl: Treat Tigerlake like Icelake

Christian König (2):
      dma-buf: fix dma_buf_export init order v2
      drm/amdgpu: fix amdgpu_job_free_resources v2

Chunhao Lin (2):
      r8169: move rtl_wol_enable_rx() and rtl_prepare_power_down()
      r8169: fix dmar pte write access is not set error

Cindy Lu (1):
      vdpa_sim_net: should not drop the multicast/broadcast packet

Damien Le Moal (2):
      zonefs: Detect append writes at invalid locations
      block: mq-deadline: Rename deadline_is_seq_writes()

Daniel Scally (1):
      usb: gadget: g_webcam: Send color matching descriptor per frame

Daniil Tatianin (1):
      net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats

David Hildenbrand (3):
      mm/hugetlb: fix PTE marker handling in hugetlb_change_protection()
      mm/hugetlb: fix uffd-wp handling for migration entries in hugetlb_change_protection()
      mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA

Drew Davenport (1):
      drm/i915/display: Check source height is > 0

Duke Xin(辛安文) (5):
      USB: serial: option: add Quectel EM05-G (GR) modem
      USB: serial: option: add Quectel EM05-G (CS) modem
      USB: serial: option: add Quectel EM05-G (RS) modem
      USB: serial: option: add Quectel EM05CN (SG) modem
      USB: serial: option: add Quectel EM05CN modem

Eli Cohen (3):
      vdpa/mlx5: Return error on vlan ctrl commands if not supported
      vdpa/mlx5: Avoid using reslock in event_handler
      vdpa/mlx5: Avoid overwriting CVQ iotlb

Enzo Matsumiya (1):
      cifs: do not include page data when checking signature

Eric Dumazet (1):
      Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()"

Felix Fietkau (2):
      wifi: mac80211: fix MLO + AP_VLAN check
      wifi: mac80211: fix initialization of rx->link and rx->link_sta

Filipe Manana (7):
      btrfs: fix missing error handling when logging directory items
      btrfs: fix directory logging due to race with concurrent index key deletion
      btrfs: add missing setup of log for full commit at add_conflicting_inode()
      btrfs: do not abort transaction on failure to write log tree when syncing log
      btrfs: do not abort transaction on failure to update log root
      btrfs: fix invalid leaf access due to inline extent during lseek
      btrfs: fix race between quota rescan and disable leading to NULL pointer deref

Flavio Suligoi (1):
      usb: core: hub: disable autosuspend for TI TUSB8041

Gaosheng Cui (1):
      tty: fix possible null-ptr-defer in spk_ttyio_release

Geetha sowjanya (1):
      octeontx2-pf: Avoid use of GFP_KERNEL in atomic context

Greg Kroah-Hartman (4):
      Revert "serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler"
      prlimit: do_prlimit needs to have a speculation check
      USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100
      Linux 6.1.8

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting

Hao Sun (1):
      selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID

Harshit Mogalapalli (1):
      vduse: Validate vq_num in vduse_validate_config()

Heiner Kallweit (2):
      dt-bindings: phy: g12a-usb2-phy: fix compatible string documentation
      dt-bindings: phy: g12a-usb3-pcie-phy: fix compatible string documentation

Huacai Chen (1):
      LoongArch: Add HWCAP_LOONGARCH_CPUCFG to elf_hwcap

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

Jann Horn (1):
      exit: Put an upper limit on how often we can oops

Jens Axboe (2):
      pktcdvd: check for NULL returna fter calling bio_split_to_limits()
      io_uring/poll: don't reissue in case of poll race on multishot request

Jimmy Hu (1):
      usb: xhci: Check endpoint is valid before dereferencing it

Jiri Slaby (SUSE) (1):
      RDMA/srp: Move large values to a new enum for gcc13

Johannes Berg (1):
      wifi: iwlwifi: fw: skip PPAG for JF

Joshua Ashton (2):
      drm/amd/display: Calculate output_color_space after pixel encoding adjustment
      drm/amd/display: Fix COLOR_SPACE_YCBCR2020_TYPE matrix

Juhyung Park (1):
      usb-storage: apply IGNORE_UAS only for HIKSEMI MD202 on RTL9210

Kees Cook (8):
      panic: Separate sysctl logic from CONFIG_SMP
      exit: Expose "oops_count" to sysfs
      exit: Allow oops_limit to be disabled
      panic: Consolidate open-coded panic_on_warn checks
      panic: Introduce warn_limit
      panic: Expose "warn_count" to sysfs
      docs: Fix path paste-o for /sys/kernel/warn_count
      exit: Use READ_ONCE() for all oops/warn limit reads

Kevin Hao (1):
      octeontx2-pf: Fix the use of GFP_KERNEL in atomic context on rt

Khazhismel Kumykov (1):
      gsmi: fix null-deref in gsmi_get_variable

Krzysztof Kozlowski (3):
      Bluetooth: hci_qca: Fix driver shutdown on closed serdev
      tty: serial: qcom-geni-serial: fix slab-out-of-bounds on RX FIFO buffer
      ARM: dts: qcom: apq8084-ifc6540: fix overriding SDHCI

Kui-Feng Lee (1):
      bpf: keep a reference to the mm, in case the task is dead.

Lang Yu (2):
      drm/amdgpu: allow multipipe policy on ASICs with one MEC
      drm/amdgpu: correct MEC number for gfx11 APUs

Li Jun (1):
      arm64: dts: imx8mp: correct usb clocks

Liam Howlett (3):
      nommu: fix memory leak in do_mmap() error path
      nommu: fix do_munmap() error path
      nommu: fix split_vma() map_count error

Lino Sanfilippo (1):
      serial: amba-pl011: fix high priority character transmission in rs486 mode

Luiz Augusto von Dentz (1):
      Bluetooth: hci_sync: Fix use HCI_OP_LE_READ_BUFFER_SIZE_V2

Maciej Żenczykowski (1):
      usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()

Marek Vasut (1):
      serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler

Mathias Nyman (5):
      xhci: Fix null pointer dereference when host dies
      xhci: Add update_hub_device override for PCI xHCI hosts
      xhci: Add a flag to disable USB3 lpm on a xhci root port level.
      usb: acpi: add helper to check port lpm capability using acpi _DSM
      xhci: Detect lpm incapable xHC USB3 roothub ports from ACPI tables

Matthew Howell (1):
      serial: exar: Add support for Sealevel 7xxxC serial cards

Matthias Kaehlcke (2):
      usb: misc: onboard_hub: Invert driver registration order
      usb: misc: onboard_hub: Move 'attach' work to the driver

Matthieu Baerts (2):
      mptcp: netlink: respect v4/v6-only sockets
      selftests: mptcp: userspace: validate v4-v6 subflows mix

Michael Adler (1):
      USB: serial: cp210x: add SCALANCE LPE-9000 device id

Mika Westerberg (3):
      thunderbolt: Disable XDomain lane 1 only in software connection manager
      thunderbolt: Use correct function to calculate maximum USB3 link rate
      thunderbolt: Do not call PM runtime functions in tb_retimer_scan()

Mikulas Patocka (1):
      x86/asm: Fix an assembler warning with current binutils

Mohan Kumar (1):
      dmaengine: tegra210-adma: fix global intr clear

Naohiro Aota (1):
      btrfs: fix trace event name typo for FLUSH_DELAYED_REFS

Nirmoy Das (1):
      drm/i915: Remove unused variable

Ola Jeppsson (1):
      misc: fastrpc: Fix use-after-free race condition for maps

Olga Kornievskaia (1):
      pNFS/filelayout: Fix coalescing test for single DS

Paolo Abeni (2):
      mptcp: explicitly specify sock family at subflow creation time
      net/ulp: use consistent error code when blocking ULP

Paul Moore (1):
      bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and PERF_BPF_EVENT_PROG_UNLOAD

Paulo Alcantara (2):
      cifs: fix race in assemble_neg_contexts()
      cifs: reduce roundtrips on create/qinfo requests

Pawel Laszczak (1):
      usb: cdns3: remove fetched trb from cache before dequeuing

Peter Harliman Liem (1):
      dmaengine: lgm: Move DT parsing after initialization

Peter Xu (1):
      mm/hugetlb: pre-allocate pgtable pages for uffd wr-protects

Po-Hsu Lin (1):
      selftests: net: fix cmsg_so_mark.sh test hang

Prashant Malani (2):
      usb: typec: altmodes/displayport: Add pin assignment helper
      usb: typec: altmodes/displayport: Fix pin assignment calculation

Qu Wenruo (3):
      btrfs: always report error in run_one_delayed_ref()
      btrfs: add extra error messages to cover non-ENOMEM errors from device_add_list()
      btrfs: qgroup: do not warn on record without old_roots populated

Reinette Chatre (3):
      dmaengine: idxd: Let probe fail when workqueue cannot be enabled
      dmaengine: idxd: Prevent use after free on completion memory
      dmaengine: idxd: Do not call DMX TX callbacks during workqueue disable

Ricardo Cañuelo (1):
      tools/virtio: initialize spinlocks in vring_test.c

Ricardo Ribalda (1):
      xhci-pci: set the dma max_seg_size

Rob Herring (1):
      of: fdt: Honor CONFIG_CMDLINE* even without /chosen node, take 2

Ryusuke Konishi (1):
      nilfs2: fix general protection fault in nilfs_btree_insert()

Samuel Holland (1):
      mmc: sunxi-mmc: Fix clock refcount imbalance during unbind

Sasa Dragic (1):
      drm/i915: re-disable RC6p on Sandy Bridge

Shawn.Shao (1):
      Add exception protection processing for vd in axi_chan_handle_err function

Stephan Gerhold (1):
      soc: qcom: apr: Make qcom,protection-domain optional again

Thomas Zimmermann (1):
      drm/i915: Allow switching away via vga-switcheroo if uninitialized

Tim Huang (8):
      drm/amdgpu/discovery: add PSP IP v13.0.11 support
      drm/amdgpu/soc21: add mode2 asic reset for SMU IP v13.0.11
      drm/amdgpu/pm: use the specific mailbox registers only for SMU IP v13.0.4
      drm/amdgpu: enable PSP IP v13.0.11 support
      drm/amdgpu: enable GFX IP v11.0.4 CG support
      drm/amdgpu: enable GFX Power Gating for GC IP v11.0.4
      drm/amdgpu: enable GFX Clock Gating control for GC IP v11.0.4
      drm/amdgpu: add tmz support for GC IP v11.0.4

Tobias Schramm (1):
      serial: atmel: fix incorrect baudrate setup

Utkarsh Patel (1):
      thunderbolt: Do not report errors if on-board retimers are found

Vishnu Dasa (1):
      VMCI: Use threaded irqs instead of tasklets

Yang Yingliang (2):
      usb: musb: fix error return code in omap2430_probe()
      net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()

Yifan Zhang (13):
      drm/amdgpu/discovery: enable soc21 common for GC 11.0.4
      drm/amdgpu/discovery: enable gmc v11 for GC 11.0.4
      drm/amdgpu/discovery: enable gfx v11 for GC 11.0.4
      drm/amdgpu/discovery: enable mes support for GC v11.0.4
      drm/amdgpu: set GC 11.0.4 family
      drm/amdgpu/discovery: set the APU flag for GC 11.0.4
      drm/amdgpu: add gfx support for GC 11.0.4
      drm/amdgpu: add gmc v11 support for GC 11.0.4
      drm/amdgpu/pm: enable swsmu for SMU IP v13.0.11
      drm/amdgpu: add smu 13 support for smu 13.0.11
      drm/amdgpu/pm: add GFXOFF control IP version check for SMU IP v13.0.11
      drm/amdgpu/discovery: enable nbio support for NBIO v7.7.1
      drm/amdgpu: add tmz support for GC 11.0.1

YingChi Long (1):
      x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN

Zach O'Keefe (2):
      mm/shmem: restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE
      mm/MADV_COLLAPSE: don't expand collapse when vm_end is past requested end

Zhang Rui (2):
      perf/x86/rapl: Add support for Intel Meteor Lake
      perf/x86/rapl: Add support for Intel Emerald Rapids

hongao (1):
      drm/amd/display: Fix set scaling doesn's work

jie1zhan (1):
      drm/amdgpu: Correct the power calcultion for Renior/Cezanne.

