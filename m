Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F054F2D3E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343654AbiDEI5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242255AbiDEIhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:37:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E234C1BE93;
        Tue,  5 Apr 2022 01:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00987B81A32;
        Tue,  5 Apr 2022 08:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E157C385A1;
        Tue,  5 Apr 2022 08:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147547;
        bh=6Lq4sipMDR5UXTKY8yA83D+TVvYA3yW3ZltgIU3EKrw=;
        h=From:To:Cc:Subject:Date:From;
        b=auRrQyoWg3dMfokFkLvi3mUjkpUYKkfcDXmsrrlVoL4QJ6kE7+1APofMzWngZRXyc
         LbjIAK5pVPKPqa8gwCC9yWozcMCflYFelEnHxZDSafNwpO7R/Q/3f1HdsjSOA2sX1Q
         aJZcJmIqgHw+hongtDr/Q6E8BBRrW6iVXfXVCMyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.16 0000/1017] 5.16.19-rc1 review
Date:   Tue,  5 Apr 2022 09:15:13 +0200
Message-Id: <20220405070354.155796697@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.16.19-rc1
X-KernelTest-Deadline: 2022-04-07T07:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.16.19 release.
There are 1017 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.16.19-rc1

Eric W. Biederman <ebiederm@xmission.com>
    coredump: Use the vma snapshot in fill_files_note

Eric W. Biederman <ebiederm@xmission.com>
    coredump/elf: Pass coredump_params into fill_note_info

Eric W. Biederman <ebiederm@xmission.com>
    coredump: Remove the WARN_ON in dump_vma_snapshot

Eric W. Biederman <ebiederm@xmission.com>
    coredump: Snapshot the vmas in do_coredump

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: do compare-and-exchange of gPTE via the user address

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: rtsx: Fix build errors/warnings for unused variable

Kai-Heng Feng <kai.heng.feng@canonical.com>
    mmc: rtsx: Let MMC core handle runtime PM

Jens Axboe <axboe@kernel.dk>
    Revert "nbd: fix possible overflow on 'first_minor' in nbd_dev_add()"

Jackie Liu <liuyun01@kylinos.cn>
    n64cart: convert bi_disk to bi_bdev->bd_disk fix build

Paul E. McKenney <paulmck@kernel.org>
    torture: Make torture.sh help message match reality

Martin Varghese <martin.varghese@nokia.com>
    openvswitch: Fixed nd target mask field in the flow dump.

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Avoid processing works if workqueue was destroyed

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: Fix indexing in ice_tx_xsk_pool()

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Do not write NULL in SW ring at allocation failure

Guilherme G. Piccoli <gpiccoli@igalia.com>
    docs: sysctl/kernel: add missing bit to panic_print

Anton Ivanov <anton.ivanov@cambridgegreys.com>
    um: Fix uml_mconsole stop/go

Kuldeep Singh <singh.kuldeep87k@gmail.com>
    arm64: dts: ls1046a: Update i2c node dma properties

Kuldeep Singh <singh.kuldeep87k@gmail.com>
    arm64: dts: ls1043a: Update i2c dma properties

Kuldeep Singh <singh.kuldeep87k@gmail.com>
    ARM: dts: spear13xx: Update SPI dma properties

Kuldeep Singh <singh.kuldeep87k@gmail.com>
    ARM: dts: spear1340: Update serial node properties

Leilk Liu <leilk.liu@mediatek.com>
    spi: mediatek: support tick_delay without enhance_timing

Guodong Liu <guodong.liu@mediatek.com>
    pinctrl: canonical rsel resistance selection property

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix crop rectangle affected by set format

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Add try support to selection API operations

Ian Rogers <irogers@google.com>
    perf vendor events: Update metrics for SkyLake Server

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Allow TLV control to be either read or write

Zheng Bin <zhengbin13@huawei.com>
    ASoC: SOF: Intel: Fix build error without SND_SOC_SOF_PCI_DEV

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Return error code if memory allocation fails in add_aeb()

Horatiu Vultur <horatiu.vultur@microchip.com>
    dt-bindings: pinctrl: pinctrl-microchip-sgpio: Fix example

Yong Wu <yong.wu@mediatek.com>
    dt-bindings: memory: mtk-smi: Correct minItems to 2 for the gals clocks

Yong Wu <yong.wu@mediatek.com>
    dt-bindings: memory: mtk-smi: No need mediatek,larb-id for mt8167

Yong Wu <yong.wu@mediatek.com>
    dt-bindings: memory: mtk-smi: Rename clock to clocks

Martin Kepplinger <martink@posteo.de>
    media: dt-bindings: media: hynix,hi846: add link-frequencies description

Martin Kepplinger <martink@posteo.de>
    media: dt-binding: media: hynix,hi846: use $defs/port-base port description

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: spi: mxic: The interrupt property is not mandatory

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: mtd: nand-controller: Fix a comment in the examples

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: mtd: nand-controller: Fix the reg property description

Kai-Heng Feng <kai.heng.feng@canonical.com>
    mmc: rtsx: Use pm_runtime_{get,put}() to handle runtime PM

Zhang Wensheng <zhangwensheng5@huawei.com>
    nbd: fix possible overflow on 'first_minor' in nbd_dev_add()

Hengqi Chen <hengqi.chen@gmail.com>
    bpf: Fix comment for helper bpf_current_task_under_cgroup()

Namhyung Kim <namhyung@kernel.org>
    bpf: Adjust BPF stack helper functions to accommodate skip > 0

Toke Høiland-Jørgensen <toke@redhat.com>
    libbpf: Define BTF_KIND_* constants in btf.h to avoid compilation errors

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    af_unix: Support POLLPRI for OOB.

Randy Dunlap <rdunlap@infradead.org>
    mm/usercopy: return 1 from hardened_usercopy __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    mm/memcontrol: return 1 from cgroup.memory __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    ARM: 9187/1: JIVE: fix return value of __setup handler

Randy Dunlap <rdunlap@infradead.org>
    mm/mmap: return 1 from stack_guard_gap __setup() handler

Eric Dumazet <edumazet@google.com>
    net: preserve skb_end_offset() in skb_unclone_keeptruesize()

Eric Dumazet <edumazet@google.com>
    net: add skb_set_end_offset() helper

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have type enum modifications copy the strings

Linus Torvalds <torvalds@linux-foundation.org>
    Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: soc-compress: Change the check for codec_dai

Will Deacon <will@kernel.org>
    arm64: mm: Drop 'const' from conditional arm64_dma_phys_limit definition

Wan Jiabing <wanjiabing@vivo.com>
    docs: fix 'make htmldocs' warning in SCTP.rst

Arınç ÜNAL <arinc.unal@arinc9.com>
    staging: mt7621-dts: fix pinctrl-0 items to be size-1 items on ethernet

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Add qla2x00_async_done() for async routines

Maxime Ripard <maxime@cerno.tech>
    drm/connector: Fix typo in documentation

Lv Ruyi <lv.ruyi@zte.com.cn>
    proc: bootconfig: Add null pointer check

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: restore accidentally removed MSG_PEEK feature

Prashant Malani <pmalani@chromium.org>
    platform/chrome: cros_ec_typec: Check for EC device

Jon Hunter <jonathanh@nvidia.com>
    spi: Fix Tegra QSPI example

Anirudh Rayabharam <mail@anirudhrb.com>
    vhost: handle error while adding split ranges to iotlb

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: CPPC: Avoid out of bounds access when parsing _CPC data

Fangrui Song <maskray@google.com>
    riscv module: remove (NOLOAD)

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix memory leak of uid in files registration

Stefano Garzarella <sgarzare@redhat.com>
    virtio: use virtio_device_ready() in virtio_device_restore()

Jason Wang <jasowang@redhat.com>
    Revert "virtio_pci: harden MSI-X interrupts"

Jason Wang <jasowang@redhat.com>
    Revert "virtio-pci: harden INTX interrupts"

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    block: Fix the maximum minor value is blk_alloc_ext_minor()

Arnd Bergmann <arnd@arndb.de>
    ARM: iop32x: offset IRQ numbers by 1

Baokun Li <libaokun1@huawei.com>
    ubi: Fix race condition between ctrl_cdev_ioctl and ubi_cdev_ioctl

Jiaxin Yu <jiaxin.yu@mediatek.com>
    ASoC: mediatek: mt6358: add missing EXPORT_SYMBOLs

Meng Tang <tangmeng@uniontech.com>
    ASoC: rockchip: i2s_tdm: Fixup config for SND_SOC_DAIFMT_DSP_A/B

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    pinctrl: nuvoton: npcm7xx: Use %zu printk format for ARRAY_SIZE()

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    pinctrl: nuvoton: npcm7xx: Rename DS() macro to DSTR()

Randy Dunlap <rdunlap@infradead.org>
    net: sparx5: uses, depends on BRIDGE or !BRIDGE

Miaoqian Lin <linmq006@gmail.com>
    watchdog: rti-wdt: Add missing pm_runtime_disable() in probe function

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: pinconf-generic: Print arguments for bias-pull-*

Eric Dumazet <edumazet@google.com>
    watch_queue: Free the page array when watch_queue is dismantled

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: arm/aes-neonbs-cbc - Select generic cbc and aes

Robin Gong <yibin.gong@nxp.com>
    mailbox: imx: fix wakeup failure from freeze mode

David Howells <dhowells@redhat.com>
    rxrpc: Fix call timer start racing with call destruction

Xiaolong Huang <butterflyhuangxx@gmail.com>
    rxrpc: fix some null-ptr-deref bugs in server_key.c

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix software vlan talbe of vlan 0 inconsistent with hardware

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix the concurrency between functions reading debugfs

Andrew Price <anprice@redhat.com>
    gfs2: Make sure FITRIM minlen is rounded up to fs block size

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix gfs2_file_buffered_write endless loop workaround

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: gfs2_setattr_size error path fix

Carlos Llamas <cmllamas@google.com>
    loop: fix ioctl calls using compat_loop_info

Tom Rix <trix@redhat.com>
    rtc: check if __rtc_read_time was successful

Masahiro Yamada <masahiroy@kernel.org>
    modpost: restore the warning message for missing symbol versions

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Update the LRU list in xas_split()

Tom Rix <trix@redhat.com>
    can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix return of error value

Pavel Skripkin <paskripkin@gmail.com>
    can: mcba_usb: properly check endpoint type

Hangyu Hua <hbh25y@gmail.com>
    can: mcba_usb: mcba_usb_start_xmit(): fix double dev_kfree_skb in error path

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix xas_create_range() when multi-order entry present

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: socket: ignore v6 endpoints when ipv6 is disabled

Wang Hai <wanghai38@huawei.com>
    wireguard: socket: free skb in send6 when ipv6 is disabled

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: queueing: use CFI-safe ptr_ring cleanup function

Pankaj Raghav <p.raghav@samsung.com>
    nvme: fix the read-only state for zoned namespaces with unsupposed features

Sungup Moon <sungup.moon@samsung.com>
    nvme: allow duplicate NSIDs for private namespaces

Baokun Li <libaokun1@huawei.com>
    ubifs: rename_whiteout: correct old_dir size computing

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix to add refcount once page is set private

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix read out-of-bounds in ubifs_wbuf_write_nolock()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: setflags: Make dirtied_ino_d 8 bytes aligned

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Rectify space amount budget for mkdir/tmpfile operations

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix 'ui->dirty' race between do_tmpfile() and writeback work

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Rename whiteout atomically

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Add missing iput if do_tmpfile() failed in rename whiteout

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix deadlock in concurrent rename whiteout and inode writeback

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: rename_whiteout: Fix double free for whiteout_ui->data

Yi Wang <wang.yi59@zte.com.cn>
    KVM: SVM: fix panic on out-of-bounds guest IRQ

Li RongQing <lirongqing@baidu.com>
    KVM: x86: fix sending PV IPI

David Matlack <dmatlack@google.com>
    KVM: Prevent module exit until all VMs are freed

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq

Paul Cercueil <paul@crapouillou.net>
    MIPS: crypto: Fix CRC32 code

Gwendal Grignou <gwendal@chromium.org>
    platform: chrome: Split trace include file

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: Use correct feature type field during RFF_ID processing

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Reduce false trigger to login

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix stuck session of PRLI reject

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix N2N inconsistent PLOGI

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix crash during module load unload test

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix missed DMA unmap for NVMe ls requests

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix laggy FC remote port session recovery

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix hang due to session stuck

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix incorrect reporting of task management failure

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix disk failure to rediscover

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Suppress a kernel complaint in qla_create_qpair()

Joe Carnuccio <joe.carnuccio@cavium.com>
    scsi: qla2xxx: Check for firmware dump already collected

Joe Carnuccio <joe.carnuccio@cavium.com>
    scsi: qla2xxx: Add devids and conditionals for 28xx

Joe Carnuccio <joe.carnuccio@cavium.com>
    scsi: qla2xxx: Fix T10 PI tag escape and IP guard options for 28XX adapters

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix clang warning

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix device reconnect in loop topology

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix warning for missing error code

Bikash Hazarika <bhazarika@marvell.com>
    scsi: qla2xxx: Fix wrong FDMI data for 64G adapter

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix premature hw access after PCI error

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix scheduling while atomic

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix warning message due to adisc being flushed

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix stuck session in gpdb

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Implement ref count for SRB

Daniel Wagner <dwagner@suse.de>
    scsi: qla2xxx: Refactor asynchronous command initialization

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Reject unsupported TMDS rates on ICL+

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix PSF GV point mask when SAGV is not possible

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Treat SAGV block time 0 as SAGV disabled

Kees Cook <keescook@chromium.org>
    drm/dp: Fix off-by-one in register cache size

Anders Roxell <anders.roxell@linaro.org>
    powerpc: Fix build errors with newer binutils

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Add set_memory_{p/np}() and remove set_memory_attr()

Anders Roxell <anders.roxell@linaro.org>
    powerpc/lib/sstep: Fix build errors with newer binutils

Anders Roxell <anders.roxell@linaro.org>
    powerpc/lib/sstep: Fix 'sthcx' instruction

Chen Jingwen <chenjingwen6@huawei.com>
    powerpc/kasan: Fix early region not updated correctly

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: hyper-v: Fix the maximum number of sparse banks for XMM fast TLB flush hypercalls

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: hyper-v: Drop redundant 'ex' parameter from kvm_hv_flush_tlb()

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: hyper-v: Drop redundant 'ex' parameter from kvm_hv_send_ipi()

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP MMU

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Zap _all_ roots when unmapping gfn range in TDP MMU

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Move "invalid" check out of kvm_tdp_mmu_get_root()

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap hook

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Reinitialize context if host userspace toggles EFER.LME

Matt Kramer <mccleetus@gmail.com>
    ALSA: hda/realtek: Add alc256-samsung-headphone fixup

Mauro Carvalho Chehab <mchehab@kernel.org>
    media: atomisp: fix bad usage at error handling logic

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: host: Return an error when ->enable_sdio_irq() ops is missing

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have TRACE_DEFINE_ENUM affect trace event types as well

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_es8336: log all quirks

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_es8336: use NHLT information to set dmic and SSP

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: Revert "ASoC: Intel: sof_es8336: add quirk for Huawei D15 2021"

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: soc-acpi: add more ACPI HIDs for ES83x6 devices

Anthony I Gilea <i@cpp.in>
    ASoC: Intel: sof_sdw: fix quirks for 2022 HP Spectre x360 13"

Dongliang Mu <mudongliangabcd@gmail.com>
    media: hdpvr: initialize dev->worker at hdpvr_register_videodev

Pavel Skripkin <paskripkin@gmail.com>
    media: Revert "media: em28xx: add missing em28xx_close_extension"

Hans de Goede <hdegoede@redhat.com>
    media: i2c: ov5648: Fix lockdep error

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: sm712fb: Fix crash in smtcfb_write()

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: vangogh: fix uninitialized symbol warning in machine driver

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: vg: fix for pm resume callback sequence

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    ARM: mmp: Fix failure to remove sram device

Richard Leitner <richard.leitner@skidata.com>
    ARM: tegra: tamonten: Fix I2C3 pad setting

Arnd Bergmann <arnd@arndb.de>
    lib/test_lockup: fix kernel pointer check for separate address spaces

Arnd Bergmann <arnd@arndb.de>
    uaccess: fix type mismatch warnings from access_ok()

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5682s: Fix the wrong jack type detected

Daniel González Cabanelas <dgcbueu@gmail.com>
    media: cx88-mpeg: clear interrupt status register before streaming video

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: fix a bug of accessing array out of bounds

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    ASoC: Intel: sof_es8336: add quirk for Huawei D15 2021

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: soc-core: skip zero num_dai component in searching dai name

Richard Schleich <rs@noreya.tech>
    ARM: dts: bcm2711: Add the missing L1/L2 cache information

Jing Yao <yao.jing2@zte.com.cn>
    video: fbdev: udlfb: replace snprintf in show functions with sysfs_emit

Jing Yao <yao.jing2@zte.com.cn>
    video: fbdev: omapfb: panel-tpo-td043mtea1: Use sysfs_emit() instead of snprintf()

Jing Yao <yao.jing2@zte.com.cn>
    video: fbdev: omapfb: panel-dsi-cm: Use sysfs_emit() instead of snprintf()

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    arm64: defconfig: build imx-sdma as a module

Abel Vesa <abel.vesa@nxp.com>
    ARM: dts: imx7: Use audio_mclk_post_div instead audio_mclk_root_clk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix driver index handling at re-binding

Ard Biesheuvel <ardb@kernel.org>
    ARM: ftrace: avoid redundant loads or clobbering IP

Tsuchiya Yuto <kitakar@gmail.com>
    media: atomisp: fix dummy_ptr check to avoid duplicate active_bo

Hans de Goede <hdegoede@redhat.com>
    media: atomisp_gmin_platform: Add DMI quirk to not turn AXP ELDO2 regulator off on some boards

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: madera: Add dependencies on MFD

Richard Schleich <rs@noreya.tech>
    ARM: dts: bcm2837: Add the missing L1/L2 cache information

David Heidelberg <david@ixit.cz>
    ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960

Yang Guang <yang.guang5@zte.com.cn>
    video: fbdev: omapfb: acx565akm: replace snprintf with sysfs_emit

George Kennedy <george.kennedy@oracle.com>
    video: fbdev: cirrusfb: check pixclock to avoid divide by zero

Evgeny Novikov <novikov@ispras.ru>
    video: fbdev: w100fb: Reset global state

Tim Gardner <tim.gardner@canonical.com>
    video: fbdev: nvidiafb: Use strscpy() to prevent buffer overflow

Yong Wu <yong.wu@mediatek.com>
    media: iommu/mediatek: Add device_link between the consumer and the larb devices

Yong Wu <yong.wu@mediatek.com>
    media: iommu/mediatek: Return ENODEV if the device is NULL

Yong Wu <yong.wu@mediatek.com>
    media: iommu/mediatek-v1: Free the existed fwspec if the master dev already has

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: hda: Remove link assignment limitation

Mirela Rabulea <mirela.rabulea@oss.nxp.com>
    media: imx-jpeg: Prevent decoding NV12M jpegs into single-planar buffers

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: Intel: match sdw version on link_slaves_found

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Report full jack status when plug is detected

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    ASoC: sh: rz-ssi: Make the data structures available before registering the handlers

Peiwei Hu <jlu.hpw@foxmail.com>
    media: ir_toy: free before error exiting

