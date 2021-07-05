Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BFD3BBBBB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhGELCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230511AbhGELCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B116A6135B;
        Mon,  5 Jul 2021 10:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482776;
        bh=XBRYYP5/n7xUYJTZnMtG0DYf7Rut6Wcsb6Fzlhh+AIw=;
        h=From:To:Cc:Subject:Date:From;
        b=bzDzYRAiV1dF4tlAKohsf2alHECKNJD6V/7rNoNyDU1tkXqj7nLUGT09Y+Muyhl4I
         d2dIIB9SRlo3R1ggBkE0GcnfSvEQSLvjoUljRZk1N4b482EK6Wr0SETPHOHOZR2NLg
         tjKt1dZ1Uc1wAzj66CmgYRWM5JK0fUPDYlnKBhtwA70XqwYK87fNzRzq0Opala/GDC
         FvxWjtX7N1k/OO1QTthENlpasuz2puhJSPz0ioVrVV14ces9/JPEHPXwFwfKigJJYv
         P8U3fdnN4UOI22WH2VaW3HMpRMqNMzbqUVDGcaZwY3ZMAPkcTpiB4HCI1ISOk/crnD
         E+u44xbpkbPXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de
Subject: [PATCH 5.12 0/7] 5.12.15-rc1 review
Date:   Mon,  5 Jul 2021 06:59:27 -0400
Message-Id: <20210705105934.1513188-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.15-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 5.12.15 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 07 Jul 2021 10:59:20 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.12.y&id2=v5.12.14
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Christian König (1):
  drm/nouveau: fix dma_address check for CPU/GPU sync

Johannes Berg (1):
  gpio: AMD8111 and TQMX86 require HAS_IOPORT_MAP

Loic Poulain (1):
  gpio: mxc: Fix disabled interrupt wake-up support

ManYi Li (1):
  scsi: sr: Return appropriate error code when disk is ejected

Sasha Levin (1):
  Linux 5.12.15-rc1

Sean Christopherson (1):
  Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"

Tony Krowiak (1):
  s390/vfio-ap: clean up mdev resources when remove callback invoked

 Makefile                             |  4 ++--
 arch/x86/include/asm/kvm_host.h      |  1 +
 arch/x86/kvm/mmu/mmu.c               |  1 +
 drivers/gpio/Kconfig                 |  2 ++
 drivers/gpio/gpio-mxc.c              |  2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c |  4 ++--
 drivers/s390/crypto/vfio_ap_ops.c    | 10 ----------
 drivers/scsi/sr.c                    |  2 ++
 8 files changed, 11 insertions(+), 15 deletions(-)

-- 
2.30.2

