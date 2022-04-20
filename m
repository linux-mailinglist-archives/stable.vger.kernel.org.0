Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F4D508263
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 09:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355269AbiDTHk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 03:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376269AbiDTHkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 03:40:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4889F1B7AD;
        Wed, 20 Apr 2022 00:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDC08B81D6B;
        Wed, 20 Apr 2022 07:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C45C385A0;
        Wed, 20 Apr 2022 07:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650440266;
        bh=akwbacdI4GJ7ABrRjv2MexMbIUH4jSnKpRWC2Fxd5t4=;
        h=From:To:Cc:Subject:Date:From;
        b=0ki8xsaD9mNOTUYQfEuPcAq6Qgewhu8wYwM1/iriJ6n0XciAAXAzd1igswmhe8jfX
         TU0E9NGqgLhTSTelKqvntyeWtQCFNwCN7CQU0eldMhJr41wMQfN3+IGKJyarC0J6b0
         JZ6aZJrRLaY28D+bVzzoI3bThPHfwQclhFwFgPeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.112
Date:   Wed, 20 Apr 2022 09:37:42 +0200
Message-Id: <1650440263166125@kroah.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.112 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    2 
 arch/arm/mach-davinci/board-da850-evm.c                       |    4 
 arch/arm64/kernel/alternative.c                               |    6 
 arch/arm64/kernel/cpuidle.c                                   |    6 
 arch/x86/include/asm/kvm_host.h                               |    5 
 arch/x86/kvm/mmu/mmu.c                                        |   20 
 arch/x86/kvm/x86.c                                            |   20 
 drivers/acpi/processor_idle.c                                 |   15 
 drivers/ata/libata-core.c                                     |    3 
 drivers/firmware/arm_scmi/clock.c                             |    3 
 drivers/gpio/gpiolib-acpi.c                                   |    4 
 drivers/gpu/drm/amd/amdgpu/ObjectID.h                         |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c              |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                       |    2 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c                         |    3 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                       |   11 
 drivers/gpu/drm/amd/amdkfd/kfd_events.c                       |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c             |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c             |    4 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c     |   14 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c            |   14 
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c |    5 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                         |    2 
 drivers/gpu/drm/msm/dsi/dsi_manager.c                         |    2 
 drivers/gpu/drm/msm/msm_gem.c                                 |    1 
 drivers/gpu/ipu-v3/ipu-di.c                                   |    5 
 drivers/hv/ring_buffer.c                                      |   11 
 drivers/i2c/busses/i2c-pasemi.c                               |    6 
 drivers/infiniband/ulp/iser/iscsi_iser.c                      |    2 
 drivers/md/dm-historical-service-time.c                       |   10 
 drivers/md/dm-integrity.c                                     |    7 
 drivers/media/platform/rockchip/rga/rga.c                     |    2 
 drivers/memory/atmel-ebi.c                                    |   23 
 drivers/memory/renesas-rpc-if.c                               |   10 
 drivers/net/dsa/ocelot/felix_vsc9959.c                        |    2 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                |    4 
 drivers/net/ethernet/mellanox/mlxsw/i2c.c                     |    1 
 drivers/net/ethernet/micrel/Kconfig                           |    1 
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c              |    6 
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c            |    8 
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h            |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c           |   13 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c             |   13 
 drivers/net/hamradio/6pack.c                                  |    5 
 drivers/net/mdio/mdio-bcm-unimac.c                            |   16 
 drivers/net/mdio/mdio-bitbang.c                               |    4 
 drivers/net/mdio/mdio-cavium.c                                |    2 
 drivers/net/mdio/mdio-gpio.c                                  |   10 
 drivers/net/mdio/mdio-ipq4019.c                               |    4 
 drivers/net/mdio/mdio-ipq8064.c                               |    4 
 drivers/net/mdio/mdio-mscc-miim.c                             |    8 
 drivers/net/mdio/mdio-mux-bcm-iproc.c                         |   10 
 drivers/net/mdio/mdio-mux-gpio.c                              |    8 
 drivers/net/mdio/mdio-mux-mmioreg.c                           |    6 
 drivers/net/mdio/mdio-mux-multiplexer.c                       |    2 
 drivers/net/mdio/mdio-mux.c                                   |    6 
 drivers/net/mdio/mdio-octeon.c                                |    8 
 drivers/net/mdio/mdio-thunder.c                               |   10 
 drivers/net/mdio/mdio-xgene.c                                 |    6 
 drivers/net/mdio/of_mdio.c                                    |   10 
 drivers/net/slip/slip.c                                       |    2 
 drivers/net/usb/aqc111.c                                      |    9 
 drivers/net/veth.c                                            |    2 
 drivers/net/wireless/ath/ath9k/main.c                         |    2 
 drivers/net/wireless/ath/ath9k/xmit.c                         |   33 
 drivers/perf/fsl_imx8_ddr_perf.c                              |    2 
 drivers/regulator/wm8994-regulator.c                          |   42 
 drivers/scsi/be2iscsi/be_iscsi.c                              |   19 
 drivers/scsi/be2iscsi/be_main.c                               |    1 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                              |   24 
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                            |    1 
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                            |    1 
 drivers/scsi/cxgbi/libcxgbi.c                                 |   12 
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c                      |    2 
 drivers/scsi/libiscsi.c                                       |   70 +
 drivers/scsi/lpfc/lpfc_init.c                                 |    2 
 drivers/scsi/megaraid/megaraid_sas.h                          |    3 
 drivers/scsi/megaraid/megaraid_sas_base.c                     |    7 
 drivers/scsi/mvsas/mv_init.c                                  |    1 
 drivers/scsi/pm8001/pm80xx_hwi.c                              |   33 
 drivers/scsi/qedi/qedi_iscsi.c                                |   26 
 drivers/scsi/qla4xxx/ql4_os.c                                 |    2 
 drivers/scsi/scsi_transport_iscsi.c                           |  541 ++++++----
 drivers/target/target_core_user.c                             |    3 
 fs/btrfs/block-group.c                                        |    4 
 fs/btrfs/disk-io.c                                            |    5 
 fs/btrfs/file.c                                               |   13 
 fs/btrfs/inode.c                                              |    1 
 fs/btrfs/volumes.c                                            |    2 
 fs/cifs/link.c                                                |    3 
 include/asm-generic/tlb.h                                     |   10 
 include/net/ax25.h                                            |   12 
 include/net/flow_dissector.h                                  |    2 
 include/scsi/libiscsi.h                                       |    1 
 include/scsi/scsi_transport_iscsi.h                           |   14 
 include/trace/events/sunrpc.h                                 |    7 
 kernel/dma/direct.h                                           |    3 
 kernel/irq/affinity.c                                         |    5 
 kernel/smp.c                                                  |    2 
 kernel/time/tick-sched.c                                      |    2 
 kernel/time/timer.c                                           |   11 
 mm/kmemleak.c                                                 |    8 
 mm/page_alloc.c                                               |    2 
 mm/page_io.c                                                  |   54 
 net/ax25/af_ax25.c                                            |   38 
 net/ax25/ax25_dev.c                                           |   28 
 net/ax25/ax25_route.c                                         |   13 
 net/ax25/ax25_subr.c                                          |   20 
 net/core/flow_dissector.c                                     |    1 
 net/ipv6/ip6_output.c                                         |    2 
 net/nfc/nci/core.c                                            |    4 
 net/sched/cls_api.c                                           |    2 
 net/sched/cls_flower.c                                        |   18 
 net/sched/sch_taprio.c                                        |    3 
 net/sctp/socket.c                                             |    2 
 net/smc/smc_pnet.c                                            |    5 
 net/wireless/nl80211.c                                        |    3 
 net/wireless/scan.c                                           |    2 
 scripts/gcc-plugins/latent_entropy_plugin.c                   |   44 
 sound/core/pcm_misc.c                                         |    2 
 sound/pci/hda/patch_realtek.c                                 |    2 
 tools/perf/util/parse-events.c                                |    5 
 tools/testing/selftests/mqueue/mq_perf_tests.c                |   25 
 124 files changed, 1053 insertions(+), 578 deletions(-)

