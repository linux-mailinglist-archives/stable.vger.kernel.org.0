Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F73BD157B
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfJIRXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbfJIRXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:53 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 126CA206BB;
        Wed,  9 Oct 2019 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641833;
        bh=BnNP/S94t0ycyVIws48GAEBsgOMeY35JYl69u3+93fc=;
        h=From:To:Cc:Subject:Date:From;
        b=kU6CQGlrQqr5rwGxHL3NP8rtMt8jQRFHeJcBGjHpZkp9ry50kUKJs9rL2p3hWTihu
         tT+/xZgCS1iO/FqE8mKljpiJju3puOerUBhhuY13uy3st7nM9WHd00Nt5XyneaES2/
         4khjHPm+/pgHD9XJkm77SZiL+hpfjr9WMHEoMuNU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 01/68] KVM: arm/arm64: vgic: Use the appropriate TRACE_INCLUDE_PATH
Date:   Wed,  9 Oct 2019 13:04:40 -0400
Message-Id: <20191009170547.32204-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit aac60f1a867773de9eb164013d89c99f3ea1f009 ]

Commit 49dfe94fe5ad ("KVM: arm/arm64: Fix TRACE_INCLUDE_PATH") fixes
TRACE_INCLUDE_PATH to the correct relative path to the define_trace.h
and explains why did the old one work.

The same fix should be applied to virt/kvm/arm/vgic/trace.h.

Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/trace.h b/virt/kvm/arm/vgic/trace.h
index 55fed77a9f739..4fd4f6db181b0 100644
--- a/virt/kvm/arm/vgic/trace.h
+++ b/virt/kvm/arm/vgic/trace.h
@@ -30,7 +30,7 @@ TRACE_EVENT(vgic_update_irq_pending,
 #endif /* _TRACE_VGIC_H */
 
 #undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH ../../../virt/kvm/arm/vgic
+#define TRACE_INCLUDE_PATH ../../virt/kvm/arm/vgic
 #undef TRACE_INCLUDE_FILE
 #define TRACE_INCLUDE_FILE trace
 
-- 
2.20.1

