Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54A14726EA
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbhLMJz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:55:58 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:43988 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbhLMJxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:53:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13F76CE0E83;
        Mon, 13 Dec 2021 09:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8EEC34607;
        Mon, 13 Dec 2021 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389231;
        bh=deZSjk36pXZ3kmOmpIILqx1w3+2NYOFfURuBVIhWkpc=;
        h=From:To:Cc:Subject:Date:From;
        b=eFVbdqbKBlNn4jRer37QwaRdY3Pro251aKzHGeIk0eG8ELafU/Q1raHXKFQb7NWnh
         OxmXPG73AaNmLqGXrFJqLlsVpHcgZ94U3UnWYkAJs8pHMa5eeGpWN/kSwWZBQjHGC5
         64lbj+JPmIn2OcFneFjCWWxVODnebsF94q62GdTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 000/171] 5.15.8-rc1 review
Date:   Mon, 13 Dec 2021 10:28:35 +0100
Message-Id: <20211213092945.091487407@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.8-rc1
X-KernelTest-Deadline: 2021-12-15T09:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.8 release.
There are 171 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.8-rc1

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Add selftests to cover packet access corner cases

Alexey Sheplyakov <asheplyakov@basealt.ru>
    clocksource/drivers/dw_apb_timer_of: Fix probe failure

Jeya R <jeyr@codeaurora.org>
    misc: fastrpc: fix improper packet size calculation

Vladimir Murzin <vladimir.murzin@arm.com>
    irqchip: nvic: Fix offset for Interrupt Priority Offsets

Wudi Wang <wangwudi@hisilicon.com>
    irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL

Xie Yongji <xieyongji@bytedance.com>
    aio: Fix incorrect usage of eventfd_signal_allowed()

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Fix support for Multi-MSI interrupts

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Fix return value of armada_370_xp_msi_alloc()

Billy Tsai <billy_tsai@aspeedtech.com>
    irqchip/aspeed-scu: Replace update_bits with write_bits.

Kelly Devilliv <kelly.devilliv@gmail.com>
    csky: fix typo of fpu config macro

Loic Poulain <loic.poulain@linaro.org>
    bus: mhi: core: Add support for forced PM resume

Slark Xiao <slark_xiao@163.com>
    bus: mhi: pci_generic: Fix device recovery failed issue

Ralph Siemsen <ralph.siemsen@linaro.org>
    nvmem: eeprom: at25: fix FRAM byte_len

Kai-Heng Feng <kai.heng.feng@canonical.com>
    misc: rtsx: Avoid mangling IRQ during runtime PM

Yang Yingliang <yangyingliang@huawei.com>
    iio: accel: kxcjk-1013: Fix possible memory leak in probe and remove

Lars-Peter Clausen <lars@metafoo.de>
    iio: ad7768-1: Call iio_trigger_notify_done() on error

Evgeny Boger <boger@wirenboard.com>
    iio: adc: axp20x_adc: fix charging current reporting on AXP22x

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    iio: adc: stm32: fix a current leak by resetting pcsel before disabling vdda

Gwendal Grignou <gwendal@chromium.org>
    iio: at91-sama5d2: Fix incorrect sign extension

Lars-Peter Clausen <lars@metafoo.de>
    iio: dln2: Check return value of devm_iio_trigger_register()

Noralf Trønnes <noralf@tronnes.org>
    iio: dln2-adc: Fix lockdep complaint

Lars-Peter Clausen <lars@metafoo.de>
    iio: itg3200: Call iio_trigger_notify_done() on error

Lars-Peter Clausen <lars@metafoo.de>
    iio: kxsd9: Don't return error code in trigger handler

Lars-Peter Clausen <lars@metafoo.de>
    iio: ltr501: Don't return error code in trigger handler

Lars-Peter Clausen <lars@metafoo.de>
    iio: mma8452: Fix trigger reference couting

Lars-Peter Clausen <lars@metafoo.de>
    iio: stk3310: Don't return error code in interrupt handler

Alyssa Ross <hi@alyssa.is>
    iio: trigger: stm32-timer: fix MODULE_ALIAS

Lars-Peter Clausen <lars@metafoo.de>
    iio: trigger: Fix reference counting

