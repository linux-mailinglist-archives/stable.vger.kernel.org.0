Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED79AB1E8B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388347AbfIMNLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388155AbfIMNLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:13 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74873208C0;
        Fri, 13 Sep 2019 13:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380271;
        bh=xSFZaKNzA+UGp3DLx1VR+F+iyqy69UoLxuTUSty0Enk=;
        h=From:To:Cc:Subject:Date:From;
        b=Wg8M+5s8p+L0XuFpmV7zqKkIcI++LCDIbgPbwoe9XrJC4PpjuEkXmPWWDfTMelMeZ
         SAcwYNH7KUMpUxZE9KpqHK+8QY9in41jkPF+Mb6Sl5DeqDSC9trn9A1pjKIf4qpN/P
         6d7yQ+piInEgeBqop+Zzw9zQqWurlC1ScJiQQuvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/190] 4.19.73-stable review
Date:   Fri, 13 Sep 2019 14:04:15 +0100
Message-Id: <20190913130559.669563815@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.73-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.73-rc1
X-KernelTest-Deadline: 2019-09-15T13:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.73 release.
There are 190 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.73-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.73-rc1

yongduan <yongduan@tencent.com>
    vhost: make sure log_num < in_num

Michael S. Tsirkin <mst@redhat.com>
    vhost: block speculation of translated descriptors

Gustavo Romero <gromero@linux.ibm.com>
    powerpc/tm: Fix restoring FP/VMX facility incorrectly on interrupts

Breno Leitao <leitao@debian.org>
    powerpc/tm: Remove msr_tm_active()

Lyude Paul <lyude@redhat.com>
    PCI: Reset both NVIDIA GPU and HDA in ThinkPad P50 workaround

Colin Ian King <colin.king@canonical.com>
    ext4: unsigned int compared against zero

Theodore Ts'o <tytso@mit.edu>
    ext4: fix block validity checks for journal inodes using indirect blocks

Theodore Ts'o <tytso@mit.edu>
    ext4: don't perform block validity checks on the journal inode

Lyude Paul <lyude@redhat.com>
    drm/atomic_helper: Allow DPMS On<->Off changes for unregistered connectors

Halil Pasic <pasic@linux.ibm.com>
    virtio/s390: fix race on airq_areas[]

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Make sure cdclk is high enough for DP audio on VLV/CHV

Coly Li <colyli@suse.de>
    bcache: fix race in btree_flush_write()

Coly Li <colyli@suse.de>
    bcache: add comments for mutex_lock(&b->write_lock)

Coly Li <colyli@suse.de>
    bcache: only clear BTREE_NODE_dirty bit when it is set

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix delegation state recovery

Arnd Bergmann <arnd@arndb.de>
    iio: adc: gyroadc: fix uninitialized return code

Ralph Campbell <rcampbell@nvidia.com>
    mm/migrate.c: initialize pud_entry in migrate_vma()

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    i2c: at91: fix clk_offset for sama5d2

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    i2c: at91: disable TXRDY interrupt after sending data

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpio: don't WARN() on NULL descs if gpiolib is disabled

Chris Wilson <chris@chris-wilson.co.uk>
    iommu/iova: Remove stale cached32_node

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    powerpc/mm: Limit rma_size to 1TB when running without HV mode

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix intermittent CORB/RIRB stall on Intel chips

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    drm/panel: Add support for Armadeus ST0700 Adapt

Mike Snitzer <snitzer@redhat.com>
    dm thin metadata: check if in fail_io mode when setting needs_check

Norbert Manthey <nmanthey@amazon.de>
    pstore: Fix double-free in pstore_mkfile() failure path

Nadav Amit <namit@vmware.com>
    resource: fix locking in find_next_iomem_res()

Bjorn Helgaas <bhelgaas@google.com>
    resource: Fix find_next_iomem_res() iteration issue

Bjorn Helgaas <bhelgaas@google.com>
    resource: Include resource end in walk_*() interfaces

Johannes Thumshirn <jthumshirn@suse.de>
    btrfs: correctly validate compression type

Bart Van Assche <bvanassche@acm.org>
    RDMA/srp: Accept again source addresses that do not have a port number

