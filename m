Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430755B6F2F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiIMOKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiIMOJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:09:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1745B04B;
        Tue, 13 Sep 2022 07:08:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECA6FB80EFC;
        Tue, 13 Sep 2022 14:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14A0C433D6;
        Tue, 13 Sep 2022 14:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078121;
        bh=IcdafbfeilZtaX9tMKf4nxs97oDMmwy3TwKJ5ytcXyc=;
        h=From:To:Cc:Subject:Date:From;
        b=UiBARBELqMiTMnR6s9+cGU5Tf+T9y9jPHSPKOybJT79+KD0pHY629W05EyfRA6KZU
         nl3HZb0yIrpv3MBfH11z/IcoIeQ18kSf6rk//2+BZyLflouXJdULvvf7mVA0XpXK8L
         tc7Wx6j/DeUbx8AsxMxd27a/JZOXHTBT0obLIPm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.19 000/192] 5.19.9-rc1 review
Date:   Tue, 13 Sep 2022 16:01:46 +0200
Message-Id: <20220913140410.043243217@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.9-rc1
X-KernelTest-Deadline: 2022-09-15T14:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.19.9 release.
There are 192 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.9-rc1

Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
    drm/amd/display: Removing assert statements for Linux

Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
    drm/amd/display: Add SMU logging code

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Fix false ownership failure on AMD systems with PASID activated

Jean-Philippe Brucker <jean-philippe@linaro.org>
    iommu/virtio: Fix interaction with VFIO

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Correctly calculate sagaw value of IOMMU

Mark Brown <broonie@kernel.org>
    arm64/bti: Disable in kernel BTI when cross section thunks are broken

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) autoload module via DMI data

Urs Schroffenegger <nabajour@lampshade.ch>
    hwmon: (asus-ec-sensors) add definitions for ROG ZENITH II EXTREME

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) add missing sensors for X570-I GAMING

Michael Carns <mike@carns.com>
    hwmon: (asus-ec-sensors) add support for Maximus XI Hero

Shady Nawara <shady.nawara@outlook.com>
    hwmon: (asus-ec-sensors) add support for Strix Z690-a D4

Sasha Levin <sashal@kernel.org>
    Revert "arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags""

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf stat: Fix L2 Topdown metrics disappear for raw events

Kan Liang <kan.liang@linux.intel.com>
    perf evlist: Always use arch_evlist__add_default_attrs()

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix possible recursive locking in intel_iommu_init()

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) enable polling for all VM channels

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) fix multi-channel voltage reading

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) fix voltage equation for negative source input

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) update pvt->v_num and vm_num to the actual number of used sensors

Eliav Farber <farbere@amazon.com>
    hwmon: (mr75203) fix VM sensor allocation when "intel,vm-map" not defined

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: tc-taprio intervals smaller than MTU should send at least one packet

Vladimir Oltean <vladimir.oltean@nxp.com>
    time64.h: consolidate uses of PSEC_PER_NSEC

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/boot: fix absolute zero lowcore corruption on boot

John Sperbeck <jsperbeck@google.com>
    iommu/amd: use full 64-bit value in build_completion_wait()

Chao Gao <chao.gao@intel.com>
    swiotlb: avoid potential left shift overflow

Hangbin Liu <liuhangbin@gmail.com>
    bonding: accept unsolicited NA message

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: bonding: replace dev_trans_start() with the jiffies of the last ARP/NS

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    i40e: Fix ADQ rate limiting for PF

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    i40e: Refactor tc mqprio checks

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: disable header exports for UML in a straightforward way

Yang Ling <gnaygnil@gmail.com>
    MIPS: loongson32: ls1c: Fix hang during startup

Casey Schaufler <casey@schaufler-ca.com>
    Smack: Provide read control for io_uring_cmd

Paul Moore <paul@paul-moore.com>
    selinux: implement the security_uring_cmd() LSM hook

Luis Chamberlain <mcgrof@kernel.org>
    lsm,io_uring: add LSM hooks for the new uring_cmd file op

Nathan Chancellor <nathan@kernel.org>
    ASoC: mchp-spdiftx: Fix clang -Wbitfield-constant-conversion

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdiftx: remove references to mchp_i2s_caps

