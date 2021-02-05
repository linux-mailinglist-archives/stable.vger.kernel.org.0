Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A281F311403
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhBEVzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233006AbhBEO7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:59:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28DC8650A9;
        Fri,  5 Feb 2021 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534458;
        bh=Vi/bexT9yrJVpP62Gb+W1C1AqSKUPbVPQzod7jPuTTA=;
        h=From:To:Cc:Subject:Date:From;
        b=XDON2EyAhgkG9uml5Qw4UXnSLEt30btF/eEWWxau6pg3+iqfM1cL5j+0EbLSGNR31
         TeyVKIllGkxmo702CW/a+vckBeZL/cGkrMXgwZ936zyNBSKuG8zbajpKGU4iDTmVV0
         Dr9oHtyiYbePDF0duHfp9sMCM2JFyPh3UUafziB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/17] 4.19.174-rc1 review
Date:   Fri,  5 Feb 2021 15:07:54 +0100
Message-Id: <20210205140649.825180779@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.174-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.174-rc1
X-KernelTest-Deadline: 2021-02-07T14:06+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.174 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.174-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.174-rc1

Peter Zijlstra <peterz@infradead.org>
    workqueue: Restrict affinity change to rescuer

Peter Zijlstra <peterz@infradead.org>
    kthread: Extract KTHREAD_IS_PER_CPU

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Don't fail on missing symbol table

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Only test lwm/stmw on big endian

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Set default timeout to avoid crash during migration

Felix Fietkau <nbd@nbd.name>
    mac80211: fix fast-rx encryption check

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

Christian Brauner <christian@brauner.io>
    sysctl: handle overflow in proc_get_long

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: thermal: Do not call acpi_thermal_check() directly

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: Ensure that CRQ entry read are correctly ordered

Pan Bian <bianpan2016@163.com>
    net: dsa: bcm_sf2: put device node before return


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/include/asm/msr.h                         |  4 +-
 drivers/acpi/thermal.c                             | 55 +++++++++++++++-------
 drivers/net/dsa/bcm_sf2.c                          |  8 +++-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  6 +++
 drivers/phy/motorola/phy-cpcap-usb.c               | 19 +++++---
 drivers/platform/x86/intel-vbtn.c                  |  6 +++
 drivers/platform/x86/touchscreen_dmi.c             | 18 +++++++
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  4 +-
 drivers/scsi/libfc/fc_exch.c                       | 16 ++++++-
 drivers/scsi/scsi_transport_srp.c                  |  9 +++-
 include/linux/kthread.h                            |  3 ++
 kernel/kthread.c                                   | 27 ++++++++++-
 kernel/smpboot.c                                   |  1 +
 kernel/sysctl.c                                    | 40 +++++++++++++++-
 kernel/workqueue.c                                 |  9 ++--
 net/core/gen_estimator.c                           | 11 +++--
 net/mac80211/rx.c                                  |  2 +
 tools/objtool/elf.c                                |  7 ++-
 .../powerpc/alignment/alignment_handler.c          |  5 +-
 20 files changed, 206 insertions(+), 48 deletions(-)


