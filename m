Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9256649F3
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbjAJS2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239092AbjAJS1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:27:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D050F5D418;
        Tue, 10 Jan 2023 10:22:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DAE761865;
        Tue, 10 Jan 2023 18:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58FAC433D2;
        Tue, 10 Jan 2023 18:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374971;
        bh=oRZbMAigtaDQM3hUoFHLqEGIC4FuKx2ucK1l7tYiGt4=;
        h=From:To:Cc:Subject:Date:From;
        b=OjHvjN+rKHcwnCRE0Yn8vhgT1sqmNqKAqjd7qh+EYugqdammu+HxMrBBHig3IoHpn
         72Ph8gOOpIYamQdE/5oMZ4ozfP3E9y2zAob7ZYTP0UDPdntLS7L7jp5q4baVVIt3uz
         1l++HbDmA12C77RRf3artcKFh1cqTr6sOxOIoQZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/290] 5.15.87-rc1 review
Date:   Tue, 10 Jan 2023 19:01:32 +0100
Message-Id: <20230110180031.620810905@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.87-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.87-rc1
X-KernelTest-Deadline: 2023-01-12T18:00+00:00
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

This is the start of the stable review cycle for the 5.15.87 release.
There are 290 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.87-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.87-rc1

Jocelyn Falempe <jfalempe@redhat.com>
    drm/mgag200: Fix PLL setup for G200_SE_A rev >=4

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    io_uring: Fix unsigned 'res' comparison with zero in io_fixup_rw_res()

Ard Biesheuvel <ardb@kernel.org>
    efi: random: combine bootloader provided RNG seed with RNG protocol output

Jan Kara <jack@suse.cz>
    mbcache: Avoid nesting of cache->c_list_lock under bit locks

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix return value check bug of rx copybreak

Qu Wenruo <wqu@suse.com>
    btrfs: make thaw time super block check to also verify checksum

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests: set the BUILD variable to absolute path

Eric Biggers <ebiggers@google.com>
    ext4: don't allow journal inode to have encrypt flag

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: use proper req destructor for IPv6

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: dedicated request sock for subflow in v6

Mario Limonciello <mario.limonciello@amd.com>
    Revert "ACPI: PM: Add support for upcoming AMD uPEP HID AMDI007"

William Liu <will@willsroot.io>
    ksmbd: check nt_len to be at least CIFS_ENCPWD_SIZE in ksmbd_decode_ntlmssp_auth_blob

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix infinite loop in ksmbd_conn_handler_loop()

Linus Torvalds <torvalds@linux-foundation.org>
    hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling

Arnd Bergmann <arnd@arndb.de>
    hfs/hfsplus: use WARN_ON for sanity check

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: fix vgpu debugfs clean in remove

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: fix gvt debugfs destroy

Björn Töpel <bjorn@rivosinc.com>
    riscv, kprobes: Stricter c.jr/c.jalr decoding

Ben Dooks <ben-linux@fluff.org>
    riscv: uaccess: fix type of 0 variable on error in get_user()

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: int340x: Add missing attribute for data rate base

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix CQ waiting timeout handling

Jens Axboe <axboe@kernel.dk>
    block: don't allow splitting of a REQ_NOWAIT bio

Paul Menzel <pmenzel@molgen.mpg.de>
    fbdev: matroxfb: G200eW: Increase max memory from 1 MB to 16 MB

Jeff Layton <jlayton@kernel.org>
    nfsd: fix handling of readdir in v4root vs. mount upcall timeout

Rodrigo Branco <bsdaemon@google.com>
    x86/bugs: Flush IBP in ib_prctl_set()

Takashi Iwai <tiwai@suse.de>
    x86/kexec: Fix double-free of elf header buffer

Qu Wenruo <wqu@suse.com>
    btrfs: check superblock to ensure the fs was not modified at thaw time

Christoph Hellwig <hch@lst.de>
    nvme: also return I/O command effects from nvme_command_effects

Christoph Hellwig <hch@lst.de>
    nvmet: use NVME_CMD_EFFECTS_CSUPP instead of open coding it

Jens Axboe <axboe@kernel.dk>
    io_uring: check for valid register opcode earlier

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

Namhyung Kim <namhyung@kernel.org>
    perf stat: Fix handling of --for-each-cgroup with --bpf-counters to match non BPF mode

