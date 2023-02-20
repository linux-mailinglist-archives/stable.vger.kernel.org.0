Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A7C69CE54
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbjBTN6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjBTN6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76541E9E1;
        Mon, 20 Feb 2023 05:58:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12152B80D53;
        Mon, 20 Feb 2023 13:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381E8C433EF;
        Mon, 20 Feb 2023 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901491;
        bh=I6+cHP70ZlmW6g6kRgAbSfRqzDTHh3oebRt/9VoAEKg=;
        h=From:To:Cc:Subject:Date:From;
        b=02ot3n9GF9gEOi6vU/kQdW9OmGdlMNxoBQMRAJ5D+MOOpnpMp2/tHDjrRSLJUHmsZ
         8E+9uKIdoSYzqLRWUASK/FXlXNOK4m4TBeK/kUCxhxHeH2yPi2SUouFYcFj5ADEYc2
         7jf2cIY4qXUmC5NV08912BJZ+//KCQeuJNNLFzhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/118] 6.1.13-rc1 review
Date:   Mon, 20 Feb 2023 14:35:16 +0100
Message-Id: <20230220133600.368809650@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.13-rc1
X-KernelTest-Deadline: 2023-02-22T13:36+00:00
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

This is the start of the stable review cycle for the 6.1.13 release.
There are 118 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.13-rc1

Dan Carpenter <error27@gmail.com>
    net: sched: sch: Fix off by one in htb_activate_prios()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: fix possible stream_tag leak

Keith Busch <kbusch@kernel.org>
    nvme-pci: refresh visible attrs for cmb attributes

Thomas Gleixner <tglx@linutronix.de>
    alarmtimer: Prevent starvation by small intervals and SIG_IGN

Sean Christopherson <seanjc@google.com>
    perf/x86: Refuse to export capabilities for hybrid PMUs

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kvm: initialize all of the kvm_debugregs structure before sending it to userspace

Sean Christopherson <seanjc@google.com>
    KVM: x86/pmu: Disable vPMU support on hybrid CPUs (host PMUs)

Christoph Hellwig <hch@lst.de>
    nvme-apple: fix controller shutdown in apple_nvme_disable

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: stop auth work after tearing down queues in error recovery

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: stop auth work after tearing down queues in error recovery

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: tcindex: search key must be 16 bits

Natalia Petrova <n.petrova@fintech.ru>
    i40e: Add checking for null for nlmsg_find_attr()

Arnd Bergmann <arnd@arndb.de>
    mm: extend max struct page size for kmsan

Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
    mm/gup: add folio to list when folio_isolate_lru() succeed

Guillaume Nault <gnault@redhat.com>
    ipv6: Fix tcp socket connection with DSCP.

Guillaume Nault <gnault@redhat.com>
    ipv6: Fix datagram socket connection with DSCP.

Jason Xing <kernelxing@tencent.com>
    ixgbe: add double of VLAN header when computing the max MTU

Miroslav Lichvar <mlichvar@redhat.com>
    igb: Fix PPS input and output using 3rd and 4th SDP

Corinna Vinschen <vinschen@redhat.com>
    igb: conditionalize I2C bit banging on external thermal sensor support

Jakub Kicinski <kuba@kernel.org>
    net: mpls: fix stale pointer if allocation fails during device rename

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix kernel warning when sending SYN message

Eric Dumazet <edumazet@google.com>
    net: use a bounce buffer for copying skb->mark

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    net: stmmac: Restrict warning on disabling DMA store and fwd mode

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Make trace_define_field_ext() static

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix mqprio and XDP ring checking logic

Johannes Zink <j.zink@pengutronix.de>
    net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence

Hangyu Hua <hbh25y@gmail.com>
    net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_ctinfo: use percpu stats

Miko Larsson <mikoxyzzz@gmail.com>
    net/usb: kalmia: Don't pass act_len in usb_bulk_msg error path

Kuniyuki Iwashima <kuniyu@amazon.com>
    dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: xsk: Fix cleaning of XDP_TX frames

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: tcindex: update imperfect hash filters respecting rcu

Pietro Borrello <borrello@diag.uniroma1.it>
    sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw: Add RX DMA Channel Teardown Quirk

Rafał Miłecki <rafal@milecki.pl>
    net: bgmac: fix BCM5358 support by setting correct flags

Jason Xing <kernelxing@tencent.com>
    i40e: add double of VLAN header when computing the max MTU

Jason Xing <kernelxing@tencent.com>
    ixgbe: allow to increase MTU to 3K with XDP enabled

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: fix lost multicast packets in promisc mode

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT list

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: Fix YUV plane handling when planes are in different buffers

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: crtc: Increase setup cost in core clock calculation to handle extreme reduced blanking

