Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06347483253
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiACO0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:26:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56822 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbiACO0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:26:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED6EF6111C;
        Mon,  3 Jan 2022 14:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A8BC36AEB;
        Mon,  3 Jan 2022 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219971;
        bh=OxQOxc9smlvPUCmx8zG86DwTnH1zcYG8D4lj15RjHj0=;
        h=From:To:Cc:Subject:Date:From;
        b=kgajXM3ZhFZaBNPZTk1rf6HMddjWOMy1VcNdlcAyjKspM7//pDTKVl0oIP1dxgRhv
         JtIBp3XZSpNVB94Onp2fBDr/avZJdA1KSz/ByKh8IWVDIE+Ub4LwfYPek2GwZQ+vep
         ZHWhu8e0cuFK2oXithgNgsqxhy0dgHgm36jcYqp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/27] 4.19.224-rc1 review
Date:   Mon,  3 Jan 2022 15:23:40 +0100
Message-Id: <20220103142052.162223000@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.224-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.224-rc1
X-KernelTest-Deadline: 2022-01-05T14:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.224 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.224-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.224-rc1

Muchun Song <songmuchun@bytedance.com>
    net: fix use-after-free in tw_timer_handler

Leo L. Schwab <ewhac@ewhac.org>
    Input: spaceball - fix parsing of movement data packets

Pavel Skripkin <paskripkin@gmail.com>
    Input: appletouch - initialize work before device registration

Alexey Makhalov <amakhalov@vmware.com>
    scsi: vmw_pvscsi: Set residual data length conditionally

Todd Kjos <tkjos@google.com>
    binder: fix async_free_space accounting for empty parcels

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: set interval of FS intr and isoc endpoint

Vincent Pelletier <plr.vincent@gmail.com>
    usb: gadget: f_fs: Clear ffs_eventfd in ffs_data_clear.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fresco FL1100 controller should not have BROKEN_MSI quirk set.

Dmitry V. Levin <ldv@altlinux.org>
    uapi: fix linux/nfc.h userspace compilation errors

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: uapi: use kernel size_t to fix user-space builds

Pavel Skripkin <paskripkin@gmail.com>
    i2c: validate user data in compat ioctl

Miaoqian Lin <linmq006@gmail.com>
    fsl/fman: Fix missing put_device() call in fman_port_probe

wujianguo <wujianguo@chinatelecom.cn>
    selftests/net: udpgso_bench_tx: fix dst ip argument

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix wrong features assignment in case of error

Wei Yongjun <weiyongjun1@huawei.com>
    NFC: st21nfca: Fix memory leak in device probe and remove

Matthias-Christian Ott <ott@mirix.org>
    net: usb: pegasus: Do not drop long Ethernet frames

Xin Long <lucien.xin@gmail.com>
    sctp: use call_rcu to free endpoint

Coco Li <lixiaoyan@google.com>
    selftests: Calculate udpgso segment count without header adjustment

Coco Li <lixiaoyan@google.com>
    udp: using datalen to cap ipv6 udp max gso segments

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()

Tom Rix <trix@redhat.com>
    selinux: initialize proto variable in selinux_ip_postroute_compat()

Heiko Carstens <hca@linux.ibm.com>
    recordmcount.pl: fix typo in s390 mcount regex

Wang Qing <wangqing@vivo.com>
    platform/x86: apple-gmux: use resource_size() with res

Samuel Čavoj <samuel@cavoj.net>
    Input: i8042 - enable deferred probe quirk for ASUS UM325UA

Takashi Iwai <tiwai@suse.de>
    Input: i8042 - add deferred probe support

Jens Wiklander <jens.wiklander@linaro.org>
    tee: handle lookup of shm with reference count 0

Hans de Goede <hdegoede@redhat.com>
    HID: asus: Add depends on USB_HID to HID_ASUS Kconfig option


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt   |   2 +
 Makefile                                          |   4 +-
 drivers/android/binder_alloc.c                    |   2 +-
 drivers/hid/Kconfig                               |   1 +
 drivers/i2c/i2c-dev.c                             |   3 +
 drivers/input/joystick/spaceball.c                |  11 +-
 drivers/input/mouse/appletouch.c                  |   4 +-
 drivers/input/serio/i8042-x86ia64io.h             |  21 +++
 drivers/input/serio/i8042.c                       |  54 ++++---
 drivers/net/ethernet/freescale/fman/fman_port.c   |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  11 +-
 drivers/net/usb/pegasus.c                         |   4 +-
 drivers/nfc/st21nfca/i2c.c                        |  29 ++--
 drivers/platform/x86/apple-gmux.c                 |   2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                  |   4 +-
 drivers/scsi/vmw_pvscsi.c                         |   7 +-
 drivers/tee/tee_shm.c                             | 177 ++++++++--------------
 drivers/usb/gadget/function/f_fs.c                |   9 +-
 drivers/usb/host/xhci-pci.c                       |   5 +-
 drivers/usb/mtu3/mtu3_gadget.c                    |   7 +
 include/linux/tee_drv.h                           |   4 +-
 include/net/sctp/sctp.h                           |   6 +-
 include/net/sctp/structs.h                        |   3 +-
 include/uapi/linux/nfc.h                          |   6 +-
 net/ipv4/af_inet.c                                |  10 +-
 net/ipv6/udp.c                                    |   2 +-
 net/sctp/diag.c                                   |  12 +-
 net/sctp/endpointola.c                            |  23 ++-
 net/sctp/socket.c                                 |  23 ++-
 scripts/recordmcount.pl                           |   2 +-
 security/selinux/hooks.c                          |   2 +-
 tools/testing/selftests/net/udpgso.c              |  12 +-
 tools/testing/selftests/net/udpgso_bench_tx.c     |   8 +-
 33 files changed, 268 insertions(+), 214 deletions(-)


