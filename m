Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7971D2E9149
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 08:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbhADHmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 02:42:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:41088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbhADHmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 02:42:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B0828B282;
        Mon,  4 Jan 2021 07:41:31 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org
Subject: [PATCH 2/5] bcache: fix typo from SUUP to SUPP in features.h
Date:   Mon,  4 Jan 2021 15:41:19 +0800
Message-Id: <20210104074122.19759-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104074122.19759-1-colyli@suse.de>
References: <20210104074122.19759-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes the following typos,
from BCH_FEATURE_COMPAT_SUUP to BCH_FEATURE_COMPAT_SUPP
from BCH_FEATURE_INCOMPAT_SUUP to BCH_FEATURE_INCOMPAT_SUPP
from BCH_FEATURE_INCOMPAT_SUUP to BCH_FEATURE_RO_COMPAT_SUPP

Fixes: d721a43ff69c ("bcache: increase super block version for cache device and backing device")
Fixes: ffa470327572 ("bcache: add bucket_size_hi into struct cache_sb_disk for large bucket")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org # 5.9+
---
 drivers/md/bcache/features.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
index a1653c478041..32c5bbda2f0d 100644
--- a/drivers/md/bcache/features.h
+++ b/drivers/md/bcache/features.h
@@ -15,9 +15,9 @@
 /* Incompat feature set */
 #define BCH_FEATURE_INCOMPAT_LARGE_BUCKET	0x0001 /* 32bit bucket size */
 
-#define BCH_FEATURE_COMPAT_SUUP		0
-#define BCH_FEATURE_RO_COMPAT_SUUP	0
-#define BCH_FEATURE_INCOMPAT_SUUP	BCH_FEATURE_INCOMPAT_LARGE_BUCKET
+#define BCH_FEATURE_COMPAT_SUPP		0
+#define BCH_FEATURE_RO_COMPAT_SUPP	0
+#define BCH_FEATURE_INCOMPAT_SUPP	BCH_FEATURE_INCOMPAT_LARGE_BUCKET
 
 #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
 		((sb)->feature_compat & (mask))
-- 
2.26.2

