Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E4A43A187
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbhJYTjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235166AbhJYThT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C329610C7;
        Mon, 25 Oct 2021 19:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190438;
        bh=3muY8169BLA2GxkGl1NnHu0mVeOHbBchTUUsFbbRqsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsnUieeTnAjyUD/uMTuXtzhqlOECU2B5KZagIdEEZUFac9HjYNQFOvLZezm0/VVal
         9jkkr4NsSXgcYVCRbqWJxWQ8LPNneZnDpvyeDqen2tNevouYYW4g0+qQuVgkOLLYNw
         CGq3Nplp1fcD9JX5cykCK76cshFbVzynK9cs6d2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 76/95] platform/x86: intel_scu_ipc: Update timeout value in comment
Date:   Mon, 25 Oct 2021 21:15:13 +0200
Message-Id: <20211025191007.971299732@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 425d2064148f..69d706039cb2 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -247,7 +247,7 @@ static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 	return -ETIMEDOUT;
 }
 
-/* Wait till ipc ioc interrupt is received or timeout in 3 HZ */
+/* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
 static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
 {
 	int status;
-- 
2.33.0



