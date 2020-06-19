Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75836200C79
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbgFSOqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388816AbgFSOqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:46:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF192083B;
        Fri, 19 Jun 2020 14:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577973;
        bh=e9uUPq55txQLRNZTyfo+78Az23yvEm0DFNffD3OkEk0=;
        h=From:To:Cc:Subject:Date:From;
        b=wmhVWi3f7hnkDusA2F4PJqmDZPf3WuwZ+COo5qaGzEBxyVB6a6bGzGkGBEywjzdBo
         XONqyP5oDVldAcfhu/zqFZanhdNV5s0PatgksPyQhWMxHwMCgIEkmWoFjZ1INVg1OZ
         gOlH8uWtmIIejr9Y+IrUnOFxpC3Xs8ehrAajMRpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/190] 4.14.185-rc1 review
Date:   Fri, 19 Jun 2020 16:30:45 +0200
Message-Id: <20200619141633.446429600@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.185-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.185-rc1
X-KernelTest-Deadline: 2020-06-21T14:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.185 release.
There are 190 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.185-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.185-rc1

Adrian Hunter <adrian.hunter@intel.com>
    perf symbols: Fix debuginfo search for Ubuntu

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to check blacklist address correctly

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Do not show the skipped events

H. Nikolaus Schaller <hns@goldelico.com>
    w1: omap-hdq: cleanup to add missing newline for some dev_dbg

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: pasemi: Fix the probe error path

Álvaro Fernández Rojas <noltari@gmail.com>
    mtd: rawnand: brcmnand: fix hamming oob layout

NeilBrown <neilb@suse.de>
    sunrpc: clean up properly in gss_mech_unregister()

NeilBrown <neilb@suse.de>
    sunrpc: svcauth_gss_register_pseudoflavor must reject duplicate registrations.

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: force to build vmlinux if CONFIG_MODVERSION=y

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Save FSCR to init_task.thread.fscr after feature init

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Don't let DT CPU features set FSCR_DSCR

Michael Ellerman <mpe@ellerman.id.au>
    drivers/macintosh: Fix memleak in windfarm_pm112 driver

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: Correct PL310 Auxiliary Control Register initialization

Douglas Anderson <dianders@chromium.org>
    kernel/cpu_pm: Fix uninitted local in cpu_pm

Eric Biggers <ebiggers@google.com>
    dm crypt: avoid truncating the logical block size

Al Viro <viro@zeniv.linux.org.uk>
    sparc64: fix misuses of access_process_vm() in genregs32_[sg]et()

Al Viro <viro@zeniv.linux.org.uk>
    sparc32: fix register window handling in genregs32_[gs]et()

Jonathan Bakker <xc-racer2@live.ca>
    pinctrl: samsung: Save/restore eint_mask over suspend for EINT_TYPE GPIOs

Anders Roxell <anders.roxell@linaro.org>
    power: vexpress: add suppress_bind_attrs to true

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igb: Report speed and duplex as unknown when device is runtime suspended

Tomi Valkeinen <tomi.valkeinen@ti.com>
    media: ov5640: fix use of destroyed mutex

Larry Finger <Larry.Finger@lwfinger.net>
    b43_legacy: Fix connection problem with WPA3

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix connection problem with WPA3

Larry Finger <Larry.Finger@lwfinger.net>
    b43legacy: Fix case where channel status is corrupted

Chuhong Yuan <hslester96@gmail.com>
    media: go7007: fix a miss of snd_card_free

Christian Lamparter <chunkeey@gmail.com>
    carl9170: remove P2P_GO support

Punit Agrawal <punit1.agrawal@toshiba.co.jp>
    e1000e: Relax condition to trigger reset for ME workaround

Kai-Heng Feng <kai.heng.feng@canonical.com>
    e1000e: Disable TSO for buffer overrun workaround

Ashok Raj <ashok.raj@intel.com>
    PCI: Program MPS for RCiEP devices

Giuliano Procida <gprocida@google.com>
    blk-mq: move _blk_mq_update_nr_hw_queues synchronize_rcu call

