Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66ADA6D4A16
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbjDCOoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbjDCOn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:43:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5285280F1;
        Mon,  3 Apr 2023 07:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 320DC61EE3;
        Mon,  3 Apr 2023 14:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B2EC433EF;
        Mon,  3 Apr 2023 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533017;
        bh=12zQstq3TBXExEXeXP58E5Pq9rdLFwqLZKf3LEt4/Mo=;
        h=From:To:Cc:Subject:Date:From;
        b=2WCo2H0EZSrxPQ2X9EjZCWPY4EJgkMUcyeTGi1VZJtlZmvY4pbSsxztP6qkSY64mh
         a2RyEpu6Hoocx8gTEMgOJplicuaZW/1Vl4xauwTHPRrAQoPg7z4KOgsXtKfCpp61Eh
         twc9ERKv4w1KZcEsrCYn9d5TI6nry4Hjn9b/GcS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.2 000/187] 6.2.10-rc1 review
Date:   Mon,  3 Apr 2023 16:07:25 +0200
Message-Id: <20230403140416.015323160@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.2.10-rc1
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

This is the start of the stable review cycle for the 6.2.10 release.
There are 187 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.2.10-rc1

Jan Beulich <jbeulich@suse.com>
    x86/PVH: avoid 32-bit build warning when obtaining VGA console info

Matthieu Baerts <matthieu.baerts@tessares.net>
    hsr: ratelimit only when errors are printed

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Get prange->offset after svm_range_vram_node_new

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix btf_dump's packed struct determination

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Add few corner cases to test padding handling of btf_dump

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix BTF-to-C converter's padding logic

Hans de Goede <hdegoede@redhat.com>
    usb: ucsi: Fix ucsi->connector race

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Check for kvm_vma_mte_allowed in the critical section

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Disable interrupts while walking userspace PTs

David Matlack <dmatlack@google.com>
    KVM: arm64: Retry fault if vma_lookup() results become invalid

Reiji Watanabe <reijiw@google.com>
    KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

Reiji Watanabe <reijiw@google.com>
    KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Move CSC load back into .color_commit_arm() when PSR is enabled on skl/glk

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Split icl_color_commit_noarm() from skl_color_commit_noarm()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Disable DC states for all commits

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dpt: Treat the DPT BO as a framebuffer

Chris Wilson <chris.p.wilson@linux.intel.com>
    drm/i915/gem: Flush lmem contents after construction

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Take FEC Overhead into Timeslot Calculation

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Add DSC Support for Synaptics Cascaded MST Hub

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: allow more APUs to do mode2 reset when go to S4

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix reference leak when mmaping imported buffer

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    s390: reintroduce expoline dependence to scripts

Heiko Carstens <hca@linux.ibm.com>
    s390/uaccess: add missing earlyclobber annotations to __clear_user()

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: mtd: jedec,spi-nor: Document CPOL/CPHA support

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

Benjamin Gray <bgray@linux.ibm.com>
    powerpc/64s: Fix __pte_needs_flush() false positive warning

Haren Myneni <haren@linux.ibm.com>
    powerpc/pseries/vas: Ignore VAS update for DLPAR if copy/paste is not enabled

Jens Axboe <axboe@kernel.dk>
    powerpc: Don't try to copy PPR for task with NULL pt_regs

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: int340x: processor_thermal: Fix additional deadlock

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Stop sending KEY_TOUCHPAD_TOGGLE

Johan Hovold <johan+linaro@kernel.org>
    pinctrl: at91-pio4: fix domain name assignment

Kornel Dulęba <korneld@chromium.org>
    pinctrl: amd: Disable and mask interrupts on resume

Ben Hutchings <ben@decadent.org.uk>
    modpost: Fix processing of CRCs on 32-bit build machines

Josua Mayer <josua@solid-run.com>
    net: phy: dp83869: fix default value for tx-/rx-internal-delay

Juergen Gross <jgross@suse.com>
    xen/netback: don't do grant copy across page boundary

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: prevent deadlock by moving j1939_sk_errqueue()

Mike Snitzer <snitzer@kernel.org>
    dm: fix __send_duplicate_bios() to always allow for splitting IO

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Always invalidate last cached page on append write

