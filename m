Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2ED6DEED5
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjDLIpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjDLIpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:45:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7E15FD5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC016630B4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6B8C4339C;
        Wed, 12 Apr 2023 08:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289080;
        bh=7dKDgcGJtTOo5/LJAr61enMxkUxsY7O9Sv8OXzmIO8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pI5/DF5xPYHnIGL3rtfkHWkSxK30MkR1HT0Nnuh8mZx1NFuX9vDB6hTJgguBbhwp
         hjNGbbSuDeulInMWRNkOFqWByMf8JSY1WIa4Pl6fbEgQPGP6IMlYJ8GJsqokS+8z8D
         xIxshT5MSaZC0DVT03Ssa6u5kspSD7UD+TXn+2VY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 129/164] zsmalloc: document freeable stats
Date:   Wed, 12 Apr 2023 10:34:11 +0200
Message-Id: <20230412082842.095836037@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit 618a8a917dbf5830e2064d2fa0568940eb5d2584 upstream.

When freeable class stat was added to classes file (back in 2016) we
forgot to update zsmalloc documentation.  Fix that.

Link: https://lkml.kernel.org/r/20230325024631.2817153-3-senozhatsky@chromium.org
Fixes: 1120ed548394 ("mm/zsmalloc: add `freeable' column to pool stat")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/mm/zsmalloc.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -68,6 +68,8 @@ pages_used
 	the number of pages allocated for the class
 pages_per_zspage
 	the number of 0-order pages to make a zspage
+freeable
+	the approximate number of pages class compaction can free
 
 We assign a zspage to ZS_ALMOST_EMPTY fullness group when n <= N / f, where
 


