Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489C3579A90
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbiGSMPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239530AbiGSMOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:14:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C82952FC7;
        Tue, 19 Jul 2022 05:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C2676165C;
        Tue, 19 Jul 2022 12:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE88C341C6;
        Tue, 19 Jul 2022 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232339;
        bh=/5EmyQ8xGgRq4SnzKnG5rkyv5seW2+6wdnFsn1gOmNs=;
        h=From:To:Cc:Subject:Date:From;
        b=PIEzZ8X7+wRUdQ9EgODO1LSsW8Redq+eZ1rLv6h2wLX2085FxIG/JVQqOwTT+CRWF
         Cm2df6KwLe0gN++YiqbINrpN8ETDnXGyitfWlK5GVd7r0XcUHha1ZvC3Wr2nJ2E3tG
         fYQXuEDLsyIzicM4lji5u9nxYdy58Fni+rBcKfv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/112] 5.10.132-rc1 review
Date:   Tue, 19 Jul 2022 13:52:53 +0200
Message-Id: <20220719114626.156073229@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.132-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.132-rc1
X-KernelTest-Deadline: 2022-07-21T11:46+00:00
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

This is the start of the stable review cycle for the 5.10.132 release.
There are 112 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.132-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.132-rc1

Juergen Gross <jgross@suse.com>
    x86/pat: Fix x86_has_pat_wp()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Fix PM usage_count for console handover

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: stm32: Clear prev values before setting RTS delays

Yi Yang <yiyang13@huawei.com>
    serial: 8250: fix return error code in serial8250_request_std_resource()

Yangxi Xiang <xyangxi5@gmail.com>
    vt: fix memory overlapping when deleting chars in the buffer

Chanho Park <chanho61.park@samsung.com>
    tty: serial: samsung_tty: set dma burst_size to 1

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix event pending check

Linyu Yuan <quic_linyyuan@quicinc.com>
    usb: typec: add missing uevent when partner support PD

Lucien Buchmann <lucien.buchmann@gmx.net>
    USB: serial: ftdi_sio: add Belimo device ids

Linus Torvalds <torvalds@linux-foundation.org>
    signal handling: don't use BUG_ON() for debugging

Keith Busch <kbusch@kernel.org>
    nvme-pci: phison e16 has bogus namespace ids

Srinivas Neeli <srinivas.neeli@xilinx.com>
    Revert "can: xilinx_can: Limit CANFD brp to 2"

Gabriel Fernandez <gabriel.fernandez@foss.st.com>
    ARM: dts: stm32: use the correct clock source for CEC on stm32mp151

Linus Walleij <linus.walleij@linaro.org>
    soc: ixp4xx/npe: Fix unused match warning

Juergen Gross <jgross@suse.com>
    x86: Clear .brk area at early boot

Stafford Horne <shorne@gmail.com>
    irqchip: or1k-pic: Undefine mask_ack for level triggered hardware

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: madera: Fix event generation for rate controls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: madera: Fix event generation for OUT1 demux

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs47l15: Fix event generation for low power mux control

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Initialise kcontrol data for mux/demux controls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm5110: Fix DRE control

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-loader: Clarify the cl_dsp_init() flow

Haowen Bai <baihaowen@meizu.com>
    pinctrl: aspeed: Fix potential NULL dereference in aspeed_pinmux_set_mux()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix off by one in range control validation

Jianglei Nie <niejianglei2021@163.com>
    net: sfp: fix memory leak in sfp_probe()

Ruozhu Li <liruozhu@huawei.com>
    nvme: fix regression when disconnect a recovering ctrl

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: always fail a request when sending it failed

Michael Walle <michael@walle.cc>
    NFC: nxp-nci: don't print header length mismatch on i2c error

Hangyu Hua <hbh25y@gmail.com>
    net: tipc: fix possible refcount leak in tipc_sk_create()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    platform/x86: hp-wmi: Ignore Sanitization Mode event

Liang He <windhl@126.com>
    cpufreq: pmac32-cpufreq: Fix refcount leak bug

John Garry <john.garry@huawei.com>
    scsi: hisi_sas: Limit max hw sectors for v3 HW