Alexandru Gagniuc <mr.nuke.me@gmail.com>
    hwmon: (tps23861) fix byte order in resistance register

Adrian Hunter <adrian.hunter@intel.com>
    perf record: Fix synthesis failure warnings

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf script: Fix Cannot print 'iregs' field for hybrid systems

Adrian Hunter <adrian.hunter@intel.com>
    perf dlfilter dlfilter-show-cycles: Fix types for print format

Adrian Hunter <adrian.hunter@intel.com>
    libperf evlist: Fix per-thread mmaps for multi-threaded targets

Toke Høiland-Jørgensen <toke@toke.dk>
    sch_sfb: Also store skb len before calling child enqueue

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: phy: lan87xx: change interrupt src of link_up to comm_ready

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: recycle kbuf recycle on tw requeue

Yacan Liu <liuyacan@corp.netease.com>
    net/smc: Fix possible access to freed memory in link clear

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: check max allowed hash in mtk_ppe_check_skb

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: fix typo in __mtk_foe_entry_clear

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: access QSYS_TAG_CONFIG under tas_lock in vsc9959_sched_speed_set

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: disable cut-through forwarding for frames oversized for tc-taprio

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Report RNR NAK generation in device caps

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Return correct WC error for bind operation failure

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Return error on MR deregister CQP failure

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Report the correct max cqes from query device

Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
    nvmet: fix mar and mor off-by-one errors

Qu Wenruo <wqu@suse.com>
    btrfs: fix the max chunk size and stripe length calculation

Neal Cardwell <ncardwell@google.com>
    tcp: fix early ETIMEDOUT after spurious non-SACK RTO

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix regression that causes sporadic requests to time out

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix UAF when detecting digest errors

Gao Xiang <xiang@kernel.org>
    erofs: fix pcluster use-after-free on UP platforms

Sun Ke <sunke32@huawei.com>
    erofs: fix error return code in erofs_fscache_{meta_,}read_folio

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix mounting with conventional zones

Chris Mi <cmi@nvidia.com>
    RDMA/mlx5: Set local port to one when accessing counters

Yishai Hadas <yishaih@nvidia.com>
    IB/core: Fix a nested dead lock as part of ODP flow

David Lebrun <dlebrun@google.com>
    ipv6: sr: fix out-of-bounds read when setting HMAC data.

Hangbin Liu <liuhangbin@gmail.com>
    bonding: add all node mcast address when slave up

Hangbin Liu <liuhangbin@gmail.com>
    bonding: use unspecified address if no available link local address

Linus Walleij <linus.walleij@linaro.org>
    RDMA/siw: Pass a pointer to virt_to_page()

Ming Lei <ming.lei@redhat.com>
    block: don't add partitions if GD_SUPPRESS_PART_SCAN is set

Paul Durrant <pdurrant@amazon.com>
    xen-netback: only remove 'hotplug-status' when the vif is actually destroyed

Csókás Bence <csokas.bence@prolan.hu>
    net: fec: Use a spinlock to guard `fep->ptp_clk_on`

Ivan Vecera <ivecera@redhat.com>
    iavf: Detach device during reset task

Ivan Vecera <ivecera@redhat.com>
    i40e: Fix kernel crash during module removal

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: use bitmap_free instead of devm_kfree

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    ice: Fix DMA mappings leak

Eric Dumazet <edumazet@google.com>
    tcp: TX zerocopy should not sense pfmemalloc status

Pavel Begunkov <asml.silence@gmail.com>
    net: introduce __skb_fill_page_desc_noacc

Dan Carpenter <dan.carpenter@oracle.com>
    tipc: fix shift wrapping bug in map_get()

Toke Høiland-Jørgensen <toke@toke.dk>
    sch_sfb: Don't assume the skb is still around after enqueueing to child

Heiner Kallweit <hkallweit1@gmail.com>
    Revert "net: phy: meson-gxl: improve link-up behavior"

Sander Vanheule <sander@svanheule.net>
    kunit: fix assert_type for comparison macros

David Howells <dhowells@redhat.com>
    afs: Use the operation issue time instead of the reply time for callbacks

David Howells <dhowells@redhat.com>
    rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()

