Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9977C435796
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhJUA1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhJUA0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A226D611CC;
        Thu, 21 Oct 2021 00:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775832;
        bh=1mhfeHEhyimC8v2ZpBQtxBPWc4NhpHFzLAW0gj7zt5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZ62aaP0cDb/ghScWnQyZm25EfD7wwJ/Jrop81Hfj8z1asHXzlgEmWjlMjOmgXYdY
         EZCKS09htmkisAIbNxNig2zWhao+9nQMG+gB6OHeUh0k87CEO7xweBa5WOuzupBhQ8
         LxbLz0zvfuSZAYOgsLWeA4jMx13vn9zSob+v6/VZ75E6j3hdYdmuB5dlH6nbIglNsc
         71lO0uoEznG2EnG1kuDlA8TVpcUI9kt/aObj9P+lFib844Her623Z3CdKSdU9zZrRZ
         Rh8StK2OiMOdigAcJG+M3BX3juEt921SlKLnC7hJfFl0QBv34NoDiyirZFm5AlX2Pc
         VegZrINP+HSZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mgross@linux.intel.com,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 7/9] platform/x86: intel_scu_ipc: Update timeout value in comment
Date:   Wed, 20 Oct 2021 20:23:31 -0400
Message-Id: <20211021002333.1129824-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002333.1129824-1-sashal@kernel.org>
References: <20211021002333.1129824-1-sashal@kernel.org>
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
index 2434ce8bead6..46d543063b6d 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -183,7 +183,7 @@ static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 	return 0;
 }
 
-/* Wait till ipc ioc interrupt is received or timeout in 3 HZ */
+/* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
 static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
 {
 	int status;
-- 
2.33.0

