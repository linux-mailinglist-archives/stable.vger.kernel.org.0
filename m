Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A9249442
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbfFQVU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbfFQVU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:20:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B9C221019;
        Mon, 17 Jun 2019 21:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806426;
        bh=ymTC7xgtEe+AQ5AzpsjgvGVxKHuHax+zsKCSiuXSbZI=;
        h=From:To:Cc:Subject:Date:From;
        b=BQTXu0IVOb2cyNlm0Bwf5nsksi8VKxM8LyFvdJwdcbe/QUGaYthMSLb0MtzhoPf5o
         V/g8GmORQ6l69/zU97Z0hWuPtqShS93jnsKHjTigNiqsVApkcbMQnYKtq+Zwxa/dZ4
         mRd5Tt0rNs9pVbLx+ZnT9wFfAfuvt0kuokwuHWmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.1 000/115] 5.1.12-stable review
Date:   Mon, 17 Jun 2019 23:08:20 +0200
Message-Id: <20190617210759.929316339@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.1.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.1.12-rc1
X-KernelTest-Deadline: 2019-06-19T21:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.1.12 release.
There are 115 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.1.12-rc1

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix THP PMD collapse serialisation

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc: Fix kexec failure on book3s/32

Jani Nikula <jani.nikula@intel.com>
    drm: add fallback override/firmware EDID modes workaround

Jani Nikula <jani.nikula@intel.com>
    drm/edid: abstract override/firmware EDID retrieval

Prarit Bhargava <prarit@redhat.com>
    x86/resctrl: Prevent NULL pointer dereference when local MBM is disabled

Baoquan He <bhe@redhat.com>
    x86/mm/KASLR: Compute the size of the vmemmap section properly

Andrey Ryabinin <aryabinin@virtuozzo.com>
    x86/kasan: Fix boot with 5-level paging and KASAN

Borislav Petkov <bp@suse.de>
    x86/microcode, cpuhotplug: Add a microcode loader CPU hotplug callback

Borislav Petkov <bp@suse.de>
    RAS/CEC: Fix binary search function

Cong Wang <xiyou.wangcong@gmail.com>
    RAS/CEC: Convert the timer callback to a workqueue

Thomas Gleixner <tglx@linutronix.de>
    timekeeping: Repair ktime_get_coarse*() granularity

Eiichi Tsukata <devel@etsukata.com>
    tracing/uprobe: Fix NULL pointer dereference in trace_uprobe_create()

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit 0x1260 and 0x1261 compositions

Jörgen Storvist <jorgen.storvist@gmail.com>
    USB: serial: option: add support for Simcom SIM7500/SIM7600 RNDIS mode

Chris Packham <chris.packham@alliedtelesis.co.nz>
    USB: serial: pl2303: add Allied Telesis VT-Kit3

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: usb-storage: Add new ID to ums-realtek

Marco Zatta <marco@zatta.me>
    USB: Fix chipmunk-like voice when using Logitech C270 for recording audio.

Douglas Anderson <dianders@chromium.org>
    usb: dwc2: host: Fix wMaxPacketSize handling (fix webcam regression)

Martin Schiller <ms@dev.tdt.de>
    usb: dwc2: Fix DMA cache alignment issues

Murray McAllister <murray.mcallister@gmail.com>
    drm/vmwgfx: NULL pointer dereference from vmw_cmd_dx_view_define()

Murray McAllister <murray.mcallister@gmail.com>
    drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader() leading to an invalid read

Stefan Raspl <stefan.raspl@de.ibm.com>
    tools/kvm_stat: fix fields filter for child events

Andrew Jones <drjones@redhat.com>
    kvm: selftests: aarch64: fix default vm mode

Andrew Jones <drjones@redhat.com>
    kvm: selftests: aarch64: dirty_log_test: fix unaligned memslot size

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/pmu: do not mask the value that is written to fixed PMUs

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/pmu: mask the result of rdpmc according to the width of the counters

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not spam dmesg with VMCS/VMCB dumps

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow

