Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080BC12EBCD
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgABWMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbgABWMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:12:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE52621835;
        Thu,  2 Jan 2020 22:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003141;
        bh=uKsiOJaX668gVqjmiklzECBA0GKkF/p39aVol8W/zZ8=;
        h=From:To:Cc:Subject:Date:From;
        b=kPHNKxKRF7mO0Yo/AYS3DIHpjfaUBh2CWfJ4KFhjkHdTVA//4o19DEiuWlLTwa2vZ
         XTepXBR8HT8orxiMl7Hkc/bT0jHFeLl8Cw0ZAKfEAFLGyfn6azdZbrRxpGJrgkHvSX
         yEV8p4/DEJIfdRTJ5X1g7fMUlybWpyXhuYYnlAkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/191] 5.4.8-stable review
Date:   Thu,  2 Jan 2020 23:04:42 +0100
Message-Id: <20200102215829.911231638@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.8-rc1
X-KernelTest-Deadline: 2020-01-04T21:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.8 release.
There are 191 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 04 Jan 2020 21:55:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.8-rc1

Yangbo Lu <yangbo.lu@nxp.com>
    mmc: sdhci-of-esdhc: re-implement erratum A-009204 workaround

Yangbo Lu <yangbo.lu@nxp.com>
    mmc: sdhci-of-esdhc: fix up erratum A-008171 workaround

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: accept only packets with the right dst_cid

Netanel Belgazal <netanel@amazon.com>
    net: ena: fix napi handler misbehavior when the napi budget is zero

Russell King <rmk+kernel@armlinux.org.uk>
    net: phylink: fix interface passed to mac_link_up

Hangbin Liu <liuhangbin@gmail.com>
    ipv6/addrconf: only check invalid header values when NETLINK_F_STRICT_CHK is set

Jonathan Lemon <jonathan.lemon@gmail.com>
    bnxt: apply computed clamp value for coalece parameter

Taehee Yoo <ap420073@gmail.com>
    gtp: do not allow adding duplicate tid and ms_addr pdp context

Taehee Yoo <ap420073@gmail.com>
    gtp: fix an use-after-free in ipv4_pdp_find()

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix tx_table init in rndis_set_subchannel()

Eric Dumazet <edumazet@google.com>
    tcp/dccp: fix possible race __inet_lookup_established()

Eric Dumazet <edumazet@google.com>
    tcp: do not send empty skb from tcp_write_xmit()

Mahesh Bandewar <maheshb@google.com>
    bonding: fix active-backup transition after link failure

Taehee Yoo <ap420073@gmail.com>
    gtp: avoid zero size hashtable

Taehee Yoo <ap420073@gmail.com>
    gtp: fix wrong condition in gtp_genl_dump_pdp()

Russell King <rmk+kernel@armlinux.org.uk>
    net: marvell: mvpp2: phylink requires the link interrupt

Vladimir Oltean <olteanv@gmail.com>
    net: dsa: sja1105: Reconcile the meaning of TPID and TPID2 for E/T and P/Q/R/S

Hangbin Liu <liuhangbin@gmail.com>
    net/dst: do not confirm neighbor for vxlan and geneve pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    sit: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    vti: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    tunnel: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    net/dst: add new function skb_dst_update_pmtu_no_confirm

Hangbin Liu <liuhangbin@gmail.com>
    gtp: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    ip6_gre: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    net: add bool confirm_neigh parameter for dst_ops.update_pmtu

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum: Use dedicated policer for VRRP packets

Amit Cohen <amitc@mellanox.com>
    mlxsw: spectrum_router: Skip loopback RIFs during MAC validation

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Add missing devlink health reporters for VFs.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix the logic that creates the health reporters.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Remove unnecessary NULL checks for fw_health

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix bp->fw_health allocation and free logic.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Return error if FW returns more data than dump length

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Free context memory in the open path if firmware has been reset.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix MSIX request logic for RDMA driver.

