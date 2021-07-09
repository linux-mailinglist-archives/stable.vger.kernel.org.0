Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD433C247B
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhGINXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232413AbhGINXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:23:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3080F608FE;
        Fri,  9 Jul 2021 13:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836823;
        bh=O0M0pxLYjP0vqL1M7/m3fHuBafy0fs0uj3AAK7Rj/Mc=;
        h=From:To:Cc:Subject:Date:From;
        b=WI26g4DC+98gHLFcDFoaBxNzomSREJNV3LU4MEolp8a44YYUp5RgXQqy2n5aCQ0bz
         6EHHsQLlPt7yX7gHa3b++m/5k1I26SDh5jzunyaoPpLzINXi8UVdVXdexGUQT0uxqE
         V3BzRPTgpIOMNRFpZppHhqSSRLwD9CA2CYsDtrS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 0/4] 5.4.131-rc1 review
Date:   Fri,  9 Jul 2021 15:20:14 +0200
Message-Id: <20210709131531.277334979@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.131-rc1
X-KernelTest-Deadline: 2021-07-11T13:15+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.131 release.
There are 4 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.131-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.131-rc1

Juergen Gross <jgross@suse.com>
    xen/events: reset active flag for lateeoi events later

Alper Gun <alpergun@google.com>
    KVM: SVM: Call SEV Guest Decommission if ASID binding fails

Heiko Carstens <hca@linux.ibm.com>
    s390/stack: fix possible register corruption with stack switch helper

David Rientjes <rientjes@google.com>
    KVM: SVM: Periodically schedule when unregistering regions on destroy


-------------

Diffstat:

 Makefile                           |  4 ++--
 arch/s390/include/asm/stacktrace.h | 18 +++++++++++-------
 arch/x86/kvm/svm.c                 | 33 ++++++++++++++++++++++-----------
 drivers/xen/events/events_base.c   | 23 +++++++++++++++++++----
 4 files changed, 54 insertions(+), 24 deletions(-)


