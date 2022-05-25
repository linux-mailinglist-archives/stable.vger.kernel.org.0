Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92974533848
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 10:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbiEYIUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 04:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiEYIUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 04:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4467687A24;
        Wed, 25 May 2022 01:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5822D61834;
        Wed, 25 May 2022 08:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36814C385B8;
        Wed, 25 May 2022 08:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653466836;
        bh=pjjTe605fjcJZ2qC3i7D1zvXnt0i0sjMuGLT4eOu2gQ=;
        h=From:To:Cc:Subject:Date:From;
        b=wnv5aMR3rzSov2nN5ueBBRYBde+oqVJjTPmVNjH0NHpDdjU+4q6PAjbJLeO9oWf/W
         6o6DSwKGYK5diUN2qeZhEToo+vOF/G5TAv1PnZ5sdzJ3CuX/yk9EGfqYLir0PRsivi
         76houeecl5H05k8iIkMVzuYkEOfuYYHbxgRbtoh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.17.10
Date:   Wed, 25 May 2022 10:20:28 +0200
Message-Id: <165346682912940@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.17.10 kernel.

All users of the 5.17 kernel series must upgrade.

The updated 5.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.17.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst                                |    3 
 Documentation/devicetree/bindings/pinctrl/aspeed,ast2600-pinctrl.yaml |    2 
 Makefile                                                              |    2 
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi                              |    9 
 arch/arm/boot/dts/aspeed-g6.dtsi                                      |   10 
 arch/arm/kernel/entry-armv.S                                          |    2 
 arch/arm/kernel/stacktrace.c                                          |   10 
 arch/arm/mm/proc-v7-bugs.c                                            |    1 
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts                               |   12 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                                  |    4 
 arch/arm64/kernel/cpu_errata.c                                        |    2 
 arch/arm64/kernel/mte.c                                               |    3 
 arch/arm64/kernel/paravirt.c                                          |   29 
 arch/arm64/kernel/relocate_kernel.S                                   |   22 
 arch/arm64/kvm/sys_regs.c                                             |    3 
 arch/mips/lantiq/falcon/sysctrl.c                                     |    2 
 arch/mips/lantiq/xway/gptu.c                                          |    2 
 arch/mips/lantiq/xway/sysctrl.c                                       |   46 -
 arch/riscv/boot/dts/sifive/fu540-c000.dtsi                            |    2 
 arch/s390/kernel/traps.c                                              |    6 
 arch/s390/pci/pci.c                                                   |    1 
 arch/s390/pci/pci_bus.h                                               |    3 
 arch/s390/pci/pci_clp.c                                               |    9 
 arch/s390/pci/pci_event.c                                             |    7 
 arch/x86/crypto/chacha-avx512vl-x86_64.S                              |    4 
 arch/x86/kvm/mmu/mmu.c                                                |   10 
 arch/x86/kvm/pmu.c                                                    |    7 
 arch/x86/um/shared/sysdep/syscalls_64.h                               |    5 
 block/mq-deadline.c                                                   |    1 
 drivers/block/drbd/drbd_main.c                                        |    7 
 drivers/block/floppy.c                                                |   18 
 drivers/clk/at91/clk-generated.c                                      |    4 
 drivers/crypto/qcom-rng.c                                             |    1 
 drivers/crypto/stm32/stm32-crc32.c                                    |    4 
 drivers/dma-buf/dma-buf.c                                             |    8 
 drivers/gpio/gpio-mvebu.c                                             |    3 
 drivers/gpio/gpio-vf610.c                                             |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                                   |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c                              |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                               |    2 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_init.c                     |    5 
 drivers/gpu/drm/drm_dp_mst_topology.c                                 |    1 
 drivers/gpu/drm/i915/display/intel_dmc.c                              |   44 +
 drivers/gpu/drm/i915/display/intel_opregion.c                         |   15 
 drivers/gpu/drm/i915/gt/intel_reset.c                                 |    2 
 drivers/gpu/drm/i915/gt/uc/intel_guc.h                                |    2 
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c                     |   16 
 drivers/gpu/drm/i915/gt/uc/intel_uc.c                                 |    2 
 drivers/gpu/drm/i915/gt/uc/intel_uc.h                                 |    2 
 drivers/gpu/drm/i915/i915_reg.h                                       |   16 
 drivers/i2c/busses/i2c-mt7621.c                                       |   10 
 drivers/i2c/busses/i2c-piix4.c                                        |  213 +++++-
 drivers/input/input.c                                                 |   19 
 drivers/input/touchscreen/ili210x.c                                   |    4 
 drivers/input/touchscreen/stmfts.c                                    |    8 
 drivers/mmc/core/mmc_ops.c                                            |    2 
 drivers/net/can/m_can/m_can_pci.c                                     |   48 -
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c                      |   20 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c             |    7 
 drivers/net/ethernet/broadcom/bcmsysport.c                            |    6 
 drivers/net/ethernet/cadence/macb_main.c                              |    2 
 drivers/net/ethernet/dec/tulip/tulip_core.c                           |    5 
 drivers/net/ethernet/intel/ice/ice_lib.c                              |   16 
 drivers/net/ethernet/intel/ice/ice_main.c                             |    7 
 drivers/net/ethernet/intel/ice/ice_ptp.c                              |   19 
 drivers/net/ethernet/intel/ice/ice_txrx.h                             |   11 
 drivers/net/ethernet/intel/igb/igb_main.c                             |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                     |   27 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                     |  131 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h                     |    6 
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c                    |   25 
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h                    |    1 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                        |   19 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c          |   71 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c              |    4 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c          |    4 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h           |    3 
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c              |    4 
 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h             |    3 
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c                 |   28 
 drivers/net/ethernet/qlogic/qla3xxx.c                                 |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c                      |    4 
 drivers/net/ipa/gsi.c                                                 |    6 
 drivers/net/ipa/ipa_endpoint.c                                        |   13 
 drivers/net/ppp/pppoe.c                                               |    1 
 drivers/net/vmxnet3/vmxnet3_drv.c                                     |    6 
 drivers/nvme/host/core.c                                              |    1 
 drivers/nvme/host/multipath.c                                         |   25 
 drivers/nvme/host/nvme.h                                              |    4 
 drivers/nvme/host/pci.c                                               |    5 
 drivers/nvme/target/admin-cmd.c                                       |    2 
 drivers/nvme/target/configfs.c                                        |    2 
 drivers/nvme/target/core.c                                            |   24 
 drivers/nvme/target/fc.c                                              |    8 
 drivers/nvme/target/fcloop.c                                          |   16 
 drivers/nvme/target/io-cmd-file.c                                     |    6 
 drivers/nvme/target/loop.c                                            |    4 
 drivers/nvme/target/nvmet.h                                           |    1 
 drivers/nvme/target/passthru.c                                        |    2 
 drivers/nvme/target/rdma.c                                            |   12 
 drivers/nvme/target/tcp.c                                             |   10 
 drivers/pci/controller/pci-aardvark.c                                 |   48 -
 drivers/pci/pci.c                                                     |   10 
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c                            |   14 
 drivers/pinctrl/mediatek/pinctrl-mt8365.c                             |    2 
 drivers/pinctrl/pinctrl-ocelot.c                                      |    4 
 drivers/platform/chrome/cros_ec_debugfs.c                             |   12 
 drivers/platform/surface/surface_gpe.c                                |    8 
 drivers/platform/x86/intel/pmt/telemetry.c                            |    2 
 drivers/platform/x86/thinkpad_acpi.c                                  |   49 +
 drivers/ptp/ptp_ocp.c                                                 |    5 
 drivers/rtc/class.c                                                   |    9 
 drivers/rtc/rtc-mc146818-lib.c                                        |   16 
 drivers/rtc/rtc-pcf2127.c                                             |    3 
 drivers/rtc/rtc-sun6i.c                                               |   14 
 drivers/scsi/device_handler/scsi_dh_alua.c                            |    3 
 drivers/scsi/qla2xxx/qla_target.c                                     |    3 
 drivers/scsi/ufs/ufshpb.c                                             |   19 
 drivers/usb/gadget/legacy/raw_gadget.c                                |    2 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                                     |   61 -
 drivers/vhost/net.c                                                   |   15 
 drivers/vhost/vdpa.c                                                  |    5 
 drivers/video/fbdev/core/fbmem.c                                      |    5 
 drivers/video/fbdev/core/fbsysfs.c                                    |    4 
 drivers/watchdog/sp5100_tco.c                                         |  334 ++++++----
 drivers/watchdog/sp5100_tco.h                                         |    7 
 fs/afs/inode.c                                                        |   14 
 fs/cifs/cifs_debug.c                                                  |    2 
 fs/cifs/cifsfs.c                                                      |    4 
 fs/cifs/cifsglob.h                                                    |   18 
 fs/cifs/cifssmb.c                                                     |   11 
 fs/cifs/connect.c                                                     |   32 
 fs/cifs/misc.c                                                        |    2 
 fs/cifs/smb2pdu.c                                                     |    4 
 fs/gfs2/file.c                                                        |    4 
 fs/gfs2/glock.c                                                       |   10 
 fs/gfs2/inode.c                                                       |   49 -
 fs/ioctl.c                                                            |    2 
 fs/nilfs2/btnode.c                                                    |   23 
 fs/nilfs2/btnode.h                                                    |    1 
 fs/nilfs2/btree.c                                                     |   27 
 fs/nilfs2/dat.c                                                       |    4 
 fs/nilfs2/gcinode.c                                                   |    7 
 fs/nilfs2/inode.c                                                     |  159 ++++
 fs/nilfs2/mdt.c                                                       |   43 -
 fs/nilfs2/mdt.h                                                       |    6 
 fs/nilfs2/nilfs.h                                                     |   16 
 fs/nilfs2/page.c                                                      |    7 
 fs/nilfs2/segment.c                                                   |    9 
 fs/nilfs2/super.c                                                     |    5 
 include/linux/audit.h                                                 |    2 
 include/linux/ceph/osd_client.h                                       |    3 
 include/linux/ioport.h                                                |    2 
 include/linux/mc146818rtc.h                                           |    2 
 include/linux/netdevice.h                                             |    2 
 include/linux/security.h                                              |    2 
 include/net/ip.h                                                      |    1 
 include/net/netns/xfrm.h                                              |    6 
 include/net/xfrm.h                                                    |   58 -
 include/uapi/linux/dma-buf.h                                          |    4 
 kernel/auditsc.c                                                      |    6 
 kernel/debug/debug_core.c                                             |   24 
 kernel/debug/kdb/kdb_main.c                                           |   62 +
 kernel/events/core.c                                                  |   14 
 net/bridge/br_input.c                                                 |    7 
 net/ceph/osd_client.c                                                 |  302 +++------
 net/core/dev.c                                                        |    2 
 net/core/skbuff.c                                                     |    4 
 net/ipv4/route.c                                                      |   23 
 net/key/af_key.c                                                      |    6 
 net/mac80211/rx.c                                                     |    3 
 net/mptcp/options.c                                                   |   36 -
 net/mptcp/pm.c                                                        |    5 
 net/mptcp/protocol.h                                                  |   16 
 net/mptcp/subflow.c                                                   |   14 
 net/netfilter/nf_flow_table_core.c                                    |   80 --
 net/netfilter/nf_flow_table_ip.c                                      |   19 
 net/netfilter/nft_flow_offload.c                                      |   28 
 net/nfc/nci/data.c                                                    |    2 
 net/nfc/nci/hci.c                                                     |    4 
 net/sched/act_pedit.c                                                 |    4 
 net/wireless/nl80211.c                                                |   18 
 net/wireless/scan.c                                                   |    2 
 net/xfrm/xfrm_policy.c                                                |   10 
 net/xfrm/xfrm_user.c                                                  |   43 -
 scripts/kconfig/confdata.c                                            |    2 
 security/security.c                                                   |    2 
 security/selinux/ss/hashtab.c                                         |    3 
 sound/isa/wavefront/wavefront_synth.c                                 |    3 
 sound/pci/hda/patch_realtek.c                                         |   17 
 sound/usb/quirks-table.h                                              |    9 
 tools/build/Makefile.feature                                          |    1 
 tools/build/feature/Makefile                                          |    4 
 tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c         |    7 
 tools/perf/Makefile.config                                            |    7 
 tools/perf/arch/x86/util/perf_regs.c                                  |   12 
 tools/perf/bench/numa.c                                               |    2 
 tools/perf/tests/bpf.c                                                |   10 
 tools/perf/tests/shell/stat_all_pmu.sh                                |   10 
 tools/perf/util/bpf-event.c                                           |    4 
 tools/perf/util/stat.c                                                |   17 
 tools/testing/selftests/net/fcnal-test.sh                             |   12 
 tools/virtio/Makefile                                                 |    3 
 virt/kvm/kvm_main.c                                                   |    2 
 204 files changed, 2185 insertions(+), 1147 deletions(-)

