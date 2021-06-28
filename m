Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CEF3B6397
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhF1O6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236719AbhF1Oz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E4661607;
        Mon, 28 Jun 2021 14:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891208;
        bh=uiI51N416hgyuMaff2alU9ZbZwuhNR44gZ6RjN+11hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBnHOCLe5MzDSEMMTaKWXULw9ssD3G3AnAgv7ZPStFB74N4e9pY+HDsvX+6elu69o
         cWLluT5KvNMk2Knx75XDcJz4VaO2PljIhJPx6gihPEyoVQQqVGAPOfvNcgCnagpdBX
         DgSSdL8jDGa+co/bw2bJ3GOy6S1lF3EGEsnfR+JAfy+Y5+XCzrFryqhEQKr/HhM3Gr
         Jlp5nnxfqevT+48EljfHFK/P7vT+DK3Xq46x7Bk0HJRV7wC8E5zf90z6GDwLs0TY7J
         jxTkPC24tqoaa8BL5dR5Z0yMhUHgiFXEAt1EziySngM197sjyb7HSAjTwy9T4l147o
         KeHk4FRtfEXiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Bolhuis <mark@bolhuis.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/71] HID: Add BUS_VIRTUAL to hid_connect logging
Date:   Mon, 28 Jun 2021 10:38:55 -0400
Message-Id: <20210628144003.34260-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 40b36e59a867..a056850328ef 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1804,6 +1804,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
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

