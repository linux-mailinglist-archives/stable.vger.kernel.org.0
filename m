Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1BD5EAE18
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiIZRW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiIZRWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:22:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3AE11CB3B;
        Mon, 26 Sep 2022 09:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E436101C;
        Mon, 26 Sep 2022 16:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A7AC433D6;
        Mon, 26 Sep 2022 16:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664210221;
        bh=h33NALZvGt1dAeuPJ9481Kwly2kJ/cTkA4PAq57/E5M=;
        h=From:To:Cc:Subject:Date:From;
        b=ajAbWHnGKgSQbpCEoJyv9jxmXJlUp9pHzrsogpklATilYaM3g0udEzRJ6NT6+y+bv
         UJ0aauIi9HKglQ4NiRQbmj90yyeXD38glAt0YsgQvxxV2uEGfhUy5o5XOM8Zp2xQQa
         1TtmDOau4eyBQuyA5JKETVGZbzrUDqEbm3pJI8Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/138] 5.10.146-rc2 review
Date:   Mon, 26 Sep 2022 18:36:58 +0200
Message-Id: <20220926163550.904900693@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.146-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.146-rc2
X-KernelTest-Deadline: 2022-09-28T16:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.146 release.
There are 138 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.146-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.146-rc2

Jan Kara <jack@suse.cz>
    ext4: make directory inode spreading reflect flexbg size

Theodore Ts'o <tytso@mit.edu>
    ext4: limit the number of retries after discarding preallocations blocks

Luís Henriques <lhenriques@suse.de>
    ext4: fix bug in extents parsing when eh_entries == 0 and eh_depth > 0

Dan Williams <dan.j.williams@intel.com>
    devdax: Fix soft-reservation memory description

Asmaa Mnebhi <asmaa@nvidia.com>
    i2c: mlxbf: Fix frequency calculation

Asmaa Mnebhi <asmaa@nvidia.com>
    i2c: mlxbf: prevent stack overflow in mlxbf_i2c_smbus_start_transaction()

Asmaa Mnebhi <asmaa@nvidia.com>
    i2c: mlxbf: incorrect base address passed during io write

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    i2c: imx: If pm_runtime_get_sync() returned 1 device access is possible

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    workqueue: don't skip lockdep work dependency in cancel_work_sync()

Nathan Huckleberry <nhuck@google.com>
    drm/rockchip: Fix return type of cdn_dp_connector_mode_valid

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Mark dml30's UseMinimumDCFCLK() as noinline for stack usage

Yao Wang1 <Yao.Wang1@amd.com>
    drm/amd/display: Limit user regamma to a valid value

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amdgpu: use dirty framebuffer helper

Hans de Goede <hdegoede@redhat.com>
    drm/gma500: Fix BUG: sleeping function called from invalid context errors

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Stefan Metzmacher <metze@samba.org>
    cifs: always initialize struct msghdr smb_msg completely

David Howells <dhowells@redhat.com>
    cifs: use discard iterator to discard unneeded network data more efficiently

Luben Tuikov <luben.tuikov@amd.com>
    drm/amdgpu: Fix check for RAS support

Daniel Jordan <daniel.m.jordan@oracle.com>
    vfio/type1: fix vaddr_get_pfns() return in vfio_pin_page_external()

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix issue of out-of-bounds array access

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx accounting

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: Create uart_xmit_advance()

Jingwen Chen <Jingwen.Chen2@amd.com>
    drm/amd/amdgpu: fixing read wrong pf2vf data in SRIOV

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: add shebang for sch_red.sh

Hangyu Hua <hbh25y@gmail.com>
    net: sched: fix possible refcount leak in tc_new_tfilter()

Sean Anderson <seanga2@gmail.com>
    net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Stop the CLC flow if no link to map buffers on

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/mediatek: dsi: Move mtk_dsi_stop() call back to mtk_dsi_poweroff()

Adrian Hunter <adrian.hunter@intel.com>
    perf kcore_copy: Do not check /proc/modules is unchanged

Lieven Hey <lieven.hey@kdab.com>
    perf jit: Include program header in ELF files

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): fix race dev->can.state condition

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: fix memory leak when blob is malformed

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    netfilter: nf_tables: fix percpu memory leak at nf_tables_addchain()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: avoid disabling offload when it was never enabled

Arnd Bergmann <arnd@arndb.de>
    net: socket: remove register_gifconf

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: move enetc_set_psfp() out of the common enetc_set_features()

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: netlink: avoid variable-sized memcpy on sockaddr

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: ratelimiter: disable timings test by default

Alex Elder <elder@linaro.org>
    net: ipa: properly limit modem routing table use

Alex Elder <elder@linaro.org>
    net: ipa: kill IPA_TABLE_ENTRY_SIZE

