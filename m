Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CB06E61B0
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjDRM0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjDRM0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7305B7EEB;
        Tue, 18 Apr 2023 05:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57D1963149;
        Tue, 18 Apr 2023 12:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD82C433D2;
        Tue, 18 Apr 2023 12:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820733;
        bh=T+3OAg7/t2CJYRbQYGALsOUJk7F/d1DCuQN8XD/3T7I=;
        h=From:To:Cc:Subject:Date:From;
        b=Toi8qvceowMLThL8jXTWHUJjMGBOwIZ9E6WCbaQ2otNBOKy6ypzpviGAjAezkj82Z
         YNBndK+1FTePt0/a5N2HAOwY+IULrzYOkCz48C8n1hD8YbZrZr1x97bm82jirLSiCa
         LIfjghur4DgK1f1UZqqpEi+zA6RMQVOtH1O8L+hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.19 00/57] 4.19.281-rc1 review
Date:   Tue, 18 Apr 2023 14:21:00 +0200
Message-Id: <20230418120258.713853188@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.281-rc1
X-KernelTest-Deadline: 2023-04-20T12:03+00:00
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

This is the start of the stable review cycle for the 4.19.281 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.281-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.281-rc1

Marc Zyngier <marc.zyngier@arm.com>
    arm64: KVM: Fix system register enumeration

Dave Martin <Dave.Martin@arm.com>
    KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST

Dave Martin <Dave.Martin@arm.com>
    KVM: arm64: Factor out core register ID enumeration

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: add missing consistency checks for CR0 and CR4

Steve Clevenger <scclevenger@os.amperecomputing.com>
    coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

George Cherian <george.cherian@marvell.com>
    watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

ZhaoLong Wang <wangzhaolong1@huawei.com>
    ubi: Fix deadlock caused by recursively holding work_sem

Lee Jones <lee.jones@linaro.org>
    mtd: ubi: wl: Fix a couple of kernel-doc issues

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Jiri Kosina <jkosina@suse.cz>
    scsi: ses: Handle enclosure with just a primary component gracefully

Robbie Harwood <rharwood@redhat.com>
    verify_pefile: relax wrapper length check

Hans de Goede <hdegoede@redhat.com>
    efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: imx-lpi2c: clean rx/tx buffers upon new message

Grant Grundler <grundler@chromium.org>
    power: supply: cros_usbpd: reclassify "default case!" as debug

Eric Dumazet <edumazet@google.com>
    udp6: fix potential access to stale information

Roman Gushchin <roman.gushchin@linux.dev>
    net: macb: fix a memory corruption in extended buffer descriptor mode

Xin Long <lucien.xin@gmail.com>
    sctp: fix a potential overflow in sctp_ifwdtsn_skip

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

Kornel Dulęba <korneld@chromium.org>
    Revert "pinctrl: amd: Disable and mask interrupts on resume"

Rongwei Wang <rongwei.wang@linux.alibaba.com>
    mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Zheng Yejian <zhengyejian1@huawei.com>
    ring-buffer: Fix race while reader and writer are on the same page

John Keeping <john@metanate.com>
    ftrace: Mark get_lock_parent_ip() __always_inline

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix the same task check in perf_event_set_output

Jeremy Soller <jeremy@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo X370SNW

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix sysfs interface lifetime

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix transmit end interrupt handler

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

Xin Long <lucien.xin@gmail.com>
    sctp: check send stream number after wait_for_sndbuf

Jakub Kicinski <kuba@kernel.org>
    net: don't let netpoll invoke NAPI if in xmit context

Eric Dumazet <edumazet@google.com>
    icmp: guard against too small mtu

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: cros-ec: Explicitly set .polarity in .get_state()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix hangs when recovering open state after a server reboot

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Check the return value of update_open_stateid()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Convert struct nfs4_state to use refcount_t

Kornel Dulęba <korneld@chromium.org>
    pinctrl: amd: Disable and mask interrupts on resume

Sachi King <nakato@nakato.io>
    pinctrl: amd: disable and mask interrupts on probe

Linus Walleij <linus.walleij@linaro.org>
    pinctrl: amd: Use irqchip template

Sandeep Singh <sandeep.singh@amd.com>
    pinctrl: Added IRQF_SHARED flag for amd-pinctrl driver


-------------

Diffstat:

 Documentation/sound/hd-audio/models.rst         |  2 +-
 Makefile                                        |  4 +-
 arch/arm64/kvm/guest.c                          | 83 ++++++++++++++++++++-----
 arch/x86/kernel/sysfb_efi.c                     |  8 +++
 arch/x86/kvm/vmx/vmx.c                          | 10 ++-
 arch/x86/pci/fixup.c                            | 21 +++++++
 crypto/asymmetric_keys/verify_pefile.c          | 12 ++--
 drivers/gpio/gpio-davinci.c                     |  2 +-
 drivers/hwtracing/coresight/coresight-etm4x.c   |  2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c              |  2 +
 drivers/iio/dac/cio-dac.c                       |  4 +-
 drivers/mtd/mtdblock.c                          | 12 ++--
 drivers/mtd/ubi/build.c                         | 21 +++++--
 drivers/mtd/ubi/wl.c                            |  5 +-
 drivers/net/ethernet/cadence/macb_main.c        |  4 ++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c |  8 ++-
 drivers/net/ethernet/sun/niu.c                  |  2 +-
 drivers/pinctrl/pinctrl-amd.c                   | 56 +++++++++++++----
 drivers/power/supply/cros_usbpd-charger.c       |  2 +-
 drivers/pwm/pwm-cros-ec.c                       |  1 +
 drivers/scsi/ses.c                              | 20 +++---
 drivers/tty/serial/sh-sci.c                     |  9 ++-
 drivers/usb/serial/cp210x.c                     |  1 +
 drivers/usb/serial/option.c                     | 10 +++
 drivers/watchdog/sbsa_gwdt.c                    |  1 +
 fs/nfs/nfs4_fs.h                                |  2 +-
 fs/nfs/nfs4proc.c                               | 25 ++++----
 fs/nfs/nfs4state.c                              |  8 +--
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
 net/core/netpoll.c                              | 19 +++++-
 net/ipv4/icmp.c                                 |  5 ++
 net/ipv6/ip6_output.c                           |  7 ++-
 net/ipv6/udp.c                                  |  8 ++-
 net/mac80211/sta_info.c                         |  3 +-
 net/sctp/socket.c                               |  4 ++
 net/sctp/stream_interleave.c                    |  3 +-
 sound/i2c/cs8427.c                              |  7 ++-
 sound/pci/emu10k1/emupcm.c                      |  4 +-
 sound/pci/hda/patch_realtek.c                   |  1 +
 sound/pci/hda/patch_sigmatel.c                  | 10 +++
 50 files changed, 350 insertions(+), 129 deletions(-)


