Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738092D651E
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390753AbgLJOdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:33:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390743AbgLJOd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:33:27 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 20/39] dm writecache: fix the maximum number of arguments
Date:   Thu, 10 Dec 2020 15:26:59 +0100
Message-Id: <20201210142603.278587563@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.272595094@linuxfoundation.org>
References: <20201210142602.272595094@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 67aa3ec3dbc43d6e34401d9b2a40040ff7bb57af upstream.

Advance the maximum number of arguments to 16.
This fixes issue where certain operations, combined with table
configured args, exceed 10 arguments.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 48debafe4f2f ("dm: add writecache target")
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1883,7 +1883,7 @@ static int writecache_ctr(struct dm_targ
 	struct wc_memory_superblock s;
 
 	static struct dm_arg _args[] = {
-		{0, 10, "Invalid number of feature args"},
+		{0, 16, "Invalid number of feature args"},
 	};
 
 	as.argc = argc;


