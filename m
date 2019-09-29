Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23EAC15AD
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfI2OAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbfI2OAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:00:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0CA12082F;
        Sun, 29 Sep 2019 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765620;
        bh=RM8R5ulGcdJoqaMk/ycFz7m7mX6UWE4dG75ns3wU5c4=;
        h=From:To:Cc:Subject:Date:From;
        b=AoF9mWelZnKlBF66+dJib7rQWho0v9CpJgIFXbYjyYSqNyLJyhbt2GzhI/SbsYOJO
         D1OJk1Yxotd0gIFaKi5WpopmTDFZ7Wnzir6Nkepgk2rvsRqsgduKRRsFlG/IUyNd0J
         +LwppF5PtYmR73R84M5HgTbjTqkv1efl30MF4960=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 00/45] 5.2.18-stable review
Date:   Sun, 29 Sep 2019 15:55:28 +0200
Message-Id: <20190929135024.387033930@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.18-rc1
X-KernelTest-Deadline: 2019-10-01T13:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.18 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.18-rc1

Ka-Cheong Poon <ka-cheong.poon@oracle.com>
    net/rds: An rds_sock is added too early to the hash table

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: check cops->tcf_block in tc_bind_tclass()

Jian-Hong Pan <jian-hong@endlessm.com>
    Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices

Fernando Fernandez Mancera <ffmancera@riseup.net>
    netfilter: nft_socket: fix erroneous socket assignment

Florian Westphal <fw@strlen.de>
    xfrm: policy: avoid warning splat when merging nodes

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't crash on null attr fork xfs_bmapi_read

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/disp/nv50-: fix center/aspect-corrected scaling

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add new hw_changes_brightness quirk, set it on PB Easynote MZ35

Jian-Hong Pan <jian-hong@endlessm.com>
    Bluetooth: btrtl: HCI reset on close for Realtek BT chip

Stephen Hemminger <stephen@networkplumber.org>
    net: don't warn in inet diag when IPV6 is disabled

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/dp: Add DP_DPCD_QUIRK_NO_SINK_COUNT

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Flush output polling on shutdown

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to do sanity check on segment bitmap of LFS curseg

Michal Suchanek <msuchanek@suse.de>
    net/ibmvnic: Fix missing { in __ibmvnic_reset

Mikulas Patocka <mpatocka@redhat.com>
    dm zoned: fix invalid memory access

Chao Yu <yuchao0@huawei.com>
    Revert "f2fs: avoid out-of-range memory access"

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

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Revert "HID: logitech-hidpp: add USB PID for a few more supported mice"

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

David S. Miller <davem@davemloft.net>
    Revert "net: hns: fix LED configuration for marvell phy"

Nick Desaulniers <ndesaulniers@google.com>
    drm/amd/display: readd -msse2 to prevent Clang from emitting libcalls to undefined SW FP routines

Greg Kurz <groug@kaod.org>
    powerpc/xive: Fix bogus error code returned by OPAL

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Don't replace the dc_state for fast updates

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Skip determining update type for async updates

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Allow cursor async updates for framebuffer swaps

Juliet Kim <julietk@linux.vnet.ibm.com>
    net/ibmvnic: free reset work of removed device from queue

Bjorn Andersson <bjorn.andersson@linaro.org>
    phy: qcom-qmp: Correct ready status, again

Marc Gonzalez <marc.w.gonzalez@free.fr>
    phy: qcom-qmp: Raise qcom_qmp_phy_enable() polling delay

Steve French <stfrench@microsoft.com>
    smb3: fix unmount hang in open_shroot

Marcel Holtmann <marcel@holtmann.org>
    Revert "Bluetooth: validate BLE connection interval updates"


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/powerpc/include/asm/opal.h                   |  2 +-
 arch/powerpc/platforms/powernv/opal-call.c        |  2 +-
 arch/powerpc/sysdev/xive/native.c                 | 11 +++
 drivers/acpi/acpi_video.c                         | 37 ++++++++++
 drivers/bluetooth/btrtl.c                         | 20 +++++
 drivers/bluetooth/btrtl.h                         |  6 ++
 drivers/bluetooth/btusb.c                         |  4 +
 drivers/clk/imx/clk-imx8mm.c                      |  4 +-
 drivers/crypto/talitos.c                          |  1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 56 ++++++++++----
 drivers/gpu/drm/amd/display/dc/calcs/Makefile     |  4 +
 drivers/gpu/drm/amd/display/dc/dml/Makefile       |  4 +
 drivers/gpu/drm/drm_dp_helper.c                   |  4 +-
 drivers/gpu/drm/drm_probe_helper.c                |  9 ++-
 drivers/gpu/drm/nouveau/dispnv50/head.c           | 28 ++++++-
 drivers/hid/hid-ids.h                             |  1 +
 drivers/hid/hid-lg.c                              | 10 ++-
 drivers/hid/hid-lg4ff.c                           |  1 -
 drivers/hid/hid-logitech-dj.c                     | 10 +--
 drivers/hid/hid-logitech-hidpp.c                  | 20 -----
 drivers/hid/hid-prodikeys.c                       | 12 ++-
 drivers/hid/hid-quirks.c                          |  1 +
 drivers/hid/hid-sony.c                            |  2 +-
 drivers/hid/hidraw.c                              |  2 +-
 drivers/md/dm-zoned-target.c                      |  2 -
 drivers/mtd/chips/cfi_cmdset_0002.c               | 18 +++--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c     | 23 +-----
 drivers/net/ethernet/ibm/ibmvnic.c                |  9 ++-
 drivers/phy/qualcomm/phy-qcom-qmp.c               | 33 ++++-----
 drivers/platform/x86/i2c-multi-instantiate.c      |  2 +-
 fs/cifs/smb2ops.c                                 | 21 +++---
 fs/f2fs/segment.c                                 | 44 +++++++++--
 fs/xfs/libxfs/xfs_bmap.c                          | 29 ++++++--
 include/drm/drm_dp_helper.h                       |  7 ++
 mm/z3fold.c                                       | 90 -----------------------
 net/bluetooth/hci_event.c                         |  5 --
 net/bluetooth/l2cap_core.c                        |  9 +--
 net/ipv4/raw_diag.c                               |  3 -
 net/netfilter/nft_socket.c                        |  6 +-
 net/rds/bind.c                                    | 40 +++++-----
 net/sched/sch_api.c                               |  2 +
 net/xfrm/xfrm_policy.c                            |  6 +-
 sound/firewire/dice/dice-alesis.c                 |  2 +-
 sound/pci/hda/hda_intel.c                         |  3 +-
 sound/pci/hda/patch_analog.c                      |  1 +
 sound/usb/quirks.c                                |  2 +
 tools/objtool/Makefile                            |  2 +-
 tools/testing/selftests/net/xfrm_policy.sh        |  7 ++
 49 files changed, 349 insertions(+), 272 deletions(-)


