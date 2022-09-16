Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B5A5BAAA3
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiIPKKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiIPKJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:09:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7482FABF3D;
        Fri, 16 Sep 2022 03:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52C09B82507;
        Fri, 16 Sep 2022 10:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDCDC433D7;
        Fri, 16 Sep 2022 10:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322912;
        bh=jaexKV/ISln6aKv9PrpU0ZKA7HGBT+BGvGa+IiQ2i6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFh08g12IS4mby1izyf1CrpJmWRndBEFdTpBbkrhzufJ3mki71i8J0zS6xiCFX9ey
         9BD0QL/N1wYb4E5iZljXP+f7q8PRseyQ1hrBOXsF27MUSfcl1u1auc9xoPICcpUM0y
         oIf2hF7PVOnQBsxsivY032sjrlU36yjaUKkqCkos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/11] HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo
Date:   Fri, 16 Sep 2022 12:07:58 +0200
Message-Id: <20220916100442.786603835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100442.662955946@linuxfoundation.org>
References: <20220916100442.662955946@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <wangborong@cdjrlc.com>

[ Upstream commit 94553f8a218540d676efbf3f7827ed493d1057cf ]

The double `like' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp-hid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.h b/drivers/hid/intel-ish-hid/ishtp-hid.h
index f5c7eb79b7b53..fa16983007f60 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid.h
+++ b/drivers/hid/intel-ish-hid/ishtp-hid.h
@@ -118,7 +118,7 @@ struct report_list {
  * @multi_packet_cnt:	Count of fragmented packet count
  *
  * This structure is used to store completion flags and per client data like
- * like report description, number of HID devices etc.
+ * report description, number of HID devices etc.
  */
 struct ishtp_cl_data {
 	/* completion flags */
-- 
2.35.1



