Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E40736FC2B
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhD3OV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhD3OVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A064F61450;
        Fri, 30 Apr 2021 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792462;
        bh=6G+pLgjYTHGSJy2+4tTEXtRGPYz0bm6Tb6DhitxL+hc=;
        h=From:To:Cc:Subject:Date:From;
        b=jBmyGKDX1Yg6jkEhns6TelJqDtz949m+8FhBWK3TSoXJr2nBUcu0pPkWr2XkMGzKg
         16UK2W20LyzCPriz0mQLMQfFL0CK/ArELxEtc6/G8MusalhBIeIB7oMPvrtxGeIcQP
         dhkwYKSOTGMnCX56Y0ftyOLGZymtDMbrTHP/yMNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 0/3] 5.11.18-rc1 review
Date:   Fri, 30 Apr 2021 16:20:49 +0200
Message-Id: <20210430141910.693887691@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.18-rc1
X-KernelTest-Deadline: 2021-05-02T14:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.18 release.
There are 3 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.18-rc1

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add Alder Lake P device id.

Qingqing Zhuo <qingqing.zhuo@amd.com>
    drm/amd/display: Update modifier list for gfx10_3

Jiri Kosina <jkosina@suse.cz>
    iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()


-------------

Diffstat:

 Makefile                                          | 4 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 drivers/misc/mei/hw-me-regs.h                     | 1 +
 drivers/misc/mei/pci-me.c                         | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 7 ++++---
 5 files changed, 10 insertions(+), 7 deletions(-)