Szymon Heidrich <szymon.heidrich@gmail.com>
    usb: rndis_host: Secure rndis_query check against int overflow

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Fix lmtst ID used in aura free

Daniil Tatianin <d-tatianin@yandex-team.ru>
    drivers/net/bonding/bond_3ad: return when there's no aggregator

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fs/ntfs3: don't hold ni_lock when calling truncate_setsize()

Philipp Zabel <p.zabel@pengutronix.de>
    drm/imx: ipuv3-plane: Fix overlay plane width

Miaoqian Lin <linmq006@gmail.com>
    perf tools: Fix resources leak in perf_data__open_dir()

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Rework long task execution when adding/deleting entries

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: fix hash:net,port,net hang with /0 subnet

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: sparx5: Fix reading of the MAC address

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

Shay Drory <shayd@nvidia.com>
    RDMA/mlx5: Fix mlx5_ib_get_hw_stats when used for device

Miaoqian Lin <linmq006@gmail.com>
    net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe

David Arinzon <darinzon@amazon.com>
    net: ena: Update NUMA TPH hint register upon NUMA node update

David Arinzon <darinzon@amazon.com>
    net: ena: Set default value for RX interrupt moderation

David Arinzon <darinzon@amazon.com>
    net: ena: Fix rx_copybreak value update

David Arinzon <darinzon@amazon.com>
    net: ena: Use bitmask to indicate packet redirection

David Arinzon <darinzon@amazon.com>
    net: ena: Account for the number of processed bytes in XDP

David Arinzon <darinzon@amazon.com>
    net: ena: Don't register memory info on XDP exchange

David Arinzon <darinzon@amazon.com>
    net: ena: Fix toeplitz initial hash value

Jiguang Xiao <jiguang.xiao@windriver.com>
    net: amd-xgbe: add missed tasklet_kill

Adham Faris <afaris@nvidia.com>
    net/mlx5e: Fix hw mtu initializing at XDP SQ allocation

Chris Mi <cmi@nvidia.com>
    net/mlx5e: Always clear dest encap in neigh-update-del

Roi Dayan <roid@nvidia.com>
    net/mlx5e: TC, Refactor mlx5e_tc_add_flow_mod_hdr() to get flow attr

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default

Shay Drory <shayd@nvidia.com>
    net/mlx5: Avoid recovery in probe flows

Jiri Pirko <jiri@nvidia.com>
    net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: E-Switch, properly handle ingress tagged packets on VST

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim: fix vringh initialization in vdpasim_queue_ready()

Stefano Garzarella <sgarzare@redhat.com>
    vhost: fix range used in translate_desc()

Stefano Garzarella <sgarzare@redhat.com>
    vringh: fix range used in iotlb_translate()

Yuan Can <yuancan@huawei.com>
    vhost/vsock: Fix error handling in vhost_vsock_init()

ruanjinjie <ruanjinjie@huawei.com>
    vdpa_sim: fix possible memory leak in vdpasim_net_init() and vdpasim_blk_init()

Miaoqian Lin <linmq006@gmail.com>
    nfc: Fix potential resource leaks

Johnny S. Lee <foss@jsl.io>
    net: dsa: mv88e6xxx: depend on PTP conditionally

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure

Hawkins Jiawei <yin31149@gmail.com>
    net: sched: fix memory leak in tcindex_set_parms

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix VF promisc mode not update when mac table full

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix miss L3E checking for rx packet

Peng Li <lipeng321@huawei.com>
    net: hns3: extract macro to simplify ring stats update code

Hao Chen <chenhao288@hisilicon.com>
    net: hns3: refactor hns3_nic_reuse_page()

Jie Wang <wangjie125@huawei.com>
    net: hns3: add interrupts re-initialization while doing VF FLR

Jeff Layton <jlayton@kernel.org>
    nfsd: shut down the NFSv4 state objects before the filecache

Shawn Bohrer <sbohrer@cloudflare.com>
    veth: Fix race with AF_XDP exposing old or uninitialized descriptors

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: honor set timeout and garbage collection updates

Ronak Doshi <doshir@vmware.com>
    vmxnet3: correctly report csum_level for encapsulated packet

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: perform type checking for existing sets

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: add function to create set stateful expressions

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: consolidate set description