Ronak Doshi <doshir@vmware.com>
    vmxnet3: use gro callback when UPT is enabled

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix poll/netmsg alloc caches

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: fix rogue rsrc node grabbing

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: clear single/double poll flags on poll arming

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Do not propagate iomap_dio_rw() ENOTBLK error to user space

Filipe Manana <fdmanana@suse.com>
    btrfs: ignore fiemap path cache when there are multiple paths for a node

Anand Jain <anand.jain@oracle.com>
    btrfs: scan device in non-exclusive mode

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between quota disable and quota assign ioctls

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock when aborting transaction during relocation with scrub

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add Lenovo Yoga Book X90F to nine_bytes_report DMI table

Jonathan Denose <jdenose@chromium.org>
    Input: i8042 - add quirk for Fujitsu Lifebook A574/H

David Disseldorp <ddiss@suse.de>
    cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL

Paulo Alcantara <pc@manguebit.com>
    cifs: prevent infinite recursion in CIFSGetDFSRefer()

Jason A. Donenfeld <Jason@zx2c4.com>
    Input: focaltech - use explicitly signed char type

msizanoen <msizanoen@qtmlabs.xyz>
    Input: alps - fix compatibility with -funsigned-char

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add TUXEDO devices to i8042 quirk tables for partial fix

Javier Martinez Canillas <javierm@redhat.com>
    Revert "venus: firmware: Correct non-pix start and end addresses"

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Allow zero SAGAW if second-stage not supported

Matthias Benkmann <matthias.benkmann@gmail.com>
    Input: xpad - fix incorrectly applied patch for MAP_PROFILE_BUTTON

Horatiu Vultur <horatiu.vultur@microchip.com>
    pinctrl: ocelot: Fix alt mode for ocelot

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: add missing ppe cache flush when deleting a flow

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix L2 offloading with DSA untag offload

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix flow block refcounting logic

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sync unicast and multicast addresses for VLAN filters too

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

Jakub Kicinski <kuba@kernel.org>
    bnx2x: use the right build_skb() helper

Alex Elder <elder@linaro.org>
    net: ipa: compute DMA pool size properly

Hans de Goede <hdegoede@redhat.com>
    drm/nouveau/kms: Fix backlight registration

M Chetan Kumar <m.chetan.kumar@linux.intel.com>
    net: wwan: iosm: fixes 7560 modem crash

Tasos Sahanidis <tasos@tasossah.com>
    ALSA: ymfpci: Fix BUG_ON in probe function

Tasos Sahanidis <tasos@tasossah.com>
    ALSA: ymfpci: Create card with device-managed snd_devm_card_new()

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix tx throughput regression with direct 1G links

Jakob Koschel <jkl820.git@gmail.com>
    ice: fix invalid check for empty list in ice_sched_assoc_vsi_to_agg()

Junfeng Guo <junfeng.guo@intel.com>
    ice: add profile conflict check for AVF FDIR

Brett Creeley <brett.creeley@intel.com>
    ice: Fix ice_cfg_rdma_fltr() to only update relevant fields

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: bus: Rework system-level device notification handling

Tony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix memory leak in vfio_ap device driver

Ivan Orlov <ivan.orlov0322@gmail.com>
    can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Rajvi Jingar <rajvi.jingar@linux.intel.com>
    platform/x86/intel/pmc: Alder Lake PCH slp_s0_residency fix

Chris Wilson <chris.p.wilson@linux.intel.com>
    drm/i915/perf: Drop wakeref on GuC RC error

Imre Deak <imre.deak@intel.com>
    drm/i915/tc: Fix the ICL PHY ownership check in TC-cold state

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/i915/pmu: Use functions common with sysfs to read actual freq

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: stmmac: don't reject VLANs when IFF_PROMISC is set

Faicker Mo <faicker.mo@ucloud.cn>
    net/net_failover: fix txq exceeding warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    regulator: Handle deferred clk

ChunHao Lin <hau@realtek.com>
    r8169: fix RTL8168H and RTL8107E rx crc error

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: microchip: ksz8: fix MDB configuration with non-zero VID

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: microchip: ksz8863_smi: fix bulk access

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: microchip: ksz8: ksz8_fdb_dump: avoid extracting ghost entry from empty dynamic MAC table.

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: microchip: ksz8: fix offset for the timestamp filed

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: microchip: ksz8: fix ksz8_fdb_dump() to extract all 1024 entries

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: microchip: ksz8: fix ksz8_fdb_dump()

