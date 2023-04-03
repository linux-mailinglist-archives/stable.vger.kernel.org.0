Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C8D6D48BC
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjDCObZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbjDCObX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694E835031;
        Mon,  3 Apr 2023 07:31:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF82B81C5F;
        Mon,  3 Apr 2023 14:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B771C433D2;
        Mon,  3 Apr 2023 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532278;
        bh=PgI8H4mHwIK8nuPnJbzukKmoonrFI26NdVhKB4ZBr0o=;
        h=From:To:Cc:Subject:Date:From;
        b=bXMFU57h2NiKfOgGZx3uv96RgYS9PWCGOy7dshtnOjQO+CZQ1ntYJvOFLuwuXGbJP
         HJUUcCN0ZTMAiXWlvui09/092Cyh1eLFiHT/DWbJVZlyhB7Qg5bciY21qa+Ynwn2zs
         IgBVMHDChHdxq4RZxQ4mo6XatXtzoDBD0Km1aqQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 00/99] 5.15.106-rc1 review
Date:   Mon,  3 Apr 2023 16:08:23 +0200
Message-Id: <20230403140356.079638751@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.106-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.106-rc1
X-KernelTest-Deadline: 2023-04-05T14:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.106 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.106-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.106-rc1

Jan Beulich <jbeulich@suse.com>
    x86/PVH: avoid 32-bit build warning when obtaining VGA console info

Matthieu Baerts <matthieu.baerts@tessares.net>
    hsr: ratelimit only when errors are printed

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix btf_dump's packed struct determination

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Add few corner cases to test padding handling of btf_dump

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix BTF-to-C converter's padding logic

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Test btf dump for struct with padding only fields

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Fix error message in zonefs_file_dio_append()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Purge "highest ISR" cache when updating APICv state

Sean Christopherson <seanjc@google.com>
    KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Move preemption timer <=> hrtimer dance to common x86

Heiko Carstens <hca@linux.ibm.com>
    s390/uaccess: add missing earlyclobber annotations to __clear_user()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Disable interrupts while walking userspace PTs

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Add DSC Support for Synaptics Cascaded MST Hub

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix reference leak when mmaping imported buffer

Douglas Raillard <douglas.raillard@arm.com>
    rcu: Fix rcu_torture_read ftrace event

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix KASAN report for show_stack

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/realtek: Add quirk for Lenovo ZhaoYang CF4620Z

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirks for some Clevo laptops

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix regression on detection of Roland VS-100

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Partial revert of a quirk for Lenovo

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix hangs when recovering open state after a server reboot

Jens Axboe <axboe@kernel.dk>
    powerpc: Don't try to copy PPR for task with NULL pt_regs

Johan Hovold <johan+linaro@kernel.org>
    pinctrl: at91-pio4: fix domain name assignment

Kornel Dulęba <korneld@chromium.org>
    pinctrl: amd: Disable and mask interrupts on resume

Josua Mayer <josua@solid-run.com>
    net: phy: dp83869: fix default value for tx-/rx-internal-delay

Juergen Gross <jgross@suse.com>
    xen/netback: don't do grant copy across page boundary

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: prevent deadlock by moving j1939_sk_errqueue()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Always invalidate last cached page on append write

Anand Jain <anand.jain@oracle.com>
    btrfs: scan device in non-exclusive mode

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between quota disable and quota assign ioctls

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add Lenovo Yoga Book X90F to nine_bytes_report DMI table

David Disseldorp <ddiss@suse.de>
    cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL

Paulo Alcantara <pc@manguebit.com>
    cifs: prevent infinite recursion in CIFSGetDFSRefer()

Jason A. Donenfeld <Jason@zx2c4.com>
    Input: focaltech - use explicitly signed char type

msizanoen <msizanoen@qtmlabs.xyz>
    Input: alps - fix compatibility with -funsigned-char

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Allow zero SAGAW if second-stage not supported

Horatiu Vultur <horatiu.vultur@microchip.com>
    pinctrl: ocelot: Fix alt mode for ocelot

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix flow block refcounting logic

