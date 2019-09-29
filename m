Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1799C157F
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfI2OCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbfI2OCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F086721882;
        Sun, 29 Sep 2019 14:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765772;
        bh=VMET+PjEaLvGZp3XEaxxb8FxyhaWnRrGnESSoSLxdfc=;
        h=From:To:Cc:Subject:Date:From;
        b=JdoWiya3EhQz/pivuMpNJ8HVnEl9BTjq79Y8mWIHs6k+gftMZ3nFhYlt71W6exkT8
         hONAG+6RcE3KBxTHoQj4Oy/Hn9mhNtWA2I406xBO46mtOtb+ds+VHg77GCzeZtTrL0
         0tooV5K0oeK1uE9KOezpzFyIxUXWHM6LnOPeiTac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 00/25] 5.3.2-stable review
Date:   Sun, 29 Sep 2019 15:56:03 +0200
Message-Id: <20190929135006.127269625@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.2-rc1
X-KernelTest-Deadline: 2019-10-01T13:50+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.2 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.2-rc1

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Clobber user CFLAGS variable

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    platform/x86: i2c-multi-instantiate: Derive the device name from parent

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Apply AMD controller workaround for Raven platform

Shih-Yuan Lee (FourDollars) <fourdollars@debian.org>
    ALSA: hda - Add laptop imic fixup for ASUS M9V laptop

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix wrong packet parameter for Alesis iO26

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Add DSD support for EVGA NU Audio

Ilya Pshonkin <sudokamikaze@protonmail.com>
    ALSA: usb-audio: Add Hiby device family to quirks for native DSD support

Vitaly Wool <vitalywool@gmail.com>
    Revert "mm/z3fold.c: fix race between migration and destruction"

Peng Fan <peng.fan@nxp.com>
    clk: imx: imx8mm: fix audio pll setting

Gustavo A. R. Silva <gustavo@embeddedor.com>
    crypto: talitos - fix missing break in switch statement

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Use chip_good() to retry in do_write_oneword()

Sebastian Parschauer <s.parschauer@gmx.de>
    HID: Add quirk for HP X500 PIXART OEM mouse

Alan Stern <stern@rowland.harvard.edu>
    HID: hidraw: Fix invalid read in hidraw_ioctl

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-dj: Fix crash when initial logi_dj_recv_query_paired_devices fails

Alan Stern <stern@rowland.harvard.edu>
    HID: logitech: Fix general protection fault caused by Logitech driver

Roderick Colenbrander <roderick.colenbrander@sony.com>
    HID: sony: Fix memory corruption issue on cleanup.

Alan Stern <stern@rowland.harvard.edu>
    HID: prodikeys: Fix general protection fault during probe

Greg Kurz <groug@kaod.org>
    powerpc/xive: Fix bogus error code returned by OPAL

Nick Desaulniers <ndesaulniers@google.com>
    drm/amd/display: readd -msse2 to prevent Clang from emitting libcalls to undefined SW FP routines

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Don't replace the dc_state for fast updates

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Skip determining update type for async updates

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Allow cursor async updates for framebuffer swaps

Jon Hunter <jonathanh@nvidia.com>
    clocksource/drivers: Do not warn on probe defer

Jon Hunter <jonathanh@nvidia.com>
    clocksource/drivers/timer-of: Do not warn on deferred probe

Jeremy Sowden <jeremy@azazel.net>
    netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/powerpc/include/asm/opal.h                   |  2 +-
 arch/powerpc/platforms/powernv/opal-call.c        |  2 +-
 arch/powerpc/sysdev/xive/native.c                 | 11 +++
 drivers/clk/imx/clk-imx8mm.c                      |  4 +-
 drivers/clocksource/timer-of.c                    |  6 +-
 drivers/clocksource/timer-probe.c                 |  4 +-
 drivers/crypto/talitos.c                          |  1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 56 ++++++++++----
 drivers/gpu/drm/amd/display/dc/calcs/Makefile     |  4 +
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile     |  4 +
 drivers/gpu/drm/amd/display/dc/dml/Makefile       |  4 +
 drivers/gpu/drm/amd/display/dc/dsc/Makefile       |  4 +
 drivers/hid/hid-ids.h                             |  1 +
 drivers/hid/hid-lg.c                              | 10 ++-
 drivers/hid/hid-lg4ff.c                           |  1 -
 drivers/hid/hid-logitech-dj.c                     | 10 +--
 drivers/hid/hid-prodikeys.c                       | 12 ++-
 drivers/hid/hid-quirks.c                          |  1 +
 drivers/hid/hid-sony.c                            |  2 +-
 drivers/hid/hidraw.c                              |  2 +-
 drivers/mtd/chips/cfi_cmdset_0002.c               | 18 +++--
 drivers/platform/x86/i2c-multi-instantiate.c      |  2 +-
 include/net/netfilter/nf_tables.h                 |  4 +
 mm/z3fold.c                                       | 90 -----------------------
 sound/firewire/dice/dice-alesis.c                 |  2 +-
 sound/pci/hda/hda_intel.c                         |  3 +-
 sound/pci/hda/patch_analog.c                      |  1 +
 sound/usb/quirks.c                                |  2 +
 tools/objtool/Makefile                            |  2 +-
 30 files changed, 130 insertions(+), 139 deletions(-)


