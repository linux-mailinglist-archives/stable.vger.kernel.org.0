Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF6B5E9EC7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiIZKN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiIZKNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:13:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2568C32;
        Mon, 26 Sep 2022 03:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E6A260A55;
        Mon, 26 Sep 2022 10:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FB8C433C1;
        Mon, 26 Sep 2022 10:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187229;
        bh=litRyAjStSqHEezQJkB04fWiFgRbwMFxc0CuFPEHHtw=;
        h=From:To:Cc:Subject:Date:From;
        b=hQZ/jl7zy/2KNfoCOIrvvGV09FcRPqBIDC4ndI678/STdsIqKjXnrNAWqXAi/lPxK
         86/tmw0/wX2nW2O9lbigY+GYY+D6NRzx6c6oG1UlJZJ6C2GmL4bAatNOdey/n8KzKV
         Xd6EXarwk/em+X37R3uYmECsmy27pz9QO+YK/GRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/30] 4.9.330-rc1 review
Date:   Mon, 26 Sep 2022 12:11:31 +0200
Message-Id: <20220926100736.153157100@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.330-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.330-rc1
X-KernelTest-Deadline: 2022-09-28T10:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.330 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.330-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.330-rc1

Jan Kara <jack@suse.cz>
    ext4: make directory inode spreading reflect flexbg size

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: Create uart_xmit_advance()

Sean Anderson <seanga2@gmail.com>
    net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Adrian Hunter <adrian.hunter@intel.com>
    perf kcore_copy: Do not check /proc/modules is unchanged

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): fix race dev->can.state condition

Randy Dunlap <rdunlap@infradead.org>
    MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko

Benjamin Poirier <bpoirier@nvidia.com>
    net: team: Unsync device addresses on ndo_stop

Lu Wei <luwei32@huawei.com>
    ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

David Leadbeater <dgl@dgl.cx>
    netfilter: nf_conntrack_irc: Tighten matching on DCC message

Igor Ryzhov <iryzhov@nfware.com>
    netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Chao Yu <chao.yu@oppo.com>
    mm/slub: fix to return errno if kmalloc() fails

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: add Intel 5 Series / 3400 PCI DID

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda/tegra: set depop delay for tegra

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix RST error in hub.c

Siddh Raman Pant <code@siddh.me>
    wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Liang He <windhl@126.com>
    arm: mach-spear: Add missing of_node_put() in time.c

Liang He <windhl@126.com>
    mips: lantiq: Add missing of_node_put() in irq.c

Liang He <windhl@126.com>
    mips/pic32/pic32mzda: Fix refcount leak bugs

Liang He <windhl@126.com>
    mips: lantiq: xway: Fix refcount leak bug in sysctrl

Liang He <windhl@126.com>
    mips: lantiq: falcon: Fix refcount leak bug in sysctrl

Yihao Han <hanyihao@vivo.com>
    video: fbdev: simplefb: Check before clk_put() not needed

Hyunwoo Kim <imv4bel@gmail.com>
    video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Petr Cvek <petrcvekcz@gmail.com>
    video: fbdev: intelfb: Use aperture size from pci_resource_len

Xiang wangx <wangxiang@cdjrlc.com>
    video: fbdev: skeletonfb: Fix syntax errors in comments

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: crtc: Use an union to store the page flip callback

Stefan Metzmacher <metze@samba.org>
    cifs: don't send down the destination address to sendmsg for a SOCK_STREAM

Yang Yingliang <yangyingliang@huawei.com>
    parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()


-------------

Diffstat:

 Makefile                                |  4 ++--
 arch/arm/mach-spear/time.c              |  8 ++++++--
 arch/mips/lantiq/clk.c                  |  1 +
 arch/mips/lantiq/falcon/sysctrl.c       |  6 ++++++
 arch/mips/lantiq/irq.c                  |  1 +
 arch/mips/lantiq/xway/sysctrl.c         |  4 ++++
 arch/mips/pic32/pic32mzda/init.c        |  7 ++++++-
 arch/mips/pic32/pic32mzda/time.c        |  3 +++
 drivers/gpu/drm/vc4/vc4_crtc.c          | 20 +++++++++++++------
 drivers/hv/vmbus_drv.c                  | 10 +++++++++-
 drivers/net/can/usb/gs_usb.c            |  4 ++--
 drivers/net/ethernet/sun/sunhme.c       |  4 ++--
 drivers/net/ipvlan/ipvlan_core.c        |  6 ++++--
 drivers/net/team/team.c                 | 24 +++++++++++++++++------
 drivers/parisc/ccio-dma.c               |  1 +
 drivers/s390/block/dasd_alias.c         |  9 +++++++--
 drivers/tty/serial/serial-tegra.c       |  5 ++---
 drivers/usb/core/hub.c                  |  2 +-
 drivers/video/fbdev/intelfb/intelfbhw.c | 12 +++++-------
 drivers/video/fbdev/pxa3xx-gcu.c        |  2 +-
 drivers/video/fbdev/simplefb.c          |  3 +--
 drivers/video/fbdev/skeletonfb.c        |  2 +-
 fs/cifs/transport.c                     |  4 ++--
 fs/ext4/ialloc.c                        |  2 +-
 include/linux/serial_core.h             | 17 +++++++++++++++++
 mm/slub.c                               |  5 ++++-
 net/mac80211/scan.c                     | 11 +++++++----
 net/netfilter/nf_conntrack_irc.c        | 34 +++++++++++++++++++++++++++------
 net/netfilter/nf_conntrack_sip.c        |  4 ++--
 sound/pci/hda/hda_intel.c               |  2 ++
 sound/pci/hda/patch_hdmi.c              |  1 +
 tools/perf/util/symbol-elf.c            |  7 ++-----
 32 files changed, 163 insertions(+), 62 deletions(-)


