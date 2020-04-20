Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E001B0ACE
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgDTMvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbgDTMsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:48:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B06206E9;
        Mon, 20 Apr 2020 12:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386916;
        bh=EYXGi7HV2/0W2ZRhjlVVZ79ey/gKftrbxBPbKd/uK3U=;
        h=From:To:Cc:Subject:Date:From;
        b=NWU147lRRYicAIbgN4XVTKupqxfE3ljUV2PZJxCfrFnfy8WsFewotEYBJo0Pj/S4U
         O+4JuoovpnEnNTfUYRrYM1sDPk1AE9z/4Thewt3VVV9hlTRdAW1pBsOiGLCcLeVzyn
         NqETlMpcKWSwj0GltSubSxvYC8pAXevXOTD1lgoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/40] 4.19.117-rc1 review
Date:   Mon, 20 Apr 2020 14:39:10 +0200
Message-Id: <20200420121444.178150063@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.117-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.117-rc1
X-KernelTest-Deadline: 2020-04-22T12:15+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.117 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.117-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.117-rc1

Austin Kim <austindh.kim@gmail.com>
    mm/vmalloc.c: move 'area->pages' after if statement

Karthick Gopalasubramanian <kargop@codeaurora.org>
    wil6210: remove reset file from debugfs

Dedy Lansky <dlansky@codeaurora.org>
    wil6210: make sure Rx ring sizes are correlated

Alexei Avshalom Lazar <ailizaro@codeaurora.org>
    wil6210: add general initialization/size checks

Maya Erez <merez@codeaurora.org>
    wil6210: ignore HALP ICR if already handled

Dedy Lansky <dlansky@codeaurora.org>
    wil6210: check rx_buff_mgmt before accessing it

Reinette Chatre <reinette.chatre@intel.com>
    x86/resctrl: Fix invalid attempt at removing the default resource group

James Morse <james.morse@arm.com>
    x86/resctrl: Preserve CDP enable over CPU hotplug

John Allen <john.allen@amd.com>
    x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: fix hang when multiple threads try to destroy the same iscsi session

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: remove boilerplate code

Jim Mattson <jmattson@google.com>
    kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD

Jan Kara <jack@suse.cz>
    ext4: do not zeroout extents beyond i_disksize

Sergei Lopatin <magist3r@gmail.com>
    drm/amd/powerplay: force the trim of the mclk dpm_levels if OD is enabled

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't clear flags before transfer ended

Sasha Levin <sashal@kernel.org>
    usb: dwc3: gadget: don't enable interrupt when disabling endpoint

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    mac80211_hwsim: Use kstrndup() in place of kasprintf()

Josef Bacik <josef@toxicpanda.com>
    btrfs: check commit root generation in should_ignore_root

Xiao Yang <yangx.jy@cn.fujitsu.com>
    tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation

Vasily Averin <vvs@virtuozzo.com>
    keys: Fix proc_keys_next to increase position index

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check mapping at creating connector controls, too

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't create jack controls for PCM terminals

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't override ignore_ctl_error value from the map

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Filter error from connector kctl ops, too

Colin Ian King <colin.king@canonical.com>
    ASoC: Intel: mrfld: return error codes when an error occurs

Colin Ian King <colin.king@canonical.com>
    ASoC: Intel: mrfld: fix incorrect check on p->sink

Josh Triplett <josh@joshtriplett.org>
    ext4: fix incorrect inodes per group in error message

Josh Triplett <josh@joshtriplett.org>
    ext4: fix incorrect group count in ext4_fill_super error message

Sven Van Asbroeck <TheSven73@gmail.com>
    pwm: pca9685: Fix PWM/GPIO inter-operation

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: improve comments about freeing data buffers whose page mapping is NULL

Can Guo <cang@codeaurora.org>
    scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Amir Goldstein <amir73il@gmail.com>
    ovl: fix value of i_ino for lower hardlink corner case

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode

Florian Fainelli <f.fainelli@gmail.com>
    net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    net: revert default NAPI poll timeout to 2 jiffies

Wang Wenhu <wenhu.wang@vivo.com>
    net: qrtr: send msgs from local of same id as broadcast

Tim Stallard <code@timstallard.me.uk>
    net: ipv6: do not consider routes via gateways for anycast address check

Taras Chornyi <taras.chornyi@plvision.eu>
    net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin

Taehee Yoo <ap420073@gmail.com>
    hsr: check protocol version in hsr_newlink()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    amd-xgbe: Use __napi_schedule() in BH context


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/x86/include/asm/microcode_amd.h              |  2 +-
 arch/x86/kernel/cpu/intel_rdt.c                   |  2 +
 arch/x86/kernel/cpu/intel_rdt.h                   |  1 +
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c          | 16 ++++-
 arch/x86/kvm/cpuid.c                              |  3 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c  |  5 +-
 drivers/net/dsa/mt7530.c                          | 18 +++--
 drivers/net/dsa/mt7530.h                          |  7 ++
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |  2 +
 drivers/net/wireless/ath/wil6210/debugfs.c        | 29 +-------
 drivers/net/wireless/ath/wil6210/interrupt.c      | 12 ++--
 drivers/net/wireless/ath/wil6210/main.c           |  5 +-
 drivers/net/wireless/ath/wil6210/txrx.c           |  4 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c      | 14 +++-
 drivers/net/wireless/ath/wil6210/wil6210.h        |  3 +-
 drivers/net/wireless/ath/wil6210/wmi.c            |  2 +-
 drivers/net/wireless/mac80211_hwsim.c             | 12 ++--
 drivers/pwm/pwm-pca9685.c                         | 85 +++++++++++++----------
 drivers/scsi/ufs/ufshcd.c                         |  5 ++
 drivers/target/iscsi/iscsi_target.c               | 79 ++++++---------------
 drivers/target/iscsi/iscsi_target.h               |  1 -
 drivers/target/iscsi/iscsi_target_configfs.c      |  5 +-
 drivers/target/iscsi/iscsi_target_login.c         |  5 +-
 drivers/usb/dwc3/gadget.c                         | 18 ++---
 fs/btrfs/relocation.c                             |  4 +-
 fs/ext4/extents.c                                 |  8 +--
 fs/ext4/super.c                                   |  6 +-
 fs/jbd2/commit.c                                  |  7 +-
 fs/overlayfs/inode.c                              |  4 +-
 include/net/ip6_route.h                           |  1 +
 include/target/iscsi/iscsi_target_core.h          |  2 +-
 kernel/trace/trace_events_trigger.c               | 10 +--
 mm/vmalloc.c                                      |  8 ++-
 net/core/dev.c                                    |  3 +-
 net/hsr/hsr_netlink.c                             | 10 ++-
 net/ipv4/devinet.c                                | 13 ++--
 net/qrtr/qrtr.c                                   |  7 +-
 security/keys/proc.c                              |  2 +
 sound/soc/intel/atom/sst-atom-controls.c          |  2 +-
 sound/soc/intel/atom/sst/sst_pci.c                |  2 +-
 sound/usb/mixer.c                                 | 31 +++++----
 sound/usb/mixer_maps.c                            |  4 +-
 44 files changed, 252 insertions(+), 213 deletions(-)