Alex Elder <elder@linaro.org>
    net: ipa: DMA addresses are nicely aligned

Alex Elder <elder@linaro.org>
    net: ipa: avoid 64-bit modulus

Alex Elder <elder@linaro.org>
    net: ipa: fix table alignment requirement

Alex Elder <elder@linaro.org>
    net: ipa: fix assumptions about DMA address size

Liang He <windhl@126.com>
    of: mdio: Add of_node_put() when breaking out of for_each_xx

Randy Dunlap <rdunlap@infradead.org>
    drm/hisilicon: Add depends on MMU

Javier Martinez Canillas <javierm@redhat.com>
    drm/hisilicon/hibmc: Allow to be built if COMPILE_TEST is enabled

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix null pointer dereference in efx_hard_start_xmit

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix TX channel offset when using legacy interrupts

Michal Jaron <michalx.jaron@intel.com>
    i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Michal Jaron <michalx.jaron@intel.com>
    i40e: Fix VF set max MTU size

Michal Jaron <michalx.jaron@intel.com>
    iavf: Fix set max MTU size with port VLAN and jumbo frames

Norbert Zulinski <norbertx.zulinski@intel.com>
    iavf: Fix bad page state

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    MIPS: Loongson32: Fix PHY-mode being left unspecified

Randy Dunlap <rdunlap@infradead.org>
    MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko

Heiko Schocher <hs@denx.de>
    drm/panel: simple: Fix innolux_g121i1_l01 bus_format

Benjamin Poirier <bpoirier@nvidia.com>
    net: team: Unsync device addresses on ndo_stop

Benjamin Poirier <bpoirier@nvidia.com>
    net: bonding: Unsync device addresses on ndo_stop

Benjamin Poirier <bpoirier@nvidia.com>
    net: bonding: Share lacpdu_mcast_addr definition

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix return value check of dma_get_required_mask()

Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Force PCIe scatterlist allocations to be within same 4 GB region

Ioana Ciornei <ioana.ciornei@nxp.com>
    net: phy: aquantia: wait for the suspend/resume operations to finish

Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>
    net: core: fix flow symmetric hash

zhang kai <zhangkaiheb@126.com>
    net: let flow have same hash in two directions

Lu Wei <luwei32@huawei.com>
    ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Brett Creeley <brett.creeley@intel.com>
    iavf: Fix cached head and tail value for iavf_get_tx_pending

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()

David Leadbeater <dgl@dgl.cx>
    netfilter: nf_conntrack_irc: Tighten matching on DCC message

Igor Ryzhov <iryzhov@nfware.com>
    netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Fabio Estevam <festevam@denx.de>
    arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma

Liang He <windhl@126.com>
    dmaengine: ti: k3-udma-private: Fix refcount leak bug in of_xudma_dev_get()

zain wang <wzz@rock-chips.com>
    arm64: dts: rockchip: Set RK3399-Gru PCLK_EDP to 24 MHz

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: dsi: Add atomic {destroy,duplicate}_state, reset callbacks

Brian Norris <briannorris@chromium.org>
    arm64: dts: rockchip: Pull up wlan wake# on Gru-Bob

Dave Chinner <dchinner@redhat.com>
    xfs: validate inode fork size against fork format

Dave Chinner <dchinner@redhat.com>
    xfs: reorder iunlink remove operation in xfs_ifree

Christoph Hellwig <hch@lst.de>
    xfs: fix up non-directory creation in SGID directories

Mike Tipton <mdtipton@codeaurora.org>
    interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate

Mingwei Zhang <mizhang@google.com>
    KVM: SEV: add cache flush to solve SEV cache incoherency issues

Chao Yu <chao.yu@oppo.com>
    mm/slub: fix to return errno if kmalloc() fails

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: flexcan_mailbox_read() fix return value for drop = true

Al Viro <viro@zeniv.linux.org.uk>
    riscv: fix a nasty sigreturn bug...

Meng Li <Meng.Li@windriver.com>
    gpiolib: cdev: Set lineevent_state::irq after IRQ register successfully

Bartosz Golaszewski <brgl@bgdev.pl>
    gpio: mockup: fix NULL pointer dereference when removing debugfs

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix reading current per-tid starting sequence number for aggregation

Ard Biesheuvel <ardb@kernel.org>
    efi: libstub: check Shim mode using MokSBStateRT

Ard Biesheuvel <ardb@kernel.org>
    efi: x86: Wipe setup_data on pure EFI boot

Johan Hovold <johan@kernel.org>
    media: flexcop-usb: fix endpoint type check

Yi Liu <yi.l.liu@intel.com>
    iommu/vt-d: Check correct capability for sagaw determination