Aaron Lewis (1):
      kvm: x86/pmu: Fix the compare function used by the pmu event filter

Al Viro (1):
      Fix double fget() in vhost_net_set_backend()

Alex Elder (2):
      net: ipa: certain dropped packets aren't accounted for
      net: ipa: record proper RX transaction count

Andre Przywara (1):
      rtc: sun6i: Fix time overflow handling

Andreas Gruenbacher (3):
      gfs2: cancel timed-out glock requests
      gfs2: Switch lock order of inode and iopen glock
      gfs2: Disable page faults during lockless buffered reads

Andrew Lunn (1):
      net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.

Anton Eidelman (1):
      nvme-multipath: fix hang when disk goes live over reconnect

Anusha Srivatsa (1):
      drm/i915/dmc: Add MMIO range restrictions

Ard Biesheuvel (2):
      ARM: 9196/1: spectre-bhb: enable for Cortex-A15
      ARM: 9197/1: spectre-bhb: fix loop8 sequence for Thumb2

Arkadiusz Kubalewski (1):
      ice: fix crash when writing timestamp on RX rings

Arnaldo Carvalho de Melo (1):
      perf build: Fix check for btf__load_from_kernel_by_id() in libbpf

Athira Rajeev (2):
      perf test: Fix "all PMU test" to skip hv_24x7/hv_gpci tests on powerpc
      perf test bpf: Skip test if clang is not present

