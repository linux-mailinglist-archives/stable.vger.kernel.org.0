Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACE774002
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387951AbfGXTYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfGXTYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:24:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0E90218F0;
        Wed, 24 Jul 2019 19:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996267;
        bh=Caq76ZDgonI0ZMEcz8/SalsWSeBrGkUbRB5nBd/pJQ4=;
        h=From:To:Cc:Subject:Date:From;
        b=rdmG9q99M5Qzdfo0L4PeWHWuAA9Avu7Ql53IVAsi3DBldPRu+4wOLJCWUeHrdxXTM
         Vc5+PI0eS12KMtuTKXjsbF6gwBMW7VpXYpUrLusZBiLb34HiSySDH+CL+gUyrCSymd
         DlDZ+r+/9RYLrqtYK+BYliXfVMrbj2r1HLy4xTtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 000/413] 5.2.3-stable review
Date:   Wed, 24 Jul 2019 21:14:51 +0200
Message-Id: <20190724191735.096702571@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.3-rc1
X-KernelTest-Deadline: 2019-07-26T19:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.3 release.
There are 413 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.3-rc1

Junxiao Bi <junxiao.bi@oracle.com>
    dm bufio: fix deadlock with loop device

Mike Snitzer <snitzer@redhat.com>
    dm thin metadata: check if in fail_io mode when setting needs_check

Bjorn Andersson <bjorn.andersson@linaro.org>
    phy: qcom-qmp: Correct READY_STATUS poll break condition

Norbert Manthey <nmanthey@amazon.de>
    pstore: Fix double-free in pstore_mkfile() failure path

Josua Mayer <josua@solid-run.com>
    dt-bindings: allow up to four clocks for orion-mdio

Josua Mayer <josua@solid-run.com>
    net: mvmdio: allow up to four clocks to be specified for orion-mdio

Tejun Heo <tj@kernel.org>
    blkcg: update blkcg_print_stat() to handle larger outputs

Tejun Heo <tj@kernel.org>
    blk-iolatency: clear use_delay when io.latency is set to zero

Peng Fan <peng.fan@nxp.com>
    clk: imx: imx8mm: correct audio_pll2_clk to audio_pll2_out

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    blk-throttle: fix zero wait time for iops throttled group

Lee, Chiasheng <chiasheng.lee@intel.com>
    usb: Handle USB3 remote wakeup for LPM enabled devices correctly

Matthew Wilcox (Oracle) <willy@infradead.org>
    dax: Fix missed wakeup with PMD faults

Szymon Janc <szymon.janc@codecoup.pl>
    Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: msu: Fix single mode with disabled IOMMU

YueHaibing <yuehaibing@huawei.com>
    intel_th: msu: Remove set but not used variable 'last'

liaoweixiong <liaoweixiong@allwinnertech.com>
    mtd: spinand: read returns badly if the last page has bitflips

Xiaolei Li <xiaolei.li@mediatek.com>
    mtd: rawnand: mtk: Correct low level time calculation of r/w cycle

Dan Carpenter <dan.carpenter@oracle.com>
    eCryptfs: fix a couple type promotion bugs

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    mmc: sdhci-msm: fix mutex while in spinlock

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: Fix oops in hotplug memory notifier

Greg Kurz <groug@kaod.org>
    powerpc/pseries: Fix xive=off command line

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/powernv: Fix stale iommu table base after VFIO

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/powernv/idle: Fix restore of SPRN_LDBAR for POWER9 stop state.

Greg Kurz <groug@kaod.org>
    powerpc/powernv/npu: Fix reference leak

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/watchpoint: Restore NV GPRs while returning from exception

Andreas Schwab <schwab@linux-m68k.org>
    powerpc/mm/32s: fix condition that is always true

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/32s: fix suspend/resume when IBATs 4-7 are used

Helge Deller <deller@gmx.de>
    parisc: Fix kernel panic due invalid values in IAOQ0 or IAOQ1

Helge Deller <deller@gmx.de>
    parisc: Avoid kernel panic triggered by invalid kprobe

Helge Deller <deller@gmx.de>
    parisc: Ensure userspace privilege for ptraced processes in regset functions

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM

Nadav Amit <namit@vmware.com>
    resource: fix locking in find_next_iomem_res()

Drew Davenport <ddavenport@chromium.org>
    include/asm-generic/bug.h: fix "cut here" for WARN_ON for __WARN_TAINT architectures

Jan Harkes <jaharkes@cs.cmu.edu>
    coda: pass the host file in vma->vm_file on mmap

Henry Burns <henryburns@google.com>
    mm/z3fold.c: lock z3fold page before __SetPageMovable()

Yafang Shao <laoar.shao@gmail.com>
    mm/memcontrol: fix wrong statistics in memory.stat

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/pfn: fix fsdax-mode namespace info-block zero-fields

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/nvdimm: add is_ioremap_addr and use that to check ioremap address

Kuo-Hsin Yang <vovoy@chromium.org>
    mm: vmscan: scan anonymous pages on file refaults

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: correct touch resolution x/y typo

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: generic: Correct pad syncing

Aaron Armstrong Skomra <skomra@gmail.com>
    HID: wacom: generic: only switch the mode on devices with LEDs

Danit Goldberg <danitg@mellanox.com>
    IB/mlx5: Report correctly tag matching rendezvous capability

Filipe Manana <fdmanana@suse.com>
    Btrfs: add missing inode version, ctime and mtime updates when punching hole

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix fsync not persisting dentry deletions due to inode evictions

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix data loss after inode eviction, renaming it, and fsync it

Johannes Thumshirn <jthumshirn@suse.de>
    btrfs: correctly validate compression type

Niklas Cassel <niklas.cassel@linaro.org>
    PCI: qcom: Ensure that PERST is asserted for at least 100 ms

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Do not poll for PME if the device is in D3cold

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Fix a use-after-free bug in hv_eject_device_work()

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Ice Lake NNPI support

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/odp: Fix missed unlock in non-blocking invalidate_start

Bart Van Assche <bvanassche@acm.org>
    RDMA/srp: Accept again source addresses that do not have a port number

Damien Le Moal <damien.lemoal@wdc.com>
    block: Fix potential overflow in blk_report_zones()

Damien Le Moal <damien.lemoal@wdc.com>
    block: Allow mapping of vmalloc-ed buffers

Andres Rodriguez <andresx7@gmail.com>
    drm/edid: parse CEA blocks embedded in DisplayID

Eiichi Tsukata <devel@etsukata.com>
    x86/stacktrace: Prevent infinite loop in arch_stack_walk_user()

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/uncore: Do not set 'ThreadMask' and 'SliceMask' for non-L3 PMCs

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix spurious NMI on fixed counter

David Rientjes <rientjes@google.com>
    x86/boot: Fix memory leak in default_get_smp_config()

Dexuan Cui <decui@microsoft.com>
    x86/hyper-v: Zero out the VP ASSIST PAGE on allocation

Soeren Moch <smoch@web.de>
    rt2x00usb: fix rx queue hang

YueHaibing <yuehaibing@huawei.com>
    9p/virtio: Add cleanup path in p9_virtio_init

YueHaibing <yuehaibing@huawei.com>
    9p/xen: Add cleanup path in p9_trans_xen_init

Juergen Gross <jgross@suse.com>
    xen/events: fix binding user event channels to cpus

Damien Le Moal <damien.lemoal@wdc.com>
    dm zoned: fix zone state management race

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: use smp_mb in padata_reorder to avoid orphaned padata jobs

Lyude Paul <lyude@redhat.com>
    drm/nouveau/i2c: Enable i2c pads & busses during preinit

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: gemini: Set DIR-685 SPI CS as active low

