Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A883D615D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhGZPaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237790AbhGZP3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 897EF60F6B;
        Mon, 26 Jul 2021 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315712;
        bh=pjztQd3/wEH1Z0JF64e5VJIZuwlAOyZbLmVPnvBxSn0=;
        h=From:To:Cc:Subject:Date:From;
        b=YZDvw3fHqCT7Tro+O7FPfvrywhV3tZUJu7B9il5U9npCVKVxTqkhZmtne/uJBrwcz
         7ZdOWYWb4Hn7po7SaIGXLcIsoG6gQKa1DkXxpfxBM29OLK7HZ24NKdLD0btqdYAj3I
         JFY1dO+o1lDCxMq/eNo5qCGoteay+ik67Zq1kHfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 000/223] 5.13.6-rc1 review
Date:   Mon, 26 Jul 2021 17:36:32 +0200
Message-Id: <20210726153846.245305071@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.6-rc1
X-KernelTest-Deadline: 2021-07-28T15:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.6 release.
There are 223 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.6-rc1

Íñigo Huguet <ihuguet@redhat.com>
    sfc: ensure correct number of XDP queues

Yoshitaka Ikeda <ikeda@nskint.co.jp>
    spi: spi-cadence-quadspi: Fix division by zero warning - try2

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Clear d3_entered on elsp cmd submission.

Riccardo Mancini <rickyman7@gmail.com>
    perf inject: Close inject.output on exit

Mark Rutland <mark.rutland@arm.com>
    arm64: entry: fix KCOV suppression

Robert Richter <rrichter@amd.com>
    Documentation: Fix intiramfs script name

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: multi_v7_defconfig: Make NOP_USB_XCEIV driver built-in

Paul Blakey <paulb@nvidia.com>
    skbuff: Release nfct refcount on napi stolen or re-used skbs

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: fix 'masking a bool' warning

Mahesh Bandewar <maheshb@google.com>
    bonding: fix build issue

Yoshitaka Ikeda <ikeda@nskint.co.jp>
    spi: spi-cadence-quadspi: Revert "Fix division by zero warning"

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: update golden setting for sienna_cichlid

Xiaojian Du <Xiaojian.Du@amd.com>
    drm/amdgpu: update the golden setting for vangogh

Tao Zhou <tao.zhou1@amd.com>
    drm/amdgpu: update gc golden setting for dimgrey_cavefish

Charles Baylis <cb-kernel@fishzet.co.uk>
    drm: Return -ENOTTY for non-drm ioctls

Jason Ekstrand <jason@jlekstrand.net>
    Revert "drm/i915: Propagate errors on awaiting already signaled fences"

Adrian Hunter <adrian.hunter@intel.com>
    driver core: Prevent warning when removing a device link from unregistered consumer

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nds32: fix up stack guard gap

Jérôme Glisse <jglisse@redhat.com>
    misc: eeprom: at24: Always append device id even if label property is set.

Ilya Dryomov <idryomov@gmail.com>
    rbd: always kick acquire on "acquired" and "released" notifications

Ilya Dryomov <idryomov@gmail.com>
    rbd: don't hold lock_rwsem while running_list is being drained

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: fix mount mode command line processing

Qi Zheng <zhengqi.arch@bytedance.com>
    mm: fix the deadlock in finish_fault()

Mike Rapoport <rppt@kernel.org>
    memblock: make for_each_mem_range() traverse MEMBLOCK_HOTPLUG regions

Sergei Trofimovich <slyfox@gentoo.org>
    mm: page_alloc: fix page_poison=1 / INIT_ON_ALLOC_DEFAULT_ON interaction

Christoph Hellwig <hch@lst.de>
    mm: call flush_dcache_page() in memcpy_to_page() and memzero_page()

Alexander Potapenko <glider@google.com>
    kfence: skip all GFP_ZONEMASK allocations

Alexander Potapenko <glider@google.com>
    kfence: move the size check to the beginning of __kfence_alloc()

Peter Collingbourne <pcc@google.com>
    userfaultfd: do not untag user pointers

Jens Axboe <axboe@kernel.dk>
    io_uring: fix early fdput() of file

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: remove double poll entry on arm failure

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: explicitly count entries for poll reqs

