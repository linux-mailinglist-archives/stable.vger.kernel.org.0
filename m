Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D3E3739F8
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhEEMGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhEEMGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3EA761154;
        Wed,  5 May 2021 12:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216336;
        bh=DCRVEipV4htkfXERlLw5ak61oGTjOfJrVeTpLoSsH/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=0CyTdbihStL2/n1BfqDQl105DTLjANwzAteSvMOibxUicJIhJmd3S89ChrapLfSkx
         XsTHGsY4O+q2JL7FnFo+nN0tPQJQpM3DYzWO9kqMa/D/g3TMDLGlqu1heeEr/9UhD6
         +cnkC6eGhKNemxtVpIER3Gl5Lw3gqI6qOmjZTDZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/15] 4.19.190-rc1 review
Date:   Wed,  5 May 2021 14:05:05 +0200
Message-Id: <20210505120503.781531508@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.190-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.190-rc1
X-KernelTest-Deadline: 2021-05-07T12:05+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.190 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 07 May 2021 12:04:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.190-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.190-rc1

Miklos Szeredi <mszeredi@redhat.com>
    ovl: allow upperdir inside lowerdir

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

Jiri Kosina <jkosina@suse.cz>
    iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix masking negation logic upon negative dst register

Romain Naour <romain.naour@gmail.com>
    mips: Do not include hi and lo in clobber list for R6

Jiri Kosina <jkosina@suse.cz>
    iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()

Phillip Potter <phil@philpotter.co.uk>
    net: usb: ax88179_178a: initialize local variables before use

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: tables: x86: Reserve memory occupied by ACPI tables

Gao Xiang <hsiangkao@redhat.com>
    erofs: fix extended inode could cross boundary


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/mips/vdso/gettimeofday.c                     |  14 ++-
 arch/x86/kernel/acpi/boot.c                       |  25 ++--
 arch/x86/kernel/setup.c                           |   7 +-
 drivers/acpi/tables.c                             |  42 ++++++-
 drivers/net/usb/ax88179_178a.c                    |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |   7 +-
 drivers/platform/x86/thinkpad_acpi.c              |  31 +++--
 drivers/staging/erofs/inode.c                     | 135 ++++++++++++++--------
 drivers/usb/core/quirks.c                         |   4 +
 fs/overlayfs/super.c                              |  12 +-
 include/linux/acpi.h                              |   9 +-
 kernel/bpf/verifier.c                             |  12 +-
 sound/soc/codecs/ak4458.c                         |   1 +
 sound/soc/codecs/ak5558.c                         |   1 +
 sound/usb/quirks-table.h                          |  10 ++
 17 files changed, 224 insertions(+), 101 deletions(-)


