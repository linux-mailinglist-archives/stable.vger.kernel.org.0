Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C693BBBAA
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhGEK7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 06:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhGEK7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 06:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A82686135B;
        Mon,  5 Jul 2021 10:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482618;
        bh=GKGiPgmuBN10Wu0XGdubRqsFLbJa0/FXjoD4yBv1+E8=;
        h=From:To:Cc:Subject:Date:From;
        b=IJIjSiCBfAsAOyd5gn84GDIw5MTnmQnNDu6aifkBbVfE5PcY0A8348kt7kVMlVyyD
         qkzuVFcS1kgLoeFpxIHekXm/syxyRKUwcDc6JWNKJoeE/CEO20EwRCBUSgqps3fuIG
         DlPbZTzWLh8yViC5FwhPdFZSY9n+dkytGoDX8OwBjG/RdJql/EzAI1Jx7eBcFqROIW
         T3l5LQswSmG74yVPbHjdLV+cCXqKcVNJAoYiGlIWEipdRkO6qDVkehPwzd+FjchU3b
         tFHvLbOiny2QKQ3TWLDCeJ1Luuh7Q4+Ndz+S3b0xamHpls3hAFjGfEpHFZKGqxlrCb
         dhu9/tFhDgIfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de
Subject: [PATCH 5.13 0/2] 5.13.1-rc1 review
Date:   Mon,  5 Jul 2021 06:56:54 -0400
Message-Id: <20210705105656.1512997-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.1-rc1
X-KernelTest-Deadline: 2021-07-07T10:49+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 5.13.1 release.
There are 2 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 07 Jul 2021 10:49:46 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Sasha Levin (1):
  Linux 5.13.1-rc1

Sean Christopherson (1):
  Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"

 Makefile                        | 4 ++--
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.30.2