Adrian Hunter (1):
      perf tools: Fix misleading add event PMU debug message

Ajish Koshy (2):
      scsi: pm80xx: Mask and unmask upper interrupt vectors 32-63
      scsi: pm80xx: Enable upper inbound, outbound queues

Alexey Galakhov (1):
      scsi: mvsas: Add PCI ID of RocketRaid 2640

Andy Chiu (1):
      net: axienet: setup mdio unconditionally

Anna-Maria Behnsen (1):
      timers: Fix warning condition in __run_timers()

Athira Rajeev (1):
      testing/selftests/mqueue: Fix mq_perf_tests to free the allocated cpu set

Aurabindo Pillai (1):
      drm/amd: Add USBC connector ID

Benedikt Spranger (1):
      net/sched: taprio: Check if socket flags are valid

Borislav Petkov (1):
      perf/imx_ddr: Fix undefined behavior due to shift overflowing the constant

Calvin Johnson (1):
      net: mdio: Alphabetically sort header inclusion

Chandrakanth patil (1):
      scsi: megaraid_sas: Target with invalid LUN ID is deleted during scan

Chao Gao (1):
      dma-direct: avoid redundant memory sync for swiotlb

Charlene Liu (1):
      drm/amd/display: fix audio format not updated after edid updated

Chiawen Huang (1):
      drm/amd/display: FEC check in timing validation

