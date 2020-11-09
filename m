Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285602ABC07
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbgKINdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731138AbgKINGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:06:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B055B2076E;
        Mon,  9 Nov 2020 13:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927207;
        bh=O0SCRTWO93eCIlxEDHZcwmDLvWrbDDpBynD2p9B8QO8=;
        h=From:To:Cc:Subject:Date:From;
        b=s5A2b7gcvBqf+aNuml/3u056xJO4qyahRHeQyzooZnc7f1bc0EoYchKICHv5qj8HA
         6KY0NFPqI8SDe49m3eJrM9j2yKmlbIqo/w0FPqSz9kkN0IcPEKDb+gjpLuG5MsKKb7
         IJfM96zI1R+f2m46DSh5eV5H+dprqM/vgjqdGNDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.14 00/48] 4.14.205-rc1 review
Date:   Mon,  9 Nov 2020 13:55:09 +0100
Message-Id: <20201109125016.734107741@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.205-rc1
X-KernelTest-Deadline: 2020-11-11T12:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.205 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.205-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.205-rc1

Tomasz Maciej Nowak <tmn505@gmail.com>
    arm64: dts: marvell: espressobin: add ethernet alias

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Resume the device earlier in __device_release_driver()

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    Revert "ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE"

Vineet Gupta <vgupta@synopsys.com>
    ARC: stack unwinding: avoid indefinite looping

Macpaul Lin <macpaul.lin@mediatek.com>
    usb: mtu3: fix panic in mtu3_gadget_stop()

Alan Stern <stern@rowland.harvard.edu>
    USB: Add NO_LPM quirk for Kingston flash drive

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN980 composition 0x1055

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add LE910Cx compositions 0x1203, 0x1230, 0x1231

Ziyi Cao <kernel@septs.pw>
    USB: serial: option: add Quectel EC200T module support

Johan Hovold <johan@kernel.org>
    USB: serial: cyberjack: fix write-URB completion race

Qinglang Miao <miaoqinglang@huawei.com>
    serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init

Claire Chang <tientzu@chromium.org>
    serial: 8250_mtk: Fix uart_get_baud_rate warning

Eddy Wu <itseddy0402@gmail.com>
    fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent

Daniel Vetter <daniel.vetter@ffwll.ch>
    vt: Disable KD_FONT_OP_COPY

Zhang Qilong <zhangqilong3@huawei.com>
    ACPI: NFIT: Fix comparison to '-ENXIO'

Hoegeun Kwon <hoegeun.kwon@samsung.com>
    drm/vc4: drv: Add error handding for bind

Jeff Vander Stoep <jeffv@google.com>
    vsock: use ns_capable_noaudit() on socket create

Ming Lei <ming.lei@redhat.com>
    scsi: core: Don't start concurrent async scan on same host

Gabriel Krisman Bertazi <krisman@collabora.com>
    blk-cgroup: Pre-allocate tree node on blkg_conf_prep

Gabriel Krisman Bertazi <krisman@collabora.com>
    blk-cgroup: Fix memleak on error path

Vincent Whitchurch <vincent.whitchurch@axis.com>
    of: Fix reserved-memory overlap detection

Kairui Song <kasong@redhat.com>
    x86/kexec: Use up-to-dated screen_info copy to fill boot params

Clément Péron <peron.clem@gmail.com>
    ARM: dts: sun4i-a10: fix cpu_alert temperature

Mike Galbraith <efault@gmx.de>
    futex: Handle transient "ownerless" rtmutex state correctly

Qiujun Huang <hqjagain@gmail.com>
    tracing: Fix out of bounds write in get_trace_buf

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Handle tracing when switching between context

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Fix recursion check for NMI test

Alexander Aring <aahringo@redhat.com>
    gfs2: Wake up when sd_glock_disposal becomes zero

Jason Gunthorpe <jgg@nvidia.com>
    mm: always have io_remap_pfn_range() set pgprot_decrypted()

Zqiang <qiang.zhang@windriver.com>
    kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

Vasily Gorbik <gor@linux.ibm.com>
    lib/crc32test: remove extra local_irq_disable/enable

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Add implicit feedback quirk for Qu-16

Lee Jones <lee.jones@linaro.org>
    Fonts: Replace discarded const qualifier

Martyna Szapar <martyna.szapar@intel.com>
    i40e: Memory leak in i40e_config_iwarp_qvlist