Aya Levin (1):
      net/mlx5e: Block rx-gro-hw feature in switchdev mode

Bart Van Assche (1):
      block/mq-deadline: Set the fifo_time member also if inserting at head

Brian Bunker (1):
      scsi: scsi_dh_alua: Properly handle the ALUA transitioning state

Catalin Marinas (1):
      arm64: mte: Ensure the cleared tags are visible before setting the PTE

Charan Teja Kalla (1):
      dma-buf: ensure unique directory name for dmabuf stats

Christophe JAILLET (2):
      net: systemport: Fix an error handling path in bcm_sysport_probe()
      net/qla3xxx: Fix a test in ql_reset_work()

Codrin Ciubotariu (1):
      clk: at91: generated: consider range when calculating best rate

Daejun Park (1):
      scsi: ufs: core: Fix referencing invalid rsp field

Daniel Thompson (1):
      lockdown: also lock down previous kgdb use

Daniel Vetter (1):
      fbdev: Prevent possible use-after-free in fb_release()

David Gow (1):
      um: Cleanup syscall_handler_t definition/cast, fix warning

David Howells (1):
      afs: Fix afs_getattr() to refetch file status if callback break occurred

Dmitry Baryshkov (1):
      arm64: dts: qcom: sm8250: don't enable rx/tx macro by default

