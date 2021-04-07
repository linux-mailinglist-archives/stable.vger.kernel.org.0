Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D86356D12
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbhDGNRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 09:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhDGNRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 09:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77AF361353;
        Wed,  7 Apr 2021 13:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617801452;
        bh=KhZEV54fPGyeM2gDn5kG7EgMLluWHtk2r1mifbCRsM8=;
        h=From:To:Cc:Subject:Date:From;
        b=rTH4pUVppFYlwc1BDo8iNhfKuqPAqoAyd5LqBDNwhC9ntwCkuZ2zixKFvmnCbzG49
         uPbhaL7EkBXXxft7Z5GchqOiFn+FiqBGh+7QLP46yBNmW9CPZusUQYyFr5CgvwaxdU
         RXKD6thrw8ozdKBWb1Uc5p8X4ACIBtR8zE6U21RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.28
Date:   Wed,  7 Apr 2021 15:17:27 +0200
Message-Id: <16178014489275@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.28 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm64/mm/mmu.c                                         |   20 
 arch/riscv/include/asm/uaccess.h                            |    7 
 arch/s390/include/asm/vdso/data.h                           |    2 
 arch/s390/kernel/time.c                                     |    1 
 arch/x86/include/asm/smp.h                                  |    1 
 arch/x86/kernel/acpi/boot.c                                 |   25 
 arch/x86/kernel/setup.c                                     |    8 
 arch/x86/kernel/smpboot.c                                   |    2 
 arch/x86/kvm/svm/nested.c                                   |   28 
 arch/x86/net/bpf_jit_comp.c                                 |   27 
 arch/xtensa/kernel/coprocessor.S                            |   64 
 arch/xtensa/mm/fault.c                                      |    5 
 drivers/acpi/processor_idle.c                               |    7 
 drivers/acpi/tables.c                                       |   42 
 drivers/base/dd.c                                           |    3 
 drivers/base/power/runtime.c                                |   10 
 drivers/extcon/extcon.c                                     |    1 
 drivers/firewire/nosy.c                                     |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                      |   10 
 drivers/gpu/drm/amd/amdkfd/kfd_dbgdev.c                     |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c       |    6 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h       |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager.c             |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c          |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_vi.c          |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h                       |    8 
 drivers/gpu/drm/imx/imx-drm-core.c                          |    2 
 drivers/gpu/drm/tegra/dc.c                                  |   20 
 drivers/gpu/drm/tegra/sor.c                                 |    7 
 drivers/net/can/Makefile                                    |    7 
 drivers/net/can/dev.c                                       | 1339 -----------
 drivers/net/can/dev/Makefile                                |    7 
 drivers/net/can/dev/dev.c                                   | 1341 ++++++++++++
 drivers/net/can/dev/rx-offload.c                            |  376 +++
 drivers/net/can/m_can/tcan4x5x.c                            |    2 
 drivers/net/can/rx-offload.c                                |  376 ---
 drivers/net/can/slcan.c                                     |    4 
 drivers/net/can/vcan.c                                      |    2 
 drivers/net/can/vxcan.c                                     |    6 
 drivers/net/ethernet/aquantia/atlantic/aq_main.c            |    4 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c             |    4 
 drivers/net/ipa/gsi_reg.h                                   |   10 
 drivers/net/ipa/ipa_cmd.c                                   |   32 
 drivers/net/netdevsim/dev.c                                 |   40 
 drivers/net/wan/lmc/lmc_main.c                              |    2 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                   |    7 
 drivers/net/wireless/ath/ath11k/mac.c                       |    7 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    7 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c             |   11 
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c           |    5 
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                |   22 
 drivers/net/wireless/realtek/rtw88/rtw8821c.c               |   16 
 drivers/nvme/target/tcp.c                                   |    2 
 drivers/pinctrl/pinctrl-rockchip.c                          |   13 
 drivers/scsi/qla2xxx/qla_target.h                           |    2 
 drivers/scsi/st.c                                           |    2 
 drivers/soc/qcom/qcom-geni-se.c                             |   74 
 drivers/staging/comedi/drivers/cb_pcidas.c                  |    2 
 drivers/staging/comedi/drivers/cb_pcidas64.c                |    2 
 drivers/staging/rtl8192e/rtllib.h                           |    2 
 drivers/staging/rtl8192e/rtllib_rx.c                        |    2 
 drivers/thermal/thermal_sysfs.c                             |    3 
 drivers/tty/serial/qcom_geni_serial.c                       |    7 
 drivers/usb/class/cdc-acm.c                                 |   61 
 drivers/usb/core/quirks.c                                   |    4 
 drivers/usb/dwc2/hcd.c                                      |    5 
 drivers/usb/dwc3/dwc3-pci.c                                 |    2 
 drivers/usb/dwc3/dwc3-qcom.c                                |    3 
 drivers/usb/dwc3/gadget.c                                   |    8 
 drivers/usb/gadget/udc/amd5536udc_pci.c                     |   10 
 drivers/usb/host/xhci-mtk.c                                 |   10 
 drivers/usb/musb/musb_core.c                                |   12 
 drivers/usb/usbip/vhci_hcd.c                                |    2 
 drivers/vfio/pci/Kconfig                                    |    2 
 drivers/vhost/vhost.c                                       |    2 
 drivers/video/fbdev/core/fbcon.c                            |    3 
 drivers/video/fbdev/hyperv_fb.c                             |    3 
 fs/ext4/balloc.c                                            |   38 
 fs/ext4/ext4.h                                              |    1 
 fs/ext4/inode.c                                             |    6 
 fs/ext4/namei.c                                             |   18 
 fs/ext4/super.c                                             |    5 
 fs/ext4/sysfs.c                                             |    7 
 fs/fuse/virtio_fs.c                                         |    9 
 fs/io_uring.c                                               |   33 
 fs/iomap/swapfile.c                                         |   10 
 fs/nfsd/Kconfig                                             |    1 
 fs/nfsd/nfs4callback.c                                      |    1 
 fs/reiserfs/xattr.h                                         |    2 
 include/linux/acpi.h                                        |    9 
 include/linux/bpf.h                                         |   24 
 include/linux/can/can-ml.h                                  |   12 
 include/linux/extcon.h                                      |   23 
 include/linux/firmware/intel/stratix10-svc-client.h         |    2 
 include/linux/netdevice.h                                   |   34 
 include/linux/qcom-geni-se.h                                |    2 
 include/linux/ww_mutex.h                                    |    5 
 kernel/bpf/bpf_struct_ops.c                                 |    2 
 kernel/bpf/core.c                                           |    4 
 kernel/bpf/trampoline.c                                     |  218 +
 kernel/locking/mutex.c                                      |   25 
 kernel/static_call.c                                        |   14 
 kernel/trace/trace.c                                        |    3 
 mm/memory.c                                                 |    2 
 net/9p/client.c                                             |    4 
 net/appletalk/ddp.c                                         |   33 
 net/can/af_can.c                                            |   34 
 net/can/j1939/main.c                                        |   22 
 net/can/j1939/socket.c                                      |   13 
 net/can/proc.c                                              |   19 
 net/core/filter.c                                           |   12 
 net/core/flow_dissector.c                                   |    6 
 net/sunrpc/auth_gss/svcauth_gss.c                           |   11 
 sound/pci/hda/hda_intel.c                                   |    8 
 sound/pci/hda/patch_realtek.c                               |    4 
 sound/soc/codecs/cs42l42.c                                  |   74 
 sound/soc/codecs/cs42l42.h                                  |   13 
 sound/soc/codecs/es8316.c                                   |    9 
 sound/soc/codecs/rt1015.c                                   |    1 
 sound/soc/codecs/rt5640.c                                   |    4 
 sound/soc/codecs/rt5651.c                                   |    4 
 sound/soc/codecs/rt5659.c                                   |    5 
 sound/soc/codecs/rt711.c                                    |    8 
 sound/soc/codecs/sgtl5000.c                                 |    2 
 sound/soc/soc-core.c                                        |    4 
 sound/usb/quirks.c                                          |    1 
 tools/testing/selftests/net/forwarding/tc_flower.sh         |   38 
 128 files changed, 2720 insertions(+), 2311 deletions(-)

