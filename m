Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891D05BE3FA
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 12:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiITK50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 06:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiITK5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 06:57:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421886DF80;
        Tue, 20 Sep 2022 03:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF647B827F4;
        Tue, 20 Sep 2022 10:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284C5C433C1;
        Tue, 20 Sep 2022 10:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663671437;
        bh=Qqx3LDo62KXol9sezdhDPuBzoVWxabbkh48Rql5AGO4=;
        h=From:To:Cc:Subject:Date:From;
        b=hU33QvBBgmC5QHn9irUzP6wx1uj/tCMlbbJCDS8u2drqdX1lP5dZCIhlVhFzRClrW
         IavJUKX7ZnAmismlWGcMNEg1W7KPS57K07/+ko9mxT7OXc7zmg5uQFt4g7qxEmDLKu
         UWLP/G/v6sl6m+c8EgPQYMkEfHbrs/cDaKwYXQew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.69
Date:   Tue, 20 Sep 2022 12:57:45 +0200
Message-Id: <1663671465161217@kroah.com>
X-Mailer: git-send-email 2.37.3
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

I'm announcing the release of the 5.15.69 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml |    2 
 Documentation/input/joydev/joystick.rst                           |    1 
 Makefile                                                          |    2 
 arch/arm/boot/dts/at91-sama7g5ek.dts                              |   20 +-
 arch/arm/boot/dts/imx28-evk.dts                                   |    2 
 arch/arm/boot/dts/imx28-m28evk.dts                                |    2 
 arch/arm/boot/dts/imx28-sps1.dts                                  |    2 
 arch/arm/boot/dts/imx6dl-rex-basic.dts                            |    2 
 arch/arm/boot/dts/imx6q-ba16.dtsi                                 |    2 
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                               |    2 
 arch/arm/boot/dts/imx6q-cm-fx6.dts                                |    2 
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts                           |    2 
 arch/arm/boot/dts/imx6q-dms-ba16.dts                              |    2 
 arch/arm/boot/dts/imx6q-gw5400-a.dts                              |    2 
 arch/arm/boot/dts/imx6q-marsboard.dts                             |    2 
 arch/arm/boot/dts/imx6q-rex-pro.dts                               |    2 
 arch/arm/boot/dts/imx6qdl-aristainetos.dtsi                       |    2 
 arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi                      |    2 
 arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi                      |    2 
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi                     |    4 
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi                          |    2 
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi                      |    2 
 arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi                     |    2 
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi                         |    2 
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi                          |    2 
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi                          |    2 
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi                            |    2 
 arch/arm/boot/dts/imx6sl-evk.dts                                  |    2 
 arch/arm/boot/dts/imx6sx-nitrogen6sx.dts                          |    2 
 arch/arm/boot/dts/imx6sx-sdb-reva.dts                             |    4 
 arch/arm/boot/dts/imx6sx-sdb.dts                                  |    4 
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi                           |    2 
 arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi                   |    2 
 arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi                   |    2 
 arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi            |    2 
 arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi                  |    2 
 arch/arm64/kernel/entry-common.c                                  |    8 
 arch/x86/include/asm/cpu_entry_area.h                             |    2 
 arch/x86/include/asm/page_64.h                                    |    2 
 arch/x86/kvm/x86.h                                                |    2 
 drivers/acpi/resource.c                                           |   10 +
 drivers/gpio/gpio-mockup.c                                        |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                           |    2 
 drivers/gpu/drm/msm/msm_rd.c                                      |    3 
 drivers/hid/intel-ish-hid/ishtp-hid.h                             |    2 
 drivers/hid/intel-ish-hid/ishtp/client.c                          |   68 +++---
 drivers/infiniband/hw/irdma/uk.c                                  |    3 
 drivers/input/joystick/iforce/iforce-main.c                       |    1 
 drivers/input/touchscreen/goodix.c                                |    2 
 drivers/iommu/intel/iommu.c                                       |  100 ++++------
 drivers/net/ethernet/broadcom/tg3.c                               |    8 
 drivers/net/ieee802154/cc2520.c                                   |    1 
 drivers/nvme/target/tcp.c                                         |    3 
 drivers/perf/arm_pmu_platform.c                                   |    2 
 drivers/platform/surface/surface_aggregator_registry.c            |    3 
 drivers/platform/x86/acer-wmi.c                                   |    9 
 drivers/soc/fsl/Kconfig                                           |    1 
 drivers/usb/gadget/function/f_uac2.c                              |   30 ++-
 drivers/usb/storage/unusual_uas.h                                 |    7 
 fs/tracefs/inode.c                                                |   31 ++-
 include/linux/intel-iommu.h                                       |    9 
 include/linux/irqflags.h                                          |    4 
 include/linux/kvm_host.h                                          |    2 
 include/linux/nfs_fs.h                                            |    4 
 include/linux/sched/task_stack.h                                  |    2 
 kernel/entry/common.c                                             |    6 
 kernel/locking/lockdep.c                                          |   22 --
 kernel/sched/idle.c                                               |    2 
 kernel/trace/trace_preemptirq.c                                   |    8 
 mm/mmap.c                                                         |    9 
 net/dsa/tag_hellcreek.c                                           |    2 
 71 files changed, 278 insertions(+), 196 deletions(-)