Duoming Zhou (1):
      NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc

Eli Cohen (1):
      vdpa/mlx5: Use consistent RQT size

Eric Yang (1):
      drm/amd/display: undo clearing of z10 related function pointers

Eyal Birger (1):
      xfrm: fix "disable_policy" flag use when arriving from different devices

Felix Fietkau (5):
      netfilter: flowtable: fix excessive hw offload attempts after failure
      netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices
      net: fix dev_fill_forward_path with pppoe + bridge
      netfilter: nft_flow_offload: fix offload with pppoe + vlan
      mac80211: fix rx reordering with non explicit / psmp ack policy

Gal Pressman (1):
      net/mlx5e: Remove HW-GRO from reported features

Gleb Chesnokov (1):
      scsi: qla2xxx: Fix missed DMA unmap for aborted commands

Grant Grundler (4):
      net: atlantic: fix "frag[0] not initialized"
      net: atlantic: reduce scope of is_rsc_complete
      net: atlantic: add check for MAX_SKB_FRAGS
      net: atlantic: verify hw_head_ lies within TX buffer ring

Greg Kroah-Hartman (1):
      Linux 5.17.10

Greg Thelen (1):
      Revert "drm/i915/opregion: check port number bounds for SWSCI display power state"

Guo Xuenan (1):
      fs: fix an infinite loop in iomap_fiemap

Haibo Chen (1):
      gpio: gpio-vf610: do not touch other bits when set the target bit

Hangyu Hua (1):
      drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

Harini Katakam (1):
      net: macb: Increment rx bd head after allocating skb and buffer

Heiko Carstens (1):
      s390/traps: improve panic message for translation-specification exception