Martyna Szapar <martyna.szapar@intel.com>
    i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c

Grzegorz Siwik <grzegorz.siwik@intel.com>
    i40e: Wrong truncation from u16 to u8

Sergey Nemov <sergey.nemov@intel.com>
    i40e: add num_vectors checker in iwarp handler

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i40e: Fix a potential NULL pointer dereference

Luis Chamberlain <mcgrof@kernel.org>
    blktrace: fix debugfs use after free

Liu Bo <bo.liu@linux.alibaba.com>
    Blktrace: bail out early if block debugfs is not configured

YueHaibing <yuehaibing@huawei.com>
    sfp: Fix error handing in sfp_probe()

Petr Malat <oss@malat.biz>
    sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Account for Tx PTP timestamp in the skb headroom

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP

Hoang Huu Le <hoang.h.le@dektech.com.au>
    tipc: fix use-after-free in tipc_bcast_get_mode

Juergen Gross <jgross@suse.com>
    xen/events: don't use chip_data for legacy IRQs

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Break up error capture compression loops with cond_resched()


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/arc/kernel/entry.S                            | 16 +++++++----
 arch/arc/kernel/stacktrace.c                       |  7 ++++-
 arch/arm/boot/dts/sun4i-a10.dtsi                   |  2 +-
 .../boot/dts/marvell/armada-3720-espressobin.dts   |  4 +++
 arch/x86/kernel/kexec-bzimage64.c                  |  3 +-
 block/blk-cgroup.c                                 | 15 ++++++++--
 drivers/acpi/nfit/core.c                           |  2 +-
 drivers/base/dd.c                                  |  7 +++--
 drivers/gpu/drm/i915/i915_gpu_error.c              |  3 ++
 drivers/gpu/drm/vc4/vc4_drv.c                      |  1 +
 drivers/net/ethernet/freescale/gianfar.c           | 14 ++--------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 32 ++++++++++++++++++----
 drivers/net/phy/sfp.c                              |  3 +-
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/of/of_reserved_mem.c                       | 13 +++++++--
 drivers/scsi/scsi_scan.c                           |  7 +++--
 drivers/tty/serial/8250/8250_mtk.c                 |  2 +-
 drivers/tty/serial/serial_txx9.c                   |  3 ++
 drivers/tty/vt/vt.c                                | 24 ++--------------
 drivers/usb/core/quirks.c                          |  3 ++
 drivers/usb/mtu3/mtu3_gadget.c                     |  1 +
 drivers/usb/serial/cyberjack.c                     |  7 ++++-
 drivers/usb/serial/option.c                        | 10 +++++++
 drivers/xen/events/events_base.c                   | 29 ++++++++++++++------
 fs/gfs2/glock.c                                    |  3 +-
 include/asm-generic/pgtable.h                      |  4 ---
 include/linux/mm.h                                 |  9 ++++++
 kernel/fork.c                                      | 10 +++----
 kernel/futex.c                                     | 16 +++++++++--
 kernel/kthread.c                                   |  3 +-
 kernel/trace/blktrace.c                            | 24 ++++++++++------
 kernel/trace/trace.c                               |  2 +-
 kernel/trace/trace.h                               | 26 ++++++++++++++++--
 kernel/trace/trace_selftest.c                      |  9 ++++--
 lib/crc32test.c                                    |  4 ---
 lib/fonts/font_10x18.c                             |  2 +-
 lib/fonts/font_6x10.c                              |  2 +-
 lib/fonts/font_6x11.c                              |  2 +-
 lib/fonts/font_7x14.c                              |  2 +-
 lib/fonts/font_8x16.c                              |  2 +-
 lib/fonts/font_8x8.c                               |  2 +-
 lib/fonts/font_acorn_8x8.c                         |  2 +-
 lib/fonts/font_mini_4x6.c                          |  2 +-
 lib/fonts/font_pearl_8x8.c                         |  2 +-
 lib/fonts/font_sun12x22.c                          |  2 +-
 lib/fonts/font_sun8x16.c                           |  2 +-
 net/sctp/sm_sideeffect.c                           |  4 +--
 net/tipc/core.c                                    |  5 ++++
 net/vmw_vsock/af_vsock.c                           |  2 +-
 sound/usb/pcm.c                                    |  1 +
 51 files changed, 240 insertions(+), 117 deletions(-)


