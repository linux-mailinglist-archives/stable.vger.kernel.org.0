Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF847531D0E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbiEWRIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239574AbiEWRHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:07:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D5B6B081;
        Mon, 23 May 2022 10:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7FF4B811F3;
        Mon, 23 May 2022 17:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24439C385A9;
        Mon, 23 May 2022 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325636;
        bh=F+sWX1baTJCgczaYKPpOKB7mc581bu3517lILKKxZf0=;
        h=From:To:Cc:Subject:Date:From;
        b=qxY3yIKrcNYsOhMUhZ3h8ah2uockchnu52X1lBY6o1q2hTJkXauY8teTbWvvKOVJA
         UWLhRf2iiqxUgw5bab6RoYbq5zYsTy7oGJtjNZUhmxUgqM2MwCBc6DrEUNNngVZ1bd
         efwebo9d6kuxO5omG+oKQDbiykDtDqHMbPdw7MEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/97] 5.10.118-rc1 review
Date:   Mon, 23 May 2022 19:05:04 +0200
Message-Id: <20220523165812.244140613@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.118-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.118-rc1
X-KernelTest-Deadline: 2022-05-25T17:01+00:00
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

This is the start of the stable review cycle for the 5.10.118 release.
There are 97 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.118-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.118-rc1

Jessica Yu <jeyu@kernel.org>
    module: check for exit sections in layout_sections() instead of module_init_section()

Eugene Syromiatnikov <esyr@redhat.com>
    include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage

David Howells <dhowells@redhat.com>
    afs: Fix afs_getattr() to refetch file status if callback break occurred

Yang Yingliang <yangyingliang@huawei.com>
    i2c: mt7621: fix missing clk_disable_unprepare() on error in mtk_i2c_probe()

Jessica Yu <jeyu@kernel.org>
    module: treat exit sections the same as init sections when !CONFIG_MODULE_UNLOAD

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

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    selftests: add ping test with ping_group_range tuned

Kieran Frewen <kieran.frewen@morsemicro.com>
    nl80211: validate S1G channel width

Felix Fietkau <nbd@nbd.name>
    mac80211: fix rx reordering with non explicit / psmp ack policy

Gleb Chesnokov <Chesnokov.G@raidix.com>
    scsi: qla2xxx: Fix missed DMA unmap for aborted commands

Thomas Richter <tmricht@linux.ibm.com>
    perf bench numa: Address compiler error on s390

Kan Liang <kan.liang@linux.intel.com>
    perf regs x86: Fix arch__intr_reg_mask() for the hybrid platform

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    gpio: mvebu/pwm: Refuse requests with inverted polarity

Haibo Chen <haibo.chen@nxp.com>
    gpio: gpio-vf610: do not touch other bits when set the target bit

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    riscv: dts: sifive: fu540-c000: align dma node name with dtschema

Andrew Lunn <andrew@lunn.ch>
    net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.

Kevin Mitchell <kevmitch@arista.com>
    igb: skip phy status check where unavailable

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9197/1: spectre-bhb: fix loop8 sequence for Thumb2

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9196/1: spectre-bhb: enable for Cortex-A15

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: af_key: add check for pfkey_broadcast in function pfkey_process

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Properly block LRO when XDP is enabled

Duoming Zhou <duoming@zju.edu.cn>
    NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net/qla3xxx: Fix a test in ql_reset_work()

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    clk: at91: generated: consider range when calculating best rate

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix possible under reporting of ethtool Tx and Rx statistics

Zixuan Fu <r33s3n6@gmail.com>
    net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()

Zixuan Fu <r33s3n6@gmail.com>
    net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: systemport: Fix an error handling path in bcm_sysport_probe()

Paolo Abeni <pabeni@redhat.com>
    net/sched: act_pedit: sanitize shift argument before usage

Eyal Birger <eyal.birger@gmail.com>
    xfrm: fix "disable_policy" flag use when arriving from different devices

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: rework default policy structure

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: fix dflt policy check when there is no policy configured

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: notify default policy on update

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm: make user policy API complete

Pavel Skripkin <paskripkin@gmail.com>
    net: xfrm: fix shift-out-of-bounce

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Add possibility to set the default to block if we have no policy

