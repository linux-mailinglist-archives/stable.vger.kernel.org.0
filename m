Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585BC133298
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgAGVMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730035AbgAGVLJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:11:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 556622080A;
        Tue,  7 Jan 2020 21:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431468;
        bh=Sz4u2+3x7rV+qTd3T5LO3bq1Ota15txsjXkvkIJ+ESM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yi6tN94EYP0GL48fzXa525z9O30upx8q9FtsfUa7Vjx1q/gBFxoaLC+vAM6IvU8rz
         vMrsNtmkQebpqBY1fQGcvGPDU1iys5+9GjAikwVvn3YPIBI3ddgwSfIxEjS4MD6Ydy
         98SOcgbO0DaQ8tx3/yHMFb9V7yBwHDz+v2E6OeIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 4.14 32/74] locks: print unsigned ino in /proc/locks
Date:   Tue,  7 Jan 2020 21:54:57 +0100
Message-Id: <20200107205202.614945650@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 98ca480a8f22fdbd768e3dad07024c8d4856576c upstream.

An ino is unsigned, so display it as such in /proc/locks.

Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/locks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2691,7 +2691,7 @@ static void lock_get_status(struct seq_f
 	}
 	if (inode) {
 		/* userspace relies on this representation of dev_t */
-		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
+		seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 	} else {


