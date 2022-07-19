Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEC4579BA8
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbiGSMaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240545AbiGSM3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:29:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036636A9CF;
        Tue, 19 Jul 2022 05:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9857A616F8;
        Tue, 19 Jul 2022 12:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBDFC341C6;
        Tue, 19 Jul 2022 12:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232679;
        bh=HdiADg9IDjn01JE0MSYU6x7oZ4fj0icwC+Gu+KSL6ag=;
        h=From:To:Cc:Subject:Date:From;
        b=mZH5wgQ2j1T11AXWmDbjDFG7FJB2JVA2IxCCHN+wNeL7Tt/1f0NF3Fssf5ns28Zmc
         /P4Hp4+BTodpk98bfTtgpZjdygNWJ8Ii6ZheQqm4d85IpRdgYEgexsIUa9sdR60whR
         DaGXjAXPiXOBIe0S16fJ3bxolm/cjeSgp3QiN+JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/167] 5.15.56-rc1 review
Date:   Tue, 19 Jul 2022 13:52:12 +0200
Message-Id: <20220719114656.750574879@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.56-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.56-rc1
X-KernelTest-Deadline: 2022-07-21T11:47+00:00
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

This is the start of the stable review cycle for the 5.15.56 release.
There are 167 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.56-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.56-rc1

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

Egor Vorontsov <sdoregor@sdore.me>
    ALSA: usb-audio: Add quirk for Fiero SC-01 (fw v1.0.0)

Egor Vorontsov <sdoregor@sdore.me>
    ALSA: usb-audio: Add quirk for Fiero SC-01

John Veness <john-linux@pelago.org.uk>
    ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices

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

Shuming Fan <shumingf@realtek.com>
    ASoC: rt711-sdca: fix kernel NULL pointer dereference when IO error

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm5110: Fix DRE control

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_wm5102: Fix GPIO related probe-ordering problem

Mark Brown <broonie@kernel.org>
    ASoC: wcd938x: Fix event generation for some controls

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-loader: Clarify the cl_dsp_init() flow

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: codecs: rt700/rt711/rt711-sdca: initialize workqueues in probe

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt7*-sdw: harden jack_detect_handler

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt711: fix calibrate mutex initialization

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: handle errors on card registration

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: rt711-sdca-sdw: fix calibrate mutex initialization

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove

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

Javier Martinez Canillas <javierm@redhat.com>
    fbdev: Disable sysfb device registration when removing conflicting FBs

Javier Martinez Canillas <javierm@redhat.com>
    firmware: sysfb: Add sysfb_disable() helper function

Javier Martinez Canillas <javierm@redhat.com>
    firmware: sysfb: Make sysfb_create_simplefb() return a pdev pointer

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

Parav Pandit <parav@nvidia.com>
    vduse: Tie vduse mgmtdev and its device

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Initialize CVQ vringh only once

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/xive/spapr: correct bitmap allocation size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use SOCK_NONBLOCK type for kernel_accept()

Christoph Hellwig <hch@lst.de>
    btrfs: zoned: fix a leaked bioc in read_zone_info

Qu Wenruo <wqu@suse.com>
    btrfs: rename btrfs_bio to btrfs_io_context

Muchun Song <songmuchun@bytedance.com>
    mm: sysctl: fix missing numa_stat when !CONFIG_HUGETLB_PAGE

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Fix acpi_video_handles_brightness_key_presses()

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

Jeff Layton <jlayton@kernel.org>
    ceph: switch netfs read ops to use rreq->inode instead of rreq->mapping->host

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix use after free when disabling sriov

Yefim Barashkin <mr.b34r@kolabnow.com>
    drm/amd/pm: Prevent divide by zero

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Only use depth 36 bpp linebuffers on DCN display engines.

Jianglei Nie <niejianglei2021@163.com>
    ima: Fix potential memory leak in ima_init_crypto()

Coiby Xu <coxu@redhat.com>
    ima: force signature verification when CONFIG_KEXEC_SIG is configured

Dan Carpenter <dan.carpenter@oracle.com>
    net: stmmac: fix leaks in probe

Liang He <windhl@126.com>
    net: ftgmac100: Hold reference returned by of_get_child_by_name()

Kuniyuki Iwashima <kuniyu@amazon.com>
    nexthop: Fix data-races around nexthop_compat_mode.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix data-races around sysctl_ip_dynaddr.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_ecn_fallback.