SongJingyi <u201912584@hust.edu.cn>
    ptp_qoriq: fix memory leak in probe()

Ahmad Fatoum <a.fatoum@pengutronix.de>
    net: dsa: realtek: fix out-of-bounds access

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

Liang He <windhl@126.com>
    platform/surface: aggregator: Add missing fwnode_handle_put()

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: Add possible_values for ThinkStation

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: only display possible_values if available

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: use correct possible_values delimiters

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: add missing type attribute

Petr Tesarik <petr.tesarik.ext@huawei.com>
    swiotlb: fix slot alignment checks

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    PCI: dwc: Fix PORT_LINK_CONTROL update when CDM check enabled

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix recursive locking at XRUN during syncing

Álvaro Fernández Rojas <noltari@gmail.com>
    mips: bmips: BCM6358: disable RAC flush for TP1

Rajnesh Kanwal <rkanwal@rivosinc.com>
    riscv/kvm: Fix VM hang in case of timer delta being zero.

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

GuoRui.Yu <GuoRui.Yu@linux.alibaba.com>
    swiotlb: fix the deadlock in swiotlb_do_find_slots

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: nand: mxic-ecc: Fix mxic_ecc_data_xfer_wait_for_completion() when irq is used

Arseniy Krasnov <AVKrasnov@sberdevices.ru>
    mtd: rawnand: meson: initialize struct with zeroes

Josef Bacik <josef@toxicpanda.com>
    btrfs: use temporary variable for space_info in btrfs_update_block_group

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix uninitialized variable warning in btrfs_update_block_group

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

Adham Faris <afaris@nvidia.com>
    net/mlx5e: Lower maximum allowed MTU in XSK to match XDP prerequisites

David Belanger <david.belanger@amd.com>
    drm/amdkfd: Fixed kfd_process cleanup on module exit.

Philipp Geulen <p.geulen@js-elektronik.de>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM620

Irvin Cote <irvincoteg@gmail.com>
    nvme-pci: fixing memory leak in probe teardown path

Linus Torvalds <torvalds@linux-foundation.org>
    sched_getaffinity: don't assume 'cpumask_size()' is fully initialized

Chen Yu <yu.c.chen@intel.com>
    ACPI: tools: pfrut: Check if the input of level and type is in the right numeric range

Wei Chen <harperchen1110@gmail.com>
    fbdev: tgafb: Fix potential divide by zero

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ALSA: hda/ca0132: fixup buffer overrun at tuning_ctl_set()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ALSA: asihpi: check pao in control_message()

Kristian Overskeid <koverskeid@gmail.com>
    net: hsr: Don't log netdev_err message on unknown prp dst node

Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
    drm/amd/display: Fix HDCP failing to enable after suspend

Chia-I Wu <olvaffe@gmail.com>
    drm/amdkfd: fix potential kgd_mem UAFs

Jane Jian <Jane.Jian@amd.com>
    drm/amdgpu/vcn: custom video info caps for sriov

Chia-I Wu <olvaffe@gmail.com>
    drm/amdkfd: fix a potential double free in pqm_create_queue

Xiaogang Chen <Xiaogang.Chen@amd.com>
    drm/amdkfd: Fix BO offset for multi-VMA page migration

Jan Beulich <jbeulich@suse.com>
    x86/PVH: obtain VGA console info in Dom0

NeilBrown <neilb@suse.de>
    md: avoid signed overflow in slot_store()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: check basic rates validity

Emil Abildgaard Svendsen <EMAS@bang-olufsen.dk>
    ASoC: hdmi-codec: only startup/shutdown on supported streams

Rander Wang <rander.wang@intel.com>
    ASoC: SOF: IPC4: update gain ipc msg definition to align with fw

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda-ctrl: re-add sleep after entering and exiting reset

Rander Wang <rander.wang@intel.com>
    ASoC: SOF: Intel: hda-dsp: harden D0i3 programming sequence

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: pci-tng: revert invalid bar size setting

Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
    ASoC: SOF: ipc4-topology: Fix incorrect sample rate print unit

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc3: Check for upper size limit for the received message

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Book X90

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Add skip i2c clients quirk for Acer Iconia One 7 B1-750

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Introduce an acpi_quirk_skip_gpio_event_handlers() helper

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    ACPI: video: Add backlight=native DMI quirk for Dell Vostro 15 3535

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    zstd: Fix definition of assert()

