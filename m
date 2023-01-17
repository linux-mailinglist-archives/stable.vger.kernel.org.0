Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454FD66DE0A
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 13:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbjAQMsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 07:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbjAQMs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 07:48:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934207ED6;
        Tue, 17 Jan 2023 04:48:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 047D96130E;
        Tue, 17 Jan 2023 12:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C7AC433D2;
        Tue, 17 Jan 2023 12:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673959704;
        bh=wUzIlsvSt5DbqHOMGXpgTu/SsS6BmLbdgiadcrhtg70=;
        h=From:To:Cc:Subject:Date:From;
        b=OyOAZ1PYLkM+HdLm9GeOplGSxF0G3X9hwtsfQN37Zmbfmekg/nYAYyfqeOdDW8kgt
         7m940zFPN20U8ETW7iM1b2S8SFaenIRCPQvsmMq9liOco3UY7a3MQTHnLOsJep0bSB
         m6bUm5Z2svBoGUK7C6IwcIHt/oCJoXC9k9OUIOBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 000/622] 5.4.229-rc2 review
Date:   Tue, 17 Jan 2023 13:48:21 +0100
Message-Id: <20230117124648.308618956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.229-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.229-rc2
X-KernelTest-Deadline: 2023-01-19T12:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.229 release.
There are 622 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.229-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.229-rc2

Xin Long <lucien.xin@gmail.com>
    tipc: call tipc_lxc_xmit without holding node_read_lock

Heming Zhao <ocfs2-devel@oss.oracle.com>
    ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: Add a missing case of TIPC_DIRECT_MSG type

Dmitry Osipenko <digetx@gmail.com>
    tty: serial: tegra: Handle RX transfer in PIO mode if DMA wasn't started

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix use-after-free in tipc_disc_rcv()

Ferry Toth <ftoth@exalondelft.nl>
    Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"

Aaron Thompson <dev@aaront.org>
    mm: Always release pages to the buddy allocator in memblock_free_late().

Johan Hovold <johan+linaro@kernel.org>
    efi: fix NULL-deref in init error path

Mark Rutland <mark.rutland@arm.com>
    arm64: cmpxchg_double*: hazard against entire exchange variable

Mark Rutland <mark.rutland@arm.com>
    arm64: atomics: remove LL/SC trampolines

Mark Rutland <mark.rutland@arm.com>
    arm64: atomics: format whitespace consistently

Rob Clark <robdclark@chromium.org>
    drm/virtio: Fix GEM handle creation UAF

Peter Newman <peternewman@google.com>
    x86/resctrl: Fix task CLOSID/RMID update race

Reinette Chatre <reinette.chatre@intel.com>
    x86/resctrl: Use task_curr() instead of task_struct->on_cpu to prevent unnecessary IPI

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek-v1: Add error handle for mtk_iommu_probe

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5: Fix ptp max frequency adjustment range

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Rename ptp clock info

Ido Schimmel <idosch@nvidia.com>
    net/sched: act_mpls: Fix warning during failed attribute validation

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Roger Pau Monne <roger.pau@citrix.com>
    hvc/xen: lock console list traversal

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix unexpected link reset due to discovery messages

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: eliminate checking netns if node established

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: improve throughput between nodes in netns

Ricardo Ribalda <ribalda@chromium.org>
    regulator: da9211: Use irq handler when ready

Eliav Farber <farbere@amazon.com>
    EDAC/device: Fix period calculation in edac_device_reset_delay_period()

Peter Zijlstra <peterz@infradead.org>
    x86/boot: Avoid using Intel mnemonics in AT&T syntax asm

Kajol Jain <kjain@linux.ibm.com>
    powerpc/imc-pmu: Fix use of mutex in IRQs disabled section

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Ye Bin <yebin10@huawei.com>
    ext4: fix uninititialized value in 'ext4_evict_inode'

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_orphan_cleanup

zhengliang <zhengliang6@huawei.com>
    ext4: lost matching-pair of trace in ext4_truncate

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on in __es_tree_search caused by bad quota inode

Jan Kara <jack@suse.cz>
    quota: Factor out setup of quota inode

Bixuan Cui <cuibixuan@linux.alibaba.com>
    jbd2: use the correct print format

Ferry Toth <ftoth@exalondelft.nl>
    usb: ulpi: defer ulpi_register on ulpi_read_id timeout

Michael Walle <michael@walle.cc>
    wifi: wilc1000: sdio: fix module autoloading

Herbert Xu <herbert@gondor.apana.org.au>
    ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Yang Yingliang <yangyingliang@huawei.com>
    ixgbe: fix pci device refcount leak

Hans de Goede <hdegoede@redhat.com>
    platform/x86: sony-laptop: Don't turn off 0x153 keyboard backlight during probe

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/adreno: Make adreno quirks not overwrite each other

Volker Lendecke <vl@samba.org>
    cifs: Fix uninitialized memory read for smb311 posix symlink create

Adrian Chan <adchan@google.com>
    ALSA: hda/hdmi: Add a HP device 0x8715 to force connect list

Clement Lecigne <clecigne@google.com>
    ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF

Paolo Abeni <pabeni@redhat.com>
    net/ulp: prevent ULP without clone op from entering the LISTEN status

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/kexec: fix ipl report address for kdump

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix address filter duplicate symbol selection

Jonathan Corbet <corbet@lwn.net>
    docs: Fix the docs build with Sphinx 6.0

Ard Biesheuvel <ardb@kernel.org>
    efi: tpm: Avoid READ_ONCE() for accessing the event log

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix S1PTW handling on RO memslots

Frederick Lawler <fred@cloudflare.com>
    net: sched: disallow noqueue for qdisc classes

Isaac J. Manjarres <isaacmanjarres@google.com>
    driver core: Fix bus_type.match() error handling in __driver_attach()

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests: set the BUILD variable to absolute path

Shuah Khan <skhan@linuxfoundation.org>
    selftests: Fix kselftest O=objdir build from cluttering top level objdir

Helge Deller <deller@gmx.de>
    parisc: Align parisc MADV_XXX constants with all other architectures

Jan Kara <jack@suse.cz>
    mbcache: Avoid nesting of cache->c_list_lock under bit locks

Linus Torvalds <torvalds@linux-foundation.org>
    hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling

Arnd Bergmann <arnd@arndb.de>
    hfs/hfsplus: use WARN_ON for sanity check

Eric Biggers <ebiggers@google.com>
    ext4: don't allow journal inode to have encrypt flag

Ben Dooks <ben-linux@fluff.org>
    riscv: uaccess: fix type of 0 variable on error in get_user()

Jeff Layton <jlayton@kernel.org>
    nfsd: fix handling of readdir in v4root vs. mount upcall timeout

Rodrigo Branco <bsdaemon@google.com>
    x86/bugs: Flush IBP in ib_prctl_set()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Advantech MICA-071 tablet

Jan Kara <jack@suse.cz>
    udf: Fix extension of the last extent in the file

Zhengchao Shao <shaozhengchao@huawei.com>
    caif: fix memory leak in cfctrl_linkup_request()

Dan Carpenter <error27@gmail.com>
    drm/i915: unpin on error in intel_vgpu_shadow_mm_pin()

Szymon Heidrich <szymon.heidrich@gmail.com>
    usb: rndis_host: Secure rndis_query check against int overflow

Daniil Tatianin <d-tatianin@yandex-team.ru>
    drivers/net/bonding/bond_3ad: return when there's no aggregator

Miaoqian Lin <linmq006@gmail.com>
    perf tools: Fix resources leak in perf_data__open_dir()

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: cbq: dont intepret cls results when asked to drop

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: atm: dont intepret cls results when asked to drop

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Fix validation of max_rd_atomic caps for DC

Leon Romanovsky <leon@kernel.org>
    RDMA/uverbs: Silence shiftTooManyBitsSigned warning

Miaoqian Lin <linmq006@gmail.com>
    net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe

Jiguang Xiao <jiguang.xiao@windriver.com>
    net: amd-xgbe: add missed tasklet_kill

Stefano Garzarella <sgarzare@redhat.com>
    vhost: fix range used in translate_desc()

Miaoqian Lin <linmq006@gmail.com>
    nfc: Fix potential resource leaks

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure

Hawkins Jiawei <yin31149@gmail.com>
    net: sched: fix memory leak in tcindex_set_parms

Jie Wang <wangjie125@huawei.com>
    net: hns3: add interrupts re-initialization while doing VF FLR

Jeff Layton <jlayton@kernel.org>
    nfsd: shut down the NFSv4 state objects before the filecache

Jakub Kicinski <kuba@kernel.org>
    bpf: pull before calling skb_postpull_rcsum()

minoura makoto <minoura@valinux.co.jp>
    SUNRPC: ensure the matching upcall is in-flight upon downcall

Jan Kara <jack@suse.cz>
    ext4: fix deadlock due to mbcache entry corruption

Jan Kara <jack@suse.cz>
    mbcache: automatically delete entries from cache on freeing

Jan Kara <jack@suse.cz>
    ext4: fix race when reusing xattr blocks

Jan Kara <jack@suse.cz>
    ext4: unindent codeblock in ext4_xattr_block_set()

Jan Kara <jack@suse.cz>
    ext4: remove EA inode entry from mbcache on inode eviction

Jan Kara <jack@suse.cz>
    mbcache: add functions to delete entry if unused

Jan Kara <jack@suse.cz>
    mbcache: don't reclaim used entries

Shuqi Zhang <zhangshuqi3@huawei.com>
    ext4: use kmemdup() to replace kmalloc + memcpy

Alexander Potapenko <glider@google.com>
    fs: ext4: initialize fsdata in pagecache_write()

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    ext4: use memcpy_to_page() in pagecache_write()

Ira Weiny <ira.weiny@intel.com>
    mm/highmem: Lift memcpy_[to|from]_page to core

Baokun Li <libaokun1@huawei.com>
    ext4: correct inconsistent error msg in nojournal mode

Jason Yan <yanaijie@huawei.com>
    ext4: goto right label 'failed_mount3a'

Biju Das <biju.das.jz@bp.renesas.com>
    ravb: Fix "failed to switch device to config mode" message during unbind

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: VMX: Fix the spelling of CPU_BASED_USE_TSC_OFFSETTING

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: VMX: Rename NMI_PENDING to NMI_WINDOW

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: VMX: Rename INTERRUPT_PENDING to INTERRUPT_WINDOW

Andrea Arcangeli <aarcange@redhat.com>
    KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers

Andrea Arcangeli <aarcange@redhat.com>
    KVM: x86: optimize more exit handlers in vmx.c

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    perf probe: Use dwarf_attr_integrate as generic DWARF attr accessor