Peter Collingbourne <pcc@google.com>
    selftest: use mmap instead of posix_memalign to allocate memory

Frederic Weisbecker <frederic@kernel.org>
    posix-cpu-timers: Fix rearm racing against process tick

Loic Poulain <loic.poulain@linaro.org>
    bus: mhi: pci_generic: Fix inbound IPCR channel

Bhaumik Bhatt <bbhatt@codeaurora.org>
    bus: mhi: core: Validate channel ID when processing command completions

Bhaumik Bhatt <bbhatt@codeaurora.org>
    bus: mhi: pci_generic: Apply no-op for wake using sideband wake boolean

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    driver core: auxiliary bus: Fix memory leak when driver_register() fail

Markus Boehme <markubo@amazon.com>
    ixgbe: Fix packet corruption due to missing DMA sync

Gustavo A. R. Silva <gustavoars@kernel.org>
    media: ngene: Fix out-of-bounds bug in ngene_command_config_free_buf()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lock inversion problem when doing qgroup extent tracing

Filipe Manana <fdmanana@suse.com>
    btrfs: fix unpersisted i_size on fsync after expanding truncate

Anand Jain <anand.jain@oracle.com>
    btrfs: check for missing device in btrfs_trim_fs

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Synthetic event field_pos is an index not a boolean

Haoran Luo <www@aegistudio.net>
    tracing: Fix bug in rb_per_cpu_empty() that might cause deadloop.

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing/histogram: Rename "cpu" to "common_cpu"

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracepoints: Update static_call before tp_funcs when adding a tracepoint

Marc Zyngier <maz@kernel.org>
    firmware/efi: Tell memblock about EFI iomem reservations

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: typec: stusb160x: Don't block probing of consumer of "connector" nodes

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: typec: stusb160x: register role switch before interrupt registration

Martin Kepplinger <martink@posteo.de>
    usb: typec: tipd: Don't block probing of consumer of "connector" nodes

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix sending zero length packet in DDMA mode.

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix GOUTNAK flow for Slave mode.

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc2: Skip clock gating on Samsung SoCs

Zhang Qilong <zhangqilong3@huawei.com>
    usb: gadget: Fix Unbalanced pm_runtime_enable in tegra_xudc_probe

John Keeping <john@metanate.com>
    USB: serial: cp210x: add ID for CEL EM3588 USB ZigBee stick

Ian Ray <ian.ray@ge.com>
    USB: serial: cp210x: fix comments for GE CS1000

Marco De Marco <marco.demarco@posteo.net>
    USB: serial: option: add support for u-blox LARA-R6 family

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: Fix superfluous irqs happen after usb_pkt_pop()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    usb: max-3421: Prevent corruption of freed memory

Julian Sikorski <belegdol@gmail.com>
    USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix link power management max exit latency (MEL) calculations

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Disable USB 3 device initiated lpm if exit latency is too high

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV Nested: Sanitise H_ENTER_NESTED TM state

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S: Fix H_RTAS rets buffer overflow

David Jeffery <djeffery@redhat.com>
    usb: ehci: Prevent missed ehci interrupts with edge-triggered MSI

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix lost USB 2 remote wake

Greg Thelen <gthelen@google.com>
    usb: xhci: avoid renesas_usb_fw.mem when it's unusable

Moritz Fischer <mdf@kernel.org>
    Revert "usb: renesas-xhci: Fix handling of unknown ROM state"

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix mmap capability check

Alan Young <consult.awy@gmail.com>
    ALSA: pcm: Call substream ack() method upon compat mmap commit

Takashi Iwai <tiwai@suse.de>
    ALSA: hdmi: Expose all pins on MSI MS-7C94 board

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: Fix pop noise and 2 Front Mic issues on a machine

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Fix potential ABBA deadlock in CSP driver

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum headsets

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add missing proc text entry for BESPOKEN type

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/boot: fix use of expolines in the DMA code

Vasily Gorbik <gor@linux.ibm.com>
    s390/ftrace: fix ftrace_update_ftrace_func implementation