Steven Price <steven.price@arm.com>
    drm/panfrost: Fix GEM handle creation ref-counting

Jakub Kicinski <kuba@kernel.org>
    bpf: pull before calling skb_postpull_rcsum()

Sasha Levin <sashal@kernel.org>
    btrfs: fix an error handling path in btrfs_defrag_leaves()

minoura makoto <minoura@valinux.co.jp>
    SUNRPC: ensure the matching upcall is in-flight upon downcall

Matthew Auld <matthew.auld@intel.com>
    drm/i915/migrate: fix length calculation

Matthew Auld <matthew.auld@intel.com>
    drm/i915/migrate: fix offset calculation

Matthew Auld <matthew.auld@intel.com>
    drm/i915/migrate: don't check the scratch page

Jan Kara <jack@suse.cz>
    ext4: fix deadlock due to mbcache entry corruption

Jan Kara <jack@suse.cz>
    mbcache: automatically delete entries from cache on freeing

Baokun Li <libaokun1@huawei.com>
    ext4: correct inconsistent error msg in nojournal mode

Jason Yan <yanaijie@huawei.com>
    ext4: goto right label 'failed_mount3a'

Biju Das <biju.das.jz@bp.renesas.com>
    ravb: Fix "failed to switch device to config mode" message during unbind

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

void0red <void0red@gmail.com>
    btrfs: fix extent map use-after-free when handling missing device in read_one_chunk

Nikolay Borisov <nborisov@suse.com>
    btrfs: move missing device handling in a dedicate function

Sasha Levin <sashal@kernel.org>
    btrfs: replace strncpy() with strscpy()

Sasha Levin <sashal@kernel.org>
    phy: qcom-qmp-combo: fix out-of-bounds clock access

Jens Axboe <axboe@kernel.dk>
    ARM: renumber bits related to _TIF_WORK_MASK

Eric Biggers <ebiggers@kernel.org>
    ext4: fix off-by-one errors in fast-commit block filling

Eric Biggers <ebiggers@kernel.org>
    ext4: fix unaligned memory access in ext4_fc_reserve_space()

Eric Biggers <ebiggers@kernel.org>
    ext4: add missing validation of fast-commit record lengths

Eric Biggers <ebiggers@kernel.org>
    ext4: don't set up encryption key during jbd2 transaction

Eric Biggers <ebiggers@kernel.org>
    ext4: disable fast-commit of encrypted dir operations

Eric Biggers <ebiggers@kernel.org>
    ext4: fix potential out of bound read in ext4_fc_replay_scan()

Eric Biggers <ebiggers@kernel.org>
    ext4: factor out ext4_fc_get_tl()

Eric Biggers <ebiggers@kernel.org>
    ext4: introduce EXT4_FC_TAG_BASE_LEN helper

Eric Biggers <ebiggers@kernel.org>
    ext4: use ext4_debug() instead of jbd_debug()

Eric Biggers <ebiggers@kernel.org>
    ext4: remove unused enum EXT4_FC_COMMIT_FAILED

Zheng Yejian <zhengyejian1@huawei.com>
    tracing: Fix issue of missing one synthetic field

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    block: mq-deadline: Fix dd_finish_request() for zoned devices

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

Ye Bin <yebin10@huawei.com>
    ext4: fix kernel BUG in 'ext4_write_inline_data_end()'

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

Ye Bin <yebin10@huawei.com>
    ext4: fix uninititialized value in 'ext4_evict_inode'

Eric Biggers <ebiggers@google.com>
    ext4: fix leaking uninitialized memory in fast-commit journal

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

Alexander Potapenko <glider@google.com>
    fs: ext4: initialize fsdata in pagecache_write()

Luís Henriques <lhenriques@suse.de>
    ext4: remove trailing newline from ext4_msg() message

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

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: fix sc8180x reset

Isaac J. Manjarres <isaacmanjarres@google.com>
    driver core: Fix bus_type.match() error handling in __driver_attach()

Mario Limonciello <mario.limonciello@amd.com>
    crypto: ccp - Add support for TEE for PCI ID 0x14CA

Corentin Labbe <clabbe@baylibre.com>
    crypto: n2 - add missing hash statesize

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    riscv: mm: notify remote harts about mmu cache updates

