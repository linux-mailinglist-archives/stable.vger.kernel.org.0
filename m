Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AEB26B068
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 00:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgIOWJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 18:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgIOUSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 16:18:22 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1B9C06178A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 13:17:34 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a19so4234213ilq.10
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 13:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8233hWho9xAv3jrZHve1ybB6KX3rxBr8Lk6tzRmgLi4=;
        b=Rs6wBEHdtoS9+BTk+k33GiT4evNOrCeUp5wnmrX+8GKLJy5rqmUuJkMh3fGF8H9cvF
         aXkUP7aiqhkCf1TRthFHKkbVxQcjKcirel4kUu8zGfGX2gj1mxkB0CfNXH3aGgxmhwdh
         NR3w8ez49EYo6wgPlWw94m3vBcE4pWR8LyeSvcDRU9UT3v59RMYawUkW9GY3+jAVdWPQ
         1SVSXomWaNBg936ILXWxU2VkkLqzk2oza9b0Niy/6b5sdJxxciBi51fG374V9FOJl4C7
         1i2euPE8QmtSwKE/VKg8KFKC8RNoh/BM14bMpTIRnJRJ5MSox99hYnWsRe96QBsia3Nf
         mYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=8233hWho9xAv3jrZHve1ybB6KX3rxBr8Lk6tzRmgLi4=;
        b=Vd0QUmQME67fKK885gTlU1s4ZXVQ5ihE8Ww85/PLrdx3zvk3HpuwIw3qFEIom/ZxEp
         I/Qi/L7QeZLXdIt4DvkO2M2ehUrpK5/F+EW1GVO0gFpOeUJk75afeSLOqJZMm7FmLELw
         6p1uzVc2V/jq/zHrSaCVmKHMc0poVZx3snf+xDjdvdVMEMEOO56Fw2ZyumLeln3FL5Au
         PYp1tlBOuBEZmASoc4c1a6YHswxtAKee8UOLCEvOVht71/U9yORgQpLXRgulN/ivUBZl
         4eF5jBZgvCEakdypQifZAa3WyWXiNhxlVAAJ2R2ueA7D4Nc8H4wTsVE2xYB16CcGI6kp
         CU/w==
X-Gm-Message-State: AOAM532nsVN0SohMOFvMBJLtsHwyT44zdEQmQj4fQW2W9o+hlWe3Lasd
        vO2AOembv+c6LmDq8tsQ3OB87g==
X-Google-Smtp-Source: ABdhPJweEUNVUHuTjJ+c+L6Wu6kLCZIAxq4PmY0Obg1AZ4NsI/5BQEpvrUkm2Gd0Bm1xXlxtBeKOew==
X-Received: by 2002:a92:dc81:: with SMTP id c1mr14054092iln.220.1600201053912;
        Tue, 15 Sep 2020 13:17:33 -0700 (PDT)
Received: from localhost ([2601:441:27f:8f73:89be:770e:7358:ee10])
        by smtp.gmail.com with ESMTPSA id 9sm9069632ilj.83.2020.09.15.13.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 13:17:33 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:17:32 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Jonathan Marek <jonathan@marek.ca>
Subject: Re: [PATCH 5.4 000/130] 5.4.66-rc2 review
Message-ID: <20200915201732.4474qpgnxwshanpw@nuc.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        ben.hutchings@codethink.co.uk, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Jonathan Marek <jonathan@marek.ca>
References: <20200915164455.372746145@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200915164455.372746145@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 06:45:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.66 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Sep 2020 16:44:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.66-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.4.66-rc2
> 
> Jordan Crouse <jcrouse@codeaurora.org>
>     drm/msm: Disable the RPTR shadow
> 
> Jonathan Marek <jonathan@marek.ca>
>     drm/msm/a6xx: update a6xx_hw_init for A640 and A650

This one ("drm/msm/a6xx: update a6xx_hw_init for A640 and A650") is
still causing builds to fail on arm and arm64.

