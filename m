Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395B13C2424
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhGINVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231776AbhGINVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24CF0613B6;
        Fri,  9 Jul 2021 13:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836704;
        bh=gJRhTVBdQ1m3hYZc97kyOXs22b98oz/0Illy7o76wHg=;
        h=From:To:Cc:Subject:Date:From;
        b=VQ1U3ptdoI0V3KXlXDph9Ybr93h0IlvG1ZJ+AEy1wlLeon5pOgnpM7oiuIcqNd2Pj
         LzBrtyYaLhXkGYJecqFW3T+RGN1Es8sheEdGfGqh82oMdktMQwL4bXlfm4IobJ2dNv
         EcUyYrXADeiif0Fof6WhE1Dy0/RRWzzHELmt+NEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 0/4] 4.4.275-rc1 review
Date:   Fri,  9 Jul 2021 15:18:12 +0200
Message-Id: <20210709131529.395072769@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.275-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.275-rc1
X-KernelTest-Deadline: 2021-07-11T13:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.275 release.
There are 4 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.275-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.275-rc1

Masami Hiramatsu <mhiramat@kernel.org>
    arm: kprobes: Allow to handle reentered kprobe on single-stepping

Juergen Gross <jgross@suse.com>
    xen/events: reset active flag for lateeoi events later

Christian König <christian.koenig@amd.com>
    drm/nouveau: fix dma_address check for CPU/GPU sync

ManYi Li <limanyi@uniontech.com>
    scsi: sr: Return appropriate error code when disk is ejected


-------------

Diffstat:

 Makefile                             |  4 ++--
 arch/arm/probes/kprobes/core.c       |  6 ++++++
 drivers/gpu/drm/nouveau/nouveau_bo.c |  4 ++--
 drivers/scsi/sr.c                    |  2 ++
 drivers/xen/events/events_base.c     | 23 +++++++++++++++++++----
 5 files changed, 31 insertions(+), 8 deletions(-)


