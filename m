Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B10348C80
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 10:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCYJPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 05:15:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14894 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhCYJPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 05:15:17 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F5fXy13N9zlVtH;
        Thu, 25 Mar 2021 17:13:38 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.26.249) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 17:15:07 +0800
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
CC:     <maz@kernel.org>, <pbonzini@redhat.com>, <linuxarm@huawei.com>
Subject: [PATCH for-stable-5.10 0/2] Backport for- Work around firmware wrongly advertising GICv2 compatibility 
Date:   Thu, 25 Mar 2021 09:14:22 +0000
Message-ID: <20210325091424.26348-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.26.249]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport 2 patches that are required on ARM64 platforms having
firmware wrongly advertising GICv2 compatibility.

Patch 1 has nvhe related conflict resolution while patch 2 is
cleanly applied.

Tested on HiSilicon D06 platform.

Marc Zyngier (2):
  KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to
    __vgic_v3_get_gic_config()
  KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3
    compatibility

 arch/arm64/include/asm/kvm_asm.h   |  4 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  4 +--
 arch/arm64/kvm/hyp/vgic-v3-sr.c    | 40 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v3.c      | 12 ++++++---
 4 files changed, 51 insertions(+), 9 deletions(-)

-- 
2.17.1

