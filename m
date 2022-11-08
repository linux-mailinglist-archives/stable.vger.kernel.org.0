Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D6E6212A2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiKHNlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbiKHNlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:41:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E48145084;
        Tue,  8 Nov 2022 05:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0449461568;
        Tue,  8 Nov 2022 13:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85DFC433C1;
        Tue,  8 Nov 2022 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914876;
        bh=PUH0P6d6mILgBvprntFdpvlT13euJKuZBQoO9KamjRU=;
        h=From:To:Cc:Subject:Date:From;
        b=GJOyAyjl8BuHV9qlsADOTlp/ABU0WjIxY8ZpOXWLNX7a9jQJDH2uGSm8FXOKSiBC4
         qGbhD0kYbVBvVsbAoB21dXRZ1TZAkTaNNCzk57upzE8+SFYu6Nq4/g2nnEWEBA9uTX
         9KCus7XFRwej2O5mIbjmdrVK62gcOpSP1f/EC2o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 4.9 00/30] 4.9.333-rc1 review
Date:   Tue,  8 Nov 2022 14:38:48 +0100
Message-Id: <20221108133326.715586431@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.333-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.333-rc1
X-KernelTest-Deadline: 2022-11-10T13:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.333 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.333-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.333-rc1

Dokyung Song <dokyung.song@gmail.com>
    wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: update the emulation mode after CR0 write

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: introduce emulator_recalc_and_set_mode

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: em_sysexit should update ctxt->mode

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off reserved bits in CPUID.80000008H

Ye Bin <yebin10@huawei.com>
    ext4: fix warning in 'ext4_da_release_space'

Helge Deller <deller@gmx.de>
    parisc: Export iosapic_serial_irq() symbol for serial port driver

Helge Deller <deller@gmx.de>
    parisc: Make 8250_gsc driver dependend on CONFIG_PARISC

John Veness <john-linux@pelago.org.uk>
    ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices

David Sterba <dsterba@suse.com>
    btrfs: fix type of parameter generation in btrfs_get_dentry

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix attempting to access uninitialized memory

Martin Tůma <martin.tuma@digiteqautomotive.com>
    i2c: xiic: Add platform module alias

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: dvb-frontends/drxk: initialize err to 0

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: s5p_cec: limit msg.len to CEC_MAX_MSG_SIZE

Gaosheng Cui <cuigaosheng1@huawei.com>
    net: mdio: fix undefined behavior in bit shift for __mdiobus_register

Zhengchao Shao <shaozhengchao@huawei.com>
    Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()

Maxim Mikityanskiy <maxtram95@gmail.com>
    Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu

Filipe Manana <fdmanana@suse.com>
    btrfs: fix ulist leaks in error paths of qgroup self tests

Yang Yingliang <yangyingliang@huawei.com>
    isdn: mISDN: netjet: fix wrong check of device registration

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: fix possible memory leak in mISDN_register_device()

Zhang Qilong <zhangqilong3@huawei.com>
    rose: Fix NULL pointer dereference in rose_send_frame()

Jason A. Donenfeld <Jason@zx2c4.com>
    ipvs: use explicitly signed chars

Dan Carpenter <dan.carpenter@oracle.com>
    net: sched: Fix use after free in red_enqueue()

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_legacy: fix pdc20230_set_piomode()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: fec: fix improper use of NETDEV_TX_BUSY

Shang XiaoJing <shangxiaojing@huawei.com>
    nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()

Shang XiaoJing <shangxiaojing@huawei.com>
    nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    nfs4: Fix kmemleak when allocate slot failed

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: We must always send RECLAIM_COMPLETE after a reboot

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: Handle RECLAIM_COMPLETE trunking errors


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/x86/kvm/cpuid.c                               |   1 +
 arch/x86/kvm/emulate.c                             | 102 +++++++++++++++------
 drivers/ata/pata_legacy.c                          |   5 +-
 drivers/i2c/busses/i2c-xiic.c                      |   1 +
 drivers/isdn/hardware/mISDN/netjet.c               |   2 +-
 drivers/isdn/mISDN/core.c                          |   5 +-
 drivers/media/dvb-frontends/drxk_hard.c            |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   4 +-
 drivers/net/phy/mdio_bus.c                         |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   4 +
 drivers/nfc/nfcmrvl/i2c.c                          |   7 +-
 drivers/nfc/s3fwrn5/core.c                         |   8 +-
 drivers/parisc/iosapic.c                           |   1 +
 drivers/staging/media/s5p-cec/s5p_cec.c            |   2 +
 drivers/tty/serial/8250/Kconfig                    |   2 +-
 fs/btrfs/export.c                                  |   2 +-
 fs/btrfs/export.h                                  |   2 +-
 fs/btrfs/tests/qgroup-tests.c                      |  20 +++-
 fs/ext4/migrate.c                                  |   3 +-
 fs/nfs/nfs4client.c                                |   1 +
 fs/nfs/nfs4state.c                                 |   2 +
 net/bluetooth/l2cap_core.c                         |  52 +++++++++--
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +-
 net/rose/rose_link.c                               |   3 +
 net/sched/sch_red.c                                |   4 +-
 sound/usb/quirks-table.h                           |  58 ++++++++++++
 sound/usb/quirks.c                                 |   1 +
 28 files changed, 241 insertions(+), 63 deletions(-)


