Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D541531723
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbiEWRIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239578AbiEWRHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:07:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C3D6B0B3;
        Mon, 23 May 2022 10:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDD00614CB;
        Mon, 23 May 2022 17:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6327CC385A9;
        Mon, 23 May 2022 17:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325643;
        bh=b0pqmH4BTEQvIXGxkdMwSNODEzX22pYBwnBtIi0Maf0=;
        h=From:To:Cc:Subject:Date:From;
        b=McijuBEoTQmOPVQGhnOxQyn+mGcAOT0k0Y5mICyc7NP3EJn+p83UiJ8VD1tGY3vJP
         HCG0tRNVzGrF3ISIT5zHWeLnRZ+inrKppW2QNoVrPu+cizB2IPVdRzRKNEpT3PdRO/
         J8JEobqRWZuHoX4U7BX4pK01HdcDuqcLdMAbwPVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/132] 5.15.42-rc1 review
Date:   Mon, 23 May 2022 19:03:29 +0200
Message-Id: <20220523165823.492309987@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.42-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.42-rc1
X-KernelTest-Deadline: 2022-05-25T16:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.42 release.
There are 132 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.42-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.42-rc1

David Howells <dhowells@redhat.com>
    afs: Fix afs_getattr() to refetch file status if callback break occurred

Yang Yingliang <yangyingliang@huawei.com>
    i2c: mt7621: fix missing clk_disable_unprepare() on error in mtk_i2c_probe()

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921e: fix possible probe failure after reboot

Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
    dt-bindings: pinctrl: aspeed-g6: remove FWQSPID group

Marek Vasut <marex@denx.de>
    Input: ili210x - fix reset timing

Shreyas K K <quic_shrekk@quicinc.com>
    arm64: Enable repeat tlbi workaround on KRYO4XX gold CPUs

Grant Grundler <grundler@chromium.org>
    net: atlantic: verify hw_head_ lies within TX buffer ring

Grant Grundler <grundler@chromium.org>
    net: atlantic: add check for MAX_SKB_FRAGS

Grant Grundler <grundler@chromium.org>
    net: atlantic: reduce scope of is_rsc_complete

Grant Grundler <grundler@chromium.org>
    net: atlantic: fix "frag[0] not initialized"

Yang Yingliang <yangyingliang@huawei.com>
    net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()

Yang Yingliang <yangyingliang@huawei.com>
    ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix locking in nl80211_set_tx_bitrate_mask()

Lina Wang <lina.wang@mediatek.com>
    net: fix wrong network header length

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbdev: Prevent possible use-after-free in fb_release()

Javier Martinez Canillas <javierm@redhat.com>
    Revert "fbdev: Make fb_release() return -ENODEV if fbdev was unregistered"

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    selftests: add ping test with ping_group_range tuned

Kieran Frewen <kieran.frewen@morsemicro.com>
    nl80211: validate S1G channel width

Felix Fietkau <nbd@nbd.name>
    mac80211: fix rx reordering with non explicit / psmp ack policy

Gleb Chesnokov <Chesnokov.G@raidix.com>
    scsi: qla2xxx: Fix missed DMA unmap for aborted commands

Brian Bunker <brian@purestorage.com>
    scsi: scsi_dh_alua: Properly handle the ALUA transitioning state

Thomas Richter <tmricht@linux.ibm.com>
    perf bench numa: Address compiler error on s390

Kan Liang <kan.liang@linux.intel.com>
    perf regs x86: Fix arch__intr_reg_mask() for the hybrid platform

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    gpio: mvebu/pwm: Refuse requests with inverted polarity

Haibo Chen <haibo.chen@nxp.com>
    gpio: gpio-vf610: do not touch other bits when set the target bit

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Fix check for btf__load_from_kernel_by_id() in libbpf

Daejun Park <daejun7.park@samsung.com>
    scsi: ufs: core: Fix referencing invalid rsp field

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    riscv: dts: sifive: fu540-c000: align dma node name with dtschema

Andrew Lunn <andrew@lunn.ch>
    net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.

Ritaro Takenaka <ritarot634@gmail.com>
    netfilter: flowtable: move dst_check to packet path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: pass flowtable to nf_flow_table_iterate()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: fix TCP flow teardown

Kevin Mitchell <kevmitch@arista.com>
    igb: skip phy status check where unavailable

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: Do TCP fallback on early DSS checksum failure

Paolo Abeni <pabeni@redhat.com>
    mptcp: strict local address ID selection

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix checksum byte order

