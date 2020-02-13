Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8129515C688
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgBMQBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgBMPYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:39 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A0B424690;
        Thu, 13 Feb 2020 15:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607477;
        bh=NfqMGgsz/9LAR04SZCgUEC+Sp63O3iAHJ+ddfyrLdH8=;
        h=From:To:Cc:Subject:Date:From;
        b=F69ufoJ/3hUuTdABREOWdc7qrFPTjs9jVAXr5VDnbJpOwDFTN9xx71b6HCg6JQLeN
         06MScpc86msavBzH9qGrqdKtC16wpoCB6+9v7z0nZJsk4mNDZsStKF4xXx/GZF846M
         scx5rjtfjABTueRinHKQO/3A1HeVR9xTyWXQYD5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/173] 4.14.171-stable review
Date:   Thu, 13 Feb 2020 07:18:23 -0800
Message-Id: <20200213151931.677980430@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.171-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.171-rc1
X-KernelTest-Deadline: 2020-02-15T15:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.171 release.
There are 173 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.171-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.171-rc1

Nicolai Stange <nstange@suse.de>
    libertas: make lbs_ibss_join_existing() return error code on rates overflow

Nicolai Stange <nstange@suse.de>
    libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held

Qing Xu <m1s5p6688@gmail.com>
    mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()

Qing Xu <m1s5p6688@gmail.com>
    mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()

Mike Snitzer <snitzer@redhat.com>
    dm: fix potential for q->make_request_fn NULL pointer

Anand Lodnoor <anand.lodnoor@broadcom.com>
    scsi: megaraid_sas: Do not initiate OCR if controller is not in ready state

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B

Gustavo A. R. Silva <gustavo@embeddedor.com>
    media: i2c: adv748x: Fix unsafe macros

Eric Biggers <ebiggers@google.com>
    crypto: atmel-sha - fix error handling when setting hmac key

Eric Biggers <ebiggers@google.com>
    crypto: artpec6 - return correct error code for failed setkey()

Gavin Shan <gshan@redhat.com>
    KVM: arm/arm64: Fix young bit from mmu notifier

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: cpufeature: Fix the type of no FP/SIMD capability

Olof Johansson <olof@lixom.net>
    ARM: 8949/1: mm: mark free_memmap as __init

Eric Auger <eric.auger@redhat.com>
    KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-multi-tce for DDW

Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
    powerpc/pseries/vio: Fix iommu_table use-after-free refcount warning

Zhengyuan Liu <liuzhengyuan@kylinos.cn>
    tools/power/acpi: fix compilation error

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: at91: sama5d3: define clock rate range for tcb1

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: at91: sama5d3: fix maximum peripheral clock rates

Mika Westerberg <mika.westerberg@linux.intel.com>
    platform/x86: intel_mid_powerbtn: Take a copy of ddata

Jose Abreu <Jose.Abreu@synopsys.com>
    ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    rtc: cmos: Stop using shared IRQ

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    rtc: hym8563: Return -EINVAL if the time is known to be invalid

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    serial: uartps: Add a timeout to the tx empty wait

Robert Milkowski <rmilkowski@gmail.com>
    NFSv4: try lease recovery on NFS4ERR_EXPIRED

Trond Myklebust <trondmy@gmail.com>
    NFS/pnfs: Fix pnfs_generic_prepare_to_resend_writes()

Geert Uytterhoeven <geert+renesas@glider.be>
    nfs: NFS_SWAP should depend on SWAP

Logan Gunthorpe <logang@deltatee.com>
    PCI: Don't disable bridge BARs when assigning bus resources

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Fix vep_vector_number ioread width

Bean Huo <beanhuo@micron.com>
    scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/netlink: Do not always generate an ACK for some netlink operations

Sunil Muthuswamy <sunilmut@microsoft.com>
    hv_sock: Remove the accept port restriction

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: pcm: update FE/BE trigger order based on the command

David Howells <dhowells@redhat.com>
    rxrpc: Fix service call disconnection

Song Liu <songliubraving@fb.com>
    perf/core: Fix mlock accounting in perf_mmap()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    clocksource: Prevent double add_timer_on() for watchdog_timer

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fail i/o on soft mounts if sessionsetup errors out

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: do not clobber registers during guest reset/store status

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Play nice with read-only memslots when querying host page size

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Use vcpu-specific gva->hva translation when querying host page size

