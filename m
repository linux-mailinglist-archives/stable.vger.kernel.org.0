Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6163E43A1D5
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbhJYTmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237264AbhJYTkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2808F61166;
        Mon, 25 Oct 2021 19:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190558;
        bh=C/KD8IzQS/lHhkJsx1771E0e47te31/ry60mqwv5fls=;
        h=From:To:Cc:Subject:Date:From;
        b=hpEjpgWVUPLKxFdRBPsN6SIAtyqR4Ws4LegYjrf3HtyN6bLbIVQy7gPZxgPEerfLQ
         FwrWKWT+YgFoRrkc9A11ZL0XgvRCMacaVd3lcB5vUmYEjeDfVJcUFC1ZrI65KwQ3Uh
         Di6MZWu5SFbNcZ8ckWBH/HHg6PknbzYgObirjuIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 000/169] 5.14.15-rc1 review
Date:   Mon, 25 Oct 2021 21:13:01 +0200
Message-Id: <20211025191017.756020307@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.15-rc1
X-KernelTest-Deadline: 2021-10-27T19:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.15 release.
There are 169 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 27 Oct 2021 19:08:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.15-rc1

Fabien Dessenne <fabien.dessenne@foss.st.com>
    pinctrl: stm32: use valid pin identifier in stm32_pinctrl_resume()

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9122/1: select HAVE_FUTEX_CMPXCHG

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Separate TGP board type from SPT

Yanfei Xu <yanfei.xu@windriver.com>
    net: mdiobus: Fix memory leak in __mdiobus_register

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity check for maxpacket

Daniel Borkmann <daniel@iogearbox.net>
    bpf, test, cgroup: Use sk_{alloc,free} for test cases

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: fix zpci_zdev_put() on reserve

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: cleanup resources only if necessary

Dexuan Cui <decui@microsoft.com>
    scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()

Ian Kent <raven@themaw.net>
    autofs: fix wait name hash calculation in autofs_wait()

Anitha Chrisanthus <anitha.chrisanthus@intel.com>
    drm/kmb: Limit supported mode to 1080p

Edmund Dea <edmund.j.dea@intel.com>
    drm/kmb: Enable alpha blended second plane

Maor Dickman <maord@nvidia.com>
    net/mlx5: Lag, change multipath and bonding to be mutually exclusive

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: Lag, move lag destruction to a workqueue

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix for miscalculation of rx unused desc

Woody Lin <woodylin@google.com>
    sched/scs: Reset the shadow stack when idle_task_exit

Marek Szyprowski <m.szyprowski@samsung.com>
    mm/thp: decrease nr_thps in file's mapping on THP split

Joy Gu <jgu@purestorage.com>
    scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Fix duplicate device entries when scanning through sysfs

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    scsi: storvsc: Fix validation for unsolicited incoming packets

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix set_param() handling

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    ASoC: codec: wcd938x: Add irq config support

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Input: snvs_pwrkey - add clk handling

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/msr: Add Sapphire Rapids CPU support

Shunsuke Nakamura <nakamura.shun@fujitsu.com>
    libperf tests: Fix test_stat_cpu

Shunsuke Nakamura <nakamura.shun@fujitsu.com>
    libperf test evsel: Fix build error on !x86 architectures

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi-mux: Fix false-positive lockdep splats

Mark Brown <broonie@kernel.org>
    spi: Fix deadlock when adding SPI controllers on SPI buses

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: avoid write to STATESTS if controller is in reset

Prashant Malani <pmalani@chromium.org>
    platform/x86: intel_scu_ipc: Update timeout value in comment

Prashant Malani <pmalani@chromium.org>
    platform/x86: intel_scu_ipc: Increase virtual timeout to 10s

Zheyu Ma <zheyuma97@gmail.com>
    isdn: mISDN: Fix sleeping function called from invalid context

Herve Codina <herve.codina@bootlin.com>
    ARM: dts: spear3xx: Fix gmac node

Herve Codina <herve.codina@bootlin.com>
    net: stmmac: add support for dwmac 3.40a

Filipe Manana <fdmanana@suse.com>
    btrfs: deal with errors when checking if a dir entry exists during log replay

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: intel: Allow repeatedly probing on codec configuration errors