Vitor Soares <Vitor.Soares@synopsys.com>
    i3c: fix i2c and i3c scl rate by bus mode

Radoslaw Burny <rburny@google.com>
    fs/proc/proc_sysctl.c: fix the default values of i_uid/i_gid on /proc/sys inodes.

Eric W. Biederman <ebiederm@xmission.com>
    signal: Correct namespace fixups of si_pid and si_uid

Eric W. Biederman <ebiederm@xmission.com>
    signal/usb: Replace kill_pid_info_as_cred with kill_pid_usb_asyncio

Shaokun Zhang <zhangshaokun@hisilicon.com>
    intel_th: msu: Fix unused variable warning on arm64 platform

Julien Thierry <julien.thierry@arm.com>
    arm64: Fix incorrect irqflag restore for priority masking

Julien Thierry <julien.thierry@arm.com>
    arm64: irqflags: Add condition flags to inline asm clobber list

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix AGIC register range

Like Xu <like.xu@linux.intel.com>
    KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Michael Neuling <mikey@neuling.org>
    KVM: PPC: Book3S HV: Fix CR0 setting in TM emulation

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    KVM: PPC: Book3S HV: Clear pending decrementer exceptions on nested guest entry

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    KVM: PPC: Book3S HV: Signed extend decrementer value if not using large decrementer

KarimAllah Ahmed <karahmed@amazon.de>
    KVM: Properly check if "page" is valid in kvm_vcpu_unmap

Wanpeng Li <wanpengli@tencent.com>
    KVM: VMX: check CPUID before allowing read/write of IA32_XSS

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Fix handling of #MC that occurs during VM-Entry

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Don't dump VMCS if virtual APIC page can't be mapped

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: videobuf2-dma-sg: Prevent size from overflowing

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: videobuf2-core: Prevent size alignment wrapping buffer size to 0

Ezequiel Garcia <ezequiel@collabora.com>
    media: coda: Remove unbalanced and unneeded mutex unlock

Boris Brezillon <boris.brezillon@collabora.com>
    media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()

Yan, Zheng <zyan@redhat.com>
    ceph: use ceph_evict_inode to cleanup inode's resource

Luis Henriques <lhenriques@suse.com>
    ceph: fix end offset in truncate_inode_pages_range call

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi - Fix i915 reverse port/pin mapping

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi - Remove duplicated define

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Headphone Mic can't record on Dell platform

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't resume forcibly i915 HDMI/DP codec

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Break too long mutex context in the write loop

Masahiro Yamada <yamada.masahiro@socionext.com>
    kconfig: fix missing choice values in auto.conf

Xiao Ni <xni@redhat.com>
    raid5-cache: Need to do start() part job after adding journal device

Mark Brown <broonie@kernel.org>
    ASoC: core: Adapt for debugfs API change

Mark Brown <broonie@kernel.org>
    ASoC: dapm: Adapt for debugfs API change

Christophe Leroy <christophe.leroy@c-s.fr>
    lib/scatterlist: Fix mapping iterator when sg->offset is greater than PAGE_SIZE

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Ensure the bvecs are reset when we re-encode the RPC request

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs: Fix a problem where we gratuitously start doing I/O through the MDS

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs/flexfiles: Fix PTR_ERR() dereferences in ff_layout_track_ds_error

Max Kellermann <mk@cm4all.com>
    Revert "NFS: readdirplus optimization by cache mechanism" (memleak)

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Handle the special Linux file open access mode

Eiichi Tsukata <devel@etsukata.com>
    tracing: Fix user stack trace "??" output

Julien Thierry <julien.thierry@arm.com>
    arm64: Fix interrupt tracing in the presence of NMIs

Dmitry Osipenko <digetx@gmail.com>
    opp: Don't use IS_ERR on invalid supplies

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: clear rfkill_safe_init_done when we start the firmware

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: delay GTK setting in FW in AP mode

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: fix RF-Kill interrupt while FW load for gen2 devices

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: don't WARN when calling iwl_get_shared_mem_conf with RF-Kill

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: fix ALIVE interrupt handling for gen2 devices w/o MSI-X

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: don't service an interrupt that was masked

Oren Givon <oren.givon@intel.com>
    iwlwifi: add support for hr1 RF ID

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix Jetson Nano GPU regulator

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Update Jetson TX1 GPU regulator timings

Krzysztof Kozlowski <krzk@kernel.org>
    regulator: s2mps11: Fix buck7 and buck8 wrong voltages

Krzysztof Kozlowski <krzk@kernel.org>
    regulator: s2mps11: Fix ERR_PTR dereference on GPIO lookup failure

Hui Wang <hui.wang@canonical.com>
    Input: alps - fix a mismatch between a condition check and its comment

Nick Black <dankamongmen@gmail.com>
    Input: synaptics - whitelist Lenovo T580 SMBus intertouch

Hui Wang <hui.wang@canonical.com>
    Input: alps - don't handle ALPS cs19 trackpoint-only device

Grant Hernandez <granthernandez@google.com>
    Input: gtco - bounds check collection indent level

Coly Li <colyli@suse.de>
    bcache: destroy dc->writeback_write_wq if failed to create dc->writeback_thread

Coly Li <colyli@suse.de>
    bcache: fix mistaken sysfs entry for io_error counter

Coly Li <colyli@suse.de>
    bcache: ignore read-ahead request failure on backing device

Coly Li <colyli@suse.de>
    bcache: Revert "bcache: free heap cache_set->flush_btree in bch_journal_free"

Coly Li <colyli@suse.de>
    bcache: Revert "bcache: fix high CPU occupancy during journal"

Coly Li <colyli@suse.de>
    Revert "bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()"

Aurelien Aptel <aaptel@suse.com>
    CIFS: fix deadlock in cached root handling

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: flush before set-info if we have writeable handles

Paulo Alcantara (SUSE) <paulo@paulo.ac>
    cifs: Properly handle auto disabling of serverino option

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix crash in smb2_compound_op()/smb2_set_next_command()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: always add credits back for unsolicited PDUs

Wen Yang <wen.yang99@zte.com.cn>
    crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe

Cfir Cohen <cfir@google.com>
    crypto: ccp/gcm - use const time tag comparison.

Hook, Gary <Gary.Hook@amd.com>
    crypto: ccp - memset structure fields to zero before reuse

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - block ciphers should only accept complete blocks

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix blocksize for cfb and ofb

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix AES CTR blocksize value

Eric Biggers <ebiggers@google.com>
    crypto: chacha20poly1305 - fix atomic sleep when using async algorithm

Elena Petrova <lenaptr@google.com>
    crypto: arm64/sha2-ce - correct digest for empty data in finup

Elena Petrova <lenaptr@google.com>
    crypto: arm64/sha1-ce - correct digest for empty data in finup

Hook, Gary <Gary.Hook@amd.com>
    crypto: ccp - Validate the the error value used to index error messages

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: caam - limit output IV to CBC to work around CTR mode DMA issue

Eric Biggers <ebiggers@google.com>
    crypto: ghash - fix unaligned memory access in ghash_setkey()

Finn Thain <fthain@telegraphics.com.au>
    scsi: mac_scsi: Fix pseudo DMA implementation, take 2

Finn Thain <fthain@telegraphics.com.au>
    scsi: mac_scsi: Increase PIO/PDMA transfer length threshold

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: megaraid_sas: Fix calculation of target ID

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: fix request object use-after-free in send path causing wrong traces

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: fix request object use-after-free in send path causing seqno errors

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: sd_zbc: Fix compilation warning