#
# make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache aarch64-linux-gnu-gcc" O=build modules
#
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c: In function ‘a6xx_hw_init’:
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:414:6: error: implicit declaration of function ‘adreno_is_a640’; did you mean ‘adreno_is_a540’? [-Werror=implicit-function-declaration]
  414 |  if (adreno_is_a640(adreno_gpu) || adreno_is_a650(adreno_gpu)) {
      |      ^~~~~~~~~~~~~~
      |      adreno_is_a540
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:414:36: error: implicit declaration of function ‘adreno_is_a650’; did you mean ‘adreno_is_a540’? [-Werror=implicit-function-declaration]
  414 |  if (adreno_is_a640(adreno_gpu) || adreno_is_a650(adreno_gpu)) {
      |                                    ^~~~~~~~~~~~~~
      |                                    adreno_is_a540
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:415:18: error: ‘REG_A6XX_GBIF_QSB_SIDE0’ undeclared (first use in this function)
  415 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE0, 0x00071620);
      |                  ^~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:415:18: note: each undeclared identifier is reported only once for each function it appears in
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:416:18: error: ‘REG_A6XX_GBIF_QSB_SIDE1’ undeclared (first use in this function)
  416 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE1, 0x00071620);
      |                  ^~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:417:18: error: ‘REG_A6XX_GBIF_QSB_SIDE2’ undeclared (first use in this function)
  417 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE2, 0x00071620);
      |                  ^~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:418:18: error: ‘REG_A6XX_GBIF_QSB_SIDE3’ undeclared (first use in this function)
  418 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE3, 0x00071620);
      |                  ^~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[5]: *** [../scripts/Makefile.build:266: drivers/gpu/drm/msm/adreno/a6xx_gpu.o] Error 1
make[5]: Target '__build' not remade because of errors.
make[4]: *** [../scripts/Makefile.build:500: drivers/gpu/drm/msm] Error 2
make[4]: Target '__build' not remade because of errors.
make[3]: *** [../scripts/Makefile.build:500: drivers/gpu/drm] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [../scripts/Makefile.build:500: drivers/gpu] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/linux/Makefile:1729: drivers] Error 2
make[1]: Target 'modules' not remade because of errors.
make: *** [Makefile:179: sub-make] Error 2
make: Target 'modules' not remade because of errors.

Dan

