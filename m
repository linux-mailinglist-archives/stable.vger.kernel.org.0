Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83175FA403
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 21:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJJTMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 15:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiJJTME (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 15:12:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F965CCE;
        Mon, 10 Oct 2022 12:12:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2B1260EFB;
        Mon, 10 Oct 2022 19:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD857C433D6;
        Mon, 10 Oct 2022 19:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665429122;
        bh=xx/c25lbYKGq3BwQQ2tAV9AKzfFfjZILbHqk9YdrrNA=;
        h=From:To:Cc:Subject:Date:From;
        b=Gw4Rv8/pjLcVX1hwZ4JRwXYXUEaRYWBkIZirLEph/O6SRpR4noE5cJs+fc5XX6mEW
         7FZTudAe+gFiukWu1uOdKcphEPXAyYtgM97icxTWYgBrMiQwPYO820vX9WC83/L8q0
         T/vph2TiH7GWDFGQT8mzobH5p3U4Y5S5OnaNvwvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.19 00/46] 5.19.15-rc2 review
Date:   Mon, 10 Oct 2022 21:12:45 +0200
Message-Id: <20221010191212.200768859@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.15-rc2
X-KernelTest-Deadline: 2022-10-12T19:12+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.19.15 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Oct 2022 19:12:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.15-rc2

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: use hdev->workqueue when queuing hdev->{cmd,ncmd}_timer works

Jules Irenge <jbi.octave@gmail.com>
    bpf: Fix resetting logic for unreferenced kptrs

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: fix state in __mtk_foe_entry_clear

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Gate dynptr API behind CAP_BPF

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rpmsg: qcom: glink: replace strncpy() with strscpy_pad()

Brian Norris <briannorris@chromium.org>
    mmc: core: Terminate infinite loop in SD-UHS voltage switch

ChanWoo Lee <cw9316.lee@samsung.com>
    mmc: core: Replace with already defined values for readability

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib: acpi: Add a quirk for Asus UM325UAZ

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib: acpi: Add support to ignore programming an interrupt

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix 300 bps rate for SIO

Tadeusz Struk <tadeusz.struk@linaro.org>
    usb: mon: make mmapped memory read only

Zhang Qilong <zhangqilong3@huawei.com>
    i2c: davinci: fix PM disable depth imbalance in davinci_i2c_probe

Al Viro <viro@zeniv.linux.org.uk>
    don't use __kernel_write() on kmap_local_page()

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix unchecked MSR access error for Alder Lake N

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: increase dcn315 pstate change latency

Cruise Hung <Cruise.Hung@amd.com>
    drm/amd/display: Fix DP MST timeslot issue when fallback happened

zhikzhai <zhikai.zhai@amd.com>
    drm/amd/display: skip audio setup when audio stream is enabled

Hugo Hu <hugo.hu@amd.com>
    drm/amd/display: update gamut remap if plane has changed

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Assume an LTTPR is always present on fixed_vs links

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fix double cursor on non-video RGB MPO

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: Pass initialized arg even if unused

Jianglei Nie <niejianglei2021@163.com>
    net: atlantic: fix potential memory leak in aq_ndev_close()

David Gow <davidgow@google.com>
    arch: um: Mark the stack non-executable to fix a binutils warning

Linus Walleij <linus.walleij@linaro.org>
    gpio: ftgpio010: Make irqchip immutable

Lukas Straub <lukasstraub2@web.de>
    um: Cleanup compiler warning in arch/x86/um/tls_32.c

Lukas Straub <lukasstraub2@web.de>
    um: Cleanup syscall_handler_t cast in syscalls_32.h

Jaroslav Kysela <perex@perex.cz>
    ALSA: hda/hdmi: Fix the converter reuse for the silent stream

Oleksandr Mazur <oleksandr.mazur@plvision.eu>
    net: marvell: prestera: add support for for Aldrin2

Haimin Zhang <tcs.kernel@gmail.com>
    net/ieee802154: fix uninit value bug in dgram_sendmsg

Letu Ren <fantasquex@gmail.com>
    scsi: qedf: Fix a UAF bug in __qedf_probe()

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/mes: zero the sdma_hqd_mask of 2nd SDMA engine for SDMA 6.0.1

Sergei Antonov <saproj@gmail.com>
    ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer

Jason A. Donenfeld <Jason@zx2c4.com>
    wifi: iwlwifi: don't spam logs with NSS>2 messages

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: Fix devm_platform_ioremap_resource error handling

