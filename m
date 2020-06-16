Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310B51FBCD3
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 19:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgFPR1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 13:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729241AbgFPR1T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 13:27:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C97220B1F;
        Tue, 16 Jun 2020 17:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592328438;
        bh=f/INNJArfVD9P9bLLQuD4FxBExf8wszjQr86w8jf6+8=;
        h=From:To:Cc:Subject:Date:From;
        b=2ZK0gTs7tuCygxgxgWqiNh+qhHW3Q5mortvpNPaT8l8BjorCZ8+oFL9vrNn9clpim
         8cCYImLsRZpyU/nLnwYpW5QIm5AJANnugnukp3+Yc3C6syk25ORK0k1svpJiI13xRk
         fcLisrdj4DXsf5QyTOWJmAMgLFQIlc0ySaQZYX0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 000/162] 5.7.3-rc2 review
Date:   Tue, 16 Jun 2020 19:27:11 +0200
Message-Id: <20200616172615.453746383@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.3-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.3-rc2
X-KernelTest-Deadline: 2020-06-18T17:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.7.3 release.
There are 162 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 18 Jun 2020 17:25:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.3-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.3-rc2

John Stultz <john.stultz@linaro.org>
    serial: amba-pl011: Make sure we initialize the port.lock spinlock

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Save the host's PtrAuth keys in non-preemptible context

Mattia Dongili <malattia@linux.it>
    platform/x86: sony-laptop: Make resuming thermal profile safer

Mattia Dongili <malattia@linux.it>
    platform/x86: sony-laptop: SNC calls should handle BUFFER types

Juergen Gross <jgross@suse.com>
    xen/pvcalls-back: test for errors when calling backend_connect()

Jiri Kosina <jkosina@suse.cz>
    block/floppy: fix contended case in floppy_queue_rq()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdio: Fix several potential memory leaks in mmc_sdio_init_card()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdio: Fix potential NULL pointer error in mmc_sdio_init_card()

Ludovic Desroches <ludovic.desroches@microchip.com>
    ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node description

Masahiro Yamada <yamada.masahiro@socionext.com>
    mmc: uniphier-sd: call devm_request_irq() after tmio_mmc_host_probe()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: tmio: Further fixup runtime PM management at remove

Ludovic Barre <ludovic.barre@st.com>
    mmc: mmci_sdmmc: fix DMA API warning overlapping mappings

Eugen Hristev <eugen.hristev@microchip.com>
    mmc: sdhci-of-at91: fix CALCR register being rewritten

Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
    mmc: sdhci-msm: Clear tuning done flag while hs400 tuning

Chris Wilson <chris@chris-wilson.co.uk>
    agp/intel: Reinforce the barrier after GTT updates

Barret Rhoden <brho@google.com>
    perf: Add cond_resched() to task_function_call()

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: don't allow to mount if the FAT length == 0

Wang Hai <wanghai38@huawei.com>
    mm/slub: fix a memory leak in sysfs_slab_add()

Ezequiel Garcia <ezequiel@collabora.com>
    drm/vkms: Hold gem object while still in-use

Casey Schaufler <casey@schaufler-ca.com>
    Smack: slab-out-of-bounds in vsscanf

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Qiujun Huang <hqjagain@gmail.com>
    ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix use-after-free Write in ath9k_htc_rx_msg

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix use-after-free Read in htc_connect_service

Masami Hiramatsu <mhiramat@kernel.org>
    selftests/ftrace: Return unsupported if no error_log file

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro with __BIG_ENDIAN_BITFIELD macro

Dick Kennedy <dick.kennedy@broadcom.com>
    scsi: lpfc: Fix negation of else clause in lpfc_prep_node_fc4type

Sumit Saxena <sumit.saxena@broadcom.com>
    scsi: megaraid_sas: TM command refire leads to controller firmware crash

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts

James Morse <james.morse@arm.com>
    KVM: arm64: Stop writing aarch32's CSSELR into ACTLR

Xing Li <lixing@loongson.cn>
    KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits

Xing Li <lixing@loongson.cn>
    KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Consult only the "basic" exit reason when routing nested exit

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nSVM: leave ASID aside in copy_vmcb_control_area

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nSVM: fix condition for filtering async PF

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02

