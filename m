Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245AE12185E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbfLPR7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbfLPR7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:59:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94324205C9;
        Mon, 16 Dec 2019 17:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519173;
        bh=kIOuWdKOFKVyD3Zp6UQCx4HapgrmXEDzh8vHF1opV18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqiTeGYa55p00VUBIggK4dqujBHZCcH/N3u9SFdnl5dGkgZqdMgMPrzzzqNXxLZ0a
         0H0tRJOhYW+pbTERKJ3d9Lh2y9jGY8YOcdJIxXI+nHb1w0iL1OIfRckayp7rjsYacs
         /y7Y9rPjZEBec1CwMNqHEih28D/OJq1tqOG+2FAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 188/267] btrfs: Remove btrfs_bio::flags member
Date:   Mon, 16 Dec 2019 18:48:34 +0100
Message-Id: <20191216174912.823708256@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 34b127aecd4fe8e6a3903e10f204a7b7ffddca22 upstream.

The last user of btrfs_bio::flags was removed in commit 326e1dbb5736
("block: remove management of bi_remaining when restoring original
bi_end_io"), remove it.

(Tagged for stable as the structure is heavily used and space savings
are desirable.)

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.h |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -317,7 +317,6 @@ struct btrfs_bio {
 	u64 map_type; /* get from map_lookup->type */
 	bio_end_io_t *end_io;
 	struct bio *orig_bio;
-	unsigned long flags;
 	void *private;
 	atomic_t error;
 	int max_errors;


