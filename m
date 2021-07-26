Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1333D6024
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbhGZPVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236359AbhGZPU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C44C660F5A;
        Mon, 26 Jul 2021 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315287;
        bh=yrg2zQfx1mb+HxXgY83T9VzpeaUY/zAsHKDTSRqZ00o=;
        h=From:To:Cc:Subject:Date:From;
        b=LNq1wl6GkdcQDlfEgAKeYT9+qR7l0R5rhxJEu3wI848jWrJQLTqvlOaN3ApwsO3FM
         C5+QnmNN2GaPiQF1VbVJPj3BMRLeiwswrt+4PwJJvP7v/2BJpg74ir6qa+WluCltlB
         nov53GZ4AXtZdaYxF/+Q38wasJelV+7p7udsAxsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/167] 5.10.54-rc1 review
Date:   Mon, 26 Jul 2021 17:37:13 +0200
Message-Id: <20210726153839.371771838@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.54-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.54-rc1
X-KernelTest-Deadline: 2021-07-28T15:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.54 release.
There are 167 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.54-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.54-rc1

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: add xhci_get_virt_ep() helper

Íñigo Huguet <ihuguet@redhat.com>
    sfc: ensure correct number of XDP queues

Colin Xu <colin.xu@intel.com>
    drm/i915/gvt: Clear d3_entered on elsp cmd submission.

David Jeffery <djeffery@redhat.com>
    usb: ehci: Prevent missed ehci interrupts with edge-triggered MSI

Riccardo Mancini <rickyman7@gmail.com>
    perf inject: Close inject.output on exit

Robert Richter <rrichter@amd.com>
    Documentation: Fix intiramfs script name

Paul Blakey <paulb@nvidia.com>
    skbuff: Release nfct refcount on napi stolen or re-used skbs

Mahesh Bandewar <maheshb@google.com>
    bonding: fix build issue

Evan Quan <evan.quan@amd.com>
    PCI: Mark AMD Navi14 GPU ATS as broken

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on Topaz

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: update golden setting for sienna_cichlid

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

Mike Rapoport <rppt@kernel.org>
    memblock: make for_each_mem_range() traverse MEMBLOCK_HOTPLUG regions

Peter Collingbourne <pcc@google.com>
    userfaultfd: do not untag user pointers

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: remove double poll entry on arm failure

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: explicitly count entries for poll reqs

Peter Collingbourne <pcc@google.com>
    selftest: use mmap instead of posix_memalign to allocate memory

Frederic Weisbecker <frederic@kernel.org>
    posix-cpu-timers: Fix rearm racing against process tick

Bhaumik Bhatt <bbhatt@codeaurora.org>
    bus: mhi: core: Validate channel ID when processing command completions

Markus Boehme <markubo@amazon.com>
    ixgbe: Fix packet corruption due to missing DMA sync

Gustavo A. R. Silva <gustavoars@kernel.org>
    media: ngene: Fix out-of-bounds bug in ngene_command_config_free_buf()

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
    usb: typec: stusb160x: register role switch before interrupt registration

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix sending zero length packet in DDMA mode.

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix GOUTNAK flow for Slave mode.

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

Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
    proc: Avoid mixing integer types in mem_rw()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix fallocate when trying to allocate a hole.

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: only write 64kb at a time when fallocating a small region of a file

Maxime Ripard <maxime@cerno.tech>
    drm/panel: raspberrypi-touchscreen: Prevent double-free

Yajun Deng <yajun.deng@linux.dev>
    net: sched: cls_api: Fix the the wrong parameter

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: make VID 4095 a bridge VLAN too

Wei Wang <weiwan@google.com>
    tcp: disable TFO blackhole logic by default

Xin Long <lucien.xin@gmail.com>
    sctp: update active_key for asoc when old key is being replaced

Christoph Hellwig <hch@lst.de>
    nvme: set the PRACT bit when using Write Zeroes with T10 PI

Sayanta Pattanayak <sayanta.pattanayak@arm.com>
    r8169: Avoid duplicate sysfs entry creation error

David Howells <dhowells@redhat.com>
    afs: Fix tracepoint string placement with built-in AFS

Vincent Palatin <vpalatin@chromium.org>
    Revert "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem"

Zhihao Cheng <chengzhihao1@huawei.com>
    nvme-pci: don't WARN_ON in nvme_reset_work if ctrl.state is not RESETTING

Luis Henriques <lhenriques@suse.de>
    ceph: don't WARN if we're still opening a session to an MDS

Paolo Abeni <pabeni@redhat.com>
    ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions

Peilin Ye <peilin.ye@bytedance.com>
    net/sched: act_skbmod: Skip non-Ethernet packets

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

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Add missing check for BNXT_STATE_ABORT_ERR in bnxt_fw_rset_task()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Refresh RoCE capabilities in bnxt_ulp_probe()

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: don't disable an already disabled PCI device

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

