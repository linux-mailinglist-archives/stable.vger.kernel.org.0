Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BED3EB8CF
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241821AbhHMPQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241915AbhHMPOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1F536112E;
        Fri, 13 Aug 2021 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867660;
        bh=xZihEZsLc4INQ12kabEFEMJKBu4OArueTDSDf4TvJJg=;
        h=From:To:Cc:Subject:Date:From;
        b=MD8unSo6UQQm4qjqWFBTFVddSVN9u60yzDM6rbJTk+i6PaFuwSM+kaY+0bkB+boB7
         n7L7tLbwl84Sg9XUGHZOLiswJZXyC3oxUuw5GL9Bye4xZUPS6lnS4pyy+V38MdfnL2
         9tOXMdVXHcgpw4P8SrPOT8Wu+o7lM3U+3Dmzcc4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/19] 5.10.59-rc1 review
Date:   Fri, 13 Aug 2021 17:07:17 +0200
Message-Id: <20210813150522.623322501@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.59-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.59-rc1
X-KernelTest-Deadline: 2021-08-15T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.59 release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.59-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.59-rc1

YueHaibing <yuehaibing@huawei.com>
    net: xilinx_emaclite: Do not print real IOMEM pointer

Miklos Szeredi <mszeredi@redhat.com>
    ovl: prevent private clone if bind mount is not allowed

Pali Rohár <pali@kernel.org>
    ppp: Fix generating ppp unit id when ifname is not specified

Luke D Jones <luke@ljones.dev>
    ALSA: hda: Add quirk for ASUS Flow x13

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 650 G8 Notebook PC

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix mmap breakage without explicit buffer setup

Longfang Liu <liulongfang@huawei.com>
    USB:ehci:fix Kunpeng920 ehci hardware problem

Hans de Goede <hdegoede@redhat.com>
    vboxsf: Make vboxsf_dir_create() return the handle for the created file

Hans de Goede <hdegoede@redhat.com>
    vboxsf: Honor excl flag to the dir-inode create op

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: beacon: Fix USB ref clock references

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: beacon: Fix USB extal reference

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: rzg2: Add usb2_clksel to RZ/G2 M/N/H

Mike Rapoport <rppt@kernel.org>
    mm: make zone_to_nid() and zone_set_nid() available for DISCONTIGMEM

Reinette Chatre <reinette.chatre@intel.com>
    Revert "selftests/resctrl: Use resctrl/info for feature detection"

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add lockdown check for probe_write_user helper

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add _kernel suffix to internal lockdown_bpf_read

Allen Pais <apais@linux.microsoft.com>
    firmware: tee_bnxt: Release TEE shm, session, and context during kexec

Sumit Garg <sumit.garg@linaro.org>
    tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Fix off-by-one indexing when nullifying last used SEV VMCB


-------------

Diffstat:

 Makefile                                           |  4 +-
 .../boot/dts/renesas/beacon-renesom-baseboard.dtsi |  4 +-
 .../arm64/boot/dts/renesas/beacon-renesom-som.dtsi |  6 ++-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi          | 15 +++++++
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi          | 15 +++++++
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi          | 15 +++++++
 arch/x86/kvm/svm/sev.c                             |  2 +-
 drivers/firmware/broadcom/tee_bnxt_fw.c            | 14 ++++--
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  5 +--
 drivers/net/ppp/ppp_generic.c                      | 19 ++++++--
 drivers/tee/optee/call.c                           |  2 +-
 drivers/tee/optee/core.c                           |  3 +-
 drivers/tee/optee/rpc.c                            |  5 ++-
 drivers/tee/optee/shm_pool.c                       |  8 +++-
 drivers/tee/tee_shm.c                              |  4 +-
 drivers/usb/host/ehci-pci.c                        |  3 ++
 fs/namespace.c                                     | 42 +++++++++++------
 fs/vboxsf/dir.c                                    | 28 +++++++-----
 include/linux/mmzone.h                             |  4 +-
 include/linux/security.h                           |  3 +-
 include/linux/tee_drv.h                            |  1 +
 kernel/bpf/helpers.c                               |  4 +-
 kernel/trace/bpf_trace.c                           | 13 +++---
 security/security.c                                |  3 +-
 sound/core/pcm_native.c                            |  5 ++-
 sound/pci/hda/patch_realtek.c                      |  2 +
 tools/testing/selftests/resctrl/resctrl.h          |  6 +--
 tools/testing/selftests/resctrl/resctrlfs.c        | 52 +++++-----------------
 28 files changed, 178 insertions(+), 109 deletions(-)


