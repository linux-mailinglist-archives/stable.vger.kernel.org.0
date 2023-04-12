Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5996DEE62
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjDLIlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjDLIku (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1417E7AA9;
        Wed, 12 Apr 2023 01:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FFF262903;
        Wed, 12 Apr 2023 08:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40042C433D2;
        Wed, 12 Apr 2023 08:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288794;
        bh=qlN2kpTizfK9dHdTZIB5Ho7ngcQq48hnnWw0ktWLHAc=;
        h=From:To:Cc:Subject:Date:From;
        b=SguSTxj3mbkfHAh7Wm0g5iY9GfJwANS5BWxcC1WV8lVh3mXZZXZFfpYcJ1ZFm7uNG
         1VQh7gIS0pu2FoO1EWRGZ9+VwpgFbVIua+1kD3MqB6pF4DsOP31dCFfDXNaXszBgwv
         7kWdSXJ65eX0hqcTdSnPRBcqmD8YdFZlBanZDdmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/164] 6.1.24-rc1 review
Date:   Wed, 12 Apr 2023 10:32:02 +0200
Message-Id: <20230412082836.695875037@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.24-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.24-rc1
X-KernelTest-Deadline: 2023-04-14T08:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.24 release.
There are 164 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.24-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.24-rc1

Liam R. Howlett <Liam.Howlett@Oracle.com>
    mm: enable maple tree RCU mode by default.

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: add RCU lock checking to rcu callback functions

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: add smp_rmb() to dead node detection

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: remove extra smp_wmb() from mas_dead_leaves()

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: fix freeing of nodes in rcu mode

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: detect dead nodes in mas_start()

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: refine ma_state init from mas_start()

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: be more cautious about dead nodes

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: fix mas_prev() and mas_find() state handling

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: fix handle of invalidated state in mas_wr_store_setup()

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: reduce user error potential

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: fix potential rcu issue

Liam R. Howlett <Liam.Howlett@Oracle.com>
    maple_tree: remove GFP_ZERO from kmem_cache_alloc() and kmem_cache_alloc_bulk()

Alistair Popple <apopple@nvidia.com>
    mm: take a page reference when removing device exclusive entries

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Split icl_color_commit_noarm() from skl_color_commit_noarm()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Use _MMIO_PIPE() for SKL_BOTTOM_COLOR

Robert Foss <robert.foss@linaro.org>
    drm/bridge: lt9611: Fix PLL being unable to lock

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Fix payload removal during output disabling

Imre Deak <imre.deak@intel.com>
    drm/display/dp_mst: Handle old/new payload states in drm_dp_remove_payload()

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: skip psp suspend for IMU enabled ASICs mode2 reset

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: for S0ix, skip SDMA 5.x+ suspend/resume

Roman Li <roman.li@amd.com>
    drm/amd/display: Clear MST topology if it fails to resume

Kemeng Shi <shikemeng@huawei.com>
    blk-throttle: Fix that bps of child could exceed bps limited in parent

Peng Zhang <zhangpeng.00@bytedance.com>
    maple_tree: fix a potential concurrency bug in RCU mode

Peng Zhang <zhangpeng.00@bytedance.com>
    maple_tree: fix get wrong data_end in mtree_lookup_walk()

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix uffd wr-protection for CoW optimization path

Rongwei Wang <rongwei.wang@linux.alibaba.com>
    mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Zheng Yejian <zhengyejian1@huawei.com>
    ring-buffer: Fix race while reader and writer are on the same page

Min Li <lm0963hack@gmail.com>
    drm/i915: fix race condition UAF in i915_perf_add_config_ioctl

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Fix context runtime accounting

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/disp: Support more modes by checking with lower bpc

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path

Jens Axboe <axboe@kernel.dk>
    ublk: read any SQE values upfront

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: ignore key disable commands

Yafang Shao <laoar.shao@gmail.com>
    mm: vmalloc: avoid warn_alloc noise caused by fatal signal

Sergey Senozhatsky <senozhatsky@chromium.org>
    zsmalloc: document freeable stats

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/synthetic: Make lastcmd_mutex static

