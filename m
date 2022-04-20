Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A579508289
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 09:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349121AbiDTHt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 03:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbiDTHt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 03:49:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD689FE0;
        Wed, 20 Apr 2022 00:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DC6261868;
        Wed, 20 Apr 2022 07:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC159C385A0;
        Wed, 20 Apr 2022 07:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650440800;
        bh=2EQ7bRiBBjrPBF2hWYdXqLPhbEyF/RAKUzDnkFsrLL4=;
        h=From:To:Cc:Subject:Date:From;
        b=hRtZkUrFPgTpIh/wer4bcIrZNoLGLrzEm+o8HFkN3xqEl6doGP9DdwXLX5CYe908x
         RqRDSg+qrxbvgqaxX0gNp3teDxs7A7EQU0eZlqIntJU8eDIi9ObT8uPewsb1LHOJEk
         SepV9nUq6712YL2YPdNSX+gUj4zc+6+iAxIxFj1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.35
Date:   Wed, 20 Apr 2022 09:46:36 +0200
Message-Id: <165044079665151@kroah.com>
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

I'm announcing the release of the 5.15.35 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/qcom,ipa.yaml           |    6 
 Documentation/devicetree/bindings/net/snps,dwmac.yaml         |    6 
 Makefile                                                      |    2 
 arch/arm/mach-davinci/board-da850-evm.c                       |    4 
 arch/arm64/kernel/alternative.c                               |    6 
 arch/arm64/kernel/cpuidle.c                                   |    6 
 arch/x86/include/asm/kvm_host.h                               |    5 
 arch/x86/include/asm/msr-index.h                              |    4 
 arch/x86/kernel/cpu/common.c                                  |    2 
 arch/x86/kernel/cpu/cpu.h                                     |    5 
 arch/x86/kernel/cpu/intel.c                                   |    7 
 arch/x86/kernel/cpu/tsx.c                                     |  104 +++++-
 arch/x86/kvm/mmu/mmu.c                                        |   20 -
 arch/x86/kvm/x86.c                                            |   20 +
 block/bio.c                                                   |    2 
 drivers/acpi/processor_idle.c                                 |   23 +
 drivers/ata/libata-core.c                                     |    3 
 drivers/base/dd.c                                             |    1 
 drivers/block/drbd/drbd_main.c                                |    1 
 drivers/cpufreq/intel_pstate.c                                |   10 
 drivers/firmware/arm_scmi/clock.c                             |    3 
 drivers/firmware/arm_scmi/driver.c                            |    3 
 drivers/gpio/gpiolib-acpi.c                                   |    4 
 drivers/gpu/drm/amd/amdgpu/ObjectID.h                         |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                    |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                       |    2 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c                        |    2 
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c                         |    5 
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                         |    4 
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c                         |    3 
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                       |   11 
 drivers/gpu/drm/amd/amdkfd/kfd_events.c                       |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c             |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c             |    4 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c           |    1 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c     |   29 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c            |   14 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c           |    1 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c            |    5 
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c         |    1 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c           |   63 +++
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c            |    5 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c         |    2 
 drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h              |    2 
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c |    5 
 drivers/gpu/drm/i915/gem/i915_gem_mman.c                      |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                         |    2 
 drivers/gpu/drm/msm/dp/dp_display.c                           |    6 
 drivers/gpu/drm/msm/dp/dp_panel.c                             |   20 -
 drivers/gpu/drm/msm/dp/dp_panel.h                             |    1 
 drivers/gpu/drm/msm/dsi/dsi_manager.c                         |    2 
 drivers/gpu/drm/msm/msm_gem.c                                 |    1 
 drivers/gpu/ipu-v3/ipu-di.c                                   |    5 
 drivers/hv/hv_balloon.c                                       |   36 ++
 drivers/hv/ring_buffer.c                                      |   11 
 drivers/hv/vmbus_drv.c                                        |   18 -
 drivers/i2c/busses/i2c-pasemi.c                               |    6 
 drivers/i2c/i2c-dev.c                                         |   15 
 drivers/md/dm-integrity.c                                     |    7 
 drivers/md/dm-ps-historical-service-time.c                    |   10 
 drivers/media/platform/rockchip/rga/rga.c                     |    2 
 drivers/memory/atmel-ebi.c                                    |   23 +
 drivers/memory/renesas-rpc-if.c                               |   10 
 drivers/net/dsa/ocelot/felix_vsc9959.c                        |    2 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                |    4 
 drivers/net/ethernet/faraday/ftgmac100.c                      |   10 
 drivers/net/ethernet/mellanox/mlxsw/i2c.c                     |    1 
 drivers/net/ethernet/micrel/Kconfig                           |    1 
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c              |    6 
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c            |    8 
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h            |    4 
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c           |   13 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c             |   13 
 drivers/net/hamradio/6pack.c                                  |    5 
 drivers/net/ipa/Kconfig                                       |    1 
 drivers/net/ipa/ipa_power.c                                   |   52 +++
 drivers/net/ipa/ipa_power.h                                   |    7 
 drivers/net/ipa/ipa_uc.c                                      |    5 
 drivers/net/macvlan.c                                         |    8 
 drivers/net/mdio/fwnode_mdio.c                                |    5 
 drivers/net/slip/slip.c                                       |    2 
 drivers/net/usb/aqc111.c                                      |    9 
 drivers/net/veth.c                                            |    2 
 drivers/net/wireless/ath/ath11k/mac.c                         |   21 -
 drivers/net/wireless/ath/ath9k/main.c                         |    2 
 drivers/net/wireless/ath/ath9k/xmit.c                         |   33 +
 drivers/pci/controller/pci-hyperv.c                           |    9 
 drivers/perf/fsl_imx8_ddr_perf.c                              |    2 
 drivers/regulator/wm8994-regulator.c                          |   42 ++
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c                      |    2 
 drivers/scsi/lpfc/lpfc_init.c                                 |    2 
 drivers/scsi/megaraid/megaraid_sas.h                          |    3 
 drivers/scsi/megaraid/megaraid_sas_base.c                     |    7 
 drivers/scsi/mpt3sas/mpt3sas_config.c                         |    9 
 drivers/scsi/mvsas/mv_init.c                                  |    1 
 drivers/scsi/pm8001/pm80xx_hwi.c                              |   33 +
 drivers/scsi/scsi_transport_iscsi.c                           |  168 ++++++----
 drivers/soc/qcom/qcom_aoss.c                                  |   58 +++
 drivers/spi/spi-cadence-quadspi.c                             |   46 --
 drivers/target/target_core_user.c                             |    3 
 drivers/vfio/pci/vfio_pci_core.c                              |  124 ++++---
 fs/btrfs/block-group.c                                        |    4 
 fs/btrfs/compression.c                                        |    2 
 fs/btrfs/disk-io.c                                            |    5 
 fs/btrfs/extent_io.c                                          |    5 
 fs/btrfs/file.c                                               |   13 
 fs/btrfs/inode.c                                              |    7 
 fs/btrfs/volumes.c                                            |    2 
 fs/cifs/cifsfs.c                                              |   28 -
 fs/cifs/link.c                                                |    3 
 fs/io_uring.c                                                 |   24 -
 include/asm-generic/tlb.h                                     |   10 
 include/linux/soc/qcom/qcom_aoss.h                            |   38 ++
 include/linux/sunrpc/svc.h                                    |    1 
 include/linux/vfio_pci_core.h                                 |    2 
 include/net/ax25.h                                            |   12 
 include/net/flow_dissector.h                                  |    2 
 include/scsi/scsi_transport_iscsi.h                           |    2 
 include/sound/core.h                                          |    1 
 include/trace/events/sunrpc.h                                 |    7 
 kernel/cpu.c                                                  |   36 +-
 kernel/dma/direct.h                                           |    3 
 kernel/irq/affinity.c                                         |    5 
 kernel/smp.c                                                  |    2 
 kernel/time/tick-sched.c                                      |    2 
 kernel/time/timer.c                                           |   11 
 mm/kmemleak.c                                                 |    8 
 mm/page_alloc.c                                               |    2 
 mm/page_io.c                                                  |   54 ---
 mm/secretmem.c                                                |   17 +
 net/ax25/af_ax25.c                                            |   38 +-
 net/ax25/ax25_dev.c                                           |   28 +
 net/ax25/ax25_route.c                                         |   13 
 net/ax25/ax25_subr.c                                          |   20 -
 net/core/flow_dissector.c                                     |    1 
 net/ipv6/ip6_output.c                                         |    2 
 net/netfilter/nf_tables_api.c                                 |    2 
 net/netfilter/nft_socket.c                                    |    7 
 net/nfc/nci/core.c                                            |    4 
 net/sched/cls_api.c                                           |    2 
 net/sched/cls_flower.c                                        |   18 -
 net/sched/sch_taprio.c                                        |    3 
 net/sctp/socket.c                                             |    2 
 net/smc/smc_pnet.c                                            |    5 
 net/sunrpc/svc_xprt.c                                         |    3 
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c                       |    2 
 net/wireless/nl80211.c                                        |    3 
 net/wireless/scan.c                                           |    2 
 scripts/gcc-plugins/latent_entropy_plugin.c                   |   44 +-
 sound/core/init.c                                             |   28 +
 sound/core/pcm_misc.c                                         |    2 
 sound/drivers/mtpav.c                                         |    4 
 sound/isa/galaxy/galaxy.c                                     |    7 
 sound/isa/sc6000.c                                            |    7 
 sound/pci/ad1889.c                                            |   10 
 sound/pci/ali5451/ali5451.c                                   |   10 
 sound/pci/als300.c                                            |    8 
 sound/pci/als4000.c                                           |   10 
 sound/pci/atiixp.c                                            |   10 
 sound/pci/atiixp_modem.c                                      |   10 
 sound/pci/au88x0/au88x0.c                                     |    8 
 sound/pci/aw2/aw2-alsa.c                                      |    8 
 sound/pci/azt3328.c                                           |    8 
 sound/pci/bt87x.c                                             |   10 
 sound/pci/ca0106/ca0106_main.c                                |   10 
 sound/pci/cmipci.c                                            |    8 
 sound/pci/cs4281.c                                            |   10 
 sound/pci/cs5535audio/cs5535audio.c                           |   10 
 sound/pci/echoaudio/echoaudio.c                               |    9 
 sound/pci/emu10k1/emu10k1x.c                                  |   10 
 sound/pci/ens1370.c                                           |   10 
 sound/pci/es1938.c                                            |   10 
 sound/pci/es1968.c                                            |   10 
 sound/pci/fm801.c                                             |   10 
 sound/pci/hda/patch_realtek.c                                 |    2 
 sound/pci/ice1712/ice1724.c                                   |   10 
 sound/pci/intel8x0.c                                          |   10 
 sound/pci/intel8x0m.c                                         |   10 
 sound/pci/korg1212/korg1212.c                                 |    8 
 sound/pci/lola/lola.c                                         |   10 
 sound/pci/lx6464es/lx6464es.c                                 |    8 
 sound/pci/maestro3.c                                          |    8 
 sound/pci/nm256/nm256.c                                       |    2 
 sound/pci/oxygen/oxygen_lib.c                                 |   12 
 sound/pci/riptide/riptide.c                                   |    8 
 sound/pci/rme32.c                                             |    8 
 sound/pci/rme96.c                                             |   10 
 sound/pci/rme9652/hdsp.c                                      |    8 
 sound/pci/rme9652/hdspm.c                                     |    8 
 sound/pci/rme9652/rme9652.c                                   |    8 
 sound/pci/sis7019.c                                           |   14 
 sound/pci/sonicvibes.c                                        |   10 
 sound/pci/via82xx.c                                           |   10 
 sound/pci/via82xx_modem.c                                     |   10 
 sound/usb/pcm.c                                               |   16 
 sound/x86/intel_hdmi_audio.c                                  |    7 
 tools/arch/x86/include/asm/msr-index.h                        |    4 
 tools/perf/util/parse-events.c                                |    5 
 tools/testing/selftests/mqueue/mq_perf_tests.c                |   25 +
 201 files changed, 1644 insertions(+), 651 deletions(-)