Steffen Bätz <steffen@innosonix.de>
    net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Add missing 200G link speed reporting

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix typo in PCI id to device description string mapping

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix reporting of test result in ethtool selftest

Radoslaw Tyl <radoslawx.tyl@intel.com>
    i40e: fix registers dump after run ethtool adapter self test

Alex Elder <elder@linaro.org>
    net: ipa: compute DMA pool size properly

Tasos Sahanidis <tasos@tasossah.com>
    ALSA: ymfpci: Fix BUG_ON in probe function

Tasos Sahanidis <tasos@tasossah.com>
    ALSA: ymfpci: Create card with device-managed snd_devm_card_new()

Jakob Koschel <jkl820.git@gmail.com>
    ice: fix invalid check for empty list in ice_sched_assoc_vsi_to_agg()

Junfeng Guo <junfeng.guo@intel.com>
    ice: add profile conflict check for AVF FDIR

Wolfram Sang <wsa+renesas@sang-engineering.com>
    smsc911x: avoid PHY being resumed when interface is not up

Sven Auhagen <sven.auhagen@voleatech.de>
    net: mvpp2: parser fix PPPoE

Sven Auhagen <sven.auhagen@voleatech.de>
    net: mvpp2: parser fix QinQ

Sven Auhagen <sven.auhagen@voleatech.de>
    net: mvpp2: classifier flow fix fragmentation flags

Alyssa Ross <hi@alyssa.is>
    loop: LOOP_CONFIGURE: send uevents for partitions

Christoph Hellwig <hch@lst.de>
    loop: suppress uevents while reconfiguring the device

Tony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix memory leak in vfio_ap device driver

Ivan Orlov <ivan.orlov0322@gmail.com>
    can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Rajvi Jingar <rajvi.jingar@linux.intel.com>
    platform/x86/intel/pmc: Alder Lake PCH slp_s0_residency fix

Imre Deak <imre.deak@intel.com>
    drm/i915/tc: Fix the ICL PHY ownership check in TC-cold state

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: stmmac: don't reject VLANs when IFF_PROMISC is set

Faicker Mo <faicker.mo@ucloud.cn>
    net/net_failover: fix txq exceeding warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    regulator: Handle deferred clk

ChunHao Lin <hau@realtek.com>
    r8169: fix RTL8168H and RTL8107E rx crc error

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: microchip: ksz8863_smi: fix bulk access

SongJingyi <u201912584@hust.edu.cn>
    ptp_qoriq: fix memory leak in probe()

Jerry Snitselaar <jsnitsel@redhat.com>
    scsi: mpt3sas: Don't print sense pool info twice

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Fix crash after a double completion

Íñigo Huguet <ihuguet@redhat.com>
    sfc: ef10: don't overwrite offload features at NIC reset

Siddharth Kawar <Siddharth.Kawar@microsoft.com>
    SUNRPC: fix shutdown of NFS TCP client socket

Arseniy Krasnov <avkrasnov@sberdevices.ru>
    mtd: rawnand: meson: invalidate cache on polling ECC bit

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: Add possible_values for ThinkStation

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: only display possible_values if available

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: use correct possible_values delimiters

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: add missing type attribute

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix recursive locking at XRUN during syncing

Álvaro Fernández Rojas <noltari@gmail.com>
    mips: bmips: BCM6358: disable RAC flush for TP1

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

Anton Gusev <aagusev@ispras.ru>
    tracing: Fix wrong return in kprobe_event_gen_test.c

Antti Laakso <antti.laakso@intel.com>
    tools/power turbostat: fix decoding of HWP_STATUS

Prarit Bhargava <prarit@redhat.com>
    tools/power turbostat: Fix /dev/cpu_dma_latency warnings

Wei Chen <harperchen1110@gmail.com>
    fbdev: au1200fb: Fix potential divide by zero

Wei Chen <harperchen1110@gmail.com>
    fbdev: lxfb: Fix potential divide by zero

