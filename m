Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5D7558075
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiFWQrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiFWQrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:47:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402564992A;
        Thu, 23 Jun 2022 09:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F143DB8248E;
        Thu, 23 Jun 2022 16:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E64AC3411B;
        Thu, 23 Jun 2022 16:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002830;
        bh=lW1c08ukeQAzXeoU4TLRtgkbf4eQNLv6V030ud35N/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PfMdT7s4Q/3Bqy5qnm0QtmHsV7VQaBRbL+yXYTQ2OV725l3riyKRpazoS3ovy/vDj
         UBgLjkyUzaNJMrxe0yD+1VCEkbzi0DycNONsnpRL6C1hnHSNcpLMsQ+6GeRPvXQjY/
         /o4MBQvSP4hZm6EFooa+5MZw/4g9znTyh52NSw48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 005/264] random: fix comment for unused random_min_urandom_seed
Date:   Thu, 23 Jun 2022 18:39:58 +0200
Message-Id: <20220623164344.211637838@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

From: "Stephan Müller" <smueller@chronox.de>

commit 5d0e5ea343a0f70351428476bcf8715e0731f26a upstream.

The variable random_min_urandom_seed is not needed any more as it
defined the reseeding behavior of the nonblocking pool. Though it is not
needed any more, it is left in the code for user space interface
compatibility.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -314,9 +314,7 @@ static int random_read_wakeup_bits = 64;
 static int random_write_wakeup_bits = 28 * OUTPUT_POOL_WORDS;
 
 /*
- * The minimum number of seconds between urandom pool reseeding.  We
- * do this to limit the amount of entropy that can be drained from the
- * input pool even if there are heavy demands on /dev/urandom.
+ * Variable is currently unused by left for user space compatibility.
  */
 static int random_min_urandom_seed = 60;
 