Filipe Manana <fdmanana@suse.com>
    btrfs: fix wrong file range cleanup after an error filling dealloc range

Omar Sandoval <osandov@fb.com>
    btrfs: fix error handling when submitting direct I/O bio

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Unify ACS quirk desired vs provided checking

Ashok Raj <ashok.raj@intel.com>
    PCI: Add ACS quirk for Intel Root Complex Integrated Endpoints

Abhishek Sahu <abhsahu@nvidia.com>
    PCI: Generalize multi-function power dependency device links

Lukas Wunner <lukas@wunner.de>
    vga_switcheroo: Use device link for HDA controller

Lukas Wunner <lukas@wunner.de>
    vga_switcheroo: Deduplicate power state tracking

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Make ACS quirk implementations more uniform

Feng Kan <fkan@apm.com>
    PCI: Add ACS quirk for Ampere root ports

Abhinav Ratna <abhinav.ratna@broadcom.com>
    PCI: Add ACS quirk for iProc PAXB

Kevin Buettner <kevinb@redhat.com>
    PCI: Avoid FLR for AMD Starship USB 3.0

Marcos Scriven <marcos@scriven.org>
    PCI: Avoid FLR for AMD Matisse HD Audio & USB 3.0

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: Disable MSI for Freescale Layerscape PCIe RC mode

Eric Biggers <ebiggers@google.com>
    ext4: fix race between ext4_sync_parent() and rename()

Jeffle Xu <jefflexu@linux.alibaba.com>
    ext4: fix error pointer dereference

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    ext4: fix EXT_MAX_EXTENT/INDEX to check for zeroed eh_max

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Fix possible memory leak in evm_calc_hmac_or_hash()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Directly assign the ima_default_policy pointer to ima_rules

Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
    ima: Fix ima digest hash table key calculation

Andrea Arcangeli <aarcange@redhat.com>
    mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: send: emit file capabilities after chown

Daniel Axtens <dja@axtens.net>
    string.h: fix incompatibility between FORTIFY_SOURCE and KASAN

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: hp-wmi: Convert simple_strtoul() to kstrtou32()

Qiushi Wu <wu000273@umn.edu>
    cpuidle: Fix three reference count leaks

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Return any value retrieved from the dma_transfer callback

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci-esdhc-imx: fix the mask for tuning start point

Xie XiuQi <xiexiuqi@huawei.com>
    ixgbe: fix signed-integer-overflow warning

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: via-sdmmc: Respect the cmd->busy_timeout from the mmc core

Ulf Hansson <ulf.hansson@linaro.org>
    staging: greybus: sdio: Respect the cmd->busy_timeout from the mmc core

Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
    mmc: sdhci-msm: Set SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 quirk

YuanJunQing <yuanjunqing66@163.com>
    MIPS: Fix IRQ tracing when call handle_fpe() and handle_msa_fpe()

Jiaxun Yang <jiaxun.yang@flygoat.com>
    PCI: Don't disable decoding when mmio_always_on is set

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    macvlan: Skip loopback packets in RX handler

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Don't call via_flush_cache() on Mac IIfx

Arvind Sankar <nivedita@alum.mit.edu>
    x86/mm: Stop printing BRK addresses

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    mips: Add udelay lpj numbers adjustment

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    mips: MAAR: Use more precise address mask

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot: Correct relocation destination on old linkers

Pali Rohár <pali@kernel.org>
    mwifiex: Fix memory corruption in dump_station

Dan Carpenter <dan.carpenter@oracle.com>
    rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: don't flush workqueue unconditionally in md_open

Bhupesh Sharma <bhsharma@redhat.com>
    net: qed*: Reduce RX and TX default ring count when running inside kdump kernel

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wcn36xx: Fix error handling path in 'wcn36xx_probe()'

Christoph Hellwig <hch@lst.de>
    nvme: refine the Qemu Identify CNS quirk

