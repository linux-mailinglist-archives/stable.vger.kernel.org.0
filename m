Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8811F6E9228
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbjDTLKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbjDTLJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:09:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C6F59FB;
        Thu, 20 Apr 2023 04:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEC5961820;
        Thu, 20 Apr 2023 11:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF27C433D2;
        Thu, 20 Apr 2023 11:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681988687;
        bh=iKnWOMya1dcHNug3Sjp1VsysMk2ou6mA9mF/V/KPdmQ=;
        h=From:To:Cc:Subject:Date:From;
        b=dPjwTlRfXAWnUOiBJroxUpLhbnqkwunlrjTSdNGVMc1wOM+u16uqzbWEF5T3bZYV/
         Fs+qFFVkA9cqtcTYTeC6FHzsDLrxaAcxD8SclW2wBgfcx3iKs0Rpf8hXCj3JRne3nQ
         ahnXQr4dkxEE9pYZBAQtzWQtQxiutep+B9KQpu/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.2.12
Date:   Thu, 20 Apr 2023 13:04:40 +0200
Message-Id: <2023042040-wired-camera-52d3@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.2.12 kernel.

All users of the 6.2 kernel series must upgrade.

The updated 6.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.rst                    |    2 
 Documentation/sound/hd-audio/models.rst                   |    2 
 Makefile                                                  |    2 
 arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts               |   10 
 arch/arm/lib/uaccess_with_memcpy.c                        |    4 
 arch/arm64/boot/dts/qcom/sa8540p-ride.dts                 |    2 
 arch/arm64/kvm/arm.c                                      |   26 +-
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h            |    5 
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                        |    7 
 arch/arm64/kvm/pmu-emul.c                                 |    1 
 arch/arm64/kvm/sys_regs.c                                 |    1 
 arch/arm64/net/bpf_jit.h                                  |    4 
 arch/arm64/net/bpf_jit_comp.c                             |    3 
 arch/loongarch/net/bpf_jit.c                              |    4 
 arch/powerpc/mm/numa.c                                    |    1 
 arch/powerpc/platforms/pseries/papr_scm.c                 |    7 
 arch/riscv/kernel/signal.c                                |    9 
 arch/x86/kernel/x86_init.c                                |    4 
 arch/x86/pci/fixup.c                                      |   21 +
 crypto/asymmetric_keys/pkcs7_verify.c                     |   10 
 crypto/asymmetric_keys/verify_pefile.c                    |   32 +-
 drivers/acpi/resource.c                                   |    7 
 drivers/acpi/video_detect.c                               |    8 
 drivers/block/ublk_drv.c                                  |    3 
 drivers/bluetooth/btbcm.c                                 |    2 
 drivers/clk/clk-renesas-pcie.c                            |    3 
 drivers/clk/sprd/common.c                                 |    9 
 drivers/dma/apple-admac.c                                 |   20 +
 drivers/firmware/efi/sysfb_efi.c                          |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c                 |    9 
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c                    |   14 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |   57 +++-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h              |    6 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c      |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c      |   87 ++++++
 drivers/gpu/drm/armada/armada_drv.c                       |    1 
 drivers/gpu/drm/drm_panel_orientation_quirks.c            |   13 -
 drivers/gpu/drm/i915/display/icl_dsi.c                    |   20 +
 drivers/gpu/drm/i915/display/intel_color.c                |   43 +++
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gf108.c            |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk104.c            |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gk110.c            |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gm107.c            |    1 
 drivers/hid/intel-ish-hid/ishtp/bus.c                     |    4 
 drivers/hwmon/peci/cputemp.c                              |    8 
 drivers/hwmon/xgene-hwmon.c                               |   14 -
 drivers/i2c/busses/i2c-hisi.c                             |    7 
 drivers/i2c/busses/i2c-imx-lpi2c.c                        |    2 
 drivers/i2c/busses/i2c-mchp-pci1xxxx.c                    |   60 ++--
 drivers/i2c/busses/i2c-ocores.c                           |   35 +-
 drivers/infiniband/core/cma.c                             |   60 ++--
 drivers/infiniband/core/verbs.c                           |    2 
 drivers/infiniband/hw/erdma/erdma_cq.c                    |    2 
 drivers/infiniband/hw/erdma/erdma_hw.h                    |    4 
 drivers/infiniband/hw/erdma/erdma_main.c                  |    2 
 drivers/infiniband/hw/erdma/erdma_qp.c                    |    4 
 drivers/infiniband/hw/erdma/erdma_verbs.h                 |    2 
 drivers/infiniband/hw/irdma/cm.c                          |   16 -
 drivers/infiniband/hw/irdma/cm.h                          |    2 
 drivers/infiniband/hw/irdma/hw.c                          |    3 
 drivers/infiniband/hw/irdma/utils.c                       |    5 
 drivers/infiniband/hw/mlx5/main.c                         |    4 
 drivers/mtd/mtdblock.c                                    |   12 
 drivers/mtd/nand/raw/meson_nand.c                         |    6 
 drivers/mtd/nand/raw/stm32_fmc2_nand.c                    |    3 
 drivers/mtd/ubi/build.c                                   |   21 +
 drivers/mtd/ubi/wl.c                                      |    4 
 drivers/net/bonding/bond_main.c                           |    5 
 drivers/net/ethernet/cadence/macb_main.c                  |    4 
 drivers/net/ethernet/intel/iavf/iavf.h                    |   20 -
 drivers/net/ethernet/intel/iavf/iavf_main.c               |   44 +--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c           |   68 ++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c           |    8 
 drivers/net/ethernet/sun/niu.c                            |    2 
 drivers/net/phy/nxp-c45-tja11xx.c                         |   14 +
 drivers/net/phy/sfp.c                                     |   13 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c         |   50 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h              |    6 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c              |    6 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c              |   29 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c               |    2 
 drivers/net/wireless/marvell/mwifiex/sdio.c               |    2 
 drivers/net/wwan/iosm/iosm_ipc_pcie.c                     |    3 
 drivers/nvme/host/core.c                                  |    3 
 drivers/nvme/host/pci.c                                   |    3 
 drivers/pci/remove.c                                      |    5 
 drivers/pinctrl/pinctrl-amd.c                             |   36 +-
 drivers/power/supply/axp288_fuel_gauge.c                  |    2 
 drivers/power/supply/cros_usbpd-charger.c                 |    2 
 drivers/power/supply/rk817_charger.c                      |    4 
 drivers/scsi/ses.c                                        |   20 -
 drivers/thermal/intel/therm_throt.c                       |   73 +++++
 drivers/video/fbdev/core/fbcon.c                          |   18 -
 drivers/video/fbdev/core/fbmem.c                          |    2 
 fs/btrfs/disk-io.c                                        |   14 +
 fs/btrfs/super.c                                          |    4 
 fs/cifs/smb2pdu.c                                         |   41 ++-
 fs/ksmbd/smb2pdu.c                                        |   23 +
 include/linux/pci.h                                       |    2 
 include/linux/rtnetlink.h                                 |    3 
 include/linux/trace.h                                     |   12 
 include/net/bluetooth/hci_core.h                          |    1 
 include/net/bonding.h                                     |    8 
 io_uring/io_uring.c                                       |    2 
 kernel/cgroup/cpuset.c                                    |  177 +++++++++++---
 kernel/cgroup/legacy_freezer.c                            |    7 
 kernel/cgroup/rstat.c                                     |    4 
 kernel/sched/fair.c                                       |   10 
 kernel/trace/trace.c                                      |   41 +--
 lib/maple_tree.c                                          |    7 
 net/9p/trans_xen.c                                        |    4 
 net/bluetooth/hci_conn.c                                  |   92 ++++---
 net/bluetooth/hci_event.c                                 |   18 -
 net/bluetooth/hci_sync.c                                  |   13 -
 net/bluetooth/hidp/core.c                                 |    2 
 net/bluetooth/l2cap_core.c                                |   24 -
 net/bluetooth/sco.c                                       |   16 -
 net/core/dev.c                                            |    3 
 net/core/rtnetlink.c                                      |   11 
 net/core/skbuff.c                                         |   16 -
 net/ipv4/sysctl_net_ipv4.c                                |    3 
 net/ipv4/tcp_ipv4.c                                       |    4 
 net/ipv6/udp.c                                            |    8 
 net/mptcp/fastopen.c                                      |   11 
 net/mptcp/options.c                                       |    5 
 net/mptcp/protocol.c                                      |    2 
 net/mptcp/subflow.c                                       |   18 -
 net/openvswitch/actions.c                                 |    2 
 net/qrtr/af_qrtr.c                                        |    8 
 net/sctp/stream_interleave.c                              |    3 
 net/smc/af_smc.c                                          |   11 
 sound/firewire/tascam/tascam-stream.c                     |    2 
 sound/i2c/cs8427.c                                        |    7 
 sound/pci/emu10k1/emupcm.c                                |   14 -
 sound/pci/hda/patch_hdmi.c                                |    2 
 sound/pci/hda/patch_realtek.c                             |   29 ++
 sound/pci/hda/patch_sigmatel.c                            |   10 
 tools/testing/radix-tree/maple.c                          |   16 +
 tools/testing/selftests/bpf/progs/find_vma_fail1.c        |    1 
 tools/testing/selftests/net/config                        |    1 
 tools/testing/selftests/net/mptcp/userspace_pm.sh         |    2 
 tools/testing/selftests/net/openvswitch/ovs-dpctl.py      |    2 
 142 files changed, 1350 insertions(+), 567 deletions(-)

