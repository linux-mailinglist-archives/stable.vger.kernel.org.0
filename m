Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27426500E84
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243906AbiDNNSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243805AbiDNNSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC1A7CDC5;
        Thu, 14 Apr 2022 06:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E8F8612ED;
        Thu, 14 Apr 2022 13:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD377C385A5;
        Thu, 14 Apr 2022 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942138;
        bh=ceMNTbkY/iK4EykDrI1Yzowu1c6og5yoWUZqZ3vTdJc=;
        h=From:To:Cc:Subject:Date:From;
        b=syP/JuJV+B/0OPEIG/5gvHYet1gIaDEkfByNJN4odp6wVHIGZ/O8e481PyDib+zsF
         GII+gwVKFvyD9skfqYOmH/bG0xMmZcrxV56MpkUeADr4/as/sYlNyCGBnLEfQnfUTX
         a8jdHHigZC1gziLldWtlMzLmHxg7CUvCMmAKE1gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 000/338] 4.19.238-rc1 review
Date:   Thu, 14 Apr 2022 15:08:23 +0200
Message-Id: <20220414110838.883074566@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.238-rc1
X-KernelTest-Deadline: 2022-04-16T11:08+00:00
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

This is the start of the stable review cycle for the 4.19.238 release.
There are 338 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.238-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.238-rc1

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: Use drm_priv to pass VM from KFD to amdgpu

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Check if fd really is an amdgpu fd.

Xin Long <lucien.xin@gmail.com>
    xfrm: policy: match with both mark and mask on user interfaces

Tejun Heo <tj@kernel.org>
    selftests: cgroup: Test open-time cgroup namespace usage for migration checks

Tejun Heo <tj@kernel.org>
    selftests: cgroup: Test open-time credential usage for migration checks

Tejun Heo <tj@kernel.org>
    selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644

Tejun Heo <tj@kernel.org>
    cgroup: Use open-time cgroup namespace for process migration perm checks

Tejun Heo <tj@kernel.org>
    cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv

Tejun Heo <tj@kernel.org>
    cgroup: Use open-time credentials for process migraton perm checks

Waiman Long <longman@redhat.com>
    mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

Fangrui Song <maskray@google.com>
    arm64: module: remove (NOLOAD) from linker script

Peter Xu <peterx@redhat.com>
    mm: don't skip swap entry even if zap_details specified

Vinod Koul <vkoul@kernel.org>
    dmaengine: Revert "dmaengine: shdma: Fix runtime PM imbalance on error"

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Use $(shell ) instead of `` to get embedded libperl's ccopts

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Filter out options and warnings not supported by clang

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3: Fix GICR_CTLR.RWP polling

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    perf: qcom_l2_pmu: fix an incorrect NULL check on list iterator

Christian Lamparter <chunkeey@gmail.com>
    ata: sata_dwc_460ex: Fix crash due to OOB write

Guo Ren <guoren@linux.alibaba.com>
    arm64: patch_text: Fixup last cpu should be master

Ethan Lien <ethanlien@synology.com>
    btrfs: fix qgroup reserve overflow the qgroup limit

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Restore speculation related MSRs during S3 resume

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/pm: Save the MSR validity status at context setup

Miaohe Lin <linmiaohe@huawei.com>
    mm/mempolicy: fix mpol_new leak in shared_policy_replace

Paolo Bonzini <pbonzini@redhat.com>
    mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: don't overwrite TAP settings when HS400 tuning is complete

Pali Rohár <pali@kernel.org>
    Revert "mmc: sdhci-xenon: fix annoying 1.8V regulator warning"

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    drbd: Fix five use after free bugs in get_initial_state

Kamal Dasu <kdasu.kdev@gmail.com>
    spi: bcm-qspi: fix MSPI only access with bcm_qspi_exec_mem_op()

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    qede: confirm skb is allocated before using

Eric Dumazet <edumazet@google.com>
    rxrpc: fix a race in rxrpc_exit_net()

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: don't send internal clone attribute to the userspace.

José Expósito <jose.exposito89@gmail.com>
    drm/imx: Fix memory leak in imx_pd_connector_get_modes

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: Fix unset max_speed difference between DT and non-DT platforms

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()

Guilherme G. Piccoli <gpiccoli@igalia.com>
    Drivers: hv: vmbus: Fix potential crash on module unload

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amdgpu: fix off by one in amdgpu_gfx_kiq_acquire()

James Morse <james.morse@arm.com>
    KVM: arm64: Check arm64_get_bp_hardening_data() didn't return NULL

Mauricio Faria de Oliveira <mfo@canonical.com>
    mm: fix race between MADV_FREE reclaim and blkdev direct IO read

Willem de Bruijn <willemb@google.com>
    net: add missing SOF_TIMESTAMPING_OPT_ID support

Helge Deller <deller@gmx.de>
    parisc: Fix CPU affinity for Lasi, WAX and Dino chips

Haimin Zhang <tcs_kernel@tencent.com>
    jfs: prevent NULL deref in diFree

Randy Dunlap <rdunlap@infradead.org>
    virtio_console: eliminate anonymous module_init & module_exit

Jiri Slaby <jslaby@suse.cz>
    serial: samsung_tty: do not unlock port->lock for uart_write_wakeup()

NeilBrown <neilb@suse.de>
    NFS: swap-out must always use STABLE writes.

NeilBrown <neilb@suse.de>
    NFS: swap IO handling is slightly different for O_DIRECT IO

NeilBrown <neilb@suse.de>
    SUNRPC/call_alloc: async tasks mustn't block waiting for memory

Maxime Ripard <maxime@cerno.tech>
    clk: Enforce that disjoints limits are invalid

Dongli Zhang <dongli.zhang@oracle.com>
    xen: delay xen_hvm_init_time_ops() if kdump is boot on vcpu>=32

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Protect the state recovery thread against direct reclaim

Lucas Denefle <lucas.denefle@converge.io>
    w1: w1_therm: fixes w1_seq for ds28ea00 sensors

Qinghua Jin <qhjin.dev@gmail.com>
    minix: fix bug when opening a file with O_DIRECT

Randy Dunlap <rdunlap@infradead.org>
    init/main.c: return 1 from handled __setup() functions

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix use after free in hci_send_acl

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix DTC warning unit_address_format

H. Nikolaus Schaller <hns@goldelico.com>
    usb: dwc3: omap: fix "unbalanced disables for smps10_out1" on omap5evm

Jianglei Nie <niejianglei2021@163.com>
    scsi: libfc: Fix use after free in fc_exch_abts_resp()