Luo Meng <luomeng12@huawei.com>
    dm thin: resume even if in FAIL mode

Smitha T Murthy <smitha.t@samsung.com>
    media: s5p-mfc: Fix in register read and write for H264

Smitha T Murthy <smitha.t@samsung.com>
    media: s5p-mfc: Clear workbit to handle error condition

Smitha T Murthy <smitha.t@samsung.com>
    media: s5p-mfc: Fix to handle reference queue during finishing

Kant Fan <kant@allwinnertech.com>
    PM/devfreq: governor: Add a private governor_data for governor

Sasha Levin <sashal@kernel.org>
    btrfs: replace strncpy() with strscpy()

Ye Bin <yebin10@huawei.com>
    ext4: allocate extended attribute value in vmalloc area

Jan Kara <jack@suse.cz>
    ext4: avoid unaccounted block allocation when expanding inode

Jan Kara <jack@suse.cz>
    ext4: initialize quota before expanding inode in setproject ioctl

Ye Bin <yebin10@huawei.com>
    ext4: fix inode leak in ext4_xattr_inode_create() on an error path

Jan Kara <jack@suse.cz>
    ext4: avoid BUG_ON when creating xattrs

Luís Henriques <lhenriques@suse.de>
    ext4: fix error code return to user-space in ext4_get_branch()

Baokun Li <libaokun1@huawei.com>
    ext4: fix corruption when online resizing a 1K bigalloc fs

Eric Whitney <enwlinux@gmail.com>
    ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline

Ye Bin <yebin10@huawei.com>
    ext4: init quota for 'old.inode' in 'ext4_rename'

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on in __es_tree_search caused by bad boot loader inode

Ye Bin <yebin10@huawei.com>
    ext4: fix reserved cluster accounting in __es_remove_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: add helper to check quota inums

Baokun Li <libaokun1@huawei.com>
    ext4: add EXT4_IGET_BAD flag to prevent unexpected bad inode

Gaosheng Cui <cuigaosheng1@huawei.com>
    ext4: fix undefined behavior in bit shift for ext4_check_flag_values

Baokun Li <libaokun1@huawei.com>
    ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Validate the box size for the snooped cursor

Simon Ser <contact@emersion.fr>
    drm/connector: send hotplug uevent on connector cleanup

Wang Weiyang <wangweiyang2@huawei.com>
    device_cgroup: Roll back to original exceptions after copy failure

Shang XiaoJing <shangxiaojing@huawei.com>
    parisc: led: Fix potential null-ptr-deref in start_task()

Kim Phillips <kim.phillips@amd.com>
    iommu/amd: Fix ivrs_acpihid cmdline parsing code

Corentin Labbe <clabbe@baylibre.com>
    crypto: n2 - add missing hash statesize

Sascha Hauer <s.hauer@pengutronix.de>
    PCI/sysfs: Fix double free in error path

Michael S. Tsirkin <mst@redhat.com>
    PCI: Fix pci_device_is_present() for VFs by checking PF

Dan Carpenter <error27@gmail.com>
    ipmi: fix use after free in _ipmi_destroy_user()

Huaxin Lu <luhuaxin1@huawei.com>
    ima: Fix a potential NULL pointer access in ima_restore_measurement_list

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()

Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
    ipmi: fix long wait in unload when IPMI disconnect

Aditya Garg <gargaditya08@live.com>
    efi: Add iMac Pro 2017 to uefi skip cert quirk

Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
    md/bitmap: Fix bitmap chunk size overflow issues

Steve French <stfrench@microsoft.com>
    cifs: fix missing display of three mount options

Paulo Alcantara <pc@cjr.nz>
    cifs: fix confusing debug message

Takashi Iwai <tiwai@suse.de>
    media: dvb-core: Fix UAF due to refcount races at releasing

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    media: dvb-core: Fix double free in dvb_register_device()

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod

Yang Jihong <yangjihong1@huawei.com>
    tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix wrong return value in parse_action_params()

Ashok Raj <ashok.raj@intel.com>
    x86/microcode/intel: Do not retry microcode reloading on the APs

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix out-of-bound write on 'action_data.var_ref_idx'

Mike Snitzer <snitzer@kernel.org>
    dm cache: set needs_check flag after aborting metadata

Luo Meng <luomeng12@huawei.com>
    dm cache: Fix UAF in destroy()

Luo Meng <luomeng12@huawei.com>
    dm clone: Fix UAF in clone_dtr()

Luo Meng <luomeng12@huawei.com>
    dm integrity: Fix UAF in dm_integrity_dtr()

Luo Meng <luomeng12@huawei.com>
    dm thin: Fix UAF in run_timer_softirq()

Zhihao Cheng <chengzhihao1@huawei.com>
    dm thin: Use last transaction's pmd->root when commit failed

Zhihao Cheng <chengzhihao1@huawei.com>
    dm thin: Fix ABBA deadlock between shrink_slab and dm_pool_abort_metadata

Mike Snitzer <snitzer@kernel.org>
    dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort

Wang Yufen <wangyufen@huawei.com>
    binfmt: Fix error return code in load_elf_fdpic_binary()

Eric W. Biederman <ebiederm@xmission.com>
    binfmt: Move install_exec_creds after setup_new_exec to match binfmt_elf

Yongqiang Liu <liuyongqiang13@huawei.com>
    cpufreq: Init completion before kobject_init_and_add()

Mickaël Salaün <mic@digikod.net>
    selftests: Use optional USERCFLAGS and USERLDFLAGS

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength

Jason A. Donenfeld <Jason@zx2c4.com>
    ARM: ux500: do not directly dereference __iomem

Boris Burkov <boris@bur.io>
    btrfs: fix resolving backrefs for inline extent followed by prealloc

Wenchao Chen <wenchao.chen@unisoc.com>
    mmc: sdhci-sprd: Disable CLK_AUTO when the clock is less than 400K

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl minconfig: Unset configs instead of just removing them

Steven Rostedt <rostedt@goodmis.org>
    kest.pl: Fix grub2 menu handling for rebooting

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    soc: qcom: Select REMAP_MMIO for LLCC driver

Jason A. Donenfeld <Jason@zx2c4.com>
    media: stv0288: use explicitly signed char

Eric Dumazet <edumazet@google.com>
    net/af_packet: make sure to pull mac header

Hangbin Liu <liuhangbin@gmail.com>
    net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Don't leak netobj memory when gss_read_proxy_verf() fails

Hanjun Guo <guohanjun@huawei.com>
    tpm: tpm_tis: Add the missed acpi_put_table() to fix memory leak

Hanjun Guo <guohanjun@huawei.com>
    tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak

Deren Wu <deren.wu@mediatek.com>
    mmc: vub300: fix warning - do not call blocking ops when !TASK_RUNNING

Pavel Machek <pavel@denx.de>
    f2fs: should put a page when checking the summary info

NARIBAYASHI Akira <a.naribayashi@fujitsu.com>
    mm, compaction: fix fast_isolate_around() to stay within boundaries

Mikulas Patocka <mpatocka@redhat.com>
    md: fix a crash in mempool_free

Christian Brauner <brauner@kernel.org>
    pnode: terminate at peers of source

Artem Egorkine <arteme@gmail.com>
    ALSA: line6: fix stack overflow in line6_midi_transmit

Artem Egorkine <arteme@gmail.com>
    ALSA: line6: correct midi status byte when receiving data from podxt

Zhang Tianci <zhangtianci.1997@bytedance.com>
    ovl: Use ovl mounter's fsuid and fsgid in ovl_link()

Aditya Garg <gargaditya08@live.com>
    hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: plantronics: Additional PIDs for double volume key presses quirk

José Expósito <jose.exposito89@gmail.com>
    HID: multitouch: fix Asus ExpertBook P2 P2451FA trackpoint

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: avoid scheduling in rtas_os_term()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: avoid device tree lookups in rtas_os_term()

Christophe Leroy <christophe.leroy@csgroup.eu>
    objtool: Fix SEGFAULT

Christoph Hellwig <hch@lst.de>
    nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition

Revanth Rajashekar <revanth.rajashekar@intel.com>
    nvme: resync include/linux/nvme.h with nvmecli

Adam Vodopjan <grozzly@protonmail.com>
    ata: ahci: Fix PCS quirk application for suspend

Klaus Jensen <k.jensen@samsung.com>
    nvme-pci: fix doorbell buffer value endianness

Paulo Alcantara <pc@cjr.nz>
    cifs: fix oops during encryption

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: fix refcnt bug

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: fix build warning due to comments

Rickard x Andersson <rickaran@axis.com>
    gcov: add support for checksum field

Johan Hovold <johan+linaro@kernel.org>
    regulator: core: fix deadlock on regulator enable

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    iio: adc128s052: add proper .data members in adc128_of_match table

Nuno Sá <nuno.sa@analog.com>
    iio: adc: ad_sigma_delta: do not use internal iio_dev lock

Roberto Sassu <roberto.sassu@huawei.com>
    reiserfs: Add missing calls to reiserfs_security_free()

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Ensure bootloader PID is usable in hidraw mode

Ferry Toth <ftoth@exalondelft.nl>
    usb: dwc3: core: defer probe on ulpi_read_id timeout

Jiao Zhou <jiaozhou@google.com>
    ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list

Edward Pacman <edward@edward-p.xyz>
    ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB

John Stultz <jstultz@google.com>
    pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES

John Stultz <jstultz@google.com>
    pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5670: Remove unbalanced pm_runtime_put()

Wang Jingjin <wangjingjin1@huawei.com>
    ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: Fix potential deadlock

Wang Jingjin <wangjingjin1@huawei.com>
    ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()

Wang Yufen <wangyufen@huawei.com>
    ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()

Wang Yufen <wangyufen@huawei.com>
    ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Fix driver hang during shutdown

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: add snd_hdac_stop_streams() helper

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA/ASoC: hda: move/rename snd_hdac_ext_stop_streams to hdac_stream.c

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()

Nathan Chancellor <nathan@kernel.org>
    drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

Nathan Chancellor <nathan@kernel.org>
    drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()

Hawkins Jiawei <yin31149@gmail.com>
    hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: st: Fix memory leak in st_of_quadfs_setup()

Shigeru Yoshida <syoshida@redhat.com>
    media: si470x: Fix use-after-free in si470x_int_in_callback()

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    mmc: f-sdh30: Add quirks for broken timeout clock capability

Rui Zhang <zr.zhang@vivo.com>
    regulator: core: fix use_count leakage when handling boot-on