Adrian Hunter (1):
      perf tools: Fix misleading add event PMU debug message

Ajish Koshy (2):
      scsi: pm80xx: Mask and unmask upper interrupt vectors 32-63
      scsi: pm80xx: Enable upper inbound, outbound queues

Alex Deucher (1):
      drm/amdgpu/gmc: use PCI BARs for APUs in passthrough

Alex Elder (3):
      dt-bindings: net: qcom,ipa: add optional qcom,qmp property
      net: ipa: request IPA register values be retained
      net: ipa: fix a build dependency

Alexey Galakhov (1):
      scsi: mvsas: Add PCI ID of RocketRaid 2640

Andrea Parri (Microsoft) (1):
      Drivers: hv: vmbus: Deactivate sysctl_record_panic_msg by default in isolated guests

Andy Chiu (1):
      net: axienet: setup mdio unconditionally

Andy Shevchenko (1):
      i2c: dev: check return value when calling dev_set_name()

Anilkumar Kolli (1):
      Revert "ath11k: mesh: add support for 256 bitmap in blockack frames in 11ax"

Anna-Maria Behnsen (1):
      timers: Fix warning condition in __run_timers()

Antoine Tenart (1):
      netfilter: nf_tables: nft_parse_register can return a negative value

Athira Rajeev (1):
      testing/selftests/mqueue: Fix mq_perf_tests to free the allocated cpu set

