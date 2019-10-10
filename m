Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C0BD24C9
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388575AbfJJIut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390003AbfJJIus (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F0F820B7C;
        Thu, 10 Oct 2019 08:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697446;
        bh=SEeUxYKKSvIWAKLSQy/rMzSqP/uDnglN9iFCnlo+MBY=;
        h=From:To:Cc:Subject:Date:From;
        b=ZpFIfUpBBKhLBukBLlFS1zx//qjXZDeCx3j8cLlcieBTtwtatPsij6YzEttzv1wzH
         +69GQw5gVeEyKipmAAujuROeYP2owGth4t8VIcd4eg21aRJzi+MmU48ldEczZFSmGF
         40b9pj9UNz5DS45evBXL/BnsDo+ukLSBSoko2www=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/61] 4.14.149-stable review
Date:   Thu, 10 Oct 2019 10:36:25 +0200
Message-Id: <20191010083449.500442342@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.149-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.149-rc1
X-KernelTest-Deadline: 2019-10-12T08:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.149 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.149-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.149-rc1

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: sgtl5000: Improve VAG power and mute control

Johannes Berg <johannes.berg@intel.com>
    nl80211: validate beacon head

Jouni Malinen <j@w1.fi>
    cfg80211: Use const more consistently in for_each_element macros

Johannes Berg <johannes.berg@intel.com>
    cfg80211: add and use strongly typed element iteration macros

Andrew Murray <andrew.murray@arm.com>
    coresight: etm4x: Use explicit barriers on enable/disable

Eric Sandeen <sandeen@redhat.com>
    vfs: Fix EOVERFLOW testing in put_compat_statfs64

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/userptr: Acquire the page lock around set_page_dirty()

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    perf stat: Reset previous counts on repeat with interval

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    perf stat: Fix a segmentation fault when using repeat forever

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix segfault in cpu_cache_level__read()

Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
    tick: broadcast-hrtimer: Fix a race in bc_set_next

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on failure

Gautham R. Shenoy <ego@linux.vnet.ibm.com>
    powerpc/pseries: Fix cpu_hotplug_lock acquisition in resize_hpt()

Mike Christie <mchristi@redhat.com>
    nbd: fix max number of supported devs

Dan Melnic <dmm@fb.com>
    block/ndb: add WQ_UNBOUND to the knbd-recv workqueue

Xiubo Li <xiubli@redhat.com>
    nbd: fix crash when the blksize is zero

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disabling the VP

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf unwind: Fix libunwind build failure on i386 systems

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    kernel/elfcore.c: include proper prototypes

Thomas Richter <tmricht@linux.ibm.com>
    perf build: Add detection of java-11-openjdk-devel package

KeMeng Shi <shikemeng@huawei.com>
    sched/core: Fix migration to invalid CPU in __set_cpus_allowed_ptr()

zhengbin <zhengbin13@huawei.com>
    fuse: fix memleak in cuse_channel_open

Ido Schimmel <idosch@mellanox.com>
    thermal: Fix use-after-free when unregistering thermal zone device

Fabrice Gasnier <fabrice.gasnier@st.com>
    pwm: stm32-lp: Add check in case requested period cannot be achieved

Trond Myklebust <trondmy@gmail.com>
    pNFS: Ensure we do clear the return-on-close layout stateid on fatal errors

Trek <trek00@inbox.ru>
    drm/amdgpu: Check for valid number of registers to read

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: allow lookups in dynamic sets

Ryan Chen <ryan_chen@aspeedtech.com>
    watchdog: aspeed: Add support for AST2600

Erqi Chen <chenerqi@gmail.com>
    ceph: reconnect connection if session hang in opening state

Luis Henriques <lhenriques@suse.com>
    ceph: fix directories inode i_blkbits initialization

Igor Druzhinin <igor.druzhinin@citrix.com>
    xen/pci: reserve MCFG areas earlier

Chengguang Xu <cgxu519@zoho.com.cn>
    9p: avoid attaching writeback_fid on mmap with type PRIVATE

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: nfs: Fix possible null-pointer dereferences in encode_attrs()

Sascha Hauer <s.hauer@pengutronix.de>
    ima: always return negative code for error

Johannes Berg <johannes.berg@intel.com>
    cfg80211: initialize on-stack chandefs

Johan Hovold <johan@kernel.org>
    ieee802154: atusb: fix use-after-free at disconnect

Juergen Gross <jgross@suse.com>
    xen/xenbus: fix self-deadlock after killing user process

Wanpeng Li <wanpengli@tencent.com>
    Revert "locking/pvqspinlock: Don't wait if vCPU is preempted"

Russell King <rmk+kernel@armlinux.org.uk>
    mmc: sdhci-of-esdhc: set DMA snooping based on DMA coherence

Russell King <rmk+kernel@armlinux.org.uk>
    mmc: sdhci: improve ADMA error reporting

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/omap: fix max fclk divider for omap36xx

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    watchdog: imx2_wdt: fix min() calculation in imx2_wdt_set_timeout

Li RongQing <lirongqing@baidu.com>
    timer: Read jiffies once when forwarding base clk

Kees Cook <keescook@chromium.org>
    usercopy: Avoid HIGHMEM pfn warning

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Treat Loongson Extensions as ASEs

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - fix concurrency issue in givencrypt descriptor

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: cavium/zip - Add missing single_release()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: skcipher - Unmap pages after an external error

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    crypto: qat - Silence smp_processor_id() warning

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Fix "robust" test of do_generate_dynamic_list_file

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251x: mcp251x_hw_reset(): allow more time after a reset

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc/powernv: Restrict OPAL symbol map to only be readable by root

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: Define a set of DAPM pre/post-up events

