Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97FB57DC93
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 10:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiGVImj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 04:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiGVImi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 04:42:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334619E2B7;
        Fri, 22 Jul 2022 01:42:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA09C61E09;
        Fri, 22 Jul 2022 08:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D929C341C6;
        Fri, 22 Jul 2022 08:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658479354;
        bh=KWGsbjqZnXcFA5bpW7QxkemfWUaC/ZPIVLqSQzrLPw8=;
        h=From:To:Cc:Subject:Date:From;
        b=Dl7R8tkX7dxPxnZDb0XKvpT6mJsCZ13poYPXHHx4kwA4AgGzJmxlJIO4Y2VMlQtrU
         QQC4zZpMR6JkBeg/qGbDxevfFqm65rK/Uec2tcvdJycRNF8Ji6MOgaFNu64TqMJ1Vi
         Wjj2jQuT9ClCY7b86QQYLPIIbArUlCK0RlAE2dVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.13
Date:   Fri, 22 Jul 2022 10:42:29 +0200
Message-Id: <16584793491379@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.18.13 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/sound/qcom,lpass-cpu.yaml |    8 
 Documentation/driver-api/firmware/other_interfaces.rst      |    6 
 Documentation/filesystems/netfs_library.rst                 |    8 
 Documentation/networking/ip-sysctl.rst                      |    4 
 Makefile                                                    |    2 
 arch/arm/boot/dts/imx6qdl-ts7970.dtsi                       |    2 
 arch/arm/boot/dts/sama5d2.dtsi                              |    2 
 arch/arm/boot/dts/stm32mp151.dtsi                           |    2 
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts           |    2 
 arch/arm/include/asm/domain.h                               |   13 
 arch/arm/include/asm/mach/map.h                             |    1 
 arch/arm/include/asm/ptrace.h                               |   26 +
 arch/arm/mm/Kconfig                                         |    6 
 arch/arm/mm/alignment.c                                     |    3 
 arch/arm/mm/mmu.c                                           |   15 
 arch/arm/mm/proc-v7-bugs.c                                  |    9 
 arch/arm/probes/decode.h                                    |   26 -
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi           |    8 
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi           |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi              |    5 
 arch/powerpc/sysdev/xive/spapr.c                            |    5 
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi           |    4 
 arch/riscv/kvm/vcpu.c                                       |    2 
 arch/s390/Makefile                                          |    8 
 arch/s390/lib/Makefile                                      |    3 
 arch/s390/lib/expoline.S                                    |   12 
 arch/s390/lib/expoline/Makefile                             |    3 
 arch/s390/lib/expoline/expoline.S                           |   12 
 arch/sh/include/asm/io.h                                    |    8 
 arch/x86/include/asm/setup.h                                |    3 
 arch/x86/kernel/acpi/cppc.c                                 |    6 
 arch/x86/kernel/head64.c                                    |    4 
 arch/x86/kvm/x86.c                                          |   18 
 arch/x86/mm/init.c                                          |   14 
 arch/x86/xen/enlighten_pv.c                                 |    8 
 arch/x86/xen/xen-head.S                                     |   10 
 drivers/acpi/acpi_video.c                                   |   11 
 drivers/cpufreq/pmac32-cpufreq.c                            |    4 
 drivers/firmware/sysfb.c                                    |   58 ++
 drivers/firmware/sysfb_simplefb.c                           |   16 
 drivers/gpio/gpio-sim.c                                     |   16 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                 |   25 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c                    |    3 
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c                      |    3 
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c                      |    3 
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c                       |    3 
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c                       |    3 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                     |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   85 +++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h           |    8 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   17 
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c           |   11 
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c              |    2 
 drivers/gpu/drm/drm_aperture.c                              |   26 -
 drivers/gpu/drm/i915/display/intel_dp_mst.c                 |    1 
 drivers/gpu/drm/i915/gem/i915_gem_region.c                  |    2 
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c                     |   11 
 drivers/gpu/drm/i915/gt/intel_gt.c                          |   15 
 drivers/gpu/drm/i915/gt/intel_reset.c                       |   37 +
 drivers/gpu/drm/i915/gt/selftest_lrc.c                      |    8 
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c                    |    9 
 drivers/gpu/drm/i915/gvt/cmd_parser.c                       |    6 
 drivers/gpu/drm/i915/i915_scatterlist.c                     |   27 -
 drivers/gpu/drm/i915/i915_scatterlist.h                     |    6 
 drivers/gpu/drm/i915/intel_region_ttm.c                     |   10 
 drivers/gpu/drm/i915/intel_region_ttm.h                     |    3 
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c               |    2 
 drivers/gpu/drm/i915/selftests/intel_memory_region.c        |   21 -
 drivers/gpu/drm/i915/selftests/mock_region.c                |    3 
 drivers/gpu/drm/panfrost/panfrost_drv.c                     |    4 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                     |    2 
 drivers/irqchip/irq-or1k-pic.c                              |    1 
 drivers/net/can/xilinx_can.c                                |    4 
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c        |   23 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |    5 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                   |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c           |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c               |   13 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c             |    7 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |    2 
 drivers/net/ethernet/faraday/ftgmac100.c                    |   15 
 drivers/net/ethernet/intel/ice/ice_devids.h                 |    1 
 drivers/net/ethernet/intel/ice/ice_devlink.c                |   59 +-
 drivers/net/ethernet/intel/ice/ice_fw_update.c              |   96 ++++
 drivers/net/ethernet/intel/ice/ice_main.c                   |    1 
 drivers/net/ethernet/marvell/prestera/prestera_router.c     |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c          |   20 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c  |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c  |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c             |   39 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c        |    5 
 drivers/net/ethernet/mscc/ocelot_fdma.c                     |   17 
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c                |   33 +
 drivers/net/ethernet/sfc/ef10.c                             |    3 
 drivers/net/ethernet/sfc/ef10_sriov.c                       |   10 
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c     |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c         |    6 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                    |   17 
 drivers/net/phy/sfp.c                                       |    2 
 drivers/net/xen-netback/rx.c                                |    1 
 drivers/nfc/nxp-nci/i2c.c                                   |    8 
 drivers/nvme/host/core.c                                    |    8 
 drivers/nvme/host/nvme.h                                    |    1 
 drivers/nvme/host/pci.c                                     |    3 
 drivers/nvme/host/rdma.c                                    |   12 
 drivers/nvme/host/tcp.c                                     |   13 
 drivers/nvme/host/trace.h                                   |    2 
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                     |    4 
 drivers/pinctrl/freescale/pinctrl-imx93.c                   |    1 
 drivers/platform/x86/hp-wmi.c                               |    3 
 drivers/platform/x86/intel/pmc/core.c                       |    1 
 drivers/platform/x86/thinkpad_acpi.c                        |   50 +-
 drivers/power/supply/power_supply_core.c                    |   24 -
 drivers/s390/crypto/ap_bus.c                                |    2 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                      |    7 
 drivers/scsi/megaraid/megaraid_sas_base.c                   |    3 
 drivers/scsi/ufs/ufshcd.c                                   |    2 
 drivers/soc/ixp4xx/ixp4xx-npe.c                             |    2 
 drivers/spi/spi-amd.c                                       |    8 
 drivers/tee/tee_core.c                                      |    2 
 drivers/tty/pty.c                                           |   14 
 drivers/tty/serial/8250/8250_core.c                         |    4 
 drivers/tty/serial/8250/8250_port.c                         |    4 
 drivers/tty/serial/amba-pl011.c                             |   23 +
 drivers/tty/serial/mvebu-uart.c                             |   25 -
 drivers/tty/serial/samsung_tty.c                            |    5 
 drivers/tty/serial/serial_core.c                            |    5 
 drivers/tty/serial/stm32-usart.c                            |    2 
 drivers/tty/tty.h                                           |    3 
 drivers/tty/tty_buffer.c                                    |   46 +-
 drivers/tty/vt/vt.c                                         |    2 
 drivers/usb/dwc3/gadget.c                                   |    4 
 drivers/usb/serial/ftdi_sio.c                               |    3 
 drivers/usb/serial/ftdi_sio_ids.h                           |    6 
 drivers/usb/typec/class.c                                   |    1 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                           |   31 -
 drivers/vdpa/vdpa_user/vduse_dev.c                          |   60 +-
 drivers/video/fbdev/core/fbmem.c                            |   12 
 drivers/virtio/virtio_mmio.c                                |   26 +
 drivers/xen/gntdev.c                                        |    6 
 fs/afs/file.c                                               |    2 
 fs/btrfs/inode.c                                            |   14 
 fs/btrfs/zoned.c                                            |   13 
 fs/ceph/addr.c                                              |   11 
 fs/cifs/smb2pdu.c                                           |   13 
 fs/exec.c                                                   |    2 
 fs/ksmbd/transport_tcp.c                                    |    2 
 fs/lockd/svcsubs.c                                          |   14 
 fs/netfs/buffered_read.c                                    |   17 
 fs/nfsd/nfs4xdr.c                                           |    9 
 fs/nfsd/nfsd.h                                              |    3 
 fs/nilfs2/nilfs.h                                           |    3 
 fs/remap_range.c                                            |    3 
 include/linux/cgroup-defs.h                                 |    3 
 include/linux/kexec.h                                       |    6 
 include/linux/netfs.h                                       |    2 
 include/linux/nvme.h                                        |    2 
 include/linux/reset.h                                       |    2 
 include/linux/sched/task.h                                  |    2 
 include/linux/serial_core.h                                 |    5 
 include/linux/sysfb.h                                       |   22 -
 include/net/netfilter/nf_conntrack.h                        |    9 
 include/net/netfilter/nf_conntrack_ecache.h                 |    4 
 include/net/netfilter/nf_tables.h                           |   30 -
 include/net/netns/conntrack.h                               |    1 
 include/net/raw.h                                           |    2 
 include/net/sock.h                                          |    2 
 include/net/tls.h                                           |    4 
 include/trace/events/sock.h                                 |    6 
 kernel/cgroup/cgroup.c                                      |   37 +
 kernel/exit.c                                               |    2 
 kernel/kexec_file.c                                         |   11 
 kernel/signal.c                                             |    8 
 kernel/sysctl.c                                             |   57 +-
 kernel/time/posix-timers.c                                  |   19 
 kernel/trace/trace.c                                        |   11 
 kernel/trace/trace_events_hist.c                            |    2 
 mm/damon/vaddr.c                                            |    3 
 mm/memory.c                                                 |   27 -
 mm/sparse-vmemmap.c                                         |    8 
 mm/userfaultfd.c                                            |    5 
 net/8021q/vlan_netlink.c                                    |   10 
 net/bridge/br_netfilter_hooks.c                             |   21 -
 net/core/filter.c                                           |    1 
 net/ipv4/af_inet.c                                          |    4 
 net/ipv4/cipso_ipv4.c                                       |   12 
 net/ipv4/fib_semantics.c                                    |    4 
 net/ipv4/fib_trie.c                                         |    2 
 net/ipv4/icmp.c                                             |   20 
 net/ipv4/inet_timewait_sock.c                               |    3 
 net/ipv4/inetpeer.c                                         |   12 
 net/ipv4/nexthop.c                                          |    5 
 net/ipv4/syncookies.c                                       |    2 
 net/ipv4/sysctl_net_ipv4.c                                  |   12 
 net/ipv4/tcp.c                                              |    3 
 net/ipv4/tcp_input.c                                        |    2 
 net/ipv4/tcp_output.c                                       |    4 
 net/ipv6/icmp.c                                             |    2 
 net/ipv6/route.c                                            |    2 
 net/ipv6/seg6_iptunnel.c                                    |    5 
 net/ipv6/seg6_local.c                                       |    2 
 net/mac80211/wme.c                                          |    4 
 net/mptcp/protocol.c                                        |    4 
 net/netfilter/nf_conntrack_core.c                           |   86 ++--
 net/netfilter/nf_conntrack_ecache.c                         |  139 +++---
 net/netfilter/nf_conntrack_netlink.c                        |  125 ++++--
 net/netfilter/nf_conntrack_standalone.c                     |    3 
 net/netfilter/nf_log_syslog.c                               |    8 
 net/netfilter/nf_tables_api.c                               |   72 ++-
 net/netfilter/nf_tables_core.c                              |   24 +
 net/netfilter/nf_tables_trace.c                             |   44 +-
 net/tipc/socket.c                                           |    1 
 net/tls/tls_device.c                                        |    4 
 net/tls/tls_main.c                                          |    7 
 security/integrity/evm/evm_crypto.c                         |    7 
 security/integrity/ima/ima_appraise.c                       |    3 
 security/integrity/ima/ima_crypto.c                         |    1 
 security/integrity/ima/ima_efi.c                            |    2 
 sound/pci/hda/patch_conexant.c                              |    1 
 sound/pci/hda/patch_realtek.c                               |   20 
 sound/soc/codecs/cs35l41-lib.c                              |   10 
 sound/soc/codecs/cs35l41.c                                  |   12 
 sound/soc/codecs/cs47l15.c                                  |    5 
 sound/soc/codecs/madera.c                                   |   14 
 sound/soc/codecs/max98373-sdw.c                             |   12 
 sound/soc/codecs/rt1308-sdw.c                               |   11 
 sound/soc/codecs/rt1316-sdw.c                               |   11 
 sound/soc/codecs/rt5682-sdw.c                               |    5 
 sound/soc/codecs/rt700-sdw.c                                |    6 
 sound/soc/codecs/rt700.c                                    |   14 
 sound/soc/codecs/rt711-sdca-sdw.c                           |    9 
 sound/soc/codecs/rt711-sdca.c                               |   18 
 sound/soc/codecs/rt711-sdw.c                                |    9 
 sound/soc/codecs/rt711.c                                    |   16 
 sound/soc/codecs/rt715-sdca-sdw.c                           |   12 
 sound/soc/codecs/rt715-sdw.c                                |   12 
 sound/soc/codecs/sgtl5000.c                                 |    9 
 sound/soc/codecs/sgtl5000.h                                 |    1 
 sound/soc/codecs/tas2764.c                                  |   46 +-
 sound/soc/codecs/tas2764.h                                  |    6 
 sound/soc/codecs/wcd9335.c                                  |    8 
 sound/soc/codecs/wcd938x.c                                  |   12 
 sound/soc/codecs/wm5110.c                                   |    8 
 sound/soc/codecs/wm_adsp.c                                  |    2 
 sound/soc/intel/boards/bytcr_wm5102.c                       |   13 
 sound/soc/intel/boards/sof_sdw.c                            |   51 +-
 sound/soc/intel/skylake/skl-nhlt.c                          |   40 +
 sound/soc/soc-dapm.c                                        |    5 
 sound/soc/soc-ops.c                                         |    4 
 sound/soc/sof/intel/hda-dsp.c                               |   10 
 sound/soc/sof/intel/hda-loader.c                            |   10 
 sound/soc/sof/intel/hda.h                                   |    1 
 sound/usb/quirks-table.h                                    |  248 ++++++++++++
 sound/usb/quirks.c                                          |    9 
 tools/testing/selftests/wireguard/qemu/Makefile             |    5 
 tools/testing/selftests/wireguard/qemu/arch/arm.config      |    1 
 tools/testing/selftests/wireguard/qemu/arch/armeb.config    |    1 
 tools/testing/selftests/wireguard/qemu/arch/i686.config     |    1 
 tools/testing/selftests/wireguard/qemu/arch/m68k.config     |    1 
 tools/testing/selftests/wireguard/qemu/arch/mips.config     |    1 
 tools/testing/selftests/wireguard/qemu/arch/mipsel.config   |    1 
 tools/testing/selftests/wireguard/qemu/arch/powerpc.config  |    1 
 tools/testing/selftests/wireguard/qemu/init.c               |   11 
 264 files changed, 2390 insertions(+), 943 deletions(-)