Ming Lei <ming.lei@redhat.com>
    scsi: core: Fix race on creating sense cache

Finn Thain <fthain@telegraphics.com.au>
    Revert "scsi: ncr5380: Increase register polling limit"

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Handle PDMA failure reliably

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Always re-enable reselection interrupt

Juergen Gross <jgross@suse.com>
    xen: let alloc_xenballooned_pages() fail if not enough memory free

Denis Efremov <efremov@ispras.ru>
    floppy: fix out-of-bounds read in copy_buffer

Denis Efremov <efremov@ispras.ru>
    floppy: fix invalid pointer dereference in drive_name

Denis Efremov <efremov@ispras.ru>
    floppy: fix out-of-bounds read in next_valid_format

Denis Efremov <efremov@ispras.ru>
    floppy: fix div-by-zero in setup_format_params

Andrii Nakryiko <andriin@fb.com>
    libbpf: fix another GCC8 warning for strncpy

Dennis Zhou <dennis@kernel.org>
    blk-iolatency: fix STS_AGAIN handling

Colin Ian King <colin.king@canonical.com>
    iavf: fix dereference of null rx_buffer pointer

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: fix __QUEUE_STATE_STACK_XOFF not cleared issue

Josua Mayer <josua@solid-run.com>
    net: mvmdio: defer probe of orion-mdio if a clock is not ready

Ilya Maximets <i.maximets@samsung.com>
    xdp: fix race on generic receive path

Taehee Yoo <ap420073@gmail.com>
    gtp: fix use-after-free in gtp_newlink()

Taehee Yoo <ap420073@gmail.com>
    gtp: fix use-after-free in gtp_encap_destroy()

Taehee Yoo <ap420073@gmail.com>
    gtp: fix Illegal context switch in RCU read-side critical section.

Taehee Yoo <ap420073@gmail.com>
    gtp: fix suspicious RCU usage

csonsino <csonsino@gmail.com>
    Bluetooth: validate BLE connection interval updates

Taehee Yoo <ap420073@gmail.com>
    gtp: add missing gtp_encap_disable_sock() in gtp_encap_enable()

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: hidp: NUL terminate a string in the compat ioctl

Matias Karhumaa <matias.karhumaa@gmail.com>
    Bluetooth: Check state in l2cap_disconnect_rsp

Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>
    perf tests: Fix record+probe_libc_inet_pton.sh for powerpc64

Shijith Thotton <sthotton@marvell.com>
    genirq: Update irq stats from NMI handlers

Josua Mayer <josua.mayer@jm0.eu>
    Bluetooth: 6lowpan: search for destination address in all peers

João Paulo Rechi Vita <jprvita@gmail.com>
    Bluetooth: Add new 13d3:3501 QCA_ROME device

João Paulo Rechi Vita <jprvita@gmail.com>
    Bluetooth: Add new 13d3:3491 QCA_ROME device

Tomas Bortoli <tomasbortoli@gmail.com>
    Bluetooth: hci_bcsp: Fix memory leak in rx_skb

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix port capbility updating issue

Jian Shen <shenjian15@huawei.com>
    net: hns3: enable broadcast promisc mode when initializing VF

Jiri Olsa <jolsa@redhat.com>
    tools: bpftool: Fix json dump crash on powerpc

Wen Yang <wen.yang99@zte.com.cn>
    ASoC: audio-graph-card: fix use-after-free in graph_for_each_link

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    iommu/arm-smmu-v3: Invalidate ATC when detaching a device

Geert Uytterhoeven <geert+renesas@glider.be>
    gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants

Cong Wang <xiyou.wangcong@gmail.com>
    bonding: validate ip header before check IPPROTO_IGMP

Jiri Benc <jbenc@redhat.com>
    selftests: bpf: fix inlines in test_lwt_seg6local

Leo Yan <leo.yan@linaro.org>
    bpf, libbpf, smatch: Fix potential NULL pointer dereference

Andrii Nakryiko <andriin@fb.com>
    libbpf: fix GCC8 warning for strncpy

David Howells <dhowells@redhat.com>
    rxrpc: Fix oops in tracepoint

Phong Tran <tranmanphong@gmail.com>
    net: usb: asix: init MAC address buffers

Guilherme G. Piccoli <gpiccoli@canonical.com>
    bnx2x: Prevent ptp_task to be rescheduled indefinitely

Taehee Yoo <ap420073@gmail.com>
    vxlan: do not destroy fdb if register_netdevice() is failed

Andi Kleen <ak@linux.intel.com>
    perf stat: Fix group lookup for metric group

Andi Kleen <ak@linux.intel.com>
    perf stat: Don't merge events in the same PMU

Andi Kleen <ak@linux.intel.com>
    perf stat: Fix metrics with --no-merge

Andi Kleen <ak@linux.intel.com>
    perf stat: Make metric event lookup more robust

Rander Wang <rander.wang@linux.intel.com>
    ALSA: hda: Fix a headphone detection issue when using SOF

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Cap the returned MSIX vectors to the RDMA driver.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix statistics context reservation logic for RDMA driver.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Disable bus master during PCI shutdown and driver unload.

Shahar S Matityahu <shahar.s.matityahu@intel.com>
    iwlwifi: dbg: fix debug monitor stop and restart delays

He Zhe <zhe.he@windriver.com>
    netfilter: Fix remainder of pseudo-header protocol 0

Baruch Siach <baruch@tkos.co.il>
    bpf: fix uapi bpf_prog_info fields alignment

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    iwlwifi: mvm: Drop large non sta frames

Dann Frazier <dann.frazier@canonical.com>
    ixgbe: Avoid NULL pointer dereference with VF on non-IPsec hw

Marek Vasut <marex@denx.de>
    net: ethernet: ti: cpsw: Assign OF node to slave devices

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: add Asym Pause support to fix autoneg problem

Vedang Patel <vedang.patel@intel.com>
    igb: clear out skb->tstamp after reading the txtime

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvpp2: prs: Don't override the sign bit in SRAM parser shift

Wen Gong <wgong@codeaurora.org>
    ath10k: destroy sdio workqueue while remove sdio module

Dundi Raviteja <dundi@codeaurora.org>
    ath10k: Fix memory leak in qmi

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: add some error checking in hclge_tm module

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix a -Wformat-nonliteral compile warning

Coly Li <colyli@suse.de>
    bcache: fix potential deadlock in cached_def_free()

Coly Li <colyli@suse.de>
    bcache: avoid a deadlock in bcache_reboot()

Coly Li <colyli@suse.de>
    bcache: check c->gc_thread by IS_ERR_OR_NULL in cache_set_flush()

Coly Li <colyli@suse.de>
    bcache: acquire bch_register_lock later in cached_dev_free()

Coly Li <colyli@suse.de>
    bcache: check CACHE_SET_IO_DISABLE bit in bch_journal()

Coly Li <colyli@suse.de>
    bcache: check CACHE_SET_IO_DISABLE in allocator code

Coly Li <colyli@suse.de>
    bcache: fix return value error in bch_journal_read()

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Attach/detach XDP program safely

Eiichi Tsukata <devel@etsukata.com>
    EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec

Ahmad Masri <amasri@codeaurora.org>
    wil6210: drop old event after wmi_call timeout

Zefir Kurtisi <zefir.kurtisi@neratec.com>
    ath9k: correctly handle short radar pulses

Arnd Bergmann <arnd@arndb.de>
    crypto: asymmetric_keys - select CRYPTO_HASH where needed

Arnd Bergmann <arnd@arndb.de>
    crypto: serpent - mark __serpent_setkey_sbox noinline

Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
    ixgbe: Check DDM existence in transceiver before access

