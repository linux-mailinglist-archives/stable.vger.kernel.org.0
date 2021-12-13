Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092E0472627
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbhLMJtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33114 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbhLMJq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:46:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49A93B80E2F;
        Mon, 13 Dec 2021 09:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15967C341C8;
        Mon, 13 Dec 2021 09:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388813;
        bh=XHf5GMn16JXl3wdih0CVR5rbmgBRxBj06KdeCua7ALc=;
        h=From:To:Cc:Subject:Date:From;
        b=19ewcDU/auKuD+Wa4zpS7vu24YfYvYaFjPu/WqdT22HMqLsh78biUcnJjWc100wci
         ku6lplSt8eKfSB1fuG+PWrqW8xDdSMX2NLwJPl1EsDXhoFHIE9XyxMqe33Ow+IBCdi
         BD/ta7yX6NBNned/+i4Mn/HjC/evZSz3ZvQ0H4GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/132] 5.10.85-rc1 review
Date:   Mon, 13 Dec 2021 10:29:01 +0100
Message-Id: <20211213092939.074326017@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.85-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.85-rc1
X-KernelTest-Deadline: 2021-12-15T09:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.85 release.
There are 132 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.85-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.85-rc1

Robert Karszniewicz <r.karszniewicz@phytec.de>
    Documentation/Kbuild: Remove references to gcc-plugin.sh

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    MAINTAINERS: adjust GCC PLUGINS after gcc-plugin.sh removal

Masahiro Yamada <masahiroy@kernel.org>
    doc: gcc-plugins: update gcc-plugins.rst

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: simplify GCC_PLUGINS enablement in dummy-tools/gcc

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Add selftests to cover packet access corner cases

Jeya R <jeyr@codeaurora.org>
    misc: fastrpc: fix improper packet size calculation

Vladimir Murzin <vladimir.murzin@arm.com>
    irqchip: nvic: Fix offset for Interrupt Priority Offsets

Wudi Wang <wangwudi@hisilicon.com>
    irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Fix support for Multi-MSI interrupts

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Fix return value of armada_370_xp_msi_alloc()

Billy Tsai <billy_tsai@aspeedtech.com>
    irqchip/aspeed-scu: Replace update_bits with write_bits.

Kelly Devilliv <kelly.devilliv@gmail.com>
    csky: fix typo of fpu config macro

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

Marek Behún <kabel@kernel.org>
    Revert "PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated bridge"

Norbert Zulinski <norbertx.zulinski@intel.com>
    i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc

Herve Codina <herve.codina@bootlin.com>
    mtd: rawnand: fsmc: Fix timing computation

Herve Codina <herve.codina@bootlin.com>
    mtd: rawnand: fsmc: Take instruction delay into account

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix pre-set max number of queues for VF

Karen Sornek <karen.sornek@intel.com>
    i40e: Fix failed opcode appearing if handling messages from VF

Miles Chen <miles.chen@mediatek.com>
    clk: imx: use module_platform_driver

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

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: scsi_debug: Fix buffer size of REPORT ZONES command

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Do not call scsi_remove_host() in pm8001_alloc()

Davidlohr Bueso <dave@stgolabs.net>
    block: fix ioprio_get(IOPRIO_WHO_PGRP) vs setuid(2)

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Set all files to the same group ownership as the mount option

Louis Amas <louis.amas@eho.link>
    net: mvpp2: fix XDP rx queues registering

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

Hannes Reinecke <hare@suse.de>
    libata: add horkage for ASMedia 1092

Brian Silverman <brian.silverman@bluerivertech.com>
    can: m_can: Disable and ignore ELO interrupt

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: pch_can: pch_can_rx_normal: fix use after free

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/syncobj: Deal with signalled fences in drm_syncobj_find_fence.

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: regmap-mux: fix parent clock lookup

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: initialize variable properly when tuning

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Have new files inherit the ownership of their parent

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    nfsd: Fix nsfd startup race (again)

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix use-after-free due to delegation race

Markus Hochholdinger <markus@hochholdinger.net>
    md: fix update super 1.0 on rdev size change

Qu Wenruo <wqu@suse.com>
    btrfs: replace the BUG_ON in btrfs_del_root_ref with proper error handling