Aaron Conole (1):
      selftests: openvswitch: adjust datapath NL message declaration

Ahmed Zaki (2):
      iavf: refactor VLAN filter states
      iavf: remove active_cvlans and active_svlans bitmaps

Alexander Stein (2):
      clk: rs9: Fix suspend/resume
      i2c: imx-lpi2c: clean rx/tx buffers upon new message

Alexei Starovoitov (1):
      selftests/bpf: Fix progs/find_vma_fail1.c build error.

Andrew Jeffery (1):
      ARM: 9290/1: uaccess: Fix KASAN false-positives

Aneesh Kumar K.V (1):
      powerpc/papr_scm: Update the NUMA distance table for the target node

Archie Pusaka (1):
      Bluetooth: Free potentially unfreed SCO connection

Arseniy Krasnov (1):
      mtd: rawnand: meson: fix bitmask for length in command word

Aymeric Wibo (1):
      ACPI: resource: Add Medion S17413 to IRQ override quirk

Bang Li (1):
      mtdblock: tolerate corrected bit-flips

Basavaraj Natikar (1):
      x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Brian Masney (1):
      arm64: dts: qcom: sa8540p-ride: correct name of remoteproc_nsp0 firmware

Cheng Xu (4):
      RDMA/erdma: Fix some typos
      RDMA/erdma: Update default EQ depth to 4096 and max_send_wr to 8192
      RDMA/erdma: Inline mtt entries into WQE if supported
      RDMA/erdma: Defer probing if netdevice can not be found

