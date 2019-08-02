Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDFE7F390
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406501AbfHBJ6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407057AbfHBJ6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:58:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF5F820B7C;
        Fri,  2 Aug 2019 09:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739888;
        bh=Ho5DB0pXNWfplBmDqj1zfHEzIx5bFi4tLPJKGf8BLm8=;
        h=From:To:Cc:Subject:Date:From;
        b=r0QCZRbIQfYnh2GXRUKUFmYzMeRwqptdXVXrDaDiGU4kRCUkS6Ds8Ej0BwhKVBoWy
         zcYt7XS5ZITMMnFaOBrrA/Fic081o+PiAe4WEF/qgI/J7wgwdk1KnoMW7nWOt3FKqw
         5TuXUtPsMJ1/irlpmN8gNOSwXW1S+N5H+3Ay8QD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.2 00/20] 5.2.6-stable review
Date:   Fri,  2 Aug 2019 11:39:54 +0200
Message-Id: <20190802092055.131876977@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.6-rc1
X-KernelTest-Deadline: 2019-08-04T09:21+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.2.6 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.2.6-rc1

Yan, Zheng <zyan@redhat.com>
    ceph: hold i_ceph_lock when removing caps for freeing inode

Yoshinori Sato <ysato@users.sourceforge.jp>
    Fix allyesconfig output.

Miroslav Lichvar <mlichvar@redhat.com>
    drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl

Linus Torvalds <torvalds@linux-foundation.org>
    /proc/<pid>/cmdline: add back the setproctitle() special case

Linus Torvalds <torvalds@linux-foundation.org>
    /proc/<pid>/cmdline: remove all the special cases

Jann Horn <jannh@google.com>
    sched/fair: Use RCU accessors consistently for ->numa_group

Jann Horn <jannh@google.com>
    sched/fair: Don't free p->numa_faults with concurrent readers

Vladis Dronov <vdronov@redhat.com>
    Bluetooth: hci_uart: check for missing tty operations

Marta Rybczynska <mrybczyn@kalray.eu>
    nvme: fix multipath crash when ANA is deactivated

Florian Westphal <fw@strlen.de>
    xfrm: policy: fix bydst hlist corruption on hash rebuild

Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
    media: radio-raremono: change devm_k*alloc to k*alloc

Benjamin Coddington <bcodding@redhat.com>
    NFS: Cleanup if nfs_match_client is interrupted

Andrey Konovalov <andreyknvl@google.com>
    media: pvrusb2: use a different format for warnings

Oliver Neukum <oneukum@suse.com>
    media: cpia2_usb: first wake up, then free in disconnect

Fabio Estevam <festevam@gmail.com>
    ath10k: Change the warning message string

Sean Young <sean@mess.org>
    media: au0828: fix null dereference in error path

Stanislav Fomichev <sdf@google.com>
    bpf: fix NULL deref in btf_type_is_resolve_source_only

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Sanity checks for each pipe and EP types

Phong Tran <tranmanphong@gmail.com>
    ISDN: hfcsusb: checking idx of ep configuration

Sunil Muthuswamy <sunilmut@microsoft.com>
    vsock: correct removal of socket from the list


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/sh/boards/Kconfig                       |  14 +--
 drivers/bluetooth/hci_ath.c                  |   3 +
 drivers/bluetooth/hci_bcm.c                  |   3 +
 drivers/bluetooth/hci_intel.c                |   3 +
 drivers/bluetooth/hci_ldisc.c                |  13 +++
 drivers/bluetooth/hci_mrvl.c                 |   3 +
 drivers/bluetooth/hci_qca.c                  |   3 +
 drivers/bluetooth/hci_uart.h                 |   1 +
 drivers/isdn/hardware/mISDN/hfcsusb.c        |   3 +
 drivers/media/radio/radio-raremono.c         |  30 ++++--
 drivers/media/usb/au0828/au0828-core.c       |  12 +--
 drivers/media/usb/cpia2/cpia2_usb.c          |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |   6 +-
 drivers/media/usb/pvrusb2/pvrusb2-std.c      |   2 +-
 drivers/net/wireless/ath/ath10k/usb.c        |   2 +-
 drivers/nvme/host/multipath.c                |   8 +-
 drivers/nvme/host/nvme.h                     |   6 +-
 drivers/pps/pps.c                            |   8 ++
 fs/ceph/caps.c                               |  10 +-
 fs/ceph/inode.c                              |   2 +-
 fs/ceph/super.h                              |   2 +-
 fs/exec.c                                    |   2 +-
 fs/nfs/client.c                              |   4 +-
 fs/proc/base.c                               | 132 +++++++++++++-----------
 include/linux/sched.h                        |  10 +-
 include/linux/sched/numa_balancing.h         |   4 +-
 kernel/bpf/btf.c                             |  12 +--
 kernel/fork.c                                |   2 +-
 kernel/sched/fair.c                          | 144 +++++++++++++++++++--------
 net/vmw_vsock/af_vsock.c                     |  38 ++-----
 net/xfrm/xfrm_policy.c                       |  12 ++-
 sound/usb/helper.c                           |  17 ++++
 sound/usb/helper.h                           |   1 +
 sound/usb/quirks.c                           |  18 +++-
 tools/testing/selftests/net/xfrm_policy.sh   |  27 ++++-
 37 files changed, 368 insertions(+), 200 deletions(-)


