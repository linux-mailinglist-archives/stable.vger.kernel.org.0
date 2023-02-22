Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4D669F433
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjBVMQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjBVMPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:15:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884C639CF2;
        Wed, 22 Feb 2023 04:15:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC53EB81230;
        Wed, 22 Feb 2023 12:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432B5C433EF;
        Wed, 22 Feb 2023 12:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677068128;
        bh=muU07pfPXLwXUb1ZGca3ALRJZU9x9Q3rxiwO9NlfbXg=;
        h=From:To:Cc:Subject:Date:From;
        b=msWAmyQNLtDGK5cVp8h9YMB5Xdh2Qj1bwjy2pKXR45CemGAYIz+V+f7/ZYVb8m5tJ
         pF+OG5HK7P5CHMjHsBsj+2wEhS+CvzK76bTZGfeYOfO3gOlUig5gRlThc7l8VpxMWF
         7Y9i0xxt/VGNwhMLb3+PX/XXlg9xUAkBTE6qluhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.13
Date:   Wed, 22 Feb 2023 13:15:15 +0100
Message-Id: <1677068116114212@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.13 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                         |    2 
 arch/powerpc/include/asm/hw_irq.h                                |   41 -
 arch/powerpc/kernel/dbell.c                                      |    2 
 arch/powerpc/kernel/irq.c                                        |    2 
 arch/powerpc/kernel/time.c                                       |    2 
 arch/s390/boot/decompressor.c                                    |    2 
 arch/x86/events/core.c                                           |   12 
 arch/x86/kvm/pmu.h                                               |   26 
 arch/x86/kvm/x86.c                                               |    3 
 drivers/ata/ahci.c                                               |    1 
 drivers/ata/libata-core.c                                        |    3 
 drivers/gpio/gpio-sim.c                                          |    2 
 drivers/gpu/drm/Kconfig                                          |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                       |    3 
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c                           |    2 
 drivers/gpu/drm/amd/amdgpu/soc21.c                               |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |   17 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c          |    5 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c                |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c |    2 
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c                  |   12 
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                               |    6 
 drivers/gpu/drm/i915/gt/intel_workarounds.c                      |   14 
 drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c              |   23 
 drivers/gpu/drm/vc4/vc4_crtc.c                                   |    2 
 drivers/gpu/drm/vc4/vc4_plane.c                                  |    6 
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                               |   12 
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c                          |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c                              |    8 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                              |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c                          |    1 
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c                           |    1 
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c                          |   10 
 drivers/mmc/core/sdio_bus.c                                      |   17 
 drivers/mmc/core/sdio_cis.c                                      |   12 
 drivers/mmc/host/jz4740_mmc.c                                    |   10 
 drivers/mmc/host/meson-gx-mmc.c                                  |   23 
 drivers/mmc/host/mmc_spi.c                                       |    8 
 drivers/net/ethernet/broadcom/bgmac-bcma.c                       |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |    8 
 drivers/net/ethernet/intel/i40e/i40e_main.c                      |    4 
 drivers/net/ethernet/intel/ice/ice_main.c                        |   26 
 drivers/net/ethernet/intel/ice/ice_xsk.c                         |   15 
 drivers/net/ethernet/intel/igb/igb_main.c                        |   54 +
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                         |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                    |   28 
 drivers/net/ethernet/mediatek/mtk_ppe.c                          |    3 
 drivers/net/ethernet/mediatek/mtk_ppe.h                          |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c          |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c                     |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c            |    2 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                         |   12 
 drivers/net/ethernet/ti/am65-cpsw-nuss.h                         |    1 
 drivers/net/usb/kalmia.c                                         |    8 
 drivers/net/vmxnet3/vmxnet3_drv.c                                |   50 -
 drivers/nvme/host/core.c                                         |    5 
 drivers/nvme/host/pci.c                                          |    8 
 drivers/nvme/host/rdma.c                                         |    2 
 drivers/nvme/host/tcp.c                                          |    2 
 drivers/nvme/target/fc.c                                         |    4 
 drivers/of/of_reserved_mem.c                                     |    3 
 drivers/platform/x86/touchscreen_dmi.c                           |    9 
 drivers/vdpa/ifcvf/ifcvf_main.c                                  |    2 
 drivers/video/fbdev/core/fb_defio.c                              |   10 
 drivers/video/fbdev/core/fbmem.c                                 |    4 
 fs/aio.c                                                         |    4 
 fs/btrfs/extent_io.c                                             |    2 
 fs/btrfs/file.c                                                  |  340 ----------
 fs/btrfs/tree-defrag.c                                           |  337 +++++++++
 fs/ceph/addr.c                                                   |   17 
 fs/ceph/caps.c                                                   |   16 
 fs/ceph/file.c                                                   |    3 
 fs/ceph/mds_client.c                                             |   30 
 fs/ceph/snap.c                                                   |   36 +
 fs/ceph/super.h                                                  |   11 
 fs/coredump.c                                                    |   48 -
 fs/fscache/volume.c                                              |    3 
 fs/nilfs2/ioctl.c                                                |    7 
 fs/nilfs2/super.c                                                |    9 
 fs/nilfs2/the_nilfs.c                                            |    8 
 fs/squashfs/xattr_id.c                                           |    2 
 include/linux/ceph/libceph.h                                     |   10 
 include/linux/fb.h                                               |    1 
 include/linux/hugetlb.h                                          |    5 
 include/linux/mm.h                                               |   12 
 include/linux/shrinker.h                                         |    5 
 include/linux/stmmac.h                                           |    1 
 include/net/sock.h                                               |   13 
 kernel/sched/psi.c                                               |    7 
 kernel/time/alarmtimer.c                                         |   33 
 kernel/trace/trace_events.c                                      |    2 
 kernel/umh.c                                                     |   20 
 mm/filemap.c                                                     |    5 
 mm/gup.c                                                         |    2 
 mm/huge_memory.c                                                 |    6 
 mm/kasan/common.c                                                |    3 
 mm/kasan/generic.c                                               |    7 
 mm/kasan/shadow.c                                                |   12 
 mm/khugepaged.c                                                  |    1 
 mm/memblock.c                                                    |    8 
 mm/migrate.c                                                     |    2 
 mm/shrinker_debug.c                                              |   13 
 mm/vmscan.c                                                      |    6 
 net/core/dev.c                                                   |    2 
 net/core/sock_map.c                                              |   61 +
 net/dccp/ipv6.c                                                  |    7 
 net/ipv6/datagram.c                                              |    2 
 net/ipv6/tcp_ipv6.c                                              |   11 
 net/mpls/af_mpls.c                                               |    4 
 net/mptcp/pm_netlink.c                                           |   43 -
 net/mptcp/sockopt.c                                              |   20 
 net/mptcp/subflow.c                                              |    2 
 net/openvswitch/meter.c                                          |    4 
 net/rose/af_rose.c                                               |    8 
 net/sched/act_ctinfo.c                                           |    6 
 net/sched/cls_tcindex.c                                          |   34 -
 net/sched/sch_htb.c                                              |    5 
 net/sctp/diag.c                                                  |    4 
 net/socket.c                                                     |    9 
 net/tipc/socket.c                                                |    2 
 sound/pci/hda/hda_bind.c                                         |    2 
 sound/pci/hda/hda_codec.c                                        |    3 
 sound/pci/hda/patch_conexant.c                                   |    1 
 sound/pci/hda/patch_realtek.c                                    |    9 
 sound/soc/amd/yc/acp6x-mach.c                                    |   21 
 sound/soc/codecs/cs42l56.c                                       |    6 
 sound/soc/intel/boards/sof_cs42l42.c                             |    3 
 sound/soc/intel/boards/sof_nau8825.c                             |    5 
 sound/soc/intel/boards/sof_rt5682.c                              |    5 
 sound/soc/intel/boards/sof_ssp_amp.c                             |    5 
 sound/soc/sof/intel/hda-dai.c                                    |    8 
 sound/soc/sof/sof-audio.c                                        |    4 
 sound/usb/quirks.c                                               |    2 
 tools/testing/memblock/internal.h                                |    4 
 tools/testing/selftests/bpf/verifier/search_pruning.c            |   36 +
 tools/testing/selftests/net/cmsg_ipv6.sh                         |    2 
 tools/testing/selftests/net/mptcp/userspace_pm.sh                |   11 
 tools/virtio/linux/bug.h                                         |    8 
 tools/virtio/linux/build_bug.h                                   |    7 
 tools/virtio/linux/cpumask.h                                     |    7 
 tools/virtio/linux/gfp.h                                         |    7 
 tools/virtio/linux/kernel.h                                      |    1 
 tools/virtio/linux/kmsan.h                                       |   12 
 tools/virtio/linux/scatterlist.h                                 |    1 
 tools/virtio/linux/topology.h                                    |    7 
 146 files changed, 1307 insertions(+), 724 deletions(-)