Eugen Hristev <eugen.hristev@microchip.com>
    media: atmel: atmel-isc-base: report frame sizes as full supported range

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: staging: media: zoran: fix various V4L2 compliance errors

Corentin Labbe <clabbe@baylibre.com>
    media: staging: media: zoran: calculate the right buffer number for zoran_reap_stat_com

Corentin Labbe <clabbe@baylibre.com>
    media: staging: media: zoran: move videodev alloc

Dongliang Mu <mudongliangabcd@gmail.com>
    ntfs: add sanity check on allocation size

Rohith Surabattula <rohiths@microsoft.com>
    Adjust cifssb maximum read size

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to print raw data size in error path of lz4 decompression

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: use spin_lock to avoid hang

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not clean up repair bio if submit fails

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not double complete bio on errors during compressed reads

Josef Bacik <josef@toxicpanda.com>
    btrfs: handle csum lookup errors properly on reads

Josef Bacik <josef@toxicpanda.com>
    btrfs: make search_csum_tree return 0 if we get -EFBIG

Anand Jain <anand.jain@oracle.com>
    btrfs: harden identification of a stale device

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: don't get FREEZE lock in f2fs_evict_inode in frozen fs

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix nfsd_breaker_owns_lease() return values

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on curseg->alloc_type

Theodore Ts'o <tytso@mit.edu>
    ext4: don't BUG if someone dirty pages without asking ext4 first

Valentin Schneider <valentin.schneider@arm.com>
    sched/tracing: Report TASK_RTLOCK_WAIT tasks as TASK_UNINTERRUPTIBLE

Valentin Schneider <valentin.schneider@arm.com>
    sched/tracing: Don't re-read p->state when emitting sched_switch event

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix ext4_mb_mark_bb() with flex_bg with fast_commit

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: correct cluster len and clusters changed accounting in ext4_mb_mark_bb

Waiman Long <longman@redhat.com>
    locking/lockdep: Iterate lock_classes directly when reading lockdep files

Mark Rutland <mark.rutland@arm.com>
    atomics: Fix atomic64_{read_acquire,set_release} fallbacks

Eddie James <eajames@linux.ibm.com>
    spi: fsi: Implement a timeout for polling status

Minghao Chi <chi.minghao@zte.com.cn>
    spi: tegra20: Use of_device_get_match_data()

Chris Leech <cleech@redhat.com>
    nvme-tcp: lockdep: annotate in-kernel sockets

John David Anglin <dave.anglin@bell.net>
    parisc: Fix handling off probe non-access faults

John David Anglin <dave.anglin@bell.net>
    parisc: Fix non-access data TLB cache flush faults

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    PM: core: keep irq flags in device_pm_check_callbacks()

Darren Hart <darren@os.amperecomputing.com>
    ACPI/APEI: Limit printable size of BERT table data

Paolo Valente <paolo.valente@linaro.org>
    Revert "Revert "block, bfq: honor already-setup queue merges""

Paul Menzel <pmenzel@molgen.mpg.de>
    lib/raid6/test/Makefile: Use $(pound) instead of \# for Make 4.3

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Avoid walking the ACPI Namespace if it is not there

Zhang Wensheng <zhangwensheng5@huawei.com>
    bfq: fix use-after-free in bfq_dispatch_request

Akira Kawata <akirakawata1@gmail.com>
    fs/binfmt_elf: Fix AT_PHDR for unusual ELF files

Souptick Joarder (HPE) <jrdr.linux@gmail.com>
    irqchip/nvic: Release nvic_base upon failure

Marc Zyngier <maz@kernel.org>
    irqchip/qcom-pdc: Fix broken locking

Casey Schaufler <casey@schaufler-ca.com>
    Fix incorrect type in assignment of ipv6 port for audit

Chaitanya Kulkarni <kch@nvidia.com>
    loop: use sysfs_emit() in the sysfs xxx show()

Richard Haines <richard_c_haines@btinternet.com>
    selinux: allow FIOCLEX and FIONCLEX with policy capability

Fangrui Song <maskray@google.com>
    arm64: module: remove (NOLOAD) from linker script

Daniel Lezcano <daniel.lezcano@linaro.org>
    powercap/dtpm_cpu: Reset per_cpu variable in the release function

Christian Göttsche <cgzones@googlemail.com>
    selinux: use correct type for context length

Yu Kuai <yukuai3@huawei.com>
    block, bfq: don't move oom_bfqq

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/sec - not need to enable sm4 extra mode at HW V3

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: xts - Add softdep on ecb

Yahu Gao <gaoyahu19@gmail.com>
    block/bfq_wf2q: correct weight to ioprio

Christoph Hellwig <hch@lst.de>
    memstick/mspro_block: fix handling of read-only devices

Ming Lei <ming.lei@redhat.com>
    block: throttle split bio in case of iops limit

Paul E. McKenney <paulmck@kernel.org>
    rcu: Mark writes to the rcu_segcblist structure's ->flags field

Marc Zyngier <maz@kernel.org>
    pinctrl: npcm: Fix broken references to chip->parent_device

David Woodhouse <dwmw@amazon.co.uk>
    rcu: Kill rnp->ofl_seq and use only rcu_state.ofl_lock for exclusion

Kees Cook <keescook@chromium.org>
    gcc-plugins/stackleak: Exactly match strings instead of prefixes

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/qm - cleanup warning in qm_vf_read_qos

Dave Stevenson <dave.stevenson@raspberrypi.com>
    regulator: rpi-panel: Handle I2C errors/timing to the Atmel

Casey Schaufler <casey@schaufler-ca.com>
    LSM: general protection fault in legacy_parse_param

Linus Torvalds <torvalds@linux-foundation.org>
    fs: fix fd table size alignment properly

Dan Carpenter <dan.carpenter@oracle.com>
    lib/test: use after free in register_test_dev_kmod()

Linus Torvalds <torvalds@linux-foundation.org>
    fs: fd tables have to be multiples of BITS_PER_LONG

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Fix another issue with a list iterator pointing to the head

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    net/sched: act_ct: fix ref leak when switching zones

Florian Westphal <fw@strlen.de>
    net: prefer nf_ct_put instead of nf_conntrack_put

Jakub Kicinski <kuba@kernel.org>
    selftests: tls: skip cmsg_to_pipe tests with TLS=n

Tom Rix <trix@redhat.com>
    octeontx2-af: initialize action variable

Zheng Yongjun <zhengyongjun3@huawei.com>
    net: sparx5: switchdev: fix possible NULL pointer dereference

Duoming Zhou <duoming@zju.edu.cn>
    net/x25: Fix null-ptr-deref caused by x25_disconnect

Tom Rix <trix@redhat.com>
    qlcnic: dcb: default to returning -EOPNOTSUPP

Randy Dunlap <rdunlap@infradead.org>
    net: sparx5: depends on PTP_1588_CLOCK_OPTIONAL

Peng Li <lipeng321@huawei.com>
    net: hns3: clean residual vf config after disable sriov

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't loop forever in nfs_do_recoalesce()

Ido Schimmel <idosch@nvidia.com>
    selftests: test_vxlan_under_vrf: Fix broken test case

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Fix brcm_fet_config_init()

Jian Shen <shenjian15@huawei.com>
    net: hns3: refine the process when PF set VF VLAN

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: format the output of the MAC address

Jian Shen <shenjian15@huawei.com>
    net: hns3: add vlan list lock to protect vlan list

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix port base vlan add fail when concurrent with reset

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix bug when PF set the duplicate MAC address for VFs

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: report software timestamping via SO_TIMESTAMPING

Juergen Gross <jgross@suse.com>
    xen: fix is_xen_pmu()

Maxime Ripard <maxime@cerno.tech>
    clk: Initialize orphan req_rate

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: enable VQs early on probe

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: read the negotiated features before using VQs

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: initialize vdev->priv before using VQs

Konrad Dybcio <konrad.dybcio@somainline.org>
    clk: qcom: gcc-msm8994: Fix gpll4 width

Thomas Richter <tmricht@linux.ibm.com>
    perf stat: Fix forked applications enablement of counters

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix the putarea helper function

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1: don't retry BIND_CONN_TO_SESSION on session error

Olga Kornievskaia <kolga@netapp.com>
    SUNRPC don't resend a task on an offlined transport

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options

Phil Sutter <phil@nwl.cc>
    netfilter: egress: Report interface as outgoing

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Don't call connect() more than once on a TCP socket

NeilBrown <neilb@suse.de>
    SUNRPC: improve 'swap' handling: scheduling and PF_MEMALLOC

NeilBrown <neilb@suse.de>
    SUNRPC/call_alloc: async tasks mustn't block waiting for memory

Pavel Skripkin <paskripkin@gmail.com>
    jfs: fix divide error in dbNextAG

Randy Dunlap <rdunlap@infradead.org>
    driver core: dd: fix return value of __setup handler

David Gow <davidgow@google.com>
    firmware: google: Properly state IOMEM dependency

Randy Dunlap <rdunlap@infradead.org>
    kgdbts: fix return value of __setup handler

Xiaolong Huang <butterflyhuangxx@gmail.com>
    virt: acrn: fix a memory leak in acrn_dev_ioctl()

Yonghua Huang <yonghua.huang@intel.com>
    virt: acrn: obtain pa from VMA with PFNMAP flag

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: fix XOFF/XON sending when DMA is used

Randy Dunlap <rdunlap@infradead.org>
    kgdboc: fix return value of __setup handler

Randy Dunlap <rdunlap@infradead.org>
    tty: hvc: fix return value of __setup handler

Miaoqian Lin <linmq006@gmail.com>
    pinctrl/rockchip: Add missing of_node_put() in rockchip_pinctrl_probe

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: nomadik: Add missing of_node_put() in nmk_pinctrl_probe

Michael Walle <michael@walle.cc>
    pinctrl: microchip-sgpio: lock RMW access

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Skip custom extra pin config dump for virtual GPIOs

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Fix pingroup pin config state readback

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Fix "argument" argument type for mtk_pinconf_get()

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Fix PIN_CONFIG_BIAS_* readback

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: mediatek: Fix missing of_node_put() in mtk_pctrl_init

Arınç ÜNAL <arinc.unal@arinc9.com>
    staging: mt7621-dts: fix GB-PC2 devicetree

Arınç ÜNAL <arinc.unal@arinc9.com>
    staging: mt7621-dts: fix pinctrl properties for ethernet

Arınç ÜNAL <arinc.unal@arinc9.com>
    staging: mt7621-dts: fix formatting

Arınç ÜNAL <arinc.unal@arinc9.com>
    staging: mt7621-dts: fix LEDs and pinctrl on GB-PC1 devicetree

Alexey Khoroshilov <khoroshilov@ispras.ru>
    NFS: remove unneeded check in decode_devicenotify_args()

Robin Gong <yibin.gong@nxp.com>
    mailbox: imx: fix crash in resume on i.mx8ulp

Miaoqian Lin <linmq006@gmail.com>
    clk: tegra: tegra124-emc: Fix missing put_device() call in emc_ensure_emc_driver

Maxime Ripard <maxime@cerno.tech>
    clk: Fix clk_hw_get_clk() when dev is NULL

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    clk: clps711x: Terminate clk_div_table with sentinel element

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    clk: hisilicon: Terminate clk_div_table with sentinel element

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    clk: loongson1: Terminate clk_div_table with sentinel element

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    clk: actions: Terminate clk_div_table with sentinel element

Dan Williams <dan.j.williams@intel.com>
    nvdimm/region: Fix default alignment for small regions

Miaoqian Lin <linmq006@gmail.com>
    remoteproc: qcom_q6v5_mss: Fix some leaks in q6v5_alloc_memory_region

Miaoqian Lin <linmq006@gmail.com>
    remoteproc: qcom_wcnss: Add missing of_node_put() in wcnss_alloc_memory_region

Miaoqian Lin <linmq006@gmail.com>
    remoteproc: qcom: Fix missing of_node_put in adsp_alloc_memory_region

Jie Hai <haijie1@huawei.com>
    dmaengine: hisi_dma: fix MSI allocate fail when reload hisi_dma

Taniya Das <tdas@codeaurora.org>
    clk: qcom: clk-rcg2: Update the frac table for pixel clock

Taniya Das <tdas@codeaurora.org>
    clk: qcom: clk-rcg2: Update logic to calculate D value for RCG

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    clk: at91: sama7g5: fix parents of PDMCs' GCLK

Dan Carpenter <dan.carpenter@oracle.com>
    clk: imx: off by one in imx_lpcg_parse_clks_from_dt()

Abel Vesa <abel.vesa@nxp.com>
    clk: imx7d: Remove audio_mclk_root_clk

Randy Dunlap <rdunlap@infradead.org>
    dma-debug: fix return value of __setup handlers

Martin Kaiser <martin@kaiser.cx>
    staging: r8188eu: fix endless loop in recv_func

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Return valid errors from nfs2/3_decode_dirent()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    habanalabs: Add check for pci_enable_device

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    iio: adc: Add check for devm_request_threaded_irq

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: 8250: Fix race condition in RTS-after-send handling

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Use of mapping_set_error() results in spurious errors

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_lpss: Balance reference count for PCI DMA device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_mid: Balance reference count for PCI DMA device

Rafał Miłecki <rafal@milecki.pl>
    phy: phy-brcm-usb: fixup BCM4908 support

Liu Ying <victor.liu@nxp.com>
    phy: dphy: Correct lpx parameter and its derivatives(ta_{get,go,sure})

Dirk Buchwalder <buchwalder@posteo.de>
    clk: qcom: ipq8074: Use floor ops for SDCC1 clock

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: checker: Fix miscalculation of number of states

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a77470: Reduce size for narrow VIN1 channel

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    staging:iio:adc:ad7280a: Fix handing of device address bit reversing.

Zev Weiss <zev@bewilderbeest.net>
    serial: 8250_aspeed_vuart: add PORT_ASPEED_VUART port type

Hangyu Hua <hbh25y@gmail.com>
    staging: qlge: add unregister_netdev in qlge_probe

Hans de Goede <hdegoede@redhat.com>
    iio: mma8452: Fix probe failing when an i2c_device_id is used

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: restore traffic class defaults after wq reset

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: change bandwidth token to read buffers

Robert Marko <robimarko@gmail.com>
    clk: qcom: ipq8074: fix PCI-E clock oops

Libin Yang <libin.yang@intel.com>
    soundwire: intel: fix wrong register name in intel_shim_wake

Luca Weiss <luca@z3ntu.xyz>
    cpufreq: qcom-cpufreq-nvmem: fix reading of PVS Valid fuse

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    misc: alcor_pci: Fix an error handling path

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    fsi: Aspeed: Fix a potential double free

Robert Hancock <robert.hancock@calian.com>
    pps: clients: gpio: Propagate return value from pps_gpio_probe

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc18xx-sct: Initialize driver data and hardware before pwmchip_add()

Joel Stanley <joel@jms.id.au>
    fsi: scom: Remove retries in indirect scoms

Joel Stanley <joel@jms.id.au>
    fsi: scom: Fix error handling

Jiri Slaby <jirislaby@kernel.org>
    mxser: fix xmit_buf leak in activate when LSR == 0xff

Michael Straube <straube.linux@gmail.com>
    staging: r8188eu: release_firmware is not called if allocation fails

Phillip Potter <phil@philpotter.co.uk>
    staging: r8188eu: convert DBG_88E_LEVEL call in hal/rtl8188e_hal_init.c

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: r9a07g044: Update multiplier and divider values for PLL2/3

Miaohe Lin <linmiaohe@huawei.com>
    kernel/resource: fix kfree() of bootmem memory again

Sondhauß, Jan <Jan.Sondhauss@wago.com>
    drivers: ethernet: cpsw: fix panic when interrupt coaleceing is set via ethtool

Alexander Lobakin <alexandr.lobakin@intel.com>
    ice: don't allow to run ice_send_event_to_aux() in atomic ctx

Alexander Lobakin <alexandr.lobakin@intel.com>
    ice: fix 'scheduling while atomic' on aux critical err interrupt

Miaoqian Lin <linmq006@gmail.com>
    mfd: asic3: Add missing iounmap() on error asic3_mfd_probe

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix the timer expires after interval 100ms

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix panic on shutdown if multi-chip tree failed to probe

Aaron Conole <aconole@redhat.com>
    openvswitch: always update flow key after nat

Jakub Kicinski <kuba@kernel.org>
    tcp: ensure PMTU updates are processed during fastopen

Jeremy Linton <jeremy.linton@arm.com>
    net: bcmgenet: Use stronger register read/writes to assure ordering

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Avoid broken MSI on SB600 USB devices

Yafang Shao <laoar.shao@gmail.com>
    bpftool: Fix print error when show bpf map

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf/test_lirc_mode2.sh: Exit with proper code

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Fix use after free in remove_phb_dynamic()

Peter Rosin <peda@axentia.se>
    i2c: mux: demux-pinctrl: do not deactivate a master that is not active

Phil Sutter <phil@nwl.cc>
    netfilter: conntrack: Add and use nf_ct_set_auto_assign_helper_warned()

Lucas Tanure <tanure@linux.com>
    i2c: meson: Fix wrong speed use from probe

Petr Machata <petrm@nvidia.com>
    af_netlink: Fix shift out of bounds in group mask calculation

Yonglong Li <liyonglong@chinatelecom.cn>
    mptcp: Fix crash due to tcp_tsorted_anchor was initialized before release skb

Guillaume Nault <gnault@redhat.com>
    ipv4: Fix route lookups when handling ICMP redirects and PMTU updates

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/nldev: Prevent underflow in nldev_stat_set_counter_dynamic_doit()

Yake Yang <yake.yang@mediatek.com>
    Bluetooth: btmtksdio: Fix kernel oops in btmtksdio_interrupt

Niels Dossche <dossche.niels@gmail.com>
    Bluetooth: call hci_le_conn_failed with hdev lock in hci_le_conn_failed

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: hci_uart: add missing NULL check in h5_enqueue

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/bpf: Fix error reporting from sock_fields programs

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    af_unix: Fix some data-races around unix_sk(sk)->oob_skb.

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: fix race between xmit and reset

Hangbin Liu <liuhangbin@gmail.com>
    bareudp: use ipv6_mod_enabled to check if IPv6 enabled

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: support MSG_TRUNC flag when reading from socket

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: return -EADDRNOTAVAIL when reading from unbound socket

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: fix mt7921_queues_acq implementation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: Fix QinQ and pppoe support for inet table

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display: Do not re-enable PSR after it was marked as not reliable

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display: Fix HPD short pulse handling for eDP

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix ref error in rxe_av.c

Chengguang Xu <cgxu519@mykernel.net>
    RDMA/rxe: Change variable and function argument to proper type

Dan Carpenter <dan.carpenter@oracle.com>
    USB: storage: ums-realtek: fix error code in rts51x_read_mem()

Niklas Söderlund <niklas.soderlund@corigine.com>
    samples/bpf, xdpsock: Fix race when running for fix duration of time

Wang Yufen <wangyufen@huawei.com>
    bpf, sockmap: Fix double uncharge the mem of sk_msg

Wang Yufen <wangyufen@huawei.com>
    bpf, sockmap: Fix more uncharged while msg has more_data

Wang Yufen <wangyufen@huawei.com>
    bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full

Wang Yufen <wangyufen@huawei.com>
    bpf, sockmap: Fix memleak in sk_psock_queue_msg

