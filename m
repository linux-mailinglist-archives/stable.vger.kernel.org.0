Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEAE353EBE
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbhDEJHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237878AbhDEJHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C19261398;
        Mon,  5 Apr 2021 09:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613647;
        bh=9btHH1L4GrYkO/NoubSMT2xMwraYA74HRXnO6QfbxGY=;
        h=From:To:Cc:Subject:Date:From;
        b=v+WzAL4GB4S2E/VCrXrJUejtdQ0HLQIWgywvsZQzcip4zosCygIB/mlGSsmzlS/bx
         0SC4DBGvllow56lsJlL5Yz7RyROuwDc6zHpbGaJpUpBOb7YvmIliyClfavMJYypTzT
         0gtzUxmLJXlocy+YoktnvFL+2xkuPfJVJ1MO1iN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/126] 5.10.28-rc1 review
Date:   Mon,  5 Apr 2021 10:52:42 +0200
Message-Id: <20210405085031.040238881@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.28-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.28-rc1
X-KernelTest-Deadline: 2021-04-07T08:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.28 release.
There are 126 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.28-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.28-rc1

Stanislav Fomichev <sdf@google.com>
    bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG

Jens Axboe <axboe@kernel.dk>
    Revert "kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing"

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: evaluate put_user() arg before enabling user access

Du Cheng <ducheng2@gmail.com>
    drivers: video: fbcon: fix NULL dereference in fbcon_cursor()

Ahmad Fatoum <a.fatoum@pengutronix.de>
    driver core: clear deferred probe reason on probe retry

Atul Gopinathan <atulgopinathan@gmail.com>
    staging: rtl8192e: Change state information from u16 to u8

Atul Gopinathan <atulgopinathan@gmail.com>
    staging: rtl8192e: Fix incorrect source in memcpy()

Roja Rani Yarubandi <rojay@codeaurora.org>
    soc: qcom-geni-se: Cleanup the code to remove proxy votes

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable

Shawn Guo <shawn.guo@linaro.org>
    usb: dwc3: qcom: skip interconnect init for ACPI probe

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Prevent core suspend when port connection flag is 0

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board.

Tong Zhang <ztong0001@gmail.com>
    usb: gadget: udc: amd5536udc_pci fix null-ptr-dereference

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix use-after-free after probe failure

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix double free on probe failure

Oliver Neukum <oneukum@suse.com>
    USB: cdc-acm: downgrade message to debug

Oliver Neukum <oneukum@suse.com>
    USB: cdc-acm: untangle a circular dependency between callback and softint

Oliver Neukum <oneukum@suse.com>
    cdc-acm: fix BREAK rx code path adding necessary calls

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix broken streams issue on 0.96 xHCI

Tony Lindgren <tony@atomide.com>
    usb: musb: Fix suspend with devices connected for a64

Vincent Palatin <vpalatin@chromium.org>
    USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem

Shuah Khan <skhan@linuxfoundation.org>
    usbip: vhci_hcd fix shift out-of-bounds in vhci_hub_control()

Zheyu Ma <zheyuma97@gmail.com>
    firewire: nosy: Fix a use-after-free bug in nosy_ioctl()

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    video: hyperv_fb: Fix a double free in hvfb_probe

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: dwc3: pci: Enable dis_uX_susphy_quirk for Intel Merrifield

Richard Gong <richard.gong@intel.com>
    firmware: stratix10-svc: reset COMMAND_RECONFIG_FLAG_PARTIAL to 0

Dinghao Liu <dinghao.liu@zju.edu.cn>
    extcon: Fix error handling in extcon_dev_register

Krzysztof Kozlowski <krzk@kernel.org>
    extcon: Add stubs for extcon_register_notifier_all() functions

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: compile out TDP MMU on 32-bit systems

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Use atomic ops to set SPTEs in TDP MMU map

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Factor out functions to add/remove TDP MMU pages

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Fix braces in kvm_recover_nx_lpages

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Don't redundantly clear TDP MMU pt memory

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Add comment on __tdp_mmu_set_spte

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range zap

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Protect TDP MMU page table memory with RCU

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Factor out handling of removed page tables

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Add lockdep when setting a TDP MMU SPTE

Ben Gardon <bgardon@google.com>
    kvm: x86/mmu: Add existing trace points to TDP MMU

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Ensure forward progress when yielding in TDP MMU iter

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Rename goal_gfn to next_last_level_gfn

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Merge flush and non-flush tdp_mmu_iter_cond_resched

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: change TDP MMU yield function returns to match cond_resched

Wang Panzhenzhuan <randy.wang@rock-chips.com>
    pinctrl: rockchip: fix restore error in resume

Jason Gunthorpe <jgg@ziepe.ca>
    vfio/nvlink: Add missing SPAPR_TCE_IOMMU depends