Miaohe Lin <linmiaohe@huawei.com>
    KVM: nVMX: vmread should not set rflags to specify success in case of #PF

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Add non-canonical check on writes to RTIT address MSRs

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX platform

Josef Bacik <josef@toxicpanda.com>
    btrfs: flush write bio if we loop in extent_write_cache_pages

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Remove VCPI while disabling topology mgr

Claudiu Beznea <claudiu.beznea@microchip.com>
    drm: atmel-hlcdc: enable clock before configuring timing engine

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between adding and putting tree mod seq elements and nodes

David Sterba <dsterba@suse.com>
    btrfs: remove trivial locking wrappers of tree mod log

Josef Bacik <josef@toxicpanda.com>
    btrfs: free block groups after free'ing fs trees

Anand Jain <anand.jain@oracle.com>
    btrfs: use bool argument in free_root_pointers()

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix missing hole after hole punching and fsync when using NO_HOLES

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix assertion failure on fsync with NO_HOLES enabled

Qu Wenruo <wqu@suse.com>
    btrfs: Get rid of the confusing btrfs_file_extent_inline_len

Eric Biggers <ebiggers@google.com>
    ext4: fix deadlock allocating crypto bounce page from mempool

Eric Dumazet <edumazet@google.com>
    bonding/alb: properly access headers in bond_alb_xmit()

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Limit maximum GEM TX length in TSO

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Remove unnecessary alignment check for TSO

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: Avoid RBUF stuck in Wake-on-LAN mode

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix a resource leak in tcindex_set_parms()

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port

Andreas Kemnade <andreas@kemnade.info>
    mfd: rn5t618: Mark ADC control register volatile

Marco Felsch <m.felsch@pengutronix.de>
    mfd: da9062: Fix watchdog compatible string

Dan Carpenter <dan.carpenter@oracle.com>
    ubi: Fix an error pointer dereference in error handling code

Sascha Hauer <s.hauer@pengutronix.de>
    ubi: fastmap: Fix inverted logic in seen selfcheck

Arnd Bergmann <arnd@arndb.de>
    nfsd: fix jiffies/time_t mixup in LRU list

Arnd Bergmann <arnd@arndb.de>
    nfsd: fix delay timer on 32-bit architectures

Yishai Hadas <yishaih@mellanox.com>
    IB/core: Fix ODP get user pages flow

Prabhath Sajeepa <psajeepa@purestorage.com>
    IB/mlx5: Fix outstanding_pi index for GSI qps

Nathan Chancellor <natechancellor@gmail.com>
    net: tulip: Adjust indentation in {dmfe, uli526x}_init_module

Nathan Chancellor <natechancellor@gmail.com>
    net: smc911x: Adjust indentation in smc911x_phy_configure

Nathan Chancellor <natechancellor@gmail.com>
    ppp: Adjust indentation into ppp_async_input

Nathan Chancellor <natechancellor@gmail.com>
    NFC: pn544: Adjust indentation in pn544_hci_check_presence

Nathan Chancellor <natechancellor@gmail.com>
    powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize

Nathan Chancellor <natechancellor@gmail.com>
    ext2: Adjust indentation in ext2_fill_super

Nathan Chancellor <natechancellor@gmail.com>
    phy: qualcomm: Adjust indentation in read_poll_timeout

Asutosh Das <asutoshd@codeaurora.org>
    scsi: ufs: Recheck bkops level if bkops is disabled

Nathan Chancellor <natechancellor@gmail.com>
    scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free

Nathan Chancellor <natechancellor@gmail.com>
    scsi: csiostor: Adjust indentation in csio_device_reset

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return type

Stephen Warren <swarren@nvidia.com>
    clk: tegra: Mark fuse clock as critical

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: PPC: Book3S PR: Free shared page if mmu initialization fails

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect MSR-based index computations in fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF attacks in x86.c

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks

Juergen Gross <jgross@suse.com>
    xen/balloon: Support xend-based toolstack take two

Gavin Shan <gshan@redhat.com>
    tools/kvm_stat: Fix kvm_exit filter name

Roberto Bergantinos Corpas <rbergant@redhat.com>
    sunrpc: expiry_time should be seconds not timeval

Brian Norris <briannorris@chromium.org>
    mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: don't throw error when trying to remove IGTK

