Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF845FC285
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 10:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJLI5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 04:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJLI5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 04:57:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E641AD92;
        Wed, 12 Oct 2022 01:57:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60A6B61481;
        Wed, 12 Oct 2022 08:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F40C433C1;
        Wed, 12 Oct 2022 08:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665565065;
        bh=7qTxSgakZzTi83vF6+h1WSVoCpnnBSYHVtEx2QxW2/E=;
        h=From:To:Cc:Subject:Date:From;
        b=h/qv1OzgVPp+G6nbpxnUkSeqeOSA4Z7Sd5mwkho/59Gy3F5rdnzj1G6m5nXsnZbAQ
         GpIMkaIxslmrL2KIGnq5BcqRz/iKrAo7F3mZN6L2OMoqzFoWCdSJJjLy366mWZ1+4m
         m9uKtOF2XsyUdGYKK8gXfCF9SzJ1PZ8pSLNgJOWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.15
Date:   Wed, 12 Oct 2022 10:58:25 +0200
Message-Id: <1665565105253128@kroah.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.19.15 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt      |    4 
 Documentation/process/code-of-conduct-interpretation.rst       |    2 
 Makefile                                                       |    6 
 arch/arm/boot/dts/moxart-uc7112lx.dts                          |    2 
 arch/arm/boot/dts/moxart.dtsi                                  |    4 
 arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts             |    2 
 arch/s390/kvm/gaccess.c                                        |   16 
 arch/sparc/include/asm/smp_32.h                                |   15 
 arch/sparc/kernel/leon_smp.c                                   |   12 
 arch/sparc/kernel/sun4d_smp.c                                  |   12 
 arch/sparc/kernel/sun4m_smp.c                                  |   10 
 arch/sparc/mm/srmmu.c                                          |   29 -
 arch/um/Makefile                                               |    8 
 arch/x86/events/intel/core.c                                   |   40 +
 arch/x86/events/intel/ds.c                                     |    9 
 arch/x86/events/perf_event.h                                   |    2 
 arch/x86/um/shared/sysdep/syscalls_32.h                        |    5 
 arch/x86/um/tls_32.c                                           |    6 
 arch/x86/um/vdso/Makefile                                      |    2 
 drivers/clk/ti/clk-44xx.c                                      |  210 +++++-----
 drivers/clk/ti/clk-54xx.c                                      |  160 +++----
 drivers/clk/ti/clkctrl.c                                       |    4 
 drivers/dma/xilinx/xilinx_dma.c                                |   21 -
 drivers/firmware/arm_scmi/clock.c                              |    6 
 drivers/firmware/arm_scmi/scmi_pm_domain.c                     |   20 
 drivers/firmware/arm_scmi/sensors.c                            |   25 +
 drivers/gpio/gpio-ftgpio010.c                                  |   22 -
 drivers/gpio/gpiolib-acpi.c                                    |   38 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c                        |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c              |   12 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c |   22 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c               |   16 
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c    |    6 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c             |    1 
 drivers/i2c/busses/i2c-davinci.c                               |    3 
 drivers/mmc/core/sd.c                                          |    3 
 drivers/net/ethernet/aquantia/atlantic/aq_main.c               |    3 
 drivers/net/ethernet/marvell/prestera/prestera_pci.c           |    1 
 drivers/net/ethernet/mediatek/mtk_ppe.c                        |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c              |    4 
 drivers/rpmsg/qcom_glink_native.c                              |    2 
 drivers/rpmsg/qcom_smd.c                                       |    4 
 drivers/scsi/qedf/qedf_main.c                                  |    5 
 drivers/usb/mon/mon_bin.c                                      |    5 
 drivers/usb/serial/ftdi_sio.c                                  |    3 
 fs/coredump.c                                                  |   38 +
 fs/inode.c                                                     |    7 
 fs/internal.h                                                  |    3 
 fs/read_write.c                                                |   22 -
 include/linux/scmi_protocol.h                                  |    4 
 include/net/ieee802154_netdev.h                                |   37 +
 include/net/xsk_buff_pool.h                                    |    2 
 kernel/bpf/helpers.c                                           |   28 -
 kernel/bpf/syscall.c                                           |    2 
 net/bluetooth/hci_core.c                                       |   15 
 net/bluetooth/hci_event.c                                      |    6 
 net/ieee802154/socket.c                                        |   42 +-
 net/xdp/xsk.c                                                  |    4 
 net/xdp/xsk_buff_pool.c                                        |    5 
 scripts/Makefile.extrawarn                                     |    1 
 security/Kconfig.hardening                                     |   14 
 sound/pci/hda/patch_hdmi.c                                     |    1 
 62 files changed, 645 insertions(+), 373 deletions(-)

