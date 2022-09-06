Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA4E5AEC48
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbiIFOC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240180AbiIFOAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770B683F15;
        Tue,  6 Sep 2022 06:44:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 735A861549;
        Tue,  6 Sep 2022 13:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28433C433C1;
        Tue,  6 Sep 2022 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471790;
        bh=iIRou6xcC4lTxkOWIS9pNWlQly+nIsq/9puwlL6fDJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ztHHyIf6wK/wDNbLY4UMflOmkwJmRwvEbCJ80BqjdD3p7A9Zmt0lmc7c++jpbuP15
         TPgS89OvQlm2ZuGCAFvmpitCbn9GaXPu3Uj//2Hx63m9mbrK1ObFh/0dBWZ2Lx6yp8
         ceNUB1ht2uFH9QrWGCA972VCtBPemBAHgqSABUyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.19 000/155] 5.19.8-rc1 review
Date:   Tue,  6 Sep 2022 15:29:08 +0200
Message-Id: <20220906132829.417117002@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.8-rc1
X-KernelTest-Deadline: 2022-09-08T13:28+00:00
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

This is the start of the stable review cycle for the 5.19.8 release.
There are 155 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.8-rc1

Fedor Pchelkin <pchelkin@ispras.ru>
    tty: n_gsm: avoid call of sleeping functions from atomic context

Fedor Pchelkin <pchelkin@ispras.ru>
    tty: n_gsm: replace kicktimer with delayed_work

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tty: n_gsm: initialize more members at gsm_alloc_mux()

Mazin Al Haddad <mazinalhaddad05@gmail.com>
    tty: n_gsm: add sanity check for gsm->receive in gsm_receive_buf()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Skip wm/ddb readout for disabled pipes

Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
    drm/i915/glk: ECS Liva Q2 needs GLK HDMI port timing quirk

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915/guc: clear stalled request after a reset

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/backlight: Disable pps power hook for aux based backlight

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix data-race at module auto-loading

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix data-race for max_midi_devs access

Kacper Michajłow <kasper93@gmail.com>
    ALSA: hda/realtek: Add speaker AMP init for Samsung laptops with ALC298

Takashi Iwai <tiwai@suse.de>
    ALSA: memalloc: Revive x86-specific WC page allocations again

Miquel Raynal <miquel.raynal@bootlin.com>
    net: mac802154: Fix a condition in the receive path

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: Use u64_stats_fetch_begin_irq() for stats fetch.

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip: fix triggering of 'icmp redirect'

Siddh Raman Pant <code@siddh.me>
    wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Siddh Raman Pant <code@siddh.me>
    wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected

Isaac J. Manjarres <isaacmanjarres@google.com>
    driver core: Don't probe devices after bus_type.match() probe deferral

Levi Yun <ppbuk5246@gmail.com>
    arm64/kexec: Fix missing extra range for crashkres_low.

Christian König <ckoenig.leichtzumerken@gmail.com>
    dma-buf/dma-resv: check if the new fence is really later

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: Fix obscure lockdep violation for udc_mutex

Krishna Kurapati <quic_kriskura@quicinc.com>
    usb: gadget: mass_storage: Fix cdrom data transfers on MAC-OS

Jing Leng <jleng@ambarella.com>
    usb: gadget: f_uac2: fix superspeed transfer

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix bandwidth release issue

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: relax TT periodic bandwidth allocation

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Prevent nested device-reset calls

Josh Poimboeuf <jpoimboe@kernel.org>
    s390: fix nospec table alignments

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages

Witold Lipieta <witold.lipieta@thaumatec.com>
    usb-storage: Add ignore-residue quirk for NXP PN7462AU

Thierry GUIBERT <thierry.guibert@croix-rouge.fr>
    USB: cdc-acm: Add Icom PMR F3400 support (0c26:0020)

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC transfer

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: fix issue with rearming ISO OUT endpoint

Heiner Kallweit <hkallweit1@gmail.com>
    usb: dwc2: fix wrong order of phy_power_on and phy_init

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Return ENOTSUPP for power supply prop writes