Stephen Warren <swarren@nvidia.com>
    ARM: tegra: Enable PLLP bypass during Tegra124 LP1

Josef Bacik <josef@toxicpanda.com>
    btrfs: set trans->drity in btrfs_commit_transaction

Trond Myklebust <trondmy@gmail.com>
    NFS: Directory page cache pages need to be locked when read

Trond Myklebust <trondmy@gmail.com>
    NFS: Fix memory leaks and corruption in readdir

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix unbound NVME response length

Chuhong Yuan <hslester96@gmail.com>
    crypto: picoxcell - adjust the position of tasklet_init and fix missed tasklet_kill

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix race condition in crypto_spawn_alg

Tudor Ambarus <tudor.ambarus@microchip.com>
    crypto: atmel-aes - Fix counter overflow in CTR mode

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Do not clear MAY_SLEEP flag in original request

Ard Biesheuvel <ardb@kernel.org>
    crypto: ccp - set max RSA modulus size for v3 platform devices as well

Toke Høiland-Jørgensen <toke@redhat.com>
    samples/bpf: Don't try to remove user's homedir on clean

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Protect ftrace_graph_hash with ftrace_sync

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Add comment to why rcu_dereference_sched() is open coded

Amol Grover <frextrite@gmail.com>
    tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu

Amol Grover <frextrite@gmail.com>
    tracing: Annotate ftrace_graph_hash pointer with __rcu

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Remove broken queue flushing

Milan Broz <gmazyland@gmail.com>
    dm crypt: fix benbi IV constructor crash if used in authenticated mode

Joe Thornber <ejt@redhat.com>
    dm space map common: fix to ensure new block isn't already in use

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    dm zoned: support zone sizes smaller than 128MiB

Michael Ellerman <mpe@ellerman.id.au>
    of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: core: Fix handling of devices deleted during system-wide resume

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: code cleanup for f2fs_statfs_project()

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: fix miscounted block limit in f2fs_statfs_project()

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: choose hardlimit when softlimit is larger than hardlimit in f2fs_statfs_project()

Sven Van Asbroeck <thesven73@gmail.com>
    power: supply: ltc2941-battery-gauge: fix use-after-free

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix mtcp dump collection failure

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Check spawn->alg under lock in crypto_drop_spawn

Tianyu Lan <Tianyu.Lan@microsoft.com>
    hv_balloon: Balloon up according to request page number

Eric Biggers <ebiggers@google.com>
    ubifs: don't trigger assertion on invalid no-key filename

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: sdhci-of-at91: fix memleak on clk_get failure

Yurii Monakov <monakov.y@gmail.com>
    PCI: keystone: Fix link training retries initiation

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix deadlock in concurrent bulk-read and writepage

Eric Biggers <ebiggers@google.com>
    ubifs: Fix FS_IOC_SETFLAGS unexpectedly clearing encrypt flag

Hou Tao <houtao1@huawei.com>
    ubifs: Reject unsupported ioctl flags explicitly

Stephen Boyd <swboyd@chromium.org>
    alarmtimer: Unregister wakeup source when module get fails

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Do not export a non working backlight interface on MSI MS-7721 boards

Linus Walleij <linus.walleij@linaro.org>
    mmc: spi: Toggle SPI polarity, do not hardcode it

Pingfan Liu <kernelfans@gmail.com>
    powerpc/pseries: Advance pfn if section is not present in lmb_is_removable()

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    powerpc/xmon: don't access ASDR in VMs

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: fix dynamic pagetable upgrade for hugetlbfs

Alexander Lobakin <alobakin@dlink.ru>
    MIPS: fix indentation of the 'RELOCS' message

Christoffer Dall <christoffer.dall@arm.com>
    KVM: arm64: Only sign-extend MMIO up to register width

Mika Westerberg <mika.westerberg@linux.intel.com>
    platform/x86: intel_scu_ipc: Fix interrupt support

Kevin Hao <haokexin@gmail.com>
    irqdomain: Fix a memory leak in irq_domain_push_irq()

Gustavo A. R. Silva <gustavo@embeddedor.com>
    lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()

Helen Koike <helen.koike@collabora.com>
    media: v4l2-rect.h: fix v4l2_rect_map_inside() top/left adjustments

John Hubbard <jhubbard@nvidia.com>
    media/v4l2-core: set pages dirty upon releasing DMA buffers