Aaron Thompson (1):
      Revert "mm: Always release pages to the buddy allocator in memblock_free_late()."

Alex Deucher (1):
      drm/amd/display: Properly handle additional cases where DCN is not supported

Amit Engel (1):
      nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association

Andrei Gherzan (1):
      selftest: net: Improve IPV6_TCLASS/IPV6_HOPLIMIT tests apparmor compatibility

Andrew Morton (1):
      revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"

Andrey Konovalov (1):
      net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC

Andy Chi (2):
      ALSA: hda/realtek: fix mute/micmute LEDs don't work for a HP platform.
      ALSA: hda/realtek: Enable mute/micmute LEDs and speaker support for HP Laptops

Arnd Bergmann (2):
      ASoC: cs42l56: fix DT probe
      mm: extend max struct page size for kmsan

Bard Liao (1):
      ASoC: SOF: sof-audio: start with the right widget type

Bartosz Golaszewski (1):
      gpio: sim: fix a memory leak

Ben Skeggs (1):
      drm/nouveau/devinit/tu102-: wait for GFW_BOOT_PROGRESS == COMPLETED

Bo Liu (1):
      ALSA: hda/conexant: add a new hda codec SN6180

Cezary Rojewski (2):
      ALSA: hda: Do not unset preset when cleaning up codec
      ALSA: hda: Fix codec device field initializan