Wei Chen <harperchen1110@gmail.com>
    fbdev: intelfb: Fix potential divide by zero

Wei Chen <harperchen1110@gmail.com>
    fbdev: nvidia: Fix potential divide by zero

Linus Torvalds <torvalds@linux-foundation.org>
    sched_getaffinity: don't assume 'cpumask_size()' is fully initialized

Wei Chen <harperchen1110@gmail.com>
    fbdev: tgafb: Fix potential divide by zero

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ALSA: hda/ca0132: fixup buffer overrun at tuning_ctl_set()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ALSA: asihpi: check pao in control_message()

Kristian Overskeid <koverskeid@gmail.com>
    net: hsr: Don't log netdev_err message on unknown prp dst node

Jan Beulich <jbeulich@suse.com>
    x86/PVH: obtain VGA console info in Dom0

NeilBrown <neilb@suse.de>
    md: avoid signed overflow in slot_store()

Ravulapati Vishnu Vardhan Rao <quic_visr@quicinc.com>
    ASoC: codecs: tx-macro: Fix for KASAN: slab-out-of-bounds

Herbert Xu <herbert@gondor.apana.org.au>
    xfrm: Zero padding when dumping algos and encap

Ivan Bornyakov <i.bornyakov@metrotek.ru>
    bus: imx-weim: fix branch condition evaluates to a garbage value

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: don't terminate inactive sessions after a few seconds

Marco Elver <elver@google.com>
    kcsan: avoid passing -g for test

Anders Roxell <anders.roxell@linaro.org>
    kernel: kcsan: kcsan_test: build without structleak plugin

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Add 1ms delay after end transfer command without IOC

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc3: gadget: move cmd_endtransfer to extra function

