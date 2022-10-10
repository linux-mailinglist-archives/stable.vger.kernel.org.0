Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A753B5FA405
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 21:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiJJTMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 15:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiJJTMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 15:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D7F75CF2;
        Mon, 10 Oct 2022 12:12:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DD4BB81084;
        Mon, 10 Oct 2022 19:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64562C433C1;
        Mon, 10 Oct 2022 19:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665429128;
        bh=YUnRcz0RNpBzLtpKwGdLPjshaP8h9awopuNaPf5+VjI=;
        h=From:To:Cc:Subject:Date:From;
        b=0EMDE5DgurB9tGEBzwH6ftwOzGLLRvZ1IMXY4pEbkX+58o1yI6EBLPmPTFmRoroAp
         UcGnL8jV8vny5W6vBgMQhUKLhW05NPWP2Bo6lrUPY2/lVxdpzMHJZQlvVRQqHIa2f8
         Qq3/b0uPX5QuxQxjqgSSupIV8qE8/lhoV6nWeD/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.15 00/35] 5.15.73-rc2 review
Date:   Mon, 10 Oct 2022 21:12:52 +0200
Message-Id: <20221010191226.167997210@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.73-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.73-rc2
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

This is the start of the stable review cycle for the 5.15.73 release.
There are 35 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Oct 2022 19:12:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.73-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.73-rc2

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rpmsg: qcom: glink: replace strncpy() with strscpy_pad()

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix 300 bps rate for SIO

Tadeusz Struk <tadeusz.struk@linaro.org>
    usb: mon: make mmapped memory read only

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Disable irq when locking lag_lock

Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>
    wifi: cfg80211: fix MCS divisor value

Naoya Horiguchi <naoya.horiguchi@nec.com>
    mm/huge_memory: use pfn_to_online_page() in split_huge_pages_all()

Miaohe Lin <linmiaohe@huawei.com>
    mm/huge_memory: minor cleanup for split_huge_pages_all

Ian Rogers <irogers@google.com>
    perf parse-events: Identify broken modifiers

Brian Norris <briannorris@chromium.org>
    mmc: core: Terminate infinite loop in SD-UHS voltage switch

ChanWoo Lee <cw9316.lee@samsung.com>
    mmc: core: Replace with already defined values for readability

zhikzhai <zhikai.zhai@amd.com>
    drm/amd/display: skip audio setup when audio stream is enabled

Hugo Hu <hugo.hu@amd.com>
    drm/amd/display: update gamut remap if plane has changed

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Assume an LTTPR is always present on fixed_vs links

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fix double cursor on non-video RGB MPO

Jianglei Nie <niejianglei2021@163.com>
    net: atlantic: fix potential memory leak in aq_ndev_close()

David Gow <davidgow@google.com>
    arch: um: Mark the stack non-executable to fix a binutils warning

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

Sergei Antonov <saproj@gmail.com>
    ARM: dts: fix Moxa SDIO 'compatible', remove 'sdhci' misnomer

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: Fix devm_platform_ioremap_resource error handling

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add SCMI PM driver remove routine

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Harden accesses to the sensor domains

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Improve checks in the info_get operations

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: fix UAF/GPF bug in nilfs_mdt_destroy

Yang Shi <shy828301@gmail.com>
    powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush

Yang Shi <shy828301@gmail.com>
    mm: gup: fix the fast GUP race against THP collapse

Jalal Mostafa <jalal.a.mostapha@gmail.com>
    xsk: Inherit need_wakeup flag for shared sockets

Shuah Khan <skhan@linuxfoundation.org>
    docs: update mediator information in CoC docs

Sami Tolvanen <samitolvanen@google.com>
    Makefile.extrawarn: Move -Wcast-function-type-strict to W=1


-------------

Diffstat:

 .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  4 +-
 .../process/code-of-conduct-interpretation.rst     |  2 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/moxart-uc7112lx.dts              |  2 +-
 arch/arm/boot/dts/moxart.dtsi                      |  4 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |  9 ----
 arch/um/Makefile                                   |  8 ++++
 arch/x86/um/shared/sysdep/syscalls_32.h            |  5 +-
 arch/x86/um/tls_32.c                               |  6 ---
 arch/x86/um/vdso/Makefile                          |  2 +-
 drivers/dma/xilinx/xilinx_dma.c                    | 21 +++++----
 drivers/firmware/arm_scmi/clock.c                  |  6 ++-
 drivers/firmware/arm_scmi/scmi_pm_domain.c         | 20 ++++++++
 drivers/firmware/arm_scmi/sensors.c                | 25 ++++++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 12 ++++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  8 ++++
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |  6 ++-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  1 +
 drivers/mmc/core/sd.c                              |  3 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |  3 --
 .../net/ethernet/marvell/prestera/prestera_pci.c   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      | 55 +++++++++++++---------
 drivers/rpmsg/qcom_glink_native.c                  |  2 +-
 drivers/rpmsg/qcom_smd.c                           |  4 +-
 drivers/scsi/qedf/qedf_main.c                      |  5 --
 drivers/usb/mon/mon_bin.c                          |  5 ++
 drivers/usb/serial/ftdi_sio.c                      |  3 +-
 fs/inode.c                                         |  7 ++-
 include/linux/scmi_protocol.h                      |  4 +-
 include/net/ieee802154_netdev.h                    | 37 +++++++++++++++
 include/net/xsk_buff_pool.h                        |  2 +-
 mm/gup.c                                           | 34 ++++++++++---
 mm/huge_memory.c                                   | 13 +++--
 mm/khugepaged.c                                    | 10 ++--
 net/ieee802154/socket.c                            | 42 +++++++++--------
 net/wireless/util.c                                |  2 +-
 net/xdp/xsk.c                                      |  4 +-
 net/xdp/xsk_buff_pool.c                            |  5 +-
 scripts/Makefile.extrawarn                         |  1 +
 sound/pci/hda/patch_hdmi.c                         |  1 +
 tools/perf/util/parse-events.y                     | 10 ++++
 41 files changed, 272 insertions(+), 126 deletions(-)


