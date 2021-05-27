Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945733931F5
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbhE0POZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235201AbhE0POZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:14:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26B5E60724;
        Thu, 27 May 2021 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128371;
        bh=m4QWhkWkXV79NPaR6FSY6kADFmMWzVqlu01VmDwdiyk=;
        h=From:To:Cc:Subject:Date:From;
        b=LcEoWiOkQmsMYf/TrJEGLS7iNIQtDXWVMkXKzpGP82HctTjEWLwSWY6suuM/oiglp
         wiOKaaS14BKi87hHImJ8UGFN/DBwv3Jx1Ndl2uaXvQVAV6dM+MQL47SG5LQN3seOQ0
         TdeaFTa4l2OySAffztkr9qZvnRenY1ZArZQq5Yh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 0/7] 5.4.123-rc1 review
Date:   Thu, 27 May 2021 17:12:42 +0200
Message-Id: <20210527151139.224619013@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.123-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.123-rc1
X-KernelTest-Deadline: 2021-05-29T15:11+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.123 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.123-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.123-rc1

Dongliang Mu <mudongliangabcd@gmail.com>
    NFC: nci: fix memory leak in nci_allocate_device

Dave Rigby <d.rigby@me.com>
    perf unwind: Set userdata for all __report_module() paths

Jan Kratochvil <jan.kratochvil@redhat.com>
    perf unwind: Fix separate debug info files when using elfutils' libdw's unwinder

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: gadget: Enable suspend events

Daniel Borkmann <daniel@iogearbox.net>
    bpf: No need to simulate speculative domain for immediates

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix mask direction swap upon off reg sign change

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Wrap aux data inside bpf_sanitize_info container


-------------

Diffstat:

 Makefile                       |  4 ++--
 drivers/usb/dwc3/gadget.c      |  4 ++++
 include/net/nfc/nci_core.h     |  1 +
 kernel/bpf/verifier.c          | 46 +++++++++++++++++++++++++-----------------
 net/nfc/nci/core.c             |  1 +
 net/nfc/nci/hci.c              |  5 +++++
 tools/perf/util/unwind-libdw.c | 35 ++++++++++++++++++++++++++++----
 7 files changed, 72 insertions(+), 24 deletions(-)