Christophe Leroy (1):
      kasan: fix Oops due to missing calls to kasan_arch_is_ready()

Corinna Vinschen (1):
      igb: conditionalize I2C bit banging on external thermal sensor support

Cristian Ciocaltea (1):
      net: stmmac: Restrict warning on disabling DMA store and fwd mode

Dan Carpenter (1):
      net: sched: sch: Fix off by one in htb_activate_prios()

Daniel Miess (2):
      drm/amd/display: Add missing brackets in calculation
      drm/amd/display: Adjust downscaling limits for dcn314

Dave Stevenson (1):
      drm/vc4: Fix YUV plane handling when planes are in different buffers

Dom Cobley (1):
      drm/vc4: crtc: Increase setup cost in core clock calculation to handle extreme reduced blanking

Eduard Zingerman (1):
      selftests/bpf: Verify copy_register_state() preserves parent/live fields

Eric Dumazet (1):
      net: use a bounce buffer for copying skb->mark

Evan Quan (1):
      drm/amdgpu: enable HDP SD for gfx 11.0.3

Felix Riemann (1):
      net: Fix unwanted sign extension in netdev_stats_to_stats64()

Filipe Manana (1):
      btrfs: lock the inode in shared mode before starting fiemap

Geert Uytterhoeven (1):
      coredump: Move dump_emit_page() to kill unused warning

