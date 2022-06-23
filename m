Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B97E558542
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiFWRy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiFWRxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:53:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532FDAA33E;
        Thu, 23 Jun 2022 10:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D44B861DDC;
        Thu, 23 Jun 2022 17:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94227C341C4;
        Thu, 23 Jun 2022 17:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004461;
        bh=2XrBjZ9r1JiQmbgW7MJXyVhxs+2lGIZGcEAZKhkzzC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MneT1sQS3bCPlE6c6lIlbNDjVnKlpmsNlcbw912Oq5XOSoYuRSotWDoLn2Ooclvr8
         kLK3dRkU0AgLQZqWkuN98fd4fHRec1+NzbW2t598AarWYX53iVmvAbE1lgsSGg1421
         bNJed6dp5vTx75U5SxP/YlnCdWqJifhmFgzkea1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 046/234] crypto: blake2s - include <linux/bug.h> instead of <asm/bug.h>
Date:   Thu, 23 Jun 2022 18:41:53 +0200
Message-Id: <20220623164344.370161937@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit bbda6e0f1303953c855ee3669655a81b69fbe899 upstream.

Address the following checkpatch warning:

	WARNING: Use #include <linux/bug.h> instead of <asm/bug.h>

Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/blake2s.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -6,12 +6,11 @@
 #ifndef BLAKE2S_H
 #define BLAKE2S_H
 
+#include <linux/bug.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 
-#include <asm/bug.h>
-
 enum blake2s_lengths {
 	BLAKE2S_BLOCK_SIZE = 64,
 	BLAKE2S_HASH_SIZE = 32,