Ye Bin <yebin10@huawei.com>
    blk-mq: fix possible memleak when register 'hctx' failed

Mazin Al Haddad <mazinalhaddad05@gmail.com>
    media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: adopts refcnt to avoid UAF

Yan Lei <yan_lei@dahuatech.com>
    media: dvb-frontends: fix leak of memory fw

Stanislav Fomichev <sdf@google.com>
    bpf: Prevent decl_tag from being referenced in func_proto arg

Stanislav Fomichev <sdf@google.com>
    ppp: associate skb with a device at tx

Schspa Shi <schspa@gmail.com>
    mrp: introduce active flags to prevent UAF when applicant uninit

Eric Dumazet <edumazet@google.com>
    net: add atomic_long_t to net_device_stats fields

Jiang Li <jiang.li@ugreen.com>
    md/raid1: stop mdx_raid1 thread when raid1 array run failed

Li Zhong <floridsleeves@gmail.com>
    drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/sti: Use drm_mode_copy()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/rockchip: Use drm_mode_copy()

Nathan Chancellor <nathan@kernel.org>
    s390/lcs: Fix return type of lcs_start_xmit()

Nathan Chancellor <nathan@kernel.org>
    s390/netiucv: Fix return type of netiucv_tx()

Nathan Chancellor <nathan@kernel.org>
    s390/ctcm: Fix return type of ctc{mp,}m_tx()

Kees Cook <keescook@chromium.org>
    igb: Do not free q_vector unless new one was allocated

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()

Nathan Chancellor <nathan@kernel.org>
    hamradio: baycom_epp: Fix return type of baycom_send_packet()

Nathan Chancellor <nathan@kernel.org>
    net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()

Stanislav Fomichev <sdf@google.com>
    bpf: make sure skb->len != 0 when redirecting to a tunneling device

Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
    ipmi: fix memleak when unload ipmi driver

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: codecs: rt298: Add quirk for KBL-R RVP platform

Shigeru Yoshida <syoshida@redhat.com>
    wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: verify the expected usb_endpoints are present

Wright Feng <wright.feng@cypress.com>
    brcmfmac: return error when getting invalid max_flowrings from dongle

Doug Brown <doug@schmorgal.com>
    drm/etnaviv: add missing quirks for GC300

ZhangPeng <zhangpeng362@huawei.com>
    hfs: fix OOB Read in __hfs_brec_find

Zheng Yejian <zhengyejian1@huawei.com>
    acct: fix potential integer overflow in encode_comp_t()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Fix error code path in acpi_ds_call_control_method()

Hoi Pok Wu <wuhoipok@gmail.com>
    fs: jfs: fix shift-out-of-bounds in dbDiscardAG

Shigeru Yoshida <syoshida@redhat.com>
    udf: Avoid double brelse() in udf_rename()

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: jfs: fix shift-out-of-bounds in dbAllocAG

Liu Shixin <liushixin2@huawei.com>
    binfmt_misc: fix shift-out-of-bounds in check_special_flags

Zqiang <qiang1.zhang@intel.com>
    rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state()

Eric Dumazet <edumazet@google.com>
    net: stream: purge sk_error_queue in sk_stream_kill_queues()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    myri10ge: Fix an error handling path in myri10ge_probe()

David Howells <dhowells@redhat.com>
    rxrpc: Fix missing unlock in rxrpc_do_sendmsg()

Cong Wang <cong.wang@bytedance.com>
    net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Yang Yingliang <yangyingliang@huawei.com>
    mailbox: zynq-ipi: fix error handling while device_register() fails

Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
    skbuff: Account for tail adjustment during pull operations

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: Fix flow lookup to use unmasked key

GUO Zihua <guozihua@huawei.com>
    rtc: mxc_v2: Add missing clk_disable_unprepare()

Li Zetao <lizetao1@huawei.com>
    r6040: Fix kmemleak in probe and remove

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    nfc: pn533: Clear nfc_target before being used

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Dan Aloni <dan.aloni@vastdata.com>
    nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add tracepoints to NFSD's duplicate reply cache

Trond Myklebust <trondmy@gmail.com>
    nfsd: Define the file access mode enum for tracing

Gaosheng Cui <cuigaosheng1@huawei.com>
    rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()

Gaosheng Cui <cuigaosheng1@huawei.com>
    rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()

Yuan Can <yuancan@huawei.com>
    remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()

Gaosheng Cui <cuigaosheng1@huawei.com>
    remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Call pwm_sifive_update_clock() while mutex is held

Miaoqian Lin <linmq006@gmail.com>
    selftests/powerpc: Fix resource leaks

Kajol Jain <kjain@linux.ibm.com>
    powerpc/hv-gpci: Fix hv_gpci event list

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/perf: callchain validate kernel stack pointer bounds

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()

Miaoqian Lin <linmq006@gmail.com>
    cxl: Fix refcount leak in cxl_calc_capp_routing

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    powerpc/52xx: Fix a resource leak in an error handling path

Xie Shaowen <studentxswpy@163.com>
    macintosh/macio-adb: check the return value of ioremap()

Yang Yingliang <yangyingliang@huawei.com>
    macintosh: fix possible memory leak in macio_add_one_device()

Yuan Can <yuancan@huawei.com>
    iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()

Yang Yingliang <yangyingliang@huawei.com>
    iommu/amd: Fix pci device refcount leak in ppr_notifier()

Alexander Stein <alexander.stein@ew.tq-group.com>
    rtc: pcf85063: Fix reading alarm

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    rtc: snvs: Allow a time difference on clock register read

Matt Redfearn <matt.redfearn@mips.com>
    include/uapi/linux/swab: Fix potentially missing __always_inline

Arnd Bergmann <arnd@arndb.de>
    RDMA/siw: Fix pointer cast warning

ruanjinjie <ruanjinjie@huawei.com>
    power: supply: fix null pointer dereferencing in power_supply_get_battery_info

Yuan Can <yuancan@huawei.com>
    HSI: omap_ssi_core: Fix error handling in ssi_init()

Ajay Kaher <akaher@vmware.com>
    perf symbol: correction while adjusting symbol

Leo Yan <leo.yan@linaro.org>
    perf trace: Handle failure when trace point folder is missed

Leo Yan <leo.yan@linaro.org>
    perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf trace: Add a strtoul() method to 'struct syscall_arg_fmt'

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf trace: Allow associating scnprintf routines with well known arg names

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf trace: Add the syscall_arg_fmt pointer to syscall_arg

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf trace: Factor out the initialization of syscal_arg_fmt->scnprintf

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf trace: Separate 'struct syscall_fmt' definition from syscall_fmts variable

Leo Yan <leo.yan@linaro.org>
    perf trace: Return error if a system call doesn't exist

Zeng Heng <zengheng4@huawei.com>
    power: supply: fix residue sysfs file in error handle route of __power_supply_register()

Yang Yingliang <yangyingliang@huawei.com>
    HSI: omap_ssi_core: fix possible memory leak in ssi_probe()

Yang Yingliang <yangyingliang@huawei.com>
    HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    fbdev: vermilion: decrease reference count in error path

Shang XiaoJing <shangxiaojing@huawei.com>
    fbdev: via: Fix error in via_core_init()

Yang Yingliang <yangyingliang@huawei.com>
    fbdev: pm2fb: fix missing pci_disable_device()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fbdev: ssd1307fb: Drop optional dependency

Shang XiaoJing <shangxiaojing@huawei.com>
    samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix issue of losting command info in error_log

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    usb: storage: Add check for kcalloc

Zheyu Ma <zheyuma97@gmail.com>
    i2c: ismt: Fix an out-of-bounds bug in ismt_access()

Chen Zhongjin <chenzhongjin@huawei.com>
    vme: Fix error not catched in fake_init()

YueHaibing <yuehaibing@huawei.com>
    staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()

Dan Carpenter <error27@gmail.com>
    staging: rtl8192u: Fix use after free in ieee80211_rx()

Hui Tang <tanghui20@huawei.com>
    i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe

Yang Yingliang <yangyingliang@huawei.com>
    chardev: fix error handling in cdev_device_add()

Yang Yingliang <yangyingliang@huawei.com>
    mcb: mcb-parse: fix error handing in chameleon_parse_gdd()

Zhengchao Shao <shaozhengchao@huawei.com>
    drivers: mcb: fix resource leak in mcb_probe()

John Keeping <john@metanate.com>
    usb: gadget: f_hid: fix refcount leak on error path

John Keeping <john@metanate.com>
    usb: gadget: f_hid: fix f_hidg lifetime vs cdev

Maxim Devaev <mdevaev@gmail.com>
    usb: gadget: f_hid: optional SETUP/SET_REPORT mode

Yang Yingliang <yangyingliang@huawei.com>
    usb: roles: fix of node refcount leak in usb_role_switch_is_parent()

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-lptimer-cnt: fix the check on arr and cmp registers update

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()

Zheng Wang <zyytlz.wz@163.com>
    misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os

ruanjinjie <ruanjinjie@huawei.com>
    misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()

Yang Yingliang <yangyingliang@huawei.com>
    misc: ocxl: fix possible name leak in ocxl_file_register_afu()

Zhengchao Shao <shaozhengchao@huawei.com>
    test_firmware: fix memory leak in test_firmware_init()

Yuan Can <yuancan@huawei.com>
    serial: sunsab: Fix error handling in sunsab_init()

Gabriel Somlo <gsomlo@gmail.com>
    serial: altera_uart: fix locking in polling mode

Jiri Slaby <jslaby@suse.cz>
    tty: serial: altera_uart_{r,t}x_chars() need only uart_port

Jiri Slaby <jslaby@suse.cz>
    tty: serial: clean up stop-tx part in altera_uart_tx_chars()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    serial: pch: Fix PCI device refcount leak in pch_request_dma()

delisun <delisun@pateo.com.cn>
    serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.

Jiamei Xie <jiamei.xie@arm.com>
    serial: amba-pl011: avoid SBSA UART accessing DMACR register

Yang Yingliang <yangyingliang@huawei.com>
    usb: typec: tcpci: fix of node refcount leak in tcpci_register_port()

Sven Peter <sven@svenpeter.dev>
    usb: typec: Check for ops->exit instead of ops->enter in altmode_exit

Gaosheng Cui <cuigaosheng1@huawei.com>
    staging: vme_user: Fix possible UAF in tsi148_dma_list_add

Linus Walleij <linus.walleij@linaro.org>
    usb: fotg210-udc: Fix ages old endianness issues

Rafael Mendonca <rafaelmendsr@gmail.com>
    uio: uio_dmem_genirq: Fix deadlock between irq config and handling