George Shen (1):
      drm/amd/display: Unassign does_plane_fit_in_mall function from dcn3.2

Greg Kroah-Hartman (2):
      kvm: initialize all of the kvm_debugregs structure before sending it to userspace
      Linux 6.1.13

Guillaume Nault (2):
      ipv6: Fix datagram socket connection with DSCP.
      ipv6: Fix tcp socket connection with DSCP.

Hangyu Hua (1):
      net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()

Hans de Goede (1):
      platform/x86: touchscreen_dmi: Add Chuwi Vi8 (CWI501) DMI match

Heiner Kallweit (1):
      mmc: meson-gx: fix SDIO mode if cap_sdio_irq isn't set

Hou Tao (1):
      fscache: Use clear_and_wake_up_bit() in fscache_create_volume_work()

Hyunwoo Kim (1):
      net/rose: Fix to not accept on connected socket

Isaac J. Manjarres (1):
      of: reserved_mem: Have kmemleak ignore dynamically allocated reserved mem

Jack Xiao (1):
      drm/amd/amdgpu: fix warning during suspend

Jakub Kicinski (1):
      net: mpls: fix stale pointer if allocation fails during device rename

Jakub Sitnicki (1):
      bpf, sockmap: Don't let sock_map_{close,destroy,unhash} call itself

Jason Xing (3):
      ixgbe: allow to increase MTU to 3K with XDP enabled
      i40e: add double of VLAN header when computing the max MTU
      ixgbe: add double of VLAN header when computing the max MTU

Jesse Brandeburg (1):
      ice: fix lost multicast packets in promisc mode

Johannes Zink (1):
      net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence

Josef Bacik (1):
      btrfs: move the auto defrag code to defrag.c

Kailang Yang (1):
      ALSA: hda/realtek - fixed wrong gpio assigned

Kees Cook (2):
      net: ethernet: mtk_eth_soc: Avoid truncating allocation
      net: sched: sch: Bounds check priority

Keith Busch (1):
      nvme-pci: refresh visible attrs for cmb attributes

Kuan-Ying Lee (1):
      mm/gup: add folio to list when folio_isolate_lru() succeed

Kuniyuki Iwashima (1):
      dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.

Larysa Zaremba (1):
      ice: xsk: Fix cleaning of XDP_TX frames

Leo Li (1):
      drm/amd/display: Fail atomic_check early on normalize_zpos error

Matt Roper (1):
      drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT list

Matthieu Baerts (2):
      mptcp: sockopt: make 'tcp_fastopen_connect' generic
      selftests: mptcp: userspace: fix v4-v6 test in v6.1

Maurizio Lombardi (2):
      nvme: clear the request_queue pointers on failure in nvme_alloc_admin_tag_set
      nvme: clear the request_queue pointers on failure in nvme_alloc_io_tag_set

Michael Chan (1):
      bnxt_en: Fix mqprio and XDP ring checking logic

Mike Kravetz (1):
      hugetlb: check for undefined shift on 32 bit architectures

Miko Larsson (1):
      net/usb: kalmia: Don't pass act_len in usb_bulk_msg error path

Miroslav Lichvar (1):
      igb: Fix PPS input and output using 3rd and 4th SDP

Munehisa Kamata (1):
      sched/psi: Fix use-after-free in ep_remove_wait_queue()

Natalia Petrova (1):
      i40e: Add checking for null for nlmsg_find_attr()

Nicholas Kazlauskas (1):
      drm/amd/display: Reset DMUB mailbox SW state after HW reset

Nicholas Piggin (1):
      powerpc/64: Fix perf profiling asynchronous interrupt handlers

Paolo Abeni (3):
      mptcp: fix locking for setsockopt corner-case
      mptcp: deduplicate error paths on endpoint creation
      mptcp: fix locking for in-kernel listener creation