Christian Lamparter (1):
      ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs

Chuck Lever (1):
      SUNRPC: Fix the svc_deferred_event trace class

Cristian Marussi (1):
      firmware: arm_scmi: Fix sorting of retrieved clock rates

Darrick J. Wong (1):
      btrfs: fix fallocate to use file_modified to update permissions consistently

Dinh Nguyen (1):
      net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link

Duoming Zhou (9):
      drivers: net: slip: fix NPD bug in sl_tx_timeout()
      ax25: add refcount in ax25_dev to avoid UAF bugs
      ax25: fix reference count leaks of ax25_dev
      ax25: fix UAF bugs of net_device caused by rebinding operation
      ax25: Fix refcount leaks caused by ax25_cb_del()
      ax25: fix UAF bug in ax25_send_control()
      ax25: fix NPD bug in ax25_disconnect
      ax25: Fix NULL pointer dereferences in ax25 timers
      ax25: Fix UAF bugs in ax25 timers

Fabio M. De Francesco (1):
      ALSA: pcm: Test for "silence" field in struct "pcm_format_data"

Felix Kuehling (1):
      drm/amdkfd: Use drm_priv to pass VM from KFD to amdgpu

Greg Kroah-Hartman (1):
      Linux 5.10.112

Guillaume Nault (1):
      veth: Ensure eth header is in skb's linear part

Harshit Mogalapalli (1):
      cifs: potential buffer overflow in handling symlinks

James Smart (1):
      scsi: lpfc: Fix queue failures when recovering from PCI parity error

Jason A. Donenfeld (1):
      gcc-plugins: latent_entropy: use /dev/urandom

Jeremy Linton (1):
      net: bcmgenet: Revert "Use stronger register read/writes to assure ordering"

Jia-Ju Bai (1):
      btrfs: fix root ref counts in error handling in btrfs_get_root_ref

Joey Gouly (1):
      arm64: alternatives: mark patch_alternative() as `noinstr`

Johan Hovold (1):
      memory: renesas-rpc-if: fix platform-device leak in error path

Johannes Berg (1):
      nl80211: correctly check NL80211_ATTR_REG_ALPHA2 size

Jonathan Bakker (1):
      regulator: wm8994: Add an off-on delay for WM8994 variant

Josef Bacik (1):
      btrfs: do not warn for free space inode in cow_file_range

Juergen Gross (1):
      mm, page_alloc: fix build_zonerefs_node()

Karsten Graul (1):
      net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()

Khazhismel Kumykov (1):
      dm mpath: only use ktime_get_ns() in historical selector

Kyle Copperfield (1):
      media: rockchip/rga: do proper error checking in probe

Leo (Hanghong) Ma (1):
      drm/amd/display: Update VTEM Infopacket definition

Leo Ruan (1):
      gpu: ipu-v3: Fix dev_dbg frequency output

Lin Ma (3):
      hamradio: defer 6pack kfree after unregister_netdev
      hamradio: remove needs_free_netdev to avoid UAF
      nfc: nci: add flush_workqueue to prevent uaf

Linus Torvalds (1):
      gpiolib: acpi: use correct format characters

Marcelo Ricardo Leitner (1):
      net/sched: fix initialization order when updating chain 0 head

Marcin Kozlowski (1):
      net: usb: aqc111: Fix out-of-bounds accesses in RX fixup