Daniel Thompson <daniel.thompson@linaro.org>
    kgdb: Fix spurious true from in_dbg_master()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    mips: cm: Fix an invalid error code of INTVN_*_ERR

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Truncate link address into 32bit for 32bit kernel

Devulapally Shiva Krishna <shiva@chelsio.com>
    Crypto/chcr: fix for ccm(aes) failed test

Jeremy Kerr <jk@ozlabs.org>
    powerpc/spufs: fix copy_to_user while atomic

Yunjian Wang <wangyunjian@huawei.com>
    net: allwinner: Fix use correct return type for ndo_start_xmit()

Dan Carpenter <dan.carpenter@oracle.com>
    media: cec: silence shift wrapping warning in __cec_s_log_addrs()

Wei Yongjun <weiyongjun1@huawei.com>
    net: lpc-enet: fix error return code in lpc_mii_init()

Jann Horn <jannh@google.com>
    exit: Move preemption fixup up, move blocking operations down

Nathan Chancellor <natechancellor@gmail.com>
    lib/mpi: Fix 64-bit MIPS build with Clang

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: set Rx mode before starting netif

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported

Paul Moore <paul@paul-moore.com>
    audit: fix a net reference leak in audit_list_rules_send()

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Make sparse_init() using top-down allocation

Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
    media: platform: fcp: Set appropriate DMA parameters

Colin Ian King <colin.king@canonical.com>
    media: dvb: return -EREMOTEIO on i2c transfer failure.

Paul Moore <paul@paul-moore.com>
    audit: fix a net reference leak in audit_send_reply()

Jitao Shi <jitao.shi@mediatek.com>
    dt-bindings: display: mediatek: control dpi pins mode to avoid leakage

Kees Cook <keescook@chromium.org>
    e1000: Distribute switch variables for initialization

Stephane Eranian <eranian@google.com>
    tools api fs: Make xxx__mountpoint() more scalable

Jaehoon Chung <jh80.chung@samsung.com>
    brcmfmac: fix wrong location to get firmware feature

Christoph Hellwig <hch@lst.de>
    staging: android: ion: use vmap instead of vm_map_ram

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()

Jon Doron <arilou@gmail.com>
    x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Fix Rx-only DMA transfers

Linus Walleij <linus.walleij@linaro.org>
    ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE

Filipe Manana <fdmanana@suse.com>
    btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clocksource: dw_apb_timer_of: Fix missing clockevent timers

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clocksource: dw_apb_timer: Make CPU-affiliation being optional

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Enable interrupts in accordance with DMA xfer mode

Douglas Anderson <dianders@chromium.org>
    kgdb: Prevent infinite recursive entries to the debugger

Hsin-Yu Chao <hychao@chromium.org>
    Bluetooth: Add SCO fallback for invalid LMP parameters error

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Build ATI Radeon GPU driver as module

Jesper Dangaard Brouer <brouer@redhat.com>
    ixgbe: Fix XDP redirect on archs with PAGE_SIZE above 4K

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw: Zero DMA Tx and Rx configurations on stack

Arthur Kiyanovski <akiyano@amazon.com>
    net: ena: fix error returning in ena_com_get_hash_function()

Evan Green <evgreen@chromium.org>
    spi: pxa2xx: Apply CS clk quirk to BXT

Julien Thierry <jthierry@redhat.com>
    objtool: Ignore empty alternatives

Brad Love <brad@nextdimension.cc>
    media: si2157: Better check for running tuner in init

Arnd Bergmann <arnd@arndb.de>
    crypto: ccp -- don't "select" CONFIG_DMADEVICES

Bogdan Togorean <bogdan.togorean@analog.com>
    drm: bridge: adv7511: Extend list of audio sample rates

Ard Biesheuvel <ardb@kernel.org>
    ACPI: GED: use correct trigger type field in _Exx / _Lxx handling

Juergen Gross <jgross@suse.com>
    xen/pvcalls-back: test for errors when calling backend_connect()

Xiaolong Huang <butterflyhuangxx@gmail.com>
    can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdio: Fix potential NULL pointer error in mmc_sdio_init_card()

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

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    video: fbdev: w100fb: Fix a potential double free.