Stephen Boyd <swboyd@chromium.org>
    mmc: core: Don't allocate IDA for OF aliases

Olivier Langlois <olivier@trillion01.com>
    io_uring: Fix race condition when sqp thread goes to sleep

Linus Torvalds <torvalds@linux-foundation.org>
    ACPI: fix NULL pointer dereference

Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
    proc: Avoid mixing integer types in mem_rw()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix fallocate when trying to allocate a hole.

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: only write 64kb at a time when fallocating a small region of a file

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: seed the buffer pool after allocating the swp

Maxime Ripard <maxime@cerno.tech>
    drm/panel: raspberrypi-touchscreen: Prevent double-free

Yajun Deng <yajun.deng@linux.dev>
    net: sched: cls_api: Fix the the wrong parameter

Heinrich Schuchardt <xypron.glpk@gmx.de>
    RISC-V: load initrd wherever it fits into memory

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: make VID 4095 a bridge VLAN too

Wei Wang <weiwan@google.com>
    tcp: disable TFO blackhole logic by default

Bin Meng <bmeng.cn@gmail.com>
    riscv: Fix 32-bit RISC-V boot failure

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Remove the proper scrq flush

Vadim Fedorenko <vfedorenko@novek.ru>
    udp: check encap socket in __udp_lib_err

Xin Long <lucien.xin@gmail.com>
    sctp: update active_key for asoc when old key is being replaced

Christoph Hellwig <hch@lst.de>
    nvme: set the PRACT bit when using Write Zeroes with T10 PI

Sayanta Pattanayak <sayanta.pattanayak@arm.com>
    r8169: Avoid duplicate sysfs entry creation error

David Howells <dhowells@redhat.com>
    afs: Fix setting of writeback_index

Tom Rix <trix@redhat.com>
    afs: check function return

David Howells <dhowells@redhat.com>
    afs: Fix tracepoint string placement with built-in AFS

Vincent Palatin <vpalatin@chromium.org>
    Revert "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem"

Zhihao Cheng <chengzhihao1@huawei.com>
    nvme-pci: don't WARN_ON in nvme_reset_work if ctrl.state is not RESETTING

Jason Ekstrand <jason@jlekstrand.net>
    drm/ttm: Force re-init if ttm_global_init() fails

David Disseldorp <ddiss@suse.de>
    scsi: target: Fix NULL dereference on XCOPY completion

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: mpc: Poll for MCF

Luis Henriques <lhenriques@suse.de>
    ceph: don't WARN if we're still opening a session to an MDS

Paolo Abeni <pabeni@redhat.com>
    ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions

Peilin Ye <peilin.ye@bytedance.com>
    net/sched: act_skbmod: Skip non-Ethernet packets

Yang Yingliang <yangyingliang@huawei.com>
    io_uring: fix memleak in io_init_wq_offload()

Alexandru Tachici <alexandru.tachici@analog.com>
    spi: spi-bcm2835: Fix deadlock

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix rx VLAN offload state inconsistent issue

Chengwen Feng <fengchengwen@huawei.com>
    net: hns3: fix possible mismatches resp of mailbox

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: intel-dsp-cfg: add missing ElkhartLake PCI ID

Eric Dumazet <edumazet@google.com>
    net/tcp_fastopen: fix data races around tfo_active_disable_stamp

Randy Dunlap <rdunlap@infradead.org>
    net: hisilicon: rename CACHE_LINE_MASK to avoid redefinition

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Check abort error state in bnxt_half_open_nic()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Validate vlan protocol ID on RX packets

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: fix error path of FW reset

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Add missing check for BNXT_STATE_ABORT_ERR in bnxt_fw_rset_task()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Refresh RoCE capabilities in bnxt_ulp_probe()

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: don't disable an already disabled PCI device

Andy Shevchenko <andy.shevchenko@gmail.com>
    ACPI: utils: Fix reference counting in for_each_acpi_dev_match()

Andy Shevchenko <andy.shevchenko@gmail.com>
    efi/dev-path-parser: Switch to use for_each_acpi_dev_match()

Robert Richter <rrichter@amd.com>
    ACPI: Kconfig: Fix table override from built-in initrd

