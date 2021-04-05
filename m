Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE24353CFC
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhDEI5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233320AbhDEI5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0B3061398;
        Mon,  5 Apr 2021 08:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613060;
        bh=bZ+lbQXm5oH/oXXgzEONm8vZOpt+svu8Zet91L3kHI0=;
        h=From:To:Cc:Subject:Date:From;
        b=AyRkVlszo2QPso5kjoDKECDhPGBeORxpzJnYtn3qR9hstA+1fDHbIU2mJ1WW7H1VJ
         f7c9OUaELJJLD6kT/PJMC2MYyYNu5RQpq4D/pMTwDnPcP3wT1MPzOdrsqv0tU1I2jC
         7jWhiZ3jvuEW1vFg0t7ap+Lo9zu9wa+8EIeB3u0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/35] 4.9.265-rc1 review
Date:   Mon,  5 Apr 2021 10:53:35 +0200
Message-Id: <20210405085018.871387942@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.265-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.265-rc1
X-KernelTest-Deadline: 2021-04-07T08:50+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.265 release.
There are 35 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.265-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.265-rc1

Paul Moore <paul@paul-moore.com>
    audit: fix a net reference leak in audit_list_rules_send()

Paul Moore <paul@paul-moore.com>
    audit: fix a net reference leak in audit_send_reply()

Atul Gopinathan <atulgopinathan@gmail.com>
    staging: rtl8192e: Change state information from u16 to u8

Atul Gopinathan <atulgopinathan@gmail.com>
    staging: rtl8192e: Fix incorrect source in memcpy()

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix use-after-free after probe failure

Oliver Neukum <oneukum@suse.com>
    USB: cdc-acm: downgrade message to debug

Oliver Neukum <oneukum@suse.com>
    cdc-acm: fix BREAK rx code path adding necessary calls

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix broken streams issue on 0.96 xHCI

Vincent Palatin <vpalatin@chromium.org>
    USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem

Zheyu Ma <zheyuma97@gmail.com>
    firewire: nosy: Fix a use-after-free bug in nosy_ioctl()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    extcon: Fix error handling in extcon_dev_register

Wang Panzhenzhuan <randy.wang@rock-chips.com>
    pinctrl: rockchip: fix restore error in resume

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    reiserfs: update reiserfs_xattrs_initialized() condition

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    mm: fix race by making init_zero_pfn() early_initcall

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix stack trace event size

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: call alc_update_headset_mode() in hp_automute_hook

Ikjoon Jang <ikjn@chromium.org>
    ALSA: usb-audio: Apply sample rate quirk to Logitech Connect

Jesper Dangaard Brouer <brouer@redhat.com>
    bpf: Remove MTU check in __bpf_skb_max_len

Tong Zhang <ztong0001@gmail.com>
    net: wan/lmc: unregister device when no matching device is found

Doug Brown <doug@schmorgal.com>
    appletalk: Fix skb allocation size in loopback case

zhangyi (F) <yi.zhang@huawei.com>
    ext4: do not iput inode under running transaction in ext4_rename()

Sameer Pujar <spujar@nvidia.com>
    ASoC: rt5659: Update MCLK rate in set_sysclk()

Tong Zhang <ztong0001@gmail.com>
    staging: comedi: cb_pcidas64: fix request_irq() warn

Tong Zhang <ztong0001@gmail.com>
    staging: comedi: cb_pcidas: fix request_irq() warn

Alexey Dobriyan <adobriyan@gmail.com>
    scsi: qla2xxx: Fix broken #endif placement

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    scsi: st: Fix a use after free in st_open()

Laurent Vivier <lvivier@redhat.com>
    vhost: Fix vhost_vq_reset()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Force inlining of cpu_has_feature() to avoid build failure

Benjamin Rood <benjaminjrood@gmail.com>
    ASoC: sgtl5000: set DAP_AVC_CTRL register to correct default value on probe

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5651: Fix dac- and adc- vol-tlv values being off by a factor of 10

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5640: Fix dac- and adc- vol-tlv values being off by a factor of 10

J. Bruce Fields <bfields@redhat.com>
    rpc: fix NULL dereference on kmalloc failure

Zhaolong Zhang <zhangzl2013@126.com>
    ext4: fix bh ref count on error paths

Jakub Kicinski <kuba@kernel.org>
    ipv6: weaken the v4mapped source check

David Brazdil <dbrazdil@google.com>
    selinux: vsock: Set SID for socket returned by accept()


-------------

Diffstat:

 Makefile                                     |  4 +--
 arch/powerpc/include/asm/cpu_has_feature.h   |  4 +--
 drivers/extcon/extcon.c                      |  1 +
 drivers/firewire/nosy.c                      |  9 ++++--
 drivers/net/wan/lmc/lmc_main.c               |  2 ++
 drivers/pinctrl/pinctrl-rockchip.c           | 13 +++++---
 drivers/scsi/qla2xxx/qla_target.h            |  2 +-
 drivers/scsi/st.c                            |  2 +-
 drivers/staging/comedi/drivers/cb_pcidas.c   |  2 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c |  2 +-
 drivers/staging/rtl8192e/rtllib.h            |  2 +-
 drivers/staging/rtl8192e/rtllib_rx.c         |  2 +-
 drivers/usb/class/cdc-acm.c                  | 12 +++++--
 drivers/usb/core/quirks.c                    |  4 +++
 drivers/usb/host/xhci-mtk.c                  | 10 +++++-
 drivers/vhost/vhost.c                        |  2 +-
 fs/ext4/inode.c                              |  6 ++--
 fs/ext4/namei.c                              | 18 +++++------
 fs/reiserfs/xattr.h                          |  2 +-
 kernel/audit.c                               | 48 +++++++++++++++++-----------
 kernel/audit.h                               |  2 +-
 kernel/auditfilter.c                         | 13 ++++----
 kernel/trace/trace.c                         |  3 +-
 mm/memory.c                                  |  2 +-
 net/appletalk/ddp.c                          | 33 ++++++++++++-------
 net/core/filter.c                            |  7 ++--
 net/dccp/ipv6.c                              |  5 +++
 net/ipv6/ip6_input.c                         | 10 ------
 net/ipv6/tcp_ipv6.c                          |  5 +++
 net/sunrpc/auth_gss/svcauth_gss.c            | 11 ++++---
 net/vmw_vsock/af_vsock.c                     |  1 +
 sound/pci/hda/patch_realtek.c                |  1 +
 sound/soc/codecs/rt5640.c                    |  4 +--
 sound/soc/codecs/rt5651.c                    |  4 +--
 sound/soc/codecs/rt5659.c                    |  5 +++
 sound/soc/codecs/sgtl5000.c                  |  2 +-
 sound/usb/quirks.c                           |  1 +
 37 files changed, 157 insertions(+), 99 deletions(-)


