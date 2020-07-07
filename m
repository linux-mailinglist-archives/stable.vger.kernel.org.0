Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F45A216FF7
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgGGPOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbgGGPOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B527B2065D;
        Tue,  7 Jul 2020 15:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134844;
        bh=xJYuqbJhFQb7gAW7m99nnSEgrTj2Tb/a1uYGT1IyZcc=;
        h=From:To:Cc:Subject:Date:From;
        b=BsfZJJ6li7Ji0LotBsZwAQJWNPBXXf98y19wQvMh3xx9GxJhbr9SNGEePAJeF3tT7
         YlBAlLKYsM0dDPTMZ9HfFHmpdYPZEdqUhfOnsycDh/NKmXtpXRi+BssUjpw51bRHXr
         yin12+IL0ddL0H3YdVRsG02+4zNC3C5NP3TEOHg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/24] 4.9.230-rc1 review
Date:   Tue,  7 Jul 2020 17:13:32 +0200
Message-Id: <20200707145748.952502272@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.230-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.230-rc1
X-KernelTest-Deadline: 2020-07-09T14:57+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.230 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.230-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.230-rc1

Peter Jones <pjones@redhat.com>
    efi: Make it possible to disable efivar_ssdt entirely

Vasily Averin <vvs@virtuozzo.com>
    netfilter: nf_conntrack_h323: lost .data_len definition for Q.931/ipv6

Hauke Mehrtens <hauke@hauke-m.de>
    MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix the target file was deleted when rename failed.

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor persistent/resilient handle flags for multiuser mounts

Paul Aurich <paul@darkrain42.org>
    SMB3: Honor 'seal' flag for multiuser mounts

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: usb-audio: Improve frames size computation"

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665

Hou Tao <houtao1@huawei.com>
    virtio-blk: free vblk-vqs in error path of virtblk_probe()

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    hwmon: (acpi_power_meter) Fix potential memory leak in acpi_power_meter_add()

Chu Lin <linchuyuan@google.com>
    hwmon: (max6697) Make sure the OVERT mask is set correctly

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: parse TC-U32 key values and masks natively

Shile Zhang <shile.zhang@nokia.com>
    sched/rt: Show the 'sched_rr_timeslice' SCHED_RR timeslice tuning knob in milliseconds

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock_sock()

Douglas Anderson <dianders@chromium.org>
    kgdb: Avoid suspicious RCU usage warning

Zqiang <qiang.zhang@windriver.com>
    usb: usbtest: fix missing kfree(dev->buf) in usbtest_disconnect

Qian Cai <cai@lca.pw>
    mm/slub: fix stack overruns with SLUB_STATS

Dongli Zhang <dongli.zhang@oracle.com>
    mm/slub.c: fix corrupted freechain in deactivate_slab()

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    usbnet: smsc95xx: Fix use-after-free after removal

Borislav Petkov <bp@suse.de>
    EDAC/amd64: Read back the scrub rate PCI register on F15h

Hugh Dickins <hughd@google.com>
    mm: fix swap cache node allocation mask

Filipe Manana <fdmanana@suse.com>
    btrfs: fix data block group relocation failure due to concurrent scrub

Anand Jain <Anand.Jain@oracle.com>
    btrfs: cow_file_range() num_bytes and disk_num_bytes are same

Filipe Manana <fdmanana@suse.com>
    btrfs: fix a block group ref counter leak after failure to remove block group


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/mips/kernel/traps.c                           |   1 +
 crypto/af_alg.c                                    |  26 ++---
 crypto/algif_aead.c                                |   9 +-
 crypto/algif_hash.c                                |   9 +-
 crypto/algif_skcipher.c                            |   9 +-
 drivers/block/virtio_blk.c                         |   1 +
 drivers/edac/amd64_edac.c                          |   2 +
 drivers/firmware/efi/Kconfig                       |  11 ++
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/hwmon/acpi_power_meter.c                   |   4 +-
 drivers/hwmon/max6697.c                            |   7 +-
 drivers/i2c/algos/i2c-algo-pca.c                   |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c  |  18 +--
 .../ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h    | 122 ++++++++++++++-------
 drivers/net/usb/smsc95xx.c                         |   2 +-
 drivers/usb/misc/usbtest.c                         |   1 +
 fs/btrfs/extent-tree.c                             |  19 ++--
 fs/btrfs/inode.c                                   |  36 ++++--
 fs/cifs/connect.c                                  |   3 +
 fs/cifs/inode.c                                    |  10 +-
 include/crypto/if_alg.h                            |   4 +-
 include/linux/sched/sysctl.h                       |   1 +
 kernel/debug/debug_core.c                          |   4 +
 kernel/sched/core.c                                |   5 +-
 kernel/sched/rt.c                                  |   1 +
 kernel/sysctl.c                                    |   2 +-
 mm/slub.c                                          |  30 ++++-
 mm/swap_state.c                                    |   3 +-
 net/netfilter/nf_conntrack_h323_main.c             |   1 +
 sound/usb/card.h                                   |   4 -
 sound/usb/endpoint.c                               |  43 +-------
 sound/usb/endpoint.h                               |   1 -
 sound/usb/pcm.c                                    |   2 -
 34 files changed, 235 insertions(+), 165 deletions(-)


