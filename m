Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0ECA5BAAB8
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiIPKSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiIPKRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:17:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA6B3888;
        Fri, 16 Sep 2022 03:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 143FCB82528;
        Fri, 16 Sep 2022 10:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A68EC433D6;
        Fri, 16 Sep 2022 10:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323138;
        bh=znlwG4SYJwHQa4PUP4H7LJOLAYmTZuxpRhN1tn8fOsA=;
        h=From:To:Cc:Subject:Date:From;
        b=uGziHrE0ttHn6yf2QlGlKuRB+KdsI2vx0bF8RL7J3yuEgYy14Tm0M9xq4yGsHZBKY
         vtC2LCmGw/i4nhM9R9Jk8Eai6tvi6Qydv1qrimNcxRZ9W4rS77VoeAJmAlrthBYhu2
         Q+ofm5eqsOr46hXxQBbKJPn/EI5BAUuxeWbhmjGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/35] 5.15.69-rc1 review
Date:   Fri, 16 Sep 2022 12:08:23 +0200
Message-Id: <20220916100446.916515275@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.69-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.69-rc1
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

This is the start of the stable review cycle for the 5.15.69 release.
There are 35 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.69-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.69-rc1

Jarrah Gosbell <kernel@undef.tools>
    Input: goodix - add compatible string for GT1158

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Use s/g array in post send only when its valid

Jing Leng <jleng@ambarella.com>
    usb: gadget: f_uac2: fix superspeed transfer

Colin Ian King <colin.king@canonical.com>
    usb: gadget: f_uac2: clean up some inconsistent indenting

Mathew McBride <matt@traverse.com.au>
    soc: fsl: select FSL_GUTS driver for DPIO

Jann Horn <jannh@google.com>
    mm: Fix TLB flush for not-first PFNMAP mappings in unmap_region()

Hu Xiaoying <huxiaoying@kylinos.cn>
    usb: storage: Add ASUS <0x0b05:0x1932> to IGNORE_UAS

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes

Yu Zhe <yuzhe@nfschina.com>
    perf/arm_pmu_platform: fix tests for platform_get_irq() failure

Kurt Kanzenbach <kurt@linutronix.de>
    net: dsa: hellcreek: Print warning only once

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

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: iio: gyroscope: bosch,bmg160: correct number of pins

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER error messages

Rob Clark <robdclark@chromium.org>
    drm/msm/rd: Fix FIFO-full deadlock

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add support for Surface Laptop Go 2

Ondrej Jirman <megi@xff.cz>
    Input: goodix - add support for GT1158

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix kdump kernels boot failure with scalable mode

Brian Norris <briannorris@chromium.org>
    tracefs: Only clobber mode/uid/gid on remount if asked

Yipeng Zou <zouyipeng@huawei.com>
    tracing: hold caller_addr to hardirq_{enable,disable}_ip

Borislav Petkov <bp@suse.de>
    task_stack, x86/cea: Force-inline stack helpers

Borislav Petkov <bp@suse.de>
    x86/mm: Force-inline __phys_addr_nodebug()

Nick Desaulniers <ndesaulniers@google.com>
    lockdep: Fix -Wunused-parameter for _THIS_IP_

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sama7g5ek: specify proper regulator output ranges

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: fix low limit for CPU regulator

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6qdl-kontron-samx6i: fix spi-flash compatible

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: imx: align SPI NOR node name with dtschema

Chuanhong Guo <gch981213@gmail.com>
    ACPI: resource: skip IRQ override on AMD Zen platforms

Dave Wysochanski <dwysocha@redhat.com>
    NFS: Fix WARN_ON due to unionization of nfs_inode.nrequests


-------------

