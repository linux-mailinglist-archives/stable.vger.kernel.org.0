Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50B5531A34
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbiEWRHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239552AbiEWRHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:07:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E7B6AA4E;
        Mon, 23 May 2022 10:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8916DB811F8;
        Mon, 23 May 2022 17:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99661C385A9;
        Mon, 23 May 2022 17:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325630;
        bh=lpud0YoSIFzb5VEeZIOD/hyl1cdNw0K79PgKuahr3DY=;
        h=From:To:Cc:Subject:Date:From;
        b=DTBaw53Jp7yPBM9feMkK+bpz4BbNIRJfU0Hd8+Z5x0ROxN4EA46dFoz9sb7xBcX/7
         WV1Y+RtvFl0toe7WOq0FoC9lbqhVrjqgNeaOQnkpsIEw+RFS9xZGy0r5vZ8vfe6Crc
         CfS4iTdsagbPyfCjdLGHZA8xCMllkwP5TdnsleUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/68] 5.4.196-rc1 review
Date:   Mon, 23 May 2022 19:04:27 +0200
Message-Id: <20220523165802.500642349@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.196-rc1
X-KernelTest-Deadline: 2022-05-25T17:03+00:00
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

This is the start of the stable review cycle for the 5.4.196 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.196-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.196-rc1

David Howells <dhowells@redhat.com>
    afs: Fix afs_getattr() to refetch file status if callback break occurred

Yang Yingliang <yangyingliang@huawei.com>
    i2c: mt7621: fix missing clk_disable_unprepare() on error in mtk_i2c_probe()

Peter Zijlstra <peterz@infradead.org>
    x86/xen: Mark cpu_bringup_and_idle() as dead_end_function

Juergen Gross <jgross@suse.com>
    x86/xen: fix booting 32-bit pv guest

Linus Torvalds <torvalds@linux-foundation.org>
    Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""

Abel Vesa <abel.vesa@nxp.com>
    ARM: dts: imx7: Use audio_mclk_post_div instead audio_mclk_root_clk

Thiébaud Weksteen <tweek@google.com>
    firmware_loader: use kernel credentials when reading firmware

Tan Tee Min <tee.min.tan@linux.intel.com>
    net: stmmac: disable Split Header (SPH) for Intel platforms

Ming Lei <ming.lei@redhat.com>
    block: return ELEVATOR_DISCARD_MERGE if possible

Marek Vasut <marex@denx.de>
    Input: ili210x - fix reset timing

Grant Grundler <grundler@chromium.org>
    net: atlantic: verify hw_head_ lies within TX buffer ring

Yang Yingliang <yangyingliang@huawei.com>
    net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()

Yang Yingliang <yangyingliang@huawei.com>
    ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    selftests: add ping test with ping_group_range tuned

Felix Fietkau <nbd@nbd.name>
    mac80211: fix rx reordering with non explicit / psmp ack policy

Gleb Chesnokov <Chesnokov.G@raidix.com>
    scsi: qla2xxx: Fix missed DMA unmap for aborted commands

Thomas Richter <tmricht@linux.ibm.com>
    perf bench numa: Address compiler error on s390

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    gpio: mvebu/pwm: Refuse requests with inverted polarity

Haibo Chen <haibo.chen@nxp.com>
    gpio: gpio-vf610: do not touch other bits when set the target bit

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

Paolo Abeni <pabeni@redhat.com>
    net/sched: act_pedit: sanitize shift argument before usage

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Increment rx bd head after allocating skb and buffer

Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
    ARM: dts: aspeed-g6: fix SPI1/SPI2 quad pin group

Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
    ARM: dts: aspeed-g6: remove FWQSPID group in pinctrl dtsi

Jérôme Pouiller <jerome.pouiller@silabs.com>
    dma-buf: fix use of DMA_BUF_SET_NAME_{A,B} in userspace

Hangyu Hua <hbh25y@gmail.com>
    drm/dp/mst: fix a possible memory leak in fetch_monitor_name()

Ondrej Mosnacek <omosnace@redhat.com>
    crypto: qcom-rng - fix infinite loop on requests not multiple of WORD_SZ

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Update number of zapped pages even if page list is stable

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold

Al Viro <viro@zeniv.linux.org.uk>
    Fix double fget() in vhost_net_set_backend()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix sys_perf_event_open() race against self

Takashi Iwai <tiwai@suse.de>
    ALSA: wavefront: Proper check of get_user() error

Meena Shanmugam <meenashanmugam@google.com>
    SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

Meena Shanmugam <meenashanmugam@google.com>
    SUNRPC: Don't call connect() more than once on a TCP socket

Meena Shanmugam <meenashanmugam@google.com>
    SUNRPC: Prevent immediate close+reconnect

Meena Shanmugam <meenashanmugam@google.com>
    SUNRPC: Clean up scheduling of autoclose

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC

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

Mario Limonciello <mario.limonciello@amd.com>
    rtc: mc146818-lib: Fix the AltCentury for AMD platforms

Anton Eidelman <anton.eidelman@gmail.com>
    nvme-multipath: fix hang when disk goes live over reconnect

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Enable headset mic on Lenovo P360

Peter Zijlstra <peterz@infradead.org>
    crypto: x86/chacha20 - Avoid spurious jumps to other functions

Zheng Yongjun <zhengyongjun3@huawei.com>
    crypto: stm32 - fix reference leak in stm32_crc_remove

Zheng Yongjun <zhengyongjun3@huawei.com>
    Input: stmfts - fix reference leak in stmfts_input_open

Jeff LaBundy <jeff@labundy.com>
    Input: add bounds checking to input_set_capability()

David Gow <davidgow@google.com>
    um: Cleanup syscall_handler_t definition/cast, fix warning

