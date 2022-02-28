Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97864C7325
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbiB1Rcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbiB1RcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:32:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CB08A323;
        Mon, 28 Feb 2022 09:29:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF26561359;
        Mon, 28 Feb 2022 17:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA31CC340F3;
        Mon, 28 Feb 2022 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069348;
        bh=ttvpikkwgU87/GG3b4mpv99Y+KtbX34DKeSS+FTISXM=;
        h=From:To:Cc:Subject:Date:From;
        b=uSnf0cvZmJOmYwklsDjy+BgvtpGlkfLMpJVix80JUKjr4q7WJZ2qwCMjxBUYCvFI5
         08L0EDhE8z7qiuQpeCt4e+6z6aYCKLSMfSEiOt4eOahf64jKoxfHzGsw1St14iDhr+
         Uxzk3GxmkuuXaeYos/QuRyAYMnhynkyHL42df0V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/34] 4.19.232-rc1 review
Date:   Mon, 28 Feb 2022 18:24:06 +0100
Message-Id: <20220228172207.090703467@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.232-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.232-rc1
X-KernelTest-Deadline: 2022-03-02T17:22+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.232 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.232-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.232-rc1

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix encoding of control signal octet bit DV

Hongyu Xie <xiehongyu1@kylinos.cn>
    xhci: Prevent futile URB re-submissions due to incorrect return value.

Puma Hsu <pumahsu@google.com>
    xhci: re-initialize the HC during resume if HCE was set

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: dwc3: gadget: Let the interrupt handler disable bottom halves.

Hans de Goede <hdegoede@redhat.com>
    usb: dwc3: pci: Fix Bay Trail phy GPIO mappings

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910R1 compositions

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for DW5829e

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracefs: Set the group ownership in apply_options() not parse_options()

Szymon Heidrich <szymon.heidrich@gmail.com>
    USB: gadget: validate endpoint index for xilinx udc

Daehwan Jung <dh10.jung@samsung.com>
    usb: gadget: rndis: add spinlock for rndis response list

Dmytro Bagrii <dimich.dmb@gmail.com>
    Revert "USB: serial: ch341: add new Product ID for CH341A"

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_hpt37x: disable primary channel on HPT371

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: adc: men_z188_adc: Fix a resource leak in an error handling path

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have traceon and traceoff trigger honor the instance

Linus Torvalds <torvalds@linux-foundation.org>
    fget: clarify and improve __fget_files() implementation

Miaohe Lin <linmiaohe@huawei.com>
    memblock: use kfree() to release kmalloced memblock regions

Karol Herbst <kherbst@redhat.com>
    Revert "drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR"

Marc Zyngier <maz@kernel.org>
    gpio: tegra186: Fix chip_data type confusion

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix proper link termination after failed open

Bart Van Assche <bvanassche@acm.org>
    RDMA/ib_srp: Fix a deadlock

ChenXiaoSong <chenxiaosong2@huawei.com>
    configfs: fix a race in configfs_{,un}register_subsystem()

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix wrong return value on ioctl EEPROM query failure

Maxime Ripard <maxime@cerno.tech>
    drm/edid: Always set RGB444

Paul Blakey <paulb@nvidia.com>
    openvswitch: Fix setting ipv6 fields causing hw csum failure

Tao Liu <thomas.liu@ucloud.cn>
    gso: do not skip outer ip header in case of ipip and net_failover

Dan Carpenter <dan.carpenter@oracle.com>
    tipc: Fix end of loop tests for list_for_each_entry()

Eric Dumazet <edumazet@google.com>
    net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends

Xin Long <lucien.xin@gmail.com>
    ping: remove pr_err from ping_lookup

Oliver Neukum <oneukum@suse.com>
    USB: zaurus: support another broken Zaurus

Oliver Neukum <oneukum@suse.com>
    sr9700: sanity check for packet length

Helge Deller <deller@gmx.de>
    parisc/unaligned: Fix ldw() and stw() unalignment handlers

Helge Deller <deller@gmx.de>
    parisc/unaligned: Fix fldd and fstd unaligned handlers on 32-bit kernel

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: don't check owner in vhost_vsock_stop() while releasing

Zhang Qiao <zhangqiao22@huawei.com>
    cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/parisc/kernel/unaligned.c                     | 14 ++---
 drivers/ata/pata_hpt37x.c                          | 14 +++++
 drivers/gpio/gpio-tegra186.c                       | 14 +++--
 drivers/gpu/drm/drm_edid.c                         |  2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c     | 37 +++++------
 drivers/iio/adc/men_z188_adc.c                     |  9 ++-
 drivers/infiniband/ulp/srp/ib_srp.c                |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  2 +-
 drivers/net/usb/cdc_ether.c                        | 12 ++++
 drivers/net/usb/sr9700.c                           |  2 +-
 drivers/net/usb/zaurus.c                           | 12 ++++
 drivers/tty/n_gsm.c                                |  4 +-
 drivers/usb/dwc3/dwc3-pci.c                        |  4 +-
 drivers/usb/dwc3/gadget.c                          |  2 +
 drivers/usb/gadget/function/rndis.c                |  8 +++
 drivers/usb/gadget/function/rndis.h                |  1 +
 drivers/usb/gadget/udc/udc-xilinx.c                |  6 ++
 drivers/usb/host/xhci.c                            | 28 ++++++---
 drivers/usb/serial/ch341.c                         |  1 -
 drivers/usb/serial/option.c                        | 12 ++++
 drivers/vhost/vsock.c                              | 21 ++++---
 fs/configfs/dir.c                                  | 14 +++++
 fs/file.c                                          | 73 +++++++++++++++++-----
 fs/tracefs/inode.c                                 |  5 +-
 include/net/checksum.h                             |  5 ++
 kernel/cgroup/cpuset.c                             |  2 +
 kernel/trace/trace_events_trigger.c                | 52 +++++++++++++--
 mm/memblock.c                                      | 10 ++-
 net/core/skbuff.c                                  |  4 +-
 net/ipv4/af_inet.c                                 |  5 +-
 net/ipv4/ping.c                                    |  1 -
 net/ipv6/ip6_offload.c                             |  2 +
 net/openvswitch/actions.c                          | 46 +++++++++++---
 net/tipc/name_table.c                              |  2 +-
 net/tipc/socket.c                                  |  2 +-
 36 files changed, 337 insertions(+), 101 deletions(-)


