Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EADC6648F9
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239095AbjAJSQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbjAJSQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:16:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAF143A21;
        Tue, 10 Jan 2023 10:14:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D36DC6184D;
        Tue, 10 Jan 2023 18:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5930EC433D2;
        Tue, 10 Jan 2023 18:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374466;
        bh=Dt4G2aNpiyNXRetdFFfGvs4y2s4i9UQQVVaB+GAll98=;
        h=From:To:Cc:Subject:Date:From;
        b=G9u7KSVZtPZtg2NGqzlPc1Tk4+G2ntQBkvJL3WQzWaIOy9PXQZVcK5MsmY2ce9bR+
         a5bSOT4HvYIYxMq3uB1JXajKJOYXTtLAYjqdJ7gOauw5FpZ0JbQyD8hFqKCDXMyP2h
         JjoTFhKrYK9M+mEobtxvm2cpmpYENYE25MQ3XDVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/159] 6.1.5-rc1 review
Date:   Tue, 10 Jan 2023 19:02:28 +0100
Message-Id: <20230110180018.288460217@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.5-rc1
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

This is the start of the stable review cycle for the 6.1.5 release.
There are 159 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.5-rc1

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: Send PME message during wakeup from D3cold

Ard Biesheuvel <ardb@kernel.org>
    efi: random: combine bootloader provided RNG seed with RNG protocol output

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence

William Liu <will@willsroot.io>
    ksmbd: check nt_len to be at least CIFS_ENCPWD_SIZE in ksmbd_decode_ntlmssp_auth_blob

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: send proper error response in smb2_tree_connect()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix infinite loop in ksmbd_conn_handler_loop()

Qu Wenruo <wqu@suse.com>
    btrfs: handle case when repair happens with dev-replace

Samson Tam <samson.tam@amd.com>
    drm/amd/display: Uninitialized variables causing 4k60 UCLK to stay at DPM1 and not DPM0

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Add check for DET fetch latency hiding for dcn32

Rafael Mendonca <rafaelmendsr@gmail.com>
    virtio_blk: Fix signedness bug in virtblk_prep_rq()

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    virtio-blk: use a helper to handle request queuing errors

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: fix vgpu debugfs clean in remove

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: fix gvt debugfs destroy

Mukul Joshi <mukul.joshi@amd.com>
    drm/amdkfd: Fix kernel warning during topology setup

Ma Jun <majun@amd.com>
    drm/plane-helper: Add the missing declaration of drm_atomic_state

Andreas Rammhold <andreas@rammhold.de>
    of/fdt: run soc memory setup when early_init_dt_scan_memory fails

Björn Töpel <bjorn@rivosinc.com>
    riscv, kprobes: Stricter c.jr/c.jalr decoding

Ben Dooks <ben-linux@fluff.org>
    riscv: uaccess: fix type of 0 variable on error in get_user()

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: int340x: Add missing attribute for data rate base

Cindy Lu <lulu@redhat.com>
    vhost_vdpa: fix the crash in unmap a large memory

Jason A. Donenfeld <Jason@zx2c4.com>
    tpm: Allow system suspend to continue when TPM suspend fails

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix CQ waiting timeout handling

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: pin context while queueing deferred tw

Jens Axboe <axboe@kernel.dk>
    block: don't allow splitting of a REQ_NOWAIT bio

Christian Marangi <ansuelsmth@gmail.com>
    net: dsa: tag_qca: fix wrong MGMT_DATA2 size

Christian Marangi <ansuelsmth@gmail.com>
    net: dsa: qca8k: fix wrong length value for mgmt eth packet

Christian Marangi <ansuelsmth@gmail.com>
    Revert "net: dsa: qca8k: cache lo and hi for mdio write"

Michel Dänzer <mdaenzer@redhat.com>
    Revert "drm/amd/display: Enable Freesync Video Mode by default"

Chuang Wang <nashuiliang@gmail.com>
    bpf: Fix panic due to wrong pageattr of im->image

Paul Menzel <pmenzel@molgen.mpg.de>
    fbdev: matroxfb: G200eW: Increase max memory from 1 MB to 16 MB

Jeff Layton <jlayton@kernel.org>
    nfsd: fix handling of readdir in v4root vs. mount upcall timeout