Thierry Reding <treding@nvidia.com>
    drm/tegra: sor: Grab runtime PM reference across reset

Thierry Reding <treding@nvidia.com>
    drm/tegra: dc: Restore coupling of display controllers

Pan Bian <bianpan2016@163.com>
    drm/imx: fix memory leak when fails to init

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    reiserfs: update reiserfs_xattrs_initialized() condition

Xℹ Ruoyao <xry111@mengyan1223.wang>
    drm/amdgpu: check alignment on CPU page for bo map

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: fix offset calculation in amdgpu_vm_bo_clear_mappings()

Qu Huang <jinsdb@126.com>
    drm/amdkfd: dqm fence memory corruption

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    mm: fix race by making init_zero_pfn() early_initcall

Heiko Carstens <hca@linux.ibm.com>
    s390/vdso: fix tod_steering_delta type

Heiko Carstens <hca@linux.ibm.com>
    s390/vdso: copy tod_steering_delta value to vdso_data page

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix stack trace event size

Adrian Hunter <adrian.hunter@intel.com>
    PM: runtime: Fix ordering in pm_runtime_get_suppliers()

Adrian Hunter <adrian.hunter@intel.com>
    PM: runtime: Fix race getting/putting suppliers at probe

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: ensure that EFER.SVME is set when running nested guest or on nested vmexit

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: load control fields from VMCB12 before checking them

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: move coprocessor_flush to the .text section

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix uaccess-related livelock in do_page_fault

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP 640 G8

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: call alc_update_headset_mode() in hp_automute_hook

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: fix a determine_headset_type issue for a Dell AIO

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add missing sanity checks in PM prepare/complete callbacks

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Re-add dropped snd_poewr_change_state() calls

Ikjoon Jang <ikjn@chromium.org>
    ALSA: usb-audio: Apply sample rate quirk to Logitech Connect

Vitaly Kuznetsov <vkuznets@redhat.com>
    ACPI: processor: Fix CPU0 wakeup in acpi_idle_play_dead()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: tables: x86: Reserve memory occupied by ACPI tables

Jesper Dangaard Brouer <brouer@redhat.com>
    bpf: Remove MTU check in __bpf_skb_max_len

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: 9p: advance iov on empty read

Tong Zhang <ztong0001@gmail.com>
    net: wan/lmc: unregister device when no matching device is found

Alex Elder <elder@linaro.org>
    net: ipa: fix register write command validation

Alex Elder <elder@linaro.org>
    net: ipa: remove two unused register definitions

Doug Brown <doug@schmorgal.com>
    appletalk: Fix skb allocation size in loopback case

Nathan Rossi <nathan.rossi@digi.com>
    net: ethernet: aquantia: Handle error cleanup of start on open

Shuah Khan <skhan@linuxfoundation.org>
    ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: don't disable interrupts for reg_lock

Ido Schimmel <idosch@nvidia.com>
    netdevsim: dev: Initialize FIB module after debugfs

Guo-Feng Fan <vincent_fann@realtek.com>
    rtw88: coex: 8821c: correct antenna switch function

Wen Gong <wgong@codeaurora.org>
    ath11k: add ieee80211_unregister_hw to avoid kernel crash caused by NULL pointer

Luca Pesce <luca.pesce@vimar.com>
    brcmfmac: clear EAP/association status bits on linkdown events

Sasha Levin <sashal@kernel.org>
    can: tcan4x5x: fix max register value

Oleksij Rempel <linux@rempel-privat.de>
    net: introduce CAN specific pointer in the struct net_device

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: move driver related infrastructure into separate subdir

Davide Caratti <dcaratti@redhat.com>
    flow_dissector: fix TTL and TOS dissection on IPv4 fragments

Sasha Levin <sashal@kernel.org>
    net: mvpp2: fix interrupt mask/unmask skip condition

Stefan Metzmacher <metze@samba.org>
    io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL

zhangyi (F) <yi.zhang@huawei.com>
    ext4: do not iput inode under running transaction in ext4_rename()

Peter Zijlstra <peterz@infradead.org>
    static_call: Align static_call_is_init() patching condition

Stefan Metzmacher <metze@samba.org>
    io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls

Elad Grupi <elad.grupi@dell.com>
    nvmet-tcp: fix kmap leak when data digest in use

Waiman Long <longman@redhat.com>
    locking/ww_mutex: Fix acquire/release imbalance in ww_acquire_init()/ww_acquire_fini()

Waiman Long <longman@redhat.com>
    locking/ww_mutex: Simplify use_ww_ctx & ww_ctx handling

Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>
    thermal/core: Add NULL pointer check before using cooling device stats

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: rt711: add snd_soc_component remove callback

Sameer Pujar <spujar@nvidia.com>
    ASoC: rt5659: Update MCLK rate in set_sysclk()

