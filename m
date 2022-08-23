Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F4859DBFB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353355AbiHWKRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353362AbiHWKPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:15:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E4272FE9;
        Tue, 23 Aug 2022 02:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DEF3B81C28;
        Tue, 23 Aug 2022 09:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E75C433D6;
        Tue, 23 Aug 2022 09:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245220;
        bh=+zceuIB6el/O21QOGCOIhx1OEvOVzEkdAGtZ7vCbyog=;
        h=From:To:Cc:Subject:Date:From;
        b=YcHs2fIu1w24Fzn0l+Vs56vwPR6Cvykj3X/GJKbxeODo1/5oK2Y06arrh5N5JJpSJ
         sfzpxmx9uwI1MsYyLNBC3GRNKmi2olSzXYGTFb5AkOEKMKu3umoK1EAtrlJWCUcKKZ
         pJz3EDiSyuE2ezasq+5lxDkFNCOBMNyfkY782e5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 000/287] 4.19.256-rc1 review
Date:   Tue, 23 Aug 2022 10:22:49 +0200
Message-Id: <20220823080100.268827165@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.256-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.256-rc1
X-KernelTest-Deadline: 2022-08-25T08:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.256 release.
There are 287 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.256-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.256-rc1

Qu Wenruo <wqu@suse.com>
    btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

Qu Wenruo <wqu@suse.com>
    btrfs: only write the sectors in the vertical stripe which has data stripes

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/probes: Have kprobes and uprobes use $COMM too

Jens Wiklander <jens.wiklander@linaro.org>
    tee: add overflow check in register_shm_helper()

Nathan Chancellor <nathan@kernel.org>
    MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: i740fb: Check the argument of i740_calc_vclk()

Zhouyi Zhou <zhouzhouyi@gmail.com>
    powerpc/64: Init jump labels before parse_early_param()

Steve French <stfrench@microsoft.com>
    smb3: check xattr value length earlier

Chao Yu <chao.yu@oppo.com>
    f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Use deferred fasync helper

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Add async signal helpers

Laurent Dufour <ldufour@linux.ibm.com>
    watchdog: export lockup_detector_reconfigure

Xianting Tian <xianting.tian@linux.alibaba.com>
    RISC-V: Add fast call path of crash_kexec()

Celeste Liu <coelacanthus@outlook.com>
    riscv: mmap with PROT_WRITE but no PROT_READ is invalid

Liang He <windhl@126.com>
    mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start

Schspa Shi <schspa@gmail.com>
    vfio: Clear the caps->buf to NULL after free

Liang He <windhl@126.com>
    tty: serial: Fix refcount leak bug in ucc_uart.c

Guenter Roeck <linux@roeck-us.net>
    lib/list_debug.c: Detect uninitialized lists

Kiselev, Oleg <okiselev@amazon.com>
    ext4: avoid resizing to a partial cluster size

Ye Bin <yebin10@huawei.com>
    ext4: avoid remove directory when directory is corrupted

Wentao_Liang <Wentao_Liang_g@163.com>
    drivers:md:fix a potential use-after-free bug

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    dmaengine: sprd: Cleanup in .remove() after pm_runtime_get_sync() failed

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    cxl: Fix a memory leak in an error handling path

Jozef Martiniak <jomajm@gmail.com>
    gadgetfs: ep_io - wait until IRQ finishes

Robert Marko <robimarko@gmail.com>
    clk: qcom: ipq8074: dont disable gcc_sleep_clk_src

Pascal Terjan <pterjan@google.com>
    vboxguest: Do not use devm for irq

Liang He <windhl@126.com>
    usb: renesas: Fix refcount leak bug

Liang He <windhl@126.com>
    usb: host: ohci-ppc-of: Fix refcount leak bug

Sai Prakash Ranjan <quic_saipraka@quicinc.com>
    irqchip/tegra: Fix overflow implicit truncation warnings

Pavan Chebbi <pavan.chebbi@broadcom.com>
    PCI: Add ACS quirk for Broadcom BCM5750x NICs

Liang He <windhl@126.com>
    drm/meson: Fix refcount bugs in meson_vpu_has_available_connectors()

Hector Martin <marcan@marcan.st>
    locking/atomic: Make test_and_*_bit() ordered on failure

Andrew Donnellan <ajd@linux.ibm.com>
    gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin disabled for a file

Lin Ma <linma@zju.edu.cn>
    igb: Add lock to avoid data race

Csókás Bence <csokas.bence@prolan.hu>
    fec: Fix timer capture timing in `fec_ptp_enable_pps()`

Alan Brady <alan.brady@intel.com>
    i40e: Fix to stop tx_timeout recovery if GLOBR fails

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pci: Fix get_phb_number() locking

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: really skip inactive sets when allocating name

Al Viro <viro@zeniv.linux.org.uk>
    nios2: add force_successful_syscall_return()

Al Viro <viro@zeniv.linux.org.uk>
    nios2: restarts apply only to the first sigframe we build...

Al Viro <viro@zeniv.linux.org.uk>
    nios2: fix syscall restart checks

Al Viro <viro@zeniv.linux.org.uk>
    nios2: traced syscall does need to check the syscall number