Guo Ren <guoren@linux.alibaba.com>
    riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument

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

Maximilian Luz <luzmaximilian@gmail.com>
    ipu3-imgu: Fix NULL pointer dereference in imgu_subdev_set_selection()

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    ASoC: jz4740-i2s: Handle independent FIFO flush bits

Michael Walle <michael@walle.cc>
    wifi: wilc1000: sdio: fix module autoloading

Aditya Garg <gargaditya08@live.com>
    efi: Add iMac Pro 2017 to uefi skip cert quirk

Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
    md/bitmap: Fix bitmap chunk size overflow issues

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    block: mq-deadline: Do not break sequential write streams to zoned HDDs

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
    staging: media: tegra-video: fix device_node use after free

Luca Ceresoli <luca.ceresoli@bootlin.com>
    staging: media: tegra-video: fix chan->mipi value on error

Yang Jihong <yangjihong1@huawei.com>
    tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/probes: Handle system names with hyphens

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix wrong return value in parse_action_params()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Fix complicated dependency of CONFIG_TRACER_MAX_TRACE

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Fix race where eprobes can be called before the event

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/kprobes: Fix optprobe optimization check with CONFIG_RETHUNK

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/kprobes: Fix kprobes instruction boudary check with CONFIG_RETHUNK

Steven Rostedt (Google) <rostedt@goodmis.org>
    ftrace/x86: Add back ftrace_expected for ftrace bug reports

Ashok Raj <ashok.raj@intel.com>
    x86/microcode/intel: Do not retry microcode reloading on the APs

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Resume guest immediately when injecting #GP on ECREATE

Rob Herring <robh@kernel.org>
    of/kexec: Fix reading 32-bit "linux,initrd-{start,end}" values

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

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: remove MPTCP 'ifdef' in TCP SYN cookies

Florian Westphal <fw@strlen.de>
    mptcp: mark ops structures as ro_after_init

Alexander Aring <aahringo@redhat.com>
    fs: dlm: retry accept() until -EAGAIN or error returns

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix sock release if listen fails

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

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Clear attr_update properly

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Disable I/O stacks to PMU mapping on ICX-D

Bixuan Cui <cuibixuan@linux.alibaba.com>
    jbd2: use the correct print format

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl minconfig: Unset configs instead of just removing them

Steven Rostedt <rostedt@goodmis.org>
    kest.pl: Fix grub2 menu handling for rebooting

Manivannan Sadhasivam <mani@kernel.org>
    soc: qcom: Select REMAP_MMIO for LLCC driver

Jason A. Donenfeld <Jason@zx2c4.com>
    media: stv0288: use explicitly signed char

Eric Dumazet <edumazet@google.com>
    net/af_packet: make sure to pull mac header

Hangbin Liu <liuhangbin@gmail.com>
    net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Simplify trc_read_check_handler() atomic operations

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

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: allow to read node block after shutdown

Pavel Machek <pavel@denx.de>
    f2fs: should put a page when checking the summary info

NARIBAYASHI Akira <a.naribayashi@fujitsu.com>
    mm, compaction: fix fast_isolate_around() to stay within boundaries

Mikulas Patocka <mpatocka@redhat.com>
    md: fix a crash in mempool_free

ChiYuan Huang <cy_huang@richtek.com>
    mfd: mt6360: Add bounds checking in Regmap read/write call-backs

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

Luca Stefani <luca@osomprivacy.com>
    pstore: Properly assign mem_type property

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

Yin Xiujiang <yinxiujiang@kylinos.cn>
    fs/ntfs3: Fix slab-out-of-bounds in r_page

Dan Carpenter <dan.carpenter@oracle.com>
    fs/ntfs3: Delete duplicate condition in ntfs_read_mft()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fs/ntfs3: Use __GFP_NOWARN allocation at ntfs_fill_super()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fs/ntfs3: Use __GFP_NOWARN allocation at wnd_init()

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate index root when initialize NTFS security

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: dmi-quirks: add quirk variant for LAPBC710 NUC15

Hawkins Jiawei <yin31149@gmail.com>
    fs/ntfs3: Fix slab-out-of-bounds read in run_unpack

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate resident attribute name

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate buffer length while parsing index

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate attribute name offset

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Add null pointer check for inode operations

