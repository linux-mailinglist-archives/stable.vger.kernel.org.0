Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57B46C15D2
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 15:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjCTO6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 10:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjCTO5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 10:57:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F6426BC;
        Mon, 20 Mar 2023 07:55:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39A5161584;
        Mon, 20 Mar 2023 14:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18871C433D2;
        Mon, 20 Mar 2023 14:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324153;
        bh=tGxmDq+X7Y8B+Z1LBH2wtct4JYekdvI+9JTrruafvMw=;
        h=From:To:Cc:Subject:Date:From;
        b=QVIKHoFz0BRgu6oLNBghtoQGKbmQSsAjWPFW+cjejRDftiMvIQmW04vea8fV2jPwO
         Z1xzgqnFxj8q6c5jriDHKQ+whEdqLeY3Nv7IDsVjCXNx+Re2X/b7s3YCU9LHtNm6nC
         E5EHIFVlbxPabC9HLbAthP+csyT7Wz7XaoqWnrXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.14 00/30] 4.14.311-rc1 review
Date:   Mon, 20 Mar 2023 15:54:24 +0100
Message-Id: <20230320145420.204894191@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.311-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.311-rc1
X-KernelTest-Deadline: 2023-03-22T14:54+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.311 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Mar 2023 14:54:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.311-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.311-rc1

Lee Jones <lee@kernel.org>
    HID: uhid: Over-ride the default maximum data buffer value with our own

Lee Jones <lee@kernel.org>
    HID: core: Provide new max_buffer_size attribute to over-ride the default

Biju Das <biju.das.jz@bp.renesas.com>
    serial: 8250_em: Fix UART port type

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use stolen memory for ring buffers with LLC

Helge Deller <deller@gmx.de>
    fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks

Chen Zhongjin <chenzhongjin@huawei.com>
    ftrace: Fix invalid address access in lookup_rec() when index is 0

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sh: intc: Avoid spurious sizeof-pointer-div warning

Baokun Li <libaokun1@huawei.com>
    ext4: fix task hung in ext4_xattr_delete_inode

Baokun Li <libaokun1@huawei.com>
    ext4: fail ext4_iget if special inode unallocated

David Gow <davidgow@google.com>
    rust: arch/um: Disable FP/SIMD instruction to match x86

Tobias Schramm <t.schramm@manjaro.org>
    mmc: atmel-mci: fix race between stop command and start of next command

Linus Torvalds <torvalds@linux-foundation.org>
    media: m5mols: fix off-by-one loop termination error

Zheng Wang <zyytlz.wz@163.com>
    hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    hwmon: (adt7475) Fix masking of hysteresis registers

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    hwmon: (adt7475) Display smoothing attributes in correct order

Liang He <windhl@126.com>
    ethernet: sun: add check for the mdesc_grab()

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: Fix size of interrupt data

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect table ID in IOCTL path

Liang He <windhl@126.com>
    block: sunvdc: add check for mdesc_grab() returning NULL

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    nvmet: avoid potential UAF in nvmet_req_complete()

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc75xx: Limit packet length to skb->len

Zheng Wang <zyytlz.wz@163.com>
    nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails

Eric Dumazet <edumazet@google.com>
    net: tunnels: annotate lockless accesses to dev->needed_headroom

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qed/qed_dev: guard against a possible division by zero

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: pn533: initialize struct pn533_out_arg properly

Breno Leitao <leitao@debian.org>
    tcp: tcp_make_synack() can be called from process context

Eric Biggers <ebiggers@kernel.org>
    fs: sysfs_emit_at: Remove PAGE_SIZE alignment check

Eric Biggers <ebiggers@google.com>
    ext4: fix cgroup writeback accounting with fs-layer encryption


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/x86/Makefile.um                      |  6 ++++++
 drivers/block/sunvdc.c                    |  2 ++
 drivers/gpu/drm/i915/intel_ringbuffer.c   |  5 +++--
 drivers/hid/hid-core.c                    | 18 +++++++++++++-----
 drivers/hid/uhid.c                        |  1 +
 drivers/hwmon/adt7475.c                   |  8 ++++----
 drivers/hwmon/xgene-hwmon.c               |  1 +
 drivers/media/i2c/m5mols/m5mols_core.c    |  2 +-
 drivers/mmc/host/atmel-mci.c              |  3 ---
 drivers/net/ethernet/qlogic/qed/qed_dev.c |  5 +++++
 drivers/net/ethernet/sun/ldmvsw.c         |  3 +++
 drivers/net/ethernet/sun/sunvnet.c        |  3 +++
 drivers/net/phy/smsc.c                    |  5 ++++-
 drivers/net/usb/smsc75xx.c                |  7 +++++++
 drivers/nfc/pn533/usb.c                   |  1 +
 drivers/nfc/st-nci/ndlc.c                 |  6 ++++--
 drivers/nvme/target/core.c                |  4 +++-
 drivers/tty/serial/8250/8250_em.c         |  4 ++--
 drivers/video/fbdev/stifb.c               | 27 +++++++++++++++++++++++++++
 fs/ext4/inode.c                           | 18 ++++++++----------
 fs/ext4/page-io.c                         | 11 ++++++-----
 fs/ext4/xattr.c                           | 11 +++++++++++
 fs/sysfs/file.c                           |  2 +-
 include/linux/hid.h                       |  3 +++
 include/linux/netdevice.h                 |  6 ++++--
 include/linux/sh_intc.h                   |  5 ++++-
 kernel/trace/ftrace.c                     |  3 ++-
 net/ipv4/fib_frontend.c                   |  3 +++
 net/ipv4/ip_tunnel.c                      | 12 ++++++------
 net/ipv4/tcp_output.c                     |  2 +-
 net/ipv6/ip6_tunnel.c                     |  4 ++--
 net/iucv/iucv.c                           |  2 +-
 33 files changed, 144 insertions(+), 53 deletions(-)


