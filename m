Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C490A6E612E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjDRMYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDRMYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:24:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD5549EF;
        Tue, 18 Apr 2023 05:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8671563108;
        Tue, 18 Apr 2023 12:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA8DC433EF;
        Tue, 18 Apr 2023 12:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820637;
        bh=Hhx6ov/CsPO500xLzzF/Vw43A36iCQKkXonCC9OGrm4=;
        h=From:To:Cc:Subject:Date:From;
        b=z6ODEoh26S6HBnKDXZdkSE1vPLtQK1wyutiykMhxcTwPj0Af09F4A9FP2Xy3oEYCy
         YqcPamnZIxoBINWHX0pSR9hQFGE3gYXFiqSOVMCjDlEEshpPvPf4+6Ptutfjq2hWd4
         yjIq151Nes90J3Wz/jmiAIWj6QRAG3FzDVuIfUvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.14 00/37] 4.14.313-rc1 review
Date:   Tue, 18 Apr 2023 14:21:10 +0200
Message-Id: <20230418120254.687480980@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.313-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.313-rc1
X-KernelTest-Deadline: 2023-04-20T12:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.313 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.313-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.313-rc1

Marc Zyngier <marc.zyngier@arm.com>
    arm64: KVM: Fix system register enumeration

Dave Martin <Dave.Martin@arm.com>
    KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST

Dave Martin <Dave.Martin@arm.com>
    KVM: arm64: Factor out core register ID enumeration

Steve Clevenger <scclevenger@os.amperecomputing.com>
    coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

George Cherian <george.cherian@marvell.com>
    watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Robbie Harwood <rharwood@redhat.com>
    verify_pefile: relax wrapper length check

Hans de Goede <hdegoede@redhat.com>
    efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: imx-lpi2c: clean rx/tx buffers upon new message

Roman Gushchin <roman.gushchin@linux.dev>
    net: macb: fix a memory corruption in extended buffer descriptor mode

Denis Plotnikov <den-plotnikov@yandex-team.ru>
    qlcnic: check pci_reset_function result

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    niu: Fix missing unwind goto in niu_alloc_channels()

Zheng Wang <zyytlz.wz@163.com>
    9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Bang Li <libang.linuxer@gmail.com>
    mtdblock: tolerate corrected bit-flips

Min Li <lm0963hack@gmail.com>
    Bluetooth: Fix race condition in hidp_session_thread

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: i2c/cs8427: fix iec958 mixer control deactivation

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: fix capture interrupt handler unlinking

Rongwei Wang <rongwei.wang@linux.alibaba.com>
    mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Zheng Yejian <zhengyejian1@huawei.com>
    ring-buffer: Fix race while reader and writer are on the same page

John Keeping <john@metanate.com>
    ftrace: Mark get_lock_parent_ip() __always_inline

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix the same task check in perf_event_set_output

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix sysfs interface lifetime

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

William Breathitt Gray <william.gray@linaro.org>
    iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: add Quectel RM500U-CN modem

Enrico Sau <enrico.sau@gmail.com>
    USB: serial: option: add Telit FE990 compositions

Kees Jan Koster <kjkoster@kjkoster.org>
    USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

Dhruva Gole <d-gole@ti.com>
    gpio: davinci: Add irq chip flag to skip set wake

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv6: Fix an uninit variable access bug in __ip6_make_skb()

Eric Dumazet <edumazet@google.com>
    icmp: guard against too small mtu

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: cros-ec: Explicitly set .polarity in .get_state()


-------------

Diffstat:

 Documentation/sound/hd-audio/models.rst         |  2 +-
 Makefile                                        |  4 +-
 arch/arm64/kvm/guest.c                          | 83 ++++++++++++++++++++-----
 arch/x86/kernel/sysfb_efi.c                     |  8 +++
 crypto/asymmetric_keys/verify_pefile.c          | 12 ++--
 drivers/gpio/gpio-davinci.c                     |  2 +-
 drivers/hwtracing/coresight/coresight-etm4x.c   |  2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c              |  2 +
 drivers/iio/dac/cio-dac.c                       |  4 +-
 drivers/mtd/mtdblock.c                          | 12 ++--
 drivers/mtd/ubi/build.c                         | 21 +++++--
 drivers/net/ethernet/cadence/macb_main.c        |  4 ++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c |  8 ++-
 drivers/net/ethernet/sun/niu.c                  |  2 +-
 drivers/pwm/pwm-cros-ec.c                       |  1 +
 drivers/tty/serial/sh-sci.c                     |  2 +-
 drivers/usb/serial/cp210x.c                     |  1 +
 drivers/usb/serial/option.c                     | 10 +++
 drivers/watchdog/sbsa_gwdt.c                    |  1 +
 fs/nilfs2/segment.c                             |  3 +-
 fs/nilfs2/super.c                               |  2 +
 fs/nilfs2/the_nilfs.c                           | 12 ++--
 include/linux/ftrace.h                          |  2 +-
 kernel/cgroup/cpuset.c                          |  4 +-
 kernel/events/core.c                            |  2 +-
 kernel/trace/ring_buffer.c                      | 13 +++-
 mm/swapfile.c                                   |  3 +-
 net/9p/trans_xen.c                              |  4 ++
 net/bluetooth/hidp/core.c                       |  2 +-
 net/bluetooth/l2cap_core.c                      | 24 ++-----
 net/ipv4/icmp.c                                 |  5 ++
 net/ipv6/ip6_output.c                           |  7 ++-
 net/mac80211/sta_info.c                         |  3 +-
 sound/i2c/cs8427.c                              |  7 ++-
 sound/pci/emu10k1/emupcm.c                      |  4 +-
 sound/pci/hda/patch_sigmatel.c                  | 10 +++
 36 files changed, 211 insertions(+), 77 deletions(-)