Aurabindo Pillai (1):
      drm/amd: Add USBC connector ID

Axel Rasmussen (1):
      mm/secretmem: fix panic when growing a memfd_secret

Benedikt Spranger (1):
      net/sched: taprio: Check if socket flags are valid

Boqun Feng (1):
      Drivers: hv: balloon: Disable balloon and hot-add accordingly

Borislav Petkov (1):
      perf/imx_ddr: Fix undefined behavior due to shift overflowing the constant

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

Christoph Böhmwalder (1):
      drbd: set QUEUE_FLAG_STABLE_WRITES

Chuck Lever (2):
      SUNRPC: Fix the svc_deferred_event trace class
      SUNRPC: Fix NFSD's request deferral on RDMA transports

Cristian Marussi (2):
      firmware: arm_scmi: Remove clear channel call on the TX channel
      firmware: arm_scmi: Fix sorting of retrieved clock rates

Darrick J. Wong (1):
      btrfs: fix fallocate to use file_modified to update permissions consistently

Deepak Kumar Singh (1):
      soc: qcom: aoss: Expose send for generic usecase

Dinh Nguyen (1):
      net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link

Dongjin Yang (1):
      dt-bindings: net: snps: remove duplicate name

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

Dylan Hung (1):
      net: ftgmac100: access hardware register after clock ready