Jianbo Liu <jianbol@mellanox.com>
    net/mlx5: Get vport ACL namespace by vport index

Jian Shen <shenjian15@huawei.com>
    net: hns3: restore the MAC autoneg state after reset

Waibel Georg <Georg.Waibel@sensor-technik.de>
    gpio: Fix return value mismatch of function gpiod_get_from_of_node()

Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>
    rslib: Fix handling of of caller provided syndrome

Jiong Wang <jiong.wang@netronome.com>
    bpf: fix BPF_ALU32 | BPF_ARSH on BE arches

Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>
    rslib: Fix decoding of shortened codes

Nathan Chancellor <natechancellor@gmail.com>
    xsk: Properly terminate assignment in xskq_produce_flush_desc

Felix Kaechele <felix@kaechele.ca>
    netfilter: ctnetlink: Fix regression in conntrack entry deletion

Marek Szyprowski <m.szyprowski@samsung.com>
    clocksource/drivers/exynos_mct: Increase priority over ARM arch timer

Dmitry Osipenko <digetx@gmail.com>
    clocksource/drivers/tegra: Restore base address before cleanup

Tejun Heo <tj@kernel.org>
    libata: don't request sense data on !ZAC ATA devices

Dmitry Osipenko <digetx@gmail.com>
    clocksource/drivers/tegra: Release all IRQ's on request_irq() error

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: fix rq_in_driver check in bfq_update_inject_limit

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: hdac_hdmi: Set ops to NULL on remove

Kyle Meyer <kyle.meyer@hpe.com>
    perf tools: Increase MAX_NR_CPUS and MAX_CACHES

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: hdac: Fix codec name after machine driver is unloaded and reloaded

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix PCIE device wake up failed

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix fw crash by moving chip reset after napi disabled

Claire Chang <tientzu@chromium.org>
    ath10k: add missing error handling

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: do not process rx packets if the device is not initialized

Julian Anastasov <ja@ssi.bg>
    ipvs: fix tinfo memory leak in start_sync_thread

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix possible memory leak when the device is disconnected

Masahiro Yamada <yamada.masahiro@socionext.com>
    x86/build: Add 'set -e' to mkcapflags.sh to delete broken capflags.c

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: do not schedule rx_tasklet when the device has been disconnected

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: rtl8192cu: fix error handle when usb probe failed

Icenowy Zheng <icenowy@aosc.io>
    net: stmmac: sun8i: force select external PHY when no internal one

Hans Verkuil <hverkuil@xs4all.nl>
    media: hdpvr: fix locking and a missing msleep

André Almeida <andrealmeid@collabora.com>
    media: vimc: cap: check v4l2_fill_pixfmt return value

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: increment sequence offset for the last returned frame

Marco Felsch <m.felsch@pengutronix.de>
    media: coda: fix last buffer handling in V4L2_ENC_CMD_STOP

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: fix mpeg2 sequence number handling

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    acpi/arm64: ignore 5.1 FADTs that are reported as 5.0

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-core: call snd_soc_unbind_card() under mutex_lock;

Robert Jarzmik <robert.jarzmik@free.fr>
    media: mt9m111: fix fw-node refactoring

Nathan Huckleberry <nhuck@google.com>
    timer_list: Guard procfs specific code

Miroslav Lichvar <mlichvar@redhat.com>
    ntp: Limit TAI-UTC offset

Anders Roxell <anders.roxell@linaro.org>
    media: i2c: fix warning same module names

Marek Szyprowski <m.szyprowski@samsung.com>
    media: s5p-mfc: Make additional clocks optional

Julian Anastasov <ja@ssi.bg>
    ipvs: defer hook registration to avoid leaks

Colin Ian King <colin.king@canonical.com>
    media: staging: davinci: fix memory leaks and check for allocation failure

Arnd Bergmann <arnd@arndb.de>
    ipsec: select crypto ciphers for xfrm_algo

Julien Thierry <julien.thierry@arm.com>
    arm64: Do not enable IRQs for ct_user_exit

Minwoo Im <minwoo.im.dev@gmail.com>
    nvme-pci: adjust irq max_vector using num_possible_cpus()

Geert Uytterhoeven <geert@linux-m68k.org>
    lightnvm: fix uninitialized pointer in nvm_remove_tgt()

Heiner Litz <hlitz@ucsc.edu>
    lightnvm: pblk: fix freeing of merged pages

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme-pci: set the errno on ctrl state change error

Minwoo Im <minwoo.im.dev@gmail.com>
    nvme-pci: properly report state change failure in nvme_reset_work

Anton Eidelman <anton@lightbitslabs.com>
    nvme: fix possible io failures when removing multipathed ns

Pan Bian <bianpan2016@163.com>
    EDAC/sysfs: Fix memory leak when creating a csrow object

Greg KH <gregkh@linuxfoundation.org>
    EDAC/sysfs: Drop device references properly

Tudor Ambarus <tudor.ambarus@microchip.com>
    spi: fix ctrl->num_chipselect constraint

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Clear status of GPEs on first direct enable

Dennis Zhou <dennis@kernel.org>
    blk-iolatency: only account submitted bios

Qian Cai <cai@lca.pw>
    x86/cacheinfo: Fix a -Wtype-limits warning

Ilias Apalodimas <ilias.apalodimas@linaro.org>
    net: netsec: initialize tx ring on ndo_open

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: Add missing link delays required by the PCIe spec

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Handle slang being in /usr/include and in /usr/include/slang/

Alexei Starovoitov <ast@kernel.org>
    bpf: fix callees pruning callers

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Fix the zstd test in the test-all.c common case feature test

Nilkanth Ahirrao <anilkanth@jp.adit-jv.com>
    ASoC: rsnd: fixup mod ID calculation in rsnd_ctu_probe_

Denis Kirjanov <kda@linux-powerpc.org>
    ipoib: correcly show a VF hardware address

Mitch Williams <mitch.a.williams@intel.com>
    iavf: allow null RX descriptors

Jason Wang <jasowang@redhat.com>
    vhost_net: disable zerocopy by default

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf evsel: Make perf_evsel__name() accept a NULL argument

Peter Zijlstra <peterz@infradead.org>
    x86/atomic: Fix smp_mb__{before,after}_atomic()

Geert Uytterhoeven <geert@linux-m68k.org>
    integrity: Fix __integrity_init_keyring() section mismatch

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Handle invalid event coding for free-running counter

Jiri Olsa <jolsa@redhat.com>
    perf/x86/intel: Disable check_msr for real HW

Qian Cai <cai@lca.pw>
    sched/fair: Fix "runnable_avg_yN_inv" not used warnings

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add more Icelake CPUIDs

Gao Xiang <gaoxiang25@huawei.com>
    sched/core: Add __sched tag for io_schedule()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: fix sa selector validation

Tejun Heo <tj@kernel.org>
    blkcg, writeback: dead memcgs shouldn't contribute to writeback ownership arbitration

Bob Liu <bob.liu@oracle.com>
    block: null_blk: fix race condition for null_del_dev

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: delay ring buffer clearing during reset

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix for skb leak when doing selftest

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix for dereferencing before null checking

Michal Kalderon <michal.kalderon@marvell.com>
    qed: iWARP - Fix tc for MPA ll2 connection

Aaron Lewis <aaronlewis@google.com>
    x86/cpufeatures: Add FDP_EXCPTN_ONLY and ZERO_FCS_FDS

Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
    perf/x86: Add Intel Ice Lake NNPI uncore support

Waiman Long <longman@redhat.com>
    rcu: Force inlining of rcu_read_lock()

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm: fix sample clock inversion

Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
    x86/cpu: Add Ice Lake NNPI to Intel family