Vincent Bernat <vincent@bernat.ch>
    net: evaluate net.ipvX.conf.all.disable_policy and disable_xfrm

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Increment rx bd head after allocating skb and buffer

Alex Elder <elder@linaro.org>
    net: ipa: record proper RX transaction count

Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
    ARM: dts: aspeed-g6: fix SPI1/SPI2 quad pin group

Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
    pinctrl: pinctrl-aspeed-g6: remove FWQSPID group in pinctrl

Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
    ARM: dts: aspeed-g6: remove FWQSPID group in pinctrl dtsi

Jérôme Pouiller <jerome.pouiller@silabs.com>
    dma-buf: fix use of DMA_BUF_SET_NAME_{A,B} in userspace

Hangyu Hua <hbh25y@gmail.com>
    drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

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

Linus Torvalds <torvalds@linux-foundation.org>
    Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""

Sasha Levin <sashal@kernel.org>
    Revert "swiotlb: fix info leak with DMA_FROM_DEVICE"

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

Michael S. Tsirkin <mst@redhat.com>
    tools/virtio: compile with -pthread

Zhu Lingshan <lingshan.zhu@intel.com>
    vhost_vdpa: don't setup irq offloading when irq_num < 0

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: improve zpci_dev reference counting

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

Sasha Neftin <sasha.neftin@intel.com>
    igc: Update I226_K device ID

Sasha Neftin <sasha.neftin@intel.com>
    igc: Remove phy->type checking

Sasha Neftin <sasha.neftin@intel.com>
    igc: Remove _I_PHY_ID checking

Greg Thelen <gthelen@google.com>
    Revert "drm/i915/opregion: check port number bounds for SWSCI display power state"

Willy Tarreau <w@1wt.eu>
    floppy: use a statically allocated error counter

Jens Axboe <axboe@kernel.dk>
    io_uring: always grab file table for deferred statx