Bart Van Assche <bvanassche@acm.org>
    RDMA/srp: Document srp_parse_in() arguments

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: gemini: Set DIR-685 SPI CS as active low

Michael Neuling <mikey@neuling.org>
    KVM: PPC: Book3S HV: Fix CR0 setting in TM emulation

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Use ccr field in pt_regs struct embedded in vcpu struct

Wanpeng Li <wanpengli@tencent.com>
    KVM: VMX: check CPUID before allowing read/write of IA32_XSS

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Fix handling of #MC that occurs during VM-Entry

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: optimize check for valid PAT value

Yan, Zheng <zyan@redhat.com>
    ceph: use ceph_evict_inode to cleanup inode's resource

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't resume forcibly i915 HDMI/DP codec

Paulo Alcantara (SUSE) <paulo@paulo.ac>
    cifs: Properly handle auto disabling of serverino option

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: fix request object use-after-free in send path causing wrong traces

Ajay Singh <ajay.kathat@microchip.com>
    staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: target/iblock: Fix overrun in WRITE SAME emulation

Bart Van Assche <bvanassche@acm.org>
    scsi: target/core: Use the SECTOR_SHIFT constant

Mike Salvatore <mike.salvatore@canonical.com>
    apparmor: reset pos on failure to unpack for various functions

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Avoid hardlockup with flushlist_lock

Jon Hunter <jonathanh@nvidia.com>
    clk: tegra210: Fix default rates for HDA clocks

Jon Hunter <jonathanh@nvidia.com>
    clk: tegra: Fix maximum audio sync clock for Tegra124/210

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: add spinlock for the openFileList to cifsInodeInfo

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between block group removal and block group allocation

Shirish S <shirish.s@amd.com>
    drm/amdgpu/{uvd,vcn}: fetch ring's read_ptr after alloc

Louis Li <Ching-shih.Li@amd.com>
    drm/amdgpu: fix ring test failure issue during s3 in vce 3.0 (V2)

Peter Xu <peterx@redhat.com>
    kvm: Check irqchip mode before assign irqfd

Kent Russell <kent.russell@amd.com>
    drm/amdkfd: Add missing Polaris10 ID

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: mm: SIGSEGV userspace trying to access kernel virtual memory

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: mm: fix uninitialised signal code in do_page_fault

Eric W. Biederman <ebiederm@xmission.com>
    signal/arc: Use force_sig_fault where appropriate

Milan Broz <gmazyland@gmail.com>
    dm crypt: move detailed message into debug level

Long Li <longli@microsoft.com>
    cifs: smbd: take an array of reqeusts when sending upper layer data

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    PCI: dwc: Use devm_pci_alloc_host_bridge() to simplify code

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Add support for Intel CML

Ming Lei <ming.lei@redhat.com>
    blk-mq: free hw queue's resource in hctx's release handler

Yufen Yu <yuyufen@huawei.com>
    dm mpath: fix missing call of path selector type->end_io

Lyude Paul <lyude@redhat.com>
    PCI: Reset Lenovo ThinkPad P50 nvgpu at boot if necessary

Logan Gunthorpe <logang@deltatee.com>
    PCI: Add macro for Switchtec quirk declarations

Christoph Muellner <christoph.muellner@theobroma-systems.com>
    dt-bindings: mmc: Add disable-cqe-dcmd property.

Sowjanya Komatineni <skomatineni@nvidia.com>
    dt-bindings: mmc: Add supports-cqe property

Christian Lamparter <chunkeey@gmail.com>
    ARM: dts: qcom: ipq4019: enlarge PCIe BAR range

Niklas Cassel <niklas.cassel@linaro.org>
    ARM: dts: qcom: ipq4019: Fix MSI IRQ type

Mathias Kresin <dev@kresin.me>
    ARM: dts: qcom: ipq4019: fix PCI range

Theodore Ts'o <tytso@mit.edu>
    ext4: protect journal inode's blocks using block_validity

Koen Vandeputte <koen.vandeputte@ncentric.com>
    media: i2c: tda1997x: select V4L2_FWNODE

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix lease buffer length error

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Always use 32-bit SMRAM save state for 32-bit kernels

