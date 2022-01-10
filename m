Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62A54890B4
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239233AbiAJHYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239227AbiAJHYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:24:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F81C06173F;
        Sun,  9 Jan 2022 23:24:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 077CC6112C;
        Mon, 10 Jan 2022 07:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B199DC36AED;
        Mon, 10 Jan 2022 07:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799444;
        bh=Dj22NY8+/uoBLrN/3qCVXl3cEEJtqFHJF6pZmeYNYBs=;
        h=From:To:Cc:Subject:Date:From;
        b=rg/SU6MnY5uV3qYAZ8giUM86D/RIAo3O0V4YvcwxIQi/L16DJsRnYikEViFI7zqrd
         kSD7ax4X+9ZNpmdvbRB4bvQb17Y+yKBrUgGCP/V12VV1a4cfRO0ZOetnNI3/+qlHXl
         jNDcO9iGdFRT6FOCSlT1mu61ELkrmJHcOngbatso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/14] 4.4.299-rc1 review
Date:   Mon, 10 Jan 2022 08:22:39 +0100
Message-Id: <20220110071811.779189823@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.299-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.299-rc1
X-KernelTest-Deadline: 2022-01-12T07:18+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.299 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.299-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.299-rc1

Nathan Chancellor <nathan@kernel.org>
    power: reset: ltc2952: Fix use of floating point literals

wolfgang huang <huangjinhui@kylinos.cn>
    mISDN: change function names to avoid conflicts

yangxingwu <xingwu.yang@gmail.com>
    net: udp: fix alignment problem in udp4_seq_show()

William Zhao <wizhao@redhat.com>
    ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate

Lixiaokeng <lixiaokeng@huawei.com>
    scsi: libiscsi: Fix UAF in iscsi_conn_get_param()/iscsi_conn_teardown()

Hangyu Hua <hbh25y@gmail.com>
    phonet: refcount leak in pep_sock_accep

Thomas Toye <thomas@toye.io>
    rndis_host: support Hytera digital radios

Darrick J. Wong <djwong@kernel.org>
    xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate

Eric Dumazet <edumazet@google.com>
    sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix incorrect netdev's real number of RX/TX queues

Tom Rix <trix@redhat.com>
    mac80211: initialize variable have_higher_than_11mbit

Pavel Skripkin <paskripkin@gmail.com>
    ieee802154: atusb: fix uninit value in atusb_set_extended_addr

Takashi Iwai <tiwai@suse.de>
    Bluetooth: btusb: Apply QCA Rome patches for some ATH3012 models

Daniel Borkmann <daniel@iogearbox.net>
    bpf, test: fix ld_abs + vlan push/pop stress test


-------------

Diffstat:

 Makefile                                    |  4 ++--
 drivers/bluetooth/btusb.c                   | 32 ++++++++++++++++++++++-------
 drivers/isdn/mISDN/core.c                   |  6 +++---
 drivers/isdn/mISDN/core.h                   |  4 ++--
 drivers/isdn/mISDN/layer1.c                 |  4 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c | 32 ++++++++++++++++++++++-------
 drivers/net/ieee802154/atusb.c              | 10 +++++----
 drivers/net/usb/rndis_host.c                |  5 +++++
 drivers/power/reset/ltc2952-poweroff.c      |  4 ++--
 drivers/scsi/libiscsi.c                     |  6 ++++--
 fs/xfs/xfs_ioctl.c                          |  3 ++-
 lib/test_bpf.c                              |  2 +-
 net/ipv4/udp.c                              |  2 +-
 net/ipv6/ip6_vti.c                          |  2 ++
 net/mac80211/mlme.c                         |  2 +-
 net/phonet/pep.c                            |  1 +
 net/sched/sch_qfq.c                         |  6 ++----
 17 files changed, 86 insertions(+), 39 deletions(-)


