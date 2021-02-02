Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B00B30BFE3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhBBNn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:43:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232660AbhBBNkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:40:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6073164F5D;
        Tue,  2 Feb 2021 13:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273186;
        bh=umizZQI+grMgeXeqz/fNIWsxMiAJ6M35RMWOiorboSs=;
        h=From:To:Cc:Subject:Date:From;
        b=PyNz7nKH/oip5bRMW5uckGPax4/M2vi6bCb5a114BMpO+HYkRwf4klH+NkwhcKfo3
         RsVJn77aAy96BWq2O+x/a6odPTNaVjTugVhtcT5kClwErelzUtboY7x5leWNvApzGe
         /vecUc3qetTBno/tEBKCMcT7AyobpNZEH20ZVTuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.10 000/142] 5.10.13-rc1 review
Date:   Tue,  2 Feb 2021 14:36:03 +0100
Message-Id: <20210202132957.692094111@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.13-rc1
X-KernelTest-Deadline: 2021-02-04T13:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.13 release.
There are 142 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.13-rc1

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN

Enke Chen <enchen@paloaltonetworks.com>
    tcp: make TCP_USER_TIMEOUT accurate for zero window probes

Ivan Vecera <ivecera@redhat.com>
    team: protect features update by RCU to avoid deadlock

Enzo Matsumiya <ematsumiya@suse.de>
    scsi: qla2xxx: Fix description for parameter ql2xenforce_iocb_limit

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: topology: Fix memory corruption in soc_tplg_denum_create_values()

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Properly unregister DAI on removal

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: mediatek: mt8183-mt6358: ignore TDM DAI link by default

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: mediatek: mt8183-da7219: ignore TDM DAI link by default

Pan Bian <bianpan2016@163.com>
    NFC: fix possible resource leak

Pan Bian <bianpan2016@163.com>
    NFC: fix resource leak when target index is invalid

Takeshi Misawa <jeliantsurux@gmail.com>
    rxrpc: Fix memory leak in rxrpc_lookup_local

Danielle Ratson <danieller@nvidia.com>
    selftests: forwarding: Specify interface when invoking mausezahn

Daniel Wagner <dwagner@suse.de>
    nvme-multipath: Early exit if no path is available

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Correctly check addr alignment in qi_flush_dev_iotlb_pasid()

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Use IVHD EFR for early initialization of IOMMU features

Yong Wu <yong.wu@mediatek.com>
    of/device: Update dma_range_map only when dev has valid dma-ranges

Moritz Fischer <mdf@kernel.org>
    ACPI/IORT: Do not blindly trust DMA masks from firmware

Dan Carpenter <dan.carpenter@oracle.com>
    can: dev: prevent potential information leak in can_fill_info()

Paul Blakey <paulb@nvidia.com>
    net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhashtable

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Revert parameters on errors when changing MTU and LRO state without reset

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Revert parameters on errors when changing trust state without reset

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Correctly handle changing the number of queues when the interface is down

Paul Blakey <paulb@nvidia.com>
    net/mlx5e: Fix CT rule + encap slow path offload and deletion

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Disable hw-tc-offload when MLX5_CLS_ACT config is disabled

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: Maintain separate page trees for ECPF and PF functions

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Reduce tc unsupported key print level

Pan Bian <bianpan2016@163.com>
    net/mlx5e: free page before return

Parav Pandit <parav@nvidia.com>
    net/mlx5e: E-switch, Fix rate calculation for overflow

Roi Dayan <roid@nvidia.com>
    net/mlx5: Fix memory leak on flow table creation error flow

Corinna Vinschen <vinschen@redhat.com>
    igc: fix link speed advertising

Stefan Assmann <sassmann@kpanic.de>
    i40e: acquire VSI pointer only after VF is initialized

Brett Creeley <brett.creeley@intel.com>
    ice: Fix MSI-X vector fallback logic

Brett Creeley <brett.creeley@intel.com>
    ice: Don't allow more channels than LAN MSI-X available

Nick Nunley <nicholas.d.nunley@intel.com>
    ice: update dev_addr in ice_set_mac_address even if HW filter exists

Nick Nunley <nicholas.d.nunley@intel.com>
    ice: Implement flow for IPv6 next header (extension header)

Henry Tieman <henry.w.tieman@intel.com>
    ice: fix FDir IPv6 flexbyte

Johannes Berg <johannes.berg@intel.com>
    mac80211: pause TX while changing interface type

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: reschedule in long-running memory reads

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: use jiffies for memory read spin time limit

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: set LTR on more devices

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pnvm: don't try to load after failures

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pnvm: don't skip everything when not reloading

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: avoid potential PNVM leaks

