Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659544556EA
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244508AbhKRI3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:29:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244304AbhKRI3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 03:29:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F4860184;
        Thu, 18 Nov 2021 08:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637223961;
        bh=3Av4we/Z9AWwCtrF2VUjwLF9VN+ZxaMSW/2OvmhLraA=;
        h=From:To:Cc:Subject:Date:From;
        b=anpAc6zVfw+BP5bovBLSVEoMn8xU1JOGolVhUfNxkRogLYI3/I9wdm1kqJh/lJr3e
         m2DMPSQ2qRg9n+iS2HtqHb2scylpT9Y4lxObt7/OPbYWHzCuhdKE0yTF5u2Z/TjbV0
         uIRLB272ZbldE8qfljahVs7O5lEVd7dZTKHFhxgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 000/920] 5.15.3-rc4 review
Date:   Thu, 18 Nov 2021 09:25:58 +0100
Message-Id: <20211118081919.507743013@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc4.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.3-rc4
X-KernelTest-Deadline: 2021-11-20T08:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.3 release.
There are 920 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 20 Nov 2021 08:14:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc4.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.3-rc4

Hans de Goede <hdegoede@redhat.com>
    media: videobuf2-dma-sg: Fix buf->vb NULL pointer dereference

Sergey Senozhatsky <senozhatsky@chromium.org>
    media: videobuf2: always set buffer vb2 pointer

Borislav Petkov <bp@suse.de>
    x86/sev: Make the #VC exception stacks part of the default stacks storage

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Add an x86 version of cc_platform_has()

Tom Lendacky <thomas.lendacky@amd.com>
    arch/cc: Introduce a function to check for confidential computing features

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Fix also no-alu32 strobemeta selftest

Borislav Petkov <bp@suse.de>
    selftests/x86/iopl: Adjust to the faked iopl CLI/STI usage

Colin Ian King <colin.king@canonical.com>
    mmc: moxart: Fix null pointer dereference on pointer host

Arnd Bergmann <arnd@arndb.de>
    ath10k: fix invalid dma_addr_t token assignment

Paulo Alcantara <pc@cjr.nz>
    cifs: fix memory leak of smb3_fs_context_dup::server_hostname

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vidtv: move kfree(dvb) to vidtv_bridge_dev_release()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Look at firmware version to determine using dmub on dcn21

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Partial revert of commit 6f9f17287e78

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix PCIe Max Payload Size setting

Pali Rohár <pali@kernel.org>
    PCI: Add PCI_EXP_DEVCTL_PAYLOAD_* macros

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: Fix macros in sun8i_csc.h

Xiaoming Ni <nixiaoming@huawei.com>
    powerpc/85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=n

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: ignore ibm, platform-facilities updates

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/interrupt: Fix check_return_regs_valid() false positive

Russell Currey <ruscur@russell.cc>
    powerpc/security: Use a mutex for interrupt exit code patching

Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
    powerpc/powernv/prd: Unregister OPAL_MSG_PRD2 notifier during module unload

Nicholas Piggin <npiggin@gmail.com>
    powerpc/32e: Ignore ESR in instruction storage interrupt handler

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/bpf: Fix write protecting JIT code

Gustavo A. R. Silva <gustavoars@kernel.org>
    powerpc/vas: Fix potential NULL pointer dereference

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: au1550nd: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: plat_nand: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: orion: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: pasemi: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: gpio: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: mpc5121: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: xway: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: ams-delta: Keep the driver compatible with on-die ECC engines

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: fsmc: Fix use of SM ORDER

Dong Aisheng <aisheng.dong@nxp.com>
    remoteproc: imx_rproc: Fix rsc-table name

Dong Aisheng <aisheng.dong@nxp.com>
    remoteproc: imx_rproc: Fix ignoring mapping vdev regions

Dong Aisheng <aisheng.dong@nxp.com>
    remoteproc: Fix the wrong default value of is_iomem

Peng Fan <peng.fan@nxp.com>
    remoteproc: elf_loader: Fix loading segment when is_iomem true

Halil Pasic <pasic@linux.ibm.com>
    s390/cio: make ccw_device_dma_* more robust

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix hanging ioctl caused by orphaned replies

Sven Schnelle <svens@linux.ibm.com>
    s390/tape: fix timer initialization in tape_std_assign()

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: check the subchannel validity for dev_busid

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpumf: cpum_cf PMU displays invalid value after hotplug remove

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Avoid calling put_device() under dpm_list_mtx

Coly Li <colyli@suse.de>
    bcache: Revert "bcache: use bvec_virt"

Coly Li <colyli@suse.de>
    bcache: fix use-after-free problem in bcache_device_free()

Marek Vasut <marex@denx.de>
    video: backlight: Drop maximum brightness override for brightness zero

Jack Andersen <jackoalan@gmail.com>
    mfd: dln2: Add cell for initializing DLN2 ADC

Rongwei Wang <rongwei.wang@linux.alibaba.com>
    mm, thp: fix incorrect unmap behavior for private pages

Rongwei Wang <rongwei.wang@linux.alibaba.com>
    mm, thp: lock filemap when truncating page cache

Michal Hocko <mhocko@suse.com>
    mm, oom: do not trigger out_of_memory from the #PF

Vasily Averin <vvs@virtuozzo.com>
    mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

Vasily Averin <vvs@virtuozzo.com>
    memcg: prohibit unconditional exceeding the limit of dying tasks

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm/filemap.c: remove bogus VM_BUG_ON

Dominique Martinet <asmadeus@codewreck.org>
    9p/net: fix missing error check in p9_check_errors

Daniel Borkmann <daniel@iogearbox.net>
    net, neigh: Enable state migration between NUD_PERMANENT and NTF_USE

Anatolij Gustschin <agust@denx.de>
    dmaengine: bestcomm: fix system boot lockups

Kishon Vijay Abraham I <kishon@ti.com>
    dmaengine: ti: k3-udma: Set r/tchan or rflow to NULL if request fail

Kishon Vijay Abraham I <kishon@ti.com>
    dmaengine: ti: k3-udma: Set bchan to NULL if a channel request fail

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: don't need 8byte alignment for request length in ksmbd_check_message

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: Fix buffer length check in fsctl_validate_negotiate_info()

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    block: Hold invalidate_lock in BLKRESETZONE ioctl

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    block: Hold invalidate_lock in BLKZEROOUT ioctl

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    block: Hold invalidate_lock in BLKDISCARD ioctl

Matthew Brost <matthew.brost@intel.com>
    drm/i915/guc: Fix blocked context accounting

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: fix unsafe pagevec reuse of hooked pclusters

Xiubo Li <xiubli@redhat.com>
    ceph: fix mdsmap decode when there are MDS's beyond max_mds

Dongliang Mu <mudongliangabcd@gmail.com>
    f2fs: fix UAF in f2fs_available_free_memory

Daeho Jeong <daehojeong@google.com>
    f2fs: include non-compressed blocks in compr_written_block

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: should use GFP_NOFS for directory inodes

Guo Ren <guoren@linux.alibaba.com>
    irqchip/sifive-plic: Fixup EOI failed when masked

Michael Pratt <mpratt@google.com>
    posix-cpu-timers: Clear task::posix_cputimers_work in copy_process()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: move guest_pv_has out of user_access section

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Destroy sysfs before freeing entries

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Move non-mask check back into low level accessors

Dave Jones <davej@codemonkey.org.uk>
    x86/mce: Add errata workaround for Skylake SKX37

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Fix assembly error from MIPSr2 code used within MIPS_ISA_ARCH_LEVEL

Masahiro Yamada <masahiroy@kernel.org>
    MIPS: fix *-pkg builds for loongson2ef platform

Masahiro Yamada <masahiroy@kernel.org>
    MIPS: fix duplicated slashes for Platform file path

John David Anglin <dave.anglin@bell.net>
    parisc: Flush kernel data mapping in set_pte_at() when installing pte for user page

Helge Deller <deller@gmx.de>
    parisc: Fix backtrace to always include init funtion names

Arnd Bergmann <arnd@arndb.de>
    ARM: 9156/1: drop cc-option fallbacks for architecture selection

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    ARM: 9155/1: fix early early_iounmap()

Steve French <stfrench@microsoft.com>
    smb3: do not error on fsync when readonly

Linus Torvalds <torvalds@linux-foundation.org>
    thermal: int340x: fix build on 32-bit targets

Willem de Bruijn <willemb@google.com>
    selftests/net: udpgso_bench_rx: fix port argument

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix eeprom len when diagnostics not implemented

Dust Li <dust.li@linux.alibaba.com>
    net/smc: fix sk_refcnt underflow on linkdown and fallback

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    vsock: prevent unnecessary refcnt inc for nonblocking connect

Marek Behún <kabel@kernel.org>
    net: marvell: mvpp2: Fix wrong SerDes reconfiguration order

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: ethernet: ti: cpsw_ale: Fix access to un-initialized memory

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: stmmac: allow a tc-taprio base-time of zero

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: allow configure ETS bandwidth of all TCs

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix kernel crash when unload VF while it is being reset

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix pfc packet number incorrect after querying pfc parameters

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix ROCE base interrupt vector initialization bug

Eric Dumazet <edumazet@google.com>
    net/sched: sch_taprio: fix undefined behavior in ktime_mono_to_any

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Don't support >1G speeds on 6191X on ports other than 10

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: fix uvd crash on Polaris12 during driver unloading

Muchun Song <songmuchun@bytedance.com>
    seq_file: fix passing wrong private data

Andrew Halaney <ahalaney@redhat.com>
    init: make unknown command line param message clearer

Imre Deak <imre.deak@intel.com>
    drm/i915/fb: Fix rounding error in subsampled plane size calculation

Dan Carpenter <dan.carpenter@oracle.com>
    gve: Fix off by one in gve_tx_timeout()

Arnd Bergmann <arnd@arndb.de>
    dmaengine: stm32-dma: avoid 64-bit division in stm32_dma_get_max_width

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-dma: fix burst in case of unaligned memory address

Jussi Maki <joamaki@gmail.com>
    bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg

John Fastabend <john.fastabend@gmail.com>
    bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Fix race in ingress receive verdict with redirect to self

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Remove unhash handler for BPF sockmap usage

Arnd Bergmann <arnd@arndb.de>
    arm64: pgtable: make __pte_to_phys/__phys_to_pte_val inline functions

Reiji Watanabe <reijiw@google.com>
    arm64: arm64_ftr_reg->name may not be a human-readable string

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    litex_liteeth: Fix a double free in the remove function

Chengfeng Ye <cyeaa@connect.ust.hk>
    nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails

Eric Dumazet <edumazet@google.com>
    llc: fix out-of-bound array index in llc_sk_dev_hash()

Ian Rogers <irogers@google.com>
    perf bpf: Add missing free to bpf_event__print_bpf_prog_info()

Dan Carpenter <dan.carpenter@oracle.com>
    zram: off by one in read_block_state()

Miaohe Lin <linmiaohe@huawei.com>
    mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_chip_start(): fix error handling for mcp251xfd_chip_rx_int_enable()

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: etas_es58x: es58x_rx_err_msg(): fix memory leak in error path

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/powerplay: fix sysfs_emit/sysfs_emit_at handling

Fabio Estevam <festevam@gmail.com>
    Revert "drm/imx: Annotate dma-fence critical section in commit path"

Arnd Bergmann <arnd@arndb.de>
    drm: fb_helper: improve CONFIG_FB dependency

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf/xdp_redirect_multi: Limit the tests in netns

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf/xdp_redirect_multi: Give tcpdump a chance to terminate cleanly

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf/xdp_redirect_multi: Use arping to accurate the arp number

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf/xdp_redirect_multi: Put the logs to tmp folder

Mehrdad Arshad Rad <arshad.rad@gmail.com>
    libbpf: Fix lookup_and_delete_elem_flags error reporting

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Fix device wakeup power reference counting error

Kai Song <songkai01@inspur.com>
    mfd: altera-sysmgr: Fix a mistake caused by resource_size conversion

Mark Brown <broonie@kernel.org>
    mfd: sprd: Add SPI device ID table

Mark Brown <broonie@kernel.org>
    mfd: cpcap: Add SPI device ID table

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    mfd: core: Add missing of_node_put for loop iteration

Takashi Iwai <tiwai@suse.de>
    ALSA: memalloc: Catch call with NULL snd_dma_buffer pointer

Arnd Bergmann <arnd@arndb.de>
    octeontx2-pf: select CONFIG_NET_DEVLINK

Huang Guobin <huangguobin4@huawei.com>
    bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed

Jason Gunthorpe <jgg@ziepe.ca>
    drm/ttm: remove ttm_bo_vm_insert_huge()

Luis Chamberlain <mcgrof@kernel.org>
    block: fix device_add_disk() kobject_create_and_add() error handling

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix duplex out of sync problem while changing settings

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Clear HWP desired on suspend/shutdown and offline

Selvin Xavier <selvin.xavier@broadcom.com>
    PCI: Do not enable AtomicOps on VFs

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    ataflop: remove ataflop_probe_lock mutex

Luis Chamberlain <mcgrof@kernel.org>
    block/ataflop: provide a helper for cleanup up an atari disk

Luis Chamberlain <mcgrof@kernel.org>
    block/ataflop: add registration bool before calling del_gendisk()

Luis Chamberlain <mcgrof@kernel.org>
    block/ataflop: use the blk_cleanup_disk() helper

Luis Chamberlain <mcgrof@kernel.org>
    nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned

Chenyuan Mi <cymi20@fudan.edu.cn>
    drm/nouveau/svm: Fix refcount leak bug and missing check against null bug

Andrea Righi <andrea.righi@canonical.com>
    selftests: net: properly support IPv6 in GSO GRE test

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: ufshpb: Properly handle max-single-cmd

Bean Huo <beanhuo@micron.com>
    scsi: ufs: core: Fix NULL pointer dereference

Daejun Park <daejun7.park@samsung.com>
    scsi: ufs: ufshpb: Use proper power management API

Jackie Liu <liuyun01@kylinos.cn>
    scsi: bsg: Fix errno when scsi_bsg_register_queue() fails

Luis Chamberlain <mcgrof@kernel.org>
    nvdimm/btt: do not call del_gendisk() if not needed

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    PCI: j721e: Fix j721e_pcie_probe() error path

Hans de Goede <hdegoede@redhat.com>
    ACPI: PMIC: Fix intel_pmic_regs_handler() read accesses

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Adopt scheduler's task classification

Brett Creeley <brett.creeley@intel.com>
    ice: Fix not stopping Tx queues for VFs

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    ice: Fix replacing VF hardware MAC to existing MAC filter

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: fix broken VLAN-tagged PTP under VLAN-aware bridge

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: vlan: fix a UAF in vlan_dev_real_dev()

Stafford Horne <shorne@gmail.com>
    openrisc: fix SMP tlb flush NULL pointer dereference

Jakub Kicinski <kuba@kernel.org>
    ethtool: fix ethtool msg len calculation for pause stats

Hangbin Liu <liuhangbin@gmail.com>
    kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile

Hangbin Liu <liuhangbin@gmail.com>
    kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile

Hangbin Liu <liuhangbin@gmail.com>
    kselftests/net: add missed SRv6 tests

Hangbin Liu <liuhangbin@gmail.com>
    kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile

Hangbin Liu <liuhangbin@gmail.com>
    kselftests/net: add missed icmp.sh test to Makefile

Maxim Kiselev <bigunclemax@gmail.com>
    net: davinci_emac: Fix interrupt pacing disable

Beld Zhang <beldzhang@gmail.com>
    io-wq: fix max-workers not correctly set on multi-node system

Yu Kuai <yukuai3@huawei.com>
    nbd: fix possible overflow for 'first_minor' in nbd_dev_add()

Yu Kuai <yukuai3@huawei.com>
    nbd: fix max value for 'first_minor'

YueHaibing <yuehaibing@huawei.com>
    xen-pciback: Fix return in pm_ctrl_init()

Sander Vanheule <sander@svanheule.net>
    gpio: realtek-otto: fix GPIO line IRQ offset

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: xlr: Fix a resource leak in the error handling path of 'xlr_i2c_probe()'

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: fix resource leak on dmaengine driver disable

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a regression in nfs_set_open_stateid_locked()

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix EDIF bsg

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Increase ELS payload

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Flush stale events and msgs on session down

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix app start delay

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix app start fail

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Turn off target reset during issue_lip

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix gnl list corruption

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Relogin during fabric disturbance

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: core: Remove from tmr_list during LUN unlink

Jackie Liu <liuyun01@kylinos.cn>
    ar7: fix kernel builds for compiler test

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: fix inaccurate report in WDIOC_GETTIMEOUT

Randy Dunlap <rdunlap@infradead.org>
    m68k: set a default value for MEMORY_RESERVE

Eric W. Biederman <ebiederm@xmission.com>
    signal/sh: Use force_sig(SIGKILL) instead of do_group_exit(SIGKILL)

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: reconfig device after device reset command

