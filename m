Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728446673CD
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjALN6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbjALN6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:58:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A2B48CE6;
        Thu, 12 Jan 2023 05:58:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9464B81E67;
        Thu, 12 Jan 2023 13:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7327AC433EF;
        Thu, 12 Jan 2023 13:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531916;
        bh=f9pbuiT4dlfEyD5DWVQRKoA/OZq9BgQe7vP16kC5o8I=;
        h=From:To:Cc:Subject:Date:From;
        b=EdL4fqBqwkwpocUbKCaRRj5+6I24o/z/kys+uomzWAcyPiMkBrHlwOGJD1eI8dvyK
         EnCdh6l77wcG8qlvp741PecwFp6x4IovCb1fZmqq12U1yjMCZY9f9kTF1jnPuuRJRt
         33b8dS7aodCS1XiobvdoEs/+hrGF9+wVGC+tV420=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 000/783] 5.10.163-rc1 review
Date:   Thu, 12 Jan 2023 14:45:16 +0100
Message-Id: <20230112135524.143670746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.163-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.163-rc1
X-KernelTest-Deadline: 2023-01-14T13:56+00:00
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

This is the start of the stable review cycle for the 5.10.163 release.
There are 783 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.163-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.163-rc1

Paolo Abeni <pabeni@redhat.com>
    net/ulp: prevent ULP without clone op from entering the LISTEN status

Frederick Lawler <fred@cloudflare.com>
    net: sched: disallow noqueue for qdisc classes

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: use proper req destructor for IPv6

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: dedicated request sock for subflow in v6

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: remove MPTCP 'ifdef' in TCP SYN cookies

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: mark ops structures as ro_after_init

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    serial: fixup backport of "serial: Deassert Transmit Enable on probe in driver-specific way"

Indan Zupancic <Indan.Zupancic@mep-info.com>
    fsl_lpuart: Don't enable interrupts too early

Eric Biggers <ebiggers@google.com>
    ext4: don't set up encryption key during jbd2 transaction

Eric Biggers <ebiggers@google.com>
    ext4: disable fast-commit of encrypted dir operations

Helge Deller <deller@gmx.de>
    parisc: Align parisc MADV_XXX constants with all other architectures

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    io_uring: Fix unsigned 'res' comparison with zero in io_fixup_rw_res()

Ard Biesheuvel <ardb@kernel.org>
    efi: random: combine bootloader provided RNG seed with RNG protocol output

Jan Kara <jack@suse.cz>
    mbcache: Avoid nesting of cache->c_list_lock under bit locks

Linus Torvalds <torvalds@linux-foundation.org>
    hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling

Arnd Bergmann <arnd@arndb.de>
    hfs/hfsplus: use WARN_ON for sanity check

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests: set the BUILD variable to absolute path

Eric Biggers <ebiggers@google.com>
    ext4: don't allow journal inode to have encrypt flag

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: fix vgpu debugfs clean in remove

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: fix gvt debugfs destroy

Ben Dooks <ben-linux@fluff.org>
    riscv: uaccess: fix type of 0 variable on error in get_user()

Paul Menzel <pmenzel@molgen.mpg.de>
    fbdev: matroxfb: G200eW: Increase max memory from 1 MB to 16 MB

Jeff Layton <jlayton@kernel.org>
    nfsd: fix handling of readdir in v4root vs. mount upcall timeout

Rodrigo Branco <bsdaemon@google.com>
    x86/bugs: Flush IBP in ib_prctl_set()

Yanjun Zhang <zhangyanjun@cestc.cn>
    nvme: fix multipath crash caused by flush request when blktrace is enabled

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

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Rework long task execution when adding/deleting entries

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: fix hash:net,port,net hang with /0 subnet

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: cbq: dont intepret cls results when asked to drop

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: atm: dont intepret cls results when asked to drop

Miaoqian Lin <linmq006@gmail.com>
    gpio: sifive: Fix refcount leak in sifive_gpio_probe

Xiubo Li <xiubli@redhat.com>
    ceph: switch to vfs_inode_has_locks() to fix file lock bug

Jeff Layton <jlayton@kernel.org>
    filelock: new helper: vfs_inode_has_locks

Carlo Caione <ccaione@baylibre.com>
    drm/meson: Reduce the FIFO lines held when AFBC is not used

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Fix validation of max_rd_atomic caps for DC

Miaoqian Lin <linmq006@gmail.com>
    net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe

Jiguang Xiao <jiguang.xiao@windriver.com>
    net: amd-xgbe: add missed tasklet_kill

Adham Faris <afaris@nvidia.com>
    net/mlx5e: Fix hw mtu initializing at XDP SQ allocation

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default

Shay Drory <shayd@nvidia.com>
    net/mlx5: Avoid recovery in probe flows

Jiri Pirko <jiri@nvidia.com>
    net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path

Stefano Garzarella <sgarzare@redhat.com>
    vhost: fix range used in translate_desc()

Stefano Garzarella <sgarzare@redhat.com>
    vringh: fix range used in iotlb_translate()

Yuan Can <yuancan@huawei.com>
    vhost/vsock: Fix error handling in vhost_vsock_init()

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

Shawn Bohrer <sbohrer@cloudflare.com>
    veth: Fix race with AF_XDP exposing old or uninitialized descriptors

Ronak Doshi <doshir@vmware.com>
    vmxnet3: correctly report csum_level for encapsulated packet

Steven Price <steven.price@arm.com>
    drm/panfrost: Fix GEM handle creation ref-counting

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

Eric Biggers <ebiggers@google.com>
    ext4: fix leaking uninitialized memory in fast-commit journal

Bhaskar Chowdhury <unixbhaskar@gmail.com>
    ext4: fix various seppling typos

Jan Kara <jack@suse.cz>
    ext4: simplify ext4 error translation

Jan Kara <jack@suse.cz>
    ext4: move functions in super.c

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

Guo Ren <guoren@linux.alibaba.com>
    riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument

Chen Huang <chenhuang5@huawei.com>
    riscv/stacktrace: Fix stack output without ra on the stack top

Biju Das <biju.das.jz@bp.renesas.com>
    ravb: Fix "failed to switch device to config mode" message during unbind

Luca Ceresoli <luca.ceresoli@bootlin.com>
    staging: media: tegra-video: fix device_node use after free

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/kprobes: Fix optprobe optimization check with CONFIG_RETHUNK

Borislav Petkov <bp@suse.de>
    x86/kprobes: Convert to insn_decode()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    perf probe: Use dwarf_attr_integrate as generic DWARF attr accessor

Smitha T Murthy <smitha.t@samsung.com>
    media: s5p-mfc: Fix in register read and write for H264

Smitha T Murthy <smitha.t@samsung.com>
    media: s5p-mfc: Clear workbit to handle error condition

Smitha T Murthy <smitha.t@samsung.com>
    media: s5p-mfc: Fix to handle reference queue during finishing

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/MCE/AMD: Clear DFR errors found in THR handler

Borislav Petkov <bp@suse.de>
    x86/mce: Get rid of msr_ops

Sasha Levin <sashal@kernel.org>
    btrfs: replace strncpy() with strscpy()

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Clear attr_update properly

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Generalize I/O stacks to PMON mapping procedure