Alex Deucher (2):
      drm/amdgpu: keep fbdev buffers pinned during suspend
      drm/amdgpu/display: disable prefer_shadow for generic fb helpers

Andrea Mayer (3):
      seg6: fix skb checksum evaluation in SRH encapsulation/insertion
      seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors
      seg6: bpf: fix skb checksum in bpf_push_seg6_encap()

Andrzej Hajda (1):
      drm/i915/selftests: fix subtraction overflow bug

Anup Patel (1):
      RISC-V: KVM: Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()

Ard Biesheuvel (2):
      ARM: 9214/1: alignment: advance IT state after emulating Thumb instruction
      ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle

Axel Rasmussen (1):
      mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages

Baolin Wang (1):
      mm/damon: use set_huge_pte_at() to make huge pte old

Baowen Zheng (1):
      nfp: fix issue of skb segments exceeds descriptor limitation

Bartosz Golaszewski (1):
      gpio: sim: fix the chip_name configfs item

Bjorn Andersson (1):
      scsi: ufs: core: Drop loglevel of WriteBoost message

Bryan O'Donoghue (1):
      ASoC: dt-bindings: Fix description for msm8916

Chanho Park (1):
      tty: serial: samsung_tty: set dma burst_size to 1

Charles Keepax (8):
      ASoC: wm_adsp: Fix event for preloader
      ASoC: wm5110: Fix DRE control
      ASoC: cs35l41: Correct some control names
      ASoC: dapm: Initialise kcontrol data for mux/demux controls
      ASoC: cs35l41: Add ASP TX3/4 source to register patch
      ASoC: cs47l15: Fix event generation for low power mux control
      ASoC: madera: Fix event generation for OUT1 demux
      ASoC: madera: Fix event generation for rate controls