Tomi Valkeinen <tomi.valkeinen@ti.com>
    media: videobuf2-dma-contig: fix bad kfree in vb2_dma_contig_clear_max_seg_size

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    video: fbdev: w100fb: Fix a potential double free.

Sam Ravnborg <sam@ravnborg.org>
    video: vt8500lcdfb: fix fallthrough warning

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx: Use the mcmtr register to retrieve close_pg/bank_xor_enable

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Fix up cpufreq_boost_set_sw()

Suman Anna <s-anna@ti.com>
    remoteproc: Fix and restore the parenting hierarchy for vdev

Tero Kristo <t-kristo@ti.com>
    remoteproc: Fall back to using parent memory pool if no dedicated available

Eric W. Biederman <ebiederm@xmission.com>
    proc: Use new_inode not new_inode_pseudo

Namjae Jeon <namjae.jeon@samsung.com>
    exfat: fix incorrect update of stream entry in __exfat_truncate()

Al Viro <viro@zeniv.linux.org.uk>
    exfat: fix memory leak in exfat_parse_param()

Yuxuan Shui <yshuiv7@gmail.com>
    ovl: initialize error in ovl_copy_xattr

Amir Goldstein <amir73il@gmail.com>
    ovl: fix out of bounds access warning in ovl_check_fb_len()

Oz Shlomo <ozsh@mellanox.com>
    net/mlx5e: CT: Fix ipv6 nat header rewrite actions

Valentin Longchamp <valentin@longchamp.me>
    net: sched: export __netdev_watchdog_up()

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: am65-cpsw-nuss: fix ale parameters init

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: ale: fix allmulti for nu type ale

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix races between shutdown and recvmsg

Shannon Nelson <snelson@pensando.io>
    ionic: wait on queue start until after IFF_UP

Paolo Abeni <pabeni@redhat.com>
    mptcp: don't leak msk in token container

Parav Pandit <parav@mellanox.com>
    net/mlx5: Disable reload while removing the device

Charles Keepax <ckeepax@opensource.cirrus.com>
    net: macb: Only disable NAPI on the actual error path

Corentin Labbe <clabbe@baylibre.com>
    net: cadence: macb: disable NAPI on error

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix repeated XSK usage on one channel

Shay Drory <shayd@mellanox.com>
    net/mlx5: Fix fatal error handling during device load

Shay Drory <shayd@mellanox.com>
    net/mlx5: drain health workqueue in case of driver load error

tannerlove <tannerlove@google.com>
    selftests/net: in rxtimestamp getopt_long needs terminating null entry

Lorenzo Bianconi <lorenzo@kernel.org>
    net: mvneta: do not redirect frames during reconfiguration

Wang Hai <wanghai38@huawei.com>
    dccp: Fix possible memleak in dccp_init and dccp_fini

Franck LENORMAND <franck.lenormand@nxp.com>
    firmware: imx: scu: Fix corruption of header

Peng Fan <peng.fan@nxp.com>
    firmware: imx-scu: Support one TX and one RX

Tony Luck <tony.luck@intel.com>
    x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned

Longpeng(Mike) <longpeng2@huawei.com>
    crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()

Longpeng(Mike) <longpeng2@huawei.com>
    crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req()

Longpeng(Mike) <longpeng2@huawei.com>
    crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: drbg - fix error return code in drbg_alloc_state()

Eric Biggers <ebiggers@google.com>
    crypto: algapi - Avoid spurious modprobe on LOADED

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium/nitrox - Fix 'nitrox_get_first_device()' when ndevlist is fully iterated

Linus Torvalds <torvalds@linux-foundation.org>
    gup: document and work around "COW can break either way" issue

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: clk: Fix clk_pm_runtime_get() error path

Justin Chen <justinpopo6@gmail.com>
    spi: bcm-qspi: when tx/rx buffer is NULL set to 0

Florian Fainelli <f.fainelli@gmail.com>
    spi: bcm-qspi: Handle clock probe deferral

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835aux: Fix controller unregister order

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix controller unregister order

Lukas Wunner <lukas@wunner.de>
    spi: pxa2xx: Fix runtime PM ref imbalance on probe error

Lukas Wunner <lukas@wunner.de>
    spi: pxa2xx: Fix controller unregister order

Lukas Wunner <lukas@wunner.de>
    spi: Fix controller unregister order

