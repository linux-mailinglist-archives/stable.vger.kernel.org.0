Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427672ED22E
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbhAGObK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:31:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbhAGObJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:31:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E72D423343;
        Thu,  7 Jan 2021 14:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029828;
        bh=GVL+E4+txpvarzFyPumGWCpY73arDVDFceM+2WCFEZo=;
        h=From:To:Cc:Subject:Date:From;
        b=y7jQoZUQSPC+XE0lqAHvz32r7XMxUpDGqfZWOZuCh31917aUs5NE0qBeaBTfOO2vo
         ZHXCAgZfwJsyULXGHxyCnJTUw8NPs8ZNr0g9nLUdTsZt7ECq3lZWT1oGsvyE4eZdLR
         H7gHGJ5OanePTQvtevzq8MO4QlKY9FimzzKU/F28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.14 00/29] 4.14.214-rc1 review
Date:   Thu,  7 Jan 2021 15:31:15 +0100
Message-Id: <20210107143052.973437064@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.214-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.214-rc1
X-KernelTest-Deadline: 2021-01-09T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.214 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.214-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.214-rc1

Zhang Xiaohui <ruc_zhangxiaohui@163.com>
    mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:magnetometer:mag3110: Fix alignment and data leak issues.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:bmi160: Fix alignment and data leak issues

Josh Poimboeuf <jpoimboe@redhat.com>
    kdev_t: always inline major/minor helper functions

Hyeongseok Kim <hyeongseok@gmail.com>
    dm verity: skip verity work if I/O error when system is shutting down

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Clear the full allocated memory at hw_params

Jessica Yu <jeyu@kernel.org>
    module: delay kobject uevent until after module init call

Qinglang Miao <miaoqinglang@huawei.com>
    powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()

Jan Kara <jack@suse.cz>
    quota: Don't overflow quota file offsets

Miroslav Benes <mbenes@suse.cz>
    module: set MODULE_STATE_GOING state when a module fails to load

Dinghao Liu <dinghao.liu@zju.edu.cn>
    rtc: sun6i: Fix memleak in sun6i_rtc_clk_init

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

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/bitops: Fix possible undefined behaviour with fls() and fls64()

Johan Hovold <johan@kernel.org>
    USB: serial: digi_acceleport: fix write-wakeup deadlocks

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging device offline processing

Eric Auger <eric.auger@redhat.com>
    vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: fix excessive complexity in memory.stat reporting

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: implement lruvec stat functions on top of each other

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: eliminate raw access to stat and event counters

Johan Hovold <johan@kernel.org>
    ALSA: usb-audio: fix sync-ep altsetting sanity check

Alberto Aguirre <albaguirre@gmail.com>
    ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Fix work handling in delayed HP detection

Kevin Vigor <kvigor@gmail.com>
    md/raid10: initialize r10_bio->read_slot before use.

Jan Beulich <JBeulich@suse.com>
    x86/entry/64: Add instruction suffix


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/powerpc/include/asm/bitops.h           |  23 +++-
 arch/powerpc/sysdev/mpic_msgr.c             |   2 +-
 arch/x86/entry/entry_64.S                   |   2 +-
 drivers/iio/imu/bmi160/bmi160_core.c        |  13 ++-
 drivers/iio/magnetometer/mag3110.c          |  13 ++-
 drivers/md/dm-verity-target.c               |  12 +-
 drivers/md/raid10.c                         |   3 +-
 drivers/media/usb/dvb-usb/gp8psk.c          |   2 +-
 drivers/misc/vmw_vmci/vmci_context.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/join.c |   2 +
 drivers/rtc/rtc-sun6i.c                     |   8 +-
 drivers/s390/block/dasd_alias.c             |  10 +-
 drivers/usb/serial/digi_acceleport.c        |  45 +++-----
 drivers/vfio/pci/vfio_pci.c                 |   3 +-
 fs/quota/quota_tree.c                       |   8 +-
 fs/reiserfs/stree.c                         |   6 +
 include/linux/kdev_t.h                      |  22 ++--
 include/linux/memcontrol.h                  | 165 +++++++++++++++++-----------
 include/linux/of.h                          |   1 +
 include/uapi/linux/const.h                  |   5 +
 include/uapi/linux/ethtool.h                |   2 +-
 include/uapi/linux/kernel.h                 |   9 +-
 include/uapi/linux/lightnvm.h               |   2 +-
 include/uapi/linux/mroute6.h                |   2 +-
 include/uapi/linux/netfilter/x_tables.h     |   2 +-
 include/uapi/linux/netlink.h                |   2 +-
 include/uapi/linux/sysctl.h                 |   2 +-
 kernel/module.c                             |   6 +-
 mm/memcontrol.c                             | 160 +++++++++++++--------------
 sound/core/pcm_native.c                     |   9 +-
 sound/core/seq/seq_queue.h                  |   8 +-
 sound/pci/hda/patch_ca0132.c                |  16 ++-
 sound/usb/pcm.c                             |  52 ++++-----
 34 files changed, 348 insertions(+), 275 deletions(-)