Yi Wang <wang.yi59@zte.com.cn>
    kvm: vmx: Fix -Wmissing-prototypes warnings

Dan Carpenter <dan.carpenter@oracle.com>
    KVM: selftests: Fix a condition in test_hv_cpuid()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: really fix the size checks on KVM_SET_NESTED_STATE

James Morse <james.morse@arm.com>
    KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation

Jens Axboe <axboe@kernel.dk>
    tools/io_uring: fix Makefile for pthread library link

Keith Busch <keith.busch@intel.com>
    nvme-pci: use blk-mq mapping for unmanaged irqs

Bernd Eckstein <3erndeckstein@gmail.com>
    usbnet: ipheth: fix racing condition

Tom Zanussi <tom.zanussi@linux.intel.com>
    tracing: Prevent hist_field_var_ref() from accessing NULL tracing_map_elts

Kees Cook <keescook@chromium.org>
    selftests/timers: Add missing fflush(stdout) calls

Hangbin Liu <liuhangbin@gmail.com>
    selftests: fib_rule_tests: fix local IPv4 address typo

Qian Cai <cai@lca.pw>
    libnvdimm: Fix compilation warnings with W=1

Flora Cui <flora.cui@amd.com>
    drm/amdgpu: keep stolen memory on picasso

Colin Ian King <colin.king@canonical.com>
    scsi: bnx2fc: fix incorrect cast to u64 on shift operation

YueHaibing <yuehaibing@huawei.com>
    scsi: myrs: Fix uninitialized variable

Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
    platform/x86: pmc_atom: Add several Beckhoff Automation boards to critclk_systems DMI table

Hans de Goede <hdegoede@redhat.com>
    platform/x86: pmc_atom: Add Lex 3I380D industrial PC to critclk_systems DMI table

Yufen Yu <yuyufen@huawei.com>
    nvme: fix memory leak for power latency tolerance

Christoph Hellwig <hch@lst.de>
    nvme: release namespace SRCU protection before performing controller ioctls

Christoph Hellwig <hch@lst.de>
    nvme: merge nvme_ns_ioctl into nvme_ioctl

Christoph Hellwig <hch@lst.de>
    nvme: remove the ifdef around nvme_nvm_ioctl

Christoph Hellwig <hch@lst.de>
    nvme: fix srcu locking on error return in nvme_get_ns_from_disk

Keith Busch <keith.busch@intel.com>
    nvme-pci: Fix controller freeze wait disabling

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: fix bpf_get_current_task

Yonghong Song <yhs@fb.com>
    tools/bpftool: move set_max_rlimit() before __bpf_object__open_xattr()

Mark Rutland <mark.rutland@arm.com>
    arm64/mm: Inhibit huge-vmap with ptdump

John Fastabend <john.fastabend@gmail.com>
    bpf, tcp: correctly handle DONT_WAIT flags and timeo == 0

Claudiu Manoil <claudiu.manoil@nxp.com>
    enetc: Fix NULL dma address unmap for Tx BD extensions

Luca Ceresoli <luca@lucaceresoli.net>
    net: macb: fix error format in dev_err()

Will Deacon <will.deacon@arm.com>
    arm64: Print physical address of page table base in show_pte()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: add check for loss of ndlp when sending RRQ

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: correct rcu unlock issue in lpfc_nvme_info_show

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: resolve lockdep warnings

YueHaibing <yuehaibing@huawei.com>
    scsi: qedi: remove set but not used variables 'cdev' and 'udev'

YueHaibing <yuehaibing@huawei.com>
    scsi: qedi: remove memset/memcpy to nfunc and use func instead

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Add cleanup for PCI EEH recovery

John Fastabend <john.fastabend@gmail.com>
    bpf: sockmap fix msg->sg.size account on ingress skb

John Fastabend <john.fastabend@gmail.com>
    bpf: sockmap remove duplicate queue free