Josef Bacik <josef@toxicpanda.com>
    btrfs: clear extent buffer uptodate when we fail to write it

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Format log strings only if needed

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

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Wait for IPIs to be delivered when handling Hyper-V TLB flush hypercall

Eric Dumazet <edumazet@google.com>
    net/sched: fq_pie: prevent dismantle issue

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

Jianguo Wu <wujianguo@chinatelecom.cn>
    udp: using datalen to cap max gso segments

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix the iif in the IPv6 socket control block

Jianglei Nie <niejianglei2021@163.com>
    nfp: Fix memory leak in nfp_cpp_area_cache_add()

Eric Dumazet <edumazet@google.com>
    bonding: make tx_rebalance_counter an atomic

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: ignore dropped packets during init

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Fix the off-by-two error in range markings

Björn Töpel <bjorn@kernel.org>
    bpf, x86: Fix "no previous prototype" warning

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vrf: don't run conntrack on vrf with !dflt qdisc

Florian Westphal <fw@strlen.de>
    selftests: netfilter: add a vrf+conntrack testcase

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdkfd: fix boot failure when iommu is disabled in Picasso.

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: init iommu after amdkfd device init

James Zhu <James.Zhu@amd.com>
    drm/amdgpu: move iommu_resume before ip init/resume

James Zhu <James.Zhu@amd.com>
    drm/amdgpu: add amdgpu_amdkfd_resume_iommu

James Zhu <James.Zhu@amd.com>
    drm/amdkfd: separate kfd_iommu_resume from kfd_resume

Lang Yu <Lang.Yu@amd.com>
    drm/amd/amdkfd: adjust dummy functions' placement

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sme: Explicitly map new EFI memmap table as encrypted

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

xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>
    HID: google: add eel USB id

Hans de Goede <hdegoede@redhat.com>
    HID: quirks: Add quirk for the Microsoft Surface 3 type-cover

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    gcc-plugins: fix gcc 11 indigestion with plugins...

Masahiro Yamada <masahiroy@kernel.org>
    gcc-plugins: simplify GCC plugin-dev capability test

Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
    usb: gadget: uvc: fix multiple opens


-------------