Kister Genesis Jimenez <kister.jimenez@analog.com>
    iio: gyro: adxrs290: fix data signedness

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: avoid race between disable slot command and host runtime suspend

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: core: config: using bit mask instead of individual bits

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime suspending

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: core: config: fix validation of wMaxPacketValue entries

Douglas Anderson <dianders@chromium.org>
    Revert "usb: dwc3: dwc3-qcom: Enable tx-fifo-resize property by default"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: zero allocate endpoint 0 buffers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: detect too-big endpoint 0 requests

Peilin Ye <peilin.ye@bytedance.com>
    selftests/fib_tests: Rework fib_rp_filter_test()

Dan Carpenter <dan.carpenter@oracle.com>
    net/qla3xxx: fix an error code in ql_adapter_up()

Eric Dumazet <edumazet@google.com>
    net, neigh: clear whole pneigh_entry at alloc time

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()

Dan Carpenter <dan.carpenter@oracle.com>
    net: altera: set a couple error code in probe()

Lee Jones <lee.jones@linaro.org>
    net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Remove needless libpython-version feature check that breaks test-all fast path

Alexander Stein <alexander.stein@ew.tq-group.com>
    dt-bindings: net: Reintroduce PHY no lane swap binding

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Documentation/locking/locktypes: Update migrate_disable() bits.

Ian Rogers <irogers@google.com>
    perf tools: Fix SMT detection fast read path

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix DPIA outbox timeout after S3/S4/reset

Marek Behún <kabel@kernel.org>
    Revert "PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated bridge"

Norbert Zulinski <norbertx.zulinski@intel.com>
    i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Re-evaluate proto ops when psock is removed from sockmap

Herve Codina <herve.codina@bootlin.com>
    mtd: rawnand: fsmc: Fix timing computation

Herve Codina <herve.codina@bootlin.com>
    mtd: rawnand: fsmc: Take instruction delay into account

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix pre-set max number of queues for VF

Karen Sornek <karen.sornek@intel.com>
    i40e: Fix failed opcode appearing if handling messages from VF

Bjorn Andersson <bjorn.andersson@linaro.org>
    clk: qcom: clk-alpha-pll: Don't reconfigure running Trion

Miles Chen <miles.chen@mediatek.com>
    clk: imx: use module_platform_driver

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Fix warning on /proc/i8k creation error

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Do not destroy QP resources in the hw resetting phase

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Do not halt commands during reset until later

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: return correct value from mixer put

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: handle channel mappping list correctly

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wsa881x: fix return values from kcontrol put

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6routing: Fix return value from msm_routing_put_audio_mixer

Rob Clark <robdclark@chromium.org>
    ASoC: rt5682: Fix crash due to out of scope stack vars

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Fix pm_runtime_active() kerneldoc comment

Manish Chopra <manishc@marvell.com>
    qede: validate non LSO skb length

Geraldo Nascimento <geraldogabriel@gmail.com>
    ALSA: usb-audio: Reorder snd_djm_devices[] entries

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: scsi_debug: Fix buffer size of REPORT ZONES command

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Do not call scsi_remove_host() in pm8001_alloc()

Davidlohr Bueso <dave@stgolabs.net>
    block: fix ioprio_get(IOPRIO_WHO_PGRP) vs setuid(2)

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: mpc: Use atomic read and fix break condition

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Set all files to the same group ownership as the mount option

Eric Biggers <ebiggers@google.com>
    aio: fix use-after-free due to missing POLLFREE handling

Eric Biggers <ebiggers@google.com>
    aio: keep poll requests on waitqueue until completed

Eric Biggers <ebiggers@google.com>
    signalfd: use wake_up_pollfree()

Eric Biggers <ebiggers@google.com>
    binder: use wake_up_pollfree()

Eric Biggers <ebiggers@google.com>
    wait: add wake_up_pollfree()

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure task_work gets run as part of cancelations

Hannes Reinecke <hare@suse.de>
    libata: add horkage for ASMedia 1092

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/syncobj: Deal with signalled fences in drm_syncobj_find_fence.

Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
    thermal: int340x: Fix VCoRefLow MMIO bit offset for TGL

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: regmap-mux: fix parent clock lookup

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: initialize variable properly when tuning

Billy Tsai <billy_tsai@aspeedtech.com>
    hwmon: (pwm-fan) Ensure the fan going on in .probe()