Adrian Hunter (2):
      PM: runtime: Fix race getting/putting suppliers at probe
      PM: runtime: Fix ordering in pm_runtime_get_suppliers()

Ahmad Fatoum (1):
      driver core: clear deferred probe reason on probe retry

Alex Elder (2):
      net: ipa: remove two unused register definitions
      net: ipa: fix register write command validation

Alexei Starovoitov (1):
      bpf: Fix fexit trampoline.

Alexey Dobriyan (1):
      scsi: qla2xxx: Fix broken #endif placement

Andy Shevchenko (1):
      usb: dwc3: pci: Enable dis_uX_susphy_quirk for Intel Merrifield

Artur Petrosyan (2):
      usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board.
      usb: dwc2: Prevent core suspend when port connection flag is 0

Atul Gopinathan (2):
      staging: rtl8192e: Fix incorrect source in memcpy()
      staging: rtl8192e: Change state information from u16 to u8

Bard Liao (1):
      ASoC: rt711: add snd_soc_component remove callback

Ben Dooks (1):
      riscv: evaluate put_user() arg before enabling user access

Benjamin Rood (1):
      ASoC: sgtl5000: set DAP_AVC_CTRL register to correct default value on probe

Chunfeng Yun (1):
      usb: xhci-mtk: fix broken streams issue on 0.96 xHCI