Shigeru Yoshida <syoshida@redhat.com>
    fs/ntfs3: Fix memory leak on ntfs_fill_super() error path

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Add null pointer check to attr_load_runs_vcn

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate data run offset

edward lo <edward.lo@ambergroup.io>
    fs/ntfs3: Add overflow check for attribute size

edward lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate BOOT record_size

Christoph Hellwig <hch@lst.de>
    nvmet: don't defer passthrough commands with trivial effects to the workqueue

Christoph Hellwig <hch@lst.de>
    nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition

Adam Vodopjan <grozzly@protonmail.com>
    ata: ahci: Fix PCS quirk application for suspend

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq

Adrian Freund <adrian@freund.io>
    ACPI: resource: do IRQ override on Lenovo 14ALC7

Erik Schumacher <ofenfisch@googlemail.com>
    ACPI: resource: do IRQ override on XMG Core 15

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    ACPI: resource: do IRQ override on LENOVO IdeaPad

Tamim Khan <tamim@fusetak.com>
    ACPI: resource: Skip IRQ override on Asus Vivobook K3402ZA/K3502ZA

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix page size checks

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix mempool alloc size

Klaus Jensen <k.jensen@samsung.com>
    nvme-pci: fix doorbell buffer value endianness

Sasha Levin <sashal@kernel.org>
    Revert "selftests/bpf: Add test for unstable CT lookup API"