Paolo Bonzini <pbonzini@redhat.com>
    selftests: KVM: avoid failures due to reserved HyperTransport region

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Have new files inherit the ownership of their parent

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    nfsd: Fix nsfd startup race (again)

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix use-after-free due to delegation race

Markus Hochholdinger <markus@hochholdinger.net>
    md: fix update super 1.0 on rdev size change

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix error timestamp setting on the decoder error path

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix missing 'instruction' events with 'q' option

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix next 'err' value, walking trace

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix state setting when receiving overflow (OVF) packet

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix intel_pt_fup_event() assumptions about setting state type

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix sync state when a PSB (synchronization) packet is found

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix some PGE (packet generation enable/control flow packets) usage

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: free exchange changeset on failures

Qu Wenruo <wqu@suse.com>
    btrfs: replace the BUG_ON in btrfs_del_root_ref with proper error handling

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: fix re-dirty process of tree-log nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: clear extent buffer uptodate when we fail to write it

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Format log strings only if needed

Vincent Whitchurch <vincent.whitchurch@axis.com>
    cifs: Fix crash on unload of cifs_arc4.ko

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Handle missing errors in snd_pcm_oss_change_params*()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Limit the period size to 16MB

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix negative period/buffer sizes

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Fix quirk for TongFang PHxTxX1

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add headset Mic support for Lenovo ALC897 platform

Alan Young <consult.awy@gmail.com>
    ALSA: ctl: Fix copy of updated id with element read/write

Manjong Lee <mj0123.lee@samsung.com>
    mm: bdi: initialize bdi_min_ratio when bdi is unregistered

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    mm/slub: fix endianness bug for alloc/free_traces attributes

SeongJae Park <sj@kernel.org>
    mm/damon/core: fix fake load reports due to uninterruptible sleeps

SeongJae Park <sj@kernel.org>
    timers: implement usleep_idle_range()

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Wait for IPIs to be delivered when handling Hyper-V TLB flush hypercall

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI req

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't WARN if userspace mucks with RCX during string I/O exit

Louis Amas <louis.amas@eho.link>
    net: mvpp2: fix XDP rx queues registering

Eric Dumazet <edumazet@google.com>
    net/sched: fq_pie: prevent dismantle issue

José Expósito <jose.exposito89@gmail.com>
    net: dsa: felix: Fix memory leak in felix_setup_mmio_filtering

Ameer Hamza <amhamza.mgc@gmail.com>
    net: dsa: mv88e6xxx: error handling for serdes_power functions

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: bcm4908: Handle dma_set_coherent_mask error codes

Eric Dumazet <edumazet@google.com>
    devlink: fix netns refcount leak in devlink_nl_cmd_reload()

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Correct guard on eager buffer deallocation

Michal Maloszewski <michal.maloszewski@intel.com>
    iavf: Fix reporting when setting descriptor count

Mitch Williams <mitch.a.williams@intel.com>
    iavf: restore MSI state on reset

Eric Dumazet <edumazet@google.com>
    netfilter: conntrack: annotate data-races around ct->timeout

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_exthdr: break evaluation if setting TCP option fails

Jianguo Wu <wujianguo@chinatelecom.cn>
    udp: using datalen to cap max gso segments

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix the iif in the IPv6 socket control block

Jianglei Nie <niejianglei2021@163.com>
    nfp: Fix memory leak in nfp_cpp_area_cache_add()

Eric Dumazet <edumazet@google.com>
    bonding: make tx_rebalance_counter an atomic

Antoine Tenart <atenart@kernel.org>
    ethtool: do not perform operations on net devices being unregistered

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: ignore dropped packets during init

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Fix the off-by-two error in range markings

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    bpf: Make sure bpf_disable_instrumentation() is safe vs preemption.

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Attach map progs to psock early for feature probes

Björn Töpel <bjorn@kernel.org>
    bpf, x86: Fix "no previous prototype" warning

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vrf: don't run conntrack on vrf with !dflt qdisc

Florian Westphal <fw@strlen.de>
    selftests: netfilter: add a vrf+conntrack testcase

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done

Fabrizio Bertocci <fabriziobertocci@gmail.com>
    platform/x86: amd-pmc: Fix s2idle failures on certain AMD laptops

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sme: Explicitly map new EFI memmap table as encrypted

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal PHY's"