Horatiu Vultur (2):
      pinctrl: ocelot: Fix for lan966x alt mode
      net: lan966x: Fix assignment of the MAC address

Howard Chiu (1):
      ARM: dts: aspeed: Add video engine to g6

Hugo Villeneuve (1):
      rtc: pcf2127: fix bug when reading alarm registers

Ian Rogers (1):
      perf stat: Fix and validate CPU map inputs in synthetic PERF_RECORD_STAT events

Ilya Dryomov (1):
      libceph: fix potential use-after-free on linger ping and resends

Jae Hyun Yoo (4):
      ARM: dts: aspeed-g6: remove FWQSPID group in pinctrl dtsi
      pinctrl: pinctrl-aspeed-g6: remove FWQSPID group in pinctrl
      ARM: dts: aspeed-g6: fix SPI1/SPI2 quad pin group
      dt-bindings: pinctrl: aspeed-g6: remove FWQSPID group

Jakob Koschel (1):
      drbd: remove usage of list iterator variable after loop

Jarkko Nikula (1):
      Revert "can: m_can: pci: use custom bit timings for Elkhart Lake"

Javier Martinez Canillas (1):
      Revert "fbdev: Make fb_release() return -ENODEV if fbdev was unregistered"

Jeff LaBundy (1):
      Input: add bounds checking to input_set_capability()

Jiasheng Jiang (1):
      net: af_key: add check for pfkey_broadcast in function pfkey_process

Johannes Berg (1):
      nl80211: fix locking in nl80211_set_tx_bitrate_mask()

Jonathan Lemon (1):
      ptp: ocp: have adjtime handle negative delta_ns correctly

Julian Orth (1):
      audit,io_uring,io-wq: call __audit_uring_exit for dummy contexts

Jérôme Pouiller (1):
      dma-buf: fix use of DMA_BUF_SET_NAME_{A,B} in userspace

Kai-Heng Feng (1):
      ALSA: hda/realtek: Enable headset mic on Lenovo P360

Kan Liang (1):
      perf regs x86: Fix arch__intr_reg_mask() for the hybrid platform

Kevin Mitchell (1):
      igb: skip phy status check where unavailable

Kieran Frewen (2):
      nl80211: validate S1G channel width
      cfg80211: retrieve S1G operating channel number

Krzysztof Kozlowski (1):
      riscv: dts: sifive: fu540-c000: align dma node name with dtschema

Lina Wang (1):
      net: fix wrong network header length

Maor Dickman (1):
      net/mlx5: DR, Fix missing flow_source when creating multi-destination FW table

Marc Zyngier (1):
      KVM: arm64: vgic-v3: Consistently populate ID_AA64PFR0_EL1.GIC

Marek Vasut (1):
      Input: ili210x - fix reset timing

Mario Limonciello (3):
      rtc: mc146818-lib: Fix the AltCentury for AMD platforms
      drm/amd: Don't reset dGPUs if the system is going to s2idle
      platform/x86: thinkpad_acpi: Convert btusb DMI list to quirks

Mark Pearson (1):
      platform/x86: thinkpad_acpi: Correct dual fan probe

Mark Rutland (1):
      arm64: kexec: load from kimage prior to clobbering

Masahiro Yamada (1):
      kconfig: add fflush() before ferror() check

Mattijs Korpershoek (1):
      pinctrl: mediatek: mt8365: fix IES control pins

Maxim Mikityanskiy (2):
      net/mlx5e: Properly block LRO when XDP is enabled
      net/mlx5e: Properly block HW GRO when XDP is enabled

Maximilian Luz (1):
      platform/surface: gpe: Add support for Surface Pro 8

Michael S. Tsirkin (1):
      tools/virtio: compile with -pthread

Michal Wilczynski (1):
      ice: Fix interrupt moderation settings getting cleared

Monish Kumar R (1):
      nvme-pci: add quirks for Samsung X5 SSDs

Nicolas Dichtel (2):
      xfrm: rework default policy structure
      selftests: add ping test with ping_group_range tuned

Niklas Schnelle (1):
      s390/pci: improve zpci_dev reference counting

Ondrej Mosnacek (2):
      selinux: fix bad cleanup on error in hashtab_duplicate()
      crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ

Pablo Neira Ayuso (2):
      netfilter: flowtable: fix TCP flow teardown
      netfilter: flowtable: pass flowtable to nf_flow_table_iterate()

