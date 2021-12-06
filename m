Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE75469E71
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359573AbhLFPix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379015AbhLFPgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E92BC07E5F9;
        Mon,  6 Dec 2021 07:22:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A00BB8111D;
        Mon,  6 Dec 2021 15:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A49C341C2;
        Mon,  6 Dec 2021 15:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804131;
        bh=NPKgSspk1v/AbKT8uwFLiIRMwX76bmHvdHU3cYfh1sc=;
        h=From:To:Cc:Subject:Date:From;
        b=K/aGOgYD8ylaMPRXRY4fOriZk/VqoJLH7SGrXYAqB0Ntxu44RCCs0jxjH425nt+qO
         h0DCZpRnQ10JUpWD4TIoftpIphxTVL9BzIWJHeQrGuvPLTut2rQjuK5ih0C6OZwpnS
         ZPx0jEjxpLEzuOSd68yd6uRPzzRCQl2HrUVUuWKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 000/207] 5.15.7-rc1 review
Date:   Mon,  6 Dec 2021 15:54:14 +0100
Message-Id: <20211206145610.172203682@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.7-rc1
X-KernelTest-Deadline: 2021-12-08T14:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.7 release.
There are 207 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.7-rc1

Wei Yongjun <weiyongjun1@huawei.com>
    ipmi: msghandler: Make symbol 'remove_work_wq' static

Johan Hovold <johan@kernel.org>
    serial: liteuart: fix minor-number leak on probe errors

Johan Hovold <johan@kernel.org>
    serial: liteuart: fix use-after-free and memleak on unbind

Ilia Sergachev <silia@ethz.ch>
    serial: liteuart: Fix NULL pointer dereference in ->remove()

Lukas Wunner <lukas@wunner.de>
    serial: 8250: Fix RTS modem control while in rs485 mode

Jay Dolan <jay.dolan@accesio.com>
    serial: 8250_pci: rewrite pericom_do_set_divisor()

Jay Dolan <jay.dolan@accesio.com>
    serial: 8250_pci: Fix ACCES entries in pci_serial_quirks array

Johan Hovold <johan@kernel.org>
    serial: core: fix transmit-buffer reset and memleak

Patrik John <patrik.john@u-blox.com>
    serial: tegra: Change lower tolerance baud rate limit for tegra20 and tegra30

Pierre Gondois <Pierre.Gondois@arm.com>
    serial: pl011: Add ACPI SBSA UART match id

Sven Eckelmann <sven@narfation.org>
    tty: serial: msm_serial: Deactivate RX DMA for polling support

Joerg Roedel <jroedel@suse.de>
    x86/64/mm: Map all kernel memory into trampoline_pgd

Feng Tang <feng.tang@intel.com>
    x86/tsc: Disable clocksource watchdog for TSC on qualified platorms

Feng Tang <feng.tang@intel.com>
    x86/tsc: Add a timer to make sure TSC_adjust is always checked

Zhou Qingyang <zhou1615@umn.edu>
    usb: cdnsp: Fix a NULL pointer dereference in cdnsp_endpoint_init()

Frank Li <Frank.Li@nxp.com>
    usb: cdns3: gadget: fix new urb never complete if ep cancel previous requests

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect

Ole Ernst <olebowle@gmx.com>
    USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Maciej W. Rozycki <macro@orcam.me.uk>
    vgacon: Propagate console boot parameters before calling `vc_resize'

Helge Deller <deller@gmx.de>
    parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Helge Deller <deller@gmx.de>
    parisc: Fix "make install" on newer debian releases

Helge Deller <deller@gmx.de>
    parisc: Fix KBUILD_IMAGE for self-extracting kernel

Al Cooper <alcooperx@gmail.com>
    serial: 8250_bcm7271: UART errors after resuming from S2

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: Sync TIR params updates against concurrent create/modify

Khalid Manaa <khalidm@nvidia.com>
    net/mlx5e: Rename TIR lro functions to TIR packet merge functions

Ben Ben-Ishay <benishay@nvidia.com>
    net/mlx5e: Rename lro_timeout to packet_merge_timeout

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Remove spurious TLB flushes in TDP MMU zap collapsible path

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Rename slot_handle_leaf to slot_handle_level_4k

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Return appropriate error codes if SEV-ES scratch setup fails

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix rq->uclamp_max not set on first enqueue

Andrew Halaney <ahalaney@redhat.com>
    preempt/dynamic: Fix setup_preempt_mode() return value

Lai Jiangshan <laijs@linux.alibaba.com>
    x86/xen: Add xenpv_restore_regs_and_return_to_usermode()

Lai Jiangshan <laijs@linux.alibaba.com>
    x86/entry: Use the correct fence macro after swapgs in kernel CR3

Lai Jiangshan <laijs@linux.alibaba.com>
    x86/entry: Add a fence for kernel entry SWAPGS in paranoid_entry()

Michael Sterritt <sterritt@google.com>
    x86/sev: Fix SEV-ES INS/OUTS instructions for word, dword, and qword

Jens Axboe <axboe@kernel.dk>
    io-wq: don't retry task_work creation failure on fatal conditions

José Roberto de Souza <jose.souza@intel.com>
    Revert "drm/i915: Implement Wa_1508744258"

Matt Johnston <matt@codeconstruct.com.au>
    mctp: Don't let RTM_DELROUTE delete local routes

Dan Carpenter <dan.carpenter@oracle.com>
    KVM: VMX: Set failure code in prepare_vmcs02()

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register

Dmytro Linkin <dlinkin@nvidia.com>
    net/mlx5: E-Switch, Check group pointer before reading bw_share value

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: E-Switch, fix single FDB creation on BlueField

Dmytro Linkin <dlinkin@nvidia.com>
    net/mlx5: E-switch, Respect BW share of the new group

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Move MODIFY_RQT command to ignore list in internal error state

Raed Salem <raeds@nvidia.com>
    net/mlx5e: Fix missing IPsec statistics on uplink representor

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SEV: initialize regions_list of a mirror VM

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Fix when shadow_root_level=5 && guest root_level<4

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iwlwifi: Fix memory leaks in error handling path

Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
    ASoC: rk817: Add module alias for rk817-codec

Rob Clark <robdclark@chromium.org>
    drm/msm: Restore error return on invalid fence

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix wait_fence submitqueue leak

Douglas Anderson <dianders@chromium.org>
    drm/msm: Fix mmap to include VM_IO and VM_DONTDUMP

Rob Clark <robdclark@chromium.org>
    drm/msm/devfreq: Fix OPP refcnt leak

Hou Wenlong <houwenlong93@linux.alibaba.com>
    KVM: x86/mmu: Pass parameter flush as false in kvm_tdp_mmu_zap_collapsible_sptes()

Hou Wenlong <houwenlong93@linux.alibaba.com>
    KVM: x86/mmu: Skip tlb flush if it has been done in zap_gfn_range()

Sameer Saurabh <ssaurabh@marvell.com>
    atlantic: Remove warn trace message.

Dmitry Bogdanov <dbezrukov@marvell.com>
    atlantic: Fix statistics logic for production hardware

Sameer Saurabh <ssaurabh@marvell.com>
    Remove Half duplex mode speed capabilities.

Nikita Danilov <ndanilov@aquantia.com>
    atlantic: Add missing DIDs and fix 115c.

Sameer Saurabh <ssaurabh@marvell.com>
    atlantic: Fix to display FW bundle version instead of FW mac version.

Nikita Danilov <ndanilov@aquantia.com>
    atlatnic: enable Nbase-t speeds with base-t

Dmitry Bogdanov <dbezrukov@marvell.com>
    atlantic: Increase delay for fw transactions

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: kms: Fix previous HVS commit wait

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: kms: Don't duplicate pending commit

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: kms: Clear the HVS FIFO commit pointer once done

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: kms: Add missing drm_crtc_commit_put

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: kms: Fix return code check

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: kms: Wait for the commit before increasing our clock rate

Rob Clark <robdclark@chromium.org>
    drm/msm: Do hw_init() before capturing GPU state

Douglas Anderson <dianders@chromium.org>
    drm/msm/a6xx: Allocate enough space for GMU registers

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Keep smc_close_final rc during active close

William Kucharski <william.kucharski@oracle.com>
    net/rds: correct socket tunable error in rds_tcp_tune()

Dust Li <dust.li@linux.alibaba.com>
    net/smc: fix wrong list_del in smc_lgr_cleanup_early

Eric Dumazet <edumazet@google.com>
    ipv4: convert fib_num_tclassid_users to atomic_t

Eric Dumazet <edumazet@google.com>
    net: annotate data-races on txq->xmit_lock_owner

Zhou Qingyang <zhou1615@umn.edu>
    octeontx2-af: Fix a memleak bug in rvu_mbox_init()

Dongliang Mu <mudongliangabcd@gmail.com>
    dpaa2-eth: destroy workqueue at the end of remove function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: marvell: mvpp2: Fix the computation of shared CPUs

Sven Schuchmann <schuchmann@schleissheimer.de>
    net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Vincent Whitchurch <vincent.whitchurch@axis.com>
    net: stmmac: Avoid DMA_CHAN_CONTROL write if no Split Header support

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: intel-dsp-config: add quirk for CML devices based on ES8336 codec

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in AHUB

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in DSPK

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in DMIC

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in I2S

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in ADMAIF

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix wrong value type in DSPK

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix wrong value type in DMIC

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix wrong value type in I2S

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix wrong value type in ADMAIF

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: fix NULL pointer dereference in mt7915_get_phy_mode

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Add SPI ID table

Li Zhijian <lizhijian@cn.fujitsu.com>
    selftests: net: Correct case name

Zhou Qingyang <zhou1615@umn.edu>
    net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()

Raed Salem <raeds@nvidia.com>
    net/mlx5e: IPsec: Fix Software parser inner l3 type setting in case of encapsulation

Łukasz Bartosik <lb@semihalf.com>
    iwlwifi: fix warnings produced by kernel debug options

Mark Rutland <mark.rutland@arm.com>
    arm64: ftrace: add missing BTIs

Arnd Bergmann <arnd@arndb.de>
    siphash: use _unaligned version by default

Benjamin Poirier <bpoirier@nvidia.com>
    net: mpls: Fix notifications when deleting a device

Zhou Qingyang <zhou1615@umn.edu>
    net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()

Paolo Abeni <pabeni@redhat.com>
    tcp: fix page frag corruption on page fault

Randy Dunlap <rdunlap@infradead.org>
    natsemi: xtensa: fix section mismatch warnings

Aaro Koskinen <aaro.koskinen@iki.fi>
    i2c: cbus-gpio: set atomic transfer callback

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: stop dma transfer in case of NACK

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: recover the bus on access timeout

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: flush TX FIFO upon transfer errors

Gustavo A. R. Silva <gustavoars@kernel.org>
    wireguard: ratelimiter: use kvcalloc() instead of kvzalloc()

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: receive: drop handshakes if queue lock is contended

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: receive: use ring buffer for incoming handshakes

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: device: reset peer src endpoint when netns exits

Li Zhijian <lizhijian@cn.fujitsu.com>
    wireguard: selftests: rename DEBUG_PI_LIST to DEBUG_PLIST

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: actually test for routing loops

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: allowedips: add missing __rcu annotation to satisfy sparse

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: increase default dmesg log size

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Fix inband AN for 2500base-x on 88E6393X family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Add fix for erratum 5.2 of 88E6393X family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and receiver

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Drop unnecessary check in mv88e6393x_serdes_erratum_4_6()

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing/histograms: String compares should not care about signed values

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: check PIR even for vCPUs with disabled APICv

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Use vcpu->arch.walk_mmu for kvm_mmu_invlpg()

Catalin Marinas <catalin.marinas@arm.com>
    KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1

Paolo Bonzini <pbonzini@redhat.com>
    KVM: MMU: shadow nested paging does not have PKU

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Use a stable condition around all VT-d PI paths

Paolo Bonzini <pbonzini@redhat.com>
    KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Abide to KVM_REQ_TLB_FLUSH_GUEST request on nested vmentry/vmexit

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Emulate guest TLB flush on nested VM-Enter with new vpid12

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: ignore APICv if LAPIC is not enabled

Sean Christopherson <seanjc@google.com>
    KVM: Ensure local memslot copies operate on up-to-date arch-specific data

Ben Gardon <bgardon@google.com>
    KVM: x86/mmu: Fix TLB flush range when handling disconnected pt

Sean Christopherson <seanjc@google.com>
    KVM: Disallow user memslot with size that exceeds "unsigned long"

Paolo Bonzini <pbonzini@redhat.com>
    KVM: fix avic_set_running for preemptable kernels

Lyude Paul <lyude@redhat.com>
    drm/i915/dp: Perform 30ms delay after source OUI write

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Allow DSC on supported MST branch devices

msizanoen1 <msizanoen@qtmlabs.xyz>
    ipv6: fix memory leak in fib6_rule_suppress

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Add support for Intel ADL

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix non-recovery of remote ports following an unsolicited LOGO

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl

Linus Torvalds <torvalds@linux-foundation.org>
    fget: check that the fd still exists after getting a ref to it

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: move pseudo-MMIO to prevent MIO overlap

Guangming <Guangming.Cao@mediatek.com>
    dma-buf: system_heap: Use 'for_each_sgtable_sg' in pages free flow

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: mvm: retry init flow if failed

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    cpufreq: Fix get_cpu_device() failure in add_cpu_dev_symlink()

Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
    ipmi: Move remove_work to dedicated workqueue

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: do not mark device gone on EPROTO errors during start

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/cs8409: Set PMSG_ON earlier inside cs8409 driver

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Limit max data_size of the kretprobe instances

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    net/tls: Fix authentication failure in CCM mode

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: Add stubs for wakeup handler functions

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Avoid warning of possible recursive locking

Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
    tracing: Don't use out-of-sync va_list in event printing

Ian Rogers <irogers@google.com>
    perf report: Fix memory leaks around perf_tip()

Ian Rogers <irogers@google.com>
    perf hist: Fix memory leak of a perf_hpp_fmt

German Gomez <german.gomez@arm.com>
    perf inject: Fix ARM SPE handling

Namhyung Kim <namhyung@kernel.org>
    perf sort: Fix the 'p_stage_cyc' sort key behavior

Namhyung Kim <namhyung@kernel.org>
    perf sort: Fix the 'ins_lat' sort key behavior

Namhyung Kim <namhyung@kernel.org>
    perf sort: Fix the 'weight' sort key behavior

Teng Qi <starmiku1207184332@gmail.com>
    net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

zhangyue <zhangyue1@kylinos.cn>
    net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

Jordy Zomer <jordy@pwning.systems>
    ipv6: check return value of ipv6_skip_exthdr

Teng Qi <starmiku1207184332@gmail.com>
    ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()

Mario Limonciello <mario.limonciello@amd.com>
    ata: libahci: Adjust behavior when StorageD3Enable _DSD is set

Mario Limonciello <mario.limonciello@amd.com>
    ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile

Bernard Zhao <bernard@vivo.com>
    drm/amd/amdgpu: fix potential memleak

shaoyunl <shaoyun.liu@amd.com>
    drm/amd/amdkfd: Fix kernel panic when reset failed and been triggered again

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Remove artificial freq level on Navi1x

Aaron Ma <aaron.ma@canonical.com>
    net: usb: r8152: Add MAC passthrough support for more Lenovo Docks

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Unblock session then wake up error handler

Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>
    thermal: core: Reset previous low and high trip during thermal zone init

Wang Yugui <wangyugui@e16-tech.com>
    btrfs: check-integrity: fix a warning on write caching disabled disk

Filipe Manana <fdmanana@suse.com>
    btrfs: silence lockdep when reading chunk tree during mount

Vasily Gorbik <gor@linux.ibm.com>
    s390/setup: avoid using memblock_enforce_memory_limit

Slark Xiao <slark_xiao@163.com>
    platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

Jimmy Wang <jimmy221b@163.com>
    platform/x86: thinkpad_acpi: Add support for dual fan control

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: dell-wmi-descriptor: disable by default

Julian Braha <julianbraha@gmail.com>
    pinctrl: qcom: fix unmet dependencies on GPIOLIB for GPIOLIB_IRQCHIP

liuguoqiang <liuguoqiang@uniontech.com>
    net: return correct error code

Zekun Shen <bruceshenzk@gmail.com>
    atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Transfer remaining wait queue entries during fallback

Sean Christopherson <seanjc@google.com>
    x86/hyperv: Move required MSRs check to initial platform probing

Felix Fietkau <nbd@nbd.name>
    mac80211: fix throughput LED trigger

Xing Song <xing.song@mediatek.com>
    mac80211: do not access the IV when it was stripped

Julian Braha <julianbraha@gmail.com>
    drm/sun4i: fix unmet dependency on RESET_CONTROLLER for PHY_SUN6I_MIPI_DPHY

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pseries/ddw: Do not try direct mapping with persistent memory and one window

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pseries/ddw: Revert "Extend upper limit for huge DMA window for persistent memory"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix length of holes reported at end-of-file

Bob Peterson <rpeterso@redhat.com>
    gfs2: release iopen glock early in evict

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't start stream for capture at prepare

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Switch back to non-latency mode at a later point

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Less restriction for low-latency playback mode

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix packet size calculation regression

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid killing in-flight URBs during draining

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Improved lowlatency playback support

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add spinlock to stop_urbs()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check available frames for the next packet size

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Disable low-latency mode for implicit feedback sync

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Disable low-latency playback for free-wheel mode

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Rename early_playback_start flag with lowlatency_playback

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Restrict rates for the shared clocks


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/kernel/entry-ftrace.S                   |   6 +
 arch/parisc/Makefile                               |   5 +
 arch/parisc/install.sh                             |   1 +
 arch/parisc/kernel/time.c                          |  30 +--
 arch/powerpc/platforms/pseries/iommu.c             |  15 +-
 arch/s390/include/asm/pci_io.h                     |   7 +-
 arch/s390/kernel/setup.c                           |   3 -
 arch/x86/entry/entry_64.S                          |  35 ++-
 arch/x86/hyperv/hv_init.c                          |   9 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  20 +-
 arch/x86/kernel/sev.c                              |  57 ++--
 arch/x86/kernel/tsc.c                              |  28 +-
 arch/x86/kernel/tsc_sync.c                         |  41 +++
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  37 +--
 arch/x86/kvm/mmu/tdp_mmu.c                         |  36 +--
 arch/x86/kvm/mmu/tdp_mmu.h                         |   5 +-
 arch/x86/kvm/svm/avic.c                            |  16 +-
 arch/x86/kvm/svm/pmu.c                             |   2 +-
 arch/x86/kvm/svm/sev.c                             |  31 ++-
 arch/x86/kvm/svm/svm.c                             |   1 -
 arch/x86/kvm/vmx/nested.c                          |  49 ++--
 arch/x86/kvm/vmx/posted_intr.c                     |  20 +-
 arch/x86/kvm/vmx/vmx.c                             |  62 +++--
 arch/x86/kvm/x86.c                                 |  46 +++-
 arch/x86/kvm/x86.h                                 |   7 +-
 arch/x86/realmode/init.c                           |  12 +-
 arch/x86/xen/xen-asm.S                             |  20 ++
 drivers/ata/ahci.c                                 |   1 +
 drivers/ata/libahci.c                              |  15 ++
 drivers/ata/sata_fsl.c                             |  20 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  13 +-
 drivers/cpufreq/cpufreq.c                          |   9 +-
 drivers/dma-buf/heaps/system_heap.c                |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c           |   1 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   5 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  20 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |  13 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   3 +
 drivers/gpu/drm/i915/display/intel_dp.c            |  11 +
 drivers/gpu/drm/i915/display/intel_dp.h            |   2 +
 .../gpu/drm/i915/display/intel_dp_aux_backlight.c  |   5 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |   7 -
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |   4 +-
 drivers/gpu/drm/msm/msm_debugfs.c                  |   1 +
 drivers/gpu/drm/msm/msm_drv.c                      |  49 ++--
 drivers/gpu/drm/msm/msm_gem.c                      |   3 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   1 +
 drivers/gpu/drm/msm/msm_gpu.h                      |   3 +
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |   5 +
 drivers/gpu/drm/sun4i/Kconfig                      |   1 +
 drivers/gpu/drm/vc4/vc4_kms.c                      |  40 ++-
 drivers/i2c/busses/i2c-cbus-gpio.c                 |   5 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  31 ++-
 drivers/net/dsa/b53/b53_spi.c                      |  14 +
 drivers/net/dsa/mv88e6xxx/serdes.c                 | 252 +++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h                 |   4 +
 drivers/net/ethernet/aquantia/atlantic/aq_common.h |  27 +-
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h     |   2 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  10 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   7 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |   3 -
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c        |  25 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |   3 -
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c   |  22 +-
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h   |   2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h      |  38 ++-
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c   | 110 ++++++--
 drivers/net/ethernet/dec/tulip/de4x5.c             |  34 ++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   2 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   4 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  21 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c   |  23 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.h   |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |  66 ++++-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c   |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.h   |   6 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  24 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  46 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   7 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  11 +-
 drivers/net/usb/lan78xx.c                          |   2 +-
 drivers/net/usb/r8152.c                            |   9 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/wireguard/allowedips.c                 |   2 +-
 drivers/net/wireguard/device.c                     |  39 +--
 drivers/net/wireguard/device.h                     |   9 +-
 drivers/net/wireguard/queueing.c                   |   6 +-
 drivers/net/wireguard/queueing.h                   |   2 +-
 drivers/net/wireguard/ratelimiter.c                |   4 +-
 drivers/net/wireguard/receive.c                    |  39 +--
 drivers/net/wireguard/socket.c                     |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   6 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  22 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   5 +
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   3 +
 drivers/pinctrl/qcom/Kconfig                       |   2 +
 drivers/platform/x86/dell/Kconfig                  |   2 +-
 drivers/platform/x86/thinkpad_acpi.c               |  13 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   9 +-
 drivers/scsi/scsi_transport_iscsi.c                |   6 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |  18 ++
 drivers/thermal/thermal_core.c                     |   2 +
 drivers/tty/serial/8250/8250_bcm7271.c             |  13 +
 drivers/tty/serial/8250/8250_pci.c                 |  39 ++-
 drivers/tty/serial/8250/8250_port.c                |   7 -
 drivers/tty/serial/amba-pl011.c                    |   1 +
 drivers/tty/serial/liteuart.c                      |  20 +-
 drivers/tty/serial/msm_serial.c                    |   3 +
 drivers/tty/serial/serial-tegra.c                  |   4 +-
 drivers/tty/serial/serial_core.c                   |  18 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |  20 +-
 drivers/usb/cdns3/cdnsp-mem.c                      |   3 +
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/host/xhci-ring.c                       |  21 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   4 -
 drivers/video/console/vgacon.c                     |  14 +-
 fs/btrfs/disk-io.c                                 |  14 +-
 fs/btrfs/volumes.c                                 |  18 +-
 fs/file.c                                          |   4 +
 fs/gfs2/bmap.c                                     |   2 +-
 fs/gfs2/super.c                                    |  14 +-
 fs/io-wq.c                                         |   7 +
 include/linux/acpi.h                               |   9 +
 include/linux/kprobes.h                            |   2 +
 include/linux/mlx5/mlx5_ifc.h                      |   8 +-
 include/linux/netdevice.h                          |  19 +-
 include/linux/siphash.h                            |  14 +-
 include/net/dst_cache.h                            |  11 +
 include/net/fib_rules.h                            |   4 +-
 include/net/ip_fib.h                               |   2 +-
 include/net/netns/ipv4.h                           |   2 +-
 include/net/sock.h                                 |  13 +-
 kernel/kprobes.c                                   |   3 +
 kernel/sched/core.c                                |   6 +-
 kernel/trace/trace.c                               |  12 +
 kernel/trace/trace_events_hist.c                   |   2 +-
 lib/siphash.c                                      |  12 +-
 net/core/dev.c                                     |   5 +-
 net/core/dst_cache.c                               |  19 ++
 net/core/fib_rules.c                               |   2 +-
 net/ipv4/devinet.c                                 |   2 +-
 net/ipv4/fib_frontend.c                            |   2 +-
 net/ipv4/fib_rules.c                               |   5 +-
 net/ipv4/fib_semantics.c                           |   4 +-
 net/ipv6/esp6.c                                    |   6 +
 net/ipv6/fib6_rules.c                              |   4 +-
 net/mac80211/led.h                                 |   8 +-
 net/mac80211/rx.c                                  |  10 +-
 net/mac80211/tx.c                                  |  34 ++-
 net/mctp/route.c                                   |   9 +-
 net/mpls/af_mpls.c                                 |  68 +++--
 net/rds/tcp.c                                      |   2 +-
 net/rxrpc/conn_client.c                            |  14 +-
 net/rxrpc/peer_object.c                            |  14 +-
 net/smc/af_smc.c                                   |  14 +
 net/smc/smc_close.c                                |   8 +-
 net/smc/smc_core.c                                 |   7 +-
 net/tls/tls_sw.c                                   |   4 +-
 sound/hda/intel-dsp-config.c                       |  10 +
 sound/pci/hda/hda_local.h                          |   9 +
 sound/pci/hda/patch_cs8409.c                       |   5 +
 sound/soc/codecs/rk817_codec.c                     |   1 +
 sound/soc/tegra/tegra186_dspk.c                    | 181 ++++++++++---
 sound/soc/tegra/tegra210_admaif.c                  | 140 +++++++---
 sound/soc/tegra/tegra210_ahub.c                    |  11 +-
 sound/soc/tegra/tegra210_dmic.c                    | 184 ++++++++++---
 sound/soc/tegra/tegra210_i2s.c                     | 296 ++++++++++++++++-----
 sound/usb/card.h                                   |  10 +-
 sound/usb/endpoint.c                               | 223 +++++++++++-----
 sound/usb/endpoint.h                               |  13 +-
 sound/usb/pcm.c                                    | 165 +++++++++---
 tools/perf/builtin-report.c                        |  15 +-
 tools/perf/ui/hist.c                               |  28 +-
 tools/perf/util/arm-spe.c                          |  15 ++
 tools/perf/util/hist.c                             |  23 +-
 tools/perf/util/hist.h                             |   1 -
 tools/perf/util/sort.c                             |  52 ++--
 tools/perf/util/sort.h                             |   6 +-
 tools/perf/util/util.c                             |  14 +-
 tools/perf/util/util.h                             |   2 +-
 tools/testing/selftests/net/fcnal-test.sh          |   4 +-
 tools/testing/selftests/wireguard/netns.sh         |  30 ++-
 .../testing/selftests/wireguard/qemu/debug.config  |   2 +-
 .../testing/selftests/wireguard/qemu/kernel.config |   1 +
 virt/kvm/kvm_main.c                                |  50 ++--
 207 files changed, 2854 insertions(+), 1215 deletions(-)


