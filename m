Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7695B9710
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiIOJLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiIOJLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 05:11:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF3D985B0;
        Thu, 15 Sep 2022 02:11:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97FA56221D;
        Thu, 15 Sep 2022 09:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D16C433D6;
        Thu, 15 Sep 2022 09:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663233108;
        bh=jPMFlW64FGc/8uhJRiy4GQW60BNBOkYCb176GBjepg4=;
        h=From:To:Cc:Subject:Date:From;
        b=2j20+z8GILimAVdny0YwUIcajD69MrbFMSFeWuzlowgHvHB9Xi/nbHmWWOoEAmLQ8
         qAYqZ+RzNqjUFMbPAF/tqHvFZrB8QRYaVPtpVYtCNXen0ZdnWeTS8nNQVEGN3FEhS7
         JMKE/1a4+JWa8FSDiAMbDQf0xtLPiiy18OFUHqY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.9
Date:   Thu, 15 Sep 2022 11:12:12 +0200
Message-Id: <1663233132208201@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
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

I'm announcing the release of the 5.19.9 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst                              |    2 
 Documentation/hwmon/asus_ec_sensors.rst                             |    4 
 Makefile                                                            |    5 
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi                         |   21 
 arch/arm/boot/dts/at91-sama5d2_icp.dts                              |   21 
 arch/arm/boot/dts/at91-sama7g5ek.dts                                |   18 
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi                       |   12 
 arch/arm/boot/dts/imx6qdl-vicut1.dtsi                               |    2 
 arch/arm/mach-at91/pm.c                                             |   36 
 arch/arm/mach-at91/pm_suspend.S                                     |   24 
 arch/arm64/Kconfig                                                  |   19 
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts              |    1 
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts              |    4 
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi                    |   11 
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts              |    8 
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi                    |    4 
 arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi                   |    1 
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi                           |    2 
 arch/arm64/kernel/cpu_errata.c                                      |   10 
 arch/arm64/kernel/cpufeature.c                                      |    5 
 arch/arm64/kernel/hibernate.c                                       |    5 
 arch/arm64/kernel/mte.c                                             |    9 
 arch/arm64/kernel/topology.c                                        |   32 
 arch/arm64/mm/copypage.c                                            |    9 
 arch/arm64/mm/mteswap.c                                             |    9 
 arch/arm64/tools/cpucaps                                            |    1 
 arch/mips/loongson32/ls1c/board.c                                   |    1 
 arch/parisc/include/asm/bitops.h                                    |    8 
 arch/parisc/kernel/head.S                                           |   43 
 arch/riscv/boot/dts/microchip/mpfs.dtsi                             |    2 
 arch/s390/kernel/nmi.c                                              |    2 
 arch/s390/kernel/setup.c                                            |    1 
 arch/x86/include/asm/sev.h                                          |    2 
 arch/x86/kernel/sev.c                                               |    2 
 block/partitions/core.c                                             |    3 
 drivers/base/driver.c                                               |    6 
 drivers/base/regmap/regmap-spi.c                                    |    8 
 drivers/cpufreq/cpufreq.c                                           |    2 
 drivers/firmware/efi/capsule-loader.c                               |   31 
 drivers/firmware/efi/libstub/Makefile                               |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                          |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                             |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c                              |   18 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                               |    3 
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c                             |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c           |    2 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c |   18 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/dcn301_smu.c          |   17 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c            |   14 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_smu.c          |   14 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_smu.c          |   14 
 drivers/gpu/drm/drm_gem.c                                           |   17 
 drivers/gpu/drm/drm_internal.h                                      |    4 
 drivers/gpu/drm/drm_prime.c                                         |   20 
 drivers/gpu/drm/i915/display/intel_bios.c                           |    7 
 drivers/gpu/drm/i915/display/intel_dp_link_training.c               |   22 
 drivers/gpu/drm/i915/gt/intel_llc.c                                 |   19 
 drivers/gpu/drm/i915/gt/intel_rps.c                                 |   50 +
 drivers/gpu/drm/i915/gt/intel_rps.h                                 |    2 
 drivers/gpu/drm/radeon/radeon_device.c                              |    3 
 drivers/hwmon/asus-ec-sensors.c                                     |  446 ++++++----
 drivers/hwmon/mr75203.c                                             |   72 +
 drivers/hwmon/tps23861.c                                            |   10 
 drivers/infiniband/core/cma.c                                       |    4 
 drivers/infiniband/core/umem_odp.c                                  |    2 
 drivers/infiniband/hw/hns/hns_roce_device.h                         |    1 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                          |    3 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                          |    4 
 drivers/infiniband/hw/hns/hns_roce_main.c                           |    2 
 drivers/infiniband/hw/hns/hns_roce_qp.c                             |    7 
 drivers/infiniband/hw/irdma/uk.c                                    |    4 
 drivers/infiniband/hw/irdma/utils.c                                 |   15 
 drivers/infiniband/hw/irdma/verbs.c                                 |   13 
 drivers/infiniband/hw/mlx5/mad.c                                    |    6 
 drivers/infiniband/sw/siw/siw_qp_tx.c                               |   18 
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                              |    9 
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                              |   14 
 drivers/infiniband/ulp/srp/ib_srp.c                                 |    3 
 drivers/iommu/amd/iommu.c                                           |    3 
 drivers/iommu/amd/iommu_v2.c                                        |    2 
 drivers/iommu/intel/dmar.c                                          |    7 
 drivers/iommu/intel/iommu.c                                         |   55 -
 drivers/iommu/iommu.c                                               |   21 
 drivers/iommu/virtio-iommu.c                                        |   11 
 drivers/md/md.c                                                     |    1 
 drivers/net/bonding/bond_main.c                                     |   55 -
 drivers/net/dsa/ocelot/felix_vsc9959.c                              |  162 ++-
 drivers/net/ethernet/intel/i40e/i40e.h                              |   14 
 drivers/net/ethernet/intel/i40e/i40e_client.c                       |    5 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                      |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |   23 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                         |    3 
 drivers/net/ethernet/intel/iavf/iavf_main.c                         |   14 
 drivers/net/ethernet/intel/ice/ice_base.c                           |   17 
 drivers/net/ethernet/intel/ice/ice_main.c                           |   10 
 drivers/net/ethernet/intel/ice/ice_xsk.c                            |   63 +
 drivers/net/ethernet/intel/ice/ice_xsk.h                            |    8 
 drivers/net/ethernet/mediatek/mtk_ppe.c                             |    2 
 drivers/net/ethernet/mediatek/mtk_ppe.h                             |    3 
 drivers/net/phy/meson-gxl.c                                         |    8 
 drivers/net/phy/microchip_t1.c                                      |   58 +
 drivers/net/wireless/intel/iwlegacy/4965-rs.c                       |    5 
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c                 |    2 
 drivers/net/wireless/microchip/wilc1000/netdev.h                    |    1 
 drivers/net/wireless/microchip/wilc1000/sdio.c                      |   39 
 drivers/net/wireless/microchip/wilc1000/wlan.c                      |   15 
 drivers/net/xen-netback/xenbus.c                                    |    2 
 drivers/nvme/host/tcp.c                                             |    7 
 drivers/nvme/target/core.c                                          |    6 
 drivers/nvme/target/zns.c                                           |   17 
 drivers/parisc/ccio-dma.c                                           |   11 
 drivers/perf/riscv_pmu_sbi.c                                        |    2 
 drivers/regulator/core.c                                            |    9 
 drivers/scsi/lpfc/lpfc_init.c                                       |    5 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                         |    1 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                                |    2 
 drivers/scsi/qla2xxx/qla_target.c                                   |   10 
 drivers/scsi/scsi_lib.c                                             |   44 
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                                 |   50 -
 drivers/soc/fsl/Kconfig                                             |    1 
 drivers/soc/imx/gpcv2.c                                             |    5 
 drivers/soc/imx/imx8m-blk-ctrl.c                                    |    1 
 drivers/spi/spi-bitbang-txrx.h                                      |    6 
 drivers/tee/tee_shm.c                                               |    1 
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c             |    9 
 drivers/ufs/core/ufshcd.c                                           |    9 
 drivers/vfio/vfio_iommu_type1.c                                     |   12 
 drivers/video/fbdev/chipsfb.c                                       |    1 
 drivers/video/fbdev/core/fbsysfs.c                                  |    4 
 drivers/video/fbdev/omap/omapfb_main.c                              |    4 
 fs/afs/flock.c                                                      |    2 
 fs/afs/fsclient.c                                                   |    2 
 fs/afs/internal.h                                                   |    3 
 fs/afs/rxrpc.c                                                      |    7 
 fs/afs/yfsclient.c                                                  |    3 
 fs/btrfs/ctree.h                                                    |    2 
 fs/btrfs/disk-io.c                                                  |    1 
 fs/btrfs/inode.c                                                    |    7 
 fs/btrfs/space-info.c                                               |    2 
 fs/btrfs/volumes.c                                                  |    3 
 fs/btrfs/zoned.c                                                    |   99 +-
 fs/cifs/smb2file.c                                                  |    1 
 fs/cifs/smb2ops.c                                                   |   88 -
 fs/cifs/smb2pdu.c                                                   |   20 
 fs/cifs/smb2proto.h                                                 |    4 
 fs/debugfs/inode.c                                                  |   22 
 fs/erofs/fscache.c                                                  |    8 
 fs/erofs/internal.h                                                 |   29 
 fs/tracefs/inode.c                                                  |   31 
 include/kunit/test.h                                                |    6 
 include/linux/buffer_head.h                                         |   11 
 include/linux/debugfs.h                                             |    6 
 include/linux/dmar.h                                                |    4 
 include/linux/lsm_hook_defs.h                                       |    1 
 include/linux/lsm_hooks.h                                           |    3 
 include/linux/security.h                                            |    5 
 include/linux/skbuff.h                                              |   49 -
 include/linux/time64.h                                              |    3 
 include/linux/udp.h                                                 |    1 
 include/net/bonding.h                                               |   13 
 include/net/udp_tunnel.h                                            |    4 
 include/soc/at91/sama7-ddr.h                                        |    8 
 io_uring/io_uring.c                                                 |    5 
 kernel/cgroup/cgroup.c                                              |   85 +
 kernel/cgroup/cpuset.c                                              |    3 
 kernel/dma/swiotlb.c                                                |    5 
 kernel/fork.c                                                       |    1 
 kernel/kprobes.c                                                    |    1 
 kernel/sched/debug.c                                                |    2 
 kernel/trace/trace_events_trigger.c                                 |    3 
 kernel/trace/trace_preemptirq.c                                     |    4 
 mm/kmemleak.c                                                       |    8 
 net/bridge/br_netfilter_hooks.c                                     |    2 
 net/bridge/br_netfilter_ipv6.c                                      |    1 
 net/core/datagram.c                                                 |    2 
 net/core/skbuff.c                                                   |    5 
 net/ipv4/tcp.c                                                      |    2 
 net/ipv4/tcp_input.c                                                |   25 
 net/ipv4/udp.c                                                      |    2 
 net/ipv4/udp_tunnel_core.c                                          |    1 
 net/ipv6/addrconf.c                                                 |    8 
 net/ipv6/seg6.c                                                     |    5 
 net/ipv6/udp.c                                                      |    5 
 net/netfilter/nf_conntrack_irc.c                                    |    5 
 net/netfilter/nf_conntrack_proto_tcp.c                              |   31 
 net/netfilter/nf_tables_api.c                                       |    4 
 net/rxrpc/ar-internal.h                                             |    1 
 net/rxrpc/local_object.c                                            |    1 
 net/rxrpc/peer_event.c                                              |  293 +++++-
 net/rxrpc/rxkad.c                                                   |    2 
 net/sched/sch_sfb.c                                                 |   13 
 net/sched/sch_taprio.c                                              |    5 
 net/smc/smc_core.c                                                  |    1 
 net/smc/smc_core.h                                                  |    2 
 net/smc/smc_wr.c                                                    |    5 
 net/smc/smc_wr.h                                                    |    5 
 net/tipc/monitor.c                                                  |    2 
 security/security.c                                                 |    4 
 security/selinux/hooks.c                                            |   24 
 security/selinux/include/classmap.h                                 |    2 
 security/smack/smack_lsm.c                                          |   32 
 sound/core/memalloc.c                                               |    9 
 sound/core/oss/pcm_oss.c                                            |    6 
 sound/drivers/aloop.c                                               |    7 
 sound/pci/emu10k1/emupcm.c                                          |    2 
 sound/pci/hda/hda_intel.c                                           |    2 
 sound/soc/atmel/mchp-spdiftx.c                                      |   10 
 sound/soc/codecs/cs42l42.c                                          |   13 
 sound/soc/qcom/sm8250.c                                             |    1 
 sound/soc/sof/Kconfig                                               |    2 
 sound/usb/card.c                                                    |    2 
 sound/usb/endpoint.c                                                |   25 
 sound/usb/endpoint.h                                                |    6 
 sound/usb/pcm.c                                                     |   14 
 sound/usb/quirks.c                                                  |    2 
 sound/usb/stream.c                                                  |    9 
 tools/lib/perf/evlist.c                                             |   50 +
 tools/objtool/check.c                                               |   34 
 tools/perf/arch/x86/util/evlist.c                                   |    7 
 tools/perf/builtin-record.c                                         |    8 
 tools/perf/builtin-script.c                                         |    3 
 tools/perf/builtin-stat.c                                           |   11 
 tools/perf/dlfilters/dlfilter-show-cycles.c                         |    4 
 tools/perf/util/evlist.c                                            |    9 
 tools/perf/util/evlist.h                                            |    7 
 226 files changed, 2437 insertions(+), 969 deletions(-)

