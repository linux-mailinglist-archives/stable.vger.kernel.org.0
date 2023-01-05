Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5993365E5D8
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjAEHRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjAEHRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:17:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CC75276E;
        Wed,  4 Jan 2023 23:17:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75027618F5;
        Thu,  5 Jan 2023 07:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9470C433F0;
        Thu,  5 Jan 2023 07:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672903027;
        bh=2jIBrk0hTYQ4PjzwWFByjNot02am0tOhmqhgQvvRaIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDRe56VVrvgDDGE7ArInKwBccSULMlFCfbGbbOnDaTMxmwjOUi3BpD+9rFEBoOyvc
         sp3TyNUkGyrHj6t+xx5QzlBoxXKtDBGh2JjpVwGiqtE9kOoPrWHWIW7J/TQHjCpWo0
         U35z2i8KVbXnULHXDPprNaFrkmr4mA2R9h5pw48AI4q6IJa+wlIIct17EQYOELaxqa
         c3mAAL8LXbg2tNQkswK/Vv81h58hnoXcwEUy2FGNsnTh65vDCxzTqGx2Fb+em2HKVM
         sGW5dIuKydfyH2bNrKriIuXNGaaaoBDIgyX4pSA7FdQXMMNUSqOgXgKA3H8RQjTP9H
         rLNxswn9xjcCQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5.15 01/10] ext4: remove unused enum EXT4_FC_COMMIT_FAILED
Date:   Wed,  4 Jan 2023 23:13:50 -0800
Message-Id: <20230105071359.257952-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105071359.257952-1-ebiggers@kernel.org>
References: <20230105071359.257952-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit c864ccd182d6ff2730a0f5b636c6b7c48f6f4f7f upstream.

Below commit removed all references of EXT4_FC_COMMIT_FAILED.
commit 0915e464cb274 ("ext4: simplify updating of fast commit stats")

Just remove it since it is not used anymore.

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/c941357e476be07a1138c7319ca5faab7fb80fc6.1647057583.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/fast_commit.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index 083ad1cb705a7..a0fed4e8a8c8e 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -93,7 +93,6 @@ enum {
 	EXT4_FC_REASON_RENAME_DIR,
 	EXT4_FC_REASON_FALLOC_RANGE,
 	EXT4_FC_REASON_INODE_JOURNAL_DATA,
-	EXT4_FC_COMMIT_FAILED,
 	EXT4_FC_REASON_MAX
 };
 
-- 
2.39.0