Rafael Mendonca <rafaelmendsr@gmail.com>
    uio: uio_dmem_genirq: Fix missing unlock in irq configuration

Rafael Mendonca <rafaelmendsr@gmail.com>
    vfio: platform: Do not pass return buffer to ACPI _RST method

Yang Yingliang <yangyingliang@huawei.com>
    class: fix possible memory leak in __class_register()

Kartik <kkartik@nvidia.com>
    serial: tegra: Read DMA status before terminating

Dmitry Osipenko <digetx@gmail.com>
    tty: serial: tegra: Activate RX DMA transfer by request

Yang Yingliang <yangyingliang@huawei.com>
    drivers: dio: fix possible memory leak in dio_init()

Dragos Tatulea <dtatulea@nvidia.com>
    IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hwrng: geode - Fix PCI device refcount leak

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hwrng: amd - Fix PCI device refcount leak

Gaosheng Cui <cuigaosheng1@huawei.com>
    crypto: img-hash - Fix variable dereferenced before check 'hdev->req'

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix sysfs not cleanup when dev init failed

Wang Yufen <wangyufen@huawei.com>
    RDMA/hfi1: Fix error return code in parse_platform_config()

Shang XiaoJing <shangxiaojing@huawei.com>
    crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()

Yonggil Song <yonggil.song@samsung.com>
    f2fs: avoid victim selection from previous victim section

Yuan Can <yuancan@huawei.com>
    RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()

Gaosheng Cui <cuigaosheng1@huawei.com>
    scsi: snic: Fix possible UAF in snic_tgt_create()

Chen Zhongjin <chenzhongjin@huawei.com>
    scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails

Shang XiaoJing <shangxiaojing@huawei.com>
    scsi: ipr: Fix WARNING in ipr_init()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: fcoe: Fix possible name leak when device_register() fails

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix error handling in hpsa_add_sas_host()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()

Zhang Yiqun <zhangyiqun@phytium.com.cn>
    crypto: tcrypt - Fix multibuffer skcipher speed test mem leak

Yuan Can <yuancan@huawei.com>
    scsi: hpsa: Fix possible memory leak in hpsa_init_one()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    crypto: ccree - Make cc_debugfs_global_fini() available for module init function

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    RDMA/hfi: Decrease PCI device reference count in error path

Zeng Heng <zengheng4@huawei.com>
    PCI: Check for alloc failure in pci_request_irq()

Gaosheng Cui <cuigaosheng1@huawei.com>
    crypto: ccree - Remove debugfs when platform_driver_register failed

Geert Uytterhoeven <geert+renesas@glider.be>
    crypto: ccree - swap SHA384 and SHA512 larval hashes at build time

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    scsi: scsi_debug: Fix a warning in resp_write_scat()

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Set defined status for work completion with undefined status

Mark Zhang <markzhang@nvidia.com>
    RDMA/nldev: Return "-EAGAIN" if the cm_id isn't from expected port

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix immediate work request flush to completion queue

Dongdong Zhang <zhangdongdong1@oppo.com>
    f2fs: fix normal discard process

Leon Romanovsky <leonro@nvidia.com>
    RDMA/core: Fix order of nldev_exit call

Xiu Jianfeng <xiujianfeng@huawei.com>
    apparmor: Use pointer to struct aa_label for lbs_cred

John Johansen <john.johansen@canonical.com>
    apparmor: Fix abi check to include v8 abi

John Johansen <john.johansen@canonical.com>
    apparmor: fix lockdep warning when removing a namespace

Gaosheng Cui <cuigaosheng1@huawei.com>
    apparmor: fix a memleak in multi_transaction_new()

Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
    stmmac: fix potential division by 0

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: RFCOMM: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_core: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_bcsp: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_h5: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_ll: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()

Eric Pilmore <epilmore@gigaio.com>
    ntb_netdev: Use dev_kfree_skb_any() in interrupt context

Jerry Ray <jerry.ray@microchip.com>
    net: lan9303: Fix read error execution path

Markus Schneider-Pargmann <msp@baylibre.com>
    can: tcan4x5x: Remove invalid write in clear_interrupts

Tom Lendacky <thomas.lendacky@amd.com>
    net: amd-xgbe: Check only the minimum speed for active/passive cables

Tom Lendacky <thomas.lendacky@amd.com>
    net: amd-xgbe: Fix logic around active and passive cables

Yang Yingliang <yangyingliang@huawei.com>
    net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: ethernet: dnet: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()

Hangbin Liu <liuhangbin@gmail.com>
    net/tunnel: wait until all sk_user_data reader finish before releasing the sock

Li Zetao <lizetao1@huawei.com>
    net: farsync: Fix kmemleak when rmmods farsync

Yang Yingliang <yangyingliang@huawei.com>
    ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()

ruanjinjie <ruanjinjie@huawei.com>
    of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()

Yuan Can <yuancan@huawei.com>
    drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()

Yongqiang Liu <liuyongqiang13@huawei.com>
    net: defxx: Fix missing err handling in dfx_init()

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    net: vmw_vsock: vmci: Check memcpy_from_msg()

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: socfpga: Fix memory leak in socfpga_gate_init()

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: use clk_hw_register for a5/c5

Lee Jones <lee.jones@linaro.org>
    clk: socfpga: clk-pll: Remove unused variable 'rc'

Yang Jihong <yangjihong1@huawei.com>
    blktrace: Fix output non-blktrace event when blk_classic option enabled

Wang Yufen <wangyufen@huawei.com>
    wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h

Kris Bahnsen <kris@embeddedTS.com>
    spi: spi-gpio: Don't set MOSI as an input if not 3WIRE mode

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: samsung: Fix memory leak in _samsung_clk_register_pll()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: Add check for kmalloc

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: Add check for dcoda_iram_alloc

Liang He <windhl@126.com>
    media: c8sectpfe: Add of_node_put() when breaking out of loop

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mmci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: wbsd: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: via-sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: meson-gx: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: omap_hsmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: atmel-mci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: wmt-sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: vub300: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: toshsd: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: pxamci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mxcmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: moxart: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: alcor: fix return value check of mmc_add_host()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.x: Fail client initialisation if state manager thread can't run

Wang ShaoBo <bobo.shaobowang@huawei.com>
    SUNRPC: Fix missing release socket in rpc_sockname()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()

Gaosheng Cui <cuigaosheng1@huawei.com>
    ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt

Liu Shixin <liushixin2@huawei.com>
    media: saa7164: fix missing pci_disable_device()

Eric Dumazet <edumazet@google.com>
    bpf, sockmap: fix race in sock_map_free()

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix resource leak in regulator_register()

Chen Zhongjin <chenzhongjin@huawei.com>
    configfs: fix possible memory leak in configfs_create_dir()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Avoid double remove of a node.

Christian Marangi <ansuelsmth@gmail.com>
    clk: qcom: clk-krait: fix wrong div2 functions

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix module refcount leak in set_supply()

Chen Zhongjin <chenzhongjin@huawei.com>
    wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE

Dan Carpenter <error27@gmail.com>
    bonding: uninitialized variable in bond_miimon_inspect()

Pengcheng Yang <yangpc@wangsu.com>
    bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect

Pengcheng Yang <yangpc@wangsu.com>
    bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: set icmpv6 redirects as RELATED

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()

Ricardo Ribalda <ribalda@chromium.org>
    ASoC: mediatek: mt8173: Enable IRQ when pdata is ready

Ben Greear <greearb@candelatech.com>
    wifi: iwlwifi: mvm: fix double free on tx path.

Liu Shixin <liushixin2@huawei.com>
    ALSA: asihpi: fix missing pci_disable_device()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Fix initialisation of struct nfs4_label

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Fix a memory stomp in decode_attr_security_label

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: mediatek: mtk-btcvsd: Add checks for write and read of mtk_btcvsd_snd

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ASoC: dt-bindings: wcd9335: fix reset line polarity in example

Zhang Zekun <zhangzekun11@huawei.com>
    drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()

Aakarsh Jain <aakarsh.jain@samsung.com>
    media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC

Baisong Zhong <zhongbaisong@huawei.com>
    media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()

Chen Zhongjin <chenzhongjin@huawei.com>
    media: dvb-core: Fix ignored return value in dvb_register_frontend()

ZhangPeng <zhangpeng362@huawei.com>
    pinctrl: pinconf-generic: add missing of_node_put()

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx: replace osc_hdmi with dummy

Li Jun <jun.li@nxp.com>
    clk: imx8mn: correct the usb1_ctrl parent to be usb_bus

Gautam Menghani <gautammenghani201@gmail.com>
    media: imon: fix a race condition in send_packet()

Zheng Yongjun <zhengyongjun3@huawei.com>
    mtd: maps: pxa2xx-flash: fix memory leak in probe

Jonathan Toppins <jtoppins@redhat.com>
    bonding: fix link recovery in mode 2 when updelay is nonzero

Maor Gottlieb <maorg@mellanox.com>
    bonding: Rename slave_arr to usable_slaves

Maor Gottlieb <maorg@mellanox.com>
    bonding: Export skip slave logic to function

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: rockchip: Fix memory leak in rockchip_clk_register_pll()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    regulator: core: use kfree_const() to free space conditionally

Baisong Zhong <zhongbaisong@huawei.com>
    ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT

Baisong Zhong <zhongbaisong@huawei.com>
    ALSA: pcm: fix undefined behavior in bit shift for SNDRV_PCM_RATE_KNOT

Marcus Folkesson <marcus.folkesson@gmail.com>
    HID: hid-sensor-custom: set fixed size for custom attributes

Stanislav Fomichev <sdf@google.com>
    bpf: Move skb->len == 0 checks into __bpf_redirect

Christoph Hellwig <hch@lst.de>
    media: videobuf-dma-contig: use dma_mmap_coherent

Yuan Can <yuancan@huawei.com>
    media: platform: exynos4-is: Fix error handling in fimc_md_init()

Yang Yingliang <yangyingliang@huawei.com>
    media: solo6x10: fix possible memory leak in solo_sysfs_init()

Douglas Anderson <dianders@chromium.org>
    Input: elants_i2c - properly handle the reset GPIO when power is off

Hui Tang <tanghui20@huawei.com>
    mtd: lpddr2_nvm: Fix possible null-ptr-deref

Xiu Jianfeng <xiujianfeng@huawei.com>
    wifi: ath10k: Fix return value in ath10k_pci_init()

Xiu Jianfeng <xiujianfeng@huawei.com>
    ima: Fix misuse of dereference of pointer in template_desc_init_fields()

GUO Zihua <guozihua@huawei.com>
    integrity: Fix memory leakage in keyring allocation error path