Al Viro <viro@zeniv.linux.org.uk>
    nios2: don't leave NULLs in sys_call_table[]

Al Viro <viro@zeniv.linux.org.uk>
    nios2: page fault et.al. are *not* restartable syscalls...

Duoming Zhou <duoming@zju.edu.cn>
    atm: idt77252: fix use-after-free bugs caused by tst_timer

Dan Carpenter <dan.carpenter@oracle.com>
    xen/xenbus: fix return type in xenbus_file_read()

Dan Carpenter <dan.carpenter@oracle.com>
    NTB: ntb_tool: uninitialized heap data in tool_fn_write()

Roberto Sassu <roberto.sassu@huawei.com>
    tools build: Switch to new openssl API for test-libcrypto

Peilin Ye <peilin.ye@bytedance.com>
    vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()

Peilin Ye <peilin.ye@bytedance.com>
    vsock: Fix memory leak in vsock_connect()

Matthias May <matthias.may@westermo.com>
    geneve: do not use RT_TOS for IPv6 flowlabel

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Return type of acpi_add_nondev_subnodes() should be bool

Nikita Travkin <nikita@trvn.ru>
    pinctrl: qcom: msm8916: Allow CAMSS GP clocks to be muxed

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Reinitialise the backchannel request buffers before reuse

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Fix a use-after-free bug in open

Zhang Xianwei <zhang.xianwei8@zte.com.cn>
    NFSv4.1: RECLAIM_COMPLETE must handle EACCES

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix races in the legacy idmapper upcall

Xiu Jianfeng <xiujianfeng@huawei.com>
    apparmor: Fix memleak in aa_simple_write_to_buffer()

Xin Xiong <xiongx18@fudan.edu.cn>
    apparmor: fix reference count leak in aa_pivotroot()

John Johansen <john.johansen@canonical.com>
    apparmor: fix overlapping attachment computation

Tom Rix <trix@redhat.com>
    apparmor: fix aa_label_asxprint return check

John Johansen <john.johansen@canonical.com>
    apparmor: Fix failed mount permission check error message

John Johansen <john.johansen@canonical.com>
    apparmor: fix absroot causing audited secids to begin with =

John Johansen <john.johansen@canonical.com>
    apparmor: fix quiet_denied for file rules

Marc Kleine-Budde <mkl@pengutronix.de>
    can: ems_usb: fix clang's -Wunaligned-access warning

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have filter accept "common_cpu" to be consistent

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error handling when looking up extended ref on log replay

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: pxamci: Fix an error handling path in pxamci_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: pxamci: Fix another error handling path in pxamci_probe()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata-eh: Add missing command name

Mikulas Patocka <mpatocka@redhat.com>
    rds: add missing barrier to release_refill

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: info: Fix llseek return value when using callback

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/mm: Split dump_pagelinuxtables flag_array table

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails

Jamal Hadi Salim <jhs@mojatatu.com>
    net_sched: cls_route: disallow handle of 0

Tyler Hicks <tyhicks@linux.microsoft.com>
    net/9p: Initialize the iounit field during fid creation

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Jose Alonso <joalonsof@gmail.com>
    Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Tony Battersby <tonyb@cybernetics.com>
    scsi: sg: Allow waiting for commands to complete on removed device

Eric Dumazet <edumazet@google.com>
    tcp: fix over estimation in sk_forced_mem_schedule()

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Add infrastructure and macro to mark VM as bugged

Qu Wenruo <wqu@suse.com>
    btrfs: reject log replay if there is unsupported RO compat flag

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    net_sched: cls_route: remove from list when handle is 0

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: CPPC: Do not prevent CPPC from working in the future

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: set a default MAX_WRITEBACK_JOBS

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix address sanitizer warning in raid_status

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix address sanitizer warning in raid_resume

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Meteor Lake-P support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Raptor Lake-S PCH support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Raptor Lake-S CPU support

Baokun Li <libaokun1@huawei.com>
    ext4: correct the misjudgment in ext4_iget_extra_inode

Baokun Li <libaokun1@huawei.com>
    ext4: correct max_inline_xattr_value_size computing

Eric Whitney <enwlinux@gmail.com>
    ext4: fix extent status tree race in writeback error recovery path

Theodore Ts'o <tytso@mit.edu>
    ext4: update s_overhead_clusters in the superblock during an on-line resize

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_xattr_set_entry

Lukas Czerner <lczerner@redhat.com>
    ext4: make sure ext4_append() always allocates new block

Baokun Li <libaokun1@huawei.com>
    ext4: add EXT4_INODE_HAS_XATTR_SPACE macro in xattr.h

David Collins <quic_collinsd@quicinc.com>
    spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

Alexander Lobakin <alexandr.lobakin@intel.com>
    x86/olpc: fix 'logical not is only applied to the left hand side'

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Fix missing auto port scan and thus missing target ports

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: s3fb: Check the size of screen before memset_io()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: arkfb: Check the size of screen before memset_io()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: vt8623fb: Check the size of screen before memset_io()

Florian Fainelli <f.fainelli@gmail.com>
    tools/thermal: Fix possible path truncations

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: arkfb: Fix a divide-by-zero bug in ark_set_pixclock()

