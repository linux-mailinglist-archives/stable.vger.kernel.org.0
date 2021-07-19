Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3842C3CE548
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347270AbhGSPse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349412AbhGSPpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FC4C613FD;
        Mon, 19 Jul 2021 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711899;
        bh=ATonV81nOGjEXxpwkk/59DWJmKmJejiC6yqoy6NdHDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBfEqPFQCqyh/AlTiiT1umCbQqj2uwMhUjMOF0UaPtCXoA8VPXWnGhaC7zN2ZfoP8
         Mw4OT6GWmwHVAzPrFBi+RQdljptXiRzgiirbg2h6POZe3Fhe6C/vNRqBBMu7Jpx8FC
         oB4zxNX6AKAn8Chtt7fl+yCK3dIe4NwqnaTGCyH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 173/292] f2fs: atgc: fix to set default age threshold
Date:   Mon, 19 Jul 2021 16:53:55 +0200
Message-Id: <20210719144948.190928869@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 89e53ff1651a61cf2abef9356e2f60d0086215be ]

Default age threshold value is missed to set, fix it.

Fixes: 093749e296e2 ("f2fs: support age threshold based garbage collection")
Reported-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index a8567cb47621..70d6047ffacf 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1799,6 +1799,7 @@ static void init_atgc_management(struct f2fs_sb_info *sbi)
 	am->candidate_ratio = DEF_GC_THREAD_CANDIDATE_RATIO;
 	am->max_candidate_count = DEF_GC_THREAD_MAX_CANDIDATE_COUNT;
 	am->age_weight = DEF_GC_THREAD_AGE_WEIGHT;
+	am->age_threshold = DEF_GC_THREAD_AGE_THRESHOLD;
 }
 
 void f2fs_build_gc_manager(struct f2fs_sb_info *sbi)
-- 
2.30.2