Rodrigo Branco <bsdaemon@google.com>
    x86/bugs: Flush IBP in ib_prctl_set()

Takashi Iwai <tiwai@suse.de>
    x86/kexec: Fix double-free of elf header buffer

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: pci-tgl: unblock S5 entry if DMA stop has failed"

Christoph Hellwig <hch@lst.de>
    nvme: also return I/O command effects from nvme_command_effects

Christoph Hellwig <hch@lst.de>
    nvmet: use NVME_CMD_EFFECTS_CSUPP instead of open coding it

YoungJun.park <her0gyugyu@gmail.com>
    kunit: alloc_string_stream_fragment error handling bug fix

Jens Axboe <axboe@kernel.dk>
    io_uring: check for valid register opcode earlier

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: video: Don't enable fallback path for creating ACPI backlight by default

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Report to ACPI video if no panels were found

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: video: Allow GPU drivers to report no panels

Yanjun Zhang <zhangyanjun@cestc.cn>
    nvme: fix multipath crash caused by flush request when blktrace is enabled

Jens Axboe <axboe@kernel.dk>
    io_uring/cancel: re-grab ctx mutex after finishing wait

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix double release compute pasid

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix kfd_process_device_init_vm error handling

Luben Tuikov <luben.tuikov@amd.com>
    drm/amdgpu: Fix size validation for non-exclusive domains (v4)

YC Hung <yc.hung@mediatek.com>
    ASoC: SOF: mediatek: initialize panic_info to zero

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Advantech MICA-071 tablet

Dominique Martinet <asmadeus@codewreck.org>
    9p/client: fix data race on req->status

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Revert: "core: unregister clients and machine drivers in .shutdown"

Linus Torvalds <torvalds@linux-foundation.org>
    hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling

Arnd Bergmann <arnd@arndb.de>
    usb: dwc3: xilinx: include linux/gpio/consumer.h

Jan Kara <jack@suse.cz>
    udf: Fix extension of the last extent in the file

Zhengchao Shao <shaozhengchao@huawei.com>
    caif: fix memory leak in cfctrl_linkup_request()

Paolo Abeni <pabeni@redhat.com>
    net/ulp: prevent ULP without clone op from entering the LISTEN status

Caleb Sander <csander@purestorage.com>
    qed: allow sleep in qed_mcp_trace_dump()

Ming Lei <ming.lei@redhat.com>
    ublk: honor IO_URING_F_NONBLOCK for handling control command

Zheng Wang <zyytlz.wz@163.com>
    drm/i915/gvt: fix double free bug in split_2MB_gtt_entry

Dan Carpenter <error27@gmail.com>
    drm/i915: unpin on error in intel_vgpu_shadow_mm_pin()

Namhyung Kim <namhyung@kernel.org>
    perf stat: Fix handling of --for-each-cgroup with --bpf-counters to match non BPF mode

Namhyung Kim <namhyung@kernel.org>
    perf stat: Fix handling of unsupported cgroup events when using BPF counters

Thomas Richter <tmricht@linux.ibm.com>
    perf lock contention: Fix core dump related to not finding the "__sched_text_end" symbol on s/390

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

Xiu Jianfeng <xiujianfeng@huawei.com>
    drm/virtio: Fix memory leak in virtio_gpu_object_create()

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Rework long task execution when adding/deleting entries

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: fix hash:net,port,net hang with /0 subnet

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: sparx5: Fix reading of the MAC address

Ido Schimmel <idosch@nvidia.com>
    vxlan: Fix memory leaks in error path

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

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: return non-zero for failures reported in arp_ndisc_evict_nocarrier

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: fix cleanup_v6() for arp_ndisc_evict_nocarrier

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Fix validation of max_rd_atomic caps for DC

Shay Drory <shayd@nvidia.com>
    RDMA/mlx5: Fix mlx5_ib_get_hw_stats when used for device

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: avoid to use uninitialized value pinctrl

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

Jian Shen <shenjian15@huawei.com>
    net: hns3: refine the handling for VF heartbeat

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Add TIME_WAIT sockets in bhash2.

Kees Cook <keescook@chromium.org>
    bpf: Always use maximal size for copy_array()

Eli Cohen <elic@nvidia.com>
    net/mlx5: Lag, fix failure to cancel delayed bond work

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Set geneve_tlv_option_0_exist when matching on geneve option

