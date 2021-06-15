Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1F53A76E3
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 08:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhFOGJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 02:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhFOGJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 02:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BF9261403;
        Tue, 15 Jun 2021 06:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623737241;
        bh=1zff0RX1AFmNmDHbsrh7OySwrtsyw5e38MV2i85oadI=;
        h=From:To:Cc:Subject:Date:From;
        b=Jq3RgDy1dZhZF6nNiNCS9SpN9k1G9SJalYLFuVx8j/te80kKl9ODID4GL9P7sVjuY
         PM55A8GdtEZoJ2/OOsHQhh1/lRXIXfA/N09PPl8FSfBtVoLHOj46q3M2FkfBoKhdpn
         /Hzojxl68u8zQN0wkk7ARBAWX0E6s9J0Lh99LcdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/41] 4.9.273-rc2 review
Date:   Tue, 15 Jun 2021 08:07:19 +0200
Message-Id: <20210615060657.351134482@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.273-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.273-rc2
X-KernelTest-Deadline: 2021-06-17T06:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.273 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 17 Jun 2021 06:06:45 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.273-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.273-rc2

Liangyan <liangyan.peng@linux.alibaba.com>
    tracing: Correct the length check which causes memory corruption

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Do not blindly read the ip address in ftrace_bug()

Ming Lei <ming.lei@redhat.com>
    scsi: core: Only put parent device if host state differs from SHOST_CREATED

Ming Lei <ming.lei@redhat.com>
    scsi: core: Fix error handling of scsi_host_alloc()

Dai Ngo <dai.ngo@oracle.com>
    NFSv4: nfs4_proc_set_acl needs to restore NFS_CAP_UIDGID_NOMAP on error.

Paolo Bonzini <pbonzini@redhat.com>
    kvm: fix previous commit for 32-bit builds

Leo Yan <leo.yan@linaro.org>
    perf session: Correct buffer copying when peeking events

Dan Carpenter <dan.carpenter@oracle.com>
    NFS: Fix a potential NULL dereference in nfs_get_client()

Marco Elver <elver@google.com>
    perf: Fix data race between pin_count increment/decrement

Maciej Żenczykowski <maze@google.com>
    usb: fix various gadget panics on 10gbps cabling

Maciej Żenczykowski <maze@google.com>
    usb: fix various gadgets null ptr deref on 10gbps cabling.

Linyu Yuan <linyyuan@codeaurora.com>
    usb: gadget: eem: fix wrong eem header operation

Johan Hovold <johan@kernel.org>
    USB: serial: quatech2: fix control-request directions

Alexandre GRIVEAUX <agriveaux@deutnet.info>
    USB: serial: omninet: add device id for Zyxel Omni 56K Plus

George McCollister <george.mccollister@gmail.com>
    USB: serial: ftdi_sio: add NovaTech OrionMX product ID

Marian-Cristian Rotariu <marian.c.rotariu@gmail.com>
    usb: dwc3: ep0: fix NULL pointer exception

Maciej Żenczykowski <maze@google.com>
    USB: f_ncm: ncm_bitrate (speed) is unsigned

Alexander Kuznetsov <wwfq@yandex-team.ru>
    cgroup1: don't allow '\n' in renaming

Ritesh Harjani <riteshh@linux.ibm.com>
    btrfs: return value from btrfs_mark_extent_written() in case of error

Paolo Bonzini <pbonzini@redhat.com>
    kvm: avoid speculation-based attacks from out-of-range memslot accesses

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    drm: Lock pointer access in drm_master_release()

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: mpc: implement erratum A-004447 workaround

Chris Packham <chris.packham@alliedtelesis.co.nz>
    i2c: mpc: Make use of i2c_recover_bus()

Chris Packham <chris.packham@alliedtelesis.co.nz>
    powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P1010 i2c controllers

Chris Packham <chris.packham@alliedtelesis.co.nz>
    powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P2041 i2c controllers

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    bnx2x: Fix missing error code in bnx2x_iov_init_one()

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Fix kernel hang under FUNCTION_GRAPH_TRACER and PREEMPT_TRACER

Saubhik Mukherjee <saubhik.mukherjee@gmail.com>
    net: appletalk: cops: Fix data race in cops_probe1

