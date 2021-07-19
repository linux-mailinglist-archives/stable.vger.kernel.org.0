Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C93E3CE172
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346803AbhGSP0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347832AbhGSPVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D55F6142F;
        Mon, 19 Jul 2021 15:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710351;
        bh=jZikTFUTv0AzTXuWcBdCDyBsPChwXYD3vXY8IpLsFXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDgI8FxUULV3tYCefavPx1RX7S2UJvuXYwQ5TO/rXOFfQJoj/vIZ6dkZnAgZ6psXV
         LBtkZB9HX1ja/MbznbC4BPTAg8RYQ89n09orxKtpQpcosWNErNKaB5mf9xcEkAxoje
         QzXSqVQIEOCkEGp3ja/qt0EJyHeo7KSIhCWkMObg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/243] f2fs: atgc: fix to set default age threshold
Date:   Mon, 19 Jul 2021 16:52:55 +0200
Message-Id: <20210719144945.620669055@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index 9b38cef4d50f..e02affb5c0e7 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1801,6 +1801,7 @@ static void init_atgc_management(struct f2fs_sb_info *sbi)
 	am->candidate_ratio = DEF_GC_THREAD_CANDIDATE_RATIO;
 	am->max_candidate_count = DEF_GC_THREAD_MAX_CANDIDATE_COUNT;
 	am->age_weight = DEF_GC_THREAD_AGE_WEIGHT;
+	am->age_threshold = DEF_GC_THREAD_AGE_THRESHOLD;
 }
 
 void f2fs_build_gc_manager(struct f2fs_sb_info *sbi)
-- 
2.30.2



