Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5170443A110
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhJYThN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236192AbhJYTdm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:33:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E89B60724;
        Mon, 25 Oct 2021 19:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190166;
        bh=hGpd3YvNPeXFjd18sjoJ/3BCSMDycHYGo7nmSGnP960=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQ2K+199MKlmI7YK5+6cyQh6gFyOsfjzXCxd+fD7zWN726h8v8sGl6ZSVY+cSw5Qg
         gppvuO6we+Je/hhlN13CDYIcSFVEC87PXhoD/NC4H6OQJeeCOr/WHLiEiZRXGre/LU
         r66hYyJAvUM+lq51FAADDhrXCLFl2C4rDKq0d7/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/58] platform/x86: intel_scu_ipc: Update timeout value in comment
Date:   Mon, 25 Oct 2021 21:15:07 +0200
Message-Id: <20211025190946.070109834@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
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
index e330ec73c465..bcb516892d01 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -181,7 +181,7 @@ static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 	return 0;
 }
 
-/* Wait till ipc ioc interrupt is received or timeout in 3 HZ */
+/* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
 static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
 {
 	int status;
-- 
2.33.0