Michael Forney <mforney@mforney.org>
    objtool: Update section header before relocations

Michael Forney <mforney@mforney.org>
    objtool: Check for gelf_update_rel[a] failures

Arnd Bergmann <arnd@arndb.de>
    bitfield: build kunit tests without structleak plugin

Brendan Higgins <brendanhiggins@google.com>
    thunderbolt: build kunit tests without structleak plugin

Brendan Higgins <brendanhiggins@google.com>
    device property: build kunit tests without structleak plugin

Brendan Higgins <brendanhiggins@google.com>
    iio/test-format: build kunit tests without structleak plugin

Brendan Higgins <brendanhiggins@google.com>
    gcc-plugins/structleak: add makefile var for disabling structleak

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx: Serialize GMU communication

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    kunit: fix reference count leak in kfree_at_end

Chenyi Qiang <chenyi.qiang@intel.com>
    KVM: MMU: Reset mmu->pkru_mask to avoid stale data

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix the max tx size according to user manual

Marek Vasut <marex@denx.de>
    drm: mxsfb: Fix NULL pointer dereference crash on unload

Peter Gonda <pgonda@google.com>
    KVM: SEV-ES: Set guest_state_protected after VMSA update

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: mcast: use multicast_membership_interval for IGMPv3

Florian Westphal <fw@strlen.de>
    selftests: netfilter: remove stray bash debug line

Vegard Nossum <vegard.nossum@gmail.com>
    netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Xiaolong Huang <butterflyhuangxx@gmail.com>
    isdn: cpai: check ctr->cnr to avoid array index out of bound

Lin Ma <linma@zju.edu.cn>
    nfc: nci: fix the UAF of rf_conn_info object

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: remove unnecessary arguments from complete_emulator_pio_in

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: split the two parts of emulator_pio_in

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: check for interrupts before deciding whether to exit the fast path

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: leave vcpu->arch.pio.count alone in emulator_pio_in_out

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SEV-ES: reduce ghcb_sa_len to 32 bits

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SEV-ES: go over the sev_pio_data buffer in multiple passes if needed

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SEV-ES: fix length of string I/O

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SEV-ES: keep INS functions together

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SEV-ES: clean up kvm_sev_es_ins/outs

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SEV-ES: rename guest_ins_data to sev_pio_data

Masahiro Kozuka <masa.koz@kozuka.jp>
    KVM: SEV: Flush cache on non-coherent systems before RECEIVE_UPDATE_DATA

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: promptly process interrupts delivered while in guest mode

Miaohe Lin <linmiaohe@huawei.com>
    mm, slub: fix incorrect memcg slab count for bulk free

Miaohe Lin <linmiaohe@huawei.com>
    mm, slub: fix potential use-after-free in slab_debugfs_fops

Miaohe Lin <linmiaohe@huawei.com>
    mm, slub: fix potential memoryleak in kmem_cache_open()

Miaohe Lin <linmiaohe@huawei.com>
    mm, slub: fix mismatch between reconstructed freelist depth and cnt

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/idle: Don't corrupt back chain when going idle

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Fix signal ucount refcounting

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Proper error handling in set_cred_ucounts

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Pair inc_rlimit_ucounts with dec_rlimit_ucoutns in commit_creds

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Move get_ucounts from cred_alloc_blank to key_change_session_keyring

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: correct ds->num_ports

Gaosheng Cui <cuigaosheng1@huawei.com>
    audit: fix possible null-pointer dereference in audit_filter_rules

Tejun Heo <tj@kernel.org>
    blk-cgroup: blk_cgroup_bio_start() should use irq-safe operations on blkg->iostat_cpu

Hans de Goede <hdegoede@redhat.com>
    ASoC: nau8824: Fix headphone vs headset, button-press detection no longer working

Takashi Iwai <tiwai@suse.de>
    ASoC: DAPM: Fix missing kctl change notifications

Steven Clarkson <sc@lambdal.com>
    ALSA: hda/realtek: Add quirk for Clevo PC50HS

Brendan Grieve <brendan@grieve.com.au>
    ALSA: usb-audio: Provide quirk for Sennheiser GSP670 Headset

Sean Christopherson <seanjc@google.com>
    mm/secretmem: fix NULL page->mapping dereference in page_is_secretmem()