Takashi Iwai <tiwai@suse.de>
    ALSA: dummy: Fix PCM format loop in proc output

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    usb: gadget: f_ecm: Use atomic_t to track in-flight request

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    usb: gadget: f_ncm: Use atomic_t to track in-flight request

Roger Quadros <rogerq@ti.com>
    usb: gadget: legacy: set max_speed to super-speed

Navid Emamdoost <navid.emamdoost@gmail.com>
    brcmfmac: Fix memory leak in brcmf_usbdev_qinit

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    tracing: Fix sched switch start/stop refcount racy updates

Oliver Neukum <oneukum@suse.com>
    mfd: dln2: More sanity checking for endpoints

Will Deacon <will@kernel.org>
    media: uvcvideo: Avoid cyclic entity chains due to malformed USB descriptors

David Howells <dhowells@redhat.com>
    rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect

David Howells <dhowells@redhat.com>
    rxrpc: Fix insufficient receive notification generation

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->segs_{in|out} in tcp_disconnect()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->data_segs{in|out} in tcp_disconnect()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->delivered in tcp_disconnect()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->total_retrans in tcp_disconnect()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix TC queue mapping.

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix an OOB access in cls_tcindex

Eric Dumazet <edumazet@google.com>
    net: hsr: fix possible NULL deref in hsr_handle_frame()

Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
    l2tp: Allow duplicate session creation with UDP

Taehee Yoo <ap420073@gmail.com>
    gtp: use __GFP_NOWARN to avoid memalloc warning

Eric Dumazet <edumazet@google.com>
    cls_rsvp: fix rsvp_policy

Arnd Bergmann <arnd@arndb.de>
    sparc32: fix struct ipc64_perm type definition

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: fix NVM check for 3168 devices

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR

Johan Hovold <johan@kernel.org>
    media: iguanair: fix endpoint sanity check

YueHaibing <yuehaibing@huawei.com>
    kernel/module: Fix memleak in module_add_modinfo_attrs()


-------------