Frank Wunderlich <frank-w@public-files.de>
    arm64: dts: rockchip: fix upper usb port on BPI-R2-Pro

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add SCMI PM driver remove routine

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Harden accesses to the sensor domains

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Improve checks in the info_get operations

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: fix UAF/GPF bug in nilfs_mdt_destroy

Jalal Mostafa <jalal.a.mostapha@gmail.com>
    xsk: Inherit need_wakeup flag for shared sockets

Shuah Khan <skhan@linuxfoundation.org>
    docs: update mediator information in CoC docs

Kees Cook <keescook@chromium.org>
    hardening: Remove Clang's enable flag for -ftrivial-auto-var-init=zero

Sami Tolvanen <samitolvanen@google.com>
    Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Bart Van Assche <bvanassche@acm.org>
    sparc: Unbreak the build


-------------

Diffstat:

 .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  4 +--
 .../process/code-of-conduct-interpretation.rst     |  2 +-
 Makefile                                           |  8 ++---
 arch/arm/boot/dts/moxart-uc7112lx.dts              |  2 +-
 arch/arm/boot/dts/moxart.dtsi                      |  4 +--
 arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts |  2 +-
 arch/s390/kvm/gaccess.c                            | 16 +++++++--
 arch/sparc/include/asm/smp_32.h                    | 15 ++++----
 arch/sparc/kernel/leon_smp.c                       | 12 ++++---
 arch/sparc/kernel/sun4d_smp.c                      | 12 ++++---
 arch/sparc/kernel/sun4m_smp.c                      | 10 +++---
 arch/sparc/mm/srmmu.c                              | 29 +++++++--------
 arch/um/Makefile                                   |  8 +++++
 arch/x86/events/intel/core.c                       | 40 ++++++++++++++++++++-
 arch/x86/events/intel/ds.c                         |  9 +++--
 arch/x86/events/perf_event.h                       |  2 ++
 arch/x86/um/shared/sysdep/syscalls_32.h            |  5 ++-
 arch/x86/um/tls_32.c                               |  6 ----
 arch/x86/um/vdso/Makefile                          |  2 +-
 drivers/dma/xilinx/xilinx_dma.c                    | 21 ++++++-----
 drivers/firmware/arm_scmi/clock.c                  |  6 +++-
 drivers/firmware/arm_scmi/scmi_pm_domain.c         | 20 +++++++++++
 drivers/firmware/arm_scmi/sensors.c                | 25 ++++++++++---
 drivers/gpio/gpio-ftgpio010.c                      | 22 +++++++-----
 drivers/gpio/gpiolib-acpi.c                        | 38 +++++++++++++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |  3 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 12 +++++--
 .../amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c | 22 +++++++-----
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   | 16 ++++++++-
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |  6 ++--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  1 +
 drivers/i2c/busses/i2c-davinci.c                   |  3 +-
 drivers/mmc/core/sd.c                              |  3 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |  3 --
 .../net/ethernet/marvell/prestera/prestera_pci.c   |  1 +
 drivers/net/ethernet/mediatek/mtk_ppe.c            |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  4 +--
 drivers/rpmsg/qcom_glink_native.c                  |  2 +-
 drivers/rpmsg/qcom_smd.c                           |  4 +--
 drivers/scsi/qedf/qedf_main.c                      |  5 ---
 drivers/usb/mon/mon_bin.c                          |  5 +++
 drivers/usb/serial/ftdi_sio.c                      |  3 +-
 fs/coredump.c                                      | 38 +++++++++++++++++---
 fs/inode.c                                         |  7 ++--
 fs/internal.h                                      |  3 ++
 fs/read_write.c                                    | 22 +++++++-----
 include/linux/scmi_protocol.h                      |  4 +--
 include/net/ieee802154_netdev.h                    | 37 +++++++++++++++++++
 include/net/xsk_buff_pool.h                        |  2 +-
 kernel/bpf/helpers.c                               | 28 +++++++--------
 kernel/bpf/syscall.c                               |  2 +-
 net/bluetooth/hci_core.c                           | 15 ++++++--
 net/bluetooth/hci_event.c                          |  6 ++--
 net/ieee802154/socket.c                            | 42 ++++++++++++----------
 net/xdp/xsk.c                                      |  4 +--
 net/xdp/xsk_buff_pool.c                            |  5 +--
 scripts/Makefile.extrawarn                         |  1 +
 security/Kconfig.hardening                         | 14 +++++---
 sound/pci/hda/patch_hdmi.c                         |  1 +
 59 files changed, 457 insertions(+), 189 deletions(-)