Antonio Messina <amessina@google.com>
    udp: fix integer overflow while computing available space in sk_rcvbuf

Cambda Zhu <cambda@linux.alibaba.com>
    tcp: Fix highest_sack and highest_sack_seq

Vladis Dronov <vdronov@redhat.com>
    ptp: fix the race between the release of ptp_clock and cdev

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: properly set sk->sk_pacing_status

Davide Caratti <dcaratti@redhat.com>
    net/sched: add delete_empty() to filters and use it in cls_flower

Shmulik Ladkani <sladkani@proofpoint.com>
    net/sched: act_mirred: Pull mac prior redir to non mac_header_xmit device

Madalin Bucur <madalin.bucur@oss.nxp.com>
    net: phy: aquantia: add suspend / resume ops for AQR105

Vladyslav Tarasiuk <vladyslavt@mellanox.com>
    net/mlxfw: Fix out-of-memory error in mfa2 flash burning

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix IP fragment location and behavior

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4/cxgb4vf: fix flow control display for auto negotiation

Brian Foster <bfoster@redhat.com>
    xfs: fix mount failure crash on invalid iclog memory access

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm: limit to INT_MAX in create_blob ioctl

Kees Cook <keescook@chromium.org>
    uaccess: disallow > INT_MAX copy sizes

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: Don't use nifty names on sockets.

Eric Dumazet <edumazet@google.com>
    hrtimer: Annotate lockless access to timer->state

Eric Dumazet <edumazet@google.com>
    net: icmp: fix data-race in cmp_global_allow()

Eric Dumazet <edumazet@google.com>
    net: add a READ_ONCE() in skb_peek_tail()

Eric Dumazet <edumazet@google.com>
    inetpeer: fix data-race in inet_putpeer / inet_putpeer

Eric Dumazet <edumazet@google.com>
    netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: add fallback check to connect()

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc: Fix __clear_user() with KUAP enabled

Eric Dumazet <edumazet@google.com>
    6pack,mkiss: fix possible deadlock

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: compat: reject all padding in matches/watchers

Anders Kaseorg <andersk@mit.edu>
    Revert "iwlwifi: assign directly to iwl_trans->cfg in QuZ detection"

Yufen Yu <yuyufen@huawei.com>
    md: make sure desc_nr less than MD_SB_DISKS

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fix err handling of stream initialization

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "powerpc/vcpu: Assume dedicated processors as non-preempt"

Mike Rapoport <rppt@linux.ibm.com>
    userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK

Johannes Weiner <hannes@cmpxchg.org>
    kernel: sysctl: make drop_caches write-only

Mike Kravetz <mike.kravetz@oracle.com>
    mm/hugetlbfs: fix error handling when setting up mounts

Anders Roxell <anders.roxell@linaro.org>
    selftests: vm: add fragment CONFIG_TEST_VMALLOC

Vasily Gorbik <gor@linux.ibm.com>
    s390: disable preemption when switching to nodat stack with CALL_ON_STACK

Daniel Baluta <daniel.baluta@nxp.com>
    mailbox: imx: Fix Tx doorbell shutdown path

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ocfs2: fix passing zero to 'PTR_ERR' warning

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Check for SDBT and SDB consistency

Vasily Gorbik <gor@linux.ibm.com>
    s390/unwind: filter out unreliable bogus %r14

Masahiro Yamada <yamada.masahiro@socionext.com>
    libfdt: define INT32_MAX and UINT32_MAX in libfdt_env.h

Daniel Baluta <daniel.baluta@nxp.com>
    mailbox: imx: Clear the right interrupts at shutdown

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: handle new reply code FILTERED_BY_HYPERVISOR

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf regs: Make perf_reg_name() return "unknown" instead of NULL

Adrian Hunter <adrian.hunter@intel.com>
    perf script: Fix brstackinsn for AUXTRACE

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf diff: Use llabs() with 64-bit values

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: move cifsFileInfo_put logic into a work-queue