Dave Jiang <dave.jiang@intel.com>
    dmanegine: idxd: fix resource free ordering on driver removal

Dongliang Mu <mudongliangabcd@gmail.com>
    dmaengine: tegra210-adma: fix pm runtime unbalance

Lars-Peter Clausen <lars@metafoo.de>
    dmaengine: dmaengine_desc_callback_valid(): Check for `callback_result`

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: fix OOB when mac header was cleared

Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
    soc: fsl: dpaa2-console: free buffer before returning from dpaa2_console_read

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: ht16k33: Fix frame buffer device blanking

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: ht16k33: Connect backlight to fbdev

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: img-ascii-lcd: Fix lock-up when displaying empty string

Alexey Gladkov <legion@kernel.org>
    Fix user namespace leak

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix an Oops in pnfs_mark_request_commit()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up commit deadlocks

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-dma: fix stm32_dma_get_max_width

Claudiu Beznea <claudiu.beznea@microchip.com>
    dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro

Claudiu Beznea <claudiu.beznea@microchip.com>
    dmaengine: at_xdmac: call at_xdmac_axi_config() on resume path

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: rv3032: fix error handling in rv3032_clkout_set_rate()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    remoteproc: Fix a memory leak in an error handling path in 'rproc_handle_vdev()'

Zev Weiss <zev@bewilderbeest.net>
    mtd: core: don't remove debugfs directory if device is in use

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: arasan: Prevent an unsupported configuration

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    PCI: uniphier: Serialize INTx masking/unmasking and fix the bit operation

Evgeny Novikov <novikov@ispras.ru>
    mtd: spi-nor: hisi-sfc: Remove excessive clk_disable_unprepare()

Guido Günther <agx@sigxcpu.org>
    drm/bridge: nwl-dsi: Add atomic_get_input_bus_fmts

John Keeping <john@metanate.com>
    Input: st1232 - increase "wait ready" timeout

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: orangefs: fix error return code of orangefs_revalidate_lookup()

Kees Cook <keescook@chromium.org>
    sparc: Add missing "FORCE" target when using if_changed

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix deadlocks in nfs_scan_commit_list()

YueHaibing <yuehaibing@huawei.com>
    opp: Fix return in _opp_add_static_v2()

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix preserving PCI_EXP_RTCTL_CRSSVE flag on emulated bridge

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Don't spam about PIO Response Status

Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
    drm/plane-helper: fix uninitialized variable reference

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge/lontium-lt9611uxc: fix provided connector suport

Baptiste Lepers <baptiste.lepers@gmail.com>
    pnfs/flexfiles: Fix misplaced barrier in nfs4_ff_layout_prepare_ds

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix dentry verifier races

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Ignore the directory size when marking for revalidation

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't set NFS_INO_DATA_INVAL_DEFER and NFS_INO_INVALID_DATA

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Default change_attr_type to NFS4_CHANGE_TYPE_IS_UNDEFINED

Kewei Xu <kewei.xu@mediatek.com>
    i2c: mediatek: fixing the incorrect register offset

Mark Brown <broonie@kernel.org>
    Input: ariel-pwrbutton - add SPI device ID table

Mark Brown <broonie@kernel.org>
    rtc: mcp795: Add SPI ID table

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: move out percpu_ref_exit() to ensure it's outside submission

Heiner Kallweit <hkallweit1@gmail.com>
    i2c: i801: Use PCI bus rescan mutex to protect P2SB access

Dong Aisheng <aisheng.dong@nxp.com>
    remoteproc: imx_rproc: Fix TCM io memory type

Mark Brown <broonie@kernel.org>
    rtc: pcf2123: Add SPI ID table

Mark Brown <broonie@kernel.org>
    rtc: ds1390: Add SPI ID table

Mark Brown <broonie@kernel.org>
    rtc: ds1302: Add SPI ID table

J. Bruce Fields <bfields@redhat.com>
    nfsd: don't alloc under spinlock in rpc_parse_scope_id

Evgeny Novikov <novikov@ispras.ru>
    mtd: rawnand: intel: Fix potential buffer overflow in probe

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    rpmsg: Fix rpmsg_create_ept return when RPMSG config is not defined

Tom Rix <trix@redhat.com>
    apparmor: fix error check

Aharon Landau <aharonl@nvidia.com>
    RDMA/core: Require the driver to set the IOVA correctly during rereg_mr

Hans de Goede <hdegoede@redhat.com>
    power: supply: bq27xxx: Fix kernel crash on IRQ handler register error

Geert Uytterhoeven <geert+renesas@glider.be>
    mips: cm: Convert to bitfield API to fix out-of-bounds access

Parav Pandit <parav@nvidia.com>
    vdpa/mlx5: Fix clearing of VIRTIO_NET_F_MAC feature bit

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio_ring: check desc == NULL when using indirect with packed

Geert Uytterhoeven <geert@linux-m68k.org>
    serial: cpm_uart: Protect udbg definitions by CONFIG_SERIAL_CPM_CONSOLE

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: rsnd: Fix an error handling path in 'rsnd_node_count()'

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Modify the value of MAX_LP_MSG_LEN to meet hardware compatibility

Haoyue Xu <xuhaoyue1@hisilicon.com>
    RDMA/hns: Fix initial arm_st of CQ

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Correct configuring of switch inversion from ts-inv

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Don't provide __kernel_map_pages() without ARCH_SUPPORTS_DEBUG_PAGEALLOC

Logan Gunthorpe <logang@deltatee.com>
    iommu/dma: Fix incorrect error return on iommu deferred attach

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: oxfw: fix functional regression for Mackie Onyx 1640i in v5.14 or later

Denis Kirjanov <kda@linux-powerpc.org>
    powerpc/xmon: fix task state output

Bixuan Cui <cuibixuan@linux.alibaba.com>
    powerpc/44x/fsp2: add missing of_node_put

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/book3e: Fix set_memory_x() and set_memory_nx()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/nohash: Fix __ptep_set_access_flags() and ptep_set_wrprotect()

Andrej Shadura <andrew.shadura@collabora.co.uk>
    HID: u2fzero: properly handle timeouts in usb_submit_urb

Andrej Shadura <andrew.shadura@collabora.co.uk>
    HID: u2fzero: clarify error check and length calculations

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: clk-master: fix prescaler logic

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: clk-master: check if div or pres is zero

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: sam9x60-pll: use DIV_ROUND_CLOSEST_ULL

Anssi Hannula <anssi.hannula@bitwise.fi>
    serial: xilinx_uartps: Fix race condition causing stuck TX

Yang Yingliang <yangyingliang@huawei.com>
    phy: Sparx5 Eth SerDes: Fix return value check in sparx5_serdes_probe()

Sandeep Maheswaram <quic_c_sanm@quicinc.com>
    phy: qcom-snps: Correct the FSEL_MASK

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: qcom-qmp: another fix for the sc8180x PCIe definition

Dan Carpenter <dan.carpenter@oracle.com>
    phy: ti: gmii-sel: check of_get_address() for failure

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    phy: qcom-qusb2: Fix a memory leak on probe

Mark Brown <broonie@kernel.org>
    ASoC: topology: Fix stub for snd_soc_tplg_component_remove()

Rahul Tanwar <rtanwar@maxlinear.com>
    pinctrl: equilibrium: Fix function addition in multiple groups

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sdm845: Fix Qualcomm crypto engine bus clock

Bhupesh Sharma <bhupesh.sharma@linaro.org>
    arm64: dts: qcom: sdm845: Use RPMH_CE_CLK macro directly

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: pmi8994: Fix "eternal"->"external" typo in WLED node

Wan Jiabing <wanjiabing@vivo.com>
    soc: qcom: apr: Add of_node_put() before return

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: rpmhpd: fix sm8350_mxc's peer domain

Guru Das Srinagesh <quic_gurus@quicinc.com>
    firmware: qcom_scm: Fix error retval in __qcom_scm_is_call_available()

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: gadget: Skip resizing EP's TX FIFO if already resized

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/booke: Disable STRICT_KERNEL_RWX, DEBUG_PAGEALLOC and KFENCE

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: drd: reset current session before setting the new one

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: drd: fix dwc2_drd_role_sw_set when clock could be disabled

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: drd: fix dwc2_force_mode call in dwc2_ovr_init

Stefan Agner <stefan@agner.ch>
    serial: imx: fix detach/attach of serial console

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Wait for successful restart of SLI3 adapter during host sg_reset

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    scsi: ufs: ufshcd-pltfrm: Fix memory leak due to probe defer

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: bus: stop dereferencing invalid slave pointer

Nuno Sá <nuno.sa@analog.com>
    iio: adis: do not disabe IRQs in 'adis_init()'

Randy Dunlap <rdunlap@infradead.org>
    usb: typec: STUSB160X should select REGMAP_I2C

Yang Yingliang <yangyingliang@huawei.com>
    iio: buffer: Fix double-free in iio_buffers_alloc_sysfs_and_mask()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: socinfo: add two missing PMIC IDs

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: rpmhpd: Make power_on actually enable the domain

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Defer probe if request_threaded_irq() returns EPROBE_DEFER

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Correct some register default values

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Always configure both ASP TX channels

Olivier Moysan <olivier.moysan@foss.st.com>
    ARM: dts: stm32: fix AV96 board SAI2 pin muxing on stm32mp15

Olivier Moysan <olivier.moysan@foss.st.com>
    ARM: dts: stm32: fix SAI sub nodes register range

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    ARM: dts: stm32: fix STUSB1600 Type-C irq level on stm32mp15xx-dkx

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Reduce DHCOR SPI NOR frequency to 50 MHz

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: checker: Fix off-by-one bug in drive register check

Athira Rajeev <atrajeev@linux.vnet.ibm.cm>
    powerpc/perf: Fix cycles/instructions as PM_CYC/PM_INST_CMPL in power10

Andrew Halaney <ahalaney@redhat.com>
    dyndbg: make dyndbg a known cli param

Logan Gunthorpe <logang@deltatee.com>
    RDMA/core: Set sgtable nents when using ib_dma_virt_map_sg()

Vegard Nossum <vegard.nossum@oracle.com>
    staging: ks7010: select CRYPTO_HASH/CRYPTO_MICHAEL_MIC

Nikita Yushchenko <nikita.yoush@cogentembedded.com>
    staging: most: dim2: do not double-register the same device

Randy Dunlap <rdunlap@infradead.org>
    usb: musb: select GENERIC_PHY instead of depending on it

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Return missed an error if device doesn't support steering

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()

Yang Yingliang <yangyingliang@huawei.com>
    power: supply: max17040: fix null-ptr-deref in max17040_probe()

Jakob Hauser <jahau@rocketmail.com>
    power: supply: rt5033_battery: Change voltage values to µV

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: hid: fix error code in do_config()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Drop wrong use of ACPI_PTR()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/paravirt: correct preempt debug splat in vcpu_is_preempted()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc: fix unbalanced node refcount in check_kvm_guest()

Christophe Leroy <christophe.leroy@csgroup.eu>
    video: fbdev: chipsfb: use memset_io() instead of memset()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/mem: Fix arch/powerpc/mm/mem.c:53:12: error: no previous prototype for 'create_section_mapping'

Clément Léger <clement.leger@bootlin.com>
    clk: at91: check pmc node status before registering syscore ops

Dongliang Mu <mudongliangabcd@gmail.com>
    memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    soc/tegra: Fix an error handling path in tegra_powergate_power_up()

Mark Brown <broonie@kernel.org>
    iio: st_pressure_spi: Add missing entries SPI to device ID table

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: topology: do not power down primary core during topology removal

Andreas Kemnade <andreas@kemnade.info>
    arm: dts: omap3-gta04a4: accelerometer irq fix

Yang Yingliang <yangyingliang@huawei.com>
    driver core: Fix possible memory leak in device_link_add()

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()

Sumit Saxena <sumit.saxena@broadcom.com>
    scsi: megaraid_sas: Fix concurrent access to ISR between IRQ polling and real interrupt

Bart Van Assche <bvanassche@google.com>
    scsi: ufs: core: Stop clearing UNIT ATTENTIONS

Bean Huo <beanhuo@micron.com>
    scsi: ufs: core: Fix ufshcd_probe_hba() prototype to match the definition

Claudiu Beznea <claudiu.beznea@microchip.com>
    power: reset: at91-reset: check properly the return value of devm_of_iomap

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: debugfs: use controller id and link_id for debugfs

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix possible race at sync of urb completions

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Use position buffer for SKL+ again

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Reduce udelay() at SKL+ position reporting

David Stevens <stevensd@chromium.org>
    iommu/dma: Fix arch_sync_dma for map

David Stevens <stevensd@chromium.org>
    iommu/dma: Fix sync_sg with swiotlb

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: pm8916: Remove wrong reg-names for rtc@6000

Arnd Bergmann <arnd@arndb.de>
    iommu/mediatek: Fix out-of-range warning with clang

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: beacon: Fix Ethernet PHY mode

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Fix Secondary MI2S bit clock

Yassine Oudjana <y.oudjana@protonmail.com>
    ASoC: wcd9335: Use correct version to initialize Class H

Biju Das <biju.das.jz@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix missing port register 21h

Dongliang Mu <mudongliangabcd@gmail.com>
    JFS: fix memleak in jfs_mount

Jackie Liu <liuyun01@kylinos.cn>
    MIPS: loongson64: make CPU_LOONGSON64 depends on MIPS_FP_SUPPORT

Tong Zhang <ztong0001@gmail.com>
    scsi: dc395: Fix error case unwinding

Kuogee Hsieh <khsieh@codeaurora.org>
    arm64: dts: qcom: sc7280: fix display port phy reg property

Naina Mehta <nainmeht@codeaurora.org>
    soc: qcom: llcc: Disable MMUHWT retention

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sc7180: Base dynamic CPU power coefficients in reality

Peter Rosin <peda@axentia.se>
    ARM: dts: at91: tse850: the emac<->phy interface is rmii

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix timekeeping_suspended warning on resume

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: meson-sm1: Fix the pwm regulator supply properties

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: meson-g12b: Fix the pwm regulator supply properties

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: meson-g12a: Fix the pwm regulator supply properties

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: j7200-main: Fix "bus-range" upto 256 bus number for PCIe

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: j7200-main: Fix "vendor-id"/"device-id" properties of pcie node

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: k3-j721e-main: Fix "bus-range" upto 256 bus number for PCIe

Kishon Vijay Abraham I <kishon@ti.com>
    arm64: dts: ti: k3-j721e-main: Fix "max-virtual-functions" in PCIe EP nodes

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix query SRQ failure

Marijn Suijten <marijn.suijten@somainline.org>
    ARM: dts: qcom: msm8974: Add xo_board reference clock to DSI0 PHY

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Fix GPU register width for RK3328

Jackie Liu <liuyun01@kylinos.cn>
    ARM: s3c: irq-s3c24xx: Fix return value check for s3c24xx_init_intc()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix NVMe I/O failover to non-optimized path

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Use link event to wake up app

Ajish Koshy <Ajish.Koshy@microchip.com>
    scsi: pm80xx: Fix lockup in outbound queue management

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    clk: mvebu: ap-cpu-clk: Fix a memory leak in error handling paths

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: broadcom: bcm4908: Fix UART clock name

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Fix memory nodes names

Junji Wei <weijunji@bytedance.com>
    RDMA/rxe: Fix wrong port_cap_flags

Alexandru Ardelean <aardelean@deviqon.com>
    iio: st_sensors: disable regulators after device unregistration

Dongjin Kim <tobetter@gmail.com>
    arm64: dts: meson: sm1: add Ethernet PHY reset line for ODROID-C4/HC4

Pavel Skripkin <paskripkin@gmail.com>
    staging: r8188eu: fix memory leak in rtw_set_key

Hector.Yuan <hector.yuan@mediatek.com>
    cpufreq: Fix parameter in parse_perf_domain()

Frank Rowand <frank.rowand@sony.com>
    of: unittest: fix EXPECT text for gpio hog errors

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix propagation of signed bounds from 64-bit min/max into 32-bit.

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix propagation of bounds from 64-bit min/max into 32-bit and var_off.

Dan Schatzberg <schatzberg.dan@gmail.com>
    cgroup: Fix rootcg cpu.stat guest double counting

Liu Jian <liujian56@huawei.com>
    skmsg: Lose offset info in sk_psock_skb_ingress

Geliang Tang <geliang.tang@suse.com>
    selftests: mptcp: fix proto type in link_failure tests

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: delay complete()

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Process crqs after enabling interrupts

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: don't stop queue in xmit

Jakub Kicinski <kuba@kernel.org>
    udp6: allow SO_MARK ctrl msg to affect routing

Andrea Righi <andrea.righi@canonical.com>
    selftests/bpf: Fix fclose/pclose mismatch in test_progs

Daniel Jordan <daniel.m.jordan@oracle.com>
    crypto: pcrypt - Delay write to padata->info