Siddh Raman Pant <code@siddh.me>
    x86/numa: Use cpumask_available instead of hardcoded NULL check

Josh Poimboeuf <jpoimboe@kernel.org>
    scripts/faddr2line: Fix vmlinux detection on arm64

Arnaldo Carvalho de Melo <acme@redhat.com>
    genelf: Use HAVE_LIBCRYPTO_SUPPORT, not the never defined HAVE_LIBCRYPTO

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pci: Fix PHB numbering when using opal-phbid

Chen Zhongjin <chenzhongjin@huawei.com>
    kprobes: Forbid probing on trampoline and BPF code areas

Miaoqian Lin <linmq006@gmail.com>
    powerpc/cell/axon_msi: Fix refcount leak in setup_msi_msg_address

Miaoqian Lin <linmq006@gmail.com>
    powerpc/xive: Fix refcount leak in xive_get_max_prio

Miaoqian Lin <linmq006@gmail.com>
    powerpc/spufs: Fix refcount leak in spufs_init_isolated_loader

Pali Rohár <pali@kernel.org>
    powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32

Rustam Subkhankulov <subkhankulov@ispras.ru>
    video: fbdev: sis: fix typos in SiS_GetModeID()

Liang He <windhl@126.com>
    video: fbdev: amba-clcd: Fix refcount leak bugs

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: qcom: q6dsp: Fix an off-by-one in q6adm_alloc_copp()

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/zcore: fix race when reading from hardware system area

Liang He <windhl@126.com>
    iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mfd: t7l66xb: Drop platform disable callback

Dan Carpenter <dan.carpenter@oracle.com>
    kfifo: fix kfifo_to_user() return type

Miaoqian Lin <linmq006@gmail.com>
    rpmsg: qcom_smd: Fix refcount leak in qcom_smd_parse_edge

Sam Protsenko <semen.protsenko@linaro.org>
    iommu/exynos: Handle failed IOMMU device registration properly

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing corner cases in gsmld_poll()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix DM command

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong T1 retry count handling

Eric Farman <farman@linux.ibm.com>
    vfio/ccw: Do not change FSM state in subchannel event

Sireesh Kodali <sireeshkodali1@gmail.com>
    remoteproc: qcom: wcnss: Fix handling of IRQs

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix race condition in gsmld_write()

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix packet re-transmission without open control channel

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix non flow control frames during mux flow off

Chen Zhongjin <chenzhongjin@huawei.com>
    profiling: fix shift too large makes kernel panic

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dw: Store LSR into lsr_saved_flags in dw8250_tx_wait_empty()

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: mt8173-rt5650: Fix refcount leak in mt8173_rt5650_dev_probe

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: codecs: da7210: add check for i2c_add_driver

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mt6797-mt6351: Fix refcount leak in mt6797_mt6351_dev_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: mt8173: Fix refcount leak in mt8173_rt5650_rt5676_dev_probe

Zhihao Cheng <chengzhihao1@huawei.com>
    jbd2: fix assertion 'jh->b_frozen_data == NULL' failure when journal aborted

Li Lingfeng <lilingfeng3@huawei.com>
    ext4: recover csum seed of tmp_inode after migrating to extents

Dan Carpenter <dan.carpenter@oracle.com>
    null_blk: fix ida error handling in null_add_dev()

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix error unwind in rxe_create_qp()

Miaohe Lin <linmiaohe@huawei.com>
    mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region

Dan Carpenter <dan.carpenter@oracle.com>
    platform/olpc: Fix uninitialized data in debugfs write

Johan Hovold <johan@kernel.org>
    USB: serial: fix tty-port initialized comments

Artem Borisov <dedsa2002@gmail.com>
    HID: alps: Declare U1_UNICORN_LEGACY support

Liang He <windhl@126.com>
    mmc: cavium-thunderx: Add of_node_put() when breaking out of loop

Liang He <windhl@126.com>
    mmc: cavium-octeon: Add of_node_put() when breaking out of loop

Liang He <windhl@126.com>
    gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()

Jianglei Nie <niejianglei2021@163.com>
    RDMA/hfi1: fix potential memory leak in setup_base_ctxt()

Randy Dunlap <rdunlap@infradead.org>
    usb: gadget: udc: amd5536 depends on HAS_DMA

Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>
    scsi: smartpqi: Fix DMA direction for RAID requests

Stefan Roese <sr@denx.de>
    PCI/portdrv: Don't disable AER reporting in get_port_device_capability()

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: fix set_uhs_signaling rewriting of MC1R

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick/ms_block: Fix a memory leak

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick/ms_block: Fix some incorrect memory allocation

Miaoqian Lin <linmq006@gmail.com>
    mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch

Duoming Zhou <duoming@zju.edu.cn>
    staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: bus_type: fix remove and shutdown support

Robert Marko <robimarko@gmail.com>
    clk: qcom: ipq8074: set BRANCH_HALT_DELAY flag for UBI clocks

Robert Marko <robimarko@gmail.com>
    clk: qcom: ipq8074: fix NSS port frequency tables

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    misc: rtsx: Fix an error handling path in rtsx_pci_probe()

Miaoqian Lin <linmq006@gmail.com>
    usb: ohci-nxp: Fix refcount leak in ohci_hcd_nxp_probe