Diego Elio Pettenò <flameeyes@flameeyes.com>
    cdrom: respect device capabilities during opening action

Erhard Furtner <erhard_f@mailbox.org>
    of: unittest: fix memory leak in attach_node_and_children

Jens Axboe <axboe@kernel.dk>
    io_uring: io_allocate_scq_urings() should return a sane state

Johannes Berg <johannes.berg@intel.com>
    um: virtio: Keep reading on -EAGAIN

Paulo Alcantara (SUSE) <pc@cjr.nz>
    cifs: Fix use-after-free bug in cifs_reconnect()

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: choose hardlimit when softlimit is larger than hardlimit in f2fs_statfs_project()

Nathan Chancellor <natechancellor@gmail.com>
    powerpc: Don't add -mabi= flags when building with Clang

Masahiro Yamada <yamada.masahiro@socionext.com>
    scripts/kallsyms: fix definitely-lost memory leak

Jason Gunthorpe <jgg@ziepe.ca>
    drm/amdgpu: Call find_vma under mmap_sem

Colin Ian King <colin.king@canonical.com>
    apparmor: fix unsigned len comparison with less than zero

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Fix crash handler reset of Hyper-V synic

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    tools/power/x86/intel-speed-select: Ignore missing config level

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: lynxpoint: Setup correct IRQ handlers

Vladimir Oltean <vladimir.oltean@nxp.com>
    gpio: mpc8xxx: Don't overwrite default irq_set_type callback

Gayatri Kammela <gayatri.kammela@intel.com>
    platform/x86: intel_pmc_core: Add Comet Lake (CML) platform support to intel_pmc_core driver

Gayatri Kammela <gayatri.kammela@intel.com>
    platform/x86: intel_pmc_core: Fix the SoC naming inconsistency

Russell King <rmk+kernel@armlinux.org.uk>
    gpio/mpc8xxx: fix qoriq GPIO reading

Omer Shpigelman <oshpigelman@habana.ai>
    habanalabs: skip VA block list update in reset flow

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: Fix deadlock in f2fs_gc() context during atomic files handling

Bart Van Assche <bvanassche@acm.org>
    scsi: target: iscsi: Wait for all commands to finish before freeing a session

Anatol Pomazau <anatol@google.com>
    scsi: iscsi: Don't send data to unbound connection

Can Guo <cang@codeaurora.org>
    scsi: ufs: Fix up auto hibern8 enablement

Bart Van Assche <bvanassche@acm.org>
    scsi: target: core: Release SPC-2 reservations when closing a session

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Add disconnect_mask module parameter

Maurizio Lombardi <mlombard@redhat.com>
    scsi: scsi_debug: num_tgts must be >= 0

Subhash Jadavani <subhashj@codeaurora.org>
    scsi: ufs: Fix error handing during hibern8 enter

peter chang <dpf@google.com>
    scsi: pm80xx: Fix for SATA device discovery

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/fixmap: Use __fix_to_virt() instead of fix_to_virt()

Kevin Hao <haokexin@gmail.com>
    watchdog: Fix the race between the release of watchdog_core_data and cdev

Julia Cartwright <julia@ni.com>
    watchdog: prevent deferral of watchdogd wakeup on RT

Fabio Estevam <festevam@gmail.com>
    watchdog: imx7ulp: Fix reboot hang

Andrew Duggan <aduggan@synaptics.com>
    HID: rmi: Check that the RMI_STARTED bit is set before unregistering the RMI transport device

Blaž Hrastnik <blaz@mxxn.io>
    HID: Improve Windows Precision Touchpad detection.

Qian Cai <cai@lca.pw>
    libnvdimm/btt: fix variable 'rc' set but not used

Doug Berger <opendmb@gmail.com>
    ARM: 8937/1: spectre-v2: remove Brahma-B53 from hardening