Adrian Hunter (3):
      libperf evlist: Fix per-thread mmaps for multi-threaded targets
      perf dlfilter dlfilter-show-cycles: Fix types for print format
      perf record: Fix synthesis failure warnings

Ajay.Kathat@microchip.com (1):
      wifi: wilc1000: fix DMA on stack objects

Alex Williamson (1):
      vfio/type1: Unpin zero pages

Alexander Gordeev (1):
      s390/boot: fix absolute zero lowcore corruption on boot

Alexander Stein (1):
      arm64: dts: imx8mq-tqma8mq: Remove superfluous interrupt-names

Alexandru Gagniuc (1):
      hwmon: (tps23861) fix byte order in resistance register

Andrejs Cainikovs (2):
      arm64: dts: imx8mm-verdin: update CAN clock to 40MHz
      arm64: dts: imx8mm-verdin: use level interrupt for mcp251xfd

Andrew Halaney (1):
      regulator: core: Clean up on enable failure

Ard Biesheuvel (1):
      efi: libstub: Disable struct randomization

Arun Ramadoss (1):
      net: phy: lan87xx: change interrupt src of link_up to comm_ready

Bart Van Assche (2):
      scsi: ufs: core: Reduce the power mode change timeout
      nvmet: fix a use-after-free

Borislav Petkov (1):
      x86/sev: Mark snp_abort() noreturn