Dan Carpenter <error27@gmail.com>
    amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()

Zeng Heng <zengheng4@huawei.com>
    ASoC: pxa: fix null-pointer dereference in filter()

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: Modify dpi power on/off sequence.

Hanjun Guo <guohanjun@huawei.com>
    drm/radeon: Add the missed acpi_put_table() to fix memory leak

David Howells <dhowells@redhat.com>
    rxrpc: Fix ack.bufferSize to be 0 when generating an ack

David Howells <dhowells@redhat.com>
    net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: camss: Clean up received buffers on failed start of streaming

Marek Vasut <marex@denx.de>
    wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    mtd: Fix device name leak when register device failed in add_mtd_device()

Andrii Nakryiko <andrii@kernel.org>
    bpf: propagate precision in ALU/ALU64 operations

Liu Shixin <liushixin2@huawei.com>
    media: vivid: fix compose size exceed boundary

GUO Zihua <guozihua@huawei.com>
    ima: Handle -ESTALE returned by ima_filter_rule_match()

Gustavo A. R. Silva <gustavoars@kernel.org>
    ima: Fix fall-through warnings for Clang

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Rename internal filter rule functions

Marek Vasut <marex@denx.de>
    drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    spi: Update reference to struct spi_controller

Marek Vasut <marex@denx.de>
    clk: renesas: r9a06g032: Repair grave increment error

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Add struct kvaser_usb_busparams

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix bogus restart events

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix wrong CAN state after stopping

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix improved state not being reported

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Set Warning state even without bus errors

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: kvaser_usb: do not increase tx statistics when sending error message frames

Ricardo Ribalda <ribalda@chromium.org>
    media: i2c: ad5820: Fix error path

Junlin Yang <yangjunlin@yulong.com>
    pata_ipx4xx_cf: Fix unsigned comparison with less than zero

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix reading the vendor of combo chips

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()

Cai Xinchen <caixinchen1@huawei.com>
    rapidio: devices: fix missing put_device in mport_cdev_open

ZhangPeng <zhangpeng362@huawei.com>
    hfs: Fix OOB Write in hfs_asc2mac

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    relay: fix type mismatch when allocating memory in relay_create_buf()

Zhang Qilong <zhangqilong3@huawei.com>
    eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD

Wang Weiyang <wangweiyang2@huawei.com>
    rapidio: fix possible UAF when kfifo_alloc() fails

Chen Zhongjin <chenzhongjin@huawei.com>
    fs: sysv: Fix sysv_nblocks() returns wrong value

Ladislav Michl <ladis@linux-mips.org>
    MIPS: OCTEON: warn only once if deprecated link status is being used

Anastasia Belova <abelova@astralinux.ru>
    MIPS: BCM63xx: Add check for NULL for clk in clk_enable

Yu Liao <liaoyu15@huawei.com>
    platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Do not call __rpm_callback() from rpm_idle()

Ulf Hansson <ulf.hansson@linaro.org>
    PM: runtime: Improve path in rpm_idle() when no callback

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()

Xiu Jianfeng <xiujianfeng@huawei.com>
    x86/xen: Fix memory leak in xen_init_lock_cpu()

Xiu Jianfeng <xiujianfeng@huawei.com>
    x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()

Juergen Gross <jgross@suse.com>
    xen/events: only register debug interrupt for 2-level events

Oleg Nesterov <oleg@redhat.com>
    uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix

Li Zetao <lizetao1@huawei.com>
    ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()

Geert Uytterhoeven <geert+renesas@glider.be>
    clocksource/drivers/sh_cmt: Make sure channel clock supply is enabled

Yang Yingliang <yangyingliang@huawei.com>
    rapidio: rio: fix possible name leak in rio_register_mport()

Yang Yingliang <yangyingliang@huawei.com>
    rapidio: fix possible name leaks when rio_add_device() fails

Li Zetao <ocfs2-devel@oss.oracle.com>
    ocfs2: fix memory leak in ocfs2_mount_volume()

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: rewrite error handling of ocfs2_fill_super

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: ocfs2_mount_volume does cleanup job before return error

Akinobu Mita <akinobu.mita@gmail.com>
    debugfs: fix error when writing negative value to atomic_t debugfs file

Wolfram Sang <wsa+renesas@sang-engineering.com>
    docs: fault-injection: fix non-working usage of negative values

Akinobu Mita <akinobu.mita@gmail.com>
    lib/notifier-error-inject: fix error when writing -errno to debugfs file

Akinobu Mita <akinobu.mita@gmail.com>
    libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    cpufreq: amd_freq_sensitivity: Add missing pci_dev_put()

Yang Yingliang <yangyingliang@huawei.com>
    genirq/irqdesc: Don't try to remove non-existing sysfs files

Jeff Layton <jlayton@kernel.org>
    nfsd: don't call nfsd_file_put from client states seqfile display

Yang Yingliang <yangyingliang@huawei.com>
    EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()

Shang XiaoJing <shangxiaojing@huawei.com>
    irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()

Yang Yingliang <yangyingliang@huawei.com>
    PNP: fix name memory leak in pnp_alloc_dev()

Zhao Gongyi <zhaogongyi@huawei.com>
    selftests/efivarfs: Add checking of the test return value

Yang Yingliang <yangyingliang@huawei.com>
    MIPS: vpe-cmp: fix possible memory leak while module exiting

Yang Yingliang <yangyingliang@huawei.com>
    MIPS: vpe-mt: fix possible memory leak while module exiting

Shang XiaoJing <shangxiaojing@huawei.com>
    ocfs2: fix memory leak in ocfs2_stack_glue_init()

Gaosheng Cui <cuigaosheng1@huawei.com>
    lib/fonts: fix undefined behavior in bit shift for get_default_font

Alexey Dobriyan <adobriyan@gmail.com>
    proc: fixup uptime selftest

Barnabás Pőcze <pobrn@protonmail.com>
    timerqueue: Use rb_entry_safe() in timerqueue_getnext()

Chen Zhongjin <chenzhongjin@huawei.com>
    perf: Fix possible memleak in pmu_dev_alloc()

Yipeng Zou <zouyipeng@huawei.com>
    selftests/ftrace: event_triggers: wait longer for test_event_enable

Ondrej Mosnacek <omosnace@redhat.com>
    fs: don't audit the capability check in simple_xattr_list()

xiongxin <xiongxin@kylinos.cn>
    PM: hibernate: Fix mistake in kerneldoc comment

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix syscall entry in !AUDUT_SYSCALL case

Ulf Hansson <ulf.hansson@linaro.org>
    cpuidle: dt: Return the correct numbers of parsed idle states

Michael Kelley <mikelley@microsoft.com>
    tpm/tpm_crb: Fix error message in __crb_relinquish_locality()

Stephen Boyd <swboyd@chromium.org>
    pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP

Doug Brown <doug@schmorgal.com>
    ARM: mmp: fix timer_read delay

Wang Yufen <wangyufen@huawei.com>
    pstore/ram: Fix error return code in ramoops_probe()

Pali Rohár <pali@kernel.org>
    arm64: dts: armada-3720-turris-mox: Add missing interrupt for RTC

Pali Rohár <pali@kernel.org>
    ARM: dts: turris-omnia: Add switch port 6 node

Pali Rohár <pali@kernel.org>
    ARM: dts: turris-omnia: Add ethernet aliases

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-39x: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-38x: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-375: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-xp: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-370: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt6797: Fix 26M oscillator unit name

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712-evb: Fix usb vbus regulators unit names

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712e: Fix unit address for pinctrl node

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712e: Fix unit_address_vs_reg warning for oscillators

Shang XiaoJing <shangxiaojing@huawei.com>
    perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()

Yuan Can <yuancan@huawei.com>
    perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()

Zhang Qilong <zhangqilong3@huawei.com>
    soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe

Zhang Qilong <zhangqilong3@huawei.com>
    soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe

Minghao Chi <chi.minghao@zte.com.cn>
    soc: ti: knav_qmss_queue: Use pm_runtime_resume_and_get instead of pm_runtime_get_sync

Kory Maincent <kory.maincent@bootlin.com>
    arm: dts: spear600: Fix clcd interrupt

Chen Jiahao <chenjiahao16@huawei.com>
    drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias

Luca Weiss <luca@z3ntu.xyz>
    ARM: dts: qcom: apq8064: fix coresight compatible

Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
    usb: musb: remove extra check in musb_gadget_vbus_draw

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    net: loopback: use NET_NAME_PREDICTABLE for name_assign_type

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix u8 overflow

José Expósito <jose.exposito89@gmail.com>
    HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch 10E

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Add support for Acer S1002 keyboard-dock

Pratyush Yadav <ptyadav@amazon.de>
    xen-netback: move removal of "hotplug-status" to the right place

Tony Nguyen <anthony.l.nguyen@intel.com>
    igb: Initialize mailbox message for VF reset

Johan Hovold <johan@kernel.org>
    USB: serial: f81534: fix division by zero on line-speed change

Johan Hovold <johan@kernel.org>
    USB: serial: f81232: fix division by zero on line-speed change

Bruno Thomsen <bruno.thomsen@gmail.com>
    USB: serial: cp210x: add Kamstrup RF sniffer PIDs

Duke Xin <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G modem

Szymon Heidrich <szymon.heidrich@gmail.com>
    usb: gadget: uvc: Prevent buffer overflow in setup handler

Jan Kara <jack@suse.cz>
    udf: Fix extending file within last block

Jan Kara <jack@suse.cz>
    udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size

Jan Kara <jack@suse.cz>
    udf: Fix preallocation discarding at indirect extent boundary

Jan Kara <jack@suse.cz>
    udf: Discard preallocation before extending file with a hole

Pratyush Yadav <ptyadav@amazon.de>
    tracing/ring-buffer: Only do full wait when cpu != RING_BUFFER_ALL_CPUS


-------------