Jason Montleon <jmontleo@redhat.com>
    ASoC: hdac_hdmi: use set_stream() instead of set_tdm_slots()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Free error logs of tracing instances

Daniel Bristot de Oliveira <bristot@kernel.org>
    tracing/osnoise: Fix notify new tracing_max_latency

Daniel Bristot de Oliveira <bristot@kernel.org>
    tracing/timerlat: Notify new max thread latency

Tze-nan Wu <Tze-nan.Wu@mediatek.com>
    tracing/synthetic: Fix races on freeing last_cmd

Song Yoong Siang <yoong.siang.song@intel.com>
    net: stmmac: Add queue reset into stmmac_xdp_open() function

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add acpi_backlight=video quirk for Lenovo ThinkPad W530

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add acpi_backlight=video quirk for Apple iMac14,1 and iMac14,2

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Make acpi_backlight=video work independent from GPU driver

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add auto_detect arg to __acpi_video_get_backlight_type()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos

Michal Sojka <michal.sojka@cvut.cz>
    can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix race between isotp_sendsmg() and isotp_release()

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

Christian Brauner <brauner@kernel.org>
    fs: drop peer group ids under namespace lock

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Fix issue that 'direct->addr' not restored in modify_ftrace_direct()

John Keeping <john@metanate.com>
    ftrace: Mark get_lock_parent_ip() __always_inline

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix the same task check in perf_event_set_output

Yu Kuai <yukuai3@huawei.com>
    block: don't set GD_NEED_PART_SCAN if scan partition failed

Ming Lei <ming.lei@redhat.com>
    block: ublk: make sure that block size is set correctly

Thiago Rafael Becker <tbecker@redhat.com>
    cifs: sanitize paths in cifs_update_super_prepath.

Keith Busch <kbusch@kernel.org>
    nvme: fix discard support without oncs

Zhong Jinghua <zhongjinghua@huawei.com>
    scsi: iscsi_tcp: Check that sock is valid before iscsi_set_param()

Li Zetao <lizetao1@huawei.com>
    scsi: qla2xxx: Fix memory leak in qla2x00_probe_one()

Wojciech Lukowicz <wlukowicz01@gmail.com>
    io_uring: fix memory leak when removing provided buffers

Wojciech Lukowicz <wlukowicz01@gmail.com>
    io_uring: fix return value when removing provided buffers

Nuno Sá <nuno.sa@analog.com>
    iio: adc: ad7791: fix IRQ flags

Keith Busch <kbusch@kernel.org>
    blk-mq: directly poll requests

William Breathitt Gray <william.gray@linaro.org>
    counter: 104-quad-8: Fix Synapse action reported for Index signals

William Breathitt Gray <william.gray@linaro.org>
    counter: 104-quad-8: Fix race condition between FLAG and CNTR reads

Steve Clevenger <scclevenger@os.amperecomputing.com>
    coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Do not access TRCIDR1 for identification

Muchun Song <muchun.song@linux.dev>
    mm: kfence: fix handling discontiguous page

Muchun Song <muchun.song@linux.dev>
    mm: kfence: fix PG_slab and memcg_data clearing

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Do not report error code when synthesizing VM-Exit from Real Mode

Sean Christopherson <seanjc@google.com>
    KVM: x86: Clear "has_error_code", not "error_code", for RM exception injection

Mario Limonciello <mario.limonciello@amd.com>
    x86/ACPI/boot: Use FADT version to check support for online capable

Eric DeVolder <eric.devolder@oracle.com>
    x86/acpi/boot: Correct acpi_is_processor_usable() check

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Jeremy Soller <jeremy@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo X370SNW

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix slab-out-of-bounds in init_smb2_rsp_hdr

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Prevent starting up DMA Rx on THRI interrupt

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: serial: renesas,scif: Fix 4th IRQ for 4-IRQ SCIFs

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix sysfs interface lifetime

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix transmit end interrupt handler

Kai-Heng Feng <kai.heng.feng@canonical.com>
    iio: light: cm32181: Unregister second I2C client if present

Nuno Sá <nuno.sa@analog.com>
    iio: buffer: make sure O_NONBLOCK is respected