Brian Bunker (1):
      scsi: core: Allow the ALUA transitioning state enough time

Brian Norris (1):
      tracefs: Only clobber mode/uid/gid on remount if asked

Candice Li (1):
      drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.

Casey Schaufler (1):
      Smack: Provide read control for io_uring_cmd

Chao Gao (1):
      swiotlb: avoid potential left shift overflow

Chengchang Tang (1):
      RDMA/hns: Fix supported page size

Chris Mi (1):
      RDMA/mlx5: Set local port to one when accessing counters

Christian A. Ehrhardt (1):
      kprobes: Prohibit probes in gate area

Claudiu Beznea (8):
      ARM: at91: pm: fix self-refresh for sama7g5
      ARM: at91: pm: fix DDR recalibration when resuming from backup and self-refresh
      ARM: dts: at91: sama5d27_wlsom1: specify proper regulator output ranges
      ARM: dts: at91: sama5d2_icp: specify proper regulator output ranges
      ARM: dts: at91: sama7g5ek: specify proper regulator output ranges
      ARM: dts: at91: sama5d27_wlsom1: don't keep ldo2 enabled all the time
      ARM: dts: at91: sama5d2_icp: don't keep vdd_other enabled all the time
      ASoC: mchp-spdiftx: remove references to mchp_i2s_caps