Alexander Lobakin <alobakin@pm.me>
    MIPS: fix fortify panic when copying asm exception handlers

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Eliminate unintended link toggle during FW reset

Sven Eckelmann <sven@narfation.org>
    macvtap: advertise link netns via netlink

Dust Li <dust.li@linux.alibaba.com>
    net/smc: correct settings of RMB window update limit

Randy Dunlap <rdunlap@infradead.org>
    scsi: aha152x: Fix aha152x_setup() __setup handler return value

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix pm8001_mpi_task_abort_resp()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: make CRAT table missing message informational only

Jordy Zomer <jordy@jordyzomer.github.io>
    dm ioctl: prevent potential spectre v1 gadget

Ido Schimmel <idosch@nvidia.com>
    ipv4: Invalidate neighbour for broadcast address upon address addition

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: pciehp: Add Qualcomm quirk for Command Completed erratum

Neal Liu <neal_liu@aspeedtech.com>
    usb: ehci: add pci device support for Aspeed platforms

Zhou Guanghui <zhouguanghui1@huawei.com>
    iommu/arm-smmu-v3: fix event handling soft lockup

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for MSI interrupts

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc: Set crashkernel offset to mid of RMA region

Evgeny Boger <boger@wirenboard.com>
    power: supply: axp20x_battery: properly report current when discharging

Yang Guang <yang.guang5@zte.com.cn>
    scsi: bfa: Replace snprintf() with sysfs_emit()

Yang Guang <yang.guang5@zte.com.cn>
    scsi: mvsas: Replace snprintf() with sysfs_emit()

Maxim Kiselev <bigunclemax@gmail.com>
    powerpc: dts: t104xrdb: fix phy type for FMAN 4/5

Yang Guang <yang.guang5@zte.com.cn>
    ptp: replace snprintf with sysfs_emit

Xin Xiong <xiongx18@fudan.edu.cn>
    drm/amd/amdgpu/amdgpu_cs: fix refcount leak of a dma_fence obj

Zekun Shen <bruceshenzk@gmail.com>
    ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

Anisse Astier <anisse@astier.eu>
    drm: Add orientation quirk for GPD Win Max

Jim Mattson <jmattson@google.com>
    KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs

Randy Dunlap <rdunlap@infradead.org>
    ARM: 9187/1: JIVE: fix return value of __setup handler

Fangrui Song <maskray@google.com>
    riscv module: remove (NOLOAD)

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    rtc: wm8350: Handle error for wm8350_register_irq

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Rectify space amount budget for mkdir/tmpfile operations

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasn't activated

Martin Varghese <martin.varghese@nokia.com>
    openvswitch: Fixed nd target mask field in the flow dump.

Anton Ivanov <anton.ivanov@cambridgegreys.com>
    um: Fix uml_mconsole stop/go

Kuldeep Singh <singh.kuldeep87k@gmail.com>
    ARM: dts: spear13xx: Update SPI dma properties

Kuldeep Singh <singh.kuldeep87k@gmail.com>
    ARM: dts: spear1340: Update serial node properties

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Allow TLV control to be either read or write

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Return error code if memory allocation fails in add_aeb()

Hengqi Chen <hengqi.chen@gmail.com>
    bpf: Fix comment for helper bpf_current_task_under_cgroup()

Randy Dunlap <rdunlap@infradead.org>
    mm/usercopy: return 1 from hardened_usercopy __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    mm/memcontrol: return 1 from cgroup.memory __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    mm/mmap: return 1 from stack_guard_gap __setup() handler

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: CPPC: Avoid out of bounds access when parsing _CPC data

Baokun Li <libaokun1@huawei.com>
    ubi: Fix race condition between ctrl_cdev_ioctl and ubi_cdev_ioctl

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: pinconf-generic: Print arguments for bias-pull-*

Andrew Price <anprice@redhat.com>
    gfs2: Make sure FITRIM minlen is rounded up to fs block size

Pavel Skripkin <paskripkin@gmail.com>
    can: mcba_usb: properly check endpoint type

Hangyu Hua <hbh25y@gmail.com>
    can: mcba_usb: mcba_usb_start_xmit(): fix double dev_kfree_skb in error path

Baokun Li <libaokun1@huawei.com>
    ubifs: rename_whiteout: correct old_dir size computing

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix read out-of-bounds in ubifs_wbuf_write_nolock()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: setflags: Make dirtied_ino_d 8 bytes aligned

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Add missing iput if do_tmpfile() failed in rename whiteout

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix deadlock in concurrent rename whiteout and inode writeback

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: rename_whiteout: Fix double free for whiteout_ui->data

Li RongQing <lirongqing@baidu.com>
    KVM: x86: fix sending PV IPI

David Matlack <dmatlack@google.com>
    KVM: Prevent module exit until all VMs are freed

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: Use correct feature type field during RFF_ID processing

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Reduce false trigger to login

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix hang due to session stuck

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix incorrect reporting of task management failure

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Suppress a kernel complaint in qla_create_qpair()

Joe Carnuccio <joe.carnuccio@cavium.com>
    scsi: qla2xxx: Check for firmware dump already collected

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix warning for missing error code

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix stuck session in gpdb

Anders Roxell <anders.roxell@linaro.org>
    powerpc: Fix build errors with newer binutils

Anders Roxell <anders.roxell@linaro.org>
    powerpc/lib/sstep: Fix build errors with newer binutils

Anders Roxell <anders.roxell@linaro.org>
    powerpc/lib/sstep: Fix 'sthcx' instruction

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: host: Return an error when ->enable_sdio_irq() ops is missing

Dongliang Mu <mudongliangabcd@gmail.com>
    media: hdpvr: initialize dev->worker at hdpvr_register_videodev

Pavel Skripkin <paskripkin@gmail.com>
    media: Revert "media: em28xx: add missing em28xx_close_extension"

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: sm712fb: Fix crash in smtcfb_write()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    ARM: mmp: Fix failure to remove sram device

Richard Leitner <richard.leitner@skidata.com>
    ARM: tegra: tamonten: Fix I2C3 pad setting

Daniel González Cabanelas <dgcbueu@gmail.com>
    media: cx88-mpeg: clear interrupt status register before streaming video

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: soc-core: skip zero num_dai component in searching dai name

Jing Yao <yao.jing2@zte.com.cn>
    video: fbdev: udlfb: replace snprintf in show functions with sysfs_emit

Jing Yao <yao.jing2@zte.com.cn>
    video: fbdev: omapfb: panel-tpo-td043mtea1: Use sysfs_emit() instead of snprintf()