Tong Zhang <ztong0001@gmail.com>
    staging: comedi: cb_pcidas64: fix request_irq() warn

Tong Zhang <ztong0001@gmail.com>
    staging: comedi: cb_pcidas: fix request_irq() warn

Alexey Dobriyan <adobriyan@gmail.com>
    scsi: qla2xxx: Fix broken #endif placement

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    scsi: st: Fix a use after free in st_open()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix ->flags races by linked timeouts

Laurent Vivier <lvivier@redhat.com>
    vhost: Fix vhost_vq_reset()

Jens Axboe <axboe@kernel.dk>
    kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing

Olga Kornievskaia <kolga@netapp.com>
    NFSD: fix error handling in NFSv4.0 callbacks

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Always wait at least 3ms after reset

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Fix mixer volume control

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Fix channel width support

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs42l42: Fix Bitclock polarity inversion

Jon Hunter <jonathanh@nvidia.com>
    ASoC: soc-core: Prevent warning if no DMI table is present

Hans de Goede <hdegoede@redhat.com>
    ASoC: es8316: Simplify adc_pga_gain_tlv table

Benjamin Rood <benjaminjrood@gmail.com>
    ASoC: sgtl5000: set DAP_AVC_CTRL register to correct default value on probe

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5651: Fix dac- and adc- vol-tlv values being off by a factor of 10

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5640: Fix dac- and adc- vol-tlv values being off by a factor of 10

Jack Yu <jack.yu@realtek.com>
    ASoC: rt1015: fix i2c communication error

Ritesh Harjani <riteshh@linux.ibm.com>
    iomap: Fix negative assignment to unsigned sis->pages in iomap_swapfile_activate

J. Bruce Fields <bfields@redhat.com>
    rpc: fix NULL dereference on kmalloc failure

Julian Braha <julianbraha@gmail.com>
    fs: nfsd: fix kconfig dependency warning for NFSD_V4

Zhaolong Zhang <zhangzl2013@126.com>
    ext4: fix bh ref count on error paths

Eric Whitney <enwlinux@gmail.com>
    ext4: shrink race window in ext4_should_retry_alloc()

Vivek Goyal <vgoyal@redhat.com>
    virtiofs: Fail dax mount if device does not support it

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix fexit trampoline.

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: mm: correct the inside linear map range during hotplug check


-------------