Brian Silverman <brian.silverman@bluerivertech.com>
    can: m_can: Disable and ignore ELO interrupt

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    can: m_can: pci: fix iomap_read_fifo() and iomap_write_fifo()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    can: m_can: pci: fix incorrect reference clock rate

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: m_can: m_can_read_fifo: fix memory leak in error branch

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: pch_can: pch_can_rx_normal: fix use after free

Dan Carpenter <dan.carpenter@oracle.com>
    can: sja1000: fix use after free in ems_pcmcia_add_card()

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: kvaser_pciefd_rx_error_frame(): increase correct stats->{rx,tx}_errors counter

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: get CAN clock frequency from device

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Fix leak of rcvhdrtail_dummy_kvaddr

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Fix early init panic

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Insure use of smp_processor_id() is preempt disabled

Stefano Brivio <sbrivio@redhat.com>
    nft_set_pipapo: Fix bucket load in AVX2 lookup routine for six 8-bit groups

Alex Hung <alex.hung@canonical.com>
    platform/x86/intel: hid: add quirk to support Surface Go 3

Hans de Goede <hdegoede@redhat.com>
    HID: Ignore battery for Elan touchscreen on Asus UX550VE

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: sony: fix error path in probe

Jon Hunter <jonathanh@nvidia.com>
    mmc: spi: Add device-tree SPI IDs

Jon Hunter <jonathanh@nvidia.com>
    mtd: dataflash: Add device-tree SPI IDs

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: check for valid USB device for many HID drivers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: wacom: fix problems when device is not a valid USB device

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: bigbenff: prevent null pointer dereference

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add USB_HID dependancy on some USB HID drivers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add USB_HID dependancy to hid-chicony

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add USB_HID dependancy to hid-prodikeys

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add hid_is_usb() function to make it simpler for USB detection

Thomas Weißschuh <linux@weissschuh.net>
    HID: intel-ish-hid: ipc: only enable IRQ wakeup when requested

xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>
    HID: google: add eel USB id

Hans de Goede <hdegoede@redhat.com>
    HID: quirks: Add quirk for the Microsoft Surface 3 type-cover

Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
    usb: gadget: uvc: fix multiple opens


-------------