Marek Vasut <marex@denx.de>
    spi: cadence: Correct initialisation of runtime PM again

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: Fix protect handling in WRITE SAME(32)

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix iface sysfs attr detection

Nguyen Dinh Phi <phind.uet@gmail.com>
    netrom: Decrease sock refcount when sock timers expire

Xin Long <lucien.xin@gmail.com>
    sctp: trim optlen when it's a huge value in sctp_setsockopt

Pavel Skripkin <paskripkin@gmail.com>
    net: sched: fix memory leak in tcindex_partial_destroy_work

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Fix kvm_arch_vcpu_ioctl vcpu_load leak

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S: Fix CONFIG_TRANSACTIONAL_MEM=n crash

Yajun Deng <yajun.deng@linux.dev>
    net: decnet: Fix sleeping inside in af_decnet

Michal Suchanek <msuchanek@suse.de>
    efi/tpm: Differentiate missing and invalid final event log table.

Vijendar Mukunda <vijendar.mukunda@amd.com>
    ASoC: soc-pcm: add a flag to reverse the stop sequence

Roman Skakun <Roman_Skakun@epam.com>
    dma-mapping: handle vmalloc addresses in dma_common_{mmap,get_sgtable}

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: hso: fix error handling code of hso_create_net_device

Yoshitaka Ikeda <ikeda@nskint.co.jp>
    spi: spi-cadence-quadspi: Fix division by zero warning

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: fix uninit-value in caif_seqpkt_sendmsg

Tobias Klauser <tklauser@distanz.ch>
    bpftool: Check malloc return value in mount_bpffs_for_pin

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockmap, udp: sk_prot needs inuse_idx set for proc stats

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap, tcp: sk_prot needs inuse_idx set for proc stats

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Fix potential memory leak on unlikely error case

Colin Ian King <colin.king@canonical.com>
    s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]

Colin Ian King <colin.king@canonical.com>
    liquidio: Fix unintentional sign extension issue on left shift of u16

Geert Uytterhoeven <geert+renesas@glider.be>
    net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should depend on NET_DSA_MV88E6XXX

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Drop devm interrupt handler for CEC interrupts

Nicolas Saenz Julienne <nsaenzju@redhat.com>
    timers: Fix get_next_timer_interrupt() with no timers pending

Sathya Prakash M R <sathya.prakash.m.r@intel.com>
    ASoC: SOF: Intel: Update ADL descriptor to use ACPI power states

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    xdp, net: Fix use-after-free in bpf_xdp_link_release

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix tail_call_reachable rejection for interpreter when jit failed

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    bpf, test: fix NULL pointer dereference on invalid expected_attach_type

Maxim Schwalm <maxim.schwalm@gmail.com>
    ASoC: rt5631: Fix regcache sync errors on resume

Peter Hess <peter.hess@ph-home.de>
    spi: mediatek: fix fifo rx mode

Axel Lin <axel.lin@ingics.com>
    regulator: hi6421: Fix getting wrong drvdata

Axel Lin <axel.lin@ingics.com>
    regulator: hi6421: Use correct variable type for regmap api val argument

Alain Volmat <alain.volmat@foss.st.com>
    spi: stm32: fixes pm_runtime calls in probe/remove

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm_adsp: Correct wm_coeff_tlv_get handling

Lecopzer Chen <lecopzer.chen@mediatek.com>
    Kbuild: lto: fix module versionings mismatch in GNU make 3.X

Yang Jihong <yangjihong1@huawei.com>
    perf sched: Fix record failure when CONFIG_SCHEDSTATS is not set

Riccardo Mancini <rickyman7@gmail.com>
    perf data: Close all files in close_dir()

Riccardo Mancini <rickyman7@gmail.com>
    perf probe-file: Delete namelist in del_events() on the error path

Riccardo Mancini <rickyman7@gmail.com>
    perf lzma: Close lzma stream on exit

Riccardo Mancini <rickyman7@gmail.com>
    perf script: Fix memory 'threads' and 'cpus' leaks on exit

Riccardo Mancini <rickyman7@gmail.com>
    perf script: Release zstd data

Riccardo Mancini <rickyman7@gmail.com>
    perf report: Free generated help strings for sort option