Stephan Gerhold <stephan@gerhold.net>
    ASoC: qcom: lpass: Fix out-of-bounds DAI ID lookup

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: soundwire: fix select/depend unmet dependencies

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/NFSv4: Update the layout barrier when we schedule a layoutreturn

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/NFSv4: Fix a layout segment leak in pnfs_layout_process()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: prevent recursive replay_soft_interrupts causing superfluous interrupt

Ricardo Ribalda <ribalda@chromium.org>
    ASoC: Intel: Skylake: skl-topology: Fix OOPs ib skl_tplg_complete

Pan Bian <bianpan2016@163.com>
    spi: altera: Fix memory leak on error path

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: lpass-ipq806x: fix bitwidth regmap field

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: Fix broken support to MI2S TERTIARY and QUATERNARY

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    ASoC: qcom: Fix incorrect volatile registers

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: dt-bindings: lpass: Fix and common up lpass dai ids

Kamal Heib <kamalheib1@gmail.com>
    RDMA/cxgb4: Fix the reported max_recv_sge value

Randy Dunlap <rdunlap@infradead.org>
    firmware: imx: select SOC_BUS to fix firmware build

Jacky Bai <ping.bai@nxp.com>
    arm64: dts: imx8mp: Correct the gpio ranges of gpio3

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: dts: imx6qdl-sr-som: fix some cubox-i platforms

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: fix i2c_lcd/cam default status

Arnd Bergmann <arnd@arndb.de>
    ARM: imx: fix imx8m dependencies

Michael Walle <michael@walle.cc>
    arm64: dts: ls1028a: fix the offset of the reset register

Visa Hankala <visa@hankala.org>
    xfrm: Fix wraparound in xfrm_policy_addr_delta()

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: xfrm: fix test return value override issue in xfrm_policy.sh

Eyal Birger <eyal.birger@gmail.com>
    xfrm: fix disable_xfrm sysctl when used on xfrm interfaces

Shmulik Ladkani <shmulik@metanetworks.com>
    xfrm: Fix oops in xfrm_replay_advance_bmp

Maxim Mikityanskiy <maxtram95@gmail.com>
    Revert "block: simplify set_init_blocksize" to regain lost performance

Parav Pandit <parav@nvidia.com>
    Revert "RDMA/mlx5: Fix devlink deadlock on net namespace deletion"

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: add timeout extension to template

Rob Herring <robh@kernel.org>
    ARM: zImage: atags_to_fdt: Fix node names on added root nodes

Max Krummenacher <max.oss.09@gmail.com>
    ARM: imx: build suspend-imx6.S with arm instruction set

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gcc-sm250: Use floor ops for sdcc clks

Arnd Bergmann <arnd@arndb.de>
    clk: mmp2: fix build without CONFIG_PM

Arnd Bergmann <arnd@arndb.de>
    clk: imx: fix Kconfig warning for i.MX SCU clk

Ming Lei <ming.lei@redhat.com>
    blk-mq: test QUEUE_FLAG_HCTX_ACTIVE for sbitmap_shared in hctx_may_queue

Roger Pau Monne <roger.pau@citrix.com>
    xen-blkfront: allow discard-* nodes to be optional

Rouven Czerwinski <r.czerwinski@pengutronix.de>
    tee: optee: replace might_sleep with cond_resched

Quentin Perret <qperret@google.com>
    KVM: Documentation: Fix spec for KVM_CAP_ENABLE_CAP_VM

Justin Iurman <justin.iurman@uliege.be>
    uapi: fix big endian definition of ipv6_rpl_sr_hdr

Pan Bian <bianpan2016@163.com>
    drm/i915/selftest: Fix potential memory leak

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/i915: Check for all subplatform bits

Bastian Beranek <bastian.beischer@rwth-aachen.de>
    drm/nouveau/dispnv50: Restore pushing of all data.

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: Correct POS1_SCL for hvs5

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: Correct lbm size and calculation

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/svm: fail NOUVEAU_SVM_INIT ioctl on unsupported devices

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: fix pwms for lcd-backlight

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix IPSEC stats

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915/pmu: Don't grab wakeref when enabling events

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Clear CACHE_MODE prior to clearing residuals

Matti Gottlieb <matti.gottlieb@intel.com>
    iwlwifi: Fix IWL_SUBDEVICE_NO_160 macro to use the correct bit.

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix rx buffer refcounting

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7663s: fix rx buffer refcounting

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix kernel crash unplugging the device