Christoph Hellwig (2):
      btrfs: restore the thread_pool= behavior in remount for the end I/O workqueues
      btrfs: fix fast csum implementation detection

Christophe JAILLET (1):
      drm/armada: Fix a potential double free in an error handling path

Christophe Kerello (2):
      mtd: rawnand: stm32_fmc2: remove unsupported EDO mode
      mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min

Chunyan Zhang (1):
      clk: sprd: set max_register according to mapping range

Claudia Draghicescu (1):
      Bluetooth: Set ISO Data Path on broadcast sink

Daniel Vetter (3):
      fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace
      fbcon: Fix error paths in set_con2fb_map
      fbcon: set_con2fb_map needs to set con2fb_map!

David Disseldorp (2):
      ksmbd: avoid out of bounds access in decode_preauth_ctxt()
      cifs: fix negotiate context parsing

Denis Arefev (1):
      power: supply: axp288_fuel_gauge: Added check for negative values

Denis Plotnikov (1):
      qlcnic: check pci_reset_function result

Duy Truong (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD

Eric Dumazet (1):
      udp6: fix potential access to stale information

Evan Quan (1):
      drm/amd/pm: correct the pcie link state check for SMU13

Felix Huettner (1):
      net: openvswitch: fix race on port output

Fuad Tabba (1):
      KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs

George Guo (1):
      LoongArch, bpf: Fix jit to skip speculation barrier opcode

Grant Grundler (1):
      power: supply: cros_usbpd: reclassify "default case!" as debug

Greg Kroah-Hartman (1):
      Linux 6.2.12

Gregor Herburger (1):
      i2c: ocores: generate stop condition after timeout in polling mode

Hangbin Liu (1):
      bonding: fix ns validation on backup slaves

Hans de Goede (3):
      efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L
      ACPI: video: Add backlight=native DMI quirk for Acer Aspire 3830TG
      drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F

Harshit Mogalapalli (2):
      niu: Fix missing unwind goto in niu_alloc_channels()
      net: wwan: iosm: Fix error handling path in ipc_pcie_probe()

Horatio Zhang (2):
      drm/amd/pm: correct SMU13.0.7 pstate profiling clock settings
      drm/amd/pm: correct SMU13.0.7 max shader clock reporting

Ivan Bornyakov (1):
      net: sfp: initialize sfp->i2c_block_size at sfp allocation

Iwona Winiarska (1):
      hwmon: (peci/cputemp) Fix miscalculated DTS for SKX

Jane Jian (1):
      drm/amdgpu/gfx: set cg flags to enter/exit safe mode

Jani Nikula (1):
      drm/i915/dsi: fix DSS CTL register offsets for TGL+

Jiapeng Chong (1):
      power: supply: rk817: Fix unsigned comparison with less than zero

Jiri Kosina (1):
      scsi: ses: Handle enclosure with just a primary component gracefully

Johannes Berg (2):
      wifi: iwlwifi: mvm: fix mvmtxq->stopped handling
      wifi: iwlwifi: mvm: protect TXQ list manipulation

Josh Don (1):
      cgroup: fix display of forceidle time at root

Juraj Pecigos (1):
      nvme-pci: mark Lexar NM760 as IGNORE_DEV_SUBNQN

Kai Vehmanen (1):
      ALSA: hda/hdmi: disable KAE for Intel DG2

Karol Herbst (1):
      drm/nouveau/fb: add missing sysmen flush callbacks

Kornel Dulęba (1):
      Revert "pinctrl: amd: Disable and mask interrupts on resume"

Krzysztof Kozlowski (1):
      wifi: mwifiex: mark OF related data as maybe unused

Kuniyuki Iwashima (1):
      smc: Fix use-after-free in tcp_write_timer_handler().

Liam R. Howlett (1):
      maple_tree: fix write memory barrier of nodes once dead for RCU mode

Liang Chen (1):
      skbuff: Fix a race between coalescing and releasing SKBs

Luca Weiss (1):
      ARM: dts: qcom: apq8026-lg-lenok: add missing reserved memory

Luiz Augusto von Dentz (5):
      Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}
      Bluetooth: hci_conn: Fix possible UAF
      Bluetooth: hci_conn: Fix not cleaning up on LE Connection failure
      Bluetooth: Fix printing errors if LE Connection times out
      Bluetooth: SCO: Fix possible circular locking dependency sco_sock_getsockopt