Yongzhi Liu <lyz_cs@pku.edu.cn>
    RDMA/mlx5: Fix memory leak in error flow for subscribe event routine

Leon Romanovsky <leon@kernel.org>
    Revert "RDMA/core: Fix ib_qp_usecnt_dec() called when error"

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/irdma: Prevent some integer underflows

Linus Walleij <linus.walleij@linaro.org>
    power: ab8500_chargalg: Use CLOCK_MONOTONIC

Xin Xiong <xiongx18@fudan.edu.cn>
    mtd: rawnand: atmel: fix refcount issue in atmel_nand_controller_init

Yaliang Wang <Yaliang.Wang@windriver.com>
    MIPS: pgalloc: fix memory leak caused by pgd_free()

Randy Dunlap <rdunlap@infradead.org>
    MIPS: RB532: fix return value of __setup handler

Miaoqian Lin <linmq006@gmail.com>
    mips: cdmm: Fix refcount leak in mips_cdmm_phys_base

Miaoqian Lin <linmq006@gmail.com>
    ath10k: Fix error handling in ath10k_setup_msa_resources

Oliver Hartkopp <socketcan@hartkopp.net>
    vxcan: enable local echo for sent CAN frames

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix SW error MSI-X mapping

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: add missing XCHAL_HAVE_WINDOWED check

Hangyu Hua <hbh25y@gmail.com>
    powerpc: 8xx: fix a return value error in mpc8xx_pic_init

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix incorrect 4GB boundary check

Jia-Ju Bai <baijiaju1990@gmail.com>
    platform/x86: huawei-wmi: check the return value of device_create_file()

Felix Maurer <fmaurer@redhat.com>
    selftests/bpf: Make test_lwt_ip_encap more stable and faster

lic121 <lic121@chinatelecom.cn>
    libbpf: Unmap rings when umem deleted

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mfd: mc13xxx: Add check for mc13xxx_irq_request

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Don't use DSISR for SLB faults

Jakob Koschel <jakobkoschel@gmail.com>
    powerpc/sysdev: fix incorrect use to determine if list is empty

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Sanitise Cavium switch cases in TLB handler synthesizers

Randy Dunlap <rdunlap@infradead.org>
    mips: DEC: honor CONFIG_MIPS_FP_SUPPORT=n

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx: Fix missing ARRAY_SIZE() check

Robert Hancock <robert.hancock@calian.com>
    net: axienet: fix RX ring refill allocation failure handling

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    PCI: Reduce warnings on possible RW1C corruption

Yajun Deng <yajun.deng@linux.dev>
    RDMA/core: Fix ib_qp_usecnt_dec() called when error

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Allow larger MTU without AIP

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    power: supply: wm8350-power: Add missing free in free_charger_irq

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    power: supply: wm8350-power: Handle error for wm8350_register_irq

Divya Koppera <Divya.Koppera@microchip.com>
    net: phy: micrel: Fix concurrent register access

Robert Hancock <robert.hancock@calian.com>
    i2c: xiic: Make bus names unique

Mark Brown <broonie@kernel.org>
    KVM: arm64: Enable Cortex-A510 erratum 2077057 by default

Anssi Hannula <anssi.hannula@bitwise.fi>
    hv_balloon: rate-limit "Unhandled message" warning

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Exit to userspace on ENOMEM/EFAULT GHCB errors

Hou Wenlong <houwenlong.hwl@antgroup.com>
    KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()

Zhenzhong Duan <zhenzhong.duan@intel.com>
    KVM: x86: Fix emulation in writing cr8

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/Makefile: Don't pass -mcpu=powerpc64 when building 32-bit

Daniel Henrique Barboza <danielhb413@gmail.com>
    powerpc/mm/numa: skip NUMA_NO_NODE onlining in parse_numa_properties()

Xu Kuohai <xukuohai@huawei.com>
    libbpf: Skip forward declaration when counting duplicated type names

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    gpu: host1x: Fix a memory leak in 'host1x_remove()'

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Remove incorrect masking of PD

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix Passthrough mode in VM

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix netdev notifications for vlan's

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Fix race at socket teardown

Hou Tao <houtao1@huawei.com>
    bpf, arm64: Feed byte-offset into bpf line info

Hou Tao <houtao1@huawei.com>
    bpf, arm64: Call build_prologue() first in first JIT pass

Nishanth Menon <nm@ti.com>
    drm/bridge: cdns-dsi: Make sure to to create proper aliases for dt

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Change permission of parameter prot_mask

Hans de Goede <hdegoede@redhat.com>
    power: supply: bq24190_charger: Fix bq24190_vbus_is_enabled() wrong false return

Miaoqian Lin <linmq006@gmail.com>
    drm/tegra: Fix reference leak in tegra_dsi_ganged_probe

Zhang Yi <yi.zhang@huawei.com>
    ext2: correct max file size computing

MeiChia Chiu <meichia.chiu@mediatek.com>
    mt76: mt7915: fix the muru tlv issue

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    power: supply: sbs-charger: Don't cancel work that is not initialized

Randy Dunlap <rdunlap@infradead.org>
    TOMOYO: fix __setup handlers return values

Maíra Canal <maira.canal@usp.br>
    drm/amd/display: Remove vupdate_int_entry definition

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Fix the flow of a miss in the allocation of a cache ODP MR

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    net: dsa: realtek-smi: move to subdirectory

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    net: dsa: realtek-smi: fix kdoc warnings

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921s: fix missing fc type/sub-type for 802.11 pkts

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix abort all task initialization

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix NCQ NON DATA command completion handling

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix NCQ NON DATA command task initialization

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix le32 values handling in pm80xx_chip_sata_req()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix command initialization in pm80XX_send_read_log()

Bart Van Assche <bvanassche@acm.org>
    scsi: fnic: Fix a tracing statement

Abhishek Sahu <abhsahu@nvidia.com>
    vfio/pci: wake-up devices around reset functions

Abhishek Sahu <abhsahu@nvidia.com>
    vfio/pci: fix memory leak during D3hot to D0 transition

Aashish Sharma <shraash@google.com>
    dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS

Rameshkumar Sundaram <quic_ramess@quicinc.com>
    ath11k: Invalidate cached reo ring entry before accessing it

P Praneesh <ppranees@codeaurora.org>
    ath11k: avoid active pdev check for each msdu

Alexander Lobakin <alexandr.lobakin@intel.com>
    i40e: remove dead stores on XSK hotpath

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: fix dp audio condition

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: add DSPP blocks teardown

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi/phy: fix 7nm v4.0 settings for C-PHY mode

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Use "ref" fw clock instead of global name for VCO parent

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: always add fail-safe mode into connector mode list

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: stop link training after link training 2 failed

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: populate connector of struct dp_panel

Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
    mtd: rawnand: pl353: Set the nand chip node as the flash node

Dan Carpenter <dan.carpenter@oracle.com>
    iwlwifi: mvm: Fix an error code in iwl_mvm_up()

Colin Ian King <colin.king@intel.com>
    iwlwifi: Fix -EIO error code that is never returned

Mukesh Sisodiya <mukesh.sisodiya@intel.com>
    iwlwifi: yoyo: Avoid using dram data if allocation failed

Rotem Saado <rotem.saado@intel.com>
    iwlwifi: yoyo: remove DBGI_SRAM address reset writing

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: align locking in D3 test debugfs

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: don't iterate unadded vifs when handling FW SMPS req

Takashi Iwai <tiwai@suse.de>
    iwlwifi: mvm: Don't call iwl_mvm_sta_from_mac80211() with NULL sta

Geliang Tang <geliang.tang@suse.com>
    selftests: mptcp: add csum mib check for mptcp_connect

Tong Zhang <ztong0001@gmail.com>
    dax: make sure inodes are flushed before destroy cache

Dan Williams <dan.j.williams@intel.com>
    cxl/port: Hold port reference until decoder release

Håkon Bugge <haakon.bugge@oracle.com>
    IB/cma: Allow XRC INI QPs to set their local ACK timeout

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix memleak in libbpf_netlink_recv()

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Add affected crtcs to atomic state for dsc mst unplug

Yiqing Yao <yiqing.yao@amd.com>
    drm/amd/pm: enable pm sysfs write for one VF mode

Yinjun Zhang <yinjun.zhang@corigine.com>
    bpftool: Fix the error when lookup in no-btf maps

Martin Povišer <povik+lin@cutebit.org>
    i2c: pasemi: Drop I2C classes from platform driver variant

Pin-Yen Lin <treapking@chromium.org>
    drm/bridge: anx7625: Fix overflow issue on reading EDID

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    iommu/ipmmu-vmsa: Check for error num after setting mask

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: i2c-hid: fix GET/SET_REPORT for unnumbered reports

Miaoqian Lin <linmq006@gmail.com>
    power: supply: ab8500: Fix memory leak in ab8500_fg_sysfs_init

Toke Høiland-Jørgensen <toke@redhat.com>
    libbpf: Use dynamically allocated buffer when receiving netlink messages

Neil Armstrong <narmstrong@baylibre.com>
    drm/bridge: dw-hdmi: use safe format when first in bridge chain

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix compilation warning due to mismatched printf format

Po Liu <po.liu@nxp.com>
    net:enetc: allocate CBD ring data memory using DMA coherent methods

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    cxl/regs: Fix size of CXL Capability Header Register

Dan Williams <dan.j.williams@intel.com>
    tools/testing/cxl: Fix root port to host bridge assignment

Dan Williams <dan.j.williams@intel.com>
    cxl/core: Fix cxl_probe_component_regs() error message

Dan Carpenter <dan.carpenter@oracle.com>
    libbpf: Fix signedness bug in btf_dump_array_data()

Xiao Yang <yangx.jy@fujitsu.com>
    RDMA/rxe: Check the last packet by RXE_END_MASK

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reading PCI_EXP_RTSTA_PME bit on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reading MSI interrupt number

Corinna Vinschen <vinschen@redhat.com>
    igb: refactor XDP registration

Corinna Vinschen <vinschen@redhat.com>
    igc: avoid kernel warning when changing RX ring parameters

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    selftests/bpf: Use "__se_" prefix on architectures without syscall wrapper

Kenta Tada <Kenta.Tada@sony.com>
    selftests/bpf: Extract syscall wrapper

Mark Brown <broonie@kernel.org>
    mtd: mchp48l640: Add SPI ID table

Mark Brown <broonie@kernel.org>
    mtd: mchp23k256: Add SPI ID table

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: bcm2835: Fix the error handling in 'bcm2835_i2c_probe()'

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    i2c: bcm2835: Use platform_get_irq() to get the interrupt

Pavel Skripkin <paskripkin@gmail.com>
    net: asix: add proper error handling of usb read errors

Christophe Leroy <christophe.leroy@csgroup.eu>
    livepatch: Fix build failure on 32 bits processors

Thomas Bracht Laumann Jespersen <t@laumann.xyz>
    scripts/dtc: Call pkg-config POSIXly correct

Johannes Berg <johannes.berg@intel.com>
    mac80211: limit bandwidth in HE capabilities

Ilan Peer <ilan.peer@intel.com>
    mac80211: Remove a couple of obsolete TODO

Yonghong Song <yhs@fb.com>
    bpf: Fix a btf decl_tag bug when tagging a function

Tobias Waldekranz <tobias@waldekranz.com>
    net: dsa: mv88e6xxx: Enable port policy support on 6097

Miroslav Lichvar <mlichvar@redhat.com>
    ptp: unregister virtual clocks when unregistering physical clock.

MeiChia Chiu <meichia.chiu@mediatek.com>
    mt76: mt7915: fix the nss setting in bitrates

Peter Chiu <chui-hao.chiu@mediatek.com>
    mt76: mt7915: fix mcs_map in mt7915_mcu_set_sta_he_mcs()

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: fix possible memory leak in mt7915_mcu_add_sta

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: check sta_rates pointer in mt7615_sta_rate_tbl_update

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7603: check sta_rates pointer in mt7603_sta_rate_tbl_update

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921e: fix possible probe failure after reboot

Leon Yen <leon.yen@mediatek.com>
    mt76: mt7921s: fix mt7921s_mcu_[fw|drv]_pmctrl

Peter Chiu <chui-hao.chiu@mediatek.com>
    mt76: mt7921: fix ht mcs in mt7921_mac_add_txs_skb()

Peter Chiu <chui-hao.chiu@mediatek.com>
    mt76: mt7915: fix ht mcs in mt7915_mac_add_txs_skb()

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix a leftover race in runtime-pm

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: fix a leftover race in runtime-pm

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: do not always disable fw runtime-pm

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: set EDCA parameters with the MCU CE command

Sean Wang <sean.wang@mediatek.com>
    mt76: mt76_connac: fix MCU_CE_CMD_SET_ROC definition error

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: use proper aid value in mt7915_mcu_sta_basic_tlv

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: use proper aid value in mt7915_mcu_wtbl_generic_tlv in sta mode

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: connac: fix sta_rec_wtbl tag len

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Don't use perf_hw_context for trace IMC PMU

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init

Maxim Kiselev <bigunclemax@gmail.com>
    powerpc: dts: t1040rdb: fix ports names for Seville Ethernet switch

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ray_cs: Check ioremap return value

Miaoqian Lin <linmq006@gmail.com>
    power: reset: gemini-poweroff: Fix IRQ check in gemini_poweroff_probe

Alexander Lobakin <alexandr.lobakin@intel.com>
    ixgbe: respect metadata on XSK Rx to skb

Alexander Lobakin <alexandr.lobakin@intel.com>
    ixgbe: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb

Alexander Lobakin <alexandr.lobakin@intel.com>
    ixgbe: pass bi->xdp to ixgbe_construct_skb_zc() directly

Alexander Lobakin <alexandr.lobakin@intel.com>
    igc: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb

Alexander Lobakin <alexandr.lobakin@intel.com>
    ice: respect metadata on XSK Rx to skb

Alexander Lobakin <alexandr.lobakin@intel.com>
    ice: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb

Alexander Lobakin <alexandr.lobakin@intel.com>
    i40e: respect metadata on XSK Rx to skb

Alexander Lobakin <alexandr.lobakin@intel.com>
    i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb

Gerhard Engleder <gerhard@engleder-embedded.com>
    selftests/net: timestamping: Fix bind_phc check

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Fix vmx/vsx mixup in mmio emulation

Maor Gottlieb <maorg@nvidia.com>
    RDMA/core: Set MR type in ib_reg_user_mr

Wen Gong <quic_wgong@quicinc.com>
    ath11k: set WMI_PEER_40MHZ while peer assoc for 6 GHz

Pavel Skripkin <paskripkin@gmail.com>
    ath9k_htc: fix uninit value bugs

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf/test_xdp_redirect_multi: use temp netns for testing

Robert Hancock <robert.hancock@calian.com>
    net: phy: at803x: move page selection fix to config_init

Tom Rix <trix@redhat.com>
    drm/amd/pm: return -ENOTSUPP if there is no get_dpm_ultimate_freq function

Zhou Qingyang <zhou1615@umn.edu>
    drm/amd/display: Fix a NULL pointer dereference in amdgpu_dm_connector_add_common_modes()

Zhou Qingyang <zhou1615@umn.edu>
    drm/nouveau/acr: Fix undefined behavior in nvkm_acr_hsfw_load_bl()

Brett Creeley <brett@pensando.io>
    ionic: Correctly print AQ errors if completions aren't received

Shannon Nelson <snelson@pensando.io>
    ionic: fix up printing of timeout error

Brett Creeley <brett@pensando.io>
    ionic: Don't send reset commands if FW isn't running

Shannon Nelson <snelson@pensando.io>
    ionic: start watchdog after all is setup

Shannon Nelson <snelson@pensando.io>
    ionic: fix type complaint in ionic_dev_cmd_clean()

Maxime Ripard <maxime@cerno.tech>
    drm/edid: Split deep color modes between RGB and YUV444

Maxime Ripard <maxime@cerno.tech>
    drm/edid: Don't clear formats if using deep color

Magnus Karlsson <magnus.karlsson@intel.com>
    selftests, xsk: Fix rx_full stats test

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    mtd: rawnand: gpmi: fix controller timings setting

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mtd: onenand: Check for error irq

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: hci_serdev: call init_rwsem() before p->open()

Tedd Ho-Jeong An <tedd.an@intel.com>
    Bluetooth: btintel: Fix WBS setting for Intel legacy ROM products

Felix Maurer <fmaurer@redhat.com>
    selftests: bpf: Fix bind on used port

Jani Nikula <jani.nikula@intel.com>
    drm/locking: fix drm_modeset_acquire_ctx kernel-doc

José Expósito <jose.exposito89@gmail.com>
    drm/selftests/test-drm_dp_mst_helper: Fix memory leak in sideband_msg_req_encode_decode

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix UAF due to race between btf_try_get_module and load_module

Pavel Skripkin <paskripkin@gmail.com>
    udmabuf: validate ubuf->pagecount

Wei Fu <fuweid89@gmail.com>
    bpftool: Only set obj->skeleton on complete success

Yafang Shao <laoar.shao@gmail.com>
    libbpf: Fix possible NULL pointer dereference when destroying skeleton

Mauricio Vásquez <mauricio@kinvolk.io>
    bpftool: Fix error check when calling hashmap__new()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/panfrost: Check for error num after setting mask

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/v3d/v3d_drv: Check for error num after setting mask

Wen Gong <quic_wgong@quicinc.com>
    ath10k: fix memory overwrite of the WoWLAN wakeup packet pattern

Jagan Teki <jagan@amarulasolutions.com>
    drm: bridge: adv7511: Fix ADV7535 HPD enablement

Miaoqian Lin <linmq006@gmail.com>
    drm/bridge: nwl-dsi: Fix PM disable depth imbalance in nwl_dsi_probe

Miaoqian Lin <linmq006@gmail.com>
    drm/bridge: Add missing pm_runtime_disable() in __dw_mipi_dsi_probe

Miaoqian Lin <linmq006@gmail.com>
    drm/bridge: Fix free wrong object in sii8620_init_rcp_input_dev

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: Fix error handling when afbcd.ops->init fails

Neil Armstrong <narmstrong@baylibre.com>
    drm/meson: split out encoder from meson_dw_hdmi

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: osd_afbcd: Add an exit callback to struct meson_afbcd_ops

Andre Przywara <andre.przywara@arm.com>
    ARM: configs: multi_v5_defconfig: re-enable DRM_PANEL and FB_xxx

Andre Przywara <andre.przywara@arm.com>
    ARM: configs: multi_v5_defconfig: re-enable CONFIG_V4L_PLATFORM_DRIVERS

Meng Tang <tangmeng@uniontech.com>
    ASoC: amd: Fix reference to PCM buffer address

Miaoqian Lin <linmq006@gmail.com>
    ASoC: codecs: wcd934x: Add missing of_node_put() in wcd934x_codec_parse_data

Miaoqian Lin <linmq006@gmail.com>
    ASoC: msm8916-wcd-analog: Fix error handling in pm8916_wcd_analog_spmi_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: atmel: Fix error handling in sam9x5_wm8731_driver_probe

zhangqilong <zhangqilong3@huawei.com>
    ASoC: rockchip: Fix PM usage reference of rockchip_i2s_tdm_resume

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mmc: davinci_mmc: Handle error for clk_enable

Miaoqian Lin <linmq006@gmail.com>
    ASoC: msm8916-wcd-digital: Fix missing clk_disable_unprepare() in msm8916_wcd_digital_probe

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: enable DMI L1 for playback streams

