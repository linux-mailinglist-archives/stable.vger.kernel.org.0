Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215BC2F1436
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733209AbhAKNS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733204AbhAKNSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 301DC2255F;
        Mon, 11 Jan 2021 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371119;
        bh=MFX2fFyY1k9rIYEBe4vxSgyv04VO/wE7buwiG+kc5K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLZW3KnQIRWhUowFAChHlkFc7WHNULUHTAx2nYaehEdMrGUfrRYfH+GVJ8HDWVqrL
         HulKEQyx5PTWhMhyJWR/t7pUSn33X12hp0UytWZG3fgGnUHBIopLVRo34Q/yHIBqr6
         OpzT3EuikHpphpqg/XIcwR0aSe2jUKefIiOfmrWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 132/145] bcache: fix typo from SUUP to SUPP in features.h
Date:   Mon, 11 Jan 2021 14:02:36 +0100
Message-Id: <20210111130054.858282273@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit f7b4943dea48a572ad751ce1f18a245d43debe7e upstream.

This patch fixes the following typos,
from BCH_FEATURE_COMPAT_SUUP to BCH_FEATURE_COMPAT_SUPP
from BCH_FEATURE_INCOMPAT_SUUP to BCH_FEATURE_INCOMPAT_SUPP
from BCH_FEATURE_INCOMPAT_SUUP to BCH_FEATURE_RO_COMPAT_SUPP

Fixes: d721a43ff69c ("bcache: increase super block version for cache device and backing device")
Fixes: ffa470327572 ("bcache: add bucket_size_hi into struct cache_sb_disk for large bucket")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/features.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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


