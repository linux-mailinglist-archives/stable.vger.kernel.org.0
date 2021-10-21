Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAD64357C5
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhJUA2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231675AbhJUA07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBC1761374;
        Thu, 21 Oct 2021 00:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775881;
        bh=vckJ+27QpxEAGzTzJ96GNZUN5D4JFQ/i+rJ7uthyoX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PA1ZOHm+uJMTWeblaxDbbkld0epgPEr2wj/6xZS+0LDwr4IVMpH70tUle7Kq8M3dR
         NBiEZUbMVTxUaNaShX7B6wh/3SlIcniCnUVYuUjS6FHzLCIzAcQeLzYejy1n81LAN5
         bDfvVMRywRtJwysj+KmW46ZvYcVQooFkWLnBssYd8Tpgs4ygV9UyhJk8vFVYsQkz8P
         fAHNmTh3ZAxw28aPAua4PZIw0VnObB/oEfZnmE5zMsiuNFqXqs1ek2bXw7+R7AYJ9V
         4O0YMiEURdJXEOD83/7soa5Yx20vookyLQyTnoRKVS8U5lBEtx59MZozKdy8gQjHQw
         L4kvV6RDIYb6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mgross@linux.intel.com,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 5/7] platform/x86: intel_scu_ipc: Update timeout value in comment
Date:   Wed, 20 Oct 2021 20:24:24 -0400
Message-Id: <20211021002427.1130044-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002427.1130044-1-sashal@kernel.org>
References: <20211021002427.1130044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit a0c5814b9933f25ecb6de169483c5b88cf632bca ]

The comment decribing the IPC timeout hadn't been updated when the
actual timeout was changed from 3 to 5 seconds in
commit a7d53dbbc70a ("platform/x86: intel_scu_ipc: Increase virtual
timeout from 3 to 5 seconds") .

Since the value is anyway updated to 10s now, take this opportunity to
update the value in the comment too.

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20210928101932.2543937-4-pmalani@chromium.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index f94b730540e2..04cabcbd8aaa 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -188,7 +188,7 @@ static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 	return 0;
 }
 
-/* Wait till ipc ioc interrupt is received or timeout in 3 HZ */
+/* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
 static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
 {
 	int status;
-- 
2.33.0

