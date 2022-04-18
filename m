Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7F50533E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240513AbiDRM4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240165AbiDRMzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F31CC;
        Mon, 18 Apr 2022 05:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76B1E6118A;
        Mon, 18 Apr 2022 12:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33061C385A1;
        Mon, 18 Apr 2022 12:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285409;
        bh=LOcZixqltZKuZWcFx6aUbnx+cyWeJEJHFk3JEh623cY=;
        h=From:To:Cc:Subject:Date:From;
        b=hBkIbR/VYjsi5vJbA5EIlLrUPprCV9xUsfnLsYl5n2DQDv4mK6NAbhipTCXsL+eW7
         Obxexmq6aI/vu+6TfWPHL1ZEqQv1aHd/ABLRS8luVZye4om/zhd9jF19Ce/qy7Si+L
         T+g7zGEiKBWxgrrZNOvctTYqPgaCwkaMV/yDcGSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/105] 5.10.112-rc1 review
Date:   Mon, 18 Apr 2022 14:12:02 +0200
Message-Id: <20220418121145.140991388@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.112-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.112-rc1
X-KernelTest-Deadline: 2022-04-20T12:11+00:00
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

This is the start of the stable review cycle for the 5.10.112 release.
There are 105 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.112-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.112-rc1

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix UAF bugs in ax25 timers

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix NULL pointer dereferences in ax25 timers

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix NPD bug in ax25_disconnect

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix UAF bug in ax25_send_control()

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix refcount leaks caused by ax25_cb_del()

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix UAF bugs of net_device caused by rebinding operation

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix reference count leaks of ax25_dev

Duoming Zhou <duoming@zju.edu.cn>
    ax25: add refcount in ax25_dev to avoid UAF bugs

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix unbound endpoint error handling

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix endpoint reuse regression

Chao Gao <chao.gao@intel.com>
    dma-direct: avoid redundant memory sync for swiotlb

Anna-Maria Behnsen <anna-maria@linutronix.de>
    timers: Fix warning condition in __run_timers()

Martin Povišer <povik+lin@cutebit.org>
    i2c: pasemi: Wait for write xfers to finish

Nadav Amit <namit@vmware.com>
    smp: Fix offline cpu check in flush_smp_call_function_queue()

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix memory corruption when tag_size is less than digest size

Nathan Chancellor <nathan@kernel.org>
    ARM: davinci: da850-evm: Avoid NULL pointer dereference

Paul Gortmaker <paul.gortmaker@windriver.com>
    tick/nohz: Use WARN_ON_ONCE() to prevent console saturation

Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
    genirq/affinity: Consider that CPUs on nodes can be unbalanced

Tomasz Moń <desowin@gmail.com>
    drm/amdgpu: Enable gfxoff quirk on MacBook Pro

Melissa Wen <mwen@igalia.com>
    drm/amd/display: don't ignore alpha property on pre-multiplied mode

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: fix panic when forwarding a pkt with no in6 dev

Johannes Berg <johannes.berg@intel.com>
    nl80211: correctly check NL80211_ATTR_REG_ALPHA2 size

Fabio M. De Francesco <fmdefrancesco@gmail.com>
    ALSA: pcm: Test for "silence" field in struct "pcm_format_data"

Tao Jin <tao-j@outlook.com>
    ALSA: hda/realtek: add quirk for Lenovo Thinkpad X12 speakers

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo PD50PNT

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: mark resumed async balance as writing

Jia-Ju Bai <baijiaju1990@gmail.com>
    btrfs: fix root ref counts in error handling in btrfs_get_root_ref

Toke Høiland-Jørgensen <toke@redhat.com>
    ath9k: Fix usage of driver-private space in tx_info

Toke Høiland-Jørgensen <toke@toke.dk>
    ath9k: Properly clear TX status area before reporting to mac80211

Jason A. Donenfeld <Jason@zx2c4.com>
    gcc-plugins: latent_entropy: use /dev/urandom

Johan Hovold <johan@kernel.org>
    memory: renesas-rpc-if: fix platform-device leak in error path

Oliver Upton <oupton@google.com>
    KVM: Don't create VM debugfs files outside of the VM directory

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded

Patrick Wang <patrick.wang.shcn@gmail.com>
    mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