WANG Chao <chao.wang@ucloud.cn>
    x86/kvm: move kvm_load/put_guest_xcr0 into atomic context

Ben Gardon <bgardon@google.com>
    kvm: mmu: Fix overflow on kvm mmu page limit calculation

Moni Shoua <monis@mellanox.com>
    IB/mlx5: Reset access mask when looping inside page fault handler

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: stratix10: add the sysmgr-syscon property from the gmac's

Hans de Goede <hdegoede@redhat.com>
    usb: typec: tcpm: Try PD-2.0 if sink does not respond to 3.0 source-caps

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Sanity check mmap length against object size

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915: Handle vm_mmap error during I915_GEM_MMAP ioctl with WC set

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix leaking locked VFS cache pages in writeback retry

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix error paths in writeback code

Ben Dooks <ben.dooks@codethink.co.uk>
    drm: add __user attribute to ptr_to_compat()

Bjorn Andersson <bjorn.andersson@linaro.org>
    PCI: qcom: Don't deassert reset GPIO during probe

Bjorn Andersson <bjorn.andersson@linaro.org>
    PCI: qcom: Fix error handling in runtime PM support

Dan Robertson <dan@dlrobertson.com>
    btrfs: init csum_list before possible free

Anand Jain <anand.jain@oracle.com>
    btrfs: scrub: fix circular locking dependency warning

David Sterba <dsterba@suse.com>
    btrfs: scrub: move scrub_setup_ctx allocation out of device_list_mutex

David Sterba <dsterba@suse.com>
    btrfs: scrub: pass fs_info to scrub_setup_ctx

Takeshi Saito <takeshi.saito.xv@renesas.com>
    mmc: renesas_sdhi: Fix card initialization failure in high speed mode

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/kvm: Save and restore host AMR/IAMR/UAMOR

Russell King <rmk+kernel@armlinux.org.uk>
    spi: spi-gpio: fix SPI_CS_HIGH capability

Pavel Tatashin <pasha.tatashin@soleen.com>
    x86/kvmclock: set offset for kvm unstable clock

Ihab Zhaika <ihab.zhaika@intel.com>
    iwlwifi: add new card for 9260 series

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules

Lyude Paul <lyude@redhat.com>
    drm/nouveau: Don't WARN_ON VCPI allocation failures

Felix Fietkau <nbd@nbd.name>
    mt76: fix corrupted software generated tx CCMP PN

Krzysztof Kozlowski <krzk@kernel.org>
    iio: adc: exynos-adc: Use proper number of channels for Exynos4x12

Jonathan Bakker <xc-racer2@live.ca>
    dt-bindings: iio: adc: exynos-adc: Add S5PV210 variant

Jonathan Bakker <xc-racer2@live.ca>
    iio: adc: exynos-adc: Add S5PV210 variant

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Compare only a single byte for VMCS' "launched" in vCPU-run

Tang Junhui <tang.junhui.linux@gmail.com>
    bcache: treat stale && dirty keys as bad keys

Coly Li <colyli@suse.de>
    bcache: replace hard coded number with BUCKET_GC_GEN_MAX

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    tpm: Fix some name collisions with drivers/char/tpm.h

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    mfd: Kconfig: Fix I2C_DESIGNWARE_PLATFORM dependencies

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/ilk: Fix warning when reading emon_status with no output

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/vblank: Allow dynamic per-crtc max_vblank_count

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - add missing inline qualifier

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix resume race condition on init

Yishai Hadas <yishaih@mellanox.com>
    IB/uverbs: Fix OOPs upon device disassociation

Vineet Gupta <vgupta@synopsys.com>
    ARC: mm: do_page_fault fixes #1: relinquish mmap_sem if signal arrives while handle_mm_fault

Vineet Gupta <vgupta@synopsys.com>
    ARC: show_regs: lockdep: re-enable preemption

Hans Verkuil <hverkuil@xs4all.nl>
    media: vim2m: only cancel work if it is for right context