Florian Westphal <fw@strlen.de>
    netfilter: br_netfilter: do not skip all hooks with 0 priority

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    virtio_mmio: Restore guest page size on resume

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    virtio_mmio: Add missing PM calls to freeze/restore

Muchun Song <songmuchun@bytedance.com>
    mm: sysctl: fix missing numa_stat when !CONFIG_HUGETLB_PAGE

Tariq Toukan <tariqt@nvidia.com>
    net/tls: Check for errors in tls_device_init

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    net: atlantic: remove aq_nic_deinit() when resume

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    net: atlantic: remove deep parameter on suspend/resume functions

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix kernel panic when creating VF

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: bpf: fix skb checksum in bpf_push_seg6_encap()

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix skb checksum evaluation in SRH encapsulation/insertion

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix use after free when disabling sriov

Jianglei Nie <niejianglei2021@163.com>
    ima: Fix potential memory leak in ima_init_crypto()

Coiby Xu <coxu@redhat.com>
    ima: force signature verification when CONFIG_KEXEC_SIG is configured

Liang He <windhl@126.com>
    net: ftgmac100: Hold reference returned by of_get_child_by_name()

Kuniyuki Iwashima <kuniyu@amazon.com>
    nexthop: Fix data-races around nexthop_compat_mode.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix data-races around sysctl_ip_dynaddr.

Kuniyuki Iwashima <kuniyu@amazon.com>
    raw: Fix a data-race around sysctl_raw_l3mdev_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix a data-race around sysctl_icmp_ratemask.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix a data-race around sysctl_icmp_ratelimit.

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data-races in proc_dointvec_ms_jiffies().

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Serialize TLB invalidates with GT resets

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/selftests: fix a couple IS_ERR() vs NULL tests

Michal Suchanek <msuchanek@suse.de>
    ARM: dts: sunxi: Fix SPI NOR campatible on Orange Pi Zero

Ryan Wanner <Ryan.Wanner@microchip.com>
    ARM: dts: at91: sama5d2: Fix typo in i2s1 node

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix a data-race around sysctl_fib_sync_mem.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix data-races around sysctl.

Kuniyuki Iwashima <kuniyu@amazon.com>
    cipso: Fix data-races around sysctl.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_mem.

Kuniyuki Iwashima <kuniyu@amazon.com>
    inetpeer: Fix data-races around sysctl.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_max_orphans.

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data races in proc_dointvec_jiffies().

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data races in proc_doulongvec_minmax().

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data races in proc_douintvec_minmax().

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data races in proc_dointvec_minmax().

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data races in proc_douintvec().

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data races in proc_dointvec().

Jon Hunter <jonathanh@nvidia.com>
    net: stmmac: dwc-qos: Disable split header for Tegra194

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: Intel: Skylake: Correct the handling of fmt_config flexible array

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: Intel: Skylake: Correct the ssp rate discovery in skl_get_ssp_clks()

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Fix amp gain register offset & default

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Correct playback volume range

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Fix and extend FSYNC polarity handling

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Add post reset delays

Francesco Dolcini <francesco.dolcini@toradex.com>
    ASoC: sgtl5000: Fix noise on shutdown/remove

Huaxin Lu <luhuaxin1@huawei.com>
    ima: Fix a potential integer overflow in ima_appraise_measurement

Hangyu Hua <hbh25y@gmail.com>
    drm/i915: fix a possible refcount leak in intel_dp_add_mst_connector()

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix capability check for updating vnic env counters

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: kTLS, Fix build time constant test in RX

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: kTLS, Fix build time constant test in TX

Zhen Lei <thunder.leizhen@huawei.com>
    ARM: 9210/1: Mark the FDT_FIXED sections as shareable

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    spi: amd: Limit max transfer and message size

Kris Bahnsen <kris@embeddedTS.com>
    ARM: dts: imx6qdl-ts7970: Fix ngpio typo and count

Baokun Li <libaokun1@huawei.com>
    ext4: fix race condition between ext4_write and ext4_convert_inline_data

Xiu Jianfeng <xiujianfeng@huawei.com>
    Revert "evm: Fix memleak in init_desc"

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: convert nommu io{re,un}map() to static inline functions

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix incorrect masking of permission flags for symlinks

