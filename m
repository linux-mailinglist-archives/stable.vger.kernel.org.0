Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18065582EE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiFWRWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbiFWRVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:21:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5384F451;
        Thu, 23 Jun 2022 10:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EC6DB8248A;
        Thu, 23 Jun 2022 17:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88A9C3411B;
        Thu, 23 Jun 2022 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003651;
        bh=amzlClXxyJSh6kQP6zvX0A/wwpXxlbtk5JoURIuaegg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bku2acgAzWYbdzFJRaiTcWA/7V5zzm66G2PLANoxo4WTy0PQVZ27wU/bEo7TFY49A
         F4Sd4eMvSnS7wRfQKRdi0YhDGvvgmrYBG5+357rTJeT4u/EPDFJZQJ5bOYanpVBxkR
         /0zlLGNxf8umWDVQHYLTbbvUYVKb28EYtwjN9vQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 042/237] random: fix typo in add_timer_randomness()
Date:   Thu, 23 Jun 2022 18:41:16 +0200
Message-Id: <20220623164344.365053666@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

From: Yangtao Li <tiny.windzz@gmail.com>

commit 727d499a6f4f29b6abdb635032f5e53e5905aedb upstream.

s/entimate/estimate

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20190607182517.28266-4-tiny.windzz@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1211,7 +1211,7 @@ static void add_timer_randomness(struct
 	/*
 	 * delta is now minimum absolute delta.
 	 * Round down by 1 bit on general principles,
-	 * and limit entropy entimate to 12 bits.
+	 * and limit entropy estimate to 12 bits.
 	 */
 	credit_entropy_bits(r, min_t(int, fls(delta>>1), 11));
 }