Diffstat:

 .../devicetree/bindings/net/ethernet-phy.yaml      |   8 +
 Documentation/locking/locktypes.rst                |   9 +-
 Makefile                                           |   4 +-
 arch/csky/kernel/traps.c                           |   4 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/kvm/hyperv.c                              |   7 +-
 arch/x86/kvm/x86.c                                 |   9 +-
 arch/x86/platform/efi/quirks.c                     |   3 +-
 block/ioprio.c                                     |   3 +
 drivers/android/binder.c                           |  21 +-
 drivers/ata/libata-core.c                          |   2 +
 drivers/bus/mhi/core/pm.c                          |  21 +-
 drivers/bus/mhi/pci_generic.c                      |   2 +-
 drivers/clk/imx/clk-imx8qxp-lpcg.c                 |   2 +-
 drivers/clk/imx/clk-imx8qxp.c                      |   2 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   9 +
 drivers/clk/qcom/clk-regmap-mux.c                  |   2 +-
 drivers/clk/qcom/common.c                          |  12 +
 drivers/clk/qcom/common.h                          |   2 +
 drivers/clocksource/dw_apb_timer_of.c              |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 +-
 drivers/gpu/drm/drm_syncobj.c                      |  11 +-
 drivers/hid/Kconfig                                |  10 +-
 drivers/hid/hid-asus.c                             |   6 +-
 drivers/hid/hid-bigbenff.c                         |   2 +-
 drivers/hid/hid-chicony.c                          |   3 +
 drivers/hid/hid-corsair.c                          |   7 +-
 drivers/hid/hid-elan.c                             |   2 +-
 drivers/hid/hid-elo.c                              |   3 +
 drivers/hid/hid-ft260.c                            |   3 +
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-holtek-kbd.c                       |   9 +-
 drivers/hid/hid-holtek-mouse.c                     |   9 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-input.c                            |   2 +
 drivers/hid/hid-lg.c                               |  10 +-
 drivers/hid/hid-logitech-dj.c                      |   2 +-
 drivers/hid/hid-prodikeys.c                        |  10 +-
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-roccat-arvo.c                      |   3 +
 drivers/hid/hid-roccat-isku.c                      |   3 +
 drivers/hid/hid-roccat-kone.c                      |   3 +
 drivers/hid/hid-roccat-koneplus.c                  |   3 +
 drivers/hid/hid-roccat-konepure.c                  |   3 +
 drivers/hid/hid-roccat-kovaplus.c                  |   3 +
 drivers/hid/hid-roccat-lua.c                       |   3 +
 drivers/hid/hid-roccat-pyra.c                      |   3 +
 drivers/hid/hid-roccat-ryos.c                      |   3 +
 drivers/hid/hid-roccat-savu.c                      |   3 +
 drivers/hid/hid-samsung.c                          |   3 +
 drivers/hid/hid-sony.c                             |  24 +-
 drivers/hid/hid-thrustmaster.c                     |   3 +
 drivers/hid/hid-u2fzero.c                          |   2 +-
 drivers/hid/hid-uclogic-core.c                     |   3 +
 drivers/hid/hid-uclogic-params.c                   |   3 +-
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   6 +-
 drivers/hid/wacom_sys.c                            |  19 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   7 +-
 drivers/hwmon/pwm-fan.c                            |   2 -
 drivers/i2c/busses/i2c-mpc.c                       |   2 +-
 drivers/iio/accel/kxcjk-1013.c                     |   5 +-
 drivers/iio/accel/kxsd9.c                          |   6 +-
 drivers/iio/accel/mma8452.c                        |   2 +-
 drivers/iio/adc/ad7768-1.c                         |   2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   3 +-
 drivers/iio/adc/axp20x_adc.c                       |  18 +-
 drivers/iio/adc/dln2-adc.c                         |  21 +-
 drivers/iio/adc/stm32-adc.c                        |   1 +
 drivers/iio/gyro/adxrs290.c                        |   5 +-
 drivers/iio/gyro/itg3200_buffer.c                  |   2 +-
 drivers/iio/industrialio-trigger.c                 |   1 -
 drivers/iio/light/ltr501.c                         |   2 +-
 drivers/iio/light/stk3310.c                        |   6 +-
 drivers/iio/trigger/stm32-timer-trigger.c          |   2 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   2 +
 drivers/infiniband/hw/hfi1/driver.c                |   2 +
 drivers/infiniband/hw/hfi1/init.c                  |  40 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  14 +-
 drivers/irqchip/irq-armada-370-xp.c                |  16 +-
 drivers/irqchip/irq-aspeed-scu-ic.c                |   4 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/irqchip/irq-nvic.c                         |   2 +-
 drivers/md/md.c                                    |   1 +
 drivers/misc/cardreader/rtsx_pcr.c                 |   4 -
 drivers/misc/eeprom/at25.c                         |  38 +-
 drivers/misc/fastrpc.c                             |  10 +-
 drivers/mmc/host/mmc_spi.c                         |   7 +
 drivers/mmc/host/renesas_sdhi_core.c               |   2 +-
 drivers/mtd/devices/mtd_dataflash.c                |   8 +
 drivers/mtd/nand/raw/fsmc_nand.c                   |  36 +-
 drivers/net/bonding/bond_alb.c                     |  14 +-
 drivers/net/can/kvaser_pciefd.c                    |   8 +-
 drivers/net/can/m_can/m_can.c                      |  18 +-
 drivers/net/can/m_can/m_can_pci.c                  |  16 +-
 drivers/net/can/pch_can.c                          |   2 +-
 drivers/net/can/sja1000/ems_pcmcia.c               |   7 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 101 +++-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  85 +--
 drivers/net/dsa/mv88e6xxx/serdes.c                 |   8 +-
 drivers/net/dsa/ocelot/felix.c                     |   5 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |   9 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |   4 +-
 drivers/net/ethernet/freescale/fec.h               |   3 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   8 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  75 ++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   2 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  43 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   7 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |  19 +-
 drivers/net/usb/cdc_ncm.c                          |   2 +
 drivers/net/vrf.c                                  |   8 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |   6 +-
 drivers/pci/controller/pci-aardvark.c              |   9 -
 drivers/platform/x86/amd-pmc.c                     |   2 +-
 drivers/platform/x86/intel/hid.c                   |   7 +
 drivers/scsi/pm8001/pm8001_init.c                  |   6 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   3 +
 drivers/scsi/scsi_debug.c                          |   2 +-
 .../intel/int340x_thermal/processor_thermal_rfim.c |   2 +-
 drivers/usb/core/config.c                          |   6 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |  15 -
 drivers/usb/gadget/composite.c                     |  14 +-
 drivers/usb/gadget/function/uvc.h                  |   2 +
 drivers/usb/gadget/function/uvc_v4l2.c             |  49 +-
 drivers/usb/gadget/legacy/dbgp.c                   |  15 +-
 drivers/usb/gadget/legacy/inode.c                  |  16 +-
 drivers/usb/host/xhci-hub.c                        |   1 +
 drivers/usb/host/xhci-ring.c                       |   1 -
 drivers/usb/host/xhci.c                            |  26 +-
 fs/aio.c                                           | 186 ++++--
 fs/btrfs/delalloc-space.c                          |  12 +-
 fs/btrfs/extent_io.c                               |   6 +
 fs/btrfs/root-tree.c                               |   3 +-
 fs/btrfs/tree-log.c                                |   5 +-
 fs/io_uring.c                                      |   6 +-
 fs/nfsd/nfs4recover.c                              |   1 +
 fs/nfsd/nfs4state.c                                |   9 +-
 fs/nfsd/nfsctl.c                                   |  14 +-
 fs/signalfd.c                                      |  12 +-
 fs/smbfs_common/cifs_arc4.c                        |  13 -
 fs/tracefs/inode.c                                 |  76 +++
 include/linux/bpf.h                                |  17 +-
 include/linux/delay.h                              |  14 +-
 include/linux/filter.h                             |   3 -
 include/linux/hid.h                                |   5 +
 include/linux/mhi.h                                |  13 +
 include/linux/pm_runtime.h                         |   2 +-
 include/linux/wait.h                               |  26 +
 include/net/bond_alb.h                             |   2 +-
 include/net/netfilter/nf_conntrack.h               |   6 +-
 include/uapi/asm-generic/poll.h                    |   2 +-
 kernel/bpf/verifier.c                              |   2 +-
 kernel/sched/wait.c                                |   7 +
 kernel/time/timer.c                                |  16 +-
 mm/backing-dev.c                                   |   7 +
 mm/damon/core.c                                    |  14 +-
 mm/slub.c                                          |  15 +-
 net/core/devlink.c                                 |  16 +-
 net/core/neighbour.c                               |   3 +-
 net/core/skmsg.c                                   |   5 +
 net/core/sock_map.c                                |  15 +-
 net/ethtool/netlink.c                              |   3 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/seg6_iptunnel.c                           |   8 +
 net/netfilter/nf_conntrack_core.c                  |   6 +-
 net/netfilter/nf_conntrack_netlink.c               |   2 +-
 net/netfilter/nf_flow_table_core.c                 |   4 +-
 net/netfilter/nft_exthdr.c                         |  11 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   2 +-
 net/nfc/netlink.c                                  |   6 +-
 net/sched/sch_fq_pie.c                             |   1 +
 sound/core/control_compat.c                        |   3 +
 sound/core/oss/pcm_oss.c                           |  37 +-
 sound/pci/hda/patch_realtek.c                      |  80 ++-
 sound/soc/codecs/rt5682.c                          |  10 +-
 sound/soc/codecs/wcd934x.c                         | 126 ++--
 sound/soc/codecs/wsa881x.c                         |  16 +-
 sound/soc/qcom/qdsp6/q6routing.c                   |   8 +-
 sound/usb/mixer_quirks.c                           |  10 +-
 tools/build/Makefile.feature                       |   1 -
 tools/build/feature/Makefile                       |   4 -
 tools/build/feature/test-all.c                     |   5 -
 tools/build/feature/test-libpython-version.c       |  11 -
 tools/perf/Makefile.config                         |   2 -
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  85 ++-
 tools/perf/util/intel-pt.c                         |   1 +
 tools/perf/util/smt.c                              |   2 +-
 .../bpf/verifier/xdp_direct_packet_access.c        | 632 +++++++++++++++++++--
 tools/testing/selftests/kvm/include/kvm_util.h     |   9 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  68 +++
 tools/testing/selftests/net/fib_tests.sh           |  59 +-
 tools/testing/selftests/netfilter/Makefile         |   3 +-
 tools/testing/selftests/netfilter/conntrack_vrf.sh | 241 ++++++++
 201 files changed, 2502 insertions(+), 730 deletions(-)