Dmitry Osipenko <digetx@gmail.com>
    PM / devfreq: tegra: Fix kHz to Hz conversion

Jack Wang <jinpu.wang@cloud.ionos.com>
    KVM: nVMX: handle page fault in vmread fix

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Don't lose pending doorbell request on migration on P9

Vasily Gorbik <gor@linux.ibm.com>
    s390/cio: exclude subchannels with no parent from pseudo check

Vasily Gorbik <gor@linux.ibm.com>
    s390/cio: avoid calling strlen on null pointer

Vasily Gorbik <gor@linux.ibm.com>
    s390/topology: avoid firing events before kobjs are created

Thomas Huth <thuth@redhat.com>
    KVM: s390: Test for bad access register and size at the start of S390_MEM_OP

Vasily Gorbik <gor@linux.ibm.com>
    s390/process: avoid potential reading of freed stack


-------------

Diffstat:

 Makefile                                       |   4 +-
 arch/mips/include/asm/cpu-features.h           |  16 ++
 arch/mips/include/asm/cpu.h                    |   4 +
 arch/mips/kernel/cpu-probe.c                   |   6 +
 arch/mips/kernel/proc.c                        |   4 +
 arch/powerpc/kvm/book3s_hv.c                   |   9 +-
 arch/powerpc/kvm/book3s_xive.c                 |  18 +-
 arch/powerpc/mm/hash_utils_64.c                |   9 +-
 arch/powerpc/platforms/powernv/opal.c          |  11 +-
 arch/powerpc/platforms/pseries/lpar.c          |   8 +-
 arch/s390/kernel/process.c                     |  22 ++-
 arch/s390/kernel/topology.c                    |   3 +-
 arch/s390/kvm/kvm-s390.c                       |   2 +-
 arch/x86/kvm/vmx.c                             |   2 +-
 crypto/skcipher.c                              |  42 +++--
 drivers/block/nbd.c                            |  61 +++++--
 drivers/crypto/caam/caamalg_desc.c             |   9 +
 drivers/crypto/caam/caamalg_desc.h             |   2 +-
 drivers/crypto/cavium/zip/zip_main.c           |   3 +
 drivers/crypto/qat/qat_common/adf_common_drv.h |   2 +-
 drivers/devfreq/tegra-devfreq.c                |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c        |   3 +
 drivers/gpu/drm/i915/i915_gem_userptr.c        |  10 +-
 drivers/gpu/drm/omapdrm/dss/dss.c              |   2 +-
 drivers/hwtracing/coresight/coresight-etm4x.c  |  14 +-
 drivers/mmc/host/sdhci-of-esdhc.c              |   7 +-
 drivers/mmc/host/sdhci.c                       |  15 +-
 drivers/net/can/spi/mcp251x.c                  |  19 +-
 drivers/net/ieee802154/atusb.c                 |   3 +-
 drivers/pwm/pwm-stm32-lp.c                     |   6 +
 drivers/s390/cio/ccwgroup.c                    |   2 +-
 drivers/s390/cio/css.c                         |   2 +
 drivers/thermal/thermal_core.c                 |   2 +-
 drivers/watchdog/aspeed_wdt.c                  |   4 +-
 drivers/watchdog/imx2_wdt.c                    |   4 +-
 drivers/xen/pci.c                              |  21 ++-
 drivers/xen/xenbus/xenbus_dev_frontend.c       |  20 ++-
 fs/9p/vfs_file.c                               |   3 +
 fs/ceph/inode.c                                |   7 +-
 fs/ceph/mds_client.c                           |   4 +-
 fs/fuse/cuse.c                                 |   1 +
 fs/nfs/nfs4xdr.c                               |   2 +-
 fs/nfs/pnfs.c                                  |   9 +-
 fs/statfs.c                                    |  17 +-
 include/linux/ieee80211.h                      |  53 ++++++
 include/sound/soc-dapm.h                       |   2 +
 kernel/elfcore.c                               |   1 +
 kernel/locking/qspinlock_paravirt.h            |   2 +-
 kernel/sched/core.c                            |   4 +-
 kernel/time/tick-broadcast-hrtimer.c           |  57 +++---
 kernel/time/timer.c                            |   8 +-
 mm/usercopy.c                                  |   8 +-
 net/netfilter/nf_tables_api.c                  |   7 +-
 net/netfilter/nft_lookup.c                     |   3 -
 net/wireless/nl80211.c                         |  42 ++++-
 net/wireless/reg.c                             |   2 +-
 net/wireless/scan.c                            |  14 +-
 net/wireless/wext-compat.c                     |   2 +-
 security/integrity/ima/ima_crypto.c            |   5 +-
 sound/soc/codecs/sgtl5000.c                    | 232 +++++++++++++++++++++----
 tools/lib/traceevent/Makefile                  |   4 +-
 tools/lib/traceevent/event-parse.c             |   3 +-
 tools/perf/Makefile.config                     |   2 +-
 tools/perf/arch/x86/util/unwind-libunwind.c    |   2 +-
 tools/perf/builtin-stat.c                      |   5 +-
 tools/perf/util/header.c                       |   2 +-
 tools/perf/util/stat.c                         |  17 ++
 tools/perf/util/stat.h                         |   1 +
 68 files changed, 696 insertions(+), 208 deletions(-)