Nick Terrell <terrelln@fb.com>
    lib: zstd: Backport fix for in-place decompression

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: nau8825: Adjust clock control

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: ssm4567: Remove nau8825 bits

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: rt5682: Explicitly define codec format

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: da7219: Explicitly define codec format

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: max98357a: Explicitly define codec format

Ravulapati Vishnu Vardhan Rao <quic_visr@quicinc.com>
    ASoC: codecs: tx-macro: Fix for KASAN: slab-out-of-bounds

Herbert Xu <herbert@gondor.apana.org.au>
    xfrm: Zero padding when dumping algos and encap

Paulo Alcantara <pc@manguebit.com>
    cifs: fix missing unload_nls() in smb2_reconnect()

Eric Biggers <ebiggers@google.com>
    fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: drop space_info->active_total_bytes

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: count fresh BG region as zone unusable

Josef Bacik <josef@toxicpanda.com>
    btrfs: rename BTRFS_FS_NO_OVERCOMMIT to BTRFS_FS_ACTIVE_ZONE_TRACKING

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Fix error message in zonefs_file_dio_append()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Separate zone information from inode information

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Reduce struct zonefs_inode_info size

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Simplify IO error handling

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Reorganize code

Shyam Prasad N <sprasad@microsoft.com>
    cifs: avoid race conditions with parallel reconnects

Paulo Alcantara <pc@manguebit.com>
    cifs: prevent data race in cifs_reconnect_tcon()

Shyam Prasad N <sprasad@microsoft.com>
    cifs: update ip_addr for ses only for primary chan setup

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Limit USB3 bandwidth of certain Intel USB4 host routers


-------------