Matthew Wilcox (Oracle) <willy@infradead.org>
    vfs: check fd has read access in kernel_read_file_from_fd()

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    elfcore: correct reference to CONFIG_UML

Eric Dumazet <edumazet@google.com>
    mm/mempolicy: do not allow illegal MPOL_F_NUMA_BALANCING | MPOL_LOCAL in mbind()

Nadav Amit <namit@vmware.com>
    userfaultfd: fix a race between writeprotect and exit_mmap()

Peter Xu <peterx@redhat.com>
    mm/userfaultfd: selftests: fix memory corruption with thp enabled

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    ocfs2: mount fails with buffer overflow in strlen

Jan Kara <jack@suse.cz>
    ocfs2: fix data corruption after conversion from inline format

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have all levels of checks prevent recursion

Jeff Layton <jlayton@kernel.org>
    ceph: fix handling of "meta" errors

Jeff Layton <jlayton@kernel.org>
    ceph: skip existing superblocks that are blocklisted or shut down when mounting

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: isotp: isotp_sendmsg(): add result check for wait_event_interruptible()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path

Zheyu Ma <zheyuma97@gmail.com>
    can: peak_pci: peak_pci_remove(): fix UAF

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    can: rcar_can: fix suspend/resume

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: make sure all traffic classes can send large frames

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: fix ethtool counter name for PM0_TERR

Anitha Chrisanthus <anitha.chrisanthus@intel.com>
    drm/kmb: Enable ADV bridge after modeset

Anitha Chrisanthus <anitha.chrisanthus@intel.com>
    drm/kmb: Corrected typo in handle_lcd_irq

Edmund Dea <edmund.j.dea@intel.com>
    drm/kmb: Disable change of plane parameters

Edmund Dea <edmund.j.dea@intel.com>
    drm/kmb: Remove clearing DPHY regs

Anitha Chrisanthus <anitha.chrisanthus@intel.com>
    drm/kmb: Work around for higher system clock

Dan Johansen <strit@manjaro.org>
    drm/panel: ilitek-ili9881c: Fix sync for Feixin K101-IM2BYL02 panel

Emeel Hakim <ehakim@nvidia.com>
    net/mlx5e: IPsec: Fix work queue entry ethernet segment checksum flags

Emeel Hakim <ehakim@nvidia.com>
    net/mlx5e: IPsec: Fix a misuse of the software parser's fields

Tony Nguyen <anthony.l.nguyen@intel.com>
    ice: Add missing E810 device ids

Sasha Neftin <sasha.neftin@intel.com>
    igc: Update I226_K device ID

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix packet loss on Tiger Lake and later

Yang Yingliang <yangyingliang@huawei.com>
    ptp: Fix possible memory leak in ptp_clock_register()

Kurt Kanzenbach <kurt@linutronix.de>
    net: stmmac: Fix E2E delay mechanism

Peng Li <lipeng321@huawei.com>
    net: hns3: disable sriov before unload hclge layer

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix vf reset workqueue cannot exit

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: schedule the polling again when allocation fails

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: add limit ets dwrr bandwidth cannot be 0

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: reset DWRR of unused tc to zero

Jiaran Zhang <zhangjiaran@huawei.com>
    net: hns3: Add configuration of TM QCN error event

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/smp: do not decrement idle task preempt count in CPU offline

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: dsa: Fix an error handling path in 'dsa_switch_parse_ports_of()'

Randy Dunlap <rdunlap@infradead.org>
    NIOS2: irqflags: rename a redefined register name

Paul Blakey <paulb@nvidia.com>
    net/sched: act_ct: Fix byte count on fragmented packets

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: dsa: lantiq_gswip: fix register definition

Randy Dunlap <rdunlap@infradead.org>
    hamradio: baycom_epp: fix build for UML

Stephen Suryaputra <ssuryaextr@gmail.com>
    ipv6: When forwarding count rx stats on the orig netdev

Leonard Crestez <cdleonard@gmail.com>
    tcp: md5: Fix overlap between vrf and non-vrf keys

Vegard Nossum <vegard.nossum@oracle.com>
    lan78xx: select CRC32