Kuniyuki Iwashima <kuniyu@amazon.com>
    raw: Fix a data-race around sysctl_raw_l3mdev_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix a data-race around sysctl_icmp_ratemask.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix a data-race around sysctl_icmp_ratelimit.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix a data-race around sysctl_icmp_errors_use_inbound_ifaddr.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix a data-race around sysctl_icmp_ignore_bogus_error_responses.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix data-races around sysctl_icmp_echo_enable_probe.

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data-races in proc_dointvec_ms_jiffies().

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data-races in proc_dou8vec_minmax().

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Fix bnxt_refclk_read()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix bnxt_reinit_after_abort() code path

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/i915: Require the vm mutex for i915_vma_bind()

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915/uc: correctly track uc_fw init failure

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Serialize TLB invalidates with GT resets

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Serialize GRDOM access between multiple engine resets

Bruce Chang <yu.bruce.chang@intel.com>
    drm/i915/dg2: Add Wa_22011100796

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/selftests: fix a couple IS_ERR() vs NULL tests

Douglas Anderson <dianders@chromium.org>
    tracing: Fix sleeping while atomic in kdb ftdump

Jeff Layton <jlayton@kernel.org>
    lockd: fix nlm_close_files

Jeff Layton <jlayton@kernel.org>
    lockd: set fl_owner when unlocking files

Demi Marie Obenour <demi@invisiblethingslab.com>
    xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/gvt: IS_ERR() vs NULL bug in intel_gvt_update_reg_whitelist()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: replace BUG_ON by element length check

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_log: incorrect offset to network header

William Zhang <william.zhang@broadcom.com>
    arm64: dts: broadcom: bcm4908: Fix cpu node for smp boot

William Zhang <william.zhang@broadcom.com>
    arm64: dts: broadcom: bcm4908: Fix timer node for BCM4906 SoC

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

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw: Fix devlink port register sequence

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

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Ring the TX doorbell on DMA errors

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix capability check for updating vnic env counters

Paul Blakey <paulb@nvidia.com>
    net/mlx5e: Fix enabling sriov while tc nic rules are offloaded

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

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    reset: Fix devm bulk optional exclusive control getter

Dave Chinner <dchinner@redhat.com>
    xfs: drop async cache flushes from CIL commits.

Dave Chinner <dchinner@redhat.com>
    xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks

Darrick J. Wong <djwong@kernel.org>
    xfs: don't include bnobt blocks when reserving free block pool

Darrick J. Wong <djwong@kernel.org>
    xfs: only run COW extent recovery when there are no live extents

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

Axel Rasmussen <axelrasmussen@google.com>
    mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages

Oleg Nesterov <oleg@redhat.com>
    fix race between exit_itimers() and /proc/pid/timers

