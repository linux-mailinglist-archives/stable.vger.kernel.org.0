Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8150373A7D
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhEEMK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233747AbhEEMJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4497E613E4;
        Wed,  5 May 2021 12:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216471;
        bh=jdbcuQdEkWUkf5XKN5t7eGU+1kqDpJkJDfaFcegWBqg=;
        h=From:To:Cc:Subject:Date:From;
        b=a4Wf7C9aW7L56Cd7X9+XtNjQs/YONGXtFKrGMMUMWVxiLkwCIPE6cOFd8MPUCb1EQ
         MSuTmpcfMtmlcXSfMJ38p99YFTXZtUk/a6ecl9CI1wxr1oqwgjT9BK2qvw7bJTJ3xm
         U7EmZE70nPvp7xCFxe7RV4VsneiZrQb4vEhT09vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.12 00/17] 5.12.2-rc1 review
Date:   Wed,  5 May 2021 14:05:55 +0200
Message-Id: <20210505112324.956720416@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.2-rc1
X-KernelTest-Deadline: 2021-05-07T11:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.12.2 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.12.2-rc1

Ondrej Mosnacek <omosnace@redhat.com>
    perf/core: Fix unconditional security_locked_down() call

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
    ALSA: usb-audio: Fix implicit sync clearance at stopping stream

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX

Miklos Szeredi <mszeredi@redhat.com>
    ovl: allow upperdir inside lowerdir

Mickaël Salaün <mic@linux.microsoft.com>
    ovl: fix leaked dentry

Bjorn Andersson <bjorn.andersson@linaro.org>
    net: qrtr: Avoid potential use after free in MHI send

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage of uninitialized bpf stack under speculation

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix masking negation logic upon negative dst register

Imre Deak <imre.deak@intel.com>
    drm/i915: Disable runtime power management during shutdown

Phillip Potter <phil@philpotter.co.uk>
    net: usb: ax88179_178a: initialize local variables before use

Jonathon Reinhart <jonathon.reinhart@gmail.com>
    netfilter: conntrack: Make global sysctls readonly in non-init netns

Romain Naour <romain.naour@gmail.com>
    mips: Do not include hi and lo in clobber list for R6


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/mips/include/asm/vdso/gettimeofday.h | 26 +++++++++++++++++++-----
 drivers/gpu/drm/i915/i915_drv.c           | 10 ++++++++++
 drivers/net/usb/ax88179_178a.c            |  6 ++++--
 drivers/platform/x86/thinkpad_acpi.c      | 31 ++++++++++++++++++++---------
 drivers/usb/core/quirks.c                 |  4 ++++
 fs/overlayfs/namei.c                      |  1 +
 fs/overlayfs/super.c                      | 12 ++++++-----
 include/linux/bpf_verifier.h              |  5 +++--
 kernel/bpf/verifier.c                     | 33 +++++++++++++++++--------------
 kernel/events/core.c                      | 12 +++++------
 net/netfilter/nf_conntrack_standalone.c   | 10 ++--------
 net/qrtr/mhi.c                            |  8 +++++---
 sound/soc/codecs/ak4458.c                 |  1 +
 sound/soc/codecs/ak5558.c                 |  1 +
 sound/usb/endpoint.c                      |  8 ++++----
 sound/usb/quirks-table.h                  | 10 ++++++++++
 17 files changed, 121 insertions(+), 61 deletions(-)


