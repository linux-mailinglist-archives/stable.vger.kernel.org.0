Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BE2283988
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgJEP1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbgJEP1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:27:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45E1D2074F;
        Mon,  5 Oct 2020 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911623;
        bh=p93z4WQtOI3uhajTZQMA3bFIP2Vl9K50ERX2Y/m25hQ=;
        h=From:To:Cc:Subject:Date:From;
        b=xMzMpcabKV/oDEUcrtsOj52sFraqHOHb5i1LgXlelhQ+ufyg9izNBwGX2TWfdspfL
         dI6IGrnz/kvQVafiN7brkKLYtGkf60OcIBlNrtqT8tW74cjuycwj1I/NKDEaUeysiz
         6v5lGo47yzGtFKFhcFod6IuD72wmOyudxbxqvdEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/38] 4.19.150-rc1 review
Date:   Mon,  5 Oct 2020 17:26:17 +0200
Message-Id: <20201005142108.650363140@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.150-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.150-rc1
X-KernelTest-Deadline: 2020-10-07T14:21+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.150 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.150-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.150-rc1

Will McVicker <willmcvicker@google.com>
    netfilter: ctnetlink: add a range check for l3/l4 protonum

Al Viro <viro@zeniv.linux.org.uk>
    ep_create_wakeup_source(): dentry name can change under you...

Al Viro <viro@zeniv.linux.org.uk>
    epoll: EPOLL_CTL_ADD: close the race in decision to take fast path

Al Viro <viro@zeniv.linux.org.uk>
    epoll: replace ->visited/visited_list with generation count

Al Viro <viro@zeniv.linux.org.uk>
    epoll: do not insert into poll queues until all sanity checks are done

Or Cohen <orcohen@paloaltonetworks.com>
    net/packet: fix overflow in tpacket_rcv

Laurent Dufour <ldufour@linux.ibm.com>
    mm: don't rely on system state to detect hot-plug operations

Laurent Dufour <ldufour@linux.ibm.com>
    mm: replace memmap_context by meminit_context

Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
    random32: Restore __latent_entropy attribute on net_rand_state

Vincent Huang <vincent.huang@tw.synaptics.com>
    Input: trackpoint - enable Synaptics trackpoints

Nicolas VINCENT <nicolas.vincent@vossloh.com>
    i2c: cpm: Fix i2c_ram structure

Yu Kuai <yukuai3@huawei.com>
    iommu/exynos: add missing put_device() call in exynos_iommu_of_xlate()

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos4: mark 'chipid' clock as CLK_IGNORE_UNUSED

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    nfs: Fix security label length not being reset

Chris Packham <chris.packham@alliedtelesis.co.nz>
    pinctrl: mvebu: Fix i2c sda definition for 98DX3236

Taiping Lai <taiping.lai@unisoc.com>
    gpio: sprd: Clear interrupt when setting the type as edge

James Smart <james.smart@broadcom.com>
    nvme-fc: fail new connections to a deleted host or remote port

Chris Packham <chris.packham@alliedtelesis.co.nz>
    spi: fsl-espi: Only process interrupts for expected events

Felix Fietkau <nbd@nbd.name>
    mac80211: do not allow bigger VHT MPDUs than the hardware supports

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc: Set skb->protocol before transmitting

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Make skb->protocol consistent with the header

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme-core: get/put ctrl and transport module in nvme_dev_open/release()

Olympia Giannou <ogiannou@gmail.com>
    rndis_host: increase sleep time in the query-response loop

Lucy Yan <lucyyan@google.com>
    net: dec: de2104x: Increase receive ring size for Tulip

Martin Cerveny <m.cerveny@computer.org>
    drm/sun4i: mixer: Extend regmap max_register

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices

Jean Delvare <jdelvare@suse.de>
    drm/amdgpu: restore proper ref count in amdgpu_display_crtc_set_config

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Move RCU is watching check after recursion check

Jiri Kosina <jkosina@suse.cz>
    Input: i8042 - add nopnp quirk for Acer Aspire 5 A515

Sebastien Boeuf <sebastien.boeuf@intel.com>
    net: virtio_vsock: Enhance connection semantics

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: add transport parameter to the virtio_transport_reset_no_sock()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: stop workers during the .remove()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: stratix10: fix the divider for the emac_ptp_free_clk

dillon min <dillon.minfei@gmail.com>
    gpio: tc35894: fix up tc35894 interrupt configuration

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpio: mockup: fix resource leak in error path

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    USB: gadget: f_ncm: Fix NDP16 datagram validation

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci: Workaround broken command queuing on Intel GLK based IRBIS models


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/ia64/mm/init.c                         |   6 +-
 drivers/base/node.c                         |  84 +++++----
 drivers/clk/samsung/clk-exynos4.c           |   4 +-
 drivers/clk/socfpga/clk-s10.c               |   2 +-
 drivers/gpio/gpio-mockup.c                  |   2 +
 drivers/gpio/gpio-sprd.c                    |   3 +
 drivers/gpio/gpio-tc3589x.c                 |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c |   2 +-
 drivers/gpu/drm/sun4i/sun8i_mixer.c         |   2 +-
 drivers/i2c/busses/i2c-cpm.c                |   3 +
 drivers/input/mouse/trackpoint.c            |   2 +
 drivers/input/serio/i8042-x86ia64io.h       |   7 +
 drivers/iommu/exynos-iommu.c                |   8 +-
 drivers/mmc/host/sdhci-pci-core.c           |   3 +-
 drivers/net/ethernet/dec/tulip/de2104x.c    |   2 +-
 drivers/net/usb/rndis_host.c                |   2 +-
 drivers/net/wan/hdlc_cisco.c                |   1 +
 drivers/net/wan/hdlc_fr.c                   |   6 +-
 drivers/net/wan/hdlc_ppp.c                  |   1 +
 drivers/net/wan/lapbether.c                 |   4 +-
 drivers/nvme/host/core.c                    |  15 ++
 drivers/nvme/host/fc.c                      |   6 +-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c   |   2 +-
 drivers/spi/spi-fsl-espi.c                  |   5 +-
 drivers/usb/gadget/function/f_ncm.c         |  30 +---
 drivers/vhost/vsock.c                       |  94 +++++-----
 fs/eventpoll.c                              |  71 ++++----
 fs/nfs/dir.c                                |   3 +
 include/linux/mm.h                          |   2 +-
 include/linux/mmzone.h                      |  11 +-
 include/linux/node.h                        |  11 +-
 include/linux/virtio_vsock.h                |   3 +-
 kernel/trace/ftrace.c                       |   6 +-
 lib/random32.c                              |   2 +-
 mm/memory_hotplug.c                         |   5 +-
 mm/page_alloc.c                             |  11 +-
 net/mac80211/vht.c                          |   8 +-
 net/netfilter/nf_conntrack_netlink.c        |   2 +
 net/packet/af_packet.c                      |   9 +-
 net/vmw_vsock/virtio_transport.c            | 265 ++++++++++++++++++----------
 net/vmw_vsock/virtio_transport_common.c     |  13 +-
 42 files changed, 425 insertions(+), 299 deletions(-)