Lukas Wunner <lukas@wunner.de>
    spi: dw: Fix controller unregister order

Alexander Gordeev <agordeev@linux.ibm.com>
    lib: fix bitmap_parse() on 64-bit big endian archs

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

Dave Rodgman <dave.rodgman@arm.com>
    lib/lzo: fix ambiguous encoding bug in lzo-rle

Nick Desaulniers <ndesaulniers@google.com>
    arm64: acpi: fix UBSAN warning

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Avoid using power resources if there are none for D0

Ard Biesheuvel <ardb@kernel.org>
    ACPI: GED: add support for _Exx / _Lxx handler methods

Qiushi Wu <wu000273@umn.edu>
    ACPI: CPPC: Fix reference count leak in acpi_cppc_processor_probe()

Qiushi Wu <wu000273@umn.edu>
    ACPI: sysfs: Fix reference count leak in acpi_sysfs_add_hotplug_profile()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: usb-audio: Add vendor, product and profile name for HP Thunderbolt Dock

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix inconsistent card PM state after resume

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    ALSA: pcm: fix snd_pcm_link() lockdep splat

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    ALSA: pcm: disallow linking stream to itself

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - add a pintbl quirk for several Lenovo machines

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: fireface: start IR context immediately

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: fireface: fix configuration error for nominal sampling transfer frequency

Hersen Wu <hersenxs.wu@amd.com>
    ALSA: hda: add sienna_cichlid audio asic id for sienna_cichlid up

Chuhong Yuan <hslester96@gmail.com>
    ALSA: es1688: Add the missed snd_card_free()

Fabio Estevam <festevam@gmail.com>
    watchdog: imx_sc_wdt: Fix reboot on crash

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: imx: Initialize lock for non-registered console

Steve French <stfrench@microsoft.com>
    smb3: fix typo in mount options displayed in /proc/mounts

Namjae Jeon <namjae.jeon@samsung.com>
    smb3: add indatalen that can be a non-zero value to calculation of credit charge in smb2 ioctl

Steve French <stfrench@microsoft.com>
    smb3: fix incorrect number of credits when ioctl MaxOutputResponse > 64K

Ard Biesheuvel <ardb@kernel.org>
    efi/efivars: Add missing kobject_put() in sysfs entry creation error path

Jens Axboe <axboe@kernel.dk>
    io_uring: allow O_NONBLOCK async retry

Denis Efremov <efremov@linux.com>
    io_uring: use kvfree() in io_sqe_buffer_register()

Jens Axboe <axboe@kernel.dk>
    io_uring: re-set iov base/len for buffer select retry

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix flush req->refs underflow

Pavel Dobias <dobias@2n.cz>
    ASoC: max9867: fix volume controls

Dan Murphy <dmurphy@ti.com>
    ASoC: tlv320adcx140: Fix mic gain registers

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/ptdump: Properly handle non standard page size

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    KVM: x86: Fix APIC page invalidation race

Felipe Franciosi <felipe@nutanix.com>
    KVM: x86: respect singlestep when emulating instruction

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be generated

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: VMX: enable X86_FEATURE_WAITPKG in KVM capabilities

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: allow KVM_STATE_NESTED_MTF_PENDING in kvm_state flags

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add more available bits for OFFCORE_RESPONSE of Intel Tremont

Thomas Gleixner <tglx@linutronix.de>
    x86/vdso: Unbreak paravirt VDSO clocks

Hill Ma <maahiuzeon@gmail.com>
    x86/reboot/quirks: Add MacBook6,1 reboot quirk

Anthony Steinhauser <asteinhauser@google.com>
    x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for indirect branches.

Anthony Steinhauser <asteinhauser@google.com>
    x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.

Anthony Steinhauser <asteinhauser@google.com>
    x86/speculation: Prevent rogue cross-process SSBD shutdown

Xiaochun Lee <lixc17@lenovo.com>
    x86/PCI: Mark Intel C620 MROMs as having non-compliant BARs

Steven Price <steven.price@arm.com>
    x86: mm: ptdump: calculate effective permissions correctly

Bob Haarman <inglorion@google.com>
    x86_64: Fix jiffies ODR violation

Vlastimil Babka <vbabka@suse.cz>
    usercopy: mark dma-kmalloc caches as usercopy caches

