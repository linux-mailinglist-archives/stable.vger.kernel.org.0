Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0014164A289
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiLLNzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbiLLNzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:55:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBDB10052;
        Mon, 12 Dec 2022 05:55:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AD98B8068B;
        Mon, 12 Dec 2022 13:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A741C433EF;
        Mon, 12 Dec 2022 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853316;
        bh=cU82GpE1qZVmcB7lolE9GrnHh2K4jkAVJ0qMrgx++IA=;
        h=From:To:Cc:Subject:Date:From;
        b=OHP43oCJB1hhdv2I0+EMApnnD67dUTq9fhwQIYsRbdkdFpFDWrNgaGApLO98CHox9
         he7sZ3R0wxiZLC7eQqF9PqEW3SDIxpEza/RfMPf7UcsngJxgCt7NF9Ne0rjzCdasFB
         vNtBwDj9DYFaD5mZ/YHL96eeA99eOa+kyUv0TnFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.9 00/31] 4.9.336-rc1 review
Date:   Mon, 12 Dec 2022 14:19:18 +0100
Message-Id: <20221212130909.943483205@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.336-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.336-rc1
X-KernelTest-Deadline: 2022-12-14T13:09+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.336 release.
There are 31 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.336-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.336-rc1

Dan Carpenter <error27@gmail.com>
    net: mvneta: Fix an out of bounds check

Yang Yingliang <yangyingliang@huawei.com>
    net: plip: don't call kfree_skb/dev_kfree_skb() under spin_lock_irq()

Juergen Gross <jgross@suse.com>
    xen/netback: fix build warning

Zhang Changzhong <zhangchangzhong@huawei.com>
    ethernet: aeroflex: fix potential skb leak in greth_init_rings()

YueHaibing <yuehaibing@huawei.com>
    tipc: Fix potential OOB in tipc_link_proto_rcv()

Liu Jian <liujian56@huawei.com>
    net: hisilicon: Fix potential use-after-free in hix5hd2_rx()

Liu Jian <liujian56@huawei.com>
    net: hisilicon: Fix potential use-after-free in hisi_femac_rx()

Kees Cook <keescook@chromium.org>
    NFC: nci: Bounds check struct nfc_target arrays

Dan Carpenter <error27@gmail.com>
    net: mvneta: Prevent out of bounds read in mvneta_config_rss()

Valentina Goncharenko <goncharenko.vp@ispras.ru>
    net: encx24j600: Fix invalid logic in reading of MISTAT register

Valentina Goncharenko <goncharenko.vp@ispras.ru>
    net: encx24j600: Add parentheses to fix precedence

Wei Yongjun <weiyongjun1@huawei.com>
    mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()

Akihiko Odaki <akihiko.odaki@daynix.com>
    igb: Allocate MSI-X vector when testing

Akihiko Odaki <akihiko.odaki@daynix.com>
    e1000e: Fix TX dispatch condition

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    gpio: amd8111: Fix PCI device reference count leak

Ziyang Xuan <william.xuanziyang@huawei.com>
    ieee802154: cc2520: Fix error return code in cc2520_hw_init()

ZhangPeng <zhangpeng362@huawei.com>
    HID: core: fix shift-out-of-bounds in hid_report_raw_event

Anastasia Belova <abelova@astralinux.ru>
    HID: hid-lg4ff: Add check for empty lbuf

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-dv-timings.c: fix too strict blanking sanity checks

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix voltage switch delay

Masahiro Yamada <yamada.masahiro@socionext.com>
    mmc: sdhci: use FIELD_GET for preset value bit masks

Connor Shu <Connor.Shu@ibm.com>
    rcutorture: Automatically create initrd directory

Juergen Gross <jgross@suse.com>
    xen/netback: don't call kfree_skb() with interrupts disabled

Juergen Gross <jgross@suse.com>
    xen/netback: do some code cleanup

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/netback: Ensure protocol headers don't fall in the non-linear area

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: soc-pcm: Add NULL check in BE reparenting

Kees Cook <keescook@chromium.org>
    ALSA: seq: Fix function prototype mismatch in snd_seq_expand_var_event

Tomislav Novak <tnovak@fb.com>
    ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix ir-receiver node names

Sebastian Reichel <sebastian.reichel@collabora.com>
    arm: dts: rockchip: fix node name for hym8563 rtc


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3036-evb.dts                   |   2 +-
 arch/arm/boot/dts/rk3188-radxarock.dts             |   2 +-
 arch/arm/boot/dts/rk3288-evb-act8846.dts           |   2 +-
 arch/arm/boot/dts/rk3288-firefly.dtsi              |   2 +-
 arch/arm/boot/dts/rk3288-miqi.dts                  |   2 +-
 arch/arm/boot/dts/rk3288-rock2-square.dts          |   2 +-
 arch/arm/include/asm/perf_event.h                  |   2 +-
 drivers/gpio/gpio-amd8111.c                        |   4 +
 drivers/hid/hid-core.c                             |   3 +
 drivers/hid/hid-lg4ff.c                            |   6 +
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  20 +-
 drivers/mmc/host/sdhci.c                           |  73 +++++--
 drivers/mmc/host/sdhci.h                           |  12 +-
 drivers/net/ethernet/aeroflex/greth.c              |   1 +
 drivers/net/ethernet/hisilicon/hisi_femac.c        |   2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   4 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   2 +
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/microchip/encx24j600-regmap.c |   4 +-
 drivers/net/ieee802154/cc2520.c                    |   2 +-
 drivers/net/plip/plip.c                            |   4 +-
 drivers/net/xen-netback/common.h                   |  14 +-
 drivers/net/xen-netback/interface.c                |  22 +-
 drivers/net/xen-netback/netback.c                  | 229 ++++++++++++---------
 drivers/net/xen-netback/rx.c                       |  10 +-
 net/bluetooth/6lowpan.c                            |   1 +
 net/mac802154/iface.c                              |   1 +
 net/nfc/nci/ntf.c                                  |   6 +
 net/tipc/link.c                                    |   4 +-
 sound/core/seq/seq_memory.c                        |  11 +-
 sound/soc/soc-pcm.c                                |   2 +
 tools/testing/selftests/rcutorture/bin/kvm.sh      |   8 +
 tools/testing/selftests/rcutorture/bin/mkinitrd.sh |  60 ++++++
 35 files changed, 342 insertions(+), 185 deletions(-)


