Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63341150CB1
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgBCQiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:38:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731399AbgBCQiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:38:19 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A4F22082E;
        Mon,  3 Feb 2020 16:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747898;
        bh=J3WUOXW1y4qWPrIWkwxslQniTU5W715FV+//9z45w+c=;
        h=From:To:Cc:Subject:Date:From;
        b=cKjmNXg9Vkg3UGtZV24O21+W0nqFXZot7aEzOmXldQH5wtxJjBhCBK1qlX6ooZDRA
         GXEM4Gwx51OCbY4WvY5RxMEQFyCX8vhY5TJ2yO24+4PQqL6ej+eb+s64Ks6JvEcSbA
         cj42EwyBIETbtMkjXICk0I+Uuy8knHERyC7zFxBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 00/23] 5.5.2-stable review
Date:   Mon,  3 Feb 2020 16:20:20 +0000
Message-Id: <20200203161902.288335885@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.2-rc1
X-KernelTest-Deadline: 2020-02-05T16:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.2 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.2-rc1

Michal Koutný <mkoutny@suse.com>
    cgroup: Prevent double killing of css when enabling threaded cgroup

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: Fix race condition in hci_release_sock()

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    ttyprintk: fix a potential deadlock in interrupt context issue

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: Use atomic_t for statistics counter

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca: zero usb_buf

Sean Young <sean@mess.org>
    media: vp7045: do not read uninitialized values if usb transfer fails

Sean Young <sean@mess.org>
    media: af9005: uninitialized variable printked

Sean Young <sean@mess.org>
    media: digitv: don't continue if remote control state can't be read

Jan Kara <jack@suse.cz>
    reiserfs: Fix memory leak of journal device string

Dan Carpenter <dan.carpenter@oracle.com>
    mm/mempolicy.c: fix out of bounds write in mpol_parse_str()

Dirk Behme <dirk.behme@de.bosch.com>
    arm64: kbuild: remove compressed images on 'make ARCH=arm64 (dist)clean'

Vitaly Chikunov <vt@altlinux.org>
    tools lib: Fix builds when glibc contains strlcpy()

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: Add new name attribute for sysfs

Andres Freund <andres@anarazel.de>
    perf c2c: Fix return type for histogram sorting comparision functions

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    lib/test_bitmap: correct test data offsets for 32-bit

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Another gfs2_find_jhead fix

David Michael <fedora.dm0@gmail.com>
    KVM: PPC: Book3S PR: Fix -Werror=return-type build failure

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix use-after-free when deleting resource groups

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix a deadlock due to inaccurate reference

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix soft mounts hanging in the reconnect code

Al Viro <viro@zeniv.linux.org.uk>
    vfs: fix do_last() regression


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-class-devfreq |  7 +++
 Makefile                                      |  4 +-
 arch/arm64/boot/Makefile                      |  2 +-
 arch/powerpc/kvm/book3s_pr.c                  |  1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c        | 32 ++++++++-----
 drivers/char/ttyprintk.c                      | 15 +++---
 drivers/devfreq/devfreq.c                     |  9 ++++
 drivers/media/usb/dvb-usb/af9005.c            |  2 +-
 drivers/media/usb/dvb-usb/digitv.c            | 10 ++--
 drivers/media/usb/dvb-usb/dvb-usb-urb.c       |  2 +-
 drivers/media/usb/dvb-usb/vp7045.c            | 21 ++++++---
 drivers/media/usb/gspca/gspca.c               |  2 +-
 fs/cifs/smb2pdu.c                             |  2 +-
 fs/gfs2/lops.c                                | 68 +++++++++++++++++----------
 fs/namei.c                                    |  4 +-
 fs/reiserfs/super.c                           |  2 +
 kernel/cgroup/cgroup.c                        | 11 +++--
 lib/test_bitmap.c                             |  9 ++--
 mm/mempolicy.c                                |  6 +--
 net/bluetooth/hci_sock.c                      |  3 ++
 security/tomoyo/common.c                      | 11 ++---
 tools/include/linux/string.h                  |  8 ++++
 tools/lib/string.c                            |  7 +++
 tools/perf/builtin-c2c.c                      | 10 ++--
 24 files changed, 164 insertions(+), 84 deletions(-)


