Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DB615E900
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391781AbgBNQPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:15:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392459AbgBNQPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E5AD246ED;
        Fri, 14 Feb 2020 16:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696934;
        bh=7jOrCJo4W6QpDHFDtZvsrVqjHYJDbtJs8AOUjYqu4cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EZVZQDrG3x4LA7/n3P3L5Lvh3jDKfS11bxQYCkjsNYdOud3GS8TjvivGsPCZTQfU
         CoFdSKx+QyCObP8pXkvu/DxyIKS4ZwZxpI3P5exO9iy2RZvN3/il0Ktk1Jl5I65yfK
         OXE+AG680JMIjoJu6G3YN06wW21Ebdtl+5uwHcZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 179/252] f2fs: free sysfs kobject
Date:   Fri, 14 Feb 2020 11:10:34 -0500
Message-Id: <20200214161147.15842-179-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 820d366736c949ffe698d3b3fe1266a91da1766d ]

Detected kmemleak.

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 98887187af4cd..b405548202d3b 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -711,4 +711,5 @@ void f2fs_unregister_sysfs(struct f2fs_sb_info *sbi)
 		remove_proc_entry(sbi->sb->s_id, f2fs_proc_root);
 	}
 	kobject_del(&sbi->s_kobj);
+	kobject_put(&sbi->s_kobj);
 }
-- 
2.20.1