Mario Limonciello (2):
      cpuidle: PSCI: Move the `has_lpi` check to the beginning of the function
      ACPI: processor idle: Check for architectural support for LPI

Martin Leung (1):
      drm/amd/display: Revert FEC check in validation

Martin Povišer (1):
      i2c: pasemi: Wait for write xfers to finish

Melissa Wen (1):
      drm/amd/display: don't ignore alpha property on pre-multiplied mode

Miaoqian Lin (1):
      memory: atmel-ebi: Fix missing of_node_put in atmel_ebi_probe

Michael Kelley (1):
      Drivers: hv: vmbus: Prevent load re-ordering when reading ring buffer

Michael Walle (1):
      net: dsa: felix: suppress -EPROBE_DEFER errors

Mike Christie (10):
      scsi: iscsi: Stop queueing during ep_disconnect
      scsi: iscsi: Force immediate failure during shutdown
      scsi: iscsi: Use system_unbound_wq for destroy_work
      scsi: iscsi: Rel ref after iscsi_lookup_endpoint()
      scsi: iscsi: Fix in-kernel conn failure handling
      scsi: iscsi: Move iscsi_ep_disconnect()
      scsi: iscsi: Fix offload conn cleanup when iscsid restarts
      scsi: iscsi: Fix conn cleanup and stop race during iscsid restart
      scsi: iscsi: Fix endpoint reuse regression
      scsi: iscsi: Fix unbound endpoint error handling

Mikulas Patocka (1):
      dm integrity: fix memory corruption when tag_size is less than digest size

Minchan Kim (1):
      mm: fix unexpected zeroed page mapping with zram swap

Nadav Amit (1):
      smp: Fix offline cpu check in flush_smp_call_function_queue()

Naohiro Aota (1):
      btrfs: mark resumed async balance as writing

Nathan Chancellor (2):
      btrfs: remove unused variable in btrfs_{start,write}_dirty_block_groups()
      ARM: davinci: da850-evm: Avoid NULL pointer dereference

Nicolas Dichtel (1):
      ipv6: fix panic when forwarding a pkt with no in6 dev

Patrick Wang (1):
      mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

Paul Gortmaker (1):
      tick/nohz: Use WARN_ON_ONCE() to prevent console saturation

Petr Malat (1):
      sctp: Initialize daddr on peeled off socket

QintaoShen (1):
      drm/amdkfd: Check for potential null return of kmalloc_array()

Rameshkumar Sundaram (1):
      cfg80211: hold bss_lock while updating nontrans_list

Randy Dunlap (1):
      net: micrel: fix KS8851_MLL Kconfig

Rei Yamamoto (1):
      genirq/affinity: Consider that CPUs on nodes can be unbalanced

Rob Clark (2):
      drm/msm: Add missing put_task_struct() in debugfs path
      drm/msm: Fix range size vs end confusion

Roman Li (1):
      drm/amd/display: Fix allocate_mst_payload assert on resume

Sean Christopherson (1):
      KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded

Stephen Boyd (1):
      drm/msm/dsi: Use connector directly in msm_dsi_manager_connector_init()

Steve Capper (1):
      tlb: hugetlb: Add more sizes to tlb_remove_huge_tlb_entry

Tao Jin (1):
      ALSA: hda/realtek: add quirk for Lenovo Thinkpad X12 speakers

Tianci Yin (1):
      drm/amdgpu/vcn: improve vcn dpg stop procedure

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo PD50PNT

Toke Høiland-Jørgensen (2):
      ath9k: Properly clear TX status area before reporting to mac80211
      ath9k: Fix usage of driver-private space in tx_info

Tomasz Moń (1):
      drm/amdgpu: Enable gfxoff quirk on MacBook Pro

Tushar Patel (1):
      drm/amdkfd: Fix Incorrect VMIDs passed to HWS

Tyrel Datwyler (1):
      scsi: ibmvscsis: Increase INITIAL_SRP_LIMIT to 1024

Vadim Pasternak (1):
      mlxsw: i2c: Fix initialization error flow

Vlad Buslov (1):
      net/sched: flower: fix parsing of ethertype following VLAN header

Xiaoguang Wang (1):
      scsi: target: tcmu: Fix possible page UAF

Xiaomeng Tong (1):
      myri10ge: fix an incorrect free for skb in myri10ge_sw_tso