Pali Rohár (1):
      Revert "PCI: aardvark: Rewrite IRQ code to chained IRQ handler"

Paolo Abeni (3):
      mptcp: fix subflow accounting on close
      net/sched: act_pedit: sanitize shift argument before usage
      mptcp: fix checksum byte order

Paul Greenwalt (1):
      ice: fix possible under reporting of ethtool Tx and Rx statistics

Peter Zijlstra (2):
      crypto: x86/chacha20 - Avoid spurious jumps to other functions
      perf: Fix sys_perf_event_open() race against self

Prakruthi Deepak Heragu (1):
      arm64: paravirt: Use RCU read locks to guard stolen_time

Prarit Bhargava (1):
      platform/x86/intel: Fix 'rmmod pmt_telemetry' panic

Rafael J. Wysocki (1):
      PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold

Randy Dunlap (1):
      ALSA: hda - fix unused Realtek function when PM is not enabled

Ritaro Takenaka (1):
      netfilter: flowtable: move dst_check to packet path

Ryusuke Konishi (2):
      nilfs2: fix lockdep warnings in page operations for btree nodes
      nilfs2: fix lockdep warnings during disk space reclamation

Sagi Grimberg (1):
      nvmet: use a private workqueue instead of the system workqueue

Schspa Shi (1):
      usb: gadget: fix race when gadget driver register via ioctl

Sean Christopherson (2):
      KVM: x86/mmu: Update number of zapped pages even if page list is stable
      KVM: Free new dirty bitmap if creating a new memslot fails

Shay Drory (2):
      net/mlx5: Initialize flow steering during driver probe
      net/mlx5: Drain fw_reset when removing device

Shreyas K K (1):
      arm64: Enable repeat tlbi workaround on KRYO4XX gold CPUs

Steve French (1):
      smb3: cleanup and clarify status of tree connections

Takashi Iwai (2):
      ALSA: usb-audio: Restore Rane SL-1 quirk
      ALSA: wavefront: Proper check of get_user() error

Terry Bowman (13):
      kernel/resource: Introduce request_mem_region_muxed()
      i2c: piix4: Replace hardcoded memory map size with a #define
      i2c: piix4: Move port I/O region request/release code into functions
      i2c: piix4: Move SMBus controller base address detect into function
      i2c: piix4: Move SMBus port selection into function
      i2c: piix4: Add EFCH MMIO support to region request and release
      i2c: piix4: Add EFCH MMIO support to SMBus base address detect
      i2c: piix4: Add EFCH MMIO support for SMBus port select
      i2c: piix4: Enable EFCH MMIO for Family 17h+
      Watchdog: sp5100_tco: Move timer initialization into function
      Watchdog: sp5100_tco: Refactor MMIO base address initialization
      Watchdog: sp5100_tco: Add initialization using EFCH MMIO
      Watchdog: sp5100_tco: Enable Family 17h+ CPUs

Thomas Richter (1):
      perf bench numa: Address compiler error on s390

Tzung-Bi Shih (1):
      platform/chrome: cros_ec_debugfs: detach log reader wq from devm

Ulf Hansson (1):
      mmc: core: Fix busy polling for MMC_SEND_OP_COND again

Umesh Nerlige Ramappa (1):
      i915/guc/reset: Make __guc_reset_context aware of guilty engines

Uwe Kleine-König (1):
      gpio: mvebu/pwm: Refuse requests with inverted polarity

Vincent Whitchurch (1):
      rtc: fix use-after-free on device removal

Werner Sembach (1):
      ALSA: hda/realtek: Add quirk for TongFang devices with pop noise

Willy Tarreau (1):
      floppy: use a statically allocated error counter

Xiaoke Wang (1):
      MIPS: lantiq: check the return value of kzalloc()

Yang Yingliang (3):
      ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()
      net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()
      i2c: mt7621: fix missing clk_disable_unprepare() on error in mtk_i2c_probe()

Yevgeny Kliteynik (1):
      net/mlx5: DR, Ignore modify TTL on RX if device doesn't support it

Zheng Yongjun (2):
      Input: stmfts - fix reference leak in stmfts_input_open
      crypto: stm32 - fix reference leak in stm32_crc_remove

Zhu Lingshan (1):
      vhost_vdpa: don't setup irq offloading when irq_num < 0

Zixuan Fu (2):
      net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
      net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

linyujun (1):
      ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()