Dylan Yudaken (3):
      io_uring: move io_uring_rsrc_update2 validation
      io_uring: verify that resv2 is 0 in io_uring_rsrc_update2
      io_uring: verify pad field is 0 in io_get_ext_arg

Fabio M. De Francesco (1):
      ALSA: pcm: Test for "silence" field in struct "pcm_format_data"

Filipe Manana (1):
      btrfs: remove no longer used counter when reading data page

Florian Westphal (1):
      netfilter: nft_socket: make cgroup match work in input too

Greg Kroah-Hartman (1):
      Linux 5.15.35

Guchun Chen (1):
      drm/amdgpu: conduct a proper cleanup of PDB bo

Guillaume Nault (1):
      veth: Ensure eth header is in skb's linear part

Harshit Mogalapalli (1):
      cifs: potential buffer overflow in handling symlinks

James Smart (1):
      scsi: lpfc: Fix queue failures when recovering from PCI parity error

Jason A. Donenfeld (1):
      gcc-plugins: latent_entropy: use /dev/urandom

Jason Gunthorpe (1):
      vfio/pci: Fix vf_token mechanism when device-specific VF drivers are used

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

Kuogee Hsieh (1):
      drm/msm/dp: add fail safe mode outside of event_mutex context

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

Martin Willi (1):
      macvlan: Fix leaking skb in source mode with nodst option

