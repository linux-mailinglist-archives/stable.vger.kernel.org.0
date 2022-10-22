Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F426085B1
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiJVHhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiJVHgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:36:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6098F1C713E;
        Sat, 22 Oct 2022 00:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12738B82DB2;
        Sat, 22 Oct 2022 07:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82933C433D6;
        Sat, 22 Oct 2022 07:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424131;
        bh=wJdCsA6y+6Xx+4rpf1HljTYVCPzp4OKFiRgeV9kH4Kw=;
        h=From:To:Cc:Subject:Date:From;
        b=r8396JgsE5RAd2x1FhlpM95HxdvUY65OnBegvaqdO9KE3sQ69fS1Ib7e5g5rzl1Q9
         QgX0SQP98CW2SM8Axno4zhcm4EIFik8BIJGTy2cqkzvrbGMebwntX2pxAwAVaRxP/6
         xds76tN+uf+6H0aiJq+v6aUSGUMLwacfnAhb5T04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.19 000/717] 5.19.17-rc1 review
Date:   Sat, 22 Oct 2022 09:17:59 +0200
Message-Id: <20221022072415.034382448@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.17-rc1
X-KernelTest-Deadline: 2022-10-24T07:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.19.17 release.
There are 717 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Note, this will be the LAST 5.19.y kernel to be released.  Please move
to the 6.0.y kernel branch at this point in time, as after this is
released, this branch will be end-of-life.

Responses should be made by Mon, 24 Oct 2022 07:19:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.17-rc1

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/bios: Use hardcoded fp_timing size for generating LFP data pointers

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/bios: Validate fp_timing terminator presence

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Rename block_size()/block_offset()

Jerry Lee 李修賢 <jerrylee@qnap.com>
    ext4: continue to expand file system when the target size doesn't reach

José Expósito <jose.exposito89@gmail.com>
    HID: uclogic: Add missing suffix for digitalizers

Nathan Chancellor <nathan@kernel.org>
    lib/Kconfig.debug: Add check for non-constant .{s,u}leb128 support to DWARF5

Masahiro Yamada <masahiroy@kernel.org>
    Kconfig.debug: add toolchain checks for DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT

Masahiro Yamada <masahiroy@kernel.org>
    Kconfig.debug: simplify the dependency of DEBUG_INFO_DWARF4/5

Martin Rodriguez Reboredo <yakoyoku@gmail.com>
    kbuild: Add skip_encoding_btf_enum64 option to pahole

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Fix build breakage with CONFIG_DEBUG_FS=n

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/interrupt: Fix lost interrupts when returning to soft-masked context

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net/ieee802154: don't warn zero-sized raw_sendmsg()

Alexander Aring <aahringo@redhat.com>
    Revert "net/ieee802154: reject zero-sized raw_sendmsg()"

Aric Cyr <aric.cyr@amd.com>
    Revert "drm/amd/display: correct hostvm flag"

Randy Dunlap <rdunlap@infradead.org>
    net: ethernet: ti: davinci_mdio: fix build for mdio bitbang uses

Yu Kuai <yukuai3@huawei.com>
    blk-wbt: fix that 'rwb->wc' is always set to 1 in wbt_init()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix last interface check for registration

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: return -EINVAL for unknown addr type

Liu Shixin <liushixin2@huawei.com>
    mm: hugetlb: fix UAF in hugetlb_handle_userfault

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix system_wide dummy event for hybrid

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc

Rob Herring <robh@kernel.org>
    perf: Skip and warn on unknown format 'configN' attrs

Ivan T. Ivanov <iivanov@suse.de>
    clk: bcm2835: Round UART input clock up

Maxime Ripard <maxime@cerno.tech>
    clk: bcm2835: Make peripheral PLLC critical

Wayne Chang <waynec@nvidia.com>
    usb: typec: ucsi: Don't warn on probe deferral

Lv Ruyi <lv.ruyi@zte.com.cn>
    fsi: master-ast-cf: Fix missing of_node_put in fsi_master_acf_probe

Eddie James <eajames@linux.ibm.com>
    fsi: occ: Prevent use after free

Eddie James <eajames@linux.ibm.com>
    hwmon (occ): Retry for checksum failure

Keith Busch <kbusch@kernel.org>
    blk-mq: use quiesced elevator switch when reinitializing queues

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: idmouse: fix an uninit-value in idmouse_open

Varun Prakash <varun@chelsio.com>
    nvmet-tcp: add bounds check on Transfer Tag

Keith Busch <kbusch@kernel.org>
    nvme: copy firmware_rev on each init

Keith Busch <kbusch@kernel.org>
    nvme: handle effects after freeing the request

Jan Kara <jack@suse.cz>
    ext2: Use kvmalloc() for group descriptor array

Arun Easi <aeasi@marvell.com>
    scsi: tracing: Fix compile error in trace_array calls when TRACING is disabled

Xiaoke Wang <xkernel.wang@foxmail.com>
    staging: rtl8723bs: fix a potential memory leak in rtw_init_cmd_priv()

Xiaoke Wang <xkernel.wang@foxmail.com>
    staging: rtl8723bs: fix potential memory leak in rtw_init_drv_sw()

sunghwan jung <onenowy@gmail.com>
    Revert "usb: storage: Add quirk for Samsung Fit flash"

Piyush Mehta <piyush.mehta@amd.com>
    usb: dwc3: core: Enable GUCTL1 bit 10 for fixing termination error after resume bug

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: imx8mp: Add snps,gfladj-refclk-lpm-sel quirk to USB nodes

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: dwc3: core: add gfladj_refclk_lpm_sel quirk

Robin Guo <guoweibin@inspur.com>
    usb: musb: Fix musb_gadget.c rxstate overflow bug

Jianglei Nie <niejianglei2021@163.com>
    usb: host: xhci: Fix potential memory leak in xhci_alloc_stream_info()

Logan Gunthorpe <logang@deltatee.com>
    md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d

Dylan Yudaken <dylany@fb.com>
    eventfd: guard wake_up in eventfd fs calls as well

Johnothan King <johnothanking@protonmail.com>
    HID: nintendo: check analog user calibration for plausibility

Jianglei Nie <niejianglei2021@163.com>
    HSI: ssi_protocol: fix potential resource leak in ssip_pn_open()

Hyunwoo Kim <imv4bel@gmail.com>
    HID: roccat: Fix use-after-free in roccat_read()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: intel: fix error handling on dai registration issues

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Don't overwrite msg->buf during write commands

Coly Li <colyli@suse.de>
    bcache: fix set_at_max_writeback_rate() for multiple attached devices

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    ata: libahci_platform: Sanity check the DT child nodes number

Yu Kuai <yukuai3@huawei.com>
    blk-throttle: prevent overflow while calculating wait time

Nam Cao <namcaov@gmail.com>
    staging: vt6655: fix potential memory leak

Wei Yongjun <weiyongjun1@huawei.com>
    power: supply: adp5061: fix out-of-bounds read in adp5061_get_chg_type()

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: increase worker prio to WQ_HIGHPRI

Yicong Yang <yangyicong@hisilicon.com>
    iommu/arm-smmu-v3: Make default domain type of HiSilicon PTT device to identity

Shigeru Yoshida <syoshida@redhat.com>
    nbd: Fix hung when signal interrupts nbd_start_device_ioctl()

Letu Ren <fantasquex@gmail.com>
    scsi: 3w-9xxx: Avoid disabling device if failing to enable it

Vaishnav Achath <vaishnav.a@ti.com>
    dmaengine: ti: k3-udma: Reset UDMA_CHAN_RT byte counters to prevent overflow

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix null ndlp ptr dereference in abnormal exit path for GFT_ID

Justin Chen <justinpopo6@gmail.com>
    usb: host: xhci-plat: suspend/resume clks for brcm

Justin Chen <justinpopo6@gmail.com>
    usb: host: xhci-plat: suspend and resume clocks

Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
    RDMA/rxe: Delete error messages triggered by incoming Read requests

Quanyang Wang <quanyang.wang@windriver.com>
    clk: zynqmp: pll: rectify rate rounding in zynqmp_pll_round_rate

Hangyu Hua <hbh25y@gmail.com>
    media: platform: fix some double free in meson-ge2d and mtk-jpeg and s5p-mfc

Zheyu Ma <zheyuma97@gmail.com>
    media: cx88: Fix a null-ptr-deref bug in buffer_prepare()