John Fastabend <john.fastabend@gmail.com>
    bpf: sockmap, only stop/flush strp if it was enabled at some point

Will Deacon <will.deacon@arm.com>
    drivers/perf: arm_spe: Don't error on high-order pages for aux buf

Randall Huang <huangrandall@google.com>
    f2fs: fix to avoid accessing xattr across the boundary

Young Xiao <YangX92@hotmail.com>
    Drivers: misc: fix out-of-bounds access in function param_set_kgdbts_var

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: seq: Protect in-kernel ioctl calls with mutex"

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix race of get-subscription call vs port-delete ioctls

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Protect in-kernel ioctl calls with mutex

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, kcov: Disable stack protector

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/i915/dmc: protect against reading random memory

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix per-pixel alpha with CCS

Hans de Goede <hdegoede@redhat.com>
    drm/i915/dsi: Use a fuzzy check for burst mode clock check

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/sdvo: Implement proper HDMI audio support for SDVO

Shirish S <shirish.s@amd.com>
    drm/amdgpu/{uvd,vcn}: fetch ring's read_ptr after alloc

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-core: fixup references at soc_cleanup_card_resources()

S.j. Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: Fix the issue about unsupported rate

S.j. Wang <shengjiu.wang@nxp.com>
    ASoC: cs42xx8: Add regcache mask dirty

Tejun Heo <tj@kernel.org>
    cgroup: Use css_tryget() instead of css_tryget_online() in task_get_css()

Coly Li <colyli@suse.de>
    bcache: only set BCACHE_DEV_WB_RUNNING when cached device attached

Coly Li <colyli@suse.de>
    bcache: fix stack corruption by PRECEDING_KEY()

Russell King <rmk+kernel@armlinux.org.uk>
    i2c: acorn: fix i2c warning

Casey Schaufler <casey@schaufler-ca.com>
    Smack: Restore the smackfsdef mount option and add missing prefixes

Robin Murphy <robin.murphy@arm.com>
    iommu/arm-smmu: Avoid constant zero in TLBI writes

Sean Young <sean@mess.org>
    media: dvb: warning about dvb frequency limits produces too much noise

Jann Horn <jannh@google.com>
    ptrace: restore smp_rmb() in __ptrace_may_access()

Eric W. Biederman <ebiederm@xmission.com>
    signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_SIGINFO

Minchan Kim <minchan@kernel.org>
    mm/vmscan.c: fix trying to reclaim unevictable LRU page

Wengang Wang <wen.gang.wang@oracle.com>
    fs/ocfs2: fix race in ocfs2_dentry_attach_lock()

Shakeel Butt <shakeelb@google.com>
    mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node

Eric Biggers <ebiggers@google.com>
    io_uring: fix memory leak of UNIX domain socket inode

Hans de Goede <hdegoede@redhat.com>
    libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk

Gen Zhang <blackgod016574@gmail.com>
    selinux: fix a missing-check bug in selinux_sb_eat_lsm_opts()

Gen Zhang <blackgod016574@gmail.com>
    selinux: fix a missing-check bug in selinux_add_mnt_opt( )

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: log raw contexts as untrusted strings

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: fix destruction of data for isochronous resources

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Update headset mode for ALC256

Rui Nuno Capela <rncbc@rncbc.org>
    ALSA: ice1712: Check correct return value to snd_i2c_sendbytes (EWS/DMX 6Fire)

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: oxfw: allow PCM capture for Stanton SCS.1m

Hui Wang <hui.wang@canonical.com>
    Revert "ALSA: hda/realtek - Improve the headset mic for Acer Aspire laptops"

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Sync INTUOSP2_BT touch state after each frame if necessary

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Correct button numbering 2nd-gen Intuos Pro over Bluetooth

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Send BTN_TOUCH in response to INTUOSP2_BT eraser contact

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Don't report anything prior to the tool entering range

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Don't set tool type until we're in range

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: multitouch: handle faulty Elo touch device

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Revert "HID: Increase maximum report size allowed by hid_field_extract()"

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: input: fix assignment of .value

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: input: make sure the wheel high resolution multiplier is set