Andrew Morton <akpm@linux-foundation.org>
    revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"

Felix Riemann <felix.riemann@sma.de>
    net: Fix unwanted sign extension in netdev_stats_to_stats64()

Aaron Thompson <dev@aaront.org>
    Revert "mm: Always release pages to the buddy allocator in memblock_free_late()."

Geert Uytterhoeven <geert@linux-m68k.org>
    coredump: Move dump_emit_page() to kill unused warning

Peter Zijlstra <peterz@infradead.org>
    freezer,umh: Fix call_usermode_helper_exec() vs SIGKILL

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: sim: fix a memory leak

Peter Xu <peterx@redhat.com>
    mm/migrate: fix wrongly apply write bit after mkdirty on sparc64

Qian Yingjin <qian@ddn.com>
    mm/filemap: fix page end in filemap_get_read_batch

Zach O'Keefe <zokeefe@google.com>
    mm/MADV_COLLAPSE: set EAGAIN on unexpected page refcount

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix underflow in second superblock position calculations

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: check for undefined shift on 32 bit architectures

Munehisa Kamata <kamatam@amazon.com>
    sched/psi: Fix use-after-free in ep_remove_wait_queue()

Patrick McLean <chutzpah@gentoo.org>
    ata: libata-core: Disable READ LOG DMA EXT for Samsung MZ7LH

Simon Gaiser <simon@invisiblethingslab.com>
    ata: ahci: Add Tiger Lake UP{3,4} AHCI controller

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: Enable mute/micmute LEDs and speaker support for HP Laptops

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for a HP platform.

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - fixed wrong gpio assigned

Bo Liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: add a new hda codec SN6180

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Fix codec device field initializan

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mmc_spi: fix error handling in mmc_spi_probe()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: sdio: fix possible resource leaks in some error paths

Heiner Kallweit <hkallweit1@gmail.com>
    mmc: meson-gx: fix SDIO mode if cap_sdio_irq isn't set

Paul Cercueil <paul@crapouillou.net>
    mmc: jz4740: Work around bug on JZ4760(B)

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Do not drop the reference to the handle too soon

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Stop accessing buffer objects which failed init

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fail atomic_check early on normalize_zpos error

Jack Xiao <Jack.Xiao@amd.com>
    drm/amd/amdgpu: fix warning during suspend

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm: Disable dynamic debug as broken

Takashi Iwai <tiwai@suse.de>
    fbdev: Fix invalid page access after closing deferred I/O devices

Ronak Doshi <doshir@vmware.com>
    vmxnet3: move rss code block under eop descriptor

Seth Jenkins <sethjenkins@google.com>
    aio: fix mremap after fork null-deref

Qi Zheng <zhengqi.arch@bytedance.com>
    mm: shrinkers: fix deadlock in shrinker debugfs

Christophe Leroy <christophe.leroy@csgroup.eu>
    kasan: fix Oops due to missing calls to kasan_arch_is_ready()

Isaac J. Manjarres <isaacmanjarres@google.com>
    of: reserved_mem: Have kmemleak ignore dynamically allocated reserved mem

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: userspace: fix v4-v6 test in v6.1

Xiubo Li <xiubli@redhat.com>
    ceph: blocklist the kclient when receiving corrupted snap trace

Xiubo Li <xiubli@redhat.com>
    ceph: move mount state enum to super.h

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add Chuwi Vi8 (CWI501) DMI match

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: Properly handle additional cases where DCN is not supported

Yiqing Yao <yiqing.yao@amd.com>
    drm/amdgpu: Enable vclk dclk node for gc11.0.3

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: enable HDP SD for gfx 11.0.3

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Reset DMUB mailbox SW state after HW reset

George Shen <george.shen@amd.com>
    drm/amd/display: Unassign does_plane_fit_in_mall function from dcn3.2

Daniel Miess <Daniel.Miess@amd.com>
    drm/amd/display: Adjust downscaling limits for dcn314

Daniel Miess <Daniel.Miess@amd.com>
    drm/amd/display: Add missing brackets in calculation

Maurizio Lombardi <mlombard@redhat.com>
    nvme: clear the request_queue pointers on failure in nvme_alloc_io_tag_set

Maurizio Lombardi <mlombard@redhat.com>
    nvme: clear the request_queue pointers on failure in nvme_alloc_admin_tag_set

Amit Engel <Amit.Engel@dell.com>
    nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association

Vasily Gorbik <gor@linux.ibm.com>
    s390/decompressor: specify __decompress() buf len to avoid overflow

Kees Cook <keescook@chromium.org>
    net: sched: sch: Bounds check priority