Xin Long <lucien.xin@gmail.com>
    sctp: fix transport encap_port update in sctp_vtag_verify

Antoine Tenart <atenart@kernel.org>
    netfilter: ipvs: make global sysctl readonly in non-init netns

Xin Long <lucien.xin@gmail.com>
    netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6

Brett Creeley <brett.creeley@intel.com>
    ice: Print the api_patch as part of the fw.mgmt.api

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: fix getting UDP tunnel entry

Dave Ertman <david.m.ertman@intel.com>
    ice: Avoid crash from unnecessary IDA free

Brett Creeley <brett.creeley@intel.com>
    ice: Fix failure to re-add LAN/RDMA Tx queues

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Fix clock configuration on slave mode

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    dma-debug: fix sg checks in debug_dma_map_sg()

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: skip netdev events generated on netns removal

Juhee Kang <claudiajkang@gmail.com>
    netfilter: xt_IDLETIMER: fix panic that occurs when timer_type has garbage value

Quentin Perret <qperret@google.com>
    KVM: arm64: Release mmap_lock when using VM_SHARED with MTE

Quentin Perret <qperret@google.com>
    KVM: arm64: Fix host stage-2 PGD refcount

Mark Brown <broonie@kernel.org>
    ASoC: cs4341: Add SPI device ID table

Mark Brown <broonie@kernel.org>
    ASoC: pcm179x: Add missing entries SPI to device ID table

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: Fix channel swap issue with ARC

Peter Rosin <peda@axentia.se>
    ASoC: pcm512x: Mend accesses to the I2S_1 and I2S_2 registers

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Emit stf barrier instruction sequences for BPF_NOSPEC

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/security: Add a helper to query stf_barrier type

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Validate branch ranges

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/lib: Add helper to check if offset is within conditional branch range

Benjamin Coddington <bcodding@redhat.com>
    NFSD: Keep existing listeners on portlist error

Guenter Roeck <linux@roeck-us.net>
    xtensa: xtfpga: Try software restart before simulating CPU reset

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: init iommu after amdkfd device init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: fix dependencies for DRM_AMD_DC_SI

Hayes Wang <hayeswang@realtek.com>
    r8152: avoid to resubmit rx immediately

Jan Beulich <jbeulich@suse.com>
    xen/x86: prevent PVH type from getting clobbered

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    block: decode QUEUE_FLAG_HCTX_ACTIVE in debugfs output

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default

Rob Herring <robh@kernel.org>
    arm: dts: vexpress-v2p-ca9: Fix the SMB unit-address

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: pgtable-3level: fix cast to pointer from integer of different size

Helge Deller <deller@gmx.de>
    parisc: math-emu: Fix fall-through warnings

Geert Uytterhoeven <geert@linux-m68k.org>
    block/mq-deadline: Move dd_queued() to fix defined but not used warning


-------------