Nikolay Aleksandrov <nikolay@nvidia.com>
    selftests: net: bridge: update IGMP/MLD membership interval value

Ivan Vecera <ivecera@redhat.com>
    net: bridge: fix uninitialized variables when BRIDGE_CFM is disabled

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: avoid mvneta warning when setting pause parameters

Yinjun Zhang <yinjun.zhang@corigine.com>
    nfp: fix potential deadlock when canceling dim work

Yinjun Zhang <yinjun.zhang@corigine.com>
    nfp: fix NULL pointer access when scheduling dim work

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ipmi: kcs_bmc: Fix a memory leak in the error handling path of 'kcs_bmc_serio_add_device()'

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Toggle PLL settings during rate change

Xin Long <lucien.xin@gmail.com>
    sctp: return true only for pathmtu update in sctp_transport_pl_toobig

Xin Long <lucien.xin@gmail.com>
    sctp: subtract sctphdr len in sctp_transport_pl_hlen

Xin Long <lucien.xin@gmail.com>
    sctp: reset probe_timer in sctp_transport_pl_update

Xin Long <lucien.xin@gmail.com>
    sctp: allow IP fragmentation when PLPMTUD enters Error state

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    selftests/bpf: Fix memory leak in test_ima

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    selftests/bpf: Fix fd cleanup in sk_lookup test

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc6: fix DMA mask from 44 to 40 bits

Lang Yu <lang.yu@amd.com>
    drm/amdgpu: fix a potential memory leak in amdgpu_device_fini_sw()

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Channel list update before hardware scan

Eric Dumazet <edumazet@google.com>
    bpf: Fixes possible race in update_prog_stats() for 32bit arches

Eric Dumazet <edumazet@google.com>
    bpf: Avoid races in __bpf_prog_run() for 32bit arches

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix discarded frames due to wrong sequence number

Benjamin Li <benl@squareup.com>
    wcn36xx: add proper DMA memory barriers in rx path

Wang Hai <wanghai38@huawei.com>
    libertas: Fix possible memory leak in probe and disconnect

Wang Hai <wanghai38@huawei.com>
    libertas_tf: Fix possible memory leak in probe and disconnect

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: Fix handle_sske page fault handling

Tiezhu Yang <yangtiezhu@loongson.cn>
    samples/kretprobes: Fix return value if register_kretprobe() failed

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    spi: spi-rpc-if: Check return value of rpcif_sw_init()

Zhang Rui <rui.zhang@intel.com>
    cpufreq: intel_pstate: Fix cpu->pstate.turbo_freq initialization

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    tracing: Fix missing trace_boot_init_histograms kstrdup NULL checks

Jon Maxwell <jmaxwell37@gmail.com>
    tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()

Ilya Leoshkevich <iii@linux.ibm.com>
    libbpf: Fix endianness detection in BPF_CORE_READ_BITFIELD_PROBED()

Mark Brown <broonie@kernel.org>
    tpm_tis_spi: Add missing SPI ID

Hao Wu <hao.wu@rubrik.com>
    tpm: fix Atmel TPM crash caused by too frequent queries

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix off-by-one bug in bpf_core_apply_relo()

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: synchronize blkg creation against policy deactivation

Michael Schmitz <schmitzmic@gmail.com>
    block: ataflop: more blk-mq refactoring fixes

Abinaya Kalaiselvan <akalaise@codeaurora.org>
    ath10k: fix module load regression with iram-recovery feature

Arnd Bergmann <arnd@arndb.de>
    ARM: 9142/1: kasan: work around LPAE build warning

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: avoid refcount warnings when ->port_{fdb,mdb}_del returns error

Mark Rutland <mark.rutland@arm.com>
    irq: mips: avoid nested irq_enter()

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: pv: avoid stalls for kvm_s390_pv_init_vm

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: pv: avoid double free of sida page

David Hildenbrand <david@redhat.com>
    s390/uv: fully validate the VMA before calling follow_page()

David Hildenbrand <david@redhat.com>
    s390/mm: fix VMA and page table handling code in storage key handling functions

David Hildenbrand <david@redhat.com>
    s390/mm: validate VMA in PGSTE manipulation functions

David Hildenbrand <david@redhat.com>
    s390/gmap: don't unconditionally call pte_unmap_unlock() in __gmap_zap()

David Hildenbrand <david@redhat.com>
    s390/gmap: validate VMA in __gmap_zap()

Nick Hainke <vincent@systemli.org>
    mt76: mt7615: mt7622: fix ibss and meshpoint

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix BTF header parsing checks

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix overflow in BTF sanity checks

Quentin Monnet <quentin@isovalent.com>
    bpftool: Avoid leaking the JSON writer prepared for program metadata

Mauricio Vásquez <mauricio@kinvolk.io>
    libbpf: Fix memory leak in btf__dedup()

Jim Mattson <jmattson@google.com>
    KVM: selftests: Fix nested SVM tests when built with clang

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: use netlbl_cfg_cipsov4_del() for deleting cipso_v4_doi

Horia Geantă <horia.geanta@nxp.com>
    crypto: tcrypt - fix skcipher multi-buffer tests for 1420B blocks

Jessica Zhang <jesszhan@codeaurora.org>
    drm/msm/dsi: fix wrong type in msm_dsi_host

Jessica Zhang <jesszhan@codeaurora.org>
    drm/msm: Fix potential NULL dereference in DPU SSPP

Joerg Roedel <jroedel@suse.de>
    x86/sev: Fix stack type check in vc_switch_off_ist()

Kees Cook <keescook@chromium.org>
    clocksource/drivers/timer-ti-dm: Select TIMER_OF

Anders Roxell <anders.roxell@linaro.org>
    PM: hibernate: fix sparse warnings

Max Gurtovoy <mgurtovoy@nvidia.com>
    nvme-rdma: fix error code in nvme_rdma_setup_ctrl

Ye Bin <yebin10@huawei.com>
    nbd: Fix use-after-free in pid_show

Stefan Agner <stefan@agner.ch>
    phy: micrel: ksz8041nl: do not use power down mode

Tim Gardner <tim.gardner@canonical.com>
    net: enetc: unmap DMA in enetc_send_cmd()

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pnvm: read EFI data only if long enough

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pnvm: don't kmemdup() more than we have

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: reset PM state on unsuccessful resume

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Send DELBA requests according to spec

Ziyang Xuan <william.xuanziyang@huawei.com>
    rsi: stop thread firstly in rsi_91x_init() error handling

Shayne Chen <shayne.chen@mediatek.com>
    mt76: mt7915: fix muar_idx in mt7915_mcu_alloc_sta_req()

Shayne Chen <shayne.chen@mediatek.com>
    mt76: mt7915: fix sta_rec_wtbl tag len

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: connac: fix possible NULL pointer dereference in mt76_connac_get_phy_mode_v2

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7615: fix monitor mode tear down crash

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix retrying release semaphore without end

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: fix possible infinite loop release semaphore

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7615: fix hwmon temp sensor mem use-after-free

Ben Greear <greearb@candelatech.com>
    mt76: mt7915: fix hwmon temp sensor mem use-after-free

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: always wake device if necessary in debugfs

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix kernel warning from cfg80211_calculate_bitrate

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix firmware usage of RA info using legacy rates

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: report HE MU radiotap

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: overwrite default reg_ops if necessary

Leon Yen <Leon.Yen@mediatek.com>
    mt76: connac: fix GTK rekey offload failure on WPA mixed mode

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921: fix dma hang in rmmod

Shayne Chen <shayne.chen@mediatek.com>
    mt76: mt7915: fix bit fields for HT rate idx

Shayne Chen <shayne.chen@mediatek.com>
    mt76: mt7915: fix potential overflow of eeprom page index

Deren Wu <deren.wu@mediatek.com>
    mt76: mt7921: Fix out of order process by invalid event pkt

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt76x02: fix endianness warnings in mt76x02_mac.c

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: fix survey-dump reporting

Sean Wang <sean.wang@mediatek.com>
    mt76: fix build error implicit enumeration conversion

Leon Yen <Leon.Yen@mediatek.com>
    mt76: connac: fix mt76_connac_gtk_rekey_tlv usage

Dan Carpenter <dan.carpenter@oracle.com>
    mt76: mt7915: fix info leak in mt7915_mcu_set_pre_cal()

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix endianness warning in mt7615_mac_write_txwi

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: fix endianness warning in mt7921_update_txs

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: fix endianness warning in mt7915_mac_add_txs_skb

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: fix endianness in mt7921_mcu_tx_done_event

Lang Yu <lang.yu@amd.com>
    drm/amdkfd: Fix an inappropriate error handling in allloc memory of gpu

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Fix sharing of wakeup power resources

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Turn off unused wakeup power resources

Fei Shao <fshao@chromium.org>
    mailbox: mtk-cmdq: Fix local clock ID usage

Fei Shao <fshao@chromium.org>
    mailbox: mtk-cmdq: Validate alias_id on probe

Nathan Chancellor <nathan@kernel.org>
    platform/x86: thinkpad_acpi: Fix bitwise vs. logical warning

Andrea Righi <andrea.righi@canonical.com>
    blk-wbt: prevent NULL pointer dereference in wb_timer_fn

Michael Schmitz <schmitzmic@gmail.com>
    block: ataflop: fix breakage introduced at blk-mq refactoring

Bixuan Cui <cuibixuan@huawei.com>
    io-wq: Remove duplicate code in io_workqueue_create()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: mxs-mmc: disable regulator on error and in the remove function

Sean Young <sean@mess.org>
    media: ir_toy: assignment to be16 should be of correct type

Randy Dunlap <rdunlap@infradead.org>
    media: ivtv: fix build for UML

jason-jh.lin <jason-jh.lin@mediatek.com>
    mailbox: Remove WARN_ON for async_cb.cb in cmdq_exec_done

Jackie Liu <liuyun01@kylinos.cn>
    thermal/drivers/qcom/lmh: make QCOM_LMH depends on QCOM_SCM

Jakub Kicinski <kuba@kernel.org>
    net: stream: don't purge sk_error_queue in sk_stream_kill_queues()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: uninitialized variable in msm_gem_import()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: fix potential NULL dereference in cleanup

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: unlock on error in get_sched_entity()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: potential error pointer dereference in init()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: Fix potential Oops in a6xx_gmu_rpmh_init()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: do not enable irq handler before powering up the host

Ziyang Xuan <william.xuanziyang@huawei.com>
    thermal/core: fix a UAF bug in __thermal_cooling_device_register()

Ovidiu Panait <ovidiu.panait@windriver.com>
    crypto: octeontx2 - set assoclen in aead_do_fallback()

Eric Dumazet <edumazet@google.com>
    tcp: switch orphan_count to bare per-cpu counters

Randy Dunlap <rdunlap@infradead.org>
    net: tulip: winbond-840: fix build for UML

Randy Dunlap <rdunlap@infradead.org>
    net: intel: igc_ptp: fix build for UML

Randy Dunlap <rdunlap@infradead.org>
    net: fealnx: fix build for UML

Zhang Qiao <zhangqiao22@huawei.com>
    kernel/sched: Fix sched_fork() access an invalid sched_task_group

Sven Eckelmann <seckelmann@datto.com>
    ath10k: fix max antenna gain unit

Zev Weiss <zev@bewilderbeest.net>
    hwmon: (pmbus/lm25066) Let compiler determine outer dimension of lm25066_coeff

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: Fix possible memleak in __hwmon_device_register()

Daniel Borkmann <daniel@iogearbox.net>
    net, neigh: Fix NTF_EXT_LEARNED in combination with NTF_USE

Dan Carpenter <dan.carpenter@oracle.com>
    memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()

Arnd Bergmann <arnd@arndb.de>
    memstick: avoid out-of-range warning

Tony Lindgren <tony@atomide.com>
    mmc: sdhci-omap: Fix context restore

Tony Lindgren <tony@atomide.com>
    mmc: sdhci-omap: Fix NULL pointer exception if regulator is not configured

Catherine Sullivan <csully@google.com>
    gve: Track RX buffer allocation failures

John Fraker <jfraker@google.com>
    gve: Recover from queue stall due to missed IRQ

Dan Carpenter <dan.carpenter@oracle.com>
    b43: fix a lower bounds test

Dan Carpenter <dan.carpenter@oracle.com>
    b43legacy: fix a lower bounds test

liqiong <liqiong@nfschina.com>
    ima: fix deadlock when traversing "ima_default_rules".

Markus Schneider-Pargmann <msp@baylibre.com>
    hwrng: mtk - Force runtime pm ops for sleep ops

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - disregard spurious PFVF interrupts

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - detect PFVF collision after ACK

Arnd Bergmann <arnd@arndb.de>
    crypto: ccree - avoid out-of-range warnings from clang

Evgeny Novikov <novikov@ispras.ru>
    media: dvb-frontends: mn88443x: Handle errors of clk_prepare_enable()

Mansur Alisha Shaik <mansur@codeaurora.org>
    media: venus: fix vpp frequency calculation for decoder

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: relax superfluous check on set updates

Peter Zijlstra <peterz@infradead.org>
    rcu: Fix rcu_dynticks_curr_cpu_in_eqs() vs noinstr

Peter Zijlstra <peterz@infradead.org>
    rcu: Always inline rcu_dynticks_task*_{enter,exit}()

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/amd64: Handle three rank interleaving mode

Borislav Petkov <bp@suse.de>
    x86/insn: Use get_unaligned() instead of memcpy()

Vincent Donnefort <vincent.donnefort@arm.com>
    PM: EM: Fix inefficient states detection

Linus Lüssing <ll@simonwunderlich.de>
    ath9k: Fix potential interrupt storm on queue reset

Stephen Boyd <swboyd@chromium.org>
    ath10k: Don't always treat modem stop events as crashes

Colin Ian King <colin.king@canonical.com>
    media: em28xx: Don't use ops->suspend if it is NULL

Anel Orazgaliyeva <anelkz@amazon.de>
    cpuidle: Fix kobject memory leaks in error paths

Arnd Bergmann <arnd@arndb.de>
    drm: fb_helper: fix CONFIG_FB dependency

Arnd Bergmann <arnd@arndb.de>
    crypto: ecc - fix CRYPTO_DEFAULT_RNG dependency

Punit Agrawal <punitagrawal@gmail.com>
    kprobes: Do not use local variable when creating debugfs file

Yee Lee <yee.lee@mediatek.com>
    scs: Release kasan vmalloc poison in scs_free process

Eugen Hristev <eugen.hristev@microchip.com>
    media: atmel: fix the ispck initialization

Colin Ian King <colin.king@canonical.com>
    media: cx23885: Fix snd_card_free call on null card pointer

Kees Cook <keescook@chromium.org>
    media: tm6000: Avoid card name truncation

Kees Cook <keescook@chromium.org>
    media: si470x: Avoid card name truncation

Kees Cook <keescook@chromium.org>
    media: radio-wl1273: Avoid card name truncation

Ondrej Jirman <megous@megous.com>
    media: sun6i-csi: Allow the video device to be open multiple times

Randy Dunlap <rdunlap@infradead.org>
    media: i2c: ths8200 needs V4L2_ASYNC

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: imx-jpeg: Fix the error handling path of 'mxc_jpeg_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: mtk-vpu: Fix a resource leak in the error handling path of 'mtk_vpu_probe()'

Tom Rix <trix@redhat.com>
    media: TDA1997x: handle short reads of hdmi info frame.

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: mtk-vcodec: venc: fix return value when start_streaming fails

Ricardo Ribalda <ribalda@chromium.org>
    media: v4l2-ioctl: S_CTRL output the right value

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx258: Fix getting clock frequency

Pavel Skripkin <paskripkin@gmail.com>
    media: dvb-usb: fix ununit-value in az6027_rc_query

Evgeny Novikov <novikov@ispras.ru>
    media: ttusb-dec: avoid release of non-acquired mutex

Colin Ian King <colin.king@canonical.com>
    media: cxd2880-spi: Fix a null pointer dereference on error handling path

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: meson-ge2d: Fix rotation parameter changes detection in 'ge2d_s_ctrl()'

Pavel Skripkin <paskripkin@gmail.com>
    media: em28xx: add missing em28xx_close_extension

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    libbpf: Fix skel_internal.h to set errno on loader retval < 0

Arnd Bergmann <arnd@arndb.de>
    drm/amdgpu: fix warning for overflow check

Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>
    arm64: mm: update max_pfn after memory hotplug

Matthew Auld <matthew.auld@intel.com>
    drm/ttm: stop calling tt_swapin in vm_access

Fabio Estevam <festevam@denx.de>
    ath10k: sdio: Add missing BH locking around napi_schdule()

Loic Poulain <loic.poulain@linaro.org>
    ath10k: Fix missing frame timestamp for beacon/probe-resp

Arnd Bergmann <arnd@arndb.de>
    gve: DQO: avoid unused variable warnings