Nuno Sá <nuno.sa@analog.com>
    iio: buffer: correctly return bytes written in output buffers

William Breathitt Gray <william.gray@linaro.org>
    iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Lars-Peter Clausen <lars@metafoo.de>
    iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: adc: qcom-spmi-adc5: Fix the channel name

Arnd Bergmann <arnd@arndb.de>
    iio: adis16480: select CONFIG_CRC32

Ian Ray <ian.ray@ge.com>
    drivers: iio: adc: ltc2497: fix LSB shift

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: add Quectel RM500U-CN modem

Enrico Sau <enrico.sau@gmail.com>
    USB: serial: option: add Telit FE990 compositions

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: Fix configure initial pin assignment

Kees Jan Koster <kjkoster@kjkoster.org>
    USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Meteor Lake-S

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fixes error: uninitialized symbol 'len'

D Scott Phillips <scott@os.amperecomputing.com>
    xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Free the command allocated for setting LPM if we return early

Wayne Chang <waynec@nvidia.com>
    usb: xhci: tegra: fix sleep in atomic call

Lukas Wunner <lukas@wunner.de>
    PCI/DOE: Fix memory leak with CONFIG_DEBUG_OBJECTS=y

Lukas Wunner <lukas@wunner.de>
    PCI/DOE: Silence WARN splat with CONFIG_DEBUG_OBJECTS=y

Lukas Wunner <lukas@wunner.de>
    cxl/pci: Handle excessive CDAT length

Lukas Wunner <lukas@wunner.de>
    cxl/pci: Handle truncated CDAT entries

Lukas Wunner <lukas@wunner.de>
    cxl/pci: Handle truncated CDAT header

Lukas Wunner <lukas@wunner.de>
    cxl/pci: Fix CDAT retrieval on big endian

Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
    net: stmmac: check fwnode for phy device before scanning for phy

Ard Biesheuvel <ardb@kernel.org>
    arm64: compat: Work around uninitialized variable warning

Shailend Chand <shailend@google.com>
    gve: Secure enough bytes in the first TX desc for all TCP pkts

Eric Dumazet <edumazet@google.com>
    netlink: annotate lockless accesses to nlk->max_recvmsg_len

Andy Roulin <aroulin@nvidia.com>
    ethtool: reset #lanes when lanes is omitted

Kuniyuki Iwashima <kuniyu@amazon.com>
    ping: Fix potentail NULL deref for /proc/net/icmp.

Kuniyuki Iwashima <kuniyu@amazon.com>
    raw: Fix NULL deref in raw_get_next().

Eric Dumazet <edumazet@google.com>
    raw: use net_hash_mix() in hash function

Lingyu Liu <lingyu.liu@intel.com>
    ice: Reset FDIR counter in FDIR init stage

Simei Su <simei.su@intel.com>
    ice: fix wrong fallback logic for FDIR

Dai Ngo <dai.ngo@oracle.com>
    NFSD: callback request does not use correct credential for AUTH_SYS

Jeff Layton <jlayton@kernel.org>
    sunrpc: only free unix grouplist after RCU settles

Corinna Vinschen <vinschen@redhat.com>
    net: stmmac: fix up RX flow hash indirection table when setting channels

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe

Dhruva Gole <d-gole@ti.com>
    gpio: davinci: Add irq chip flag to skip set wake

Dhruva Gole <d-gole@ti.com>
    gpio: davinci: Do not clear the bank intr enable bit in save_context

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: Clean up display of current_value on Thinkstation

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: Fix memory leaks when parsing ThinkStation WMI strings

Armin Wolf <W_Armin@gmx.de>
    platform/x86: think-lmi: Fix memory leak when showing current settings

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv6: Fix an uninit variable access bug in __ip6_make_skb()

Sricharan Ramabadhran <quic_srichara@quicinc.com>
    net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT

Xin Long <lucien.xin@gmail.com>
    sctp: check send stream number after wait_for_sndbuf

Gustav Ekelund <gustaek@axis.com>
    net: dsa: mv88e6xxx: Reset mv88e6393x force WD event bit

Jakub Kicinski <kuba@kernel.org>
    net: don't let netpoll invoke NAPI if in xmit context

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Preserve the previous PCM device upon re-enablement