Davide Caratti (1):
      flow_dissector: fix TTL and TOS dissection on IPv4 fragments

Dinghao Liu (1):
      extcon: Fix error handling in extcon_dev_register

Doug Brown (1):
      appletalk: Fix skb allocation size in loopback case

Du Cheng (1):
      drivers: video: fbcon: fix NULL dereference in fbcon_cursor()

Elad Grupi (1):
      nvmet-tcp: fix kmap leak when data digest in use

Eric Whitney (1):
      ext4: shrink race window in ext4_should_retry_alloc()

Greg Kroah-Hartman (1):
      Linux 5.10.28

Guo-Feng Fan (1):
      rtw88: coex: 8821c: correct antenna switch function

Hans de Goede (3):
      ASoC: rt5640: Fix dac- and adc- vol-tlv values being off by a factor of 10
      ASoC: rt5651: Fix dac- and adc- vol-tlv values being off by a factor of 10
      ASoC: es8316: Simplify adc_pga_gain_tlv table

Heiko Carstens (2):
      s390/vdso: copy tod_steering_delta value to vdso_data page
      s390/vdso: fix tod_steering_delta type

Hui Wang (2):
      ALSA: hda/realtek: fix a determine_headset_type issue for a Dell AIO
      ALSA: hda/realtek: call alc_update_headset_mode() in hp_automute_hook

Ido Schimmel (1):
      netdevsim: dev: Initialize FIB module after debugfs

Ikjoon Jang (1):
      ALSA: usb-audio: Apply sample rate quirk to Logitech Connect

Ilya Lipnitskiy (1):
      mm: fix race by making init_zero_pfn() early_initcall

J. Bruce Fields (1):
      rpc: fix NULL dereference on kmalloc failure

Jack Yu (1):
      ASoC: rt1015: fix i2c communication error

Jason Gunthorpe (1):
      vfio/nvlink: Add missing SPAPR_TCE_IOMMU depends

Jens Axboe (2):
      kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing
      Revert "kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing"