Ian Nam <young.kwan.nam@xilinx.com>
    clk: zynqmp: Fix stack-out-of-bounds in strncpy`

Alex Sverdlin <alexander.sverdlin@nokia.com>
    ARM: 9242/1: kasan: Only map modules if CONFIG_KASAN_VMALLOC=n

Li Huafei <lihuafei1@huawei.com>
    ARM: 9234/1: stacktrace: Avoid duplicate saving of exception PC value

Li Huafei <lihuafei1@huawei.com>
    ARM: 9233/1: stacktrace: Skip frame pointer boundary check for call_with_stack()

Josef Bacik <josef@toxicpanda.com>
    btrfs: call __btrfs_remove_free_space_cache_locked on cache load failure

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    btrfs: don't print information about space cache or tree every remount

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: try to fix super block errors

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: properly report super block errors in system log

Qu Wenruo <wqu@suse.com>
    btrfs: dump extra info if one free space cache has more bitmaps than it should

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    arm64: dts: imx8mq-librem5: Add bq25895 as max17055's power supply

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mm-kontron: Use the VSELECT signal to switch SD card IO voltage

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix validatation termination record after EXTRA_CONTEXT

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: imx6sx-udoo-neo: don't use multiple blank lines

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: imx6sl: use tabs for code indent

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6sx: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6sll: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6sl: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6qp: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6dl: add missing properties for sram

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6q: add missing properties for sram

Haibo Chen <haibo.chen@nxp.com>
    ARM: dts: imx7d-sdb: config the max pressure for tsc2046

Alexander Stein <alexander.stein@ew.tq-group.com>
    ARM: dts: imx6: delete interrupts property if interrupts-extended is set

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: Fix UBSAN shift-out-of-bounds warning

Wenjing Liu <wenjing.liu@amd.com>
    drm/amd/display: polling vid stream status in hpo dp blank

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Remove interface for periodic interrupt 1

Khaled Almahallawy <khaled.almahallawy@intel.com>
    drm/dp: Don't rewrite link config when setting phy test pattern

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/meson: remove drm bridges at aggregate driver unbind time

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/meson: explicitly remove aggregate driver at module unload time

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/meson: reorder driver deinit sequence to fix use-after-free bug

hongao <hongao@uniontech.com>
    drm/amdgpu: fix initial connector audio value

Sherry Wang <Yao.Wang1@amd.com>
    drm/amd/display: correct hostvm flag

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: SDMA update use unlocked iterator

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: add quirk to override topology mclk_id

Jairaj Arava <jairaj.arava@intel.com>
    ASoC: SOF: pci: Change DMI match info to support all Chrome platforms

Muralidhar Reddy <muralidhar.reddy@intel.com>
    ALSA: intel-dspconfig: add ES8336 support for AlderLake-PS

Hans de Goede <hdegoede@redhat.com>
    platform/x86: msi-laptop: Change DMI match / alias strings to fix module autoloading

Jorge Lopez <jorge.lopez2@hp.com>
    platform/x86: hp-wmi: Setting thermal profile fails with 0x06

Jameson Thies <jthies@google.com>
    platform/chrome: cros_ec: Notify the PM of wake events during resume

Maya Matuszczyk <maccraft123mc@gmail.com>
    drm: panel-orientation-quirks: Add quirk for Aya Neo Air

Maya Matuszczyk <maccraft123mc@gmail.com>
    drm: panel-orientation-quirks: Add quirk for Anbernic Win600

Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
    drm/vc4: vec: Fix timings for VEC modes

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Register card at the last interface

Yifan Zha <Yifan.Zha@amd.com>
    drm/admgpu: Skip CG/PG on SOC21 under SRIOV VF

Yifan Zha <Yifan.Zha@amd.com>
    drm/amdgpu: Skip the program of MMMC_VM_AGP_* in SRIOV on MMHUB v3_0_0

Lucas Stach <l.stach@pengutronix.de>
    drm: bridge: dw_hdmi: only trigger hotplug event on link change

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: pmc_atom: Improve quirk message to be less cryptic

Vivek Kasireddy <vivek.kasireddy@intel.com>
    udmabuf: Set ubuf->sg = NULL if the creation of sg table fails

David Gow <davidgow@google.com>
    drm/amd/display: fix overflow on MIN_I64 definition

Zeng Jingxiang <linuszeng@tencent.com>
    gpu: lontium-lt9611: Fix NULL pointer dereference in lt9611_connector_init()

Liviu Dudau <liviu.dudau@arm.com>
    drm/komeda: Fix handling of atomic commits in the atomic_commit_tail hook

Javier Martinez Canillas <javierm@redhat.com>
    drm: Prevent drm_copy_field() to attempt copying a NULL pointer

Javier Martinez Canillas <javierm@redhat.com>
    drm: Use size_t type for len variable in drm_copy_field()

Jianglei Nie <niejianglei2021@163.com>
    drm/nouveau/nouveau_bo: fix potential memory leak in nouveau_bo_alloc()

Andrew Gaul <gaul@gaul.org>
    r8152: Rate limit overflow messages

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: designware-pci: Group AMD NAVI quirk parts together

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix user-after-free

Song Liu <song@kernel.org>
    bpf: use bpf_prog_pack for bpf_dispatcher

Jiri Olsa <jolsa@kernel.org>
    bpf: Adjust kprobe_multi entry_ip for CONFIG_X86_KERNEL_IBT

Liu Jian <liujian56@huawei.com>
    net: If sock is dead don't access sock's sk_wq in sk_stream_wait_memory

Jason A. Donenfeld <Jason@zx2c4.com>
    hwmon: (sht4x) do not overflow clamping operation on 32-bit platforms

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: correctly set BBP register 86 for MT7620

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: set SoC wmac clock register

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: set VGC gain for both chains of MT7620

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620

Daniel Golle <daniel@makrotopia.org>
    wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: bcm: check the result of can_send() in bcm_can_tx()

Hou Tao <houtao1@huawei.com>
    selftests/bpf: Free the allocated resources after test case succeeds

Vadim Fedorenko <vfedorenko@novek.ru>
    bnxt_en: replace reset with config timestamps

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()

Po-Hao Huang <phhuang@realtek.com>
    wifi: rtw89: fix rx filter after scan

Po-Hao Huang <phhuang@realtek.com>
    wifi: rtw89: free unused skb to prevent memory leak

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921: reset msta->airtime_ac while clearing up hw value

Jianglei Nie <niejianglei2021@163.com>
    wifi: ath11k: mhi: fix potential memory leak in ath11k_mhi_register()

Patrick Rudolph <patrick.rudolph@9elements.com>
    regulator: core: Prevent integer underflow

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Mark Intel controller to support LE_STATES quirk

Alexander Coffin <alex.coffin@matician.com>
    wifi: brcmfmac: fix use-after-free bug in brcmf_netdev_start_xmit()

Michal Jaron <michalx.jaron@intel.com>
    iavf: Fix race between iavf_close and iavf_reset_task

Zong-Zhe Yang <kevin_yang@realtek.com>
    rtw89: ser: leave lps with mutex

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    wifi: ath11k: Register shutdown handler for WCN6750

Khalid Masum <khalid.masum.92@gmail.com>
    xfrm: Update ipcomp_scratches with NULL when freed

Richard Gobert <richardbgobert@gmail.com>
    net-next: Fix IP_UNICAST_IF option behavior for connected sockets

Robert Hancock <robert.hancock@calian.com>
    net: axienet: Switch to 64-bit RX/TX statistics

Daniel Sneddon <daniel.sneddon@linux.intel.com>
    x86/apic: Don't disable x2APIC if locked

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()

Jane Chu <jane.chu@oracle.com>
    x86/mce: Retrieve poison range from hardware

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-race around tcp_md5sig_pool_populated

Mike Pattrick <mkp@redhat.com>
    openvswitch: Fix overreporting of drops in dropwatch

Mike Pattrick <mkp@redhat.com>
    openvswitch: Fix double reporting of drops in dropwatch

Ravi Gunasekaran <r-gunasekaran@ti.com>
    net: ethernet: ti: davinci_mdio: Add workaround for errata i2329

Jacob Keller <jacob.e.keller@intel.com>
    ice: set tx_tstamps when creating new Tx rings via ethtool

Quentin Monnet <quentin@isovalent.com>
    bpftool: Clear errno after libcap's checks

Wright Feng <wright.feng@cypress.com>
    wifi: brcmfmac: fix invalid address access when enabling SCAN log level

Youghandhar Chintala <quic_youghand@quicinc.com>
    wifi: ath10k: Set tx credit to one for WCN3990 snoc based devices

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix use-after-free on source server when doing inter-server copy

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data

Kees Cook <keescook@chromium.org>
    x86/entry: Work around Clang __bdos() bug

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Add a quirk for Dell Inspiron 14 2-in-1 for StorageD3Enable

Kees Cook <keescook@chromium.org>
    ARM: decompressor: Include .data.rel.ro.local

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash

Chao Qin <chao.qin@intel.com>
    powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue

Kees Cook <keescook@chromium.org>
    MIPS: BCM47XX: Cast memcmp() of function to (void *)

Doug Smythies <dsmythies@telus.net>
    cpufreq: intel_pstate: Add Tigerlake support in no-HWP mode

Hans de Goede <hdegoede@redhat.com>
    ACPI: tables: FPDT: Don't call acpi_os_map_memory() on invalid phys address

Kees Cook <keescook@chromium.org>
    fortify: Fix __compiletime_strlen() under UBSAN_BOUNDS_LOCAL

Arvid Norlander <lkml@vorpal.se>
    ACPI: video: Add Toshiba Satellite/Portege Z830 quirk

Perry Yuan <Perry.Yuan@amd.com>
    cpufreq: amd_pstate: fix wrong lowest perf fetch

Michal Hocko <mhocko@suse.com>
    rcu: Back off upon fill_page_cache_func() allocation failure

Zqiang <qiang1.zhang@intel.com>
    rcu: Avoid triggering strict-GP irq-work when RCU is idle

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix race in lowcomms

Aaron Tomlin <atomlin@redhat.com>
    module: tracking: Keep a record of tainted unloaded modules only

Stefan Berger <stefanb@linux.ibm.com>
    selftest: tpm2: Add Client.__del__() to close /dev/tpm* handle

Chao Yu <chao@kernel.org>
    f2fs: fix to account FS_CP_DATA_IO correctly

Zhang Qilong <zhangqilong3@huawei.com>
    f2fs: fix race condition on setting FI_NO_EXTENT flag

Shuai Xue <xueshuai@linux.alibaba.com>
    ACPI: APEI: do not add task_work to kernel thread to avoid memory leak

Vincent Knecht <vincent.knecht@mailoo.org>
    thermal/drivers/qcom/tsens-v0_1: Fix MSM8939 fourth sensor hw_id

Jason A. Donenfeld <Jason@zx2c4.com>
    random: schedule jitter credit for next jiffy, not in two jiffies

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: cavium - prevent integer overflow loading firmware

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: marvell/octeontx - prevent integer overflows

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    kbuild: rpm-pkg: fix breakage when V=1 is used

Masahiro Yamada <masahiroy@kernel.org>
    linux/export: use inline assembler to populate symbol CRCs

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: remove the target in signal traps when interrupted

Nico Pache <npache@redhat.com>
    tracing/osnoise: Fix possible recursive locking in stop_per_cpu_kthreads

Yipeng Zou <zouyipeng@huawei.com>
    tracing: kprobe: Make gen test module work in arm and riscv

Yipeng Zou <zouyipeng@huawei.com>
    tracing: kprobe: Fix kprobe event gen test module on exit

Robin Murphy <robin.murphy@arm.com>
    iommu/iova: Fix module config properly

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: return correct error in ->calc_signature()

Lin Yujun <linyujun809@huawei.com>
    clocksource/drivers/timer-gxp: Add missing error handling in gxp_timer_probe

Kunkun Jiang <jiangkunkun@huawei.com>
    clocksource/drivers/arm_arch_timer: Fix handling of ARM erratum 858921

Damian Muszynski <damian.muszynski@intel.com>
    crypto: qat - fix DMA transfer direction

Peter Harliman Liem <pliem@maxlinear.com>
    crypto: inside-secure - Change swab to swab32

Koba Ko <koba.ko@canonical.com>
    crypto: ccp - Release dma channels before dmaengine unrgister

Ignat Korchagin <ignat@cloudflare.com>
    crypto: akcipher - default implementation for setting a private key

Dan Carpenter <dan.carpenter@oracle.com>
    iommu/omap: Fix buffer overflow in debugfs

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - fix missing put dfx access

Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
    crypto: qat - fix default value of WDT timer

Kshitiz Varshney <kshitiz.varshney@nxp.com>
    hwrng: imx-rngc - Moving IRQ handler registering after imx_rngc_irq_mask_clear()

Michal Koutný <mkoutny@suse.com>
    cgroup: Honor caller's cgroup NS when resolving path

Jacky Li <jackyli@google.com>
    crypto: ccp - Fail the PSP initialization when writing psp data file failed

James Cowgill <james.cowgill@blaize.com>
    hwrng: arm-smccc-trng - fix NO_ENTROPY handling

Ye Weihua <yeweihua4@huawei.com>
    crypto: hisilicon/zip - fix mismatch in get/set sgl_sge_nr

Zhengchao Shao <shaozhengchao@huawei.com>
    crypto: sahara - don't sleep when in softirq

Haren Myneni <haren@linux.ibm.com>
    powerpc/pseries/vas: Pass hw_cpu_id to node associativity HCALL

Li Huafei <lihuafei1@huawei.com>
    powerpc/kprobes: Fix null pointer reference in arch_prepare_kprobe()

Pali Rohár <pali@kernel.org>
    powerpc: Fix SPE Power ISA properties for e500v1 platforms

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64/interrupt: Fix return to masked context after hard-mask irq becomes pending

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: mark irqs hard disabled in boot paca

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix GENERIC_CPU build flags for PPC970 / G5

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition

Rohan McLure <rmclure@linux.ibm.com>
    powerpc: Fix fallocate and fadvise64_64 compat parameter combination

Anup Patel <apatel@ventanamicro.com>
    cpuidle: riscv-sbi: Fix CPU_PM_CPU_IDLE_ENTER_xyz() macro usage

Zheng Yongjun <zhengyongjun3@huawei.com>
    powerpc/powernv: add missing of_node_put() in opal_export_attrs()

Liang He <windhl@126.com>
    powerpc/pci_dn: Add missing of_node_put()

Liang He <windhl@126.com>
    powerpc/sysdev/fsl_msi: Add missing of_node_put()

Nathan Chancellor <nathan@kernel.org>
    powerpc/math_emu/efp: Include module.h

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/configs: Properly enable PAPR_SCM in pseries_defconfig

Hangyu Hua <hbh25y@gmail.com>
    ipc: mqueue: fix possible memory leak in init_mqueue_fs()

Jack Wang <jinpu.wang@ionos.com>
    mailbox: bcm-ferxrm-mailbox: Fix error check for dma_map_sg

Conor Dooley <conor.dooley@microchip.com>
    mailbox: mpfs: account for mbox offsets while sending

Conor Dooley <conor.dooley@microchip.com>
    mailbox: mpfs: fix handling of the reg property

Joel Stanley <joel@jms.id.au>
    clk: ast2600: BCLK comes from EPLL

Miaoqian Lin <linmq006@gmail.com>
    clk: ti: dra7-atl: Fix reference leak in of_dra7_atl_clk_probe

Liang He <windhl@126.com>
    clk: ti: Balance of_node_get() calls for of_find_node_by_name()

Lin Yujun <linyujun809@huawei.com>
    clk: imx: scu: fix memleak on platform_device_add() fails

Stefan Wahren <stefan.wahren@i2se.com>
    clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clk: baikal-t1: Add SATA internal ref clock buffer

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clk: baikal-t1: Add shared xGMAC ref/ptp clocks internal parent

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clk: baikal-t1: Fix invalid xGMAC PTP clock divider

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    clk: vc5: Fix 5P49V6901 outputs disabling when enabling FOD

David Collins <collinsd@codeaurora.org>
    spmi: pmic-arb: correct duplicate APID to PPID mapping logic

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: fix failed runtime suspend in host only mode

Dave Jiang <dave.jiang@intel.com>
    dmaengine: ioat: stop mod_timer from resurrecting deleted timer in __cleanup()

Chen-Yu Tsai <wenst@chromium.org>
    clk: mediatek: Migrate remaining clk_unregister_*() to clk_hw_unregister_*()

Chen-Yu Tsai <wenst@chromium.org>
    clk: mediatek: fix unregister function in mtk_clk_register_dividers cleanup

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    clk: mediatek: clk-mt8195-mfg: Reparent mfg_bg3d and propagate rate changes

Chen-Yu Tsai <wenst@chromium.org>
    clk: mediatek: mt8183: mfgcfg: Propagate rate changes to parent

Jens Hillenstedt <jens.hillenstedt@ise.de>
    mfd: da9061: Fix Failed to set Two-Wire Bus Mode.

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mfd: sm501: Add check for platform_driver_register()

Dan Carpenter <dan.carpenter@oracle.com>
    mfd: fsl-imx25: Fix check for platform_get_irq() errors

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: lp8788: Fix an error handling path in lp8788_irq_init() and lp8788_irq_init()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: lp8788: Fix an error handling path in lp8788_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: fsl-imx25: Fix an error handling path in mx25_tsadc_setup_irq()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: intel_soc_pmic: Fix an error handling path in intel_soc_pmic_i2c_probe()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    fsi: core: Check error number after calling ida_simple_get

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix resize_finish() in rxe_queue.c

Adam Skladowski <a_skl39@protonmail.com>
    clk: qcom: gcc-sm6115: Override default Alpha PLL regs

Robert Marko <robimarko@gmail.com>
    clk: qcom: apss-ipq6018: mark apcs_alias0_core_clk as critical

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername()

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Run recv path from workqueue

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Add recv workqueue helpers

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Rename iscsi_conn_queue_work()

John Garry <john.garry@huawei.com>
    scsi: pm8001: Fix running_req for internal abort commands

Duoming Zhou <duoming@zju.edu.cn>
    scsi: libsas: Fix use-after-free bug in smp_execute_task_sg()

Pali Rohár <pali@kernel.org>
    serial: 8250: Fix restoring termios speed after suspend

Guilherme G. Piccoli <gpiccoli@igalia.com>
    firmware: google: Test spinlock on panic path to avoid lockups

Lin Yujun <linyujun809@huawei.com>
    slimbus: qcom-ngd: Add error handling in of_qcom_slim_ngd_register

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    slimbus: qcom-ngd-ctrl: allow compile testing without QCOM_RPROC_COMMON

Nam Cao <namcaov@gmail.com>
    staging: vt6655: fix some erroneous memory clean-up loops

Dongliang Mu <mudongliangabcd@gmail.com>
    phy: qualcomm: call clk_disable_unprepare in the error handling

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: disable dma rx/tx use flags in lpuart_dma_shutdown

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Toggle IER bits on only after irq has been set up

Dan Carpenter <dan.carpenter@oracle.com>
    drivers: serial: jsm: fix some leaks in probe

Dan Carpenter <dan.carpenter@oracle.com>
    usb: dwc3: core: fix some leaks in probe

Albert Briscoe <albertsbriscoe@gmail.com>
    usb: gadget: function: fix dangling pnp_string in f_printer.c

Mario Limonciello <mario.limonciello@amd.com>
    xhci: Don't show warning for reinit on known broken suspend

Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
    IB: Set IOVA/LENGTH on IB_MR in core/uverbs layers

Mark Zhang <markzhang@nvidia.com>
    RDMA/cm: Use SLID in the work completion as the DLID in responder side

David Sloan <david.sloan@eideticom.com>
    md/raid5: Remove unnecessary bio_put() in raid5_read_one_chunk()

Logan Gunthorpe <logang@deltatee.com>
    md/raid5: Ensure stripe_fill happens on non-read IO with journal

Saurabh Sengar <ssengar@linux.microsoft.com>
    md: Replace snprintf with scnprintf

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: rawnand: meson: fix bit map use in meson_nfc_ecc_correct()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_has_dipm()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_has_ncq_autosense()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_has_devslp()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: fix ata_id_sense_reporting_enabled() and ata_id_has_sense_reporting()

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix QP destroy to wait for all references dropped.

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Always consume all skbuf data in sk_data_ready() upcall.

Bart Van Assche <bvanassche@acm.org>
    RDMA/srp: Fix srp_abort()

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/irdma: Validate udata inlen and outlen

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Align AE id codes to correct flush code and event

Pali Rohár <pali@kernel.org>
    mtd: rawnand: fsl_elbc: Fix none ECC mode

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mtd: rawnand: intel: Remove undocumented compatible string

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mtd: rawnand: intel: Read the chip-select line from the correct OF node

Chunfeng Yun <chunfeng.yun@mediatek.com>
    phy: phy-mtk-tphy: fix the phy type setting issue

Liang He <windhl@126.com>
    phy: amlogic: phy-meson-axg-mipi-pcie-analog: Hold reference returned by of_get_parent()

Dan Carpenter <dan.carpenter@oracle.com>
    remoteproc: Harden rproc_handle_vdev() against integer overflow

William Dean <williamsukatube@gmail.com>
    mtd: devices: docg3: check the return value of devm_ioremap() in the probe

Dang Huynh <danct12@riseup.net>
    clk: qcom: sm6115: Select QCOM_GDSC

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: drop EXPORTed dynamic_debug_exec_queries

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: let query-modname override actual module name

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix module.dyndbg handling

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix static_branch manipulation

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: f_fs: stricter integer overflow checks

Jie Hai <haijie1@huawei.com>
    dmaengine: hisilicon: Add multi-thread support for a DMA channel

Jie Hai <haijie1@huawei.com>
    dmaengine: hisilicon: Fix CQ head update

Jie Hai <haijie1@huawei.com>
    dmaengine: hisilicon: Disable channels when unregister hisi_dma

Jerry Snitselaar <jsnitsel@redhat.com>
    dmaengine: idxd: avoid deadlock in process_misc_interrupts()

Peter Geis <pgwipeout@gmail.com>
    phy: rockchip-inno-usb2: Return zero after otg sync

Dan Carpenter <dan.carpenter@oracle.com>
    fpga: prevent integer overflow in dfl_feature_ioctl_set_irq()

Hangyu Hua <hbh25y@gmail.com>
    misc: ocxl: fix possible refcount leak in afu_ioctl()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    clk: mediatek: mt8195-infra_ao: Set pwrmcu clocks as critical

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    clk: mediatek: clk-mt8195-vdo1: Reparent and set rate on vdo1_dpintf's parent

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    clk: mediatek: clk-mt8195-vdo0: Set rate on vdo0_dp_intf0_dp_intf's parent

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix the error caused by qp->sk

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix "kernel NULL pointer dereference" error

Miaoqian Lin <linmq006@gmail.com>
    media: xilinx: vipp: Fix refcount leak in xvip_graph_dma_init

Yunke Cao <yunkec@google.com>
    media: uvcvideo: Use entity get_cur in uvc_ctrl_set

José Expósito <jose.exposito89@gmail.com>
    media: uvcvideo: Fix memory leak in uvc_gpio_parse

Xu Qiang <xuqiang36@huawei.com>
    media: meson: vdec: add missing clk_disable_unprepare on error in vdec_hevc_start()

Ming Qian <ming.qian@nxp.com>
    media: amphion: fix a bug that vpu core may not resume after suspend

Ming Qian <ming.qian@nxp.com>
    media: amphion: don't change the colorspace reported by decoder.

Ming Qian <ming.qian@nxp.com>
    media: amphion: adjust the encoder's value range of gop size

Ming Qian <ming.qian@nxp.com>
    media: amphion: insert picture startcode after seek for vc1g format

Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
    tty: xilinx_uartps: Fix the ignore_status

Liang He <windhl@126.com>
    media: exynos4-is: fimc-is: Add of_node_put() when breaking out of loop

Marijn Suijten <marijn.suijten@somainline.org>
    clk: qcom: gcc-sdm660: Use floor ops for SDCC1 clock

Jack Wang <jinpu.wang@ionos.com>
    HSI: omap_ssi_port: Fix dma_map_sg error check

Miaoqian Lin <linmq006@gmail.com>
    HSI: omap_ssi: Fix refcount leak in ssi_probe

Chanho Park <chanho61.park@samsung.com>
    clk: samsung: exynosautov9: correct register offsets of peric0/c1

Miaoqian Lin <linmq006@gmail.com>
    clk: tegra20: Fix refcount leak in tegra20_clock_init

Miaoqian Lin <linmq006@gmail.com>
    clk: tegra: Fix refcount leak in tegra114_clock_init

Miaoqian Lin <linmq006@gmail.com>
    clk: tegra: Fix refcount leak in tegra210_clock_init

Liang He <windhl@126.com>
    clk: sprd: Hold reference returned by of_get_parent()

Liang He <windhl@126.com>
    clk: berlin: Add of_node_put() for of_get_parent()

Liang He <windhl@126.com>
    clk: qoriq: Hold reference returned by of_get_parent()

Liang He <windhl@126.com>
    clk: oxnas: Hold reference returned by of_get_parent()

Liang He <windhl@126.com>
    clk: st: Hold reference returned by of_get_parent()

Liang He <windhl@126.com>
    clk: meson: Hold reference returned by of_get_parent()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: common: debug: Check non-standard control requests

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Don't compare mkey tags in DEVX indirect mkey

Jakob Hauser <jahau@rocketmail.com>
    iio: magnetometer: yas530: Change data type of hard_offsets to signed

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: ABI: Fix wrong format of differential capacitance channel ABI.

Nuno Sá <nuno.sa@analog.com>
    iio: inkern: fix return value in devm_of_iio_channel_get_by_name()

Nuno Sá <nuno.sa@analog.com>
    iio: inkern: only release the device node when done with it

Claudiu Beznea <claudiu.beznea@microchip.com>
    iio: adc: at91-sama5d2_adc: disable/prepare buffer on suspend/resume

Claudiu Beznea <claudiu.beznea@microchip.com>
    iio: adc: at91-sama5d2_adc: lock around oversampling and sample freq

Claudiu Beznea <claudiu.beznea@microchip.com>
    iio: adc: at91-sama5d2_adc: check return status for pressure and touch

Claudiu Beznea <claudiu.beznea@microchip.com>
    iio: adc: at91-sama5d2_adc: fix AT91_SAMA5D2_MR_TRACKTIM_MAX

Darrick J. Wong <djwong@kernel.org>
    iomap: iomap: fix memory corruption when recording errors during writeback

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ARM: dts: exynos: fix polarity of VBUS GPIO of Origen

Mark Rutland <mark.rutland@arm.com>
    arm64: ftrace: fix module PLTs with mcount

Josh Triplett <josh@joshtriplett.org>
    ext4: don't run ext4lazyinit for read-only filesystems

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: Drop CMDLINE_* dependency on ATAGS

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ARM: dts: exynos: correct s5k6a3 reset polarity on Midas family

Matt Ranostay <mranostay@ti.com>
    arm64: dts: ti: k3-j7200: fix main pinmux range

Dmitry Osipenko <digetx@gmail.com>
    soc/tegra: fuse: Drop Kconfig dependency on TEGRA20_APB_DMA

Randy Dunlap <rdunlap@infradead.org>
    ia64: export memory_add_physaddr_to_nid to fix cxl build error

Michael Walle <michael@walle.cc>
    ARM: dts: kirkwood: lsxl: remove first ethernet port

Michael Walle <michael@walle.cc>
    ARM: dts: kirkwood: lsxl: fix serial line

Marek Behún <kabel@kernel.org>
    ARM: dts: turris-omnia: Fix mpp26 pin name and comment

Chanho Park <chanho61.park@samsung.com>
    dt-bindings: clock: exynosautov9: correct clock numbering of peric0/c1

Biju Das <biju.das.jz@bp.renesas.com>
    arm64: dts: renesas: r9a07g043: Fix SCI{Rx,Tx} interrupt types

Biju Das <biju.das.jz@bp.renesas.com>
    arm64: dts: renesas: r9a07g054: Fix SCI{Rx,Tx} interrupt types

Biju Das <biju.das.jz@bp.renesas.com>
    arm64: dts: renesas: r9a07g044: Fix SCI{Rx,Tx} interrupt types

Lucas Stach <l.stach@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: hook up DDC i2c bus

Liang He <windhl@126.com>
    soc: qcom: smem_state: Add refcounting for the 'state->of_node'

Liang He <windhl@126.com>
    soc: qcom: smsm: Fix refcount leak bugs in qcom_smsm_probe()

Amir Goldstein <amir73il@gmail.com>
    locks: fix TOCTOU race when granting write lease

Liang He <windhl@126.com>
    memory: of: Fix refcount leak bug in of_lpddr3_get_ddr_timings()

Liang He <windhl@126.com>
    memory: of: Fix refcount leak bug in of_get_ddr_timings()

Liang He <windhl@126.com>
    memory: pl353-smc: Fix refcount leak bug in pl353_smc_probe()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Don't skip notification handling during PM operation

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: mt6660: Fix PM disable depth imbalance in mt6660_i2c_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: stm: Fix PM disable depth imbalance in stm32_i2s_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: stm32: spdifrx: Fix PM disable depth imbalance in stm32_spdifrx_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: stm32: dfsdm: Fix PM disable depth imbalance in stm32_adfsdm_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: wmt-sdmmc: Fix an error handling path in wmt_mci_probe()

Andreas Pape <apape@de.adit-jv.com>
    ALSA: dmaengine: increment buffer pointer atomically

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: da7219: Fix an error handling path in da7219_register_dai_clks()

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: tx-macro: fix kcontrol put

Dan Carpenter <dan.carpenter@oracle.com>
    virtio-gpu: fix shift wrapping bug in virtio_gpu_fence_event_create()

Rafael Mendonca <rafaelmendsr@gmail.com>
    drm/vmwgfx: Fix memory leak in vmw_mksstat_add_ioctl()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Properly refcounting clock rate

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: correct 1.62G link rate at dp_catalog_ctrl_config_msa()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: index dpu_kms->hw_vbif using vbif_idx

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: lookup the ICC paths in both mdp5/dpu and mdss devices

Liang He <windhl@126.com>
    ASoC: eureka-tlv320: Hold reference returned from of_find_xxx API

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: au1xmmc: Fix an error handling path in au1xmmc_probe()

Rafael Mendonca <rafaelmendsr@gmail.com>
    drm/amdgpu: Fix memory leak in hpd_rx_irq_create_workqueue()

Liang He <windhl@126.com>
    drm/omap: dss: Fix refcount leak bugs

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: SOF: mediatek: mt8195: Import namespace SND_SOC_SOF_MTK_COMMON

Gerd Hoffmann <kraxel@redhat.com>
    drm/bochs: fix blanking

Chia-I Wu <olvaffe@gmail.com>
    drm/virtio: set fb_modifiers_not_supported

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: beep: Simplify keep-power-at-enable behavior

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: wm_adsp: Handle optional legacy support

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: rsnd: Add check for rsnd_mod_power_on

Pin-yen Lin <treapking@chromium.org>
    drm/bridge: it6505: Fix the order of DP_SET_POWER commands

Zheyu Ma <zheyuma97@gmail.com>
    drm/bridge: megachips: Fix a null pointer dereference bug

Yang Yingliang <yangyingliang@huawei.com>
    drm/amdgpu: add missing pci_disable_device() in amdgpu_pmops_runtime_resume()

Prashant Malani <pmalani@chromium.org>
    platform/chrome: cros_ec_typec: Correct alt mode index

Hans de Goede <hdegoede@redhat.com>
    platform/x86: msi-laptop: Fix resource cleanup

Hans de Goede <hdegoede@redhat.com>
    platform/x86: msi-laptop: Fix old-ec check for backlight registering

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Fix mute/unmute

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Drop conflicting set_bias_level power setting

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Allow mono streams

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-pcm.c: call __soc_pcm_close() in soc_pcm_close()

Rob Clark <robdclark@chromium.org>
    drm/virtio: Fix same-context optimization

Dan Carpenter <dan.carpenter@oracle.com>
    platform/chrome: fix memory corruption in ioctl

Rustam Subkhankulov <subkhankulov@ispras.ru>
    platform/chrome: fix double-free in chromeos_laptop_prepare()

Javier Martinez Canillas <javierm@redhat.com>
    drm/msm: Make .remove and .shutdown HW shutdown consistent

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: mt6359: fix tests for platform_get_irq() failure

Liang He <windhl@126.com>
    drm:pl111: Add of_node_put() when breaking out of for_each_available_child_of_node()

Simon Ser <contact@emersion.fr>
    drm/dp_mst: fix drm_dp_dpcd_read return value checks

Chen-Yu Tsai <wenst@chromium.org>
    drm/bridge: parade-ps8640: Fix regulator supply order

Liang He <windhl@126.com>
    drm/bridge: tc358767: Add of_node_put() when breaking out of loop

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling

Pin-Yen Lin <treapking@chromium.org>
    drm/bridge: it6505: Power on downstream device in .atomic_enable

Maxime Ripard <maxime@cerno.tech>
    drm/mipi-dsi: Detach devices when removing the host

Dan Carpenter <dan.carpenter@oracle.com>
    drm/bridge: Avoid uninitialized variable warning

Alvin Šipraga <alsi@bang-olufsen.dk>
    drm: bridge: adv7511: unregister cec i2c device after cec adapter

Alvin Šipraga <alsi@bang-olufsen.dk>
    drm: bridge: adv7511: fix CEC power down control register offset

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: mvpp2: fix mvpp2 debugfs leak

Eric Dumazet <edumazet@google.com>
    once: add DO_ONCE_SLOW() for sleepable contexts

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net/ieee802154: reject zero-sized raw_sendmsg()

Maxim Mikityanskiy <maxtram95@gmail.com>
    net: wwan: iosm: Call mutex_init before locking it

Zheng Wang <zyytlz.wz@163.com>
    eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address

Jianglei Nie <niejianglei2021@163.com>
    bnx2x: fix potential memory leak in bnx2x_tpa_stop()

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    eth: lan743x: reject extts for non-pci11x1x devices

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: prestera: acl: Add check for kmemdup

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Fix memory leaks of the whole sk due to OOB skb.

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()

Oleksandr Shamray <oleksandrs@nvidia.com>
    hwmon: (pmbus/mp2888) Fix sensors readouts for MPS Multi-phase mp2888 controller

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix not indicating power state

Marek Szyprowski <m.szyprowski@samsung.com>
    spi: Ensure that sg_table won't be used after being freed

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited

Xin Long <lucien.xin@gmail.com>
    sctp: handle the error returned from sctp_auth_asoc_init_active_key

Duoming Zhou <duoming@zju.edu.cn>
    mISDN: fix use-after-free bugs in l1oip timer handlers

Jakub Kicinski <kuba@kernel.org>
    eth: alx: take rtnl_lock on resume

Junichi Uekawa <uekawa@chromium.org>
    vhost/vsock: Use kvmalloc/kvfree for larger packets.

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix AIFS written to REG_EDCA_*_PARAM

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: gen2: Enable 40 MHz channel width

Vincent Whitchurch <vincent.whitchurch@axis.com>
    spi: s3c64xx: Fix large transfers with DMA

Phil Sutter <phil@nwl.cc>
    netfilter: nft_fib: Fix for rpath check with VRF devices

Liu Jian <liujian56@huawei.com>
    xfrm: Reinject transport-mode packets through workqueue

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not handling link timeouts propertly

Asmaa Mnebhi <asmaa@nvidia.com>
    i2c: mlxbf: support lock mechanism

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    cw1200: fix incorrect check to determine if no element is found in list

Liu Jian <liujian56@huawei.com>
    skmsg: Schedule psock work if the cached skb exists on the psock

Zhang Qilong <zhangqilong3@huawei.com>
    spi/omap100k:Fix PM disable depth imbalance in omap1_spi100k_probe

Zhang Qilong <zhangqilong3@huawei.com>
    spi: dw: Fix PM disable depth imbalance in dw_spi_bt1_probe

Zhang Qilong <zhangqilong3@huawei.com>
    spi: cadence-quadspi: Fix PM disable depth imbalance in cqspi_probe

Luciano Leão <lucianorsleao@gmail.com>
    x86/cpu: Include the header of init_ia32_feat_ctl()'s prototype

Christian Marangi <ansuelsmth@gmail.com>
    wifi: ath11k: fix peer addition/deletion error on sta band migration

Kees Cook <keescook@chromium.org>
    x86/microcode/AMD: Track patch allocation size explicitly

Arınç ÜNAL <arinc.unal@arinc9.com>
    mips: dts: ralink: mt7621: fix external phy on GB-PC2

Jesus Fernandez Manzano <jesus.manzano@galgus.net>
    wifi: ath11k: fix number of VHT beamformee spatial streams

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath11k: fix failed to find the peer with peer_id 0 when disconnected

Qingqing Yang <qingqing.yang@broadcom.com>
    flow_dissector: Do not count vlan tags inside tunnel payload

Antoine Tenart <atenart@kernel.org>
    netfilter: conntrack: revisit the gc initial rescheduling bias

Antoine Tenart <atenart@kernel.org>
    netfilter: conntrack: fix the gc rescheduling delay

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: hci_{ldisc,serdev}: check percpu_init_rwsem() failure

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: Include STA_KEEPALIVE_ARP_RESPONSE TLV header by default

Lee Jones <lee@kernel.org>
    bpf: Ensure correct locking around vulnerable function find_vpid()

Zheng Yongjun <zhengyongjun3@huawei.com>
    net: fs_enet: Fix wrong check in do_pd_setup

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: RFCOMM: Fix possible deadlock on socket shutdown/release

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: mt7921e: fix rmmod crash in driver reload test

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7915: do not check state before configuring implicit beamform

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7915: fix mcs value in ht mode

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_sta_set_decap_offload

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_[start, stop]_ap

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: connac: fix possible unaligned access in mt76_connac_mcu_add_nested_tlv

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7915: fix possible unaligned access in mt7915_mac_add_twt_setup

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7615: add mt7615_mutex_acquire/release in mt7615_sta_set_decap_offload

YN Chen <yn.chen@mediatek.com>
    wifi: mt76: sdio: fix transmitting packet hangs

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: sdio: poll sta stat when device transmits data

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: sdio: fix the deadlock caused by sdio->stat_work

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921u: fix race issue between reset and suspend/resume

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921s: fix race issue between reset and suspend/resume

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921e: fix race issue between reset and suspend/resume

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Remove copy-paste leftover in gen2_update_rate_mask

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration

Lorenz Bauer <oss@lmb.io>
    bpf: btf: fix truncated last_member_type_id in btf_struct_resolve

Neil Armstrong <narmstrong@baylibre.com>
    spi: meson-spicc: do not rely on busy flag in pow2 clk ops

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix skb misuse in TX queue selection

Xu Qiang <xuqiang36@huawei.com>
    spi: qup: add missing clk_disable_unprepare on error in spi_qup_pm_resume_runtime()

Xu Qiang <xuqiang36@huawei.com>
    spi: qup: add missing clk_disable_unprepare on error in spi_qup_resume()

Ian Rogers <irogers@google.com>
    selftests/xsk: Avoid use-after-free on ctx

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: wfx: prevent underflow in wfx_send_pds()

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: correct TX resource checking in low power mode

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: fix interrupt stuck after leaving low power mode

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend

Hou Tao <houtao1@huawei.com>
    bpf: Use this_cpu_{inc_return|dec} for prog->active

Hou Tao <houtao1@huawei.com>
    bpf: Use this_cpu_{inc|dec|inc_return} for bpf_task_storage_busy

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    wifi: ath11k: Fix incorrect QMI message ID mappings

Hou Tao <houtao1@huawei.com>
    bpf: Propagate error from htab_lock_bucket() to userspace

Hou Tao <houtao1@huawei.com>
    bpf: Disable preemption when increasing per-cpu map_locked

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    selftests/xsk: Add missing close() on netns fd

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: Fix backpressure mechanism on Tx

Kohei Tarumizu <tarumizu.kohei@fujitsu.com>
    x86/resctrl: Fix to restore to original value when re-enabling hardware prefetch register

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: mt7621: Fix an error message in mt7621_spi_probe()

Sabrina Dubroca <sd@queasysnail.net>
    esp: choose the correct inner protocol for GSO on inter address family tunnels

Richard Guy Briggs <rgb@redhat.com>
    audit: free audit_proctitle only on task exit

Richard Guy Briggs <rgb@redhat.com>
    audit: explicitly check audit_context->context enum value

Lam Thai <lamthai@arista.com>
    bpftool: Fix a wrong type cast in btf_dumper_int

Hari Chandrakanthan <quic_haric@quicinc.com>
    wifi: mac80211: allow bw change during channel switch in mesh

Shaul Triebitz <shaul.triebitz@intel.com>
    wifi: cfg80211: get correct AP link chandef

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix reference state management for synchronous callbacks

Gerhard Engleder <gerhard@engleder-embedded.com>
    tsnep: Fix TSNEP_INFO_TX_TIME register define

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    leds: lm3601x: Don't use mutex after it was destroyed

Dave Marchevsky <davemarchevsky@fb.com>
    bpf: Cleanup check_refcount_ok

Stanislav Fomichev <sdf@google.com>
    bpf: convert cgroup_bpf.progs to hlist

Joanne Koong <joannelkoong@gmail.com>
    bpf: Fix non-static bpf_func_proto struct definitions

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtlwifi: 8192de: correct checking of IQK reload

Bill Wendling <morbo@google.com>
    x86/paravirt: add extra clobbers with ZERO_CALL_USED_REGS enabled

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix handling of oversized NFSv4 COMPOUND requests

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against send buffer overflow in NFSv2 READDIR

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix svcxdr_init_encode's buflen calculation

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix svcxdr_init_decode's end-of-buffer calculation

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nfsd: Fix a memory leak in an error handling path

Sami Tolvanen <samitolvanen@google.com>
    objtool: Preserve special st_shndx indexes in elf_update_symbol

Huisong Li <lihuisong@huawei.com>
    ACPI: PCC: Fix Tx acknowledge in the PCC address space handler

Huisong Li <lihuisong@huawei.com>
    ACPI: PCC: replace wait_for_completion()

Rafael Mendonca <rafaelmendsr@gmail.com>
    ACPI: PCC: Release resources on address space setup failure path

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9247/1: mm: set readonly for MT_MEMORY_RO with ARM_LPAE

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9244/1: dump: Fix wrong pg_level in walk_pmd()

Bart Van Assche <bvanassche@acm.org>
    ARM: 9243/1: riscpc: Unbreak the build

Jia Zhu <zhujia.zj@bytedance.com>
    erofs: use kill_anon_super() to kill super in fscache mode

Gao Xiang <xiang@kernel.org>
    erofs: fix order >= MAX_ORDER warning due to crafted negative i_size

Lin Yujun <linyujun809@huawei.com>
    MIPS: SGI-IP27: Fix platform-device leak in bridge_platform_create()

Lin Yujun <linyujun809@huawei.com>
    MIPS: SGI-IP30: Fix platform-device leak in bridge_platform_create()

Kees Cook <keescook@chromium.org>
    sh: machvec: Use char[] for section boundaries

Perry Yuan <Perry.Yuan@amd.com>
    cpufreq: amd-pstate: Fix initial highest_perf value

Xuewen Yan <xuewen.yan@unisoc.com>
    thermal: cpufreq_cooling: Check the policy first in cpufreq_cooling_register()

Christian Brauner <brauner@kernel.org>
    ntfs3: rework xattr handlers and switch to POSIX ACL VFS helpers

Ondrej Mosnacek <omosnace@redhat.com>
    userfaultfd: open userfaultfds with O_RDONLY

Mimi Zohar <zohar@linux.ibm.com>
    ima: fix blocking of security.ima xattrs of unsupported algorithms

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    selinux: use "grep -E" instead of "egrep"

Steve French <stfrench@microsoft.com>
    smb3: must initialize two ACL struct fields to zero

Shirish S <shirish.s@amd.com>
    drm/amd/display: explicitly disable psr_feature_enable appropriately

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amd/display: Fix vblank refcount in vrr transition

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix watermark calculations for DG2 CCS+CC modifier

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix watermark calculations for DG2 CCS modifiers

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix watermark calculations for gen12+ CCS+CC modifier

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix watermark calculations for gen12+ MC CCS modifier

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix watermark calculations for gen12+ RC CCS modifier

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/gt: Use i915_vm_put on ppgtt_create error paths

Jianglei Nie <niejianglei2021@163.com>
    drm/nouveau: fix a use-after-free in nouveau_gem_prime_import_sg_table()

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv140-: Disable interlacing

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: greybus: audio_helper: remove unused and wrong debugfs usage

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Don't propagate vmcs12's PERF_GLOBAL_CTRL settings to vmcs02

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Unconditionally purge queued/injected events on nested "exit"

Michal Luczaj <mhal@rbox.co>
    KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility

Yu Kuai <yukuai3@huawei.com>
    blk-wbt: call rq_qos_add() after wb_normal is initialized

Yu Kuai <yukuai3@huawei.com>
    blk-throttle: fix that io throttle can only work for single bio

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    media: cedrus: Fix endless loop in cedrus_h265_skip_bits()

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    media: cedrus: Set the platform driver data earlier

Ard Biesheuvel <ardb@kernel.org>
    efi: libstub: drop pointless get_memory_map() call

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Explicitly enable lane adapter hotplug events at startup

Shengjiu Wang <shengjiu.wang@nxp.com>
    rpmsg: char: Avoid double destroy of default endpoint

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Fix reading strings from synthetic events

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Add "(fault)" name injection to kernel probes

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Move duplicate code of trace_kprobe/eprobe.c into header

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Do not free snapshot if tracer is on cmdline

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Add ioctl() to force ring buffer waiters to wake up

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Wake up waiters when tracing is disabled

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Wake up ring buffer waiters on closing of the file

Waiman Long <longman@redhat.com>
    tracing: Disable interrupt or preemption before acquiring arch_spinlock_t

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Fix race between reset page and reading page

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Add ring_buffer_wake_waiters()

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Check pending waiters when doing wake ups as well

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Have the shortest_full queue be the shortest not longest

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Allow splice to read previous partially read pages

Steven Rostedt (Google) <rostedt@goodmis.org>
    ftrace: Still disable enabled records marked as disabled

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Properly unset FTRACE_HASH_FL_MOD

Rik van Riel <riel@surriel.com>
    livepatch: fix race between fork and KLP transition

Ye Bin <yebin10@huawei.com>
    ext4: update 'state->fc_regions_size' after successful memory allocation

Ye Bin <yebin10@huawei.com>
    ext4: fix potential memory leak in ext4_fc_record_regions()

Ye Bin <yebin10@huawei.com>
    ext4: fix potential memory leak in ext4_fc_record_modified_inode()

Ye Bin <yebin10@huawei.com>
    ext4: fix miss release buffer head in ext4_fc_write_inode

Zhihao Cheng <chengzhihao1@huawei.com>
    ext4: fix dir corruption when ext4_dx_add_entry() fails

Jeff Layton <jlayton@kernel.org>
    ext4: fix i_version handling in ext4

Jinke Han <hanjinke.666@bytedance.com>
    ext4: place buffer head allocation before handle start

Zhang Yi <yi.zhang@huawei.com>
    ext4: ext4_read_bh_lock() should submit IO if the buffer isn't uptodate

Jeff Layton <jlayton@kernel.org>
    ext4: unconditionally enable the i_version counter

Lukas Czerner <lczerner@redhat.com>
    ext4: don't increase iversion counter for ea_inodes

Jan Kara <jack@suse.cz>
    ext4: fix check for block being out of directory size

Lalith Rajendran <lalithkraj@google.com>
    ext4: make ext4_lazyinit_thread freezable

Baokun Li <libaokun1@huawei.com>
    ext4: fix null-ptr-deref in ext4_write_info

Jan Kara <jack@suse.cz>
    ext4: avoid crash when inline data creation follows DIO write

Jan Kara <jack@suse.cz>
    ext2: Add sanity checks for group and filesystem size

Ye Bin <yebin10@huawei.com>
    jbd2: add miss release buffer head in fc_do_one_pass()

Ye Bin <yebin10@huawei.com>
    jbd2: fix potential use-after-free in jbd2_fc_wait_bufs

Ye Bin <yebin10@huawei.com>
    jbd2: fix potential buffer head reference count leak

Andrew Perepechko <anserper@ya.ru>
    jbd2: wake up journal waiters in FIFO order, not LIFO

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on summary info

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on destination blkaddr during recovery

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: increase the limit for reserve_root

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: flush pending checkpoints when freezing super

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: complete checkpoints during remount

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix wrong continue condition in GC

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    btrfs: set generation before calling btrfs_clean_tree_block in btrfs_init_new_buffer

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missed extent on fsync after dropping extent maps

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between quota enable and quota rescan ioctl

Qu Wenruo <wqu@suse.com>
    btrfs: enhance unsupported compat RO flags handling

Alexander Zhu <alexlzhu@fb.com>
    btrfs: fix alignment of VMA for memory mapped files on THP

Lukas Czerner <lczerner@redhat.com>
    fs: record I_DIRTY_TIME even if inode already has I_DIRTY_INODE

Mickaël Salaün <mic@digikod.net>
    ksmbd: Fix user namespace mapping

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    ksmbd: Fix wrong return value and message length check in smb2_ioctl()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix endless loop when encryption for response fails

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix incorrect handling of iterate_dir

Steve French <stfrench@microsoft.com>
    smb3: do not log confusing message when server returns no network interfaces

Jason A. Donenfeld <Jason@zx2c4.com>
    hwrng: core - let sleep be interrupted when unregistering hwrng

Hyunwoo Kim <imv4bel@gmail.com>
    fbdev: smscufx: Fix use-after-free in ufx_ops_open()

Quentin Schulz <quentin.schulz@theobroma-systems.com>
    pinctrl: rockchip: add pinmux_ops.gpio_set_direction callback

Quentin Schulz <quentin.schulz@theobroma-systems.com>
    gpio: rockchip: request GPIO mux to pinctrl when setting direction

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Populate sysfs attributes for vport

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Rework MIB Rx Monitor debug info logic

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    slimbus: qcom-ngd: cleanup in probe error path

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    slimbus: qcom-ngd: use correct error in message of pdr_add_lookup() failure

Pali Rohár <pali@kernel.org>
    powerpc/boot: Explicitly disable usage of SPE instructions

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/Kconfig: Fix non existing CONFIG_PPC_FSL_BOOKE

Zhang Rui <rui.zhang@intel.com>
    powercap: intel_rapl: Use standard Energy Unit for SPR Dram RAPL domain

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: qcom-cpufreq-hw: Fix uninitialized throttled_freq warning

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against send buffer overflow in NFSv3 READ

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against send buffer overflow in NFSv2 READ

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Protect against send buffer overflow in NFSv3 READDIR

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Request full 16550A feature probing for OxSemi PCIe devices

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Let drivers request full 16550A feature probing

Lukas Wunner <lukas@wunner.de>
    serial: stm32: Deassert Transmit Enable on ->rs485_config()

Christophe Leroy <christophe.leroy@csgroup.eu>
    serial: cpm_uart: Don't request IRQ too early for console port

Maciej W. Rozycki <macro@orcam.me.uk>
    PCI: Sanitise firmware BAR assignments behind a PCI-PCI bridge

M. Vefa Bicakci <m.v.b@runbox.com>
    xen/gntdev: Accommodate VMA splitting

M. Vefa Bicakci <m.v.b@runbox.com>
    xen/gntdev: Prevent leaking grants

Carlos Llamas <cmllamas@google.com>
    mm/mmap: undo ->mmap() when arch_validate_flags() fails

Peter Xu <peterx@redhat.com>
    mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm/damon: validate if the pmd entry is present before accessing

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page

Yang Guo <guoyang2@huawei.com>
    clocksource/drivers/arm_arch_timer: Fix CNTPCT_LO and CNTVCT_LO value

James Morse <james.morse@arm.com>
    arm64: errata: Add Cortex-A55 to the repeat tlbi list

Peter Collingbourne <pcc@google.com>
    arm64: mte: move register initialization to C

Takashi Iwai <tiwai@suse.de>
    drm/udl: Restore display mode on resume

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Use appropriate atomic state in virtio_gpu_plane_cleanup_fb()

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Unlock reservations on dma_resv_reserve_fences() error

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Unlock reservations on virtio_gpu_object_shmem_init() error

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Check whether transferred 2D BO is shmem

Christian Marangi <ansuelsmth@gmail.com>
    dmaengine: qcom-adm: fix wrong calling convention for prep_slave_sg

Christian Marangi <ansuelsmth@gmail.com>
    dmaengine: qcom-adm: fix wrong sizeof config in slave_config

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    dmaengine: mxs: use platform_driver_register

Hamza Mahfooz <hamza.mahfooz@amd.com>
    Revert "drm/amdgpu: use dirty framebuffer helper"

Sagi Grimberg <sagi@grimberg.me>
    nvme-multipath: fix possible hang in live ns resize with ANA access

Gaosheng Cui <cuigaosheng1@huawei.com>
    nvmem: core: Fix memleak in nvmem_register()

Huacai Chen <chenhuacai@kernel.org>
    UM: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Fangrui Song <maskray@google.com>
    riscv: Pass -mno-relax only on lld < 15.0.0

Wenting Zhang <zephray@outlook.com>
    riscv: always honor the CONFIG_CMDLINE_FORCE when parsing dtb

Andrew Bresticker <abrestic@rivosinc.com>
    riscv: Make VM_WRITE imply VM_READ

Andrew Bresticker <abrestic@rivosinc.com>
    riscv: Allow PROT_WRITE-only mmap()

Jisheng Zhang <jszhang@kernel.org>
    riscv: vdso: fix NULL deference in vdso_join_timens() when vfork

Helge Deller <deller@gmx.de>
    parisc: Fix userspace graphics card breakage due to pgtable special bit

Helge Deller <deller@gmx.de>
    parisc: fbdev/stifb: Align graphics memory size to 4MB

Maciej W. Rozycki <macro@orcam.me.uk>
    RISC-V: Make port I/O string accessors actually work

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Re-enable counter access from userspace

Conor Dooley <conor.dooley@microchip.com>
    riscv: topology: fix default topology reporting

Conor Dooley <conor.dooley@microchip.com>
    arm64: topology: move store_cpu_topology() to shared code

Linus Walleij <linus.walleij@linaro.org>
    regulator: qcom_rpm: Fix circular deferral regression

Mika Westerberg <mika.westerberg@linux.intel.com>
    net: thunderbolt: Enable DMA paths only after rings are enabled

Liang He <windhl@126.com>
    hwmon: (gsc-hwmon) Call of_node_get() before of_find_xxx API

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: wcd934x: fix order of Slimbus unprepare/disable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: wcd9335: fix order of Slimbus unprepare/disable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-mtp: correct ADC settle time

Patryk Duda <pdk@semihalf.com>
    platform/chrome: cros_ec_proto: Update version on GET_NEXT_EVENT failure

Zhihao Cheng <chengzhihao1@huawei.com>
    quota: Check next/prev free block number after reading from quota file

Andri Yngvason <andri@yngvason.is>
    HID: multitouch: Add memory barriers

Roberto Sassu <roberto.sassu@huawei.com>
    btf: Export bpf_dynptr definition

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix invalid derefence of sb_lvbptr

Alexander Aring <aahringo@redhat.com>
    fs: dlm: handle -EBUSY first in lock arg validation

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix race between test_bit() and queue_work()

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: designware: Fix handling of real but unexpected device interrupts

Wenchao Chen <wenchao.chen@unisoc.com>
    mmc: sdhci-sprd: Fix minimum clock limit

Prathamesh Shete <pshete@nvidia.com>
    mmc: sdhci-tegra: Use actual clock rate for SW tuning correction

Biju Das <biju.das.jz@bp.renesas.com>
    mmc: renesas_sdhi: Fix rounding errors

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix CAN state after restart

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix TX queue out of sync after restart

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix overread with an invalid command

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb: Fix use of uninitialized completion

Avri Altman <avri.altman@wdc.com>
    mmc: core: Add SD card quirk for broken discard

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    usb: add quirks for Lenovo OneLink+ Dock

Nathan Chancellor <nathan@kernel.org>
    usb: gadget: uvc: Fix argument to sizeof() in uvc_register_video()

Rafael Mendonca <rafaelmendsr@gmail.com>
    xhci: dbc: Fix memory leak in xhci_alloc_dbc()

Eddie James <eajames@linux.ibm.com>
    iio: pressure: dps310: Reset chip after timeout

Eddie James <eajames@linux.ibm.com>
    iio: pressure: dps310: Refactor startup procedure

Nuno Sá <nuno.sa@analog.com>
    iio: adc: ad7923: fix channel readings for some variants

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    iio: ltc2497: Fix reading conversion results

Michael Hennerich <michael.hennerich@analog.com>
    iio: dac: ad5593r: Fix i2c read protocol requirements

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: destage dirty pages before re-reading them for cache=none

Gaurav Kohli <gauravkohli@linux.microsoft.com>
    hv_netvsc: Fix race between VF offering and VF association message from host

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: correct pinned_vm accounting

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/af_unix: defer registered files gc to io_uring release

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: don't update msg_name if not provided

Stefan Metzmacher <metze@samba.org>
    io_uring/net: fix fast_iov assignment in io_setup_async_msg()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rw: fix unexpected link breakage

Tudor Ambarus <tudor.ambarus@microchip.com>
    mtd: rawnand: atmel: Unmap streaming DMA mappings

Saranya Gopal <saranya.gopal@intel.com>
    ALSA: hda/realtek: Add Intel Reference SSID to support headset keys

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add quirk for ASUS GV601R laptop

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Correct pin configs for ASUS G533Z

Callum Osmotherly <callum.osmotherly@gmail.com>
    ALSA: hda/realtek: remove ALC289_FIXUP_DUAL_SPK for Dell 5530

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix NULL dererence at error path

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential memory leaks

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Drop register_mutex in snd_rawmidi_free()

Takashi Iwai <tiwai@suse.de>
    ALSA: oss: Fix potential deadlock at unregistration

Sasha Levin <sashal@kernel.org>
    Revert "fs: check FMODE_LSEEK to control internal pipe splicing"


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio            |   2 +-
 Documentation/admin-guide/kernel-parameters.txt    |   4 +
 Documentation/arm64/silicon-errata.rst             |   2 +
 Documentation/filesystems/vfs.rst                  |   3 +
 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   1 -
 arch/arm/boot/compressed/misc.c                    |   2 +
 arch/arm/boot/compressed/vmlinux.lds.S             |   2 +
 arch/arm/boot/dts/armada-385-turris-omnia.dts      |   4 +-
 arch/arm/boot/dts/exynos4412-midas.dtsi            |   2 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |   2 +-
 arch/arm/boot/dts/imx6dl-riotboard.dts             |   1 +
 arch/arm/boot/dts/imx6dl.dtsi                      |   3 +
 arch/arm/boot/dts/imx6q-arm2.dts                   |   1 +
 arch/arm/boot/dts/imx6q-evi.dts                    |   1 +
 arch/arm/boot/dts/imx6q-mccmon6.dts                |   1 +
 arch/arm/boot/dts/imx6q.dtsi                       |   3 +
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |   6 +-
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi           |   1 +
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi       |   1 +
 arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi      |   1 +
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi          |   1 +
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |   1 +
 arch/arm/boot/dts/imx6qdl-tqma6a.dtsi              |   1 +
 arch/arm/boot/dts/imx6qdl-ts7970.dtsi              |   1 +
 arch/arm/boot/dts/imx6qp.dtsi                      |   6 +
 arch/arm/boot/dts/imx6sl.dtsi                      |  23 +-
 arch/arm/boot/dts/imx6sll.dtsi                     |   3 +
 arch/arm/boot/dts/imx6sx-udoo-neo.dtsi             |  14 +-
 arch/arm/boot/dts/imx6sx.dtsi                      |   6 +
 arch/arm/boot/dts/imx7d-sdb.dts                    |   7 +-
 arch/arm/boot/dts/kirkwood-lsxl.dtsi               |  16 +-
 arch/arm/include/asm/stacktrace.h                  |   6 +
 arch/arm/kernel/return_address.c                   |   1 +
 arch/arm/kernel/stacktrace.c                       |  84 +++++--
 arch/arm/lib/call_with_stack.S                     |   2 +
 arch/arm/mm/dump.c                                 |   2 +-
 arch/arm/mm/kasan_init.c                           |   9 +-
 arch/arm/mm/mmu.c                                  |   4 +
 arch/arm64/Kconfig                                 |  17 ++
 .../boot/dts/freescale/imx8mm-kontron-n801x-s.dts  |   3 +
 .../dts/freescale/imx8mm-kontron-n801x-som.dtsi    |   2 -
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   4 +-
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi  |   1 +
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts            |  12 +-
 arch/arm64/boot/dts/renesas/r9a07g043.dtsi         |   8 +-
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi         |   8 +-
 arch/arm64/boot/dts/renesas/r9a07g054.dtsi         |   8 +-
 .../boot/dts/ti/k3-j7200-common-proc-board.dts     |  10 +-
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi          |  11 +-
 arch/arm64/include/asm/mte.h                       |   5 +
 arch/arm64/kernel/cpu_errata.c                     |   5 +
 arch/arm64/kernel/cpufeature.c                     |   3 +-
 arch/arm64/kernel/ftrace.c                         |  17 +-
 arch/arm64/kernel/mte.c                            |  51 ++++
 arch/arm64/kernel/suspend.c                        |   2 +
 arch/arm64/kernel/topology.c                       |  40 ----
 arch/arm64/mm/proc.S                               |  46 +---
 arch/ia64/mm/numa.c                                |   1 +
 arch/mips/bcm47xx/prom.c                           |   4 +-
 arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts |   6 +-
 arch/mips/sgi-ip27/ip27-xtalk.c                    |  70 ++++--
 arch/mips/sgi-ip30/ip30-xtalk.c                    |  70 ++++--
 arch/parisc/include/asm/pgtable.h                  |   7 +-
 arch/parisc/kernel/entry.S                         |   8 +
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/Makefile                              |   2 +-
 arch/powerpc/boot/Makefile                         |   1 +
 arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi    |  51 ++++
 arch/powerpc/boot/dts/fsl/mpc8540ads.dts           |   2 +-
 arch/powerpc/boot/dts/fsl/mpc8541cds.dts           |   2 +-
 arch/powerpc/boot/dts/fsl/mpc8555cds.dts           |   2 +-
 arch/powerpc/boot/dts/fsl/mpc8560ads.dts           |   2 +-
 arch/powerpc/configs/pseries_defconfig             |   1 +
 arch/powerpc/include/asm/syscalls.h                |  12 +
 arch/powerpc/kernel/interrupt.c                    |  10 -
 arch/powerpc/kernel/interrupt_64.S                 |  45 +++-
 arch/powerpc/kernel/kprobes.c                      |   8 +-
 arch/powerpc/kernel/pci_dn.c                       |   1 +
 arch/powerpc/kernel/setup_64.c                     |   4 +-
 arch/powerpc/kernel/sys_ppc32.c                    |  14 +-
 arch/powerpc/kernel/syscalls.c                     |   4 +-
 arch/powerpc/math-emu/math_efp.c                   |   1 +
 arch/powerpc/platforms/powernv/opal.c              |   1 +
 arch/powerpc/platforms/pseries/vas.c               |   2 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   2 +
 arch/riscv/Kconfig                                 |   2 +-
 arch/riscv/Makefile                                |   2 +
 arch/riscv/include/asm/io.h                        |  16 +-
 arch/riscv/include/asm/mmu.h                       |   1 -
 arch/riscv/kernel/setup.c                          |   4 +-
 arch/riscv/kernel/smpboot.c                        |   3 +-
 arch/riscv/kernel/sys_riscv.c                      |   3 -
 arch/riscv/kernel/vdso.c                           |  13 +-
 arch/riscv/mm/fault.c                              |   3 +-
 arch/sh/include/asm/sections.h                     |   2 +-
 arch/sh/kernel/machvec.c                           |  10 +-
 arch/um/kernel/um_arch.c                           |   2 +-
 arch/x86/Kconfig                                   |   7 +-
 arch/x86/include/asm/cpu.h                         |   2 +
 arch/x86/include/asm/hyperv-tlfs.h                 |   4 +-
 arch/x86/include/asm/microcode.h                   |   1 +
 arch/x86/include/asm/msr-index.h                   |  13 +
 arch/x86/include/asm/paravirt_types.h              |  11 +-
 arch/x86/kernel/apic/apic.c                        |  44 +++-
 arch/x86/kernel/cpu/feat_ctl.c                     |   2 +-
 arch/x86/kernel/cpu/mce/apei.c                     |  13 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   3 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c          |  12 +-
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  37 ++-
 arch/x86/kvm/vmx/vmx.c                             |  12 +-
 arch/x86/net/bpf_jit_comp.c                        |  16 +-
 arch/x86/xen/enlighten_pv.c                        |   3 +-
 block/bio.c                                        |   2 -
 block/blk-mq.c                                     |   6 +-
 block/blk-throttle.c                               |  28 +--
 block/blk-throttle.h                               |   2 +-
 block/blk-wbt.c                                    |  10 +-
 block/blk.h                                        |   3 +-
 block/elevator.c                                   |   4 +-
 crypto/akcipher.c                                  |   8 +
 drivers/acpi/acpi_fpdt.c                           |  22 ++
 drivers/acpi/acpi_pcc.c                            |  28 ++-
 drivers/acpi/acpi_video.c                          |  16 ++
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/x86/utils.c                           |  19 +-
 drivers/ata/libahci_platform.c                     |  14 +-
 drivers/base/arch_topology.c                       |  19 ++
 drivers/block/nbd.c                                |   6 +-
 drivers/bluetooth/btintel.c                        |  17 +-
 drivers/bluetooth/btusb.c                          |  14 ++
 drivers/bluetooth/hci_ldisc.c                      |   7 +-
 drivers/bluetooth/hci_serdev.c                     |  10 +-
 drivers/char/hw_random/arm_smccc_trng.c            |   4 +-
 drivers/char/hw_random/core.c                      |  19 +-
 drivers/char/hw_random/imx-rngc.c                  |  14 +-
 drivers/char/random.c                              |   4 +-
 drivers/clk/baikal-t1/ccu-div.c                    |  65 +++++
 drivers/clk/baikal-t1/ccu-div.h                    |  10 +
 drivers/clk/baikal-t1/clk-ccu-div.c                |  26 +-
 drivers/clk/bcm/clk-bcm2835.c                      |  43 +++-
 drivers/clk/berlin/bg2.c                           |   5 +-
 drivers/clk/berlin/bg2q.c                          |   6 +-
 drivers/clk/clk-ast2600.c                          |   2 +-
 drivers/clk/clk-oxnas.c                            |   6 +-
 drivers/clk/clk-qoriq.c                            |  10 +-
 drivers/clk/clk-versaclock5.c                      |   2 +-
 drivers/clk/imx/clk-scu.c                          |   6 +-
 drivers/clk/mediatek/clk-mt8183-mfgcfg.c           |   6 +-
 drivers/clk/mediatek/clk-mt8195-infra_ao.c         |  13 +-
 drivers/clk/mediatek/clk-mt8195-mfg.c              |   6 +-
 drivers/clk/mediatek/clk-mt8195-vdo0.c             |   7 +-
 drivers/clk/mediatek/clk-mt8195-vdo1.c             |   6 +-
 drivers/clk/mediatek/clk-mtk.c                     |  12 +-
 drivers/clk/meson/meson-aoclk.c                    |   5 +-
 drivers/clk/meson/meson-eeclk.c                    |   5 +-
 drivers/clk/meson/meson8b.c                        |   5 +-
 drivers/clk/qcom/Kconfig                           |   1 +
 drivers/clk/qcom/apss-ipq6018.c                    |   2 +-
 drivers/clk/qcom/gcc-sdm660.c                      |   2 +-
 drivers/clk/qcom/gcc-sm6115.c                      |  46 ++--
 drivers/clk/samsung/clk-exynosautov9.c             |  20 +-
 drivers/clk/sprd/common.c                          |   9 +-
 drivers/clk/st/clkgen-fsyn.c                       |   5 +-
 drivers/clk/st/clkgen-mux.c                        |   5 +-
 drivers/clk/tegra/clk-tegra114.c                   |   1 +
 drivers/clk/tegra/clk-tegra20.c                    |   1 +
 drivers/clk/tegra/clk-tegra210.c                   |   1 +
 drivers/clk/ti/clk-dra7-atl.c                      |   9 +-
 drivers/clk/ti/clk.c                               |   5 +-
 drivers/clk/zynqmp/clkc.c                          |   7 +
 drivers/clk/zynqmp/pll.c                           |  31 ++-
 drivers/clocksource/arm_arch_timer.c               |   6 +-
 drivers/clocksource/timer-gxp.c                    |   7 +-
 drivers/cpufreq/amd-pstate.c                       |  16 +-
 drivers/cpufreq/intel_pstate.c                     |   1 +
 drivers/cpufreq/qcom-cpufreq-hw.c                  |  10 +-
 drivers/cpuidle/cpuidle-riscv-sbi.c                |   7 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |   6 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |   6 +-
 drivers/crypto/ccp/sev-dev.c                       |  26 +-
 drivers/crypto/hisilicon/qm.c                      |   6 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c          |   4 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   8 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |  18 +-
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h   |   2 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |  18 +-
 drivers/crypto/sahara.c                            |  18 +-
 drivers/dma-buf/udmabuf.c                          |   9 +-
 drivers/dma/hisi_dma.c                             |  28 +--
 drivers/dma/idxd/irq.c                             |   2 -
 drivers/dma/ioat/dma.c                             |   6 +-
 drivers/dma/mxs-dma.c                              |  11 +-
 drivers/dma/qcom/qcom_adm.c                        |  22 +-
 drivers/dma/ti/k3-udma.c                           |  25 +-
 drivers/firmware/efi/libstub/fdt.c                 |   8 -
 drivers/firmware/google/gsmi.c                     |   9 +
 drivers/fpga/dfl.c                                 |   2 +-
 drivers/fsi/fsi-core.c                             |   3 +
 drivers/fsi/fsi-master-ast-cf.c                    |   2 +
 drivers/fsi/fsi-occ.c                              |  18 +-
 drivers/gpio/gpio-rockchip.c                       |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |   9 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |   4 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  45 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  67 +++---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |   8 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  16 +-
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |   6 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  35 +--
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h  |   3 +-
 .../display/dc/dcn31/dcn31_hpo_dp_stream_encoder.c |   6 +-
 .../gpu/drm/amd/display/dc/dml/calcs/bw_fixed.c    |   6 +-
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h  |   8 +-
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c   |   4 +-
 drivers/gpu/drm/arm/display/komeda/komeda_kms.c    |  21 +-
 drivers/gpu/drm/arm/display/komeda/komeda_kms.h    |   2 +
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |   5 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c       |   4 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   5 +-
 drivers/gpu/drm/bridge/ite-it6505.c                |   5 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   3 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |   4 +-
 drivers/gpu/drm/bridge/parade-ps8640.c             |   4 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |  13 +-
 drivers/gpu/drm/bridge/tc358767.c                  |   5 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |   9 -
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   6 +-
 drivers/gpu/drm/drm_bridge.c                       |   4 +-
 drivers/gpu/drm/drm_ioctl.c                        |   8 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   1 +
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  18 ++
 drivers/gpu/drm/i915/display/intel_bios.c          | 110 ++++-----
 drivers/gpu/drm/i915/gt/gen6_ppgtt.c               |  16 +-
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c               |  58 ++---
 drivers/gpu/drm/i915/gt/intel_gtt.c                |   3 +
 drivers/gpu/drm/i915/intel_pm.c                    |  16 +-
 drivers/gpu/drm/meson/meson_drv.c                  |  14 +-
 drivers/gpu/drm/meson/meson_drv.h                  |   7 +
 drivers/gpu/drm/meson/meson_encoder_cvbs.c         |  13 +
 drivers/gpu/drm/meson/meson_encoder_cvbs.h         |   1 +
 drivers/gpu/drm/meson/meson_encoder_hdmi.c         |  13 +
 drivers/gpu/drm/meson/meson_encoder_hdmi.h         |   1 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |  19 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c           |  29 +--
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |   9 +-
 drivers/gpu/drm/msm/dp/dp_catalog.c                |   2 +-
 drivers/gpu/drm/msm/msm_drv.c                      |  13 +-
 drivers/gpu/drm/msm/msm_drv.h                      |   2 +
 drivers/gpu/drm/msm/msm_io_utils.c                 |  22 ++
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   4 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   3 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   1 -
 drivers/gpu/drm/omapdrm/dss/dss.c                  |   3 +
 drivers/gpu/drm/pl111/pl111_versatile.c            |   1 +
 drivers/gpu/drm/tiny/bochs.c                       |   2 +
 drivers/gpu/drm/udl/udl_modeset.c                  |   3 -
 drivers/gpu/drm/vc4/vc4_vec.c                      |   4 +-
 drivers/gpu/drm/virtio/virtgpu_display.c           |   2 +
 drivers/gpu/drm/virtio/virtgpu_gem.c               |   4 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   4 +-
 drivers/gpu/drm/virtio/virtgpu_object.c            |   3 +
 drivers/gpu/drm/virtio/virtgpu_plane.c             |   6 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                |   1 +
 drivers/hid/hid-multitouch.c                       |   8 +-
 drivers/hid/hid-nintendo.c                         |  55 +++--
 drivers/hid/hid-roccat.c                           |   4 +
 drivers/hid/hid-uclogic-core.c                     |   1 +
 drivers/hsi/clients/ssi_protocol.c                 |   1 +
 drivers/hsi/controllers/omap_ssi_core.c            |   1 +
 drivers/hsi/controllers/omap_ssi_port.c            |   8 +-
 drivers/hwmon/gsc-hwmon.c                          |   1 +
 drivers/hwmon/occ/p9_sbe.c                         |  17 +-
 drivers/hwmon/pmbus/mp2888.c                       |  13 +-
 drivers/hwmon/sht4x.c                              |   2 +-
 drivers/i2c/busses/i2c-designware-core.h           |   7 +-
 drivers/i2c/busses/i2c-designware-master.c         |  13 +
 drivers/i2c/busses/i2c-designware-pcidrv.c         |  30 +--
 drivers/i2c/busses/i2c-mlxbf.c                     |  44 +++-
 drivers/iio/adc/ad7923.c                           |   4 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |  28 ++-
 drivers/iio/adc/ltc2497.c                          |  13 +
 drivers/iio/dac/ad5593r.c                          |  46 ++--
 drivers/iio/inkern.c                               |   8 +-
 drivers/iio/magnetometer/yamaha-yas530.c           |   2 +-
 drivers/iio/pressure/dps310.c                      | 262 +++++++++++++--------
 drivers/infiniband/core/cm.c                       |  14 +-
 drivers/infiniband/core/uverbs_cmd.c               |   5 +-
 drivers/infiniband/core/verbs.c                    |   2 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   1 -
 drivers/infiniband/hw/irdma/defs.h                 |   1 +
 drivers/infiniband/hw/irdma/hw.c                   |  51 ++--
 drivers/infiniband/hw/irdma/type.h                 |   1 +
 drivers/infiniband/hw/irdma/user.h                 |   1 +
 drivers/infiniband/hw/irdma/utils.c                |   3 +
 drivers/infiniband/hw/irdma/verbs.c                |  69 +++++-
 drivers/infiniband/hw/mlx4/mr.c                    |   1 -
 drivers/infiniband/hw/mlx5/main.c                  |   3 +
 drivers/infiniband/hw/mlx5/odp.c                   |   3 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  10 +-
 drivers/infiniband/sw/rxe/rxe_queue.c              |  12 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  10 +-
 drivers/infiniband/sw/siw/siw.h                    |   1 +
 drivers/infiniband/sw/siw/siw_qp.c                 |   2 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |  27 ++-
 drivers/infiniband/sw/siw/siw_verbs.c              |   3 +
 drivers/infiniband/ulp/srp/ib_srp.c                |   4 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  21 ++
 drivers/iommu/omap-iommu-debug.c                   |   6 +-
 drivers/isdn/mISDN/l1oip.h                         |   1 +
 drivers/isdn/mISDN/l1oip_core.c                    |  13 +-
 drivers/leds/flash/leds-lm3601x.c                  |   2 -
 drivers/mailbox/bcm-flexrm-mailbox.c               |   8 +-
 drivers/mailbox/mailbox-mpfs.c                     |  25 +-
 drivers/md/bcache/writeback.c                      |  73 ++++--
 drivers/md/raid0.c                                 |   2 +-
 drivers/md/raid5.c                                 |  15 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |   9 +-
 drivers/media/pci/cx88/cx88-video.c                |  43 ++--
 drivers/media/platform/amlogic/meson-ge2d/ge2d.c   |   1 -
 drivers/media/platform/amphion/vdec.c              |  16 +-
 drivers/media/platform/amphion/venc.c              |   2 +-
 drivers/media/platform/amphion/vpu.h               |   1 -
 drivers/media/platform/amphion/vpu_core.c          |  84 +++----
 drivers/media/platform/amphion/vpu_core.h          |   1 +
 drivers/media/platform/amphion/vpu_dbg.c           |   9 +-
 drivers/media/platform/amphion/vpu_malone.c        |   2 +-
 .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |   1 -
 .../media/platform/samsung/exynos4-is/fimc-is.c    |   1 +
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c   |   3 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   9 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  83 ++++---
 drivers/media/usb/uvc/uvc_driver.c                 |   8 +-
 drivers/memory/of_memory.c                         |   2 +
 drivers/memory/pl353-smc.c                         |   1 +
 drivers/mfd/da9062-core.c                          |   1 +
 drivers/mfd/fsl-imx25-tsadc.c                      |  34 ++-
 drivers/mfd/intel_soc_pmic_core.c                  |   1 +
 drivers/mfd/lp8788-irq.c                           |   3 +
 drivers/mfd/lp8788.c                               |  12 +-
 drivers/mfd/sm501.c                                |   7 +-
 drivers/misc/ocxl/file.c                           |   2 +
 drivers/mmc/core/block.c                           |   6 +-
 drivers/mmc/core/card.h                            |   6 +
 drivers/mmc/core/quirks.h                          |   6 +
 drivers/mmc/host/au1xmmc.c                         |   3 +-
 drivers/mmc/host/renesas_sdhi_core.c               |  21 +-
 drivers/mmc/host/sdhci-sprd.c                      |   2 +-
 drivers/mmc/host/sdhci-tegra.c                     |   2 +-
 drivers/mmc/host/wmt-sdmmc.c                       |   5 +-
 drivers/mtd/devices/docg3.c                        |   7 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   1 +
 drivers/mtd/nand/raw/fsl_elbc_nand.c               |  28 ++-
 drivers/mtd/nand/raw/intel-nand-controller.c       |  12 +-
 drivers/mtd/nand/raw/meson_nand.c                  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |   2 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   3 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  79 +++++++
 drivers/net/ethernet/atheros/alx/main.c            |   5 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  10 +-
 drivers/net/ethernet/engleder/tsnep_hw.h           |   3 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c   |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 177 +++++++++++---
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |  10 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  13 +-
 .../net/ethernet/marvell/prestera/prestera_acl.c   |   8 +-
 .../net/ethernet/marvell/prestera/prestera_acl.h   |   4 +-
 .../ethernet/marvell/prestera/prestera_flower.c    |   6 +-
 drivers/net/ethernet/microchip/lan743x_ptp.c       |   7 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c       |   2 +-
 drivers/net/ethernet/ti/Kconfig                    |   1 +
 drivers/net/ethernet/ti/davinci_mdio.c             | 242 ++++++++++++++++++-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  12 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  37 ++-
 drivers/net/hyperv/hyperv_net.h                    |   3 +-
 drivers/net/hyperv/netvsc.c                        |   4 +
 drivers/net/hyperv/netvsc_drv.c                    |  19 ++
 drivers/net/thunderbolt.c                          |  28 ++-
 drivers/net/usb/r8152.c                            |   4 +-
 drivers/net/wireless/ath/ath10k/core.c             |  16 ++
 drivers/net/wireless/ath/ath10k/htc.c              |  11 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   2 +
 drivers/net/wireless/ath/ath10k/mac.c              |  54 +++--
 drivers/net/wireless/ath/ath11k/ahb.c              |  58 ++++-
 drivers/net/wireless/ath/ath11k/core.c             |   2 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  25 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |  17 +-
 drivers/net/wireless/ath/ath11k/peer.c             |  30 ++-
 drivers/net/wireless/ath/ath11k/qmi.c              |  38 ++-
 drivers/net/wireless/ath/ath11k/qmi.h              |  10 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   9 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   2 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |  43 ++--
 drivers/net/wireless/ath/ath9k/rng.c               |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   4 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   5 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  26 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  15 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |  28 ++-
 drivers/net/wireless/mediatek/mt76/sdio.c          |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  34 ++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  96 ++++++--
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |   9 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   8 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |  12 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   5 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |   3 +
 drivers/net/wireless/silabs/wfx/main.c             |   2 +-
 drivers/net/wireless/st/cw1200/queue.c             |  18 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c              |   5 +-
 drivers/nvme/host/core.c                           |  20 +-
 drivers/nvme/host/ioctl.c                          |   9 +-
 drivers/nvme/host/multipath.c                      |   1 +
 drivers/nvme/host/nvme.h                           |   4 +-
 drivers/nvme/target/passthru.c                     |   7 +-
 drivers/nvme/target/tcp.c                          |  11 +-
 drivers/nvmem/core.c                               |  15 +-
 drivers/pci/setup-res.c                            |  11 +
 drivers/perf/riscv_pmu_sbi.c                       |   7 +-
 .../phy/amlogic/phy-meson-axg-mipi-pcie-analog.c   |   6 +-
 drivers/phy/mediatek/phy-mtk-tphy.c                |   7 +-
 drivers/phy/qualcomm/phy-qcom-usb-hsic.c           |   6 +-
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |  10 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  13 +
 drivers/platform/chrome/chromeos_laptop.c          |  24 +-
 drivers/platform/chrome/cros_ec.c                  |   8 +-
 drivers/platform/chrome/cros_ec_chardev.c          |   3 +
 drivers/platform/chrome/cros_ec_proto.c            |  32 +++
 drivers/platform/chrome/cros_ec_typec.c            |   2 +-
 drivers/platform/x86/hp-wmi.c                      |  11 +-
 drivers/platform/x86/msi-laptop.c                  |  14 +-
 drivers/platform/x86/pmc_atom.c                    |   2 +-
 drivers/power/supply/adp5061.c                     |   6 +-
 drivers/powercap/intel_rapl_common.c               |   4 +-
 drivers/regulator/core.c                           |   2 +-
 drivers/regulator/qcom_rpm-regulator.c             |  24 +-
 drivers/remoteproc/remoteproc_core.c               |   5 +-
 drivers/rpmsg/rpmsg_char.c                         |   4 +-
 drivers/scsi/3w-9xxx.c                             |   2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   2 +-
 drivers/scsi/iscsi_tcp.c                           | 140 ++++++++---
 drivers/scsi/iscsi_tcp.h                           |   5 +
 drivers/scsi/libiscsi.c                            |  41 +++-
 drivers/scsi/libsas/sas_expander.c                 |   2 +-
 drivers/scsi/lpfc/lpfc.h                           |  14 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   8 +
 drivers/scsi/lpfc/lpfc_ct.c                        |   7 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |  59 +----
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  83 ++-----
 drivers/scsi/lpfc/lpfc_mem.c                       |   9 +-
 drivers/scsi/lpfc/lpfc_sli.c                       | 190 ++++++++++++++-
 drivers/scsi/pm8001/pm8001_hwi.c                   |   4 +
 drivers/scsi/qedf/qedf_main.c                      |  21 ++
 drivers/slimbus/Kconfig                            |   3 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |  22 +-
 drivers/soc/qcom/smem_state.c                      |   3 +-
 drivers/soc/qcom/smsm.c                            |  20 +-
 drivers/soc/tegra/Kconfig                          |   1 -
 drivers/soundwire/cadence_master.c                 |   9 +-
 drivers/soundwire/intel.c                          |   1 -
 drivers/spi/spi-cadence-quadspi.c                  |   3 +-
 drivers/spi/spi-dw-bt1.c                           |   4 +-
 drivers/spi/spi-meson-spicc.c                      |   6 +-
 drivers/spi/spi-mt7621.c                           |   8 +-
 drivers/spi/spi-omap-100k.c                        |   1 +
 drivers/spi/spi-qup.c                              |  21 +-
 drivers/spi/spi-s3c64xx.c                          |   9 +
 drivers/spi/spi.c                                  |   2 +
 drivers/spmi/spmi-pmic-arb.c                       |  13 +-
 drivers/staging/greybus/audio_helper.c             |  11 -
 drivers/staging/media/meson/vdec/vdec_hevc.c       |   6 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c   |   5 +-
 drivers/staging/rtl8723bs/core/rtw_cmd.c           |  16 +-
 drivers/staging/rtl8723bs/os_dep/os_intfs.c        |  60 ++---
 drivers/staging/vt6655/device_main.c               |   8 +-
 drivers/thermal/cpufreq_cooling.c                  |  10 +-
 drivers/thermal/intel/intel_powerclamp.c           |   6 +-
 drivers/thermal/qcom/tsens-v0_1.c                  |   2 +-
 drivers/thunderbolt/nhi.c                          |  49 +++-
 drivers/thunderbolt/switch.c                       |  24 ++
 drivers/thunderbolt/tb.h                           |   1 +
 drivers/thunderbolt/tb_regs.h                      |   1 +
 drivers/thunderbolt/usb4.c                         |  20 ++
 drivers/tty/serial/8250/8250_core.c                |  16 +-
 drivers/tty/serial/8250/8250_pci.c                 |   5 +
 drivers/tty/serial/8250/8250_port.c                |  18 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |  22 +-
 drivers/tty/serial/fsl_lpuart.c                    |   2 +
 drivers/tty/serial/jsm/jsm_driver.c                |   3 +-
 drivers/tty/serial/stm32-usart.c                   | 100 ++++----
 drivers/tty/serial/xilinx_uartps.c                 |   2 +
 drivers/usb/common/debug.c                         |  96 +++++---
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/dwc3/core.c                            |  83 +++++--
 drivers/usb/dwc3/core.h                            |   6 +
 drivers/usb/gadget/function/f_fs.c                 |   4 +-
 drivers/usb/gadget/function/f_printer.c            |  12 +-
 drivers/usb/gadget/function/f_uvc.c                |   6 +-
 drivers/usb/gadget/function/uvc.h                  |   1 +
 drivers/usb/gadget/function/uvc_v4l2.c             |   2 +-
 drivers/usb/gadget/function/uvc_video.c            |   9 +-
 drivers/usb/host/xhci-dbgcap.c                     |   2 +-
 drivers/usb/host/xhci-mem.c                        |   7 +-
 drivers/usb/host/xhci-plat.c                       |  18 +-
 drivers/usb/host/xhci.c                            |   3 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/misc/idmouse.c                         |   8 +-
 drivers/usb/mtu3/mtu3_core.c                       |   2 -
 drivers/usb/mtu3/mtu3_plat.c                       |   2 +
 drivers/usb/musb/musb_gadget.c                     |   3 +
 drivers/usb/storage/unusual_devs.h                 |   6 -
 drivers/usb/typec/ucsi/ucsi.c                      |   8 +-
 drivers/vhost/vsock.c                              |   2 +-
 drivers/video/fbdev/smscufx.c                      |  14 +-
 drivers/video/fbdev/stifb.c                        |   2 +-
 drivers/xen/gntdev-common.h                        |   3 +-
 drivers/xen/gntdev.c                               |  80 ++++---
 fs/btrfs/block-group.c                             |  11 +-
 fs/btrfs/extent-tree.c                             |   3 +
 fs/btrfs/file.c                                    |  59 ++++-
 fs/btrfs/free-space-cache.c                        |  59 +++--
 fs/btrfs/qgroup.c                                  |  15 ++
 fs/btrfs/scrub.c                                   |  69 ++++--
 fs/btrfs/super.c                                   |  20 +-
 fs/cifs/cifsproto.h                                |   2 +-
 fs/cifs/connect.c                                  |   2 +-
 fs/cifs/file.c                                     |   9 +
 fs/cifs/smb2ops.c                                  |  23 +-
 fs/cifs/smb2pdu.c                                  |   7 +-
 fs/cifs/smb2transport.c                            |  10 +-
 fs/dlm/ast.c                                       |   6 +-
 fs/dlm/lock.c                                      |  20 +-
 fs/dlm/lowcomms.c                                  |   4 +
 fs/erofs/inode.c                                   |   2 +-
 fs/erofs/super.c                                   |   2 +-
 fs/eventfd.c                                       |  10 +-
 fs/ext2/super.c                                    |  22 +-
 fs/ext4/fast_commit.c                              |  40 ++--
 fs/ext4/file.c                                     |   6 +
 fs/ext4/inode.c                                    |  17 +-
 fs/ext4/ioctl.c                                    |   4 +
 fs/ext4/namei.c                                    |  17 +-
 fs/ext4/resize.c                                   |   2 +-
 fs/ext4/super.c                                    |  47 ++--
 fs/ext4/xattr.c                                    |   1 +
 fs/f2fs/checkpoint.c                               |  47 +++-
 fs/f2fs/data.c                                     |   4 +-
 fs/f2fs/extent_cache.c                             |   3 +-
 fs/f2fs/f2fs.h                                     |   9 +-
 fs/f2fs/gc.c                                       |  22 +-
 fs/f2fs/recovery.c                                 |  23 +-
 fs/f2fs/segment.c                                  |   2 +-
 fs/f2fs/super.c                                    |  15 +-
 fs/file_table.c                                    |   7 +-
 fs/fs-writeback.c                                  |  37 ++-
 fs/internal.h                                      |  10 +
 fs/iomap/buffered-io.c                             |   2 +-
 fs/jbd2/commit.c                                   |   2 +-
 fs/jbd2/journal.c                                  |  10 +-
 fs/jbd2/recovery.c                                 |   1 +
 fs/jbd2/transaction.c                              |   6 +-
 fs/ksmbd/server.c                                  |   4 +-
 fs/ksmbd/smb2pdu.c                                 |  27 +--
 fs/ksmbd/smb_common.c                              |   6 +-
 fs/nfsd/nfs3proc.c                                 |  11 +-
 fs/nfsd/nfs4proc.c                                 |  19 +-
 fs/nfsd/nfs4recover.c                              |   4 +-
 fs/nfsd/nfs4state.c                                |   5 +
 fs/nfsd/nfs4xdr.c                                  |  14 +-
 fs/nfsd/nfsproc.c                                  |   6 +-
 fs/nfsd/xdr4.h                                     |   3 +-
 fs/ntfs3/inode.c                                   |   2 -
 fs/ntfs3/xattr.c                                   | 102 +-------
 fs/open.c                                          |  11 +-
 fs/quota/quota_tree.c                              |  38 +++
 fs/splice.c                                        |  10 +-
 fs/userfaultfd.c                                   |   4 +-
 fs/xfs/xfs_super.c                                 |  10 +-
 include/dt-bindings/clock/samsung,exynosautov9.h   |  56 ++---
 include/linux/ata.h                                |  39 +--
 include/linux/bio.h                                |   2 +-
 include/linux/blk_types.h                          |   2 +-
 include/linux/bpf-cgroup-defs.h                    |   4 +-
 include/linux/bpf-cgroup.h                         |   2 +-
 include/linux/bpf.h                                |   6 +-
 include/linux/bpf_verifier.h                       |  11 +
 include/linux/dynamic_debug.h                      |  11 +-
 include/linux/eventfd.h                            |   2 +-
 include/linux/export-internal.h                    |   6 +-
 include/linux/filter.h                             |   5 +
 include/linux/fortify-string.h                     |   3 +-
 include/linux/fs.h                                 |   9 +-
 include/linux/hugetlb.h                            |   8 +-
 include/linux/hw_random.h                          |   3 +
 include/linux/iova.h                               |   2 +-
 include/linux/mmc/card.h                           |   1 +
 include/linux/once.h                               |  28 +++
 include/linux/ring_buffer.h                        |   2 +-
 include/linux/sched.h                              |   2 +-
 include/linux/serial_8250.h                        |   1 +
 include/linux/serial_core.h                        |   3 +-
 include/linux/skbuff.h                             |   2 +
 include/linux/sunrpc/svc.h                         |  19 +-
 include/linux/tcp.h                                |   2 +-
 include/linux/trace.h                              |  36 ++-
 include/linux/trace_events.h                       |   1 +
 include/net/ieee802154_netdev.h                    |  12 +-
 include/net/tcp.h                                  |   5 +-
 include/scsi/libiscsi.h                            |   6 +-
 include/uapi/rdma/mlx5-abi.h                       |   1 +
 io_uring/io_uring.c                                |  21 +-
 ipc/mqueue.c                                       |   1 +
 kernel/auditsc.c                                   |   4 +-
 kernel/bpf/bpf_local_storage.c                     |   4 +-
 kernel/bpf/bpf_task_storage.c                      |   8 +-
 kernel/bpf/btf.c                                   |   2 +-
 kernel/bpf/cgroup.c                                |  76 +++---
 kernel/bpf/core.c                                  |   9 +-
 kernel/bpf/dispatcher.c                            |  27 ++-
 kernel/bpf/hashtab.c                               |  30 ++-
 kernel/bpf/helpers.c                               |  14 +-
 kernel/bpf/syscall.c                               |   4 +-
 kernel/bpf/trampoline.c                            |   8 +-
 kernel/bpf/verifier.c                              | 116 ++++-----
 kernel/cgroup/cgroup.c                             |   6 +-
 kernel/cgroup/cpuset.c                             |  18 +-
 kernel/livepatch/transition.c                      |  18 +-
 kernel/module/tracking.c                           |   3 +
 kernel/rcu/tree.c                                  |  17 +-
 kernel/rcu/tree_plugin.h                           |   3 +-
 kernel/trace/bpf_trace.c                           |  20 +-
 kernel/trace/ftrace.c                              |  28 ++-
 kernel/trace/kprobe_event_gen_test.c               |  49 +++-
 kernel/trace/ring_buffer.c                         |  87 ++++++-
 kernel/trace/trace.c                               |  76 +++++-
 kernel/trace/trace_eprobe.c                        |  60 +----
 kernel/trace/trace_events_synth.c                  |  23 +-
 kernel/trace/trace_kprobe.c                        |  60 +----
 kernel/trace/trace_osnoise.c                       |   3 +-
 kernel/trace/trace_probe_kernel.h                  | 115 +++++++++
 lib/Kconfig.debug                                  |  10 +-
 lib/dynamic_debug.c                                |  45 +---
 lib/once.c                                         |  30 +++
 mm/damon/vaddr.c                                   |  10 +
 mm/gup.c                                           |  14 +-
 mm/hugetlb.c                                       |  68 +++---
 mm/memory.c                                        |   2 +
 mm/mmap.c                                          |   5 +-
 mm/mprotect.c                                      |   2 +
 net/bluetooth/hci_core.c                           |  34 ++-
 net/bluetooth/hci_sync.c                           |   1 +
 net/bluetooth/hci_sysfs.c                          |   3 +
 net/bluetooth/l2cap_core.c                         |  17 +-
 net/bluetooth/rfcomm/sock.c                        |   3 +
 net/can/bcm.c                                      |   7 +-
 net/core/flow_dissector.c                          |   4 +-
 net/core/skmsg.c                                   |  12 +-
 net/core/stream.c                                  |   3 +-
 net/ieee802154/socket.c                            |   4 +
 net/ipv4/datagram.c                                |   2 +
 net/ipv4/esp4_offload.c                            |   5 +-
 net/ipv4/inet_hashtables.c                         |   4 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |   3 +
 net/ipv4/tcp.c                                     |  16 +-
 net/ipv4/tcp_output.c                              |  19 +-
 net/ipv6/esp6_offload.c                            |   5 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |   6 +-
 net/mac80211/cfg.c                                 |   3 -
 net/netfilter/nf_conntrack_core.c                  |  18 +-
 net/openvswitch/datapath.c                         |  18 +-
 net/rds/tcp.c                                      |   2 +-
 net/sctp/auth.c                                    |  18 +-
 net/unix/af_unix.c                                 |  13 +-
 net/unix/garbage.c                                 |  20 ++
 net/vmw_vsock/virtio_transport_common.c            |   2 +-
 net/wireless/reg.c                                 |   4 +
 net/xdp/xsk.c                                      |  22 +-
 net/xdp/xsk_queue.h                                |  22 +-
 net/xfrm/xfrm_input.c                              |  18 +-
 net/xfrm/xfrm_ipcomp.c                             |   1 +
 scripts/Kbuild.include                             |  23 +-
 scripts/package/mkspec                             |   4 +-
 scripts/pahole-flags.sh                            |   4 +
 scripts/selinux/install_policy.sh                  |   2 +-
 security/integrity/ima/ima_appraise.c              |  12 +-
 sound/core/pcm_dmaengine.c                         |   8 +-
 sound/core/rawmidi.c                               |   2 -
 sound/core/sound_oss.c                             |  13 +-
 sound/hda/intel-dsp-config.c                       |   5 +
 sound/pci/hda/hda_beep.c                           |  15 +-
 sound/pci/hda/hda_beep.h                           |   1 +
 sound/pci/hda/patch_hdmi.c                         |   6 -
 sound/pci/hda/patch_realtek.c                      |  11 +-
 sound/pci/hda/patch_sigmatel.c                     |  25 +-
 sound/soc/codecs/da7219.c                          |   5 +-
 sound/soc/codecs/lpass-tx-macro.c                  |  13 +-
 sound/soc/codecs/mt6359-accdet.c                   |   6 +-
 sound/soc/codecs/mt6660.c                          |   8 +-
 sound/soc/codecs/tas2764.c                         |  78 ++----
 sound/soc/codecs/wcd9335.c                         |   2 +-
 sound/soc/codecs/wcd934x.c                         |   2 +-
 sound/soc/codecs/wm5102.c                          |   6 +-
 sound/soc/codecs/wm5110.c                          |   6 +-
 sound/soc/codecs/wm8997.c                          |   6 +-
 sound/soc/codecs/wm_adsp.c                         |   4 +-
 sound/soc/fsl/eukrea-tlv320.c                      |   8 +-
 sound/soc/sh/rcar/ctu.c                            |   6 +-
 sound/soc/sh/rcar/dvc.c                            |   6 +-
 sound/soc/sh/rcar/mix.c                            |   6 +-
 sound/soc/sh/rcar/src.c                            |   5 +-
 sound/soc/sh/rcar/ssi.c                            |   4 +-
 sound/soc/soc-pcm.c                                |   2 +-
 sound/soc/sof/intel/hda.c                          |  11 +
 sound/soc/sof/ipc3-topology.c                      |   7 +
 sound/soc/sof/mediatek/mt8195/mt8195.c             |   1 +
 sound/soc/sof/sof-pci-dev.c                        |   2 +-
 sound/soc/sof/sof-priv.h                           |   4 +
 sound/soc/stm/stm32_adfsdm.c                       |   8 +-
 sound/soc/stm/stm32_i2s.c                          |   4 +-
 sound/soc/stm/stm32_spdifrx.c                      |   4 +-
 sound/usb/card.c                                   |  32 ++-
 sound/usb/endpoint.c                               |  17 +-
 sound/usb/quirks.c                                 |  42 ----
 sound/usb/quirks.h                                 |   2 -
 sound/usb/usbaudio.h                               |   1 +
 tools/bpf/bpftool/btf_dumper.c                     |   2 +-
 tools/bpf/bpftool/main.c                           |  10 +
 tools/lib/bpf/xsk.c                                |   6 +-
 tools/objtool/elf.c                                |   7 +-
 tools/perf/arch/x86/util/intel-pt.c                |   2 +-
 tools/perf/util/intel-pt.c                         |   9 +-
 tools/perf/util/parse-events.c                     |   3 +
 tools/perf/util/pmu.c                              |  17 ++
 tools/perf/util/pmu.h                              |   2 +
 tools/perf/util/pmu.l                              |   2 -
 tools/perf/util/pmu.y                              |  15 +-
 .../selftests/arm64/signal/testcases/testcases.c   |   2 +-
 .../selftests/bpf/map_tests/array_map_batch_ops.c  |   2 +
 .../selftests/bpf/map_tests/htab_map_batch_ops.c   |   2 +
 .../bpf/map_tests/lpm_trie_map_batch_ops.c         |   2 +
 tools/testing/selftests/bpf/progs/kprobe_multi.c   |   4 +-
 tools/testing/selftests/bpf/test_maps.c            |  24 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |   4 +
 tools/testing/selftests/net/fcnal-test.sh          |  30 +++
 tools/testing/selftests/net/nettest.c              |  16 +-
 tools/testing/selftests/tpm2/tpm2.py               |   4 +
 768 files changed, 7191 insertions(+), 3390 deletions(-)