Dave Chinner <dchinner@redhat.com>
    fs/remap: constrain dedupe of EOF blocks

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/panfrost: Fix shrinker list corruption by madvise IOCTL

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/panfrost: Put mapping instead of shmem obj on panfrost_mmu_map_fault_addr() error

Filipe Manana <fdmanana@suse.com>
    btrfs: return -EAGAIN for NOWAIT dio reads/writes on compressed and inline extents

Tejun Heo <tj@kernel.org>
    cgroup: Use separate src/dst nodes when preloading css_sets for migration

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix queue selection for mesh/OCB interfaces

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9214/1: alignment: advance IT state after emulating Thumb instruction

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    ARM: 9213/1: Print message about disabled Spectre workarounds only once

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip: fix dflt addr selection for connected nexthop

Steven Rostedt (Google) <rostedt@goodmis.org>
    net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/histograms: Fix memory leak problem

Gowans, James <jgowans@amazon.com>
    mm: split huge PUD on wp_huge_pud fallback

Oleg Nesterov <oleg@redhat.com>
    fix race between exit_itimers() and /proc/pid/timers

Juergen Gross <jgross@suse.com>
    xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc221

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/realtek: Fix headset mic for Acer SF313-51

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/conexant: Apply quirk for another HP ProDesk 600 G3 model

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda - Add fixup for Dell Latitidue E5430


-------------