Diffstat:

 .../bindings/iio/gyroscope/bosch,bmg160.yaml       |   2 +
 Documentation/input/joydev/joystick.rst            |   1 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/at91-sama7g5ek.dts               |  20 ++---
 arch/arm/boot/dts/imx28-evk.dts                    |   2 +-
 arch/arm/boot/dts/imx28-m28evk.dts                 |   2 +-
 arch/arm/boot/dts/imx28-sps1.dts                   |   2 +-
 arch/arm/boot/dts/imx6dl-rex-basic.dts             |   2 +-
 arch/arm/boot/dts/imx6q-ba16.dtsi                  |   2 +-
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                |   2 +-
 arch/arm/boot/dts/imx6q-cm-fx6.dts                 |   2 +-
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts            |   2 +-
 arch/arm/boot/dts/imx6q-dms-ba16.dts               |   2 +-
 arch/arm/boot/dts/imx6q-gw5400-a.dts               |   2 +-
 arch/arm/boot/dts/imx6q-marsboard.dts              |   2 +-
 arch/arm/boot/dts/imx6q-rex-pro.dts                |   2 +-
 arch/arm/boot/dts/imx6qdl-aristainetos.dtsi        |   2 +-
 arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi       |   2 +-
 arch/arm/boot/dts/imx6qdl-dfi-fs700-m60.dtsi       |   2 +-
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |   4 +-
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi           |   2 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi       |   2 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6_som2.dtsi      |   2 +-
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi          |   2 +-
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |   2 +-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |   2 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |   2 +-
 arch/arm/boot/dts/imx6sl-evk.dts                   |   2 +-
 arch/arm/boot/dts/imx6sx-nitrogen6sx.dts           |   2 +-
 arch/arm/boot/dts/imx6sx-sdb-reva.dts              |   4 +-
 arch/arm/boot/dts/imx6sx-sdb.dts                   |   4 +-
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi            |   2 +-
 arch/arm/boot/dts/imx6ul-kontron-n6310-som.dtsi    |   2 +-
 arch/arm/boot/dts/imx6ul-kontron-n6311-som.dtsi    |   2 +-
 .../boot/dts/imx6ul-kontron-n6x1x-som-common.dtsi  |   2 +-
 arch/arm/boot/dts/imx6ull-kontron-n6411-som.dtsi   |   2 +-
 arch/arm64/kernel/entry-common.c                   |   8 +-
 arch/x86/include/asm/cpu_entry_area.h              |   2 +-
 arch/x86/include/asm/page_64.h                     |   2 +-
 arch/x86/kvm/x86.h                                 |   2 +-
 drivers/acpi/resource.c                            |  10 +++
 drivers/gpio/gpio-mockup.c                         |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   2 +-
 drivers/gpu/drm/msm/msm_rd.c                       |   3 +
 drivers/hid/intel-ish-hid/ishtp-hid.h              |   2 +-
 drivers/hid/intel-ish-hid/ishtp/client.c           |  68 ++++++++------
 drivers/hwmon/pmbus/pmbus_core.c                   |   9 +-
 drivers/infiniband/hw/irdma/uk.c                   |   3 +-
 drivers/input/joystick/iforce/iforce-main.c        |   1 +
 drivers/input/touchscreen/goodix.c                 |   2 +
 drivers/iommu/intel/iommu.c                        | 100 +++++++++------------
 drivers/net/ethernet/broadcom/tg3.c                |   8 +-
 drivers/net/ieee802154/cc2520.c                    |   1 +
 drivers/nvme/target/tcp.c                          |   3 +
 drivers/perf/arm_pmu_platform.c                    |   2 +-
 .../platform/surface/surface_aggregator_registry.c |   3 +
 drivers/platform/x86/acer-wmi.c                    |   9 +-
 drivers/soc/fsl/Kconfig                            |   1 +
 drivers/usb/gadget/function/f_uac2.c               |  30 +++++--
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 fs/tracefs/inode.c                                 |  31 +++++--
 include/linux/intel-iommu.h                        |   9 +-
 include/linux/irqflags.h                           |   4 +-
 include/linux/kvm_host.h                           |   2 +-
 include/linux/nfs_fs.h                             |   4 +-
 include/linux/sched/task_stack.h                   |   2 +-
 kernel/entry/common.c                              |   6 +-
 kernel/locking/lockdep.c                           |  22 ++---
 kernel/sched/idle.c                                |   2 +-
 kernel/trace/trace_preemptirq.c                    |   8 +-
 mm/mmap.c                                          |   9 +-
 net/dsa/tag_hellcreek.c                            |   2 +-
 72 files changed, 283 insertions(+), 202 deletions(-)


