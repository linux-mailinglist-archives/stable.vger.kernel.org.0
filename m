Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882F638ED37
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhEXPe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhEXPdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:33:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 161B4613F3;
        Mon, 24 May 2021 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870298;
        bh=sxHF9u8X4s/tujxDufRWWDRa3/f0rWst6hprUmo+Z3w=;
        h=From:To:Cc:Subject:Date:From;
        b=wTSpW4NZczwBpcXkveIbT6JM8LNkyqLO8Y8xlvfzicTinG7KUYOjSJdQn4O+ImEu1
         YaqoEXsxFK52JKU4aPT3CD4Noyh4h1O1uevm7bdslLD8D9xUYTuX1hpfmJifs8Iov1
         1Ymoc6EDjTSO+18orGfMbGvfYe18VedrQru3Eiug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/31] 4.4.270-rc1 review
Date:   Mon, 24 May 2021 17:24:43 +0200
Message-Id: <20210524152322.919918360@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.270-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.270-rc1
X-KernelTest-Deadline: 2021-05-26T15:23+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.270 release.
There are 31 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.270-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.270-rc1

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tty: vt: always invoke vc->vc_sw->con_resize callback

Maciej W. Rozycki <macro@orcam.me.uk>
    vt: Fix character height handling with VT_RESIZEX

Maciej W. Rozycki <macro@orcam.me.uk>
    vgacon: Record video mode changes with VT_RESIZEX

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    video: hgafb: fix potential NULL pointer dereference

Tom Seewald <tseewald@gmail.com>
    qlcnic: Add null check after calling netdev_alloc_skb

Phillip Potter <phil@philpotter.co.uk>
    leds: lp5523: check return value of lp5xx_read and jump to cleanup code

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: rtlwifi: properly check for alloc_workqueue() failure

Anirudh Rayabharam <mail@anirudhrb.com>
    net: stmicro: handle clk_prepare() failure during init

Du Cheng <ducheng2@gmail.com>
    ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "niu: fix missing checks of niu_pci_eeprom_read"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "qlcnic: Avoid potential NULL pointer dereference"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "rtlwifi: fix a potential NULL pointer dereference"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    cdrom: gdrom: initialize global variable at init time

Atul Gopinathan <atulgopinathan@gmail.com>
    cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "gdrom: fix a memory leak bug"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ecryptfs: replace BUG_ON with error handling code"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "video: imsttfb: fix potential NULL pointer dereferences"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "leds: lp5523: fix a missing check of return value of lp55xx_read"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: stmicro: fix a missing check of clk_prepare"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "video: hgafb: fix potential NULL pointer dereference"

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: fix crash with transient storage and zero chunk size

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: fix a crash when an origin has no snapshots

Jan Beulich <jbeulich@suse.com>
    xen-pciback: reconfigure also from backend watch handler

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: sb8: add a check for request_region"

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate MS endpoint descriptors

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix memory leak in smb2_copychunk_range

Oleg Nesterov <oleg@redhat.com>
    ptrace: make ptrace() fail if the tracee changed its pid unexpectedly

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    openrisc: Fix a memory leak


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/openrisc/kernel/setup.c                       |  2 +
 drivers/cdrom/gdrom.c                              | 13 +++--
 drivers/hwmon/lm80.c                               | 11 +----
 drivers/leds/leds-lp5523.c                         |  2 +-
 drivers/md/dm-snap.c                               |  6 +--
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |  3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |  8 ++--
 drivers/net/ethernet/sun/niu.c                     | 32 ++++++++-----
 drivers/net/wireless/realtek/rtlwifi/base.c        | 19 ++++----
 drivers/scsi/qla2xxx/qla_nx.c                      |  3 +-
 drivers/tty/vt/vt.c                                |  2 +-
 drivers/tty/vt/vt_ioctl.c                          |  6 +--
 drivers/video/console/fbcon.c                      |  2 +-
 drivers/video/console/vgacon.c                     | 56 ++++++++++++----------
 drivers/video/fbdev/hgafb.c                        | 21 ++++----
 drivers/video/fbdev/imsttfb.c                      |  5 --
 drivers/xen/xen-pciback/xenbus.c                   | 22 +++++++--
 fs/cifs/smb2ops.c                                  |  2 +
 fs/ecryptfs/crypto.c                               |  6 +--
 include/linux/console_struct.h                     |  1 +
 kernel/ptrace.c                                    | 18 ++++++-
 sound/firewire/Kconfig                             |  4 +-
 sound/firewire/bebob/bebob.c                       |  2 +-
 sound/firewire/oxfw/oxfw.c                         |  1 -
 sound/isa/sb/sb8.c                                 |  4 --
 sound/usb/midi.c                                   |  4 ++
 27 files changed, 152 insertions(+), 107 deletions(-)