Eric Dumazet <edumazet@google.com>
    icmp: guard against too small mtu

Jeff Layton <jlayton@kernel.org>
    nfsd: call op_release, even when op_func returns an error

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Avoid calling OPDESC() with ops->opnum == OP_ILLEGAL

Hans de Goede <hdegoede@redhat.com>
    wifi: brcmfmac: Fix SDIO suspend/resume regression

Andrea Righi <andrea.righi@canonical.com>
    l2tp: generate correct module alias strings

Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
    net: stmmac: remove redundant fixup to support fixed-link mode

Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
    net: stmmac: check if MAC needs to attach to a PHY

Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
    net: phylink: add phylink_expects_phy() method

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: qrtr: Fix a refcount bug in qrtr_recvmsg()

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mac80211: fix the size calculation of ieee80211_ie_len_eht_cap()

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: pv: fix external interruption loop not always detected

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: lpass: fix the order or clks turn off during suspend

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: meson: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sprd: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: iqs620a: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: cros-ec: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: hibvt: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: Make .get_state() callback return an error code

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: ipc4: Ensure DSP is in D0I0 during sof_ipc4_set_get_data()

Mohammed Gamal <mgamal@redhat.com>
    Drivers: vmbus: Check for channel allocation before looking up relids

Randy Dunlap <rdunlap@infradead.org>
    gpio: GPIO_REGMAP: select REGMAP instead of depending on it

Reiji Watanabe <reijiw@google.com>
    KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

Marc Zyngier <maz@kernel.org>
    KVM: arm64: PMU: Sanitise PMCR_EL0.LP on first vcpu run

Marc Zyngier <maz@kernel.org>
    KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow

Marc Zyngier <maz@kernel.org>
    KVM: arm64: PMU: Align chained counter implementation with architecture pseudocode

Mike Snitzer <snitzer@kernel.org>
    dm: fix improper splitting for abnormal bios

Heinz Mauelshagen <heinzm@redhat.com>
    dm: change "unsigned" to "unsigned int"

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    dm integrity: Remove bi_sector that's only used by commented debug code

Joe Thornber <ejt@redhat.com>
    dm cache: Add some documentation to dm-cache-background-tracker.h


-------------

