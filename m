Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958C5359A68
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhDIJ63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233771AbhDIJ5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24537611BE;
        Fri,  9 Apr 2021 09:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962242;
        bh=ZTGjvPpX4x6XCHR41mBzBpjePuAtjMXdtn8AuUA4s7w=;
        h=From:To:Cc:Subject:Date:From;
        b=prKSx7IX8MT7jSsFXRNWXKe2G+R3u7cOU92p4FwrzHQOP5/nP435uPLMKf5++EOqg
         Y3jVsreq6nEAiF3mWzvQcmR56vW08jhswCoWqvZcZ07mH74TjDiR82Xlbp4sVc6R6G
         QwOAZE/kTea9KnQhWJVRuwb1zIVv5HCDRgDbQGEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/18] 4.19.186-rc1 review
Date:   Fri,  9 Apr 2021 11:53:28 +0200
Message-Id: <20210409095301.525783608@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.186-rc1
X-KernelTest-Deadline: 2021-04-11T09:53+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.186 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.186-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.186-rc1

Masahiro Yamada <masahiroy@kernel.org>
    init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

Heiko Carstens <hca@linux.ibm.com>
    init/Kconfig: make COMPILE_TEST depend on !S390

Piotr Krysiuk <piotras@gmail.com>
    bpf, x86: Validate computation of branch displacements for x86-32

Piotr Krysiuk <piotras@gmail.com>
    bpf, x86: Validate computation of branch displacements for x86-64

Vincent Whitchurch <vincent.whitchurch@axis.com>
    cifs: Silently ignore unknown oplock break handle

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: revalidate mapping when we open files for SMB1 POSIX

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix format strings for err_inject

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: mca: allocate early mca with GFP_ATOMIC

Martin Wilck <mwilck@suse.com>
    scsi: target: pscsi: Clean up after failure in pscsi_map_sg()

Arnd Bergmann <arnd@arndb.de>
    x86/build: Turn off -fcf-protection for realmode targets

Esteve Varela Colominas <esteve.varela@gmail.com>
    platform/x86: thinkpad_acpi: Allow the FnLock LED to change state

Rob Clark <robdclark@chromium.org>
    drm/msm: Ratelimit invalid-fence message

Karthikeyan Kathirvel <kathirve@codeaurora.org>
    mac80211: choose first enabled channel for monitor

Tong Zhang <ztong0001@gmail.com>
    mISDN: fix crash in fritzpci

Pavel Andrianov <andrianov@ispras.ru>
    net: pxa168_eth: Fix a potential data race in pxa168_eth_remove

Alban Bedel <albeu@free.fr>
    platform/x86: intel-hid: Support Lenovo ThinkPad X1 Tablet Gen 2

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix warning on unbind if reset is not deasserted

Mans Rullgard <mans@mansr.com>
    ARM: dts: am33xx: add aliases for mmc interfaces


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/arm/boot/dts/am33xx.dtsi             |  3 +++
 arch/ia64/kernel/err_inject.c             | 22 +++++++++++-----------
 arch/ia64/kernel/mca.c                    |  2 +-
 arch/x86/Makefile                         |  2 +-
 arch/x86/net/bpf_jit_comp.c               | 11 ++++++++++-
 arch/x86/net/bpf_jit_comp32.c             | 11 ++++++++++-
 drivers/bus/ti-sysc.c                     |  4 +++-
 drivers/gpu/drm/msm/msm_fence.c           |  2 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c   |  2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c |  2 +-
 drivers/platform/x86/intel-hid.c          |  7 +++++++
 drivers/platform/x86/thinkpad_acpi.c      |  8 +++++++-
 drivers/target/target_core_pscsi.c        |  8 ++++++++
 fs/cifs/file.c                            |  1 +
 fs/cifs/smb2misc.c                        |  4 ++--
 init/Kconfig                              |  3 +--
 net/mac80211/main.c                       | 13 ++++++++++++-
 18 files changed, 82 insertions(+), 27 deletions(-)


