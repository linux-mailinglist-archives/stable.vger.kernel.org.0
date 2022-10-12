Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E309E5FC283
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 10:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJLI5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 04:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiJLI5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 04:57:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98945DFA;
        Wed, 12 Oct 2022 01:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DFE9B819DC;
        Wed, 12 Oct 2022 08:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881ADC433D6;
        Wed, 12 Oct 2022 08:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665565055;
        bh=dfsZ80+7Ux8WZyYrJQUtM55NMYrL5oa7hebhOUoFD4k=;
        h=From:To:Cc:Subject:Date:From;
        b=Hm5EHI9duWnVpcYe7G+oNGkcv+YaPwjFM34yWO816gJp+E3GjQDCcO2waXLvx9SNY
         nlapD0H3tCInB3+XThuNjK5dnqrV+aNJtFJuWBXj2WLU7/xII+U/y0GrV+mM67DRif
         XX7Au172PpugiuDQeNiru15OxVUlUmi7KvqoDGPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.73
Date:   Wed, 12 Oct 2022 10:58:18 +0200
Message-Id: <166556509845128@kroah.com>
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

I'm announcing the release of the 5.15.73 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt   |    4 
 Documentation/process/code-of-conduct-interpretation.rst    |    2 
 Makefile                                                    |    2 
 arch/arm/boot/dts/moxart-uc7112lx.dts                       |    2 
 arch/arm/boot/dts/moxart.dtsi                               |    4 
 arch/powerpc/mm/book3s64/radix_pgtable.c                    |    9 
 arch/um/Makefile                                            |    8 
 arch/x86/um/shared/sysdep/syscalls_32.h                     |    5 
 arch/x86/um/tls_32.c                                        |    6 
 arch/x86/um/vdso/Makefile                                   |    2 
 drivers/clk/ti/clk-44xx.c                                   |  210 ++++++------
 drivers/clk/ti/clk-54xx.c                                   |  160 ++++-----
 drivers/clk/ti/clkctrl.c                                    |    4 
 drivers/dma/xilinx/xilinx_dma.c                             |   21 -
 drivers/firmware/arm_scmi/clock.c                           |    6 
 drivers/firmware/arm_scmi/scmi_pm_domain.c                  |   20 +
 drivers/firmware/arm_scmi/sensors.c                         |   25 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   12 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c            |    8 
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c |    6 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c          |    1 
 drivers/mmc/core/sd.c                                       |    3 
 drivers/net/ethernet/aquantia/atlantic/aq_main.c            |    3 
 drivers/net/ethernet/marvell/prestera/prestera_pci.c        |    1 
 drivers/net/ethernet/mellanox/mlx5/core/lag.c               |   55 +--
 drivers/rpmsg/qcom_glink_native.c                           |    2 
 drivers/rpmsg/qcom_smd.c                                    |    4 
 drivers/scsi/qedf/qedf_main.c                               |    5 
 drivers/usb/mon/mon_bin.c                                   |    5 
 drivers/usb/serial/ftdi_sio.c                               |    3 
 fs/inode.c                                                  |    7 
 include/linux/scmi_protocol.h                               |    4 
 include/net/ieee802154_netdev.h                             |   37 ++
 include/net/xsk_buff_pool.h                                 |    2 
 mm/gup.c                                                    |   34 +
 mm/huge_memory.c                                            |   13 
 mm/khugepaged.c                                             |   10 
 net/ieee802154/socket.c                                     |   42 +-
 net/wireless/util.c                                         |    2 
 net/xdp/xsk.c                                               |    4 
 net/xdp/xsk_buff_pool.c                                     |    5 
 scripts/Makefile.extrawarn                                  |    1 
 sound/pci/hda/patch_hdmi.c                                  |    1 
 tools/perf/util/parse-events.y                              |   10 
 44 files changed, 460 insertions(+), 310 deletions(-)

Brian Norris (1):
      mmc: core: Terminate infinite loop in SD-UHS voltage switch

ChanWoo Lee (1):
      mmc: core: Replace with already defined values for readability

Cristian Marussi (3):
      firmware: arm_scmi: Improve checks in the info_get operations
      firmware: arm_scmi: Harden accesses to the sensor domains
      firmware: arm_scmi: Add SCMI PM driver remove routine

David Gow (1):
      arch: um: Mark the stack non-executable to fix a binutils warning

Dongliang Mu (1):
      fs: fix UAF/GPF bug in nilfs_mdt_destroy

Greg Kroah-Hartman (1):
      Linux 5.15.73

Haimin Zhang (1):
      net/ieee802154: fix uninit value bug in dgram_sendmsg

Hugo Hu (1):
      drm/amd/display: update gamut remap if plane has changed

Ian Rogers (1):
      perf parse-events: Identify broken modifiers

Jalal Mostafa (1):
      xsk: Inherit need_wakeup flag for shared sockets

Jaroslav Kysela (1):
      ALSA: hda/hdmi: Fix the converter reuse for the silent stream

Jianglei Nie (1):
      net: atlantic: fix potential memory leak in aq_ndev_close()

Johan Hovold (1):
      USB: serial: ftdi_sio: fix 300 bps rate for SIO

Krzysztof Kozlowski (1):
      rpmsg: qcom: glink: replace strncpy() with strscpy_pad()

Leo Li (1):
      drm/amd/display: Fix double cursor on non-video RGB MPO

Letu Ren (1):
      scsi: qedf: Fix a UAF bug in __qedf_probe()

Lukas Straub (2):
      um: Cleanup syscall_handler_t cast in syscalls_32.h
      um: Cleanup compiler warning in arch/x86/um/tls_32.c

Miaohe Lin (1):
      mm/huge_memory: minor cleanup for split_huge_pages_all

Michael Strauss (1):
      drm/amd/display: Assume an LTTPR is always present on fixed_vs links

Naoya Horiguchi (1):
      mm/huge_memory: use pfn_to_online_page() in split_huge_pages_all()

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

Tamizh Chelvam Raja (1):
      wifi: cfg80211: fix MCS divisor value

Vlad Buslov (1):
      net/mlx5: Disable irq when locking lag_lock

Yang Shi (2):
      mm: gup: fix the fast GUP race against THP collapse
      powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush

zhikzhai (1):
      drm/amd/display: skip audio setup when audio stream is enabled

