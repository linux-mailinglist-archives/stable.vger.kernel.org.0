Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2584357B1
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhJUA2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232032AbhJUA0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8129361381;
        Thu, 21 Oct 2021 00:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775858;
        bh=fyj9I3XPf2AF6zgHV9ufCSsOVwVPKoCgptUH2+OCzYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhqef0/Qamf6y3GXi5Rg6SvXnT+mtrsFDmkw72tNAizl8s55J98CHheUrMxfzEoAE
         +RoUg3PjbfoHOl7DNV1toXA0UWvwMZ+Ik/M/gZxoVjJt0eu0d9ttcR0XdxMtN+yRqB
         szxxl/T6CBy1ayCPtwUPakzXsOm3qZMdjkuHdpjud9SjH51n9GwnEjUJa092r/vvs7
         SorwSiXB0LeaFo7BN4N0TVD3uO8T3p/ry2uEP+3sohSz73OzpZXMlKhI0gddnk+l1U
         oAAEGsqAAzdX+1TuqHGXye43z7vrVyeXe64aNFyRDbzoA4T1wR+My8WL2mmRFF//SP
         RpMg57NxozZWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mgross@linux.intel.com,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/7] platform/x86: intel_scu_ipc: Update timeout value in comment
Date:   Wed, 20 Oct 2021 20:24:01 -0400
Message-Id: <20211021002404.1129946-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002404.1129946-1-sashal@kernel.org>
References: <20211021002404.1129946-1-sashal@kernel.org>
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
index e81daff65f62..238ee4275f5c 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -187,7 +187,7 @@ static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 	return 0;
 }
 
-/* Wait till ipc ioc interrupt is received or timeout in 3 HZ */
+/* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
 static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
 {
 	int status;
-- 
2.33.0