Bharat Gooty <bharat.gooty@broadcom.com>
    arm64: dts: broadcom: Fix USB DMA address translation for Stingray

Andrea Righi <andrea.righi@canonical.com>
    leds: trigger: fix potential deadlock with libata

David Woodhouse <dwmw@amazon.co.uk>
    xen: Fix XenStore initialisation for XS_LOCAL

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix wqe->lock/completion_lock deadlock

Marc Zyngier <maz@kernel.org>
    KVM: Forbid the use of tagged userspace addresses for memslots

Jay Zhou <jianjay.zhou@huawei.com>
    KVM: x86: get smi pending status correctly

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: nVMX: Sync unsync'd vmcs02 state to vmcs12 on migration

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Filter out v8.1+ events on v8.0 HW

Like Xu <like.xu@linux.intel.com>
    KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()

Like Xu <like.xu@linux.intel.com>
    KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix possible free space tree corruption with online conversion

Su Yue <l@damenly.su>
    btrfs: fix lockdep warning due to seqcount_mutex on 32bit arch

Claudiu Beznea <claudiu.beznea@microchip.com>
    drivers: soc: atmel: add null entry at the end of at91_soc_allowed_list[]

Sudeep Holla <sudeep.holla@arm.com>
    drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvel/cesa - Fix tdma descriptor on 64-bit

Lukas Wunner <lukas@wunner.de>
    efi/apple-properties: Reinstate support for boolean properties

Nick Desaulniers <ndesaulniers@google.com>
    x86/entry: Emit a symbol for register restoring thunk

Laurent Badel <laurentbadel@eaton.com>
    PM: hibernate: flush swap writer after marking

Tony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: No need to disable IRQ after queue reset

Janosch Frank <frankja@linux.ibm.com>
    s390: uv: Fix sysfs max number of VCPUs reporting

Giacinto Cifelli <gciofono@gmail.com>
    net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family

Coly Li <colyli@suse.de>
    bcache: only check feature sets when sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES

Lyude Paul <lyude@redhat.com>
    drivers/nouveau/kms/nv50-: Reject format modifiers for cursor planes

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Always try to reserve GGTT address 0x0

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Always flush the active worker before returning from the wait

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/gk104-gp1xx: Fix > 64x64 cursors

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu/swsmu: drop set_fan_speed_percent (v2)"

Jaroslav Kysela <perex@perex.cz>
    ASoC: AMD Renoir - refine DMI entries for some Lenovo products

Juergen Gross <jgross@suse.com>
    x86/xen: avoid warning in Xen pv guest with CONFIG_AMD_MEM_ENCRYPT enabled

Johannes Berg <johannes.berg@intel.com>
    wext: fix NULL-ptr-dereference with cfg80211's lack of commit()

Koen Vandeputte <koen.vandeputte@citymesh.com>
    ARM: dts: imx6qdl-gw52xx: fix duplicate regulator naming

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Reserve memory carveouts

Soeren Moch <smoch@web.de>
    ARM: dts: tbs2910: rename MMC node aliases

Sean Young <sean@mess.org>
    media: rc: ensure that uevent can be read directly after rc device register

Matthias Reichl <hias@horus.com>
    media: rc: ite-cir: fix min_timeout calculation

Matthias Reichl <hias@horus.com>
    media: rc: fix timeout handling after switch to microsecond durations

Ricardo Ribalda <ribalda@chromium.org>
    media: hantro: Fix reset_raw_fmt initialization

Jernej Skrabec <jernej.skrabec@siol.net>
    media: cedrus: Fix H264 decoding

Yannick Fertre <yannick.fertre@foss.st.com>
    media: cec: add stm32 driver

Helge Deller <deller@gmx.de>
    parisc: Enable -mlong-calls gcc option by default when !CONFIG_MODULES

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via: Apply the workaround generically for Clevo machines

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable headset of ASUS B1400CEPE with ALC256

Baoquan He <bhe@redhat.com>
    kernel: kexec: remove the lock operation of system_transition_mutex

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: thermal: Do not call acpi_thermal_check() directly

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ACPI: sysfs: Prefer "compatible" modalias

Linus Torvalds <torvalds@linux-foundation.org>
    tty: avoid using vfs_iocb_iter_write() for redirected console writes

Josef Bacik <josef@toxicpanda.com>
    nbd: freeze the queue while we're adding connections

Eric Dumazet <edumazet@google.com>
    iwlwifi: provide gso_type to GSO packets


-------------