David Howells <dhowells@redhat.com>
    rxrpc: Fix ICMP/ICMP6 error handling

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Register card again for iface over delayed_register option

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Inform the delayed registration more properly

yangx.jy@fujitsu.com <yangx.jy@fujitsu.com>
    RDMA/srp: Set scmnd->result only when scmnd is not NULL

David Leadbeater <dgl@dgl.cx>
    netfilter: nf_conntrack_irc: Fix forged IP logic

Conor Dooley <conor.dooley@microchip.com>
    riscv: dts: microchip: use an mpfs specific l2 compatible

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: clean up hook list when offload flags check fails

Harsh Modi <harshmodi@google.com>
    netfilter: br_netfilter: Drop dst references before setting.

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d2_icp: don't keep vdd_other enabled all the time

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d27_wlsom1: don't keep ldo2 enabled all the time

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama7g5ek: specify proper regulator output ranges

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d2_icp: specify proper regulator output ranges

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama5d27_wlsom1: specify proper regulator output ranges

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: fix DDR recalibration when resuming from backup and self-refresh

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: fix self-refresh for sama7g5

Ajay.Kathat@microchip.com <Ajay.Kathat@microchip.com>
    wifi: wilc1000: fix DMA on stack objects

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Remove the num_qpc_timer variable

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fix wrong fixed value of qp->rq.wqe_shift

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix supported page size

Liang He <windhl@126.com>
    soc: brcmstb: pm-arm: Fix refcount leak and __iomem leak bugs

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/cma: Fix arguments order in net device validation

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a779g0: Fix HSCIF0 interrupt number

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/irdma: Fix drain SQ hang with no completion

Jens Wiklander <jens.wiklander@linaro.org>
    tee: fix compiler warning in tee_shm_register()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Kconfig: Make IPC_MESSAGE_INJECTOR depend on SND_SOC_SOF

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Kconfig: Make IPC_FLOOD_TEST depend on SND_SOC_SOF

Andrew Halaney <ahalaney@redhat.com>
    regulator: core: Clean up on enable failure

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    arm64: dts: freescale: verdin-imx8mp: fix atmel_mxt_ts reset polarity

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    arm64: dts: freescale: verdin-imx8mm: fix atmel_mxt_ts reset polarity

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mm-venice-gw7901: fix port/phy validation

Philippe Schenker <philippe.schenker@toradex.com>
    arm64: dts: verdin-imx8mm: add otg2 pd to usbphy

Marek Vasut <marex@denx.de>
    soc: imx: gpcv2: Assert reset before ungating clock

Vladimir Oltean <vladimir.oltean@nxp.com>
    arm64: dts: ls1028a-qds-65bb: don't use in-band autoneg for 2500base-x

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: fix spi-flash compatible

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: remove duplicated node

David Jander <david@protonic.nl>
    ARM: dts: imx6qdl-vicut1.dtsi: Fix node name backlight_led

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs-srv: Pass the correct number of entries for dma mapped SGL

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs-clt: Use the right sg_cnt after ib_dma_map_sg

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: imx8mq-tqma8mq: Remove superfluous interrupt-names

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-venice-gw74xx: fix sai2 pin settings

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    regmap: spi: Reserve space for register address/padding

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: sm8250: add missing module owner

Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
    arm64: dts: imx8mm-verdin: use level interrupt for mcp251xfd

Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
    arm64: dts: imx8mm-verdin: update CAN clock to 40MHz

Marco Felsch <m.felsch@pengutronix.de>
    Revert "soc: imx: imx8m-blk-ctrl: set power device name"

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Only report button state if there was a button interrupt

Robin Murphy <robin.murphy@arm.com>
    spi: bitbang: Fix lsb-first Rx

David Howells <dhowells@redhat.com>
    smb3: missing inode locks in zero range

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: remove useless parameter 'is_fsctl' from SMB2_ioctl()

Tejun Heo <tj@kernel.org>
    cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Tejun Heo <tj@kernel.org>
    cgroup: Elide write-locking threadgroup_rwsem when updating csses on an empty subtree

