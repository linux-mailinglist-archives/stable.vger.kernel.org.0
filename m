Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB43676EE2
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjAVPP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjAVPP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:15:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CDB22023
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:15:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8457C60C60
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954ECC433D2;
        Sun, 22 Jan 2023 15:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400524;
        bh=ppVz6zurDT4AfZUZu/DgoJgtNNnLOZO3tDtzhFf6pC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiOqt0Hi5BdWDHo+XuqVDz/oFQHcgzUFp7A30k/ErBzMZgzuTspTYxXn3xWSv5kZ4
         UJyRcZc1QmR+uuy13YnyidiSvyMP8NdnAPoSnZoBNhv16AkKWW2nbslxif+rIwRwEq
         ua5wzEVy9zQCWgeDGfD8zHqE40/lFH+P7hoKOJMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/117] btrfs: fix trace event name typo for FLUSH_DELAYED_REFS
Date:   Sun, 22 Jan 2023 16:03:11 +0100
Message-Id: <20230122150232.812880612@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 0a3212de8ab3e2ce5808c6265855e528d4a6767b ]

Fix a typo of printing FLUSH_DELAYED_REFS event in flush_space() as
FLUSH_ELAYED_REFS.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8f58fd95efc7..9271b5dfae4c 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -96,7 +96,7 @@ struct btrfs_space_info;
 	EM( FLUSH_DELALLOC_WAIT,	"FLUSH_DELALLOC_WAIT")		\
 	EM( FLUSH_DELALLOC_FULL,	"FLUSH_DELALLOC_FULL")		\
 	EM( FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR")	\
-	EM( FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS")		\
+	EM( FLUSH_DELAYED_REFS,		"FLUSH_DELAYED_REFS")		\
 	EM( ALLOC_CHUNK,		"ALLOC_CHUNK")			\
 	EM( ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE")		\
 	EM( RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS")		\
-- 
2.35.1