Aaron Ma <aaron.ma@canonical.com>
    HID: i2c-hid: fix no irq after reset on raydium 3118

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-hidpp: Silence intermittent get_battery_capacity errors

Rob Herring <robh@kernel.org>
    dt-bindings: Improve validation build error handling

Jinke Fan <fanjinke@hygon.cn>
    HID: quirks: Add quirk for HP MSU1465 PIXART OEM mouse

Coly Li <colyli@suse.de>
    bcache: at least try to shrink 1 node in bch_mca_scan()

Robert Jarzmik <robert.jarzmik@free.fr>
    clk: pxa: fix one of the pxa RTC clocks

Finn Thain <fthain@telegraphics.com.au>
    scsi: atari_scsi: sun3_scsi: Set sg_tablesize to 1 instead of SG_NONE

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s/mm: Update Oops message to print the correct translation in use

Sam Bobroff <sbobroff@linux.ibm.com>
    powerpc/eeh: differentiate duplicate detection message

Gustavo L. F. Walbon <gwalbon@linux.ibm.com>
    powerpc/security: Fix wrong message when RFI Flush is disable

Tyrel Datwyler <tyreld@linux.ibm.com>
    PCI: rpaphp: Correctly match ibm, my-drc-index to drc-name when using drc-info

Tyrel Datwyler <tyreld@linux.ibm.com>
    PCI: rpaphp: Annotate and correctly byte swap DRC properties

Tyrel Datwyler <tyreld@linux.ibm.com>
    PCI: rpaphp: Don't rely on firmware feature to imply drc-info support

David Hildenbrand <david@redhat.com>
    powerpc/pseries/cmm: Implement release() function for sysfs device

Bean Huo <beanhuo@micron.com>
    scsi: ufs: fix potential bug which ends in system hang

Tyrel Datwyler <tyreld@linux.ibm.com>
    PCI: rpaphp: Fix up pointer to first drc-info entry

Kars de Jong <jongk@linux-m68k.org>
    scsi: zorro_esp: Limit DMA transfers to 65536 bytes (except on Fastlane)

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer dereferences

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ili210x - handle errors from input_mt_init_slots()

Jan Stancek <jstancek@redhat.com>
    iomap: fix return value of iomap_dio_bio_actor on 32bit systems

Alain Volmat <alain.volmat@st.com>
    i2c: stm32f7: fix & reorder remove & probe error handling

Jean-Philippe Brucker <jean-philippe@linaro.org>
    iommu/arm-smmu-v3: Don't display an error when IRQ lines are missing

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    fs/quota: handle overflows of sysctl fs.quota.* and report as unsigned long

Lee Jones <lee.jones@linaro.org>
    mfd: mfd-core: Honour Device Tree's request to disable a child-device

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    dma-direct: check for overflows on 32 bit DMA addresses

Paul Cercueil <paul@crapouillou.net>
    irqchip: ingenic: Error out if IRQ domain creation failed

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7038-l1: Enable parent IRQ if necessary

Michael Hennerich <michael.hennerich@analog.com>
    clk: clk-gpio: propagate rate change to parent

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    clk: qcom: Allow constant ratio freq tables for rcg

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    clk: qcom: smd: Add missing pnoc clock

Chao Yu <chao@kernel.org>
    f2fs: fix to update dir's i_pino during cross_rename

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix unexpected error messages during RSCN handling

Bart Van Assche <bvanassche@acm.org>
    scsi: tracing: Fix handling of TRANSFER LENGTH == 0 for READ(6) and WRITE(6)

Jan Kara <jack@suse.cz>
    jbd2: Fix statistics for the number of logged blocks

Matthew Bobrowski <mbobrowski@mbobrowski.org>
    ext4: iomap that extends beyond EOF should be marked dirty

Matthew Bobrowski <mbobrowski@mbobrowski.org>
    ext4: update direct I/O read lock pattern for IOCB_NOWAIT

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/hash: Add cond_resched to avoid soft lockup warning