Utkarsh Patel <utkarsh.h.patel@intel.com>
    usb: typec: intel_pmc_mux: Add new ACPI ID for Meteor Lake IOM device

Pablo Sun <pablo.sun@mediatek.com>
    usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles

Takashi Iwai <tiwai@suse.de>
    Revert "usb: typec: ucsi: add a common function ucsi_unregister_connectors()"

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Cinterion MV32-WA/WB RmNet mode

Yonglin Tan <yonglin.tan@outlook.com>
    USB: serial: option: add Quectel EM060K modem

Yan Xinyu <sdlyyxy@bupt.edu.cn>
    USB: serial: option: add support for OPPO R11 diag port

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add Decagon UCA device id

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: fix disabled rx timer on older devices

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: fix lost character on LCR updates

Johan Hovold <johan+linaro@kernel.org>
    usb: dwc3: fix PHY disable sequence

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop

Johan Hovold <johan+linaro@kernel.org>
    usb: dwc3: disable USB core PHY management

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add grace period after xHC start to prevent premature runtime suspend.

Alan Stern <stern@rowland.harvard.edu>
    media: mceusb: Use new usb_control_msg_*() routines

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: Add support for Intel Raptor Lake

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Check router generation before connecting xHCI

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use the actual buffer in tb_async_error()

SeongJae Park <sj@kernel.org>
    xen-blkfront: Cache feature_persistent value before advertisement

SeongJae Park <sj@kernel.org>
    xen-blkfront: Advertise feature-persistent as user requested

SeongJae Park <sj@kernel.org>
    xen-blkback: Advertise feature-persistent as user requested

Steven Price <steven.price@arm.com>
    mm: pagewalk: Fix race between unmap and page walker

Dan Carpenter <dan.carpenter@oracle.com>
    xen/grants: prevent integer overflow in gnttab_dma_alloc_pages()

Nathan Chancellor <nathan@kernel.org>
    powerpc/papr_scm: Ensure rc is always initialized in papr_scm_pmu_register()

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES

Sander Vanheule <sander@svanheule.net>
    gpio: realtek-otto: switch to 32-bit I/O

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: Add mutex_lock for regcache sync in PM

Armin Wolf <W_Armin@gmx.de>
    hwmon: (gpio-fan) Fix array out of bounds access

Stefan Wahren <stefan.wahren@i2se.com>
    clk: bcm: rpi: Add missing newline

Stefan Wahren <stefan.wahren@i2se.com>
    clk: bcm: rpi: Prevent out-of-bounds access

Stefan Wahren <stefan.wahren@i2se.com>
    clk: bcm: rpi: Fix error handling of raspberrypi_fw_get_rate

Kajol Jain <kjain@linux.ibm.com>
    powerpc/papr_scm: Fix nvdimm event mappings

Peter Robinson <pbrobinson@gmail.com>
    Input: rk805-pwrkey - fix module autoloading

Chen-Yu Tsai <wenst@chromium.org>
    clk: core: Fix runtime PM sequence in clk_core_unprepare()

Stephen Boyd <sboyd@kernel.org>
    Revert "clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops"

Chen-Yu Tsai <wenst@chromium.org>
    clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops

Colin Ian King <colin.king@intel.com>
    drm/i915/reg: Fix spelling mistake "Unsupport" -> "Unsupported"

Tony Lindgren <tony@atomide.com>
    clk: ti: Fix missing of_node_get() ti_find_clock_provider()

Conor Dooley <conor.dooley@microchip.com>
    riscv: kvm: move extern sbi_ext declarations to a header

Jim Mattson <jmattson@google.com>
    KVM: VMX: Heed the 'msr' argument in msr_write_intercepted()

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: fix small mempool leak in SMB2_negotiate()

Carlos Llamas <cmllamas@google.com>
    binder: fix alloc->vma_vm_mm null-ptr dereference

Carlos Llamas <cmllamas@google.com>
    binder: fix UAF of ref->proc caused by race condition