Callum Osmotherly <callum.osmotherly@gmail.com>
    ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add quirk for ASUS GA503R laptop

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add pincfg for ASUS G533Z HP jack

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add pincfg for ASUS G513 HP jack

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-arrange quirk table entries

Callum Osmotherly <callum.osmotherly@gmail.com>
    ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5570 laptop

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/realtek: Add quirk for Huawei WRT-WX9

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: add Intel 5 Series / 3400 PCI DID

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda/tegra: set depop delay for tegra

jerry meng <jerry-meng@foxmail.com>
    USB: serial: option: add Quectel RM520N

Carl Yin(殷张成) <carl.yin@quectel.com>
    USB: serial: option: add Quectel BG95 0x0203 composition

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix RST error in hub.c

Mark Brown <broonie@kernel.org>
    arm64/bti: Disable in kernel BTI when cross section thunks are broken

Nathan Chancellor <nathan@kernel.org>
    arm64: Restrict ARM64_BTI_KERNEL to clang 12.0.0 and newer

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: udc-xilinx: replace memcpy with memcpy_toio"

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Unpin zero pages

Daniel Jordan <daniel.m.jordan@oracle.com>
    vfio/type1: Prepare for batched pinning with struct vfio_batch

Daniel Jordan <daniel.m.jordan@oracle.com>
    vfio/type1: Change success value of vaddr_get_pfn()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: add quirks for Lenovo OneLink+ Dock"

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: fix issue with rearming ISO OUT endpoint

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC transfer

Piyush Mehta <piyush.mehta@amd.com>
    usb: gadget: udc-xilinx: replace memcpy with memcpy_toio

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    usb: add quirks for Lenovo OneLink+ Dock

Sergiu Moga <sergiu.moga@microchip.com>
    tty: serial: atmel: Preserve previous USART mode if RS485 disabled

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: atmel: remove redundant assignment in rs485_config

Adrian Hunter <adrian.hunter@intel.com>
    mmc: core: Fix inconsistent sd3_bus_mode at UHS-I SD voltage switch failure

Ikjoon Jang <ikjn@chromium.org>
    usb: xhci-mtk: relax TT periodic bandwidth allocation

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: allow multiple Start-Split in a microframe

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: add some schedule error number

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: add a function to (un)load bandwidth info

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: use @sch_tt to check whether need do TT schedule

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: add only one extra CS for FS/LS INTR

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: get the microframe boundary for ESIT

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't modify GEVNTCOUNT in pullup()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Refactor pullup()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Prevent repeat pullup()

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: Issue core soft reset before enabling run/stop

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Avoid starting DWC3 gadget during UDC unbind

Utkarsh Patel <utkarsh.h.patel@intel.com>
    usb: typec: intel_pmc_mux: Add new ACPI ID for Meteor Lake IOM device

Azhar Shaikh <azhar.shaikh@intel.com>
    usb: typec: intel_pmc_mux: Update IOM port status offset for AlderLake

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: make sure to init common IP before gmc

Victor Skvortsov <victor.skvortsov@amd.com>
    drm/amdgpu: Separate vf2pf work item init from virt data exchange