Minchan Kim <minchan@kernel.org>
    mm: fix unexpected zeroed page mapping with zram swap

Juergen Gross <jgross@suse.com>
    mm, page_alloc: fix build_zonerefs_node()

Borislav Petkov <bp@suse.de>
    perf/imx_ddr: Fix undefined behavior due to shift overflowing the constant

Duoming Zhou <duoming@zju.edu.cn>
    drivers: net: slip: fix NPD bug in sl_tx_timeout()

Chandrakanth patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Target with invalid LUN ID is deleted during scan

Alexey Galakhov <agalakhov@gmail.com>
    scsi: mvsas: Add PCI ID of RocketRaid 2640

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix allocate_mst_payload assert on resume

Martin Leung <Martin.Leung@amd.com>
    drm/amd/display: Revert FEC check in validation

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    myri10ge: fix an incorrect free for skb in myri10ge_sw_tso

Marcin Kozlowski <marcinguy@gmail.com>
    net: usb: aqc111: Fix out-of-bounds accesses in RX fixup

Andy Chiu <andy.chiu@sifive.com>
    net: axienet: setup mdio unconditionally

Steve Capper <steve.capper@arm.com>
    tlb: hugetlb: Add more sizes to tlb_remove_huge_tlb_entry

Joey Gouly <joey.gouly@arm.com>
    arm64: alternatives: mark patch_alternative() as `noinstr`

Jonathan Bakker <xc-racer2@live.ca>
    regulator: wm8994: Add an off-on delay for WM8994 variant

Leo Ruan <tingquan.ruan@cn.bosch.com>
    gpu: ipu-v3: Fix dev_dbg frequency output

Christian Lamparter <chunkeey@gmail.com>
    ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs

Randy Dunlap <rdunlap@infradead.org>
    net: micrel: fix KS8851_MLL Kconfig

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsis: Increase INITIAL_SRP_LIMIT to 1024

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix queue failures when recovering from PCI parity error

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    scsi: target: tcmu: Fix possible page UAF

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Prevent load re-ordering when reading ring buffer

QintaoShen <unSimple1993@163.com>
    drm/amdkfd: Check for potential null return of kmalloc_array()

Tianci Yin <tianci.yin@amd.com>
    drm/amdgpu/vcn: improve vcn dpg stop procedure

Tushar Patel <tushar.patel@amd.com>
    drm/amdkfd: Fix Incorrect VMIDs passed to HWS

Leo (Hanghong) Ma <hanghong.ma@amd.com>
    drm/amd/display: Update VTEM Infopacket definition

Chiawen Huang <chiawen.huang@amd.com>
    drm/amd/display: FEC check in timing validation

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: fix audio format not updated after edid updated

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not warn for free space inode in cow_file_range

Darrick J. Wong <djwong@kernel.org>
    btrfs: fix fallocate to use file_modified to update permissions consistently

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd: Add USBC connector ID

Jeremy Linton <jeremy.linton@arm.com>
    net: bcmgenet: Revert "Use stronger register read/writes to assure ordering"

Khazhismel Kumykov <khazhy@google.com>
    dm mpath: only use ktime_get_ns() in historical selector

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    cifs: potential buffer overflow in handling symlinks

Lin Ma <linma@zju.edu.cn>
    nfc: nci: add flush_workqueue to prevent uaf

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix misleading add event PMU debug message

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    testing/selftests/mqueue: Fix mq_perf_tests to free the allocated cpu set

Petr Malat <oss@malat.biz>
    sctp: Initialize daddr on peeled off socket

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix conn cleanup and stop race during iscsid restart

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix offload conn cleanup when iscsid restarts

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Move iscsi_ep_disconnect()

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix in-kernel conn failure handling

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Rel ref after iscsi_lookup_endpoint()

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Use system_unbound_wq for destroy_work

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Force immediate failure during shutdown

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Stop queueing during ep_disconnect

Ajish Koshy <Ajish.Koshy@microchip.com>
    scsi: pm80xx: Enable upper inbound, outbound queues

Ajish Koshy <Ajish.Koshy@microchip.com>
    scsi: pm80xx: Mask and unmask upper interrupt vectors 32-63

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()

Stephen Boyd <swboyd@chromium.org>
    drm/msm/dsi: Use connector directly in msm_dsi_manager_connector_init()

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix range size vs end confusion