Riccardo Mancini <rickyman7@gmail.com>
    perf env: Fix memory leak of cpu_pmu_caps

Riccardo Mancini <rickyman7@gmail.com>
    perf test maps__merge_in: Fix memory leak of maps

Riccardo Mancini <rickyman7@gmail.com>
    perf dso: Fix memory leak in dso__new_map()

Riccardo Mancini <rickyman7@gmail.com>
    perf test event_update: Fix memory leak of unit

Riccardo Mancini <rickyman7@gmail.com>
    perf test event_update: Fix memory leak of evlist

Riccardo Mancini <rickyman7@gmail.com>
    perf test session_topology: Delete session->evlist

Riccardo Mancini <rickyman7@gmail.com>
    perf env: Fix sibling_dies memory leak

Riccardo Mancini <rickyman7@gmail.com>
    perf probe: Fix dso->nsinfo refcounting

Riccardo Mancini <rickyman7@gmail.com>
    perf map: Fix dso->nsinfo refcounting

Riccardo Mancini <rickyman7@gmail.com>
    perf inject: Fix dso->nsinfo refcounting

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Ensure drivers provide a probe function

Zev Weiss <zev@bewilderbeest.net>
    ARM: dts: aspeed: Update e3c246d4i vuart properties

Mark Rutland <mark.rutland@arm.com>
    arm64: mte: fix restoration of GCR_EL1 from suspend

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Fix sev_pin_memory() error checks in SEV migration utilities

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Return -EFAULT if copy_to_user() for SEV mig packet header fails

Like Xu <like.xu.linux@gmail.com>
    KVM: x86/pmu: Clear anythread deprecated bit when 0xa leaf is unsupported on the SVM

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix lack of XDP TX queues - error XDP TX failed (-22)

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: ocelot: fix switchdev objects synced for wrong netdev with LAG offload

Casey Chen <cachen@purestorage.com>
    nvme-pci: do not call nvme_dev_remove_admin from nvme_remove

Marek Behún <kabel@kernel.org>
    net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340

Paolo Abeni <pabeni@redhat.com>
    mptcp: properly account bulk freed memory

Paolo Abeni <pabeni@redhat.com>
    mptcp: refine mptcp_cleanup_rbuf

Paolo Abeni <pabeni@redhat.com>
    mptcp: use fast lock for subflows when possible

Jianguo Wu <wujianguo@chinatelecom.cn>
    selftests: mptcp: fix case multiple subflows limited by server

Jianguo Wu <wujianguo@chinatelecom.cn>
    mptcp: avoid processing packet if a subflow reset

Geliang Tang <geliangtang@gmail.com>
    mptcp: add sk parameter for mptcp_get_options

Jianguo Wu <wujianguo@chinatelecom.cn>
    mptcp: fix syncookie process if mptcp can not_accept new subflow

Jianguo Wu <wujianguo@chinatelecom.cn>
    mptcp: remove redundant req destruct in subflow_check_req()

Jianguo Wu <wujianguo@chinatelecom.cn>
    mptcp: fix warning in __skb_flow_dissect() when do syn cookie for subflow join

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Fix a bad merge in otable batch takedown

Shahjada Abul Husain <shahjada@chelsio.com>
    cxgb4: fix IRQ free race during driver unload

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sprd: Ensure configuring period and duty_cycle isn't wrongly skipped

Hangbin Liu <liuhangbin@gmail.com>
    selftests: icmp_redirect: IPv6 PMTU info should be cleared after redirect

Hangbin Liu <liuhangbin@gmail.com>
    selftests: icmp_redirect: remove from checking for IPv6 route get

YueHaibing <yuehaibing@huawei.com>
    stmmac: platform: Fix signedness bug in stmmac_probe_config_dt()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: fix 'disable_policy' for fwd packets

Taehee Yoo <ap420073@gmail.com>
    bonding: fix incorrect return value of bond_ipsec_offload_ok()

Taehee Yoo <ap420073@gmail.com>
    bonding: fix suspicious RCU usage in bond_ipsec_offload_ok()

Taehee Yoo <ap420073@gmail.com>
    bonding: Add struct bond_ipesc to manage SA