Diffstat:

 Documentation/virt/kvm/locking.rst                 |   9 +-
 Makefile                                           |   4 +-
 arch/arm64/mm/mmu.c                                |  20 +-
 arch/riscv/include/asm/uaccess.h                   |   7 +-
 arch/s390/include/asm/vdso/data.h                  |   2 +-
 arch/s390/kernel/time.c                            |   1 +
 arch/x86/include/asm/kvm_host.h                    |  15 +
 arch/x86/include/asm/smp.h                         |   1 +
 arch/x86/kernel/acpi/boot.c                        |  25 +-
 arch/x86/kernel/setup.c                            |   8 +-
 arch/x86/kernel/smpboot.c                          |   2 +-
 arch/x86/kvm/Makefile                              |   3 +-
 arch/x86/kvm/mmu/mmu.c                             |  49 +--
 arch/x86/kvm/mmu/mmu_internal.h                    |   5 +
 arch/x86/kvm/mmu/tdp_iter.c                        |  46 +--
 arch/x86/kvm/mmu/tdp_iter.h                        |  21 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         | 450 +++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h                         |  32 +-
 arch/x86/kvm/svm/nested.c                          |  28 +-
 arch/x86/net/bpf_jit_comp.c                        |  27 +-
 arch/xtensa/kernel/coprocessor.S                   |  64 +--
 arch/xtensa/mm/fault.c                             |   5 +-
 drivers/acpi/processor_idle.c                      |   7 +
 drivers/acpi/tables.c                              |  42 +-
 drivers/base/dd.c                                  |   3 +
 drivers/base/power/runtime.c                       |  10 +-
 drivers/extcon/extcon.c                            |   1 +
 drivers/firewire/nosy.c                            |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_dbgdev.c            |   2 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   6 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager.c    |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_vi.c |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   8 +-
 drivers/gpu/drm/imx/imx-drm-core.c                 |   2 +-
 drivers/gpu/drm/tegra/dc.c                         |  20 +-
 drivers/gpu/drm/tegra/sor.c                        |   7 +
 drivers/net/can/Makefile                           |   7 +-
 drivers/net/can/dev/Makefile                       |   7 +
 drivers/net/can/{ => dev}/dev.c                    |   4 +-
 drivers/net/can/{ => dev}/rx-offload.c             |   0
 drivers/net/can/m_can/tcan4x5x.c                   |   2 +-
 drivers/net/can/slcan.c                            |   4 +-
 drivers/net/can/vcan.c                             |   2 +-
 drivers/net/can/vxcan.c                            |   6 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   4 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 drivers/net/ipa/gsi_reg.h                          |  10 -
 drivers/net/ipa/ipa_cmd.c                          |  32 +-
 drivers/net/netdevsim/dev.c                        |  40 +-
 drivers/net/wan/lmc/lmc_main.c                     |   2 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   7 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   7 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  22 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |  16 +-
 drivers/nvme/target/tcp.c                          |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  13 +-
 drivers/scsi/qla2xxx/qla_target.h                  |   2 +-
 drivers/scsi/st.c                                  |   2 +-
 drivers/soc/qcom/qcom-geni-se.c                    |  74 ----
 drivers/staging/comedi/drivers/cb_pcidas.c         |   2 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   2 +-
 drivers/staging/rtl8192e/rtllib.h                  |   2 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |   2 +-
 drivers/thermal/thermal_sysfs.c                    |   3 +
 drivers/tty/serial/qcom_geni_serial.c              |   7 -
 drivers/usb/class/cdc-acm.c                        |  61 ++-
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/dwc2/hcd.c                             |   5 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +
 drivers/usb/dwc3/dwc3-qcom.c                       |   3 +
 drivers/usb/dwc3/gadget.c                          |   8 +-
 drivers/usb/gadget/udc/amd5536udc_pci.c            |  10 +-
 drivers/usb/host/xhci-mtk.c                        |  10 +-
 drivers/usb/musb/musb_core.c                       |  12 +-
 drivers/usb/usbip/vhci_hcd.c                       |   2 +
 drivers/vfio/pci/Kconfig                           |   2 +-
 drivers/vhost/vhost.c                              |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |   3 +
 drivers/video/fbdev/hyperv_fb.c                    |   3 -
 fs/ext4/balloc.c                                   |  38 +-
 fs/ext4/ext4.h                                     |   1 +
 fs/ext4/inode.c                                    |   6 +-
 fs/ext4/namei.c                                    |  18 +-
 fs/ext4/super.c                                    |   5 +
 fs/ext4/sysfs.c                                    |   7 +
 fs/fuse/virtio_fs.c                                |   9 +-
 fs/io_uring.c                                      |  33 +-
 fs/iomap/swapfile.c                                |  10 +
 fs/nfsd/Kconfig                                    |   1 +
 fs/nfsd/nfs4callback.c                             |   1 +
 fs/reiserfs/xattr.h                                |   2 +-
 include/linux/acpi.h                               |   9 +-
 include/linux/bpf.h                                |  24 +-
 include/linux/can/can-ml.h                         |  12 +
 include/linux/extcon.h                             |  23 ++
 .../linux/firmware/intel/stratix10-svc-client.h    |   2 +-
 include/linux/netdevice.h                          |  34 +-
 include/linux/qcom-geni-se.h                       |   2 -
 include/linux/ww_mutex.h                           |   5 +-
 kernel/bpf/bpf_struct_ops.c                        |   2 +-
 kernel/bpf/core.c                                  |   4 +-
 kernel/bpf/trampoline.c                            | 218 +++++++---
 kernel/locking/mutex.c                             |  25 +-
 kernel/static_call.c                               |  14 +-
 kernel/trace/trace.c                               |   3 +-
 mm/memory.c                                        |   2 +-
 net/9p/client.c                                    |   4 -
 net/appletalk/ddp.c                                |  33 +-
 net/can/af_can.c                                   |  34 +-
 net/can/j1939/main.c                               |  22 +-
 net/can/j1939/socket.c                             |  13 +-
 net/can/proc.c                                     |  19 +-
 net/core/filter.c                                  |  12 +-
 net/core/flow_dissector.c                          |   6 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  11 +-
 sound/pci/hda/hda_intel.c                          |   8 +
 sound/pci/hda/patch_realtek.c                      |   4 +-
 sound/soc/codecs/cs42l42.c                         |  74 ++--
 sound/soc/codecs/cs42l42.h                         |  13 +-
 sound/soc/codecs/es8316.c                          |   9 +-
 sound/soc/codecs/rt1015.c                          |   1 +
 sound/soc/codecs/rt5640.c                          |   4 +-
 sound/soc/codecs/rt5651.c                          |   4 +-
 sound/soc/codecs/rt5659.c                          |   5 +
 sound/soc/codecs/rt711.c                           |   8 +
 sound/soc/codecs/sgtl5000.c                        |   2 +-
 sound/soc/soc-core.c                               |   4 +
 sound/usb/quirks.c                                 |   1 +
 .../testing/selftests/net/forwarding/tc_flower.sh  |  38 +-
 135 files changed, 1457 insertions(+), 778 deletions(-)