Conor Dooley (1):
      riscv: dts: microchip: use an mpfs specific l2 compatible

Cristian Ciocaltea (1):
      regmap: spi: Reserve space for register address/padding

Dan Carpenter (1):
      tipc: fix shift wrapping bug in map_get()

David Howells (4):
      smb3: missing inode locks in zero range
      rxrpc: Fix ICMP/ICMP6 error handling
      rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()
      afs: Use the operation issue time instead of the reply time for callbacks

David Jander (1):
      ARM: dts: imx6qdl-vicut1.dtsi: Fix node name backlight_led

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Fix forged IP logic

David Lebrun (1):
      ipv6: sr: fix out-of-bounds read when setting HMAC data.

David Sloan (1):
      md: Flush workqueue md_rdev_misc_wq in md_alloc()

Dennis Maisenbacher (1):
      nvmet: fix mar and mor off-by-one errors

Deren Wu (1):
      wifi: mt76: mt7921e: fix crash in chip reset fail

Dongxiang Ke (1):
      ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()

Eliav Farber (5):
      hwmon: (mr75203) fix VM sensor allocation when "intel,vm-map" not defined
      hwmon: (mr75203) update pvt->v_num and vm_num to the actual number of used sensors
      hwmon: (mr75203) fix voltage equation for negative source input
      hwmon: (mr75203) fix multi-channel voltage reading
      hwmon: (mr75203) enable polling for all VM channels

