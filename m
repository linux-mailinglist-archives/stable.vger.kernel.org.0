Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F23492EA
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfFQVZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbfFQVZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:25:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 626CA2063F;
        Mon, 17 Jun 2019 21:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806712;
        bh=3zxhVVeyvEczVauP+Kdvi0ImT85MSXuohe+CaORyClw=;
        h=From:To:Cc:Subject:Date:From;
        b=a1+WmKzPCt8mBm9IQq3kBT7X2cStiuirOXtBRVS5cJGU3pCtKRxFuuxwChyoz2dpM
         fo193bqdO0jNrQimBLymQKfrvPUhayO66RIXY+ifxq2lHMX3wusPdfItEOiLvYqIst
         BNV3EkRoc7jrgiWUqIRxWADI+RfphAXnQqh8Q+Zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/75] 4.19.53-stable review
Date:   Mon, 17 Jun 2019 23:09:11 +0200
Message-Id: <20190617210752.799453599@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.53-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.53-rc1
X-KernelTest-Deadline: 2019-06-19T21:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.53 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.53-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.53-rc1

Baruch Siach <baruch@tkos.co.il>
    rtc: pcf8523: don't return invalid date when battery is low

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

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/pmu: do not mask the value that is written to fixed PMUs

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/pmu: mask the result of rdpmc according to the width of the counters

James Morse <james.morse@arm.com>
    KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation

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

Colin Ian King <colin.king@canonical.com>
    scsi: bnx2fc: fix incorrect cast to u64 on shift operation

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

Mark Rutland <mark.rutland@arm.com>
    arm64/mm: Inhibit huge-vmap with ptdump

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: add check for loss of ndlp when sending RRQ

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: correct rcu unlock issue in lpfc_nvme_info_show

YueHaibing <yuehaibing@huawei.com>
    scsi: qedi: remove set but not used variables 'cdev' and 'udev'

YueHaibing <yuehaibing@huawei.com>
    scsi: qedi: remove memset/memcpy to nfunc and use func instead

Randall Huang <huangrandall@google.com>
    f2fs: fix to avoid accessing xattr across the boundary

Young Xiao <YangX92@hotmail.com>
    Drivers: misc: fix out-of-bounds access in function param_set_kgdbts_var

Vasily Gorbik <gor@linux.ibm.com>
    s390/kasan: fix strncpy_from_user kasan checks

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: seq: Protect in-kernel ioctl calls with mutex"

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix race of get-subscription call vs port-delete ioctls

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Protect in-kernel ioctl calls with mutex

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, kcov: Disable stack protector

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/sdvo: Implement proper HDMI audio support for SDVO

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

Robin Murphy <robin.murphy@arm.com>
    iommu/arm-smmu: Avoid constant zero in TLBI writes

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

Hans de Goede <hdegoede@redhat.com>
    libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: fix destruction of data for isochronous resources

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Update headset mode for ALC256

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

Thomas Backlund <tmb@mageia.org>
    nouveau: Fix build with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT disabled