Baochen Qiang <bqiang@codeaurora.org>
    ath11k: Fix memory leak in ath11k_qmi_driver_event_work

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
    ath11k: fix packet drops due to incorrect 6 GHz freq value in rx status

Sriram R <srirrama@codeaurora.org>
    ath11k: Avoid race during regd updates

Dan Carpenter <dan.carpenter@oracle.com>
    ath11k: fix some sleeping in atomic bugs

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf/tests: Fix error in tail call limit tests

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366: Fix a bug in deleting VLANs

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: rtl8366rb: Fix off-by-one bug

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Accept devlink user input after driver initialization complete

Johannes Berg <johannes.berg@intel.com>
    cfg80211: always free wiphy specific regdomain

Johannes Berg <johannes.berg@intel.com>
    mac80211: twt: don't use potentially unaligned pointer

Kees Cook <keescook@chromium.org>
    fortify: Fix dropped strcpy() compile-time write overflow check

Florian Westphal <fw@strlen.de>
    mptcp: do not shrink snd_nxt when recovering

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()

Leon Romanovsky <leon@kernel.org>
    qed: Don't ignore devlink allocation failures

Leon Romanovsky <leon@kernel.org>
    bnxt_en: Check devlink allocation and registration status

Hans de Goede <hdegoede@redhat.com>
    Bluetooth: hci_h5: Fix (runtime)suspend issues on RTL8723BS HCIs

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - power up 4xxx device

Michael Walle <michael@walle.cc>
    crypto: caam - disable pkc for non-E SoCs

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: move amdgpu_virt_release_full_gpu to fini_early stage

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Pass display_pipe_params_st as const in DML

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: Fix crash on device remove/driver unload

Dinghao Liu <dinghao.liu@zju.edu.cn>
    Bluetooth: btmtkuart: fix a memleak in mtk_hci_wmt_sync

Ajay Singh <ajay.kathat@microchip.com>
    wilc1000: fix possible memory leak in cfg_scan_result()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Fix Antenna Diversity Switching

Waiman Long <longman@redhat.com>
    cgroup: Make rebind_subsystems() disable v2 controllers all at once

Yoshitaka Ikeda <ikeda@nskint.co.jp>
    spi: Fixed division by zero warning

Alex Bee <knaerzche@gmail.com>
    drm: bridge: it66121: Fix return value it66121_probe

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: don't call netif_carrier_off() with NULL netdev

Yajun Deng <yajun.deng@linux.dev>
    net: net_namespace: Fix undefined member in key_remove_domain()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    lockdep: Let lock_is_held_type() detect recursive read as read

liuyuntao <liuyuntao10@huawei.com>
    virtio-gpu: fix possible memory allocation failure

Nathan Chancellor <nathan@kernel.org>
    crypto: sm4 - Do not change section of ck and sbox

Iago Toral Quiroga <itoral@igalia.com>
    drm/v3d: fix wait for TMU write combiner flush

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Publish and unpublish all devlink parameters at once

Peter Zijlstra <peterz@infradead.org>
    objtool: Handle __sanitize_cov*() tail calls

Peter Zijlstra <peterz@infradead.org>
    x86/xen: Mark cpu_bringup_and_idle() as dead_end_function

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: fix burst length for DEU

Neeraj Upadhyay <neeraju@codeaurora.org>
    rcu: Fix existing exp request check in sync_sched_exp_online_cleanup()

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: hci_uart: fix GPF in h5_recv

Toke Høiland-Jørgensen <toke@redhat.com>
    libbpf: Don't crash on object files with no symbol tables

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: fix init and cleanup of sco_conn.timeout_work

Paul Cercueil <paul@crapouillou.net>
    drm/bridge: it66121: Wait for next bridge to be probed

Paul Cercueil <paul@crapouillou.net>
    drm/bridge: it66121: Initialize {device,vendor}_ids

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix Intel SPR M3UPI event constraints

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix Intel SPR M2PCIE event constraints

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix Intel SPR IIO event constraints

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix Intel SPR CHA event constraints

Robert Foss <robert.foss@linaro.org>
    drm/bridge: anx7625: Propagate errors from sp_tx_rst_aux()

Imre Deak <imre.deak@intel.com>
    fbdev/efifb: Release PCI device's runtime PM ref during FB destroy

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Fix strobemeta selftest regression

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: set on IPS_ASSURED if flows enters internal stream state

Sven Schnelle <svens@stackframe.org>
    parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling

Sven Schnelle <svens@stackframe.org>
    parisc/unwind: fix unwinder when CONFIG_64BIT is enabled

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: don't trigger WARN() when decompression fails

Helge Deller <deller@gmx.de>
    task_stack: Fix end_of_stack() for architectures with upwards-growing stack

Sven Schnelle <svens@stackframe.org>
    parisc: fix warning in flush_tlb_all

Stephane Eranian <eranian@google.com>
    perf/x86/intel: Fix ICL/SPR INST_RETIRED.PREC_DIST encodings

Shuah Khan <skhan@linuxfoundation.org>
    selftests/core: fix conflicting types compile error for close_range()

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/display: dcn20_resource_construct reduce scope of FPU enabled

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/hyperv: Protect set_hv_tscchange_cb() against getting preempted

Eric Dumazet <edumazet@google.com>
    inet: remove races in inet{6}_getname()

王贇 <yun.wang@linux.alibaba.com>
    ftrace: do CPU checking after preemption disabled

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    Revert "wcn36xx: Enable firmware link monitoring"

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix packet drop on resume

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Correct band/freq reporting on RX

Yang Yingliang <yangyingliang@huawei.com>
    spi: bcm-qspi: Fix missing clk_disable_unprepare() on error in bcm_qspi_probe()

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not take the uuid_mutex in btrfs_rm_device

Sidong Yang <realwakka@gmail.com>
    btrfs: reflink: initialize return value to 0 in btrfs_extent_same()

Hui Wang <hui.wang@canonical.com>
    ACPI: resources: Add one more Medion model in IRQ override quirk

Stefan Schaeckeler <schaecsn@gmx.net>
    ACPI: AC: Quirk GK45 to skip reading _PSR

Eric Dumazet <edumazet@google.com>
    net: annotate data-race in neigh_output()

Florian Westphal <fw@strlen.de>
    vrf: run conntrack only in context of lower/physdev for locally generated packets

Viktor Rosendahl <Viktor.Rosendahl@bmw.de>
    tools/latency-collector: Use correct size when writing queue_full_warning

Arnd Bergmann <arnd@arndb.de>
    ARM: 9136/1: ARMv7-M uses BE-8, not BE-32

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix glock_hash_walk bugs

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Cancel remote delete work asynchronously

Marc Kleine-Budde <mkl@pengutronix.de>
    can: bittiming: can_fixup_bittiming(): change type of tseg1 and alltseg to unsigned int

Stephen Suryaputra <ssuryaextr@gmail.com>
    gre/sit: Don't generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE

Masami Hiramatsu <mhiramat@kernel.org>
    ARM: clang: Do not rely on lr register for stacktrace

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: use __GFP_NOFAIL for smk_cipso_doi()

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: disable RX-diversity in powersave

Jiri Olsa <jolsa@redhat.com>
    selftests/bpf: Fix perf_buffer test on system with offline cpus

Shuah Khan <skhan@linuxfoundation.org>
    selftests: kvm: fix mismatched fclose() after popen()

Ye Bin <yebin10@huawei.com>
    PM: hibernate: Get block device exclusively in swsusp_check()

Nick Desaulniers <ndesaulniers@google.com>
    arm64: vdso32: suppress error message for 'make mrproper'

David Yang <davidcomponentone@gmail.com>
    samples/bpf: Fix application of sizeof to pointer

Hannes Reinecke <hare@suse.de>
    nvme: drop scan_lock and always kick requeue list when removing namespaces

Israel Rukshin <israelr@nvidia.com>
    nvmet-tcp: fix use-after-free when a port is removed

Israel Rukshin <israelr@nvidia.com>
    nvmet-rdma: fix use-after-free when a port is removed

Israel Rukshin <israelr@nvidia.com>
    nvmet: fix use-after-free when a port is removed

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: properly handle sclk for profiling modes on vangogh

Michael Tretter <m.tretter@pengutronix.de>
    media: allegro: ignore interrupt if mailbox is not initialized

Jens Axboe <axboe@kernel.dk>
    block: remove inaccurate requeue check

Yaara Baruch <yaara.baruch@intel.com>
    iwlwifi: change all JnP to NO-160 configuration

Zheyu Ma <zheyuma97@gmail.com>
    mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: fix an off-by-one bound check

Kalesh Singh <kaleshsingh@google.com>
    tracing/cfi: Fix cmp_entries_* functions signature mismatch

Menglong Dong <imagedong@tencent.com>
    workqueue: make sysfs of unbound kworker cpumask more clever

Lasse Collin <lasse.collin@tukaani.org>
    lib/xz: Validate the value before assigning it to an enum variable

Lasse Collin <lasse.collin@tukaani.org>
    lib/xz: Avoid overlapping memcpy() with invalid input with in-place decompression

Yanfei Xu <yanfei.xu@windriver.com>
    locking/rwsem: Disable preemption for spinning region

Zheyu Ma <zheyuma97@gmail.com>
    memstick: r592: Fix a UAF bug when removing the driver

Xiao Ni <xni@redhat.com>
    md: update superblock after changing rdev flags in state_store

Luis Chamberlain <mcgrof@kernel.org>
    floppy: fix calling platform_device_unregister() on invalid drives

Jens Axboe <axboe@kernel.dk>
    block: bump max plugged deferred size from 16 to 32

Ansuel Smith <ansuelsmth@gmail.com>
    thermal/drivers/tsens: Add timeout to get_temp_tsens_valid

Tim Gardner <tim.gardner@canonical.com>
    drm/msm: prevent NULL dereference in msm_gpu_crashstate_capture()

Yuanzheng Song <songyuanzheng@huawei.com>
    thermal/core: Fix null pointer dereference in thermal_release()

Kees Cook <keescook@chromium.org>
    leaking_addresses: Always print a trailing newline

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    net: phy: micrel: make *-skew-ps check more lenient

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdkfd: fix resume error when iommu disabled in Picasso

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: fix null pointer deref when plugging in display

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: scan: Release PM resources blocked by unused objects

André Almeida <andrealmeid@collabora.com>
    ACPI: battery: Accept charges over the design capacity as full

Andreas Gruenbacher <agruenba@redhat.com>
    iov_iter: Fix iov_iter_get_pages{,_alloc} page fault return value

Xin Xiong <xiongx18@fudan.edu.cn>
    mmc: moxart: Fix reference count leaks in moxart_probe

Will Deacon <will@kernel.org>
    KVM: arm64: Propagate errors from __pkvm_prot_finalize hypercall

Tuo Li <islituo@gmail.com>
    ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Disable "other" permission bits in the tracefs files

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Have tracefs directories not set OTH permission bits by default

Alex Sierra <alex.sierra@amd.com>
    drm/amdkfd: rm BO resv on validation to avoid deadlock

Antoine Tenart <atenart@kernel.org>
    net-sysfs: try not to restart the syscall if it will fail eventually

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()

Ricardo Ribalda <ribalda@chromium.org>
    media: ipu3-imgu: VIDIOC_QUERYCAP: Fix bus_info

Ricardo Ribalda <ribalda@chromium.org>
    media: ipu3-imgu: imgu_fmt: Handle properly try

Mirela Rabulea <mirela.rabulea@nxp.com>
    media: imx-jpeg: Fix possible null pointer dereference

Wojciech Drewek <wojciech.drewek@intel.com>
    ice: Move devlink port to PF/VF struct

Vincent Donnefort <vincent.donnefort@arm.com>
    cpufreq: Make policy min/max hard requirements

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Avoid evaluating methods too early during system resume

Li Zhijian <lizhijian@cn.fujitsu.com>
    kselftests/sched: cleanup the child processes

Josh Don <joshdon@google.com>
    fs/proc/uptime.c: Fix idle time reporting in /proc/uptime

Corey Minyard <cminyard@mvista.com>
    ipmi: Disable some operations during a panic

Nadezda Lutovinova <lutovinova@ispras.ru>
    media: rcar-csi2: Add checking to rcsi2_start_receiver()

Hans de Goede <hdegoede@redhat.com>
    brcmfmac: Add DMI nvram filename quirk for Cyberbook T116 tablet

Zong-Zhe Yang <kevin_yang@realtek.com>
    rtw88: fix RX clock gate setting while fifo dump

Randy Dunlap <rdunlap@infradead.org>
    ia64: don't do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK

Rajat Asthana <rajatasthana4@gmail.com>
    media: mceusb: return without resubmitting URB in case of -EPROTO error.

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: rcar-vin: Use user provided buffers when starting

Martin Kepplinger <martink@posteo.de>
    media: imx: set a media_device bus_info string

Sergey Senozhatsky <senozhatsky@chromium.org>
    media: videobuf2: rework vb2_mem_ops API

Nadezda Lutovinova <lutovinova@ispras.ru>
    media: s5p-mfc: Add checking to s5p_mfc_probe().

Tuo Li <islituo@gmail.com>
    media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()

Evgeny Novikov <novikov@ispras.ru>
    media: vidtv: Fix memory leak in remove

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Set unique vdev name based in type

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Return -EIO for control errors

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Set capability in s_param

Dmitriy Ulitin <ulitin@ispras.ru>
    media: stm32: Potential NULL pointer dereference in dcmi_irq_thread()

Evgeny Novikov <novikov@ispras.ru>
    media: atomisp: Fix error handling in probe

Zheyu Ma <zheyuma97@gmail.com>
    media: netup_unidvb: handle interrupt properly according to the firmware

Dirk Bender <d.bender@phytec.de>
    media: mt9p031: Fix corrupted frame after restarting stream

Rakesh Babu <rsaladi2@marvell.com>
    octeontx2-pf: Enable promisc/allmulti match MCAM entries.

Alagu Sankar <alagusankar@silex-india.com>
    ath10k: high latency fixes for beacon buffer

Baochen Qiang <bqiang@codeaurora.org>
    ath11k: Change DMA_FROM_DEVICE to DMA_TO_DEVICE when map reinjected packets

Wen Gong <wgong@codeaurora.org>
    ath11k: add handler for scan event WMI_SCAN_EVENT_DEQUEUED

Sriram R <srirrama@codeaurora.org>
    ath11k: Avoid reg rules update during firmware recovery

Petr Machata <petrm@nvidia.com>
    selftests: net: fib_nexthops: Wait before checking reported idle time

Jimmy Kizito <Jimmy.Kizito@amd.com>
    drm/amd/display: Fix null pointer dereference for encoders

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: Fix MMIO access page fault

Eric Biggers <ebiggers@google.com>
    fscrypt: allow 256-bit master keys with AES-256-XTS

Mark Brown <broonie@kernel.org>
    spi: Check we have a spi_device_id for each DT compatible

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Properly initialize private structure on interface type changes

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type

Peter Zijlstra <peterz@infradead.org>
    x86: Increase exception stack sizes

Peter Zijlstra <peterz@infradead.org>
    x86/mm/64: Improve stack overflow warnings

Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
    crypto: aesni - check walk.nbytes instead of err

Seevalamuthu Mariappan <seevalam@codeaurora.org>
    ath11k: Align bss_chan_info structure with firmware

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    smackfs: Fix use-after-free in netlbl_catmap_walk()

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Move RTGS_WAIT_CBS to beginning of rcu_tasks_kthread() loop

Hui Wang <hui.wang@canonical.com>
    ACPI: resources: Add DMI-based legacy IRQ override quirk

Jakub Kicinski <kuba@kernel.org>
    net: sched: update default qdisc visibility after Tx queue cnt changes

Peter Zijlstra <peterz@infradead.org>
    locking/lockdep: Avoid RCU-induced noinstr fail

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: reset correct number of channel

Aleksander Jan Bajkowski <olek2@wp.pl>
    MIPS: lantiq: dma: add small delay after reset

James Zhu <James.Zhu@amd.com>
    drm/amdgpu: move iommu_resume before ip init/resume

Barnabás Pőcze <pobrn@protonmail.com>
    platform/x86: wmi: do not fail if disabling fails

Scott Wood <swood@redhat.com>
    rcutorture: Avoid problematic critical section nesting on PREEMPT_RT

Simon Ser <contact@emersion.fr>
    drm/panel-orientation-quirks: add Valve Steam Deck

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: call sock_hold earlier in sco_conn_del

Wang ShaoBo <bobo.shaobowang@huawei.com>
    Bluetooth: fix use-after-free error in lock_sock_nested()

Takashi Iwai <tiwai@suse.de>
    Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for the Samsung Galaxy Book 10.6

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for KD Kurio Smart C15200 2-in-1

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Update the Lenovo Ideapad D330 quirk (v2)

Charan Teja Reddy <charante@codeaurora.org>
    dma-buf: WARN on dmabuf release with pending attachments

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    component: do not leave master devres group open after bind

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: Clear status bits in interrupt handler