Eric W. Biederman <ebiederm@xmission.com>
    proc: Use new_inode not new_inode_pseudo

Yuxuan Shui <yshuiv7@gmail.com>
    ovl: initialize error in ovl_copy_xattr

tannerlove <tannerlove@google.com>
    selftests/net: in rxtimestamp getopt_long needs terminating null entry

Longpeng(Mike) <longpeng2@huawei.com>
    crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()

Longpeng(Mike) <longpeng2@huawei.com>
    crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()

Longpeng(Mike) <longpeng2@huawei.com>
    crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req()

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835: Fix controller unregister order

Lukas Wunner <lukas@wunner.de>
    spi: pxa2xx: Fix controller unregister order

Lukas Wunner <lukas@wunner.de>
    spi: Fix controller unregister order

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: No need to assign dummy value in spi_unregister_controller()

Lukas Wunner <lukas@wunner.de>
    spi: dw: Fix controller unregister order

Sasha Levin <sashal@kernel.org>
    spi: dw: fix possible race condition

Anthony Steinhauser <asteinhauser@google.com>
    x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for indirect branches.

Anthony Steinhauser <asteinhauser@google.com>
    x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.

Thomas Lendacky <Thomas.Lendacky@amd.com>
    x86/speculation: Add support for STIBP always-on preferred mode

Waiman Long <longman@redhat.com>
    x86/speculation: Change misspelled STIPB to STIBP

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: only do L1TF workaround on affected processors

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Consolidate "is MMIO SPTE" code

Kai Huang <kai.huang@linux.intel.com>
    kvm: x86: Fix L1TF mitigation for shadow MMU

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    ALSA: pcm: disallow linking stream to itself

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium/nitrox - Fix 'nitrox_get_first_device()' when ndevlist is fully iterated

Justin Chen <justinpopo6@gmail.com>
    spi: bcm-qspi: when tx/rx buffer is NULL set to 0

Lukas Wunner <lukas@wunner.de>
    spi: bcm2835aux: Fix controller unregister order

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

Tejun Heo <tj@kernel.org>
    cgroup, blkcg: Prepare some symbols for module and !CONFIG_CGROUP usages

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Avoid using power resources if there are none for D0

Ard Biesheuvel <ardb@kernel.org>
    ACPI: GED: add support for _Exx / _Lxx handler methods

Qiushi Wu <wu000273@umn.edu>
    ACPI: CPPC: Fix reference count leak in acpi_cppc_processor_probe()

Qiushi Wu <wu000273@umn.edu>
    ACPI: sysfs: Fix reference count leak in acpi_sysfs_add_hotplug_profile()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix inconsistent card PM state after resume

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - add a pintbl quirk for several Lenovo machines

Chuhong Yuan <hslester96@gmail.com>
    ALSA: es1688: Add the missed snd_card_free()

Ard Biesheuvel <ardb@kernel.org>
    efi/efivars: Add missing kobject_put() in sysfs entry creation error path

Hill Ma <maahiuzeon@gmail.com>
    x86/reboot/quirks: Add MacBook6,1 reboot quirk

Anthony Steinhauser <asteinhauser@google.com>
    x86/speculation: Prevent rogue cross-process SSBD shutdown

Xiaochun Lee <lixc17@lenovo.com>
    x86/PCI: Mark Intel C620 MROMs as having non-compliant BARs

Bob Haarman <inglorion@google.com>
    x86_64: Fix jiffies ODR violation

Waiman Long <longman@redhat.com>
    mm: add kvfree_sensitive() for freeing sensitive data objects

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Accept the instance number of kretprobe event

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Silence undersized packet warnings

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Clear the page tables for the ESB IO mapping

Thomas Falcon <tlfalcon@linux.ibm.com>
    drivers/net/ibmvnic: Update VNIC protocol version reporting

Dennis Kadioglu <denk@eclipso.email>
    Input: synaptics - add a second working PNP_ID for Lenovo T470s