Diffstat:

 Documentation/networking/ip-sysctl.rst             |  4 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/imx6qdl-ts7970.dtsi              |  2 +-
 arch/arm/boot/dts/sama5d2.dtsi                     |  2 +-
 arch/arm/boot/dts/stm32mp151.dtsi                  |  2 +-
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts  |  2 +-
 arch/arm/include/asm/mach/map.h                    |  1 +
 arch/arm/include/asm/ptrace.h                      | 26 +++++++++++
 arch/arm/mm/alignment.c                            |  3 ++
 arch/arm/mm/mmu.c                                  | 15 +++++-
 arch/arm/mm/proc-v7-bugs.c                         |  9 ++--
 arch/arm/probes/decode.h                           | 26 +----------
 arch/sh/include/asm/io.h                           |  8 +++-
 arch/x86/kernel/head64.c                           |  2 +
 arch/x86/kernel/ima_arch.c                         |  2 +
 arch/x86/kvm/x86.c                                 | 18 ++++----
 arch/x86/mm/init.c                                 | 14 +++++-
 drivers/cpufreq/pmac32-cpufreq.c                   |  4 ++
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |  1 +
 drivers/gpu/drm/i915/gt/intel_gt.c                 | 15 +++++-
 drivers/gpu/drm/i915/gt/selftest_lrc.c             |  8 ++--
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  4 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |  2 +-
 drivers/irqchip/irq-or1k-pic.c                     |  1 -
 drivers/net/can/xilinx_can.c                       |  4 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   | 23 ++++------
 drivers/net/ethernet/faraday/ftgmac100.c           | 15 +++++-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  2 +-
 drivers/net/ethernet/sfc/ef10.c                    |  3 ++
 drivers/net/ethernet/sfc/ef10_sriov.c              | 10 ++--
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |  1 +
 drivers/net/phy/sfp.c                              |  2 +-
 drivers/net/xen-netback/rx.c                       |  1 +
 drivers/nfc/nxp-nci/i2c.c                          |  8 +++-
 drivers/nvme/host/core.c                           |  2 +
 drivers/nvme/host/nvme.h                           |  1 +
 drivers/nvme/host/pci.c                            |  3 +-
 drivers/nvme/host/rdma.c                           | 12 +++--
 drivers/nvme/host/tcp.c                            | 13 ++++--
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |  4 +-
 drivers/platform/x86/hp-wmi.c                      |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  7 +++
 drivers/soc/ixp4xx/ixp4xx-npe.c                    |  2 +-
 drivers/spi/spi-amd.c                              |  8 ++++
 drivers/tty/serial/8250/8250_core.c                |  4 ++
 drivers/tty/serial/8250/8250_port.c                |  4 +-
 drivers/tty/serial/amba-pl011.c                    | 23 +++++++++-
 drivers/tty/serial/samsung_tty.c                   |  5 +-
 drivers/tty/serial/serial_core.c                   |  5 --
 drivers/tty/serial/stm32-usart.c                   |  2 +
 drivers/tty/vt/vt.c                                |  2 +-
 drivers/usb/dwc3/gadget.c                          |  4 +-
 drivers/usb/serial/ftdi_sio.c                      |  3 ++
 drivers/usb/serial/ftdi_sio_ids.h                  |  6 +++
 drivers/usb/typec/class.c                          |  1 +
 drivers/virtio/virtio_mmio.c                       | 26 +++++++++++
 fs/btrfs/inode.c                                   | 14 +++++-
 fs/exec.c                                          |  2 +-
 fs/ext4/extents.c                                  |  9 ++--
 fs/ext4/inode.c                                    |  9 ----
 fs/nilfs2/nilfs.h                                  |  3 ++
 fs/remap_range.c                                   |  3 +-
 include/linux/cgroup-defs.h                        |  3 +-
 include/linux/kexec.h                              |  6 +++
 include/linux/sched/task.h                         |  2 +-
 include/linux/serial_core.h                        |  5 ++
 include/net/raw.h                                  |  2 +-
 include/net/sock.h                                 |  2 +-
 include/net/tls.h                                  |  4 +-
 include/trace/events/sock.h                        |  6 ++-
 kernel/cgroup/cgroup.c                             | 37 +++++++++------
 kernel/exit.c                                      |  2 +-
 kernel/kexec_file.c                                | 11 ++++-
 kernel/signal.c                                    |  8 ++--
 kernel/sysctl.c                                    | 53 ++++++++++++----------
 kernel/time/posix-timers.c                         | 19 ++++++--
 kernel/trace/trace_events_hist.c                   |  2 +
 mm/memory.c                                        | 27 +++++------
 net/bridge/br_netfilter_hooks.c                    | 21 +++++++--
 net/core/filter.c                                  |  1 -
 net/ipv4/af_inet.c                                 |  4 +-
 net/ipv4/cipso_ipv4.c                              | 12 +++--
 net/ipv4/fib_semantics.c                           |  4 +-
 net/ipv4/fib_trie.c                                |  2 +-
 net/ipv4/icmp.c                                    | 10 ++--
 net/ipv4/inetpeer.c                                | 12 +++--
 net/ipv4/nexthop.c                                 |  5 +-
 net/ipv4/tcp.c                                     |  3 +-
 net/ipv6/route.c                                   |  2 +-
 net/ipv6/seg6_iptunnel.c                           |  5 +-
 net/ipv6/seg6_local.c                              |  2 -
 net/mac80211/wme.c                                 |  4 +-
 net/tipc/socket.c                                  |  1 +
 net/tls/tls_device.c                               |  4 +-
 net/tls/tls_main.c                                 |  7 ++-
 security/integrity/evm/evm_crypto.c                |  7 +--
 security/integrity/ima/ima_appraise.c              |  3 +-
 security/integrity/ima/ima_crypto.c                |  1 +
 sound/pci/hda/patch_conexant.c                     |  1 +
 sound/pci/hda/patch_realtek.c                      | 16 +++++++
 sound/soc/codecs/cs47l15.c                         |  5 +-
 sound/soc/codecs/madera.c                          | 14 ++++--
 sound/soc/codecs/sgtl5000.c                        |  9 ++++
 sound/soc/codecs/sgtl5000.h                        |  1 +
 sound/soc/codecs/tas2764.c                         | 46 +++++++++++--------
 sound/soc/codecs/tas2764.h                         |  6 +--
 sound/soc/codecs/wm5110.c                          |  8 +++-
 sound/soc/intel/skylake/skl-nhlt.c                 | 40 ++++++++++------
 sound/soc/soc-dapm.c                               |  5 ++
 sound/soc/soc-ops.c                                |  4 +-
 sound/soc/sof/intel/hda-loader.c                   |  8 ++--
 113 files changed, 604 insertions(+), 288 deletions(-)


