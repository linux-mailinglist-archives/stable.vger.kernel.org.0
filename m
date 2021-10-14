Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3D542DD76
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhJNPHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233516AbhJNPGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:06:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 837666124F;
        Thu, 14 Oct 2021 15:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223692;
        bh=0tUhcSrlPV3AkdZnjx1FS+t/zjtp+7R+7dW6khaeO8M=;
        h=From:To:Cc:Subject:Date:From;
        b=Ce303F1edK0h5s7ZDff/cXiZvfMWh3sMwzMnrHmoPJlP1nAYZLR7ZLFsriz7GUzn+
         8qx7krZTlj51ZW4cxjeKKJnB0j70McdbTLUmWGazoJTHzdIqSUe2yVRgFgO4d7EPOm
         6aDa2bfLwimBQbwdt2qBq8j6su6/PcgB/6i96oP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 00/30] 5.14.13-rc1 review
Date:   Thu, 14 Oct 2021 16:54:05 +0200
Message-Id: <20211014145209.520017940@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.13-rc1
X-KernelTest-Deadline: 2021-10-16T14:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.13 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.13-rc1

Brandon Wyman <bjwyman@gmail.com>
    hwmon: (pmbus/ibm-cffps) max_power_out swap changes

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: kill fasync

Peter Zijlstra <peterz@infradead.org>
    sched: Always inline is_percpu_thread()

Song Liu <songliubraving@fb.com>
    perf/core: fix userpage->time_enabled of inactive events

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix excessive messages during device logout

Colin Ian King <colin.king@canonical.com>
    scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    scsi: ses: Fix unsigned comparison with less than zero

Leslie Shi <Yuliang.Shi@amd.com>
    drm/amdgpu: fix gart.bo pin_count leak

Randy Dunlap <rdunlap@infradead.org>
    net: sun: SUNVNET_COMMON should depend on INET

Linus Torvalds <torvalds@linux-foundation.org>
    vboxfs: fix broken legacy mount signature checking

Matthew Hagan <mnhagan88@gmail.com>
    net: bgmac-platform: handle mac-address deferral

MichelleJin <shjy180909@gmail.com>
    mac80211: check return value of rhashtable_init

王贇 <yun.wang@linux.alibaba.com>
    net: prevent user from passing illegal stab size

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    hwmon: (ltc2947) Properly handle errors when looking for the external clock

Al Viro <viro@zeniv.linux.org.uk>
    m68k: Handle arrivals of multiple signals correctly

Rajendra Nayak <rnayak@codeaurora.org>
    pinctrl: qcom: sc7280: Add PM suspend callbacks

YueHaibing <yuehaibing@huawei.com>
    mac80211: Drop frames from invalid MAC address in ad-hoc mode

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat_masquerade: defer conntrack walk to work queue

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat_masquerade: make async masq_inet6_event handling generic

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm64: nvhe: Fix missing FORCE for hyp-reloc.S build rule

Marc Herbert <marc.herbert@intel.com>
    ASoC: SOF: loader: release_firmware() on load failure to avoid batching

Joshua-Dickens <Joshua@Joshua-Dickens.com>
    HID: wacom: Add new Intuos BT (CTL-4100WL/CTL-6100WL) device IDs

Jeremy Sowden <jeremy@azazel.net>
    netfilter: ip6_tables: zero-initialize fragment offset

Mizuho Mori <morimolymoly@gmail.com>
    HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Unify mixer resume and reset_resume procedure

Shawn Guo <shawn.guo@linaro.org>
    interconnect: qcom: sdm660: Add missing a2noc qos clocks

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: oxfw: fix transmission method for Loud models based on OXFW971

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: tag SoundWire BEs as non-atomic

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct the error path of ext4_write_inline_data_end()

Zhang Yi <yi.zhang@huawei.com>
    ext4: check and update i_disksize properly


-------------

Diffstat:

 Makefile                                       |   4 +-
 arch/arm64/kvm/hyp/nvhe/Makefile               |   2 +-
 arch/m68k/kernel/signal.c                      |  88 +++++++------
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c          |   3 +-
 drivers/hid/hid-apple.c                        |   7 ++
 drivers/hid/wacom_wac.c                        |   8 ++
 drivers/hwmon/ltc2947-core.c                   |   8 +-
 drivers/hwmon/pmbus/ibm-cffps.c                |  10 +-
 drivers/interconnect/qcom/sdm660.c             |  14 +++
 drivers/net/ethernet/broadcom/bgmac-platform.c |   3 +
 drivers/net/ethernet/sun/Kconfig               |   1 +
 drivers/pinctrl/qcom/pinctrl-sc7280.c          |   1 +
 drivers/scsi/qla2xxx/qla_isr.c                 |   4 +-
 drivers/scsi/ses.c                             |   2 +-
 drivers/scsi/virtio_scsi.c                     |   4 +-
 fs/ext4/inline.c                               |  15 +--
 fs/ext4/inode.c                                |  41 +++---
 fs/io_uring.c                                  |  17 +--
 fs/vboxsf/super.c                              |  12 +-
 include/linux/perf_event.h                     |   4 +-
 include/linux/sched.h                          |   2 +-
 include/net/pkt_sched.h                        |   1 +
 kernel/events/core.c                           |  34 ++++-
 net/ipv6/netfilter/ip6_tables.c                |   1 +
 net/mac80211/mesh_pathtbl.c                    |   5 +-
 net/mac80211/rx.c                              |   3 +-
 net/netfilter/nf_nat_masquerade.c              | 168 ++++++++++++++-----------
 net/sched/sch_api.c                            |   6 +
 sound/firewire/oxfw/oxfw.c                     |  13 +-
 sound/soc/intel/boards/sof_sdw.c               |   5 +
 sound/soc/sof/core.c                           |   4 +-
 sound/soc/sof/loader.c                         |   2 +
 sound/usb/card.c                               |  18 +--
 sound/usb/mixer.c                              |  26 +---
 sound/usb/mixer.h                              |   3 +-
 sound/usb/mixer_quirks.c                       |   2 +-
 37 files changed, 305 insertions(+), 239 deletions(-)