Miklos Szeredi <mszeredi@redhat.com>
    aio: fix async fsync creds

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PM: Adjust pcie_wait_for_link_delay() for caller delay

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: only do L1TF workaround on affected processors

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: add separate cpuhp node for CPUHP_PADATA_DEAD

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/uverbs: Make the event_queue fds return POLLERR when disassociated

Kim Phillips <kim.phillips@amd.com>
    x86/cpu/amd: Make erratum #1054 a legacy erratum

Petr Tesarik <ptesarik@suse.com>
    s390/pci: Log new handle in clp_disable_fh()

Arnd Bergmann <arnd@arndb.de>
    smack: avoid unused 'sip' variable warning

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Silence undersized packet warnings

Sasha Levin <sashal@kernel.org>
    spi: dw: Fix native CS being unset

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Clear the page tables for the ESB IO mapping

Amir Goldstein <amir73il@gmail.com>
    fanotify: fix ignore mask logic for events on child and on dir

Saravana Kannan <saravanak@google.com>
    driver core: Update device link status correctly for SYNC_STATE_ONLY links

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Accept the instance number of kretprobe event

Waiman Long <longman@redhat.com>
    mm: add kvfree_sensitive() for freeing sensitive data objects

Vlad Buslov <vladbu@mellanox.com>
    selftests: fix flower parent qdisc

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix double free

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-pci: properly power off dual-ported pcie phy

Nick Desaulniers <ndesaulniers@google.com>
    elfnote: mark all .note sections SHF_ALLOC

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix NULL pointer dereference in streaming

Michal Vokáč <michal.vokac@ysoft.com>
    net: dsa: qca8k: Fix "Unexpected gfp" kernel exception

Cong Wang <xiyou.wangcong@gmail.com>
    genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()

Geliang Tang <geliangtang@gmail.com>
    mptcp: bugfix for RM_ADDR option parsing

Sameeh Jubran <sameehj@amazon.com>
    net: ena: xdp: update napi budget for DROP and ABORTED

Sameeh Jubran <sameehj@amazon.com>
    net: ena: xdp: XDP_TX: fix memory leak

Ido Schimmel <idosch@mellanox.com>
    vxlan: Avoid infinite loop when suppressing NS messages with invalid options

Ido Schimmel <idosch@mellanox.com>
    bridge: Avoid infinite loop when suppressing NS messages with invalid options

Willem de Bruijn <willemb@google.com>
    tun: correct header offsets in napi frags mode

Vasily Averin <vvs@virtuozzo.com>
    net_failover: fixed rollback in net_failover_open()

Vadim Pasternak <vadimp@mellanox.com>
    mlxsw: core: Use different get_trend() callbacks for different thermal zones

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: fix IPV6_ADDRFORM operation logic


-------------