Diffstat:

 .../devicetree/bindings/serial/renesas,scif.yaml   |   4 +-
 Documentation/mm/zsmalloc.rst                      |   2 +
 Makefile                                           |   4 +-
 arch/arm64/kernel/compat_alignment.c               |  32 +-
 arch/arm64/kvm/pmu-emul.c                          | 352 ++++++-------------
 arch/arm64/kvm/sys_regs.c                          |   6 +-
 arch/s390/kvm/intercept.c                          |  32 +-
 arch/x86/kernel/acpi/boot.c                        |   9 +-
 arch/x86/kvm/vmx/nested.c                          |   7 +-
 arch/x86/kvm/x86.c                                 |  11 +-
 block/blk-mq.c                                     |   4 +-
 block/blk-throttle.c                               |   2 +-
 block/genhd.c                                      |   8 +-
 drivers/acpi/acpi_video.c                          |  15 +-
 drivers/acpi/video_detect.c                        |  58 +++-
 drivers/block/ublk_drv.c                           |  26 +-
 drivers/counter/104-quad-8.c                       |  31 +-
 drivers/cxl/core/pci.c                             |  38 +-
 drivers/cxl/cxlpci.h                               |  14 +
 drivers/gpio/Kconfig                               |   2 +-
 drivers/gpio/gpio-davinci.c                        |   5 +-
 drivers/gpio/gpio-mvebu.c                          |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  18 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   2 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   1 +
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |  14 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  26 +-
 drivers/gpu/drm/i915/display/intel_color.c         |  21 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |  14 +-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |  12 +-
 drivers/gpu/drm/i915/i915_perf.c                   |   6 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   3 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |  34 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |   8 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   1 +
 drivers/hv/connection.c                            |   4 +
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  24 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |  20 +-
 drivers/iio/adc/ad7791.c                           |   2 +-
 drivers/iio/adc/ltc2497.c                          |   6 +-
 drivers/iio/adc/qcom-spmi-adc5.c                   |  10 +-
 drivers/iio/adc/ti-ads7950.c                       |   1 +
 drivers/iio/dac/cio-dac.c                          |   4 +-
 drivers/iio/imu/Kconfig                            |   1 +
 drivers/iio/industrialio-buffer.c                  |  21 +-
 drivers/iio/light/cm32181.c                        |  12 +
 drivers/leds/rgb/leds-qcom-lpg.c                   |  14 +-
 drivers/md/dm-bio-prison-v1.c                      |  10 +-
 drivers/md/dm-bio-prison-v2.c                      |  12 +-
 drivers/md/dm-bio-prison-v2.h                      |  10 +-
 drivers/md/dm-bufio.c                              |  58 ++--
 drivers/md/dm-cache-background-tracker.c           |   8 +-
 drivers/md/dm-cache-background-tracker.h           |  46 ++-
 drivers/md/dm-cache-metadata.c                     |  40 +--
 drivers/md/dm-cache-metadata.h                     |   4 +-
 drivers/md/dm-cache-policy-internal.h              |  10 +-
 drivers/md/dm-cache-policy-smq.c                   | 163 ++++-----
 drivers/md/dm-cache-policy.c                       |   2 +-
 drivers/md/dm-cache-policy.h                       |   4 +-
 drivers/md/dm-cache-target.c                       |  50 +--
 drivers/md/dm-core.h                               |   6 +-
 drivers/md/dm-crypt.c                              |  48 +--
 drivers/md/dm-delay.c                              |   6 +-
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-era-target.c                         |  32 +-
 drivers/md/dm-exception-store.c                    |   6 +-
 drivers/md/dm-exception-store.h                    |  18 +-
 drivers/md/dm-flakey.c                             |  22 +-
 drivers/md/dm-integrity.c                          | 328 +++++++++---------
 drivers/md/dm-io-rewind.c                          |   4 +-
 drivers/md/dm-io.c                                 |  32 +-
 drivers/md/dm-ioctl.c                              |  18 +-
 drivers/md/dm-kcopyd.c                             |  30 +-
 drivers/md/dm-linear.c                             |   2 +-
 drivers/md/dm-log-userspace-base.c                 |   6 +-
 drivers/md/dm-log-userspace-transfer.c             |   2 +-
 drivers/md/dm-log-writes.c                         |  10 +-
 drivers/md/dm-log.c                                |  10 +-
 drivers/md/dm-mpath.c                              |  46 +--
 drivers/md/dm-mpath.h                              |   2 +-
 drivers/md/dm-path-selector.h                      |   2 +-
 drivers/md/dm-ps-io-affinity.c                     |   4 +-
 drivers/md/dm-ps-queue-length.c                    |  10 +-
 drivers/md/dm-ps-round-robin.c                     |   6 +-
 drivers/md/dm-ps-service-time.c                    |  14 +-
 drivers/md/dm-raid.c                               |   2 +-
 drivers/md/dm-raid1.c                              |  22 +-
 drivers/md/dm-region-hash.c                        |  22 +-
 drivers/md/dm-rq.c                                 |  16 +-
 drivers/md/dm-rq.h                                 |   2 +-
 drivers/md/dm-snap-persistent.c                    |   8 +-
 drivers/md/dm-snap-transient.c                     |   6 +-
 drivers/md/dm-snap.c                               |  34 +-
 drivers/md/dm-stats.c                              |  74 ++--
 drivers/md/dm-stats.h                              |   6 +-
 drivers/md/dm-stripe.c                             |  10 +-
 drivers/md/dm-switch.c                             |  46 +--
 drivers/md/dm-table.c                              |  25 +-
 drivers/md/dm-thin-metadata.c                      |  24 +-
 drivers/md/dm-thin.c                               |  46 +--
 drivers/md/dm-uevent.c                             |   4 +-
 drivers/md/dm-uevent.h                             |   4 +-
 drivers/md/dm-verity-fec.c                         |  30 +-
 drivers/md/dm-verity-fec.h                         |  18 +-
 drivers/md/dm-verity-target.c                      |  30 +-
 drivers/md/dm-verity.h                             |   8 +-
 drivers/md/dm-writecache.c                         |  80 ++---
 drivers/md/dm.c                                    |  55 ++-
 drivers/md/dm.h                                    |   4 +-
 drivers/md/persistent-data/dm-array.c              |  69 ++--
 drivers/md/persistent-data/dm-array.h              |   2 +-
 drivers/md/persistent-data/dm-bitset.c             |  12 +-
 drivers/md/persistent-data/dm-block-manager.c      |  16 +-
 drivers/md/persistent-data/dm-block-manager.h      |   6 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  46 +--
 drivers/md/persistent-data/dm-btree-spine.c        |   4 +-
 drivers/md/persistent-data/dm-btree.c              |  98 +++---
 drivers/md/persistent-data/dm-btree.h              |  12 +-
 .../persistent-data/dm-persistent-data-internal.h  |   6 +-
 drivers/md/persistent-data/dm-space-map-common.c   |  28 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |  20 +-
 .../md/persistent-data/dm-transaction-manager.c    |  16 +-
 .../md/persistent-data/dm-transaction-manager.h    |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/dsa/mv88e6xxx/global2.c                |  20 ++
 drivers/net/dsa/mv88e6xxx/global2.h                |   1 +
 drivers/net/ethernet/google/gve/gve.h              |   2 +
 drivers/net/ethernet/google/gve/gve_tx.c           |  12 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |  23 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  21 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   6 +-
 drivers/net/phy/phylink.c                          |  19 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  36 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   2 +
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  70 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  15 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  18 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  13 +-
 drivers/nvme/host/core.c                           |   6 +-
 drivers/pci/doe.c                                  |  30 +-
 drivers/platform/x86/think-lmi.c                   |  20 +-
 drivers/pwm/pwm-atmel.c                            |   6 +-
 drivers/pwm/pwm-bcm-iproc.c                        |   8 +-
 drivers/pwm/pwm-crc.c                              |  10 +-
 drivers/pwm/pwm-cros-ec.c                          |   9 +-
 drivers/pwm/pwm-dwc.c                              |   6 +-
 drivers/pwm/pwm-hibvt.c                            |   7 +-
 drivers/pwm/pwm-imx-tpm.c                          |   8 +-
 drivers/pwm/pwm-imx27.c                            |   8 +-
 drivers/pwm/pwm-intel-lgm.c                        |   6 +-
 drivers/pwm/pwm-iqs620a.c                          |   7 +-
 drivers/pwm/pwm-keembay.c                          |   6 +-
 drivers/pwm/pwm-lpss.c                             |   6 +-
 drivers/pwm/pwm-meson.c                            |  16 +-
 drivers/pwm/pwm-mtk-disp.c                         |  12 +-
 drivers/pwm/pwm-pca9685.c                          |   8 +-
 drivers/pwm/pwm-raspberrypi-poe.c                  |   8 +-
 drivers/pwm/pwm-rockchip.c                         |  12 +-
 drivers/pwm/pwm-sifive.c                           |   6 +-
 drivers/pwm/pwm-sl28cpld.c                         |   8 +-
 drivers/pwm/pwm-sprd.c                             |   9 +-
 drivers/pwm/pwm-stm32-lp.c                         |   8 +-
 drivers/pwm/pwm-sun4i.c                            |  12 +-
 drivers/pwm/pwm-sunplus.c                          |   6 +-
 drivers/pwm/pwm-visconti.c                         |   6 +-
 drivers/pwm/pwm-xilinx.c                           |   8 +-
 drivers/scsi/iscsi_tcp.c                           |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   1 +
 drivers/tty/serial/8250/8250_port.c                |  11 +
 drivers/tty/serial/fsl_lpuart.c                    |   8 +-
 drivers/tty/serial/sh-sci.c                        |  10 +-
 drivers/usb/cdns3/cdnsp-ep0.c                      |   3 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/host/xhci-tegra.c                      |   6 +-
 drivers/usb/host/xhci.c                            |   7 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/option.c                        |  10 +
 drivers/usb/typec/altmodes/displayport.c           |   6 +-
 fs/cifs/fs_context.c                               |  13 +-
 fs/cifs/fs_context.h                               |   3 +
 fs/cifs/misc.c                                     |   2 +-
 fs/ksmbd/connection.c                              |   5 +-
 fs/ksmbd/server.c                                  |   5 +-
 fs/ksmbd/smb2pdu.c                                 |   3 -
 fs/ksmbd/smb_common.c                              | 138 ++++++--
 fs/ksmbd/smb_common.h                              |   2 +-
 fs/namespace.c                                     |   2 +-
 fs/nfsd/blocklayout.c                              |   1 +
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/nfsd/nfs4xdr.c                                  |  15 +-
 fs/nilfs2/segment.c                                |   3 +-
 fs/nilfs2/super.c                                  |   2 +
 fs/nilfs2/the_nilfs.c                              |  12 +-
 include/acpi/video.h                               |  15 +-
 include/drm/display/drm_dp_mst_helper.h            |   3 +-
 include/kvm/arm_pmu.h                              |   2 -
 include/linux/device-mapper.h                      |  38 +-
 include/linux/dm-bufio.h                           |  12 +-
 include/linux/dm-dirty-log.h                       |   6 +-
 include/linux/dm-io.h                              |   8 +-
 include/linux/dm-kcopyd.h                          |  22 +-
 include/linux/dm-region-hash.h                     |   2 +-
 include/linux/ftrace.h                             |   2 +-
 include/linux/mm_types.h                           |   3 +-
 include/linux/pci-doe.h                            |   8 +-
 include/linux/phylink.h                            |   1 +
 include/linux/pwm.h                                |   4 +-
 include/net/raw.h                                  |  15 +-
 io_uring/io_uring.c                                |   2 +-
 io_uring/kbuf.c                                    |   7 +-
 kernel/events/core.c                               |   2 +-
 kernel/fork.c                                      |   3 +
 kernel/trace/ftrace.c                              |  15 +-
 kernel/trace/ring_buffer.c                         |  13 +-
 kernel/trace/trace.c                               |   1 +
 kernel/trace/trace_events_synth.c                  |  19 +-
 kernel/trace/trace_osnoise.c                       |   4 +-
 lib/maple_tree.c                                   | 383 +++++++++++++--------
 mm/hugetlb.c                                       |  14 +-
 mm/kfence/core.c                                   |  32 +-
 mm/memory.c                                        |  16 +-
 mm/mmap.c                                          |   3 +-
 mm/swapfile.c                                      |   3 +-
 mm/vmalloc.c                                       |   8 +-
 net/can/isotp.c                                    |  74 ++--
 net/can/j1939/transport.c                          |   5 +-
 net/core/netpoll.c                                 |  19 +-
 net/ethtool/linkmodes.c                            |   7 +-
 net/ipv4/icmp.c                                    |   5 +
 net/ipv4/ping.c                                    |   8 +-
 net/ipv4/raw.c                                     |  49 +--
 net/ipv4/raw_diag.c                                |  10 +-
 net/ipv6/ip6_output.c                              |   7 +-
 net/ipv6/raw.c                                     |  14 +-
 net/l2tp/l2tp_ip.c                                 |   8 +-
 net/l2tp/l2tp_ip6.c                                |   8 +-
 net/mac80211/sta_info.c                            |   3 +-
 net/mac80211/util.c                                |   2 +-
 net/netlink/af_netlink.c                           |  15 +-
 net/qrtr/af_qrtr.c                                 |   2 +
 net/qrtr/ns.c                                      |  15 +-
 net/sctp/socket.c                                  |   4 +
 net/sunrpc/svcauth_unix.c                          |  17 +-
 sound/pci/hda/patch_hdmi.c                         |  11 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/codecs/hdac_hdmi.c                       |  17 +-
 sound/soc/codecs/lpass-rx-macro.c                  |   4 +-
 sound/soc/codecs/lpass-tx-macro.c                  |   4 +-
 sound/soc/codecs/lpass-wsa-macro.c                 |   4 +-
 sound/soc/sof/ipc4.c                               |   8 +
 tools/testing/radix-tree/maple.c                   |  18 +-
 256 files changed, 2733 insertions(+), 2053 deletions(-)


