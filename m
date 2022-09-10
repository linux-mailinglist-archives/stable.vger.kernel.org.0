Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05DC5B4995
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiIJVVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiIJVUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D38D4F649;
        Sat, 10 Sep 2022 14:18:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E941EB8092F;
        Sat, 10 Sep 2022 21:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26FEC433D6;
        Sat, 10 Sep 2022 21:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844684;
        bh=CDsStmIrPeAHmX1Ml4M5Nc0oNw9u01LP4Yp6v594aKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSrpVsE30tUl29WaACvrmaubzK2nA5T2UBssfHDwXx00N0yJWK3EA/i6CSRUVkpVU
         2ke/j5w3PaiAzHrWe8eDtn4xukgveo5Io4+7vVVrNpzXW059U7sNwYWAL6tdS6TAeO
         AAt+gQVh85KYzCCK/6nrA2hsBTORAVAiuir3ddgKdTCNHf1huZZZCR8FU0pHdRgmga
         4dkOlmMJQs4SDApmNzwHeTcQXy79B2SWCF+FAXOirp+1vMiEjAfmd6bFsdbo4HSWMV
         w3Yq5qFQp4CX/8v+OL6e/BIOHgp53C/WWrvc+FzWzPFmI+t4s+DFYCG427thZUk8kA
         ZQdKjeNXeRuYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Wang <wangborong@cdjrlc.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>,
        srinivas.pandruvada@linux.intel.com, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/21] HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo
Date:   Sat, 10 Sep 2022 17:17:38 -0400
Message-Id: <20220910211752.70291-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
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

