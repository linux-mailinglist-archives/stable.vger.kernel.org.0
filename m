Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E822E2E7A
	for <lists+stable@lfdr.de>; Sat, 26 Dec 2020 16:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgLZPVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Dec 2020 10:21:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgLZPVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Dec 2020 10:21:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3088207FF;
        Sat, 26 Dec 2020 15:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608996025;
        bh=iQ8CrUusqY4BaFkwe3gir/1OGASCiElMG71Gw2O0Ylw=;
        h=From:To:Cc:Subject:Date:From;
        b=07oTNh7+HgMD1rw5VH81sbuK3PYaL6c3ZaIO4QjgvyqJbEm/Xf8jwrbLsyTLGxlp1
         ZRRFLQ8e9rrhj6ld2twmKkp10On3Bv2js4K8rmc8l8D6P6DLyrWLHvsfAiZQcQcrsR
         vCc9JATGj2r08Tvef/NY/IT+mdqdlyjtf8m6rJsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.3
Date:   Sat, 26 Dec 2020 16:20:21 +0100
Message-Id: <16089960203931@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.3 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |    6 +-
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi          |   28 +++++++++++
 arch/arm/boot/dts/exynos5410.dtsi                  |    4 +
 arch/x86/kernel/traps.c                            |    3 -
 crypto/af_alg.c                                    |   10 ++--
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |    8 +++
 drivers/hwtracing/coresight/coresight-etb10.c      |    4 +
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   41 ++++++++++------
 drivers/hwtracing/coresight/coresight-priv.h       |    2 
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |    4 +
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |    4 +
 drivers/md/md.c                                    |    7 ++
 drivers/media/usb/msi2500/msi2500.c                |    2 
 drivers/scsi/megaraid/megaraid_sas_base.c          |   16 ++++--
 drivers/soc/tegra/fuse/speedo-tegra210.c           |    2 
 drivers/tty/serial/serial_core.c                   |    4 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |    3 -
 drivers/usb/gadget/function/f_acm.c                |    2 
 drivers/usb/gadget/function/f_fs.c                 |    5 +-
 drivers/usb/gadget/function/f_midi.c               |    6 ++
 drivers/usb/gadget/function/f_rndis.c              |    4 +
 drivers/usb/mtu3/mtu3_debugfs.c                    |    2 
 drivers/usb/serial/option.c                        |   23 ++++++++-
 fs/crypto/fscrypt_private.h                        |    9 ++-
 fs/crypto/hooks.c                                  |    5 +-
 fs/crypto/keyring.c                                |    2 
 fs/crypto/keysetup.c                               |    4 +
 fs/crypto/policy.c                                 |    5 +-
 fs/exfat/nls.c                                     |    6 +-
 fs/ext4/namei.c                                    |    3 +
 fs/f2fs/f2fs.h                                     |    2 
 fs/f2fs/file.c                                     |   11 +++-
 fs/f2fs/segment.c                                  |    2 
 fs/quota/dquot.c                                   |    2 
 fs/quota/quota_v2.c                                |   19 +++++++
 fs/ubifs/dir.c                                     |   17 +++++--
 include/linux/fscrypt.h                            |   34 ++++++++++++++
 include/uapi/linux/fscrypt.h                       |    5 --
 include/uapi/linux/if_alg.h                        |   16 ++++++
 net/bluetooth/hci_event.c                          |   12 ++--
 net/ipv4/ipconfig.c                                |   14 +++--
 net/wireless/core.h                                |    2 
 net/wireless/nl80211.c                             |    7 +-
 net/wireless/util.c                                |   51 +++++++++++++++++----
 45 files changed, 333 insertions(+), 87 deletions(-)

Alexey Kardashevskiy (1):
      serial_core: Check for port state when tty is in error state

Anant Thazhemadam (2):
      fs: quota: fix array-index-out-of-bounds bug by passing correct argument to vfs_cleanup_quota_inode()
      nl80211: validate key indexes for cfg80211_registered_device

Andi Kleen (1):
      x86/split-lock: Avoid returning with interrupts enabled

Antti Palosaari (1):
      media: msi2500: assign SPI bus number dynamically

Arnd Bergmann (1):
      scsi: megaraid_sas: Check user-provided offsets

Artem Labazov (1):
      exfat: Avoid allocating upcase table using kcalloc()

Chao Yu (1):
      f2fs: fix to seek incorrect data offset in inline data file

Dae R. Jeong (1):
      md: fix a warning caused by a race between concurrent md_ioctl()s

Dan Carpenter (1):
      usb: mtu3: fix memory corruption in mtu3_debugfs_regset()

Eric Biggers (6):
      fscrypt: remove kernel-internal constants from UAPI header
      fscrypt: add fscrypt_is_nokey_name()
      ubifs: prevent creating duplicate encrypted filenames
      ext4: prevent creating duplicate encrypted filenames
      f2fs: prevent creating duplicate encrypted filenames
      crypto: af_alg - avoid undefined behavior accessing salg_name

Fabio Estevam (1):
      usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to imx6ul

Greg Kroah-Hartman (1):
      Linux 5.10.3

Jack Pham (1):
      usb: gadget: f_fs: Re-use SS descriptors for SuperSpeedPlus

Jack Qiu (1):
      f2fs: init dirty_secmap incorrectly

Jan Kara (1):
      quota: Sanity-check quota file headers on load

Johan Hovold (1):
      USB: serial: option: add interface-number sanity check to flag handling

Julian Sax (1):
      HID: i2c-hid: add Vero K147 to descriptor override

Krzysztof Kozlowski (3):
      ARM: dts: exynos: fix roles of USB 3.0 ports on Odroid XU
      ARM: dts: exynos: fix USB 3.0 VBUS control and over-current pins on Exynos5410
      ARM: dts: exynos: fix USB 3.0 pins supply being turned off on Odroid XU

Mao Jinlong (1):
      coresight: tmc-etr: Check if page is valid before dma_map_page()

Nicolin Chen (1):
      soc/tegra: fuse: Fix index bug in get_process_id

Peilin Ye (1):
      Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()

Sai Prakash Ranjan (3):
      coresight: tmc-etf: Fix NULL ptr dereference in tmc_enable_etf_sink_perf()
      coresight: etb10: Fix possible NULL ptr dereference in etb_enable_perf()
      coresight: etm4x: Skip setting LPOVERRIDE bit for qcom, skip-power-up

Suzuki K Poulose (5):
      coresight: tmc-etr: Fix barrier packet insertion for perf buffer
      coresight: etm4x: Fix accesses to TRCVMIDCTLR1
      coresight: etm4x: Fix accesses to TRCCIDCTLR1
      coresight: etm4x: Fix accesses to TRCPROCSELR
      coresight: etm4x: Handle TRCVIPCSSCTLR accesses

Thierry Reding (1):
      net: ipconfig: Avoid spurious blank lines in boot log

Will McVicker (2):
      USB: gadget: f_midi: setup SuperSpeed Plus descriptors
      USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

taehyun.cho (1):
      USB: gadget: f_acm: add support for SuperSpeed Plus