Yang Yingliang <yangyingliang@huawei.com>
    scsi: lpfc: Add missing destroy_workqueue() in error path

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix use-after-free warning

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Implement WaEdpLinkRateDataReload

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/i915/slpc: Let's fix the PCODE min freq table setup for SLPC

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/bios: Copy the whole MIPI sequence block

Bart Van Assche <bvanassche@acm.org>
    nvmet: fix a use-after-free

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    driver core: fix driver_set_override() issue with empty strings

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/amd/display: fix memory leak when using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    sched/debug: fix dentry leak in update_sched_domain_debugfs

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    debugfs: add debugfs_lookup_and_remove()

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    perf: RISC-V: fix access beyond allocated array

Christian A. Ehrhardt <lk@c--e.de>
    kprobes: Prohibit probes in gate area

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Unpin zero pages

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix API misuse of zone finish waiting

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    btrfs: zoned: set pseudo max append zone limit in zone emulation mode

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Fix to check event_mutex is held while accessing trigger list

Yipeng Zou <zouyipeng@huawei.com>
    tracing: hold caller_addr to hardirq_{enable,disable}_ip

Brian Norris <briannorris@chromium.org>
    tracefs: Only clobber mode/uid/gid on remount if asked

Dongxiang Ke <kdx.glider@gmail.com>
    ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Clear fixed clock rate at closing EP

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Split endpoint setups for hw_params and prepare

Pattara Teerapong <pteerapong@chromium.org>
    ALSA: aloop: Fix random zeros in capture data when using jiffies timer

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Once again fix regression of page allocations with IOMMU

Tasos Sahanidis <tasos@tasossah.com>
    ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC

Qu Huang <jinsdb@126.com>
    drm/amdgpu: mmVM_L2_CNTL3 register not initialized correctly

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: add sdma instance check for gfx11 CGCG

Borislav Petkov <bp@suse.de>
    x86/sev: Mark snp_abort() noreturn

Yang Yingliang <yangyingliang@huawei.com>
    fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()

Shigeru Yoshida <syoshida@redhat.com>
    fbdev: fbcon: Destroy mutex on freeing struct fb_info

Yu Zhe <yuzhe@nfschina.com>
    fbdev: omapfb: Fix tests for platform_get_irq() failure

David Sloan <david.sloan@eideticom.com>
    md: Flush workqueue md_rdev_misc_wq in md_alloc()

lily <floridsleeves@gmail.com>
    net/core/skbuff: Check the return value of skb_copy_bits()

Lukasz Luba <lukasz.luba@arm.com>
    cpufreq: check only freq_table in __resolve_freq()

Lee, Chun-Yi <joeyli.kernel@gmail.com>
    thermal/int340x_thermal: handle data_vault when the value is ZERO_SIZE_PTR

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: work around exceeded receive window

Mark Brown <broonie@kernel.org>
    arm64/signal: Raise limit on stack frames

Ionela Voinescu <ionela.voinescu@arm.com>
    arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly

Helge Deller <deller@gmx.de>
    parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Li Qiong <liqiong@nfschina.com>
    parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Helge Deller <deller@gmx.de>
    Revert "parisc: Show error if wrong 32/64-bit compiler is being used"

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Reduce the power mode change timeout

Zhenneng Li <lizhenneng@kylinos.cn>
    drm/radeon: add a force flush to delay work when radeon

shaoyunl <shaoyun.liu@amd.com>
    drm/amdgpu: Remove the additional kfd pre reset call for sriov

Candice Li <candice.li@amd.com>
    drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amdgpu: fix hive reference leak when adding xgmi device

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amdgpu: Move psp_xgmi_terminate call from amdgpu_xgmi_remove_device to psp_hw_fini

Jeffy Chen <jeffy.chen@rock-chips.com>
    drm/gem: Fix GEM handle release errors

Guixin Liu <kanie@linux.alibaba.com>
    scsi: megaraid_sas: Fix double kfree()

Brian Bunker <brian@purestorage.com>
    scsi: core: Allow the ALUA transitioning state enough time

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX

Yee Lee <yee.lee@mediatek.com>
    Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

Mathew McBride <matt@traverse.com.au>
    soc: fsl: select FSL_GUTS driver for DPIO