Paulo Alcantara <pc@cjr.nz>
    cifs: fix oops during encryption

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/include/asm/thread_info.h                 |  13 +-
 arch/arm/nwfpe/Makefile                            |   6 +
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   5 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   6 +-
 arch/powerpc/kernel/rtas.c                         |  20 +-
 arch/riscv/include/asm/mmu.h                       |   2 +
 arch/riscv/include/asm/pgtable.h                   |   2 +-
 arch/riscv/include/asm/tlbflush.h                  |  18 ++
 arch/riscv/include/asm/uaccess.h                   |   2 +-
 arch/riscv/kernel/probes/simulate-insn.h           |   4 +-
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/riscv/mm/context.c                            |  10 +
 arch/riscv/mm/tlbflush.c                           |  28 +-
 arch/x86/events/intel/uncore.h                     |   1 +
 arch/x86/events/intel/uncore_snbep.c               |  22 +-
 arch/x86/kernel/cpu/bugs.c                         |   2 +
 arch/x86/kernel/cpu/mce/amd.c                      |  37 +--
 arch/x86/kernel/cpu/mce/core.c                     |  95 +++----
 arch/x86/kernel/cpu/mce/internal.h                 |  12 +-
 arch/x86/kernel/cpu/microcode/intel.c              |   8 +-
 arch/x86/kernel/crash.c                            |   4 +-
 arch/x86/kernel/ftrace.c                           |   2 +
 arch/x86/kernel/kprobes/core.c                     |  10 +-
 arch/x86/kernel/kprobes/opt.c                      |  28 +-
 arch/x86/kvm/vmx/nested.c                          |  47 +++-
 arch/x86/kvm/vmx/sgx.c                             |   4 +-
 block/bfq-iosched.c                                |   2 +-
 block/blk-merge.c                                  |  10 +
 block/mq-deadline.c                                |  84 +++++-
 drivers/acpi/resource.c                            |  78 +++++-
 drivers/acpi/x86/s2idle.c                          |  10 +-
 drivers/ata/ahci.c                                 |  32 ++-
 drivers/base/dd.c                                  |   6 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   4 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  27 +-
 drivers/char/tpm/eventlog/acpi.c                   |  12 +-
 drivers/char/tpm/tpm_crb.c                         |  29 ++-
 drivers/char/tpm/tpm_tis.c                         |   9 +-
 drivers/cpufreq/cpufreq.c                          |   2 +-
 drivers/crypto/ccp/sp-pci.c                        |  11 +-
 drivers/crypto/n2_core.c                           |   6 +
 drivers/devfreq/devfreq.c                          |   6 +-
 drivers/devfreq/governor_userspace.c               |  12 +-
 drivers/firmware/efi/efi.c                         |   4 +-
 drivers/firmware/efi/libstub/efistub.h             |   2 +
 drivers/firmware/efi/libstub/random.c              |  42 ++-
 drivers/gpio/gpio-sifive.c                         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/gpu/drm/drm_connector.c                    |   3 +
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c       |   4 +-
 drivers/gpu/drm/i915/gt/intel_migrate.c            |   8 +-
 drivers/gpu/drm/i915/gvt/debugfs.c                 |  17 +-
 drivers/gpu/drm/i915/gvt/scheduler.c               |   1 +
 drivers/gpu/drm/imx/ipuv3-plane.c                  |  14 +-
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c          |   6 +-
 drivers/gpu/drm/meson/meson_viu.c                  |   5 +-
 drivers/gpu/drm/mgag200/mgag200_pll.c              |   3 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  27 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  16 +-
 drivers/gpu/drm/panfrost/panfrost_gem.h            |   5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   3 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-multitouch.c                       |   4 +
 drivers/hid/hid-plantronics.c                      |   9 +
 drivers/infiniband/hw/mlx5/counters.c              |   6 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  49 +++-
 drivers/iommu/amd/init.c                           |   7 +
 drivers/md/dm-cache-metadata.c                     |  54 +++-
 drivers/md/dm-cache-target.c                       |  11 +-
 drivers/md/dm-clone-target.c                       |   1 +
 drivers/md/dm-integrity.c                          |   2 +
 drivers/md/dm-thin-metadata.c                      |  60 ++++-
 drivers/md/dm-thin.c                               |  18 +-
 drivers/md/md-bitmap.c                             |  20 +-
 drivers/md/md.c                                    |   9 +-
 drivers/media/dvb-core/dmxdev.c                    |   8 +
 drivers/media/dvb-core/dvbdev.c                    |   1 +
 drivers/media/dvb-frontends/stv0288.c              |   5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  14 +-
 drivers/mfd/mt6360-core.c                          |  14 +-
 drivers/mmc/host/sdhci-sprd.c                      |  16 +-
 drivers/mmc/host/vub300.c                          |   2 +
 drivers/mtd/spi-nor/core.c                         |   2 +
 drivers/net/bonding/bond_3ad.c                     |   1 +
 drivers/net/dsa/mv88e6xxx/Kconfig                  |   4 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |  29 +--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  83 ++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |  17 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   3 +
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c           |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 178 +++++--------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   7 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  75 +++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  30 ++-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   4 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |   7 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |  33 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  30 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   6 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h    |  10 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   8 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   2 +-
 drivers/net/phy/xilinx_gmii2rgmii.c                |   1 +
 drivers/net/usb/rndis_host.c                       |   3 +-
 drivers/net/veth.c                                 |   5 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   8 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   1 +
 drivers/nvme/host/core.c                           |  32 ++-
 drivers/nvme/host/nvme.h                           |   2 +-
 drivers/nvme/host/pci.c                            |  37 +--
 drivers/nvme/target/admin-cmd.c                    |  35 +--
 drivers/nvme/target/passthru.c                     |  11 +-
 drivers/of/kexec.c                                 |  10 +-
 drivers/parisc/led.c                               |   3 +
 drivers/pci/pci-sysfs.c                            |  13 +-
 drivers/pci/pci.c                                  |   2 +
 drivers/phy/qualcomm/phy-qcom-qmp.c                |   8 +-
 drivers/remoteproc/remoteproc_core.c               |   9 +-
 drivers/rtc/rtc-ds1347.c                           |   2 +-
 drivers/soc/qcom/Kconfig                           |   1 +
 drivers/soc/ux500/ux500-soc-id.c                   |  10 +-
 drivers/soundwire/dmi-quirks.c                     |   8 +
 drivers/soundwire/intel.c                          |   8 +-
 drivers/soundwire/qcom.c                           |   8 +-
 drivers/soundwire/stream.c                         |   4 +-
 drivers/staging/media/ipu3/ipu3-v4l2.c             |  57 +++--
 drivers/staging/media/tegra-video/csi.c            |   4 +-
 drivers/staging/media/tegra-video/csi.h            |   2 +-
 .../intel/int340x_thermal/processor_thermal_rfim.c |   4 +
 drivers/usb/dwc3/dwc3-qcom.c                       |  13 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   3 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |   4 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |   4 +-
 drivers/vhost/vhost.c                              |   4 +-
 drivers/vhost/vringh.c                             |   5 +-
 drivers/vhost/vsock.c                              |   9 +-
 drivers/video/fbdev/matrox/matroxfb_base.c         |   4 +-
 fs/binfmt_elf_fdpic.c                              |   5 +-
 fs/btrfs/backref.c                                 |   4 +
 fs/btrfs/disk-io.c                                 |  35 ++-
 fs/btrfs/disk-io.h                                 |   6 +-
 fs/btrfs/ioctl.c                                   |   9 +-
 fs/btrfs/rcu-string.h                              |   6 +-
 fs/btrfs/super.c                                   |  76 ++++++
 fs/btrfs/tree-defrag.c                             |   6 +-
 fs/btrfs/volumes.c                                 |  43 ++--
 fs/ceph/caps.c                                     |   2 +-
 fs/ceph/locks.c                                    |   4 -
 fs/ceph/super.h                                    |   1 -
 fs/cifs/cifsfs.c                                   |   8 +-
 fs/cifs/cifsglob.h                                 |  69 +++++
 fs/cifs/cifsproto.h                                |   4 +-
 fs/cifs/connect.c                                  |   4 +-
 fs/cifs/misc.c                                     |   4 +-
 fs/cifs/smb2ops.c                                  | 143 +++++------
 fs/dlm/lowcomms.c                                  |   9 +-
 fs/ext4/balloc.c                                   |   2 +-
 fs/ext4/ext4.h                                     |   9 +-
 fs/ext4/ext4_jbd2.c                                |   3 +-
 fs/ext4/extents.c                                  |   8 +
 fs/ext4/extents_status.c                           |   3 +-
 fs/ext4/fast_commit.c                              | 285 ++++++++++++---------
 fs/ext4/fast_commit.h                              |   7 +-
 fs/ext4/indirect.c                                 |  13 +-
 fs/ext4/inode.c                                    |  50 +++-
 fs/ext4/ioctl.c                                    |  13 +-
 fs/ext4/namei.c                                    |  47 ++--
 fs/ext4/orphan.c                                   |  26 +-
 fs/ext4/resize.c                                   |   6 +-
 fs/ext4/super.c                                    |  52 +++-
 fs/ext4/verity.c                                   |   2 +-
 fs/ext4/xattr.c                                    |  19 +-
 fs/f2fs/gc.c                                       |   1 +
 fs/f2fs/node.c                                     |   3 +-
 fs/hfs/inode.c                                     |  13 +-
 fs/hfsplus/hfsplus_fs.h                            |   2 +
 fs/hfsplus/inode.c                                 |  16 +-
 fs/hfsplus/options.c                               |   4 +
 fs/ksmbd/auth.c                                    |   3 +-
 fs/ksmbd/connection.c                              |   7 +-
 fs/ksmbd/transport_tcp.c                           |   5 +-
 fs/locks.c                                         |  23 ++
 fs/mbcache.c                                       | 121 ++++-----
 fs/nfsd/nfs4xdr.c                                  |  11 +
 fs/nfsd/nfssvc.c                                   |   2 +-
 fs/ntfs3/attrib.c                                  |  18 ++
 fs/ntfs3/attrlist.c                                |   5 +
 fs/ntfs3/bitmap.c                                  |   2 +-
 fs/ntfs3/file.c                                    |   4 +-
 fs/ntfs3/frecord.c                                 |  14 +
 fs/ntfs3/fslog.c                                   |  35 +--
 fs/ntfs3/fsntfs.c                                  |  10 +-
 fs/ntfs3/index.c                                   |   6 +
 fs/ntfs3/inode.c                                   |   9 +
 fs/ntfs3/record.c                                  |  10 +
 fs/ntfs3/super.c                                   |   9 +-
 fs/overlayfs/dir.c                                 |  46 ++--
 fs/pnode.c                                         |   2 +-
 fs/pstore/ram.c                                    |   2 +-
 fs/pstore/zone.c                                   |   2 +-
 fs/quota/dquot.c                                   |   2 +
 fs/udf/inode.c                                     |   2 +-
 include/linux/devfreq.h                            |   7 +-
 include/linux/efi.h                                |   2 -
 include/linux/fs.h                                 |   6 +
 include/linux/mbcache.h                            |  33 ++-
 include/linux/mlx5/device.h                        |   5 +
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/nvme.h                               |   3 +-
 include/linux/sunrpc/rpc_pipe_fs.h                 |   5 +
 include/net/mptcp.h                                |  12 +-
 include/net/netfilter/nf_tables.h                  |  25 +-
 include/sound/soc-dai.h                            |  32 +--
 include/trace/events/ext4.h                        |   7 +-
 include/trace/events/jbd2.h                        |  44 ++--
 io_uring/io_uring.c                                |  13 +-
 kernel/events/core.c                               |   6 +-
 kernel/kcsan/core.c                                |  50 ++++
 kernel/rcu/tasks.h                                 |  20 +-
 kernel/trace/Kconfig                               |   2 +
 kernel/trace/trace.c                               |  38 ++-
 kernel/trace/trace.h                               |  27 +-
 kernel/trace/trace_eprobe.c                        |   3 +
 kernel/trace/trace_events_hist.c                   |  11 +-
 kernel/trace/trace_events_synth.c                  |   2 +-
 kernel/trace/trace_probe.c                         |   2 +-
 mm/compaction.c                                    |  18 +-
 net/caif/cfctrl.c                                  |   6 +-
 net/core/filter.c                                  |   7 +-
 net/ipv4/syncookies.c                              |   7 +-
 net/mptcp/subflow.c                                |  76 ++++--
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
 net/netfilter/ipset/ip_set_hash_netportnet.c       |  40 +--
 net/netfilter/nf_tables_api.c                      | 261 ++++++++++++-------
 net/nfc/netlink.c                                  |  52 +++-
 net/packet/af_packet.c                             |  20 +-
 net/sched/cls_tcindex.c                            |  12 +-
 net/sched/sch_atm.c                                |   5 +-
 net/sched/sch_cbq.c                                |   4 +-
 net/sunrpc/auth_gss/auth_gss.c                     |  19 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   9 +-
 security/device_cgroup.c                           |  33 ++-
 security/integrity/ima/ima_template.c              |   5 +-
 security/integrity/platform_certs/load_uefi.c      |   1 +
 sound/pci/hda/patch_realtek.c                      |  50 ++++
 sound/soc/codecs/hdac_hda.c                        |  22 +-
 sound/soc/codecs/max98373-sdw.c                    |   2 +-
 sound/soc/codecs/rt1308-sdw.c                      |   2 +-
 sound/soc/codecs/rt1316-sdw.c                      |   2 +-
 sound/soc/codecs/rt5682-sdw.c                      |   2 +-
 sound/soc/codecs/rt700.c                           |   2 +-
 sound/soc/codecs/rt711-sdca.c                      |   2 +-
 sound/soc/codecs/rt711.c                           |   2 +-
 sound/soc/codecs/rt715-sdca.c                      |   2 +-
 sound/soc/codecs/rt715.c                           |   2 +-
 sound/soc/codecs/sdw-mockup.c                      |   2 +-
 sound/soc/codecs/wcd938x.c                         |   2 +-
 sound/soc/codecs/wsa881x.c                         |   2 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  15 ++
 sound/soc/intel/boards/sof_sdw.c                   |   6 +-
 sound/soc/intel/skylake/skl-pcm.c                  |   7 +-
 sound/soc/jz4740/jz4740-i2s.c                      |  39 ++-
 sound/soc/qcom/sdm845.c                            |   4 +-
 sound/soc/qcom/sm8250.c                            |   4 +-
 sound/soc/sof/intel/hda-dai.c                      |   7 +-
 sound/usb/line6/driver.c                           |   3 +-
 sound/usb/line6/midi.c                             |   6 +-
 sound/usb/line6/midibuf.c                          |  25 +-
 sound/usb/line6/midibuf.h                          |   5 +-
 sound/usb/line6/pod.c                              |   3 +-
 tools/objtool/check.c                              |   2 +-
 tools/perf/util/cgroup.c                           |  23 +-
 tools/perf/util/data.c                             |   2 +
 tools/perf/util/dwarf-aux.c                        |  23 +-
 tools/testing/ktest/ktest.pl                       |  23 +-
 tools/testing/selftests/Makefile                   |  26 +-
 tools/testing/selftests/bpf/config                 |   4 -
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |  48 ----
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    | 109 --------
 tools/testing/selftests/lib.mk                     |   5 +
 305 files changed, 3239 insertions(+), 1867 deletions(-)


