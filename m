Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B305B97FB
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 11:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiIOJsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 05:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiIOJrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 05:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E819A956;
        Thu, 15 Sep 2022 02:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C917E61353;
        Thu, 15 Sep 2022 09:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0FAC4314E;
        Thu, 15 Sep 2022 09:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663235212;
        bh=THgkhgrIvXNzpfMwkk5eW5YPSW00zXrEGgDkc13YD7s=;
        h=From:To:Cc:Subject:Date:From;
        b=lA2Rde4ujl4tOjCwHqayDv2Wp/UzqWlM3iOEp+bzxeHszGjK8yP8oYCpwWlWyckSP
         FnUIfM718rBobRIZ6mXNHt/cH6i8n48H5u1jcdgbeyNiykrewz5FXj/63y8l6dAXXS
         5CuNZ6IW6D8RSOSZq7cpwMfN55CunAcZ4QcjPS1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.143
Date:   Thu, 15 Sep 2022 11:47:14 +0200
Message-Id: <166323523495191@kroah.com>
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

I'm announcing the release of the 5.10.143 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.rst                |    2 
 Makefile                                              |    2 
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi           |   21 ++--
 arch/arm/boot/dts/at91-sama5d2_icp.dts                |   21 ++--
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi         |   10 --
 arch/arm64/Kconfig                                    |   18 +++
 arch/arm64/include/asm/cpucaps.h                      |    3 
 arch/arm64/kernel/cacheinfo.c                         |    6 +
 arch/arm64/kernel/cpu_errata.c                        |    9 +
 arch/arm64/kernel/cpufeature.c                        |    5 -
 arch/mips/loongson32/ls1c/board.c                     |    1 
 arch/parisc/kernel/head.S                             |   43 ++++++++-
 drivers/block/xen-blkfront.c                          |   14 +-
 drivers/firmware/efi/capsule-loader.c                 |   31 +-----
 drivers/firmware/efi/libstub/Makefile                 |    7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c               |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c              |    2 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                 |    3 
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c               |    1 
 drivers/gpu/drm/drm_gem.c                             |   17 ---
 drivers/gpu/drm/drm_internal.h                        |    4 
 drivers/gpu/drm/drm_prime.c                           |   20 ++--
 drivers/gpu/drm/i915/display/intel_dp_link_training.c |   22 ++++
 drivers/gpu/drm/radeon/radeon_device.c                |    3 
 drivers/hwmon/mr75203.c                               |   72 ++++++++++-----
 drivers/infiniband/core/cma.c                         |    4 
 drivers/infiniband/core/umem_odp.c                    |    2 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h            |    2 
 drivers/infiniband/hw/hns/hns_roce_qp.c               |    7 -
 drivers/infiniband/hw/mlx5/mad.c                      |    6 +
 drivers/infiniband/sw/siw/siw_qp_tx.c                 |   18 ++-
 drivers/iommu/amd/iommu.c                             |    3 
 drivers/net/ethernet/intel/i40e/i40e_client.c         |    5 -
 drivers/net/ethernet/intel/ice/ice_main.c             |    2 
 drivers/net/wireless/intel/iwlegacy/4965-rs.c         |    5 -
 drivers/net/xen-netback/xenbus.c                      |    2 
 drivers/nvme/host/tcp.c                               |    7 -
 drivers/nvme/target/core.c                            |    6 -
 drivers/parisc/ccio-dma.c                             |   11 +-
 drivers/regulator/core.c                              |    9 +
 drivers/scsi/lpfc/lpfc_init.c                         |    5 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c           |    1 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                  |    2 
 drivers/scsi/qla2xxx/qla_target.c                     |   10 --
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                   |   50 ++++++++--
 drivers/tee/tee_shm.c                                 |    1 
 drivers/tty/n_gsm.c                                   |   46 ++++-----
 drivers/video/fbdev/chipsfb.c                         |    1 
 fs/afs/flock.c                                        |    2 
 fs/afs/fsclient.c                                     |    2 
 fs/afs/internal.h                                     |    3 
 fs/afs/rxrpc.c                                        |    7 -
 fs/afs/yfsclient.c                                    |    3 
 fs/cifs/smb2file.c                                    |    1 
 fs/cifs/smb2ops.c                                     |   45 +++------
 fs/cifs/smb2pdu.c                                     |   20 +---
 fs/cifs/smb2proto.h                                   |    4 
 fs/debugfs/inode.c                                    |   22 ++++
 fs/nfsd/vfs.c                                         |    4 
 include/linux/buffer_head.h                           |   11 ++
 include/linux/debugfs.h                               |    6 +
 kernel/cgroup/cgroup.c                                |   85 +++++++++++++-----
 kernel/cgroup/cpuset.c                                |    3 
 kernel/dma/swiotlb.c                                  |    5 -
 kernel/fork.c                                         |    1 
 kernel/kprobes.c                                      |    1 
 mm/kmemleak.c                                         |    8 -
 net/bridge/br_netfilter_hooks.c                       |    2 
 net/bridge/br_netfilter_ipv6.c                        |    1 
 net/core/skbuff.c                                     |    5 -
 net/ipv4/tcp_input.c                                  |   25 +++--
 net/ipv6/seg6.c                                       |    5 +
 net/netfilter/nf_conntrack_irc.c                      |    5 -
 net/netfilter/nf_tables_api.c                         |    4 
 net/rxrpc/rxkad.c                                     |    2 
 net/sched/sch_sfb.c                                   |   13 +-
 net/tipc/monitor.c                                    |    2 
 sound/drivers/aloop.c                                 |    7 -
 sound/pci/emu10k1/emupcm.c                            |    2 
 sound/soc/atmel/mchp-spdiftx.c                        |   10 --
 sound/usb/card.c                                      |    2 
 sound/usb/quirks.c                                    |    2 
 sound/usb/stream.c                                    |    9 +
 83 files changed, 554 insertions(+), 320 deletions(-)

