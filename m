Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33412E1DF3
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgLWPdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgLWPdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:33:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5938F23340;
        Wed, 23 Dec 2020 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737552;
        bh=DXXjcAZnf0rcQGlEid33oK1AyAIzkMZbFoTrthUQAnw=;
        h=From:To:Cc:Subject:Date:From;
        b=NxOO8HRBYcqXorKyE8alapyr1oljrO+CHbPEoQXGmzfRRfNpRw+Pbh2pvibnDUP+1
         QCbd1lHKVvstJquZTA4GrfKMqgSaDTma0394GVRxtYG1EATfl55OpdhZzTxkmoZX7s
         m7ccSyd4eJYloFOToEnplfA65sSnQtzoZ4VQcs/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.10 00/40] 5.10.3-rc1 review
Date:   Wed, 23 Dec 2020 16:33:01 +0100
Message-Id: <20201223150515.553836647@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.3-rc1
X-KernelTest-Deadline: 2020-12-25T15:05+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.3 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 25 Dec 2020 15:05:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.3-rc1

Dae R. Jeong <dae.r.jeong@kaist.ac.kr>
    md: fix a warning caused by a race between concurrent md_ioctl()s

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    nl80211: validate key indexes for cfg80211_registered_device

Eric Biggers <ebiggers@google.com>
    crypto: af_alg - avoid undefined behavior accessing salg_name

Antti Palosaari <crope@iki.fi>
    media: msi2500: assign SPI bus number dynamically

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    fs: quota: fix array-index-out-of-bounds bug by passing correct argument to vfs_cleanup_quota_inode()

Jan Kara <jack@suse.cz>
    quota: Sanity-check quota file headers on load

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()

Eric Biggers <ebiggers@google.com>
    f2fs: prevent creating duplicate encrypted filenames

Eric Biggers <ebiggers@google.com>
    ext4: prevent creating duplicate encrypted filenames

Eric Biggers <ebiggers@google.com>
    ubifs: prevent creating duplicate encrypted filenames

Eric Biggers <ebiggers@google.com>
    fscrypt: add fscrypt_is_nokey_name()

Eric Biggers <ebiggers@google.com>
    fscrypt: remove kernel-internal constants from UAPI header

Alexey Kardashevskiy <aik@ozlabs.ru>
    serial_core: Check for port state when tty is in error state

Julian Sax <jsbc@gmx.de>
    HID: i2c-hid: add Vero K147 to descriptor override

Arnd Bergmann <arnd@arndb.de>
    scsi: megaraid_sas: Check user-provided offsets

Jack Qiu <jack.qiu@huawei.com>
    f2fs: init dirty_secmap incorrectly

Chao Yu <chao@kernel.org>
    f2fs: fix to seek incorrect data offset in inline data file

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Handle TRCVIPCSSCTLR accesses

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Fix accesses to TRCPROCSELR

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Fix accesses to TRCCIDCTLR1

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Fix accesses to TRCVMIDCTLR1

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: etm4x: Skip setting LPOVERRIDE bit for qcom, skip-power-up

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: etb10: Fix possible NULL ptr dereference in etb_enable_perf()

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc-etr: Fix barrier packet insertion for perf buffer

Mao Jinlong <jinlmao@codeaurora.org>
    coresight: tmc-etr: Check if page is valid before dma_map_page()

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: tmc-etf: Fix NULL ptr dereference in tmc_enable_etf_sink_perf()

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: fix USB 3.0 pins supply being turned off on Odroid XU

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: fix USB 3.0 VBUS control and over-current pins on Exynos5410

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: fix roles of USB 3.0 ports on Odroid XU

Fabio Estevam <festevam@gmail.com>
    usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to imx6ul

Will McVicker <willmcvicker@google.com>
    USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

Jack Pham <jackp@codeaurora.org>
    usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus

Will McVicker <willmcvicker@google.com>
    USB: gadget: f_midi: setup SuperSpeed Plus descriptors

taehyun.cho <taehyun.cho@samsung.com>
    USB: gadget: f_acm: add support for SuperSpeed Plus

Johan Hovold <johan@kernel.org>
    USB: serial: option: add interface-number sanity check to flag handling

Dan Carpenter <dan.carpenter@oracle.com>
    usb: mtu3: fix memory corruption in mtu3_debugfs_regset()

Nicolin Chen <nicoleotsuka@gmail.com>
    soc/tegra: fuse: Fix index bug in get_process_id

Artem Labazov <123321artyom@gmail.com>
    exfat: Avoid allocating upcase table using kcalloc()

Andi Kleen <ak@linux.intel.com>
    x86/split-lock: Avoid returning with interrupts enabled

Thierry Reding <treding@nvidia.com>
    net: ipconfig: Avoid spurious blank lines in boot log


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |  6 ++-
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi          | 28 ++++++++++++
 arch/arm/boot/dts/exynos5410.dtsi                  |  4 ++
 arch/x86/kernel/traps.c                            |  3 +-
 crypto/af_alg.c                                    | 10 +++--
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  8 ++++
 drivers/hwtracing/coresight/coresight-etb10.c      |  4 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 41 ++++++++++-------
 drivers/hwtracing/coresight/coresight-priv.h       |  2 +
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |  4 +-
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |  4 +-
 drivers/md/md.c                                    |  7 ++-
 drivers/media/usb/msi2500/msi2500.c                |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          | 16 ++++---
 drivers/soc/tegra/fuse/speedo-tegra210.c           |  2 +-
 drivers/tty/serial/serial_core.c                   |  4 ++
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  3 +-
 drivers/usb/gadget/function/f_acm.c                |  2 +-
 drivers/usb/gadget/function/f_fs.c                 |  5 ++-
 drivers/usb/gadget/function/f_midi.c               |  6 +++
 drivers/usb/gadget/function/f_rndis.c              |  4 +-
 drivers/usb/mtu3/mtu3_debugfs.c                    |  2 +-
 drivers/usb/serial/option.c                        | 23 +++++++++-
 fs/crypto/fscrypt_private.h                        |  9 ++--
 fs/crypto/hooks.c                                  |  5 ++-
 fs/crypto/keyring.c                                |  2 +-
 fs/crypto/keysetup.c                               |  4 +-
 fs/crypto/policy.c                                 |  5 ++-
 fs/exfat/nls.c                                     |  6 +--
 fs/ext4/namei.c                                    |  3 ++
 fs/f2fs/f2fs.h                                     |  2 +
 fs/f2fs/file.c                                     | 11 +++--
 fs/f2fs/segment.c                                  |  2 +-
 fs/quota/dquot.c                                   |  2 +-
 fs/quota/quota_v2.c                                | 19 ++++++++
 fs/ubifs/dir.c                                     | 17 ++++++--
 include/linux/fscrypt.h                            | 34 +++++++++++++++
 include/uapi/linux/fscrypt.h                       |  5 +--
 include/uapi/linux/if_alg.h                        | 16 +++++++
 net/bluetooth/hci_event.c                          | 12 +++--
 net/ipv4/ipconfig.c                                | 14 +++---
 net/wireless/core.h                                |  2 +
 net/wireless/nl80211.c                             |  7 +--
 net/wireless/util.c                                | 51 ++++++++++++++++++----
 45 files changed, 334 insertions(+), 88 deletions(-)