Dave Airlie <airlied@redhat.com>
    drm/nouveau: add kconfig option to turn off nouveau legacy contexts. (v3)


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm/kvm/hyp/Makefile                       |   1 +
 arch/arm64/kvm/hyp/Makefile                     |   1 +
 arch/arm64/mm/mmu.c                             |  11 +-
 arch/s390/include/asm/uaccess.h                 |   2 +
 arch/s390/kvm/kvm-s390.c                        |  35 +++---
 arch/x86/kernel/cpu/intel_rdt_monitor.c         |   3 +
 arch/x86/kernel/cpu/microcode/core.c            |   2 +-
 arch/x86/kvm/pmu.c                              |  10 +-
 arch/x86/kvm/pmu.h                              |   3 +-
 arch/x86/kvm/pmu_amd.c                          |   2 +-
 arch/x86/kvm/pmu_intel.c                        |  26 +++--
 arch/x86/mm/kasan_init_64.c                     |   2 +-
 arch/x86/mm/kaslr.c                             |  11 +-
 drivers/ata/libata-core.c                       |   9 +-
 drivers/gpu/drm/drm_edid.c                      |  55 ++++++++--
 drivers/gpu/drm/drm_probe_helper.c              |   7 ++
 drivers/gpu/drm/i915/intel_sdvo.c               |  58 ++++++++--
 drivers/gpu/drm/i915/intel_sdvo_regs.h          |   3 +
 drivers/gpu/drm/nouveau/Kconfig                 |  13 ++-
 drivers/gpu/drm/nouveau/nouveau_drm.c           |   7 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c           |   4 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c         |   7 +-
 drivers/hid/hid-multitouch.c                    |   7 ++
 drivers/hid/wacom_wac.c                         |  71 +++++++++----
 drivers/i2c/busses/i2c-acorn.c                  |   1 +
 drivers/iommu/arm-smmu.c                        |  15 ++-
 drivers/md/bcache/bset.c                        |  16 ++-
 drivers/md/bcache/bset.h                        |  34 +++---
 drivers/md/bcache/sysfs.c                       |   7 +-
 drivers/misc/kgdbts.c                           |   4 +-
 drivers/net/usb/ipheth.c                        |   3 +-
 drivers/nvdimm/bus.c                            |   4 +-
 drivers/nvdimm/label.c                          |   2 +
 drivers/nvdimm/label.h                          |   2 -
 drivers/nvme/host/core.c                        |  74 ++++++++-----
 drivers/platform/x86/pmc_atom.c                 |  33 ++++++
 drivers/ras/cec.c                               |  80 +++++++-------
 drivers/rtc/rtc-pcf8523.c                       |  32 ++++--
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                |   2 +-
 drivers/scsi/lpfc/lpfc_attr.c                   |  32 +++---
 drivers/scsi/lpfc/lpfc_els.c                    |   5 +-
 drivers/scsi/qedi/qedi_dbg.c                    |  32 ++----
 drivers/scsi/qedi/qedi_iscsi.c                  |   4 -
 drivers/usb/core/quirks.c                       |   3 +
 drivers/usb/dwc2/hcd.c                          |  39 ++++---
 drivers/usb/dwc2/hcd.h                          |  20 ++--
 drivers/usb/dwc2/hcd_intr.c                     |   5 +-
 drivers/usb/dwc2/hcd_queue.c                    |  10 +-
 drivers/usb/serial/option.c                     |   6 ++
 drivers/usb/serial/pl2303.c                     |   1 +
 drivers/usb/serial/pl2303.h                     |   3 +
 drivers/usb/storage/unusual_realtek.h           |   5 +
 fs/f2fs/xattr.c                                 |  36 +++++--
 fs/f2fs/xattr.h                                 |   2 +
 fs/ocfs2/dcache.c                               |  12 +++
 include/drm/drm_edid.h                          |   1 +
 include/linux/cgroup.h                          |  10 +-
 include/linux/cpuhotplug.h                      |   1 +
 kernel/Makefile                                 |   1 +
 kernel/cred.c                                   |   9 ++
 kernel/ptrace.c                                 |  20 +++-
 kernel/time/timekeeping.c                       |   5 +-
 kernel/trace/trace_events_hist.c                |   3 +
 mm/list_lru.c                                   |   2 +-
 mm/vmscan.c                                     |   2 +-
 sound/core/seq/seq_clientmgr.c                  |  10 +-
 sound/core/seq/seq_ports.c                      |  13 ++-
 sound/core/seq/seq_ports.h                      |   5 +-
 sound/firewire/motu/motu-stream.c               |   2 +-
 sound/firewire/oxfw/oxfw.c                      |   3 -
 sound/pci/hda/patch_realtek.c                   |  91 +++++++++++-----
 sound/soc/codecs/cs42xx8.c                      |   1 +
 sound/soc/fsl/fsl_asrc.c                        |   4 +-
 tools/kvm/kvm_stat/kvm_stat                     |  16 ++-
 tools/kvm/kvm_stat/kvm_stat.txt                 |   2 +
 tools/testing/selftests/net/fib_rule_tests.sh   |   2 +-
 tools/testing/selftests/timers/adjtick.c        |   1 +
 tools/testing/selftests/timers/leapcrash.c      |   1 +
 tools/testing/selftests/timers/mqueue-lat.c     |   1 +
 tools/testing/selftests/timers/nanosleep.c      |   1 +
 tools/testing/selftests/timers/nsleep-lat.c     |   1 +
 tools/testing/selftests/timers/raw_skew.c       |   1 +
 tools/testing/selftests/timers/set-tai.c        |   1 +
 tools/testing/selftests/timers/set-tz.c         |   2 +
 tools/testing/selftests/timers/threadtest.c     |   1 +
 tools/testing/selftests/timers/valid-adjtimex.c |   2 +
 virt/kvm/arm/aarch32.c                          | 121 ---------------------
 virt/kvm/arm/hyp/aarch32.c                      | 136 ++++++++++++++++++++++++
 89 files changed, 898 insertions(+), 452 deletions(-)