Jing Yao <yao.jing2@zte.com.cn>
    video: fbdev: omapfb: panel-dsi-cm: Use sysfs_emit() instead of snprintf()

Ard Biesheuvel <ardb@kernel.org>
    ARM: ftrace: avoid redundant loads or clobbering IP

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

Dongliang Mu <mudongliangabcd@gmail.com>
    ntfs: add sanity check on allocation size

Theodore Ts'o <tytso@mit.edu>
    ext4: don't BUG if someone dirty pages without asking ext4 first

Minghao Chi <chi.minghao@zte.com.cn>
    spi: tegra20: Use of_device_get_match_data()

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

Souptick Joarder (HPE) <jrdr.linux@gmail.com>
    irqchip/nvic: Release nvic_base upon failure

Marc Zyngier <maz@kernel.org>
    irqchip/qcom-pdc: Fix broken locking

Casey Schaufler <casey@schaufler-ca.com>
    Fix incorrect type in assignment of ipv6 port for audit

Chaitanya Kulkarni <kch@nvidia.com>
    loop: use sysfs_emit() in the sysfs xxx show()

Christian Göttsche <cgzones@googlemail.com>
    selinux: use correct type for context length

Dan Carpenter <dan.carpenter@oracle.com>
    lib/test: use after free in register_test_dev_kmod()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Fix another issue with a list iterator pointing to the head

Duoming Zhou <duoming@zju.edu.cn>
    net/x25: Fix null-ptr-deref caused by x25_disconnect

Tom Rix <trix@redhat.com>
    qlcnic: dcb: default to returning -EOPNOTSUPP

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Fix brcm_fet_config_init()

Juergen Gross <jgross@suse.com>
    xen: fix is_xen_pmu()

Konrad Dybcio <konrad.dybcio@somainline.org>
    clk: qcom: gcc-msm8994: Fix gpll4 width

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options

Pavel Skripkin <paskripkin@gmail.com>
    jfs: fix divide error in dbNextAG

Randy Dunlap <rdunlap@infradead.org>
    kgdbts: fix return value of __setup handler

Randy Dunlap <rdunlap@infradead.org>
    kgdboc: fix return value of __setup handler

Randy Dunlap <rdunlap@infradead.org>
    tty: hvc: fix return value of __setup handler

Miaoqian Lin <linmq006@gmail.com>
    pinctrl/rockchip: Add missing of_node_put() in rockchip_pinctrl_probe

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: nomadik: Add missing of_node_put() in nmk_pinctrl_probe

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: mediatek: Fix missing of_node_put() in mtk_pctrl_init

Alexey Khoroshilov <khoroshilov@ispras.ru>
    NFS: remove unneeded check in decode_devicenotify_args()

Miaoqian Lin <linmq006@gmail.com>
    clk: tegra: tegra124-emc: Fix missing put_device() call in emc_ensure_emc_driver

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    clk: clps711x: Terminate clk_div_table with sentinel element

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    clk: loongson1: Terminate clk_div_table with sentinel element

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    clk: actions: Terminate clk_div_table with sentinel element

Miaoqian Lin <linmq006@gmail.com>
    remoteproc: qcom_wcnss: Add missing of_node_put() in wcnss_alloc_memory_region

Taniya Das <tdas@codeaurora.org>
    clk: qcom: clk-rcg2: Update the frac table for pixel clock

Randy Dunlap <rdunlap@infradead.org>
    dma-debug: fix return value of __setup handlers

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    iio: adc: Add check for devm_request_threaded_irq

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: 8250: Fix race condition in RTS-after-send handling

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_mid: Balance reference count for PCI DMA device

Dirk Buchwalder <buchwalder@posteo.de>
    clk: qcom: ipq8074: Use floor ops for SDCC1 clock

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    staging:iio:adc:ad7280a: Fix handing of device address bit reversing.

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc18xx-sct: Initialize driver data and hardware before pwmchip_add()

Jiri Slaby <jslaby@suse.cz>
    mxser: fix xmit_buf leak in activate when LSR == 0xff

Miaoqian Lin <linmq006@gmail.com>
    mfd: asic3: Add missing iounmap() on error asic3_mfd_probe

Jakub Kicinski <kuba@kernel.org>
    tcp: ensure PMTU updates are processed during fastopen

Jeremy Linton <jeremy.linton@arm.com>
    net: bcmgenet: Use stronger register read/writes to assure ordering

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf/test_lirc_mode2.sh: Exit with proper code

Peter Rosin <peda@axentia.se>
    i2c: mux: demux-pinctrl: do not deactivate a master that is not active

Petr Machata <petrm@nvidia.com>
    af_netlink: Fix shift out of bounds in group mask calculation

Dan Carpenter <dan.carpenter@oracle.com>
    USB: storage: ums-realtek: fix error code in rts51x_read_mem()

Xin Xiong <xiongx18@fudan.edu.cn>
    mtd: rawnand: atmel: fix refcount issue in atmel_nand_controller_init

Randy Dunlap <rdunlap@infradead.org>
    MIPS: RB532: fix return value of __setup handler

Oliver Hartkopp <socketcan@hartkopp.net>
    vxcan: enable local echo for sent CAN frames

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mfd: mc13xxx: Add check for mc13xxx_irq_request

Jakob Koschel <jakobkoschel@gmail.com>
    powerpc/sysdev: fix incorrect use to determine if list is empty

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    PCI: Reduce warnings on possible RW1C corruption

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    power: supply: wm8350-power: Add missing free in free_charger_irq

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    power: supply: wm8350-power: Handle error for wm8350_register_irq

Robert Hancock <robert.hancock@calian.com>
    i2c: xiic: Make bus names unique

Anssi Hannula <anssi.hannula@bitwise.fi>
    hv_balloon: rate-limit "Unhandled message" warning

Hou Wenlong <houwenlong.hwl@antgroup.com>
    KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()

Zhenzhong Duan <zhenzhong.duan@intel.com>
    KVM: x86: Fix emulation in writing cr8

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/Makefile: Don't pass -mcpu=powerpc64 when building 32-bit

Nishanth Menon <nm@ti.com>
    drm/bridge: cdns-dsi: Make sure to to create proper aliases for dt

Hans de Goede <hdegoede@redhat.com>
    power: supply: bq24190_charger: Fix bq24190_vbus_is_enabled() wrong false return

Miaoqian Lin <linmq006@gmail.com>
    drm/tegra: Fix reference leak in tegra_dsi_ganged_probe

Zhang Yi <yi.zhang@huawei.com>
    ext2: correct max file size computing

