Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597E1604417
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiJSL5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiJSL46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:56:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544D2A59A4;
        Wed, 19 Oct 2022 04:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D826FCE2154;
        Wed, 19 Oct 2022 09:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1B0C433D6;
        Wed, 19 Oct 2022 09:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170146;
        bh=d/SBqC/iWgZnvoilQmoMgTf/cQ6a1kVGxLMDkcIvoqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0bmSx7ZTnh751PL9X5UQtKxFEd1tAPITCDj/Xa9BLOsshmdt+tTjlvV6YBOfzUXO
         DCMporOZfWJzCg/cgJoGhNeNmvRBEpF/NFbAK3YlWFLL9sJ3WuFo3Ezm0veAkQNpYe
         /XK2zFlaejRJi26sFaQVR4zNM383ZhDdCP6qGJU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 544/862] block: Fix the enum blk_eh_timer_return documentation
Date:   Wed, 19 Oct 2022 10:30:31 +0200
Message-Id: <20221019083313.997289806@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit b2bed51a5261f4266ecb857bba680a7f668d3ddf ]

The documentation of the blk_eh_timer_return enumeration values does not
reflect correctly how e.g. the SCSI core uses these values. Fix the
documentation.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Fixes: 88b0cfad2888 ("block: document the blk_eh_timer_return values")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20220920200626.3422296-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blk-mq.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 92294a5fb083..1532cd07a597 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -268,9 +268,16 @@ static inline void rq_list_move(struct request **src, struct request **dst,
 	rq_list_add(dst, rq);
 }
 
+/**
+ * enum blk_eh_timer_return - How the timeout handler should proceed
+ * @BLK_EH_DONE: The block driver completed the command or will complete it at
+ *	a later time.
+ * @BLK_EH_RESET_TIMER: Reset the request timer and continue waiting for the
+ *	request to complete.
+ */
 enum blk_eh_timer_return {
-	BLK_EH_DONE,		/* drivers has completed the command */
-	BLK_EH_RESET_TIMER,	/* reset timer and try again */
+	BLK_EH_DONE,
+	BLK_EH_RESET_TIMER,
 };
 
 #define BLK_TAG_ALLOC_FIFO 0 /* allocate starting from 0 */
-- 
2.35.1



