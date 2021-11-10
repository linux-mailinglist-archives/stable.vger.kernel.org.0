Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F6344C84C
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhKJTAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:57162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234464AbhKJS6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:58:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B163E61213;
        Wed, 10 Nov 2021 18:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570269;
        bh=Pscvcjb96NM4zvDaxzISIdeTzUHjlNGHXrJhBoXozBs=;
        h=From:To:Cc:Subject:Date:From;
        b=wEKgluUhfzfQhLZ62bffknlaMn22x5AlknHtwRH8Sm3v9fmehTkv+iwiNnbfYDC/Q
         +x3ehQYAjLJQy9nAF2ggrIOBElO2X2N05fHIyN1On9TRUKQSYzZ5W/VfyfV3KrJVYR
         3/0VUT82cQWDlZa1Pbx1v4VX+u4g+qRWBjZeVXJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 00/26] 5.15.2-rc1 review
Date:   Wed, 10 Nov 2021 19:43:59 +0100
Message-Id: <20211110182003.700594531@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.2-rc1
X-KernelTest-Deadline: 2021-11-12T18:20+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.2 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.2-rc1

Johan Hovold <johan@kernel.org>
    rsi: fix control-message timeout

Gustavo A. R. Silva <gustavoars@kernel.org>
    media: staging/intel-ipu3: css: Fix wrong size comparison imgu_css_fw_init

Martin Kaiser <martin@kaiser.cx>
    staging: r8188eu: fix memleak in rtw_wx_set_enc_ext

Johan Hovold <johan@kernel.org>
    staging: rtl8192u: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    staging: r8712u: fix control-message timeout

Johan Hovold <johan@kernel.org>
    comedi: vmk80xx: fix bulk and interrupt message timeouts

Johan Hovold <johan@kernel.org>
    comedi: vmk80xx: fix bulk-buffer overflow

Johan Hovold <johan@kernel.org>
    comedi: vmk80xx: fix transfer-buffer overflows

Johan Hovold <johan@kernel.org>
    comedi: ni_usb6501: fix NULL-deref in command paths

Johan Hovold <johan@kernel.org>
    comedi: dt9812: fix DMA buffers on stack

Jan Kara <jack@suse.cz>
    isofs: Fix out of bound access for corrupted isofs image

Pavel Skripkin <paskripkin@gmail.com>
    staging: rtl8712: fix use-after-free in rtl8712_dl_fw

Linus Torvalds <torvalds@linux-foundation.org>
    btrfs: fix lzo_decompress_bio() kmap leakage

Marco Elver <elver@google.com>
    kfence: default to dynamic branch instead of static keys mode

Marco Elver <elver@google.com>
    kfence: always use static branches to guard kfence_alloc()

Todd Kjos <tkjos@google.com>
    binder: don't detect sender/target during buffer cleanup

Todd Kjos <tkjos@google.com>
    binder: use cred instead of task for getsecid

Todd Kjos <tkjos@google.com>
    binder: use cred instead of task for selinux checks

Todd Kjos <tkjos@google.com>
    binder: use euid from cred instead of using task

Kees Cook <keescook@chromium.org>
    Revert "proc/wchan: use printk format instead of lookup_symbol_name()"

James Buren <braewoods+lkml@braewoods.net>
    usb-storage: Add compatibility quirk flags for iODD 2531/2541

Viraj Shah <viraj.shah@linutronix.de>
    usb: musb: Balance list entry in musb_gadget_queue

Geert Uytterhoeven <geert@linux-m68k.org>
    usb: gadget: Mark USB_FSL_QE broken on 64-bit

Neal Liu <neal_liu@aspeedtech.com>
    usb: ehci: handshake CMD_RUN instead of STS_HALT

Juergen Gross <jgross@suse.com>
    Revert "x86/kvm: fix vcpu-id indexed array sizes"

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: avoid warning with -Wbitwise-instead-of-logical


-------------

Diffstat:

 Documentation/dev-tools/kfence.rst           |  12 ++-
 Makefile                                     |   4 +-
 arch/x86/kvm/ioapic.c                        |   2 +-
 arch/x86/kvm/ioapic.h                        |   4 +-
 arch/x86/kvm/mmu/spte.h                      |   7 +-
 drivers/android/binder.c                     |  41 ++++------
 drivers/android/binder_internal.h            |   4 +
 drivers/comedi/drivers/dt9812.c              | 115 ++++++++++++++++++++-------
 drivers/comedi/drivers/ni_usb6501.c          |  10 +++
 drivers/comedi/drivers/vmk80xx.c             |  28 ++++---
 drivers/net/wireless/rsi/rsi_91x_usb.c       |   2 +-
 drivers/staging/media/ipu3/ipu3-css-fw.c     |   7 +-
 drivers/staging/media/ipu3/ipu3-css-fw.h     |   2 +-
 drivers/staging/r8188eu/os_dep/ioctl_linux.c |   5 +-
 drivers/staging/rtl8192u/r8192U_core.c       |  18 ++---
 drivers/staging/rtl8712/usb_intf.c           |   4 +-
 drivers/staging/rtl8712/usb_ops_linux.c      |   2 +-
 drivers/usb/gadget/udc/Kconfig               |   1 +
 drivers/usb/host/ehci-hcd.c                  |  11 ++-
 drivers/usb/host/ehci-platform.c             |   6 ++
 drivers/usb/host/ehci.h                      |   1 +
 drivers/usb/musb/musb_gadget.c               |   4 +-
 drivers/usb/storage/unusual_devs.h           |  10 +++
 fs/btrfs/lzo.c                               |   3 +-
 fs/isofs/inode.c                             |   2 +
 fs/proc/base.c                               |  19 +++--
 include/linux/kfence.h                       |  21 ++---
 include/linux/lsm_hook_defs.h                |  14 ++--
 include/linux/lsm_hooks.h                    |  14 ++--
 include/linux/security.h                     |  33 ++++----
 lib/Kconfig.kfence                           |  26 +++---
 mm/kfence/core.c                             |  16 ++--
 security/security.c                          |  14 ++--
 security/selinux/hooks.c                     |  48 +++--------
 34 files changed, 298 insertions(+), 212 deletions(-)