Johan Hovold <johan@kernel.org>
    USB: chipidea: fix interrupt deadlock

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    most: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    Revert "serial: 8250: Fix reporting real baudrate value in c_ospeed field"

Pali Rohár <pali@kernel.org>
    serial: 8250: Fix reporting real baudrate value in c_ospeed field

Jens Axboe <axboe@kernel.dk>
    io-wq: serialize hash clear with wakeup

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: set unique value to volume serial field in FS_VOLUME_INFORMATION

Johan Hovold <johan@kernel.org>
    serial: 8250: fix racy uartclk update

Wang Hai <wanghai38@huawei.com>
    USB: serial: keyspan: fix memleak on probe errors

Mihail Chindris <mihail.chindris@analog.com>
    Documentation:devicetree:bindings:iio:dac: Fix val

Nuno Sá <nuno.sa@analog.com>
    iio: ad5770r: make devicetree property reading consistent

Pekka Korpinen <pekka.korpinen@iki.fi>
    iio: dac: ad5446: Fix ad5622_write() return value

Mihail Chindris <mihail.chindris@analog.com>
    drivers: iio: dac: ad5766: Fix dt property name

Yang Yingliang <yangyingliang@huawei.com>
    iio: buffer: Fix memory leak in iio_buffer_register_legacy_sysfs_groups()

Yang Yingliang <yangyingliang@huawei.com>
    iio: buffer: Fix memory leak in __iio_buffer_alloc_sysfs_and_mask()

Yang Yingliang <yangyingliang@huawei.com>
    iio: buffer: Fix memory leak in iio_buffers_alloc_sysfs_and_mask()

Yang Yingliang <yangyingliang@huawei.com>
    iio: buffer: check return value of kstrdup_const()

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: trbe: Defer the probe on offline CPUs

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: trbe: Fix incorrect access of the sink specific data

Tao Zhang <quic_taozha@quicinc.com>
    coresight: cti: Correct the parameter for pm_runtime_put

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: core: fix possible memory leak in pinctrl_enable()

Robert Marko <robert.marko@sartura.hr>
    mfd: simple-mfd-i2c: Select MFD_CORE to fix build error

Paulo Alcantara <pc@cjr.nz>
    cifs: set a minimum of 120s for next dns resolution

Shyam Prasad N <sprasad@microsoft.com>
    cifs: To match file servers, make sure the server hostname matches

Zhang Yi <yi.zhang@huawei.com>
    quota: correct error number in free_dqentry()

Zhang Yi <yi.zhang@huawei.com>
    quota: check block number when reading the block in quota file

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for bus mastering and PCI_COMMAND on emulated bridge

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Read all 16-bits from PCIE_MSI_PAYLOAD_REG

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Fix return value of MSI domain .alloc() method

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix configuring Reference clock

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reporting Data Link Layer Link Active

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Do not unmask unused interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix checking for link up via LTSSM state

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Do not clear status bits of masked interrupts

Dan Williams <dan.j.williams@intel.com>
    cxl/pci: Fix NULL vs ERR_PTR confusion

Li Chen <lchen@ambarella.com>
    PCI: cadence: Add cdns_plat_pcie_probe() missing return

Marek Behún <kabel@kernel.org>
    PCI: pci-bridge-emul: Fix emulation of W1C bits

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix filattr copy-up failure

yangerkun <yangerkun@huawei.com>
    ovl: fix use after free in struct ovl_aio_req

Juergen Gross <jgross@suse.com>
    xen/balloon: add late_initcall_sync() for initial ballooning done

Arnd Bergmann <arnd@arndb.de>
    ifb: fix building without CONFIG_NET_CLS_ACT

Pali Rohár <pali@kernel.org>
    serial: core: Fix initializing and restoring termios speed

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Protect ring_buffer_reset() from reentrancy

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: honour zeroes as io-wq worker limits

Xiaoming Ni <nixiaoming@huawei.com>
    powerpc/85xx: Fix oops when mpc85xx_smp_guts_ids node cannot be found

Oleksij Rempel <linux@rempel-privat.de>
    iio: adc: tsc2046: fix scan interval warning

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_can_recv(): ignore messages with invalid source address

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM transport

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_irq(): add missing can_rx_offload_threaded_irq_finish() in case of bus off

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: always ask for BERR reporting for PCAN-USB devices

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Handle dynamic MSR intercept toggling

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Query current VMCS when determining if MSR bitmaps are in use

Sean Christopherson <seanjc@google.com>
    KVM: x86: Add helper to consolidate core logic of SET_CPUID{2} flows

David Woodhouse <dwmw2@infradead.org>
    KVM: x86: Fix recording of guest steal time / preempted status

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Extract ESR_ELx.EC only

Yang Yingliang <yangyingliang@huawei.com>
    iio: core: check return value when calling dev_set_name()

Yang Yingliang <yangyingliang@huawei.com>
    iio: core: fix double free in iio_device_unregister_sysfs()

Henrik Grimler <henrik@grimler.se>
    power: supply: max17042_battery: use VFSOC for capacity when no rsns

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: Prevent int underflow in set_soc_threshold

Eugene Syromiatnikov <esyr@redhat.com>
    mctp: handle the struct sockaddr_mctp padding fields

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: socrates: Keep the driver compatible with on-die ECC engines

Meng Li <Meng.Li@windriver.com>
    soc: fsl: dpio: use the combined functions to protect critical zone

Meng Li <Meng.Li@windriver.com>
    soc: fsl: dpio: replace smp_processor_id with raw_smp_processor_id

David Virag <virag.david003@gmail.com>
    soc: samsung: exynos-pmu: Fix compilation when nothing selects CONFIG_MFD_CORE

Eric W. Biederman <ebiederm@xmission.com>
    signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed

Eric W. Biederman <ebiederm@xmission.com>
    signal/mips: Update (_save|_restore)_fp_context to fail with -EFAULT

Wolfram Sang <wsa+renesas@sang-engineering.com>
    memory: renesas-rpc-if: Correct QSPI data transfer in Manual mode

Eric W. Biederman <ebiederm@xmission.com>
    signal: Remove the bogus sigkill_pending in ptrace_stop

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra: Restore AC97 support

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra: Set default card name for Trimslice

Alok Prasad <palok@marvell.com>
    RDMA/qedr: Fix NULL deref for query_qp on the GSI QP

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix Intel ICX IIO event constraints

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix invalid unit check

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Support extra IMC channel on Ice Lake server

Marek Vasut <marex@denx.de>
    rsi: Fix module dev_oper_mode parameter description

Martin Fuzzey <martin.fuzzey@flowbird.group>
    rsi: fix rate mask set leading to P2P failure

Martin Fuzzey <martin.fuzzey@flowbird.group>
    rsi: fix key enabled check causing unwanted encryption for vap_id > 0

Martin Fuzzey <martin.fuzzey@flowbird.group>
    rsi: fix occasional initialisation failure with BT coex

Benjamin Li <benl@squareup.com>
    wcn36xx: handle connection loss indication

Christian König <christian.koenig@amd.com>
    dma-buf: fix and rework dma_buf_poll v7

Reimar Döffinger <Reimar.Doeffinger@gmx.de>
    libata: fix checking of DMA state

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Try waking the firmware until we get an interrupt

Jonas Dreßler <verdre@v0yd.nl>
    mwifiex: Read a PCI register after writing the TX ring write pointer

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Do not let "syscore" devices runtime-suspend during system transitions

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix (QoS) null data frame bitrate/modulation

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix tx_status mechanism

Loic Poulain <loic.poulain@linaro.org>
    wcn36xx: Fix HT40 capability for 2Ghz band

Maximilian Luz <luzmaximilian@gmail.com>
    HID: surface-hid: Allow driver matching for target ID 1 devices

Maximilian Luz <luzmaximilian@gmail.com>
    HID: surface-hid: Use correct event registry for managing HID events

Felix Fietkau <nbd@nbd.name>
    mt76: mt7615: fix skb use-after-free on mac reset

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add support for Surface Laptop Studio

Lukas Wunner <lukas@wunner.de>
    ifb: Depend on netfilter alternatively to tc

Austin Kim <austin.kim@lge.com>
    evm: mark evm_fixmode as __ro_after_init

Johan Hovold <johan@kernel.org>
    rtl8187: fix control-message timeouts

Ingmar Klein <ingmar_klein@web.de>
    PCI: Mark Atheros QCA6174 to avoid bus reset

Johan Hovold <johan@kernel.org>
    ath10k: fix division by zero in send path

Johan Hovold <johan@kernel.org>
    ath10k: fix control-message timeout

Johan Hovold <johan@kernel.org>
    ath6kl: fix control-message timeout

Johan Hovold <johan@kernel.org>
    ath6kl: fix division by zero in send path

Johan Hovold <johan@kernel.org>
    mwifiex: fix division by zero in fw download path

Eric Badger <ebadger@purestorage.com>
    EDAC/sb_edac: Fix top-of-high-memory value for Broadwell/Haswell

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    regulator: dt-bindings: samsung,s5m8767: correct s5m8767,pmic-buck-default-dvs-idx property

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    regulator: s5m8767: do not use reset value as DVS voltage if GPIO DVS is disabled

Zev Weiss <zev@bewilderbeest.net>
    hwmon: (pmbus/lm25066) Add offset coefficients

Guoqing Jiang <guoqing.jiang@linux.dev>
    md/raid1: only allocate write behind bio for WriteMostly device

Corey Minyard <cminyard@mvista.com>
    ipmi:watchdog: Set panic count to proper value on a panic

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix race condition when computing ocontext SIDs

Masami Hiramatsu <mhiramat@kernel.org>
    ia64: kprobes: Fix to pass correct trampoline address to the handler

Laurent Vivier <lvivier@redhat.com>
    KVM: PPC: Tick accounting should defer vtime accounting 'til after IRQ handling

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Unregister posted interrupt wakeup handler on hardware unsetup

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Drop a redundant, broken remote TLB flush

Anand Jain <anand.jain@oracle.com>
    btrfs: call btrfs_check_rw_degradable only if there is a missing device

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error handling when replaying directory deletes

Li Zhang <zhanglikernel@gmail.com>
    btrfs: clear MISSING device status bit in btrfs_close_one_device

Peter Zijlstra <peterz@infradead.org>
    x86/iopl: Fake iopl(3) CLI/STI usage

Sean Christopherson <seanjc@google.com>
    x86/irq: Ensure PI wakeup handler is unregistered before module unload

Jane Malalane <jane.malalane@citrix.com>
    x86/cpu: Fix migration safety with X86_BUG_NULL_SEL

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sme: Use #define USE_EARLY_PGTABLE_L5 in mem_encrypt_identity.c

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix page stealing

yangerkun <yangerkun@huawei.com>
    ext4: refresh the ext4_ext_path struct after dropping i_data_sem.

yangerkun <yangerkun@huawei.com>
    ext4: ensure enough credits in ext4_ext_shift_path_extents

Shaoying Xu <shaoyi@amazon.com>
    ext4: fix lazy initialization next schedule time computation in more granular unit

Eric Whitney <enwlinux@gmail.com>
    Revert "ext4: enforce buffer head state assertion in ext4_da_map_blocks"

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Unconditionally unlink slave instances, too

Wang Wensheng <wangwensheng4@huawei.com>
    ALSA: timer: Fix use-after-free problem

Takashi Iwai <tiwai@suse.de>
    ALSA: PCM: Fix NULL dereference at mmap checks

Takashi Iwai <tiwai@suse.de>
    ALSA: pci: rme: Fix unaligned buffer addresses

Austin Kim <austin.kim@lge.com>
    ALSA: synth: missing check for possible NULL after the call to kstrdup

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Free card instance properly at probe errors

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum 400

Jason Ormes <skryking@gmail.com>
    ALSA: usb-audio: Line6 HX-Stomp XL USB_ID for 48k-fixed quirk

Pavel Skripkin <paskripkin@gmail.com>
    ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume

Takashi Iwai <tiwai@suse.de>
    ALSA: mixer: oss: Fix racy access to slots

Johan Hovold <johan@kernel.org>
    ALSA: line6: fix control and interrupt message timeouts

Johan Hovold <johan@kernel.org>
    ALSA: 6fire: fix control and bulk message timeouts

Johan Hovold <johan@kernel.org>
    ALSA: ua101: fix division by zero at probe

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Add quirk for HP EliteBook 840 G7 mute LED

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for ASUS UX550VE

Jaroslav Kysela <perex@perex.cz>
    ALSA: hda/realtek: Add a quirk for Acer Spin SP513-54N

Jeremy Soller <jeremy@system76.com>
    ALSA: hda/realtek: Headset fixup for Clevo NH77HJQ

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo PC70HS

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add a quirk for HP OMEN 15 mute LED

Johnathon Clark <john.clark@cantab.net>
    ALSA: hda/realtek: Fix mic mute LED for the HP Spectre x360 14

Ricardo Ribalda <ribalda@chromium.org>
    media: v4l2-ioctl: Fix check_ext_ctrls

Sean Young <sean@mess.org>
    media: ir-kbd-i2c: improve responsiveness of hauppauge zilog receivers

Chen-Yu Tsai <wenst@chromium.org>
    media: rkvdec: Support dynamic resolution changes

Sean Young <sean@mess.org>
    media: ite-cir: IR receiver stop working after receive overflow

Chen-Yu Tsai <wenst@chromium.org>
    media: rkvdec: Do not override sizeimage for output format

Tang Bin <tangbin@cmss.chinamobile.com>
    crypto: s5p-sss - Add error handling in s5p_aes_probe()

jing yangyang <cgel.zte@gmail.com>
    firmware/psci: fix application of sizeof to pointer

Dan Carpenter <dan.carpenter@oracle.com>
    tpm: Check for integer overflow in tpm2_map_response_body()

Helge Deller <deller@gmx.de>
    parisc: Fix ptrace check on syscall return

Helge Deller <deller@gmx.de>
    parisc: Fix set_fixmap() on PA1.x CPUs

Pavel Begunkov <asml.silence@gmail.com>
    io-wq: remove worker to owner tw dependency

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: fix incorrect loading of i_blocks for large files

Christian Löhle <CLoehle@hyperstone.com>
    mmc: dw_mmc: Dont wait for DRTO on Write RSP error

Derong Liu <derong.liu@mediatek.com>
    mmc: mtk-sd: Add wait dma stop done flow

Ziyang Xuan <william.xuanziyang@huawei.com>
    char: xillybus: fix msg_ep UAF in xillyusb_probe()

Ben Skeggs <bskeggs@redhat.com>
    ce/gf100: fix incorrect CE0 address calculation on some GPUs

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix use after free in eh_abort path

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix kernel crash when accessing port_speed sysfs file

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix crash in NVMe abort path

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix FCP I/O flush functionality for TMF routines

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Don't release final kref on Fport node while ABTS outstanding

Tadeusz Struk <tadeusz.struk@linaro.org>
    scsi: core: Remove command size deduction from scsi_setup_scsi_cmnd()

Ewan D. Milne <emilne@redhat.com>
    scsi: core: Avoid leaving shost->last_reset with stale value if EH does not run

Tadeusz Struk <tadeusz.struk@linaro.org>
    scsi: scsi_ioctl: Validate command size

Jan Kara <jack@suse.cz>
    ocfs2: fix data corruption on truncate

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    libata: fix read log timeout value

Takashi Iwai <tiwai@suse.de>
    Input: i8042 - Add quirk for Fujitsu Lifebook T725

Phoenix Huang <phoenix@emc.com.tw>
    Input: elantench - fix misreporting trackpoint coordinates

Johan Hovold <johan@kernel.org>
    Input: iforce - fix control-message timeout