Adrian Hunter <adrian.hunter@intel.com>
    mmc: core: Fix inconsistent sd3_bus_mode at UHS-I SD voltage switch failure

Adrian Hunter <adrian.hunter@intel.com>
    mmc: core: Fix UHS-I SD 1.8V workaround branch

Mickaël Salaün <mic@digikod.net>
    landlock: Fix file reparenting without explicit LANDLOCK_ACCESS_FS_REFER

Niek Nooijens <niek.nooijens@omron.com>
    USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id

Russ Weight <russell.h.weight@intel.com>
    firmware_loader: Fix memory leak in firmware upload

Russ Weight <russell.h.weight@intel.com>
    firmware_loader: Fix use-after-free during unregister

Johan Hovold <johan+linaro@kernel.org>
    misc: fastrpc: fix memory corruption on open

Johan Hovold <johan+linaro@kernel.org>
    misc: fastrpc: fix memory corruption on probe

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: adc: mcp3911: use correct formula for AD conversion

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: adc: mcp3911: correct "microchip,device-addr" property

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: ad7292: Prevent regulator double disable

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: light: cm3605: Fix an error handling path in cm3605_probe()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Input: iforce - wake up after clearing IFORCE_XMIT_RUNNING flag

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: lpuart: disable flow control while waiting for the transmit engine to complete

Arnd Bergmann <arnd@arndb.de>
    musb: fix USB_MUSB_TUSB6010 dependency

Helge Deller <deller@gmx.de>
    vt: Clear selection before changing the font

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/rtas: Fix RTAS MSR[HV] handling for Cell

Masahiro Yamada <masahiroy@kernel.org>
    powerpc: align syscall table for ppc32

Michael Ellerman <mpe@ellerman.id.au>
    Revert "powerpc: Remove unused FW_FEATURE_NATIVE references"

Grzegorz Szymaszek <gszymaszek@short.pl>
    staging: r8188eu: add firmware dependency

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8188eu: Add Rosewill USB-N150 Nano to device tables

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8712: fix use after free bugs

Sergiu Moga <sergiu.moga@microchip.com>
    tty: serial: atmel: Preserve previous USART mode if RS485 disabled

Shenwei Wang <shenwei.wang@nxp.com>
    serial: fsl_lpuart: RS485 RTS polariy is inverse

Vadim Pasternak <vadimp@nvidia.com>
    platform/mellanox: mlxreg-lc: Fix locking issue

Vadim Pasternak <vadimp@nvidia.com>
    platform/mellanox: mlxreg-lc: Fix coverity warning

Waiman Long <longman@redhat.com>
    mm/slab_common: Deleting kobject in kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: qcom: fix device status array range

Yacan Liu <liuyacan@corp.netease.com>
    net/smc: Remove redundant refcount increase

Jakub Kicinski <kuba@kernel.org>
    Revert "sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb"

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-race around challenge_timestamp

Toke Høiland-Jørgensen <toke@toke.dk>
    sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb

Cong Wang <cong.wang@bytedance.com>
    kcm: fix strp_init() order and cleanup

David Thompson <davthompson@nvidia.com>
    mlxbf_gige: compute MDIO period based on i1clk

Xin Yin <yinxin.x@bytedance.com>
    cachefiles: make on-demand request distribution fairer

Sun Ke <sunke32@huawei.com>
    cachefiles: fix error return code in cachefiles_ondemand_copen()

Duoming Zhou <duoming@zju.edu.cn>
    ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler

Dan Carpenter <dan.carpenter@oracle.com>
    net: lan966x: improve error handle in lan966x_fdma_rx_get_frame()

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: micrel: Make the GPIO to be non-exclusive

Wang Hai <wanghai38@huawei.com>
    net/sched: fix netdevice reference leaks in attach_default_qdiscs()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: sched: tbf: don't call qdisc_put() while holding tree lock

Łukasz Bartosik <lb@semihalf.com>
    drm/i915: fix null pointer dereference

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: dsa: xrs700x: Use irqsave variant for u64 stats update

Tianyu Yuan <tianyu.yuan@corigine.com>
    nfp: flower: fix ingress police using matchall filter

Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
    openvswitch: fix memory leak at failed datapath creation