Enzo Matsumiya (1):
      cifs: remove useless parameter 'is_fsctl' from SMB2_ioctl()

Eric Dumazet (1):
      tcp: TX zerocopy should not sense pfmemalloc status

Eugene Shalygin (2):
      hwmon: (asus-ec-sensors) add missing sensors for X570-I GAMING
      hwmon: (asus-ec-sensors) autoload module via DMI data

Florian Westphal (1):
      netfilter: conntrack: work around exceeded receive window

Gao Xiang (1):
      erofs: fix pcluster use-after-free on UP platforms

Geert Uytterhoeven (1):
      arm64: dts: renesas: r8a779g0: Fix HSCIF0 interrupt number

Greg Kroah-Hartman (5):
      debugfs: add debugfs_lookup_and_remove()
      sched/debug: fix dentry leak in update_sched_domain_debugfs
      drm/amd/display: fix memory leak when using debugfs_lookup()
      driver core: fix driver_set_override() issue with empty strings
      Linux 5.19.9

Guixin Liu (1):
      scsi: megaraid_sas: Fix double kfree()

Hangbin Liu (3):
      bonding: use unspecified address if no available link local address
      bonding: add all node mcast address when slave up
      bonding: accept unsolicited NA message

Harsh Modi (1):
      netfilter: br_netfilter: Drop dst references before setting.

Heiner Kallweit (1):
      Revert "net: phy: meson-gxl: improve link-up behavior"

Helge Deller (2):
      Revert "parisc: Show error if wrong 32/64-bit compiler is being used"
      parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Hyunwoo Kim (1):
      efi: capsule-loader: Fix use-after-free in efi_capsule_write

Ionela Voinescu (1):
      arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly

Ivan Vecera (2):
      i40e: Fix kernel crash during module removal
      iavf: Detach device during reset task

Jack Wang (2):
      RDMA/rtrs-clt: Use the right sg_cnt after ib_dma_map_sg
      RDMA/rtrs-srv: Pass the correct number of entries for dma mapped SGL

Jason Gunthorpe (1):
      iommu: Fix false ownership failure on AMD systems with PASID activated

Jean-Philippe Brucker (1):
      iommu/virtio: Fix interaction with VFIO

Jeffy Chen (1):
      drm/gem: Fix GEM handle release errors

Jens Wiklander (1):
      tee: fix compiler warning in tee_shm_register()

Johannes Thumshirn (1):
      btrfs: zoned: fix mounting with conventional zones

John Sperbeck (1):
      iommu/amd: use full 64-bit value in build_completion_wait()

Kan Liang (1):
      perf evlist: Always use arch_evlist__add_default_attrs()

Lee, Chun-Yi (1):
      thermal/int340x_thermal: handle data_vault when the value is ZERO_SIZE_PTR

Li Qiong (1):
      parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Liang He (1):
      soc: brcmstb: pm-arm: Fix refcount leak and __iomem leak bugs

Linus Torvalds (1):
      fs: only do a memory barrier for the first set_buffer_uptodate()

Linus Walleij (1):
      RDMA/siw: Pass a pointer to virt_to_page()

Lorenzo Bianconi (2):
      net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear
      net: ethernet: mtk_eth_soc: check max allowed hash in mtk_ppe_check_skb

Lu Baolu (2):
      iommu/vt-d: Fix possible recursive locking in intel_iommu_init()
      iommu/vt-d: Correctly calculate sagaw value of IOMMU