Diffstat:

 .../devicetree/bindings/mtd/jedec,spi-nor.yaml     |    7 +
 Makefile                                           |    4 +-
 arch/arm64/kvm/mmu.c                               |   99 +-
 arch/arm64/kvm/pmu-emul.c                          |    3 +-
 arch/arm64/kvm/sys_regs.c                          |   21 +-
 arch/mips/bmips/dma.c                              |    5 +
 arch/mips/bmips/setup.c                            |    8 +
 arch/powerpc/include/asm/book3s/64/tlbflush.h      |    9 +-
 arch/powerpc/kernel/ptrace/ptrace-view.c           |    6 +
 arch/powerpc/platforms/pseries/vas.c               |    8 +
 arch/riscv/kvm/vcpu_timer.c                        |    6 +-
 arch/s390/Makefile                                 |    2 +-
 arch/s390/lib/uaccess.c                            |    2 +-
 arch/x86/xen/Makefile                              |    2 +-
 arch/x86/xen/enlighten_pv.c                        |    3 +-
 arch/x86/xen/enlighten_pvh.c                       |   13 +
 arch/x86/xen/vga.c                                 |    5 +-
 arch/x86/xen/xen-ops.h                             |    7 +-
 arch/xtensa/kernel/traps.c                         |   16 +-
 drivers/acpi/bus.c                                 |   83 +-
 drivers/acpi/video_detect.c                        |    7 +
 drivers/acpi/x86/utils.c                           |   45 +-
 drivers/block/loop.c                               |   18 +-
 drivers/gpio/gpiolib-acpi.c                        |    3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |    4 +
 drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h        |    3 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |  103 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   16 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |   33 +-
 drivers/gpu/drm/amd/amdkfd/kfd_module.c            |    1 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |    1 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   67 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |    4 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |    2 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   51 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.h    |   15 +
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c        |   10 +-
 drivers/gpu/drm/i915/display/intel_color.c         |   44 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   28 +-
 drivers/gpu/drm/i915/display/intel_dpt.c           |    2 +
 drivers/gpu/drm/i915/display/intel_tc.c            |    4 +-
 drivers/gpu/drm/i915/gem/i915_gem_lmem.c           |    3 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.h         |    2 +-
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h   |    3 +
 drivers/gpu/drm/i915/gt/intel_rps.c                |   38 +-
 drivers/gpu/drm/i915/gt/intel_rps.h                |    4 +-
 drivers/gpu/drm/i915/i915_perf.c                   |   14 +-
 drivers/gpu/drm/i915/i915_perf_types.h             |    6 +
 drivers/gpu/drm/i915/i915_pmu.c                    |   10 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |    7 +-
 drivers/input/joystick/xpad.c                      |    7 +-
 drivers/input/mouse/alps.c                         |   16 +-
 drivers/input/mouse/focaltech.c                    |    8 +-
 drivers/input/serio/i8042-acpipnpio.h              |   36 +
 drivers/input/touchscreen/goodix.c                 |   14 +-
 drivers/iommu/intel/dmar.c                         |    3 +-
 drivers/md/dm.c                                    |    2 +
 drivers/md/md.c                                    |    3 +
 drivers/media/platform/qcom/venus/firmware.c       |    4 +-
 drivers/mtd/nand/ecc-mxic.c                        |    1 +
 drivers/mtd/nand/raw/meson_nand.c                  |   10 +-
 drivers/net/dsa/microchip/ksz8795.c                |   11 +-
 drivers/net/dsa/microchip/ksz8863_smi.c            |    9 -
 drivers/net/dsa/microchip/ksz_common.c             |   12 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |    9 +-
 drivers/net/dsa/realtek/realtek-mdio.c             |    5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   16 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |    1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |    3 +
 drivers/net/ethernet/intel/i40e/i40e_diag.c        |   11 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h        |    2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |    8 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   26 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   73 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   30 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |   86 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |    8 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |    6 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   10 +-
 drivers/net/ethernet/realtek/r8169_phy_config.c    |    3 +
 drivers/net/ethernet/sfc/ef10.c                    |   38 +-
 drivers/net/ethernet/sfc/efx.c                     |   17 +-
 drivers/net/ethernet/smsc/smsc911x.c               |    7 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |    1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   61 +-
 drivers/net/ieee802154/ca8210.c                    |    3 +-
 drivers/net/ipa/gsi_trans.c                        |    2 +-
 drivers/net/net_failover.c                         |    8 +-
 drivers/net/phy/dp83869.c                          |    6 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |    4 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.c              |    7 +
 drivers/net/xen-netback/common.h                   |    2 +-
 drivers/net/xen-netback/netback.c                  |   25 +-
 drivers/nvme/host/pci.c                            |    3 +
 drivers/pci/controller/dwc/pcie-designware.c       |   10 +-
 drivers/pinctrl/pinctrl-amd.c                      |   36 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                |    1 -
 drivers/pinctrl/pinctrl-ocelot.c                   |    2 +-
 drivers/platform/surface/aggregator/bus.c          |    4 +-
 drivers/platform/x86/ideapad-laptop.c              |   23 +-
 drivers/platform/x86/intel/pmc/core.c              |   13 +-
 drivers/platform/x86/think-lmi.c                   |   60 +-
 drivers/ptp/ptp_qoriq.c                            |    2 +-
 drivers/regulator/fixed.c                          |    2 +-
 drivers/s390/crypto/vfio_ap_drv.c                  |    3 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |    4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |    5 -
 .../int340x_thermal/processor_thermal_device_pci.c |    1 -
 drivers/thunderbolt/quirks.c                       |   31 +
 drivers/thunderbolt/tb.h                           |    3 +
 drivers/thunderbolt/usb4.c                         |   17 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   22 +-
 drivers/video/fbdev/au1200fb.c                     |    3 +
 drivers/video/fbdev/geode/lxfb_core.c              |    3 +
 drivers/video/fbdev/intelfb/intelfbdrv.c           |    3 +
 drivers/video/fbdev/nvidia/nvidia.c                |    2 +
 drivers/video/fbdev/tgafb.c                        |    3 +
 fs/btrfs/backref.c                                 |   85 +-
 fs/btrfs/block-group.c                             |   30 +-
 fs/btrfs/free-space-cache.c                        |    8 +-
 fs/btrfs/fs.h                                      |    7 +-
 fs/btrfs/ioctl.c                                   |    2 +
 fs/btrfs/qgroup.c                                  |   11 +-
 fs/btrfs/space-info.c                              |   42 +-
 fs/btrfs/space-info.h                              |    2 -
 fs/btrfs/transaction.c                             |   15 +-
 fs/btrfs/volumes.c                                 |   20 +-
 fs/btrfs/zoned.c                                   |   31 +-
 fs/cifs/cifsfs.h                                   |    5 +-
 fs/cifs/cifsproto.h                                |    1 +
 fs/cifs/cifssmb.c                                  |   52 +-
 fs/cifs/connect.c                                  |   64 +-
 fs/cifs/misc.c                                     |   44 +
 fs/cifs/smb2pdu.c                                  |  132 +-
 fs/cifs/smb2transport.c                            |   17 +-
 fs/nfs/nfs4proc.c                                  |    5 +-
 fs/verity/enable.c                                 |   24 +-
 fs/zonefs/Makefile                                 |    2 +-
 fs/zonefs/file.c                                   |  902 +++++++++++
 fs/zonefs/super.c                                  | 1640 ++++++--------------
 fs/zonefs/trace.h                                  |   20 +-
 fs/zonefs/zonefs.h                                 |  100 +-
 include/acpi/acpi_bus.h                            |    5 +
 include/trace/events/rcu.h                         |    2 +-
 include/xen/interface/platform.h                   |    3 +
 io_uring/alloc_cache.h                             |    1 +
 io_uring/poll.c                                    |    1 +
 io_uring/rsrc.h                                    |   12 +-
 kernel/compat.c                                    |    2 +-
 kernel/dma/swiotlb.c                               |   24 +-
 kernel/sched/core.c                                |    4 +-
 kernel/trace/kprobe_event_gen_test.c               |    4 +-
 lib/zstd/common/zstd_deps.h                        |    2 +-
 lib/zstd/decompress/zstd_decompress.c              |   25 +-
 net/can/bcm.c                                      |   16 +-
 net/can/j1939/transport.c                          |    8 +-
 net/dsa/slave.c                                    |  121 +-
 net/hsr/hsr_framereg.c                             |    2 +-
 net/mac80211/cfg.c                                 |   21 +-
 net/sunrpc/xprtsock.c                              |    1 +
 net/xfrm/xfrm_user.c                               |   45 +-
 scripts/mod/modpost.c                              |    2 +-
 sound/core/pcm_lib.c                               |    2 +
 sound/pci/asihpi/hpi6205.c                         |    2 +-
 sound/pci/hda/patch_ca0132.c                       |    4 +-
 sound/pci/hda/patch_conexant.c                     |    6 +-
 sound/pci/hda/patch_realtek.c                      |    5 +
 sound/pci/ymfpci/ymfpci.c                          |    2 +-
 sound/pci/ymfpci/ymfpci_main.c                     |    2 +-
 sound/soc/codecs/hdmi-codec.c                      |   11 +
 sound/soc/codecs/lpass-tx-macro.c                  |   11 +-
 sound/soc/intel/avs/boards/da7219.c                |   21 +
 sound/soc/intel/avs/boards/max98357a.c             |   22 +
 sound/soc/intel/avs/boards/nau8825.c               |   14 +-
 sound/soc/intel/avs/boards/rt5682.c                |   22 +
 sound/soc/intel/avs/boards/ssm4567.c               |   31 -
 sound/soc/sof/intel/hda-ctrl.c                     |    3 +
 sound/soc/sof/intel/hda-dsp.c                      |   12 +
 sound/soc/sof/intel/pci-tng.c                      |    6 +-
 sound/soc/sof/ipc3.c                               |    5 +-
 sound/soc/sof/ipc4-control.c                       |    3 +-
 sound/soc/sof/ipc4-topology.c                      |    6 +-
 sound/soc/sof/ipc4-topology.h                      |    6 +-
 sound/usb/endpoint.c                               |   22 +-
 sound/usb/endpoint.h                               |    4 +-
 sound/usb/format.c                                 |    8 +-
 sound/usb/pcm.c                                    |    2 +-
 tools/lib/bpf/btf_dump.c                           |  154 +-
 tools/power/acpi/tools/pfrut/pfrut.c               |   18 +-
 tools/power/x86/turbostat/turbostat.8              |    2 +
 tools/power/x86/turbostat/turbostat.c              |    4 +-
 .../bpf/progs/btf_dump_test_case_bitfields.c       |    2 +-
 .../bpf/progs/btf_dump_test_case_packing.c         |   80 +-
 .../bpf/progs/btf_dump_test_case_padding.c         |  162 +-
 197 files changed, 3771 insertions(+), 2190 deletions(-)


