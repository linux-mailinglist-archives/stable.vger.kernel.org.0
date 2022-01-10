Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6E2489103
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbiAJH2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbiAJH01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:26:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F196FC061748;
        Sun,  9 Jan 2022 23:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A109611C9;
        Mon, 10 Jan 2022 07:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA3AC36AED;
        Mon, 10 Jan 2022 07:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799535;
        bh=/Sy/pGzKSRxY03GFQvlHvQ1eIeu/MTUcXDtQ+i7n7Tk=;
        h=From:To:Cc:Subject:Date:From;
        b=B9FXLPeO0xN6PZdwfqG+BRaf+MhB5ntyhUl6W4tkuXQS3lGRzhl/abhce+61Q6XUl
         BCg8NKoJScSpPI+gX1aFtCe1Djgufrf3g1FXwoevO00Ld4m4G3pIshGFOZbcvBN6BN
         iYlvi4MWBp1985qOvJWCdM7vb/Yagd4OoV6eePdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/21] 4.9.297-rc1 review
Date:   Mon, 10 Jan 2022 08:22:47 +0100
Message-Id: <20220110071812.806606886@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.297-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.297-rc1
X-KernelTest-Deadline: 2022-01-12T07:18+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.297 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.297-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.297-rc1

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

James Morse <james.morse@arm.com>
    arm64: sysreg: Move to use definitions for all the SCTLR bits

Mark Rutland <mark.rutland@arm.com>
    arm64: move !VHE work to end of el2_setup

Mark Rutland <mark.rutland@arm.com>
    arm64: reduce el2_setup branching

Stefan Traby <stefan@hello-penguin.com>
    arm64: Remove a redundancy in sysreg.h

Ian Abbott <abbotti@mev.co.uk>
    bug: split BUILD_BUG stuff out into <linux/build_bug.h>

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

Parav Pandit <parav@nvidia.com>
    virtio_pci: Support surprise removal of virtio pci device

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Tag trace_percpu_buffer as a percpu pointer

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    tracing: Fix check for trace_percpu_buffer validity in get_trace_buf()

Takashi Iwai <tiwai@suse.de>
    Bluetooth: btusb: Apply QCA Rome patches for some ATH3012 models


-------------

Diffstat:

 Makefile                                    |  4 +-
 arch/arm64/include/asm/sysreg.h             | 69 ++++++++++++++++++++++--
 arch/arm64/kernel/head.S                    | 49 +++++++----------
 arch/arm64/mm/proc.S                        | 24 +--------
 drivers/bluetooth/btusb.c                   | 32 ++++++++---
 drivers/isdn/mISDN/core.c                   |  6 +--
 drivers/isdn/mISDN/core.h                   |  4 +-
 drivers/isdn/mISDN/layer1.c                 |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c | 32 ++++++++---
 drivers/net/ieee802154/atusb.c              | 10 ++--
 drivers/net/usb/rndis_host.c                |  5 ++
 drivers/power/reset/ltc2952-poweroff.c      |  4 +-
 drivers/scsi/libiscsi.c                     |  6 ++-
 drivers/virtio/virtio_pci_common.c          |  7 +++
 fs/xfs/xfs_ioctl.c                          |  3 +-
 include/linux/bug.h                         | 72 +------------------------
 include/linux/build_bug.h                   | 84 +++++++++++++++++++++++++++++
 kernel/trace/trace.c                        |  6 +--
 net/ipv4/udp.c                              |  2 +-
 net/ipv6/ip6_vti.c                          |  2 +
 net/mac80211/mlme.c                         |  2 +-
 net/phonet/pep.c                            |  1 +
 net/sched/sch_qfq.c                         |  6 +--
 23 files changed, 265 insertions(+), 169 deletions(-)


