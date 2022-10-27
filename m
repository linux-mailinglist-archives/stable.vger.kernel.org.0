Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0C260FE2E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbiJ0RC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236870AbiJ0RC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:02:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DBC193454
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B9D62369
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A6EC433C1;
        Thu, 27 Oct 2022 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890175;
        bh=+RSsAh3GGy4pywNj0t2fvXFkPSyVIIH53c7AasEaONk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afgXQ8Am/r/lpLTCOHZGgqMb2Ofmp1LhbeAxu0hOWjAjF7RdHevtXbnRddMryxRT0
         8s2fYYHOnQwxFB6sCv4NjmiituzRdM9rDcbmtUNIYjcWA+sEzzUBZX1ab+pviWfT/I
         NQo0F888cqJ9YGSVUxSWwd/u1Rj1oStlr2OXHmkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Genjian Zhang <zhanggenjian@kylinos.cn>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/79] dm: remove unnecessary assignment statement in alloc_dev()
Date:   Thu, 27 Oct 2022 18:55:48 +0200
Message-Id: <20221027165056.566863966@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Genjian Zhang <zhanggenjian@kylinos.cn>

[ Upstream commit 99f4f5bcb975527508eb7a5e3e34bdb91d576746 ]

Fixes: 74fe6ba923949 ("dm: convert to blk_alloc_disk/blk_cleanup_disk")
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 41d2e1285c07..9dd2c2da075d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1797,7 +1797,6 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->first_minor = minor;
 	md->disk->minors = 1;
 	md->disk->fops = &dm_blk_dops;
-	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
-- 
2.35.1



