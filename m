Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F6E593E22
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344926AbiHOUhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345380AbiHOUfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:35:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8134ABD5F;
        Mon, 15 Aug 2022 12:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62476B81062;
        Mon, 15 Aug 2022 19:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B20C433D6;
        Mon, 15 Aug 2022 19:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590381;
        bh=lroM00tmODnDQFpUqqoc3y+4ybOKRk44pC+oLOaX9v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1l9b9tKZ5nOtY46Sv0rXvm0cMHWDvH7vkV43zVKDoFRj9nV3hxTe02LVbAV4+VjGV
         cp+YZ5ABBZotjod9HzEKEYsBTDZ2N/pb3FmZqUd75n/WOCOibRMY4VnscnM7NsyrY1
         3PSzXg7j8PxGxcsESz9aBA+Y7wuNS25HBMaDebWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0242/1095] iio: core: fix a few code style issues
Date:   Mon, 15 Aug 2022 19:54:01 +0200
Message-Id: <20220815180439.791950834@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>

[ Upstream commit f4decb4c6e374a4ded59a6a76b8236695e44d8bc ]

* Fix indent in else statement
* Remove unnecessary 'else' after 'break'
* Remove space in '* attr'

Signed-off-by: Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
Link: https://lore.kernel.org/r/20220312180343.8935-1-alexander.vorwerk@stud.uni-goettingen.de
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-buffer.c | 4 ++--
 drivers/iio/industrialio-core.c   | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index b078eb2f3c9d..01369973329a 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -915,7 +915,7 @@ static int iio_verify_update(struct iio_dev *indio_dev,
 		if (scan_mask == NULL)
 			return -EINVAL;
 	} else {
-	    scan_mask = compound_mask;
+		scan_mask = compound_mask;
 	}
 
 	config->scan_bytes = iio_compute_scan_bytes(indio_dev,
@@ -1649,7 +1649,7 @@ static int __iio_buffer_alloc_sysfs_and_mask(struct iio_buffer *buffer,
 	}
 
 	attrn = buffer_attrcount + scan_el_attrcount + ARRAY_SIZE(iio_buffer_attrs);
-	attr = kcalloc(attrn + 1, sizeof(* attr), GFP_KERNEL);
+	attr = kcalloc(attrn + 1, sizeof(*attr), GFP_KERNEL);
 	if (!attr) {
 		ret = -ENOMEM;
 		goto error_free_scan_mask;
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 58d1180f4f61..b2d2b42614d3 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -908,8 +908,7 @@ static int __iio_str_to_fixpoint(const char *str, int fract_mult,
 		} else if (*str == '\n') {
 			if (*(str + 1) == '\0')
 				break;
-			else
-				return -EINVAL;
+			return -EINVAL;
 		} else if (!strncmp(str, " dB", sizeof(" dB") - 1) && scale_db) {
 			/* Ignore the dB suffix */
 			str += sizeof(" dB") - 1;
-- 
2.35.1