Linus Torvalds <torvalds@linux-foundation.org>
    fs: only do a memory barrier for the first set_buffer_uptodate()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: mt7921e: fix crash in chip reset fail

Hyunwoo Kim <imv4bel@gmail.com>
    efi: capsule-loader: Fix use-after-free in efi_capsule_write

Ard Biesheuvel <ardb@kernel.org>
    efi: libstub: Disable struct randomization


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst             |   2 +
 Documentation/hwmon/asus_ec_sensors.rst            |   4 +
 Makefile                                           |   7 +-
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi        |  21 +-
 arch/arm/boot/dts/at91-sama5d2_icp.dts             |  21 +-
 arch/arm/boot/dts/at91-sama7g5ek.dts               |  18 +-
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |  12 +-
 arch/arm/boot/dts/imx6qdl-vicut1.dtsi              |   2 +-
 arch/arm/mach-at91/pm.c                            |  36 +-
 arch/arm/mach-at91/pm_suspend.S                    |  24 +-
 arch/arm64/Kconfig                                 |  19 +
 .../boot/dts/freescale/fsl-ls1028a-qds-65bb.dts    |   1 -
 .../boot/dts/freescale/imx8mm-venice-gw7901.dts    |   4 +
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |  11 +-
 .../boot/dts/freescale/imx8mp-venice-gw74xx.dts    |   8 +-
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi   |   4 +-
 arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi  |   1 -
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi          |   2 +-
 arch/arm64/kernel/cpu_errata.c                     |  10 +
 arch/arm64/kernel/cpufeature.c                     |   5 +-
 arch/arm64/kernel/hibernate.c                      |   5 +
 arch/arm64/kernel/mte.c                            |   9 +
 arch/arm64/kernel/signal.c                         |   2 +-
 arch/arm64/kernel/topology.c                       |  32 +-
 arch/arm64/mm/copypage.c                           |   9 +
 arch/arm64/mm/mteswap.c                            |   9 +
 arch/arm64/tools/cpucaps                           |   1 +
 arch/mips/loongson32/ls1c/board.c                  |   1 -
 arch/parisc/include/asm/bitops.h                   |   8 -
 arch/parisc/kernel/head.S                          |  43 +-
 arch/riscv/boot/dts/microchip/mpfs.dtsi            |   2 +-
 arch/s390/kernel/nmi.c                             |   2 +-
 arch/s390/kernel/setup.c                           |   1 +
 arch/x86/include/asm/sev.h                         |   2 +-
 arch/x86/kernel/sev.c                              |   2 +-
 block/partitions/core.c                            |   3 +
 drivers/base/driver.c                              |   6 +
 drivers/base/regmap/regmap-spi.c                   |   8 +
 drivers/cpufreq/cpufreq.c                          |   2 +-
 drivers/firmware/efi/capsule-loader.c              |  31 +-
 drivers/firmware/efi/libstub/Makefile              |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  18 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c            |   1 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   2 +-
 .../dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c        |  18 +-
 .../drm/amd/display/dc/clk_mgr/dcn301/dcn301_smu.c |  17 +
 .../drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c   |  14 +-
 .../drm/amd/display/dc/clk_mgr/dcn315/dcn315_smu.c |  14 +-
 .../drm/amd/display/dc/clk_mgr/dcn316/dcn316_smu.c |  14 +-
 drivers/gpu/drm/drm_gem.c                          |  17 +-
 drivers/gpu/drm/drm_internal.h                     |   4 +-
 drivers/gpu/drm/drm_prime.c                        |  20 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |   7 +
 .../gpu/drm/i915/display/intel_dp_link_training.c  |  22 +
 drivers/gpu/drm/i915/gt/intel_llc.c                |  19 +-
 drivers/gpu/drm/i915/gt/intel_rps.c                |  50 +++
 drivers/gpu/drm/i915/gt/intel_rps.h                |   2 +
 drivers/gpu/drm/radeon/radeon_device.c             |   3 +
 drivers/hwmon/asus-ec-sensors.c                    | 446 ++++++++++++++-------
 drivers/hwmon/mr75203.c                            |  72 +++-
 drivers/hwmon/tps23861.c                           |  10 +-
 drivers/infiniband/core/cma.c                      |   4 +-
 drivers/infiniband/core/umem_odp.c                 |   2 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   4 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   7 +-
 drivers/infiniband/hw/irdma/uk.c                   |   4 +-
 drivers/infiniband/hw/irdma/utils.c                |  15 +-
 drivers/infiniband/hw/irdma/verbs.c                |  13 +-
 drivers/infiniband/hw/mlx5/mad.c                   |   6 +
 drivers/infiniband/sw/siw/siw_qp_tx.c              |  18 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   9 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  14 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   3 +-
 drivers/iommu/amd/iommu.c                          |   3 +-
 drivers/iommu/amd/iommu_v2.c                       |   2 +
 drivers/iommu/intel/dmar.c                         |   7 +
 drivers/iommu/intel/iommu.c                        |  55 ++-
 drivers/iommu/iommu.c                              |  21 +-
 drivers/iommu/virtio-iommu.c                       |  11 +
 drivers/md/md.c                                    |   1 +
 drivers/net/bonding/bond_main.c                    |  55 ++-
 drivers/net/dsa/ocelot/felix_vsc9959.c             | 162 +++++---
 drivers/net/ethernet/freescale/fec.h               |   1 -
 drivers/net/ethernet/freescale/fec_main.c          |  17 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |  28 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |  14 +
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  23 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  14 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  17 -
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  63 +++
 drivers/net/ethernet/intel/ice/ice_xsk.h           |   8 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |   4 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   2 +-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |   3 +
 drivers/net/phy/meson-gxl.c                        |   8 +-
 drivers/net/phy/microchip_t1.c                     |  58 ++-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   5 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   2 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |   1 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     |  39 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |  15 +-
 drivers/net/xen-netback/xenbus.c                   |   2 +-
 drivers/nvme/host/tcp.c                            |   7 +-
 drivers/nvme/target/core.c                         |   6 +-
 drivers/nvme/target/zns.c                          |  17 +-
 drivers/parisc/ccio-dma.c                          |  11 +-
 drivers/perf/riscv_pmu_sbi.c                       |   2 +-
 drivers/regulator/core.c                           |   9 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   5 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   1 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   2 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  10 +-
 drivers/scsi/scsi_lib.c                            |  44 +-
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                |  50 ++-
 drivers/soc/fsl/Kconfig                            |   1 +
 drivers/soc/imx/gpcv2.c                            |   5 +-
 drivers/soc/imx/imx8m-blk-ctrl.c                   |   1 -
 drivers/spi/spi-bitbang-txrx.h                     |   6 +-
 drivers/tee/tee_shm.c                              |   1 +
 .../intel/int340x_thermal/int3400_thermal.c        |   9 +-
 drivers/ufs/core/ufshcd.c                          |   9 +-
 drivers/vfio/vfio_iommu_type1.c                    |  12 +
 drivers/video/fbdev/chipsfb.c                      |   1 +
 drivers/video/fbdev/core/fbsysfs.c                 |   4 +
 drivers/video/fbdev/omap/omapfb_main.c             |   4 +-
 fs/afs/flock.c                                     |   2 +-
 fs/afs/fsclient.c                                  |   2 +-
 fs/afs/internal.h                                  |   3 +-
 fs/afs/rxrpc.c                                     |   7 +-
 fs/afs/yfsclient.c                                 |   3 +-
 fs/btrfs/ctree.h                                   |   2 -
 fs/btrfs/disk-io.c                                 |   1 -
 fs/btrfs/inode.c                                   |   7 +-
 fs/btrfs/space-info.c                              |   2 +-
 fs/btrfs/volumes.c                                 |   3 +
 fs/btrfs/zoned.c                                   |  99 ++---
 fs/cifs/smb2file.c                                 |   1 -
 fs/cifs/smb2ops.c                                  |  88 ++--
 fs/cifs/smb2pdu.c                                  |  20 +-
 fs/cifs/smb2proto.h                                |   4 +-
 fs/debugfs/inode.c                                 |  22 +
 fs/erofs/fscache.c                                 |   8 +-
 fs/erofs/internal.h                                |  29 --
 fs/tracefs/inode.c                                 |  31 +-
 include/kunit/test.h                               |   6 +-
 include/linux/buffer_head.h                        |  11 +
 include/linux/debugfs.h                            |   6 +
 include/linux/dmar.h                               |   4 +-
 include/linux/lsm_hook_defs.h                      |   1 +
 include/linux/lsm_hooks.h                          |   3 +
 include/linux/security.h                           |   5 +
 include/linux/skbuff.h                             |  49 ++-
 include/linux/time64.h                             |   3 +
 include/linux/udp.h                                |   1 +
 include/net/bonding.h                              |  13 +-
 include/net/udp_tunnel.h                           |   4 +
 include/soc/at91/sama7-ddr.h                       |   8 +
 io_uring/io_uring.c                                |   5 +
 kernel/cgroup/cgroup.c                             |  85 +++-
 kernel/cgroup/cpuset.c                             |   3 +-
 kernel/dma/swiotlb.c                               |   5 +-
 kernel/fork.c                                      |   1 +
 kernel/kprobes.c                                   |   1 +
 kernel/sched/debug.c                               |   2 +-
 kernel/trace/trace_events_trigger.c                |   3 +-
 kernel/trace/trace_preemptirq.c                    |   4 +-
 mm/kmemleak.c                                      |   8 +-
 net/bridge/br_netfilter_hooks.c                    |   2 +
 net/bridge/br_netfilter_ipv6.c                     |   1 +
 net/core/datagram.c                                |   2 +-
 net/core/skbuff.c                                  |   5 +-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_input.c                               |  25 +-
 net/ipv4/udp.c                                     |   2 +
 net/ipv4/udp_tunnel_core.c                         |   1 +
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/seg6.c                                    |   5 +
 net/ipv6/udp.c                                     |   5 +-
 net/netfilter/nf_conntrack_irc.c                   |   5 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  31 ++
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/rxrpc/ar-internal.h                            |   1 +
 net/rxrpc/local_object.c                           |   1 +
 net/rxrpc/peer_event.c                             | 293 ++++++++++++--
 net/rxrpc/rxkad.c                                  |   2 +-
 net/sched/sch_sfb.c                                |  13 +-
 net/sched/sch_taprio.c                             |   5 +-
 net/smc/smc_core.c                                 |   1 +
 net/smc/smc_core.h                                 |   2 +
 net/smc/smc_wr.c                                   |   5 +
 net/smc/smc_wr.h                                   |   5 +
 net/tipc/monitor.c                                 |   2 +-
 security/security.c                                |   4 +
 security/selinux/hooks.c                           |  24 ++
 security/selinux/include/classmap.h                |   2 +-
 security/smack/smack_lsm.c                         |  32 ++
 sound/core/memalloc.c                              |   9 +-
 sound/core/oss/pcm_oss.c                           |   6 +-
 sound/drivers/aloop.c                              |   7 +-
 sound/pci/emu10k1/emupcm.c                         |   2 +-
 sound/pci/hda/hda_intel.c                          |   2 +-
 sound/soc/atmel/mchp-spdiftx.c                     |  10 +-
 sound/soc/codecs/cs42l42.c                         |  13 +-
 sound/soc/qcom/sm8250.c                            |   1 +
 sound/soc/sof/Kconfig                              |   2 +
 sound/usb/card.c                                   |   2 +-
 sound/usb/endpoint.c                               |  25 +-
 sound/usb/endpoint.h                               |   6 +-
 sound/usb/pcm.c                                    |  14 +-
 sound/usb/quirks.c                                 |   2 +-
 sound/usb/stream.c                                 |   9 +-
 tools/lib/perf/evlist.c                            |  50 +++
 tools/objtool/check.c                              |  34 +-
 tools/perf/arch/x86/util/evlist.c                  |   7 +-
 tools/perf/builtin-record.c                        |   8 +-
 tools/perf/builtin-script.c                        |   3 +
 tools/perf/builtin-stat.c                          |  11 +-
 tools/perf/dlfilters/dlfilter-show-cycles.c        |   4 +-
 tools/perf/util/evlist.c                           |   9 +-
 tools/perf/util/evlist.h                           |   7 +-
 231 files changed, 2460 insertions(+), 1000 deletions(-)