Eric Biggers <ebiggers@google.com>
    crypto: testmgr - add some more preemption points

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix empty write to keycreate file

Marek Szyprowski <m.szyprowski@samsung.com>
    media: s5p-mfc: fix reading min scratch buffer size on MFC v6/v7

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    bpf: silence warning messages in core

Young Xiao <92siuyang@gmail.com>
    media: davinci: vpif_capture: fix memory leak in vpif_probe()

Tony Lindgren <tony@atomide.com>
    gpio: omap: Fix lost edge wake-up interrupts

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    regmap: fix bulk writes on paged registers

Russell King <rmk+kernel@armlinux.org.uk>
    gpio: omap: ensure irq is enabled before wakeup

Russell King <rmk+kernel@armlinux.org.uk>
    gpio: omap: fix lack of irqstatus_raw0 for OMAP4

Eric Auger <eric.auger@redhat.com>
    iommu: Fix a leak in iommu_insert_resv_region

Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
    media: fdp1: Support M3N and E3 platforms

Oliver Neukum <oneukum@suse.com>
    media: uvcvideo: Fix access to uninitialized fields on probe error

Xingyu Chen <xingyu.chen@amlogic.com>
    irqchip/meson-gpio: Add support for Meson-G12A SoC

Hechao Li <hechaol@fb.com>
    selftests/bpf : clean up feature/ when make clean

Thomas Richter <tmricht@linux.ibm.com>
    perf report: Fix OOM error in TUI mode on s390

Thomas Richter <tmricht@linux.ibm.com>
    perf test 6: Fix missing kvm module load for s390

Mathieu Poirier <mathieu.poirier@linaro.org>
    perf cs-etm: Properly set the value of 'old' and 'head' in snapshot mode

Stefano Brivio <sbrivio@redhat.com>
    ipset: Fix memory accounting for hash types on resize

Aditya Pakki <pakki001@umn.edu>
    netfilter: ipset: fix a missing check of nla_parse

Robert Hancock <hancock@sedsystems.ca>
    net: sfp: add mutex to prevent concurrent state checks

Borislav Petkov <bp@suse.de>
    RAS/CEC: Fix pfn insertion

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: handle PENDING state for QEBSM devices

Robert Hancock <hancock@sedsystems.ca>
    net: axienet: Fix race condition causing TX hang

Fabio Estevam <festevam@gmail.com>
    net: fec: Do not use netdev messages too early

Antoine Tenart <antoine.tenart@bootlin.com>
    crypto: inside-secure - do not rely on the hardware last bit for result descriptors

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: modify default value of tx-frames

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: dwmac4: fix flow control issue

Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
    media: aspeed: fix a kernel warning on clk control

Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
    media: aspeed: change irq to threaded irq

Jiri Olsa <jolsa@redhat.com>
    perf jvmti: Address gcc string overflow warning for strncpy()

Fabio Estevam <festevam@gmail.com>
    media: imx7-mipi-csis: Propagate the error if clock enabling fails

Miles Chen <miles.chen@mediatek.com>
    arm64: mm: make CONFIG_ZONE_DMA32 configurable

Abhishek Goel <huntbag@linux.vnet.ibm.com>
    cpupower : frequency-set -r option misses the last cpu in related cpu list

Weihang Li <liweihang@hisilicon.com>
    net: hns3: set ops to null when unregister ad_dev

Weihang Li <liweihang@hisilicon.com>
    net: hns3: add a check to pointer in error_detected and slot_reset

Kefeng Wang <wangkefeng.wang@huawei.com>
    media: wl128x: Fix some error handling in fm_v4l2_init_video_device()

Neil Armstrong <narmstrong@baylibre.com>
    media: platform: ao-cec-g12a: disable regmap fast_io for cec bus regmap

Imre Deak <imre.deak@intel.com>
    locking/lockdep: Fix merging of hlocks with non-zero references

Imre Deak <imre.deak@intel.com>
    locking/lockdep: Fix OOO unlock when hlocks need merging

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix duplicated OGMs on NETDEV_UP

David S. Miller <davem@davemloft.net>
    tua6100: Avoid build warnings.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - Align SEC1 accesses to 32 bits boundaries.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - properly handle split ICV.

Vladimir Oltean <olteanv@gmail.com>
    net: dsa: sja1105: Fix broken fixed-link interfaces on user ports

Ioana Ciornei <ioana.ciornei@nxp.com>
    net: phy: Check against net_device being NULL

Shailendra Verma <shailendra.v@samsung.com>
    media: staging: media: davinci_vpfe: - Fix for memory leak if decoder initialization fails.

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof-rt5682: fix undefined references with Baytrail-only support

Kefeng Wang <wangkefeng.wang@huawei.com>
    media: saa7164: fix remove_proc_entry warning

Hans Verkuil <hverkuil@xs4all.nl>
    media: mc-device.c: don't memset __user pointer contents

Mitch Williams <mitch.a.williams@intel.com>
    ice: Check all VFs for MDD activity, don't disable

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate TUI browser: Do not use member from variable within its own initialization

Vandana BN <bnvandana@gmail.com>
    media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_querycap

Eric Biggers <ebiggers@google.com>
    fscrypt: clean up some BUG_ON()s in block encryption/decryption

sumitg <sumitg@nvidia.com>
    media: v4l2-core: fix use-after-free error

Kefeng Wang <wangkefeng.wang@huawei.com>
    media: vim2m: fix two double-free issues

Anirudh Gupta <anirudhrudr@gmail.com>
    xfrm: Fix xfrm sel prefix length validation

Jeremy Sowden <jeremy@azazel.net>
    af_key: fix leaks in key_pol_get_resp and dump_sp.

Eric W. Biederman <ebiederm@xmission.com>
    signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig

Eric W. Biederman <ebiederm@xmission.com>
    signal/pid_namespace: Fix reboot_pid_ns to use send_sig not force_sig

Michal Kalderon <michal.kalderon@marvell.com>
    qed: Set the doorbell address correctly

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix for FEC configuration

Jian Shen <shenjian15@huawei.com>
    net: hns3: initialize CPU reverse mapping

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvpp2: cls: Extract the RSS context when parsing the ethtool rule

Brett Creeley <brett.creeley@intel.com>
    ice: Fix couple of issues in ice_vsi_release

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Prevent missing interrupts when running NAPI

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: dwmac4/5: Clear unused address entries

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: dwmac1000: Clear unused address entries

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - avoid S/G table fetching for AEAD zero-length output

Wen Yang <wen.yang99@zte.com.cn>
    media: venus: firmware: fix leaked of_node references

Brett Creeley <brett.creeley@intel.com>
    ice: Gracefully handle reset failure in ice_alloc_vfs()

Jungo Lin <jungo.lin@mediatek.com>
    media: media_device_enum_links32: clean a reserved field

Kangjie Lu <kjlu@umn.edu>
    media: vpss: fix a potential NULL pointer dereference

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: adjust verifier scale test

Lubomir Rintel <lkundrak@v3.sk>
    media: marvell-ccic: fix DMA s/g desc number calculation

Akinobu Mita <akinobu.mita@gmail.com>
    media: ov7740: avoid invalid framesize setting

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix skcipher failure due to wrong output IV

Daniel Gomez <dagmcr@gmail.com>
    media: spi: IR LED: add missing of table registration

Oliver Neukum <oneukum@suse.com>
    media: dvb: usb: fix use after free in dvb_usb_device_exit

Jeremy Sowden <jeremy@azazel.net>
    batman-adv: fix for leaked TVLV handler.