Eric Biggers <ebiggers@google.com>
    fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/kvm/mmu.c                               |  45 +++++-
 arch/mips/bmips/dma.c                              |   5 +
 arch/mips/bmips/setup.c                            |   8 +
 arch/powerpc/kernel/ptrace/ptrace-view.c           |   6 +
 arch/s390/lib/uaccess.c                            |   2 +-
 arch/x86/kvm/lapic.c                               |  11 +-
 arch/x86/kvm/vmx/vmx.c                             |   6 -
 arch/x86/kvm/x86.c                                 |  21 +++
 arch/x86/xen/Makefile                              |   2 +-
 arch/x86/xen/enlighten_pv.c                        |   3 +-
 arch/x86/xen/enlighten_pvh.c                       |  13 ++
 arch/x86/xen/vga.c                                 |   5 +-
 arch/x86/xen/xen-ops.h                             |   7 +-
 arch/xtensa/kernel/traps.c                         |  16 +-
 drivers/block/loop.c                               |  21 ++-
 drivers/bus/imx-weim.c                             |   2 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  19 +++
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.h    |  12 ++
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c        |  10 +-
 drivers/gpu/drm/i915/display/intel_tc.c            |   4 +-
 drivers/input/mouse/alps.c                         |  16 +-
 drivers/input/mouse/focaltech.c                    |   8 +-
 drivers/input/touchscreen/goodix.c                 |  14 +-
 drivers/iommu/intel/dmar.c                         |   3 +-
 drivers/md/md.c                                    |   3 +
 drivers/mtd/nand/raw/meson_nand.c                  |   8 +-
 drivers/net/dsa/microchip/ksz8863_smi.c            |   9 --
 drivers/net/dsa/mv88e6xxx/chip.c                   |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   3 +
 drivers/net/ethernet/intel/i40e/i40e_diag.c        |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h        |   2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |   8 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |  73 +++++++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |  30 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |  86 +++++------
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   3 +-
 drivers/net/ethernet/realtek/r8169_phy_config.c    |   3 +
 drivers/net/ethernet/sfc/ef10.c                    |  38 +++--
 drivers/net/ethernet/sfc/efx.c                     |  17 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   7 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  61 +-------
 drivers/net/ieee802154/ca8210.c                    |   3 +-
 drivers/net/ipa/gsi_trans.c                        |   2 +-
 drivers/net/net_failover.c                         |   8 +-
 drivers/net/phy/dp83869.c                          |   6 +-
 drivers/net/xen-netback/common.h                   |   2 +-
 drivers/net/xen-netback/netback.c                  |  25 ++-
 drivers/pinctrl/pinctrl-amd.c                      |  36 +++--
 drivers/pinctrl/pinctrl-at91-pio4.c                |   1 -
 drivers/pinctrl/pinctrl-ocelot.c                   |   2 +-
 drivers/platform/x86/intel/pmc/core.c              |  13 +-
 drivers/platform/x86/think-lmi.c                   |  60 +++++++-
 drivers/ptp/ptp_qoriq.c                            |   2 +-
 drivers/regulator/fixed.c                          |   2 +-
 drivers/s390/crypto/vfio_ap_drv.c                  |   3 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   5 -
 drivers/usb/dwc3/gadget.c                          |  79 ++++++----
 drivers/video/fbdev/au1200fb.c                     |   3 +
 drivers/video/fbdev/geode/lxfb_core.c              |   3 +
 drivers/video/fbdev/intelfb/intelfbdrv.c           |   3 +
 drivers/video/fbdev/nvidia/nvidia.c                |   2 +
 drivers/video/fbdev/tgafb.c                        |   3 +
 fs/btrfs/ioctl.c                                   |   2 +
 fs/btrfs/qgroup.c                                  |  11 +-
 fs/btrfs/volumes.c                                 |  11 +-
 fs/cifs/cifsfs.h                                   |   5 +-
 fs/cifs/cifssmb.c                                  |   9 +-
 fs/ksmbd/connection.c                              |   4 +-
 fs/ksmbd/connection.h                              |   3 +-
 fs/ksmbd/transport_rdma.c                          |   2 +-
 fs/ksmbd/transport_tcp.c                           |  35 +++--
 fs/nfs/nfs4proc.c                                  |   5 +-
 fs/verity/enable.c                                 |  24 +--
 fs/zonefs/super.c                                  |  16 +-
 include/trace/events/rcu.h                         |   2 +-
 include/xen/interface/platform.h                   |   3 +
 kernel/compat.c                                    |   2 +-
 kernel/kcsan/Makefile                              |   3 +-
 kernel/sched/core.c                                |   4 +-
 kernel/trace/kprobe_event_gen_test.c               |   4 +-
 net/can/bcm.c                                      |  16 +-
 net/can/j1939/transport.c                          |   8 +-
 net/hsr/hsr_framereg.c                             |   2 +-
 net/sunrpc/xprtsock.c                              |   1 +
 net/xfrm/xfrm_user.c                               |  45 +++++-
 sound/core/pcm_lib.c                               |   2 +
 sound/pci/asihpi/hpi6205.c                         |   2 +-
 sound/pci/hda/patch_ca0132.c                       |   4 +-
 sound/pci/hda/patch_conexant.c                     |   6 +-
 sound/pci/hda/patch_realtek.c                      |   5 +
 sound/pci/ymfpci/ymfpci.c                          |   2 +-
 sound/pci/ymfpci/ymfpci_main.c                     |   2 +-
 sound/soc/codecs/lpass-tx-macro.c                  |  11 +-
 sound/usb/endpoint.c                               |  22 ++-
 sound/usb/endpoint.h                               |   4 +-
 sound/usb/format.c                                 |   8 +-
 sound/usb/pcm.c                                    |   2 +-
 tools/lib/bpf/btf_dump.c                           | 154 +++++++++++++------
 tools/power/x86/turbostat/turbostat.8              |   2 +
 tools/power/x86/turbostat/turbostat.c              |   4 +-
 .../bpf/progs/btf_dump_test_case_bitfields.c       |   2 +-
 .../bpf/progs/btf_dump_test_case_packing.c         |  80 +++++++++-
 .../bpf/progs/btf_dump_test_case_padding.c         | 171 ++++++++++++++++++---
 108 files changed, 1157 insertions(+), 454 deletions(-)