Chia-Lin Kao (AceLan) (2):
      net: atlantic: remove deep parameter on suspend/resume functions
      net: atlantic: remove aq_nic_deinit() when resume

Chris Wilson (2):
      drm/i915/gt: Serialize GRDOM access between multiple engine resets
      drm/i915/gt: Serialize TLB invalidates with GT resets

Christoph Hellwig (1):
      btrfs: zoned: fix a leaked bioc in read_zone_info

Chuck Lever (1):
      NFSD: Decode NFSv4 birth time attribute

Coiby Xu (1):
      ima: force signature verification when CONFIG_KEXEC_SIG is configured

Conor Dooley (1):
      riscv: dts: microchip: hook up the mpfs' l2cache

Cristian Ciocaltea (1):
      spi: amd: Limit max transfer and message size

Dan Carpenter (3):
      drm/i915/gvt: IS_ERR() vs NULL bug in intel_gvt_update_reg_whitelist()
      drm/i915/selftests: fix a couple IS_ERR() vs NULL tests
      net: stmmac: fix leaks in probe

Daniele Ceraolo Spurio (1):
      drm/i915/guc: ADL-N should use the same GuC FW as ADL-S

Dave Chinner (1):
      fs/remap: constrain dedupe of EOF blocks

Demi Marie Obenour (1):
      xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Dmitry Osipenko (3):
      ARM: 9213/1: Print message about disabled Spectre workarounds only once
      drm/panfrost: Put mapping instead of shmem obj on panfrost_mmu_map_fault_addr() error
      drm/panfrost: Fix shrinker list corruption by madvise IOCTL