Diffstat:

 Documentation/lzo.txt                              |  8 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts          |  2 -
 arch/arm64/include/asm/acpi.h                      |  5 +-
 arch/arm64/include/asm/kvm_emulate.h               |  6 --
 arch/arm64/include/asm/kvm_host.h                  |  6 +-
 arch/arm64/kvm/handle_exit.c                       | 19 +----
 arch/arm64/kvm/sys_regs.c                          | 10 ++-
 arch/mips/include/asm/kvm_host.h                   |  6 +-
 arch/powerpc/mm/ptdump/ptdump.c                    | 21 ++---
 arch/powerpc/sysdev/xive/common.c                  |  5 ++
 arch/s390/pci/pci_clp.c                            |  3 +-
 arch/x86/events/intel/core.c                       |  4 +-
 arch/x86/include/asm/set_memory.h                  | 19 +++--
 arch/x86/include/asm/vdso/gettimeofday.h           | 18 +++++
 arch/x86/kernel/cpu/amd.c                          |  3 +-
 arch/x86/kernel/cpu/bugs.c                         | 92 ++++++++++++---------
 arch/x86/kernel/cpu/mce/core.c                     | 11 ++-
 arch/x86/kernel/process.c                          | 28 +++----
 arch/x86/kernel/reboot.c                           |  8 ++
 arch/x86/kernel/time.c                             |  4 -
 arch/x86/kernel/vmlinux.lds.S                      |  4 +-
 arch/x86/kvm/mmu/mmu.c                             | 46 +++++------
 arch/x86/kvm/svm/nested.c                          |  6 +-
 arch/x86/kvm/vmx/nested.c                          |  4 +-
 arch/x86/kvm/vmx/vmx.c                             | 21 ++++-
 arch/x86/kvm/vmx/vmx.h                             |  3 +-
 arch/x86/kvm/x86.c                                 | 15 ++--
 arch/x86/mm/dump_pagetables.c                      | 33 +++++---
 arch/x86/pci/fixup.c                               |  4 +
 crypto/algapi.c                                    |  2 +-
 crypto/drbg.c                                      |  4 +-
 drivers/acpi/cppc_acpi.c                           |  1 +
 drivers/acpi/device_pm.c                           |  2 +-
 drivers/acpi/evged.c                               | 22 ++++-
 drivers/acpi/scan.c                                | 28 ++++---
 drivers/acpi/sysfs.c                               |  4 +-
 drivers/base/core.c                                | 34 ++++++--
 drivers/block/floppy.c                             | 10 +--
 drivers/char/agp/intel-gtt.c                       |  4 +-
 drivers/clk/clk.c                                  |  6 +-
 drivers/cpufreq/cpufreq.c                          | 11 +--
 drivers/crypto/cavium/nitrox/nitrox_main.c         |  4 +-
 drivers/crypto/virtio/virtio_crypto_algs.c         | 21 +++--
 drivers/edac/i10nm_base.c                          |  2 +-
 drivers/edac/skx_base.c                            | 20 ++---
 drivers/edac/skx_common.c                          |  6 +-
 drivers/edac/skx_common.h                          |  2 +-
 drivers/firmware/efi/efivars.c                     |  4 +-
 drivers/firmware/imx/imx-scu.c                     | 62 ++++++++++----
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c        |  8 ++
 drivers/gpu/drm/vkms/vkms_drv.h                    |  5 --
 drivers/gpu/drm/vkms/vkms_gem.c                    | 11 +--
 drivers/infiniband/core/uverbs_main.c              |  2 +
 .../media/common/videobuf2/videobuf2-dma-contig.c  | 20 +----
 drivers/mmc/core/sdio.c                            | 61 +++++++-------
 drivers/mmc/host/mmci_stm32_sdmmc.c                |  3 +
 drivers/mmc/host/sdhci-msm.c                       |  6 ++
 drivers/mmc/host/sdhci-of-at91.c                   |  7 +-
 drivers/mmc/host/tmio_mmc_core.c                   |  6 +-
 drivers/mmc/host/uniphier-sd.c                     | 12 +--
 drivers/net/dsa/qca8k.c                            |  3 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       | 10 +--
 drivers/net/ethernet/cadence/macb_main.c           | 14 ++--
 drivers/net/ethernet/marvell/mvneta.c              | 13 +++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  2 -
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 16 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  4 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   | 14 +++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  7 ++
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 23 +++++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  2 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 | 49 ++++++++---
 drivers/net/net_failover.c                         |  3 +-
 drivers/net/tun.c                                  | 14 +++-
 drivers/net/vxlan.c                                |  4 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           | 58 ++++++++++---
 drivers/net/wireless/ath/ath9k/hif_usb.h           |  6 ++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      | 10 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  6 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |  6 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |  6 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |  3 +-
 drivers/pci/pci.c                                  |  4 +-
 drivers/platform/x86/sony-laptop.c                 | 60 +++++++-------
 drivers/remoteproc/remoteproc_core.c               |  2 +-
 drivers/remoteproc/remoteproc_virtio.c             | 12 +++
 drivers/scsi/lpfc/lpfc_ct.c                        |  1 -
 drivers/scsi/megaraid/megaraid_sas.h               |  4 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  7 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |  6 +-
 drivers/spi/spi-bcm-qspi.c                         | 20 +++--
 drivers/spi/spi-bcm2835.c                          |  4 +-
 drivers/spi/spi-bcm2835aux.c                       |  4 +-
 drivers/spi/spi-dw.c                               | 14 +++-
 drivers/spi/spi-pxa2xx.c                           |  5 +-
 drivers/spi/spi.c                                  |  3 +-
 drivers/staging/mt7621-pci/pci-mt7621.c            | 12 ++-
 drivers/staging/wfx/main.c                         |  1 -
 drivers/tty/serial/amba-pl011.c                    |  1 +
 drivers/tty/serial/imx.c                           |  3 +
 drivers/video/fbdev/vt8500lcdfb.c                  |  1 +
 drivers/video/fbdev/w100fb.c                       |  2 +
 drivers/watchdog/imx_sc_wdt.c                      |  5 ++
 drivers/xen/pvcalls-back.c                         |  3 +-
 fs/aio.c                                           |  8 ++
 fs/cifs/cifsfs.c                                   |  2 +-
 fs/cifs/smb2pdu.c                                  |  4 +-
 fs/exfat/file.c                                    |  8 +-
 fs/exfat/super.c                                   | 12 ++-
 fs/fat/inode.c                                     |  6 ++
 fs/io_uring.c                                      | 24 ++++--
 fs/nilfs2/segment.c                                |  2 +
 fs/notify/fanotify/fanotify.c                      |  5 +-
 fs/overlayfs/copy_up.c                             |  2 +-
 fs/overlayfs/overlayfs.h                           |  3 +
 fs/proc/inode.c                                    |  2 +-
 fs/proc/self.c                                     |  2 +-
 fs/proc/thread_self.c                              |  2 +-
 include/linux/elfnote.h                            |  2 +-
 include/linux/kvm_host.h                           |  4 +-
 include/linux/mm.h                                 |  1 +
 include/linux/padata.h                             |  6 +-
 include/linux/ptdump.h                             |  1 +
 include/linux/set_memory.h                         |  2 +-
 include/media/videobuf2-dma-contig.h               |  2 +-
 include/net/inet_hashtables.h                      |  6 ++
 kernel/events/core.c                               | 23 +++---
 kernel/padata.c                                    | 14 ++--
 lib/bitmap.c                                       |  9 ++-
 lib/lzo/lzo1x_compress.c                           | 13 +++
 mm/gup.c                                           | 44 ++++++++--
 mm/huge_memory.c                                   |  7 +-
 mm/ptdump.c                                        | 17 +++-
 mm/slab_common.c                                   |  3 +-
 mm/slub.c                                          |  4 +-
 mm/util.c                                          | 18 +++++
 net/bridge/br_arp_nd_proxy.c                       |  4 +
 net/dccp/proto.c                                   |  7 +-
 net/ipv6/ipv6_sockglue.c                           | 13 +--
 net/mptcp/options.c                                |  2 +
 net/mptcp/protocol.c                               | 45 ++++++-----
 net/mptcp/subflow.c                                |  1 +
 net/netlink/genetlink.c                            | 94 +++++++++++++---------
 net/sched/sch_generic.c                            |  1 +
 net/tipc/msg.c                                     |  4 +-
 security/keys/internal.h                           | 11 ---
 security/keys/keyctl.c                             | 16 ++--
 security/smack/smack.h                             |  6 --
 security/smack/smack_lsm.c                         | 25 ++----
 security/smack/smackfs.c                           | 10 +++
 sound/core/pcm_native.c                            | 20 ++++-
 sound/firewire/fireface/ff-protocol-latter.c       | 12 +--
 sound/firewire/fireface/ff-stream.c                | 10 +--
 sound/isa/es1688/es1688.c                          |  4 +-
 sound/pci/hda/hda_intel.c                          |  3 +
 sound/pci/hda/patch_realtek.c                      |  6 ++
 sound/soc/codecs/max9867.c                         |  4 +-
 sound/soc/codecs/tlv320adcx140.c                   |  6 +-
 sound/usb/card.c                                   | 19 +++--
 sound/usb/quirks-table.h                           | 20 +++++
 sound/usb/usbaudio.h                               |  2 +-
 tools/perf/util/probe-event.c                      |  3 +-
 .../ftrace/test.d/ftrace/tracing-error-log.tc      |  2 +
 tools/testing/selftests/net/rxtimestamp.c          |  1 +
 .../tc-testing/tc-tests/filters/tests.json         |  6 +-
 tools/testing/selftests/tc-testing/tdc_batch.py    |  6 +-
 virt/kvm/arm/aarch32.c                             | 28 +++++++
 virt/kvm/arm/arm.c                                 | 18 ++++-
 virt/kvm/kvm_main.c                                | 26 +++---
 171 files changed, 1270 insertions(+), 682 deletions(-)