Randy Dunlap <rdunlap@infradead.org>
    TOMOYO: fix __setup handlers return values

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix abort all task initialization

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix command initialization in pm80XX_send_read_log()

Aashish Sharma <shraash@google.com>
    dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS

Colin Ian King <colin.king@canonical.com>
    iwlwifi: Fix -EIO error code that is never returned

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: i2c-hid: fix GET/SET_REPORT for unnumbered reports

Miaoqian Lin <linmq006@gmail.com>
    power: supply: ab8500: Fix memory leak in ab8500_fg_sysfs_init

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ray_cs: Check ioremap return value

Miaoqian Lin <linmq006@gmail.com>
    power: reset: gemini-poweroff: Fix IRQ check in gemini_poweroff_probe

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Fix vmx/vsx mixup in mmio emulation

Pavel Skripkin <paskripkin@gmail.com>
    ath9k_htc: fix uninit value bugs

Zhou Qingyang <zhou1615@umn.edu>
    drm/amd/display: Fix a NULL pointer dereference in amdgpu_dm_connector_add_common_modes()

Maxime Ripard <maxime@cerno.tech>
    drm/edid: Don't clear formats if using deep color

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mtd: onenand: Check for error irq

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: hci_serdev: call init_rwsem() before p->open()

Wen Gong <quic_wgong@quicinc.com>
    ath10k: fix memory overwrite of the WoWLAN wakeup packet pattern

Miaoqian Lin <linmq006@gmail.com>
    drm/bridge: Fix free wrong object in sii8620_init_rcp_input_dev

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mmc: davinci_mmc: Handle error for clk_enable

Miaoqian Lin <linmq006@gmail.com>
    ASoC: msm8916-wcd-digital: Fix missing clk_disable_unprepare() in msm8916_wcd_digital_probe

Wang Wensheng <wangwensheng4@huawei.com>
    ASoC: imx-es8328: Fix error return code in imx_es8328_probe()

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mxs: Fix error handling in mxs_sgtl5000_probe

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    ASoC: dmaengine: do not use a NULL prepare_slave_config() callback

Miaoqian Lin <linmq006@gmail.com>
    video: fbdev: omapfb: Add missing of_node_put() in dvic_probe_of

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: fsi: Add check for clk_enable

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: wm8350: Handle error for wm8350_register_irq

Miaoqian Lin <linmq006@gmail.com>
    ASoC: atmel: Add missing of_node_put() in at91sam9g20ek_audio_probe

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: stk1160: If start stream fails, return buffers with VB2_BUF_STATE_QUEUED

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix uninitialized flag for AV/C deferred transaction

Jia-Ju Bai <baijiaju1990@gmail.com>
    memory: emif: check the pointer temp in get_device_details()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    memory: emif: Add check for setup_interrupts

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

Jia-Ju Bai <baijiaju1990@gmail.com>
    ASoC: rt5663: check the return value of devm_kzalloc() in rt5663_parse_dp()

Dan Carpenter <dan.carpenter@oracle.com>
    media: usb: go7007: s2250-board: fix leak in probe()

Dongliang Mu <mudongliangabcd@gmail.com>
    media: em28xx: initialize refcount before kref_get

Miaoqian Lin <linmq006@gmail.com>
    soc: ti: wkup_m3_ipc: Fix IRQ check in wkup_m3_ipc_probe

Pavel Kubelun <be.dissent@gmail.com>
    ARM: dts: qcom: ipq4019: fix sleep clock

Dan Carpenter <dan.carpenter@oracle.com>
    video: fbdev: fbcvt.c: fix printing in fb_cvt_print_name()

Wang Hai <wanghai38@huawei.com>
    video: fbdev: smscufx: Fix null-ptr-deref in ufx_usb_probe()

Miaoqian Lin <linmq006@gmail.com>
    media: coda: Fix missing put_device() call in coda_get_vdoa_data

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix address filter config for 32-bit kernel

Adrian Hunter <adrian.hunter@intel.com>
    perf/core: Fix address filter parser for multiple filters

Bharata B Rao <bharata@amd.com>
    sched/debug: Remove mpol_get/put and task_lock/unlock from sched_show_numa

Randy Dunlap <rdunlap@infradead.org>
    clocksource: acpi_pm: fix return value of __setup handler

Brandon Wyman <bjwyman@gmail.com>
    hwmon: (pmbus) Add Vin unit off handling

Dāvis Mosāns <davispuh@gmail.com>
    crypto: ccp - ccp_dmaengine_unregister release dma channels

Randy Dunlap <rdunlap@infradead.org>
    ACPI: APEI: fix return value of __setup handlers

Guillaume Ranquet <granquet@baylibre.com>
    clocksource/drivers/timer-of: Check return value of of_iomap in timer_of_base_init()

Petr Vorel <pvorel@suse.cz>
    crypto: vmx - add missing dependencies

Claudiu Beznea <claudiu.beznea@microchip.com>
    hwrng: atmel - disable trng on failure path

Randy Dunlap <rdunlap@infradead.org>
    PM: suspend: fix return value of __setup handler

Randy Dunlap <rdunlap@infradead.org>
    PM: hibernate: fix __setup handler error handling

Eric Biggers <ebiggers@google.com>
    block: don't delete queue kobject before its children

Armin Wolf <W_Armin@gmx.de>
    hwmon: (sch56xx-common) Replace WDOG_ACTIVE with WDOG_HW_RUNNING

Patrick Rudolph <patrick.rudolph@9elements.com>
    hwmon: (pmbus) Add mutex to regulator ops

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: pxa2xx-pci: Balance reference count for PCI DMA device

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/x86: Add validity check and allow field splitting

Miaoqian Lin <linmq006@gmail.com>
    spi: tegra114: Add missing IRQ check in tegra_spi_probe

Tomas Paukrt <tomaspaukrt@email.cz>
    crypto: mxs-dcp - Fix scatterlist processing

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: authenc - Fix sleep in atomic context in decrypt_tail

kernel test robot <lkp@intel.com>
    regulator: qcom_smd: fix for_each_child.cocci warnings

Liguang Zhang <zhangliguang@linux.alibaba.com>
    PCI: pciehp: Clear cmd_busy bit in polling mode

Hector Martin <marcan@marcan.st>
    brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio

Hector Martin <marcan@marcan.st>
    brcmfmac: firmware: Allocate space for default boardrev in nvram

Johan Hovold <johan@kernel.org>
    media: davinci: vpif: fix unbalanced runtime PM get

