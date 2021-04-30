Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A8A36FC22
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhD3OVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233007AbhD3OVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CE4613EA;
        Fri, 30 Apr 2021 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792449;
        bh=YMNv5MAE6d7ABbjj73dH5lMjZa8cdFtiy987rheiT5k=;
        h=From:To:Cc:Subject:Date:From;
        b=ghVnIDKTOghjR5UUoye8Mj5a98RVlqg+d4amlVg4M/9k36YAM2MKSpIMw8lm6BNrI
         FXjwY3jwRbPUecSYVhBPTRKMgEW637H8rEKXRvfSNk1a8rsE3rGyABhwRfXjTQI+Br
         DrzfayyzzhVoBhXUyeSxmm0yg0z3LEpbgpDAumps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 0/2] 5.10.34-rc1 review
Date:   Fri, 30 Apr 2021 16:20:41 +0200
Message-Id: <20210430141910.473289618@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.34-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.34-rc1
X-KernelTest-Deadline: 2021-05-02T14:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.34 release.
There are 2 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.34-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.34-rc1

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add Alder Lake P device id.

Jiri Kosina <jkosina@suse.cz>
    iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()


-------------

Diffstat:

 Makefile                                          | 4 ++--
 drivers/misc/mei/hw-me-regs.h                     | 1 +
 drivers/misc/mei/pci-me.c                         | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 7 ++++---
 4 files changed, 8 insertions(+), 5 deletions(-)