Wang Wensheng <wangwensheng4@huawei.com>
    ASoC: imx-es8328: Fix error return code in imx_es8328_probe()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_spdif: Disable TX clock when stop

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mxs: Fix error handling in mxs_sgtl5000_probe

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    ASoC: dmaengine: do not use a NULL prepare_slave_config() callback

Miaoqian Lin <linmq006@gmail.com>
    ASoC: rk817: Fix missing clk_disable_unprepare() in rk817_platform_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: mt8192-mt6359: Fix error handling in mt8192_mt6359_dev_probe

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: mediatek: use of_device_get_match_data()

Miaoqian Lin <linmq006@gmail.com>
    ASoC: SOF: Add missing of_node_put() in imx8m_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: rockchip: i2s: Fix missing clk_disable_unprepare() in rockchip_i2s_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: atmel: Fix error handling in snd_proto_probe

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    ivtv: fix incorrect device_caps for ivtvfb

Jakob Koschel <jakobkoschel@gmail.com>
    media: saa7134: fix incorrect use to determine if list is empty

Miaoqian Lin <linmq006@gmail.com>
    video: fbdev: omapfb: Add missing of_node_put() in dvic_probe_of

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: fsi: Add check for clk_enable

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: wm8350: Handle error for wm8350_register_irq

Miaoqian Lin <linmq006@gmail.com>
    ASoC: atmel: Add missing of_node_put() in at91sam9g20ek_audio_probe

Lucas Tanure <tanureal@opensource.cirrus.com>
    ASoC: cs35l41: Fix max number of TX channels

David Rhodes <drhodes@opensource.cirrus.com>
    ASoC: cs35l41: Fix GPIO2 configuration

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: vidtv: Check for null return of vzalloc

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: stk1160: If start stream fails, return buffers with VB2_BUF_STATE_QUEUED

Randy Dunlap <rdunlap@infradead.org>
    m68k: coldfire/device.c: only build for MCF_EDMA when h/w macros are defined

Rob Herring <robh@kernel.org>
    arm64: dts: rockchip: Fix SDIO regulator supply properties on rk3399-firefly

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix uninitialized flag for AV/C deferred transaction

Jia-Ju Bai <baijiaju1990@gmail.com>
    memory: emif: check the pointer temp in get_device_details()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    memory: emif: Add check for setup_interrupts

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: soc-compress: prevent the potentially use of null pointer

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: dwc-i2s: Handle errors for clk_enable

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: atmel_ssc_dai: Handle errors for clk_enable

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: mxs-saif: Handle errors for clk_enable

Randy Dunlap <rdunlap@infradead.org>
    printk: fix return value of printk.devkmsg __setup handler

Frank Wunderlich <frank-w@public-files.de>
    arm64: dts: broadcom: Fix sata nodename

Kuldeep Singh <singh.kuldeep87k@gmail.com>
    arm64: dts: ns2: Fix spi-cpol and spi-cpha property

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ALSA: spi: Add check for clk_enable()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: ti: davinci-i2s: Add check for clk_enable()

Aswath Govindraju <a-govindraju@ti.com>
    mmc: sdhci_am654: Fix the driver data of AM64 SoC

Chun-Jie Chen <chun-jie.chen@mediatek.com>
    soc: mediatek: pm-domains: Add wakeup capacity support in power domain

Jia-Ju Bai <baijiaju1990@gmail.com>
    ASoC: acp: check the return value of devm_kzalloc() in acp_legacy_dai_links_create()

Jia-Ju Bai <baijiaju1990@gmail.com>
    ASoC: rt5663: check the return value of devm_kzalloc() in rt5663_parse_dp()

Arnd Bergmann <arnd@arndb.de>
    uaccess: fix nios2 and microblaze get_user_8()

Christophe Leroy <christophe.leroy@csgroup.eu>
    vsprintf: Fix %pK with kptr_restrict == 0

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/lkdtm: Add UBSAN config

Mirela Rabulea <mirela.rabulea@nxp.com>
    media: ov5640: Fix set format, v4l2_mbus_pixelcode not updated

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: v4l2-core: Initialize h264 scaling matrix

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: fix return value of wcd934x_rx_hph_mode_put

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: fix kcontrol max values

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd938x: fix kcontrol max values

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wc938x: fix accessing array out of bounds for enum type

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: va-macro: fix accessing array out of bounds for enum type

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: rx-macro: fix accessing array out of bounds for enum type

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: rx-macro: fix accessing compander for aux

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: cedrus: h264: Fix neighbour info buffer size

Jernej Skrabec <jernej.skrabec@gmail.com>
    media: cedrus: H265: Fix neighbour info buffer size

Dan Carpenter <dan.carpenter@oracle.com>
    media: usb: go7007: s2250-board: fix leak in probe()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: em28xx: initialize refcount before kref_get

Zhou Qingyang <zhou1615@umn.edu>
    media: ti-vpe: cal: Fix a NULL pointer dereference in cal_ctx_v4l2_init_formats()

Tom Rix <trix@redhat.com>
    media: video/hdmi: handle short reads of hdmi info frame.

Neil Armstrong <narmstrong@baylibre.com>
    media: mexon-ge2d: fixup frames size in registers

Marek Vasut <marex@denx.de>
    ARM: dts: imx: Add missing LVDS decoder on M53Menlo

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    vsprintf: Fix potential unaligned access

Ard Biesheuvel <ardb@kernel.org>
    ARM: ftrace: ensure that ADR takes the Thumb bit into account

Olivier Moysan <olivier.moysan@foss.st.com>
    ARM: dts: stm32: fix AV96 board SAI2 pin muxing on stm32mp15

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    ARM: dts: sun8i: v3s: Move the csi1 block to follow address order

Stephan Gerhold <stephan@gerhold.net>
    cpuidle: qcom-spm: Check if any CPU is managed by SPM

Miaoqian Lin <linmq006@gmail.com>
    soc: ti: wkup_m3_ipc: Fix IRQ check in wkup_m3_ipc_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    firmware: ti_sci: Fix compilation failure when CONFIG_TI_SCI_PROTOCOL is not defined

Baruch Siach <baruch@tkos.co.il>
    arm64: dts: qcom: ipq6018: fix usb reference period

Petr Vorel <petr.vorel@gmail.com>
    arm64: dts: qcom: msm8994: Provide missing "xo_board" and "sleep_clk" to GCC

Maulik Shah <quic_mkshah@quicinc.com>
    arm64: dts: qcom: sm8350: Correct TCS configuration for apps rsc

Maulik Shah <quic_mkshah@quicinc.com>
    arm64: dts: qcom: sm8150: Correct TCS configuration for apps rsc

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: broadcom: bcm4908: use proper TWD binding

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8250: fix PCIe bindings to follow schema

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845: fix microphone bias properties and values

Daniel Thompson <daniel.thompson@linaro.org>
    soc: qcom: aoss: remove spurious IRQF_ONESHOT flags

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: aoss: Fix missing put_device call in qmp_get

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: ocmem: Fix missing put_device() call in of_get_ocmem

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    soc: qcom: rpmpd: Check for null return of devm_kcalloc

Pavel Kubelun <be.dissent@gmail.com>
    ARM: dts: qcom: ipq4019: fix sleep clock

Marijn Suijten <marijn.suijten@somainline.org>
    firmware: qcom: scm: Remove reassignment to desc following initializer

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sc7280: Fix gmu unit address

Randy Dunlap <rdunlap@infradead.org>
    ASoC: max98927: add missing header file

Zev Weiss <zev@bewilderbeest.net>
    ARM: dts: Fix OpenBMC flash layout label addresses

Dan Carpenter <dan.carpenter@oracle.com>
    video: fbdev: fbcvt.c: fix printing in fb_cvt_print_name()

Dan Carpenter <dan.carpenter@oracle.com>
    video: fbdev: atmel_lcdfb: fix an error code in atmel_lcdfb_probe()

Wang Hai <wanghai38@huawei.com>
    video: fbdev: smscufx: Fix null-ptr-deref in ufx_usb_probe()

YueHaibing <yuehaibing@huawei.com>
    video: fbdev: controlfb: Fix COMPILE_TEST build

Z. Liu <liuzx@knownsec.com>
    video: fbdev: matroxfb: set maxvram of vbG200eW to the same as vbG200 to avoid black screen

Jammy Huang <jammy_huang@aspeedtech.com>
    media: aspeed: Correct value for h-total-pixels

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ov5648: Don't pack controls struct

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: Avoid unaligned access warnings when printing 4cc modifiers

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix set format try processing path

Chen-Yu Tsai <wenst@chromium.org>
    media: hantro: Fix overfill bottom register field name

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: meson: vdec: potential dereference of null pointer

Miaoqian Lin <linmq006@gmail.com>
    media: coda: Fix missing put_device() call in coda_get_vdoa_data

Dmitry Osipenko <digetx@gmail.com>
    memory: tegra20-emc: Correct memory device mask

Robert Hancock <robert.hancock@calian.com>
    ASoC: simple-card-utils: Set sysclk on all components

Robert Hancock <robert.hancock@calian.com>
    ASoC: xilinx: xlnx_formatter_pcm: Handle sysclk setting

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: codecs: Check for error pointer after calling devm_regmap_init_mmio

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    ASoC: sh: rz-ssi: Drop calling rz_ssi_pio_recv() recursively

Eugen Hristev <eugen.hristev@microchip.com>
    media: atmel: atmel-sama7g5-isc: fix ispck leftover

Ondrej Zary <linux@zary.sk>
    media: bttv: fix WARNING regression on tunerless devices

Martin Kepplinger <martink@posteo.de>
    media: imx: imx8mq-mipi_csi2: fix system resume

Martin Kepplinger <martink@posteo.de>
    media: imx: imx8mq-mipi-csi2: remove wrong irq config write operation

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: mtk-vcodec: potential dereference of null pointer

Chen-Yu Tsai <wenst@chromium.org>
    media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: staging: media: imx: imx7-mipi-csis: Make subdev name unique

Jonathan Marek <jonathan@marek.ca>
    media: camss: vfe-170: fix "VFE halt timeout" error

Jonathan Marek <jonathan@marek.ca>
    media: camss: csid-170: set the right HALT_CMD when disabled

Jonathan Marek <jonathan@marek.ca>
    media: camss: csid-170: don't enable unused irqs

Jonathan Marek <jonathan@marek.ca>
    media: camss: csid-170: fix non-10bit formats

Corentin Labbe <clabbe@baylibre.com>
    media: staging: media: zoran: fix usage of vb2_dma_contig_set_max_seg_size

Sam Protsenko <semen.protsenko@linaro.org>
    pinctrl: samsung: Remove EINT handler for Exynos850 ALIVE and CMGP gpios

Peng Liu <liupeng256@huawei.com>
    kunit: make kunit_test_timeout compatible with comment

David Hildenbrand <david@redhat.com>
    drivers/base/memory: add memory block to memory group after registration succeeded

Guillaume Tucker <guillaume.tucker@collabora.com>
    selftests, x86: fix how check_cc.sh is being invoked

Fengnan Chang <changfengnan@vivo.com>
    f2fs: fix compressed file start atomic write may cause data corruption

Filipe Manana <fdmanana@suse.com>
    btrfs: fix unexpected error path when reflinking an inline extent

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadlock

Valentin Schneider <valentin.schneider@arm.com>
    sched/rt: Plug rt_mutex_setprio() vs push_rt_task() race

Chengming Zhou <zhouchengming@bytedance.com>
    sched/cpuacct: Fix charge percpu cpuusage

Amir Goldstein <amir73il@gmail.com>
    nfsd: more robust allocation failure handling in nfsd_file_cache_init

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix missing free nid in f2fs_handle_failed_inode

Mel Gorman <mgorman@techsingularity.net>
    sched/fair: Improve consistency of allowed NUMA balance calculations

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix address filter config for 32-bit kernel

Adrian Hunter <adrian.hunter@intel.com>
    perf/core: Fix address filter parser for multiple filters

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq: Remove broken uapi field layout on 32-bit little endian

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix iowait boost escaping uclamp restriction

Qais Yousef <qais.yousef@arm.com>
    sched/core: Export pelt_thermal_tp

Bharata B Rao <bharata@amd.com>
    sched/debug: Remove mpol_get/put and task_lock/unlock from sched_show_numa

Chao Yu <chao@kernel.org>
    f2fs: fix to enable ATGC correctly via gc_idle sysfs interface

David Howells <dhowells@redhat.com>
    watch_queue: Actually free the watch

David Howells <dhowells@redhat.com>
    watch_queue: Fix NULL dereference in error cleanup

Jens Axboe <axboe@kernel.dk>
    io_uring: terminate manual loop iterator loop correctly for non-vecs

Jens Axboe <axboe@kernel.dk>
    io_uring: don't check unrelated req->open.how in accept request

Randy Dunlap <rdunlap@infradead.org>
    clocksource: acpi_pm: fix return value of __setup handler

Brandon Wyman <bjwyman@gmail.com>
    hwmon: (pmbus) Add Vin unit off handling

Miaoqian Lin <linmq006@gmail.com>
    hwrng: nomadik - Change clk_disable to clk_disable_unprepare

Jianglei Nie <niejianglei2021@163.com>
    crypto: ccree - Fix use after free in cc_cipher_exit()

Dāvis Mosāns <davispuh@gmail.com>
    crypto: ccp - ccp_dmaengine_unregister release dma channels

Randy Dunlap <rdunlap@infradead.org>
    ACPI: APEI: fix return value of __setup handlers

Dave Kleikamp <dave.kleikamp@oracle.com>
    KEYS: trusted: Avoid calling null function trusted_key_exit

Andreas Rammhold <andreas@rammhold.de>
    KEYS: trusted: Fix trusted key backends when building as module

Mark Rutland <mark.rutland@arm.com>
    arm64: prevent instrumentation of bp hardening callbacks

Guillaume Ranquet <granquet@baylibre.com>
    clocksource/drivers/timer-of: Check return value of of_iomap in timer_of_base_init()

Claudiu Beznea <claudiu.beznea@microchip.com>
    clocksource/drivers/timer-microchip-pit64b: Use notrace

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    clocksource/drivers/exynos_mct: Handle DTS with higher number of interrupts

Marek Szyprowski <m.szyprowski@samsung.com>
    clocksource/drivers/exynos_mct: Refactor resources allocation

Drew Fustini <dfustini@baylibre.com>
    clocksource/drivers/timer-ti-dm: Fix regression from errata i940 fix

Petr Vorel <pvorel@suse.cz>
    crypto: vmx - add missing dependencies

Corentin Labbe <clabbe@baylibre.com>
    crypto: gemini - call finalize with bh disabled

Corentin Labbe <clabbe@baylibre.com>
    crypto: amlogic - call finalize with bh disabled

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ce - call finalize with bh disabled

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - call finalize with bh disabled

Claudiu Beznea <claudiu.beznea@microchip.com>
    hwrng: atmel - disable trng on failure path

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    spi: spi-zynqmp-gqspi: Handle error for dma_set_mask

Randy Dunlap <rdunlap@infradead.org>
    PM: suspend: fix return value of __setup handler

Randy Dunlap <rdunlap@infradead.org>
    PM: hibernate: fix __setup handler error handling

Eric Biggers <ebiggers@google.com>
    block: don't delete queue kobject before its children

Christoph Hellwig <hch@lst.de>
    nvme: fix the check for duplicate unique identifiers

Christoph Hellwig <hch@lst.de>
    nvme: cleanup __nvme_check_ids

Armin Wolf <W_Armin@gmx.de>
    hwmon: (sch56xx-common) Replace WDOG_ACTIVE with WDOG_HW_RUNNING

Patrick Rudolph <patrick.rudolph@9elements.com>
    hwmon: (pmbus) Add mutex to regulator ops

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: pxa2xx-pci: Balance reference count for PCI DMA device

Kai Ye <yekai13@huawei.com>
    crypto: hisilicon/sec - fix the aead software fallback for engine

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - don't attempt 0 len DMA mappings

Randy Dunlap <rdunlap@infradead.org>
    EVM: fix the evm= __setup handler return value

Richard Guy Briggs <rgb@redhat.com>
    audit: log AUDIT_TIME_* records only from rules

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - ECB does not need IV

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/sgx: Treat CC as one argument

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/x86: Add validity check and allow field splitting

Chengming Zhou <zhouchengming@bytedance.com>
    blk-cgroup: set blkg iostat after percpu stat aggregation

Ondrej Mosnacek <omosnace@redhat.com>
    security: implement sctp_assoc_established hook in selinux

Ondrej Mosnacek <omosnace@redhat.com>
    security: add sctp_assoc_established hook

Jianyong Wu <jianyong.wu@arm.com>
    arm64/mm: avoid fixmap race condition when create pud mapping

Marco Elver <elver@google.com>
    stack: Constrain and fix stack offset randomization with Clang builds

Miaoqian Lin <linmq006@gmail.com>
    spi: tegra210-quad: Fix missin IRQ check in tegra_qspi_probe

Miaoqian Lin <linmq006@gmail.com>
    spi: tegra114: Add missing IRQ check in tegra_spi_probe

Shijith Thotton <sthotton@marvell.com>
    crypto: octeontx2 - remove CONFIG_DM_CRYPT check

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    thermal: int340x: Check for NULL after calling kmemdup()

Scott Mayhew <smayhew@redhat.com>
    selinux: Fix selinux_sb_mnt_opts_compat()

Tomas Paukrt <tomaspaukrt@email.cz>
    crypto: mxs-dcp - Fix scatterlist processing

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: authenc - Fix sleep in atomic context in decrypt_tail

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - really disable hash on A80

Geert Uytterhoeven <geert+renesas@glider.be>
    hwrng: cavium - HW_RANDOM_CAVIUM should depend on ARCH_THUNDER

Sunil Goutham <sgoutham@marvell.com>
    hwrng: cavium - Check health status while reading random data

Peter Gonda <pgonda@google.com>
    crypto: ccp - Ensure psp_ret is always init'd in __sev_platform_init_locked()

Christian Göttsche <cgzones@googlemail.com>
    selinux: check return value of sel_make_avc_files

GONG, Ruiqi <gongruiqi1@huawei.com>
    selinux: access superblock_security_struct in LSM blob way

kernel test robot <lkp@intel.com>
    regulator: qcom_smd: fix for_each_child.cocci warnings

Marc Zyngier <maz@kernel.org>
    PCI: xgene: Revert "PCI: xgene: Fix IB window setup"

Liguang Zhang <zhangliguang@linux.alibaba.com>
    PCI: pciehp: Clear cmd_busy bit in polling mode

Fabio Estevam <festevam@gmail.com>
    PCI: imx6: Allow to probe when dw_pcie_wait_for_link() fails

Mastan Katragadda <mastanx.katragadda@intel.com>
    drm/i915/gem: add missing boundary check in vm_access

Jani Nikula <jani.nikula@intel.com>
    drm/i915/opregion: check port number bounds for SWSCI display power state

Hector Martin <marcan@marcan.st>
    brcmfmac: pcie: Fix crashes due to early IRQs

Hector Martin <marcan@marcan.st>
    brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio

Hector Martin <marcan@marcan.st>
    brcmfmac: pcie: Declare missing firmware files in pcie.c

Hector Martin <marcan@marcan.st>
    brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path

