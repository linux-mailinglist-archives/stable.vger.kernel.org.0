Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0F25BE3B3
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 12:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiITKrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 06:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiITKrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 06:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A9821B6;
        Tue, 20 Sep 2022 03:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6559622C1;
        Tue, 20 Sep 2022 10:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F1BC433C1;
        Tue, 20 Sep 2022 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663670832;
        bh=BE1XzTwSy64CvBAeWMOhgemrAdEg9K81gseWPUCE5kg=;
        h=From:To:Cc:Subject:Date:From;
        b=qX3t20isqk9yZVt6DQI+3BBlWpY6xtkQOxRw4qb5tmEjYTR6ETqN90jlLuG3GIFK0
         P+cZM192odmQcVLX3l2YkKAE1avr47tsk7xpTamzmTkIC0cZ/27C+obYRsMi5tZfg2
         AC3yYRVJwFIhxV+v2OCMgryBKpyED5r1RUwa0fhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.144
Date:   Tue, 20 Sep 2022 12:47:39 +0200
Message-Id: <166367086022162@kroah.com>
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

I'm announcing the release of the 5.10.144 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/input/joydev/joystick.rst                |    1 
 Makefile                                               |    2 
 arch/arm/boot/dts/imx28-evk.dts                        |    2 
 arch/arm/boot/dts/imx28-m28evk.dts                     |    2 
 arch/arm/boot/dts/imx28-sps1.dts                       |    2 
 arch/arm/boot/dts/imx6dl-rex-basic.dts                 |    2 
 arch/arm/boot/dts/imx6q-ba16.dtsi                      |    2 
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                    |    2 
 arch/arm/boot/dts/imx6q-cm-fx6.dts                     |    2 
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts                |    2 
 arch/arm/boot/dts/imx6q-dms-ba16.dts                   |    2 
 arch/arm/boot/dts/imx6q-gw5400-a.dts                   |    2 
 arch/arm/boot/dts/imx6q-marsboard.dts                  |    2 
 arch/arm/boot/dts/imx6q-rex-pro.dts                    |    2 
 arch/arm/boot/dts/imx6qdl-aristainetos.dtsi            |    2 
 arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi           |    2 
 arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi           |    2 
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi          |    4 -
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi               |    2 
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi           |    2 
 arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi          |    2 
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi              |    2 
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi               |    2 
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi               |    2 
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi                 |    2 
 arch/arm/boot/dts/imx6sl-evk.dts                       |    2 
 arch/arm/boot/dts/imx6sx-nitrogen6sx.dts               |    2 
 arch/arm/boot/dts/imx6sx-sdb-reva.dts                  |    4 -
 arch/arm/boot/dts/imx6sx-sdb.dts                       |    4 -
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi                |    2 
 arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi        |    2 
 arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi        |    2 
 arch/arm/boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi |    2 
 arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi       |    2 
 arch/x86/kernel/ftrace.c                               |    7 -
 arch/x86/kernel/ftrace_64.S                            |   19 +++-
 drivers/gpio/gpio-mockup.c                             |    9 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                |    2 
 drivers/gpu/drm/msm/msm_rd.c                           |    3 
 drivers/hid/intel-ish-hid/ishtp-hid.h                  |    2 
 drivers/hid/intel-ish-hid/ishtp/client.c               |   68 +++++++++--------
 drivers/input/joystick/iforce/iforce-main.c            |    1 
 drivers/input/touchscreen/goodix.c                     |    2 
 drivers/iommu/intel/iommu.c                            |   28 ++++++-
 drivers/net/ethernet/broadcom/tg3.c                    |    8 +-
 drivers/net/ieee802154/cc2520.c                        |    1 
 drivers/nvme/target/tcp.c                              |    3 
 drivers/perf/arm_pmu_platform.c                        |    2 
 drivers/platform/x86/acer-wmi.c                        |    9 ++
 drivers/soc/fsl/Kconfig                                |    1 
 drivers/usb/storage/unusual_uas.h                      |    7 +
 fs/tracefs/inode.c                                     |   31 +++++--
 mm/mmap.c                                              |    9 +-
 53 files changed, 191 insertions(+), 94 deletions(-)

Brian Norris (1):
      tracefs: Only clobber mode/uid/gid on remount if asked

Chengming Gui (1):
      drm/amd/amdgpu: skip ucode loading if ucode_size == 0

Even Xu (1):
      hid: intel-ish-hid: ishtp: Fix ishtp client sending disordered message

Greg Kroah-Hartman (1):
      Linux 5.10.144

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

Kai-Heng Feng (1):
      tg3: Disable tg3 device on system reboot to avoid triggering AER

Krzysztof Kozlowski (1):
      ARM: dts: imx: align SPI NOR node name with dtschema

Li Qiong (1):
      ieee802154: cc2520: add rc code in cc2520_tx()

Lu Baolu (1):
      iommu/vt-d: Correctly calculate sagaw value of IOMMU

Marco Felsch (1):
      ARM: dts: imx6qdl-kontron-samx6i: fix spi-flash compatible

Mathew McBride (1):
      soc: fsl: select FSL_GUTS driver for DPIO

Maurizio Lombardi (1):
      nvmet-tcp: fix unhandled tcp states in nvmet_tcp_state_change()

Ondrej Jirman (1):
      Input: goodix - add support for GT1158

Peter Zijlstra (2):
      x86/ibt,ftrace: Make function-graph play nice
      x86/ftrace: Use alternative RET encoding

Rob Clark (1):
      drm/msm/rd: Fix FIFO-full deadlock

Thadeu Lima de Souza Cascardo (1):
      Revert "x86/ftrace: Use alternative RET encoding"

Wei Yongjun (1):
      gpio: mockup: remove gpio debugfs when remove device

Yu Zhe (1):
      perf/arm_pmu_platform: fix tests for platform_get_irq() failure

