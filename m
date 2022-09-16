Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457885BAB0C
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiIPKZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiIPKXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:23:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7611FB0B3D;
        Fri, 16 Sep 2022 03:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92DDCB82551;
        Fri, 16 Sep 2022 10:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9D8C433C1;
        Fri, 16 Sep 2022 10:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323257;
        bh=jok/kkh2g/6U00S6qVysOXZQEV20tRTNXa4wZUSVXec=;
        h=From:To:Cc:Subject:Date:From;
        b=s/9bCMpJU1j9Bu0+uxBvHtcCxSQobVPt5N1v3JWBaWHdcWbVHvkuRfxgvk+nH8WSq
         D8KuOn5OQXkRRedHbl3ggAqNjW+GJAUluNOJF8wc97pAbXrizzdjfdBAybCYWup34u
         shE+apZybmtBISLgdXKtNGKh5hnwGmcVL6KT3EFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.19 00/38] 5.19.10-rc1 review
Date:   Fri, 16 Sep 2022 12:08:34 +0200
Message-Id: <20220916100448.431016349@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.10-rc1
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

This is the start of the stable review cycle for the 5.19.10 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.10-rc1

Jarrah Gosbell <kernel@undef.tools>
    Input: goodix - add compatible string for GT1158

Sindhu-Devale <sindhu.devale@intel.com>
    RDMA/irdma: Use s/g array in post send only when its valid

William Breathitt Gray <william.gray@linaro.org>
    gpio: 104-idio-16: Make irq_chip immutable

William Breathitt Gray <william.gray@linaro.org>
    gpio: 104-dio-48e: Make irq_chip immutable

Yupeng Li <liyupeng@zbhlos.com>
    LoongArch: Fix arch_remove_memory() undefined build error

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix section mismatch due to acpi_os_ioremap()

Luke D. Jones <luke@ljones.dev>
    platform/x86: asus-wmi: Increase FAN_CURVE_BUF_LEN to 32

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

Shyamin Ayesh <me@shyamin.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM610

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: use vbios carried pptable for all SMU13.0.7 SKUs

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: disable FRU access on special SIENNA CICHLID card

Greg Tulli <greg.iforce@gmail.com>
    Input: iforce - add support for Boeder Force Feedback Wheel

Li Qiong <liqiong@nfschina.com>
    ieee802154: cc2520: add rc code in cc2520_tx()

Wei Yongjun <weiyongjun1@huawei.com>
    gpio: mockup: remove gpio debugfs when remove device

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    r8152: add PID for the Lenovo OneLink+ Dock

Kai-Heng Feng <kai.heng.feng@canonical.com>
    tg3: Disable tg3 device on system reboot to avoid triggering AER

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix Get Device Flags

Even Xu <even.xu@intel.com>
    hid: intel-ish-hid: ishtp: Fix ishtp client sending disordered message

Jason Wang <wangborong@cdjrlc.com>
    HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: iio: gyroscope: bosch,bmg160: correct number of pins

Junaid Shahid <junaids@google.com>
    kvm: x86: mmu: Always flush TLBs when enabling dirty logging

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER error messages

Iwona Winiarska <iwona.winiarska@intel.com>
    peci: cpu: Fix use-after-free in adev_release()

Rob Clark <robdclark@chromium.org>
    drm/msm/rd: Fix FIFO-full deadlock

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add support for Surface Laptop Go 2

Ondrej Jirman <megi@xff.cz>
    Input: goodix - add support for GT1158

Chuanhong Guo <gch981213@gmail.com>
    ACPI: resource: skip IRQ override on AMD Zen platforms

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Fix UMR cleanup on error flow of driver init

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Add a umr recovery flow

Maher Sanalla <msanalla@nvidia.com>
    RDMA/mlx5: Rely on RoCE fw cap instead of devlink when setting profile

Yishai Hadas <yishaih@nvidia.com>
    net/mlx5: Use software VHCA id when it's supported

Yishai Hadas <yishaih@nvidia.com>
    net/mlx5: Introduce ifc bits for using software vhca id

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix kdump kernels boot failure with scalable mode


-------------

Diffstat:

 .../bindings/iio/gyroscope/bosch,bmg160.yaml       |   2 +
 Documentation/input/joydev/joystick.rst            |   1 +
 Makefile                                           |   4 +-
 arch/loongarch/Kconfig                             |   1 +
 arch/loongarch/include/asm/acpi.h                  |   2 +-
 arch/loongarch/kernel/acpi.c                       |   2 +-
 arch/loongarch/mm/init.c                           |  22 +++--
 arch/x86/kvm/mmu/mmu.c                             |  45 ++--------
 arch/x86/kvm/mmu/spte.h                            |  14 ++-
 arch/x86/kvm/x86.c                                 |  44 +++++++++
 drivers/acpi/resource.c                            |  10 +++
 drivers/gpio/gpio-104-dio-48e.c                    |  10 ++-
 drivers/gpio/gpio-104-idio-16.c                    |  18 ++--
 drivers/gpio/gpio-mockup.c                         |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c     |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  35 +++++---
 drivers/gpu/drm/msm/msm_rd.c                       |   3 +
 drivers/hid/intel-ish-hid/ishtp-hid.h              |   2 +-
 drivers/hid/intel-ish-hid/ishtp/client.c           |  68 ++++++++------
 drivers/hwmon/pmbus/pmbus_core.c                   |   9 +-
 drivers/infiniband/hw/irdma/uk.c                   |   3 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   4 +
 drivers/infiniband/hw/mlx5/main.c                  |   2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  13 ++-
 drivers/infiniband/hw/mlx5/umr.c                   |  81 ++++++++++++++---
 drivers/input/joystick/iforce/iforce-main.c        |   1 +
 drivers/input/touchscreen/goodix.c                 |   2 +
 drivers/iommu/intel/iommu.c                        | 100 +++++++++------------
 drivers/net/ethernet/broadcom/tg3.c                |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  72 ++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  14 ++-
 drivers/net/ieee802154/cc2520.c                    |   1 +
 drivers/net/usb/cdc_ether.c                        |   7 ++
 drivers/net/usb/r8152.c                            |   3 +
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/target/tcp.c                          |   3 +
 drivers/peci/cpu.c                                 |   3 +-
 drivers/perf/arm_pmu_platform.c                    |   2 +-
 .../platform/surface/surface_aggregator_registry.c |   3 +
 drivers/platform/x86/acer-wmi.c                    |   9 +-
 drivers/platform/x86/asus-wmi.c                    |   9 +-
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 include/linux/intel-iommu.h                        |   9 +-
 include/linux/mlx5/driver.h                        |  20 +++--
 include/linux/mlx5/mlx5_ifc.h                      |  25 +++++-
 net/bluetooth/mgmt.c                               |  71 +++++++++------
 net/dsa/tag_hellcreek.c                            |   2 +-
 49 files changed, 541 insertions(+), 251 deletions(-)