Qu Wenruo <wqu@suse.com>
    btrfs: Use real device structure to verify dev extent

Qu Wenruo <wqu@suse.com>
    btrfs: volumes: Make sure no dev extent is beyond device boundary

Ram Pai <linuxram@us.ibm.com>
    powerpc/pkeys: Fix handling of pkey state across fork()

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: megaraid_sas: Use 63-bit DMA addressing

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: megaraid_sas: Add check for reset adapter bit

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: megaraid_sas: Fix combined reply queue mode detection

Nikolay Borisov <nborisov@suse.com>
    btrfs: Fix error handling in btrfs_cleanup_ordered_extents

Nikolay Borisov <nborisov@suse.com>
    btrfs: Remove extent_io_ops::fill_delalloc

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix deadlock with memory reclaim during scrub

Omar Sandoval <osandov@fb.com>
    Btrfs: clean up scrub is_dev_replace parameter

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Fix race between kvm_unmap_hva_range and MMU mode switch

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Cleanup gt powerstate from gem

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Restore sane defaults for KMS on GEM error load

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vim2m: use cancel_delayed_work_sync instead of flush_schedule_work

Hans Verkuil <hans.verkuil@cisco.com>
    media: vim2m: use workqueue

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: reinit ap queue state machine during device probe

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    ARM: davinci: dm644x: define gpio interrupts as separate resources

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    ARM: davinci: dm355: define gpio interrupts as separate resources

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    ARM: davinci: dm646x: define gpio interrupts as separate resources

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    ARM: davinci: dm365: define gpio interrupts as separate resources

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    ARM: davinci: da8xx: define gpio interrupts as separate resources

Lyude Paul <lyude@redhat.com>
    drm/amd/dm: Understand why attaching path/tile properties are needed

Rex Zhu <Rex.Zhu@amd.com>
    drm/amd/pp: Fix truncated clock value when set watermark

David Francis <David.Francis@amd.com>
    powerplay: Respect units on max dcfclk watermark

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: kvp: Fix the recent regression caused by incorrect clean-up

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: kvp: Fix the indentation of some "break" statements

Lyude Paul <lyude@redhat.com>
    drm/atomic_helper: Disallow new modesets on unregistered connectors

Imre Deak <imre.deak@intel.com>
    drm/i915/gen9+: Fix initial readout for Y tiled framebuffers

Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
    drm/i915: Rename PLANE_CTL_DECOMPRESSION_ENABLE

Lyude Paul <lyude@redhat.com>
    drm/i915: Fix intel_dp_mst_best_encoder()

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/kvm/lapic: preserve gfn_to_hva_cache len on cache reinit

Ladi Prosek <lprosek@redhat.com>
    KVM: hyperv: define VP assist page helpers

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: hyperv: keep track of mismatched VP indexes

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: hyperv: consistently use 'hv_vcpu' for 'struct kvm_vcpu_hv' variables

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: hyperv: enforce vp_index < KVM_MAX_VCPUS

Feifei Xu <Feifei.Xu@amd.com>
    drm/amdgpu: Update gc_9_0 golden settings.

Feifei Xu <Feifei.Xu@amd.com>
    drm/amdgpu/gfx9: Update gfx9 golden settings.

Brian Norris <briannorris@chromium.org>
    remoteproc: qcom: q6v5-mss: add SCM probe dependency

Zhimin Gu <kookoo.gu@intel.com>
    x86, hibernate: Fix nosave_regions setup for hibernation

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: kvp: Fix two "this statement may fall through" warnings

David Howells <dhowells@redhat.com>
    keys: Fix the use of the C++ keyword "private" in uapi/linux/keyctl.h

Giridhar Malavali <giridhar.malavali@cavium.com>
    scsi: qla2xxx: Move log messages before issuing command to firmware

Hans Verkuil <hans.verkuil@cisco.com>
    media: cec: remove cec-edid.c

Hans Verkuil <hans.verkuil@cisco.com>
    media: cec/v4l2: move V4L2 specific CEC functions to V4L2

Jan-Marek Glogowski <glogow@fbihome.de>
    drm/i915: Re-apply "Perform link quality check, unconditionally during long pulse"