Borislav Petkov (2):
      x86/mm: Force-inline __phys_addr_nodebug()
      task_stack, x86/cea: Force-inline stack helpers

Brian Norris (1):
      tracefs: Only clobber mode/uid/gid on remount if asked

Chengming Gui (1):
      drm/amd/amdgpu: skip ucode loading if ucode_size == 0

Chuanhong Guo (1):
      ACPI: resource: skip IRQ override on AMD Zen platforms

Claudiu Beznea (2):
      ARM: dts: at91: fix low limit for CPU regulator
      ARM: dts: at91: sama7g5ek: specify proper regulator output ranges

Colin Ian King (1):
      usb: gadget: f_uac2: clean up some inconsistent indenting

Dave Wysochanski (1):
      NFS: Fix WARN_ON due to unionization of nfs_inode.nrequests

Even Xu (1):
      hid: intel-ish-hid: ishtp: Fix ishtp client sending disordered message

Greg Kroah-Hartman (1):
      Linux 5.15.69

Greg Tulli (1):
      Input: iforce - add support for Boeder Force Feedback Wheel

Hans de Goede (1):
      platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes

Hu Xiaoying (1):
      usb: storage: Add ASUS <0x0b05:0x1932> to IGNORE_UAS

Jann Horn (1):
      mm: Fix TLB flush for not-first PFNMAP mappings in unmap_region()

Jarrah Gosbell (1):
      Input: goodix - add compatible string for GT1158

Jason Wang (1):
      HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo

Jing Leng (1):
      usb: gadget: f_uac2: fix superspeed transfer

Kai-Heng Feng (1):
      tg3: Disable tg3 device on system reboot to avoid triggering AER

Krzysztof Kozlowski (2):
      ARM: dts: imx: align SPI NOR node name with dtschema
      dt-bindings: iio: gyroscope: bosch,bmg160: correct number of pins

Kurt Kanzenbach (1):
      net: dsa: hellcreek: Print warning only once

Li Qiong (1):
      ieee802154: cc2520: add rc code in cc2520_tx()

Lu Baolu (1):
      iommu/vt-d: Fix kdump kernels boot failure with scalable mode

Marco Felsch (1):
      ARM: dts: imx6qdl-kontron-samx6i: fix spi-flash compatible

Mathew McBride (1):
      soc: fsl: select FSL_GUTS driver for DPIO

Maurizio Lombardi (1):
      nvmet-tcp: fix unhandled tcp states in nvmet_tcp_state_change()

Maximilian Luz (1):
      platform/surface: aggregator_registry: Add support for Surface Laptop Go 2

Nick Desaulniers (1):
      lockdep: Fix -Wunused-parameter for _THIS_IP_

Ondrej Jirman (1):
      Input: goodix - add support for GT1158

Rob Clark (1):
      drm/msm/rd: Fix FIFO-full deadlock

Sindhu-Devale (1):
      RDMA/irdma: Use s/g array in post send only when its valid

Wei Yongjun (1):
      gpio: mockup: remove gpio debugfs when remove device

Yipeng Zou (1):
      tracing: hold caller_addr to hardirq_{enable,disable}_ip

Yu Zhe (1):
      perf/arm_pmu_platform: fix tests for platform_get_irq() failure