Daniel Baluta <daniel.baluta@nxp.com>
    regmap: debugfs: Fix memory leak in regmap_debugfs_init

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Fix encoding for protected management frames

Anilkumar Kolli <akolli@codeaurora.org>
    ath: DFS JP domain W56 fixed pulse type 3 RADAR detection

Maya Erez <merez@codeaurora.org>
    wil6210: fix spurious interrupts in 3-msi

Wen Gong <wgong@codeaurora.org>
    ath10k: add peer id check in ath10k_peer_find_by_id

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: add some bounds checking

Maya Erez <merez@codeaurora.org>
    wil6210: fix missed MISC mbox interrupt

Surabhi Vishnoi <svishnoi@codeaurora.org>
    ath10k: Fix the wrong value of enums for wmi tlv stats id

Tim Schumacher <timschumi@gmx.de>
    ath9k: Check for errors when reading SREV register

Emil Renner Berthing <kernel@esmil.dk>
    spi: rockchip: turn down tx dma bursts

Surabhi Vishnoi <svishnoi@codeaurora.org>
    ath10k: Do not send probe response template for mesh

Gustavo A. R. Silva <gustavo@embeddedor.com>
    wil6210: fix potential out-of-bounds read

Toke Høiland-Jørgensen <toke@redhat.com>
    ath9k: Don't trust TX status TID number when reporting airtime

Pradeep kumar Chitrapu <pradeepc@codeaurora.org>
    ath10k: fix incorrect multicast/broadcast rate setting

Alagu Sankar <alagusankar@silex-india.com>
    ath10k: htt: don't use txdone_fifo with SDIO

Yingying Tang <yintang@codeaurora.org>
    ath10k: Check tx_stats before use it


-------------

