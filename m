Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D3E4181D7
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 14:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244918AbhIYMPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 08:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244871AbhIYMPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Sep 2021 08:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED63E61279;
        Sat, 25 Sep 2021 12:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632572028;
        bh=SdHoCG1mWLdT/JoBLNx//M8j+0Gk/YDLyqySwBqFMPM=;
        h=From:To:Cc:Subject:Date:From;
        b=Isj7EAFnT/5xSVHl1WsuktPMck/UlWpy69xi3K1aNq3IYiEo/URO8Tu7NmWlEmD+z
         PYX0YySJOM6ebUQ8QuZZI50bZ0NqxdqNCUR9CCXlhs8ut88ObdHwuuBCzfT5mTvb6J
         5HrFY98+5Q3PcuMvXPW9r1zUKQ0BsS6DjSqzUgSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/33] 4.19.208-rc2 review
Date:   Sat, 25 Sep 2021 14:13:46 +0200
Message-Id: <20210925120746.034087226@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.208-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.208-rc2
X-KernelTest-Deadline: 2021-09-27T12:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.208 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.208-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.208-rc2

Guenter Roeck <linux@roeck-us.net>
    drm/nouveau/nvkm: Replace -ENOSYS with -ENODEV

Li Jinlin <lijinlin3@huawei.com>
    blk-throttle: fix UAF by deleteing timer in blk_throtl_exit()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: stm32-lp: Don't modify HW state in .remove() callback

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: rockchip: Don't modify HW state in .remove() callback

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: img: Don't modify HW state in .remove() callback

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

Zou Wei <zou_wei@huawei.com>
    dmaengine: sprd: Add missing MODULE_DEVICE_TABLE

Guenter Roeck <linux@roeck-us.net>
    parisc: Move pci_dev_is_behind_card_dino to where it is used

Thomas Gleixner <tglx@linutronix.de>
    drivers: base: cacheinfo: Get rid of DEFINE_SMP_CALL_CACHE_FUNCTION()

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lpc32xx: Don't modify HW state in .probe() after the PWM chip was registered

Pavel Skripkin <paskripkin@gmail.com>
    profiling: fix shift-out-of-bounds bugs

Zhen Lei <thunder.leizhen@huawei.com>
    nilfs2: use refcount_dec_and_lock() to fix potential UAF

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

Li Huafei <lihuafei1@huawei.com>
    tracing/kprobe: Fix kprobe_on_func_entry() modification

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix max key size for sha384 and sha512

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    apparmor: remove duplicate macro list_entry_is_head()

Neeraj Upadhyay <neeraju@codeaurora.org>
    rcu: Fix missed wakeup of exp_wq waiters

Radim Krčmář <rkrcmar@redhat.com>
    KVM: remember position in kvm->vcpus array

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Fix optimizing out zero-extensions


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/arm64/kernel/cacheinfo.c                     |  7 +---
 arch/mips/kernel/cacheinfo.c                      |  7 +---
 arch/riscv/kernel/cacheinfo.c                     |  7 +---
 arch/s390/net/bpf_jit_comp.c                      | 50 ++++++++++++-----------
 arch/x86/kernel/cpu/cacheinfo.c                   |  7 +---
 block/blk-throttle.c                              |  1 +
 drivers/crypto/talitos.c                          |  2 +-
 drivers/dma/Kconfig                               |  2 +-
 drivers/dma/acpi-dma.c                            | 10 +++--
 drivers/dma/sprd-dma.c                            |  1 +
 drivers/dma/xilinx/xilinx_dma.c                   |  2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c |  2 +-
 drivers/parisc/dino.c                             | 18 ++++----
 drivers/pwm/pwm-img.c                             | 16 --------
 drivers/pwm/pwm-lpc32xx.c                         | 10 ++---
 drivers/pwm/pwm-rockchip.c                        | 14 -------
 drivers/pwm/pwm-stm32-lp.c                        |  2 -
 drivers/thermal/samsung/exynos_tmu.c              |  1 +
 fs/ceph/caps.c                                    |  2 +
 fs/nilfs2/sysfs.c                                 | 26 +++++-------
 fs/nilfs2/the_nilfs.c                             |  9 ++--
 include/linux/cacheinfo.h                         | 18 --------
 include/linux/kvm_host.h                          | 11 ++---
 kernel/profile.c                                  | 21 +++++-----
 kernel/rcu/tree_exp.h                             |  2 +-
 kernel/sys.c                                      |  7 ----
 kernel/trace/trace_kprobe.c                       |  3 +-
 lib/Kconfig.debug                                 |  1 -
 net/9p/trans_virtio.c                             |  4 +-
 net/sctp/input.c                                  |  3 ++
 net/sctp/sm_make_chunk.c                          | 13 ++++--
 security/apparmor/apparmorfs.c                    |  3 --
 virt/kvm/kvm_main.c                               |  5 ++-
 34 files changed, 117 insertions(+), 174 deletions(-)


