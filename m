Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DB63BBBDC
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhGELDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231287AbhGELDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D58CF613B9;
        Mon,  5 Jul 2021 11:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482831;
        bh=3P8aMyy8ZhPtDW/1bcXb0Z5b/w1L56YhHQnd9wTywdo=;
        h=From:To:Cc:Subject:Date:From;
        b=R8y15sPVvwWhJhLecsNMolUev4g83xJgULPiZzerye6/keeGrAaQmdGQaweK9f4bD
         jAH/ATRkie0P851ltjArI0XiR0z+7sPJINdH1w/RgrGLCxypVZDlCcnH21B2IjdDFr
         xMWNpV+toQpV6EgNc84h7dW89sfLalxI7n5uxeppRGaAYpHnfRAYXPr4TM4f/HR8/X
         uG1V6IgkZrz9NOku1euXYwbgRBpEOhgY+3YIApZBK+f1I2IHNiD6TtFtXPVy953IGQ
         /D16KIlfLIu/BO7qA0qnDwvpOMY1eURcS4K15Algb1x5bBJqZQDLAECBaGT/vIzhOu
         /qSvrG8n48Gag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de
Subject: [PATCH 5.4 0/6] 5.4.130-rc1 review
Date:   Mon,  5 Jul 2021 07:00:23 -0400
Message-Id: <20210705110029.1513384-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.130-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.130-rc1
X-KernelTest-Deadline: 2021-07-07T11:00+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 5.4.130 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 07 Jul 2021 11:00:14 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.129
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Christian König (1):
  drm/nouveau: fix dma_address check for CPU/GPU sync

Johannes Berg (1):
  gpio: AMD8111 and TQMX86 require HAS_IOPORT_MAP

ManYi Li (1):
  scsi: sr: Return appropriate error code when disk is ejected

Mark Bloch (1):
  RDMA/mlx5: Block FDB rules when not in switchdev mode

Sasha Levin (1):
  Linux 5.4.130-rc1

YueHaibing (1):
  x86/efi: remove unused variables

 Makefile                                      | 4 ++--
 drivers/gpio/Kconfig                          | 2 ++
 drivers/gpu/drm/nouveau/nouveau_bo.c          | 4 ++--
 drivers/infiniband/hw/mlx5/flow.c             | 8 ++++++++
 drivers/scsi/sr.c                             | 2 ++
 security/integrity/platform_certs/load_uefi.c | 5 -----
 6 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.30.2