Roman Skakun <Roman_Skakun@epam.com>
    dma-mapping: handle vmalloc addresses in dma_common_{mmap,get_sgtable}

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: hso: fix error handling code of hso_create_net_device

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

Nicolas Saenz Julienne <nsaenzju@redhat.com>
    timers: Fix get_next_timer_interrupt() with no timers pending

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

Clark Wang <xiaoning.wang@nxp.com>
    spi: imx: add a check for speed_hz before calculating the clock

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm_adsp: Correct wm_coeff_tlv_get handling

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
    perf report: Free generated help strings for sort option

Riccardo Mancini <rickyman7@gmail.com>
    perf env: Fix memory leak of cpu_pmu_caps

Riccardo Mancini <rickyman7@gmail.com>
    perf test maps__merge_in: Fix memory leak of maps

Riccardo Mancini <rickyman7@gmail.com>
    perf dso: Fix memory leak in dso__new_map()

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

Like Xu <like.xu.linux@gmail.com>
    KVM: x86/pmu: Clear anythread deprecated bit when 0xa leaf is unsupported on the SVM

Casey Chen <cachen@purestorage.com>
    nvme-pci: do not call nvme_dev_remove_admin from nvme_remove

Jianguo Wu <wujianguo@chinatelecom.cn>
    mptcp: fix warning in __skb_flow_dissect() when do syn cookie for subflow join

Antoine Tenart <atenart@kernel.org>
    net: do not reuse skbuff allocated from skbuff_fclone_cache in the skb cache

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

Björn Töpel <bjorn.topel@intel.com>
    net: Introduce preferred busy-polling

