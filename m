Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7200D5BAAD0
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiIPKRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiIPKQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:16:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A7FAF0EB;
        Fri, 16 Sep 2022 03:12:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62A1BB82526;
        Fri, 16 Sep 2022 10:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9588CC433C1;
        Fri, 16 Sep 2022 10:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323080;
        bh=iIZwgRxeCgfJqv8PWDkKkp2eL0TyIzSFAgtUBE+ppRE=;
        h=From:To:Cc:Subject:Date:From;
        b=muUg0vXolSx7LIhTUIETEsjEhctU8EhpWyVx6GP/S0O2tlErAHUmP0cEfxIicI764
         6jJ/j45F3Re6IQFAlP0XcW+zDArBnUJr2TVjueBOZJr8QrRcMGtw3EmMyHOLj3BMqx
         u3P7qbj7cwwdBlYdZBiPme7zpBOlH2lA+6v6ynJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/24] 5.10.144-rc1 review
Date:   Fri, 16 Sep 2022 12:08:25 +0200
Message-Id: <20220916100445.354452396@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.144-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.144-rc1
X-KernelTest-Deadline: 2022-09-18T10:04+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.144 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.144-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.144-rc1

Jarrah Gosbell <kernel@undef.tools>
    Input: goodix - add compatible string for GT1158

Mathew McBride <matt@traverse.com.au>
    soc: fsl: select FSL_GUTS driver for DPIO

Peter Zijlstra <peterz@infradead.org>
    x86/ftrace: Use alternative RET encoding

Peter Zijlstra <peterz@infradead.org>
    x86/ibt,ftrace: Make function-graph play nice

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    Revert "x86/ftrace: Use alternative RET encoding"

Jann Horn <jannh@google.com>
    mm: Fix TLB flush for not-first PFNMAP mappings in unmap_region()

Hu Xiaoying <huxiaoying@kylinos.cn>
    usb: storage: Add ASUS <0x0b05:0x1932> to IGNORE_UAS

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes

Yu Zhe <yuzhe@nfschina.com>
    perf/arm_pmu_platform: fix tests for platform_get_irq() failure

Chengming Gui <Jack.Gui@amd.com>
    drm/amd/amdgpu: skip ucode loading if ucode_size == 0

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: fix unhandled tcp states in nvmet_tcp_state_change()

Greg Tulli <greg.iforce@gmail.com>
    Input: iforce - add support for Boeder Force Feedback Wheel

Li Qiong <liqiong@nfschina.com>
    ieee802154: cc2520: add rc code in cc2520_tx()

Wei Yongjun <weiyongjun1@huawei.com>
    gpio: mockup: remove gpio debugfs when remove device

Kai-Heng Feng <kai.heng.feng@canonical.com>
    tg3: Disable tg3 device on system reboot to avoid triggering AER

Even Xu <even.xu@intel.com>
    hid: intel-ish-hid: ishtp: Fix ishtp client sending disordered message

Jason Wang <wangborong@cdjrlc.com>
    HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER error messages

Rob Clark <robdclark@chromium.org>
    drm/msm/rd: Fix FIFO-full deadlock

Ondrej Jirman <megi@xff.cz>
    Input: goodix - add support for GT1158

Brian Norris <briannorris@chromium.org>
    tracefs: Only clobber mode/uid/gid on remount if asked

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Correctly calculate sagaw value of IOMMU

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: fix spi-flash compatible

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: imx: align SPI NOR node name with dtschema


-------------

Diffstat:

 Documentation/input/joydev/joystick.rst            |  1 +
 Makefile                                           |  4 +-
 arch/arm/boot/dts/imx28-evk.dts                    |  2 +-
 arch/arm/boot/dts/imx28-m28evk.dts                 |  2 +-
 arch/arm/boot/dts/imx28-sps1.dts                   |  2 +-
 arch/arm/boot/dts/imx6dl-rex-basic.dts             |  2 +-
 arch/arm/boot/dts/imx6q-ba16.dtsi                  |  2 +-
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                |  2 +-
 arch/arm/boot/dts/imx6q-cm-fx6.dts                 |  2 +-
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts            |  2 +-
 arch/arm/boot/dts/imx6q-dms-ba16.dts               |  2 +-
 arch/arm/boot/dts/imx6q-gw5400-a.dts               |  2 +-
 arch/arm/boot/dts/imx6q-marsboard.dts              |  2 +-
 arch/arm/boot/dts/imx6q-rex-pro.dts                |  2 +-
 arch/arm/boot/dts/imx6qdl-aristainetos.dtsi        |  2 +-
 arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi       |  2 +-
 arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi       |  2 +-
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |  4 +-
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi           |  2 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi       |  2 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi      |  2 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi          |  2 +-
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  2 +-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |  2 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  2 +-
 arch/arm/boot/dts/imx6sl-evk.dts                   |  2 +-
 arch/arm/boot/dts/imx6sx-nitrogen6sx.dts           |  2 +-
 arch/arm/boot/dts/imx6sx-sdb-reva.dts              |  4 +-
 arch/arm/boot/dts/imx6sx-sdb.dts                   |  4 +-
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi            |  2 +-
 arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi    |  2 +-
 arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi    |  2 +-
 .../boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi  |  2 +-
 arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi   |  2 +-
 arch/x86/kernel/ftrace.c                           |  7 +--
 arch/x86/kernel/ftrace_64.S                        | 19 ++++--
 drivers/gpio/gpio-mockup.c                         |  9 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |  2 +-
 drivers/gpu/drm/msm/msm_rd.c                       |  3 +
 drivers/hid/intel-ish-hid/ishtp-hid.h              |  2 +-
 drivers/hid/intel-ish-hid/ishtp/client.c           | 68 +++++++++++++---------
 drivers/hwmon/pmbus/pmbus_core.c                   |  9 ++-
 drivers/input/joystick/iforce/iforce-main.c        |  1 +
 drivers/input/touchscreen/goodix.c                 |  2 +
 drivers/iommu/intel/iommu.c                        | 28 ++++++++-
 drivers/net/ethernet/broadcom/tg3.c                |  8 ++-
 drivers/net/ieee802154/cc2520.c                    |  1 +
 drivers/nvme/target/tcp.c                          |  3 +
 drivers/perf/arm_pmu_platform.c                    |  2 +-
 drivers/platform/x86/acer-wmi.c                    |  9 ++-
 drivers/soc/fsl/Kconfig                            |  1 +
 drivers/usb/storage/unusual_uas.h                  |  7 +++
 fs/tracefs/inode.c                                 | 31 +++++++---
 mm/mmap.c                                          |  9 ++-
 54 files changed, 196 insertions(+), 100 deletions(-)