Diffstat:

 .../devicetree/bindings/net/ethernet-phy.yaml      |   8 +
 Documentation/kbuild/gcc-plugins.rst               |  47 +-
 Documentation/locking/locktypes.rst                |   9 +-
 MAINTAINERS                                        |   1 -
 Makefile                                           |   4 +-
 arch/csky/kernel/traps.c                           |   4 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/platform/efi/quirks.c                     |   3 +-
 block/ioprio.c                                     |   3 +
 drivers/android/binder.c                           |  21 +-
 drivers/ata/libata-core.c                          |   2 +
 drivers/clk/imx/clk-imx8qxp-lpcg.c                 |   2 +-
 drivers/clk/imx/clk-imx8qxp.c                      |   2 +-
 drivers/clk/qcom/clk-regmap-mux.c                  |   2 +-
 drivers/clk/qcom/common.c                          |  12 +
 drivers/clk/qcom/common.h                          |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |  97 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         | 145 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  15 +-
 drivers/gpu/drm/drm_syncobj.c                      |  11 +-
 drivers/hid/Kconfig                                |  10 +-
 drivers/hid/hid-asus.c                             |   6 +-
 drivers/hid/hid-bigbenff.c                         |   2 +-
 drivers/hid/hid-chicony.c                          |   8 +-
 drivers/hid/hid-corsair.c                          |   7 +-
 drivers/hid/hid-elan.c                             |   2 +-
 drivers/hid/hid-elo.c                              |   3 +
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-holtek-kbd.c                       |   9 +-
 drivers/hid/hid-holtek-mouse.c                     |   9 +
 drivers/hid/hid-ids.h                              |   2 +
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
 drivers/hid/hid-u2fzero.c                          |   2 +-
 drivers/hid/hid-uclogic-core.c                     |   3 +
 drivers/hid/hid-uclogic-params.c                   |   3 +-
 drivers/hid/wacom_sys.c                            |  19 +-
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
 drivers/misc/fastrpc.c                             |  10 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   2 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |  36 +-
 drivers/net/bonding/bond_alb.c                     |  14 +-
 drivers/net/can/kvaser_pciefd.c                    |   8 +-
 drivers/net/can/m_can/m_can.c                      |  14 +-
 drivers/net/can/pch_can.c                          |   2 +-
 drivers/net/can/sja1000/ems_pcmcia.c               |   7 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 101 +++-
 drivers/net/ethernet/altera/altera_tse_main.c      |   9 +-
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
 drivers/pci/controller/pci-aardvark.c              |   9 -
 drivers/scsi/pm8001/pm8001_init.c                  |   6 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   3 +
 drivers/scsi/scsi_debug.c                          |   2 +-
 drivers/usb/core/config.c                          |   6 +-
 drivers/usb/gadget/composite.c                     |  14 +-
 drivers/usb/gadget/function/uvc.h                  |   2 +
 drivers/usb/gadget/function/uvc_v4l2.c             |  49 +-
 drivers/usb/gadget/legacy/dbgp.c                   |  15 +-
 drivers/usb/gadget/legacy/inode.c                  |  16 +-
 drivers/usb/host/xhci-hub.c                        |   1 +
 drivers/usb/host/xhci-ring.c                       |   1 -
 drivers/usb/host/xhci.c                            |  26 +-
 fs/aio.c                                           | 184 ++++--
 fs/btrfs/extent_io.c                               |   6 +
 fs/btrfs/root-tree.c                               |   3 +-
 fs/nfsd/nfs4recover.c                              |   1 +
 fs/nfsd/nfs4state.c                                |   9 +-
 fs/nfsd/nfsctl.c                                   |  14 +-
 fs/signalfd.c                                      |  12 +-
 fs/tracefs/inode.c                                 |  76 +++
 include/linux/bpf.h                                |   1 +
 include/linux/hid.h                                |   5 +
 include/linux/pm_runtime.h                         |   2 +-
 include/linux/wait.h                               |  26 +
 include/net/bond_alb.h                             |   2 +-
 include/net/netfilter/nf_conntrack.h               |   6 +-
 include/uapi/asm-generic/poll.h                    |   2 +-
 kernel/bpf/verifier.c                              |   2 +-
 kernel/sched/wait.c                                |   7 +
 mm/backing-dev.c                                   |   7 +
 net/core/devlink.c                                 |  16 +-
 net/core/neighbour.c                               |   3 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/seg6_iptunnel.c                           |   8 +
 net/netfilter/nf_conntrack_core.c                  |   6 +-
 net/netfilter/nf_conntrack_netlink.c               |   2 +-
 net/netfilter/nf_flow_table_core.c                 |   4 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   2 +-
 net/nfc/netlink.c                                  |   6 +-
 net/sched/sch_fq_pie.c                             |   1 +
 scripts/dummy-tools/gcc                            |  10 +-
 scripts/gcc-plugin.sh                              |  19 -
 scripts/gcc-plugins/Kconfig                        |   2 +-
 scripts/gcc-plugins/Makefile                       |   4 +-
 sound/core/control_compat.c                        |   3 +
 sound/core/oss/pcm_oss.c                           |  37 +-
 sound/pci/hda/patch_realtek.c                      |  80 ++-
 sound/soc/codecs/rt5682.c                          |  10 +-
 sound/soc/codecs/wcd934x.c                         | 126 ++--
 sound/soc/codecs/wsa881x.c                         |  16 +-
 sound/soc/qcom/qdsp6/q6routing.c                   |   8 +-
 tools/build/Makefile.feature                       |   1 -
 tools/build/feature/Makefile                       |   4 -
 tools/build/feature/test-all.c                     |   5 -
 tools/build/feature/test-libpython-version.c       |  11 -
 tools/perf/Makefile.config                         |   2 -
 tools/perf/util/smt.c                              |   2 +-
 .../bpf/verifier/xdp_direct_packet_access.c        | 632 +++++++++++++++++++--
 tools/testing/selftests/net/fib_tests.sh           |  59 +-
 tools/testing/selftests/netfilter/conntrack_vrf.sh | 241 ++++++++
 161 files changed, 2242 insertions(+), 684 deletions(-)