Aleksandr Nogikh <nogikh@google.com>
    net: add kcov handle to skb extensions

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    gve: Fix an error handling path in 'gve_probe()'

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
 arch/alpha/include/uapi/asm/socket.h               |   2 +
 arch/mips/include/uapi/asm/socket.h                |   2 +
 arch/nds32/mm/mmap.c                               |   2 +-
 arch/parisc/include/uapi/asm/socket.h              |   2 +
 arch/powerpc/kvm/book3s_hv.c                       |   2 +
 arch/powerpc/kvm/book3s_hv_nested.c                |  20 +++
 arch/powerpc/kvm/book3s_rtas.c                     |  25 ++-
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/s390/boot/text_dma.S                          |  19 +--
 arch/s390/include/asm/ftrace.h                     |   1 +
 arch/s390/kernel/ftrace.c                          |   2 +
 arch/s390/kernel/mcount.S                          |   4 +-
 arch/s390/net/bpf_jit_comp.c                       |   2 +-
 arch/sparc/include/uapi/asm/socket.h               |   2 +
 arch/x86/kvm/cpuid.c                               |   3 +-
 drivers/acpi/Kconfig                               |   2 +-
 drivers/base/core.c                                |   6 +-
 drivers/block/rbd.c                                |  32 ++--
 drivers/bus/mhi/core/main.c                        |  17 +-
 drivers/firmware/efi/efi.c                         |  13 +-
 drivers/firmware/efi/tpm.c                         |   8 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   1 +
 drivers/gpu/drm/drm_ioctl.c                        |   3 +
 drivers/gpu/drm/i915/gvt/handlers.c                |  15 ++
 drivers/gpu/drm/i915/i915_request.c                |   8 +-
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  |   1 -
 drivers/media/pci/ngene/ngene-core.c               |   2 +-
 drivers/media/pci/ngene/ngene.h                    |  14 +-
 drivers/misc/eeprom/at24.c                         |  17 +-
 drivers/mmc/core/host.c                            |  20 +--
 drivers/net/bonding/bond_main.c                    | 183 +++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/chip.c                   |  10 ++
 drivers/net/dsa/mv88e6xxx/serdes.c                 |   6 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  34 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   9 +-
 .../ethernet/cavium/liquidio/cn23xx_pf_device.c    |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |   3 +
 drivers/net/ethernet/google/gve/gve_main.c         |   5 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  10 ++
 drivers/net/ethernet/intel/e1000e/netdev.c         |   1 +
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  15 +-
 drivers/net/ethernet/intel/igc/igc.h               |   2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   4 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |  20 ++-
 drivers/net/ethernet/realtek/r8169_main.c          |   3 +-
 drivers/net/ethernet/sfc/efx_channels.c            |  13 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +-
 drivers/net/usb/hso.c                              |  33 ++--
 drivers/nvme/host/core.c                           |   5 +-
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/pci/quirks.c                               |   4 +-
 drivers/pwm/pwm-sprd.c                             |  11 +-
 drivers/regulator/hi6421-regulator.c               |  30 ++--
 drivers/scsi/scsi_transport_iscsi.c                |  90 ++++------
 drivers/spi/spi-bcm2835.c                          |  12 +-
 drivers/spi/spi-cadence.c                          |  14 +-
 drivers/spi/spi-imx.c                              |  37 +++--
 drivers/spi/spi-mt65xx.c                           |  16 +-
 drivers/spi/spi-stm32.c                            |   9 +-
 drivers/target/target_core_sbc.c                   |  35 ++--
 drivers/usb/core/hub.c                             | 120 ++++++++++----
 drivers/usb/core/quirks.c                          |   4 -
 drivers/usb/dwc2/gadget.c                          |  31 +++-
 drivers/usb/gadget/udc/tegra-xudc.c                |   1 +
 drivers/usb/host/ehci-hcd.c                        |  18 +-
 drivers/usb/host/max3421-hcd.c                     |  44 ++---
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-pci-renesas.c                |  16 +-
 drivers/usb/host/xhci-pci.c                        |   7 +
 drivers/usb/host/xhci-ring.c                       |  58 +++++--
 drivers/usb/host/xhci.h                            |   3 +-
 drivers/usb/renesas_usbhs/fifo.c                   |   7 +
 drivers/usb/serial/cp210x.c                        |   5 +-
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/usb/typec/stusb160x.c                      |  11 +-
 fs/afs/cmservice.c                                 |  25 +--
 fs/btrfs/extent-tree.c                             |   3 +
 fs/ceph/mds_client.c                               |   2 +-
 fs/cifs/smb2ops.c                                  |  49 ++++--
 fs/eventpoll.c                                     |   2 +-
 fs/hugetlbfs/inode.c                               |   2 +-
 fs/io_uring.c                                      |  18 +-
 fs/proc/base.c                                     |   2 +-
 fs/userfaultfd.c                                   |  24 ++-
 include/drm/drm_ioctl.h                            |   1 +
 include/linux/memblock.h                           |   4 +-
 include/linux/netdevice.h                          |  35 ++--
 include/linux/skbuff.h                             |  33 ++++
 include/net/bonding.h                              |   9 +-
 include/net/busy_poll.h                            |   5 +-
 include/net/sock.h                                 |   4 +
 include/trace/events/afs.h                         |  67 +++++++-
 include/uapi/asm-generic/socket.h                  |   2 +
 kernel/bpf/verifier.c                              |   2 +
 kernel/dma/ops_helpers.c                           |  12 +-
 kernel/time/posix-cpu-timers.c                     |  10 +-
 kernel/time/timer.c                                |   8 +-
 kernel/trace/ring_buffer.c                         |  28 +++-
 kernel/trace/trace.c                               |   4 +
 kernel/trace/trace_events_hist.c                   |  22 ++-
 kernel/trace/trace_synth.h                         |   2 +-
 kernel/tracepoint.c                                |   2 +-
 lib/Kconfig.debug                                  |   1 +
 mm/memblock.c                                      |   3 +-
 net/bpf/test_run.c                                 |   3 +
 net/caif/caif_socket.c                             |   3 +-
 net/core/dev.c                                     | 107 +++++++++---
 net/core/skbuff.c                                  |  12 ++
 net/core/skmsg.c                                   |  16 +-
 net/core/sock.c                                    |   9 +
 net/decnet/af_decnet.c                             |  27 ++-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/ipv4/tcp_fastopen.c                            |  28 +++-
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/udp_bpf.c                                 |   2 +-
 net/ipv6/ip6_output.c                              |   4 +-
 net/ipv6/route.c                                   |   2 +-
 net/mptcp/syncookies.c                             |  16 +-
 net/netrom/nr_timer.c                              |  20 ++-
 net/sched/act_skbmod.c                             |  12 +-
 net/sched/cls_api.c                                |   2 +-
 net/sched/cls_tcindex.c                            |   5 +-
 net/sctp/auth.c                                    |   2 +
 net/sctp/socket.c                                  |   4 +
 sound/core/pcm_native.c                            |  25 ++-
 sound/hda/intel-dsp-config.c                       |   4 +
 sound/isa/sb/sb16_csp.c                            |   4 +
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/rt5631.c                          |   2 +
 sound/soc/codecs/wm_adsp.c                         |   2 +-
 sound/usb/mixer.c                                  |  10 +-
 sound/usb/quirks.c                                 |   3 +
 tools/bpf/bpftool/common.c                         |   5 +
 tools/perf/builtin-inject.c                        |  13 +-
 tools/perf/builtin-report.c                        |  33 ++--
 tools/perf/builtin-sched.c                         |  33 +++-
 tools/perf/builtin-script.c                        |   7 +
 tools/perf/tests/event_update.c                    |   2 +-
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
 tools/testing/selftests/vm/userfaultfd.c           |   6 +-
 167 files changed, 1515 insertions(+), 637 deletions(-)