Kees Cook <keescook@chromium.org>
    net: ethernet: mtk_eth_soc: Avoid truncating allocation

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/devinit/tu102-: wait for GFW_BOOT_PROGRESS == COMPLETED

Hou Tao <houtao1@huawei.com>
    fscache: Use clear_and_wake_up_bit() in fscache_create_volume_work()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: Fix perf profiling asynchronous interrupt handlers

Andrey Konovalov <andrey.konovalov@linaro.org>
    net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC

Andrei Gherzan <andrei.gherzan@canonical.com>
    selftest: net: Improve IPV6_TCLASS/IPV6_HOPLIMIT tests apparmor compatibility

Hyunwoo Kim <v4bel@theori.io>
    net/rose: Fix to not accept on connected socket

Tanmay Bhushan <007047221b@gmail.com>
    vdpa: ifcvf: Do proper cleanup if IFCVF init fails

Shunsuke Mie <mie@igel.co.jp>
    tools/virtio: fix the vringh test for virtio ring changes

Arnd Bergmann <arnd@arndb.de>
    ASoC: cs42l56: fix DT probe

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockmap: Don't let sock_map_{close,destroy,unhash} call itself

fengwk <fengwk94@gmail.com>
    ASoC: amd: yc: Add Xiaomi Redmi Book Pro 15 2022 into DMI table

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Do not unset preset when cleaning up codec

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Verify copy_register_state() preserves parent/live fields

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_ssp_amp: always set dpcm_capture for amplifiers

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_nau8825: always set dpcm_capture for amplifiers

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_cs42l42: always set dpcm_capture for amplifiers

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_rt5682: always set dpcm_capture for amplifiers

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum610 Wireless

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: sof-audio: start with the right widget type

Syed Saba Kareem <Syed.SabaKareem@amd.com>
    ASoC: amd: yc: Add DMI support for new acer/emdoor platforms

Filipe Manana <fdmanana@suse.com>
    btrfs: lock the inode in shared mode before starting fiemap

Josef Bacik <josef@toxicpanda.com>
    btrfs: move the auto defrag code to defrag.c

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix locking for in-kernel listener creation

