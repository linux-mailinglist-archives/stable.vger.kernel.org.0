Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37A741727F
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344163AbhIXMs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344162AbhIXMsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:48:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C271760F12;
        Fri, 24 Sep 2021 12:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487595;
        bh=QliXmsSyPayHK+Ne9kksQz3eYfoAWPwGscuczzaL5Lo=;
        h=From:To:Cc:Subject:Date:From;
        b=iVq+pWyv6dgFPPyQTpKwrokdOVjZVGrzAKOnpv9/NFjXZNSkyf8nI02H3Uhi/nITw
         srDiWKFcIGb8BgawWDr5TlEPQzWtpXisTs1xvaFXKMMWkKhS1lXSibB5yEp+QqYNKz
         DpdIwLaFBp3XyQXsg/5rOZ4EpIgmH2W/ShMmudeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/26] 4.9.284-rc1 review
Date:   Fri, 24 Sep 2021 14:43:48 +0200
Message-Id: <20210924124328.336953942@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.284-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.284-rc1
X-KernelTest-Deadline: 2021-09-26T12:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.284 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.284-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.284-rc1

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: validate from_addr_param return

Guenter Roeck <linux@roeck-us.net>
    drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Li Jinlin <lijinlin3@huawei.com>
    blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_delete_##name##_group

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_create_##name##_group

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix NULL pointer in nilfs_##name##_attr_release

Nanyong Sun <sunnanyong@huawei.com>
    nilfs2: fix memory leak in nilfs_sysfs_create_device_group

Jeff Layton <jlayton@kernel.org>
    ceph: lockdep annotations for try_nonblocking_invalidate

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: xilinx_dma: Set DMA mask for coherent APIs

Johannes Berg <johannes.berg@intel.com>
    dmaengine: ioat: depends on !UML

Guenter Roeck <linux@roeck-us.net>
    parisc: Move pci_dev_is_behind_card_dino to where it is used

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: mxs: Don't modify HW state in .probe() after the PWM chip was registered

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered

Pavel Skripkin <paskripkin@gmail.com>
    profiling: fix shift-out-of-bounds bugs

Cyrill Gorcunov <gorcunov@gmail.com>
    prctl: allow to setup brk for et_dyn executables

Xie Yongji <xieyongji@bytedance.com>
    9p/trans_virtio: Remove sysfs file on probe failure

Dan Carpenter <dan.carpenter@oracle.com>
    thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: acpi: Avoid comparison GSI with Linux vIRQ

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: add param size validation for SCTP_PARAM_SET_PRIMARY

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: validate chunk size in __rcv_asconf_lookup

Cheng Chao <cs.os.kernel@gmail.com>
    staging: android: ion: fix page is NULL

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix max key size for sha384 and sha512

Tony Lindgren <tony@atomide.com>
    PM / wakeirq: Fix unbalanced IRQ enable for wakeirq

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Fix optimizing out zero-extensions


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/s390/net/bpf_jit_comp.c                      | 50 ++++++++++++-----------
 block/blk-throttle.c                              |  1 +
 drivers/base/power/wakeirq.c                      |  6 ++-
 drivers/crypto/talitos.c                          |  2 +-
 drivers/dma/Kconfig                               |  2 +-
 drivers/dma/acpi-dma.c                            | 10 +++--
 drivers/dma/xilinx/xilinx_dma.c                   |  2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c |  2 +-
 drivers/parisc/dino.c                             | 18 ++++----
 drivers/pwm/pwm-lpc32xx.c                         | 10 ++---
 drivers/pwm/pwm-mxs.c                             | 13 +++---
 drivers/staging/android/ion/ion_system_heap.c     |  2 +-
 drivers/thermal/samsung/exynos_tmu.c              |  1 +
 fs/ceph/caps.c                                    |  2 +
 fs/nilfs2/sysfs.c                                 | 26 +++++-------
 include/net/sctp/structs.h                        |  2 +-
 kernel/profile.c                                  | 21 +++++-----
 kernel/sys.c                                      |  7 ----
 net/9p/trans_virtio.c                             |  4 +-
 net/sctp/bind_addr.c                              | 20 +++++----
 net/sctp/input.c                                  |  9 +++-
 net/sctp/ipv6.c                                   |  7 +++-
 net/sctp/protocol.c                               |  7 +++-
 net/sctp/sm_make_chunk.c                          | 42 +++++++++++--------
 25 files changed, 149 insertions(+), 121 deletions(-)


