Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471703B642F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbhF1PGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236669AbhF1PCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:02:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D79F261CCA;
        Mon, 28 Jun 2021 14:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891380;
        bh=1FnxCJntlgt0Os8jcnbKPyGg0uGXabSxWSZ07gKkbqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKfarKDApwZmGVwXIm50oMTXMIc1N7ZVi+eBxOSDvqgbhponwJCKkYQcrVY10P9Fo
         JoMA47u4u2ICa8RRP5UyuJdZ5OssmzJ6ukXWteEy6dmwvuPYEiOr8442zZX0Za2jlg
         cXdMNZr4JHQnOQGUZdMrO0rA1PmhfrQoDxKjg7keWCE5mvIlhHzYjtmZLzyxfZk6nl
         bBhF/rJ7bq3skm/m+ngUrvhHF3R1K/xh0Q2XDE7gH8jxMSVo7duv0qVSDr86R4BsyK
         FbMKhGpzINEWZ8FfyVvd1P1Kh48u2VJ5qKEn8GquhC2MzbPzlvkriMcam2M91TVVMp
         GgPoXnsu9d+dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bolhuis <mark@bolhuis.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 02/57] HID: Add BUS_VIRTUAL to hid_connect logging
Date:   Mon, 28 Jun 2021 10:42:01 -0400
Message-Id: <20210628144256.34524-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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
index 25544a08fa83..1dd97f4b449a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1765,6 +1765,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
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