Adham Faris <afaris@nvidia.com>
    net/mlx5e: Fix hw mtu initializing at XDP SQ allocation

Chris Mi <cmi@nvidia.com>
    net/mlx5e: Always clear dest encap in neigh-update-del

Chris Mi <cmi@nvidia.com>
    net/mlx5e: CT: Fix ct debugfs folder name

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: Fix RX reporter for XSK RQs

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix RoCE setting at HCA level

Shay Drory <shayd@nvidia.com>
    net/mlx5: Avoid recovery in probe flows

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix io_eq_size and event_eq_size params validation

Jiri Pirko <jiri@nvidia.com>
    net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: E-Switch, properly handle ingress tagged packets on VST

Jason Wang <jasowang@redhat.com>
    vdpasim: fix memory leak when freeing IOTLBs

Rong Wang <wangrong68@huawei.com>
    vdpa/vp_vdpa: fix kfree a wrong pointer in vp_vdpa_remove

Wei Yongjun <weiyongjun1@huawei.com>
    virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim: fix vringh initialization in vdpasim_queue_ready()

Stefano Garzarella <sgarzare@redhat.com>
    vhost-vdpa: fix an iotlb memory leak

Stefano Garzarella <sgarzare@redhat.com>
    vhost: fix range used in translate_desc()

Stefano Garzarella <sgarzare@redhat.com>
    vringh: fix range used in iotlb_translate()

Yuan Can <yuancan@huawei.com>
    vhost/vsock: Fix error handling in vhost_vsock_init()

ruanjinjie <ruanjinjie@huawei.com>
    vdpa_sim: fix possible memory leak in vdpasim_net_init() and vdpasim_blk_init()

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix wrong mac address deletion

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Fix rule forwarding VLAN to TIR

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix HDS and jumbo thresholds for RX packets

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix first buffer size calculations for XDP multi-buffer

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix XDP RX path

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Simplify bnxt_xdp_buff_init()

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

Jie Wang <wangjie125@huawei.com>
    net: hns3: add interrupts re-initialization while doing VF FLR

Jeff Layton <jlayton@kernel.org>
    nfsd: shut down the NFSv4 state objects before the filecache

Shawn Bohrer <sbohrer@cloudflare.com>
    veth: Fix race with AF_XDP exposing old or uninitialized descriptors

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix configuration of the PCS

Eric Dumazet <edumazet@google.com>
    bonding: fix lockdep splat in bond_miimon_commit()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: honor set timeout and garbage collection updates

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix lockdep false positive

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix deadlock in fastopen error path

Ronak Doshi <doshir@vmware.com>
    vmxnet3: correctly report csum_level for encapsulated packet

Antoine Tenart <atenart@kernel.org>
    net: vrf: determine the dst using the original ifindex for multicast

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: do not use xdp_return_frame() on tx_buf->raw_buf

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

Arnd Bergmann <arnd@arndb.de>
    wifi: ath9k: use proper statements in conditionals

minoura makoto <minoura@valinux.co.jp>
    SUNRPC: ensure the matching upcall is in-flight upon downcall

Sasha Levin <sashal@kernel.org>
    btrfs: fix an error handling path in btrfs_defrag_leaves()

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: fix broken power on

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    perf probe: Use dwarf_attr_integrate as generic DWARF attr accessor

Qu Wenruo <wqu@suse.com>
    btrfs: fix compat_ro checks against remount

Filipe Manana <fdmanana@suse.com>
    btrfs: fix off-by-one in delalloc search during lseek

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Ignore End Transfer delay on teardown

Shyam Prasad N <sprasad@microsoft.com>
    cifs: refcount only the selected iface during interface update

Shyam Prasad N <sprasad@microsoft.com>
    cifs: fix interface count calculation during refresh

Sasha Levin <sashal@kernel.org>
    btrfs: replace strncpy() with strscpy()

