Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B942C9A28
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbgLAIzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:55:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387526AbgLAIzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:55:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E54922249;
        Tue,  1 Dec 2020 08:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812880;
        bh=mZob79UGActsfw4qwGSAo7t6H/Su6wnaETRC+gJClEw=;
        h=From:To:Cc:Subject:Date:From;
        b=UEdiqKyo3dJk0J2enT6iengV3R11cAauo9KHdM99FFaXWZ2wHMGgHW0uF2dpY3CWi
         i5LEyVQAIxhk0YL5c+Z0cG9VDbF+aoRXsGAbQmeuKTn38kSy7t3JYA9FXJibsrQxUo
         RuOLFEY+jyTsQ1O8GYv/LeBkvtrkOlpDtFhIfC4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.4 00/24] 4.4.247-rc1 review
Date:   Tue,  1 Dec 2020 09:53:06 +0100
Message-Id: <20201201084637.754785180@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.247-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.247-rc1
X-KernelTest-Deadline: 2020-12-03T08:46+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.247 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.247-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.247-rc1

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lockdep splat when reading qgroup config on mount

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix regression in Hercules audio card

Johan Hovold <johan@kernel.org>
    USB: core: add endpoint-blacklist quirk

Anand K Mistry <amistry@google.com>
    x86/speculation: Fix prctl() when spectre_v2_user={seccomp,prctl},ibpb

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Change %pK for __user pointers to %px

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to die_entrypc() returns error correctly

Ard Biesheuvel <ardb@kernel.org>
    efivarfs: revert "fix memory leak in efivarfs_create()"

Krzysztof Kozlowski <krzk@kernel.org>
    nfc: s3fwrn5: use signed integer for parsing GPIO numbers

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    IB/mthca: fix return value of error branch in mthca_init_cq()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Release PCI regions when DMA mask setup fails during probe.

Dexuan Cui <decui@microsoft.com>
    video: hyperv_fb: Fix the cache type when mapping the VRAM

Zhang Changzhong <zhangchangzhong@huawei.com>
    bnxt_en: fix error return code in bnxt_init_board()

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix race between shutdown and runtime resume flow

Mike Christie <michael.christie@oracle.com>
    scsi: target: iscsi: Fix cmd abort fabric stop race

Lee Duncan <lduncan@suse.com>
    scsi: libiscsi: Fix NOP race condition

Sugar Zhang <sugar.zhang@rock-chips.com>
    dmaengine: pl330: _prep_dma_memcpy: Fix wrong burst size

Jens Axboe <axboe@kernel.dk>
    proc: don't allow async path resolution of /proc/self components

Brian Masney <bmasney@redhat.com>
    x86/xen: don't unbind uninitialized lock_kicker_irq

Pablo Ceballos <pceballos@google.com>
    HID: hid-sensor-hub: Fix issue with devices with no report ID

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - allow insmod to succeed on devices without an i8042 controller

Frank Yang <puilp0502@gmail.com>
    HID: cypress: Support Varmilo Keyboards' media hotkeys

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Fix split-irqchip vs interrupt injection window request

Qu Wenruo <wqu@suse.com>
    btrfs: inode: Verify inode mode to avoid NULL pointer dereference

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Enhance chunk checker to validate chunk profile


-------------

Diffstat:

 Makefile                                  |  4 +--
 arch/x86/include/asm/kvm_host.h           |  1 +
 arch/x86/kernel/cpu/bugs.c                |  4 +--
 arch/x86/kvm/irq.c                        |  2 +-
 arch/x86/kvm/x86.c                        | 18 +++++++------
 arch/x86/xen/spinlock.c                   | 12 ++++++++-
 drivers/dma/pl330.c                       |  2 +-
 drivers/hid/hid-cypress.c                 | 44 +++++++++++++++++++++++++++----
 drivers/hid/hid-ids.h                     |  2 ++
 drivers/hid/hid-sensor-hub.c              |  3 ++-
 drivers/infiniband/hw/mthca/mthca_cq.c    | 10 ++++---
 drivers/input/serio/i8042.c               | 12 ++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |  3 ++-
 drivers/nfc/s3fwrn5/i2c.c                 |  4 +--
 drivers/scsi/libiscsi.c                   | 23 ++++++++++------
 drivers/scsi/ufs/ufshcd.c                 |  6 +----
 drivers/target/iscsi/iscsi_target.c       | 17 +++++++++---
 drivers/usb/core/config.c                 | 11 ++++++++
 drivers/usb/core/devio.c                  |  4 +--
 drivers/usb/core/quirks.c                 | 38 ++++++++++++++++++++++++++
 drivers/usb/core/usb.h                    |  3 +++
 drivers/video/fbdev/hyperv_fb.c           |  7 ++++-
 fs/btrfs/inode.c                          | 41 ++++++++++++++++++++++------
 fs/btrfs/qgroup.c                         |  2 +-
 fs/btrfs/tests/inode-tests.c              |  1 +
 fs/btrfs/volumes.c                        |  7 +++++
 fs/efivarfs/inode.c                       |  2 ++
 fs/efivarfs/super.c                       |  1 -
 fs/proc/self.c                            |  7 +++++
 include/linux/usb/quirks.h                |  3 +++
 include/scsi/libiscsi.h                   |  3 +++
 tools/perf/util/dwarf-aux.c               |  8 ++++++
 32 files changed, 246 insertions(+), 59 deletions(-)