Patrick McLean (1):
      ata: libata-core: Disable READ LOG DMA EXT for Samsung MZ7LH

Paul Cercueil (1):
      mmc: jz4740: Work around bug on JZ4760(B)

Pedro Tammela (3):
      net/sched: tcindex: update imperfect hash filters respecting rcu
      net/sched: act_ctinfo: use percpu stats
      net/sched: tcindex: search key must be 16 bits

Peter Xu (1):
      mm/migrate: fix wrongly apply write bit after mkdirty on sparc64

Peter Zijlstra (1):
      freezer,umh: Fix call_usermode_helper_exec() vs SIGKILL

Pierre-Louis Bossart (5):
      ASoC: Intel: sof_rt5682: always set dpcm_capture for amplifiers
      ASoC: Intel: sof_cs42l42: always set dpcm_capture for amplifiers
      ASoC: Intel: sof_nau8825: always set dpcm_capture for amplifiers
      ASoC: Intel: sof_ssp_amp: always set dpcm_capture for amplifiers
      ASoC: SOF: Intel: hda-dai: fix possible stream_tag leak

Pietro Borrello (1):
      sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list

Qi Zheng (1):
      mm: shrinkers: fix deadlock in shrinker debugfs

Qian Yingjin (1):
      mm/filemap: fix page end in filemap_get_read_batch

Rafał Miłecki (1):
      net: bgmac: fix BCM5358 support by setting correct flags

Ronak Doshi (1):
      vmxnet3: move rss code block under eop descriptor

Ryusuke Konishi (1):
      nilfs2: fix underflow in second superblock position calculations

Sagi Grimberg (2):
      nvme-tcp: stop auth work after tearing down queues in error recovery
      nvme-rdma: stop auth work after tearing down queues in error recovery

Sean Christopherson (2):
      KVM: x86/pmu: Disable vPMU support on hybrid CPUs (host PMUs)
      perf/x86: Refuse to export capabilities for hybrid PMUs

Seth Jenkins (1):
      aio: fix mremap after fork null-deref

Shunsuke Mie (1):
      tools/virtio: fix the vringh test for virtio ring changes

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Add RX DMA Channel Teardown Quirk

Simon Gaiser (1):
      ata: ahci: Add Tiger Lake UP{3,4} AHCI controller

Steven Rostedt (Google) (1):
      tracing: Make trace_define_field_ext() static

Syed Saba Kareem (1):
      ASoC: amd: yc: Add DMI support for new acer/emdoor platforms

Takashi Iwai (2):
      ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum610 Wireless
      fbdev: Fix invalid page access after closing deferred I/O devices

Tanmay Bhushan (1):
      vdpa: ifcvf: Do proper cleanup if IFCVF init fails

Thomas Gleixner (1):
      alarmtimer: Prevent starvation by small intervals and SIG_IGN

Tung Nguyen (1):
      tipc: fix kernel warning when sending SYN message

Vasily Gorbik (1):
      s390/decompressor: specify __decompress() buf len to avoid overflow

Ville Syrjälä (1):
      drm: Disable dynamic debug as broken

Xiubo Li (2):
      ceph: move mount state enum to super.h
      ceph: blocklist the kclient when receiving corrupted snap trace

Yang Yingliang (2):
      mmc: sdio: fix possible resource leaks in some error paths
      mmc: mmc_spi: fix error handling in mmc_spi_probe()

Yiqing Yao (1):
      drm/amdgpu: Enable vclk dclk node for gc11.0.3

Zach O'Keefe (1):
      mm/MADV_COLLAPSE: set EAGAIN on unexpected page refcount

Zack Rusin (2):
      drm/vmwgfx: Stop accessing buffer objects which failed init
      drm/vmwgfx: Do not drop the reference to the handle too soon

fengwk (1):
      ASoC: amd: yc: Add Xiaomi Redmi Book Pro 15 2022 into DMI table