Jens Axboe <axboe@kernel.dk>
    ARM: renumber bits related to _TIF_WORK_MASK


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/include/asm/thread_info.h                 |  13 +-
 arch/mips/ralink/of.c                              |   2 +-
 arch/riscv/include/asm/uaccess.h                   |   2 +-
 arch/riscv/kernel/probes/simulate-insn.h           |   4 +-
 arch/x86/kernel/cpu/bugs.c                         |   2 +
 arch/x86/kernel/crash.c                            |   4 +-
 block/blk-merge.c                                  |  10 +
 drivers/acpi/acpi_video.c                          |  17 +-
 drivers/block/ublk_drv.c                           |   3 +
 drivers/block/virtio_blk.c                         |  33 +--
 drivers/char/tpm/tpm-interface.c                   |   4 +-
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |   3 +-
 drivers/firmware/efi/efi.c                         |   4 +-
 drivers/firmware/efi/libstub/efistub.h             |   2 +
 drivers/firmware/efi/libstub/random.c              |  42 +++-
 drivers/gpio/gpio-pca953x.c                        |   3 +
 drivers/gpio/gpio-sifive.c                         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  39 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  27 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  19 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  24 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  16 +-
 .../amd/display/dc/dml/dcn32/display_mode_vba_32.c |  39 +++
 .../dc/dml/dcn32/display_mode_vba_util_32.c        |  69 ++++++
 .../dc/dml/dcn32/display_mode_vba_util_32.h        |  18 ++
 .../gpu/drm/amd/display/dc/dml/display_mode_vba.h  |   2 +
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c       |  94 +++++++-
 drivers/gpu/drm/i915/gvt/debugfs.c                 |  17 +-
 drivers/gpu/drm/i915/gvt/gtt.c                     |  17 +-
 drivers/gpu/drm/i915/gvt/scheduler.c               |   1 +
 drivers/gpu/drm/i915/i915_irq.c                    |   3 +
 drivers/gpu/drm/i915/i915_reg.h                    |   1 +
 drivers/gpu/drm/imx/ipuv3-plane.c                  |  14 +-
 drivers/gpu/drm/meson/meson_viu.c                  |   5 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  27 ++-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  16 +-
 drivers/gpu/drm/panfrost/panfrost_gem.h            |   5 +-
 drivers/gpu/drm/virtio/virtgpu_object.c            |   6 +-
 drivers/infiniband/hw/mlx5/counters.c              |   6 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  49 ++--
 drivers/net/bonding/bond_3ad.c                     |   1 +
 drivers/net/bonding/bond_main.c                    |   8 +-
 drivers/net/dsa/mv88e6xxx/Kconfig                  |   4 +-
 drivers/net/dsa/qca/qca8k-8xxx.c                   | 106 ++++-----
 drivers/net/dsa/qca/qca8k.h                        |   5 -
 drivers/net/ethernet/amazon/ena/ena_com.c          |  29 +--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  83 +++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |  17 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   3 +
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c           |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  22 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  15 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  10 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 132 +++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   7 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  71 +++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  30 ++-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   7 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   9 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |   7 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |  33 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  30 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   6 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 .../net/ethernet/microchip/lan966x/lan966x_port.c  |   2 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |  28 ++-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h    |  10 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   8 +-
 drivers/net/phy/xilinx_gmii2rgmii.c                |   1 +
 drivers/net/usb/rndis_host.c                       |   3 +-
 drivers/net/veth.c                                 |   5 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   8 +
 drivers/net/vrf.c                                  |   6 +-
 drivers/net/vxlan/vxlan_core.c                     |  19 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   3 +
 drivers/net/wireless/ath/ath9k/htc.h               |  14 +-
 drivers/nvme/host/core.c                           |  32 ++-
 drivers/nvme/host/nvme.h                           |   2 +-
 drivers/nvme/target/admin-cmd.c                    |  35 +--
 drivers/of/fdt.c                                   |   6 +-
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          |  20 +-
 .../intel/int340x_thermal/processor_thermal_rfim.c |   4 +
 drivers/usb/dwc3/dwc3-xilinx.c                     |   1 +
 drivers/usb/dwc3/gadget.c                          |   5 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  10 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   7 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |   4 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |   4 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |   2 +-
 drivers/vhost/vdpa.c                               |  52 ++--
 drivers/vhost/vhost.c                              |   4 +-
 drivers/vhost/vringh.c                             |   5 +-
 drivers/vhost/vsock.c                              |   9 +-
 drivers/video/fbdev/matrox/matroxfb_base.c         |   4 +-
 fs/btrfs/disk-io.c                                 |   8 +-
 fs/btrfs/disk-io.h                                 |   2 +-
 fs/btrfs/extent-io-tree.c                          |   2 +-
 fs/btrfs/extent_io.c                               |  11 +-
 fs/btrfs/file.c                                    |   2 +-
 fs/btrfs/ioctl.c                                   |   9 +-
 fs/btrfs/rcu-string.h                              |   6 +-
 fs/btrfs/super.c                                   |   2 +-
 fs/btrfs/tree-defrag.c                             |   6 +-
 fs/ceph/caps.c                                     |   2 +-
 fs/ceph/locks.c                                    |   4 -
 fs/ceph/super.h                                    |   1 -
 fs/cifs/sess.c                                     |   3 +-
 fs/cifs/smb2ops.c                                  |   3 +-
 fs/hfs/inode.c                                     |  15 +-
 fs/ksmbd/auth.c                                    |   3 +-
 fs/ksmbd/connection.c                              |   7 +-
 fs/ksmbd/smb2pdu.c                                 |   7 +-
 fs/ksmbd/transport_tcp.c                           |   5 +-
 fs/locks.c                                         |  23 ++
 fs/nfsd/nfs4xdr.c                                  |  11 +
 fs/nfsd/nfssvc.c                                   |   2 +-
 fs/ntfs3/file.c                                    |   4 +-
 fs/udf/inode.c                                     |   2 +-
 include/acpi/video.h                               |   2 +
 include/drm/drm_plane_helper.h                     |   1 +
 include/linux/dsa/tag_qca.h                        |   4 +-
 include/linux/efi.h                                |   2 -
 include/linux/fs.h                                 |   6 +
 include/linux/mlx5/device.h                        |   5 +
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/sunrpc/rpc_pipe_fs.h                 |   5 +
 include/net/inet_hashtables.h                      |   4 +
 include/net/inet_timewait_sock.h                   |   5 +
 include/net/netfilter/nf_tables.h                  |  25 +-
 io_uring/cancel.c                                  |   9 +-
 io_uring/io_uring.c                                |  19 +-
 kernel/bpf/trampoline.c                            |   4 +
 kernel/bpf/verifier.c                              |  12 +-
 lib/kunit/string-stream.c                          |   4 +-
 net/9p/client.c                                    |  15 +-
 net/9p/trans_fd.c                                  |  12 +-
 net/9p/trans_rdma.c                                |   4 +-
 net/9p/trans_virtio.c                              |   9 +-
 net/9p/trans_xen.c                                 |   4 +-
 net/caif/cfctrl.c                                  |   6 +-
 net/core/filter.c                                  |   7 +-
 net/ipv4/inet_connection_sock.c                    |  40 +++-
 net/ipv4/inet_hashtables.c                         |   8 +-
 net/ipv4/inet_timewait_sock.c                      |  31 ++-
 net/ipv4/tcp_ulp.c                                 |   4 +
 net/mptcp/protocol.c                               |  20 +-
 net/mptcp/protocol.h                               |   4 +-
 net/mptcp/subflow.c                                |  19 +-
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
 net/netfilter/ipset/ip_set_hash_netportnet.c       |  40 ++--
 net/netfilter/nf_tables_api.c                      | 261 ++++++++++++++-------
 net/nfc/netlink.c                                  |  52 ++--
 net/sched/cls_tcindex.c                            |  12 +-
 net/sched/sch_atm.c                                |   5 +-
 net/sched/sch_cbq.c                                |   4 +-
 net/sunrpc/auth_gss/auth_gss.c                     |  19 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  15 ++
 sound/soc/sof/core.c                               |   9 -
 sound/soc/sof/intel/hda-dsp.c                      |  72 ++++++
 sound/soc/sof/intel/hda.h                          |   1 +
 sound/soc/sof/intel/tgl.c                          |   2 +-
 sound/soc/sof/mediatek/mtk-adsp-common.c           |   2 +-
 tools/perf/builtin-lock.c                          |   2 +
 tools/perf/util/bpf_counter_cgroup.c               |  14 +-
 tools/perf/util/cgroup.c                           |  23 +-
 tools/perf/util/data.c                             |   2 +
 tools/perf/util/dwarf-aux.c                        |  23 +-
 .../selftests/net/arp_ndisc_evict_nocarrier.sh     |  15 +-
 197 files changed, 1988 insertions(+), 876 deletions(-)