Florian Fainelli <f.fainelli@gmail.com>
    net: smsc911x: Stop and start PHY during suspend and resume

Casper Andersson <casper.casan@gmail.com>
    net: sparx5: fix handling uneven length packets in manual extraction

Zhengping Jiang <jiangzp@google.com>
    Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: hci_event: Fix checking conn for le_conn_complete_evt

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix suspend performance regression

Hans de Goede <hdegoede@redhat.com>
    Bluetooth: hci_event: Fix vendor (unknown) opcode status handling

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Do mark_chain_precision for ARG_CONST_ALLOC_SIZE_OR_ZERO

Joanne Koong <joannelkoong@gmail.com>
    bpf: Tidy up verifier check_func_arg()

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Allow helpers to accept pointers with a fixed size

Mathias Nyman <mathias.nyman@linux.intel.com>
    Revert "xhci: turn off port power in shutdown"

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix null pointer dereference in remove if xHC has only one roothub

Dan Carpenter <dan.carpenter@oracle.com>
    wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda: intel-nhlt: Correct the handling of fmt_config flexible array

Arun R Murthy <arun.r.murthy@intel.com>
    drm/i915/display: avoid warnings when registering dual panel backlight

Matthew Auld <matthew.auld@intel.com>
    drm/i915/ttm: fix CCS handling

Kuniyuki Iwashima <kuniyu@amazon.com>
    bpf: Fix a data-race around bpf_jit_limit.

Lin Ma <linma@zju.edu.cn>
    ieee802154/adf7242: defer destroy_workqueue call

Alex Williamson <alex.williamson@redhat.com>
    drm/i915/gvt: Fix Comet Lake

Pu Lehui <pulehui@huawei.com>
    bpf, cgroup: Fix kernel BUG in purge_effective_progs

Eyal Birger <eyal.birger@gmail.com>
    ip_tunnel: Respect tunnel key's "flow_flags" in IP tunnels

YiFei Zhu <zhuyifei@google.com>
    bpf: Restrict bpf_sys_bpf to CAP_PERFMON

Liu Jian <liujian56@huawei.com>
    skmsg: Fix wrong last sg check in sk_msg_recvmsg()

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: adc: mcp3911: make use of the sign bit

Lv Ruyi <lv.ruyi@zte.com.cn>
    peci: aspeed: fix error check return value of platform_get_irq()

Bjorn Andersson <bjorn.andersson@linaro.org>
    drm/msm/gpu: Drop qos request if devm_devfreq_add_device() fails

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Fix corrupted packets for XDP_SHARED_UMEM

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Fix broken touchscreen on Chuwi Hi8 with Windows BIOS

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask

Douglas Anderson <dianders@chromium.org>
    drm/msm/dsi: Fix number of regulators for SDM660

Douglas Anderson <dianders@chromium.org>
    drm/msm/dsi: Fix number of regulators for msm8996_dsi_cfg

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: delete DP_RECOVERED_CLOCK_OUT_EN to fix tps4

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/msm/dpu: populate wb or intf before reset_intf_cfg

