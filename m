Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A605B4915
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiIJVRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiIJVQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:16:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A1C4C62F;
        Sat, 10 Sep 2022 14:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B28F60DF0;
        Sat, 10 Sep 2022 21:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55DCC433D6;
        Sat, 10 Sep 2022 21:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844600;
        bh=CDsStmIrPeAHmX1Ml4M5Nc0oNw9u01LP4Yp6v594aKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJkx2DVEAjyAFlU3BEN0623n25rk3/Sb+WhOIPLPHkax8LicglqCmJmhvNJIzU6U8
         ztHf9C101mUQqQSXUde5Yaw5yBusDcUvebtJCVLgfo0GIFJV6Z0g35B4f+t88JUm81
         Kh9xCXJTjlSfQWGv0+lmjZiwZ7tDbyr94F9mNPejL0utyLpK2DsH5GV39cNXSyhmpL
         xTnL200osrTw2PZBWO21xZgEsF6TAUiBioHyYNSu109TgzwaEoXb7ykS/1ospuVtRB
         pMqC5g/YfyJYYIP1oXk6IZjJ9752ww1LilaKdO5ImcZvVbxkoCh7aeE5XTMZezPFP5
         RujD1NwGee2AQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Wang <wangborong@cdjrlc.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>,
        srinivas.pandruvada@linux.intel.com, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 10/38] HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo
Date:   Sat, 10 Sep 2022 17:15:55 -0400
Message-Id: <20220910211623.69825-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
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
index 6a5cc11aefd89..35dddc5015b37 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid.h
+++ b/drivers/hid/intel-ish-hid/ishtp-hid.h
@@ -105,7 +105,7 @@ struct report_list {
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