Dorian Rudolph (1):
      power: supply: core: Fix boundary conditions in interpolation

Douglas Anderson (1):
      tracing: Fix sleeping while atomic in kdb ftdump

Egor Vorontsov (2):
      ALSA: usb-audio: Add quirk for Fiero SC-01
      ALSA: usb-audio: Add quirk for Fiero SC-01 (fw v1.0.0)

Eli Cohen (1):
      vdpa/mlx5: Initialize CVQ vringh only once

Eric Dumazet (1):
      vlan: fix memory leak in vlan_newlink()

Fangzhi Zuo (1):
      drm/amd/display: Ignore First MST Sideband Message Return Error

Felix Fietkau (1):
      wifi: mac80211: fix queue selection for mesh/OCB interfaces

Filipe Manana (1):
      btrfs: return -EAGAIN for NOWAIT dio reads/writes on compressed and inline extents

Florian Westphal (8):
      netfilter: ecache: move to separate structure
      netfilter: conntrack: split inner loop of list dumping to own function
      netfilter: ecache: use dedicated list for event redelivery
      netfilter: conntrack: include ecache dying list in dumps
      netfilter: conntrack: remove the percpu dying list
      netfilter: conntrack: fix crash due to confirmed bit load reordering
      netfilter: nf_tables: avoid skb access on nf_stolen
      netfilter: br_netfilter: do not skip all hooks with 0 priority