Anthony Steinhauser <asteinhauser@google.com>
    powerpc/security/book3s64: Report L1TF status in sysfs

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Skip tm-signal-sigreturn-nt if TM not available

Pavel Modilaynen <pavel.modilaynen@axis.com>
    dtc: Use pkg-config to locate libyaml

Geert Uytterhoeven <geert+renesas@glider.be>
    clocksource/drivers/timer-of: Use unique device name instead of timer

Chuhong Yuan <hslester96@gmail.com>
    clocksource/drivers/asm9260: Add a check for of_clk_get

Martin Schiller <ms@dev.tdt.de>
    leds: trigger: netdev: fix handling on interface rename

Chuhong Yuan <hslester96@gmail.com>
    leds: an30259a: add a check for devm_regmap_init_i2c

Guido Günther <agx@sigxcpu.org>
    leds: lm3692x: Handle failure to probe the regulator

Krzysztof Kozlowski <krzk@kernel.org>
    dmaengine: fsl-qdma: Handle invalid qdma-queue0 IRQ

Vladimir Murzin <vladimir.murzin@arm.com>
    dma-mapping: fix handling of dma-ranges for reserved memory (again)

Kees Cook <keescook@chromium.org>
    dma-mapping: Add vmap checks to dma_map_single()

Eric Dumazet <edumazet@google.com>
    dma-debug: add a schedule point in debug_dma_dump_mappings()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/tools: Don't quote $objdump in scripts

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Fixup clobbers for TM tests

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: st1232 - do not reset the chip too early

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/pseries: Don't fail hash page table insert for bolted mapping

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Mark accumulate_stolen_time() as notrace

Luo Jiaxing <luojiaxing@huawei.com>
    scsi: hisi_sas: Delete the debugfs folder of hisi_sas when the probe fails

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Replace in_softirq() check in hisi_sas_task_exec()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: csiostor: Don't enable IRQs too early

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix hardlockup in lpfc_abort_handler

David Disseldorp <ddiss@suse.de>
    scsi: target: compare full CHAP_A Algorithm strings

Nicholas Graumann <nick.graumann@gmail.com>
    dmaengine: xilinx_dma: Clear desc_pendingcount in xilinx_dma_reset

Thierry Reding <treding@nvidia.com>
    iommu/tegra-smmu: Fix page tables in > 4 GiB memory

Ezequiel Garcia <ezequiel@collabora.com>
    iommu: rockchip: Free domain on .domain_free

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    platform/x86: peaq-wmi: switch to using polled mode of input devices

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    tools/power/x86/intel-speed-select: Remove warning for unused result

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/papr_scm: Fix an off-by-one check in papr_scm_meta_{get, set}

Chao Yu <chao@kernel.org>
    f2fs: fix to update time in lazytime mode

Evan Green <evgreen@chromium.org>
    Input: atmel_mxt_ts - disable IRQ across suspend

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix list corruption in lpfc_sli_get_iocbq

Anson Huang <Anson.Huang@nxp.com>
    gpio: mxc: Only get the second IRQ when there is more than one IRQ

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Reject NVMe Encap cmnds to unsupported HBA

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix locking on mailbox command completion

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix clear pending bit in ioctl status

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix discovery failures when target device connectivity bounces

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix spinlock_irq issues in lpfc_els_flush_cmd()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "MIPS: futex: Emit Loongson3 sync workarounds within asm"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "MIPS: futex: Restore \n after sync instructions"


-------------