Thomas Backlund <tmb@mageia.org>
    nouveau: Fix build with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT disabled

Dave Airlie <airlied@redhat.com>
    drm/nouveau: add kconfig option to turn off nouveau legacy contexts. (v3)


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/kvm/hyp/Makefile                          |   1 +
 arch/arm64/kvm/hyp/Makefile                        |   1 +
 arch/arm64/mm/fault.c                              |   5 +-
 arch/arm64/mm/mmu.c                                |  11 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  30 +++
 arch/powerpc/include/asm/kexec.h                   |   3 +
 arch/powerpc/kernel/machine_kexec_32.c             |   4 +-
 arch/powerpc/mm/pgtable-book3s64.c                 |   3 +
 arch/s390/kvm/kvm-s390.c                           |  35 ++--
 arch/x86/kernel/cpu/microcode/core.c               |   2 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |   3 +
 arch/x86/kvm/pmu.c                                 |  10 +-
 arch/x86/kvm/pmu.h                                 |   3 +-
 arch/x86/kvm/pmu_amd.c                             |   2 +-
 arch/x86/kvm/svm.c                                 |   9 +-
 arch/x86/kvm/vmx/nested.c                          |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  26 ++-
 arch/x86/kvm/vmx/vmx.c                             |  26 ++-
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/x86/mm/kasan_init_64.c                        |   2 +-
 arch/x86/mm/kaslr.c                                |  11 +-
 drivers/ata/libata-core.c                          |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   1 +
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |   5 +-
 drivers/gpu/drm/drm_edid.c                         |  55 ++++-
 drivers/gpu/drm/drm_probe_helper.c                 |   7 +
 drivers/gpu/drm/i915/intel_csr.c                   |  18 ++
 drivers/gpu/drm/i915/intel_display.c               |  14 +-
 drivers/gpu/drm/i915/intel_drv.h                   |   1 +
 drivers/gpu/drm/i915/intel_dsi_vbt.c               |  11 +
 drivers/gpu/drm/i915/intel_sdvo.c                  |  58 +++++-
 drivers/gpu/drm/i915/intel_sdvo_regs.h             |   3 +
 drivers/gpu/drm/nouveau/Kconfig                    |  13 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   7 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |   4 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   7 +-
 drivers/hid/hid-core.c                             |  13 +-
 drivers/hid/hid-input.c                            |  81 +++++---
 drivers/hid/hid-multitouch.c                       |   7 +
 drivers/hid/wacom_wac.c                            |  71 +++++--
 drivers/i2c/busses/i2c-acorn.c                     |   1 +
 drivers/iommu/arm-smmu.c                           |  15 +-
 drivers/md/bcache/bset.c                           |  16 +-
 drivers/md/bcache/bset.h                           |  34 ++--
 drivers/md/bcache/sysfs.c                          |   7 +-
 drivers/media/dvb-core/dvb_frontend.c              |   2 +-
 drivers/misc/kgdbts.c                              |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           |  16 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   4 +-
 drivers/net/usb/ipheth.c                           |   3 +-
 drivers/nvdimm/bus.c                               |   4 +-
 drivers/nvdimm/label.c                             |   2 +
 drivers/nvdimm/label.h                             |   2 -
 drivers/nvme/host/core.c                           |  74 ++++---
 drivers/nvme/host/pci.c                            |  14 +-
 drivers/perf/arm_spe_pmu.c                         |  10 +-
 drivers/platform/x86/pmc_atom.c                    |  33 +++
 drivers/ras/cec.c                                  |  80 ++++----
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  37 ++--
 drivers/scsi/lpfc/lpfc_els.c                       |   5 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  84 +++++---
 drivers/scsi/myrs.c                                |   2 +-
 drivers/scsi/qedi/qedi_dbg.c                       |  32 +--
 drivers/scsi/qedi/qedi_iscsi.c                     |   4 -
 drivers/scsi/qla2xxx/qla_os.c                      | 221 ++++++++-------------
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc2/hcd.c                             |  39 ++--
 drivers/usb/dwc2/hcd.h                             |  20 +-
 drivers/usb/dwc2/hcd_intr.c                        |   5 +-
 drivers/usb/dwc2/hcd_queue.c                       |  10 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   3 +
 drivers/usb/storage/unusual_realtek.h              |   5 +
 fs/f2fs/xattr.c                                    |  36 +++-
 fs/f2fs/xattr.h                                    |   2 +
 fs/io_uring.c                                      |   4 +-
 fs/ocfs2/dcache.c                                  |  12 ++
 include/drm/drm_edid.h                             |   1 +
 include/linux/cgroup.h                             |  10 +-
 include/linux/cpuhotplug.h                         |   1 +
 include/linux/hid.h                                |   2 +-
 kernel/Makefile                                    |   1 +
 kernel/cred.c                                      |   9 +
 kernel/ptrace.c                                    |  20 +-
 kernel/time/timekeeping.c                          |   5 +-
 kernel/trace/trace_events_hist.c                   |   3 +
 kernel/trace/trace_uprobe.c                        |  13 +-
 mm/list_lru.c                                      |   2 +-
 mm/vmscan.c                                        |   2 +-
 net/core/skmsg.c                                   |   7 +-
 net/ipv4/tcp_bpf.c                                 |   7 +-
 security/selinux/avc.c                             |  10 +-
 security/selinux/hooks.c                           |  39 +++-
 security/smack/smack_lsm.c                         |  12 +-
 sound/core/seq/seq_clientmgr.c                     |  10 +-
 sound/core/seq/seq_ports.c                         |  13 +-
 sound/core/seq/seq_ports.h                         |   5 +-
 sound/firewire/motu/motu-stream.c                  |   2 +-
 sound/firewire/oxfw/oxfw.c                         |   3 -
 sound/pci/hda/patch_realtek.c                      |  91 ++++++---
 sound/pci/ice1712/ews.c                            |   2 +-
 sound/soc/codecs/cs42xx8.c                         |   1 +
 sound/soc/fsl/fsl_asrc.c                           |   4 +-
 sound/soc/soc-core.c                               |   7 +-
 sound/soc/soc-dapm.c                               |   3 +
 tools/bpf/bpftool/prog.c                           |   4 +-
 tools/io_uring/Makefile                            |   2 +-
 tools/kvm/kvm_stat/kvm_stat                        |  16 +-
 tools/kvm/kvm_stat/kvm_stat.txt                    |   2 +
 tools/testing/selftests/bpf/bpf_helpers.h          |   2 +-
 tools/testing/selftests/kvm/dirty_log_test.c       |   2 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   2 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |   5 +-
 tools/testing/selftests/net/fib_rule_tests.sh      |   2 +-
 tools/testing/selftests/timers/adjtick.c           |   1 +
 tools/testing/selftests/timers/leapcrash.c         |   1 +
 tools/testing/selftests/timers/mqueue-lat.c        |   1 +
 tools/testing/selftests/timers/nanosleep.c         |   1 +
 tools/testing/selftests/timers/nsleep-lat.c        |   1 +
 tools/testing/selftests/timers/raw_skew.c          |   1 +
 tools/testing/selftests/timers/set-tai.c           |   1 +
 tools/testing/selftests/timers/set-tz.c            |   2 +
 tools/testing/selftests/timers/threadtest.c        |   1 +
 tools/testing/selftests/timers/valid-adjtimex.c    |   2 +
 virt/kvm/arm/aarch32.c                             | 121 -----------
 virt/kvm/arm/hyp/aarch32.c                         | 136 +++++++++++++
 132 files changed, 1296 insertions(+), 739 deletions(-)