Diffstat:

 Makefile                                           |    4 +-
 arch/arc/boot/dts/axs10x_mb.dtsi                   |    1 +
 arch/arm/boot/dts/sama5d3.dtsi                     |   28 +-
 arch/arm/boot/dts/sama5d3_can.dtsi                 |    4 +-
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                |    1 +
 arch/arm/boot/dts/sama5d3_uart.dtsi                |    4 +-
 arch/arm/include/asm/kvm_emulate.h                 |    5 +
 arch/arm/include/asm/kvm_mmio.h                    |    2 +
 arch/arm/mach-tegra/sleep-tegra30.S                |   11 +
 arch/arm/mm/init.c                                 |    2 +-
 arch/arm64/include/asm/kvm_emulate.h               |    5 +
 arch/arm64/include/asm/kvm_mmio.h                  |    6 +-
 arch/arm64/kernel/cpufeature.c                     |    2 +-
 arch/mips/Makefile.postlink                        |    2 +-
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/boot/4xx.c                            |    2 +-
 arch/powerpc/kvm/book3s_hv.c                       |    4 +-
 arch/powerpc/kvm/book3s_pr.c                       |    4 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |    4 +-
 arch/powerpc/platforms/pseries/iommu.c             |   43 +-
 arch/powerpc/platforms/pseries/vio.c               |    2 +
 arch/powerpc/xmon/xmon.c                           |    9 +-
 arch/s390/include/asm/page.h                       |    2 +
 arch/s390/kvm/kvm-s390.c                           |    6 +-
 arch/s390/mm/hugetlbpage.c                         |  100 +-
 arch/sparc/include/uapi/asm/ipcbuf.h               |   22 +-
 arch/x86/kernel/cpu/tsx.c                          |   13 +-
 arch/x86/kvm/emulate.c                             |   27 +-
 arch/x86/kvm/hyperv.c                              |   10 +-
 arch/x86/kvm/i8259.c                               |    6 +-
 arch/x86/kvm/ioapic.c                              |   15 +-
 arch/x86/kvm/lapic.c                               |   13 +-
 arch/x86/kvm/mmu.c                                 |    6 +-
 arch/x86/kvm/mtrr.c                                |    8 +-
 arch/x86/kvm/pmu.h                                 |   18 +-
 arch/x86/kvm/pmu_intel.c                           |   24 +-
 arch/x86/kvm/vmx.c                                 |    4 +-
 arch/x86/kvm/vmx/vmx.c                             | 8033 ++++++++++++++++++++
 arch/x86/kvm/x86.c                                 |   27 +-
 crypto/algapi.c                                    |   22 +-
 crypto/api.c                                       |    3 +-
 crypto/internal.h                                  |    1 -
 crypto/pcrypt.c                                    |    1 -
 drivers/acpi/video_detect.c                        |   13 +
 drivers/base/power/main.c                          |   42 +-
 drivers/clk/tegra/clk-tegra-periph.c               |    6 +-
 drivers/crypto/atmel-aes.c                         |   37 +-
 drivers/crypto/atmel-sha.c                         |    7 +-
 drivers/crypto/axis/artpec6_crypto.c               |    2 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |    1 +
 drivers/crypto/picoxcell_crypto.c                  |   15 +-
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     |    8 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   12 +
 drivers/hv/hv_balloon.c                            |   13 +-
 drivers/infiniband/core/addr.c                     |    2 +-
 drivers/infiniband/core/sa_query.c                 |    4 +-
 drivers/infiniband/core/umem_odp.c                 |    2 +-
 drivers/infiniband/hw/mlx5/gsi.c                   |    3 +-
 drivers/md/dm-crypt.c                              |   10 +-
 drivers/md/dm-zoned-metadata.c                     |   23 +-
 drivers/md/dm.c                                    |    9 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   27 +
 drivers/md/persistent-data/dm-space-map-common.h   |    2 +
 drivers/md/persistent-data/dm-space-map-disk.c     |    6 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |    5 +-
 drivers/media/i2c/adv748x/adv748x.h                |    8 +-
 drivers/media/rc/iguanair.c                        |    2 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   12 +
 drivers/media/v4l2-core/videobuf-dma-sg.c          |    5 +-
 drivers/mfd/da9062-core.c                          |    2 +-
 drivers/mfd/dln2.c                                 |   13 +-
 drivers/mfd/rn5t618.c                              |    1 +
 drivers/mmc/host/mmc_spi.c                         |   11 +-
 drivers/mmc/host/sdhci-of-at91.c                   |    9 +-
 drivers/mtd/ubi/fastmap.c                          |   23 +-
 drivers/net/bonding/bond_alb.c                     |   44 +-
 drivers/net/dsa/bcm_sf2.c                          |    4 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |    3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    2 +-
 drivers/net/ethernet/cadence/macb_main.c           |   14 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |    7 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |    4 +-
 drivers/net/ethernet/smsc/smc911x.c                |    2 +-
 drivers/net/gtp.c                                  |    6 +-
 drivers/net/ppp/ppp_async.c                        |   18 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   10 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |    2 +
 drivers/net/wireless/marvell/mwifiex/scan.c        |    7 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |    1 +
 drivers/net/wireless/marvell/mwifiex/wmm.c         |    4 +
 drivers/nfc/pn544/pn544.c                          |    2 +-
 drivers/of/Kconfig                                 |    4 +
 drivers/of/address.c                               |    6 +-
 drivers/pci/dwc/pci-keystone-dw.c                  |    2 +-
 drivers/pci/setup-bus.c                            |   20 +-
 drivers/pci/switch/switchtec.c                     |    2 +-
 drivers/phy/qualcomm/phy-qcom-apq8064-sata.c       |    2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |    4 +-
 drivers/platform/x86/intel_mid_powerbtn.c          |    5 +-
 drivers/platform/x86/intel_scu_ipc.c               |   21 +-
 drivers/power/supply/ltc2941-battery-gauge.c       |    2 +-
 drivers/rtc/rtc-cmos.c                             |    2 +-
 drivers/rtc/rtc-hym8563.c                          |    2 +-
 drivers/scsi/csiostor/csio_scsi.c                  |    2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |    3 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |    3 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |    1 +
 drivers/scsi/qla2xxx/qla_dbg.c                     |    6 -
 drivers/scsi/qla2xxx/qla_dbg.h                     |    6 +
 drivers/scsi/qla2xxx/qla_isr.c                     |   12 +
 drivers/scsi/qla2xxx/qla_mbx.c                     |    3 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |    7 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    2 +-
 drivers/scsi/ufs/ufshcd.c                          |    6 +-
 drivers/tty/serial/xilinx_uartps.c                 |   14 +-
 drivers/usb/gadget/function/f_ecm.c                |   16 +-
 drivers/usb/gadget/function/f_ncm.c                |   17 +-
 drivers/usb/gadget/legacy/cdc2.c                   |    2 +-
 drivers/usb/gadget/legacy/g_ffs.c                  |    2 +-
 drivers/usb/gadget/legacy/multi.c                  |    2 +-
 drivers/usb/gadget/legacy/ncm.c                    |    2 +-
 drivers/xen/xen-balloon.c                          |    2 +-
 fs/btrfs/ctree.c                                   |   64 +-
 fs/btrfs/ctree.h                                   |   32 +-
 fs/btrfs/delayed-ref.c                             |    8 +-
 fs/btrfs/disk-io.c                                 |   22 +-
 fs/btrfs/extent_io.c                               |    8 +
 fs/btrfs/file-item.c                               |    2 +-
 fs/btrfs/file.c                                    |    3 +-
 fs/btrfs/inode.c                                   |   12 +-
 fs/btrfs/print-tree.c                              |    4 +-
 fs/btrfs/send.c                                    |   17 +-
 fs/btrfs/tests/btrfs-tests.c                       |    1 -
 fs/btrfs/transaction.c                             |    8 +
 fs/btrfs/tree-log.c                                |  397 +-
 fs/cifs/smb2pdu.c                                  |   10 +-
 fs/ext2/super.c                                    |    6 +-
 fs/ext4/page-io.c                                  |   19 +-
 fs/f2fs/super.c                                    |   14 +-
 fs/nfs/Kconfig                                     |    2 +-
 fs/nfs/dir.c                                       |   47 +-
 fs/nfs/direct.c                                    |    4 +-
 fs/nfs/nfs3xdr.c                                   |    5 +-
 fs/nfs/nfs4proc.c                                  |    5 +
 fs/nfs/nfs4xdr.c                                   |    5 +-
 fs/nfs/pnfs_nfs.c                                  |    7 +-
 fs/nfs/write.c                                     |    4 +-
 fs/nfsd/nfs4layouts.c                              |    2 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/nfsd/state.h                                    |    2 +-
 fs/ubifs/dir.c                                     |    2 +
 fs/ubifs/file.c                                    |    4 +-
 fs/ubifs/ioctl.c                                   |   11 +-
 include/linux/kvm_host.h                           |    2 +-
 include/media/v4l2-rect.h                          |    8 +-
 include/trace/events/btrfs.h                       |    2 +-
 kernel/events/core.c                               |   10 +-
 kernel/irq/irqdomain.c                             |    1 +
 kernel/module.c                                    |    2 +
 kernel/padata.c                                    |   46 +-
 kernel/time/alarmtimer.c                           |    8 +-
 kernel/time/clocksource.c                          |   11 +-
 kernel/trace/ftrace.c                              |   15 +-
 kernel/trace/trace.h                               |   29 +-
 kernel/trace/trace_sched_switch.c                  |    4 +-
 lib/test_kasan.c                                   |    1 +
 net/hsr/hsr_slave.c                                |    2 +
 net/ipv4/tcp.c                                     |    6 +
 net/l2tp/l2tp_core.c                               |    7 +-
 net/rxrpc/ar-internal.h                            |    1 +
 net/rxrpc/call_object.c                            |    4 +-
 net/rxrpc/conn_client.c                            |    3 +-
 net/rxrpc/conn_object.c                            |    3 +-
 net/rxrpc/input.c                                  |    3 +-
 net/rxrpc/output.c                                 |   26 +-
 net/sched/cls_rsvp.h                               |    6 +-
 net/sched/cls_tcindex.c                            |   43 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |    4 +
 net/vmw_vsock/hyperv_transport.c                   |   68 +-
 samples/bpf/Makefile                               |    2 +-
 sound/drivers/dummy.c                              |    2 +-
 sound/soc/soc-pcm.c                                |   95 +-
 tools/kvm/kvm_stat/kvm_stat                        |    8 +-
 tools/power/acpi/Makefile.config                   |    2 +-
 virt/kvm/arm/mmio.c                                |    6 +
 virt/kvm/arm/mmu.c                                 |    3 +-
 virt/kvm/arm/vgic/vgic-its.c                       |    3 +-
 virt/kvm/kvm_main.c                                |    4 +-
 190 files changed, 9334 insertions(+), 990 deletions(-)


