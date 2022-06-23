Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E23D558597
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbiFWR7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236159AbiFWR6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:58:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2074F1D7;
        Thu, 23 Jun 2022 10:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87B74B824B9;
        Thu, 23 Jun 2022 17:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763F2C3411B;
        Thu, 23 Jun 2022 17:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004571;
        bh=/ZmgAz/yF4n7uDYfBU2W7fDHZpOoFzytYqX2t0cr/gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUVOxOZeBWcIxz3FG0KM15ZQKZGpZcDV48F+v7JQLJBNT3SV4CI6Va+vEFtF5rR0G
         q5tShvmFplteptB3lbhVMAjgEzYmVpAtNZDB/9xibk/BorDsn7+6LL1hNJnmYUeGMA
         LgwvJj390eK1YN2nC5Vfu2YRMg8DP/VBeeQ/8ikw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Mark Brown <broonie@kernel.org>, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 039/234] linux/random.h: Use false with bool
Date:   Thu, 23 Jun 2022 18:41:46 +0200
Message-Id: <20220623164344.171237654@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Henderson <richard.henderson@linaro.org>

commit 66f5ae899ada79c0e9a3d8d954f93a72344cd350 upstream.

Keep the generic fallback versions in sync with the other architecture
specific implementations and use the proper name for false.

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20200110145422.49141-6-broonie@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/random.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -120,19 +120,19 @@ unsigned long randomize_page(unsigned lo
 #else
 static inline bool arch_get_random_long(unsigned long *v)
 {
-	return 0;
+	return false;
 }
 static inline bool arch_get_random_int(unsigned int *v)
 {
-	return 0;
+	return false;
 }
 static inline bool arch_get_random_seed_long(unsigned long *v)
 {
-	return 0;
+	return false;
 }
 static inline bool arch_get_random_seed_int(unsigned int *v)
 {
-	return 0;
+	return false;
 }
 #endif
 