Nehal Bakulchandra Shah <Nehal-Bakulchandra.shah@amd.com>
    usb: xhci: Enable runtime-pm by default on AMD Yellow Carp platform

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix USB 3.1 enumeration issues by increasing roothub power-on-good delay


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   7 +
 .../devicetree/bindings/iio/dac/adi,ad5766.yaml    |   2 +-
 .../bindings/regulator/samsung,s5m8767.txt         |  23 +-
 Documentation/filesystems/fscrypt.rst              |  10 +-
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   3 +
 arch/arm/Makefile                                  |  22 +-
 arch/arm/boot/dts/at91-tse850-3.dts                |   2 +-
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts        |   2 +-
 arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts        |   2 +-
 arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts  |   2 +-
 arch/arm/boot/dts/bcm4709-linksys-ea9200.dts       |   2 +-
 arch/arm/boot/dts/bcm4709-netgear-r7000.dts        |   2 +-
 arch/arm/boot/dts/bcm4709-netgear-r8000.dts        |   2 +-
 arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dts  |   2 +-
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts      |   2 +-
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts         |   2 +-
 arch/arm/boot/dts/bcm94708.dts                     |   2 +-
 arch/arm/boot/dts/bcm94709.dts                     |   2 +-
 arch/arm/boot/dts/omap3-gta04.dtsi                 |   2 +-
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   4 +-
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi           |   8 +-
 arch/arm/boot/dts/stm32mp151.dtsi                  |  16 +-
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi       |   2 +-
 arch/arm/boot/dts/stm32mp15xx-dkx.dtsi             |   2 +-
 arch/arm/kernel/stacktrace.c                       |   3 +-
 arch/arm/mach-s3c/irq-s3c24xx.c                    |  22 +-
 arch/arm/mm/Kconfig                                |   2 +-
 arch/arm/mm/kasan_init.c                           |   2 +-
 arch/arm/mm/mmu.c                                  |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts  |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12a-u200.dts    |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts |   2 +-
 .../boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi   |   4 +-
 .../boot/dts/amlogic/meson-g12b-odroid-n2.dtsi     |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi   |   4 +-
 .../boot/dts/amlogic/meson-sm1-bananapi-m5.dts     |   2 +-
 .../boot/dts/amlogic/meson-sm1-khadas-vim3l.dts    |   2 +-
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi  |   6 +-
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts   |   2 +-
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi  |   2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   8 +-
 arch/arm64/boot/dts/qcom/pm8916.dtsi               |   1 -
 arch/arm64/boot/dts/qcom/pmi8994.dtsi              |   2 +-
 .../arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi |   2 +-
 .../arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi |   8 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  52 ++---
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   6 +-
 .../arm64/boot/dts/renesas/beacon-renesom-som.dtsi |   1 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   2 +-
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi          |   6 +-
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |  16 +-
 arch/arm64/include/asm/esr.h                       |   1 +
 arch/arm64/include/asm/pgtable.h                   |  12 +-
 arch/arm64/kernel/cpufeature.c                     |  10 +-
 arch/arm64/kernel/vdso32/Makefile                  |   3 +-
 arch/arm64/kvm/arm.c                               |  30 ++-
 arch/arm64/kvm/hyp/hyp-entry.S                     |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   2 +-
 arch/arm64/mm/mmu.c                                |   5 +
 arch/ia64/Kconfig.debug                            |   2 +-
 arch/ia64/kernel/kprobes.c                         |   9 +-
 arch/m68k/Kconfig.machine                          |   1 +
 arch/mips/Kbuild.platforms                         |   2 +-
 arch/mips/Kconfig                                  |   1 +
 arch/mips/Makefile                                 |   2 +
 arch/mips/include/asm/cmpxchg.h                    |   5 +-
 arch/mips/include/asm/mips-cm.h                    |  12 +-
 arch/mips/kernel/mips-cm.c                         |  21 +-
 arch/mips/kernel/r2300_fpu.S                       |   4 +-
 arch/mips/kernel/syscall.c                         |   9 -
 arch/mips/lantiq/xway/dma.c                        |  23 +-
 arch/openrisc/kernel/dma.c                         |   4 +-
 arch/openrisc/kernel/smp.c                         |   6 +-
 arch/parisc/include/asm/pgtable.h                  |  10 +-
 arch/parisc/kernel/cache.c                         |   4 +-
 arch/parisc/kernel/entry.S                         |   2 +-
 arch/parisc/kernel/smp.c                           |  19 +-
 arch/parisc/kernel/unwind.c                        |  21 +-
 arch/parisc/kernel/vmlinux.lds.S                   |   3 +-
 arch/parisc/mm/fixmap.c                            |   5 +-
 arch/parisc/mm/init.c                              |   4 +-
 arch/powerpc/Kconfig                               |   6 +-
 arch/powerpc/include/asm/nohash/32/pgtable.h       |  19 +-
 arch/powerpc/include/asm/nohash/32/pte-8xx.h       |  22 ++
 arch/powerpc/include/asm/nohash/64/pgtable.h       |   5 -
 arch/powerpc/include/asm/nohash/pte-book3e.h       |  18 +-
 arch/powerpc/include/asm/paravirt.h                |  18 +-
 arch/powerpc/kernel/firmware.c                     |   7 +-
 arch/powerpc/kernel/head_booke.h                   |  15 +-
 arch/powerpc/kernel/interrupt.c                    |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |  30 ++-
 arch/powerpc/kvm/booke.c                           |  16 +-
 arch/powerpc/lib/feature-fixups.c                  |  11 +
 arch/powerpc/mm/mem.c                              |   2 +-
 arch/powerpc/mm/nohash/tlb_low_64e.S               |   8 +-
 arch/powerpc/mm/pgtable_32.c                       |   2 +-
 arch/powerpc/net/bpf_jit_comp.c                    |   2 +-
 arch/powerpc/perf/power10-events-list.h            |   8 +-
 arch/powerpc/perf/power10-pmu.c                    |  44 ++--
 arch/powerpc/platforms/44x/fsp2.c                  |   2 +
 arch/powerpc/platforms/85xx/Makefile               |   4 +-
 arch/powerpc/platforms/85xx/mpc85xx_pm_ops.c       |   7 +-
 arch/powerpc/platforms/85xx/smp.c                  |  12 +-
 arch/powerpc/platforms/book3s/vas-api.c            |   4 +-
 arch/powerpc/platforms/powernv/opal-prd.c          |  12 +-
 arch/powerpc/platforms/pseries/mobility.c          |  34 +++
 arch/powerpc/xmon/xmon.c                           |   3 +-
 arch/s390/kernel/perf_cpum_cf.c                    |   4 +-
 arch/s390/kernel/uv.c                              |   2 +-
 arch/s390/kvm/priv.c                               |   2 +
 arch/s390/kvm/pv.c                                 |  21 +-
 arch/s390/mm/gmap.c                                |  11 +-
 arch/s390/mm/pgtable.c                             |  70 ++++--
 arch/sh/kernel/cpu/fpu.c                           |  10 +-
 arch/sparc/boot/Makefile                           |   8 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/crypto/aesni-intel_glue.c                 |   2 +-
 arch/x86/events/intel/core.c                       |   5 +-
 arch/x86/events/intel/ds.c                         |   5 +-
 arch/x86/events/intel/uncore_discovery.h           |   2 +-
 arch/x86/events/intel/uncore_snbep.c               |  16 +-
 arch/x86/hyperv/hv_init.c                          |   5 +-
 arch/x86/include/asm/cpu_entry_area.h              |   8 +-
 arch/x86/include/asm/insn-eval.h                   |   1 +
 arch/x86/include/asm/irq_stack.h                   |  37 ++-
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/mem_encrypt.h                 |   1 +
 arch/x86/include/asm/page_64_types.h               |   2 +-
 arch/x86/include/asm/processor.h                   |   1 +
 arch/x86/include/asm/stacktrace.h                  |  10 +
 arch/x86/include/asm/traps.h                       |   6 +-
 arch/x86/kernel/Makefile                           |   6 +
 arch/x86/kernel/cc_platform.c                      |  69 ++++++
 arch/x86/kernel/cpu/amd.c                          |   2 +
 arch/x86/kernel/cpu/common.c                       |  44 +++-
 arch/x86/kernel/cpu/cpu.h                          |   1 +
 arch/x86/kernel/cpu/hygon.c                        |   2 +
 arch/x86/kernel/cpu/mce/intel.c                    |   5 +-
 arch/x86/kernel/dumpstack_64.c                     |   6 +
 arch/x86/kernel/irq.c                              |   4 +-
 arch/x86/kernel/process.c                          |   1 +
 arch/x86/kernel/sev.c                              |  32 ---
 arch/x86/kernel/traps.c                            |  60 +++--
 arch/x86/kvm/cpuid.c                               |  47 ++--
 arch/x86/kvm/mmu/mmu.c                             |   6 +-
 arch/x86/kvm/vmx/nested.c                          | 103 ++++----
 arch/x86/kvm/vmx/vmx.c                             |  68 +-----
 arch/x86/kvm/vmx/vmx.h                             |  63 +++++
 arch/x86/kvm/x86.c                                 | 108 ++++++---
 arch/x86/lib/insn-eval.c                           |   2 +-
 arch/x86/lib/insn.c                                |   5 +-
 arch/x86/mm/cpu_entry_area.c                       |   7 +
 arch/x86/mm/fault.c                                |  20 +-
 arch/x86/mm/mem_encrypt.c                          |   1 +
 arch/x86/mm/mem_encrypt_identity.c                 |   9 +
 block/blk-cgroup.c                                 |  10 +
 block/blk-mq.c                                     |   5 +-
 block/blk-wbt.c                                    |   3 +
 block/blk-zoned.c                                  |  15 +-
 block/blk.h                                        |   6 +
 block/genhd.c                                      |   8 +-
 block/ioctl.c                                      |  24 +-
 crypto/Kconfig                                     |   2 +-
 crypto/pcrypt.c                                    |  12 +-
 crypto/tcrypt.c                                    |   5 +-
 drivers/acpi/ac.c                                  |  19 ++
 drivers/acpi/acpica/acglobal.h                     |   2 +
 drivers/acpi/acpica/hwesleep.c                     |   8 +-
 drivers/acpi/acpica/hwsleep.c                      |  11 +-
 drivers/acpi/acpica/hwxfsleep.c                    |   7 +
 drivers/acpi/battery.c                             |   2 +-
 drivers/acpi/glue.c                                |  25 ++
 drivers/acpi/internal.h                            |   1 +
 drivers/acpi/pmic/intel_pmic.c                     |  51 ++--
 drivers/acpi/power.c                               |  86 +++----
 drivers/acpi/resource.c                            |  56 ++++-
 drivers/acpi/scan.c                                |   6 +
 drivers/ata/libata-core.c                          |   2 +-
 drivers/ata/libata-eh.c                            |   8 +
 drivers/auxdisplay/ht16k33.c                       |  66 +++---
 drivers/auxdisplay/img-ascii-lcd.c                 |  10 +
 drivers/base/component.c                           |   5 +-
 drivers/base/core.c                                |   4 +-
 drivers/base/power/main.c                          |  93 +++++---
 drivers/block/ataflop.c                            | 141 ++++++-----
 drivers/block/floppy.c                             |   9 +-
 drivers/block/nbd.c                                |  24 +-
 drivers/block/zram/zram_drv.c                      |   2 +-
 drivers/bluetooth/btmtkuart.c                      |  13 +-
 drivers/bluetooth/hci_h5.c                         |  28 ++-
 drivers/bus/ti-sysc.c                              |  65 +++++-
 drivers/char/hw_random/mtk-rng.c                   |   9 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  10 +-
 drivers/char/ipmi/ipmi_watchdog.c                  |  25 +-
 drivers/char/ipmi/kcs_bmc_serio.c                  |   4 +-
 drivers/char/tpm/tpm2-space.c                      |   3 +
 drivers/char/tpm/tpm_tis_core.c                    |  26 ++-
 drivers/char/tpm/tpm_tis_core.h                    |   4 +
 drivers/char/tpm/tpm_tis_spi_main.c                |   1 +
 drivers/char/xillybus/xillyusb.c                   |   1 +
 drivers/clk/at91/clk-master.c                      |   6 +-
 drivers/clk/at91/clk-sam9x60-pll.c                 |   4 +-
 drivers/clk/at91/pmc.c                             |   5 +
 drivers/clk/mvebu/ap-cpu-clk.c                     |  14 +-
 drivers/clocksource/Kconfig                        |   1 +
 drivers/cpufreq/cpufreq.c                          |   7 +
 drivers/cpufreq/intel_pstate.c                     |  35 ++-
 drivers/cpuidle/sysfs.c                            |   5 +-
 drivers/crypto/caam/caampkc.c                      |  19 +-
 drivers/crypto/caam/regs.h                         |   3 +
 drivers/crypto/ccree/cc_driver.c                   |   3 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c |   1 +
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c     |  31 +++
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h     |  10 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   1 +
 drivers/crypto/qat/qat_common/adf_init.c           |   5 +
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  13 ++
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |   6 +
 drivers/crypto/s5p-sss.c                           |   2 +
 drivers/cxl/pci.c                                  |   2 +-
 drivers/dma-buf/dma-buf.c                          | 153 ++++++------
 drivers/dma/at_xdmac.c                             |  53 +++--
 drivers/dma/bestcomm/ata.c                         |   2 +-
 drivers/dma/bestcomm/bestcomm.c                    |  22 +-
 drivers/dma/bestcomm/fec.c                         |   4 +-
 drivers/dma/bestcomm/gen_bd.c                      |   4 +-
 drivers/dma/dmaengine.h                            |   2 +-
 drivers/dma/idxd/device.c                          |   3 +-
 drivers/dma/idxd/dma.c                             |   5 +-
 drivers/dma/idxd/init.c                            |  14 +-
 drivers/dma/stm32-dma.c                            |  23 +-
 drivers/dma/tegra210-adma.c                        |   2 +-
 drivers/dma/ti/k3-udma.c                           |  32 ++-
 drivers/edac/amd64_edac.c                          |  22 +-
 drivers/edac/sb_edac.c                             |   2 +-
 drivers/firmware/psci/psci_checker.c               |   2 +-
 drivers/firmware/qcom_scm.c                        |   2 +-
 drivers/gpio/gpio-realtek-otto.c                   |   2 +-
 drivers/gpu/drm/Kconfig                            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |  24 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c              |  24 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c              |  24 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |  24 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |  32 +--
 drivers/gpu/drm/amd/amdgpu/vce_v2_0.c              |  19 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |  28 +--
 drivers/gpu/drm/amd/amdgpu/vce_v4_0.c              |  44 ++--
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |   8 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |  17 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   7 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   9 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   2 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   2 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |  18 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |   3 +-
 .../display/dc/dml/dcn20/display_rq_dlg_calc_20.c  |   6 +-
 .../display/dc/dml/dcn20/display_rq_dlg_calc_20.h  |   4 +-
 .../dc/dml/dcn20/display_rq_dlg_calc_20v2.c        |   6 +-
 .../dc/dml/dcn20/display_rq_dlg_calc_20v2.h        |   4 +-
 .../display/dc/dml/dcn21/display_rq_dlg_calc_21.c  |  62 ++---
 .../display/dc/dml/dcn21/display_rq_dlg_calc_21.h  |   4 +-
 .../display/dc/dml/dcn30/display_rq_dlg_calc_30.c  |  72 +++---
 .../display/dc/dml/dcn30/display_rq_dlg_calc_30.h  |   4 +-
 .../display/dc/dml/dcn31/display_rq_dlg_calc_31.c  |  68 +++---
 .../display/dc/dml/dcn31/display_rq_dlg_calc_31.h  |   4 +-
 .../gpu/drm/amd/display/dc/dml/display_mode_lib.h  |   4 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c   |   8 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |  10 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c    |   2 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.h    |  13 ++
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  12 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c  |   4 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |  14 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |  89 +++----
 drivers/gpu/drm/bridge/analogix/anx7625.c          |  12 +-
 drivers/gpu/drm/bridge/ite-it66121.c               |  21 +-
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |   9 +-
 drivers/gpu/drm/bridge/nwl-dsi.c                   |  35 +++
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  35 ++-
 drivers/gpu/drm/drm_plane_helper.c                 |   1 -
 drivers/gpu/drm/i915/display/intel_fb.c            |   5 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |   2 +-
 drivers/gpu/drm/imx/imx-drm-core.c                 |   2 -
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   6 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c        |   8 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   4 +
 drivers/gpu/drm/msm/dsi/dsi.h                      |   2 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  72 +++---
 drivers/gpu/drm/msm/dsi/dsi_manager.c              |  16 ++
 drivers/gpu/drm/msm/msm_gem.c                      |   5 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   2 +-
 drivers/gpu/drm/msm/msm_submitqueue.c              |   1 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   2 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |   4 +
 drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |   3 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |   2 +-
 drivers/gpu/drm/sun4i/sun8i_csc.h                  |   4 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |  99 +-------
 drivers/gpu/drm/v3d/v3d_gem.c                      |   4 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   4 -
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c         |  72 +-----
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c           |   3 -
 drivers/hid/hid-u2fzero.c                          |  10 +-
 drivers/hid/surface-hid/surface_hid.c              |   4 +-
 drivers/hwmon/hwmon.c                              |   6 +-
 drivers/hwmon/pmbus/lm25066.c                      |  25 +-
 drivers/hwtracing/coresight/coresight-cti-core.c   |   2 +-
 drivers/hwtracing/coresight/coresight-trbe.c       |  10 +-
 drivers/i2c/busses/i2c-i801.c                      |   5 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/busses/i2c-xlr.c                       |   6 +-
 drivers/iio/accel/st_accel_i2c.c                   |   4 +-
 drivers/iio/accel/st_accel_spi.c                   |   4 +-
 drivers/iio/adc/ti-tsc2046.c                       |   2 +-
 drivers/iio/dac/ad5446.c                           |   9 +-
 drivers/iio/dac/ad5766.c                           |   6 +-
 drivers/iio/dac/ad5770r.c                          |   2 +-
 drivers/iio/gyro/st_gyro_i2c.c                     |   4 +-
 drivers/iio/gyro/st_gyro_spi.c                     |   4 +-
 drivers/iio/imu/adis.c                             |   4 +-
 drivers/iio/industrialio-buffer.c                  |  28 ++-
 drivers/iio/industrialio-core.c                    |   9 +-
 drivers/iio/magnetometer/st_magn_i2c.c             |   4 +-
 drivers/iio/magnetometer/st_magn_spi.c             |   4 +-
 drivers/iio/pressure/st_pressure_i2c.c             |   4 +-
 drivers/iio/pressure/st_pressure_spi.c             |   8 +-
 drivers/infiniband/core/uverbs_cmd.c               |   3 -
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   6 +-
 drivers/infiniband/hw/mlx4/qp.c                    |   4 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  15 +-
 drivers/infiniband/sw/rxe/rxe_param.h              |   2 +-
 drivers/input/joystick/iforce/iforce-usb.c         |   2 +-
 drivers/input/misc/ariel-pwrbutton.c               |   7 +
 drivers/input/mouse/elantech.c                     |  13 ++
 drivers/input/serio/i8042-x86ia64io.h              |  14 ++
 drivers/input/touchscreen/st1232.c                 |   2 +-
 drivers/iommu/dma-iommu.c                          |  52 ++---
 drivers/iommu/mtk_iommu.c                          |   4 +-
 drivers/irqchip/irq-bcm6345-l1.c                   |   2 +-
 drivers/irqchip/irq-sifive-plic.c                  |   8 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |  11 +-
 drivers/md/bcache/btree.c                          |   2 +-
 drivers/md/bcache/super.c                          |   2 +-
 drivers/md/md.c                                    |  11 +-
 drivers/md/raid1.c                                 |   2 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |  42 ++--
 .../media/common/videobuf2/videobuf2-dma-contig.c  |  39 ++--
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |  35 +--
 drivers/media/common/videobuf2/videobuf2-vmalloc.c |  30 +--
 drivers/media/dvb-frontends/mn88443x.c             |  18 +-
 drivers/media/i2c/Kconfig                          |   1 +
 drivers/media/i2c/imx258.c                         |  12 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   1 +
 drivers/media/i2c/mt9p031.c                        |  28 ++-
 drivers/media/i2c/tda1997x.c                       |   8 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |   3 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |   4 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  27 ++-
 drivers/media/platform/allegro-dvt/allegro-core.c  |   9 +
 drivers/media/platform/atmel/atmel-isc-base.c      |  25 +-
 drivers/media/platform/atmel/atmel-isc.h           |   2 +
 drivers/media/platform/atmel/atmel-sama5d2-isc.c   |  39 ++--
 drivers/media/platform/atmel/atmel-sama7g5-isc.c   |  22 +-
 drivers/media/platform/imx-jpeg/mxc-jpeg.c         |   6 +
 drivers/media/platform/meson/ge2d/ge2d.c           |   6 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   8 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |   5 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |   8 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |   2 +
 drivers/media/platform/rcar-vin/rcar-dma.c         |   3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   6 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |  19 +-
 .../media/platform/sunxi/sun6i-csi/sun6i_video.c   |   6 +-
 drivers/media/radio/radio-wl1273.c                 |   2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   2 +-
 drivers/media/rc/ir_toy.c                          |   2 +-
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/mceusb.c                          |   1 +
 drivers/media/spi/cxd2880-spi.c                    |   2 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   4 +
 drivers/media/usb/dvb-usb/az6027.c                 |   1 +
 drivers/media/usb/dvb-usb/dibusb-common.c          |   2 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   5 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   5 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   3 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |  10 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   7 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   7 +-
 drivers/media/usb/uvc/uvc_video.c                  |   5 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |  67 ++++--
 drivers/memory/fsl_ifc.c                           |  13 +-
 drivers/memory/renesas-rpc-if.c                    | 113 ++++++---
 drivers/memstick/core/ms_block.c                   |   2 +-
 drivers/memstick/host/jmb38x_ms.c                  |   2 +-
 drivers/memstick/host/r592.c                       |   8 +-
 drivers/mfd/Kconfig                                |   1 +
 drivers/mfd/altera-sysmgr.c                        |   2 +-
 drivers/mfd/dln2.c                                 |  18 ++
 drivers/mfd/mfd-core.c                             |   2 +
 drivers/mfd/motorola-cpcap.c                       |   8 +
 drivers/mfd/sprd-sc27xx-spi.c                      |   7 +
 drivers/mmc/host/dw_mmc.c                          |   3 +-
 drivers/mmc/host/moxart-mmc.c                      |  29 ++-
 drivers/mmc/host/mtk-sd.c                          |   5 +
 drivers/mmc/host/mxs-mmc.c                         |  10 +
 drivers/mmc/host/sdhci-omap.c                      |  18 +-
 drivers/most/most_usb.c                            |   5 +-
 drivers/mtd/mtdcore.c                              |   4 +-
 drivers/mtd/nand/raw/ams-delta.c                   |  12 +-
 drivers/mtd/nand/raw/arasan-nand-controller.c      |  15 ++
 drivers/mtd/nand/raw/au1550nd.c                    |  12 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   4 +-
 drivers/mtd/nand/raw/gpio.c                        |  12 +-
 drivers/mtd/nand/raw/intel-nand-controller.c       |   5 +
 drivers/mtd/nand/raw/mpc5121_nfc.c                 |  12 +-
 drivers/mtd/nand/raw/orion_nand.c                  |  12 +-
 drivers/mtd/nand/raw/pasemi_nand.c                 |  12 +-
 drivers/mtd/nand/raw/plat_nand.c                   |  12 +-
 drivers/mtd/nand/raw/socrates_nand.c               |  12 +-
 drivers/mtd/nand/raw/xway_nand.c                   |  12 +-
 drivers/mtd/spi-nor/controllers/hisi-sfc.c         |   1 -
 drivers/net/Kconfig                                |   2 +-
 drivers/net/bonding/bond_sysfs_slave.c             |  36 +--
 drivers/net/can/dev/bittiming.c                    |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   6 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   6 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  17 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   5 +-
 drivers/net/dsa/ocelot/felix.c                     |   9 +-
 drivers/net/dsa/rtl8366.c                          |   2 +-
 drivers/net/dsa/rtl8366rb.c                        |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   8 +
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  13 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   7 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h         |   2 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   2 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.h         |   2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |   2 +-
 drivers/net/ethernet/fealnx.c                      |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  18 +-
 drivers/net/ethernet/google/gve/gve.h              |  17 +-
 drivers/net/ethernet/google/gve/gve_adminq.h       |   1 +
 drivers/net/ethernet/google/gve/gve_main.c         |  48 +++-
 drivers/net/ethernet/google/gve/gve_rx.c           |   7 +-
 drivers/net/ethernet/google/gve/gve_tx.c           |  23 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |  84 +++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  20 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  10 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  77 +++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  10 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  21 +-
 drivers/net/ethernet/intel/ice/ice.h               |   7 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c       | 109 ++++++---
 drivers/net/ethernet/intel/ice/ice_devlink.h       |   6 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   3 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   4 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  22 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |   9 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |   2 +-
 drivers/net/ethernet/litex/litex_liteeth.c         |   1 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  38 +--
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  78 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   2 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   8 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  12 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   2 -
 drivers/net/ethernet/ti/cpsw_ale.c                 |   6 +-
 drivers/net/ethernet/ti/davinci_emac.c             |  16 +-
 drivers/net/ifb.c                                  |   2 +
 drivers/net/phy/micrel.c                           |   9 +-
 drivers/net/phy/phy.c                              |   7 +-
 drivers/net/phy/phylink.c                          |   7 +-
 drivers/net/vrf.c                                  |  28 ++-
 drivers/net/wireless/ath/ath10k/core.c             |  11 +-
 drivers/net/wireless/ath/ath10k/coredump.c         |  11 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |   7 +
 drivers/net/wireless/ath/ath10k/mac.c              |  45 +++-
 drivers/net/wireless/ath/ath10k/qmi.c              |   3 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   5 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |  77 ++++++
 drivers/net/wireless/ath/ath10k/snoc.h             |   5 +
 drivers/net/wireless/ath/ath10k/usb.c              |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   4 +
 drivers/net/wireless/ath/ath10k/wmi.h              |   3 +
 drivers/net/wireless/ath/ath11k/dbring.c           |  16 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  13 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   2 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   4 +-
 drivers/net/wireless/ath/ath11k/reg.c              |  11 +-
 drivers/net/wireless/ath/ath11k/reg.h              |   2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  40 ++--
 drivers/net/wireless/ath/ath11k/wmi.h              |   3 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |   7 +-
 drivers/net/wireless/ath/ath9k/main.c              |   4 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |  10 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |  49 ++--
 drivers/net/wireless/ath/wcn36xx/hal.h             |  32 +++
 drivers/net/wireless/ath/wcn36xx/main.c            |  21 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             | 126 +++++++++-
 drivers/net/wireless/ath/wcn36xx/smd.h             |   1 +
 drivers/net/wireless/ath/wcn36xx/txrx.c            |  64 ++---
 drivers/net/wireless/ath/wcn36xx/txrx.h            |   3 +-
 drivers/net/wireless/broadcom/b43/phy_g.c          |   2 +-
 drivers/net/wireless/broadcom/b43legacy/radio.c    |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  10 +
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   6 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   2 +
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +
 drivers/net/wireless/marvell/mwifiex/11n.c         |   5 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  32 +--
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  36 ++-
 drivers/net/wireless/marvell/mwifiex/usb.c         |  16 ++
 drivers/net/wireless/marvell/mwl8k.c               |   2 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |  10 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   8 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |  29 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  60 ++---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  18 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  30 ++-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  22 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |  36 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  13 ++
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  68 +++++-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |   8 +
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  22 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |   8 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   3 +-
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c |  14 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   7 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |   1 +
 drivers/net/wireless/rsi/rsi_91x_core.c            |   2 +
 drivers/net/wireless/rsi/rsi_91x_hal.c             |  10 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |  74 ++----
 drivers/net/wireless/rsi/rsi_91x_main.c            |  17 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |  24 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   5 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   5 +-
 drivers/net/wireless/rsi/rsi_hal.h                 |  11 +
 drivers/net/wireless/rsi/rsi_main.h                |  15 +-
 drivers/nfc/pn533/pn533.c                          |   6 +-
 drivers/nvdimm/btt.c                               |   1 -
 drivers/nvdimm/pmem.c                              |  13 +-
 drivers/nvme/host/multipath.c                      |   9 +-
 drivers/nvme/host/rdma.c                           |   2 +
 drivers/nvme/target/configfs.c                     |   2 +
 drivers/nvme/target/rdma.c                         |  24 ++
 drivers/nvme/target/tcp.c                          |  16 ++
 drivers/of/unittest.c                              |  16 +-
 drivers/opp/of.c                                   |   2 +-
 drivers/pci/controller/cadence/pci-j721e.c         |   2 +-
 drivers/pci/controller/cadence/pcie-cadence-plat.c |   2 +
 drivers/pci/controller/dwc/pcie-uniphier.c         |  26 +--
 drivers/pci/controller/pci-aardvark.c              | 251 +++++++++++++++++---
 drivers/pci/msi.c                                  |  36 +--
 drivers/pci/pci-bridge-emul.c                      |  13 ++
 drivers/pci/pci.c                                  |   8 +
 drivers/pci/quirks.c                               |   1 +
 drivers/phy/microchip/sparx5_serdes.c              |   4 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |   2 +-
 drivers/phy/qualcomm/phy-qcom-qusb2.c              |  16 +-
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c      |   2 +-
 drivers/phy/ti/phy-gmii-sel.c                      |   2 +
 drivers/pinctrl/core.c                             |   2 +
 drivers/pinctrl/pinctrl-equilibrium.c              |   7 +-
 drivers/pinctrl/renesas/core.c                     |   2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   2 +-
 .../platform/surface/surface_aggregator_registry.c |  54 +++++
 drivers/platform/x86/thinkpad_acpi.c               |   2 +-
 drivers/platform/x86/wmi.c                         |   9 +-
 drivers/power/reset/at91-reset.c                   |   4 +-
 drivers/power/supply/bq27xxx_battery_i2c.c         |   3 +-
 drivers/power/supply/max17040_battery.c            |   2 +
 drivers/power/supply/max17042_battery.c            |  12 +-
 drivers/power/supply/rt5033_battery.c              |   2 +-
 drivers/regulator/s5m8767.c                        |  21 +-
 drivers/remoteproc/imx_rproc.c                     |  41 ++--
 drivers/remoteproc/remoteproc_core.c               |   8 +-
 drivers/remoteproc/remoteproc_coredump.c           |   2 +-
 drivers/remoteproc/remoteproc_elf_loader.c         |   4 +-
 drivers/rtc/rtc-ds1302.c                           |   7 +
 drivers/rtc/rtc-ds1390.c                           |   7 +
 drivers/rtc/rtc-mcp795.c                           |   7 +
 drivers/rtc/rtc-pcf2123.c                          |   9 +
 drivers/rtc/rtc-rv3032.c                           |   4 +-
 drivers/s390/char/tape_std.c                       |   3 +-
 drivers/s390/cio/css.c                             |   4 +-
 drivers/s390/cio/device_ops.c                      |  12 +-
 drivers/s390/crypto/ap_queue.c                     |   2 +
 drivers/scsi/csiostor/csio_lnode.c                 |   2 +-
 drivers/scsi/dc395x.c                              |   1 +
 drivers/scsi/hosts.c                               |   1 +
 drivers/scsi/lpfc/lpfc_els.c                       |  12 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  10 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   5 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   7 +
 drivers/scsi/lpfc/lpfc_sli.c                       | 101 ++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  11 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |   2 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |   3 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  53 ++++-
 drivers/scsi/qedf/qedf_main.c                      |   2 +
 drivers/scsi/qla2xxx/qla_attr.c                    |  24 +-
 drivers/scsi/qla2xxx/qla_edif.c                    | 259 ++++++++++++---------
 drivers/scsi/qla2xxx/qla_edif.h                    |   3 +-
 drivers/scsi/qla2xxx/qla_edif_bsg.h                |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   4 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  77 ++++--
 drivers/scsi/qla2xxx/qla_mr.c                      |  23 --
 drivers/scsi/qla2xxx/qla_nvme.c                    |  14 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  37 +--
 drivers/scsi/qla2xxx/qla_target.c                  |   1 +
 drivers/scsi/scsi_error.c                          |  25 ++
 drivers/scsi/scsi_ioctl.c                          |   2 +
 drivers/scsi/scsi_lib.c                            |   3 +-
 drivers/scsi/scsi_sysfs.c                          |   1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   4 +-
 drivers/scsi/ufs/ufshcd.c                          | 186 +--------------
 drivers/scsi/ufs/ufshcd.h                          |  14 --
 drivers/scsi/ufs/ufshpb.c                          |  31 ++-
 drivers/scsi/ufs/ufshpb.h                          |   1 -
 drivers/soc/fsl/dpaa2-console.c                    |   1 +
 drivers/soc/fsl/dpio/dpio-service.c                |   2 +-
 drivers/soc/fsl/dpio/qbman-portal.c                |   9 +-
 drivers/soc/qcom/apr.c                             |   2 +
 drivers/soc/qcom/llcc-qcom.c                       |   2 +-
 drivers/soc/qcom/rpmhpd.c                          |  20 +-
 drivers/soc/qcom/socinfo.c                         |   4 +-
 drivers/soc/samsung/Kconfig                        |   1 +
 drivers/soc/tegra/pmc.c                            |   2 +-
 drivers/soundwire/bus.c                            |   2 +-
 drivers/soundwire/debugfs.c                        |   2 +-
 drivers/spi/atmel-quadspi.c                        |   2 +-
 drivers/spi/spi-bcm-qspi.c                         |   8 +-
 drivers/spi/spi-mtk-nor.c                          |   2 +-
 drivers/spi/spi-rpc-if.c                           |   4 +-
 drivers/spi/spi-stm32-qspi.c                       |   2 +-
 drivers/spi/spi.c                                  |  41 ++++
 drivers/staging/ks7010/Kconfig                     |   3 +
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c |  37 +--
 drivers/staging/media/imx/imx-media-dev-common.c   |   2 +
 drivers/staging/media/ipu3/ipu3-v4l2.c             |   7 +-
 drivers/staging/media/rkvdec/rkvdec-h264.c         |   5 +-
 drivers/staging/media/rkvdec/rkvdec.c              |  40 ++--
 drivers/staging/most/dim2/Makefile                 |   2 +-
 drivers/staging/most/dim2/dim2.c                   |  24 +-
 drivers/staging/most/dim2/sysfs.c                  |  49 ----
 drivers/staging/most/dim2/sysfs.h                  |  11 -
 drivers/staging/r8188eu/core/rtw_mlme.c            |   2 +
 drivers/target/target_core_tmr.c                   |  17 +-
 drivers/target/target_core_transport.c             |  30 ++-
 .../intel/int340x_thermal/processor_thermal_mbox.c |   1 +
 drivers/thermal/qcom/Kconfig                       |   2 +-
 drivers/thermal/qcom/tsens.c                       |  29 ++-
 drivers/thermal/thermal_core.c                     |  16 +-
 drivers/tty/serial/8250/8250_dw.c                  |   2 +-
 drivers/tty/serial/8250/8250_port.c                |  21 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   2 +
 drivers/tty/serial/imx.c                           |   4 +-
 drivers/tty/serial/serial_core.c                   |  16 +-
 drivers/tty/serial/xilinx_uartps.c                 |   3 +-
 drivers/usb/chipidea/core.c                        |  23 +-
 drivers/usb/dwc2/drd.c                             |  24 +-
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/gadget.c                          |   8 +-
 drivers/usb/gadget/legacy/hid.c                    |   4 +-
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-pci.c                        |  16 ++
 drivers/usb/misc/iowarrior.c                       |   8 +-
 drivers/usb/musb/Kconfig                           |   2 +-
 drivers/usb/serial/keyspan.c                       |  15 +-
 drivers/usb/typec/Kconfig                          |   4 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   1 -
 drivers/video/backlight/backlight.c                |   6 -
 drivers/video/fbdev/chipsfb.c                      |   2 +-
 drivers/video/fbdev/efifb.c                        |  21 +-
 drivers/virtio/virtio_ring.c                       |  14 +-
 drivers/watchdog/Kconfig                           |   2 +-
 drivers/watchdog/f71808e_wdt.c                     |   4 +-
 drivers/xen/balloon.c                              |  86 +++++--
 drivers/xen/xen-pciback/conf_space_capability.c    |   2 +-
 fs/btrfs/disk-io.c                                 |   3 +-
 fs/btrfs/reflink.c                                 |   2 +-
 fs/btrfs/tree-log.c                                |   4 +-
 fs/btrfs/volumes.c                                 |  14 +-
 fs/ceph/mdsmap.c                                   |   4 -
 fs/cifs/cifsglob.h                                 |   3 +-
 fs/cifs/connect.c                                  |  21 +-
 fs/cifs/file.c                                     |  35 ++-
 fs/cifs/fs_context.c                               |  10 +
 fs/cifs/fs_context.h                               |   1 +
 fs/crypto/fscrypt_private.h                        |   5 +-
 fs/crypto/hkdf.c                                   |  11 +-
 fs/crypto/keysetup.c                               |  57 ++++-
 fs/erofs/decompressor.c                            |   1 -
 fs/erofs/zdata.c                                   |  13 +-
 fs/erofs/zpvec.h                                   |  13 +-
 fs/exfat/inode.c                                   |   2 +-
 fs/ext4/extents.c                                  |  63 +++--
 fs/ext4/inode.c                                    |  15 +-
 fs/ext4/super.c                                    |   9 +-
 fs/f2fs/compress.c                                 |   1 +
 fs/f2fs/inode.c                                    |   2 +-
 fs/f2fs/namei.c                                    |   2 +-
 fs/f2fs/super.c                                    |   2 +
 fs/fuse/dev.c                                      |  14 +-
 fs/gfs2/glock.c                                    |  24 +-
 fs/io-wq.c                                         |  88 +++++--
 fs/io_uring.c                                      |   4 +-
 fs/jfs/jfs_mount.c                                 |  51 ++--
 fs/ksmbd/Kconfig                                   |   1 +
 fs/ksmbd/server.c                                  |   1 +
 fs/ksmbd/smb2misc.c                                |   6 +-
 fs/ksmbd/smb2pdu.c                                 |  11 +-
 fs/nfs/dir.c                                       |   9 +-
 fs/nfs/direct.c                                    |   2 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   4 +-
 fs/nfs/inode.c                                     |  13 +-
 fs/nfs/nfs3xdr.c                                   |   2 +-
 fs/nfs/nfs4idmap.c                                 |   2 +-
 fs/nfs/nfs4proc.c                                  |  15 +-
 fs/nfs/pnfs.h                                      |   2 +-
 fs/nfs/pnfs_nfs.c                                  |   6 +-
 fs/nfs/proc.c                                      |   2 +-
 fs/nfs/write.c                                     |  26 +--
 fs/ocfs2/file.c                                    |   8 +-
 fs/open.c                                          |  16 +-
 fs/orangefs/dcache.c                               |   4 +-
 fs/overlayfs/copy_up.c                             |  23 +-
 fs/overlayfs/file.c                                |  16 +-
 fs/overlayfs/inode.c                               |   5 +-
 fs/proc/stat.c                                     |   4 +-
 fs/proc/uptime.c                                   |  14 +-
 fs/quota/quota_tree.c                              |  15 ++
 fs/tracefs/inode.c                                 |   3 +-
 include/drm/ttm/ttm_bo_api.h                       |   3 +-
 include/linux/blkdev.h                             |   2 -
 include/linux/bpf-cgroup.h                         |   1 +
 include/linux/cc_platform.h                        |  88 +++++++
 include/linux/console.h                            |   2 +
 include/linux/cpufreq.h                            |   2 +-
 include/linux/dma-buf.h                            |   2 +-
 include/linux/dsa/ocelot.h                         |   1 +
 include/linux/ethtool_netlink.h                    |   3 +
 include/linux/filter.h                             |   5 +-
 include/linux/fortify-string.h                     |   5 +-
 include/linux/kernel_stat.h                        |   1 +
 include/linux/libata.h                             |   2 +-
 include/linux/msi.h                                |   2 +-
 include/linux/nfs_fs.h                             |   1 +
 include/linux/posix-timers.h                       |   2 +
 include/linux/rpmsg.h                              |   2 +-
 include/linux/sched/task.h                         |   3 +-
 include/linux/sched/task_stack.h                   |   4 +
 include/linux/seq_file.h                           |   2 +-
 include/linux/signal_types.h                       |   3 +
 include/linux/skmsg.h                              |  18 +-
 include/linux/surface_aggregator/controller.h      |   4 +-
 include/linux/tpm.h                                |   1 +
 include/media/videobuf2-core.h                     |  37 +--
 include/memory/renesas-rpc-if.h                    |   1 +
 include/net/inet_connection_sock.h                 |   2 +-
 include/net/llc.h                                  |   4 +-
 include/net/neighbour.h                            |  12 +-
 include/net/sch_generic.h                          |   4 +
 include/net/sctp/sctp.h                            |   7 +-
 include/net/sock.h                                 |   2 +-
 include/net/strparser.h                            |  20 +-
 include/net/tcp.h                                  |  17 +-
 include/rdma/ib_verbs.h                            |   7 +-
 include/scsi/scsi_cmnd.h                           |   2 +-
 include/scsi/scsi_host.h                           |   1 +
 include/sound/soc-topology.h                       |   3 +-
 include/uapi/asm-generic/signal-defs.h             |   1 +
 include/uapi/linux/ethtool_netlink.h               |   4 +-
 include/uapi/linux/pci_regs.h                      |   6 +
 init/main.c                                        |   4 +-
 kernel/bpf/trampoline.c                            |   6 +-
 kernel/bpf/verifier.c                              |   4 +-
 kernel/cgroup/cgroup.c                             |  31 ++-
 kernel/cgroup/rstat.c                              |   2 -
 kernel/debug/kdb/kdb_bt.c                          |  16 +-
 kernel/debug/kdb/kdb_main.c                        |  37 +--
 kernel/debug/kdb/kdb_private.h                     |   4 +-
 kernel/debug/kdb/kdb_support.c                     | 118 ++--------
 kernel/fork.c                                      |   3 +-
 kernel/irq/msi.c                                   |   4 +-
 kernel/kprobes.c                                   |   3 +-
 kernel/locking/lockdep.c                           |   4 +-
 kernel/locking/rwsem.c                             |  53 +++--
 kernel/power/energy_model.c                        |  23 +-
 kernel/power/swap.c                                |   7 +-
 kernel/rcu/rcutorture.c                            |  48 +++-
 kernel/rcu/tasks.h                                 |   3 +-
 kernel/rcu/tree.c                                  |   2 +-
 kernel/rcu/tree_exp.h                              |   2 +-
 kernel/rcu/tree_plugin.h                           |   8 +-
 kernel/sched/core.c                                |  43 ++--
 kernel/scs.c                                       |   1 +
 kernel/signal.c                                    |  26 +--
 kernel/time/posix-cpu-timers.c                     |  19 +-
 kernel/trace/ftrace.c                              |  23 +-
 kernel/trace/ring_buffer.c                         |   5 +
 kernel/trace/trace.c                               |  73 +++---
 kernel/trace/trace.h                               |   3 +
 kernel/trace/trace_boot.c                          |   4 +
 kernel/trace/trace_dynevent.c                      |   2 +-
 kernel/trace/trace_event_perf.c                    |   6 +-
 kernel/trace/trace_events.c                        |  42 ++--
 kernel/trace/trace_events_synth.c                  |   4 +-
 kernel/trace/trace_functions_graph.c               |   2 +-
 kernel/trace/trace_hwlat.c                         |   6 +-
 kernel/trace/trace_kprobe.c                        |   8 +-
 kernel/trace/trace_osnoise.c                       |  14 +-
 kernel/trace/trace_printk.c                        |   2 +-
 kernel/trace/trace_recursion_record.c              |   4 +-
 kernel/trace/trace_stack.c                         |   6 +-
 kernel/trace/trace_stat.c                          |   6 +-
 kernel/trace/trace_uprobe.c                        |   4 +-
 kernel/trace/tracing_map.c                         |  40 ++--
 kernel/workqueue.c                                 |  15 +-
 lib/crypto/sm4.c                                   |   4 +-
 lib/decompress_unxz.c                              |   2 +-
 lib/dynamic_debug.c                                |  12 +
 lib/iov_iter.c                                     |   5 +-
 lib/test_bpf.c                                     |  37 ++-
 lib/xz/xz_dec_lzma2.c                              |  21 +-
 lib/xz/xz_dec_stream.c                             |   6 +-
 mm/filemap.c                                       |   1 -
 mm/memcontrol.c                                    |  27 +--
 mm/oom_kill.c                                      |  23 +-
 mm/zsmalloc.c                                      |   7 +-
 net/8021q/vlan.c                                   |   3 -
 net/8021q/vlan_dev.c                               |   3 +
 net/9p/client.c                                    |   2 +
 net/bluetooth/l2cap_sock.c                         |  10 +-
 net/bluetooth/sco.c                                |  36 +--
 net/bridge/br_private.h                            |   2 +
 net/can/j1939/main.c                               |   7 +
 net/can/j1939/transport.c                          |  11 +
 net/core/dev.c                                     |   2 +
 net/core/filter.c                                  |  58 ++++-
 net/core/neighbour.c                               |  48 ++--
 net/core/net-sysfs.c                               |  55 +++++
 net/core/net_namespace.c                           |   4 +
 net/core/skmsg.c                                   |  43 +++-
 net/core/stream.c                                  |   3 -
 net/dccp/dccp.h                                    |   2 +-
 net/dccp/proto.c                                   |  14 +-
 net/dsa/switch.c                                   |   4 +-
 net/dsa/tag_ocelot.c                               |   3 +
 net/ethtool/pause.c                                |   3 +-
 net/ipv4/af_inet.c                                 |  16 +-
 net/ipv4/inet_connection_sock.c                    |   4 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/proc.c                                    |   2 +-
 net/ipv4/tcp.c                                     |  40 +++-
 net/ipv4/tcp_bpf.c                                 |  48 +++-
 net/ipv6/addrconf.c                                |   3 +
 net/ipv6/af_inet6.c                                |  21 +-
 net/ipv6/udp.c                                     |   2 +-
 net/mac80211/s1g.c                                 |   8 +-
 net/mctp/af_mctp.c                                 |  13 ++
 net/mptcp/options.c                                |   8 +-
 net/mptcp/protocol.c                               |  43 +++-
 net/netfilter/nf_conntrack_proto_udp.c             |   7 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/netfilter/nft_dynset.c                         |  11 +-
 net/rxrpc/rtt.c                                    |   2 +-
 net/sched/sch_generic.c                            |   9 +
 net/sched/sch_mq.c                                 |  24 ++
 net/sched/sch_mqprio.c                             |  23 ++
 net/sched/sch_taprio.c                             |  27 ++-
 net/sctp/output.c                                  |  13 +-
 net/sctp/transport.c                               |  11 +-
 net/smc/af_smc.c                                   |  18 +-
 net/strparser/strparser.c                          |  10 +-
 net/sunrpc/addr.c                                  |  40 ++--
 net/sunrpc/xprt.c                                  |  28 +--
 net/vmw_vsock/af_vsock.c                           |   2 +
 net/wireless/core.c                                |  10 +
 samples/bpf/xdp_redirect_cpu_user.c                |   6 +-
 samples/kprobes/kretprobe_example.c                |   2 +-
 scripts/leaking_addresses.pl                       |   3 +-
 security/apparmor/label.c                          |   4 +-
 security/integrity/evm/evm_main.c                  |   2 +-
 security/integrity/ima/ima_policy.c                |  27 ++-
 security/selinux/ss/services.c                     | 162 ++++++-------
 security/smack/smackfs.c                           |  11 +-
 sound/core/memalloc.c                              |   7 +-
 sound/core/oss/mixer_oss.c                         |  44 +++-
 sound/core/timer.c                                 |  17 +-
 sound/firewire/oxfw/oxfw-stream.c                  |   7 +-
 sound/firewire/oxfw/oxfw.c                         |   8 +
 sound/firewire/oxfw/oxfw.h                         |   5 +
 sound/pci/hda/hda_intel.c                          |  52 ++---
 sound/pci/hda/patch_realtek.c                      |  36 +++
 sound/pci/rme9652/hdsp.c                           |  41 ++--
 sound/pci/rme9652/rme9652.c                        |  41 ++--
 sound/soc/codecs/cs42l42.c                         |  27 ++-
 sound/soc/codecs/wcd9335.c                         |   2 +-
 sound/soc/sh/rcar/core.c                           |   1 +
 sound/soc/sof/topology.c                           |   9 +
 sound/soc/tegra/tegra_asoc_machine.c               |  60 ++++-
 sound/soc/tegra/tegra_asoc_machine.h               |   1 +
 sound/synth/emux/emux.c                            |   2 +-
 sound/usb/6fire/comm.c                             |   2 +-
 sound/usb/6fire/firmware.c                         |   6 +-
 sound/usb/card.h                                   |   1 +
 sound/usb/endpoint.c                               |   7 +-
 sound/usb/format.c                                 |   1 +
 sound/usb/line6/driver.c                           |  14 +-
 sound/usb/line6/driver.h                           |   2 +-
 sound/usb/line6/podhd.c                            |   6 +-
 sound/usb/line6/toneport.c                         |   2 +-
 sound/usb/misc/ua101.c                             |   4 +-
 sound/usb/quirks.c                                 |   1 +
 tools/arch/x86/lib/insn.c                          |   5 +-
 tools/bpf/bpftool/prog.c                           |  16 +-
 tools/include/asm-generic/unaligned.h              |  23 ++
 tools/lib/bpf/bpf.c                                |   4 +-
 tools/lib/bpf/bpf_core_read.h                      |   2 +-
 tools/lib/bpf/btf.c                                |  22 +-
 tools/lib/bpf/libbpf.c                             |   8 +-
 tools/lib/bpf/skel_internal.h                      |   6 +-
 tools/objtool/arch/x86/decode.c                    |  20 ++
 tools/objtool/check.c                              | 159 +++++++------
 tools/objtool/include/objtool/arch.h               |   1 +
 tools/perf/util/bpf-event.c                        |   4 +-
 tools/perf/util/intel-pt-decoder/Build             |   2 +
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |   4 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |   4 +-
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |   3 +-
 tools/testing/selftests/bpf/progs/strobemeta.h     |   4 +-
 tools/testing/selftests/bpf/test_progs.c           |   4 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       |  62 ++---
 .../testing/selftests/bpf/verifier/array_access.c  |   2 +-
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |   4 +-
 tools/testing/selftests/core/close_range_test.c    |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c       |  14 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c       |   2 +-
 tools/testing/selftests/net/Makefile               |   9 +-
 tools/testing/selftests/net/fib_nexthops.sh        |   1 +
 .../selftests/net/forwarding/bridge_igmp.sh        |  12 +-
 .../testing/selftests/net/forwarding/bridge_mld.sh |  12 +-
 tools/testing/selftests/net/gre_gso.sh             |   9 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   2 +-
 tools/testing/selftests/net/udpgso_bench_rx.c      |  11 +-
 tools/testing/selftests/sched/cs_prctl_test.c      |  28 ++-
 tools/testing/selftests/x86/iopl.c                 |  78 +++++--
 tools/tracing/latency/latency-collector.c          |   2 +-
 984 files changed, 8834 insertions(+), 5051 deletions(-)