Jens Axboe <axboe@kernel.dk>
    ARM: renumber bits related to _TIF_WORK_MASK

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: make display pinning more flexible (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: handle polaris10/11 overlap asics (v2)

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

Zhang Yi <yi.zhang@huawei.com>
    ext4: check and assert if marking an no_delete evicting inode dirty

Ye Bin <yebin10@huawei.com>
    ext4: fix reserved cluster accounting in __es_remove_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on in __es_tree_search caused by bad quota inode

Baokun Li <libaokun1@huawei.com>
    ext4: add helper to check quota inums

Baokun Li <libaokun1@huawei.com>
    ext4: add EXT4_IGET_BAD flag to prevent unexpected bad inode

Gaosheng Cui <cuigaosheng1@huawei.com>
    ext4: fix undefined behavior in bit shift for ext4_check_flag_values

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_orphan_cleanup

Baokun Li <libaokun1@huawei.com>
    ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop

Zhang Yi <yi.zhang@huawei.com>
    ext4: silence the warning when evicting inode with dioread_nolock

Yuan Can <yuancan@huawei.com>
    drm/ingenic: Fix missing platform_driver_unregister() call in ingenic_drm_init()

Mikko Kovanen <mikko.kovanen@aavamobile.com>
    drm/i915/dsi: fix VBT send packet port selection for dual link DSI

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Validate the box size for the snooped cursor

Simon Ser <contact@emersion.fr>
    drm/connector: send hotplug uevent on connector cleanup

Wang Weiyang <wangweiyang2@huawei.com>
    device_cgroup: Roll back to original exceptions after copy failure

Shang XiaoJing <shangxiaojing@huawei.com>
    parisc: led: Fix potential null-ptr-deref in start_task()

Maria Yu <quic_aiquny@quicinc.com>
    remoteproc: core: Do pm_relax when in RPROC_OFFLINE state

Kim Phillips <kim.phillips@amd.com>
    iommu/amd: Fix ivrs_acpihid cmdline parsing code

Isaac J. Manjarres <isaacmanjarres@google.com>
    driver core: Fix bus_type.match() error handling in __driver_attach()

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

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    ASoC: jz4740-i2s: Handle independent FIFO flush bits

Michael Walle <michael@walle.cc>
    wifi: wilc1000: sdio: fix module autoloading

Aditya Garg <gargaditya08@live.com>
    efi: Add iMac Pro 2017 to uefi skip cert quirk

Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
    md/bitmap: Fix bitmap chunk size overflow issues

Ian Abbott <abbotti@mev.co.uk>
    rtc: ds1347: fix value written to century register

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

Luca Ceresoli <luca.ceresoli@bootlin.com>
    staging: media: tegra-video: fix chan->mipi value on error

Yang Jihong <yangjihong1@huawei.com>
    tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix wrong return value in parse_action_params()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/kprobes: Fix kprobes instruction boudary check with CONFIG_RETHUNK

Steven Rostedt (Google) <rostedt@goodmis.org>
    ftrace/x86: Add back ftrace_expected for ftrace bug reports

Ashok Raj <ashok.raj@intel.com>
    x86/microcode/intel: Do not retry microcode reloading on the APs

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails

Namhyung Kim <namhyung@kernel.org>
    perf/core: Call LSM hook after copying perf_event_attr

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

Luo Meng <luomeng12@huawei.com>
    dm thin: resume even if in FAIL mode

Zhihao Cheng <chengzhihao1@huawei.com>
    dm thin: Use last transaction's pmd->root when commit failed

Zhihao Cheng <chengzhihao1@huawei.com>
    dm thin: Fix ABBA deadlock between shrink_slab and dm_pool_abort_metadata

Mike Snitzer <snitzer@kernel.org>
    dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: Apply dual codec fixup for Dell Latitude laptops

Philipp Jungkamp <p.jungkamp@gmx.net>
    ALSA: patch_realtek: Fix Dell Inspiron Plus 16

Yongqiang Liu <liuyongqiang13@huawei.com>
    cpufreq: Init completion before kobject_init_and_add()

Kant Fan <kant@allwinnertech.com>
    PM/devfreq: governor: Add a private governor_data for governor

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

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-db845c: correct SPI2 pins drive strength

Bixuan Cui <cuibixuan@linux.alibaba.com>
    jbd2: use the correct print format

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

Paul E. McKenney <paulmck@kernel.org>
    rcu: Prevent lockdep-RCU splats on lock acquisition/release

Paul E. McKenney <paulmck@kernel.org>
    torture: Exclude "NOHZ tick-stop error" from fatal errors

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtlwifi: 8192de: correct checking of IQK reload

Jakub Kicinski <kuba@kernel.org>
    wifi: rtlwifi: remove always-true condition pointed out by GCC 12

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC/SoundWire: dai: expand 'stream' concept beyond SoundWire

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio

Marco Elver <elver@google.com>
    kcsan: Instrument memcpy/memset/memmove with newer Clang

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Don't leak netobj memory when gss_read_proxy_verf() fails

Hanjun Guo <guohanjun@huawei.com>
    tpm: tpm_tis: Add the missed acpi_put_table() to fix memory leak

Hanjun Guo <guohanjun@huawei.com>
    tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak

Hanjun Guo <guohanjun@huawei.com>
    tpm: acpi: Call acpi_put_table() to fix memory leak

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

Wang Yufen <wangyufen@huawei.com>
    binfmt: Fix error return code in load_elf_fdpic_binary()

Aditya Garg <gargaditya08@live.com>
    hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount

Qiujun Huang <hqjagain@gmail.com>
    pstore/zone: Use GFP_ATOMIC to allocate zone buffer

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
    nvmet: don't defer passthrough commands with trivial effects to the workqueue

Christoph Hellwig <hch@lst.de>
    nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition

Adam Vodopjan <grozzly@protonmail.com>
    ata: ahci: Fix PCS quirk application for suspend

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix page size checks

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix mempool alloc size

Klaus Jensen <k.jensen@samsung.com>
    nvme-pci: fix doorbell buffer value endianness

Paulo Alcantara <pc@cjr.nz>
    cifs: fix oops during encryption

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init

Steven Price <steven.price@arm.com>
    pwm: tegra: Fix 32 bit build

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: fix refcnt bug

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: fix build warning due to comments

Chen Zhongjin <chenzhongjin@huawei.com>
    ovl: fix use inode directly in rcu-walk mode

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

Enrik Berkhan <Enrik.Berkhan@inka.de>
    HID: mcp2221: don't connect hidraw

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Ensure bootloader PID is usable in hidraw mode

Ferry Toth <ftoth@exalondelft.nl>
    usb: dwc3: core: defer probe on ulpi_read_id timeout

Sven Peter <sven@svenpeter.dev>
    usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode

Jiao Zhou <jiaozhou@google.com>
    ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list

Edward Pacman <edward@edward-p.xyz>
    ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: usb-audio: add the quirk for KT0206 device

GUO Zihua <guozihua@huawei.com>
    ima: Simplify ima_lsm_copy_rule

John Stultz <jstultz@google.com>
    pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES

David Howells <dhowells@redhat.com>
    afs: Fix lost servers_outstanding count

Yang Jihong <yangjihong1@huawei.com>
    perf debug: Set debug_peo_args and redirect_to_stderr variable to correct values in perf_quiet_option()

John Stultz <jstultz@google.com>
    pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion

Kees Cook <keescook@chromium.org>
    LoadPin: Ignore the "contents" argument of the LSM hooks

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

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (jc42) Fix missing unlock on error in jc42_write()

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

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: better reset from HS400 mode

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    mmc: f-sdh30: Add quirks for broken timeout clock capability

Rui Zhang <zr.zhang@vivo.com>
    regulator: core: fix use_count leakage when handling boot-on

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Avoid enum forward-declarations in public API in C++ mode

Ye Bin <yebin10@huawei.com>
    blk-mq: fix possible memleak when register 'hctx' failed

Mazin Al Haddad <mazinalhaddad05@gmail.com>
    media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: adopts refcnt to avoid UAF

Yan Lei <yan_lei@dahuatech.com>
    media: dvb-frontends: fix leak of memory fw

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    ethtool: avoiding integer overflow in ethtool_phys_id()

Stanislav Fomichev <sdf@google.com>
    bpf: Prevent decl_tag from being referenced in func_proto arg

Stanislav Fomichev <sdf@google.com>
    ppp: associate skb with a device at tx

Schspa Shi <schspa@gmail.com>
    mrp: introduce active flags to prevent UAF when applicant uninit

Eric Dumazet <edumazet@google.com>
    net: add atomic_long_t to net_device_stats fields

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: fix array index out of bound error in bios parser

Jiang Li <jiang.li@ugreen.com>
    md/raid1: stop mdx_raid1 thread when raid1 array run failed

Li Zhong <floridsleeves@gmail.com>
    drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/sti: Use drm_mode_copy()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/rockchip: Use drm_mode_copy()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/msm: Use drm_mode_copy()

Nathan Chancellor <nathan@kernel.org>
    s390/lcs: Fix return type of lcs_start_xmit()

Nathan Chancellor <nathan@kernel.org>
    s390/netiucv: Fix return type of netiucv_tx()

Nathan Chancellor <nathan@kernel.org>
    s390/ctcm: Fix return type of ctc{mp,}m_tx()

Nathan Chancellor <nathan@kernel.org>
    drm/amdgpu: Fix type of second parameter in odn_edit_dpm_table() callback

Nathan Chancellor <nathan@kernel.org>
    drm/amdgpu: Fix type of second parameter in trans_msg() callback

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

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    qed (gcc13): use u16 for fid to be big enough

gehao <gehao@kylinos.cn>
    drm/amd/display: prevent memory leak

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
    nilfs2: fix shift-out-of-bounds due to too large exponent of block size

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

Gaurav Kohli <gauravkohli@linux.microsoft.com>
    x86/hyperv: Remove unregister syscore call from Hyper-V cleanup

Guilherme G. Piccoli <gpiccoli@igalia.com>
    video: hyperv_fb: Avoid taking busy spinlock on panic path

Mark Rutland <mark.rutland@arm.com>
    arm64: make is_ttbrX_addr() noinstr-safe

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

Jakub Kicinski <kuba@kernel.org>
    selftests: devlink: fix the fd redirect in dummy_reporter_test

GUO Zihua <guozihua@huawei.com>
    rtc: mxc_v2: Add missing clk_disable_unprepare()

Tan Tee Min <tee.min.tan@linux.intel.com>
    igc: Set Qbv start_time and end_time to end_time if not being configured in GCL

Kurt Kanzenbach <kurt@linutronix.de>
    igc: Lift TAPRIO schedule restriction

Tan Tee Min <tee.min.tan@linux.intel.com>
    igc: recalculate Qbv end_time by considering cycle time

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
    igc: Add checking for basetime less than zero

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Use strict cycles for Qbv scheduling

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Enhance Qbv scheduling by using first flag bit

Vladimir Oltean <olteanv@gmail.com>
    net: add a helper to avoid issues with HW TX timestamping and SO_TXTIME

Xin Long <lucien.xin@gmail.com>
    net: igc: use skb_csum_is_sctp instead of protocol check

Xin Long <lucien.xin@gmail.com>
    net: add inline function skb_csum_is_sctp

Marco Elver <elver@google.com>
    net: switch to storing KCOV handle directly in sk_buff

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

Emeel Hakim <ehakim@nvidia.com>
    net: macsec: fix net device access prior to holding a lock

Dan Aloni <dan.aloni@vastdata.com>
    nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Remove spurious cb_setup_err tracepoint

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: pcf85063: fix pcf85063_clkout_control

Gaosheng Cui <cuigaosheng1@huawei.com>
    rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()

Gaosheng Cui <cuigaosheng1@huawei.com>
    rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()

Qingfang DENG <dqfext@gmail.com>
    netfilter: flowtable: really fix NAT IPv6 offload

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/eeh: use correct API for error log size

Haowen Bai <baihaowen@meizu.com>
    powerpc/eeh: Drop redundant spinlock initialization

Yuan Can <yuancan@huawei.com>
    remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()

Luca Weiss <luca.weiss@fairphone.com>
    remoteproc: qcom_q6v5_pas: detach power domains on remove

Luca Weiss <luca.weiss@fairphone.com>
    remoteproc: qcom_q6v5_pas: disable wakeup on probe fail or remove

Gaosheng Cui <cuigaosheng1@huawei.com>
    remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Call pwm_sifive_update_clock() while mutex is held

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/sun50i: Remove IOMMU_DOMAIN_IDENTITY

Miaoqian Lin <linmq006@gmail.com>
    selftests/powerpc: Fix resource leaks

Kajol Jain <kjain@linux.ibm.com>
    powerpc/hv-gpci: Fix hv_gpci event list

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/perf: callchain validate kernel stack pointer bounds

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: refactor single builds of *.ko

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: unify modules(_install) for in-tree and external modules

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: remove unneeded mkdir for external modules_install

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()

Gustavo A. R. Silva <gustavoars@kernel.org>
    powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/xmon: Enable breakpoints on 8xx

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Disable ACPI RTC event on removal

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Rename ACPI-related functions

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Eliminate forward declarations of some functions

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Call rtc_wake_setup() from cmos_do_probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Call cmos_wake_setup() from cmos_do_probe()

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: cmos: fix build on non-ACPI platforms

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Fix wake alarm breakage

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Fix event handler registration ordering issue

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: rtc-cmos: Do not check ACPI_FADT_LOW_POWER_S0

Fenghua Yu <fenghua.yu@intel.com>
    dmaengine: idxd: Fix crc_val field for completion record

Jon Hunter <jonathanh@nvidia.com>
    pwm: tegra: Improve required rate calculation

Matt Redfearn <matt.redfearn@mips.com>
    include/uapi/linux/swab: Fix potentially missing __always_inline

Al Cooper <alcooperx@gmail.com>
    phy: usb: s2 WoL wakeup_count not incremented for USB->Eth devices

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Fix flush size

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Fix R/W permission check

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Consider all fault sources for reset

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Fix reset release

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

Marcus Folkesson <marcus.folkesson@gmail.com>
    thermal/drivers/imx8mm_thermal: Validate temperature range

Shang XiaoJing <shangxiaojing@huawei.com>
    samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix issue of losting command info in error_log

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    usb: storage: Add check for kcalloc

Zheyu Ma <zheyuma97@gmail.com>
    i2c: ismt: Fix an out-of-bounds bug in ismt_access()

Yang Yingliang <yangyingliang@huawei.com>
    i2c: mux: reg: check return value after calling platform_get_resource()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: cdev: fix NULL-pointer dereferences

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: Get rid of redundant 'else'

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

Ramona Bolboaca <ramona.bolboaca@analog.com>
    iio: adis: add '__adis_enable_irq()' implementation

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:adis: Move exports into IIO_ADISLIB namespace

Nuno Sá <nuno.sa@analog.com>
    iio: adis: stylistic changes

Nuno Sá <nuno.sa@analog.com>
    iio: adis: handle devices that cannot unmask the drdy pin

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:adis: Use IRQF_NO_AUTOEN instead of irq request then disable

Barry Song <song.bao.hua@hisilicon.com>
    genirq: Add IRQF_NO_AUTOEN for request_irq/nmi()

Cosmin Tanislav <cosmin.tanislav@analog.com>
    iio: temperature: ltc2983: make bulk write buffer DMA-safe

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()

Yang Yingliang <yangyingliang@huawei.com>
    firmware: raspberrypi: fix possible memory leak in rpi_firmware_probe()

Zheng Wang <zyytlz.wz@163.com>
    misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os

ruanjinjie <ruanjinjie@huawei.com>
    misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()

Yang Yingliang <yangyingliang@huawei.com>
    ocxl: fix pci device refcount leak when calling get_function_0()

Yang Yingliang <yangyingliang@huawei.com>
    misc: ocxl: fix possible name leak in ocxl_file_register_afu()

Zhengchao Shao <shaozhengchao@huawei.com>
    test_firmware: fix memory leak in test_firmware_init()

Yuan Can <yuancan@huawei.com>
    serial: sunsab: Fix error handling in sunsab_init()

Gabriel Somlo <gsomlo@gmail.com>
    serial: altera_uart: fix locking in polling mode

Jiri Slaby <jirislaby@kernel.org>
    tty: serial: altera_uart_{r,t}x_chars() need only uart_port

Jiri Slaby <jirislaby@kernel.org>
    tty: serial: clean up stop-tx part in altera_uart_tx_chars()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    serial: pch: Fix PCI device refcount leak in pch_request_dma()

delisun <delisun@pateo.com.cn>
    serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.

Jiamei Xie <jiamei.xie@arm.com>
    serial: amba-pl011: avoid SBSA UART accessing DMACR register

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Fix spurious fwnode_handle_put in error path

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

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix page size cap from firmware

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix PBL page MTR find

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix sysfs not cleanup when dev init failed

Wang Yufen <wangyufen@huawei.com>
    RDMA/srp: Fix error return code in srp_parse_options()

Wang Yufen <wangyufen@huawei.com>
    RDMA/hfi1: Fix error return code in parse_platform_config()

Tong Tiangen <tongtiangen@huawei.com>
    riscv/mm: add arch hook arch_clear_hugepage_flags

Shang XiaoJing <shangxiaojing@huawei.com>
    crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: amlogic - Remove kcalloc without check

Mark Zhang <markzhang@nvidia.com>
    RDMA/nldev: Fix failure to send large messages

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
    scsi: scsi_debug: Fix possible name leak in sdebug_add_host_helper()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: fcoe: Fix possible name leak when device_register() fails

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    scsi: scsi_debug: Fix a warning in resp_report_zones()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    scsi: scsi_debug: Fix a warning in resp_verify()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix error handling in hpsa_add_sas_host()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: Fix list iterator in padata_do_serial()

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: Always leave BHs disabled when running ->parallel()

Zhang Yiqun <zhangyiqun@phytium.com.cn>
    crypto: tcrypt - Fix multibuffer skcipher speed test mem leak

Yuan Can <yuancan@huawei.com>
    scsi: hpsa: Fix possible memory leak in hpsa_init_one()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed

Zhengchao Shao <shaozhengchao@huawei.com>
    RDMA/hns: fix memory leak in hns_roce_alloc_mr()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    crypto: ccree - Make cc_debugfs_global_fini() available for module init function

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    RDMA/hfi: Decrease PCI device reference count in error path

Zeng Heng <zengheng4@huawei.com>
    PCI: Check for alloc failure in pci_request_irq()

Luoyouming <luoyouming@huawei.com>
    RDMA/hns: Fix ext_sge num error when post send

Luoyouming <luoyouming@huawei.com>
    RDMA/hns: Repacing 'dseg_len' by macros in fill_ext_sge_inl_data()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    crypto: hisilicon/qm - add missing pci_dev_put() in q_num_set()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: cryptd - Use request context instead of stack for sub-request

Gaosheng Cui <cuigaosheng1@huawei.com>
    crypto: ccree - Remove debugfs when platform_driver_register failed

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

Xiu Jianfeng <xiujianfeng@huawei.com>
    apparmor: Fix memleak in alloc_ns()

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - rework by using crypto_engine

Kai Ye <yekai13@huawei.com>
    crypto: rockchip - delete unneeded variable initialization

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - remove non-aligned handling

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - better handle cipher key

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - add fallback for ahash

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - add fallback for cipher

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - do not store mode globally

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - do not do custom power management

Zhang Qilong <zhangqilong3@huawei.com>
    f2fs: Fix the race condition of resize flag between resizefs

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    PCI: pci-epf-test: Register notifier if only core_init_notifier is enabled

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Fix order of nldev_exit call

Vidya Sagar <vidyas@nvidia.com>
    PCI: dwc: Fix n_fts[] array overrun

Xiu Jianfeng <xiujianfeng@huawei.com>
    apparmor: Use pointer to struct aa_label for lbs_cred

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a race between scsi_done() and scsi_timeout()

Natalia Petrova <n.petrova@fintech.ru>
    crypto: nitrox - avoid double free on error path in nitrox_sriov_init()

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - use dma_addr instead u32

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

Firo Yang <firo.yang@suse.com>
    sctp: sysctl: make extra pointers netns aware

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
    wifi: rtl8xxxu: Fix the channel width reporting

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

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Set missing stop_operating flag at undoing trigger start

Eric Dumazet <edumazet@google.com>
    bpf, sockmap: fix race in sock_map_free()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    hwmon: (jc42) Restore the min/max/critical temperatures on resume

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    hwmon: (jc42) Convert register access and caching to regmap/regcache

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix resource leak in regulator_register()

Chen Zhongjin <chenzhongjin@huawei.com>
    configfs: fix possible memory leak in configfs_create_dir()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Synchronize sequence number updates.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Synchronize sending frames to have always incremented outgoing seq nr.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Disable netpoll.

George McCollister <george.mccollister@gmail.com>
    net: hsr: generate supervision frame without HSR/PRP tag

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Add a rcu-read lock to hsr_forward_skb().

Christian Marangi <ansuelsmth@gmail.com>
    clk: qcom: clk-krait: fix wrong div2 functions

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix module refcount leak in set_supply()

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: fix coverity overrun-call in mt76_get_txpower()

Chen Zhongjin <chenzhongjin@huawei.com>
    wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: mac80211: fix memory leak in ieee80211_if_add()

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

Guchun Chen <guchun.chen@amd.com>
    drm/amd/pm/smu11: BACO is supported when it's in BACO state

Ricardo Ribalda <ribalda@chromium.org>
    ASoC: mediatek: mt8173: Enable IRQ when pdata is ready

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: mt8173: Fix debugfs registration for components

Ben Greear <greearb@candelatech.com>
    wifi: iwlwifi: mvm: fix double free on tx path.

Liu Shixin <liushixin2@huawei.com>
    ALSA: asihpi: fix missing pci_disable_device()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix an Oops in nfs_d_automount()

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

Gautam Menghani <gautammenghani201@gmail.com>
    media: imon: fix a race condition in send_packet()

Chen Zhongjin <chenzhongjin@huawei.com>
    media: vimc: Fix wrong function called when vimc_init() fails

Yuan Can <yuancan@huawei.com>
    ASoC: qcom: Add checks for devm_kcalloc

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    drbd: fix an invalid memory access caused by incorrect use of list iterator

Zheng Yongjun <zhengyongjun3@huawei.com>
    mtd: maps: pxa2xx-flash: fix memory leak in probe

Jonathan Toppins <jtoppins@redhat.com>
    bonding: fix link recovery in mode 2 when updelay is nonzero

Yang Yingliang <yangyingliang@huawei.com>
    drm/amdgpu: fix pci device refcount leak

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

Eric Dumazet <edumazet@google.com>
    inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()

Christoph Hellwig <hch@lst.de>
    media: videobuf-dma-contig: use dma_mmap_coherent

Yuan Can <yuancan@huawei.com>
    media: platform: exynos4-is: Fix error handling in fimc_md_init()

Yang Yingliang <yangyingliang@huawei.com>
    media: solo6x10: fix possible memory leak in solo_sysfs_init()

Chen Zhongjin <chenzhongjin@huawei.com>
    media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()

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

Brian Starkey <brian.starkey@arm.com>
    drm/fourcc: Fix vsub/hsub for Q410 and Q401

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/fourcc: Add packed 10bit YUV 4:2:0 format

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

Randy Dunlap <rdunlap@infradead.org>
    Input: joystick - fix Kconfig warning for JOYSTICK_ADC

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    mtd: Fix device name leak when register device failed in add_mtd_device()

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    clk: qcom: gcc-sm8250: Use retention mode for USB GDSCs

Andrii Nakryiko <andrii@kernel.org>
    bpf: propagate precision across all frames, not just the last one

Martin KaFai Lau <kafai@fb.com>
    bpf: Check the other end of slot_type for STACK_SPILL

Andrii Nakryiko <andrii@kernel.org>
    bpf: propagate precision in ALU/ALU64 operations

Yang Yingliang <yangyingliang@huawei.com>
    media: platform: exynos4-is: fix return value check in fimc_md_probe()

Liu Shixin <liushixin2@huawei.com>
    media: vivid: fix compose size exceed boundary

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix slot type check in check_stack_write_var_off

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/hdmi: drop unused GPIO support

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/hdmi: switch to drm_bridge_connector

GUO Zihua <guozihua@huawei.com>
    ima: Handle -ESTALE returned by ima_filter_rule_match()

Gustavo A. R. Silva <gustavoars@kernel.org>
    ima: Fix fall-through warnings for Clang

Marek Vasut <marex@denx.de>
    drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    spi: Update reference to struct spi_controller

Marek Vasut <marex@denx.de>
    clk: renesas: r9a06g032: Repair grave increment error

Zhang Qilong <zhangqilong3@huawei.com>
    drm/rockchip: lvds: fix PM usage counter unbalance in poweron

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

Marek Szyprowski <m.szyprowski@samsung.com>
    media: exynos4-is: don't rely on the v4l2_async_subdev internals

Ezequiel Garcia <ezequiel@collabora.com>
    media: exynos4-is: Use v4l2_async_notifier_add_fwnode_remote_subdev

Tang Bin <tangbin@cmss.chinamobile.com>
    venus: pm_helpers: Fix error check in vcodec_domains_get()

Ricardo Ribalda <ribalda@chromium.org>
    media: i2c: ad5820: Fix error path

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: jpeg: Add check for kmalloc

Junlin Yang <yangjunlin@yulong.com>
    pata_ipx4xx_cf: Fix unsigned comparison with less than zero

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()

Xu Kuohai <xukuohai@huawei.com>
    libbpf: Fix use-after-free in btf_dump_name_dups

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/bridge: adv7533: remove dynamic lane switching from adv7533 bridge

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

Yang Yingliang <yangyingliang@huawei.com>
    platform/x86: intel_scu_ipc: fix possible name leak in __intel_scu_ipc_register()

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

Oleg Nesterov <oleg@redhat.com>
    uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix

Li Zetao <lizetao1@huawei.com>
    ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()

Yang Yingliang <yangyingliang@huawei.com>
    clocksource/drivers/timer-ti-dm: Fix missing clk_disable_unprepare in dmtimer_systimer_init_clock()

Phil Auld <pauld@redhat.com>
    cpu/hotplug: Make target_store() a nop when target == state

Alexey Izbyshev <izbyshev@ispras.ru>
    futex: Resend potentially swallowed owner death notification

Peter Zijlstra <peterz@infradead.org>
    futex: Move to kernel/futex/

Wolfram Sang <wsa+renesas@sang-engineering.com>
    clocksource/drivers/sh_cmt: Access registers according to spec

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

Yuan Can <yuancan@huawei.com>
    platform/chrome: cros_usbpd_notify: Fix error handling in cros_usbpd_notify_init()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in __uncore_imc_init_box()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in snr_uncore_mmio_map()

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

Barnabás Pőcze <pobrn@protonmail.com>
    platform/x86: huawei-wmi: fix return value calculation

wuchi <wuchi.zero@gmail.com>
    lib/debugobjects: fix stat count and optimize debug_objects_mem_init

Chen Zhongjin <chenzhongjin@huawei.com>
    perf: Fix possible memleak in pmu_dev_alloc()

Yipeng Zou <zouyipeng@huawei.com>
    selftests/ftrace: event_triggers: wait longer for test_event_enable

Chen Hui <judy.chenhui@huawei.com>
    cpufreq: qcom-hw: Fix memory leak in qcom_cpufreq_hw_read_lut()

Ondrej Mosnacek <omosnace@redhat.com>
    fs: don't audit the capability check in simple_xattr_list()

xiongxin <xiongxin@kylinos.cn>
    PM: hibernate: Fix mistake in kerneldoc comment

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix syscall entry in !AUDUT_SYSCALL case

Ulf Hansson <ulf.hansson@linaro.org>
    cpuidle: dt: Return the correct numbers of parsed idle states

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix relationship between uclamp and migration margin

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/fair: Cleanup task_util and capacity type

Michael Kelley <mikelley@microsoft.com>
    tpm/tpm_crb: Fix error message in __crb_relinquish_locality()

Yuan Can <yuancan@huawei.com>
    tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()

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
    arm64: dts: mediatek: pumpkin-common: Fix devicetree warnings

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712-evb: Fix usb vbus regulators unit names

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712e: Fix unit address for pinctrl node

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712e: Fix unit_address_vs_reg warning for oscillators

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-j721e-main: Drop dma-coherent in crypto node

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node

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

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soc: qcom: apr: make code more reuseable

Luca Weiss <luca.weiss@fairphone.com>
    soc: qcom: llcc: make irq truly optional

Chen Jiahao <chenjiahao16@huawei.com>
    drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix AV96 WLAN regulator gpio property

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Drop stm32mp15xc.dtsi from Avenger96

Marco Elver <elver@google.com>
    objtool, kcsan: Add volatile read/write instrumentation to whitelist

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    arm64: dts: qcom: msm8916: Drop MSS fallback compatible

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm630: fix UART1 pin bias

Luca Weiss <luca@z3ntu.xyz>
    ARM: dts: qcom: apq8064: fix coresight compatible

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: fix GPU OPP table

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: ipq6018-cp01-c1: use BLSPI1 pins

Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
    usb: musb: remove extra check in musb_gadget_vbus_draw


-------------

Diffstat:

 .../devicetree/bindings/sound/qcom,wcd9335.txt     |   2 +-
 Documentation/driver-api/spi.rst                   |   4 +-
 Documentation/fault-injection/fault-injection.rst  |  16 +-
 MAINTAINERS                                        |   2 +-
 Makefile                                           | 107 ++---
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
 arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts  |   1 -
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi |   2 +-
 arch/arm/include/asm/thread_info.h                 |  13 +-
 arch/arm/mach-mmp/time.c                           |  11 +-
 arch/arm/nwfpe/Makefile                            |   6 +
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   3 +
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts        |  12 +-
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi          |  22 +-
 arch/arm64/boot/dts/mediatek/mt6797.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |   6 +-
 arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts       |   2 +
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |  10 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi         |   4 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   5 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   6 +-
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |   1 -
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |   1 -
 arch/arm64/include/asm/processor.h                 |   4 +-
 arch/mips/bcm63xx/clk.c                            |   2 +
 .../cavium-octeon/executive/cvmx-helper-board.c    |   2 +-
 arch/mips/cavium-octeon/executive/cvmx-helper.c    |   2 +-
 arch/mips/kernel/vpe-cmp.c                         |   4 +-
 arch/mips/kernel/vpe-mt.c                          |   4 +-
 arch/parisc/include/uapi/asm/mman.h                |  23 +-
 arch/parisc/kernel/sys_parisc.c                    |  27 ++
 arch/parisc/kernel/syscalls/syscall.tbl            |   2 +-
 arch/powerpc/kernel/rtas.c                         |  20 +-
 arch/powerpc/perf/callchain.c                      |   1 +
 arch/powerpc/perf/hv-gpci-requests.h               |   4 +
 arch/powerpc/perf/hv-gpci.c                        |  33 +-
 arch/powerpc/perf/hv-gpci.h                        |   1 +
 arch/powerpc/perf/req-gen/perf.h                   |  20 +
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |   1 +
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |   2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |  14 +-
 arch/powerpc/sysdev/xive/spapr.c                   |   1 +
 arch/powerpc/xmon/xmon.c                           |  11 +-
 arch/riscv/include/asm/hugetlb.h                   |   6 +
 arch/riscv/include/asm/uaccess.h                   |   2 +-
 arch/riscv/kernel/stacktrace.c                     |  12 +-
 arch/x86/events/intel/uncore.h                     |   1 +
 arch/x86/events/intel/uncore_snb.c                 |   3 +
 arch/x86/events/intel/uncore_snbep.c               |  48 ++-
 arch/x86/hyperv/hv_init.c                          |   2 -
 arch/x86/kernel/cpu/bugs.c                         |   2 +
 arch/x86/kernel/cpu/mce/amd.c                      |  37 +-
 arch/x86/kernel/cpu/mce/core.c                     |  95 ++---
 arch/x86/kernel/cpu/mce/internal.h                 |  12 +-
 arch/x86/kernel/cpu/microcode/intel.c              |   8 +-
 arch/x86/kernel/ftrace.c                           |   2 +
 arch/x86/kernel/kprobes/core.c                     |  27 +-
 arch/x86/kernel/kprobes/opt.c                      |  35 +-
 arch/x86/kernel/uprobes.c                          |   4 +-
 arch/x86/kvm/vmx/nested.c                          |  44 ++-
 arch/x86/xen/smp.c                                 |  24 +-
 arch/x86/xen/smp_pv.c                              |  12 +-
 arch/x86/xen/spinlock.c                            |   6 +-
 block/blk-mq-sysfs.c                               |  11 +-
 crypto/cryptd.c                                    |  36 +-
 crypto/tcrypt.c                                    |   9 -
 drivers/acpi/acpica/dsmethod.c                     |  10 +-
 drivers/acpi/acpica/utcopy.c                       |   7 -
 drivers/ata/ahci.c                                 |  32 +-
 drivers/ata/pata_ixp4xx_cf.c                       |   2 +-
 drivers/base/class.c                               |   5 +
 drivers/base/dd.c                                  |   6 +-
 drivers/base/power/runtime.c                       |  18 +-
 drivers/block/drbd/drbd_main.c                     |   4 +-
 drivers/bluetooth/btusb.c                          |   6 +-
 drivers/bluetooth/hci_bcsp.c                       |   2 +-
 drivers/bluetooth/hci_h5.c                         |   2 +-
 drivers/bluetooth/hci_ll.c                         |   2 +-
 drivers/bluetooth/hci_qca.c                        |   2 +-
 drivers/char/hw_random/amd-rng.c                   |  18 +-
 drivers/char/hw_random/geode-rng.c                 |  36 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  12 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  27 +-
 drivers/char/tpm/eventlog/acpi.c                   |  12 +-
 drivers/char/tpm/tpm_crb.c                         |  31 +-
 drivers/char/tpm/tpm_ftpm_tee.c                    |   8 +-
 drivers/char/tpm/tpm_tis.c                         |   9 +-
 drivers/clk/imx/clk-imx8mn.c                       |  12 +-
 drivers/clk/qcom/clk-krait.c                       |   2 +
 drivers/clk/qcom/gcc-sm8250.c                      |   4 +-
 drivers/clk/renesas/r9a06g032-clocks.c             |   3 +-
 drivers/clk/rockchip/clk-pll.c                     |   1 +
 drivers/clk/samsung/clk-pll.c                      |   1 +
 drivers/clk/socfpga/clk-gate.c                     |  16 +-
 drivers/clk/socfpga/clk-periph.c                   |   8 +-
 drivers/clk/socfpga/clk-pll.c                      |  17 +-
 drivers/clk/st/clkgen-fsyn.c                       |   5 +-
 drivers/clocksource/sh_cmt.c                       | 102 +++--
 drivers/clocksource/timer-ti-dm-systimer.c         |   4 +-
 drivers/counter/stm32-lptimer-cnt.c                |   2 +-
 drivers/cpufreq/amd_freq_sensitivity.c             |   2 +
 drivers/cpufreq/cpufreq.c                          |   2 +-
 drivers/cpufreq/qcom-cpufreq-hw.c                  |   1 +
 drivers/cpuidle/dt_idle_states.c                   |   2 +-
 drivers/crypto/Kconfig                             |   5 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c          |   1 -
 drivers/crypto/amlogic/amlogic-gxl.h               |   2 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.c          |   1 +
 drivers/crypto/ccree/cc_debugfs.c                  |   2 +-
 drivers/crypto/ccree/cc_driver.c                   |  10 +-
 drivers/crypto/hisilicon/qm.h                      |   6 +-
 drivers/crypto/img-hash.c                          |   8 +-
 drivers/crypto/n2_core.c                           |   6 +
 drivers/crypto/omap-sham.c                         |   2 +-
 drivers/crypto/rockchip/rk3288_crypto.c            | 193 +--------
 drivers/crypto/rockchip/rk3288_crypto.h            |  53 +--
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 199 ++++++----
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   | 413 +++++++++++--------
 drivers/devfreq/devfreq.c                          |   6 +-
 drivers/devfreq/governor_userspace.c               |  12 +-
 drivers/dio/dio.c                                  |   8 +
 drivers/edac/i10nm_base.c                          |   3 +-
 drivers/firmware/efi/efi.c                         |   4 +-
 drivers/firmware/efi/libstub/efistub.h             |   2 +
 drivers/firmware/efi/libstub/random.c              |  42 +-
 drivers/firmware/raspberrypi.c                     |   1 +
 drivers/gpio/gpio-sifive.c                         |   1 +
 drivers/gpio/gpiolib-cdev.c                        |  93 +++--
 drivers/gpio/gpiolib.c                             |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   5 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |  16 +-
 .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |   3 +
 .../gpu/drm/amd/display/dc/dce80/dce80_resource.c  |   2 +
 drivers/gpu/drm/amd/include/kgd_pp_interface.h     |   3 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   3 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |   3 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   4 +
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |   3 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  18 +-
 drivers/gpu/drm/bridge/adv7511/adv7533.c           |  25 +-
 drivers/gpu/drm/drm_connector.c                    |   3 +
 drivers/gpu/drm/drm_fourcc.c                       |  11 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  11 +-
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c          |   5 +-
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c       |   4 +-
 drivers/gpu/drm/i915/gvt/debugfs.c                 |  17 +-
 drivers/gpu/drm/i915/gvt/scheduler.c               |   1 +
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c          |   6 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  12 +-
 drivers/gpu/drm/meson/meson_viu.c                  |   5 +-
 drivers/gpu/drm/msm/Makefile                       |   2 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   2 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |  78 ++--
 drivers/gpu/drm/msm/hdmi/hdmi.h                    |  30 +-
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |  81 +++-
 .../drm/msm/hdmi/{hdmi_connector.c => hdmi_hpd.c}  | 216 +---------
 drivers/gpu/drm/panel/panel-sitronix-st7701.c      |  10 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  27 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  16 +-
 drivers/gpu/drm/panfrost/panfrost_gem.h            |   5 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |  19 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   2 +-
 drivers/gpu/drm/rockchip/inno_hdmi.c               |   2 +-
 drivers/gpu/drm/rockchip/rk3066_hdmi.c             |   2 +-
 drivers/gpu/drm/rockchip/rockchip_lvds.c           |  10 +-
 drivers/gpu/drm/sti/sti_dvo.c                      |   7 +-
 drivers/gpu/drm/sti/sti_hda.c                      |   7 +-
 drivers/gpu/drm/sti/sti_hdmi.c                     |   7 +-
 drivers/gpu/drm/tegra/dc.c                         |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   3 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-mcp2221.c                          |  12 +-
 drivers/hid/hid-multitouch.c                       |   4 +
 drivers/hid/hid-plantronics.c                      |   9 +
 drivers/hid/hid-sensor-custom.c                    |   2 +-
 drivers/hid/wacom_sys.c                            |   8 +
 drivers/hid/wacom_wac.c                            |   4 +
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/hsi/controllers/omap_ssi_core.c            |  14 +-
 drivers/hv/ring_buffer.c                           |  13 +
 drivers/hwmon/Kconfig                              |   1 +
 drivers/hwmon/jc42.c                               | 243 +++++++-----
 drivers/i2c/busses/i2c-ismt.c                      |   3 +
 drivers/i2c/busses/i2c-pxa-pci.c                   |  10 +-
 drivers/i2c/muxes/i2c-mux-reg.c                    |   5 +-
 drivers/iio/accel/adis16201.c                      |   1 +
 drivers/iio/accel/adis16209.c                      |   1 +
 drivers/iio/adc/ad_sigma_delta.c                   |   8 +-
 drivers/iio/adc/ti-adc128s052.c                    |  14 +-
 drivers/iio/gyro/adis16136.c                       |   1 +
 drivers/iio/gyro/adis16260.c                       |   1 +
 drivers/iio/imu/adis.c                             |  98 ++---
 drivers/iio/imu/adis16400.c                        |   1 +
 drivers/iio/imu/adis16460.c                        |   5 +-
 drivers/iio/imu/adis16475.c                        |   6 +-
 drivers/iio/imu/adis16480.c                        |   1 +
 drivers/iio/imu/adis_buffer.c                      |  10 +-
 drivers/iio/imu/adis_trigger.c                     |  20 +-
 drivers/iio/temperature/ltc2983.c                  |  10 +-
 drivers/infiniband/core/device.c                   |   2 +-
 drivers/infiniband/core/nldev.c                    |   6 +-
 drivers/infiniband/hw/hfi1/affinity.c              |   2 +
 drivers/infiniband/hw/hfi1/firmware.c              |   6 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  24 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   4 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  49 ++-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   6 +-
 drivers/infiniband/sw/siw/siw_cq.c                 |  24 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |   2 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  40 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |   7 +
 drivers/infiniband/ulp/srp/ib_srp.c                |  96 ++++-
 drivers/input/joystick/Kconfig                     |   1 +
 drivers/input/touchscreen/elants_i2c.c             |   9 +-
 drivers/iommu/amd/init.c                           |   7 +
 drivers/iommu/amd/iommu_v2.c                       |   1 +
 drivers/iommu/fsl_pamu.c                           |   2 +-
 drivers/iommu/sun50i-iommu.c                       |  16 +-
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
 drivers/media/platform/coda/coda-jpeg.c            |  10 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  32 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   2 +-
 drivers/media/platform/qcom/camss/camss-video.c    |   3 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  17 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  14 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |   1 +
 drivers/media/radio/si470x/radio-si470x-usb.c      |   4 +-
 drivers/media/rc/imon.c                            |   6 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |  22 +-
 drivers/media/test-drivers/vimc/vimc-core.c        |   2 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   1 +
 drivers/media/usb/dvb-usb/az6027.c                 |   4 +
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   4 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c      |  22 +-
 drivers/misc/cxl/guest.c                           |  24 +-
 drivers/misc/cxl/pci.c                             |  21 +-
 drivers/misc/ocxl/config.c                         |  20 +-
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
 drivers/mmc/host/renesas_sdhi_core.c               |   2 +-
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
 drivers/mtd/spi-nor/core.c                         |   2 +
 drivers/net/bonding/bond_3ad.c                     |   1 +
 drivers/net/bonding/bond_main.c                    |  13 +-
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
 drivers/net/ethernet/freescale/enetc/enetc.c       |   8 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  10 +-
 drivers/net/ethernet/intel/igc/igc.h               |   2 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c          | 245 +++++++++---
 drivers/net/ethernet/intel/igc/igc_tsn.c           |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   6 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   1 +
 drivers/net/ethernet/neterion/s2io.c               |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   3 +-
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
 drivers/net/macsec.c                               |  34 +-
 drivers/net/ntb_netdev.c                           |   4 +-
 drivers/net/phy/xilinx_gmii2rgmii.c                |   1 +
 drivers/net/ppp/ppp_generic.c                      |   2 +
 drivers/net/usb/rndis_host.c                       |   3 +-
 drivers/net/veth.c                                 |   5 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   8 +
 drivers/net/wan/farsync.c                          |   2 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |   6 +
 drivers/net/wireless/ath/ath10k/pci.c              |  20 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  46 ++-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   5 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   3 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |  10 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |   4 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   6 +-
 drivers/nfc/pn533/pn533.c                          |   4 +
 drivers/nvme/host/nvme.h                           |   2 +-
 drivers/nvme/host/pci.c                            |  37 +-
 drivers/nvme/target/passthru.c                     |  11 +-
 drivers/of/overlay.c                               |   4 +-
 drivers/parisc/led.c                               |   3 +
 drivers/pci/controller/dwc/pcie-designware.c       |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   2 +-
 drivers/pci/irq.c                                  |   2 +
 drivers/pci/pci-sysfs.c                            |  13 +-
 drivers/pci/pci.c                                  |   2 +
 drivers/perf/arm_dsu_pmu.c                         |   6 +-
 drivers/perf/arm_smmuv3_pmu.c                      |   8 +-
 drivers/phy/broadcom/phy-brcm-usb.c                |   6 +-
 drivers/pinctrl/pinconf-generic.c                  |   4 +-
 drivers/platform/chrome/cros_usbpd_notify.c        |   6 +-
 drivers/platform/x86/huawei-wmi.c                  |  20 +-
 drivers/platform/x86/intel_scu_ipc.c               |   2 +-
 drivers/platform/x86/mxm-wmi.c                     |   8 +-
 drivers/pnp/core.c                                 |   4 +-
 drivers/power/supply/power_supply_core.c           |   7 +-
 drivers/pwm/pwm-sifive.c                           |   5 +-
 drivers/pwm/pwm-tegra.c                            |   4 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  15 +-
 drivers/rapidio/rio-scan.c                         |   8 +-
 drivers/rapidio/rio.c                              |   9 +-
 drivers/regulator/core.c                           |  15 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   4 +
 drivers/remoteproc/qcom_sysmon.c                   |   5 +-
 drivers/remoteproc/remoteproc_core.c               |   9 +-
 drivers/rtc/rtc-cmos.c                             | 366 ++++++++---------
 drivers/rtc/rtc-ds1347.c                           |   2 +-
 drivers/rtc/rtc-mxc_v2.c                           |   4 +-
 drivers/rtc/rtc-pcf85063.c                         |  10 +-
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
 drivers/scsi/scsi_debug.c                          |  11 +-
 drivers/scsi/scsi_error.c                          |  14 +-
 drivers/scsi/snic/snic_disc.c                      |   3 +
 drivers/soc/qcom/Kconfig                           |   1 +
 drivers/soc/qcom/apr.c                             | 142 ++++---
 drivers/soc/qcom/llcc-qcom.c                       |   2 +-
 drivers/soc/ti/knav_qmss_queue.c                   |   6 +-
 drivers/soc/ti/smartreflex.c                       |   1 +
 drivers/soc/ux500/ux500-soc-id.c                   |  10 +-
 drivers/soundwire/intel.c                          |   8 +-
 drivers/soundwire/qcom.c                           |   8 +-
 drivers/soundwire/stream.c                         |   4 +-
 drivers/spi/spi-gpio.c                             |  16 +-
 drivers/spi/spidev.c                               |  21 +-
 drivers/staging/iio/accel/adis16203.c              |   1 +
 drivers/staging/iio/accel/adis16240.c              |   1 +
 drivers/staging/media/tegra-video/csi.c            |   4 +-
 drivers/staging/media/tegra-video/csi.h            |   2 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |   2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   4 +-
 drivers/thermal/imx8mm_thermal.c                   |   8 +-
 drivers/tty/serial/altera_uart.c                   |  21 +-
 drivers/tty/serial/amba-pl011.c                    |  14 +-
 drivers/tty/serial/fsl_lpuart.c                    |  18 +-
 drivers/tty/serial/pch_uart.c                      |   4 +
 drivers/tty/serial/serial-tegra.c                  |   6 +-
 drivers/tty/serial/serial_core.c                   |   3 +-
 drivers/tty/serial/sunsab.c                        |   8 +-
 drivers/uio/uio_dmem_genirq.c                      |  13 +-
 drivers/usb/dwc3/core.c                            |  23 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |  13 +-
 drivers/usb/gadget/function/f_hid.c                | 271 ++++++++++---
 drivers/usb/gadget/function/u_hid.h                |   1 +
 drivers/usb/gadget/udc/fotg210-udc.c               |  12 +-
 drivers/usb/musb/musb_gadget.c                     |   2 -
 drivers/usb/roles/class.c                          |   5 +-
 drivers/usb/storage/alauda.c                       |   2 +
 drivers/usb/typec/bus.c                            |   2 +-
 drivers/usb/typec/tcpm/tcpci.c                     |   5 +-
 drivers/usb/typec/tps6598x.c                       |   2 +-
 drivers/vfio/platform/vfio_platform_common.c       |   3 +-
 drivers/vhost/vhost.c                              |   4 +-
 drivers/vhost/vringh.c                             |   5 +-
 drivers/vhost/vsock.c                              |   9 +-
 drivers/video/fbdev/Kconfig                        |   1 -
 drivers/video/fbdev/hyperv_fb.c                    |   8 +-
 drivers/video/fbdev/matrox/matroxfb_base.c         |   4 +-
 drivers/video/fbdev/pm2fb.c                        |   9 +-
 drivers/video/fbdev/uvesafb.c                      |   1 +
 drivers/video/fbdev/vermilion/vermilion.c          |   4 +-
 drivers/video/fbdev/via/via-core.c                 |   9 +-
 drivers/vme/bridges/vme_fake.c                     |   2 +
 drivers/vme/bridges/vme_tsi148.c                   |   1 +
 drivers/xen/privcmd.c                              |   2 +-
 fs/afs/fs_probe.c                                  |   5 +-
 fs/binfmt_elf_fdpic.c                              |   5 +-
 fs/binfmt_misc.c                                   |   8 +-
 fs/btrfs/backref.c                                 |   4 +
 fs/btrfs/ioctl.c                                   |   9 +-
 fs/btrfs/rcu-string.h                              |   6 +-
 fs/ceph/caps.c                                     |   2 +-
 fs/ceph/locks.c                                    |   4 -
 fs/ceph/super.h                                    |   1 -
 fs/char_dev.c                                      |   2 +-
 fs/cifs/cifsfs.c                                   |   8 +-
 fs/cifs/cifsglob.h                                 |  69 ++++
 fs/cifs/cifsproto.h                                |   4 +-
 fs/cifs/connect.c                                  |   4 +-
 fs/cifs/misc.c                                     |   4 +-
 fs/cifs/smb2ops.c                                  | 143 ++++---
 fs/configfs/dir.c                                  |   2 +
 fs/debugfs/file.c                                  |  28 +-
 fs/ext4/ext4.h                                     |   9 +-
 fs/ext4/extents.c                                  |   8 +
 fs/ext4/extents_status.c                           |   3 +-
 fs/ext4/fast_commit.c                              |  49 ++-
 fs/ext4/fast_commit.h                              |   1 +
 fs/ext4/indirect.c                                 |  11 +-
 fs/ext4/inline.c                                   |   2 +-
 fs/ext4/inode.c                                    |  49 ++-
 fs/ext4/ioctl.c                                    |  13 +-
 fs/ext4/mballoc.h                                  |   2 +-
 fs/ext4/migrate.c                                  |   6 +-
 fs/ext4/namei.c                                    |  49 ++-
 fs/ext4/resize.c                                   |   6 +-
 fs/ext4/super.c                                    | 230 +++++------
 fs/ext4/verity.c                                   |   7 +-
 fs/ext4/xattr.c                                    | 184 ++++-----
 fs/ext4/xattr.h                                    |   1 +
 fs/f2fs/gc.c                                       |  11 +-
 fs/f2fs/segment.c                                  |   2 +-
 fs/hfs/inode.c                                     |  13 +-
 fs/hfs/trans.c                                     |   2 +-
 fs/hfsplus/hfsplus_fs.h                            |   2 +
 fs/hfsplus/inode.c                                 |  16 +-
 fs/hfsplus/options.c                               |   4 +
 fs/hugetlbfs/inode.c                               |   6 +-
 fs/jfs/jfs_dmap.c                                  |  27 +-
 fs/libfs.c                                         |  22 +-
 fs/locks.c                                         |  23 ++
 fs/mbcache.c                                       | 121 ++++--
 fs/nfs/namespace.c                                 |   2 +-
 fs/nfs/nfs4proc.c                                  |  34 +-
 fs/nfs/nfs4state.c                                 |   2 +
 fs/nfs/nfs4xdr.c                                   |  12 +-
 fs/nfsd/nfs4callback.c                             |   8 +-
 fs/nfsd/nfs4state.c                                |  51 ++-
 fs/nfsd/nfs4xdr.c                                  |  11 +
 fs/nfsd/nfssvc.c                                   |   2 +-
 fs/nilfs2/the_nilfs.c                              |  73 +++-
 fs/ocfs2/journal.c                                 |   2 +-
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/stackglue.c                               |   8 +-
 fs/ocfs2/super.c                                   | 105 ++---
 fs/orangefs/orangefs-debugfs.c                     |  29 +-
 fs/orangefs/orangefs-mod.c                         |   8 +-
 fs/overlayfs/dir.c                                 |  46 ++-
 fs/overlayfs/super.c                               |   7 +-
 fs/pnode.c                                         |   2 +-
 fs/pstore/Kconfig                                  |   1 +
 fs/pstore/pmsg.c                                   |   7 +-
 fs/pstore/ram.c                                    |   2 +
 fs/pstore/ram_core.c                               |   6 +-
 fs/pstore/zone.c                                   |   2 +-
 fs/quota/dquot.c                                   |   2 +
 fs/reiserfs/namei.c                                |   4 +
 fs/reiserfs/xattr_security.c                       |   2 +-
 fs/sysv/itree.c                                    |   2 +-
 fs/udf/inode.c                                     |   2 +-
 fs/udf/namei.c                                     |   8 +-
 fs/xattr.c                                         |   2 +-
 include/linux/debugfs.h                            |  19 +-
 include/linux/devfreq.h                            |   7 +-
 include/linux/efi.h                                |   2 -
 include/linux/eventfd.h                            |   2 +-
 include/linux/fs.h                                 |  18 +-
 include/linux/highmem.h                            |  18 +
 include/linux/hyperv.h                             |   2 +
 include/linux/iio/imu/adis.h                       |  63 +--
 include/linux/interrupt.h                          |   4 +
 include/linux/mbcache.h                            |  41 +-
 include/linux/netdevice.h                          |  58 +--
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/nvme.h                               |   3 +-
 include/linux/proc_fs.h                            |   2 +
 include/linux/skbuff.h                             |  42 +-
 include/linux/soc/qcom/apr.h                       |  12 +-
 include/linux/sunrpc/rpc_pipe_fs.h                 |   5 +
 include/linux/timerqueue.h                         |   2 +-
 include/media/dvbdev.h                             |  32 +-
 include/net/dst.h                                  |   5 +-
 include/net/mptcp.h                                |  12 +-
 include/net/mrp.h                                  |   1 +
 include/net/pkt_sched.h                            |   9 +
 include/sound/hdaudio.h                            |   2 +
 include/sound/hdaudio_ext.h                        |   1 -
 include/sound/pcm.h                                |  36 +-
 include/sound/soc-dai.h                            |  32 +-
 include/trace/events/ext4.h                        |   7 +-
 include/trace/events/jbd2.h                        |  44 +--
 include/uapi/drm/drm_fourcc.h                      |  11 +
 include/uapi/linux/idxd.h                          |   2 +-
 include/uapi/linux/swab.h                          |   2 +-
 include/uapi/sound/asequencer.h                    |   8 +-
 io_uring/io_uring.c                                |   2 +-
 kernel/Makefile                                    |   2 +-
 kernel/acct.c                                      |   2 +
 kernel/bpf/btf.c                                   |   5 +
 kernel/bpf/verifier.c                              | 123 +++---
 kernel/cpu.c                                       |   4 +-
 kernel/events/core.c                               |  14 +-
 kernel/futex/Makefile                              |   3 +
 kernel/{futex.c => futex/core.c}                   |  30 +-
 kernel/gcov/gcc_4_7.c                              |   5 +
 kernel/irq/internals.h                             |   2 +
 kernel/irq/irqdesc.c                               |  15 +-
 kernel/irq/manage.c                                |  11 +-
 kernel/kcsan/core.c                                |  50 +++
 kernel/padata.c                                    |  15 +-
 kernel/power/snapshot.c                            |   4 +-
 kernel/rcu/tree.c                                  |  23 +-
 kernel/rcu/tree.h                                  |   1 +
 kernel/relay.c                                     |   4 +-
 kernel/sched/fair.c                                | 128 +++++-
 kernel/trace/blktrace.c                            |   3 +-
 kernel/trace/trace.c                               |  15 +-
 kernel/trace/trace_events_hist.c                   |  13 +-
 lib/Kconfig.debug                                  |   1 -
 lib/debugobjects.c                                 |  10 +
 lib/fonts/fonts.c                                  |   4 +-
 lib/iov_iter.c                                     |  14 -
 lib/notifier-error-inject.c                        |   2 +-
 lib/test_firmware.c                                |   1 +
 mm/compaction.c                                    |  18 +-
 net/802/mrp.c                                      |  18 +-
 net/bluetooth/hci_core.c                           |   2 +-
 net/bluetooth/rfcomm/core.c                        |   2 +-
 net/bpf/test_run.c                                 |   3 -
 net/caif/cfctrl.c                                  |   6 +-
 net/core/dev.c                                     |  16 +-
 net/core/filter.c                                  |  18 +-
 net/core/skbuff.c                                  |   9 +-
 net/core/sock_map.c                                |   2 +
 net/core/stream.c                                  |   6 +
 net/ethtool/ioctl.c                                |   3 +-
 net/hsr/hsr_device.c                               |  59 +--
 net/hsr/hsr_forward.c                              |  15 +-
 net/hsr/hsr_framereg.c                             |   9 +-
 net/hsr/hsr_framereg.h                             |   2 +
 net/ipv4/inet_connection_sock.c                    |  28 +-
 net/ipv4/syncookies.c                              |   7 +-
 net/ipv4/tcp_bpf.c                                 |   8 +-
 net/ipv4/tcp_ulp.c                                 |   4 +
 net/ipv4/udp_tunnel_core.c                         |   1 +
 net/mac80211/iface.c                               |   1 +
 net/mptcp/subflow.c                                |  76 +++-
 net/netfilter/ipset/ip_set_core.c                  |   7 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |  14 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c           |  13 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |  13 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c         |  13 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |  13 +-
 net/netfilter/ipset/ip_set_hash_net.c              |  17 +-
 net/netfilter/ipset/ip_set_hash_netiface.c         |  15 +-
 net/netfilter/ipset/ip_set_hash_netnet.c           |  23 +-
 net/netfilter/ipset/ip_set_hash_netport.c          |  19 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c       |  40 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c          |  53 +++
 net/netfilter/nf_flow_table_offload.c              |   6 +-
 net/nfc/netlink.c                                  |  52 ++-
 net/openvswitch/datapath.c                         |  25 +-
 net/packet/af_packet.c                             |  20 +-
 net/rxrpc/output.c                                 |   2 +-
 net/rxrpc/sendmsg.c                                |   2 +-
 net/sched/cls_tcindex.c                            |  12 +-
 net/sched/ematch.c                                 |   2 +
 net/sched/sch_api.c                                |   5 +
 net/sched/sch_atm.c                                |   5 +-
 net/sched/sch_cbq.c                                |   4 +-
 net/sctp/sysctl.c                                  |  73 ++--
 net/sunrpc/auth_gss/auth_gss.c                     |  19 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   9 +-
 net/sunrpc/clnt.c                                  |   2 +-
 net/sunrpc/xprtrdma/verbs.c                        |   2 +-
 net/vmw_vsock/vmci_transport.c                     |   6 +-
 net/wireless/reg.c                                 |   4 +-
 samples/vfio-mdev/mdpy-fb.c                        |   8 +-
 security/apparmor/apparmorfs.c                     |   4 +-
 security/apparmor/lsm.c                            |   4 +-
 security/apparmor/policy.c                         |   2 +-
 security/apparmor/policy_ns.c                      |   2 +-
 security/apparmor/policy_unpack.c                  |   2 +-
 security/device_cgroup.c                           |  33 +-
 security/integrity/digsig.c                        |   6 +-
 security/integrity/ima/ima_main.c                  |   1 +
 security/integrity/ima/ima_policy.c                |  53 ++-
 security/integrity/ima/ima_template.c              |   9 +-
 security/integrity/platform_certs/load_uefi.c      |   1 +
 security/loadpin/loadpin.c                         |  30 +-
 sound/core/pcm_native.c                            |   4 +-
 sound/drivers/mts64.c                              |   3 +
 sound/hda/ext/hdac_ext_stream.c                    |  17 -
 sound/hda/hdac_stream.c                            |  27 ++
 sound/pci/asihpi/hpioctl.c                         |   2 +-
 sound/pci/hda/hda_controller.c                     |   4 +-
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |  77 ++++
 sound/soc/codecs/hdac_hda.c                        |  22 +-
 sound/soc/codecs/max98373-sdw.c                    |   2 +-
 sound/soc/codecs/pcm512x.c                         |   8 +-
 sound/soc/codecs/rt1308-sdw.c                      |   2 +-
 sound/soc/codecs/rt298.c                           |   7 +
 sound/soc/codecs/rt5670.c                          |   2 -
 sound/soc/codecs/rt5682-sdw.c                      |   2 +-
 sound/soc/codecs/rt700.c                           |   2 +-
 sound/soc/codecs/rt711.c                           |   2 +-
 sound/soc/codecs/rt715.c                           |   2 +-
 sound/soc/codecs/wm8994.c                          |   5 +
 sound/soc/codecs/wsa881x.c                         |   2 +-
 sound/soc/generic/audio-graph-card.c               |   4 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  15 +
 sound/soc/intel/boards/sof_sdw.c                   |   6 +-
 sound/soc/intel/skylake/skl-pcm.c                  |   7 +-
 sound/soc/intel/skylake/skl.c                      |   7 +-
 sound/soc/jz4740/jz4740-i2s.c                      |  39 +-
 sound/soc/mediatek/common/mtk-btcvsd.c             |   6 +-
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c         |  71 +++-
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |   7 +-
 sound/soc/pxa/mmp-pcm.c                            |   2 +-
 sound/soc/qcom/lpass-sc7180.c                      |   3 +
 sound/soc/qcom/sdm845.c                            |   4 +-
 sound/soc/rockchip/rockchip_pdm.c                  |   1 +
 sound/soc/rockchip/rockchip_spdif.c                |   1 +
 sound/soc/sof/intel/hda-dai.c                      |   7 +-
 sound/usb/line6/driver.c                           |   3 +-
 sound/usb/line6/midi.c                             |   6 +-
 sound/usb/line6/midibuf.c                          |  25 +-
 sound/usb/line6/midibuf.h                          |   5 +-
 sound/usb/line6/pod.c                              |   3 +-
 sound/usb/quirks-table.h                           |   2 +
 tools/arch/parisc/include/uapi/asm/mman.h          |  12 +-
 tools/lib/bpf/bpf.h                                |   7 +
 tools/lib/bpf/btf_dump.c                           |  29 +-
 tools/lib/bpf/libbpf.c                             |   3 +
 tools/objtool/check.c                              |  12 +-
 tools/perf/bench/bench.h                           |  12 -
 tools/perf/builtin-trace.c                         |  32 +-
 tools/perf/util/data.c                             |   2 +
 tools/perf/util/debug.c                            |   4 +
 tools/perf/util/dwarf-aux.c                        |  23 +-
 tools/perf/util/symbol-elf.c                       |   2 +-
 tools/testing/ktest/ktest.pl                       |  23 +-
 tools/testing/selftests/Makefile                   |  26 +-
 .../selftests/drivers/net/netdevsim/devlink.sh     |   4 +-
 tools/testing/selftests/efivarfs/efivarfs.sh       |   5 +
 .../ftrace/test.d/ftrace/func_event_triggers.tc    |  15 +-
 tools/testing/selftests/lib.mk                     |   5 +
 .../selftests/netfilter/conntrack_icmp_related.sh  |  36 +-
 .../selftests/powerpc/dscr/dscr_sysfs_test.c       |   5 +-
 tools/testing/selftests/proc/proc-uptime-002.c     |   3 +-
 .../selftests/rcutorture/bin/console-badness.sh    |   3 +-
 747 files changed, 7705 insertions(+), 4186 deletions(-)