Taehee Yoo <ap420073@gmail.com>
    bonding: disallow setting nested bonding + ipsec offload

Taehee Yoo <ap420073@gmail.com>
    bonding: fix suspicious RCU usage in bond_ipsec_del_sa()

Taehee Yoo <ap420073@gmail.com>
    ixgbevf: use xso.real_dev instead of xso.dev in callback functions of struct xfrmdev_ops

Taehee Yoo <ap420073@gmail.com>
    bonding: fix null dereference in bond_ipsec_add_sa()

Taehee Yoo <ap420073@gmail.com>
    bonding: fix suspicious RCU usage in bond_ipsec_add_sa()

Wang Hai <wanghai38@huawei.com>
    bpf, samples: Fix xdpsock with '-M' parameter missing unload process

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    gve: Fix an error handling path in 'gve_probe()'

Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
    net: stmmac: Terminate FPE workqueue in suspend

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    igb: Fix position of assignment to *ring

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    igb: Check if num of q_vectors is smaller than max before array access

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iavf: Fix an error handling path in 'iavf_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    e1000e: Fix an error handling path in 'e1000_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    fm10k: Fix an error handling path in 'fm10k_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    igb: Fix an error handling path in 'igb_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    igc: Fix an error handling path in 'igc_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ixgbe: Fix an error handling path in 'ixgbe_probe()'

Tom Rix <trix@redhat.com>
    igc: change default return of igc_read_phy_reg()

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igb: Fix use-after-free error during reset

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Fix use-after-free error during reset


-------------