Zong Li <zong.li@sifive.com>
    net: macb: ensure the device is available before accessing GEMGXL control registers

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: qla2xxx: Wait for stop_phase1 at WWN removal

Matt Wang <wwentao@vmware.com>
    scsi: vmw_pvscsi: Set correct residual data length

Zheyu Ma <zheyuma97@gmail.com>
    net/qla3xxx: fix schedule while atomic in ql_sem_spinlock

Sergey Senozhatsky <senozhatsky@chromium.org>
    wq: handle VM suspension in stall detection

Shakeel Butt <shakeelb@google.com>
    cgroup: disable controllers at parse time

Dan Carpenter <dan.carpenter@oracle.com>
    net: mdiobus: get rid of a BUG_ON()

Johannes Berg <johannes.berg@intel.com>
    netlink: disable IRQs for netlink_lock_table()

Johannes Berg <johannes.berg@intel.com>
    bonding: init notify_work earlier to avoid uninitialized use

Zheyu Ma <zheyuma97@gmail.com>
    isdn: mISDN: netjet: Fix crash in nj_probe:

Zou Wei <zou_wei@huawei.com>
    ASoC: sti-sas: add missing MODULE_DEVICE_TABLE

Jeimon <jjjinmeng.zhou@gmail.com>
    net/nfc/rawsock.c: fix a permission check bug

Kees Cook <keescook@chromium.org>
    proc: Track /proc/$pid/attr/ opener mm_struct


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/mips/lib/mips-atomic.c                       | 12 +--
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi       |  8 ++
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi       | 16 ++++
 drivers/gpu/drm/drm_auth.c                        |  3 +-
 drivers/i2c/busses/i2c-mpc.c                      | 95 ++++++++++++++++++++++-
 drivers/isdn/hardware/mISDN/netjet.c              |  1 -
 drivers/net/appletalk/cops.c                      |  4 +-
 drivers/net/bonding/bond_main.c                   |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |  4 +-
 drivers/net/ethernet/cadence/macb.c               |  3 +
 drivers/net/ethernet/qlogic/qla3xxx.c             |  2 +-
 drivers/net/phy/mdio_bus.c                        |  3 +-
 drivers/scsi/hosts.c                              | 25 +++---
 drivers/scsi/qla2xxx/qla_target.c                 |  2 +
 drivers/scsi/vmw_pvscsi.c                         |  8 +-
 drivers/usb/dwc3/ep0.c                            |  3 +
 drivers/usb/gadget/config.c                       |  8 ++
 drivers/usb/gadget/function/f_ecm.c               |  2 +-
 drivers/usb/gadget/function/f_eem.c               |  6 +-
 drivers/usb/gadget/function/f_loopback.c          |  2 +-
 drivers/usb/gadget/function/f_ncm.c               |  2 +-
 drivers/usb/gadget/function/f_printer.c           |  3 +-
 drivers/usb/gadget/function/f_rndis.c             |  2 +-
 drivers/usb/gadget/function/f_serial.c            |  2 +-
 drivers/usb/gadget/function/f_sourcesink.c        |  3 +-
 drivers/usb/gadget/function/f_subset.c            |  2 +-
 drivers/usb/gadget/function/f_tcm.c               |  3 +-
 drivers/usb/serial/ftdi_sio.c                     |  1 +
 drivers/usb/serial/ftdi_sio_ids.h                 |  1 +
 drivers/usb/serial/omninet.c                      |  2 +
 drivers/usb/serial/quatech2.c                     |  6 +-
 fs/btrfs/file.c                                   |  4 +-
 fs/nfs/client.c                                   |  2 +-
 fs/nfs/nfs4proc.c                                 |  8 ++
 fs/proc/base.c                                    |  9 ++-
 include/linux/kvm_host.h                          | 11 ++-
 kernel/cgroup.c                                   | 17 ++--
 kernel/events/core.c                              |  2 +
 kernel/trace/ftrace.c                             |  8 +-
 kernel/trace/trace.c                              |  2 +-
 kernel/workqueue.c                                | 12 ++-
 net/netlink/af_netlink.c                          |  6 +-
 net/nfc/rawsock.c                                 |  2 +-
 sound/soc/codecs/sti-sas.c                        |  1 +
 tools/perf/util/session.c                         |  1 +
 46 files changed, 260 insertions(+), 65 deletions(-)