Paolo Abeni <pabeni@redhat.com>
    mptcp: deduplicate error paths on endpoint creation

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix locking for setsockopt corner-case

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: sockopt: make 'tcp_fastopen_connect' generic


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/powerpc/include/asm/hw_irq.h                  |  41 ++-
 arch/powerpc/kernel/dbell.c                        |   2 +-
 arch/powerpc/kernel/irq.c                          |   2 +-
 arch/powerpc/kernel/time.c                         |   2 +-
 arch/s390/boot/decompressor.c                      |   2 +-
 arch/x86/events/core.c                             |  12 +-
 arch/x86/kvm/pmu.h                                 |  26 +-
 arch/x86/kvm/x86.c                                 |   3 +-
 drivers/ata/ahci.c                                 |   1 +
 drivers/ata/libata-core.c                          |   3 +
 drivers/gpio/gpio-sim.c                            |   2 +-
 drivers/gpu/drm/Kconfig                            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   3 +
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  17 +-
 .../drm/amd/display/dc/dcn314/dcn314_resource.c    |   5 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c  |   2 +-
 .../display/dc/dml/dcn314/display_mode_vba_314.c   |   2 +-
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c    |  12 +
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   6 +-
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |  14 +-
 .../gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c    |  23 ++
 drivers/gpu/drm/vc4/vc4_crtc.c                     |   2 +-
 drivers/gpu/drm/vc4/vc4_plane.c                    |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |  12 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c                |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  10 +-
 drivers/mmc/core/sdio_bus.c                        |  17 +-
 drivers/mmc/core/sdio_cis.c                        |  12 -
 drivers/mmc/host/jz4740_mmc.c                      |  10 +
 drivers/mmc/host/meson-gx-mmc.c                    |  23 +-
 drivers/mmc/host/mmc_spi.c                         |   8 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  26 ++
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  15 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  54 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  28 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   3 +-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |   1 -
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  12 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |   1 +
 drivers/net/usb/kalmia.c                           |   8 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  50 +--
 drivers/nvme/host/apple.c                          |   3 +-
 drivers/nvme/host/core.c                           |   5 +-
 drivers/nvme/host/pci.c                            |   8 +
 drivers/nvme/host/rdma.c                           |   2 +-
 drivers/nvme/host/tcp.c                            |   2 +-
 drivers/nvme/target/fc.c                           |   4 +-
 drivers/of/of_reserved_mem.c                       |   3 +-
 drivers/platform/x86/touchscreen_dmi.c             |   9 +
 drivers/vdpa/ifcvf/ifcvf_main.c                    |   2 +-
 drivers/video/fbdev/core/fb_defio.c                |  10 +-
 drivers/video/fbdev/core/fbmem.c                   |   4 +
 fs/aio.c                                           |   4 +
 fs/btrfs/extent_io.c                               |   2 +
 fs/btrfs/file.c                                    | 340 ---------------------
 fs/btrfs/tree-defrag.c                             | 337 ++++++++++++++++++++
 fs/ceph/addr.c                                     |  17 +-
 fs/ceph/caps.c                                     |  16 +-
 fs/ceph/file.c                                     |   3 +
 fs/ceph/mds_client.c                               |  30 +-
 fs/ceph/snap.c                                     |  36 ++-
 fs/ceph/super.h                                    |  11 +
 fs/coredump.c                                      |  48 +--
 fs/fscache/volume.c                                |   3 +-
 fs/nilfs2/ioctl.c                                  |   7 +
 fs/nilfs2/super.c                                  |   9 +
 fs/nilfs2/the_nilfs.c                              |   8 +-
 fs/squashfs/xattr_id.c                             |   2 +-
 include/linux/ceph/libceph.h                       |  10 -
 include/linux/fb.h                                 |   1 +
 include/linux/hugetlb.h                            |   5 +-
 include/linux/mm.h                                 |  12 +-
 include/linux/shrinker.h                           |   5 +-
 include/linux/stmmac.h                             |   1 +
 include/net/sock.h                                 |  13 +
 kernel/sched/psi.c                                 |   7 +-
 kernel/time/alarmtimer.c                           |  33 +-
 kernel/trace/trace_events.c                        |   2 +-
 kernel/umh.c                                       |  20 +-
 mm/filemap.c                                       |   5 +-
 mm/gup.c                                           |   2 +-
 mm/huge_memory.c                                   |   6 +-
 mm/kasan/common.c                                  |   3 +
 mm/kasan/generic.c                                 |   7 +-
 mm/kasan/shadow.c                                  |  12 +
 mm/khugepaged.c                                    |   1 +
 mm/memblock.c                                      |   8 +-
 mm/migrate.c                                       |   2 +
 mm/shrinker_debug.c                                |  13 +-
 mm/vmscan.c                                        |   6 +-
 net/core/dev.c                                     |   2 +-
 net/core/sock_map.c                                |  61 ++--
 net/dccp/ipv6.c                                    |   7 +-
 net/ipv6/datagram.c                                |   2 +-
 net/ipv6/tcp_ipv6.c                                |  11 +-
 net/mpls/af_mpls.c                                 |   4 +
 net/mptcp/pm_netlink.c                             |  43 ++-
 net/mptcp/sockopt.c                                |  20 +-
 net/mptcp/subflow.c                                |   2 +-
 net/openvswitch/meter.c                            |   4 +-
 net/rose/af_rose.c                                 |   8 +
 net/sched/act_ctinfo.c                             |   6 +-
 net/sched/cls_tcindex.c                            |  34 ++-
 net/sched/sch_htb.c                                |   5 +-
 net/sctp/diag.c                                    |   4 +-
 net/socket.c                                       |   9 +-
 net/tipc/socket.c                                  |   2 +
 sound/pci/hda/hda_bind.c                           |   2 +
 sound/pci/hda/hda_codec.c                          |   3 +-
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_realtek.c                      |   9 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  21 ++
 sound/soc/codecs/cs42l56.c                         |   6 -
 sound/soc/intel/boards/sof_cs42l42.c               |   3 +
 sound/soc/intel/boards/sof_nau8825.c               |   5 +-
 sound/soc/intel/boards/sof_rt5682.c                |   5 +-
 sound/soc/intel/boards/sof_ssp_amp.c               |   5 +-
 sound/soc/sof/intel/hda-dai.c                      |   8 +-
 sound/soc/sof/sof-audio.c                          |   4 +-
 sound/usb/quirks.c                                 |   2 +
 tools/testing/memblock/internal.h                  |   4 -
 .../selftests/bpf/verifier/search_pruning.c        |  36 +++
 tools/testing/selftests/net/cmsg_ipv6.sh           |   2 +-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  11 +
 tools/virtio/linux/bug.h                           |   8 +-
 tools/virtio/linux/build_bug.h                     |   7 +
 tools/virtio/linux/cpumask.h                       |   7 +
 tools/virtio/linux/gfp.h                           |   7 +
 tools/virtio/linux/kernel.h                        |   1 +
 tools/virtio/linux/kmsan.h                         |  12 +
 tools/virtio/linux/scatterlist.h                   |   1 +
 tools/virtio/linux/topology.h                      |   7 +
 147 files changed, 1310 insertions(+), 726 deletions(-)