Miaoqian Lin <linmq006@gmail.com>
    usb: host: Fix refcount leak in ehci_hcd_ppc_of_probe

Marco Pagani <marpagan@redhat.com>
    fpga: altera-pr-ip: fix unsigned comparison with less than zero

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()'s error path

Duoming Zhou <duoming@zju.edu.cn>
    mtd: sm_ftl: Fix deadlock caused by cancel_work_sync in sm_release

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    HID: cp2112: prevent a buffer overflow in cp2112_xfer()

Miaoqian Lin <linmq006@gmail.com>
    mtd: maps: Fix refcount leak in ap_flash_init

Miaoqian Lin <linmq006@gmail.com>
    mtd: maps: Fix refcount leak in of_flash_probe_versatile

Ralph Siemsen <ralph.siemsen@linaro.org>
    clk: renesas: r9a06g032: Fix UART clkgrp bitsel

Hangyu Hua <hbh25y@gmail.com>
    dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock

Eric Dumazet <edumazet@google.com>
    net: rose: fix netdev reference changes

Jakub Kicinski <kuba@kernel.org>
    netdevsim: Avoid allocation warnings triggered from user space

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS

Hangyu Hua <hbh25y@gmail.com>
    wifi: libertas: Fix possible refcount leak in if_usb_probe()

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`

Liang He <windhl@126.com>
    i2c: mux-gpmux: Add of_node_put() when breaking out of loop

Lars-Peter Clausen <lars@metafoo.de>
    i2c: cadence: Support PEC for SMBus block read

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    Bluetooth: hci_intel: Add check for platform_driver_register

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: pch_can: pch_can_error(): initialize errc before using it

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: error: specify the values of data[5..7] of CAN error frames

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: usb_8dev: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: kvaser_usb_hydra: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: sun4i_can: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: hi311x: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: sja1000: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: rcar_can: do not report txerr and rxerr during bus-off

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: pch_can: do not report txerr and rxerr during bus-off

Rustam Subkhankulov <subkhankulov@ispras.ru>
    wifi: p54: add missing parentheses in p54_flush()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: p54: Fix an error handling path in p54spi_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()

Jason A. Donenfeld <Jason@zx2c4.com>
    fs: check FMODE_LSEEK to control internal pipe splicing

Wolfram Sang <wsa+renesas@sang-engineering.com>
    selftests: timers: clocksource-switch: fix passing errors from child

Wolfram Sang <wsa+renesas@sang-engineering.com>
    selftests: timers: valid-adjtimex: build fix for newer toolchains

Anquan Wu <leiqi96@hotmail.com>
    libbpf: Fix the name of a reused map

Yonglong Li <liyonglong@chinatelecom.cn>
    tcp: make retransmitted SKB fit into the send window

Liang He <windhl@126.com>
    mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: hisilicon - Kunpeng916 crypto driver don't sleep when in softirq

Rob Clark <robdclark@chromium.org>
    drm/msm/mdp5: Fix global state lock backoff

Hangyu Hua <hbh25y@gmail.com>
    drm: bridge: sii8620: fix possible off-by-one

Bo-Chen Chen <rex-bc.chen@mediatek.com>
    drm/mediatek: dpi: Remove output format of YUV

Brian Norris <briannorris@chromium.org>
    drm/rockchip: vop: Don't crash for invalid duplicate_state()

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dsi: Correct DSI divider calculations

Niels Dossche <dossche.niels@gmail.com>
    media: hdpvr: fix error value returns in hdpvr_read

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm: bridge: adv7511: Add check for mipi_dsi_driver_register

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()

Pavel Skripkin <paskripkin@gmail.com>
    ath9k: fix use-after-free in ath9k_hif_usb_rx_cb

Zheyu Ma <zheyuma97@gmail.com>
    media: tw686x: Register the irq at the end of probe

Xu Wang <vulab@iscas.ac.cn>
    i2c: Fix a potential use after free

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: Add pull-down MIPI operation in mtk_dsi_poweroff function

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    drm/radeon: fix potential buffer overflow in ni_set_mc_special_registers()

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ath10k: do not enforce interrupt trigger type

Mike Snitzer <snitzer@kernel.org>
    dm: return early from dm_pr_call() if DM device is suspended

Markus Mayer <mmayer@broadcom.com>
    thermal/tools/tmon: Include pthread and time headers in tmon.h

Nicolas Saenz Julienne <nsaenzju@redhat.com>
    nohz/full, sched/rt: Fix missed tick-reenabling bug in dequeue_task_rt()

Liang He <windhl@126.com>
    regulator: of: Fix refcount leak bug in of_get_regulation_constraints()

Sireesh Kodali <sireeshkodali1@gmail.com>
    arm64: dts: qcom: msm8916: Fix typo in pronto remoteproc node

Yang Yingliang <yangyingliang@huawei.com>
    bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: qcom: pm8841: add required thermal-sensor-cells

Miaoqian Lin <linmq006@gmail.com>
    cpufreq: zynq: Fix refcount leak in zynq_get_revision

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init

Michael Walle <michael@walle.cc>
    soc: fsl: guts: machine variable might be unset

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: ast2500-evb: fix board compatible

Johan Hovold <johan@kernel.org>
    x86/pmem: Fix platform-device leak in error path

Miaoqian Lin <linmq006@gmail.com>
    ARM: bcm: Fix refcount leak in bcm_kona_smc_init

Miaoqian Lin <linmq006@gmail.com>
    meson-mx-socinfo: Fix refcount leak in meson_mx_socinfo_init

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: findbit: fix overflowing offset

Xiu Jianfeng <xiujianfeng@huawei.com>
    selinux: Add boundary check in put_entry()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    PM: hibernate: defer device probing when resuming from hibernation

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: fix NAND node name

huhai <huhai@kylinos.cn>
    ACPI: LPSS: Fix missing check in register_device_clock()

Manyi Li <limanyi@uniontech.com>
    ACPI: PM: save NVS memory for Lenovo G40-45

Hans de Goede <hdegoede@redhat.com>
    ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks

Liang He <windhl@126.com>
    ARM: OMAP2+: display: Fix refcount leak bug

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: fix qspi node compatible

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: fix lcdif node compatible

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: change operating-points to uint32-matrix

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6ul: add missing properties for sram

Jan Kara <jack@suse.cz>
    ext2: Add more validity checks for inode counts

haibinzhang (张海斌) <haibinzhang@tencent.com>
    arm64: fix oops in concurrently setting insn_emulation sysctls

Francis Laniel <flaniel@linux.microsoft.com>
    arm64: Do not forget syscall when starting a new thread.

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix null deref due to zeroed list head

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    netfilter: nf_tables: do not allow SET_ID to refer to another table

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    USB: HCD: Fix URB giveback issue in tasklet function

Huacai Chen <chenhuacai@loongson.cn>
    MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Avoid crashing if rng is NULL

Pali Rohár <pali@kernel.org>
    powerpc/fsl-pci: Fix Class Code of PCIe Root Port

Pali Rohár <pali@kernel.org>
    PCI: Add defines for normal and subtractive PCI bridges

Alexander Lobakin <alexandr.lobakin@intel.com>
    ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()

Mikulas Patocka <mpatocka@redhat.com>
    md-raid10: fix KASAN warning

Narendra Hadke <nhadke@marvell.com>
    serial: mvebu-uart: uart2 error bits clearing

Miklos Szeredi <mszeredi@redhat.com>
    fuse: limit nsec

Zheyu Ma <zheyuma97@gmail.com>
    iio: light: isl29028: Fix the warning in isl29028_remove()

Ovidiu Panait <ovidiu.panait@windriver.com>
    selftests/bpf: Fix "dubious pointer arithmetic" test

Ovidiu Panait <ovidiu.panait@windriver.com>
    selftests/bpf: Fix test_align verifier log patterns

Ovidiu Panait <ovidiu.panait@windriver.com>
    bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()

Leo Li <sunpeng.li@amd.com>
    drm/amdgpu: Check BO's requested pinning domains against its preferred_domains

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: fix another off-by-one in nvbios_addr

Helge Deller <deller@gmx.de>
    parisc: Fix device names in /proc/iomem

Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
    ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()

Lukas Wunner <lukas@wunner.de>
    usbnet: Fix linkwatch use-after-free on disconnect

Helge Deller <deller@gmx.de>
    fbcon: Fix boundary checks for fbcon=vc:n1-n2 parameters

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: sysfs: Fix cooling_device_stats_setup() error code path

Yang Xu <xuyang2018.jy@fujitsu.com>
    fs: Add missing umask strip in vfs_tmpfile

David Howells <dhowells@redhat.com>
    vfs: Check the truncate maximum size in inode_newsize_ok()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tty: vt: initialize unicode screen buffer

Allen Ballway <ballway@chromium.org>
    ALSA: hda/cirrus - support for iMac 12,1 model

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model

Sean Christopherson <seanjc@google.com>
    KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP

Sean Christopherson <seanjc@google.com>
    KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: Don't register pad_input for touch switch

Mikulas Patocka <mpatocka@redhat.com>
    add barriers to buffer_uptodate and set_buffer_uptodate

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: use 32-bit skb cookie

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: add back erroneously removed cast

Jeongik Cha <jeongik@google.com>
    wifi: mac80211_hwsim: fix race condition in pending packet

Zheyu Ma <zheyuma97@gmail.com>
    ALSA: bcd2000: Fix a UAF bug on the error path of probing

Nick Desaulniers <ndesaulniers@google.com>
    x86: link vdso and boot with -z noexecstack --no-warn-rwx-segments

Nick Desaulniers <ndesaulniers@google.com>
    Makefile: link with -z noexecstack --no-warn-rwx-segments


-------------

Diffstat:

 Documentation/atomic_bitops.txt                    |   2 +-
 Makefile                                           |   7 +-
 arch/arm/boot/dts/aspeed-ast2500-evb.dts           |   2 +-
 arch/arm/boot/dts/imx6ul.dtsi                      |  29 ++--
 arch/arm/boot/dts/qcom-pm8841.dtsi                 |   1 +
 arch/arm/lib/findbit.S                             |  16 +--
 arch/arm/mach-bcm/bcm_kona_smc.c                   |   1 +
 arch/arm/mach-omap2/display.c                      |   1 +
 arch/arm/mach-omap2/prm3xxx.c                      |   1 +
 arch/arm/mach-zynq/common.c                        |   1 +
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   4 +-
 arch/arm64/include/asm/processor.h                 |   3 +-
 arch/arm64/kernel/armv8_deprecated.c               |   9 +-
 arch/ia64/include/asm/processor.h                  |   2 +-
 arch/mips/cavium-octeon/octeon-platform.c          |   3 +-
 arch/mips/kernel/proc.c                            |   2 +-
 arch/mips/mm/tlbex.c                               |   4 +-
 arch/nios2/include/asm/entry.h                     |   3 +-
 arch/nios2/include/asm/ptrace.h                    |   2 +
 arch/nios2/kernel/entry.S                          |  22 ++-
 arch/nios2/kernel/signal.c                         |   3 +-
 arch/nios2/kernel/syscall_table.c                  |   1 +
 arch/parisc/kernel/drivers.c                       |   9 +-
 arch/powerpc/kernel/pci-common.c                   |  45 ++++--
 arch/powerpc/kernel/prom.c                         |   7 +
 arch/powerpc/mm/Makefile                           |   7 +
 arch/powerpc/mm/dump_linuxpagetables-8xx.c         |  82 +++++++++++
 arch/powerpc/mm/dump_linuxpagetables-book3s64.c    | 115 +++++++++++++++
 arch/powerpc/mm/dump_linuxpagetables-generic.c     |  82 +++++++++++
 arch/powerpc/mm/dump_linuxpagetables.c             | 155 +--------------------
 arch/powerpc/mm/dump_linuxpagetables.h             |  19 +++
 arch/powerpc/platforms/Kconfig.cputype             |   4 +-
 arch/powerpc/platforms/cell/axon_msi.c             |   1 +
 arch/powerpc/platforms/cell/spufs/inode.c          |   1 +
 arch/powerpc/platforms/powernv/rng.c               |   2 +
 arch/powerpc/sysdev/fsl_pci.c                      |   8 ++
 arch/powerpc/sysdev/fsl_pci.h                      |   1 +
 arch/powerpc/sysdev/xive/spapr.c                   |   1 +
 arch/riscv/kernel/sys_riscv.c                      |   5 +-
 arch/riscv/kernel/traps.c                          |   4 +
 arch/x86/boot/Makefile                             |   2 +-
 arch/x86/boot/compressed/Makefile                  |   4 +
 arch/x86/entry/vdso/Makefile                       |   2 +-
 arch/x86/kernel/pmem.c                             |   7 +-
 arch/x86/kvm/emulate.c                             |  23 ++-
 arch/x86/kvm/hyperv.c                              |   3 +
 arch/x86/kvm/lapic.c                               |   4 +
 arch/x86/kvm/svm.c                                 |   2 -
 arch/x86/mm/numa.c                                 |   4 +-
 arch/x86/platform/olpc/olpc-xo1-sci.c              |   2 +-
 drivers/acpi/acpi_lpss.c                           |   3 +
 drivers/acpi/cppc_acpi.c                           |  54 ++++---
 drivers/acpi/ec.c                                  |   7 -
 drivers/acpi/property.c                            |   8 +-
 drivers/acpi/sleep.c                               |   8 ++
 drivers/ata/libata-eh.c                            |   1 +
 drivers/atm/idt77252.c                             |   1 +
 drivers/block/null_blk_main.c                      |  14 +-
 drivers/bluetooth/hci_intel.c                      |   6 +-
 drivers/bus/hisi_lpc.c                             |  10 +-
 drivers/clk/qcom/gcc-ipq8074.c                     |  19 +++
 drivers/clk/renesas/r9a06g032-clocks.c             |   8 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |  14 +-
 drivers/crypto/hisilicon/sec/sec_drv.h             |   2 +-
 drivers/dma/sprd-dma.c                             |   5 +-
 drivers/firmware/arm_scpi.c                        |  61 ++++----
 drivers/fpga/altera-pr-ip-core.c                   |   2 +-
 drivers/gpio/gpiolib-of.c                          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   4 +
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  17 ++-
 drivers/gpu/drm/bridge/sil-sii8620.c               |   4 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  31 +----
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   2 +
 drivers/gpu/drm/meson/meson_drv.c                  |   5 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c          |   3 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c    |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |   6 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   3 +
 drivers/gpu/drm/vc4/vc4_dsi.c                      |   6 +-
 drivers/hid/hid-alps.c                             |   2 +
 drivers/hid/hid-cp2112.c                           |   5 +
 drivers/hid/wacom_sys.c                            |   2 +-
 drivers/hid/wacom_wac.c                            |  43 +++---
 drivers/hwtracing/intel_th/pci.c                   |  15 ++
 drivers/i2c/busses/i2c-cadence.c                   |  10 +-
 drivers/i2c/i2c-core-base.c                        |   3 +-
 drivers/i2c/muxes/i2c-mux-gpmux.c                  |   1 +
 drivers/iio/light/isl29028.c                       |   2 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |   4 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  12 +-
 drivers/iommu/exynos-iommu.c                       |   6 +-
 drivers/iommu/qcom_iommu.c                         |   7 +-
 drivers/irqchip/irq-tegra.c                        |  10 +-
 drivers/md/dm-raid.c                               |   4 +-
 drivers/md/dm-writecache.c                         |   2 +-
 drivers/md/dm.c                                    |   5 +
 drivers/md/raid10.c                                |   5 +-
 drivers/md/raid5.c                                 |   2 +-
 drivers/media/pci/tw686x/tw686x-core.c             |  18 ++-
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h       |   2 +
 drivers/media/usb/hdpvr/hdpvr-video.c              |   2 +-
 drivers/memstick/core/ms_block.c                   |  11 +-
 drivers/mfd/t7l66xb.c                              |   6 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   6 +-
 drivers/misc/cxl/irq.c                             |   1 +
 drivers/mmc/host/cavium-octeon.c                   |   1 +
 drivers/mmc/host/cavium-thunderx.c                 |   4 +-
 drivers/mmc/host/pxamci.c                          |   4 +-
 drivers/mmc/host/sdhci-of-at91.c                   |   9 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   1 +
 drivers/mtd/devices/st_spi_fsm.c                   |   8 +-
 drivers/mtd/maps/physmap_of_versatile.c            |   2 +
 drivers/mtd/sm_ftl.c                               |   2 +-
 drivers/net/can/pch_can.c                          |   8 +-
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/sja1000/sja1000.c                  |   7 +-
 drivers/net/can/spi/hi311x.c                       |   5 +-
 drivers/net/can/sun4i_can.c                        |   9 +-
 drivers/net/can/usb/ems_usb.c                      |   2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  12 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   6 +-
 drivers/net/can/usb/usb_8dev.c                     |   7 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   4 +-
 drivers/net/ethernet/intel/igb/igb.h               |   2 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 drivers/net/geneve.c                               |   3 +-
 drivers/net/netdevsim/bpf.c                        |   8 +-
 drivers/net/usb/ax88179_178a.c                     |  16 +--
 drivers/net/usb/usbnet.c                           |   8 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   5 +-
 drivers/net/wireless/ath/ath9k/htc.h               |  10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   3 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |  18 +--
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   5 +-
 drivers/net/wireless/intersil/p54/main.c           |   2 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |   3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  14 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   1 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   1 +
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   8 +-
 drivers/ntb/test/ntb_tool.c                        |   8 +-
 drivers/pci/pcie/portdrv_core.c                    |   9 +-
 drivers/pci/quirks.c                               |   3 +
 drivers/pinctrl/nomadik/pinctrl-nomadik.c          |   4 +-
 drivers/pinctrl/qcom/pinctrl-msm8916.c             |   4 +-
 drivers/platform/olpc/olpc-ec.c                    |   2 +-
 drivers/regulator/of_regulator.c                   |   6 +-
 drivers/remoteproc/qcom_wcnss.c                    |  10 +-
 drivers/rpmsg/qcom_smd.c                           |   1 +
 drivers/s390/char/zcore.c                          |  11 +-
 drivers/s390/cio/vfio_ccw_drv.c                    |  14 +-
 drivers/s390/scsi/zfcp_fc.c                        |  29 ++--
 drivers/s390/scsi/zfcp_fc.h                        |   6 +-
 drivers/s390/scsi/zfcp_fsf.c                       |   4 +-
 drivers/scsi/sg.c                                  |  57 +++++---
 drivers/scsi/smartpqi/smartpqi_init.c              |   4 +-
 drivers/soc/amlogic/meson-mx-socinfo.c             |   1 +
 drivers/soc/fsl/guts.c                             |   2 +-
 drivers/soundwire/bus_type.c                       |   8 +-
 drivers/staging/rtl8192u/r8192U.h                  |   2 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |  38 +++--
 drivers/staging/rtl8192u/r8192U_dm.h               |   2 +-
 drivers/tee/tee_core.c                             |   4 +
 drivers/thermal/thermal_sysfs.c                    |  10 +-
 drivers/tty/n_gsm.c                                |  90 ++++++++++--
 drivers/tty/serial/8250/8250_dw.c                  |   3 +
 drivers/tty/serial/mvebu-uart.c                    |  11 ++
 drivers/tty/serial/ucc_uart.c                      |   2 +
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/usb/core/hcd.c                             |  26 ++--
 drivers/usb/gadget/legacy/inode.c                  |   1 +
 drivers/usb/gadget/udc/Kconfig                     |   2 +-
 drivers/usb/host/ehci-ppc-of.c                     |   1 +
 drivers/usb/host/ohci-nxp.c                        |   1 +
 drivers/usb/host/ohci-ppc-of.c                     |   1 +
 drivers/usb/renesas_usbhs/rza.c                    |   4 +
 drivers/usb/serial/sierra.c                        |   3 +-
 drivers/usb/serial/usb-serial.c                    |   2 +-
 drivers/usb/serial/usb_wwan.c                      |   3 +-
 drivers/vfio/vfio.c                                |   1 +
 drivers/video/fbdev/amba-clcd.c                    |  24 +++-
 drivers/video/fbdev/arkfb.c                        |   9 +-
 drivers/video/fbdev/core/fbcon.c                   |   8 +-
 drivers/video/fbdev/i740fb.c                       |   9 +-
 drivers/video/fbdev/s3fb.c                         |   2 +
 drivers/video/fbdev/sis/init.c                     |   4 +-
 drivers/video/fbdev/vt8623fb.c                     |   2 +
 drivers/virt/vboxguest/vboxguest_linux.c           |   9 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   4 +-
 fs/attr.c                                          |   2 +
 fs/btrfs/disk-io.c                                 |  14 ++
 fs/btrfs/raid56.c                                  |  74 +++++++---
 fs/btrfs/tree-log.c                                |   4 +-
 fs/cifs/smb2ops.c                                  |   5 +-
 fs/ext2/super.c                                    |  12 +-
 fs/ext4/inline.c                                   |   3 +
 fs/ext4/inode.c                                    |  10 +-
 fs/ext4/migrate.c                                  |   4 +-
 fs/ext4/namei.c                                    |  23 ++-
 fs/ext4/resize.c                                   |  11 ++
 fs/ext4/xattr.c                                    |   6 +-
 fs/ext4/xattr.h                                    |  13 ++
 fs/f2fs/node.c                                     |   6 +-
 fs/fuse/inode.c                                    |   6 +
 fs/jbd2/transaction.c                              |  14 +-
 fs/namei.c                                         |   2 +
 fs/nfs/nfs4idmap.c                                 |  46 +++---
 fs/nfs/nfs4proc.c                                  |  14 +-
 fs/overlayfs/export.c                              |   2 +-
 fs/splice.c                                        |  10 +-
 include/acpi/cppc_acpi.h                           |   2 +-
 include/asm-generic/bitops/atomic.h                |   6 -
 include/linux/buffer_head.h                        |  25 +++-
 include/linux/kfifo.h                              |   2 +-
 include/linux/kvm_host.h                           |  28 +++-
 include/linux/mfd/t7l66xb.h                        |   1 -
 include/linux/nmi.h                                |   2 +
 include/linux/pci_ids.h                            |   2 +
 include/linux/usb/hcd.h                            |   1 +
 include/sound/core.h                               |   8 ++
 include/trace/events/spmi.h                        |  12 +-
 include/uapi/linux/can/error.h                     |   5 +-
 kernel/bpf/verifier.c                              |   1 +
 kernel/kprobes.c                                   |   3 +-
 kernel/power/user.c                                |  13 +-
 kernel/profile.c                                   |   7 +
 kernel/sched/rt.c                                  |  15 +-
 kernel/trace/trace_events.c                        |   1 +
 kernel/trace/trace_probe.c                         |   4 +-
 kernel/watchdog.c                                  |  21 ++-
 lib/list_debug.c                                   |  12 +-
 mm/mmap.c                                          |   1 -
 net/9p/client.c                                    |   5 +-
 net/bluetooth/l2cap_core.c                         |  13 +-
 net/dccp/proto.c                                   |  10 +-
 net/ipv4/tcp_output.c                              |  30 ++--
 net/netfilter/nf_tables_api.c                      |   7 +-
 net/rds/ib_recv.c                                  |   1 +
 net/rose/af_rose.c                                 |  11 +-
 net/rose/rose_route.c                              |   2 +
 net/sched/cls_route.c                              |  12 +-
 net/sunrpc/backchannel_rqst.c                      |  14 ++
 net/vmw_vsock/af_vsock.c                           |  10 +-
 scripts/Makefile.gcc-plugins                       |   2 +-
 scripts/faddr2line                                 |   4 +-
 security/apparmor/apparmorfs.c                     |   2 +-
 security/apparmor/audit.c                          |   2 +-
 security/apparmor/domain.c                         |   2 +-
 security/apparmor/include/lib.h                    |   5 +
 security/apparmor/include/policy.h                 |   2 +-
 security/apparmor/label.c                          |  13 +-
 security/apparmor/mount.c                          |   8 +-
 security/selinux/ss/policydb.h                     |   2 +
 sound/core/info.c                                  |   6 +-
 sound/core/misc.c                                  |  94 +++++++++++++
 sound/core/timer.c                                 |  11 +-
 sound/pci/hda/patch_cirrus.c                       |   1 +
 sound/pci/hda/patch_conexant.c                     |  11 +-
 sound/soc/codecs/da7210.c                          |   2 +
 sound/soc/mediatek/mt6797/mt6797-mt6351.c          |   6 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c   |  10 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650.c          |   9 +-
 sound/soc/qcom/qdsp6/q6adm.c                       |   2 +-
 sound/usb/bcd2000/bcd2000.c                        |   3 +-
 tools/build/feature/test-libcrypto.c               |  15 +-
 tools/lib/bpf/libbpf.c                             |   9 +-
 tools/perf/util/genelf.c                           |   6 +-
 tools/testing/selftests/bpf/test_align.c           |  41 +++---
 .../testing/selftests/timers/clocksource-switch.c  |   6 +-
 tools/testing/selftests/timers/valid-adjtimex.c    |   2 +-
 tools/thermal/tmon/sysfs.c                         |  24 ++--
 tools/thermal/tmon/tmon.h                          |   3 +
 virt/kvm/kvm_main.c                                |  10 +-
 276 files changed, 1886 insertions(+), 902 deletions(-)


