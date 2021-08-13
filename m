Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB64D3EB8F0
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241583AbhHMPS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242064AbhHMPQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D901A6112D;
        Fri, 13 Aug 2021 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867714;
        bh=S3nZL53rg/qzMsCOY4Nn54g2ZVjZTKaAsAsl+QKMN6U=;
        h=From:To:Cc:Subject:Date:From;
        b=0aq+IwngPt2kok8Rbv1Xt8fy207+b8xbQaxl5FU4Uj2DnTGnvQvSBi97uyvjSqYlT
         d+LBlUHN1liw0n89DnXGmQQFGquDrAlxgq1d/38zddNK08Tp106I8zjVxkVYtbYDkL
         oIwbvhZVBNomG6MLM5Quw2E3TaScls66jNN59xM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 0/8] 5.13.11-rc1 review
Date:   Fri, 13 Aug 2021 17:07:37 +0200
Message-Id: <20210813150520.090373732@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.11-rc1
X-KernelTest-Deadline: 2021-08-15T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.11 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.11-rc1

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

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add lockdown check for probe_write_user helper

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add _kernel suffix to internal lockdown_bpf_read

Allen Pais <apais@linux.microsoft.com>
    firmware: tee_bnxt: Release TEE shm, session, and context during kexec


-------------

Diffstat:

 Makefile                                |  4 ++--
 drivers/firmware/broadcom/tee_bnxt_fw.c | 14 ++++++++---
 drivers/net/ppp/ppp_generic.c           | 19 +++++++++++----
 fs/namespace.c                          | 42 ++++++++++++++++++++++-----------
 include/linux/security.h                |  3 ++-
 kernel/bpf/helpers.c                    |  4 ++--
 kernel/trace/bpf_trace.c                | 13 +++++-----
 security/security.c                     |  3 ++-
 sound/core/pcm_native.c                 |  5 +++-
 sound/pci/hda/patch_realtek.c           |  2 ++
 10 files changed, 75 insertions(+), 34 deletions(-)