Maciej W. Rozycki <macro@orcam.me.uk>
    DEC: Limit PMAX memory probing to R3k systems

Dirk Müller <dmueller@suse.de>
    lib/raid6/test: fix multiple definition linking error

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: int340x: Increase bitmap size

Colin Ian King <colin.i.king@gmail.com>
    carl9170: fix missing bit-wise or operator for tx_params

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: add missing HDMI supplies on SMDK5420

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: add missing HDMI supplies on SMDK5250

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: dts: exynos: fix UART3 pins configuration in Exynos5250

Tudor Ambarus <tudor.ambarus@microchip.com>
    ARM: dts: at91: sama5d2: Fix PMERRLOC resource size

Michael Schmitz <schmitzmic@gmail.com>
    video: fbdev: atari: Atari 2 bpp (STe) palette bugfix

Helge Deller <deller@gmx.de>
    video: fbdev: sm712fb: Fix crash in smtcfb_read()

Cooper Chiou <cooper.chiou@intel.com>
    drm/edid: check basic audio support on CEA extension block

Tejun Heo <tj@kernel.org>
    block: don't merge across cgroup boundaries if blkcg is enabled

Duoming Zhou <duoming@zju.edu.cn>
    drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: properties: Consistently return -ENOENT if there are no more references

Andreas Gruenbacher <agruenba@redhat.com>
    powerpc/kvm: Fix kvm_use_magic_page

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: fix potential silent data corruption

Rik van Riel <riel@surriel.com>
    mm,hwpoison: unmap poisoned page before invalidation

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Fix audio regression on Mi Notebook Pro 2020

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    ALSA: cs4236: fix an incorrect NULL check on list iterator

José Expósito <jose.exposito89@gmail.com>
    Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"

Manish Chopra <manishc@marvell.com>
    qed: validate and restrict untrusted VFs vlan promisc mode

Manish Chopra <manishc@marvell.com>
    qed: display VF trust config

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands

Hugh Dickins <hughd@google.com>
    mempolicy: mbind_range() set_policy() after vma_merge()

Rik van Riel <riel@surriel.com>
    mm: invalidate hwpoison page cache page in fault path

Alistair Popple <apopple@nvidia.com>
    mm/pages_alloc.c: don't create ZONE_MOVABLE beyond the end of a node

Baokun Li <libaokun1@huawei.com>
    jffs2: fix memory leak in jffs2_scan_medium

Baokun Li <libaokun1@huawei.com>
    jffs2: fix memory leak in jffs2_do_mount_fs

Baokun Li <libaokun1@huawei.com>
    jffs2: fix use-after-free in jffs2_clear_xattr_subsystem

Hangyu Hua <hbh25y@gmail.com>
    can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    pinctrl: samsung: drop pin banks references on error paths

Chao Yu <chao@kernel.org>
    f2fs: fix to unlock page correctly in error path of is_alive()

Dan Carpenter <dan.carpenter@oracle.com>
    NFSD: prevent integer overflow on 32 bit systems

Dan Carpenter <dan.carpenter@oracle.com>
    NFSD: prevent underflow in nfssvc_decode_writeargs()

NeilBrown <neilb@suse.de>
    SUNRPC: avoid race between mod_timer() and del_timer_sync()

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: update stable tree link

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: add link to stable release candidate tree

Jann Horn <jannh@google.com>
    ptrace: Check PTRACE_O_SUSPEND_SECCOMP permission on PTRACE_SEIZE

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    clk: uniphier: Fix fixed-rate initialization

Liam Beguin <liambeguin@gmail.com>
    iio: inkern: make a best effort on offset calculation

Liam Beguin <liambeguin@gmail.com>
    iio: inkern: apply consumer scale when no channel scale is available

Liam Beguin <liambeguin@gmail.com>
    iio: inkern: apply consumer scale on IIO_VAL_INT cases

Liam Beguin <liambeguin@gmail.com>
    iio: afe: rescale: use s64 for temporary scale calculations

James Clark <james.clark@arm.com>
    coresight: Fix TRCCONFIGR.QE sysfs interface

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make xhci_handshake timeout for xhci_reset() adjustable

Alan Stern <stern@rowland.harvard.edu>
    USB: usb-storage: Fix use of bitfields for hardware data in ene_ub6250.c

Xie Yongji <xieyongji@bytedance.com>
    virtio-blk: Use blk_validate_block_size() to validate block size

Xie Yongji <xieyongji@bytedance.com>
    block: Add a helper to validate the block size

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    tpm: fix reference counting for struct tpm_chip

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix pipe buffer lifetime for direct_io

Haimin Zhang <tcs_kernel@tencent.com>
    af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register

Biju Das <biju.das.jz@bp.renesas.com>
    spi: Fix erroneous sgs value with min_t()

Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
    net:mcf8390: Use platform_get_irq() to get the interrupt

Biju Das <biju.das.jz@bp.renesas.com>
    spi: Fix invalid sgs value

Zheyu Ma <zheyuma97@gmail.com>
    ethernet: sun: Free the coherent when failing in probing

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: break out of buf poll on remove

Lina Wang <lina.wang@mediatek.com>
    xfrm: fix tunnel model fragmentation behavior

Yajun Deng <yajun.deng@linux.dev>
    netdevice: add the case if dev is NULL

Randy Dunlap <rdunlap@infradead.org>
    hv: utils: add PTP_1588_CLOCK to Kconfig to fix build

Johan Hovold <johan@kernel.org>
    USB: serial: simple: add Nokia phone driver

Eddie James <eajames@linux.ibm.com>
    USB: serial: pl2303: add IBM device IDs


-------------

