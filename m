Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCEA2ED224
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbhAGOam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:30:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbhAGOam (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:30:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0216322EBF;
        Thu,  7 Jan 2021 14:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029801;
        bh=g++6W7stsKXVrnpYsku5yAZmGyGeOt55FP5yVfIlPv0=;
        h=From:To:Cc:Subject:Date:From;
        b=ZpxtzghsquzIgOjyx1flTWHAd1NCrKCsrfPF5+E6N1tPXZn8hYqgAES2IbTfPqaXA
         dx4AUc3oR616JwgXEQ4qU3NX2xuRaEBbv8WuG302gxI4mLAjmaQ145zyZM6e8ekCgA
         S1GypSCPT2jOU35019evgPvJinASNS9ux2o0nkeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.4 00/20] 4.4.250-rc2 review
Date:   Thu,  7 Jan 2021 15:31:19 +0100
Message-Id: <20210107143049.179580814@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.250-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.250-rc2
X-KernelTest-Deadline: 2021-01-09T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.250 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.250-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.250-rc2

Zhang Xiaohui <ruc_zhangxiaohui@163.com>
    mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:magnetometer:mag3110: Fix alignment and data leak issues.

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

Johan Hovold <johan@kernel.org>
    USB: serial: digi_acceleport: fix write-wakeup deadlocks

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix hanging device offline processing

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


-------------

Diffstat:

 Makefile                                |  4 +--
 arch/powerpc/sysdev/mpic_msgr.c         |  2 +-
 drivers/iio/magnetometer/mag3110.c      | 13 +++++++---
 drivers/media/usb/dvb-usb/gp8psk.c      |  2 +-
 drivers/misc/vmw_vmci/vmci_context.c    |  2 +-
 drivers/net/wireless/mwifiex/join.c     |  2 ++
 drivers/s390/block/dasd_alias.c         | 10 +++++++-
 drivers/usb/serial/digi_acceleport.c    | 45 ++++++++++-----------------------
 fs/quota/quota_tree.c                   |  8 +++---
 fs/reiserfs/stree.c                     |  6 +++++
 include/linux/of.h                      |  1 +
 include/uapi/linux/const.h              |  5 ++++
 include/uapi/linux/lightnvm.h           |  2 +-
 include/uapi/linux/netfilter/x_tables.h |  2 +-
 include/uapi/linux/netlink.h            |  2 +-
 include/uapi/linux/sysctl.h             |  2 +-
 kernel/module.c                         |  6 +++--
 sound/core/seq/seq_queue.h              |  8 +++---
 sound/pci/hda/patch_ca0132.c            | 16 ++++++++++--
 sound/pci/hda/patch_realtek.c           | 25 +++++++++++++++---
 sound/usb/pcm.c                         | 38 ++++++++++++----------------
 21 files changed, 118 insertions(+), 83 deletions(-)