Hector Martin <marcan@marcan.st>
    brcmfmac: firmware: Allocate space for default boardrev in nvram

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fb-helper: Mark screen buffers in system memory with FBINFO_VIRTFB

Lyude Paul <lyude@redhat.com>
    drm/nouveau/backlight: Just set all backlight types as RAW

Lyude Paul <lyude@redhat.com>
    drm/nouveau/backlight: Fix LVDS backlight detection on some laptops

Christian König <christian.koenig@amd.com>
    drm/syncobj: flatten dma_fence_chains on transfer

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix xtensa_wsr always writing 0

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix stop_machine_cpuslocked call in patch_text

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: define update_mmu_tlb function

Qu Wenruo <wqu@suse.com>
    btrfs: verify the tranisd of the to-be-written dirty extent buffer

Niels Dossche <dossche.niels@gmail.com>
    btrfs: extend locking to all space_info members accesses

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: mark relocation as writing

Johan Hovold <johan@kernel.org>
    media: davinci: vpif: fix use-after-free on driver unbind

Johan Hovold <johan@kernel.org>
    media: davinci: vpif: fix unbalanced runtime PM enable

Johan Hovold <johan@kernel.org>
    media: davinci: vpif: fix unbalanced runtime PM get

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: venc: Fix h264 8x8 transform control

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: hfi_cmds: List HDR10 property as unsupported for v1 and v3

Ameer Hamza <amhamza.mgc@gmail.com>
    media: venus: vdec: fixed possible memory leak issue

Kees Cook <keescook@chromium.org>
    media: omap3isp: Use struct_group() for memcpy() region

Sean Young <sean@mess.org>
    media: gpio-ir-tx: fix transmit with long spaces on Orange Pi PC

Maciej W. Rozycki <macro@orcam.me.uk>
    DEC: Limit PMAX memory probing to R3k systems

Shawn Guo <shawn.guo@linaro.org>
    PM: domains: Fix sleep-in-atomic bug caused by genpd_debug_remove()

Mingzhe Zou <mingzhe.zou@easystack.cn>
    bcache: fixup multiple threads crash

Eric Biggers <ebiggers@google.com>
    crypto: rsa-pkcs1pad - fix buffer overread in pkcs1pad_verify_complete()

Eric Biggers <ebiggers@google.com>
    crypto: rsa-pkcs1pad - restore signature length check

Eric Biggers <ebiggers@google.com>
    crypto: rsa-pkcs1pad - correctly get hash from source scatterlist

Eric Biggers <ebiggers@google.com>
    crypto: rsa-pkcs1pad - only allow with rsa

Kees Cook <keescook@chromium.org>
    exec: Force single empty string when argv is empty

Dirk Müller <dmueller@suse.de>
    lib/raid6/test: fix multiple definition linking error

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: int340x: Increase bitmap size

Jann Horn <jannh@google.com>
    pstore: Don't use semaphores in always-atomic-context code

Colin Ian King <colin.king@intel.com>
    carl9170: fix missing bit-wise or operator for tx_params

Jocelyn Falempe <jfalempe@redhat.com>
    mgag200 fix memmapsl configuration in GCTL6 register

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: add missing HDMI supplies on SMDK5420

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: add missing HDMI supplies on SMDK5250

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix UART3 pins configuration in Exynos5250

Tudor Ambarus <tudor.ambarus@microchip.com>
    ARM: dts: at91: sama5d2: Fix PMERRLOC resource size

Tudor Ambarus <tudor.ambarus@microchip.com>
    ARM: dts: at91: sama7g5: Remove unused properties in i2c nodes

Johannes Berg <johannes.berg@intel.com>
    rfkill: make new event layout opt-in

Michael Schmitz <schmitzmic@gmail.com>
    video: fbdev: atari: Atari 2 bpp (STe) palette bugfix

Helge Deller <deller@gmx.de>
    video: fbdev: sm712fb: Fix crash in smtcfb_read()

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Hot-unplug firmware fb devices on forced removal

Cooper Chiou <cooper.chiou@intel.com>
    drm/edid: check basic audio support on CEA extension block

Tejun Heo <tj@kernel.org>
    block: don't merge across cgroup boundaries if blkcg is enabled

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    block: limit request dispatch loop duration

Tejun Heo <tj@kernel.org>
    block: fix rq-qos breakage from skipping rq_qos_done_bio()

Nikolay Borisov <nborisov@suse.com>
    btrfs: zoned: put block group after final usage

Pekka Pessi <ppessi@nvidia.com>
    mailbox: tegra-hsp: Flush whole channel

Christian Brauner <brauner@kernel.org>
    landlock: Use square brackets around "landlock-ruleset"

Tom Rix <trix@redhat.com>
    samples/landlock: Fix path_list memory leak

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: make mb_optimize_scan performance mount option work with extents

Ye Bin <yebin10@huawei.com>
    ext4: fix fs corruption when tring to remove a non-empty directory with IO error

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix ext4_fc_stats trace point

Jann Horn <jannh@google.com>
    coredump: Also dump first pages of non-executable ELF libraries

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: properties: Consistently return -ENOENT if there are no more references

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: Pass the same capabilities to the _OSC regardless of the query flag"

Sergey Shtylyov <s.shtylyov@omp.ru>
    mmc: core: use sysfs_emit() instead of sprintf()

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM

Nishanth Menon <nm@ti.com>
    arm64: dts: ti: k3-am64: Fix gic-v3 compatible regs

Nishanth Menon <nm@ti.com>
    arm64: dts: ti: k3-j7200: Fix gic-v3 compatible regs

Nishanth Menon <nm@ti.com>
    arm64: dts: ti: k3-j721e: Fix gic-v3 compatible regs

Nishanth Menon <nm@ti.com>
    arm64: dts: ti: k3-am65: Fix gic-v3 compatible regs

Manivannan Sadhasivam <mani@kernel.org>
    arm64: dts: qcom: sm8250: Fix MSI IRQ for PCIe1 and PCIe2

Vijay Balakrishna <vijayb@linux.microsoft.com>
    arm64: Do not defer reserve_crashkernel() for platforms with no DMA memory zones

David Engraf <david.engraf@sysgo.com>
    arm64: signal: nofpsimd: Do not allocate fp/simd context when not available

Ben Dooks <ben.dooks@codethink.co.uk>
    PCI: fu740: Force 2.5GT/s for initial device probe

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: sanitize CAN ID checks in isotp_bind()

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: fix potential silent data corruption

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have trace event string test handle zero length strings

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: set journal entry unused when shrinking device

Mike Snitzer <snitzer@redhat.com>
    dm: fix double accounting of flush with data

Mike Snitzer <snitzer@redhat.com>
    dm: interlock pending dm_io and dm_wait_for_bios_completion

Kirill Tkhai <ktkhai@virtuozzo.com>
    dm: fix use-after-free in dm_cleanup_zoned_dev()

Mike Snitzer <snitzer@redhat.com>
    dm stats: fix too short end duration_ns when using precise_timestamps

Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
    mm/kmemleak: reset tag when compare object pointer

Rik van Riel <riel@surriel.com>
    mm,hwpoison: unmap poisoned page before invalidation

Charan Teja Kalla <quic_charante@quicinc.com>
    Revert "mm: madvise: skip unmapped vma holes passed to process_madvise"

Charan Teja Kalla <quic_charante@quicinc.com>
    mm: madvise: return correct bytes advised with process_madvise

Charan Teja Kalla <quic_charante@quicinc.com>
    mm: madvise: skip unmapped vma holes passed to process_madvise

Hans de Goede <hdegoede@redhat.com>
    drm/simpledrm: Add "panel orientation" property on non-upright mounted LCD panels

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix crash when mount with quota enabled

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure that fsnotify is always called

Ali Pouladi <quic_apouladi@quicinc.com>
    rtc: pl031: fix rtc features null pointer dereference

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: mc146818-lib: fix locking in mc146818_set_time

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Fix audio regression on Mi Notebook Pro 2020

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda: Avoid unsol event during RPM suspending

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    ALSA: cs4236: fix an incorrect NULL check on list iterator

Paulo Alcantara <pc@cjr.nz>
    cifs: fix NULL ptr dereference in smb2_ioctl_query_info()

Paulo Alcantara <pc@cjr.nz>
    cifs: prevent bad output lengths in smb2_ioctl_query_info()

Paulo Alcantara <pc@cjr.nz>
    cifs: do not skip link targets when an I/O fails

José Expósito <jose.exposito89@gmail.com>
    Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"

Dmitry Vyukov <dvyukov@google.com>
    riscv: Increase stack size under KASAN

Nikita Shubin <n.shubin@yadro.com>
    riscv: Fix fill_callchain return value

Niklas Cassel <niklas.cassel@wdc.com>
    riscv: dts: canaan: Fix SPI3 bus width

Manish Chopra <manishc@marvell.com>
    qed: validate and restrict untrusted VFs vlan promisc mode

Manish Chopra <manishc@marvell.com>
    qed: display VF trust config

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands

James Smart <jsmart2021@gmail.com>
    scsi: scsi_transport_fc: Fix FPIN Link Integrity statistics counters

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: Fix runtime PM messages never-ending cycle

Adrian Hunter <adrian.hunter@intel.com>
    scsi: core: sd: Add silence_suspend flag to suppress some PM messages

Hugh Dickins <hughd@google.com>
    mempolicy: mbind_range() set_policy() after vma_merge()

Rik van Riel <riel@surriel.com>
    mm: invalidate hwpoison page cache page in fault path

Alistair Popple <apopple@nvidia.com>
    mm/pages_alloc.c: don't create ZONE_MOVABLE beyond the end of a node

Peter Xu <peterx@redhat.com>
    mm: don't skip swap entry even if zap_details specified

Minchan Kim <minchan@kernel.org>
    mm: fs: fix lru_cache_disabled race in bh_lru

Baokun Li <libaokun1@huawei.com>
    jffs2: fix memory leak in jffs2_scan_medium

Baokun Li <libaokun1@huawei.com>
    jffs2: fix memory leak in jffs2_do_mount_fs

Baokun Li <libaokun1@huawei.com>
    jffs2: fix use-after-free in jffs2_clear_xattr_subsystem

Hangyu Hua <hbh25y@gmail.com>
    can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_tx_handler(): fix use after free of skb

Hangyu Hua <hbh25y@gmail.com>
    can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path

Sean Nyekjaer <sean@geanix.com>
    mtd: rawnand: protect access to rawnand devices while in suspend

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: mxic: Fix the transmit path

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    net: bnxt_ptp: fix compilation error

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    pinctrl: samsung: drop pin banks references on error paths

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    pinctrl: ingenic: Fix regmap on X series SoCs

Miaohe Lin <linmiaohe@huawei.com>
    mm/mlock: fix two bugs in user_shm_lock()

Alistair Delva <adelva@google.com>
    remoteproc: Fix count check in rproc_coredump_write()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on .cp_pack_total_block_count

Juhyung Park <qkrwngud825@gmail.com>
    f2fs: quota: fix loop condition at f2fs_quota_sync()

Chao Yu <chao@kernel.org>
    f2fs: fix to unlock page correctly in error path of is_alive()

Dan Carpenter <dan.carpenter@oracle.com>
    NFSD: prevent integer overflow on 32 bit systems

Dan Carpenter <dan.carpenter@oracle.com>
    NFSD: prevent underflow in nfssvc_decode_writeargs()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: NFSv2/v3 clients should never be setting NFS_CAP_XATTR

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Do not dereference non-socket transports in sysfs

NeilBrown <neilb@suse.de>
    SUNRPC: avoid race between mod_timer() and del_timer_sync()

Gwendal Grignou <gwendal@chromium.org>
    HID: intel-ish-hid: Use dma_alloc_coherent for firmware update

Johan Hovold <johan@kernel.org>
    firmware: sysfb: fix platform-device leak in error path

Ang Tien Sung <tien.sung.ang@intel.com>
    firmware: stratix10-svc: add missing callback parameter on RSU

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: update stable tree link

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: add link to stable release candidate tree

Eric Biggers <ebiggers@google.com>
    KEYS: asymmetric: properly validate hash_algo and encoding

Eric Biggers <ebiggers@google.com>
    KEYS: asymmetric: enforce that sig algo matches key algo

Eric Biggers <ebiggers@google.com>
    KEYS: fix length validation in keyctl_pkey_params_get_2()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: we do not need a spinlock around the tree access during umount

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix handlecache and multiuser

Jann Horn <jannh@google.com>
    ptrace: Check PTRACE_O_SUSPEND_SECCOMP permission on PTRACE_SEIZE

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    clk: uniphier: Fix fixed-rate initialization

Quentin Schulz <quentin.schulz@theobroma-systems.com>
    clk: rockchip: re-add rational best approximation algorithm to the fractional divider

Dan Carpenter <dan.carpenter@oracle.com>
    greybus: svc: fix an error handling bug in gb_svc_hello()

Liam Beguin <liambeguin@gmail.com>
    iio: inkern: make a best effort on offset calculation

Liam Beguin <liambeguin@gmail.com>
    iio: inkern: apply consumer scale when no channel scale is available

Liam Beguin <liambeguin@gmail.com>
    iio: inkern: apply consumer scale on IIO_VAL_INT cases

Liam Beguin <liambeguin@gmail.com>
    iio: afe: rescale: use s64 for temporary scale calculations

Billy Tsai <billy_tsai@aspeedtech.com>
    iio: adc: aspeed: Add divider flag to fix incorrect voltage reading.

Miaoqian Lin <linmq006@gmail.com>
    coresight: syscfg: Fix memleak on registration failure in cscfg_create_device

James Clark <james.clark@arm.com>
    coresight: Fix TRCCONFIGR.QE sysfs interface

Akira Yokosawa <akiyks@gmail.com>
    docs: sphinx/requirements: Limit jinja2<3.1

Paul Davey <paul.davey@alliedtelesis.co.nz>
    bus: mhi: Fix MHI DMA structure endianness

Yonglin Tan <yonglin.tan@outlook.com>
    bus: mhi: pci_generic: Add mru_default for Quectel EM1xx series

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: avoid iterator usage outside of list_for_each_entry

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add Alder Lake N device id.

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: disable driver on the ign firmware

Anssi Hannula <anssi.hannula@bitwise.fi>
    xhci: fix uninitialized string returned by xhci_decode_ctrl_ctx()

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make xhci_handshake timeout for xhci_reset() adjustable

Henry Lin <henryl@nvidia.com>
    xhci: fix runtime PM imbalance in USB2 resume

Anssi Hannula <anssi.hannula@bitwise.fi>
    xhci: fix garbage USBSTS being logged in some cases

Alan Stern <stern@rowland.harvard.edu>
    USB: usb-storage: Fix use of bitfields for hardware data in ene_ub6250.c

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Forward plug orientation to typec subsystem

Jens Axboe <axboe@kernel.dk>
    block: flush plug based on hardware and software queue order

Jens Axboe <axboe@kernel.dk>
    block: ensure plug merging checks the correct queue at least once

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    tpm: fix reference counting for struct tpm_chip

Robin Murphy <robin.murphy@arm.com>
    iommu/iova: Improve 32-bit free space estimate

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: only check for _PR3 on dGPUs

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: move PX checking into amdgpu_device_ip_early_init

Waiman Long <longman@redhat.com>
    locking/lockdep: Avoid potential access of invalid memory in lock_class

Yosry Ahmed <yosryahmed@google.com>
    selftests: vm: fix clang build error multiple output files

David Jeffery <djeffery@redhat.com>
    scsi: fnic: Finish scsi_cmnd before dropping the spinlock

Claudiu Beznea <claudiu.beznea@microchip.com>
    net: dsa: microchip: add spi_device_id tables

Haimin Zhang <tcs_kernel@tencent.com>
    af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register

Linus Walleij <linus.walleij@linaro.org>
    Input: zinitix - do not report shadow fingers

Biju Das <biju.das.jz@bp.renesas.com>
    spi: Fix erroneous sgs value with min_t()

Bartosz Golaszewski <brgl@bgdev.pl>
    Revert "gpio: Revert regression in sysfs-gpio (gpiolib.c)"

Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
    net:mcf8390: Use platform_get_irq() to get the interrupt

Biju Das <biju.das.jz@bp.renesas.com>
    spi: Fix invalid sgs value

Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
    gpio: Revert regression in sysfs-gpio (gpiolib.c)

Zheyu Ma <zheyuma97@gmail.com>
    ethernet: sun: Free the coherent when failing in probing

Stefano Garzarella <sgarzare@redhat.com>
    tools/virtio: fix virtio_test execution

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: should verify CTRL_VQ feature exists for MQ

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: break out of buf poll on remove

Daniel Palmer <daniel@0x0f.com>
    ARM: mstar: Select HAVE_ARM_ARCH_TIMER

Lina Wang <lina.wang@mediatek.com>
    xfrm: fix tunnel model fragmentation behavior

Michael Hübner <michaelh.95@t-online.de>
    HID: Add support for open wheel and no attachment to T300

Lucas Zampieri <lzampier@redhat.com>
    HID: logitech-dj: add new lightspeed receiver id

Muchun Song <songmuchun@bytedance.com>
    mm: kfence: fix missing objcg housekeeping for SLAB

Johan Hovold <johan@kernel.org>
    USB: serial: simple: add Nokia phone driver

Johan Hovold <johan@kernel.org>
    USB: serial: pl2303: fix GS type detection

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    dt-bindings: usb: hcd: correct usb-device path