Geliang Tang <geliang.tang@suse.com>
    mptcp: reuse __mptcp_make_csum in validate_data_csum

Geliang Tang <geliang.tang@suse.com>
    mptcp: change the parameter of __mptcp_make_csum

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9197/1: spectre-bhb: fix loop8 sequence for Thumb2

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9196/1: spectre-bhb: enable for Cortex-A15

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: af_key: add check for pfkey_broadcast in function pfkey_process

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Properly block LRO when XDP is enabled

Maor Dickman <maord@nvidia.com>
    net/mlx5: DR, Fix missing flow_source when creating multi-destination FW table

Duoming Zhou <duoming@zju.edu.cn>
    NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net/qla3xxx: Fix a test in ql_reset_work()

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    clk: at91: generated: consider range when calculating best rate

Michal Wilczynski <michal.wilczynski@intel.com>
    ice: Fix interrupt moderation settings getting cleared

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: move ice_container_type onto ice_ring_container

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix possible under reporting of ethtool Tx and Rx statistics

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    ice: fix crash when writing timestamp on RX rings

Zixuan Fu <r33s3n6@gmail.com>
    net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

Zixuan Fu <r33s3n6@gmail.com>
    net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: systemport: Fix an error handling path in bcm_sysport_probe()

Pali Rohár <pali@kernel.org>
    Revert "PCI: aardvark: Rewrite IRQ code to chained IRQ handler"

Felix Fietkau <nbd@nbd.name>
    netfilter: nft_flow_offload: fix offload with pppoe + vlan

Felix Fietkau <nbd@nbd.name>
    net: fix dev_fill_forward_path with pppoe + bridge

Felix Fietkau <nbd@nbd.name>
    netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices

Felix Fietkau <nbd@nbd.name>
    netfilter: flowtable: fix excessive hw offload attempts after failure

Paolo Abeni <pabeni@redhat.com>
    net/sched: act_pedit: sanitize shift argument before usage

Eyal Birger <eyal.birger@gmail.com>
    xfrm: fix "disable_policy" flag use when arriving from different devices

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: rework default policy structure

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Increment rx bd head after allocating skb and buffer

Alex Elder <elder@linaro.org>
    net: ipa: record proper RX transaction count

Randy Dunlap <rdunlap@infradead.org>
    ALSA: hda - fix unused Realtek function when PM is not enabled

Mattijs Korpershoek <mkorpershoek@baylibre.com>
    pinctrl: mediatek: mt8365: fix IES control pins

Howard Chiu <howard_chiu@aspeedtech.com>
    ARM: dts: aspeed: Add video engine to g6

Joel Stanley <joel@jms.id.au>
    ARM: dts: aspeed: Add secure boot controller node

Eddie James <eajames@linux.ibm.com>
    ARM: dts: aspeed: Add ADC for AST2600 and enable for Rainier and Everest

Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
    ARM: dts: aspeed-g6: fix SPI1/SPI2 quad pin group

Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
    pinctrl: pinctrl-aspeed-g6: remove FWQSPID group in pinctrl

Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
    ARM: dts: aspeed-g6: remove FWQSPID group in pinctrl dtsi

Charan Teja Kalla <quic_charante@quicinc.com>
    dma-buf: ensure unique directory name for dmabuf stats

Jérôme Pouiller <jerome.pouiller@silabs.com>
    dma-buf: fix use of DMA_BUF_SET_NAME_{A,B} in userspace

Hangyu Hua <hbh25y@gmail.com>
    drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

Anusha Srivatsa <anusha.srivatsa@intel.com>
    drm/i915/dmc: Add MMIO range restrictions

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Don't reset dGPUs if the system is going to s2idle

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix potential use-after-free on linger ping and resends

Ondrej Mosnacek <omosnace@redhat.com>
    crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Ensure the cleared tags are visible before setting the PTE

Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>
    arm64: paravirt: Use RCU read locks to guard stolen_time

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Update number of zapped pages even if page list is stable

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    Revert "can: m_can: pci: use custom bit timings for Elkhart Lake"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold

Al Viro <viro@zeniv.linux.org.uk>
    Fix double fget() in vhost_net_set_backend()

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix bad cleanup on error in hashtab_duplicate()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix sys_perf_event_open() race against self

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for TongFang devices with pop noise

Takashi Iwai <tiwai@suse.de>
    ALSA: wavefront: Proper check of get_user() error

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Restore Rane SL-1 quirk

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix lockdep warnings during disk space reclamation

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix lockdep warnings in page operations for btree nodes