> 
> Rob Clark <robdclark@chromium.org>
>     drm/msm/gpu: make ringbuffer readonly
> 
> Heikki Krogerus <heikki.krogerus@linux.intel.com>
>     usb: typec: ucsi: acpi: Check the _DEP dependencies
> 
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     usb: Fix out of sync data toggle if a configured device is reconfigured
> 
> Aleksander Morgado <aleksander@aleksander.es>
>     USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules
> 
> Bjørn Mork <bjorn@mork.no>
>     USB: serial: option: support dynamic Quectel USB compositions
> 
> Patrick Riphagen <patrick.riphagen@xsens.com>
>     USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter
> 
> Zeng Tao <prime.zeng@hisilicon.com>
>     usb: core: fix slab-out-of-bounds Read in read_descriptors
> 
> Sivaprakash Murugesan <sivaprak@codeaurora.org>
>     phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init
> 
> Vaibhav Agarwal <vaibhav.sr@gmail.com>
>     staging: greybus: audio: fix uninitialized value issue
> 
> Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
>     video: fbdev: fix OOB read in vga_8planes_imageblit()
> 
> Chris Healy <cphealy@gmail.com>
>     ARM: dts: vfxxx: Add syscon compatible with OCOTP
> 
> Vladis Dronov <vdronov@redhat.com>
>     debugfs: Fix module state check condition
> 
> Rustam Kovhaev <rkovhaev@gmail.com>
>     KVM: fix memory leak in kvm_io_bus_unregister_dev()
> 
> Marc Zyngier <maz@kernel.org>
>     KVM: arm64: Do not try to map PUDs when they are folded into PMD
> 
> Wanpeng Li <wanpengli@tencent.com>
>     KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit
> 
> Linus Torvalds <torvalds@linux-foundation.org>
>     vgacon: remove software scrollback support
> 
> Linus Torvalds <torvalds@linux-foundation.org>
>     fbcon: remove now unusued 'softback_lines' cursor() argument
> 
> Linus Torvalds <torvalds@linux-foundation.org>
>     fbcon: remove soft scrollback code
> 
> Mark Bloch <markb@mellanox.com>
>     RDMA/mlx4: Read pkey table length instead of hardcoded value
> 
> Yi Zhang <yi.zhang@redhat.com>
>     RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars
> 
> Ilya Dryomov <idryomov@gmail.com>
>     rbd: require global CAP_SYS_ADMIN for mapping and unmapping
> 
> Chris Packham <chris.packham@alliedtelesis.co.nz>
>     mmc: sdhci-of-esdhc: Don't walk device-tree on every interrupt
> 
> Adrian Hunter <adrian.hunter@intel.com>
>     mmc: sdio: Use mmc_pre_req() / mmc_post_req()
> 
> Jordan Crouse <jcrouse@codeaurora.org>
>     drm/msm: Disable preemption on all 5xx targets
> 
> Linus Walleij <linus.walleij@linaro.org>
>     drm/tve200: Stabilize enable/disable
> 
> Yan Zhao <yan.y.zhao@intel.com>
>     drm/i915/gvt: do not check len & max_len for lri
> 
> Hou Pu <houpu@bytedance.com>
>     scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem
> 
> Varun Prakash <varun@chelsio.com>
>     scsi: target: iscsi: Fix data digest calculation
> 
> Dmitry Osipenko <digetx@gmail.com>
>     regulator: core: Fix slab-out-of-bounds in regulator_unlock_recursive()
> 
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>     regulator: plug of_node leak in regulator_register()'s error path
> 
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>     regulator: push allocation in set_consumer_device_supply() out of lock
> 
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>     regulator: push allocations in create_regulator() outside of lock
> 
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>     regulator: push allocation in regulator_init_coupling() outside of lock
> 
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     kobject: Restore old behaviour of kobject_del(NULL)
> 
> Prateek Sood <prsood@codeaurora.org>
>     firmware_loader: fix memory leak for paged buffer
> 
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix wrong address when faulting in pages in the search ioctl
> 
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: fix lockdep splat in add_missing_dev
> 
> Qu Wenruo <wqu@suse.com>
>     btrfs: require only sector size alignment for parent eb bytenr
> 
> Rustam Kovhaev <rkovhaev@gmail.com>
>     staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:accel:mma8452: Fix timestamp alignment and prevent data leak.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:accel:mma7455: Fix timestamp alignment and prevent data leak.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio: accel: kxsd9: Fix alignment of local buffer.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:chemical:ccs811: Fix timestamp alignment and prevent data leak.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:light:max44000 Fix timestamp alignment and prevent data leak.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:magnetometer:ak8975 Fix alignment and data leak issues.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:adc:ti-adc081c Fix alignment and data leak issues
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:adc:max1118 Fix alignment of timestamp and data leak issues
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:adc:ina2xx Fix timestamp alignment issue.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:adc:ti-adc084s021 Fix alignment and data leak issues.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:accel:bmc150-accel: Fix timestamp alignment and prevent data leak.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:proximity:mb1232: Fix timestamp alignment and prevent data leak.
> 
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>     iio:light:ltr501 Fix timestamp alignment issue.
> 
> Gwendal Grignou <gwendal@chromium.org>
>     iio: cros_ec: Set Gyroscope default frequency to 25Hz
> 
> Maxim Kochetkov <fido_max@inbox.ru>
>     iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set
> 
> Angelo Compagnucci <angelo.compagnucci@gmail.com>
>     iio: adc: mcp3422: fix locking scope
> 
> Leon Romanovsky <leonro@nvidia.com>
>     gcov: Disable gcov build with GCC 10
> 
> Joerg Roedel <jroedel@suse.de>
>     iommu/amd: Do not use IOMMUv2 functionality when SME is active
> 
> Sandeep Raghuraman <sandy.8925@gmail.com>
>     drm/amdgpu: Fix bug in reporting voltage for CIK
> 
> Rander Wang <rander.wang@intel.com>
>     ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled
> 
> Rander Wang <rander.wang@intel.com>
>     ALSA: hda: hdmi - add Rocketlake support
> 
> Jessica Yu <jeyu@kernel.org>
>     arm64/module: set trampoline section flags regardless of CONFIG_DYNAMIC_FTRACE
> 
> Francisco Jerez <currojerez@riseup.net>
>     cpufreq: intel_pstate: Fix intel_pstate_get_hwp_max() for turbo disabled
> 
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: intel_pstate: Refuse to turn off with HWP enabled
> 
> Evgeniy Didin <Evgeniy.Didin@synopsys.com>
>     ARC: [plat-hsdk]: Switch ethernet phy-mode to rgmii-id
> 
> Dinghao Liu <dinghao.liu@zju.edu.cn>
>     HID: elan: Fix memleak in elan_input_configured
> 
> Xie He <xie.he.0141@gmail.com>
>     drivers/net/wan/hdlc_cisco: Add hard_header_len
> 
> Nicholas Miell <nmiell@gmail.com>
>     HID: microsoft: Add rumble support for the 8bitdo SN30 Pro+ controller
> 
> Nirenjan Krishnan <nirenjan@gmail.com>
>     HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for all Saitek X52 devices
> 
> Tong Zhang <ztong0001@gmail.com>
>     nvme-pci: cancel nvme device request before disabling
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-rdma: fix reset hang if controller died in the middle of a reset
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-rdma: fix timeout handler
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-rdma: serialize controller teardown sequences
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-tcp: fix reset hang if controller died in the middle of a reset
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-tcp: fix timeout handler
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-tcp: serialize controller teardown sequences
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme: have nvme_wait_freeze_timeout return if it timed out
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-fabrics: don't check state NVME_CTRL_NEW for request acceptance
> 
> Ziye Yang <ziye.yang@intel.com>
>     nvmet-tcp: Fix NULL dereference when a connect data comes in h2cdata pdu
> 
> Vineet Gupta <vgupta@synopsys.com>
>     irqchip/eznps: Fix build error for !ARC700 builds
> 
> Darrick J. Wong <darrick.wong@oracle.com>
>     xfs: initialize the shortform attr header padding entry
> 
> Amar Singhal <asinghal@codeaurora.org>
>     cfg80211: Adjust 6 GHz frequency to channel conversion
> 
> Xie He <xie.he.0141@gmail.com>
>     drivers/net/wan/lapbether: Set network_header before transmitting
> 
> Brian Foster <bfoster@redhat.com>
>     xfs: fix off-by-one in inode alloc block reservation calculation
> 
> Yi Li <yili@winhong.com>
>     net: hns3: Fix for geneve tx checksum bug
> 
> Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>     drivers/dma/dma-jz4780: Fix race condition between probe and irq handler
> 
> Mohan Kumar <mkumard@nvidia.com>
>     ALSA: hda/tegra: Program WAKEEN register for Tegra
> 
> Mohan Kumar <mkumard@nvidia.com>
>     ALSA: hda: Fix 2 channel swapping for Tegra
> 
> Dinghao Liu <dinghao.liu@zju.edu.cn>
>     firestream: Fix memleak in fs_open
> 
> Dinghao Liu <dinghao.liu@zju.edu.cn>
>     NFC: st95hf: Fix memleak in st95hf_in_send_cmd
> 
> Xie He <xie.he.0141@gmail.com>
>     drivers/net/wan/lapbether: Added needed_tailroom
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: allow sctp hearbeat after connection re-use
> 
> Hanjun Guo <guohanjun@huawei.com>
>     dmaengine: acpi: Put the CSRT table after using it
> 
> Vineet Gupta <vgupta@synopsys.com>
>     ARC: HSDK: wireup perf irq
> 
> Florian Fainelli <f.fainelli@gmail.com>
>     arm64: dts: ns2: Fixed QSPI compatible string
> 
> Florian Fainelli <f.fainelli@gmail.com>
>     ARM: dts: BCM5301X: Fixed QSPI compatible string
> 
> Florian Fainelli <f.fainelli@gmail.com>
>     ARM: dts: NSP: Fixed QSPI compatible string
> 
> Florian Fainelli <f.fainelli@gmail.com>
>     ARM: dts: bcm: HR2: Fixed QSPI compatible string
> 
> Sagi Grimberg <sagi@grimberg.me>
>     IB/isert: Fix unaligned immediate-data handling
> 
> Ritesh Harjani <riteshh@linux.ibm.com>
>     block: Set same_page to false in __bio_try_merge_page if ret is false
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     spi: stm32: fix pm_runtime_get_sync() error checking
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-fabrics: allow to queue requests for live queues
> 
> Marek Vasut <marex@denx.de>
>     spi: stm32: Rate-limit the 'Communication suspended' message
> 
> Douglas Anderson <dianders@chromium.org>
>     mmc: sdhci-msm: Add retries when all tuning phases are found valid
> 
> Raul E Rangel <rrangel@chromium.org>
>     mmc: sdhci-acpi: Clear amd_sdhci_host on reset
> 
> Maxime Ripard <maxime@cerno.tech>
>     drm/sun4i: backend: Disable alpha on the lowest plane on the A20
> 
> Maxime Ripard <maxime@cerno.tech>
>     drm/sun4i: backend: Support alpha property on lowest plane
> 
> Tom Rix <trix@redhat.com>
>     soundwire: fix double free of dangling pointer
> 
> Tomas Henzl <thenzl@redhat.com>
>     scsi: mpt3sas: Don't call disable_irq from IRQ poll handler
> 
> Tomas Henzl <thenzl@redhat.com>
>     scsi: megaraid_sas: Don't call disable_irq from process IRQ poll
> 
> Kamal Heib <kamalheib1@gmail.com>
>     RDMA/core: Fix reported speed and width
> 
> Luo Jiaxing <luojiaxing@huawei.com>
>     scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA
> 
> Angelo Compagnucci <angelo.compagnucci@gmail.com>
>     iio: adc: mcp3422: fix locking on error path
> 
> Ondrej Jirman <megous@megous.com>
>     drm/sun4i: Fix dsi dcs long write function
> 
> Krzysztof Kozlowski <krzk@kernel.org>
>     arm64: dts: imx8mq: Fix TMU interrupt property
> 
> Yu Kuai <yukuai3@huawei.com>
>     drm/sun4i: add missing put_device() call in sun8i_r40_tcon_tv_set_mux()
> 
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Do not report transparent vlan from QP1
> 
> Kamal Heib <kamalheib1@gmail.com>
>     RDMA/rxe: Fix panic when calling kmem_cache_create()
> 
> Kamal Heib <kamalheib1@gmail.com>
>     RDMA/rxe: Drop pointless checks in rxe_init_ports
> 
> Dinghao Liu <dinghao.liu@zju.edu.cn>
>     RDMA/rxe: Fix memleak in rxe_mem_init_user
> 
> Anson Huang <Anson.Huang@nxp.com>
>     ARM: dts: imx7ulp: Correct gpio ranges
> 
> Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
>     ARM: dts: ls1021a: fix QuadSPI-memory reg range
> 
> Po-Hsu Lin <po-hsu.lin@canonical.com>
>     selftests/timers: Turn off timeout setting
> 
> Dinh Nguyen <dinguyen@kernel.org>
>     ARM: dts: socfpga: fix register entry for timer3 on Arria10
> 
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>     regulator: remove superfluous lock in regulator_resolve_coupling()
> 
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>     regulator: push allocation in regulator_ena_gpio_request() out of lock
> 
> Adam Ford <aford173@gmail.com>
>     ARM: dts: logicpd-som-lv-baseboard: Fix missing video
> 
> Adam Ford <aford173@gmail.com>
>     ARM: dts: logicpd-som-lv-baseboard: Fix broken audio
> 
> Adam Ford <aford173@gmail.com>
>     ARM: dts: logicpd-torpedo-baseboard: Fix broken audio
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                                           |   4 +-
>  arch/arc/boot/dts/hsdk.dts                         |   6 +-
>  arch/arc/plat-eznps/include/plat/ctop.h            |   1 -
>  arch/arm/boot/dts/bcm-hr2.dtsi                     |   2 +-
>  arch/arm/boot/dts/bcm-nsp.dtsi                     |   2 +-
>  arch/arm/boot/dts/bcm5301x.dtsi                    |   2 +-
>  arch/arm/boot/dts/imx7ulp.dtsi                     |   8 +-
>  arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi    |  29 +-
>  arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi   |   2 +
>  arch/arm/boot/dts/ls1021a.dtsi                     |   2 +-
>  arch/arm/boot/dts/socfpga_arria10.dtsi             |   2 +-
>  arch/arm/boot/dts/vfxxx.dtsi                       |   2 +-
>  arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi   |   2 +-
>  arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   2 +-
>  arch/arm64/kernel/module-plts.c                    |   3 +-
>  arch/powerpc/configs/pasemi_defconfig              |   1 -
>  arch/powerpc/configs/ppc6xx_defconfig              |   1 -
>  arch/x86/configs/i386_defconfig                    |   1 -
>  arch/x86/configs/x86_64_defconfig                  |   1 -
>  arch/x86/kvm/vmx/vmx.c                             |   1 +
>  block/bio.c                                        |   4 +-
>  drivers/atm/firestream.c                           |   1 +
>  drivers/base/firmware_loader/firmware.h            |   2 +
>  drivers/base/firmware_loader/main.c                |  17 +-
>  drivers/block/rbd.c                                |  12 +
>  drivers/cpufreq/intel_pstate.c                     |  14 +-
>  drivers/dma/acpi-dma.c                             |   4 +-
>  drivers/dma/dma-jz4780.c                           |  38 +--
>  drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   3 +-
>  drivers/gpu/drm/i915/gvt/cmd_parser.c              |  12 -
>  drivers/gpu/drm/msm/adreno/a2xx_gpu.c              |   5 +
>  drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  10 +
>  drivers/gpu/drm/msm/adreno/a4xx_gpu.c              |  10 +
>  drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  14 +-
>  drivers/gpu/drm/msm/adreno/a6xx.xml.h              |  14 +
>  drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  62 +++-
>  drivers/gpu/drm/msm/adreno/adreno_gpu.c            |  27 +-
>  drivers/gpu/drm/msm/msm_ringbuffer.c               |   3 +-
>  drivers/gpu/drm/sun4i/sun4i_backend.c              |   4 +-
>  drivers/gpu/drm/sun4i/sun4i_tcon.c                 |   8 +-
>  drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c             |   4 +-
>  drivers/gpu/drm/tve200/tve200_display.c            |  22 +-
>  drivers/hid/hid-elan.c                             |   2 +
>  drivers/hid/hid-ids.h                              |   3 +
>  drivers/hid/hid-microsoft.c                        |   2 +
>  drivers/hid/hid-quirks.c                           |   2 +
>  drivers/iio/accel/bmc150-accel-core.c              |  15 +-
>  drivers/iio/accel/kxsd9.c                          |  16 +-
>  drivers/iio/accel/mma7455_core.c                   |  16 +-
>  drivers/iio/accel/mma8452.c                        |  11 +-
>  drivers/iio/adc/ina2xx-adc.c                       |  11 +-
>  drivers/iio/adc/max1118.c                          |  10 +-
>  drivers/iio/adc/mcp3422.c                          |  16 +-
>  drivers/iio/adc/ti-adc081c.c                       |  11 +-
>  drivers/iio/adc/ti-adc084s021.c                    |  10 +-
>  drivers/iio/adc/ti-ads1015.c                       |  10 +
>  drivers/iio/chemical/ccs811.c                      |  13 +-
>  .../common/cros_ec_sensors/cros_ec_sensors_core.c  |   5 +-
>  drivers/iio/light/ltr501.c                         |  15 +-
>  drivers/iio/light/max44000.c                       |  12 +-
>  drivers/iio/magnetometer/ak8975.c                  |  16 +-
>  drivers/iio/proximity/mb1232.c                     |  17 +-
>  drivers/infiniband/core/verbs.c                    |   2 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  21 +-
>  drivers/infiniband/hw/mlx4/main.c                  |   3 +-
>  drivers/infiniband/sw/rxe/rxe.c                    |   7 +-
>  drivers/infiniband/sw/rxe/rxe.h                    |   2 +
>  drivers/infiniband/sw/rxe/rxe_mr.c                 |   1 +
>  drivers/infiniband/sw/rxe/rxe_sysfs.c              |   5 +
>  drivers/infiniband/sw/rxe/rxe_verbs.c              |   2 +-
>  drivers/infiniband/ulp/isert/ib_isert.c            |  93 +++---
>  drivers/infiniband/ulp/isert/ib_isert.h            |  41 ++-
>  drivers/iommu/amd_iommu_v2.c                       |   7 +
>  drivers/mmc/core/sdio_ops.c                        |  39 +--
>  drivers/mmc/host/sdhci-acpi.c                      |  31 +-
>  drivers/mmc/host/sdhci-msm.c                       |  18 +-
>  drivers/mmc/host/sdhci-of-esdhc.c                  |  10 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   6 +-
>  drivers/net/wan/hdlc_cisco.c                       |   1 +
>  drivers/net/wan/lapbether.c                        |   3 +
>  drivers/nfc/st95hf/core.c                          |   2 +-
>  drivers/nvme/host/core.c                           |   3 +-
>  drivers/nvme/host/fabrics.c                        |  13 +-
>  drivers/nvme/host/nvme.h                           |   2 +-
>  drivers/nvme/host/pci.c                            |   4 +-
>  drivers/nvme/host/rdma.c                           |  68 +++--
>  drivers/nvme/host/tcp.c                            |  80 +++--
>  drivers/nvme/target/tcp.c                          |  10 +-
>  drivers/phy/qualcomm/phy-qcom-qmp.c                |  16 +-
>  drivers/phy/qualcomm/phy-qcom-qmp.h                |   2 +
>  drivers/regulator/core.c                           | 155 +++++-----
>  drivers/scsi/libsas/sas_ata.c                      |   5 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c        |   2 +-
>  drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +-
>  drivers/soundwire/stream.c                         |   8 +-
>  drivers/spi/spi-stm32.c                            |   8 +-
>  drivers/staging/greybus/audio_topology.c           |  29 +-
>  drivers/staging/wlan-ng/hfa384x_usb.c              |   5 -
>  drivers/staging/wlan-ng/prism2usb.c                |  19 +-
>  drivers/target/iscsi/iscsi_target.c                |  17 +-
>  drivers/target/iscsi/iscsi_target_login.c          |   6 +-
>  drivers/target/iscsi/iscsi_target_login.h          |   3 +-
>  drivers/target/iscsi/iscsi_target_nego.c           |   3 +-
>  drivers/usb/core/message.c                         |  91 +++---
>  drivers/usb/core/sysfs.c                           |   5 +
>  drivers/usb/serial/ftdi_sio.c                      |   1 +
>  drivers/usb/serial/ftdi_sio_ids.h                  |   1 +
>  drivers/usb/serial/option.c                        |  22 +-
>  drivers/usb/typec/ucsi/ucsi_acpi.c                 |   4 +
>  drivers/video/console/Kconfig                      |  46 ---
>  drivers/video/console/vgacon.c                     | 221 +-------------
>  drivers/video/fbdev/core/bitblit.c                 |  11 +-
>  drivers/video/fbdev/core/fbcon.c                   | 334 +--------------------
>  drivers/video/fbdev/core/fbcon.h                   |   2 +-
>  drivers/video/fbdev/core/fbcon_ccw.c               |  11 +-
>  drivers/video/fbdev/core/fbcon_cw.c                |  11 +-
>  drivers/video/fbdev/core/fbcon_ud.c                |  11 +-
>  drivers/video/fbdev/core/tileblit.c                |   2 +-
>  drivers/video/fbdev/vga16fb.c                      |   2 +-
>  fs/btrfs/extent-tree.c                             |  19 +-
>  fs/btrfs/ioctl.c                                   |   3 +-
>  fs/btrfs/print-tree.c                              |  12 +-
>  fs/btrfs/volumes.c                                 |  10 +
>  fs/debugfs/file.c                                  |   4 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c                      |   4 +-
>  fs/xfs/libxfs/xfs_ialloc.c                         |   4 +-
>  fs/xfs/libxfs/xfs_trans_space.h                    |   2 +-
>  include/linux/netfilter/nf_conntrack_sctp.h        |   2 +
>  include/soc/nps/common.h                           |   6 +
>  kernel/gcov/Kconfig                                |   1 +
>  lib/kobject.c                                      |   6 +-
>  net/netfilter/nf_conntrack_proto_sctp.c            |  39 ++-
>  net/wireless/util.c                                |   8 +-
>  sound/hda/hdac_device.c                            |   2 +
>  sound/pci/hda/hda_tegra.c                          |   7 +
>  sound/pci/hda/patch_hdmi.c                         |   6 +
>  tools/testing/selftests/timers/Makefile            |   1 +
>  tools/testing/selftests/timers/settings            |   1 +
>  virt/kvm/arm/mmu.c                                 |   7 +-
>  virt/kvm/kvm_main.c                                |  21 +-
>  140 files changed, 1064 insertions(+), 1207 deletions(-)
> 
> 

-- 
Linaro LKFT
https://lkft.linaro.org