Andrew Halaney (1):
      regulator: core: Clean up on enable failure

Ard Biesheuvel (1):
      efi: libstub: Disable struct randomization

Bart Van Assche (1):
      nvmet: fix a use-after-free

Candice Li (1):
      drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.

Chao Gao (1):
      swiotlb: avoid potential left shift overflow

Chengchang Tang (1):
      RDMA/hns: Fix supported page size

Chris Mi (1):
      RDMA/mlx5: Set local port to one when accessing counters

Christian A. Ehrhardt (1):
      kprobes: Prohibit probes in gate area

Chuck Lever (1):
      NFSD: Fix verifier returned in stable WRITEs

Claudiu Beznea (5):
      ARM: dts: at91: sama5d27_wlsom1: specify proper regulator output ranges
      ARM: dts: at91: sama5d2_icp: specify proper regulator output ranges
      ARM: dts: at91: sama5d27_wlsom1: don't keep ldo2 enabled all the time
      ARM: dts: at91: sama5d2_icp: don't keep vdd_other enabled all the time
      ASoC: mchp-spdiftx: remove references to mchp_i2s_caps

Dan Carpenter (1):
      tipc: fix shift wrapping bug in map_get()

David Howells (3):
      smb3: missing inode locks in punch hole
      rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()
      afs: Use the operation issue time instead of the reply time for callbacks

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Fix forged IP logic

David Lebrun (1):
      ipv6: sr: fix out-of-bounds read when setting HMAC data.

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

Fedor Pchelkin (1):
      tty: n_gsm: avoid call of sleeping functions from atomic context

Greg Kroah-Hartman (2):
      debugfs: add debugfs_lookup_and_remove()
      Linux 5.10.143

Guixin Liu (1):
      scsi: megaraid_sas: Fix double kfree()

Harsh Modi (1):
      netfilter: br_netfilter: Drop dst references before setting.

Helge Deller (1):
      parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Hyunwoo Kim (1):
      efi: capsule-loader: Fix use-after-free in efi_capsule_write

Ionela Voinescu (1):
      arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly

Ivan Vecera (1):
      i40e: Fix kernel crash during module removal

Jeffy Chen (1):
      drm/gem: Fix GEM handle release errors

Jens Wiklander (1):
      tee: fix compiler warning in tee_shm_register()

John Sperbeck (1):
      iommu/amd: use full 64-bit value in build_completion_wait()

Li Qiong (1):
      parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Liang He (1):
      soc: brcmstb: pm-arm: Fix refcount leak and __iomem leak bugs

Linus Torvalds (1):
      fs: only do a memory barrier for the first set_buffer_uptodate()

Linus Walleij (1):
      RDMA/siw: Pass a pointer to virt_to_page()

Marco Felsch (1):
      ARM: dts: imx6qdl-kontron-samx6i: remove duplicated node

Michael Guralnik (1):
      RDMA/cma: Fix arguments order in net device validation

Michal Swiatkowski (1):
      ice: use bitmap_free instead of devm_kfree

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

Qu Huang (1):
      drm/amdgpu: mmVM_L2_CNTL3 register not initialized correctly

Sagi Grimberg (2):
      nvme-tcp: fix UAF when detecting digest errors
      nvme-tcp: fix regression that causes sporadic requests to time out

SeongJae Park (1):
      xen-blkfront: Cache feature_persistent value before advertisement

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix use-after-free warning

Stanislaw Gruszka (1):
      wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

Sudeep Holla (1):
      arm64: cacheinfo: Fix incorrect assignment of signed error value to unsigned fw_level

Takashi Iwai (2):
      ALSA: usb-audio: Inform the delayed registration more properly
      ALSA: usb-audio: Register card again for iface over delayed_register option

Tasos Sahanidis (1):
      ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Tejun Heo (2):
      cgroup: Elide write-locking threadgroup_rwsem when updating csses on an empty subtree
      cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Tetsuo Handa (1):
      tty: n_gsm: initialize more members at gsm_alloc_mux()

Toke Høiland-Jørgensen (2):
      sch_sfb: Don't assume the skb is still around after enqueueing to child
      sch_sfb: Also store skb len before calling child enqueue

Tony Battersby (1):
      scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX

Ville Syrjälä (1):
      drm/i915: Implement WaEdpLinkRateDataReload

Wenpeng Liang (1):
      RDMA/hns: Fix wrong fixed value of qp->rq.wqe_shift

Yang Ling (1):
      MIPS: loongson32: ls1c: Fix hang during startup

Yang Yingliang (2):
      fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()
      scsi: lpfc: Add missing destroy_workqueue() in error path

Yee Lee (1):
      Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

YiPeng Chai (1):
      drm/amdgpu: Move psp_xgmi_terminate call from amdgpu_xgmi_remove_device to psp_hw_fini

Yishai Hadas (1):
      IB/core: Fix a nested dead lock as part of ODP flow

Zhenneng Li (1):
      drm/radeon: add a force flush to delay work when radeon

lily (1):
      net/core/skbuff: Check the return value of skb_copy_bits()