linyujun <linyujun809@huawei.com>
    ARM: 9191/1: arm/stacktrace, kasan: Silence KASAN warnings in unwind_frame()

Tzung-Bi Shih <tzungbi@google.com>
    platform/chrome: cros_ec_debugfs: detach log reader wq from devm

Jakob Koschel <jakobkoschel@gmail.com>
    drbd: remove usage of list iterator variable after loop

Xiaoke Wang <xkernel.wang@foxmail.com>
    MIPS: lantiq: check the return value of kzalloc()

Guo Xuenan <guoxuenan@huawei.com>
    fs: fix an infinite loop in iomap_fiemap

Mario Limonciello <mario.limonciello@amd.com>
    rtc: mc146818-lib: Fix the AltCentury for AMD platforms

Anton Eidelman <anton.eidelman@gmail.com>
    nvme-multipath: fix hang when disk goes live over reconnect

Sagi Grimberg <sagi@grimberg.me>
    nvmet: use a private workqueue instead of the system workqueue

Michael S. Tsirkin <mst@redhat.com>
    tools/virtio: compile with -pthread

Zhu Lingshan <lingshan.zhu@intel.com>
    vhost_vdpa: don't setup irq offloading when irq_num < 0

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: improve zpci_dev reference counting

Heiko Carstens <hca@linux.ibm.com>
    s390/traps: improve panic message for translation-specification exception

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Enable headset mic on Lenovo P360

Peter Zijlstra <peterz@infradead.org>
    crypto: x86/chacha20 - Avoid spurious jumps to other functions

Zheng Yongjun <zhengyongjun3@huawei.com>
    crypto: stm32 - fix reference leak in stm32_crc_remove

Andre Przywara <andre.przywara@arm.com>
    rtc: sun6i: Fix time overflow handling

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Disable page faults during lockless buffered reads

Monish Kumar R <monish.kumar.r@intel.com>
    nvme-pci: add quirks for Samsung X5 SSDs

Zheng Yongjun <zhengyongjun3@huawei.com>
    Input: stmfts - fix reference leak in stmfts_input_open

Jeff LaBundy <jeff@labundy.com>
    Input: add bounds checking to input_set_capability()

David Gow <davidgow@google.com>
    um: Cleanup syscall_handler_t definition/cast, fix warning

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    rtc: pcf2127: fix bug when reading alarm registers

Vincent Whitchurch <vincent.whitchurch@axis.com>
    rtc: fix use-after-free on device removal

Greg Thelen <gthelen@google.com>
    Revert "drm/i915/opregion: check port number bounds for SWSCI display power state"

Hyeonggon Yoo <42.hyeyoo@gmail.com>
    mm/kfence: reset PG_slab and memcg_data before freeing __kfence_pool

Terry Bowman <terry.bowman@amd.com>
    Watchdog: sp5100_tco: Enable Family 17h+ CPUs

Terry Bowman <terry.bowman@amd.com>
    Watchdog: sp5100_tco: Add initialization using EFCH MMIO

Terry Bowman <terry.bowman@amd.com>
    Watchdog: sp5100_tco: Refactor MMIO base address initialization

Terry Bowman <terry.bowman@amd.com>
    Watchdog: sp5100_tco: Move timer initialization into function

Terry Bowman <terry.bowman@amd.com>
    i2c: piix4: Enable EFCH MMIO for Family 17h+

Terry Bowman <terry.bowman@amd.com>
    i2c: piix4: Add EFCH MMIO support for SMBus port select

Terry Bowman <terry.bowman@amd.com>
    i2c: piix4: Add EFCH MMIO support to SMBus base address detect

Terry Bowman <terry.bowman@amd.com>
    i2c: piix4: Add EFCH MMIO support to region request and release

Terry Bowman <terry.bowman@amd.com>
    i2c: piix4: Move SMBus port selection into function

Terry Bowman <terry.bowman@amd.com>
    i2c: piix4: Move SMBus controller base address detect into function

Terry Bowman <terry.bowman@amd.com>
    i2c: piix4: Move port I/O region request/release code into functions

Terry Bowman <terry.bowman@amd.com>
    i2c: piix4: Replace hardcoded memory map size with a #define

Terry Bowman <terry.bowman@amd.com>
    kernel/resource: Introduce request_mem_region_muxed()

Willy Tarreau <w@1wt.eu>
    floppy: use a statically allocated error counter

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: arm poll for non-nowait files