Matt Roper (1):
      drm/i915: Sunset igpu legacy mmap support based on GRAPHICS_VER_FULL

Matthias Schiffer (1):
      spi: cadence-quadspi: fix protocol setup for non-1-1-X operations

Melissa Wen (1):
      drm/amd/display: don't ignore alpha property on pre-multiplied mode

Miaoqian Lin (2):
      memory: atmel-ebi: Fix missing of_node_put in atmel_ebi_probe
      soc: qcom: aoss: Fix missing put_device call in qmp_get

Michael Kelley (2):
      PCI: hv: Propagate coherence from VMbus device to PCI device
      Drivers: hv: vmbus: Prevent load re-ordering when reading ring buffer

Michael Walle (1):
      net: dsa: felix: suppress -EPROBE_DEFER errors

Mike Christie (5):
      scsi: iscsi: Move iscsi_ep_disconnect()
      scsi: iscsi: Fix offload conn cleanup when iscsid restarts
      scsi: iscsi: Fix endpoint reuse regression
      scsi: iscsi: Fix conn cleanup and stop race during iscsid restart
      scsi: iscsi: Fix unbound endpoint error handling

Mikulas Patocka (1):
      dm integrity: fix memory corruption when tag_size is less than digest size

Minchan Kim (1):
      mm: fix unexpected zeroed page mapping with zram swap

Ming Lei (1):
      block: fix offset/size check in bio_trim()

Nadav Amit (1):
      smp: Fix offline cpu check in flush_smp_call_function_queue()

Naohiro Aota (2):
      btrfs: release correct delalloc amount in direct IO write path
      btrfs: mark resumed async balance as writing

Nathan Chancellor (2):
      btrfs: remove unused variable in btrfs_{start,write}_dirty_block_groups()
      ARM: davinci: da850-evm: Avoid NULL pointer dereference

Nicholas Kazlauskas (2):
      drm/amd/display: Add pstate verification and recovery for DCN31
      drm/amd/display: Fix p-state allow debug index on dcn31

Nicolas Dichtel (1):
      ipv6: fix panic when forwarding a pkt with no in6 dev

Patrick Wang (1):
      mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

Paul Gortmaker (1):
      tick/nohz: Use WARN_ON_ONCE() to prevent console saturation

Pavel Begunkov (2):
      io_uring: zero tag on rsrc removal
      io_uring: use nospec annotation for more indexes

Pawan Gupta (2):
      x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
      x86/tsx: Disable TSX development mode at boot

Petr Malat (1):
      sctp: Initialize daddr on peeled off socket

QintaoShen (1):
      drm/amdkfd: Check for potential null return of kmalloc_array()

Qu Wenruo (1):
      btrfs: remove unused parameter nr_pages in add_ra_bio_pages()

Rameshkumar Sundaram (1):
      cfg80211: hold bss_lock while updating nontrans_list

Randy Dunlap (1):
      net: micrel: fix KS8851_MLL Kconfig

Rei Yamamoto (1):
      genirq/affinity: Consider that CPUs on nodes can be unbalanced

Richard Gong (1):
      ACPI: processor idle: Allow playing dead in C3 state

Rob Clark (2):
      drm/msm: Add missing put_task_struct() in debugfs path
      drm/msm: Fix range size vs end confusion

Roman Li (2):
      drm/amd/display: Enable power gating before init_pipes
      drm/amd/display: Fix allocate_mst_payload assert on resume

Ronnie Sahlberg (1):
      cifs: verify that tcon is valid before dereference in cifs_kill_sb

Sean Christopherson (1):
      KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded

Shyam Prasad N (1):
      cifs: release cached dentries only if mount is complete

Sreekanth Reddy (1):
      scsi: mpt3sas: Fail reset operation if config request timed out

