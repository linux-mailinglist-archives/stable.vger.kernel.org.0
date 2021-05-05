Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1033739D1
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhEEMFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232999AbhEEMFh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:05:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED00561159;
        Wed,  5 May 2021 12:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216280;
        bh=V4adCSEBJ2BbOX8ELnNSDVCjXJYZ/Wuf9VTDZ81NRI4=;
        h=From:To:Cc:Subject:Date:From;
        b=i5akRNBrj2Y0SIonlwGnmwoD9786pYW1VDoTWTWMoWtoueh/0bStLLbhbdedP2ysc
         GkafhwDHsY49fVNVXIlVldjvp5rD/xqpac3dr5BhSUhQtedqgUTjJu1EoHEgrSA+l1
         n5xbbRO74yF5sdYiwkbFsgQVFEgxpkjkXnQ3R7XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/21] 5.4.117-rc1 review
Date:   Wed,  5 May 2021 14:04:14 +0200
Message-Id: <20210505112324.729798712@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.117-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.117-rc1
X-KernelTest-Deadline: 2021-05-07T11:23+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.117 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.117-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.117-rc1

Ondrej Mosnacek <omosnace@redhat.com>
    perf/core: Fix unconditional security_locked_down() call

Miklos Szeredi <mszeredi@redhat.com>
    ovl: allow upperdir inside lowerdir

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: ufs: Unlock on a couple error paths

Mark Pearson <markpearson@lenovo.com>
    platform/x86: thinkpad_acpi: Correct thermal sensor allocation

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: Add MODULE_DEVICE_TABLE

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak4458: Add MODULE_DEVICE_TABLE

Chris Chiu <chris.chiu@canonical.com>
    USB: Add reset-resume quirk for WD19's Realtek Hub

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX

Thomas Richter <tmricht@linux.ibm.com>
    perf ftrace: Fix access to pid in array when setting a pid filter

Zhen Lei <thunder.leizhen@huawei.com>
    perf data: Fix error return code in perf_data__create_dir()

Jiri Kosina <jkosina@suse.cz>
    iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()

Arnd Bergmann <arnd@arndb.de>
    avoid __memcat_p link failure

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage of uninitialized bpf stack under speculation

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix masking negation logic upon negative dst register

Jiri Kosina <jkosina@suse.cz>
    iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()

Nick Lowe <nick.lowe@gmail.com>
    igb: Enable RSS for Intel I211 Ethernet Controller

Phillip Potter <phil@philpotter.co.uk>
    net: usb: ax88179_178a: initialize local variables before use

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: tables: x86: Reserve memory occupied by ACPI tables

Romain Naour <romain.naour@gmail.com>
    mips: Do not include hi and lo in clobber list for R6


-------------

Diffstat:

 Makefile                                          |  4 +--
 arch/mips/include/asm/vdso/gettimeofday.h         | 26 +++++++++++---
 arch/x86/kernel/acpi/boot.c                       | 25 +++++++-------
 arch/x86/kernel/setup.c                           |  7 ++--
 drivers/acpi/tables.c                             | 42 +++++++++++++++++++++--
 drivers/net/ethernet/intel/igb/igb_main.c         |  3 +-
 drivers/net/usb/ax88179_178a.c                    |  4 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  7 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |  7 ++--
 drivers/platform/x86/thinkpad_acpi.c              | 31 ++++++++++++-----
 drivers/scsi/ufs/ufshcd.c                         | 14 +++++---
 drivers/usb/core/quirks.c                         |  4 +++
 fs/overlayfs/super.c                              | 12 ++++---
 include/linux/acpi.h                              |  9 ++++-
 include/linux/bpf_verifier.h                      |  5 +--
 kernel/bpf/verifier.c                             | 33 ++++++++++--------
 kernel/events/core.c                              | 12 +++----
 lib/Makefile                                      |  4 +--
 sound/soc/codecs/ak4458.c                         |  1 +
 sound/soc/codecs/ak5558.c                         |  1 +
 sound/usb/quirks-table.h                          | 10 ++++++
 tools/perf/builtin-ftrace.c                       |  2 +-
 tools/perf/util/data.c                            |  5 +--
 23 files changed, 183 insertions(+), 85 deletions(-)