Luis Chamberlain (1):
      lsm,io_uring: add LSM hooks for the new uring_cmd file op

Lukasz Luba (1):
      cpufreq: check only freq_table in __resolve_freq()

Marcel Ziswiler (2):
      arm64: dts: freescale: verdin-imx8mm: fix atmel_mxt_ts reset polarity
      arm64: dts: freescale: verdin-imx8mp: fix atmel_mxt_ts reset polarity

Marco Felsch (3):
      Revert "soc: imx: imx8m-blk-ctrl: set power device name"
      ARM: dts: imx6qdl-kontron-samx6i: remove duplicated node
      ARM: dts: imx6qdl-kontron-samx6i: fix spi-flash compatible

Marek Vasut (1):
      soc: imx: gpcv2: Assert reset before ungating clock

Mark Brown (1):
      arm64/bti: Disable in kernel BTI when cross section thunks are broken

Masahiro Yamada (1):
      kbuild: disable header exports for UML in a straightforward way

Masami Hiramatsu (Google) (1):
      tracing: Fix to check event_mutex is held while accessing trigger list

Mathew McBride (1):
      soc: fsl: select FSL_GUTS driver for DPIO

Michael Carns (1):
      hwmon: (asus-ec-sensors) add support for Maximus XI Hero

Michael Guralnik (1):
      RDMA/cma: Fix arguments order in net device validation

Michal Swiatkowski (1):
      ice: use bitmap_free instead of devm_kfree

Ming Lei (1):
      block: don't add partitions if GD_SUPPRESS_PART_SCAN is set

Naohiro Aota (1):
      btrfs: zoned: fix API misuse of zone finish waiting

Nathan Chancellor (1):
      ASoC: mchp-spdiftx: Fix clang -Wbitfield-constant-conversion

Neal Cardwell (1):
      tcp: fix early ETIMEDOUT after spurious non-SACK RTO

Pablo Neira Ayuso (1):
      netfilter: nf_tables: clean up hook list when offload flags check fails

Pattara Teerapong (1):
      ALSA: aloop: Fix random zeros in capture data when using jiffies timer

Paul Durrant (1):
      xen-netback: only remove 'hotplug-status' when the vif is actually destroyed

Paul Moore (1):
      selinux: implement the security_uring_cmd() LSM hook

Pavel Begunkov (2):
      net: introduce __skb_fill_page_desc_noacc
      io_uring: recycle kbuf recycle on tw requeue

Peng Fan (1):
      arm64: dts: imx8mp-venice-gw74xx: fix sai2 pin settings

Peter Ujfalusi (2):
      ASoC: SOF: Kconfig: Make IPC_FLOOD_TEST depend on SND_SOC_SOF
      ASoC: SOF: Kconfig: Make IPC_MESSAGE_INJECTOR depend on SND_SOC_SOF

Philippe Schenker (1):
      arm64: dts: verdin-imx8mm: add otg2 pd to usbphy

Przemyslaw Patynowski (3):
      ice: Fix DMA mappings leak
      i40e: Refactor tc mqprio checks
      i40e: Fix ADQ rate limiting for PF

Qu Huang (1):
      drm/amdgpu: mmVM_L2_CNTL3 register not initialized correctly

Qu Wenruo (1):
      btrfs: fix the max chunk size and stripe length calculation

Richard Fitzgerald (1):
      ASoC: cs42l42: Only report button state if there was a button interrupt

Robin Murphy (1):
      spi: bitbang: Fix lsb-first Rx

Rodrigo Vivi (1):
      drm/i915/slpc: Let's fix the PCODE min freq table setup for SLPC

Saaem Rizvi (2):
      drm/amd/display: Add SMU logging code
      drm/amd/display: Removing assert statements for Linux

Sagi Grimberg (2):
      nvme-tcp: fix UAF when detecting digest errors
      nvme-tcp: fix regression that causes sporadic requests to time out

Sander Vanheule (1):
      kunit: fix assert_type for comparison macros

Sasha Levin (1):
      Revert "arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags""

Sergey Matyukevich (1):
      perf: RISC-V: fix access beyond allocated array

Shady Nawara (1):
      hwmon: (asus-ec-sensors) add support for Strix Z690-a D4