Diffstat:

 Documentation/devicetree/bindings/Makefile         |   5 +-
 Documentation/devicetree/writing-schema.rst        |   6 +-
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/libfdt_env.h              |   4 +-
 arch/arm/mm/dma-mapping-nommu.c                    |   2 +-
 arch/arm/mm/proc-v7-bugs.c                         |   3 +
 arch/mips/include/asm/barrier.h                    |  13 +-
 arch/mips/include/asm/futex.h                      |  15 +-
 arch/powerpc/Makefile                              |   4 +
 arch/powerpc/boot/libfdt_env.h                     |   2 +
 arch/powerpc/include/asm/fixmap.h                  |   7 +-
 arch/powerpc/include/asm/spinlock.h                |   4 +-
 arch/powerpc/include/asm/uaccess.h                 |   9 +-
 arch/powerpc/kernel/eeh_driver.c                   |   4 +-
 arch/powerpc/kernel/security.c                     |  21 +-
 arch/powerpc/kernel/time.c                         |   2 +-
 arch/powerpc/kernel/traps.c                        |  15 +-
 arch/powerpc/lib/string_32.S                       |   4 +-
 arch/powerpc/lib/string_64.S                       |   6 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |  10 +-
 arch/powerpc/platforms/pseries/cmm.c               |   5 +
 arch/powerpc/platforms/pseries/papr_scm.c          |   4 +-
 arch/powerpc/platforms/pseries/setup.c             |   7 -
 arch/powerpc/tools/relocs_check.sh                 |   2 +-
 arch/powerpc/tools/unrel_branch_check.sh           |   4 +-
 arch/s390/kernel/machine_kexec.c                   |   2 +
 arch/s390/kernel/perf_cpum_sf.c                    |  17 +-
 arch/s390/kernel/unwind_bc.c                       |   5 +
 arch/s390/mm/maccess.c                             |  12 +-
 arch/um/drivers/virtio_uml.c                       |   8 +-
 drivers/cdrom/cdrom.c                              |  12 +-
 drivers/clk/clk-gpio.c                             |   2 +-
 drivers/clk/pxa/clk-pxa27x.c                       |   1 +
 drivers/clk/qcom/clk-rcg2.c                        |   2 +
 drivers/clk/qcom/clk-smd-rpm.c                     |   3 +
 drivers/clk/qcom/common.c                          |   3 +
 drivers/clocksource/asm9260_timer.c                |   4 +
 drivers/clocksource/timer-of.c                     |   2 +-
 drivers/dma/fsl-qdma.c                             |   3 +
 drivers/dma/xilinx/xilinx_dma.c                    |   1 +
 drivers/gpio/gpio-lynxpoint.c                      |   6 +
 drivers/gpio/gpio-mpc8xxx.c                        |   6 +-
 drivers/gpio/gpio-mxc.c                            |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  37 ++--
 drivers/gpu/drm/drm_property.c                     |   2 +-
 drivers/hid/hid-core.c                             |   4 +
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-logitech-hidpp.c                   |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-rmi.c                              |   3 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   2 +
 drivers/hv/vmbus_drv.c                             |   2 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  19 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           |   4 +
 drivers/input/touchscreen/ili210x.c                |   7 +-
 drivers/input/touchscreen/st1232.c                 |  22 +-
 drivers/iommu/arm-smmu-v3.c                        |   8 +-
 drivers/iommu/rockchip-iommu.c                     |   7 +-
 drivers/iommu/tegra-smmu.c                         |  11 +-
 drivers/irqchip/irq-bcm7038-l1.c                   |   4 +
 drivers/irqchip/irq-ingenic.c                      |  15 +-
 drivers/leds/leds-an30259a.c                       |   7 +
 drivers/leds/leds-lm3692x.c                        |  13 +-
 drivers/leds/trigger/ledtrig-netdev.c              |   5 +-
 drivers/mailbox/imx-mailbox.c                      |  19 +-
 drivers/md/bcache/btree.c                          |   2 +
 drivers/md/md.c                                    |   1 +
 drivers/mfd/mfd-core.c                             |   5 +
 drivers/misc/habanalabs/memory.c                   |  30 ++-
 drivers/mmc/host/sdhci-esdhc.h                     |  14 ++
 drivers/mmc/host/sdhci-of-esdhc.c                  | 232 ++++++++++++++++++---
 drivers/net/bonding/bond_main.c                    |   3 -
 drivers/net/dsa/bcm_sf2_cfp.c                      |   6 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   8 +-
 drivers/net/dsa/sja1105/sja1105_static_config.c    |   7 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  63 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  93 ++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  38 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h  |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |  21 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   4 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h |   1 +
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c     |  18 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c   |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   9 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   3 +
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |  14 +-
 drivers/net/gtp.c                                  | 111 +++++-----
 drivers/net/hamradio/6pack.c                       |   4 +-
 drivers/net/hamradio/mkiss.c                       |   4 +-
 drivers/net/hyperv/rndis_filter.c                  |   6 +-
 drivers/net/phy/aquantia_main.c                    |   2 +
 drivers/net/phy/phylink.c                          |   3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  24 +--
 drivers/nvdimm/btt.c                               |   8 +-
 drivers/of/unittest.c                              |   4 +-
 drivers/pci/hotplug/rpaphp_core.c                  |  38 ++--
 drivers/platform/x86/Kconfig                       |   1 -
 drivers/platform/x86/intel_pmc_core.c              |  17 +-
 drivers/platform/x86/peaq-wmi.c                    |  66 +++---
 drivers/ptp/ptp_clock.c                            |  31 ++-
 drivers/ptp/ptp_private.h                          |   2 +-
 drivers/s390/crypto/zcrypt_error.h                 |   2 +
 drivers/scsi/NCR5380.c                             |   6 +-
 drivers/scsi/atari_scsi.c                          |   6 +-
 drivers/scsi/csiostor/csio_lnode.c                 |  15 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   9 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   1 +
 drivers/scsi/iscsi_tcp.c                           |   8 +
 drivers/scsi/lpfc/lpfc_ct.c                        |   6 +
 drivers/scsi/lpfc/lpfc_els.c                       |  42 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  12 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   4 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   5 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  18 +-
 drivers/scsi/mac_scsi.c                            |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  15 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   2 +
 drivers/scsi/scsi_debug.c                          |   5 +
 drivers/scsi/scsi_trace.c                          |  11 +-
 drivers/scsi/sun3_scsi.c                           |   4 +-
 drivers/scsi/ufs/ufs-sysfs.c                       |  15 +-
 drivers/scsi/ufs/ufshcd.c                          |  35 ++--
 drivers/scsi/ufs/ufshcd.h                          |   2 +
 drivers/scsi/zorro_esp.c                           |  11 +-
 drivers/target/iscsi/iscsi_target.c                |  10 +-
 drivers/target/iscsi/iscsi_target_auth.c           |   2 +-
 drivers/target/target_core_transport.c             |  15 ++
 drivers/vhost/vsock.c                              |   4 +-
 drivers/watchdog/imx7ulp_wdt.c                     |  16 ++
 drivers/watchdog/watchdog_dev.c                    |  80 ++++---
 fs/cifs/cifsfs.c                                   |  13 +-
 fs/cifs/cifsglob.h                                 |   5 +-
 fs/cifs/connect.c                                  |  46 +++-
 fs/cifs/file.c                                     |  74 ++++---
 fs/ext4/inode.c                                    |  16 +-
 fs/f2fs/f2fs.h                                     |  24 ++-
 fs/f2fs/file.c                                     |   1 +
 fs/f2fs/inode.c                                    |   6 +-
 fs/f2fs/namei.c                                    |  15 +-
 fs/f2fs/segment.c                                  |  21 +-
 fs/f2fs/super.c                                    |  20 +-
 fs/hugetlbfs/inode.c                               |  31 ++-
 fs/io_uring.c                                      |  10 +-
 fs/iomap/direct-io.c                               |   4 +-
 fs/jbd2/commit.c                                   |   4 +-
 fs/ocfs2/acl.c                                     |   4 +-
 fs/quota/dquot.c                                   |  29 +--
 fs/userfaultfd.c                                   |  18 +-
 fs/xfs/xfs_log.c                                   |   2 +
 include/linux/dma-direct.h                         |  12 +-
 include/linux/dma-mapping.h                        |   8 +-
 include/linux/hrtimer.h                            |  14 +-
 include/linux/libfdt_env.h                         |   3 +
 include/linux/posix-clock.h                        |  19 +-
 include/linux/quota.h                              |   2 +-
 include/linux/rculist_nulls.h                      |  37 ++++
 include/linux/skbuff.h                             |   6 +-
 include/linux/thread_info.h                        |   2 +
 include/net/dst.h                                  |  13 +-
 include/net/dst_ops.h                              |   3 +-
 include/net/inet_hashtables.h                      |  12 +-
 include/net/sch_generic.h                          |   5 +
 include/net/sock.h                                 |   5 +
 include/scsi/iscsi_proto.h                         |   1 +
 kernel/dma/coherent.c                              |  16 +-
 kernel/dma/debug.c                                 |   1 +
 kernel/sysctl.c                                    |   2 +-
 kernel/time/hrtimer.c                              |  11 +-
 kernel/time/posix-clock.c                          |  31 ++-
 net/bridge/br_netfilter_hooks.c                    |   3 +
 net/bridge/br_nf_core.c                            |   3 +-
 net/bridge/netfilter/ebtables.c                    |  33 ++-
 net/decnet/dn_route.c                              |   6 +-
 net/ipv4/icmp.c                                    |  11 +-
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/inet_diag.c                               |   3 +-
 net/ipv4/inet_hashtables.c                         |  16 +-
 net/ipv4/inetpeer.c                                |  12 +-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/ipv4/ip_vti.c                                  |   2 +-
 net/ipv4/route.c                                   |   9 +-
 net/ipv4/tcp_ipv4.c                                |   7 +-
 net/ipv4/tcp_output.c                              |  11 +
 net/ipv4/udp.c                                     |   2 +-
 net/ipv4/xfrm4_policy.c                            |   5 +-
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/inet6_connection_sock.c                   |   2 +-
 net/ipv6/ip6_gre.c                                 |   2 +-
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/ipv6/ip6_vti.c                                 |   2 +-
 net/ipv6/route.c                                   |  22 +-
 net/ipv6/sit.c                                     |   2 +-
 net/ipv6/xfrm6_policy.c                            |   5 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
 net/sched/act_mirred.c                             |  22 +-
 net/sched/cls_api.c                                |  31 +--
 net/sched/cls_flower.c                             |  12 ++
 net/sched/sch_fq.c                                 |  17 +-
 net/sctp/stream.c                                  |  30 +--
 net/sctp/transport.c                               |   2 +-
 net/smc/af_smc.c                                   |  14 +-
 scripts/dtc/Makefile                               |   4 +-
 scripts/kallsyms.c                                 |   2 +
 security/apparmor/label.c                          |  12 +-
 security/tomoyo/realpath.c                         |  32 +--
 tools/perf/builtin-diff.c                          |   4 +-
 tools/perf/builtin-script.c                        |   2 +-
 tools/perf/util/perf_regs.h                        |   2 +-
 tools/power/x86/intel-speed-select/isst-config.c   |   9 +-
 tools/power/x86/intel-speed-select/isst-core.c     |   8 +-
 tools/power/x86/intel-speed-select/isst-display.c  |   3 +-
 .../selftests/powerpc/ptrace/ptrace-tm-spd-tar.c   |   2 +-
 .../selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c   |   4 +-
 .../selftests/powerpc/ptrace/ptrace-tm-tar.c       |   2 +-
 .../selftests/powerpc/ptrace/ptrace-tm-vsx.c       |   4 +-
 .../selftests/powerpc/tm/tm-signal-sigreturn-nt.c  |   4 +
 tools/testing/selftests/vm/config                  |   1 +
 226 files changed, 1829 insertions(+), 873 deletions(-)