Al Viro (1):
      don't use __kernel_write() on kmap_local_page()

Bart Van Assche (1):
      sparc: Unbreak the build

Brian Norris (1):
      mmc: core: Terminate infinite loop in SD-UHS voltage switch

ChanWoo Lee (1):
      mmc: core: Replace with already defined values for readability

Cristian Marussi (3):
      firmware: arm_scmi: Improve checks in the info_get operations
      firmware: arm_scmi: Harden accesses to the sensor domains
      firmware: arm_scmi: Add SCMI PM driver remove routine

Cruise Hung (1):
      drm/amd/display: Fix DP MST timeslot issue when fallback happened

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix state in __mtk_foe_entry_clear

David Gow (1):
      arch: um: Mark the stack non-executable to fix a binutils warning

Dmytro Laktyushkin (1):
      drm/amd/display: increase dcn315 pstate change latency

Dongliang Mu (1):
      fs: fix UAF/GPF bug in nilfs_mdt_destroy

Frank Wunderlich (1):
      arm64: dts: rockchip: fix upper usb port on BPI-R2-Pro

Greg Kroah-Hartman (1):
      Linux 5.19.15

Haimin Zhang (1):
      net/ieee802154: fix uninit value bug in dgram_sendmsg

Hugo Hu (1):
      drm/amd/display: update gamut remap if plane has changed

Jalal Mostafa (1):
      xsk: Inherit need_wakeup flag for shared sockets

Janis Schoetterl-Glausch (1):
      KVM: s390: Pass initialized arg even if unused

Jaroslav Kysela (1):
      ALSA: hda/hdmi: Fix the converter reuse for the silent stream

Jason A. Donenfeld (1):
      wifi: iwlwifi: don't spam logs with NSS>2 messages

Jianglei Nie (1):
      net: atlantic: fix potential memory leak in aq_ndev_close()

Johan Hovold (1):
      USB: serial: ftdi_sio: fix 300 bps rate for SIO

Jules Irenge (1):
      bpf: Fix resetting logic for unreferenced kptrs

Kan Liang (1):
      perf/x86/intel: Fix unchecked MSR access error for Alder Lake N

Kees Cook (1):
      hardening: Remove Clang's enable flag for -ftrivial-auto-var-init=zero

Krzysztof Kozlowski (1):
      rpmsg: qcom: glink: replace strncpy() with strscpy_pad()

Kumar Kartikeya Dwivedi (1):
      bpf: Gate dynptr API behind CAP_BPF

Leo Li (1):
      drm/amd/display: Fix double cursor on non-video RGB MPO

Letu Ren (1):
      scsi: qedf: Fix a UAF bug in __qedf_probe()

Linus Walleij (1):
      gpio: ftgpio010: Make irqchip immutable

Lukas Straub (2):
      um: Cleanup syscall_handler_t cast in syscalls_32.h
      um: Cleanup compiler warning in arch/x86/um/tls_32.c

Mario Limonciello (2):
      gpiolib: acpi: Add support to ignore programming an interrupt
      gpiolib: acpi: Add a quirk for Asus UM325UAZ

Michael Strauss (1):
      drm/amd/display: Assume an LTTPR is always present on fixed_vs links

Oleksandr Mazur (1):
      net: marvell: prestera: add support for for Aldrin2

Sami Tolvanen (1):
      Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Sasha Levin (1):
      Revert "clk: ti: Stop using legacy clkctrl names for omap4 and 5"

Sergei Antonov (1):
      ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer

Shuah Khan (1):
      docs: update mediator information in CoC docs

Swati Agarwal (3):
      dmaengine: xilinx_dma: Fix devm_platform_ioremap_resource error handling
      dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property
      dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure

Tadeusz Struk (1):
      usb: mon: make mmapped memory read only

Tetsuo Handa (1):
      Bluetooth: use hdev->workqueue when queuing hdev->{cmd,ncmd}_timer works

Yifan Zhang (1):
      drm/amdgpu/mes: zero the sdma_hqd_mask of 2nd SDMA engine for SDMA 6.0.1

Zhang Qilong (1):
      i2c: davinci: fix PM disable depth imbalance in davinci_i2c_probe

zhikzhai (1):
      drm/amd/display: skip audio setup when audio stream is enabled

