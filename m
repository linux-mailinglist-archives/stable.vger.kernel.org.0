Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C30E393232
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhE0PQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237111AbhE0PP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:15:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E25F60724;
        Thu, 27 May 2021 15:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128433;
        bh=k176EYvGuZZv7RL2ar8QCQzXeJf1cEk3yRCNfUQ76lo=;
        h=From:To:Cc:Subject:Date:From;
        b=qqGF0cSxPduNGBsgeogSgPx5yqTFsy0Hl8X4othjrGa3/BCo64oHPg6TOD2GwhtaY
         5Ofp9Kh9+s4/wpka+nQhXB/7MpkY/PCUA36usrA5OcPxQ22AvQMb17SX3C+cf99oUF
         VrVCJutpKfqIk/0sl5VbDiGeDk9P49GKhJy+Ig78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.12 0/7] 5.12.8-rc1 review
Date:   Thu, 27 May 2021 17:13:01 +0200
Message-Id: <20210527151139.241267495@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.8-rc1
X-KernelTest-Deadline: 2021-05-29T15:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.12.8 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.12.8-rc1

Dongliang Mu <mudongliangabcd@gmail.com>
    NFC: nci: fix memory leak in nci_allocate_device

Wanpeng Li <wanpengli@tencent.com>
    KVM: x86: Defer vtime accounting 'til after IRQ handling

Wanpeng Li <wanpengli@tencent.com>
    context_tracking: Move guest exit vtime accounting to separate helpers

Wanpeng Li <wanpengli@tencent.com>
    context_tracking: Move guest exit context tracking to separate helpers

Daniel Borkmann <daniel@iogearbox.net>
    bpf: No need to simulate speculative domain for immediates

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix mask direction swap upon off reg sign change

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Wrap aux data inside bpf_sanitize_info container


-------------

Diffstat:

 Makefile                         |  4 ++--
 arch/x86/kvm/svm/svm.c           |  6 +++---
 arch/x86/kvm/vmx/vmx.c           |  6 +++---
 arch/x86/kvm/x86.c               |  9 ++++++++
 include/linux/context_tracking.h | 25 ++++++++++++++++++----
 include/net/nfc/nci_core.h       |  1 +
 kernel/bpf/verifier.c            | 46 ++++++++++++++++++++++++----------------
 net/nfc/nci/core.c               |  1 +
 net/nfc/nci/hci.c                |  5 +++++
 9 files changed, 73 insertions(+), 30 deletions(-)