Diffstat:

 Documentation/networking/devlink/ice.rst           |   9 +-
 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   1 +
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts        |   1 -
 arch/arm/boot/dts/spear3xx.dtsi                    |   2 +-
 arch/arm/boot/dts/vexpress-v2m.dtsi                |   2 +-
 arch/arm/boot/dts/vexpress-v2p-ca9.dts             |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/gfp.h              |   1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  13 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c               |  14 ++
 arch/arm64/kvm/mmu.c                               |   6 +-
 arch/nios2/include/asm/irqflags.h                  |   4 +-
 arch/nios2/include/asm/registers.h                 |   2 +-
 arch/parisc/math-emu/fpudispatch.c                 |  56 ++++++-
 arch/powerpc/include/asm/code-patching.h           |   1 +
 arch/powerpc/include/asm/security_features.h       |   5 +
 arch/powerpc/kernel/idle_book3s.S                  |  10 +-
 arch/powerpc/kernel/security.c                     |   5 +
 arch/powerpc/kernel/smp.c                          |   2 -
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  28 ++--
 arch/powerpc/lib/code-patching.c                   |   7 +-
 arch/powerpc/net/bpf_jit.h                         |  33 ++--
 arch/powerpc/net/bpf_jit64.h                       |   8 +-
 arch/powerpc/net/bpf_jit_comp.c                    |   6 +-
 arch/powerpc/net/bpf_jit_comp32.c                  |   8 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  63 +++++++-
 arch/s390/include/asm/pci.h                        |   2 +
 arch/s390/pci/pci.c                                |  48 +++++-
 arch/s390/pci/pci_event.c                          |   4 +-
 arch/sh/include/asm/pgtable-3level.h               |   2 +-
 arch/x86/events/msr.c                              |   1 +
 arch/x86/include/asm/kvm_host.h                    |   3 +-
 arch/x86/kvm/mmu/mmu.c                             |   6 +-
 arch/x86/kvm/svm/sev.c                             |  16 +-
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |  17 +-
 arch/x86/kvm/x86.c                                 | 150 ++++++++++++------
 arch/x86/xen/enlighten.c                           |   9 +-
 arch/xtensa/platforms/xtfpga/setup.c               |  12 +-
 block/blk-cgroup.c                                 |   5 +-
 block/blk-mq-debugfs.c                             |   1 +
 block/mq-deadline.c                                |  12 +-
 drivers/base/test/Makefile                         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +-
 drivers/gpu/drm/amd/display/Kconfig                |   2 +
 drivers/gpu/drm/kmb/kmb_crtc.c                     |  41 ++++-
 drivers/gpu/drm/kmb/kmb_drv.c                      |  10 +-
 drivers/gpu/drm/kmb/kmb_drv.h                      |  13 ++
 drivers/gpu/drm/kmb/kmb_dsi.c                      |  25 +--
 drivers/gpu/drm/kmb/kmb_dsi.h                      |   2 +-
 drivers/gpu/drm/kmb/kmb_plane.c                    | 122 +++++++++++++--
 drivers/gpu/drm/kmb/kmb_plane.h                    |  11 +-
 drivers/gpu/drm/kmb/kmb_regs.h                     |   3 +
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   6 +
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h              |   3 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  40 ++++-
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                  |   6 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c      |  12 +-
 drivers/iio/test/Makefile                          |   1 +
 drivers/input/keyboard/snvs_pwrkey.c               |  29 ++++
 drivers/isdn/capi/kcapi.c                          |   5 +
 drivers/isdn/hardware/mISDN/netjet.c               |   2 +-
 drivers/net/can/rcar/rcar_can.c                    |  20 ++-
 drivers/net/can/sja1000/peak_pci.c                 |   9 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   5 +-
 drivers/net/dsa/lantiq_gswip.c                     |   2 +-
 drivers/net/dsa/mt7530.c                           |   8 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   5 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  21 +++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  37 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   7 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   9 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   4 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  31 +++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   3 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  29 ++--
 drivers/net/ethernet/intel/ice/ice_common.c        |   2 +
 drivers/net/ethernet/intel/ice/ice_devids.h        |   4 +
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   3 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   9 ++
 drivers/net/ethernet/intel/ice/ice_main.c          |   8 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |  13 ++
 drivers/net/ethernet/intel/ice/ice_sched.h         |   1 +
 drivers/net/ethernet/intel/igc/igc_hw.h            |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   2 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  51 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  20 +--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  19 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h   |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-generic.c    |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +
 drivers/net/hamradio/baycom_epp.c                  |   6 +-
 drivers/net/phy/mdio_bus.c                         |   1 +
 drivers/net/usb/Kconfig                            |   1 +
 drivers/net/usb/r8152.c                            |  16 +-
 drivers/net/usb/usbnet.c                           |   4 +
 drivers/pci/hotplug/s390_pci_hpc.c                 |   9 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   4 +-
 drivers/platform/x86/intel_scu_ipc.c               |   4 +-
 drivers/ptp/ptp_clock.c                            |  15 +-
 drivers/scsi/hosts.c                               |   3 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   2 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |   2 -
 drivers/scsi/storvsc_drv.c                         |  32 ++--
 drivers/spi/spi-mux.c                              |   7 +
 drivers/spi/spi.c                                  |  27 ++--
 drivers/thunderbolt/Makefile                       |   1 +
 fs/autofs/waitq.c                                  |   2 +-
 fs/btrfs/tree-log.c                                |  47 +++---
 fs/ceph/caps.c                                     |  12 +-
 fs/ceph/file.c                                     |   1 -
 fs/ceph/inode.c                                    |   2 -
 fs/ceph/mds_client.c                               |  17 +-
 fs/ceph/super.c                                    |  17 +-
 fs/ceph/super.h                                    |   3 -
 fs/kernel_read_file.c                              |   2 +-
 fs/nfsd/nfsctl.c                                   |   5 +-
 fs/ocfs2/alloc.c                                   |  46 ++----
 fs/ocfs2/super.c                                   |  14 +-
 fs/userfaultfd.c                                   |  12 +-
 include/linux/elfcore.h                            |   2 +-
 include/linux/mlx5/driver.h                        |   1 -
 include/linux/secretmem.h                          |   2 +-
 include/linux/spi/spi.h                            |   3 +
 include/linux/trace_recursion.h                    |  49 ++----
 include/linux/user_namespace.h                     |   2 +
 include/net/sctp/sm.h                              |   6 +-
 include/sound/hda_codec.h                          |   1 +
 kernel/auditsc.c                                   |   2 +-
 kernel/cred.c                                      |   9 +-
 kernel/dma/debug.c                                 |  12 +-
 kernel/sched/core.c                                |   1 +
 kernel/signal.c                                    |  25 +--
 kernel/trace/ftrace.c                              |   4 +-
 kernel/ucount.c                                    |  49 ++++++
 lib/Makefile                                       |   2 +-
 lib/kunit/executor_test.c                          |   4 +-
 mm/huge_memory.c                                   |   6 +-
 mm/mempolicy.c                                     |  16 +-
 mm/slub.c                                          |  23 ++-
 net/bpf/test_run.c                                 |  14 +-
 net/bridge/br_private.h                            |   4 +-
 net/can/isotp.c                                    |  51 ++++--
 net/can/j1939/j1939-priv.h                         |   1 +
 net/can/j1939/main.c                               |   7 +-
 net/can/j1939/transport.c                          |  14 +-
 net/dsa/dsa2.c                                     |   9 +-
 net/ipv4/tcp_ipv4.c                                |  19 ++-
 net/ipv6/ip6_output.c                              |   3 +-
 net/ipv6/netfilter/ip6t_rt.c                       |  48 +-----
 net/netfilter/Kconfig                              |   2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   5 +
 net/netfilter/nft_chain_filter.c                   |   9 +-
 net/netfilter/xt_IDLETIMER.c                       |   2 +-
 net/nfc/nci/rsp.c                                  |   2 +
 net/sched/act_ct.c                                 |   2 +-
 scripts/Makefile.gcc-plugins                       |   4 +
 security/keys/process_keys.c                       |   8 +
 sound/hda/hdac_controller.c                        |   5 +-
 sound/pci/hda/hda_bind.c                           |  20 +--
 sound/pci/hda/hda_codec.c                          |   1 +
 sound/pci/hda/hda_controller.c                     |  24 ++-
 sound/pci/hda/hda_controller.h                     |   2 +-
 sound/pci/hda/hda_intel.c                          |  29 +++-
 sound/pci/hda/hda_intel.h                          |   4 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/Kconfig                           |   1 +
 sound/soc/codecs/cs4341.c                          |   7 +
 sound/soc/codecs/nau8824.c                         |   4 +-
 sound/soc/codecs/pcm179x-spi.c                     |   1 +
 sound/soc/codecs/pcm512x.c                         |   2 +
 sound/soc/codecs/wm8960.c                          |  13 +-
 sound/soc/fsl/fsl_xcvr.c                           |  17 +-
 sound/soc/soc-dapm.c                               |  13 +-
 sound/usb/quirks-table.h                           |  32 ++++
 tools/lib/perf/tests/test-evlist.c                 |   6 +-
 tools/lib/perf/tests/test-evsel.c                  |   7 +-
 tools/objtool/elf.c                                |  56 +++----
 tools/testing/selftests/net/forwarding/Makefile    |   1 +
 .../net/forwarding/forwarding.config.sample        |   2 +
 .../net/forwarding/ip6_forward_instats_vrf.sh      | 172 +++++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh      |   8 +
 tools/testing/selftests/netfilter/nft_flowtable.sh |   1 -
 tools/testing/selftests/vm/userfaultfd.c           |  23 ++-
 196 files changed, 1761 insertions(+), 731 deletions(-)