Shigeru Yoshida (1):
      fbdev: fbcon: Destroy mutex on freeing struct fb_info

Shin'ichiro Kawasaki (1):
      btrfs: zoned: set pseudo max append zone limit in zone emulation mode

Shiraz Saleem (1):
      RDMA/irdma: Fix drain SQ hang with no completion

Sindhu-Devale (4):
      RDMA/irdma: Report the correct max cqes from query device
      RDMA/irdma: Return error on MR deregister CQP failure
      RDMA/irdma: Return correct WC error for bind operation failure
      RDMA/irdma: Report RNR NAK generation in device caps

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix use-after-free warning

Srinivas Kandagatla (1):
      ASoC: qcom: sm8250: add missing module owner

Stanislaw Gruszka (1):
      wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

Sun Ke (1):
      erofs: fix error return code in erofs_fscache_{meta_,}read_folio

Takashi Iwai (6):
      ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC
      ALSA: hda: Once again fix regression of page allocations with IOMMU
      ALSA: usb-audio: Split endpoint setups for hw_params and prepare
      ALSA: usb-audio: Clear fixed clock rate at closing EP
      ALSA: usb-audio: Inform the delayed registration more properly
      ALSA: usb-audio: Register card again for iface over delayed_register option

Tasos Sahanidis (1):
      ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Tejun Heo (2):
      cgroup: Elide write-locking threadgroup_rwsem when updating csses on an empty subtree
      cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Tim Harvey (1):
      arm64: dts: imx8mm-venice-gw7901: fix port/phy validation

Tim Huang (1):
      drm/amdgpu: add sdma instance check for gfx11 CGCG

Toke Høiland-Jørgensen (2):
      sch_sfb: Don't assume the skb is still around after enqueueing to child
      sch_sfb: Also store skb len before calling child enqueue

Tony Battersby (1):
      scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX

Urs Schroffenegger (1):
      hwmon: (asus-ec-sensors) add definitions for ROG ZENITH II EXTREME

Ville Syrjälä (2):
      drm/i915/bios: Copy the whole MIPI sequence block
      drm/i915: Implement WaEdpLinkRateDataReload

Vladimir Oltean (6):
      arm64: dts: ls1028a-qds-65bb: don't use in-band autoneg for 2500base-x
      net: dsa: felix: disable cut-through forwarding for frames oversized for tc-taprio
      net: dsa: felix: access QSYS_TAG_CONFIG under tas_lock in vsc9959_sched_speed_set
      net: bonding: replace dev_trans_start() with the jiffies of the last ARP/NS
      time64.h: consolidate uses of PSEC_PER_NSEC
      net: dsa: felix: tc-taprio intervals smaller than MTU should send at least one packet

Wenpeng Liang (1):
      RDMA/hns: Fix wrong fixed value of qp->rq.wqe_shift

Yacan Liu (1):
      net/smc: Fix possible access to freed memory in link clear

Yang Ling (1):
      MIPS: loongson32: ls1c: Fix hang during startup

Yang Yingliang (2):
      fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()
      scsi: lpfc: Add missing destroy_workqueue() in error path

Yee Lee (1):
      Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

YiPeng Chai (2):
      drm/amdgpu: Move psp_xgmi_terminate call from amdgpu_xgmi_remove_device to psp_hw_fini
      drm/amdgpu: fix hive reference leak when adding xgmi device

Yipeng Zou (1):
      tracing: hold caller_addr to hardirq_{enable,disable}_ip

Yishai Hadas (1):
      IB/core: Fix a nested dead lock as part of ODP flow

Yixing Liu (1):
      RDMA/hns: Remove the num_qpc_timer variable

Yu Zhe (1):
      fbdev: omapfb: Fix tests for platform_get_irq() failure

Zhengjun Xing (2):
      perf script: Fix Cannot print 'iregs' field for hybrid systems
      perf stat: Fix L2 Topdown metrics disappear for raw events

Zhenneng Li (1):
      drm/radeon: add a force flush to delay work when radeon

lily (1):
      net/core/skbuff: Check the return value of skb_copy_bits()

shaoyunl (1):
      drm/amdgpu: Remove the additional kfd pre reset call for sriov

yangx.jy@fujitsu.com (1):
      RDMA/srp: Set scmnd->result only when scmnd is not NULL

