Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4A53B6213
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhF1Oll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235389AbhF1Ojy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:39:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C588A61C7A;
        Mon, 28 Jun 2021 14:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890791;
        bh=kbQZK9mTHYLW8H7dpn1S/0EQM+NCx0gJV0DRioKLeQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZA3rM9aJ7Sw45GOpyj45mwux025XNjDVGsQ1RBYrqNn2cwlWTzGj8wLSJXJNHnKx7
         2TQGGlGG3nKL2UhnReIykOTBdc+tNdxDHdWQucv3q3Jn6WHaxN+zqd8vNRyKpB+zYb
         pRAYOYvJD/ri9fyV6Sim891ca7v6F4qfgbr3FygK4YrtaJjsPNVetFQwk/oOIi3dMX
         /CtlgFVNlSjbGibxswkZtVIWGYExGTOglXO9P9s8Q9qY3n+xcGiVIT246npI+pyf/p
         0QnmJM6QjwtQoLTvGphzN731GmZD9A4aSNV/7hagy3eLao1YAInTkiyvj6j24RiF+9
         TVbdK0dJj8//g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bolhuis <mark@bolhuis.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/109] HID: Add BUS_VIRTUAL to hid_connect logging
Date:   Mon, 28 Jun 2021 10:31:20 -0400
Message-Id: <20210628143305.32978-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bolhuis <mark@bolhuis.dev>

[ Upstream commit 48e33befe61a7d407753c53d1a06fc8d6b5dab80 ]

Add BUS_VIRTUAL to hid_connect logging since it's a valid hid bus type and it
should not print <UNKNOWN>

Signed-off-by: Mark Bolhuis <mark@bolhuis.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9b66eb1d42c2..acbbc21e6233 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1823,6 +1823,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	case BUS_I2C:
 		bus = "I2C";
 		break;
+	case BUS_VIRTUAL:
+		bus = "VIRTUAL";
+		break;
 	default:
 		bus = "<UNKNOWN>";
 	}
-- 
2.30.2