Diffstat:

 .../devicetree/bindings/sound/qcom,wcd9335.txt     |   2 +-
 Documentation/driver-api/spi.rst                   |   4 +-
 Documentation/fault-injection/fault-injection.rst  |  16 +-
 Documentation/sphinx/load_config.py                |   6 +-
 Makefile                                           |   4 +-
 arch/alpha/kernel/entry.S                          |   4 +-
 arch/arm/boot/dts/armada-370.dtsi                  |   2 +-
 arch/arm/boot/dts/armada-375.dtsi                  |   2 +-
 arch/arm/boot/dts/armada-380.dtsi                  |   4 +-
 arch/arm/boot/dts/armada-385-turris-omnia.dts      |  18 +-
 arch/arm/boot/dts/armada-385.dtsi                  |   6 +-
 arch/arm/boot/dts/armada-39x.dtsi                  |   6 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |   8 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |  16 +-
 arch/arm/boot/dts/dove.dtsi                        |   2 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |   2 +-
 arch/arm/boot/dts/spear600.dtsi                    |   2 +-
 arch/arm/mach-mmp/time.c                           |  11 +-
 arch/arm/nwfpe/Makefile                            |   6 +
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   3 +
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts        |  12 +-
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi          |  22 +-
 arch/arm64/boot/dts/mediatek/mt6797.dtsi           |   2 +-
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi         |   4 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   6 +-
 arch/arm64/include/asm/atomic_ll_sc.h              | 114 +++---
 arch/arm64/include/asm/atomic_lse.h                |  16 +-
 arch/arm64/include/asm/kvm_emulate.h               |  22 +-
 arch/mips/bcm63xx/clk.c                            |   2 +
 .../cavium-octeon/executive/cvmx-helper-board.c    |   2 +-
 arch/mips/cavium-octeon/executive/cvmx-helper.c    |   2 +-
 arch/mips/kernel/vpe-cmp.c                         |   4 +-
 arch/mips/kernel/vpe-mt.c                          |   4 +-
 arch/parisc/include/uapi/asm/mman.h                |  23 +-
 arch/parisc/kernel/sys_parisc.c                    |  27 ++
 arch/parisc/kernel/syscalls/syscall.tbl            |   2 +-
 arch/powerpc/include/asm/imc-pmu.h                 |   2 +-
 arch/powerpc/kernel/rtas.c                         |  20 +-
 arch/powerpc/perf/callchain.c                      |   1 +
 arch/powerpc/perf/hv-gpci-requests.h               |   4 +
 arch/powerpc/perf/hv-gpci.c                        |  33 +-
 arch/powerpc/perf/hv-gpci.h                        |   1 +
 arch/powerpc/perf/imc-pmu.c                        | 136 ++++---
 arch/powerpc/perf/req-gen/perf.h                   |  20 +
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |   1 +
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |   2 +-
 arch/powerpc/sysdev/xive/spapr.c                   |   1 +
 arch/riscv/include/asm/uaccess.h                   |   2 +-
 arch/s390/include/asm/percpu.h                     |   2 +-
 arch/s390/kernel/machine_kexec_file.c              |   5 +-
 arch/x86/boot/bioscall.S                           |   4 +-
 arch/x86/events/intel/uncore_snbep.c               |   1 +
 arch/x86/ia32/ia32_aout.c                          |   3 +-
 arch/x86/include/asm/vmx.h                         |   6 +-
 arch/x86/include/uapi/asm/vmx.h                    |   4 +-
 arch/x86/kernel/cpu/bugs.c                         |   2 +
 arch/x86/kernel/cpu/microcode/intel.c              |   8 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  26 +-
 arch/x86/kernel/uprobes.c                          |   4 +-
 arch/x86/kvm/vmx/nested.c                          |  31 +-
 arch/x86/kvm/vmx/vmx.c                             |  66 ++--
 arch/x86/xen/smp.c                                 |  41 +-
 arch/x86/xen/smp_pv.c                              |  12 +-
 arch/x86/xen/spinlock.c                            |   6 +-
 arch/x86/xen/xen-ops.h                             |   2 +
 block/blk-mq-sysfs.c                               |  11 +-
 crypto/tcrypt.c                                    |   9 -
 drivers/acpi/acpica/dsmethod.c                     |  10 +-
 drivers/acpi/acpica/utcopy.c                       |   7 -
 drivers/ata/ahci.c                                 |  32 +-
 drivers/ata/pata_ixp4xx_cf.c                       |   2 +-
 drivers/base/class.c                               |   5 +
 drivers/base/dd.c                                  |   8 +-
 drivers/base/power/runtime.c                       |  18 +-
 drivers/bluetooth/btusb.c                          |   6 +-
 drivers/bluetooth/hci_bcsp.c                       |   2 +-
 drivers/bluetooth/hci_h5.c                         |   2 +-
 drivers/bluetooth/hci_ll.c                         |   2 +-
 drivers/bluetooth/hci_qca.c                        |   2 +-
 drivers/char/hw_random/amd-rng.c                   |  18 +-
 drivers/char/hw_random/geode-rng.c                 |  36 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  12 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  27 +-
 drivers/char/tpm/tpm_crb.c                         |  31 +-
 drivers/char/tpm/tpm_tis.c                         |   9 +-
 drivers/clk/imx/clk-imx8mn.c                       |  14 +-
 drivers/clk/qcom/clk-krait.c                       |   2 +
 drivers/clk/renesas/r9a06g032-clocks.c             |   3 +-
 drivers/clk/rockchip/clk-pll.c                     |   1 +
 drivers/clk/samsung/clk-pll.c                      |   1 +
 drivers/clk/socfpga/clk-gate.c                     |  16 +-
 drivers/clk/socfpga/clk-periph.c                   |   8 +-
 drivers/clk/socfpga/clk-pll.c                      |  17 +-
 drivers/clk/st/clkgen-fsyn.c                       |   5 +-
 drivers/clocksource/sh_cmt.c                       |  16 +-
 drivers/counter/stm32-lptimer-cnt.c                |   2 +-
 drivers/cpufreq/amd_freq_sensitivity.c             |   2 +
 drivers/cpufreq/cpufreq.c                          |   2 +-
 drivers/cpuidle/dt_idle_states.c                   |   2 +-
 drivers/crypto/ccree/cc_debugfs.c                  |   2 +-
 drivers/crypto/ccree/cc_driver.c                   |  11 +-
 drivers/crypto/ccree/cc_hash.c                     |  49 +--
 drivers/crypto/ccree/cc_hash.h                     |   2 -
 drivers/crypto/img-hash.c                          |   8 +-
 drivers/crypto/n2_core.c                           |   6 +
 drivers/crypto/omap-sham.c                         |   2 +-
 drivers/devfreq/devfreq.c                          |   6 +-
 drivers/devfreq/governor_userspace.c               |  12 +-
 drivers/dio/dio.c                                  |   8 +
 drivers/edac/edac_device.c                         |  17 +-
 drivers/edac/edac_module.h                         |   2 +-
 drivers/edac/i10nm_base.c                          |   3 +-
 drivers/firmware/efi/efi.c                         |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   1 +
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c |   3 +-
 drivers/gpu/drm/drm_connector.c                    |   3 +
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  11 +-
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c          |   5 +-
 drivers/gpu/drm/i915/gvt/scheduler.c               |   1 +
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  12 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |  10 +-
 drivers/gpu/drm/panel/panel-sitronix-st7701.c      |  10 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |  19 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   2 +-
 drivers/gpu/drm/rockchip/inno_hdmi.c               |   2 +-
 drivers/gpu/drm/rockchip/rk3066_hdmi.c             |   2 +-
 drivers/gpu/drm/sti/sti_dvo.c                      |   7 +-
 drivers/gpu/drm/sti/sti_hda.c                      |   7 +-
 drivers/gpu/drm/sti/sti_hdmi.c                     |   7 +-
 drivers/gpu/drm/tegra/dc.c                         |   4 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   3 +-
 drivers/hid/hid-ids.h                              |   5 +
 drivers/hid/hid-ite.c                              |  26 +-
 drivers/hid/hid-multitouch.c                       |   4 +
 drivers/hid/hid-plantronics.c                      |   9 +
 drivers/hid/hid-sensor-custom.c                    |   2 +-
 drivers/hid/hid-uclogic-core.c                     |   1 +
 drivers/hid/wacom_sys.c                            |   8 +
 drivers/hid/wacom_wac.c                            |   4 +
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/hsi/controllers/omap_ssi_core.c            |  14 +-
 drivers/i2c/busses/i2c-ismt.c                      |   3 +
 drivers/i2c/busses/i2c-pxa-pci.c                   |  10 +-
 drivers/iio/adc/ad_sigma_delta.c                   |   8 +-
 drivers/iio/adc/ti-adc128s052.c                    |  14 +-
 drivers/infiniband/core/device.c                   |   2 +-
 drivers/infiniband/core/nldev.c                    |   4 +-
 drivers/infiniband/core/uverbs_cmd.c               |   2 +-
 drivers/infiniband/hw/hfi1/affinity.c              |   2 +
 drivers/infiniband/hw/hfi1/firmware.c              |   6 +
 drivers/infiniband/hw/mlx5/qp.c                    |  49 ++-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   6 +-
 drivers/infiniband/sw/siw/siw_cq.c                 |  24 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |   2 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  40 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |   7 +
 drivers/input/touchscreen/elants_i2c.c             |   9 +-
 drivers/iommu/amd_iommu_init.c                     |   7 +
 drivers/iommu/amd_iommu_v2.c                       |   1 +
 drivers/iommu/fsl_pamu.c                           |   2 +-
 drivers/iommu/mtk_iommu_v1.c                       |  26 +-
 drivers/irqchip/irq-gic-pm.c                       |   2 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |  19 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  13 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  12 +-
 drivers/macintosh/macio-adb.c                      |   4 +
 drivers/macintosh/macio_asic.c                     |   2 +-
 drivers/mailbox/zynqmp-ipi-mailbox.c               |   4 +-
 drivers/mcb/mcb-core.c                             |   4 +-
 drivers/mcb/mcb-parse.c                            |   2 +-
 drivers/md/dm-cache-metadata.c                     |  54 ++-
 drivers/md/dm-cache-target.c                       |  11 +-
 drivers/md/dm-clone-target.c                       |   1 +
 drivers/md/dm-integrity.c                          |   2 +
 drivers/md/dm-thin-metadata.c                      |  60 ++-
 drivers/md/dm-thin.c                               |  18 +-
 drivers/md/md-bitmap.c                             |  47 ++-
 drivers/md/md.c                                    |   9 +-
 drivers/md/raid1.c                                 |   1 +
 drivers/media/dvb-core/dmxdev.c                    |   8 +
 drivers/media/dvb-core/dvb_ca_en50221.c            |   2 +-
 drivers/media/dvb-core/dvb_frontend.c              |  10 +-
 drivers/media/dvb-core/dvbdev.c                    |  33 +-
 drivers/media/dvb-frontends/bcm3510.c              |   1 +
 drivers/media/dvb-frontends/stv0288.c              |   5 +-
 drivers/media/i2c/ad5820.c                         |  10 +-
 drivers/media/pci/saa7164/saa7164-core.c           |   4 +-
 drivers/media/pci/solo6x10/solo6x10-core.c         |   1 +
 drivers/media/platform/coda/coda-bit.c             |  14 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   6 +-
 drivers/media/platform/qcom/camss/camss-video.c    |   3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  17 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  14 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |   1 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |   1 +
 drivers/media/radio/si470x/radio-si470x-usb.c      |   4 +-
 drivers/media/rc/imon.c                            |   6 +-
 drivers/media/usb/dvb-usb/az6027.c                 |   4 +
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   4 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c      |  22 +-
 drivers/misc/cxl/guest.c                           |  24 +-
 drivers/misc/cxl/pci.c                             |  21 +-
 drivers/misc/ocxl/file.c                           |   7 +-
 drivers/misc/sgi-gru/grufault.c                    |  13 +-
 drivers/misc/sgi-gru/grumain.c                     |  22 +-
 drivers/misc/sgi-gru/grutables.h                   |   2 +-
 drivers/misc/tifm_7xx1.c                           |   2 +-
 drivers/mmc/host/alcor.c                           |   5 +-
 drivers/mmc/host/atmel-mci.c                       |   9 +-
 drivers/mmc/host/meson-gx-mmc.c                    |   4 +-
 drivers/mmc/host/mmci.c                            |   4 +-
 drivers/mmc/host/moxart-mmc.c                      |   4 +-
 drivers/mmc/host/mxcmmc.c                          |   4 +-
 drivers/mmc/host/omap_hsmmc.c                      |   4 +-
 drivers/mmc/host/pxamci.c                          |   7 +-
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |  11 +-
 drivers/mmc/host/sdhci-sprd.c                      |  16 +-
 drivers/mmc/host/sdhci_f_sdh30.c                   |   3 +
 drivers/mmc/host/toshsd.c                          |   6 +-
 drivers/mmc/host/via-sdmmc.c                       |   4 +-
 drivers/mmc/host/vub300.c                          |  13 +-
 drivers/mmc/host/wbsd.c                            |  12 +-
 drivers/mmc/host/wmt-sdmmc.c                       |   6 +-
 drivers/mtd/lpddr/lpddr2_nvm.c                     |   2 +
 drivers/mtd/maps/pxa2xx-flash.c                    |   2 +
 drivers/mtd/mtdcore.c                              |   4 +-
 drivers/mtd/spi-nor/spi-nor.c                      |   2 +
 drivers/net/bonding/bond_3ad.c                     |   1 +
 drivers/net/bonding/bond_alb.c                     |   4 +-
 drivers/net/bonding/bond_main.c                    |  98 +++--
 drivers/net/can/m_can/tcan4x5x.c                   |   5 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |  30 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   | 115 +++++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  | 167 ++++++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 437 ++++++++++++++++++---
 drivers/net/dsa/lan9303-core.c                     |   4 +-
 drivers/net/ethernet/amd/atarilance.c              |   2 +-
 drivers/net/ethernet/amd/lance.c                   |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   3 +
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c           |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  23 +-
 drivers/net/ethernet/apple/bmac.c                  |   2 +-
 drivers/net/ethernet/apple/mace.c                  |   2 +-
 drivers/net/ethernet/dnet.c                        |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |  14 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   4 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   1 +
 drivers/net/ethernet/neterion/s2io.c               |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h    |  10 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   8 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   2 +
 drivers/net/ethernet/rdc/r6040.c                   |   5 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h   |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   8 +-
 drivers/net/ethernet/ti/netcp_core.c               |   2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   2 +-
 drivers/net/fddi/defxx.c                           |  22 +-
 drivers/net/hamradio/baycom_epp.c                  |   2 +-
 drivers/net/hamradio/scc.c                         |   6 +-
 drivers/net/loopback.c                             |   2 +-
 drivers/net/ntb_netdev.c                           |   4 +-
 drivers/net/phy/xilinx_gmii2rgmii.c                |   1 +
 drivers/net/ppp/ppp_generic.c                      |   2 +
 drivers/net/usb/rndis_host.c                       |   3 +-
 drivers/net/wan/farsync.c                          |   2 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |   6 +
 drivers/net/wireless/ath/ath10k/pci.c              |  20 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  46 ++-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   5 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  12 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  16 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |   4 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   6 +-
 drivers/net/xen-netback/xenbus.c                   |   3 +-
 drivers/nfc/pn533/pn533.c                          |   4 +
 drivers/nfc/pn533/usb.c                            |  44 ++-
 drivers/nvme/host/pci.c                            |  25 +-
 drivers/of/overlay.c                               |   4 +-
 drivers/parisc/led.c                               |   3 +
 drivers/pci/irq.c                                  |   2 +
 drivers/pci/pci-sysfs.c                            |  13 +-
 drivers/pci/pci.c                                  |   2 +
 drivers/perf/arm_dsu_pmu.c                         |   6 +-
 drivers/perf/arm_smmuv3_pmu.c                      |   8 +-
 drivers/pinctrl/pinconf-generic.c                  |   4 +-
 drivers/platform/x86/mxm-wmi.c                     |   8 +-
 drivers/platform/x86/sony-laptop.c                 |  21 +-
 drivers/pnp/core.c                                 |   4 +-
 drivers/power/avs/smartreflex.c                    |   1 +
 drivers/power/supply/power_supply_core.c           |   7 +-
 drivers/pwm/pwm-sifive.c                           |   5 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  15 +-
 drivers/rapidio/rio-scan.c                         |   8 +-
 drivers/rapidio/rio.c                              |   9 +-
 drivers/regulator/core.c                           |  15 +-
 drivers/regulator/da9211-regulator.c               |  11 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   1 +
 drivers/remoteproc/qcom_sysmon.c                   |   5 +-
 drivers/rtc/rtc-mxc_v2.c                           |   4 +-
 drivers/rtc/rtc-pcf85063.c                         |   8 +-
 drivers/rtc/rtc-pic32.c                            |   8 +-
 drivers/rtc/rtc-snvs.c                             |  16 +-
 drivers/rtc/rtc-st-lpc.c                           |   1 +
 drivers/s390/net/ctcm_main.c                       |  11 +-
 drivers/s390/net/lcs.c                             |   8 +-
 drivers/s390/net/netiucv.c                         |   9 +-
 drivers/scsi/fcoe/fcoe.c                           |   1 +
 drivers/scsi/fcoe/fcoe_sysfs.c                     |  19 +-
 drivers/scsi/hpsa.c                                |   9 +-
 drivers/scsi/ipr.c                                 |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   2 +
 drivers/scsi/scsi_debug.c                          |   2 +-
 drivers/scsi/snic/snic_disc.c                      |   3 +
 drivers/soc/qcom/Kconfig                           |   1 +
 drivers/soc/ti/knav_qmss_queue.c                   |   6 +-
 drivers/soc/ux500/ux500-soc-id.c                   |  10 +-
 drivers/spi/spi-gpio.c                             |  16 +-
 drivers/spi/spidev.c                               |  21 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |   2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   4 +-
 drivers/staging/wilc1000/wilc_sdio.c               |   1 +
 drivers/tty/hvc/hvc_xen.c                          |  46 ++-
 drivers/tty/serial/altera_uart.c                   |  21 +-
 drivers/tty/serial/amba-pl011.c                    |  14 +-
 drivers/tty/serial/pch_uart.c                      |   4 +
 drivers/tty/serial/serial-tegra.c                  | 115 +++---
 drivers/tty/serial/sunsab.c                        |   8 +-
 drivers/uio/uio_dmem_genirq.c                      |  13 +-
 drivers/usb/dwc3/core.c                            |   7 +-
 drivers/usb/gadget/function/f_hid.c                | 271 ++++++++++---
 drivers/usb/gadget/function/f_uvc.c                |   5 +-
 drivers/usb/gadget/function/u_hid.h                |   1 +
 drivers/usb/gadget/udc/fotg210-udc.c               |  12 +-
 drivers/usb/musb/musb_gadget.c                     |   2 -
 drivers/usb/roles/class.c                          |   5 +-
 drivers/usb/serial/cp210x.c                        |   2 +
 drivers/usb/serial/f81232.c                        |  12 +-
 drivers/usb/serial/f81534.c                        |  12 +-
 drivers/usb/serial/option.c                        |   3 +
 drivers/usb/storage/alauda.c                       |   2 +
 drivers/usb/typec/bus.c                            |   2 +-
 drivers/usb/typec/tcpm/tcpci.c                     |   5 +-
 drivers/vfio/platform/vfio_platform_common.c       |   3 +-
 drivers/vhost/vhost.c                              |   4 +-
 drivers/video/fbdev/Kconfig                        |   1 -
 drivers/video/fbdev/pm2fb.c                        |   9 +-
 drivers/video/fbdev/uvesafb.c                      |   1 +
 drivers/video/fbdev/vermilion/vermilion.c          |   4 +-
 drivers/video/fbdev/via/via-core.c                 |   9 +-
 drivers/vme/bridges/vme_fake.c                     |   2 +
 drivers/vme/bridges/vme_tsi148.c                   |   1 +
 drivers/xen/events/events_base.c                   |  10 +-
 drivers/xen/privcmd.c                              |   2 +-
 fs/binfmt_aout.c                                   |   2 +-
 fs/binfmt_elf_fdpic.c                              |   7 +-
 fs/binfmt_flat.c                                   |   3 +-
 fs/binfmt_misc.c                                   |   8 +-
 fs/btrfs/backref.c                                 |   4 +
 fs/btrfs/ioctl.c                                   |   9 +-
 fs/btrfs/rcu-string.h                              |   6 +-
 fs/char_dev.c                                      |   2 +-
 fs/cifs/cifsfs.c                                   |   8 +-
 fs/cifs/cifsglob.h                                 |  70 ++++
 fs/cifs/cifsproto.h                                |   4 +-
 fs/cifs/connect.c                                  |   4 +-
 fs/cifs/link.c                                     |   1 +
 fs/cifs/misc.c                                     |   4 +-
 fs/cifs/smb2ops.c                                  | 143 ++++---
 fs/configfs/dir.c                                  |   2 +
 fs/debugfs/file.c                                  |  28 +-
 fs/ext4/ext4.h                                     |   5 +-
 fs/ext4/extents.c                                  |   8 +
 fs/ext4/extents_status.c                           |   3 +-
 fs/ext4/indirect.c                                 |   9 +-
 fs/ext4/inode.c                                    |  48 ++-
 fs/ext4/ioctl.c                                    |  13 +-
 fs/ext4/namei.c                                    |   3 +
 fs/ext4/resize.c                                   |   6 +-
 fs/ext4/super.c                                    |  50 ++-
 fs/ext4/verity.c                                   |   7 +-
 fs/ext4/xattr.c                                    | 182 +++++----
 fs/ext4/xattr.h                                    |   1 +
 fs/f2fs/gc.c                                       |   6 +-
 fs/f2fs/segment.c                                  |   2 +-
 fs/hfs/inode.c                                     |  13 +-
 fs/hfs/trans.c                                     |   2 +-
 fs/hfsplus/hfsplus_fs.h                            |   2 +
 fs/hfsplus/inode.c                                 |  16 +-
 fs/hfsplus/options.c                               |   4 +
 fs/hugetlbfs/inode.c                               |   6 +-
 fs/jfs/jfs_dmap.c                                  |  27 +-
 fs/libfs.c                                         |  22 +-
 fs/mbcache.c                                       | 121 ++++--
 fs/nfs/nfs4proc.c                                  |  34 +-
 fs/nfs/nfs4state.c                                 |   2 +
 fs/nfs/nfs4xdr.c                                   |  12 +-
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/nfsd/nfs4state.c                                |  51 ++-
 fs/nfsd/nfs4xdr.c                                  |  11 +
 fs/nfsd/nfscache.c                                 |  57 +--
 fs/nfsd/nfssvc.c                                   |   2 +-
 fs/nfsd/trace.h                                    |  65 +++
 fs/nilfs2/the_nilfs.c                              |  31 +-
 fs/ocfs2/dlmglue.c                                 |   8 +-
 fs/ocfs2/journal.c                                 |   2 +-
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/stackglue.c                               |   8 +-
 fs/ocfs2/super.c                                   | 108 ++---
 fs/orangefs/orangefs-debugfs.c                     |  29 +-
 fs/orangefs/orangefs-mod.c                         |   8 +-
 fs/overlayfs/dir.c                                 |  46 ++-
 fs/pnode.c                                         |   2 +-
 fs/pstore/Kconfig                                  |   1 +
 fs/pstore/pmsg.c                                   |   7 +-
 fs/pstore/ram.c                                    |   2 +
 fs/pstore/ram_core.c                               |   6 +-
 fs/quota/dquot.c                                   | 110 ++++--
 fs/reiserfs/namei.c                                |   4 +
 fs/reiserfs/xattr_security.c                       |   2 +-
 fs/sysv/itree.c                                    |   2 +-
 fs/udf/inode.c                                     |  76 ++--
 fs/udf/namei.c                                     |   8 +-
 fs/udf/truncate.c                                  |  48 +--
 fs/xattr.c                                         |   2 +-
 include/linux/debugfs.h                            |  19 +-
 include/linux/devfreq.h                            |  11 +-
 include/linux/eventfd.h                            |   2 +-
 include/linux/fs.h                                 |  12 +-
 include/linux/highmem.h                            |  18 +
 include/linux/mbcache.h                            |  41 +-
 include/linux/netdevice.h                          |  58 +--
 include/linux/nvme.h                               |  56 ++-
 include/linux/proc_fs.h                            |   2 +
 include/linux/quotaops.h                           |   2 +
 include/linux/sunrpc/rpc_pipe_fs.h                 |   5 +
 include/linux/timerqueue.h                         |   2 +-
 include/linux/tpm_eventlog.h                       |   4 +-
 include/media/dvbdev.h                             |  32 +-
 include/net/bonding.h                              |   2 +-
 include/net/dst.h                                  |   5 +-
 include/net/mrp.h                                  |   1 +
 include/sound/hdaudio.h                            |   2 +
 include/sound/hdaudio_ext.h                        |   1 -
 include/sound/pcm.h                                |  36 +-
 include/trace/events/jbd2.h                        |  40 +-
 include/uapi/linux/swab.h                          |   2 +-
 include/uapi/sound/asequencer.h                    |   8 +-
 kernel/acct.c                                      |   2 +
 kernel/bpf/btf.c                                   |   5 +
 kernel/bpf/verifier.c                              |   5 +
 kernel/events/core.c                               |   8 +-
 kernel/gcov/gcc_4_7.c                              |   5 +
 kernel/irq/internals.h                             |   2 +
 kernel/irq/irqdesc.c                               |  15 +-
 kernel/power/snapshot.c                            |   4 +-
 kernel/rcu/tree.c                                  |   2 +-
 kernel/relay.c                                     |   4 +-
 kernel/trace/blktrace.c                            |   3 +-
 kernel/trace/ring_buffer.c                         |   1 +
 kernel/trace/trace.c                               |  15 +-
 kernel/trace/trace_events_hist.c                   |  13 +-
 lib/fonts/fonts.c                                  |   4 +-
 lib/iov_iter.c                                     |  14 -
 lib/notifier-error-inject.c                        |   2 +-
 lib/test_firmware.c                                |   1 +
 mm/compaction.c                                    |  18 +-
 mm/memblock.c                                      |   8 +-
 net/802/mrp.c                                      |  18 +-
 net/bluetooth/hci_core.c                           |   2 +-
 net/bluetooth/l2cap_core.c                         |   3 +-
 net/bluetooth/rfcomm/core.c                        |   2 +-
 net/bpf/test_run.c                                 |   3 -
 net/caif/cfctrl.c                                  |   6 +-
 net/core/dev.c                                     |  14 +-
 net/core/filter.c                                  |  18 +-
 net/core/skbuff.c                                  |   3 +
 net/core/sock_map.c                                |   2 +
 net/core/stream.c                                  |   6 +
 net/hsr/hsr_framereg.c                             |  16 +-
 net/hsr/hsr_framereg.h                             |   1 +
 net/ipv4/inet_connection_sock.c                    |  16 +-
 net/ipv4/tcp_bpf.c                                 |   8 +-
 net/ipv4/udp_tunnel.c                              |   1 +
 net/ipv6/raw.c                                     |   4 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   4 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c          |  53 +++
 net/nfc/netlink.c                                  |  52 ++-
 net/openvswitch/datapath.c                         |  25 +-
 net/packet/af_packet.c                             |  20 +-
 net/rxrpc/output.c                                 |   2 +-
 net/rxrpc/sendmsg.c                                |   2 +-
 net/sched/act_mpls.c                               |   8 +-
 net/sched/cls_tcindex.c                            |  12 +-
 net/sched/ematch.c                                 |   2 +
 net/sched/sch_api.c                                |   5 +
 net/sched/sch_atm.c                                |   5 +-
 net/sched/sch_cbq.c                                |   5 +-
 net/sunrpc/auth_gss/auth_gss.c                     |  19 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   9 +-
 net/sunrpc/clnt.c                                  |   2 +-
 net/sunrpc/xprtrdma/verbs.c                        |   1 +
 net/tipc/core.c                                    |  16 +
 net/tipc/core.h                                    |   6 +
 net/tipc/discover.c                                |   4 +-
 net/tipc/msg.h                                     |  19 +
 net/tipc/name_distr.c                              |   2 +-
 net/tipc/node.c                                    | 172 +++++++-
 net/tipc/node.h                                    |   5 +-
 net/tipc/socket.c                                  |   6 +-
 net/vmw_vsock/vmci_transport.c                     |   6 +-
 net/wireless/reg.c                                 |   4 +-
 samples/vfio-mdev/mdpy-fb.c                        |   8 +-
 security/apparmor/apparmorfs.c                     |   4 +-
 security/apparmor/lsm.c                            |   4 +-
 security/apparmor/policy.c                         |   2 +-
 security/apparmor/policy_unpack.c                  |   2 +-
 security/device_cgroup.c                           |  33 +-
 security/integrity/digsig.c                        |   6 +-
 security/integrity/ima/ima.h                       |  16 +-
 security/integrity/ima/ima_main.c                  |   1 +
 security/integrity/ima/ima_policy.c                |  65 +--
 security/integrity/ima/ima_template.c              |   9 +-
 security/integrity/platform_certs/load_uefi.c      |   1 +
 sound/core/control_compat.c                        |   4 +
 sound/drivers/mts64.c                              |   3 +
 sound/hda/ext/hdac_ext_stream.c                    |  17 -
 sound/hda/hdac_stream.c                            |  27 ++
 sound/pci/asihpi/hpioctl.c                         |   2 +-
 sound/pci/hda/hda_controller.c                     |   4 +-
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |  27 ++
 sound/soc/codecs/pcm512x.c                         |   8 +-
 sound/soc/codecs/rt298.c                           |   7 +
 sound/soc/codecs/rt5670.c                          |   2 -
 sound/soc/codecs/wm8994.c                          |   5 +
 sound/soc/generic/audio-graph-card.c               |   4 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  15 +
 sound/soc/intel/skylake/skl.c                      |   7 +-
 sound/soc/mediatek/common/mtk-btcvsd.c             |   6 +-
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c         |  20 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |   7 +-
 sound/soc/pxa/mmp-pcm.c                            |   2 +-
 sound/soc/rockchip/rockchip_pdm.c                  |   1 +
 sound/soc/rockchip/rockchip_spdif.c                |   1 +
 sound/usb/line6/driver.c                           |   3 +-
 sound/usb/line6/midi.c                             |   6 +-
 sound/usb/line6/midibuf.c                          |  25 +-
 sound/usb/line6/midibuf.h                          |   5 +-
 sound/usb/line6/pod.c                              |   3 +-
 tools/arch/parisc/include/uapi/asm/mman.h          |  12 +-
 tools/arch/x86/include/uapi/asm/vmx.h              |   4 +-
 tools/objtool/check.c                              |   2 +-
 tools/perf/bench/bench.h                           |  12 -
 tools/perf/builtin-trace.c                         | 135 +++++--
 tools/perf/trace/beauty/beauty.h                   |   3 +
 tools/perf/util/auxtrace.c                         |   2 +-
 tools/perf/util/data.c                             |   2 +
 tools/perf/util/dwarf-aux.c                        |  23 +-
 tools/perf/util/symbol-elf.c                       |   2 +-
 tools/testing/ktest/ktest.pl                       |  23 +-
 tools/testing/selftests/Makefile                   |  28 +-
 tools/testing/selftests/efivarfs/efivarfs.sh       |   5 +
 .../ftrace/test.d/ftrace/func_event_triggers.tc    |  15 +-
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |   8 +-
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |   2 +-
 tools/testing/selftests/lib.mk                     |   5 +
 .../selftests/netfilter/conntrack_icmp_related.sh  |  36 +-
 .../selftests/powerpc/dscr/dscr_sysfs_test.c       |   5 +-
 tools/testing/selftests/proc/proc-uptime-002.c     |   3 +-
 582 files changed, 5505 insertions(+), 2440 deletions(-)