Diffstat:

 Documentation/atomic_t.txt                         |   3 +
 .../devicetree/bindings/net/marvell-orion-mdio.txt |   2 +-
 Documentation/scheduler/sched-pelt.c               |   3 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/gemini-dlink-dir-685.dts         |   2 +-
 arch/arm64/Kconfig                                 |   3 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   3 +-
 arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts |  17 +-
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           |   2 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   2 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |   2 +-
 arch/arm64/include/asm/arch_gicv3.h                |   4 +-
 arch/arm64/include/asm/daifflags.h                 |  68 ++--
 arch/arm64/include/asm/irqflags.h                  |  65 ++--
 arch/arm64/include/asm/kvm_host.h                  |   7 +-
 arch/arm64/include/asm/ptrace.h                    |  10 +-
 arch/arm64/kernel/acpi.c                           |  10 +-
 arch/arm64/kernel/entry.S                          |  84 ++++-
 arch/arm64/kernel/irq.c                            |  17 +
 arch/arm64/kernel/process.c                        |   2 +-
 arch/arm64/kernel/smp.c                            |   8 +-
 arch/arm64/kvm/hyp/switch.c                        |   2 +-
 arch/arm64/mm/init.c                               |   5 +-
 arch/parisc/kernel/kprobes.c                       |   3 +
 arch/parisc/kernel/ptrace.c                        |  31 +-
 arch/powerpc/include/asm/pgtable.h                 |  14 +
 arch/powerpc/kernel/exceptions-64s.S               |   9 +-
 arch/powerpc/kernel/prom_init.c                    |  16 +-
 arch/powerpc/kernel/swsusp_32.S                    |  73 +++-
 arch/powerpc/kvm/book3s_hv.c                       |  13 +-
 arch/powerpc/kvm/book3s_hv_tm.c                    |   6 +-
 arch/powerpc/mm/pgtable_32.c                       |   2 +-
 arch/powerpc/platforms/powermac/sleep.S            |  68 +++-
 arch/powerpc/platforms/powernv/idle.c              |   2 +-
 arch/powerpc/platforms/powernv/npu-dma.c           |  15 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  10 +
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   3 +
 arch/powerpc/sysdev/xive/spapr.c                   |  52 ++-
 arch/x86/events/amd/uncore.c                       |  15 +-
 arch/x86/events/intel/core.c                       |  29 +-
 arch/x86/events/intel/uncore.c                     |   1 +
 arch/x86/events/intel/uncore.h                     |  10 +
 arch/x86/events/intel/uncore_snbep.c               |   1 +
 arch/x86/hyperv/hv_init.c                          |  13 +-
 arch/x86/include/asm/atomic.h                      |   8 +-
 arch/x86/include/asm/atomic64_64.h                 |   8 +-
 arch/x86/include/asm/barrier.h                     |   4 +-
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/intel-family.h                |   1 +
 arch/x86/kernel/cpu/cacheinfo.c                    |   3 +-
 arch/x86/kernel/cpu/mkcapflags.sh                  |   2 +
 arch/x86/kernel/mpparse.c                          |  10 +-
 arch/x86/kernel/stacktrace.c                       |   8 +-
 arch/x86/kvm/pmu.c                                 |   4 +-
 arch/x86/kvm/vmx/nested.c                          |  16 +-
 arch/x86/kvm/vmx/vmx.c                             |  35 +-
 block/bfq-iosched.c                                |   8 +-
 block/bio.c                                        |  28 +-
 block/blk-cgroup.c                                 |   8 +-
 block/blk-iolatency.c                              |  51 +--
 block/blk-throttle.c                               |   9 +-
 block/blk-zoned.c                                  |   2 +-
 crypto/asymmetric_keys/Kconfig                     |   3 +
 crypto/chacha20poly1305.c                          |  30 +-
 crypto/ghash-generic.c                             |   8 +-
 crypto/serpent_generic.c                           |   8 +-
 crypto/testmgr.c                                   |   6 +
 drivers/acpi/acpica/acevents.h                     |   3 +-
 drivers/acpi/acpica/evgpe.c                        |   8 +-
 drivers/acpi/acpica/evgpeblk.c                     |   2 +-
 drivers/acpi/acpica/evxface.c                      |   2 +-
 drivers/acpi/acpica/evxfgpe.c                      |   2 +-
 drivers/ata/libata-eh.c                            |   8 +-
 drivers/base/regmap/regmap-debugfs.c               |   2 +
 drivers/base/regmap/regmap.c                       |   2 +
 drivers/block/floppy.c                             |  34 +-
 drivers/block/null_blk_main.c                      |  11 +-
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/bluetooth/hci_bcsp.c                       |   5 +
 drivers/clk/imx/clk-imx8mm.c                       |   6 +-
 drivers/clocksource/exynos_mct.c                   |   4 +-
 drivers/clocksource/timer-tegra20.c                |   7 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |  36 +-
 drivers/crypto/amcc/crypto4xx_core.c               |  24 +-
 drivers/crypto/amcc/crypto4xx_core.h               |  10 +-
 drivers/crypto/amcc/crypto4xx_trng.c               |   1 -
 drivers/crypto/caam/caamalg.c                      |  10 +-
 drivers/crypto/caam/caamalg_qi.c                   |   2 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   9 +
 drivers/crypto/caam/qi.c                           |   3 +
 drivers/crypto/ccp/ccp-dev.c                       |  96 +++---
 drivers/crypto/ccp/ccp-dev.h                       |   2 +-
 drivers/crypto/ccp/ccp-ops.c                       |  15 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |  24 +-
 drivers/crypto/talitos.c                           |  35 +-
 drivers/edac/edac_mc_sysfs.c                       |  34 +-
 drivers/edac/edac_module.h                         |   2 +-
 drivers/gpio/gpio-omap.c                           |  29 +-
 drivers/gpio/gpiolib.c                             |  13 +-
 drivers/gpu/drm/drm_edid.c                         |  81 ++++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c     |  20 ++
 drivers/gpu/ipu-v3/ipu-ic.c                        |   2 +-
 drivers/hid/wacom_sys.c                            |   3 +
 drivers/hid/wacom_wac.c                            |  19 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/hwtracing/intel_th/msu.c                   |  45 ++-
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/i3c/master.c                               |  51 ++-
 drivers/infiniband/core/umem_odp.c                 |  14 +-
 drivers/infiniband/hw/mlx5/main.c                  |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   1 +
 drivers/infiniband/ulp/srp/ib_srp.c                |  21 +-
 drivers/input/mouse/alps.c                         |  32 ++
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/tablet/gtco.c                        |  20 +-
 drivers/iommu/arm-smmu-v3.c                        |   5 +-
 drivers/iommu/iommu.c                              |   8 +-
 drivers/irqchip/irq-gic-v3.c                       |   7 +
 drivers/irqchip/irq-meson-gpio.c                   |   1 +
 drivers/lightnvm/core.c                            |   2 +-
 drivers/lightnvm/pblk-core.c                       |  18 +-
 drivers/md/bcache/alloc.c                          |   9 +
 drivers/md/bcache/bcache.h                         |   2 -
 drivers/md/bcache/io.c                             |  12 +
 drivers/md/bcache/journal.c                        |  54 ++-
 drivers/md/bcache/super.c                          |  65 ++--
 drivers/md/bcache/sysfs.c                          |  30 +-
 drivers/md/bcache/util.h                           |   2 -
 drivers/md/bcache/writeback.c                      |   5 +
 drivers/md/dm-bufio.c                              |   4 +-
 drivers/md/dm-thin-metadata.c                      |   7 +-
 drivers/md/dm-zoned-metadata.c                     |  24 --
 drivers/md/dm-zoned.h                              |  28 +-
 drivers/md/raid5.c                                 |  11 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |   4 +
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |   2 +-
 drivers/media/dvb-frontends/tua6100.c              |  22 +-
 drivers/media/i2c/Makefile                         |   2 +-
 drivers/media/i2c/{adv7511.c => adv7511-v4l2.c}    |   5 +
 drivers/media/i2c/mt9m111.c                        |   8 +-
 drivers/media/i2c/ov7740.c                         |   6 +-
 drivers/media/media-device.c                       |  10 +-
 drivers/media/pci/saa7164/saa7164-core.c           |  33 +-
 drivers/media/platform/aspeed-video.c              |  16 +-
 drivers/media/platform/coda/coda-bit.c             |   9 +-
 drivers/media/platform/coda/coda-common.c          |   2 +
 drivers/media/platform/davinci/vpif_capture.c      |  16 +-
 drivers/media/platform/davinci/vpss.c              |   5 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |   5 +-
 drivers/media/platform/meson/ao-cec-g12a.c         |   1 -
 drivers/media/platform/qcom/venus/firmware.c       |   6 +-
 drivers/media/platform/rcar_fdp1.c                 |   8 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |   5 +
 drivers/media/platform/vim2m.c                     |   6 +-
 drivers/media/platform/vimc/vimc-capture.c         |   5 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |   3 +
 drivers/media/rc/ir-spi.c                          |   1 +
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   7 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |  17 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   4 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   3 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  27 +-
 drivers/mmc/host/sdhci-msm.c                       |   9 +-
 drivers/mtd/nand/raw/mtk_nand.c                    |  24 +-
 drivers/mtd/nand/spi/core.c                        |   2 +-
 drivers/net/bonding/bond_main.c                    |  37 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  11 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   5 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  33 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h  |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   4 +-
 drivers/net/ethernet/freescale/fec_main.c          |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 146 ++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  21 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   7 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   6 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  14 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |  27 +-
 drivers/net/ethernet/intel/ice/ice.h               |   1 -
 drivers/net/ethernet/intel/ice/ice_lib.c           |  24 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  25 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  11 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h       |   1 +
 drivers/net/ethernet/marvell/mvmdio.c              |   7 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   6 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  31 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  29 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |   2 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |   2 +-
 drivers/net/ethernet/socionext/netsec.c            |  32 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   5 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   6 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  18 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +
 drivers/net/ethernet/ti/cpsw.c                     |   3 +
 drivers/net/ethernet/ti/cpsw_priv.h                |   1 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  20 +-
 drivers/net/gtp.c                                  |  36 +-
 drivers/net/phy/phy_device.c                       |   6 +
 drivers/net/phy/sfp.c                              |   6 +-
 drivers/net/usb/asix_devices.c                     |   6 +-
 drivers/net/vxlan.c                                |  37 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   7 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   4 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   2 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  14 +-
 drivers/net/wireless/ath/ath10k/pci.c              |   9 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |   1 +
 drivers/net/wireless/ath/ath10k/sdio.c             |   7 +
 drivers/net/wireless/ath/ath10k/txrx.c             |   3 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   4 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   7 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |  10 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  32 +-
 drivers/net/wireless/ath/ath9k/recv.c              |   6 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   7 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |   2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |  67 ++--
 drivers/net/wireless/ath/wil6210/txrx.c            |   1 +
 drivers/net/wireless/ath/wil6210/wmi.c             |  13 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   2 -
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  53 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   2 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  27 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  66 ++--
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   9 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   3 +
 drivers/net/wireless/mediatek/mt7601u/dma.c        |  54 +--
 drivers/net/wireless/mediatek/mt7601u/tx.c         |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |  12 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   5 +-
 drivers/nvdimm/dax_devs.c                          |   2 +-
 drivers/nvdimm/pfn.h                               |   1 +
 drivers/nvdimm/pfn_devs.c                          |  18 +-
 drivers/nvme/host/core.c                           |  14 +-
 drivers/nvme/host/pci.c                            |  14 +-
 drivers/opp/core.c                                 |   2 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   2 +
 drivers/pci/controller/pci-hyperv.c                |  15 +-
 drivers/pci/pci.c                                  |  36 +-
 drivers/pci/pci.h                                  |   1 +
 drivers/pci/pcie/portdrv_core.c                    |  66 ++++
 drivers/phy/qualcomm/phy-qcom-qmp.c                |   4 +-
 drivers/ras/cec.c                                  |   4 +-
 drivers/regulator/da9211-regulator.c               |   2 +
 drivers/regulator/s2mps11.c                        |   9 +-
 drivers/regulator/s5m8767.c                        |   4 +-
 drivers/regulator/tps65090-regulator.c             |   7 +-
 drivers/s390/cio/qdio_main.c                       |   1 +
 drivers/s390/scsi/zfcp_fsf.c                       |  55 ++-
 drivers/scsi/NCR5380.c                             |  18 +-
 drivers/scsi/NCR5380.h                             |   2 +-
 drivers/scsi/mac_scsi.c                            | 375 ++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas_base.c          |   3 +-
 drivers/scsi/scsi_lib.c                            |   6 +-
 drivers/scsi/sd_zbc.c                              |   2 +-
 drivers/spi/spi-rockchip.c                         |   4 +-
 drivers/spi/spi.c                                  |  12 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  15 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   3 +
 drivers/staging/media/imx/imx7-mipi-csis.c         |  14 +-
 drivers/usb/core/devio.c                           |  48 +--
 drivers/usb/core/hub.c                             |   7 +-
 drivers/vhost/net.c                                |   2 +-
 drivers/xen/balloon.c                              |  16 +-
 drivers/xen/events/events_base.c                   |  12 +-
 drivers/xen/evtchn.c                               |   2 +-
 fs/btrfs/compression.c                             |  16 +
 fs/btrfs/compression.h                             |   1 +
 fs/btrfs/file.c                                    |   5 +
 fs/btrfs/props.c                                   |   6 +-
 fs/btrfs/tree-log.c                                |  40 ++-
 fs/ceph/file.c                                     |   2 +-
 fs/ceph/inode.c                                    |   7 +-
 fs/ceph/super.c                                    |   2 +-
 fs/ceph/super.h                                    |   2 +-
 fs/cifs/cifs_fs_sb.h                               |   5 +
 fs/cifs/connect.c                                  |  12 +-
 fs/cifs/inode.c                                    |  16 +
 fs/cifs/misc.c                                     |   1 +
 fs/cifs/smb2inode.c                                |  12 +
 fs/cifs/smb2ops.c                                  |  57 +++-
 fs/coda/file.c                                     |  70 +++-
 fs/crypto/crypto.c                                 |  15 +-
 fs/dax.c                                           |  53 +--
 fs/ecryptfs/crypto.c                               |  12 +-
 fs/fs-writeback.c                                  |   8 +-
 fs/nfs/dir.c                                       |  90 +----
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
 fs/nfs/inode.c                                     |   1 +
 fs/nfs/internal.h                                  |   3 +-
 fs/nfs/nfs4file.c                                  |   2 +-
 fs/nfs/pnfs.c                                      |   2 +-
 fs/proc/proc_sysctl.c                              |   4 +
 fs/pstore/inode.c                                  |  13 +-
 include/asm-generic/bug.h                          |   6 +-
 include/drm/drm_displayid.h                        |  10 +
 include/linux/blkdev.h                             |   4 +-
 include/linux/cpuhotplug.h                         |   2 +-
 include/linux/mm.h                                 |   5 +
 include/linux/rcupdate.h                           |   2 +-
 include/linux/sched/signal.h                       |   2 +-
 include/net/ip_vs.h                                |   6 +-
 include/net/xdp_sock.h                             |   2 +
 include/rdma/ib_verbs.h                            |   4 +-
 include/sound/hda_codec.h                          |   2 +
 include/trace/events/rxrpc.h                       |   2 +-
 include/uapi/linux/bpf.h                           |   1 +
 include/xen/events.h                               |   3 +-
 kernel/bpf/Makefile                                |   1 +
 kernel/bpf/core.c                                  |   4 +-
 kernel/bpf/verifier.c                              |  11 +-
 kernel/iomem.c                                     |   2 +-
 kernel/irq/chip.c                                  |   4 +
 kernel/irq/irqdesc.c                               |  16 +-
 kernel/locking/lockdep.c                           |  59 ++--
 kernel/padata.c                                    |  12 +
 kernel/pid_namespace.c                             |   2 +-
 kernel/resource.c                                  |  20 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/sched-pelt.h                          |   2 +-
 kernel/signal.c                                    | 136 ++++++--
 kernel/time/ntp.c                                  |   4 +-
 kernel/time/timer_list.c                           |  36 +-
 kernel/trace/trace_output.c                        |   9 +-
 lib/reed_solomon/decode_rs.c                       |  18 +-
 lib/scatterlist.c                                  |   9 +-
 mm/memcontrol.c                                    |   5 +-
 mm/vmscan.c                                        |   6 +-
 mm/z3fold.c                                        |  12 +-
 net/9p/trans_virtio.c                              |   8 +-
 net/9p/trans_xen.c                                 |   8 +-
 net/batman-adv/bat_iv_ogm.c                        |   4 +-
 net/batman-adv/hard-interface.c                    |   3 +
 net/batman-adv/translation-table.c                 |   2 +
 net/batman-adv/types.h                             |   3 +
 net/bluetooth/6lowpan.c                            |  14 +-
 net/bluetooth/hci_event.c                          |   5 +
 net/bluetooth/hidp/core.c                          |   2 +-
 net/bluetooth/hidp/sock.c                          |   1 +
 net/bluetooth/l2cap_core.c                         |  15 +-
 net/bluetooth/smp.c                                |  13 +
 net/key/af_key.c                                   |   8 +-
 net/netfilter/ipset/ip_set_core.c                  |  10 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  21 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   4 -
 net/netfilter/ipvs/ip_vs_sync.c                    | 134 ++++----
 net/netfilter/nf_conntrack_netlink.c               |   7 +-
 net/netfilter/nf_conntrack_proto_icmp.c            |   2 +-
 net/netfilter/nf_nat_proto.c                       |   2 +-
 net/netfilter/utils.c                              |   5 +-
 net/sunrpc/clnt.c                                  |   3 +-
 net/sunrpc/xprt.c                                  |   2 +
 net/sunrpc/xprtsock.c                              |   1 +
 net/xdp/xsk.c                                      |  31 +-
 net/xdp/xsk_queue.h                                |   2 +-
 net/xfrm/Kconfig                                   |   2 +
 net/xfrm/xfrm_user.c                               |  19 ++
 scripts/kconfig/confdata.c                         |   7 +-
 scripts/kconfig/expr.h                             |   1 +
 security/integrity/digsig.c                        |   5 +-
 security/selinux/hooks.c                           |  11 +-
 sound/core/seq/seq_clientmgr.c                     |  11 +-
 sound/hda/ext/hdac_ext_bus.c                       |   8 +-
 sound/hda/hdac_controller.c                        |   5 +-
 sound/pci/hda/hda_codec.c                          |   8 +-
 sound/pci/hda/patch_hdmi.c                         |  31 +-
 sound/pci/hda/patch_realtek.c                      |  10 +-
 sound/soc/codecs/hdac_hdmi.c                       |   6 +
 sound/soc/generic/audio-graph-card.c               |   6 +-
 sound/soc/intel/boards/Kconfig                     |   2 +-
 sound/soc/meson/axg-tdm.h                          |   2 +-
 sound/soc/sh/rcar/ctu.c                            |   2 +-
 sound/soc/soc-core.c                               |  20 +-
 sound/soc/soc-dapm.c                               |  18 +-
 tools/bpf/bpftool/jit_disasm.c                     |  11 +-
 tools/build/feature/test-all.c                     |   2 +-
 tools/include/uapi/linux/bpf.h                     |   1 +
 tools/lib/bpf/libbpf.c                             |   8 +-
 tools/lib/bpf/xsk.c                                |   6 +-
 tools/perf/Makefile.config                         |  11 +-
 tools/perf/arch/arm/util/cs-etm.c                  | 127 ++++++-
 tools/perf/jvmti/libjvmti.c                        |   4 +-
 tools/perf/perf.h                                  |   2 +-
 tools/perf/tests/parse-events.c                    |  27 ++
 .../tests/shell/record+probe_libc_inet_pton.sh     |   2 +-
 tools/perf/ui/browsers/annotate.c                  |   5 +-
 tools/perf/ui/libslang.h                           |   5 +
 tools/perf/util/annotate.c                         |   5 +-
 tools/perf/util/evsel.c                            |   8 +-
 tools/perf/util/header.c                           |   2 +-
 tools/perf/util/metricgroup.c                      |  47 ++-
 tools/perf/util/stat-display.c                     |   3 +-
 tools/perf/util/stat-shadow.c                      |  23 +-
 tools/power/cpupower/utils/cpufreq-set.c           |   2 +
 tools/testing/selftests/bpf/Makefile               |   3 +-
 .../selftests/bpf/progs/test_lwt_seg6local.c       |  12 +-
 tools/testing/selftests/bpf/test_verifier.c        |  31 +-
 virt/kvm/kvm_main.c                                |   2 +-
 419 files changed, 4191 insertions(+), 1794 deletions(-)