Diffstat:

 Documentation/asm-annotations.rst                  |   5 ++
 Documentation/virt/kvm/api.rst                     |   5 +-
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/atags_to_fdt.c            |   3 +-
 arch/arm/boot/dts/imx6q-tbs2910.dts                |   7 ++
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi              |   2 +-
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |   6 +-
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi              |  12 ++-
 arch/arm/boot/dts/ste-db8500.dtsi                  |  38 ++++++++
 arch/arm/boot/dts/ste-db8520.dtsi                  |  38 ++++++++
 arch/arm/boot/dts/ste-db9500.dtsi                  |  35 ++++++++
 arch/arm/boot/dts/ste-snowball.dts                 |   2 +-
 arch/arm/mach-imx/suspend-imx6.S                   |   1 +
 .../boot/dts/broadcom/stingray/stingray-usb.dtsi   |   7 +-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   2 +-
 arch/arm64/kvm/pmu-emul.c                          |  10 ++-
 arch/parisc/Kconfig                                |   5 +-
 arch/parisc/kernel/entry.S                         |  13 ++-
 arch/powerpc/kernel/irq.c                          |  28 +++---
 arch/s390/boot/uv.c                                |   2 +-
 arch/s390/include/asm/uv.h                         |   4 +-
 arch/s390/kernel/uv.c                              |   2 +-
 arch/x86/entry/thunk_64.S                          |   8 +-
 arch/x86/include/asm/idtentry.h                    |   1 +
 arch/x86/kvm/svm/nested.c                          |   6 ++
 arch/x86/kvm/vmx/nested.c                          |  46 +++++++---
 arch/x86/kvm/vmx/pmu_intel.c                       |   6 +-
 arch/x86/kvm/x86.c                                 |   4 +
 arch/x86/xen/enlighten_pv.c                        |  15 +++-
 arch/x86/xen/xen-asm.S                             |   1 +
 block/blk-mq.h                                     |   2 +-
 drivers/acpi/arm64/iort.c                          |  14 ++-
 drivers/acpi/device_sysfs.c                        |  20 ++---
 drivers/acpi/thermal.c                             |  46 +++++++---
 drivers/block/nbd.c                                |   8 ++
 drivers/block/xen-blkfront.c                       |  20 ++---
 drivers/clk/imx/Kconfig                            |   2 -
 drivers/clk/mmp/clk-audio.c                        |   6 +-
 drivers/clk/qcom/gcc-sm8250.c                      |   4 +-
 drivers/crypto/marvell/cesa/cesa.h                 |   4 +-
 drivers/firmware/efi/apple-properties.c            |  13 ++-
 drivers/firmware/imx/Kconfig                       |   1 +
 drivers/gpu/drm/amd/pm/inc/amdgpu_smu.h            |   1 +
 drivers/gpu/drm/amd/pm/inc/smu_v11_0.h             |   3 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   9 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   1 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |   1 +
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   1 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |  31 ++++++-
 drivers/gpu/drm/i915/gt/gen7_renderclear.c         |  12 +++
 drivers/gpu/drm/i915/gt/intel_ggtt.c               |  47 +++++++---
 drivers/gpu/drm/i915/i915_active.c                 |  28 +++---
 drivers/gpu/drm/i915/i915_drv.h                    |   2 +-
 drivers/gpu/drm/i915/i915_pmu.c                    |  30 ++++---
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c      |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/base507c.c        |   6 +-
 drivers/gpu/drm/nouveau/dispnv50/base827c.c        |   6 +-
 drivers/gpu/drm/nouveau/dispnv50/head917d.c        |  28 +++++-
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |  17 +++-
 .../gpu/drm/nouveau/include/nvhw/class/cl917d.h    |   4 +
 drivers/gpu/drm/nouveau/nouveau_svm.c              |   4 +
 drivers/gpu/drm/vc4/vc4_hvs.c                      |   8 +-
 drivers/gpu/drm/vc4/vc4_plane.c                    |  11 ++-
 drivers/infiniband/hw/cxgb4/qp.c                   |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  |   6 +-
 drivers/iommu/amd/amd_iommu.h                      |   7 +-
 drivers/iommu/amd/amd_iommu_types.h                |   4 +
 drivers/iommu/amd/init.c                           |  56 +++++++++++-
 drivers/iommu/intel/dmar.c                         |   2 +-
 drivers/leds/led-triggers.c                        |  10 ++-
 drivers/md/bcache/features.h                       |   6 ++
 drivers/media/cec/platform/Makefile                |   1 +
 drivers/media/rc/ir-mce_kbd-decoder.c              |   2 +-
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/rc-main.c                         |   8 +-
 drivers/media/rc/serial_ir.c                       |   2 +-
 drivers/net/can/dev.c                              |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  11 +--
 drivers/net/ethernet/intel/ice/ice.h               |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   8 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |   8 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  14 +--
 drivers/net/ethernet/intel/ice/ice_main.c          |  16 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   9 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |  24 +++--
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  20 +++--
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  13 +--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  39 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  22 +++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |   5 ++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  58 +++++++-----
 drivers/net/team/team.c                            |   6 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  56 ++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   6 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   3 +
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  42 +++++----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  14 +--
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |   9 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |   5 +-
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/of/device.c                                |  10 ++-
 drivers/s390/crypto/vfio_ap_drv.c                  |   6 +-
 drivers/s390/crypto/vfio_ap_ops.c                  | 100 +++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h              |  12 +--
 drivers/scsi/qla2xxx/qla_os.c                      |   2 +-
 drivers/soc/atmel/soc.c                            |  13 +++
 drivers/soc/imx/Kconfig                            |   2 +-
 drivers/spi/spi-altera.c                           |   3 +-
 drivers/staging/media/hantro/hantro_v4l2.c         |   2 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c   |   2 +-
 drivers/tee/optee/call.c                           |   4 +-
 drivers/tty/tty_io.c                               |  20 ++++-
 drivers/xen/xenbus/xenbus_probe.c                  |  31 +++++++
 fs/block_dev.c                                     |  10 ++-
 fs/btrfs/block-group.c                             |  10 ++-
 fs/btrfs/ctree.h                                   |   3 +
 fs/btrfs/free-space-tree.c                         |  10 ++-
 fs/btrfs/volumes.c                                 |   2 +-
 fs/btrfs/volumes.h                                 |  11 +--
 fs/io_uring.c                                      |  10 +--
 fs/nfs/pnfs.c                                      |  40 +++++----
 include/dt-bindings/sound/apq8016-lpass.h          |   7 +-
 include/dt-bindings/sound/qcom,lpass.h             |  15 ++++
 include/dt-bindings/sound/sc7180-lpass.h           |   6 +-
 include/linux/linkage.h                            |   5 ++
 include/linux/mlx5/driver.h                        |  18 ----
 include/net/tcp.h                                  |   3 +-
 include/uapi/linux/rpl.h                           |   6 +-
 kernel/kexec_core.c                                |   2 -
 kernel/power/swap.c                                |   2 +-
 net/ipv4/tcp_input.c                               |  14 +--
 net/ipv4/tcp_output.c                              |   2 +
 net/ipv4/tcp_recovery.c                            |   5 +-
 net/ipv4/tcp_timer.c                               |  18 ++++
 net/mac80211/ieee80211_i.h                         |   1 +
 net/mac80211/iface.c                               |   6 ++
 net/netfilter/nft_dynset.c                         |   4 +-
 net/nfc/netlink.c                                  |   1 +
 net/nfc/rawsock.c                                  |   2 +-
 net/rxrpc/call_accept.c                            |   1 +
 net/wireless/wext-core.c                           |   5 +-
 net/xfrm/xfrm_input.c                              |   2 +-
 net/xfrm/xfrm_policy.c                             |  30 ++++---
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/hda/patch_via.c                          |   2 +-
 sound/soc/amd/renoir/rn-pci-acp3x.c                |  18 +++-
 sound/soc/intel/skylake/skl-topology.c             |  13 +--
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |   5 +-
 .../mt8183/mt8183-mt6358-ts3a227-max98357.c        |   5 +-
 sound/soc/qcom/lpass-cpu.c                         |  42 +++++----
 sound/soc/qcom/lpass-ipq806x.c                     |   2 +-
 sound/soc/qcom/lpass-lpaif-reg.h                   |   2 +-
 sound/soc/qcom/lpass-platform.c                    |  27 +++---
 sound/soc/qcom/lpass-sc7180.c                      |   9 +-
 sound/soc/qcom/lpass.h                             |   2 +-
 sound/soc/soc-topology.c                           |  11 +--
 sound/soc/sof/intel/Kconfig                        |   3 +-
 .../selftests/net/forwarding/router_mpath_nh.sh    |   2 +-
 .../selftests/net/forwarding/router_multipath.sh   |   2 +-
 tools/testing/selftests/net/xfrm_policy.sh         |  45 +++++++++-
 virt/kvm/kvm_main.c                                |   1 +
 169 files changed, 1323 insertions(+), 563 deletions(-)