Schspa Shi <schspa@gmail.com>
    usb: gadget: fix race when gadget driver register via ioctl


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst             |   3 +
 .../bindings/pinctrl/aspeed,ast2600-pinctrl.yaml   |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts       |  15 +
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts       |  15 +
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi           |   9 +-
 arch/arm/boot/dts/aspeed-g6.dtsi                   |  35 +++
 arch/arm/kernel/entry-armv.S                       |   2 +-
 arch/arm/kernel/stacktrace.c                       |  10 +-
 arch/arm/mm/proc-v7-bugs.c                         |   1 +
 arch/arm64/kernel/cpu_errata.c                     |   2 +
 arch/arm64/kernel/mte.c                            |   3 +
 arch/arm64/kernel/paravirt.c                       |  29 +-
 arch/mips/lantiq/falcon/sysctrl.c                  |   2 +
 arch/mips/lantiq/xway/gptu.c                       |   2 +
 arch/mips/lantiq/xway/sysctrl.c                    |  46 ++-
 arch/riscv/boot/dts/sifive/fu540-c000.dtsi         |   2 +-
 arch/s390/kernel/traps.c                           |   6 +-
 arch/s390/pci/pci.c                                |   1 +
 arch/s390/pci/pci_bus.h                            |   3 +-
 arch/s390/pci/pci_clp.c                            |   9 +-
 arch/s390/pci/pci_event.c                          |   7 +-
 arch/x86/crypto/chacha-avx512vl-x86_64.S           |   4 +-
 arch/x86/kvm/mmu/mmu.c                             |  10 +-
 arch/x86/um/shared/sysdep/syscalls_64.h            |   5 +-
 drivers/block/drbd/drbd_main.c                     |   7 +-
 drivers/block/floppy.c                             |  18 +-
 drivers/clk/at91/clk-generated.c                   |   4 +
 drivers/crypto/qcom-rng.c                          |   1 +
 drivers/crypto/stm32/stm32-crc32.c                 |   4 +-
 drivers/dma-buf/dma-buf.c                          |   8 +
 drivers/gpio/gpio-mvebu.c                          |   3 +
 drivers/gpio/gpio-vf610.c                          |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  14 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   1 +
 drivers/gpu/drm/i915/display/intel_dmc.c           |  44 +++
 drivers/gpu/drm/i915/display/intel_opregion.c      |  15 -
 drivers/gpu/drm/i915/i915_reg.h                    |  16 +
 drivers/i2c/busses/i2c-mt7621.c                    |  10 +-
 drivers/i2c/busses/i2c-piix4.c                     | 213 ++++++++++---
 drivers/input/input.c                              |  19 ++
 drivers/input/touchscreen/ili210x.c                |   4 +-
 drivers/input/touchscreen/stmfts.c                 |   8 +-
 drivers/net/can/m_can/m_can_pci.c                  |  48 +--
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  20 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   7 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   6 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |   5 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  38 +--
 drivers/net/ethernet/intel/ice/ice_lib.c           |  16 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   7 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  19 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |  17 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 +
 .../mellanox/mlx5/core/steering/dr_action.c        |   6 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |   4 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   3 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   3 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   4 +-
 drivers/net/ipa/gsi.c                              |   6 +-
 drivers/net/ppp/pppoe.c                            |   1 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   6 +
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    | 115 -------
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  20 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    | 121 ++++++++
 drivers/nvme/host/core.c                           |   1 +
 drivers/nvme/host/multipath.c                      |  25 +-
 drivers/nvme/host/nvme.h                           |   4 +
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/nvme/target/admin-cmd.c                    |   2 +-
 drivers/nvme/target/configfs.c                     |   2 +-
 drivers/nvme/target/core.c                         |  24 +-
 drivers/nvme/target/fc.c                           |   8 +-
 drivers/nvme/target/fcloop.c                       |  16 +-
 drivers/nvme/target/io-cmd-file.c                  |   6 +-
 drivers/nvme/target/loop.c                         |   4 +-
 drivers/nvme/target/nvmet.h                        |   1 +
 drivers/nvme/target/passthru.c                     |   2 +-
 drivers/nvme/target/rdma.c                         |  12 +-
 drivers/nvme/target/tcp.c                          |  10 +-
 drivers/pci/controller/pci-aardvark.c              |  48 ++-
 drivers/pci/pci.c                                  |  10 +
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c         |  14 +-
 drivers/pinctrl/mediatek/pinctrl-mt8365.c          |   2 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |  12 +-
 drivers/rtc/class.c                                |   9 +
 drivers/rtc/rtc-mc146818-lib.c                     |  16 +-
 drivers/rtc/rtc-pcf2127.c                          |   3 +-
 drivers/rtc/rtc-sun6i.c                            |  14 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   3 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   3 +
 drivers/scsi/ufs/ufshpb.c                          |  19 +-
 drivers/usb/gadget/legacy/raw_gadget.c             |   2 +
 drivers/vhost/net.c                                |  15 +-
 drivers/vhost/vdpa.c                               |   5 +-
 drivers/video/fbdev/core/fbmem.c                   |   5 +-
 drivers/video/fbdev/core/fbsysfs.c                 |   4 +
 drivers/watchdog/sp5100_tco.c                      | 334 ++++++++++++++-------
 drivers/watchdog/sp5100_tco.h                      |   7 +
 fs/afs/inode.c                                     |  14 +-
 fs/gfs2/file.c                                     |   4 +-
 fs/io_uring.c                                      |   7 -
 fs/ioctl.c                                         |   2 +-
 fs/nilfs2/btnode.c                                 |  23 +-
 fs/nilfs2/btnode.h                                 |   1 +
 fs/nilfs2/btree.c                                  |  27 +-
 fs/nilfs2/dat.c                                    |   4 +-
 fs/nilfs2/gcinode.c                                |   7 +-
 fs/nilfs2/inode.c                                  | 159 +++++++++-
 fs/nilfs2/mdt.c                                    |  43 ++-
 fs/nilfs2/mdt.h                                    |   6 +-
 fs/nilfs2/nilfs.h                                  |  16 +-
 fs/nilfs2/page.c                                   |   7 +-
 fs/nilfs2/segment.c                                |   9 +-
 fs/nilfs2/super.c                                  |   5 +-
 include/linux/ceph/osd_client.h                    |   3 +
 include/linux/ioport.h                             |   2 +
 include/linux/mc146818rtc.h                        |   2 +
 include/linux/netdevice.h                          |   2 +-
 include/net/ip.h                                   |   1 +
 include/net/netns/xfrm.h                           |   6 +-
 include/net/xfrm.h                                 |  58 ++--
 include/uapi/linux/dma-buf.h                       |   4 +-
 kernel/events/core.c                               |  14 +
 mm/kfence/core.c                                   |  11 +
 net/bridge/br_input.c                              |   7 +
 net/ceph/osd_client.c                              | 302 ++++++++-----------
 net/core/dev.c                                     |   2 +-
 net/core/skbuff.c                                  |   4 +-
 net/ipv4/route.c                                   |  23 +-
 net/key/af_key.c                                   |   6 +-
 net/mac80211/rx.c                                  |   3 +-
 net/mptcp/options.c                                |  40 ++-
 net/mptcp/pm_netlink.c                             |  13 -
 net/mptcp/protocol.c                               |   3 +
 net/mptcp/protocol.h                               |   5 +-
 net/mptcp/subflow.c                                | 103 +++++--
 net/netfilter/nf_flow_table_core.c                 |  80 ++---
 net/netfilter/nf_flow_table_ip.c                   |  19 ++
 net/netfilter/nft_flow_offload.c                   |  28 +-
 net/nfc/nci/data.c                                 |   2 +-
 net/nfc/nci/hci.c                                  |   4 +-
 net/sched/act_pedit.c                              |   4 +
 net/wireless/nl80211.c                             |  18 +-
 net/xfrm/xfrm_policy.c                             |  10 +-
 net/xfrm/xfrm_user.c                               |  43 ++-
 security/selinux/ss/hashtab.c                      |   3 +-
 sound/isa/wavefront/wavefront_synth.c              |   3 +-
 sound/pci/hda/patch_realtek.c                      |  17 +-
 sound/usb/quirks-table.h                           |   9 +
 tools/build/Makefile.feature                       |   1 +
 tools/build/feature/Makefile                       |   4 +
 .../test-libbpf-btf__load_from_kernel_by_id.c      |   7 +
 tools/perf/Makefile.config                         |   7 +
 tools/perf/arch/x86/util/perf_regs.c               |  12 +
 tools/perf/bench/numa.c                            |   2 +-
 tools/perf/util/bpf-event.c                        |   4 +-
 tools/testing/selftests/net/fcnal-test.sh          |  12 +
 tools/virtio/Makefile                              |   3 +-
 166 files changed, 1925 insertions(+), 1083 deletions(-)


