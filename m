Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE827310DFF
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 17:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhBEO7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 09:59:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232948AbhBEO5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2981965060;
        Fri,  5 Feb 2021 14:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534360;
        bh=AFRu770qxT4dJB284AhaaMOLr7QZypYgV+N4yR/3l0E=;
        h=From:To:Cc:Subject:Date:From;
        b=k55Is1pS1Rjn9IfhzxeZDy/yuwQQSct7yBWrITnCijxJtSKXTooAR9v1YQwkhyd4P
         oCMx6DG+JDTVrL1QU5yNyUIFSARsbNrEE2hQQSosl+77L1vN0yPLigQnX1RlIBdwcT
         83bTDQpzNV5Bx486/CeHt/pK0nc3mQMJvaKuhUvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/32] 5.4.96-rc1 review
Date:   Fri,  5 Feb 2021 15:07:15 +0100
Message-Id: <20210205140652.348864025@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.96-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.96-rc1
X-KernelTest-Deadline: 2021-02-07T14:06+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.96 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.96-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.96-rc1

Peter Zijlstra <peterz@infradead.org>
    workqueue: Restrict affinity change to rescuer

Peter Zijlstra <peterz@infradead.org>
    kthread: Extract KTHREAD_IS_PER_CPU

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Don't fail on missing symbol table

Bing Guo <bing.guo@amd.com>
    drm/amd/display: Change function decide_dp_link_settings to avoid infinite looping

Jake Wang <haonan.wang2@amd.com>
    drm/amd/display: Update dram_clock_change_latency for DCN2.1

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Only test lwm/stmw on big endian

Revanth Rajashekar <revanth.rajashekar@intel.com>
    nvme: check the PRINFO bit before deciding the host buffer length

lianzhi chang <changlianzhi@uniontech.com>
    udf: fix the problem that the disc content is not displayed

Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>
    ALSA: hda: Add Cometlake-R PCI ID

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Set default timeout to avoid crash during migration

Felix Fietkau <nbd@nbd.name>
    mac80211: fix fast-rx encryption check

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ASoC: SOF: Intel: hda: Resume codec to do jack detection

Dinghao Liu <dinghao.liu@zju.edu.cn>
    scsi: fnic: Fix memleak in vnic_dev_init_devcmd2

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Avoid invoking response handler twice if ep is already completed

Martin Wilck <mwilck@suse.com>
    scsi: scsi_transport_srp: Don't block target in failfast state

Peter Zijlstra <peterz@infradead.org>
    x86: __always_inline __{rd,wr}msr()

Arnold Gozum <arngozum@gmail.com>
    platform/x86: intel-vbtn: Support for tablet mode on Dell Inspiron 7352

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add swap-x-y quirk for Goodix touchscreen on Estar Beauty HD tablet

Tony Lindgren <tony@atomide.com>
    phy: cpcap-usb: Fix warning for missing regulator_disable

Eric Dumazet <edumazet@google.com>
    net_sched: gen_estimator: support large ewma log

ethanwu <ethanwu@synology.com>
    btrfs: backref, use correct count to resolve normal data refs

ethanwu <ethanwu@synology.com>
    btrfs: backref, only search backref entries from leaves of the same root

ethanwu <ethanwu@synology.com>
    btrfs: backref, don't add refs from shared block when resolving normal backref

ethanwu <ethanwu@synology.com>
    btrfs: backref, only collect file extent items matching backref offset

Enke Chen <enchen@paloaltonetworks.com>
    tcp: make TCP_USER_TIMEOUT accurate for zero window probes

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Do not pass tagged addresses to __is_lm_address()

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: Fix kernel address detection of __is_lm_address()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: thermal: Do not call acpi_thermal_check() directly

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT""

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: Ensure that CRQ entry read are correctly ordered

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP

Pan Bian <bianpan2016@163.com>
    net: dsa: bcm_sf2: put device node before return


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/memory.h                    |  10 +-
 arch/arm64/mm/physaddr.c                           |   2 +-
 arch/x86/include/asm/msr.h                         |   4 +-
 block/blk-core.c                                   |  11 +-
 drivers/acpi/thermal.c                             |  55 +++++---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   3 +
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   2 +-
 drivers/net/dsa/bcm_sf2.c                          |   8 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   6 +
 drivers/nvme/host/core.c                           |  17 ++-
 drivers/phy/motorola/phy-cpcap-usb.c               |  19 ++-
 drivers/platform/x86/intel-vbtn.c                  |   6 +
 drivers/platform/x86/touchscreen_dmi.c             |  18 +++
 drivers/scsi/fnic/vnic_dev.c                       |   8 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   4 +-
 drivers/scsi/libfc/fc_exch.c                       |  16 ++-
 drivers/scsi/scsi_transport_srp.c                  |   9 +-
 fs/btrfs/backref.c                                 | 157 +++++++++++++--------
 fs/udf/super.c                                     |   7 +-
 include/linux/kthread.h                            |   3 +
 include/net/tcp.h                                  |   1 +
 kernel/kthread.c                                   |  27 +++-
 kernel/smpboot.c                                   |   1 +
 kernel/workqueue.c                                 |   9 +-
 net/core/gen_estimator.c                           |  11 +-
 net/ipv4/tcp_input.c                               |   1 +
 net/ipv4/tcp_output.c                              |   2 +
 net/ipv4/tcp_timer.c                               |  18 +++
 net/mac80211/rx.c                                  |   2 +
 net/switchdev/switchdev.c                          |  23 +--
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/soc/sof/intel/hda-codec.c                    |   3 +-
 tools/objtool/elf.c                                |   7 +-
 .../powerpc/alignment/alignment_handler.c          |   5 +-
 35 files changed, 348 insertions(+), 134 deletions(-)