Rameshkumar Sundaram <quic_ramess@quicinc.com>
    cfg80211: hold bss_lock while updating nontrans_list

Benedikt Spranger <b.spranger@linutronix.de>
    net/sched: taprio: Check if socket flags are valid

Dinh Nguyen <dinguyen@kernel.org>
    net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link

Michael Walle <michael@walle.cc>
    net: dsa: felix: suppress -EPROBE_DEFER errors

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    net/sched: fix initialization order when updating chain 0 head

Vadim Pasternak <vadimp@nvidia.com>
    mlxsw: i2c: Fix initialization error flow

Calvin Johnson <calvin.johnson@oss.nxp.com>
    net: mdio: Alphabetically sort header inclusion

Linus Torvalds <torvalds@linux-foundation.org>
    gpiolib: acpi: use correct format characters

Guillaume Nault <gnault@redhat.com>
    veth: Ensure eth header is in skb's linear part

Vlad Buslov <vladbu@nvidia.com>
    net/sched: flower: fix parsing of ethertype following VLAN header

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix the svc_deferred_event trace class

Kyle Copperfield <kmcopper@danwin1210.me>
    media: rockchip/rga: do proper error checking in probe

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix sorting of retrieved clock rates

Miaoqian Lin <linmq006@gmail.com>
    memory: atmel-ebi: Fix missing of_node_put in atmel_ebi_probe

Rob Clark <robdclark@chromium.org>
    drm/msm: Add missing put_task_struct() in debugfs path

Nathan Chancellor <nathan@kernel.org>
    btrfs: remove unused variable in btrfs_{start,write}_dirty_block_groups()

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: processor idle: Check for architectural support for LPI

Mario Limonciello <mario.limonciello@amd.com>
    cpuidle: PSCI: Move the `has_lpi` check to the beginning of the function

Lin Ma <linma@zju.edu.cn>
    hamradio: remove needs_free_netdev to avoid UAF