Maher Sanalla (1):
      IB/mlx5: Add support for 400G_8X lane speed

Mark Zhang (1):
      RDMA/cma: Allow UD qp_type to join multicast only

Martin George (1):
      nvme: send Identify with CNS 06h only to I/O controllers

Martin KaFai Lau (1):
      bpf: tcp: Use sock_gen_put instead of sock_put in bpf_iter_tcp

Martin Povišer (3):
      dmaengine: apple-admac: Handle 'global' interrupt flags
      dmaengine: apple-admac: Set src_addr_widths capability
      dmaengine: apple-admac: Fix 'current_tx' not getting freed

Martin Willi (1):
      rtnetlink: Restore RTM_NEW/DELLINK notification behavior

Mathis Salmen (1):
      riscv: add icache flush for nommu sigreturn trampoline

Matija Glavinic Pecotic (1):
      x86/rtc: Remove __init for runtime functions

Matthieu Baerts (1):
      selftests: mptcp: userspace pm: uniform verify events

Min Li (1):
      Bluetooth: Fix race condition in hidp_session_thread

Ming Lei (2):
      io_uring: complete request via task work in case of DEFER_TASKRUN
      block: ublk_drv: mark device as LIVE before adding disk

Mustafa Ismail (3):
      RDMA/irdma: Do not generate SW completions for NOPs
      RDMA/irdma: Fix memory leak of PBLE objects
      RDMA/irdma: Increase iWARP CM default rexmit count