sunliming <sunliming@kylinos.cn>
    drm/msm/dsi: fix the inconsistent indenting

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: make eDP panel as the first connected connector


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/kernel/machine_kexec_file.c             |   2 +-
 arch/powerpc/include/asm/firmware.h                |   8 +
 arch/powerpc/kernel/rtas_entry.S                   |   4 +
 arch/powerpc/kernel/systbl.S                       |   1 +
 arch/powerpc/platforms/pseries/papr_scm.c          |  90 ++++-------
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |  12 ++
 arch/riscv/kvm/vcpu_sbi.c                          |  12 +-
 arch/riscv/mm/pageattr.c                           |   4 +-
 arch/s390/include/asm/hugetlb.h                    |   6 +-
 arch/s390/kernel/vmlinux.lds.S                     |   1 +
 arch/x86/kvm/vmx/vmx.c                             |   3 +-
 arch/x86/kvm/x86.c                                 |  25 +++-
 drivers/android/binder.c                           |  12 ++
 drivers/android/binder_alloc.c                     |   4 +-
 drivers/base/dd.c                                  |  10 ++
 drivers/base/firmware_loader/sysfs.c               |   7 +-
 drivers/base/firmware_loader/sysfs.h               |   5 +
 drivers/base/firmware_loader/sysfs_upload.c        |  12 +-
 drivers/block/xen-blkback/common.h                 |   3 +
 drivers/block/xen-blkback/xenbus.c                 |   6 +-
 drivers/block/xen-blkfront.c                       |  20 ++-
 drivers/clk/bcm/clk-raspberrypi.c                  |  15 +-
 drivers/clk/clk.c                                  |   3 +-
 drivers/clk/ti/clk.c                               |   1 +
 drivers/dma-buf/dma-resv.c                         |   3 +-
 drivers/gpio/gpio-pca953x.c                        |   8 +-
 drivers/gpio/gpio-realtek-otto.c                   | 166 +++++++++++----------
 drivers/gpu/drm/i915/display/intel_backlight.c     |  37 ++---
 drivers/gpu/drm/i915/display/intel_bw.c            |  16 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   2 -
 drivers/gpu/drm/i915/display/intel_quirks.c        |   3 +
 drivers/gpu/drm/i915/gt/intel_migrate.c            |  44 +++---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |   7 +
 drivers/gpu/drm/i915/gvt/handlers.c                |   2 +-
 drivers/gpu/drm/i915/intel_gvt_mmio_table.c        |   3 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   8 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   6 +
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                  |   4 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |   2 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   2 +
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |   2 +
 drivers/hwmon/gpio-fan.c                           |   3 +
 drivers/iio/adc/ad7292.c                           |   4 +-
 drivers/iio/adc/mcp3911.c                          |  28 +++-
 drivers/iio/light/cm3605.c                         |   6 +-
 drivers/input/joystick/iforce/iforce-serio.c       |   6 +-
 drivers/input/joystick/iforce/iforce-usb.c         |   8 +-
 drivers/input/joystick/iforce/iforce.h             |   6 +
 drivers/input/misc/rk805-pwrkey.c                  |   1 +
 drivers/media/rc/mceusb.c                          |  35 ++---
 drivers/misc/fastrpc.c                             |  12 +-
 drivers/mmc/core/sd.c                              |  46 +++---
 drivers/net/dsa/xrs700x/xrs700x.c                  |   5 +-
 drivers/net/ethernet/cortina/gemini.c              |  24 +--
 drivers/net/ethernet/fungible/funeth/funeth_txrx.h |   4 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |  16 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  12 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |   4 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |   4 +-
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |   4 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c | 122 ++++++++++++---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   3 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |   5 +-
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |   2 +
 .../net/ethernet/netronome/nfp/flower/qos_conf.c   |   5 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   8 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   8 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |   2 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   6 +
 drivers/net/ieee802154/adf7242.c                   |   3 +-
 drivers/net/netdevsim/netdev.c                     |   4 +-
 drivers/net/phy/micrel.c                           |   8 +-
 drivers/peci/controller/peci-aspeed.c              |   2 +-
 drivers/platform/mellanox/mlxreg-lc.c              |  38 +++--
 drivers/platform/x86/pmc_atom.c                    |   2 +-
 drivers/platform/x86/x86-android-tablets.c         |  14 ++
 drivers/soundwire/qcom.c                           |   6 +-
 drivers/staging/r8188eu/os_dep/os_intfs.c          |   1 +
 drivers/staging/r8188eu/os_dep/usb_intf.c          |   1 +
 drivers/staging/rtl8712/rtl8712_cmd.c              |  36 -----
 drivers/thunderbolt/ctl.c                          |   2 +-
 drivers/thunderbolt/switch.c                       |   6 +-
 drivers/tty/n_gsm.c                                |  85 +++++------
 drivers/tty/serial/atmel_serial.c                  |   4 +-
 drivers/tty/serial/fsl_lpuart.c                    |   5 +-
 drivers/tty/vt/vt.c                                |  12 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |   4 +-
 drivers/usb/class/cdc-acm.c                        |   3 +
 drivers/usb/core/hub.c                             |  10 ++
 drivers/usb/dwc2/platform.c                        |   8 +-
 drivers/usb/dwc3/core.c                            |  19 +--
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/dwc3/gadget.c                          |   8 +-
 drivers/usb/dwc3/host.c                            |  10 ++
 drivers/usb/gadget/function/f_uac2.c               |  16 +-
 drivers/usb/gadget/function/storage_common.c       |   6 +-
 drivers/usb/gadget/udc/core.c                      |  26 ++--
 drivers/usb/host/xhci-hub.c                        |  13 +-
 drivers/usb/host/xhci-mtk-sch.c                    |  15 +-
 drivers/usb/host/xhci-plat.c                       |  11 +-
 drivers/usb/host/xhci.c                            |  19 +--
 drivers/usb/host/xhci.h                            |   4 +-
 drivers/usb/musb/Kconfig                           |   2 +-
 drivers/usb/serial/ch341.c                         |  16 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   6 +
 drivers/usb/serial/option.c                        |  15 ++
 drivers/usb/storage/unusual_devs.h                 |   7 +
 drivers/usb/typec/altmodes/displayport.c           |   4 +-
 drivers/usb/typec/mux/intel_pmc_mux.c              |   9 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   7 +
 drivers/usb/typec/ucsi/ucsi.c                      |  53 +++----
 drivers/xen/grant-table.c                          |   3 +
 fs/cachefiles/internal.h                           |   1 +
 fs/cachefiles/ondemand.c                           |  22 ++-
 fs/cifs/smb2pdu.c                                  |  12 +-
 include/linux/bpf.h                                |  13 ++
 include/linux/platform_data/x86/pmc_atom.h         |   6 +-
 include/linux/usb.h                                |   2 +
 include/linux/usb/typec_dp.h                       |   5 +
 include/net/ip_tunnels.h                           |   4 +-
 kernel/bpf/cgroup.c                                |   4 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/syscall.c                               |   2 +-
 kernel/bpf/verifier.c                              | 112 +++++++++-----
 mm/pagewalk.c                                      |  21 +--
 mm/ptdump.c                                        |   4 +-
 mm/slab_common.c                                   |  45 ++++--
 net/bluetooth/hci_event.c                          |  13 +-
 net/bluetooth/hci_sync.c                           |  30 ++--
 net/core/skmsg.c                                   |   4 +-
 net/ipv4/fib_frontend.c                            |   4 +-
 net/ipv4/ip_gre.c                                  |   2 +-
 net/ipv4/ip_tunnel.c                               |   7 +-
 net/ipv4/tcp_input.c                               |   4 +-
 net/kcm/kcmsock.c                                  |  15 +-
 net/mac80211/ibss.c                                |   4 +
 net/mac80211/scan.c                                |  11 +-
 net/mac80211/sta_info.c                            |   8 +-
 net/mac802154/rx.c                                 |   2 +-
 net/mpls/af_mpls.c                                 |   4 +-
 net/openvswitch/datapath.c                         |   4 +-
 net/sched/sch_generic.c                            |  31 ++--
 net/sched/sch_tbf.c                                |   4 +-
 net/smc/af_smc.c                                   |   1 -
 net/wireless/debugfs.c                             |   3 +-
 net/xdp/xsk_buff_pool.c                            |  16 +-
 security/landlock/fs.c                             |  48 +++---
 sound/core/memalloc.c                              |  87 +++++++++--
 sound/core/seq/oss/seq_oss_midi.c                  |   2 +
 sound/core/seq/seq_clientmgr.c                     |  12 +-
 sound/hda/intel-nhlt.c                             |   8 +-
 sound/pci/hda/patch_realtek.c                      |  63 +++++++-
 tools/testing/selftests/landlock/fs_test.c         | 155 +++++++++++++++++--
 158 files changed, 1492 insertions(+), 813 deletions(-)


