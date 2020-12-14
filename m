Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D255D2D9D33
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502042AbgLNRGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:06:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728823AbgLNRF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:05:56 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
        Mike Snitzer <snitzer@redhat.com>,
        Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 1/2] Revert "md: change mddev chunk_sectors from int to unsigned"
Date:   Mon, 14 Dec 2020 18:06:10 +0100
Message-Id: <20201214170452.733159716@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214170452.563016590@linuxfoundation.org>
References: <20201214170452.563016590@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 6ffeb1c3f8226244c08105bcdbeecc04bad6b89a.

It causes problems :(

Reported-by: Dave Jones <davej@codemonkey.org.uk>
Reported-by: Mike Snitzer <snitzer@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -311,7 +311,7 @@ struct mddev {
 	int				external;	/* metadata is
 							 * managed externally */
 	char				metadata_type[17]; /* externally set*/
-	unsigned int			chunk_sectors;
+	int				chunk_sectors;
 	time64_t			ctime, utime;
 	int				level, layout;
 	char				clevel[16];
@@ -339,7 +339,7 @@ struct mddev {
 	 */
 	sector_t			reshape_position;
 	int				delta_disks, new_level, new_layout;
-	unsigned int			new_chunk_sectors;
+	int				new_chunk_sectors;
 	int				reshape_backwards;
 
 	struct md_thread		*thread;	/* management thread */


