Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DA22ED227
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbhAGOaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbhAGOaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:30:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA8B23356;
        Thu,  7 Jan 2021 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029814;
        bh=XaBYBttM0VJQWHxHXYEg4YYfEORWXajR1gLL+nwwtbk=;
        h=From:To:Cc:Subject:Date:From;
        b=tJVdqhcPiFuQdB0Ldykgmapw8FG0WCtTzRsNlFoDzHbxPprMPmdaDCpbpyar6aIja
         KHOPPtW2LGoBc7vZlWii4CVZRDePZfBLdv93wvjNg6Zc0I+0rIdPqrkbhDF6OUQaa5
         RoJNnN1WH6BZy3PBD1NwuYhs9LL/8vXCBQFTrNog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.9 00/33] 4.9.250-rc2 review
Date:   Thu,  7 Jan 2021 15:31:33 +0100
Message-Id: <20210107143053.692614974@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.250-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.250-rc2
X-KernelTest-Deadline: 2021-01-09T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.250 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.250-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.250-rc2

Zhang Xiaohui <ruc_zhangxiaohui@163.com>
    mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:magnetometer:mag3110: Fix alignment and data leak issues.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:bmi160: Fix alignment and data leak issues

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:bmi160: Fix too large a buffer.

sayli karnik <karniksayli1995@gmail.com>
    iio: bmi160_core: Fix sparse warning due to incorrect type in assignment

SeongJae Park <sjpark@amazon.de>
    xenbus/xenbus_backend: Disallow pending watch messages

SeongJae Park <sjpark@amazon.de>
    xen/xenbus: Count pending messages for each watch

SeongJae Park <sjpark@amazon.de>
    xen/xenbus/xen_bus_type: Support will_handle watch callback

SeongJae Park <sjpark@amazon.de>
    xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()

SeongJae Park <sjpark@amazon.de>
    xen/xenbus: Allow watches discard events before queueing

Josh Poimboeuf <jpoimboe@redhat.com>
    kdev_t: always inline major/minor helper functions

Jessica Yu <jeyu@kernel.org>
    module: delay kobject uevent until after module init call

Qinglang Miao <miaoqinglang@huawei.com>
    powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()

Jan Kara <jack@suse.cz>
    quota: Don't overflow quota file offsets

Miroslav Benes <mbenes@suse.cz>
    module: set MODULE_STATE_GOING state when a module fails to load

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Use bool for snd_seq_queue internal flags

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: gp8psk: initialize stats at power control logic

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Rustam Kovhaev <rkovhaev@gmail.com>
    reiserfs: add check for an invalid ih_entry_count

Johan Hovold <johan@kernel.org>
    of: fix linker-section match-table corruption

Petr Vorel <petr.vorel@gmail.com>
    uapi: move constants from <linux/kernel.h> to <linux/const.h>

Paolo Abeni <pabeni@redhat.com>
    l2tp: fix races with ipv4-mapped ipv6 addresses

Paolo Abeni <pabeni@redhat.com>
    net: ipv6: keep sk status consistent after datagram connect failure

Johan Hovold <johan@kernel.org>
    USB: serial: digi_acceleport: fix write-wakeup deadlocks

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging device offline processing

Eric Auger <eric.auger@redhat.com>
    vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Fix a wrong FIXUP for alc289 on Dell machines

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Support Dell headset mode for ALC3271

Johan Hovold <johan@kernel.org>
    ALSA: usb-audio: fix sync-ep altsetting sanity check

Alberto Aguirre <albaguirre@gmail.com>
    ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Fix work handling in delayed HP detection

Jan Beulich <JBeulich@suse.com>
    x86/entry/64: Add instruction suffix


-------------

Diffstat:

 Makefile                                    |  4 +--
 arch/powerpc/sysdev/mpic_msgr.c             |  2 +-
 arch/x86/entry/entry_64.S                   |  2 +-
 drivers/block/xen-blkback/xenbus.c          |  3 +-
 drivers/iio/imu/bmi160/bmi160_core.c        | 12 +++++--
 drivers/iio/magnetometer/mag3110.c          | 13 +++++---
 drivers/media/usb/dvb-usb/gp8psk.c          |  2 +-
 drivers/misc/vmw_vmci/vmci_context.c        |  2 +-
 drivers/net/wireless/marvell/mwifiex/join.c |  2 ++
 drivers/net/xen-netback/xenbus.c            |  4 ++-
 drivers/s390/block/dasd_alias.c             | 10 +++++-
 drivers/usb/serial/digi_acceleport.c        | 45 ++++++++-----------------
 drivers/vfio/pci/vfio_pci.c                 |  4 +--
 drivers/xen/xen-pciback/xenbus.c            |  2 +-
 drivers/xen/xenbus/xenbus_client.c          |  8 ++++-
 drivers/xen/xenbus/xenbus_probe.c           |  1 +
 drivers/xen/xenbus/xenbus_probe.h           |  2 ++
 drivers/xen/xenbus/xenbus_probe_backend.c   |  7 ++++
 drivers/xen/xenbus/xenbus_xs.c              | 38 +++++++++++++--------
 fs/quota/quota_tree.c                       |  8 ++---
 fs/reiserfs/stree.c                         |  6 ++++
 include/linux/kdev_t.h                      | 22 ++++++------
 include/linux/of.h                          |  1 +
 include/uapi/linux/const.h                  |  5 +++
 include/uapi/linux/ethtool.h                |  2 +-
 include/uapi/linux/kernel.h                 |  9 +----
 include/uapi/linux/lightnvm.h               |  2 +-
 include/uapi/linux/mroute6.h                |  2 +-
 include/uapi/linux/netfilter/x_tables.h     |  2 +-
 include/uapi/linux/netlink.h                |  2 +-
 include/uapi/linux/sysctl.h                 |  2 +-
 include/xen/xenbus.h                        | 15 ++++++++-
 kernel/module.c                             |  6 ++--
 net/ipv6/datagram.c                         | 21 +++++++++---
 net/l2tp/l2tp_core.c                        | 38 ++++++++++-----------
 net/l2tp/l2tp_core.h                        |  3 --
 sound/core/seq/seq_queue.h                  |  8 ++---
 sound/pci/hda/patch_ca0132.c                | 16 +++++++--
 sound/pci/hda/patch_realtek.c               | 25 ++++++++++++--
 sound/usb/pcm.c                             | 52 +++++++++++------------------
 40 files changed, 244 insertions(+), 166 deletions(-)