Jens Axboe <axboe@kernel.dk>
    sched/fair: Don't NUMA balance for kthreads

Fredrik Strupe <fredrik@strupe.net>
    ARM: 8977/1: ptrace: Fix mask for thumb breakpoint hook

Su Kang Yin <cantona@cantona.net>
    crypto: talitos - fix ECB and CBC algs ivsize

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: imx: Fix handling of TC irq in combination with DMA

Christophe Leroy <christophe.leroy@c-s.fr>
    lib: Reduce user_access_begin() boundaries in strncpy_from_user() and strnlen_user()

Will Deacon <will.deacon@arm.com>
    x86: uaccess: Inhibit speculation past access_ok() in user_access_begin()

Stafford Horne <shorne@gmail.com>
    arch/openrisc: Fix issues with access_ok()

Linus Torvalds <torvalds@linux-foundation.org>
    Fix 'acccess_ok()' on alpha and SH

Linus Torvalds <torvalds@linux-foundation.org>
    make 'user_access_begin()' do 'access_ok()'

Ido Schimmel <idosch@mellanox.com>
    vxlan: Avoid infinite loop when suppressing NS messages with invalid options

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: fix IPV6_ADDRFORM operation logic


-------------

Diffstat:

 .../bindings/display/mediatek/mediatek,dpi.txt     |   6 +
 Documentation/virtual/kvm/api.txt                  |   2 +
 Makefile                                           |  17 +-
 arch/alpha/include/asm/uaccess.h                   |   8 +-
 arch/arm/kernel/ptrace.c                           |   4 +-
 arch/arm/mach-tegra/tegra.c                        |   4 +-
 arch/arm/mm/proc-macros.S                          |   3 +-
 arch/arm64/include/asm/kvm_host.h                  |   6 +-
 arch/m68k/include/asm/mac_via.h                    |   1 +
 arch/m68k/mac/config.c                             |  21 +-
 arch/m68k/mac/via.c                                |   6 +-
 arch/mips/Makefile                                 |  13 +-
 arch/mips/boot/compressed/Makefile                 |   2 +-
 arch/mips/configs/loongson3_defconfig              |   2 +-
 arch/mips/include/asm/kvm_host.h                   |   6 +-
 arch/mips/include/asm/mipsregs.h                   |   2 +-
 arch/mips/kernel/genex.S                           |   6 +-
 arch/mips/kernel/mips-cm.c                         |   6 +-
 arch/mips/kernel/setup.c                           |  10 +
 arch/mips/kernel/time.c                            |  70 +++++++
 arch/mips/kernel/vmlinux.lds.S                     |   2 +-
 arch/openrisc/include/asm/uaccess.h                |   8 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   8 +
 arch/powerpc/kernel/prom.c                         |  19 ++
 arch/powerpc/platforms/cell/spufs/file.c           | 113 ++++++----
 arch/powerpc/sysdev/xive/common.c                  |   5 +
 arch/sh/include/asm/uaccess.h                      |   7 +-
 arch/sparc/kernel/ptrace_32.c                      | 228 +++++++++------------
 arch/sparc/kernel/ptrace_64.c                      |  17 +-
 arch/x86/boot/compressed/head_32.S                 |   5 +-
 arch/x86/boot/compressed/head_64.S                 |   1 +
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/nospec-branch.h               |   1 +
 arch/x86/include/asm/uaccess.h                     |  12 +-
 arch/x86/kernel/cpu/bugs.c                         |  94 ++++++---
 arch/x86/kernel/process.c                          |  28 +--
 arch/x86/kernel/process.h                          |   2 +-
 arch/x86/kernel/reboot.c                           |   8 +
 arch/x86/kernel/time.c                             |   4 -
 arch/x86/kernel/vmlinux.lds.S                      |   4 +-
 arch/x86/kvm/mmu.c                                 |  37 ++--
 arch/x86/kvm/svm.c                                 |   6 +-
 arch/x86/kvm/vmx.c                                 |   2 +-
 arch/x86/mm/init.c                                 |   2 -
 arch/x86/pci/fixup.c                               |   4 +
 block/blk-mq.c                                     |   8 +-
 drivers/acpi/cppc_acpi.c                           |   1 +
 drivers/acpi/device_pm.c                           |   2 +-
 drivers/acpi/evged.c                               |  22 +-
 drivers/acpi/scan.c                                |  28 ++-
 drivers/acpi/sysfs.c                               |   4 +-
 drivers/char/agp/intel-gtt.c                       |   4 +-
 drivers/clocksource/dw_apb_timer.c                 |   5 +-
 drivers/clocksource/dw_apb_timer_of.c              |   6 +-
 drivers/cpuidle/sysfs.c                            |   6 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |   4 +-
 drivers/crypto/ccp/Kconfig                         |   3 +-
 drivers/crypto/chelsio/chcr_algo.c                 |   2 +-
 drivers/crypto/talitos.c                           |   2 +-
 drivers/crypto/virtio/virtio_crypto_algs.c         |  21 +-
 drivers/firmware/efi/efivars.c                     |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 -
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |  12 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  17 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   2 -
 drivers/gpu/drm/radeon/radeon_drv.c                |   2 -
 drivers/gpu/vga/vga_switcheroo.c                   | 142 +++----------
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/macintosh/windfarm_pm112.c                 |  21 +-
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/md.c                                    |   3 +-
 drivers/media/cec/cec-adap.c                       |   8 +-
 drivers/media/i2c/ov5640.c                         |   4 +-
 drivers/media/platform/rcar-fcp.c                  |   5 +
 drivers/media/tuners/si2157.c                      |  15 +-
 drivers/media/usb/dvb-usb/dibusb-mb.c              |   2 +-
 drivers/media/usb/go7007/snd-go7007.c              |  35 ++--
 drivers/mmc/core/sdio.c                            |   3 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 +-
 drivers/mmc/host/sdhci-msm.c                       |  10 +-
 drivers/mmc/host/via-sdmmc.c                       |   7 +-
 drivers/mtd/nand/brcmnand/brcmnand.c               |  11 +-
 drivers/mtd/nand/pasemi_nand.c                     |   4 +-
 drivers/net/can/usb/kvaser_usb.c                   |   6 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   4 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |   6 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   4 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |  16 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |   3 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |   2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  11 +-
 drivers/net/macvlan.c                              |   4 +
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   2 +
 drivers/net/vxlan.c                                |   4 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  58 ++++--
 drivers/net/wireless/ath/ath9k/hif_usb.h           |   6 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   6 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   3 +
 drivers/net/wireless/ath/ath9k/wmi.c               |   5 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |   3 +-
 drivers/net/wireless/ath/carl9170/fw.c             |   4 +-
 drivers/net/wireless/ath/carl9170/main.c           |  21 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   6 +-
 drivers/net/wireless/broadcom/b43/main.c           |   2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   1 +
 drivers/net/wireless/broadcom/b43legacy/xmit.c     |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   3 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  14 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   8 +-
 drivers/nvme/host/core.c                           |  16 +-
 drivers/pci/probe.c                                |  24 ++-
 drivers/pci/quirks.c                               | 207 +++++++++++++++----
 drivers/pinctrl/samsung/pinctrl-exynos.c           |   9 +
 drivers/platform/x86/hp-wmi.c                      |  10 +-
 drivers/power/reset/vexpress-poweroff.c            |   1 +
 drivers/spi/spi-bcm-qspi.c                         |   8 +-
 drivers/spi/spi-bcm2835.c                          |   4 +-
 drivers/spi/spi-bcm2835aux.c                       |   4 +-
 drivers/spi/spi-dw-mid.c                           |  16 +-
 drivers/spi/spi-dw.c                               |  15 +-
 drivers/spi/spi-pxa2xx.c                           |   5 +-
 drivers/spi/spi.c                                  |   4 +-
 drivers/staging/android/ion/ion_heap.c             |   4 +-
 drivers/staging/greybus/sdio.c                     |  10 +-
 drivers/tty/serial/imx.c                           |  22 +-
 drivers/video/fbdev/w100fb.c                       |   2 +
 drivers/w1/masters/omap_hdq.c                      |  10 +-
 drivers/xen/pvcalls-back.c                         |   3 +-
 fs/btrfs/file-item.c                               |   6 +-
 fs/btrfs/inode.c                                   |  10 +-
 fs/btrfs/send.c                                    |  67 ++++++
 fs/ext4/ext4_extents.h                             |   9 +-
 fs/ext4/fsync.c                                    |  28 ++-
 fs/ext4/xattr.c                                    |   7 +-
 fs/fat/inode.c                                     |   6 +
 fs/fs-writeback.c                                  |   1 +
 fs/nilfs2/segment.c                                |   2 +
 fs/overlayfs/copy_up.c                             |   2 +-
 fs/proc/inode.c                                    |   2 +-
 fs/proc/self.c                                     |   2 +-
 fs/proc/thread_self.c                              |   2 +-
 include/linux/kgdb.h                               |   2 +-
 include/linux/mm.h                                 |   1 +
 include/linux/pci_ids.h                            |   2 +
 include/linux/string.h                             |  60 ++++--
 include/linux/sunrpc/gss_api.h                     |   1 +
 include/linux/sunrpc/svcauth_gss.h                 |   3 +-
 include/linux/uaccess.h                            |   2 +-
 include/linux/vga_switcheroo.h                     |   6 -
 include/sound/hdaudio.h                            |   3 -
 include/uapi/linux/kvm.h                           |   2 +
 kernel/audit.c                                     |  52 +++--
 kernel/audit.h                                     |   2 +-
 kernel/auditfilter.c                               |  16 +-
 kernel/compat.c                                    |   6 +-
 kernel/cpu_pm.c                                    |   4 +-
 kernel/debug/debug_core.c                          |   1 +
 kernel/events/core.c                               |  23 ++-
 kernel/exit.c                                      |  31 +--
 kernel/sched/fair.c                                |   2 +-
 lib/mpi/longlong.h                                 |   2 +-
 lib/strncpy_from_user.c                            |  23 ++-
 lib/strnlen_user.c                                 |  23 ++-
 mm/huge_memory.c                                   |  31 ++-
 mm/slub.c                                          |   4 +-
 mm/util.c                                          |  18 ++
 net/bluetooth/hci_event.c                          |   1 +
 net/ipv6/ipv6_sockglue.c                           |  13 +-
 net/netfilter/nft_nat.c                            |   4 +-
 net/sunrpc/auth_gss/gss_mech_switch.c              |  12 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  18 +-
 security/integrity/evm/evm_crypto.c                |   2 +-
 security/integrity/ima/ima.h                       |   7 +-
 security/integrity/ima/ima_policy.c                |   3 +-
 security/keys/internal.h                           |  11 -
 security/keys/keyctl.c                             |  16 +-
 security/smack/smackfs.c                           |  10 +
 sound/core/pcm_native.c                            |   5 +
 sound/isa/es1688/es1688.c                          |   4 +-
 sound/pci/hda/hda_intel.c                          |  35 +++-
 sound/pci/hda/hda_intel.h                          |   3 -
 sound/pci/hda/patch_realtek.c                      |   6 +
 sound/usb/card.c                                   |  20 +-
 sound/usb/usbaudio.h                               |   2 +-
 tools/lib/api/fs/fs.c                              |  17 ++
 tools/lib/api/fs/fs.h                              |  12 ++
 tools/objtool/check.c                              |   6 +
 tools/perf/builtin-probe.c                         |   3 +
 tools/perf/util/dso.c                              |  16 ++
 tools/perf/util/dso.h                              |   1 +
 tools/perf/util/probe-event.c                      |  24 ++-
 tools/perf/util/probe-finder.c                     |   1 +
 tools/perf/util/symbol.c                           |   2 +
 .../networking/timestamping/rxtimestamp.c          |   1 +
 201 files changed, 1648 insertions(+), 924 deletions(-)