Diffstat:

 Documentation/process/stable-kernel-rules.rst      |  11 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2837.dtsi                     |  49 ++++++
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi          |   2 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   3 +
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |   3 +
 arch/arm/boot/dts/qcom-ipq4019.dtsi                |   3 +-
 arch/arm/boot/dts/qcom-msm8960.dtsi                |   8 +-
 arch/arm/boot/dts/sama5d2.dtsi                     |   2 +-
 arch/arm/boot/dts/spear1340.dtsi                   |   6 +-
 arch/arm/boot/dts/spear13xx.dtsi                   |   6 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |   6 +-
 arch/arm/kernel/entry-ftrace.S                     |  51 +++----
 arch/arm/mach-mmp/sram.c                           |  22 +--
 arch/arm/mach-s3c24xx/mach-jive.c                  |   6 +-
 .../arm64/boot/dts/broadcom/northstar2/ns2-svk.dts |   8 +-
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi   |   2 +-
 arch/arm64/include/asm/kvm_mmu.h                   |   3 +-
 arch/arm64/kernel/insn.c                           |   4 +-
 arch/arm64/kernel/module.lds                       |   6 +-
 arch/mips/dec/prom/Makefile                        |   2 +-
 arch/mips/include/asm/dec/prom.h                   |  15 +-
 arch/mips/include/asm/setup.h                      |   2 +-
 arch/mips/kernel/traps.c                           |  22 +--
 arch/mips/rb532/devices.c                          |   6 +-
 arch/powerpc/Makefile                              |   2 +-
 arch/powerpc/boot/dts/fsl/t104xrdb.dtsi            |   4 +-
 arch/powerpc/include/asm/io.h                      |  40 ++++-
 arch/powerpc/include/asm/uaccess.h                 |   3 +
 arch/powerpc/kernel/kvm.c                          |   2 +-
 arch/powerpc/kernel/machine_kexec.c                |  15 +-
 arch/powerpc/kernel/rtas.c                         |   6 +
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/powerpc/lib/sstep.c                           |   8 +-
 arch/powerpc/platforms/powernv/rng.c               |   6 +-
 arch/powerpc/sysdev/fsl_gtm.c                      |   4 +-
 arch/riscv/kernel/module.lds                       |   6 +-
 arch/um/drivers/mconsole_kern.c                    |   3 +-
 arch/x86/events/intel/pt.c                         |   2 +-
 arch/x86/kernel/kvm.c                              |   2 +-
 arch/x86/kvm/emulate.c                             |  14 +-
 arch/x86/kvm/hyperv.c                              |  17 ++-
 arch/x86/kvm/lapic.c                               |   5 +-
 arch/x86/kvm/pmu_amd.c                             |   8 +-
 arch/x86/power/cpu.c                               |  21 ++-
 arch/x86/xen/pmu.c                                 |  10 +-
 arch/x86/xen/pmu.h                                 |   3 +-
 arch/x86/xen/smp_hvm.c                             |   6 +
 arch/x86/xen/smp_pv.c                              |   2 +-
 arch/x86/xen/time.c                                |  24 ++-
 arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi        |   8 +-
 arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi         |   8 +-
 arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi          |   4 +-
 block/bfq-iosched.c                                |  31 ++--
 block/blk-merge.c                                  |  12 ++
 block/blk-sysfs.c                                  |   8 +-
 crypto/authenc.c                                   |   2 +-
 drivers/acpi/acpica/nswalk.c                       |   3 +
 drivers/acpi/apei/bert.c                           |  10 +-
 drivers/acpi/apei/erst.c                           |   2 +-
 drivers/acpi/apei/hest.c                           |   2 +-
 drivers/acpi/cppc_acpi.c                           |   5 +
 drivers/acpi/property.c                            |   2 +-
 drivers/ata/sata_dwc_460ex.c                       |   6 +-
 drivers/base/power/main.c                          |   6 +-
 drivers/block/drbd/drbd_int.h                      |   8 +-
 drivers/block/drbd/drbd_nl.c                       |  41 +++--
 drivers/block/drbd/drbd_req.c                      |   3 +-
 drivers/block/drbd/drbd_state.c                    |  18 +--
 drivers/block/drbd/drbd_state_change.h             |   8 +-
 drivers/block/loop.c                               |  10 +-
 drivers/block/virtio_blk.c                         |  12 +-
 drivers/bluetooth/hci_serdev.c                     |   3 +-
 drivers/char/hw_random/atmel-rng.c                 |   1 +
 drivers/char/tpm/tpm-chip.c                        |  46 +-----
 drivers/char/tpm/tpm.h                             |   2 +
 drivers/char/tpm/tpm2-space.c                      |  65 ++++++++
 drivers/char/virtio_console.c                      |  15 +-
 drivers/clk/actions/owl-s700.c                     |   1 +
 drivers/clk/actions/owl-s900.c                     |   2 +-
 drivers/clk/clk-clps711x.c                         |   2 +
 drivers/clk/clk.c                                  |  24 +++
 drivers/clk/loongson1/clk-loongson1c.c             |   1 +
 drivers/clk/qcom/clk-rcg2.c                        |   1 +
 drivers/clk/qcom/gcc-ipq8074.c                     |   2 +-
 drivers/clk/qcom/gcc-msm8994.c                     |   1 +
 drivers/clk/tegra/clk-emc.c                        |   1 +
 drivers/clk/uniphier/clk-uniphier-fixed-rate.c     |   1 +
 drivers/clocksource/acpi_pm.c                      |   6 +-
 drivers/clocksource/timer-of.c                     |   6 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |  16 ++
 drivers/crypto/mxs-dcp.c                           |   2 +-
 drivers/crypto/vmx/Kconfig                         |   4 +
 drivers/dma/sh/shdma-base.c                        |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  16 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c          |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +
 drivers/gpu/drm/bridge/cdns-dsi.c                  |   1 +
 drivers/gpu/drm/bridge/sil-sii8620.c               |   2 +-
 drivers/gpu/drm/drm_edid.c                         |  11 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/imx/parallel-display.c             |   4 +-
 drivers/gpu/drm/tegra/dsi.c                        |   4 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  32 +++-
 drivers/hv/Kconfig                                 |   1 +
 drivers/hv/hv_balloon.c                            |   2 +-
 drivers/hv/vmbus_drv.c                             |   9 +-
 drivers/hwmon/pmbus/pmbus.h                        |   1 +
 drivers/hwmon/pmbus/pmbus_core.c                   |  18 ++-
 drivers/hwmon/sch56xx-common.c                     |   2 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   8 +-
 drivers/i2c/busses/i2c-xiic.c                      |   3 +-
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   5 +-
 drivers/iio/adc/twl6030-gpadc.c                    |   2 +
 drivers/iio/afe/iio-rescale.c                      |   8 +-
 drivers/iio/inkern.c                               |  40 +++--
 drivers/input/input.c                              |   6 -
 drivers/iommu/arm-smmu-v3.c                        |   1 +
 drivers/irqchip/irq-gic-v3.c                       |   8 +-
 drivers/irqchip/irq-nvic.c                         |   2 +
 drivers/irqchip/qcom-pdc.c                         |   5 +-
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/dm-ioctl.c                              |   2 +
 drivers/media/pci/cx88/cx88-mpeg.c                 |   3 +
 drivers/media/platform/coda/coda-common.c          |   1 +
 drivers/media/platform/davinci/vpif.c              |   1 +
 drivers/media/usb/em28xx/em28xx-cards.c            |  13 +-
 drivers/media/usb/go7007/s2250-board.c             |  10 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   4 +-
 drivers/media/usb/stk1160/stk1160-core.c           |   2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |  10 +-
 drivers/media/usb/stk1160/stk1160.h                |   2 +-
 drivers/memory/emif.c                              |   8 +-
 drivers/mfd/asic3.c                                |  10 +-
 drivers/mfd/mc13xxx-core.c                         |   4 +-
 drivers/misc/kgdbts.c                              |   4 +-
 drivers/mmc/core/host.c                            |  15 +-
 drivers/mmc/host/davinci_mmc.c                     |   6 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   4 +-
 drivers/mmc/host/sdhci-xenon.c                     |  10 --
 drivers/mtd/nand/onenand/generic.c                 |   7 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  14 +-
 drivers/mtd/ubi/build.c                            |   9 +-
 drivers/mtd/ubi/fastmap.c                          |  28 ++--
 drivers/mtd/ubi/vmt.c                              |   8 +-
 drivers/net/can/usb/ems_usb.c                      |   1 -
 drivers/net/can/usb/mcba_usb.c                     |  27 ++--
 drivers/net/can/vxcan.c                            |   2 +-
 drivers/net/ethernet/8390/mcf8390.c                |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |  29 +++-
 drivers/net/ethernet/qlogic/qed/qed_sriov.h        |   1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   3 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h    |  10 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   3 +-
 drivers/net/ethernet/sun/sunhme.c                  |   6 +-
 drivers/net/hamradio/6pack.c                       |   4 +-
 drivers/net/macvtap.c                              |   6 +
 drivers/net/phy/broadcom.c                         |  21 +++
 drivers/net/wireless/ath/ath10k/wow.c              |   7 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |   3 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   5 +
 drivers/net/wireless/ath/carl9170/main.c           |   2 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  48 +-----
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |   2 +-
 drivers/net/wireless/ray_cs.c                      |   6 +
 drivers/parisc/dino.c                              |  41 ++++-
 drivers/parisc/gsc.c                               |  31 ++++
 drivers/parisc/gsc.h                               |   1 +
 drivers/parisc/lasi.c                              |   7 +-
 drivers/parisc/wax.c                               |   7 +-
 drivers/pci/access.c                               |   9 +-
 drivers/pci/controller/pci-aardvark.c              |  16 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   4 +
 drivers/perf/qcom_l2_pmu.c                         |   6 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   2 +
 drivers/pinctrl/nomadik/pinctrl-nomadik.c          |   4 +-
 drivers/pinctrl/pinconf-generic.c                  |   6 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   2 +
 drivers/pinctrl/samsung/pinctrl-samsung.c          |  30 +++-
 drivers/power/reset/gemini-poweroff.c              |   4 +-
 drivers/power/supply/ab8500_fg.c                   |   4 +-
 drivers/power/supply/axp20x_battery.c              |  13 +-
 drivers/power/supply/bq24190_charger.c             |   7 +-
 drivers/power/supply/wm8350_power.c                |  97 ++++++++++--
 drivers/ptp/ptp_sysfs.c                            |   4 +-
 drivers/pwm/pwm-lpc18xx-sct.c                      |  20 ++-
 drivers/regulator/qcom_smd-regulator.c             |   4 +-
 drivers/remoteproc/qcom_wcnss.c                    |   1 +
 drivers/rtc/rtc-wm8350.c                           |  11 +-
 drivers/scsi/aha152x.c                             |   6 +-
 drivers/scsi/bfa/bfad_attr.c                       |  26 ++--
 drivers/scsi/libfc/fc_exch.c                       |   1 +
 drivers/scsi/libsas/sas_ata.c                      |   2 +-
 drivers/scsi/mvsas/mv_init.c                       |   4 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  13 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  11 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   4 +
 drivers/scsi/qla2xxx/qla_gs.c                      |   5 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  40 ++++-
 drivers/scsi/qla2xxx/qla_isr.c                     |   1 +
 drivers/scsi/qla2xxx/qla_target.c                  |   1 +
 drivers/scsi/zorro7xx.c                            |   2 +
 drivers/soc/ti/wkup_m3_ipc.c                       |   4 +-
 drivers/spi/spi-bcm-qspi.c                         |   4 +-
 drivers/spi/spi-pxa2xx-pci.c                       |  17 ++-
 drivers/spi/spi-tegra114.c                         |   4 +
 drivers/spi/spi-tegra20-slink.c                    |   8 +-
 drivers/spi/spi.c                                  |   4 +-
 drivers/staging/iio/adc/ad7280a.c                  |   4 +-
 drivers/thermal/int340x_thermal/int3400_thermal.c  |   2 +-
 drivers/tty/hvc/hvc_iucv.c                         |   4 +-
 drivers/tty/mxser.c                                |  15 +-
 drivers/tty/serial/8250/8250_mid.c                 |  19 ++-
 drivers/tty/serial/8250/8250_port.c                |  12 ++
 drivers/tty/serial/kgdboc.c                        |   6 +-
 drivers/tty/serial/samsung.c                       |   5 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   2 +-
 drivers/usb/host/ehci-pci.c                        |   9 ++
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci-mem.c                        |   2 +-
 drivers/usb/host/xhci.c                            |  20 ++-
 drivers/usb/host/xhci.h                            |   7 +-
 drivers/usb/serial/Kconfig                         |   1 +
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   3 +
 drivers/usb/serial/usb-serial-simple.c             |   7 +
 drivers/usb/storage/ene_ub6250.c                   | 155 ++++++++++---------
 drivers/usb/storage/realtek_cr.c                   |   2 +-
 drivers/video/fbdev/atafb.c                        |  12 +-
 drivers/video/fbdev/cirrusfb.c                     |  16 +-
 drivers/video/fbdev/core/fbcvt.c                   |  53 +++----
 drivers/video/fbdev/nvidia/nv_i2c.c                |   2 +-
 .../fbdev/omap2/omapfb/displays/connector-dvi.c    |   1 +
 .../fbdev/omap2/omapfb/displays/panel-dsi-cm.c     |   8 +-
 .../omap2/omapfb/displays/panel-sony-acx565akm.c   |   2 +-
 .../omap2/omapfb/displays/panel-tpo-td043mtea1.c   |   4 +-
 drivers/video/fbdev/sm712fb.c                      |  46 ++----
 drivers/video/fbdev/smscufx.c                      |   3 +-
 drivers/video/fbdev/udlfb.c                        |   8 +-
 drivers/video/fbdev/w100fb.c                       |  15 +-
 drivers/w1/slaves/w1_therm.c                       |   8 +-
 fs/btrfs/extent_io.h                               |   2 +-
 fs/ext2/super.c                                    |   6 +-
 fs/ext4/inode.c                                    |  25 +++
 fs/f2fs/gc.c                                       |   4 +-
 fs/fuse/dev.c                                      |  12 +-
 fs/fuse/file.c                                     |   1 +
 fs/fuse/fuse_i.h                                   |   2 +
 fs/gfs2/rgrp.c                                     |   3 +-
 fs/jffs2/build.c                                   |   4 +-
 fs/jffs2/fs.c                                      |   2 +-
 fs/jffs2/scan.c                                    |   6 +-
 fs/jfs/inode.c                                     |   3 +-
 fs/jfs/jfs_dmap.c                                  |   7 +
 fs/minix/inode.c                                   |   3 +-
 fs/nfs/callback_proc.c                             |  27 ++--
 fs/nfs/callback_xdr.c                              |   4 -
 fs/nfs/direct.c                                    |  48 ++++--
 fs/nfs/file.c                                      |   4 +-
 fs/nfs/nfs4state.c                                 |  12 ++
 fs/nfs/pnfs.c                                      |  11 ++
 fs/nfs/pnfs.h                                      |   2 +
 fs/nfsd/nfsproc.c                                  |   2 +-
 fs/nfsd/xdr.h                                      |   2 +-
 fs/ntfs/inode.c                                    |   4 +
 fs/ubifs/dir.c                                     |  44 ++++--
 fs/ubifs/io.c                                      |  34 ++++-
 fs/ubifs/ioctl.c                                   |   2 +-
 include/linux/blk-cgroup.h                         |  17 +++
 include/linux/blkdev.h                             |   8 +
 include/linux/mmzone.h                             |  11 +-
 include/linux/netdevice.h                          |   6 +-
 include/linux/nfs_fs.h                             |   8 +-
 include/linux/pci.h                                |   1 +
 include/linux/sunrpc/xdr.h                         |   2 +
 include/net/arp.h                                  |   1 +
 include/net/sock.h                                 |  25 ++-
 include/net/xfrm.h                                 |  11 +-
 include/uapi/linux/bpf.h                           |   4 +-
 init/main.c                                        |   6 +-
 kernel/cgroup/cgroup-internal.h                    |  19 +++
 kernel/cgroup/cgroup-v1.c                          |  33 ++--
 kernel/cgroup/cgroup.c                             |  81 +++++++---
 kernel/dma/debug.c                                 |   4 +-
 kernel/events/core.c                               |   3 +
 kernel/power/hibernate.c                           |   2 +-
 kernel/power/suspend_test.c                        |   8 +-
 kernel/printk/printk.c                             |   6 +-
 kernel/ptrace.c                                    |  47 ++++--
 kernel/sched/debug.c                               |  10 --
 lib/raid6/test/Makefile                            |   4 +-
 lib/raid6/test/test.c                              |   1 -
 lib/test_kmod.c                                    |   1 +
 mm/memcontrol.c                                    |   2 +-
 mm/memory.c                                        |  42 ++++--
 mm/mempolicy.c                                     |   9 +-
 mm/mmap.c                                          |   2 +-
 mm/mremap.c                                        |   3 +
 mm/page_alloc.c                                    |   9 +-
 mm/rmap.c                                          |  25 ++-
 mm/usercopy.c                                      |   5 +-
 net/bluetooth/hci_event.c                          |   3 +-
 net/can/raw.c                                      |   2 +-
 net/ipv4/arp.c                                     |   9 +-
 net/ipv4/fib_frontend.c                            |   5 +-
 net/ipv4/raw.c                                     |   2 +-
 net/ipv4/tcp_output.c                              |   5 +-
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/xfrm6_output.c                            |  16 ++
 net/key/af_key.c                                   |   6 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  17 ++-
 net/netlink/af_netlink.c                           |   2 +
 net/openvswitch/actions.c                          |   2 +-
 net/openvswitch/flow_netlink.c                     |   8 +-
 net/packet/af_packet.c                             |   6 +-
 net/rxrpc/net_ns.c                                 |   2 +-
 net/smc/smc_core.c                                 |   2 +-
 net/sunrpc/sched.c                                 |   4 +-
 net/sunrpc/xprt.c                                  |   7 +
 net/sunrpc/xprtrdma/transport.c                    |   4 +-
 net/x25/af_x25.c                                   |  11 +-
 net/xfrm/xfrm_interface.c                          |   5 +-
 net/xfrm/xfrm_policy.c                             |  32 ++--
 net/xfrm/xfrm_user.c                               |  18 ++-
 security/selinux/xfrm.c                            |   2 +-
 security/smack/smack_lsm.c                         |   2 +-
 security/tomoyo/load_policy.c                      |   4 +-
 sound/firewire/fcp.c                               |   4 +-
 sound/isa/cs423x/cs4236.c                          |   8 +-
 sound/pci/hda/patch_realtek.c                      |   4 +-
 sound/soc/atmel/atmel_ssc_dai.c                    |   5 +-
 sound/soc/atmel/sam9g20_wm8731.c                   |   1 +
 sound/soc/codecs/msm8916-wcd-digital.c             |   5 +-
 sound/soc/codecs/rt5663.c                          |   2 +
 sound/soc/codecs/wm8350.c                          |  28 +++-
 sound/soc/davinci/davinci-i2s.c                    |   5 +-
 sound/soc/fsl/imx-es8328.c                         |   1 +
 sound/soc/mxs/mxs-saif.c                           |   5 +-
 sound/soc/mxs/mxs-sgtl5000.c                       |   3 +
 sound/soc/sh/fsi.c                                 |  19 ++-
 sound/soc/soc-core.c                               |   2 +-
 sound/soc/soc-generic-dmaengine-pcm.c              |   6 +-
 sound/soc/soc-topology.c                           |   3 +-
 sound/spi/at73c213.c                               |  27 +++-
 tools/build/feature/Makefile                       |   9 +-
 tools/include/uapi/linux/bpf.h                     |   4 +-
 tools/perf/Makefile.config                         |   3 +
 tools/testing/selftests/bpf/test_lirc_mode2.sh     |   5 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |   2 +-
 tools/testing/selftests/cgroup/test_core.c         | 167 +++++++++++++++++++++
 tools/testing/selftests/x86/check_cc.sh            |   2 +-
 virt/kvm/kvm_main.c                                |  13 ++
 360 files changed, 2494 insertions(+), 1147 deletions(-)