Francesco Dolcini (1):
      ASoC: sgtl5000: Fix noise on shutdown/remove

Gabriel Fernandez (1):
      ARM: dts: stm32: use the correct clock source for CEC on stm32mp151

Gal Pressman (1):
      net/mlx5e: Fix capability check for updating vnic env counters

Gayatri Kammela (1):
      platform/x86: intel/pmc: Add Alder Lake N support to PMC core driver

Geert Uytterhoeven (1):
      sh: convert nommu io{re,un}map() to static inline functions

Gowans, James (1):
      mm: split huge PUD on wp_huge_pud fallback

Greg Kroah-Hartman (1):
      Linux 5.18.13

Hangyu Hua (2):
      drm/i915: fix a possible refcount leak in intel_dp_add_mst_connector()
      net: tipc: fix possible refcount leak in tipc_sk_create()

Hans de Goede (2):
      ASoC: Intel: bytcr_wm5102: Fix GPIO related probe-ordering problem
      ACPI: video: Fix acpi_video_handles_brightness_key_presses()

Haowen Bai (1):
      pinctrl: aspeed: Fix potential NULL dereference in aspeed_pinmux_set_mux()

Hector Martin (2):
      ASoC: tas2764: Correct playback volume range
      ASoC: tas2764: Fix amp gain register offset & default