Peng Ju Zhou <PengJu.Zhou@amd.com>
    drm/amdgpu: indirect register access for nv12 sriov

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |   5 +-
 arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts    |   5 +
 .../boot/dts/rockchip/rk3399-gru-chromebook.dtsi   |   9 ++
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   1 -
 arch/mips/lantiq/clk.c                             |   1 +
 arch/mips/loongson32/common/platform.c             |  16 +-
 arch/riscv/kernel/signal.c                         |   2 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kvm/svm/sev.c                             |   8 +
 arch/x86/kvm/svm/svm.c                             |   1 +
 arch/x86/kvm/svm/svm.h                             |   2 +
 arch/x86/kvm/x86.c                                 |   6 +
 drivers/dax/hmem/device.c                          |   1 +
 drivers/dma/ti/k3-udma-private.c                   |   6 +-
 drivers/firmware/efi/libstub/secureboot.c          |   8 +-
 drivers/firmware/efi/libstub/x86-stub.c            |   7 +
 drivers/gpio/gpio-mockup.c                         |   2 +-
 drivers/gpio/gpiolib-cdev.c                        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  23 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |  34 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   1 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   5 +
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |  25 ----
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c |   3 +-
 .../drm/amd/display/modules/color/color_gamma.c    |   4 +
 drivers/gpu/drm/gma500/gma_display.c               |  11 +-
 drivers/gpu/drm/hisilicon/hibmc/Kconfig            |   3 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |  24 +--
 drivers/gpu/drm/panel/panel-simple.c               |   2 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   5 +-
 drivers/hv/vmbus_drv.c                             |  10 +-
 drivers/i2c/busses/i2c-imx.c                       |   2 +-
 drivers/i2c/busses/i2c-mlxbf.c                     |  68 ++++-----
 drivers/interconnect/qcom/icc-rpmh.c               |  10 +-
 drivers/interconnect/qcom/sm8150.c                 |   1 -
 drivers/interconnect/qcom/sm8250.c                 |   1 -
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   2 +-
 drivers/mmc/core/sd.c                              |  42 ++----
 drivers/net/bonding/bond_3ad.c                     |   5 +-
 drivers/net/bonding/bond_main.c                    |  57 +++++---
 drivers/net/can/flexcan.c                          |  10 +-
 drivers/net/can/usb/gs_usb.c                       |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  32 +---
 drivers/net/ethernet/freescale/enetc/enetc.h       |   9 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  11 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  23 +++
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  32 +++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  20 +++
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   7 +-
 drivers/net/ethernet/sfc/efx_channels.c            |   2 +-
 drivers/net/ethernet/sfc/tx.c                      |   2 +-
 drivers/net/ethernet/sun/sunhme.c                  |   4 +-
 drivers/net/ipa/gsi.c                              |  16 +-
 drivers/net/ipa/gsi_private.h                      |   2 +-
 drivers/net/ipa/gsi_trans.c                        |   9 +-
 drivers/net/ipa/ipa_cmd.c                          |   2 +-
 drivers/net/ipa/ipa_data.h                         |   4 +-
 drivers/net/ipa/ipa_qmi.c                          |  10 +-
 drivers/net/ipa/ipa_qmi_msg.c                      |   8 +-
 drivers/net/ipa/ipa_qmi_msg.h                      |  37 +++--
 drivers/net/ipa/ipa_table.c                        |  88 +++++------
 drivers/net/ipa/ipa_table.h                        |   6 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   6 +-
 drivers/net/mdio/of_mdio.c                         |   1 +
 drivers/net/phy/aquantia_main.c                    |  53 ++++++-
 drivers/net/team/team.c                            |  24 ++-
 drivers/net/wireguard/netlink.c                    |  13 +-
 drivers/net/wireguard/selftest/ratelimiter.c       |  25 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   2 +-
 drivers/s390/block/dasd_alias.c                    |   9 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                | 161 +++++++++++++++------
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   1 +
 drivers/tty/serial/atmel_serial.c                  |   8 +-
 drivers/tty/serial/serial-tegra.c                  |   5 +-
 drivers/tty/serial/tegra-tcu.c                     |   2 +-
 drivers/usb/cdns3/gadget.c                         |   4 +-
 drivers/usb/core/hub.c                             |   2 +-
 drivers/usb/dwc3/core.c                            |   4 +-
 drivers/usb/dwc3/core.h                            |   4 +
 drivers/usb/dwc3/gadget.c                          |  81 ++++++-----
 drivers/usb/host/xhci-mtk-sch.c                    | 149 +++++++++++--------
 drivers/usb/host/xhci-mtk.h                        |   2 -
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/typec/mux/intel_pmc_mux.c              |  37 ++++-
 drivers/vfio/vfio_iommu_type1.c                    | 110 +++++++++++---
 fs/cifs/cifsproto.h                                |   2 +
 fs/cifs/cifssmb.c                                  |   6 +-
 fs/cifs/connect.c                                  |  22 ++-
 fs/cifs/transport.c                                |   6 +-
 fs/ext4/extents.c                                  |   4 +
 fs/ext4/ialloc.c                                   |   2 +-
 fs/ext4/mballoc.c                                  |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c                      |  35 +++--
 fs/xfs/xfs_inode.c                                 |  36 ++---
 include/linux/inetdevice.h                         |   9 ++
 include/linux/kvm_host.h                           |   2 +
 include/linux/netdevice.h                          |   8 -
 include/linux/serial_core.h                        |  17 +++
 include/net/bond_3ad.h                             |   2 -
 include/net/bonding.h                              |   3 +
 kernel/workqueue.c                                 |   6 +-
 mm/slub.c                                          |   5 +-
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/core/dev_ioctl.c                               |  43 ++----
 net/core/flow_dissector.c                          |  21 ++-
 net/ipv4/devinet.c                                 |   4 +-
 net/netfilter/nf_conntrack_irc.c                   |  34 ++++-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/netfilter/nfnetlink_osf.c                      |   4 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/sch_taprio.c                             |  18 ++-
 net/smc/smc_core.c                                 |   5 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |  32 +++-
 tools/perf/util/genelf.c                           |  14 ++
 tools/perf/util/genelf.h                           |   4 +
 tools/perf/util/symbol-elf.c                       |   7 +-
 tools/testing/selftests/net/forwarding/sch_red.sh  |   1 +
 virt/kvm/kvm_main.c                                |  16 +-
 127 files changed, 1196 insertions(+), 703 deletions(-)