Oswald Buddenhagen (5):
      ALSA: emu10k1: fix capture interrupt handler unlinking
      ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard
      ALSA: i2c/cs8427: fix iec958 mixer control deactivation
      ALSA: emu10k1: don't create old pass-through playback device on Audigy
      ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

Paolo Abeni (3):
      mptcp: use mptcp_schedule_work instead of open-coding it
      mptcp: stricter state check in mptcp_worker
      mptcp: fix NULL pointer dereference on fastopen early fallback

Pierre-Louis Bossart (1):
      ALSA: hda: patch_realtek: add quirk for Asus N7601ZM

Radu Pirea (OSS) (2):
      net: phy: nxp-c45-tja11xx: add remove callback
      net: phy: nxp-c45-tja11xx: fix unsigned long multiplication overflow

Reiji Watanabe (1):
      KVM: arm64: PMU: Restore the guest's EL0 event counting after migration

Reinette Chatre (1):
      PCI/MSI: Provide missing stub for pci_msix_can_alloc_dyn()

Rob Herring (1):
      PCI: Fix use-after-free in pci_bus_release_domain_nr()

Robbie Harwood (2):
      verify_pefile: relax wrapper length check
      asymmetric_keys: log on fatal failures in PE/pkcs7

Roman Gushchin (1):
      net: macb: fix a memory corruption in extended buffer descriptor mode

Saravanan Vajravel (1):
      RDMA/core: Fix GID entry ref leak when create_ah fails

Sasha Finkelstein (1):
      bluetooth: btbcm: Fix logic error in forming the board name.

Srinivas Pandruvada (1):
      thermal: intel: Avoid updating unsupported THERM_STATUS_CLEAR mask bits

Stefan Binding (1):
      ALSA: hda/realtek: Add quirks for Lenovo Z13/Z16 Gen2

Steven Rostedt (Google) (2):
      tracing: Add trace_array_puts() to write into instance
      tracing: Have tracing_snapshot_instance_cond() write errors to the appropriate instance

Tanu Malhotra (1):
      HID: intel-ish-hid: Fix kernel panic during warm reset

Tatyana Nikolova (1):
      RDMA/irdma: Add ipv4 check to irdma_find_listener()

Tetsuo Handa (1):
      cgroup,freezer: hold cpu_hotplug_lock before freezer_mutex

Tharun Kumar P (1):
      i2c: mchp-pci1xxxx: Update Timing registers

Tianyi Jing (1):
      hwmon: (xgene) Fix ioremap and memremap leak

Tong Liu01 (1):
      drm/amdgpu: add mes resume when do gfx post soft reset

Ville Syrjälä (1):
      drm/i915: Workaround ICL CSC_MODE sticky arming

Vincent Guittot (1):
      sched/fair: Fix imbalance overflow

Waiman Long (4):
      cgroup/cpuset: Fix partition root's cpuset.cpus update bug
      cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()
      cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly
      cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods

Wayne Lin (1):
      drm/amd/display: Pass the right info to drm_dp_remove_payload

Xin Long (2):
      sctp: fix a potential overflow in sctp_ifwdtsn_skip
      selftests: add the missing CONFIG_IP_SCTP in net config

Xu Biang (1):
      ALSA: firewire-tascam: add missing unwind goto in snd_tscm_stream_start_duplex()

Xu Kuohai (1):
      bpf, arm64: Fixed a BTI error on returning to patched function

Yicong Yang (1):
      i2c: hisi: Avoid redundant interrupts

YuBiao Wang (1):
      drm/amdgpu: Force signal hw_fences that are embedded in non-sched jobs

YueHaibing (1):
      tcp: restrict net.ipv4.tcp_app_win

ZhaoLong Wang (1):
      ubi: Fix deadlock caused by recursively holding work_sem

Zheng Wang (1):
      9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Zhihao Cheng (1):
      ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Ziyang Xuan (1):
      net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()

