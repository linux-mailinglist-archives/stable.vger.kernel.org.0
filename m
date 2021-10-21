Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB4435736
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhJUAZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232128AbhJUAYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E62F61208;
        Thu, 21 Oct 2021 00:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775742;
        bh=V1aVFNfnQwpZqtkXt8/1Z8JI4+ZxdSjxAC7BbYAYSsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRGnAQWhuTZ1cU6sY3xAdyxBw7LXG7soh3aeAzIr0TVKTywOAf3oZ5bVFVVYugXCC
         au9iwwnN0qhMzK85x296bCIB3JzEgZi4ANkiJ8p+0/5lvnShSjBR6b7wr1w+pct/Eh
         uwghA88PnpjlDb44fjmpppXKNYoKpgXNWoJCDfFGVfEmtmnUt3JYMhq9bnb6t+SQKp
         66VuICJ1uQA3aiT9+5iT6GEFUiSeC8ShOemKkFeQuRnL7NC8V7W3i+4iGPLf0RHgk4
         QJltkOQKb7w6R7tlCxyIhu4kZ77bZdn0OP7+v+DgzzasEAvob2DJjDEo3/vL25zb2u
         V9q5jmDKJ5QLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mgross@linux.intel.com,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/14] platform/x86: intel_scu_ipc: Update timeout value in comment
Date:   Wed, 20 Oct 2021 20:21:50 -0400
Message-Id: <20211021002155.1129292-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002155.1129292-1-sashal@kernel.org>
References: <20211021002155.1129292-1-sashal@kernel.org>
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
index d9cf7f7602b0..daae5b5da827 100644
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

