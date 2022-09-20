Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3207E5BE3FB
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 12:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiITK5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 06:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiITK52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 06:57:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A796AA25;
        Tue, 20 Sep 2022 03:57:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FBC961AD7;
        Tue, 20 Sep 2022 10:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0E1C433C1;
        Tue, 20 Sep 2022 10:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663671445;
        bh=gyxIGov2d3eyMT2MP12MNGxutPHEBZwezk359v0P3ls=;
        h=From:To:Cc:Subject:Date:From;
        b=YYF4hcRJ9ZMrP9bhay8kcvgLRoU14XVWcDKiUwte+YDURPi1OeruGI8r997Ljockr
         dz2DQAkAdEcyMWklS84rddaWwvdVigtlWkF64CXFdEml4iwbRg/qptVNJuwFAJyxQf
         U8IvEQXs17EjjL/CyVDHlnkvKDGCT3XERnbF7T4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.10
Date:   Tue, 20 Sep 2022 12:57:50 +0200
Message-Id: <166367147060132@kroah.com>
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

I'm announcing the release of the 5.19.10 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml |    2 
 Documentation/input/joydev/joystick.rst                           |    1 
 Makefile                                                          |    2 
 arch/loongarch/Kconfig                                            |    1 
 arch/loongarch/include/asm/acpi.h                                 |    2 
 arch/loongarch/kernel/acpi.c                                      |    2 
 arch/loongarch/mm/init.c                                          |   22 +-
 arch/x86/kvm/mmu/mmu.c                                            |   45 ----
 arch/x86/kvm/mmu/spte.h                                           |   14 +
 arch/x86/kvm/x86.c                                                |   44 ++++
 drivers/acpi/resource.c                                           |   10 +
 drivers/gpio/gpio-104-dio-48e.c                                   |   10 -
 drivers/gpio/gpio-104-idio-16.c                                   |   18 +
 drivers/gpio/gpio-mockup.c                                        |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c                    |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                           |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c              |   35 ++-
 drivers/gpu/drm/msm/msm_rd.c                                      |    3 
 drivers/hid/intel-ish-hid/ishtp-hid.h                             |    2 
 drivers/hid/intel-ish-hid/ishtp/client.c                          |   68 +++---
 drivers/infiniband/hw/irdma/uk.c                                  |    3 
 drivers/infiniband/hw/mlx5/cq.c                                   |    4 
 drivers/infiniband/hw/mlx5/main.c                                 |    2 
 drivers/infiniband/hw/mlx5/mlx5_ib.h                              |   13 +
 drivers/infiniband/hw/mlx5/umr.c                                  |   81 +++++++-
 drivers/input/joystick/iforce/iforce-main.c                       |    1 
 drivers/input/touchscreen/goodix.c                                |    2 
 drivers/iommu/intel/iommu.c                                       |  100 ++++------
 drivers/net/ethernet/broadcom/tg3.c                               |    8 
 drivers/net/ethernet/mellanox/mlx5/core/fw.c                      |    4 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                    |   72 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/vport.c                   |   14 +
 drivers/net/ieee802154/cc2520.c                                   |    1 
 drivers/net/usb/cdc_ether.c                                       |    7 
 drivers/net/usb/r8152.c                                           |    3 
 drivers/nvme/host/pci.c                                           |    2 
 drivers/nvme/target/tcp.c                                         |    3 
 drivers/peci/cpu.c                                                |    3 
 drivers/perf/arm_pmu_platform.c                                   |    2 
 drivers/platform/surface/surface_aggregator_registry.c            |    3 
 drivers/platform/x86/acer-wmi.c                                   |    9 
 drivers/platform/x86/asus-wmi.c                                   |    9 
 drivers/usb/storage/unusual_uas.h                                 |    7 
 include/linux/intel-iommu.h                                       |    9 
 include/linux/mlx5/driver.h                                       |   20 +-
 include/linux/mlx5/mlx5_ifc.h                                     |   25 ++
 net/bluetooth/mgmt.c                                              |   71 ++++---
 net/dsa/tag_hellcreek.c                                           |    2 
 48 files changed, 536 insertions(+), 245 deletions(-)

Aharon Landau (1):
      RDMA/mlx5: Add a umr recovery flow

Chengming Gui (1):
      drm/amd/amdgpu: skip ucode loading if ucode_size == 0

Chuanhong Guo (1):
      ACPI: resource: skip IRQ override on AMD Zen platforms

Evan Quan (1):
      drm/amd/pm: use vbios carried pptable for all SMU13.0.7 SKUs

Even Xu (1):
      hid: intel-ish-hid: ishtp: Fix ishtp client sending disordered message

Greg Kroah-Hartman (1):
      Linux 5.19.10

Greg Tulli (1):
      Input: iforce - add support for Boeder Force Feedback Wheel

Guchun Chen (1):
      drm/amdgpu: disable FRU access on special SIENNA CICHLID card

Hans de Goede (1):
      platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes

Hu Xiaoying (1):
      usb: storage: Add ASUS <0x0b05:0x1932> to IGNORE_UAS

Huacai Chen (1):
      LoongArch: Fix section mismatch due to acpi_os_ioremap()

Iwona Winiarska (1):
      peci: cpu: Fix use-after-free in adev_release()

Jarrah Gosbell (1):
      Input: goodix - add compatible string for GT1158

Jason Wang (1):
      HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo

Jean-Francois Le Fillatre (1):
      r8152: add PID for the Lenovo OneLink+ Dock

Junaid Shahid (1):
      kvm: x86: mmu: Always flush TLBs when enabling dirty logging

Kai-Heng Feng (1):
      tg3: Disable tg3 device on system reboot to avoid triggering AER

Krzysztof Kozlowski (1):
      dt-bindings: iio: gyroscope: bosch,bmg160: correct number of pins

Kurt Kanzenbach (1):
      net: dsa: hellcreek: Print warning only once

Li Qiong (1):
      ieee802154: cc2520: add rc code in cc2520_tx()

Lu Baolu (1):
      iommu/vt-d: Fix kdump kernels boot failure with scalable mode

Luiz Augusto von Dentz (1):
      Bluetooth: MGMT: Fix Get Device Flags

Luke D. Jones (1):
      platform/x86: asus-wmi: Increase FAN_CURVE_BUF_LEN to 32

Maher Sanalla (1):
      RDMA/mlx5: Rely on RoCE fw cap instead of devlink when setting profile

Maor Gottlieb (1):
      RDMA/mlx5: Fix UMR cleanup on error flow of driver init

Maurizio Lombardi (1):
      nvmet-tcp: fix unhandled tcp states in nvmet_tcp_state_change()

Maximilian Luz (1):
      platform/surface: aggregator_registry: Add support for Surface Laptop Go 2

Ondrej Jirman (1):
      Input: goodix - add support for GT1158

Rob Clark (1):
      drm/msm/rd: Fix FIFO-full deadlock

Shyamin Ayesh (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM610

Sindhu-Devale (1):
      RDMA/irdma: Use s/g array in post send only when its valid

Wei Yongjun (1):
      gpio: mockup: remove gpio debugfs when remove device

William Breathitt Gray (2):
      gpio: 104-dio-48e: Make irq_chip immutable
      gpio: 104-idio-16: Make irq_chip immutable

Yishai Hadas (2):
      net/mlx5: Introduce ifc bits for using software vhca id
      net/mlx5: Use software VHCA id when it's supported

Yu Zhe (1):
      perf/arm_pmu_platform: fix tests for platform_get_irq() failure

Yupeng Li (1):
      LoongArch: Fix arch_remove_memory() undefined build error