Juergen Gross <jgross@suse.com>
    xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc221

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP machines

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

 .../driver-api/firmware/other_interfaces.rst       |   6 +
 Documentation/networking/ip-sysctl.rst             |   4 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl-ts7970.dtsi              |   2 +-
 arch/arm/boot/dts/sama5d2.dtsi                     |   2 +-
 arch/arm/boot/dts/stm32mp151.dtsi                  |   2 +-
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts  |   2 +-
 arch/arm/include/asm/mach/map.h                    |   1 +
 arch/arm/include/asm/ptrace.h                      |  26 ++
 arch/arm/mm/alignment.c                            |   3 +
 arch/arm/mm/mmu.c                                  |  15 +-
 arch/arm/mm/proc-v7-bugs.c                         |   9 +-
 arch/arm/probes/decode.h                           |  26 +-
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi  |   8 +
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi  |   2 +
 arch/powerpc/sysdev/xive/spapr.c                   |   5 +-
 arch/sh/include/asm/io.h                           |   8 +-
 arch/x86/kernel/head64.c                           |   2 +
 arch/x86/kvm/x86.c                                 |  18 +-
 arch/x86/mm/init.c                                 |  14 +-
 drivers/acpi/acpi_video.c                          |  11 +-
 drivers/cpufreq/pmac32-cpufreq.c                   |   4 +
 drivers/firmware/sysfb.c                           |  58 ++++-
 drivers/firmware/sysfb_simplefb.c                  |  16 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  11 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   2 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |  50 +++-
 drivers/gpu/drm/i915/gt/intel_gt.c                 |  15 +-
 drivers/gpu/drm/i915/gt/intel_reset.c              |  44 +++-
 drivers/gpu/drm/i915/gt/selftest_lrc.c             |   8 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c          |   2 +-
 drivers/gpu/drm/i915/gt/uc/intel_huc.c             |   2 +-
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c           |   4 +-
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h           |  17 +-
 drivers/gpu/drm/i915/gvt/cmd_parser.c              |   6 +-
 drivers/gpu/drm/i915/i915_vma.c                    |   1 +
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   4 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   2 +-
 drivers/irqchip/irq-or1k-pic.c                     |   1 -
 drivers/net/can/xilinx_can.c                       |   4 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  23 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  13 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  15 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  39 ++-
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   5 +-
 drivers/net/ethernet/sfc/ef10.c                    |   3 +
 drivers/net/ethernet/sfc/ef10_sriov.c              |  10 +-
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ingenic.c    |   6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  17 +-
 drivers/net/phy/sfp.c                              |   2 +-
 drivers/net/xen-netback/rx.c                       |   1 +
 drivers/nfc/nxp-nci/i2c.c                          |   8 +-
 drivers/nvme/host/core.c                           |   2 +
 drivers/nvme/host/nvme.h                           |   1 +
 drivers/nvme/host/pci.c                            |   3 +-
 drivers/nvme/host/rdma.c                           |  12 +-
 drivers/nvme/host/tcp.c                            |  13 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |   4 +-
 drivers/platform/x86/hp-wmi.c                      |   3 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   7 +
 drivers/soc/ixp4xx/ixp4xx-npe.c                    |   2 +-
 drivers/spi/spi-amd.c                              |   8 +
 drivers/tty/serial/8250/8250_core.c                |   4 +
 drivers/tty/serial/8250/8250_port.c                |   4 +-
 drivers/tty/serial/amba-pl011.c                    |  23 +-
 drivers/tty/serial/samsung_tty.c                   |   5 +-
 drivers/tty/serial/serial_core.c                   |   5 -
 drivers/tty/serial/stm32-usart.c                   |   2 +
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/usb/dwc3/gadget.c                          |   4 +-
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   6 +
 drivers/usb/typec/class.c                          |   1 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  31 ++-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  60 +++--
 drivers/video/fbdev/core/fbmem.c                   |  12 +
 drivers/virtio/virtio_mmio.c                       |  26 ++
 drivers/xen/gntdev.c                               |   6 +-
 fs/btrfs/check-integrity.c                         |   2 +-
 fs/btrfs/extent-tree.c                             |  19 +-
 fs/btrfs/extent_io.c                               |  18 +-
 fs/btrfs/extent_map.c                              |   4 +-
 fs/btrfs/inode.c                                   |  14 +-
 fs/btrfs/raid56.c                                  | 127 +++++-----
 fs/btrfs/raid56.h                                  |   8 +-
 fs/btrfs/reada.c                                   |  26 +-
 fs/btrfs/scrub.c                                   | 115 +++++----
 fs/btrfs/volumes.c                                 | 267 ++++++++++-----------
 fs/btrfs/volumes.h                                 |  38 ++-
 fs/btrfs/zoned.c                                   |  25 +-
 fs/ceph/addr.c                                     |   6 +-
 fs/exec.c                                          |   2 +-
 fs/ksmbd/transport_tcp.c                           |   2 +-
 fs/lockd/svcsubs.c                                 |  14 +-
 fs/nilfs2/nilfs.h                                  |   3 +
 fs/remap_range.c                                   |   3 +-
 fs/xfs/xfs_bio_io.c                                |  35 ---
 fs/xfs/xfs_fsops.c                                 |   2 +-
 fs/xfs/xfs_linux.h                                 |   2 -
 fs/xfs/xfs_log.c                                   |  58 ++---
 fs/xfs/xfs_log_cil.c                               |  42 +---
 fs/xfs/xfs_log_priv.h                              |   3 +-
 fs/xfs/xfs_log_recover.c                           |  24 +-
 fs/xfs/xfs_mount.c                                 |  12 +-
 fs/xfs/xfs_mount.h                                 |  15 ++
 fs/xfs/xfs_reflink.c                               |   5 +-
 fs/xfs/xfs_super.c                                 |   9 -
 include/linux/cgroup-defs.h                        |   3 +-
 include/linux/kexec.h                              |   6 +
 include/linux/reset.h                              |   2 +-
 include/linux/sched/task.h                         |   2 +-
 include/linux/serial_core.h                        |   5 +
 include/linux/sysfb.h                              |  22 +-
 include/net/netfilter/nf_tables.h                  |  14 +-
 include/net/raw.h                                  |   2 +-
 include/net/sock.h                                 |   2 +-
 include/net/tls.h                                  |   4 +-
 include/trace/events/sock.h                        |   6 +-
 kernel/cgroup/cgroup.c                             |  37 +--
 kernel/exit.c                                      |   2 +-
 kernel/kexec_file.c                                |  11 +-
 kernel/signal.c                                    |   8 +-
 kernel/sysctl.c                                    |  57 +++--
 kernel/time/posix-timers.c                         |  19 +-
 kernel/trace/trace.c                               |  11 +-
 kernel/trace/trace_events_hist.c                   |   2 +
 mm/memory.c                                        |  27 ++-
 mm/userfaultfd.c                                   |   5 +-
 net/bridge/br_netfilter_hooks.c                    |  21 +-
 net/core/filter.c                                  |   1 -
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv4/cipso_ipv4.c                              |  12 +-
 net/ipv4/fib_semantics.c                           |   4 +-
 net/ipv4/fib_trie.c                                |   2 +-
 net/ipv4/icmp.c                                    |  16 +-
 net/ipv4/inetpeer.c                                |  12 +-
 net/ipv4/nexthop.c                                 |   5 +-
 net/ipv4/sysctl_net_ipv4.c                         |   6 +
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/icmp.c                                    |   2 +-
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/seg6_iptunnel.c                           |   5 +-
 net/ipv6/seg6_local.c                              |   2 -
 net/mac80211/wme.c                                 |   4 +-
 net/netfilter/nf_log_syslog.c                      |   8 +-
 net/netfilter/nf_tables_api.c                      |  72 ++++--
 net/tipc/socket.c                                  |   1 +
 net/tls/tls_device.c                               |   4 +-
 net/tls/tls_main.c                                 |   7 +-
 security/integrity/evm/evm_crypto.c                |   7 +-
 security/integrity/ima/ima_appraise.c              |   3 +-
 security/integrity/ima/ima_crypto.c                |   1 +
 security/integrity/ima/ima_efi.c                   |   2 +
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_realtek.c                      |  20 ++
 sound/soc/codecs/cs47l15.c                         |   5 +-
 sound/soc/codecs/madera.c                          |  14 +-
 sound/soc/codecs/max98373-sdw.c                    |  12 +-
 sound/soc/codecs/rt1308-sdw.c                      |  11 +
 sound/soc/codecs/rt1316-sdw.c                      |  11 +
 sound/soc/codecs/rt5682-sdw.c                      |   5 +-
 sound/soc/codecs/rt700-sdw.c                       |   6 +-
 sound/soc/codecs/rt700.c                           |  14 +-
 sound/soc/codecs/rt711-sdca-sdw.c                  |   9 +-
 sound/soc/codecs/rt711-sdca.c                      |  18 +-
 sound/soc/codecs/rt711-sdw.c                       |   9 +-
 sound/soc/codecs/rt711.c                           |  16 +-
 sound/soc/codecs/rt715-sdca-sdw.c                  |  12 +
 sound/soc/codecs/rt715-sdw.c                       |  12 +
 sound/soc/codecs/sgtl5000.c                        |   9 +
 sound/soc/codecs/sgtl5000.h                        |   1 +
 sound/soc/codecs/tas2764.c                         |  46 ++--
 sound/soc/codecs/tas2764.h                         |   6 +-
 sound/soc/codecs/wcd938x.c                         |  12 +
 sound/soc/codecs/wm5110.c                          |   8 +-
 sound/soc/intel/boards/bytcr_wm5102.c              |  13 +-
 sound/soc/intel/boards/sof_sdw.c                   |  51 ++--
 sound/soc/intel/skylake/skl-nhlt.c                 |  40 ++-
 sound/soc/soc-dapm.c                               |   5 +
 sound/soc/soc-ops.c                                |   4 +-
 sound/soc/sof/intel/hda-loader.c                   |   8 +-
 sound/usb/quirks-table.h                           | 248 +++++++++++++++++++
 sound/usb/quirks.c                                 |   9 +
 190 files changed, 1872 insertions(+), 943 deletions(-)