Srinivas Pandruvada (1):
      cpufreq: intel_pstate: ITMT support for overclocked system

Stephen Boyd (1):
      drm/msm/dsi: Use connector directly in msm_dsi_manager_connector_init()

Steve Capper (1):
      tlb: hugetlb: Add more sizes to tlb_remove_huge_tlb_entry

Steven Price (1):
      cpu/hotplug: Remove the 'cpu' member of cpuhp_cpu_state

Takashi Iwai (44):
      ALSA: core: Add snd_card_free_on_error() helper
      ALSA: sis7019: Fix the missing error handling
      ALSA: ali5451: Fix the missing snd_card_free() call at probe error
      ALSA: als300: Fix the missing snd_card_free() call at probe error
      ALSA: als4000: Fix the missing snd_card_free() call at probe error
      ALSA: atiixp: Fix the missing snd_card_free() call at probe error
      ALSA: au88x0: Fix the missing snd_card_free() call at probe error
      ALSA: aw2: Fix the missing snd_card_free() call at probe error
      ALSA: azt3328: Fix the missing snd_card_free() call at probe error
      ALSA: bt87x: Fix the missing snd_card_free() call at probe error
      ALSA: ca0106: Fix the missing snd_card_free() call at probe error
      ALSA: cmipci: Fix the missing snd_card_free() call at probe error
      ALSA: cs4281: Fix the missing snd_card_free() call at probe error
      ALSA: cs5535audio: Fix the missing snd_card_free() call at probe error
      ALSA: echoaudio: Fix the missing snd_card_free() call at probe error
      ALSA: emu10k1x: Fix the missing snd_card_free() call at probe error
      ALSA: ens137x: Fix the missing snd_card_free() call at probe error
      ALSA: es1938: Fix the missing snd_card_free() call at probe error
      ALSA: es1968: Fix the missing snd_card_free() call at probe error
      ALSA: fm801: Fix the missing snd_card_free() call at probe error
      ALSA: galaxy: Fix the missing snd_card_free() call at probe error
      ALSA: hdsp: Fix the missing snd_card_free() call at probe error
      ALSA: hdspm: Fix the missing snd_card_free() call at probe error
      ALSA: ice1724: Fix the missing snd_card_free() call at probe error
      ALSA: intel8x0: Fix the missing snd_card_free() call at probe error
      ALSA: intel_hdmi: Fix the missing snd_card_free() call at probe error
      ALSA: korg1212: Fix the missing snd_card_free() call at probe error
      ALSA: lola: Fix the missing snd_card_free() call at probe error
      ALSA: lx6464es: Fix the missing snd_card_free() call at probe error
      ALSA: maestro3: Fix the missing snd_card_free() call at probe error
      ALSA: oxygen: Fix the missing snd_card_free() call at probe error
      ALSA: riptide: Fix the missing snd_card_free() call at probe error
      ALSA: rme32: Fix the missing snd_card_free() call at probe error
      ALSA: rme9652: Fix the missing snd_card_free() call at probe error
      ALSA: rme96: Fix the missing snd_card_free() call at probe error
      ALSA: sc6000: Fix the missing snd_card_free() call at probe error
      ALSA: sonicvibes: Fix the missing snd_card_free() call at probe error
      ALSA: via82xx: Fix the missing snd_card_free() call at probe error
      ALSA: usb-audio: Cap upper limits of buffer/period bytes for implicit fb
      ALSA: nm256: Don't call card private_free at probe error path
      ALSA: ad1889: Fix the missing snd_card_free() call at probe error
      ALSA: mtpav: Don't call card private_free at probe error path
      ALSA: usb-audio: Increase max buffer size
      ALSA: usb-audio: Limit max buffer and period sizes per time

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

Vladimir Oltean (1):
      net: mdio: don't defer probe forever if PHY IRQ provider is missing

Woody Suwalski (1):
      ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40

Xiaoguang Wang (1):
      scsi: target: tcmu: Fix possible page UAF

Xiaomeng Tong (1):
      myri10ge: fix an incorrect free for skb in myri10ge_sw_tso