Eddie James <eajames@linux.ibm.com>
    USB: serial: pl2303: add IBM device IDs

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-fs-f2fs            |   1 +
 Documentation/admin-guide/kernel-parameters.txt    |   3 +-
 Documentation/admin-guide/sysctl/kernel.rst        |   1 +
 .../devicetree/bindings/media/i2c/hynix,hi846.yaml |   6 +-
 .../memory-controllers/mediatek,smi-common.yaml    |  28 +-
 .../memory-controllers/mediatek,smi-larb.yaml      |  16 +-
 .../devicetree/bindings/mtd/nand-controller.yaml   |   4 +-
 .../bindings/pinctrl/microchip,sparx5-sgpio.yaml   |   2 +-
 .../bindings/spi/nvidia,tegra210-quad.yaml         |   2 +-
 Documentation/devicetree/bindings/spi/spi-mxic.txt |   4 +-
 Documentation/devicetree/bindings/usb/usb-hcd.yaml |   2 +-
 Documentation/process/stable-kernel-rules.rst      |  11 +-
 Documentation/security/SCTP.rst                    |  26 +-
 Documentation/sound/hd-audio/models.rst            |   4 +
 Documentation/sphinx/requirements.txt              |   2 +
 MAINTAINERS                                        |   3 +-
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   1 +
 arch/arc/kernel/process.c                          |   2 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |  50 +++
 arch/arm/boot/dts/bcm2837.dtsi                     |  49 +++
 arch/arm/boot/dts/dra7-l4.dtsi                     |   5 +-
 arch/arm/boot/dts/dra7.dtsi                        |   8 +-
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi          |   2 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   3 +
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |   3 +
 arch/arm/boot/dts/imx53-m53menlo.dts               |  29 +-
 arch/arm/boot/dts/imx7-colibri.dtsi                |   4 +-
 arch/arm/boot/dts/imx7-mba7.dtsi                   |   2 +-
 arch/arm/boot/dts/imx7d-nitrogen7.dts              |   2 +-
 arch/arm/boot/dts/imx7d-pico-hobbit.dts            |   4 +-
 arch/arm/boot/dts/imx7d-pico-pi.dts                |   4 +-
 arch/arm/boot/dts/imx7d-sdb.dts                    |   4 +-
 arch/arm/boot/dts/imx7s-warp.dts                   |   4 +-
 arch/arm/boot/dts/openbmc-flash-layout-64.dtsi     |   2 +-
 arch/arm/boot/dts/openbmc-flash-layout.dtsi        |   2 +-
 arch/arm/boot/dts/qcom-ipq4019.dtsi                |   3 +-
 arch/arm/boot/dts/qcom-msm8960.dtsi                |   8 +-
 arch/arm/boot/dts/sama5d2.dtsi                     |   2 +-
 arch/arm/boot/dts/sama7g5.dtsi                     |   6 -
 arch/arm/boot/dts/spear1340.dtsi                   |   6 +-
 arch/arm/boot/dts/spear13xx.dtsi                   |   6 +-
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi           |   2 +-
 arch/arm/boot/dts/sun8i-v3s.dtsi                   |  22 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |   6 +-
 arch/arm/configs/multi_v5_defconfig                |   2 +
 arch/arm/crypto/Kconfig                            |   2 +
 arch/arm/kernel/entry-ftrace.S                     |  53 +--
 arch/arm/kernel/swp_emulate.c                      |   2 +-
 arch/arm/kernel/traps.c                            |   2 +-
 arch/arm/mach-iop32x/include/mach/entry-macro.S    |   2 +-
 arch/arm/mach-iop32x/include/mach/irqs.h           |   2 +-
 arch/arm/mach-iop32x/irq.c                         |   6 +-
 arch/arm/mach-iop32x/irqs.h                        |  60 +--
 arch/arm/mach-mmp/sram.c                           |  22 +-
 arch/arm/mach-mstar/Kconfig                        |   1 +
 arch/arm/mach-s3c/mach-jive.c                      |   6 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi  |   8 +-
 .../arm64/boot/dts/broadcom/northstar2/ns2-svk.dts |   8 +-
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi   |   2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi     |   6 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |   6 +-
 arch/arm64/boot/dts/qcom/ipq6018.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |   3 +
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  16 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts    |   4 +-
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi           |   5 +-
 arch/arm64/boot/dts/ti/k3-am64.dtsi                |   1 +
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |   5 +-
 arch/arm64/boot/dts/ti/k3-am65.dtsi                |   1 +
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi          |   5 +-
 arch/arm64/boot/dts/ti/k3-j7200.dtsi               |   1 +
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |   5 +-
 arch/arm64/boot/dts/ti/k3-j721e.dtsi               |   1 +
 arch/arm64/configs/defconfig                       |   2 +-
 arch/arm64/include/asm/module.lds.h                |   6 +-
 arch/arm64/include/asm/spectre.h                   |   3 +-
 arch/arm64/kernel/proton-pack.c                    |   9 +-
 arch/arm64/kernel/signal.c                         |  10 +-
 arch/arm64/mm/init.c                               |  36 +-
 arch/arm64/mm/mmu.c                                |  41 +-
 arch/arm64/net/bpf_jit_comp.c                      |  18 +-
 arch/csky/kernel/perf_callchain.c                  |   2 +-
 arch/csky/kernel/signal.c                          |   2 +-
 arch/m68k/coldfire/device.c                        |   6 +-
 arch/microblaze/include/asm/uaccess.h              |  18 +-
 arch/mips/crypto/crc32-mips.c                      |  46 +-
 arch/mips/dec/int-handler.S                        |   6 +-
 arch/mips/dec/prom/Makefile                        |   2 +-
 arch/mips/dec/setup.c                              |   3 +-
 arch/mips/include/asm/dec/prom.h                   |  15 +-
 arch/mips/include/asm/pgalloc.h                    |   6 +
 arch/mips/mm/tlbex.c                               |  23 +-
 arch/mips/rb532/devices.c                          |   6 +-
 arch/nios2/include/asm/uaccess.h                   |  26 +-
 arch/nios2/kernel/signal.c                         |  20 +-
 arch/parisc/include/asm/traps.h                    |   1 +
 arch/parisc/kernel/cache.c                         |  28 +-
 arch/parisc/kernel/traps.c                         |   2 +
 arch/parisc/mm/fault.c                             |  89 ++++
 arch/powerpc/Makefile                              |   2 +-
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts       |  30 ++
 arch/powerpc/boot/dts/fsl/t1040rdb.dts             |   8 +-
 arch/powerpc/include/asm/io.h                      |  40 +-
 arch/powerpc/include/asm/set_memory.h              |  12 +-
 arch/powerpc/include/asm/uaccess.h                 |   3 +
 arch/powerpc/kvm/book3s_hv.c                       |   5 +-
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/powerpc/lib/sstep.c                           |  12 +-
 arch/powerpc/mm/fault.c                            |  14 +-
 arch/powerpc/mm/kasan/kasan_init_32.c              |   3 +-
 arch/powerpc/mm/numa.c                             |   4 +-
 arch/powerpc/mm/pageattr.c                         |  39 +-
 arch/powerpc/mm/pgtable_32.c                       |  24 +-
 arch/powerpc/perf/imc-pmu.c                        |   6 +-
 arch/powerpc/platforms/8xx/pic.c                   |   1 +
 arch/powerpc/platforms/powernv/rng.c               |   6 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |   4 +
 arch/powerpc/sysdev/fsl_gtm.c                      |   4 +-
 arch/riscv/boot/dts/canaan/sipeed_maix_bit.dts     |   2 +
 arch/riscv/boot/dts/canaan/sipeed_maix_dock.dts    |   2 +
 arch/riscv/boot/dts/canaan/sipeed_maix_go.dts      |   2 +
 arch/riscv/boot/dts/canaan/sipeed_maixduino.dts    |   2 +
 arch/riscv/include/asm/module.lds.h                |   6 +-
 arch/riscv/include/asm/thread_info.h               |  10 +-
 arch/riscv/kernel/perf_callchain.c                 |   6 +-
 arch/sparc/kernel/signal_32.c                      |   2 +-
 arch/um/drivers/mconsole_kern.c                    |   3 +-
 arch/x86/events/intel/pt.c                         |   2 +-
 arch/x86/kernel/kvm.c                              |   2 +-
 arch/x86/kvm/emulate.c                             |  14 +-
 arch/x86/kvm/hyperv.c                              |  96 +++--
 arch/x86/kvm/lapic.c                               |   9 +-
 arch/x86/kvm/mmu.h                                 |   1 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |  77 ++--
 arch/x86/kvm/mmu/tdp_mmu.c                         |  61 ++-
 arch/x86/kvm/mmu/tdp_mmu.h                         |   3 -
 arch/x86/kvm/svm/avic.c                            |  10 +-
 arch/x86/kvm/svm/sev.c                             |  36 +-
 arch/x86/kvm/x86.c                                 |   3 +-
 arch/x86/xen/pmu.c                                 |  10 +-
 arch/x86/xen/pmu.h                                 |   3 +-
 arch/x86/xen/smp_pv.c                              |   2 +-
 arch/xtensa/include/asm/pgtable.h                  |   4 +
 arch/xtensa/include/asm/processor.h                |   4 +-
 arch/xtensa/kernel/jump_label.c                    |   2 +-
 arch/xtensa/kernel/mxhead.S                        |   2 +
 arch/xtensa/mm/tlb.c                               |   6 +
 block/bfq-cgroup.c                                 |   6 +
 block/bfq-iosched.c                                |  31 +-
 block/bfq-wf2q.c                                   |   2 +-
 block/bio.c                                        |   3 +-
 block/blk-cgroup.c                                 |  10 +-
 block/blk-iolatency.c                              |   2 +-
 block/blk-merge.c                                  |  36 +-
 block/blk-mq-sched.c                               |   9 +-
 block/blk-mq.c                                     |  60 ++-
 block/blk-rq-qos.h                                 |  20 +-
 block/blk-sysfs.c                                  |   8 +-
 block/blk-throttle.c                               |  10 +-
 block/blk-throttle.h                               |   2 -
 block/genhd.c                                      |   2 +-
 crypto/asymmetric_keys/pkcs7_verify.c              |   6 -
 crypto/asymmetric_keys/public_key.c                | 126 ++++--
 crypto/asymmetric_keys/x509_public_key.c           |   6 -
 crypto/authenc.c                                   |   2 +-
 crypto/rsa-pkcs1pad.c                              |  11 +-
 crypto/xts.c                                       |   1 +
 drivers/acpi/acpica/nswalk.c                       |   3 +
 drivers/acpi/apei/bert.c                           |  10 +-
 drivers/acpi/apei/erst.c                           |   2 +-
 drivers/acpi/apei/hest.c                           |   2 +-
 drivers/acpi/bus.c                                 |  27 +-
 drivers/acpi/cppc_acpi.c                           |   5 +
 drivers/acpi/property.c                            |   2 +-
 drivers/base/dd.c                                  |   2 +-
 drivers/base/memory.c                              |   8 +-
 drivers/base/power/domain.c                        |   2 +-
 drivers/base/power/main.c                          |   6 +-
 drivers/block/drbd/drbd_req.c                      |   3 +-
 drivers/block/loop.c                               |  11 +-
 drivers/block/n64cart.c                            |   2 +-
 drivers/bluetooth/btintel.c                        |  11 +-
 drivers/bluetooth/btintel.h                        |   1 +
 drivers/bluetooth/btmtksdio.c                      |   4 +-
 drivers/bluetooth/btusb.c                          |   6 +
 drivers/bluetooth/hci_h5.c                         |   8 +-
 drivers/bluetooth/hci_serdev.c                     |   3 +-
 drivers/bus/mhi/core/debugfs.c                     |  26 +-
 drivers/bus/mhi/core/init.c                        |  36 +-
 drivers/bus/mhi/core/internal.h                    | 119 +++---
 drivers/bus/mhi/core/main.c                        |  22 +-
 drivers/bus/mhi/core/pm.c                          |   4 +-
 drivers/bus/mhi/pci_generic.c                      |   1 +
 drivers/bus/mips_cdmm.c                            |   1 +
 drivers/char/hw_random/Kconfig                     |   2 +-
 drivers/char/hw_random/atmel-rng.c                 |   1 +
 drivers/char/hw_random/cavium-rng-vf.c             | 194 ++++++++-
 drivers/char/hw_random/cavium-rng.c                |  11 +-
 drivers/char/hw_random/nomadik-rng.c               |   4 +-
 drivers/char/tpm/tpm-chip.c                        |  46 +-
 drivers/char/tpm/tpm.h                             |   2 +
 drivers/char/tpm/tpm2-space.c                      |  65 +++
 drivers/char/virtio_console.c                      |   7 +
 drivers/clk/actions/owl-s700.c                     |   1 +
 drivers/clk/actions/owl-s900.c                     |   2 +-
 drivers/clk/at91/sama7g5.c                         |   8 +-
 drivers/clk/clk-clps711x.c                         |   2 +
 drivers/clk/clk.c                                  |  16 +-
 drivers/clk/hisilicon/clk-hi3559a.c                |   4 +-
 drivers/clk/imx/clk-imx7d.c                        |   1 -
 drivers/clk/imx/clk-imx8qxp-lpcg.c                 |   2 +-
 drivers/clk/loongson1/clk-loongson1c.c             |   1 +
 drivers/clk/qcom/clk-rcg2.c                        |  14 +-
 drivers/clk/qcom/gcc-ipq8074.c                     |  21 +-
 drivers/clk/qcom/gcc-msm8994.c                     |   1 +
 drivers/clk/renesas/r9a07g044-cpg.c                |   4 +-
 drivers/clk/rockchip/clk.c                         |   3 +
 drivers/clk/tegra/clk-tegra124-emc.c               |   1 +
 drivers/clk/uniphier/clk-uniphier-fixed-rate.c     |   1 +
 drivers/clocksource/acpi_pm.c                      |   6 +-
 drivers/clocksource/exynos_mct.c                   |  60 ++-
 drivers/clocksource/timer-microchip-pit64b.c       |   2 +-
 drivers/clocksource/timer-of.c                     |   6 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |   4 +-
 drivers/cpufreq/qcom-cpufreq-nvmem.c               |   2 +-
 drivers/cpuidle/cpuidle-qcom-spm.c                 |  20 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   3 +
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |   3 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   3 +
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |   2 +
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |   3 +
 drivers/crypto/amlogic/amlogic-gxl-cipher.c        |   2 +
 drivers/crypto/ccp/ccp-dmaengine.c                 |  16 +
 drivers/crypto/ccp/sev-dev.c                       |   2 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |   7 +
 drivers/crypto/ccree/cc_cipher.c                   |   2 +-
 drivers/crypto/gemini/sl3516-ce-cipher.c           |   2 +
 drivers/crypto/hisilicon/qm.c                      |   2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  16 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   8 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c |  17 +-
 drivers/crypto/mxs-dcp.c                           |   2 +-
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   |   1 -
 drivers/crypto/vmx/Kconfig                         |   4 +
 drivers/cxl/core/bus.c                             |   4 +
 drivers/cxl/core/regs.c                            |   6 +-
 drivers/dax/super.c                                |   1 +
 drivers/dma-buf/udmabuf.c                          |   4 +
 drivers/dma/hisi_dma.c                             |   2 +-
 drivers/dma/idxd/device.c                          |  34 +-
 drivers/dma/idxd/idxd.h                            |  12 +-
 drivers/dma/idxd/init.c                            |   6 +-
 drivers/dma/idxd/registers.h                       |  14 +-
 drivers/dma/idxd/sysfs.c                           |  42 +-
 drivers/firmware/efi/efi-pstore.c                  |   2 +-
 drivers/firmware/google/Kconfig                    |   2 +-
 drivers/firmware/qcom_scm.c                        |   6 -
 drivers/firmware/stratix10-svc.c                   |   2 +-
 drivers/firmware/sysfb_simplefb.c                  |  23 +-
 drivers/fsi/fsi-master-aspeed.c                    |  17 +-
 drivers/fsi/fsi-scom.c                             |  45 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  15 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  11 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  10 +-
 .../amd/display/dc/irq/dcn21/irq_service_dcn21.c   |  14 -
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   2 +-
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |   1 +
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  29 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   3 +-
 drivers/gpu/drm/bridge/cdns-dsi.c                  |   1 +
 drivers/gpu/drm/bridge/nwl-dsi.c                   |   1 +
 drivers/gpu/drm/bridge/sil-sii8620.c               |   2 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |   5 +-
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c      |   1 +
 drivers/gpu/drm/drm_edid.c                         |  18 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   9 +-
 drivers/gpu/drm/drm_syncobj.c                      |  61 ++-
 drivers/gpu/drm/i915/display/intel_bw.c            |   3 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   2 +-
 drivers/gpu/drm/i915/display/intel_hdmi.c          |  13 +-
 drivers/gpu/drm/i915/display/intel_opregion.c      |  15 +
 drivers/gpu/drm/i915/display/intel_pps.c           |   6 +-
 drivers/gpu/drm/i915/display/intel_pps.h           |   2 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |   4 +
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   2 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  10 +-
 drivers/gpu/drm/meson/Makefile                     |   1 +
 drivers/gpu/drm/meson/meson_drv.c                  |  28 +-
 drivers/gpu/drm/meson/meson_dw_hdmi.c              | 341 +--------------
 drivers/gpu/drm/meson/meson_encoder_hdmi.c         | 370 +++++++++++++++++
 drivers/gpu/drm/meson/meson_encoder_hdmi.h         |  12 +
 drivers/gpu/drm/meson/meson_osd_afbcd.c            |  41 +-
 drivers/gpu/drm/meson/meson_osd_afbcd.h            |   1 +
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   5 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  12 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c             |   8 +
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   3 +
 drivers/gpu/drm/msm/dp/dp_display.c                |   5 +
 drivers/gpu/drm/msm/dp/dp_panel.c                  |   5 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c         |   4 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c         |   4 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm.c         |   4 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_28nm_8960.c    |   4 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c          |  26 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |   6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/hsfw.c     |   9 +-
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |   5 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   2 +-
 drivers/gpu/drm/selftests/test-drm_dp_mst_helper.c |   4 +-
 drivers/gpu/drm/tegra/dsi.c                        |   4 +-
 drivers/gpu/drm/tiny/simpledrm.c                   |   3 +
 drivers/gpu/drm/v3d/v3d_drv.c                      |   8 +-
 drivers/gpu/host1x/dev.c                           |   1 +
 drivers/greybus/svc.c                              |   8 +-
 drivers/hid/hid-logitech-dj.c                      |   1 +
 drivers/hid/hid-thrustmaster.c                     |   2 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  32 +-
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c        |  29 +-
 drivers/hv/hv_balloon.c                            |   2 +-
 drivers/hwmon/pmbus/pmbus.h                        |   1 +
 drivers/hwmon/pmbus/pmbus_core.c                   |  18 +-
 drivers/hwmon/sch56xx-common.c                     |   2 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   8 +-
 drivers/hwtracing/coresight/coresight-syscfg.c     |   2 +-
 drivers/i2c/busses/i2c-bcm2835.c                   |  26 +-
 drivers/i2c/busses/i2c-meson.c                     |  12 +-
 drivers/i2c/busses/i2c-pasemi-core.c               |   1 -
 drivers/i2c/busses/i2c-pasemi-pci.c                |   1 +
 drivers/i2c/busses/i2c-xiic.c                      |   3 +-
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   5 +-
 drivers/iio/accel/mma8452.c                        |  29 +-
 drivers/iio/adc/aspeed_adc.c                       |   4 +-
 drivers/iio/adc/twl6030-gpadc.c                    |   2 +
 drivers/iio/afe/iio-rescale.c                      |   8 +-
 drivers/iio/inkern.c                               |  40 +-
 drivers/infiniband/core/cma.c                      |   2 +-
 drivers/infiniband/core/nldev.c                    |   3 +-
 drivers/infiniband/core/verbs.c                    |   1 +
 drivers/infiniband/hw/hfi1/verbs.c                 |   3 +-
 drivers/infiniband/hw/irdma/ctrl.c                 |  10 +-
 drivers/infiniband/hw/irdma/hw.c                   |   2 +-
 drivers/infiniband/hw/irdma/i40iw_if.c             |   1 +
 drivers/infiniband/hw/irdma/main.c                 |   1 +
 drivers/infiniband/hw/irdma/main.h                 |   1 +
 drivers/infiniband/hw/irdma/utils.c                |  48 ++-
 drivers/infiniband/hw/irdma/verbs.c                |   4 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   4 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   2 +
 drivers/infiniband/sw/rxe/rxe_av.c                 |  19 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |   5 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  17 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |  63 +--
 drivers/infiniband/sw/rxe/rxe_resp.c               |  12 +-
 drivers/input/input.c                              |   6 -
 drivers/input/touchscreen/zinitix.c                |  44 +-
 drivers/iommu/iova.c                               |   5 +-
 drivers/iommu/ipmmu-vmsa.c                         |   4 +-
 drivers/iommu/mtk_iommu.c                          |  32 +-
 drivers/iommu/mtk_iommu_v1.c                       |  40 +-
 drivers/irqchip/irq-nvic.c                         |   2 +
 drivers/irqchip/qcom-pdc.c                         |   5 +-
 drivers/mailbox/imx-mailbox.c                      |  11 +-
 drivers/mailbox/tegra-hsp.c                        |   5 +
 drivers/md/bcache/btree.c                          |   6 +-
 drivers/md/bcache/writeback.c                      |   6 +-
 drivers/md/dm-core.h                               |   2 +
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/dm-integrity.c                          |   6 +-
 drivers/md/dm-stats.c                              |  34 +-
 drivers/md/dm-stats.h                              |  11 +-
 drivers/md/dm.c                                    |  86 ++--
 drivers/media/i2c/adv7511-v4l2.c                   |   2 +-
 drivers/media/i2c/adv7604.c                        |   2 +-
 drivers/media/i2c/adv7842.c                        |   2 +-
 drivers/media/i2c/ov5640.c                         |  14 +-
 drivers/media/i2c/ov5648.c                         |  12 +-
 drivers/media/i2c/ov6650.c                         | 115 +++--
 drivers/media/pci/bt8xx/bttv-driver.c              |   4 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |   3 +
 drivers/media/pci/ivtv/ivtv-driver.h               |   1 -
 drivers/media/pci/ivtv/ivtv-ioctl.c                |  10 +-
 drivers/media/pci/ivtv/ivtv-streams.c              |  11 +-
 drivers/media/pci/saa7134/saa7134-alsa.c           |   4 +-
 drivers/media/platform/aspeed-video.c              |   9 +-
 drivers/media/platform/atmel/atmel-isc-base.c      |  22 +-
 drivers/media/platform/atmel/atmel-sama7g5-isc.c   |   6 -
 drivers/media/platform/coda/coda-common.c          |   1 +
 drivers/media/platform/davinci/vpif.c              | 109 +++--
 drivers/media/platform/imx-jpeg/mxc-jpeg.c         |   7 +-
 drivers/media/platform/meson/ge2d/ge2d.c           |  24 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c  |   2 +
 drivers/media/platform/omap3isp/ispstat.c          |   5 +-
 drivers/media/platform/qcom/camss/camss-csid-170.c |  19 +-
 drivers/media/platform/qcom/camss/camss-vfe-170.c  |  12 +-
 drivers/media/platform/qcom/venus/helpers.c        |   2 +-
 drivers/media/platform/qcom/venus/hfi_cmds.c       |   2 +
 drivers/media/platform/qcom/venus/venc.c           |   4 +-
 drivers/media/platform/qcom/venus/venc_ctrls.c     |   6 +-
 drivers/media/platform/ti-vpe/cal-video.c          |   3 +
 drivers/media/rc/gpio-ir-tx.c                      |  28 +-
 drivers/media/rc/ir_toy.c                          |   2 +-
 drivers/media/test-drivers/vidtv/vidtv_s302m.c     |  17 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  13 +-
 drivers/media/usb/go7007/s2250-board.c             |  10 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   4 +-
 drivers/media/usb/stk1160/stk1160-core.c           |   2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |  10 +-
 drivers/media/usb/stk1160/stk1160.h                |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  10 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |  12 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  53 ++-
 drivers/memory/emif.c                              |   8 +-
 drivers/memory/tegra/tegra20-emc.c                 |   2 +-
 drivers/memstick/core/mspro_block.c                |  10 +-
 drivers/mfd/asic3.c                                |  10 +-
 drivers/mfd/mc13xxx-core.c                         |   4 +-
 drivers/misc/cardreader/alcor_pci.c                |   9 +-
 drivers/misc/habanalabs/common/debugfs.c           |   2 +
 drivers/misc/kgdbts.c                              |   4 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/hw-me.c                           |  23 +-
 drivers/misc/mei/interrupt.c                       |  35 +-
 drivers/misc/mei/pci-me.c                          |   1 +
 drivers/mmc/core/bus.c                             |   9 +-
 drivers/mmc/core/bus.h                             |   3 +-
 drivers/mmc/core/host.c                            |  15 +-
 drivers/mmc/core/mmc.c                             |  16 +-
 drivers/mmc/core/sd.c                              |  25 +-
 drivers/mmc/core/sdio.c                            |   5 +-
 drivers/mmc/core/sdio_bus.c                        |   7 +-
 drivers/mmc/host/davinci_mmc.c                     |   6 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  20 +-
 drivers/mmc/host/sdhci_am654.c                     |  24 +-
 drivers/mtd/devices/mchp23k256.c                   |  14 +
 drivers/mtd/devices/mchp48l640.c                   |  10 +
 drivers/mtd/nand/onenand/generic.c                 |   7 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  14 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   3 +
 drivers/mtd/nand/raw/nand_base.c                   |  44 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |   2 +-
 drivers/mtd/ubi/build.c                            |   9 +-
 drivers/mtd/ubi/fastmap.c                          |  28 +-
 drivers/mtd/ubi/vmt.c                              |   8 +-
 drivers/net/bareudp.c                              |  19 +-
 drivers/net/can/m_can/m_can.c                      |   5 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   2 +-
 drivers/net/can/usb/ems_usb.c                      |   1 -
 drivers/net/can/usb/mcba_usb.c                     |  27 +-
 drivers/net/can/usb/usb_8dev.c                     |  30 +-
 drivers/net/can/vxcan.c                            |   2 +-
 drivers/net/dsa/Kconfig                            |  12 +-
 drivers/net/dsa/Makefile                           |   3 +-
 drivers/net/dsa/bcm_sf2_cfp.c                      |   6 +-
 drivers/net/dsa/microchip/ksz8795_spi.c            |  11 +
 drivers/net/dsa/microchip/ksz9477_spi.c            |  12 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   1 +
 drivers/net/dsa/realtek/Kconfig                    |  20 +
 drivers/net/dsa/realtek/Makefile                   |   3 +
 drivers/net/dsa/{ => realtek}/realtek-smi-core.c   |   0
 drivers/net/dsa/{ => realtek}/realtek-smi-core.h   |   4 +-
 drivers/net/dsa/{ => realtek}/rtl8365mb.c          |   0
 drivers/net/dsa/{ => realtek}/rtl8366.c            |   0
 drivers/net/dsa/{ => realtek}/rtl8366rb.c          |   2 +
 drivers/net/ethernet/8390/mcf8390.c                |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   5 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   | 128 +++---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  18 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  15 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |   1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  47 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 234 ++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   4 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  12 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  63 ++-
 drivers/net/ethernet/ibm/ibmvnic.h                 |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  19 +-
 drivers/net/ethernet/intel/ice/ice.h               |   4 +-
 drivers/net/ethernet/intel/ice/ice_idc.c           |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  25 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  16 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   4 -
 drivers/net/ethernet/intel/igb/igb_main.c          |  19 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  16 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  27 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  15 +-
 drivers/net/ethernet/microchip/sparx5/Kconfig      |   2 +
 .../net/ethernet/microchip/sparx5/sparx5_fdma.c    |   2 +
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |  20 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |   1 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  34 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |  29 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.h        |   1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h    |  10 +-
 drivers/net/ethernet/sun/sunhme.c                  |   6 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c             |   6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  72 ++--
 drivers/net/phy/at803x.c                           |  40 +-
 drivers/net/phy/broadcom.c                         |  21 +
 drivers/net/phy/micrel.c                           |  32 +-
 drivers/net/usb/asix.h                             |   4 +-
 drivers/net/usb/asix_common.c                      |  19 +-
 drivers/net/usb/asix_devices.c                     |  21 +-
 drivers/net/wireguard/queueing.c                   |   3 +-
 drivers/net/wireguard/socket.c                     |   5 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   2 +-
 drivers/net/wireless/ath/ath10k/wow.c              |   7 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  72 ++--
 drivers/net/wireless/ath/ath11k/mac.c              |   3 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   5 +
 drivers/net/wireless/ath/carl9170/main.c           |   2 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  73 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   1 -
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   2 -
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   2 -
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   8 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   3 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   1 -
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  67 ++-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    | 119 ------
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  21 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  49 +--
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   1 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    | 124 ++++++
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |  18 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |  11 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |  38 ++
 drivers/net/wireless/mediatek/mt76/sdio.h          |   2 +
 drivers/net/wireless/ray_cs.c                      |   6 +
 drivers/nvdimm/region_devs.c                       |   3 +
 drivers/nvme/host/core.c                           |  48 ++-
 drivers/nvme/host/multipath.c                      |   7 +-
 drivers/nvme/host/nvme.h                           |  19 +
 drivers/nvme/host/tcp.c                            |  40 ++
 drivers/pci/access.c                               |   9 +-
 drivers/pci/controller/dwc/pci-imx6.c              |  10 +-
 drivers/pci/controller/dwc/pcie-fu740.c            |  51 ++-
 drivers/pci/controller/pci-aardvark.c              |  13 +-
 drivers/pci/controller/pci-xgene.c                 |   2 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   2 +
 drivers/pci/quirks.c                               |  12 +
 drivers/phy/broadcom/phy-brcm-usb-init.c           |  36 ++
 drivers/phy/broadcom/phy-brcm-usb-init.h           |   1 +
 drivers/phy/broadcom/phy-brcm-usb.c                |  11 +-
 drivers/phy/phy-core-mipi-dphy.c                   |   4 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   2 +
 drivers/pinctrl/mediatek/pinctrl-paris.c           |  32 +-
 drivers/pinctrl/nomadik/pinctrl-nomadik.c          |   4 +-
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c          | 185 ++++-----
 drivers/pinctrl/pinconf-generic.c                  |   6 +-
 drivers/pinctrl/pinctrl-ingenic.c                  |  46 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c          |  15 +
 drivers/pinctrl/pinctrl-rockchip.c                 |   2 +
 drivers/pinctrl/renesas/core.c                     |   5 +-
 drivers/pinctrl/renesas/pfc-r8a77470.c             |   4 +-
 drivers/pinctrl/samsung/pinctrl-exynos-arm64.c     |   2 -
 drivers/pinctrl/samsung/pinctrl-samsung.c          |  30 +-
 drivers/platform/chrome/Makefile                   |   3 +-
 drivers/platform/chrome/cros_ec_sensorhub_ring.c   |   3 +-
 drivers/platform/chrome/cros_ec_sensorhub_trace.h  | 123 ++++++
 drivers/platform/chrome/cros_ec_trace.h            |  95 -----
 drivers/platform/chrome/cros_ec_typec.c            |   6 +
 drivers/platform/x86/huawei-wmi.c                  |  13 +-
 drivers/power/reset/gemini-poweroff.c              |   4 +-
 drivers/power/supply/ab8500_chargalg.c             |   4 +-
 drivers/power/supply/ab8500_fg.c                   |   4 +-
 drivers/power/supply/bq24190_charger.c             |   7 +-
 drivers/power/supply/sbs-charger.c                 |  18 +-
 drivers/power/supply/wm8350_power.c                |  97 ++++-
 drivers/powercap/dtpm_cpu.c                        |   7 +
 drivers/pps/clients/pps-gpio.c                     |   2 +-
 drivers/ptp/ptp_clock.c                            |  11 +-
 drivers/pwm/pwm-lpc18xx-sct.c                      |  20 +-
 drivers/regulator/qcom_smd-regulator.c             |   4 +-
 drivers/regulator/rpi-panel-attiny-regulator.c     |  56 ++-
 drivers/remoteproc/qcom_q6v5_adsp.c                |   1 +
 drivers/remoteproc/qcom_q6v5_mss.c                 |  11 +-
 drivers/remoteproc/qcom_wcnss.c                    |   1 +
 drivers/remoteproc/remoteproc_debugfs.c            |   2 +-
 drivers/rtc/interface.c                            |   7 +-
 drivers/rtc/rtc-mc146818-lib.c                     |   6 +-
 drivers/rtc/rtc-pl031.c                            |   6 +-
 drivers/scsi/fnic/fnic_scsi.c                      |  15 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   2 +-
 drivers/scsi/libsas/sas_ata.c                      |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  25 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  23 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   | 209 +++++-----
 drivers/scsi/qla2xxx/qla_attr.c                    |   7 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   6 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  22 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |  25 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   4 +-
 drivers/scsi/qla2xxx/qla_gs.c                      | 160 +++----
 drivers/scsi/qla2xxx/qla_init.c                    | 233 ++++++-----
 drivers/scsi/qla2xxx/qla_inline.h                  |   2 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |  93 +++--
 drivers/scsi/qla2xxx/qla_isr.c                     |   1 +
 drivers/scsi/qla2xxx/qla_mbx.c                     |  29 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |   9 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |  11 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  22 +
 drivers/scsi/qla2xxx/qla_os.c                      |  54 ++-
 drivers/scsi/qla2xxx/qla_sup.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  14 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |   9 +-
 drivers/scsi/scsi_error.c                          |   9 +-
 drivers/scsi/scsi_transport_fc.c                   |  39 +-
 drivers/scsi/sd.c                                  |   6 +-
 drivers/scsi/ufs/ufshcd.c                          |  21 +-
 drivers/soc/mediatek/mtk-pm-domains.c              |   3 +
 drivers/soc/qcom/ocmem.c                           |   1 +
 drivers/soc/qcom/qcom_aoss.c                       |   8 +-
 drivers/soc/qcom/rpmpd.c                           |   3 +
 drivers/soc/ti/wkup_m3_ipc.c                       |   4 +-
 drivers/soundwire/dmi-quirks.c                     |   2 +-
 drivers/soundwire/intel.c                          |   4 +-
 drivers/spi/spi-fsi.c                              |  10 +
 drivers/spi/spi-mt65xx.c                           |  15 +-
 drivers/spi/spi-mxic.c                             |  28 +-
 drivers/spi/spi-pxa2xx-pci.c                       |  17 +-
 drivers/spi/spi-tegra114.c                         |   4 +
 drivers/spi/spi-tegra20-slink.c                    |   8 +-
 drivers/spi/spi-tegra210-quad.c                    |   2 +
 drivers/spi/spi-zynqmp-gqspi.c                     |   5 +-
 drivers/spi/spi.c                                  |   4 +-
 drivers/staging/iio/adc/ad7280a.c                  |   4 +-
 drivers/staging/media/atomisp/pci/atomisp_acc.c    |  28 +-
 .../media/atomisp/pci/atomisp_gmin_platform.c      |  18 +
 drivers/staging/media/atomisp/pci/hmm/hmm.c        |   7 +-
 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c  |   2 +-
 drivers/staging/media/hantro/hantro_h1_regs.h      |   2 +-
 drivers/staging/media/imx/imx7-mipi-csis.c         |   6 +-
 drivers/staging/media/imx/imx8mq-mipi-csi2.c       |  74 ++--
 drivers/staging/media/meson/vdec/esparser.c        |   7 +-
 drivers/staging/media/meson/vdec/vdec_helpers.c    |   8 +-
 drivers/staging/media/meson/vdec/vdec_helpers.h    |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c   |   2 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c   |   2 +-
 drivers/staging/media/zoran/zoran.h                |   2 +-
 drivers/staging/media/zoran/zoran_card.c           |  86 ++--
 drivers/staging/media/zoran/zoran_device.c         |   7 +-
 drivers/staging/media/zoran/zoran_driver.c         |  18 +-
 drivers/staging/mt7621-dts/gbpc1.dts               |  40 +-
 drivers/staging/mt7621-dts/gbpc2.dts               | 116 +++++-
 drivers/staging/mt7621-dts/mt7621.dtsi             |  26 +-
 drivers/staging/qlge/qlge_main.c                   |  11 +-
 drivers/staging/r8188eu/core/rtw_recv.c            |   3 +-
 drivers/staging/r8188eu/hal/rtl8188e_hal_init.c    |   4 +-
 .../intel/int340x_thermal/int3400_thermal.c        |   7 +-
 drivers/tty/hvc/hvc_iucv.c                         |   4 +-
 drivers/tty/mxser.c                                |  15 +-
 drivers/tty/serial/8250/8250_aspeed_vuart.c        |   2 +-
 drivers/tty/serial/8250/8250_dma.c                 |  11 +-
 drivers/tty/serial/8250/8250_lpss.c                |  28 +-
 drivers/tty/serial/8250/8250_mid.c                 |  19 +-
 drivers/tty/serial/8250/8250_port.c                |  24 +-
 drivers/tty/serial/kgdboc.c                        |   6 +-
 drivers/tty/serial/serial_core.c                   |  14 +
 drivers/usb/host/xhci-hub.c                        |   5 +-
 drivers/usb/host/xhci-mem.c                        |   2 +-
 drivers/usb/host/xhci.c                            |  20 +-
 drivers/usb/host/xhci.h                            |  14 +-
 drivers/usb/serial/Kconfig                         |   1 +
 drivers/usb/serial/pl2303.c                        |   2 +
 drivers/usb/serial/pl2303.h                        |   3 +
 drivers/usb/serial/usb-serial-simple.c             |   7 +
 drivers/usb/storage/ene_ub6250.c                   | 155 ++++---
 drivers/usb/storage/realtek_cr.c                   |   2 +-
 drivers/usb/typec/tipd/core.c                      |   5 +
 drivers/usb/typec/tipd/tps6598x.h                  |   1 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  25 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  61 +++
 drivers/vhost/iotlb.c                              |   6 +-
 drivers/video/fbdev/atafb.c                        |  12 +-
 drivers/video/fbdev/atmel_lcdfb.c                  |  11 +-
 drivers/video/fbdev/cirrusfb.c                     |  16 +-
 drivers/video/fbdev/controlfb.c                    |   2 +
 drivers/video/fbdev/core/fbcvt.c                   |  53 +--
 drivers/video/fbdev/core/fbmem.c                   |  29 +-
 drivers/video/fbdev/matrox/matroxfb_base.c         |   2 +-
 drivers/video/fbdev/nvidia/nv_i2c.c                |   2 +-
 .../fbdev/omap2/omapfb/displays/connector-dvi.c    |   1 +
 .../fbdev/omap2/omapfb/displays/panel-dsi-cm.c     |   8 +-
 .../omap2/omapfb/displays/panel-sony-acx565akm.c   |   2 +-
 .../omap2/omapfb/displays/panel-tpo-td043mtea1.c   |   4 +-
 drivers/video/fbdev/sm712fb.c                      |  46 +-
 drivers/video/fbdev/smscufx.c                      |   3 +-
 drivers/video/fbdev/udlfb.c                        |   8 +-
 drivers/video/fbdev/w100fb.c                       |  15 +-
 drivers/virt/acrn/hsm.c                            |  20 +-
 drivers/virt/acrn/mm.c                             |  24 ++
 drivers/virtio/virtio.c                            |   5 +-
 drivers/virtio/virtio_pci_common.c                 |  48 +--
 drivers/virtio/virtio_pci_common.h                 |   7 +-
 drivers/virtio/virtio_pci_legacy.c                 |   5 +-
 drivers/virtio/virtio_pci_modern.c                 |   6 +-
 drivers/watchdog/rti_wdt.c                         |   1 +
 fs/binfmt_elf.c                                    |  90 ++--
 fs/binfmt_elf_fdpic.c                              |  18 +-
 fs/btrfs/block-group.c                             |   8 +-
 fs/btrfs/compression.c                             |  20 +-
 fs/btrfs/disk-io.c                                 |  26 +-
 fs/btrfs/extent_io.c                               |  22 +-
 fs/btrfs/file-item.c                               |  38 +-
 fs/btrfs/inode.c                                   |   8 +-
 fs/btrfs/reflink.c                                 |   7 +-
 fs/btrfs/space-info.c                              |   3 +-
 fs/btrfs/volumes.c                                 |  48 ++-
 fs/buffer.c                                        |   8 +-
 fs/cifs/cifsfs.c                                   |  14 +-
 fs/cifs/connect.c                                  |  14 +-
 fs/cifs/file.c                                     |  10 +
 fs/cifs/smb2ops.c                                  | 130 +++---
 fs/coredump.c                                      |  86 +++-
 fs/exec.c                                          |  26 +-
 fs/ext2/super.c                                    |   6 +-
 fs/ext4/inline.c                                   |   9 +-
 fs/ext4/inode.c                                    |  25 ++
 fs/ext4/mballoc.c                                  | 128 +++---
 fs/ext4/namei.c                                    |  10 +-
 fs/f2fs/checkpoint.c                               |   8 +-
 fs/f2fs/compress.c                                 |   5 +-
 fs/f2fs/data.c                                     |   8 +-
 fs/f2fs/debug.c                                    |  18 +-
 fs/f2fs/f2fs.h                                     |   1 +
 fs/f2fs/file.c                                     |   5 +-
 fs/f2fs/gc.c                                       |   4 +-
 fs/f2fs/inode.c                                    |   7 +-
 fs/f2fs/node.c                                     |   6 +-
 fs/f2fs/segment.c                                  |   7 +
 fs/f2fs/super.c                                    |  10 +-
 fs/f2fs/sysfs.c                                    |   2 +-
 fs/file.c                                          |  31 +-
 fs/gfs2/bmap.c                                     |   2 +-
 fs/gfs2/file.c                                     |   3 +-
 fs/gfs2/inode.c                                    |   2 +-
 fs/gfs2/rgrp.c                                     |  10 +-
 fs/gfs2/rgrp.h                                     |   2 +-
 fs/gfs2/super.c                                    |   2 +-
 fs/io_uring.c                                      |  18 +-
 fs/jffs2/build.c                                   |   4 +-
 fs/jffs2/fs.c                                      |   2 +-
 fs/jffs2/scan.c                                    |   6 +-
 fs/jfs/jfs_dmap.c                                  |   7 +
 fs/nfs/callback_proc.c                             |  27 +-
 fs/nfs/callback_xdr.c                              |   4 -
 fs/nfs/nfs2xdr.c                                   |   2 +-
 fs/nfs/nfs3xdr.c                                   |  22 +-
 fs/nfs/nfs4proc.c                                  |   1 +
 fs/nfs/pagelist.c                                  |   1 +
 fs/nfs/pnfs.c                                      |  11 +
 fs/nfs/pnfs.h                                      |   2 +
 fs/nfs/proc.c                                      |   1 +
 fs/nfs/write.c                                     |   7 +-
 fs/nfsd/filecache.c                                |   6 +-
 fs/nfsd/nfs4state.c                                |  12 +-
 fs/nfsd/nfsproc.c                                  |   2 +-
 fs/nfsd/xdr.h                                      |   2 +-
 fs/ntfs/inode.c                                    |   4 +
 fs/ocfs2/quota_global.c                            |  23 +-
 fs/ocfs2/quota_local.c                             |   2 -
 fs/proc/bootconfig.c                               |   2 +
 fs/pstore/platform.c                               |  38 +-
 fs/ubifs/dir.c                                     | 238 ++++++-----
 fs/ubifs/file.c                                    |  14 +-
 fs/ubifs/io.c                                      |  34 +-
 fs/ubifs/ioctl.c                                   |   2 +-
 fs/ubifs/journal.c                                 |  52 ++-
 include/drm/drm_connector.h                        |  12 +-
 include/drm/drm_dp_helper.h                        |   2 +-
 include/drm/drm_modeset_lock.h                     |   1 +
 include/linux/atomic/atomic-arch-fallback.h        |  38 +-
 include/linux/binfmts.h                            |   3 +
 include/linux/blk-cgroup.h                         |  17 +
 include/linux/blk_types.h                          |   3 +-
 include/linux/coredump.h                           |   5 +-
 include/linux/fb.h                                 |   1 +
 include/linux/lsm_hook_defs.h                      |   2 +
 include/linux/lsm_hooks.h                          |   5 +
 include/linux/mm.h                                 |  14 -
 include/linux/mtd/rawnand.h                        |   2 +
 include/linux/netfilter_netdev.h                   |   2 +-
 include/linux/nvme.h                               |   1 +
 include/linux/pci.h                                |   1 +
 include/linux/pstore.h                             |   6 +-
 include/linux/randomize_kstack.h                   |  16 +-
 include/linux/sched.h                              |  19 +-
 include/linux/security.h                           |   8 +
 include/linux/serial_core.h                        |   2 +
 include/linux/skbuff.h                             |  28 +-
 include/linux/skmsg.h                              |  13 +-
 include/linux/soc/ti/ti_sci_protocol.h             |   2 +-
 include/linux/sunrpc/xdr.h                         |   2 +
 include/linux/sunrpc/xprt.h                        |   3 +
 include/linux/sunrpc/xprtsock.h                    |   2 +-
 include/net/netfilter/nf_conntrack_helper.h        |   1 +
 include/net/netfilter/nf_flow_table.h              |  18 +
 include/scsi/scsi_device.h                         |   1 +
 include/sound/pcm.h                                |   1 +
 include/trace/events/ext4.h                        |  78 ++--
 include/trace/events/rxrpc.h                       |   8 +-
 include/trace/events/sched.h                       |  11 +-
 include/uapi/linux/bpf.h                           |  12 +-
 include/uapi/linux/loop.h                          |   4 +-
 include/uapi/linux/omap3isp.h                      |  21 +-
 include/uapi/linux/rfkill.h                        |  14 +-
 include/uapi/linux/rseq.h                          |  20 +-
 include/uapi/linux/serial_core.h                   |   3 +
 kernel/audit.h                                     |   4 +
 kernel/auditsc.c                                   |  87 +++-
 kernel/bpf/btf.c                                   |  55 ++-
 kernel/bpf/stackmap.c                              |  56 ++-
 kernel/debug/kdb/kdb_support.c                     |   2 +-
 kernel/dma/debug.c                                 |   4 +-
 kernel/dma/swiotlb.c                               |  11 +-
 kernel/events/core.c                               |   3 +
 kernel/livepatch/core.c                            |   4 +-
 kernel/locking/lockdep.c                           |  38 +-
 kernel/locking/lockdep_internals.h                 |   6 +-
 kernel/locking/lockdep_proc.c                      |  51 ++-
 kernel/power/hibernate.c                           |   2 +-
 kernel/power/suspend_test.c                        |   8 +-
 kernel/printk/printk.c                             |   6 +-
 kernel/ptrace.c                                    |  47 ++-
 kernel/rcu/rcu_segcblist.h                         |   4 +-
 kernel/rcu/tree.c                                  |  71 ++--
 kernel/rcu/tree.h                                  |   4 +-
 kernel/resource.c                                  |  41 +-
 kernel/rseq.c                                      |   8 +-
 kernel/sched/core.c                                |   5 +-
 kernel/sched/cpuacct.c                             |   3 +-
 kernel/sched/cpufreq_schedutil.c                   |   1 +
 kernel/sched/deadline.c                            |  12 +-
 kernel/sched/debug.c                               |  10 -
 kernel/sched/fair.c                                |  18 +-
 kernel/sched/rt.c                                  |  32 +-
 kernel/trace/fgraph.c                              |   4 +-
 kernel/trace/ftrace.c                              |   4 +-
 kernel/trace/trace.c                               |   9 +-
 kernel/trace/trace_events.c                        |  96 ++++-
 kernel/trace/trace_osnoise.c                       |   4 +-
 kernel/trace/trace_sched_switch.c                  |   1 +
 kernel/trace/trace_sched_wakeup.c                  |   1 +
 kernel/watch_queue.c                               |   4 +-
 lib/kunit/try-catch.c                              |   2 +-
 lib/raid6/test/Makefile                            |   4 +-
 lib/raid6/test/test.c                              |   1 -
 lib/test_kmod.c                                    |   1 +
 lib/test_lockup.c                                  |  11 +-
 lib/test_xarray.c                                  |  22 +
 lib/vsprintf.c                                     |  48 ++-
 lib/xarray.c                                       |   4 +
 mm/kmemleak.c                                      |   9 +-
 mm/madvise.c                                       |   3 +-
 mm/memcontrol.c                                    |   2 +-
 mm/memory.c                                        |  65 ++-
 mm/mempolicy.c                                     |   8 +-
 mm/mlock.c                                         |   7 +-
 mm/mmap.c                                          |   2 +-
 mm/page_alloc.c                                    |   9 +-
 mm/slab.c                                          |   1 +
 mm/usercopy.c                                      |   5 +-
 net/bluetooth/hci_conn.c                           |   2 +
 net/can/isotp.c                                    |  69 +--
 net/core/skbuff.c                                  |  51 ++-
 net/core/skmsg.c                                   |  17 +-
 net/dsa/dsa2.c                                     |   5 +
 net/ipv4/route.c                                   |  18 +-
 net/ipv4/tcp_bpf.c                                 |  14 +-
 net/ipv4/tcp_output.c                              |   5 +-
 net/ipv6/xfrm6_output.c                            |  16 +
 net/key/af_key.c                                   |   2 +-
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/main.c                                |  13 +-
 net/mac80211/mesh.c                                |   2 +-
 net/mac80211/mlme.c                                |  15 +-
 net/mac80211/util.c                                |  27 +-
 net/mptcp/protocol.c                               |   1 +
 net/netfilter/nf_conntrack_core.c                  |   4 +-
 net/netfilter/nf_conntrack_helper.c                |   6 +
 net/netfilter/nf_conntrack_proto_tcp.c             |  17 +-
 net/netfilter/nf_flow_table_inet.c                 |  17 +
 net/netfilter/nf_flow_table_ip.c                   |  18 -
 net/netfilter/nft_ct.c                             |   3 +
 net/netlink/af_netlink.c                           |   2 +
 net/openvswitch/conntrack.c                        | 132 +++---
 net/openvswitch/flow_netlink.c                     |   4 +-
 net/rfkill/core.c                                  |  48 ++-
 net/rxrpc/ar-internal.h                            |  15 +-
 net/rxrpc/call_event.c                             |   2 +-
 net/rxrpc/call_object.c                            |  40 +-
 net/rxrpc/server_key.c                             |   7 +-
 net/sched/act_ct.c                                 |  19 +-
 net/sctp/sm_statefuns.c                            |   8 +-
 net/sunrpc/clnt.c                                  |   6 +-
 net/sunrpc/sched.c                                 |  22 +-
 net/sunrpc/sysfs.c                                 |  55 ++-
 net/sunrpc/xprt.c                                  |  10 +
 net/sunrpc/xprtrdma/transport.c                    |   8 +-
 net/sunrpc/xprtsock.c                              |  56 ++-
 net/tipc/socket.c                                  |   3 +-
 net/unix/af_unix.c                                 |  16 +-
 net/vmw_vsock/virtio_transport.c                   |  11 +-
 net/x25/af_x25.c                                   |  11 +-
 net/xdp/xsk.c                                      |  69 ++-
 net/xdp/xsk_buff_pool.c                            |   8 +-
 net/xfrm/xfrm_interface.c                          |   5 +-
 samples/bpf/xdpsock_user.c                         |   5 +-
 samples/landlock/sandboxer.c                       |   1 +
 scripts/atomic/fallbacks/read_acquire              |  11 +-
 scripts/atomic/fallbacks/set_release               |   7 +-
 scripts/dtc/Makefile                               |   2 +-
 scripts/gcc-plugins/stackleak_plugin.c             |  25 +-
 scripts/mod/modpost.c                              |   2 +-
 security/integrity/evm/evm_main.c                  |   2 +-
 security/keys/keyctl_pkey.c                        |  14 +-
 security/keys/trusted-keys/trusted_core.c          |   6 +-
 security/landlock/syscalls.c                       |   2 +-
 security/security.c                                |  24 +-
 security/selinux/hooks.c                           | 180 +++++---
 security/selinux/include/policycap.h               |   1 +
 security/selinux/include/policycap_names.h         |   3 +-
 security/selinux/include/security.h                |   7 +
 security/selinux/selinuxfs.c                       |   2 +
 security/selinux/xfrm.c                            |   2 +-
 security/smack/smack_lsm.c                         |   2 +-
 security/tomoyo/load_policy.c                      |   4 +-
 sound/core/pcm.c                                   |   1 +
 sound/core/pcm_lib.c                               |   9 +-
 sound/core/pcm_native.c                            |  39 +-
 sound/firewire/fcp.c                               |   4 +-
 sound/isa/cs423x/cs4236.c                          |   8 +-
 sound/pci/hda/hda_intel.c                          |  10 +-
 sound/pci/hda/patch_hdmi.c                         |   8 +-
 sound/pci/hda/patch_realtek.c                      |  15 +-
 sound/soc/amd/acp/acp-mach-common.c                |   2 +
 sound/soc/amd/vangogh/acp5x-mach.c                 |   1 +
 sound/soc/amd/vangogh/acp5x-pcm-dma.c              |  68 +--
 sound/soc/atmel/atmel_ssc_dai.c                    |   5 +-
 sound/soc/atmel/mikroe-proto.c                     |  20 +-
 sound/soc/atmel/sam9g20_wm8731.c                   |   1 +
 sound/soc/atmel/sam9x5_wm8731.c                    |  13 +-
 sound/soc/codecs/Kconfig                           |   5 +
 sound/soc/codecs/cs35l41.c                         |   6 +-
 sound/soc/codecs/cs42l42.c                         |  14 +-
 sound/soc/codecs/lpass-rx-macro.c                  |  14 +-
 sound/soc/codecs/lpass-tx-macro.c                  |   2 +
 sound/soc/codecs/lpass-va-macro.c                  |   4 +-
 sound/soc/codecs/lpass-wsa-macro.c                 |   2 +
 sound/soc/codecs/max98927.c                        |   1 +
 sound/soc/codecs/msm8916-wcd-analog.c              |  22 +-
 sound/soc/codecs/msm8916-wcd-digital.c             |   5 +-
 sound/soc/codecs/mt6358.c                          |   4 +
 sound/soc/codecs/rk817_codec.c                     |   6 +-
 sound/soc/codecs/rt5663.c                          |   2 +
 sound/soc/codecs/rt5682s.c                         |  26 +-
 sound/soc/codecs/rt5682s.h                         |   1 -
 sound/soc/codecs/wcd934x.c                         |  12 +-
 sound/soc/codecs/wcd938x.c                         |  10 +-
 sound/soc/codecs/wm8350.c                          |  28 +-
 sound/soc/dwc/dwc-i2s.c                            |  17 +-
 sound/soc/fsl/fsl_spdif.c                          |   2 +
 sound/soc/fsl/imx-es8328.c                         |   1 +
 sound/soc/generic/simple-card-utils.c              |  15 +
 sound/soc/intel/boards/sof_es8336.c                |  63 ++-
 sound/soc/intel/boards/sof_sdw.c                   |   2 +-
 sound/soc/intel/common/soc-acpi-intel-bxt-match.c  |   7 +-
 sound/soc/intel/common/soc-acpi-intel-cml-match.c  |   7 +-
 sound/soc/intel/common/soc-acpi-intel-glk-match.c  |   7 +-
 sound/soc/intel/common/soc-acpi-intel-jsl-match.c  |   7 +-
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c  |   7 +-
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |   7 +-
 .../mt8183/mt8183-mt6358-ts3a227-max98357.c        |   7 +-
 .../mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c  |  23 +-
 sound/soc/mxs/mxs-saif.c                           |   5 +-
 sound/soc/mxs/mxs-sgtl5000.c                       |   3 +
 sound/soc/rockchip/rockchip_i2s.c                  |  15 +-
 sound/soc/rockchip/rockchip_i2s_tdm.c              |  12 +-
 sound/soc/sh/fsi.c                                 |  19 +-
 sound/soc/sh/rz-ssi.c                              |  73 ++--
 sound/soc/soc-compress.c                           |   5 +
 sound/soc/soc-core.c                               |   2 +-
 sound/soc/soc-generic-dmaengine-pcm.c              |   6 +-
 sound/soc/soc-topology.c                           |   3 +-
 sound/soc/sof/imx/imx8m.c                          |   1 +
 sound/soc/sof/intel/Kconfig                        |   1 +
 sound/soc/sof/intel/hda-dai.c                      |  13 +
 sound/soc/sof/intel/hda-loader.c                   |  11 +-
 sound/soc/sof/intel/hda-pcm.c                      |   1 +
 sound/soc/sof/intel/hda.c                          |  15 +-
 sound/soc/ti/davinci-i2s.c                         |   5 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |  25 ++
 sound/spi/at73c213.c                               |  27 +-
 tools/bpf/bpftool/btf.c                            |   2 +-
 tools/bpf/bpftool/gen.c                            |   2 +-
 tools/bpf/bpftool/link.c                           |   3 +-
 tools/bpf/bpftool/map.c                            |  15 +-
 tools/bpf/bpftool/pids.c                           |   3 +-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/include/uapi/linux/bpf.h                     |   4 +-
 tools/lib/bpf/btf.h                                |  22 +-
 tools/lib/bpf/btf_dump.c                           |  11 +-
 tools/lib/bpf/libbpf.c                             |   3 +
 tools/lib/bpf/netlink.c                            |  63 ++-
 tools/lib/bpf/xsk.c                                |  11 +
 tools/perf/builtin-stat.c                          |   2 +-
 tools/perf/pmu-events/arch/x86/skylakex/cache.json | 111 ++---
 .../arch/x86/skylakex/floating-point.json          |  24 +-
 .../pmu-events/arch/x86/skylakex/frontend.json     |  18 +-
 .../perf/pmu-events/arch/x86/skylakex/memory.json  |  96 ++---
 .../pmu-events/arch/x86/skylakex/pipeline.json     |  11 +
 .../pmu-events/arch/x86/skylakex/skx-metrics.json  | 461 ++++++++++++++++++---
 .../pmu-events/arch/x86/skylakex/uncore-other.json |  23 +
 tools/testing/cxl/test/cxl.c                       |   2 +-
 tools/testing/selftests/bpf/prog_tests/bind_perm.c |  20 +-
 tools/testing/selftests/bpf/progs/bpf_misc.h       |  19 +
 .../testing/selftests/bpf/progs/test_probe_user.c  |  15 +-
 .../testing/selftests/bpf/progs/test_sock_fields.c |   2 +-
 tools/testing/selftests/bpf/test_lirc_mode2.sh     |   5 +-
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |  10 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       |  60 +--
 tools/testing/selftests/bpf/xdpxceiver.c           |   5 +-
 tools/testing/selftests/lkdtm/config               |   1 +
 .../testing/selftests/net/af_unix/test_unix_oob.c  |   6 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |  19 +
 .../testing/selftests/net/test_vxlan_under_vrf.sh  |   8 +-
 tools/testing/selftests/net/timestamping.c         |   4 +-
 tools/testing/selftests/net/tls.c                  |   6 +
 tools/testing/selftests/rcutorture/bin/torture.sh  |   4 +-
 tools/testing/selftests/sgx/Makefile               |   2 +-
 tools/testing/selftests/vm/Makefile                |  12 +-
 tools/testing/selftests/x86/Makefile               |   6 +-
 tools/testing/selftests/x86/check_cc.sh            |   2 +-
 tools/virtio/virtio_test.c                         |   1 +
 virt/kvm/kvm_main.c                                |  13 +
 1061 files changed, 11357 insertions(+), 5917 deletions(-)