YueHaibing <yuehaibing@huawei.com>
    kernel/module: Fix mem leak in module_add_modinfo_attrs

Jessica Yu <jeyu@kernel.org>
    modules: always page-align module section allocations

Brian Norris <briannorris@chromium.org>
    remoteproc: qcom: q6v5: shore up resource probe handling

Nathan Chancellor <natechancellor@gmail.com>
    clk: s2mps11: Add used attribute to s2mps11_dt_match

Hannes Reinecke <hare@suse.de>
    nvme-fc: use separate work queue to avoid warning

David Abdurachmanov <david.abdurachmanov@gmail.com>
    riscv: remove unused variable in ftrace

Nicolas Boichat <drinkcat@chromium.org>
    scripts/decode_stacktrace: match basepath using shell prefix operator, not regex

Dmitry Voytik <voytikd@gmail.com>
    arm64: dts: rockchip: enable usb-host regulators at boot on rk3328-rock64

Fabien Dessenne <fabien.dessenne@st.com>
    media: stm32-dcmi: fix irq = 0 case

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/64: mark start_here_multiplatform as __ref

Steven Rostedt (VMware) <rostedt@goodmis.org>
    x86/ftrace: Fix warning and considate ftrace_jmp_replace() and ftrace_call_replace()

Hangbin Liu <liuhangbin@gmail.com>
    selftests: fib_rule_tests: use pre-defined DEV_ADDR

Jason A. Donenfeld <Jason@zx2c4.com>
    timekeeping: Use proper ktime_add when adding nsecs in coarse offset

Manikanta Pubbisetty <mpubbise@codeaurora.org>
    {nl,mac}80211: fix interface combinations on crypto controlled devices

Dennis Zhou <dennis@kernel.org>
    blk-iolatency: fix STS_AGAIN handling

Liu Bo <bo.liu@linux.alibaba.com>
    Blk-iolatency: warn on negative inflight IO counter

Dexuan Cui <decui@microsoft.com>
    hv_sock: Fix hang when a connection is closed

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only read OGM tvlv_len after buffer len check

Eric Dumazet <edumazet@google.com>
    batman-adv: fix uninit-value in batadv_netlink_get_ifindex()

Gustavo Romero <gromero@linux.ibm.com>
    powerpc/tm: Fix FP/VMX unavailable exceptions inside a transaction

Tiwei Bie <tiwei.bie@intel.com>
    vhost/test: fix build for vhost test - again

Tiwei Bie <tiwei.bie@intel.com>
    vhost/test: fix build for vhost test

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Fix double free in vmw_recv_msg()

Liangyan <liangyan.peng@linux.alibaba.com>
    sched/fair: Don't assign runtime for throttled cfs_rq

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Fix the problem of two front mics on a ThinkCentre

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable internal speaker & headset mic of ASUS UX431FL

Sam Bazley <sambazley@fastmail.com>
    ALSA: hda/realtek - Add quirk for HP Pavilion 15

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix overridden device-specific initialization

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix potential endless loop at applying quirks


-------------

