Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F32E5943CB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349949AbiHOWin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350866AbiHOWhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA0857277;
        Mon, 15 Aug 2022 12:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 484B0B80EA9;
        Mon, 15 Aug 2022 19:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81042C433C1;
        Mon, 15 Aug 2022 19:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592978;
        bh=Yjb9Y4qVJPHM6/fkJw0FSZx+TJgkUbWAT0nB14c/RKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnKSwYY8CTbLMIYNHkxHnNiTAWxwngZTzUI+BFV7cL9RAEDfsZOBpOkdaWc9SQBfd
         8W2J7Ve7NZ6smXOBIMPvB/qpzUzK1pULib5T79KjK/wFm0RpKT1ASmD5trqxzJGGH8
         4AeDy3eYL5dD5Zk+E8JGOAET9LZXfR/GJ6PvjCs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0195/1157] io_uring: fix io_uring_cqe_overflow trace format
Date:   Mon, 15 Aug 2022 19:52:31 +0200
Message-Id: <20220815180447.527028256@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Yudaken <dylany@fb.com>

[ Upstream commit 9b26e811e934eebda59362c9a03d082852552574 ]

Make the trace format consistent with io_uring_complete for cflags

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220630091231.1456789-12-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index aa2f951b07cd..6a12eef3ffb7 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -622,7 +622,7 @@ TRACE_EVENT(io_uring_cqe_overflow,
 		__entry->ocqe		= ocqe;
 	),
 
-	TP_printk("ring %p, user_data 0x%llx, res %d, flags %x, "
+	TP_printk("ring %p, user_data 0x%llx, res %d, cflags 0x%x, "
 		  "overflow_cqe %p",
 		  __entry->ctx, __entry->user_data, __entry->res,
 		  __entry->cflags, __entry->ocqe)
-- 
2.35.1