Vincent Whitchurch <vincent.whitchurch@axis.com>
    rtc: fix use-after-free on device removal

Miroslav Benes <mbenes@suse.cz>
    x86/xen: Make the secondary CPU idle tasks reliable

Miroslav Benes <mbenes@suse.cz>
    x86/xen: Make the boot CPU idle task reliable

Willy Tarreau <w@1wt.eu>
    floppy: use a statically allocated error counter


-------------

Diffstat:

 Documentation/DMA-attributes.txt                   |  10 --
 Makefile                                           |   4 +-
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi           |   9 +-
 arch/arm/boot/dts/imx7-colibri.dtsi                |   4 +-
 arch/arm/boot/dts/imx7-mba7.dtsi                   |   2 +-
 arch/arm/boot/dts/imx7d-nitrogen7.dts              |   2 +-
 arch/arm/boot/dts/imx7d-pico-hobbit.dts            |   4 +-
 arch/arm/boot/dts/imx7d-pico-pi.dts                |   4 +-
 arch/arm/boot/dts/imx7d-sdb.dts                    |   2 +-
 arch/arm/boot/dts/imx7s-warp.dts                   |   4 +-
 arch/arm/kernel/entry-armv.S                       |   2 +-
 arch/arm/kernel/stacktrace.c                       |  10 +-
 arch/arm/mm/proc-v7-bugs.c                         |   1 +
 arch/mips/lantiq/falcon/sysctrl.c                  |   2 +
 arch/mips/lantiq/xway/gptu.c                       |   2 +
 arch/mips/lantiq/xway/sysctrl.c                    |  46 +++---
 arch/x86/crypto/chacha-avx512vl-x86_64.S           |   4 +-
 arch/x86/kvm/mmu.c                                 |  10 +-
 arch/x86/um/shared/sysdep/syscalls_64.h            |   5 +-
 arch/x86/xen/smp_pv.c                              |   3 +-
 arch/x86/xen/xen-head.S                            |  18 ++-
 block/bfq-iosched.c                                |   3 +
 block/blk-merge.c                                  |  15 --
 block/elevator.c                                   |   3 +
 block/mq-deadline.c                                |   2 +
 drivers/base/firmware_loader/main.c                |  17 +++
 drivers/block/drbd/drbd_main.c                     |   7 +-
 drivers/block/floppy.c                             |  20 ++-
 drivers/clk/at91/clk-generated.c                   |   4 +
 drivers/crypto/qcom-rng.c                          |   1 +
 drivers/crypto/stm32/stm32-crc32.c                 |   4 +-
 drivers/gpio/gpio-mvebu.c                          |   3 +
 drivers/gpio/gpio-vf610.c                          |   8 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   1 +
 drivers/i2c/busses/i2c-mt7621.c                    |  10 +-
 drivers/input/input.c                              |  19 +++
 drivers/input/touchscreen/ili210x.c                |   4 +-
 drivers/input/touchscreen/stmfts.c                 |   8 +-
 drivers/mmc/core/block.c                           |   6 +-
 drivers/mmc/core/mmc_ops.c                         |  25 ++--
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   7 +
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   7 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   5 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   6 +
 drivers/nvme/host/core.c                           |   1 +
 drivers/nvme/host/multipath.c                      |  25 +++-
 drivers/nvme/host/nvme.h                           |   4 +
 drivers/pci/pci.c                                  |  10 ++
 drivers/platform/chrome/cros_ec_debugfs.c          |  12 +-
 drivers/rtc/class.c                                |   9 ++
 drivers/rtc/rtc-mc146818-lib.c                     |  16 ++-
 drivers/scsi/qla2xxx/qla_target.c                  |   3 +
 drivers/vhost/net.c                                |  15 +-
 fs/afs/inode.c                                     |  14 +-
 fs/file_table.c                                    |   1 +
 fs/nilfs2/btnode.c                                 |  23 ++-
 fs/nilfs2/btnode.h                                 |   1 +
 fs/nilfs2/btree.c                                  |  27 ++--
 fs/nilfs2/dat.c                                    |   4 +-
 fs/nilfs2/gcinode.c                                |   7 +-
 fs/nilfs2/inode.c                                  | 159 +++++++++++++++++++--
 fs/nilfs2/mdt.c                                    |  43 ++++--
 fs/nilfs2/mdt.h                                    |   6 +-
 fs/nilfs2/nilfs.h                                  |  16 +--
 fs/nilfs2/page.c                                   |   7 +-
 fs/nilfs2/segment.c                                |   9 +-
 fs/nilfs2/super.c                                  |   5 +-
 include/linux/blkdev.h                             |  16 +++
 include/linux/dma-mapping.h                        |   8 --
 include/linux/mc146818rtc.h                        |   2 +
 include/linux/stmmac.h                             |   1 +
 include/linux/sunrpc/xprtsock.h                    |   1 +
 include/uapi/linux/dma-buf.h                       |   4 +-
 kernel/dma/swiotlb.c                               |  13 +-
 kernel/events/core.c                               |  14 ++
 net/bridge/br_input.c                              |   7 +
 net/key/af_key.c                                   |   6 +-
 net/mac80211/rx.c                                  |   3 +-
 net/nfc/nci/data.c                                 |   2 +-
 net/nfc/nci/hci.c                                  |   4 +-
 net/sched/act_pedit.c                              |   4 +
 net/sunrpc/xprt.c                                  |  34 ++---
 net/sunrpc/xprtsock.c                              |  36 +++--
 sound/isa/wavefront/wavefront_synth.c              |   3 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 tools/objtool/check.c                              |   1 +
 tools/perf/bench/numa.c                            |   2 +-
 tools/testing/selftests/net/fcnal-test.sh          |  12 ++
 94 files changed, 682 insertions(+), 264 deletions(-)