Diffstat:

 .../display/panel/armadeus,st0700-adapt.txt        |   9 ++
 .../bindings/iio/adc/samsung,exynos-adc.txt        |   6 +-
 Documentation/devicetree/bindings/mmc/mmc.txt      |   4 +
 Makefile                                           |   4 +-
 arch/arc/kernel/troubleshoot.c                     |   8 ++
 arch/arc/mm/fault.c                                |  38 ++----
 arch/arm/boot/dts/gemini-dlink-dir-685.dts         |   2 +-
 arch/arm/boot/dts/qcom-ipq4019.dtsi                |   6 +-
 arch/arm/mach-davinci/devices-da8xx.c              |  40 ++++++
 arch/arm/mach-davinci/dm355.c                      |  30 ++++
 arch/arm/mach-davinci/dm365.c                      |  35 +++++
 arch/arm/mach-davinci/dm644x.c                     |  20 +++
 arch/arm/mach-davinci/dm646x.c                     |  10 ++
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |   3 +
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts     |   2 +
 arch/powerpc/include/asm/kvm_book3s.h              |   4 +-
 arch/powerpc/include/asm/kvm_book3s_64.h           |   4 +-
 arch/powerpc/include/asm/kvm_booke.h               |   4 +-
 arch/powerpc/include/asm/kvm_host.h                |   2 -
 arch/powerpc/include/asm/mmu_context.h             |  15 +-
 arch/powerpc/include/asm/reg.h                     |   7 +-
 arch/powerpc/kernel/asm-offsets.c                  |   4 +-
 arch/powerpc/kernel/head_64.S                      |   2 +
 arch/powerpc/kernel/process.c                      |  38 ++----
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   3 +
 arch/powerpc/kvm/book3s_emulate.c                  |  12 +-
 arch/powerpc/kvm/book3s_hv.c                       |  19 ++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  30 ++--
 arch/powerpc/kvm/book3s_hv_tm.c                    |  12 +-
 arch/powerpc/kvm/book3s_hv_tm_builtin.c            |   5 +-
 arch/powerpc/kvm/book3s_pr.c                       |   4 +-
 arch/powerpc/kvm/bookehv_interrupts.S              |   8 +-
 arch/powerpc/kvm/emulate_loadstore.c               |   1 -
 arch/powerpc/mm/hash_utils_64.c                    |   9 ++
 arch/powerpc/mm/pkeys.c                            |  10 ++
 arch/riscv/kernel/ftrace.c                         |   1 -
 arch/x86/include/asm/kvm_host.h                    |  15 +-
 arch/x86/kernel/ftrace.c                           |  42 +++---
 arch/x86/kernel/kvmclock.c                         |   6 +-
 arch/x86/kernel/setup.c                            |   2 +-
 arch/x86/kvm/emulate.c                             |  10 ++
 arch/x86/kvm/hyperv.c                              |  71 ++++++++--
 arch/x86/kvm/hyperv.h                              |   4 +
 arch/x86/kvm/irq.c                                 |   7 +
 arch/x86/kvm/irq.h                                 |   1 +
 arch/x86/kvm/lapic.c                               |  14 +-
 arch/x86/kvm/lapic.h                               |   2 +-
 arch/x86/kvm/mmu.c                                 |  13 +-
 arch/x86/kvm/mmu.h                                 |   2 +-
 arch/x86/kvm/mtrr.c                                |  10 +-
 arch/x86/kvm/svm.c                                 |   2 +
 arch/x86/kvm/vmx.c                                 |  41 +++---
 arch/x86/kvm/x86.c                                 |  26 ++--
 arch/x86/kvm/x86.h                                 |  12 ++
 block/blk-core.c                                   |   3 +-
 block/blk-iolatency.c                              |  55 +++-----
 block/blk-mq-sysfs.c                               |   6 +
 block/blk-mq.c                                     |   8 +-
 block/blk-mq.h                                     |   2 +-
 drivers/char/tpm/st33zp24/i2c.c                    |   2 +-
 drivers/char/tpm/st33zp24/spi.c                    |   2 +-
 drivers/char/tpm/st33zp24/st33zp24.h               |   4 +-
 drivers/char/tpm/tpm_i2c_infineon.c                |  15 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c                 |  16 +--
 drivers/clk/clk-s2mps11.c                          |   2 +-
 drivers/clk/tegra/clk-audio-sync.c                 |   3 +-
 drivers/clk/tegra/clk-tegra-audio.c                |   7 +-
 drivers/clk/tegra/clk-tegra114.c                   |   9 +-
 drivers/clk/tegra/clk-tegra124.c                   |   9 +-
 drivers/clk/tegra/clk-tegra210.c                   |  11 +-
 drivers/clk/tegra/clk-tegra30.c                    |   9 +-
 drivers/clk/tegra/clk.h                            |   4 +-
 drivers/crypto/ccree/cc_driver.c                   |   7 +-
 drivers/crypto/ccree/cc_pm.c                       |  13 +-
 drivers/crypto/ccree/cc_pm.h                       |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   3 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |   5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   3 -
 drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c   |  32 ++---
 drivers/gpu/drm/drm_atomic.c                       |  21 +++
 drivers/gpu/drm/drm_ioc32.c                        |   6 +-
 drivers/gpu/drm/drm_vblank.c                       |  45 +++++-
 drivers/gpu/drm/i915/i915_debugfs.c                |   4 +
 drivers/gpu/drm/i915/i915_gem.c                    |  39 ++++--
 drivers/gpu/drm/i915/i915_reg.h                    |   2 +-
 drivers/gpu/drm/i915/intel_cdclk.c                 |  11 ++
 drivers/gpu/drm/i915/intel_display.c               |  37 +++--
 drivers/gpu/drm/i915/intel_dp.c                    |  16 +++
 drivers/gpu/drm/i915/intel_dp_mst.c                |   2 -
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   3 +-
 drivers/gpu/drm/panel/panel-simple.c               |  29 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |   8 +-
 drivers/hv/hv_kvp.c                                |  32 ++++-
 drivers/i2c/busses/i2c-at91.c                      |  11 +-
 drivers/iio/adc/exynos_adc.c                       |  31 +++++
 drivers/iio/adc/rcar-gyroadc.c                     |   4 +-
 drivers/infiniband/core/uverbs_main.c              |   7 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   9 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   3 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |  24 +++-
 drivers/iommu/iova.c                               |   5 +-
 drivers/md/bcache/btree.c                          |  49 ++++++-
 drivers/md/bcache/btree.h                          |   2 +
 drivers/md/bcache/extents.c                        |  15 +-
 drivers/md/bcache/journal.c                        |   7 +
 drivers/md/dm-crypt.c                              |   5 +-
 drivers/md/dm-mpath.c                              |  17 ++-
 drivers/md/dm-rq.c                                 |   8 +-
 drivers/md/dm-target.c                             |   3 +-
 drivers/md/dm-thin-metadata.c                      |   7 +-
 drivers/media/cec/Makefile                         |   2 +-
 drivers/media/cec/cec-adap.c                       |  13 ++
 drivers/media/cec/cec-edid.c                       |  95 -------------
 drivers/media/i2c/Kconfig                          |   3 +-
 drivers/media/i2c/adv7604.c                        |   4 +-
 drivers/media/i2c/adv7842.c                        |   4 +-
 drivers/media/i2c/tc358743.c                       |   2 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |   2 +-
 drivers/media/platform/vim2m.c                     |  28 ++--
 drivers/media/platform/vivid/vivid-vid-cap.c       |   4 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |   2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          | 151 +++++++++++++++++++++
 drivers/mfd/Kconfig                                |   6 +-
 drivers/mmc/host/renesas_sdhi_core.c               |  11 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   2 +
 drivers/mmc/host/sdhci-pci.h                       |   2 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  65 ++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   9 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  56 ++++----
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c |   2 +-
 drivers/nvme/host/fc.c                             |  15 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |  21 ++-
 drivers/pci/controller/dwc/pcie-qcom.c             |  58 +++++---
 drivers/pci/quirks.c                               | 148 ++++++++++++--------
 drivers/remoteproc/qcom_q6v5.c                     |  44 ++++--
 drivers/remoteproc/qcom_q6v5_pil.c                 |   3 +
 drivers/s390/crypto/ap_bus.c                       |   8 +-
 drivers/s390/crypto/ap_bus.h                       |   1 +
 drivers/s390/crypto/ap_queue.c                     |  15 ++
 drivers/s390/crypto/zcrypt_cex2a.c                 |   1 -
 drivers/s390/crypto/zcrypt_cex4.c                  |   1 -
 drivers/s390/crypto/zcrypt_pcixcc.c                |   1 -
 drivers/s390/scsi/zfcp_fsf.c                       |  10 +-
 drivers/s390/virtio/virtio_ccw.c                   |   3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |  76 +++++++----
 drivers/scsi/qla2xxx/qla_gs.c                      |  15 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  48 +++----
 drivers/spi/spi-gpio.c                             |   3 +-
 drivers/staging/wilc1000/linux_wlan.c              |  12 +-
 drivers/target/target_core_iblock.c                |   6 +-
 drivers/target/target_core_iblock.h                |   1 -
 drivers/usb/typec/tcpm.c                           |  27 +++-
 drivers/vhost/test.c                               |  13 +-
 drivers/vhost/vhost.c                              |  10 +-
 fs/btrfs/compression.c                             |  16 +++
 fs/btrfs/compression.h                             |   1 +
 fs/btrfs/ctree.h                                   |   3 +
 fs/btrfs/extent-tree.c                             |  34 ++---
 fs/btrfs/extent_io.c                               |  20 ++-
 fs/btrfs/extent_io.h                               |   5 -
 fs/btrfs/inode.c                                   |  40 ++++--
 fs/btrfs/props.c                                   |   6 +-
 fs/btrfs/scrub.c                                   | 119 ++++++++++------
 fs/btrfs/volumes.c                                 |  29 ++++
 fs/ceph/inode.c                                    |   7 +-
 fs/ceph/super.c                                    |   2 +-
 fs/ceph/super.h                                    |   2 +-
 fs/cifs/cifs_fs_sb.h                               |   5 +
 fs/cifs/cifsfs.c                                   |   1 +
 fs/cifs/cifsglob.h                                 |  24 ++++
 fs/cifs/cifssmb.c                                  |  24 +++-
 fs/cifs/connect.c                                  |   8 +-
 fs/cifs/file.c                                     |  37 +++--
 fs/cifs/inode.c                                    |  10 ++
 fs/cifs/misc.c                                     |   1 +
 fs/cifs/smb2pdu.c                                  |   1 +
 fs/cifs/smbdirect.c                                |  55 ++++----
 fs/cifs/smbdirect.h                                |   5 +-
 fs/cifs/transport.c                                |   2 +-
 fs/ext4/block_validity.c                           |  54 ++++++++
 fs/ext4/extents.c                                  |  12 +-
 fs/ext4/inode.c                                    |   4 +
 fs/nfs/delegation.c                                |   2 +-
 fs/nfs/delegation.h                                |   2 +-
 fs/nfs/nfs4proc.c                                  |  25 ++--
 fs/pstore/inode.c                                  |  12 +-
 include/drm/drm_device.h                           |   8 +-
 include/drm/drm_vblank.h                           |  22 +++
 include/linux/device-mapper.h                      |   3 +-
 include/linux/gpio/consumer.h                      |  62 ++++-----
 include/media/cec.h                                |  80 -----------
 include/media/v4l2-dv-timings.h                    |   6 +
 include/net/cfg80211.h                             |  15 ++
 include/uapi/linux/keyctl.h                        |   7 +-
 kernel/module.c                                    |  29 ++--
 kernel/resource.c                                  | 110 +++++++--------
 kernel/sched/fair.c                                |   5 +
 kernel/time/timekeeping.c                          |   2 +-
 mm/migrate.c                                       |  17 +--
 net/batman-adv/bat_iv_ogm.c                        |  20 ++-
 net/batman-adv/netlink.c                           |   2 +-
 net/mac80211/util.c                                |   7 +-
 net/vmw_vsock/hyperv_transport.c                   |   8 ++
 net/wireless/core.c                                |   6 +-
 net/wireless/nl80211.c                             |   4 +-
 net/wireless/util.c                                |  27 +++-
 scripts/decode_stacktrace.sh                       |   2 +-
 security/apparmor/policy_unpack.c                  |  40 +++++-
 sound/pci/hda/hda_auto_parser.c                    |   4 +-
 sound/pci/hda/hda_codec.c                          |   8 +-
 sound/pci/hda/hda_codec.h                          |   2 +
 sound/pci/hda/hda_generic.c                        |   3 +-
 sound/pci/hda/hda_generic.h                        |   1 +
 sound/pci/hda/hda_intel.c                          |   6 +-
 sound/pci/hda/patch_hdmi.c                         |   6 +-
 sound/pci/hda/patch_realtek.c                      |  17 +++
 tools/testing/selftests/net/fib_rule_tests.sh      |   5 +-
 virt/kvm/eventfd.c                                 |   9 ++
 222 files changed, 2346 insertions(+), 1170 deletions(-)


