Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7B4566AA7
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbiGEMAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbiGEMAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:00:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655632678;
        Tue,  5 Jul 2022 05:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9B2B3CE0B30;
        Tue,  5 Jul 2022 12:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B72EC341CB;
        Tue,  5 Jul 2022 12:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022419;
        bh=pa45tl29+G9O2mE0kb0Cca151qnPjZUs8v9AvFEseH8=;
        h=From:To:Cc:Subject:Date:From;
        b=R/vZ72WZrkOTcHeZsIv58nNoJ6AwSqNsLJukbySiX/oHuf7B/4gBKhEm1X+YyZbGH
         FvcgSQNY7Zb5RsDukIvlADJOVRuotIVeM6sMirYiHcZjmdVaENvi5bR262zkSQ+9LT
         S8UlxhTwN78wq/xmBP3TUk3+iyzjedt0f3AIvS+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/29] 4.9.322-rc1 review
Date:   Tue,  5 Jul 2022 13:57:41 +0200
Message-Id: <20220705115605.742248854@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.322-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.322-rc1
X-KernelTest-Deadline: 2022-07-07T11:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.322 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.322-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.322-rc1

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1070 composition

Carlo Lobrano <c.lobrano@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1060 composition

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions

Jörgen Storvist <jorgen.storvist@gmail.com>
    qmi_wwan: Added support for Telit LN940 series

Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
    xen/arm: Fix race in RB-tree based P2M accounting

Roger Pau Monne <roger.pau@citrix.com>
    xen/blkfront: force data bouncing when backend is untrusted

Roger Pau Monne <roger.pau@citrix.com>
    xen/netfront: force data bouncing when backend is untrusted

Roger Pau Monne <roger.pau@citrix.com>
    xen/netfront: fix leaking data in shared pages

Roger Pau Monne <roger.pau@citrix.com>
    xen/blkfront: fix leaking data in shared pages

Ilya Lesokhin <ilyal@mellanox.com>
    net: Rename and export copy_skb_header

katrinzhou <katrinzhou@tencent.com>
    ipv6/sit: fix ipip6_tunnel_get_prl return value

kernel test robot <lkp@intel.com>
    sit: use min

Doug Berger <opendmb@gmail.com>
    net: dsa: bcm_sf2: force pause link settings

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (ibmaem) don't call platform_device_del() if platform_device_add() fails

Demi Marie Obenour <demi@invisiblethingslab.com>
    xen/gntdev: Avoid blocking in unmap_grant_pages()

Michael Walle <michael@walle.cc>
    NFC: nxp-nci: Don't issue a zero length i2c_master_read()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    nfc: nfcmrvl: Fix irq_of_parse_and_map() return value

Yevhen Orlov <yevhen.orlov@plvision.eu>
    net: bonding: fix use-after-free after 802.3ad slave unbind

Eric Dumazet <edumazet@google.com>
    net: bonding: fix possible NULL deref in rlb code

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: restore set element counter when failing to update

Jason Wang <jasowang@redhat.com>
    caif_virtio: fix race between virtio_device_ready() and ndo_open()

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/powernv: wire up rng during setup_arch

Oliver Neukum <oneukum@suse.com>
    usbnet: fix memory allocation in helpers

Oliver Neukum <oneukum@suse.com>
    usbnet: make sure no NULL pointer is passed through

Jose Alonso <joalonsof@gmail.com>
    net: usb: ax88179_178a: Fix packet receiving

Duoming Zhou <duoming@zju.edu.cn>
    net: rose: fix UAF bugs caused by timer handler

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix READ_PLUS crasher

Mikulas Patocka <mpatocka@redhat.com>
    dm raid: fix KASAN warning in raid5_add_disks


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/arm/xen/p2m.c                       |   6 +-
 arch/powerpc/include/asm/ppc-opcode.h    |   4 +
 arch/powerpc/platforms/powernv/powernv.h |   2 +
 arch/powerpc/platforms/powernv/rng.c     |  91 ++++++++++++++++---
 arch/powerpc/platforms/powernv/setup.c   |   2 +
 drivers/block/xen-blkfront.c             |  52 +++++++----
 drivers/hwmon/ibmaem.c                   |  12 ++-
 drivers/md/raid5.c                       |   1 +
 drivers/net/bonding/bond_3ad.c           |   3 +-
 drivers/net/bonding/bond_alb.c           |   2 +-
 drivers/net/caif/caif_virtio.c           |  10 ++-
 drivers/net/dsa/bcm_sf2.c                |   5 ++
 drivers/net/usb/ax88179_178a.c           | 101 ++++++++++++++++------
 drivers/net/usb/qmi_wwan.c               |   6 ++
 drivers/net/usb/usbnet.c                 |  23 +++--
 drivers/net/xen-netfront.c               |  55 +++++++++++-
 drivers/nfc/nfcmrvl/i2c.c                |   6 +-
 drivers/nfc/nfcmrvl/spi.c                |   6 +-
 drivers/nfc/nxp-nci/i2c.c                |   3 +
 drivers/xen/gntdev.c                     | 144 ++++++++++++++++++++++---------
 include/linux/skbuff.h                   |   1 +
 net/core/skbuff.c                        |   9 +-
 net/ipv6/sit.c                           |  10 +--
 net/netfilter/nft_set_hash.c             |   2 +
 net/rose/rose_timer.c                    |  34 ++++----
 net/sunrpc/xdr.c                         |   2 +-
 27 files changed, 445 insertions(+), 151 deletions(-)