Huaxin Lu (1):
      ima: Fix a potential integer overflow in ima_appraise_measurement

Ilpo Järvinen (3):
      serial: stm32: Clear prev values before setting RTS delays
      serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle
      serial: 8250: Fix PM usage_count for console handover

Israel Rukshin (1):
      nvme: fix block device naming collision

Jacky Bai (1):
      pinctrl: imx: Add the zero base flag for imx93

Jason A. Donenfeld (2):
      wireguard: selftests: set fake real time in init
      wireguard: selftests: always call kernel makefile

Javier Martinez Canillas (3):
      firmware: sysfb: Make sysfb_create_simplefb() return a pdev pointer
      firmware: sysfb: Add sysfb_disable() helper function
      fbdev: Disable sysfb device registration when removing conflicting FBs

Jeff Layton (2):
      lockd: set fl_owner when unlocking files
      lockd: fix nlm_close_files

Jeremy Szu (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP machines

Jianglei Nie (2):
      ima: Fix potential memory leak in ima_init_crypto()
      net: sfp: fix memory leak in sfp_probe()

Jiri Slaby (2):
      tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()
      tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()

John Garry (1):
      scsi: hisi_sas: Limit max hw sectors for v3 HW

John Veness (1):
      ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices

Jon Hunter (1):
      net: stmmac: dwc-qos: Disable split header for Tegra194

Juergen Gross (4):
      x86/xen: Use clear_bss() for Xen PV guests
      xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue
      x86: Clear .brk area at early boot
      x86/pat: Fix x86_has_pat_wp()

Kai-Heng Feng (1):
      platform/x86: hp-wmi: Ignore Sanitization Mode event

Kashyap Desai (1):
      bnxt_en: reclaim max resources if sriov enable fails

Keith Busch (2):
      nvme-pci: phison e16 has bogus namespace ids
      nvme: use struct group for generic command dwords

Kris Bahnsen (1):
      ARM: dts: imx6qdl-ts7970: Fix ngpio typo and count

Kuniyuki Iwashima (27):
      sysctl: Fix data races in proc_dointvec().
      sysctl: Fix data races in proc_douintvec().
      sysctl: Fix data races in proc_dointvec_minmax().
      sysctl: Fix data races in proc_douintvec_minmax().
      sysctl: Fix data races in proc_doulongvec_minmax().
      sysctl: Fix data races in proc_dointvec_jiffies().
      tcp: Fix a data-race around sysctl_tcp_max_orphans.
      inetpeer: Fix data-races around sysctl.
      net: Fix data-races around sysctl_mem.
      cipso: Fix data-races around sysctl.
      icmp: Fix data-races around sysctl.
      ipv4: Fix a data-race around sysctl_fib_sync_mem.
      sysctl: Fix data-races in proc_dou8vec_minmax().
      sysctl: Fix data-races in proc_dointvec_ms_jiffies().
      tcp: Fix a data-race around sysctl_max_tw_buckets.
      icmp: Fix a data-race around sysctl_icmp_echo_ignore_all.
      icmp: Fix data-races around sysctl_icmp_echo_enable_probe.
      icmp: Fix a data-race around sysctl_icmp_echo_ignore_broadcasts.
      icmp: Fix a data-race around sysctl_icmp_ignore_bogus_error_responses.
      icmp: Fix a data-race around sysctl_icmp_errors_use_inbound_ifaddr.
      icmp: Fix a data-race around sysctl_icmp_ratelimit.
      icmp: Fix a data-race around sysctl_icmp_ratemask.
      raw: Fix a data-race around sysctl_raw_l3mdev_accept.
      tcp: Fix data-races around sysctl_tcp_ecn.
      tcp: Fix a data-race around sysctl_tcp_ecn_fallback.
      ipv4: Fix data-races around sysctl_ip_dynaddr.
      nexthop: Fix data-races around nexthop_compat_mode.

Liang He (2):
      net: ftgmac100: Hold reference returned by of_get_child_by_name()
      cpufreq: pmac32-cpufreq: Fix refcount leak bug

Linus Torvalds (1):
      signal handling: don't use BUG_ON() for debugging

Linus Walleij (3):
      ARM: 9211/1: domain: drop modify_domain()
      ARM: 9212/1: domain: Modify Kconfig help text
      soc: ixp4xx/npe: Fix unused match warning

Linyu Yuan (1):
      usb: typec: add missing uevent when partner support PD

Lucien Buchmann (1):
      USB: serial: ftdi_sio: add Belimo device ids

Marc Kleine-Budde (1):
      tee: tee_get_drvdata(): fix description of return value

Mario Kleiner (1):
      drm/amd/display: Only use depth 36 bpp linebuffers on DCN display engines.

Mario Limonciello (1):
      ACPI: CPPC: Fix enabling CPPC on AMD systems with shared memory

Mark Brown (3):
      ASoC: ops: Fix off by one in range control validation
      ASoC: wcd9335: Fix spurious event generation
      ASoC: wcd938x: Fix event generation for some controls

Mark Pearson (2):
      platform/x86: thinkpad-acpi: profile capabilities as integer
      platform/x86: thinkpad_acpi: do not use PSC mode on Intel platforms

Martin Povišer (2):
      ASoC: tas2764: Add post reset delays
      ASoC: tas2764: Fix and extend FSYNC polarity handling

Matthew Auld (2):
      drm/i915/ttm: fix sg_table construction
      drm/i915/ttm: fix 32b build

Maxim Mikityanskiy (1):
      net/mlx5e: Ring the TX doorbell on DMA errors

Meng Tang (6):
      ALSA: hda - Add fixup for Dell Latitidue E5430
      ALSA: hda/conexant: Apply quirk for another HP ProDesk 600 G3 model
      ALSA: hda/realtek: Fix headset mic for Acer SF313-51
      ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671
      ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc221
      ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Michael Chan (1):
      bnxt_en: Fix bnxt_reinit_after_abort() code path

Michael Walle (1):
      NFC: nxp-nci: don't print header length mismatch on i2c error

Michal Suchanek (1):
      ARM: dts: sunxi: Fix SPI NOR campatible on Orange Pi Zero

Michel Dänzer (1):
      drm/amd/display: Ensure valid event timestamp for cursor-only commits

Ming Lei (1):
      scsi: megaraid: Clear READ queue map's nr_queues

Muchun Song (2):
      mm: sparsemem: fix missing higher order allocation splitting
      mm: sysctl: fix missing numa_stat when !CONFIG_HUGETLB_PAGE

Namjae Jeon (1):
      ksmbd: use SOCK_NONBLOCK type for kernel_accept()

Nathan Lynch (1):
      powerpc/xive/spapr: correct bitmap allocation size

Nicolas Dichtel (1):
      ip: fix dflt addr selection for connected nexthop

Oleg Nesterov (1):
      fix race between exit_itimers() and /proc/pid/timers

Pablo Neira Ayuso (2):
      netfilter: nf_log: incorrect offset to network header
      netfilter: nf_tables: replace BUG_ON by element length check

Pali Rohár (1):
      serial: mvebu-uart: correctly report configured baudrate value

Paolo Abeni (1):
      mptcp: fix subflow traversal at disconnect time

Parav Pandit (1):
      vduse: Tie vduse mgmtdev and its device

Paul Blakey (1):
      net/mlx5e: Fix enabling sriov while tc nic rules are offloaded

Paul M Stillwell Jr (2):
      ice: handle E822 generic device ID in PLDM header
      ice: change devlink code to read NVM in blocks

Pavan Chebbi (1):
      bnxt_en: Fix bnxt_refclk_read()

Pavel Skripkin (1):
      net: ocelot: fix wrong time_after usage

Peter Ujfalusi (5):
      ASoC: Intel: Skylake: Correct the ssp rate discovery in skl_get_ssp_clks()
      ASoC: Intel: Skylake: Correct the handling of fmt_config flexible array
      ASoC: SOF: Intel: hda-dsp: Expose hda_dsp_core_power_up()
      ASoC: SOF: Intel: hda-loader: Make sure that the fw load sequence is followed
      ASoC: SOF: Intel: hda-loader: Clarify the cl_dsp_init() flow

Pierre-Louis Bossart (6):
      ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove
      ASoC: rt711-sdca-sdw: fix calibrate mutex initialization
      ASoC: Intel: sof_sdw: handle errors on card registration
      ASoC: rt711: fix calibrate mutex initialization
      ASoC: rt7*-sdw: harden jack_detect_handler
      ASoC: codecs: rt700/rt711/rt711-sdca: initialize workqueues in probe

Prike Liang (1):
      drm/amdkfd: correct the MEC atomic support firmware checking for GC 10.3.7

Roi Dayan (1):
      net/mlx5e: CT: Use own workqueue instead of mlx5e priv

Ruozhu Li (1):
      nvme: fix regression when disconnect a recovering ctrl

Ryan Wanner (1):
      ARM: dts: at91: sama5d2: Fix typo in i2s1 node

Ryusuke Konishi (1):
      nilfs2: fix incorrect masking of permission flags for symlinks

Sagi Grimberg (1):
      nvme-tcp: always fail a request when sending it failed

Sean Anderson (1):
      arm64: dts: ls1028a: Update SFP node to include clock

Serge Semin (1):
      reset: Fix devm bulk optional exclusive control getter

Shuming Fan (1):
      ASoC: rt711-sdca: fix kernel NULL pointer dereference when IO error

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Fix devlink port register sequence

Srinivas Neeli (1):
      Revert "can: xilinx_can: Limit CANFD brp to 2"

Stafford Horne (1):
      irqchip: or1k-pic: Undefine mask_ack for level triggered hardware

Stephan Gerhold (2):
      virtio_mmio: Add missing PM calls to freeze/restore
      virtio_mmio: Restore guest page size on resume

Steve French (1):
      smb3: workaround negprot bug in some Samba servers

Steven Rostedt (Google) (1):
      net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer

Tariq Toukan (3):
      net/mlx5e: kTLS, Fix build time constant test in TX
      net/mlx5e: kTLS, Fix build time constant test in RX
      net/tls: Check for errors in tls_device_init

Tejun Heo (1):
      cgroup: Use separate src/dst nodes when preloading css_sets for migration

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix event pending check

Thomas Zimmermann (1):
      drm/aperture: Run fbdev removal before internal helpers

Tony Krowiak (1):
      s390/ap: fix error handling in __verify_queue_reservations()

Vasily Gorbik (1):
      s390/nospec: build expoline.o for modules_prepare target

Vikas Gupta (1):
      bnxt_en: fix livepatch query

Vitaly Kuznetsov (1):
      KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()

William Zhang (2):
      arm64: dts: broadcom: bcm4908: Fix timer node for BCM4906 SoC
      arm64: dts: broadcom: bcm4908: Fix cpu node for smp boot

Xiu Jianfeng (1):
      Revert "evm: Fix memleak in init_desc"

Xiubo Li (1):
      netfs: do not unlock and put the folio twice

Yangxi Xiang (1):
      vt: fix memory overlapping when deleting chars in the buffer

Yassine Oudjana (1):
      ASoC: wcd9335: Remove RX channel from old list before adding it to a new one

Yefim Barashkin (1):
      drm/amd/pm: Prevent divide by zero

Yevhen Orlov (1):
      net: marvell: prestera: fix missed deinit sequence

Yi Yang (1):
      serial: 8250: fix return error code in serial8250_request_std_resource()

Zhen Lei (1):
      ARM: 9210/1: Mark the FDT_FIXED sections as shareable

Zheng Yejian (1):
      tracing/histograms: Fix memory leak problem

Íñigo Huguet (2):
      sfc: fix use after free when disabling sriov
      sfc: fix kernel panic when creating VF