Schspa Shi <schspa@gmail.com>
    usb: gadget: fix race when gadget driver register via ioctl


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst             |   3 +
 Documentation/core-api/dma-attributes.rst          |   8 -
 .../bindings/pinctrl/aspeed,ast2600-pinctrl.yaml   |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi           |   9 +-
 arch/arm/kernel/entry-armv.S                       |   2 +-
 arch/arm/kernel/stacktrace.c                       |  10 +-
 arch/arm/mm/proc-v7-bugs.c                         |   1 +
 arch/arm64/kernel/cpu_errata.c                     |   2 +
 arch/arm64/kernel/mte.c                            |   3 +
 arch/arm64/kernel/paravirt.c                       |  29 +-
 arch/mips/lantiq/falcon/sysctrl.c                  |   2 +
 arch/mips/lantiq/xway/gptu.c                       |   2 +
 arch/mips/lantiq/xway/sysctrl.c                    |  46 ++--
 arch/riscv/boot/dts/sifive/fu540-c000.dtsi         |   2 +-
 arch/s390/pci/pci.c                                |   1 +
 arch/s390/pci/pci_bus.h                            |   3 +-
 arch/s390/pci/pci_clp.c                            |   9 +-
 arch/s390/pci/pci_event.c                          |   7 +-
 arch/x86/crypto/chacha-avx512vl-x86_64.S           |   4 +-
 arch/x86/kvm/mmu/mmu.c                             |  10 +-
 arch/x86/um/shared/sysdep/syscalls_64.h            |   5 +-
 drivers/block/drbd/drbd_main.c                     |   7 +-
 drivers/block/floppy.c                             |  20 +-
 drivers/clk/at91/clk-generated.c                   |   4 +
 drivers/crypto/qcom-rng.c                          |   1 +
 drivers/crypto/stm32/stm32-crc32.c                 |   4 +-
 drivers/gpio/gpio-mvebu.c                          |   3 +
 drivers/gpio/gpio-vf610.c                          |   8 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   1 +
 drivers/gpu/drm/i915/display/intel_opregion.c      |  15 -
 drivers/i2c/busses/i2c-mt7621.c                    |  10 +-
 drivers/input/input.c                              |  19 ++
 drivers/input/touchscreen/ili210x.c                |   4 +-
 drivers/input/touchscreen/stmfts.c                 |   8 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  20 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   7 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   6 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   7 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +-
 drivers/net/ethernet/intel/igc/igc_base.c          |  10 +-
 drivers/net/ethernet/intel/igc/igc_hw.h            |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  18 +-
 drivers/net/ethernet/intel/igc/igc_phy.c           |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   4 +-
 drivers/net/ipa/gsi.c                              |   6 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   6 +
 drivers/nvme/host/core.c                           |   1 +
 drivers/nvme/host/multipath.c                      |  25 +-
 drivers/nvme/host/nvme.h                           |   4 +
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/pci/pci.c                                  |  10 +
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c         |  14 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |  12 +-
 drivers/rtc/class.c                                |   9 +
 drivers/rtc/rtc-mc146818-lib.c                     |  16 +-
 drivers/rtc/rtc-pcf2127.c                          |   3 +-
 drivers/rtc/rtc-sun6i.c                            |  14 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   3 +
 drivers/usb/gadget/legacy/raw_gadget.c             |   2 +
 drivers/vhost/net.c                                |  15 +-
 drivers/vhost/vdpa.c                               |   5 +-
 fs/afs/inode.c                                     |  14 +-
 fs/gfs2/file.c                                     |   4 +-
 fs/io_uring.c                                      |   6 +-
 fs/ioctl.c                                         |   2 +-
 fs/nilfs2/btnode.c                                 |  23 +-
 fs/nilfs2/btnode.h                                 |   1 +
 fs/nilfs2/btree.c                                  |  27 +-
 fs/nilfs2/dat.c                                    |   4 +-
 fs/nilfs2/gcinode.c                                |   7 +-
 fs/nilfs2/inode.c                                  | 159 ++++++++++-
 fs/nilfs2/mdt.c                                    |  43 ++-
 fs/nilfs2/mdt.h                                    |   6 +-
 fs/nilfs2/nilfs.h                                  |  16 +-
 fs/nilfs2/page.c                                   |   7 +-
 fs/nilfs2/segment.c                                |   9 +-
 fs/nilfs2/super.c                                  |   5 +-
 include/linux/ceph/osd_client.h                    |   3 +
 include/linux/dma-mapping.h                        |   8 -
 include/linux/mc146818rtc.h                        |   2 +
 include/net/ip.h                                   |   1 +
 include/net/netns/xfrm.h                           |   3 +
 include/net/xfrm.h                                 |  36 ++-
 include/uapi/linux/dma-buf.h                       |   4 +-
 include/uapi/linux/xfrm.h                          |  14 +
 kernel/dma/swiotlb.c                               |  12 +-
 kernel/events/core.c                               |  14 +
 kernel/module.c                                    |  18 +-
 net/bridge/br_input.c                              |   7 +
 net/ceph/osd_client.c                              | 302 ++++++++-------------
 net/ipv4/route.c                                   |  29 +-
 net/key/af_key.c                                   |   6 +-
 net/mac80211/rx.c                                  |   3 +-
 net/nfc/nci/data.c                                 |   2 +-
 net/nfc/nci/hci.c                                  |   4 +-
 net/sched/act_pedit.c                              |   4 +
 net/wireless/nl80211.c                             |  18 +-
 net/xfrm/xfrm_policy.c                             |  20 ++
 net/xfrm/xfrm_user.c                               |  88 ++++++
 security/selinux/nlmsgtab.c                        |   4 +-
 security/selinux/ss/hashtab.c                      |   3 +-
 sound/isa/wavefront/wavefront_synth.c              |   3 +-
 sound/pci/hda/patch_realtek.c                      |   9 +
 sound/usb/quirks-table.h                           |   9 +
 tools/perf/arch/x86/util/perf_regs.c               |  12 +
 tools/perf/bench/numa.c                            |   2 +-
 tools/testing/selftests/net/fcnal-test.sh          |  12 +
 tools/virtio/Makefile                              |   3 +-
 113 files changed, 1010 insertions(+), 495 deletions(-)


