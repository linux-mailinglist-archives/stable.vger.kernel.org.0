Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0081A5B4A2E
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiIJV1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiIJV1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14364F68B;
        Sat, 10 Sep 2022 14:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C29BA601BD;
        Sat, 10 Sep 2022 21:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541C6C43470;
        Sat, 10 Sep 2022 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844766;
        bh=jaexKV/ISln6aKv9PrpU0ZKA7HGBT+BGvGa+IiQ2i6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A66CGHqUjdJlC8LObdMSzbqNx5anPCSn7FF6U6Ouu1WuzWbHGO17TdTU224oF/lF7
         d98dK6EkwhXH824kSR6ubqvavPxPnovH4X9Ae1lkWb4D7Y6VTe/rBFi2T8kUpR6u35
         NBUpbKVn89TxzHiBopwZchOE0RJGz5Y+7S73Da7d4iE9loNiy+HjQAqGYxDDIVR+m4
         9pZH2H8diM498vjTuXD/r/JGah2gQ9+/jhZUzJSKkvN4bZzQnze8CY26tGlGT33p6o
         kTOkg1tQQIsxIt2rZw68Z4RLzQThvltoSTY0CLw2Mz5q8iVMBacjUXfHFpGwf9qKGq
         mxvT9BFy7IaHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Wang <wangborong@cdjrlc.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>,
        srinivas.pandruvada@linux.intel.com, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/8] HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo
Date:   Sat, 10 Sep 2022 17:19:15 -0400
Message-Id: <20220910211921.70891-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211921.70891-1-sashal@kernel.org>
References: <20220910211921.70891-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