Diffstat:

 Documentation/arm64/tagged-address-abi.rst         |  26 ++-
 .../early-userspace/early_userspace_support.rst    |   8 +-
 .../filesystems/ramfs-rootfs-initramfs.rst         |   2 +-
 Documentation/networking/ip-sysctl.rst             |   2 +-
 Documentation/trace/histogram.rst                  |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts  |   4 +-
 arch/arm/configs/multi_v7_defconfig                |   2 +-
 arch/arm64/kernel/Makefile                         |   2 +-
 arch/arm64/kernel/mte.c                            |  15 +-
 arch/nds32/mm/mmap.c                               |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |   2 +
 arch/powerpc/kvm/book3s_hv_nested.c                |  20 +++
 arch/powerpc/kvm/book3s_rtas.c                     |  25 ++-
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/riscv/include/asm/efi.h                       |   4 +-
 arch/riscv/mm/init.c                               |   4 +-
 arch/s390/boot/text_dma.S                          |  19 +--
 arch/s390/include/asm/ftrace.h                     |   1 +
 arch/s390/kernel/ftrace.c                          |   2 +
 arch/s390/kernel/mcount.S                          |   4 +-
 arch/s390/net/bpf_jit_comp.c                       |   2 +-
 arch/x86/kvm/cpuid.c                               |   3 +-
 arch/x86/kvm/svm/sev.c                             |  14 +-
 drivers/acpi/Kconfig                               |   2 +-
 drivers/acpi/utils.c                               |   7 +-
 drivers/base/auxiliary.c                           |   8 +-
 drivers/base/core.c                                |   6 +-
 drivers/block/rbd.c                                |  32 ++--
 drivers/bus/mhi/core/main.c                        |  17 +-
 drivers/bus/mhi/pci_generic.c                      |  45 ++++-
 drivers/firmware/arm_scmi/bus.c                    |   3 +
 drivers/firmware/efi/dev-path-parser.c             |  46 ++----
 drivers/firmware/efi/efi.c                         |  13 +-
 drivers/firmware/efi/tpm.c                         |   8 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   3 +
 drivers/gpu/drm/drm_ioctl.c                        |   3 +
 drivers/gpu/drm/i915/gvt/handlers.c                |  15 ++
 drivers/gpu/drm/i915/i915_request.c                |   8 +-
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  |   1 -
 drivers/gpu/drm/ttm/ttm_device.c                   |   2 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  49 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c                |   1 -
 drivers/i2c/busses/i2c-mpc.c                       |   4 +-
 drivers/media/pci/intel/ipu3/cio2-bridge.c         |   6 +-
 drivers/media/pci/ngene/ngene-core.c               |   2 +-
 drivers/media/pci/ngene/ngene.h                    |  14 +-
 drivers/misc/eeprom/at24.c                         |  17 +-
 drivers/mmc/core/host.c                            |  20 +--
 drivers/net/bonding/bond_main.c                    | 183 +++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/Kconfig                  |   2 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  63 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   9 +-
 .../ethernet/cavium/liquidio/cn23xx_pf_device.c    |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |   3 +
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  16 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   5 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  10 ++
 drivers/net/ethernet/ibm/ibmvnic.c                 |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   1 +
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  15 +-
 drivers/net/ethernet/intel/igc/igc.h               |   2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   4 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |  20 ++-
 drivers/net/ethernet/mscc/ocelot_net.c             |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   3 +-
 drivers/net/ethernet/sfc/efx_channels.c            |  18 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +-
 drivers/net/phy/marvell10g.c                       |  40 ++++-
 drivers/net/usb/hso.c                              |  33 ++--
 drivers/nvme/host/core.c                           |   5 +-
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/pwm/pwm-sprd.c                             |  11 +-
 drivers/regulator/hi6421-regulator.c               |  30 ++--
 drivers/scsi/scsi_transport_iscsi.c                |  90 ++++------
 drivers/spi/spi-bcm2835.c                          |  12 +-
 drivers/spi/spi-cadence-quadspi.c                  |   3 +
 drivers/spi/spi-cadence.c                          |  14 +-
 drivers/spi/spi-mt65xx.c                           |  16 +-
 drivers/spi/spi-stm32.c                            |   9 +-
 drivers/target/target_core_sbc.c                   |  35 ++--
 drivers/target/target_core_transport.c             |   2 +-
 drivers/usb/core/hub.c                             | 120 ++++++++++----
 drivers/usb/core/quirks.c                          |   4 -
 drivers/usb/dwc2/core.h                            |   4 +
 drivers/usb/dwc2/core_intr.c                       |   3 +-
 drivers/usb/dwc2/gadget.c                          |  31 +++-
 drivers/usb/dwc2/hcd.c                             |   6 +-
 drivers/usb/dwc2/params.c                          |   1 +
 drivers/usb/gadget/udc/tegra-xudc.c                |   1 +
 drivers/usb/host/ehci-hcd.c                        |  18 +-
 drivers/usb/host/max3421-hcd.c                     |  44 ++---
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-pci-renesas.c                |  16 +-
 drivers/usb/host/xhci-pci.c                        |   7 +
 drivers/usb/renesas_usbhs/fifo.c                   |   7 +
 drivers/usb/serial/cp210x.c                        |   5 +-
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/usb/typec/stusb160x.c                      |  20 ++-
 drivers/usb/typec/tipd/core.c                      |   9 +
 fs/afs/cmservice.c                                 |  25 +--
 fs/afs/write.c                                     |  18 +-
 fs/btrfs/backref.c                                 |   6 +-
 fs/btrfs/backref.h                                 |   3 +-
 fs/btrfs/delayed-ref.c                             |   4 +-
 fs/btrfs/extent-tree.c                             |   3 +
 fs/btrfs/qgroup.c                                  |  38 ++++-
 fs/btrfs/qgroup.h                                  |   2 +-
 fs/btrfs/tests/qgroup-tests.c                      |  20 +--
 fs/btrfs/tree-log.c                                |  31 +++-
 fs/ceph/mds_client.c                               |   2 +-
 fs/cifs/smb2ops.c                                  |  49 ++++--
 fs/hugetlbfs/inode.c                               |   2 +-
 fs/io_uring.c                                      |  33 ++--
 fs/proc/base.c                                     |   2 +-
 fs/userfaultfd.c                                   |  26 ++-
 include/acpi/acpi_bus.h                            |   8 +-
 include/drm/drm_ioctl.h                            |   1 +
 include/linux/highmem.h                            |   2 +
 include/linux/marvell_phy.h                        |   6 +-
 include/linux/memblock.h                           |   4 +-
 include/net/bonding.h                              |   9 +-
 include/net/mptcp.h                                |   5 +-
 include/sound/soc.h                                |   6 +
 include/trace/events/afs.h                         |  67 +++++++-
 kernel/bpf/verifier.c                              |   2 +
 kernel/dma/ops_helpers.c                           |  12 +-
 kernel/time/posix-cpu-timers.c                     |  10 +-
 kernel/time/timer.c                                |   8 +-
 kernel/trace/ring_buffer.c                         |  28 +++-
 kernel/trace/trace.c                               |   4 +
 kernel/trace/trace_events_hist.c                   |  22 ++-
 kernel/trace/trace_synth.h                         |   2 +-
 kernel/tracepoint.c                                |   2 +-
 mm/kfence/core.c                                   |  19 ++-
 mm/memblock.c                                      |   3 +-
 mm/memory.c                                        |  11 +-
 mm/page_alloc.c                                    |  29 ++--
 net/bpf/test_run.c                                 |   3 +
 net/caif/caif_socket.c                             |   3 +-
 net/core/dev.c                                     |  27 ++-
 net/core/skbuff.c                                  |   1 +
 net/core/skmsg.c                                   |  16 +-
 net/decnet/af_decnet.c                             |  27 ++-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/ipv4/tcp_fastopen.c                            |  28 +++-
 net/ipv4/tcp_input.c                               |  19 ++-
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/udp.c                                     |  25 ++-
 net/ipv4/udp_bpf.c                                 |   2 +-
 net/ipv6/ip6_output.c                              |   4 +-
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/udp.c                                     |  25 ++-
 net/mptcp/mib.c                                    |   1 +
 net/mptcp/mib.h                                    |   1 +
 net/mptcp/options.c                                |  24 ++-
 net/mptcp/pm_netlink.c                             |  10 +-
 net/mptcp/protocol.c                               |  81 +++++----
 net/mptcp/protocol.h                               |  14 +-
 net/mptcp/subflow.c                                |  21 +--
 net/mptcp/syncookies.c                             |  16 +-
 net/netrom/nr_timer.c                              |  20 ++-
 net/sched/act_skbmod.c                             |  12 +-
 net/sched/cls_api.c                                |   2 +-
 net/sched/cls_tcindex.c                            |   5 +-
 net/sctp/auth.c                                    |   2 +
 net/sctp/socket.c                                  |   4 +
 samples/bpf/xdpsock_user.c                         |  28 ++++
 scripts/Makefile.build                             |   2 +-
 sound/core/pcm_native.c                            |  25 ++-
 sound/hda/intel-dsp-config.c                       |   4 +
 sound/isa/sb/sb16_csp.c                            |   4 +
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/rt5631.c                          |   2 +
 sound/soc/codecs/wm_adsp.c                         |   2 +-
 sound/soc/soc-pcm.c                                |  22 ++-
 sound/soc/sof/intel/pci-tgl.c                      |   1 +
 sound/usb/mixer.c                                  |  10 +-
 sound/usb/quirks.c                                 |   3 +
 tools/bpf/bpftool/common.c                         |   5 +
 tools/perf/builtin-inject.c                        |  13 +-
 tools/perf/builtin-report.c                        |  33 ++--
 tools/perf/builtin-sched.c                         |  33 +++-
 tools/perf/builtin-script.c                        |   8 +
 tools/perf/tests/event_update.c                    |   6 +-
 tools/perf/tests/maps.c                            |   2 +
 tools/perf/tests/topology.c                        |   1 +
 tools/perf/util/data.c                             |   2 +-
 tools/perf/util/dso.c                              |   4 +-
 tools/perf/util/env.c                              |   2 +
 tools/perf/util/lzma.c                             |   8 +-
 tools/perf/util/map.c                              |   2 +
 tools/perf/util/probe-event.c                      |   4 +-
 tools/perf/util/probe-file.c                       |   4 +-
 tools/perf/util/sort.c                             |   2 +-
 tools/perf/util/sort.h                             |   2 +-
 tools/testing/selftests/net/icmp_redirect.sh       |   5 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   2 +-
 tools/testing/selftests/vm/userfaultfd.c           |   6 +-
 210 files changed, 1840 insertions(+), 869 deletions(-)