Jeremy Szu (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP 640 G8

Jesper Dangaard Brouer (1):
      bpf: Remove MTU check in __bpf_skb_max_len

Jisheng Zhang (1):
      net: 9p: advance iov on empty read

Johan Hovold (2):
      USB: cdc-acm: fix double free on probe failure
      USB: cdc-acm: fix use-after-free after probe failure

Johannes Berg (1):
      iwlwifi: pcie: don't disable interrupts for reg_lock

Jon Hunter (1):
      ASoC: soc-core: Prevent warning if no DMI table is present

Julian Braha (1):
      fs: nfsd: fix kconfig dependency warning for NFSD_V4

Krzysztof Kozlowski (1):
      extcon: Add stubs for extcon_register_notifier_all() functions

Laurent Vivier (1):
      vhost: Fix vhost_vq_reset()

Luca Pesce (1):
      brcmfmac: clear EAP/association status bits on linkdown events

Lucas Tanure (4):
      ASoC: cs42l42: Fix Bitclock polarity inversion
      ASoC: cs42l42: Fix channel width support
      ASoC: cs42l42: Fix mixer volume control
      ASoC: cs42l42: Always wait at least 3ms after reset

Lv Yunlong (2):
      scsi: st: Fix a use after free in st_open()
      video: hyperv_fb: Fix a double free in hvfb_probe

Manaf Meethalavalappu Pallikunhi (1):
      thermal/core: Add NULL pointer check before using cooling device stats

Marc Kleine-Budde (1):
      can: dev: move driver related infrastructure into separate subdir

Max Filippov (2):
      xtensa: fix uaccess-related livelock in do_page_fault
      xtensa: move coprocessor_flush to the .text section

Nathan Rossi (1):
      net: ethernet: aquantia: Handle error cleanup of start on open

Nirmoy Das (1):
      drm/amdgpu: fix offset calculation in amdgpu_vm_bo_clear_mappings()

Oleksij Rempel (1):
      net: introduce CAN specific pointer in the struct net_device

Olga Kornievskaia (1):
      NFSD: fix error handling in NFSv4.0 callbacks

Oliver Neukum (3):
      cdc-acm: fix BREAK rx code path adding necessary calls
      USB: cdc-acm: untangle a circular dependency between callback and softint
      USB: cdc-acm: downgrade message to debug

Pan Bian (1):
      drm/imx: fix memory leak when fails to init

Paolo Bonzini (2):
      KVM: SVM: load control fields from VMCB12 before checking them
      KVM: SVM: ensure that EFER.SVME is set when running nested guest or on nested vmexit

Pavel Begunkov (1):
      io_uring: fix ->flags races by linked timeouts

Pavel Tatashin (1):
      arm64: mm: correct the inside linear map range during hotplug check

Peter Zijlstra (1):
      static_call: Align static_call_is_init() patching condition

Qu Huang (1):
      drm/amdkfd: dqm fence memory corruption

Rafael J. Wysocki (1):
      ACPI: tables: x86: Reserve memory occupied by ACPI tables

Richard Gong (1):
      firmware: stratix10-svc: reset COMMAND_RECONFIG_FLAG_PARTIAL to 0

Ritesh Harjani (1):
      iomap: Fix negative assignment to unsigned sis->pages in iomap_swapfile_activate

Roja Rani Yarubandi (1):
      soc: qcom-geni-se: Cleanup the code to remove proxy votes

Sameer Pujar (1):
      ASoC: rt5659: Update MCLK rate in set_sysclk()

Sasha Levin (2):
      net: mvpp2: fix interrupt mask/unmask skip condition
      can: tcan4x5x: fix max register value

Shawn Guo (1):
      usb: dwc3: qcom: skip interconnect init for ACPI probe

Shuah Khan (2):
      ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()
      usbip: vhci_hcd fix shift out-of-bounds in vhci_hub_control()

Stanislav Fomichev (1):
      bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG

Stefan Metzmacher (2):
      io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls
      io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL

Steven Rostedt (VMware) (1):
      tracing: Fix stack trace event size

Takashi Iwai (2):
      ALSA: hda: Re-add dropped snd_poewr_change_state() calls
      ALSA: hda: Add missing sanity checks in PM prepare/complete callbacks

Tetsuo Handa (1):
      reiserfs: update reiserfs_xattrs_initialized() condition

Thierry Reding (2):
      drm/tegra: dc: Restore coupling of display controllers
      drm/tegra: sor: Grab runtime PM reference across reset

Tong Zhang (4):
      staging: comedi: cb_pcidas: fix request_irq() warn
      staging: comedi: cb_pcidas64: fix request_irq() warn
      net: wan/lmc: unregister device when no matching device is found
      usb: gadget: udc: amd5536udc_pci fix null-ptr-dereference

Tony Lindgren (1):
      usb: musb: Fix suspend with devices connected for a64

Vincent Palatin (1):
      USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem

Vitaly Kuznetsov (1):
      ACPI: processor: Fix CPU0 wakeup in acpi_idle_play_dead()

Vivek Goyal (1):
      virtiofs: Fail dax mount if device does not support it

Waiman Long (2):
      locking/ww_mutex: Simplify use_ww_ctx & ww_ctx handling
      locking/ww_mutex: Fix acquire/release imbalance in ww_acquire_init()/ww_acquire_fini()

Wang Panzhenzhuan (1):
      pinctrl: rockchip: fix restore error in resume

Wen Gong (1):
      ath11k: add ieee80211_unregister_hw to avoid kernel crash caused by NULL pointer

Wesley Cheng (1):
      usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable

Xℹ Ruoyao (1):
      drm/amdgpu: check alignment on CPU page for bo map

Zhaolong Zhang (1):
      ext4: fix bh ref count on error paths

Zheyu Ma (1):
      firewire: nosy: Fix a use-after-free bug in nosy_ioctl()

zhangyi (F) (1):
      ext4: do not iput inode under running transaction in ext4_rename()