Lin Ma <linma@zju.edu.cn>
    hamradio: defer 6pack kfree after unregister_netdev

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: Use drm_priv to pass VM from KFD to amdgpu


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-davinci/board-da850-evm.c            |   4 +-
 arch/arm64/kernel/alternative.c                    |   6 +-
 arch/arm64/kernel/cpuidle.c                        |   6 +-
 arch/x86/include/asm/kvm_host.h                    |   5 +-
 arch/x86/kvm/mmu/mmu.c                             |  20 +-
 arch/x86/kvm/x86.c                                 |  20 +-
 drivers/acpi/processor_idle.c                      |  15 +-
 drivers/ata/libata-core.c                          |   3 +
 drivers/firmware/arm_scmi/clock.c                  |   3 +-
 drivers/gpio/gpiolib-acpi.c                        |   4 +-
 drivers/gpu/drm/amd/amdgpu/ObjectID.h              |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   3 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  11 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   2 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   4 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  14 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  14 +-
 .../amd/display/modules/info_packet/info_packet.c  |   5 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_manager.c              |   2 +-
 drivers/gpu/drm/msm/msm_gem.c                      |   1 +
 drivers/gpu/ipu-v3/ipu-di.c                        |   5 +-
 drivers/hv/ring_buffer.c                           |  11 +-
 drivers/i2c/busses/i2c-pasemi.c                    |   6 +
 drivers/infiniband/ulp/iser/iscsi_iser.c           |   2 +
 drivers/md/dm-historical-service-time.c            |  10 +-
 drivers/md/dm-integrity.c                          |   7 +-
 drivers/media/platform/rockchip/rga/rga.c          |   2 +-
 drivers/memory/atmel-ebi.c                         |  23 +-
 drivers/memory/renesas-rpc-if.c                    |  10 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/i2c.c          |   1 +
 drivers/net/ethernet/micrel/Kconfig                |   1 +
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   6 +-
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c |   8 -
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h |   4 +
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  13 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  13 +-
 drivers/net/hamradio/6pack.c                       |   5 +-
 drivers/net/mdio/mdio-bcm-unimac.c                 |  16 +-
 drivers/net/mdio/mdio-bitbang.c                    |   4 +-
 drivers/net/mdio/mdio-cavium.c                     |   2 +-
 drivers/net/mdio/mdio-gpio.c                       |  10 +-
 drivers/net/mdio/mdio-ipq4019.c                    |   4 +-
 drivers/net/mdio/mdio-ipq8064.c                    |   4 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |   8 +-
 drivers/net/mdio/mdio-mux-bcm-iproc.c              |  10 +-
 drivers/net/mdio/mdio-mux-gpio.c                   |   8 +-
 drivers/net/mdio/mdio-mux-mmioreg.c                |   6 +-
 drivers/net/mdio/mdio-mux-multiplexer.c            |   2 +-
 drivers/net/mdio/mdio-mux.c                        |   6 +-
 drivers/net/mdio/mdio-octeon.c                     |   8 +-
 drivers/net/mdio/mdio-thunder.c                    |  10 +-
 drivers/net/mdio/mdio-xgene.c                      |   6 +-
 drivers/net/mdio/of_mdio.c                         |  10 +-
 drivers/net/slip/slip.c                            |   2 +-
 drivers/net/usb/aqc111.c                           |   9 +-
 drivers/net/veth.c                                 |   2 +-
 drivers/net/wireless/ath/ath9k/main.c              |   2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  33 +-
 drivers/perf/fsl_imx8_ddr_perf.c                   |   2 +-
 drivers/regulator/wm8994-regulator.c               |  42 +-
 drivers/scsi/be2iscsi/be_iscsi.c                   |  19 +-
 drivers/scsi/be2iscsi/be_main.c                    |   1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |  24 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |   1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |   1 +
 drivers/scsi/cxgbi/libcxgbi.c                      |  12 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |   2 +-
 drivers/scsi/libiscsi.c                            |  70 ++-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +
 drivers/scsi/megaraid/megaraid_sas.h               |   3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |   7 +
 drivers/scsi/mvsas/mv_init.c                       |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  33 +-
 drivers/scsi/qedi/qedi_iscsi.c                     |  26 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/scsi/scsi_transport_iscsi.c                | 541 +++++++++++++--------
 drivers/target/target_core_user.c                  |   3 +-
 fs/btrfs/block-group.c                             |   4 -
 fs/btrfs/disk-io.c                                 |   5 +-
 fs/btrfs/file.c                                    |  13 +-
 fs/btrfs/inode.c                                   |   1 -
 fs/btrfs/volumes.c                                 |   2 +
 fs/cifs/link.c                                     |   3 +
 include/asm-generic/tlb.h                          |  10 +-
 include/net/ax25.h                                 |  12 +
 include/net/flow_dissector.h                       |   2 +
 include/scsi/libiscsi.h                            |   1 +
 include/scsi/scsi_transport_iscsi.h                |  14 +-
 include/trace/events/sunrpc.h                      |   7 +-
 kernel/dma/direct.h                                |   3 +-
 kernel/irq/affinity.c                              |   5 +-
 kernel/smp.c                                       |   2 +-
 kernel/time/tick-sched.c                           |   2 +-
 kernel/time/timer.c                                |  11 +-
 mm/kmemleak.c                                      |   8 +-
 mm/page_alloc.c                                    |   2 +-
 mm/page_io.c                                       |  54 --
 net/ax25/af_ax25.c                                 |  38 +-
 net/ax25/ax25_dev.c                                |  28 +-
 net/ax25/ax25_route.c                              |  13 +-
 net/ax25/ax25_subr.c                               |  20 +-
 net/core/flow_dissector.c                          |   1 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/nfc/nci/core.c                                 |   4 +
 net/sched/cls_api.c                                |   2 +-
 net/sched/cls_flower.c                             |  18 +-
 net/sched/sch_taprio.c                             |   3 +-
 net/sctp/socket.c                                  |   2 +-
 net/smc/smc_pnet.c                                 |   5 +-
 net/wireless/nl80211.c                             |   3 +-
 net/wireless/scan.c                                |   2 +
 scripts/gcc-plugins/latent_entropy_plugin.c        |  44 +-
 sound/core/pcm_misc.c                              |   2 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 tools/perf/util/parse-events.c                     |   5 +-
 tools/testing/selftests/mqueue/mq_perf_tests.c     |  25 +-
 virt/kvm/kvm_main.c                                |  10 +-
 125 files changed, 1062 insertions(+), 581 deletions(-)


