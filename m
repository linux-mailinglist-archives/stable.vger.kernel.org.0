Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC0F558068
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiFWQrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbiFWQrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:47:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0321F49936;
        Thu, 23 Jun 2022 09:47:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 908AC61F90;
        Thu, 23 Jun 2022 16:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78340C3411B;
        Thu, 23 Jun 2022 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002821;
        bh=eWlgOcz+WbIdgP9CVmzTZ5AhYUglor+Lw72dPLC4iZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ereMvCiIbMOzIyd3Es2Doa6B+3CGUqPYqU2BnxfyB64gn/j7PoSIfB3KFyFdR+nBS
         9VRRplk6pgVQasgtRKxrF8UPE9cagmPW1/duBCXf96PpmkC5tAagWzR8PFKnUJUuGU
         7T9LvUaifRtaZ11B5pzRR9/e+Z1FxKvyBaGc/J7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 036/264] drivers/char/random.c: constify poolinfo_table
Date:   Thu, 23 Jun 2022 18:40:29 +0200
Message-Id: <20220623164345.090560238@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 26e0854ab3310bbeef1ed404a2c87132fc91f8e1 upstream.

Never modified, might as well be put in .rodata.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -360,7 +360,7 @@ static int random_write_wakeup_bits = 28
  * polynomial which improves the resulting TGFSR polynomial to be
  * irreducible, which we have made here.
  */
-static struct poolinfo {
+static const struct poolinfo {
 	int poolbitshift, poolwords, poolbytes, poolbits, poolfracbits;
 #define S(x) ilog2(x)+5, (x), (x)*4, (x)*32, (x) << (ENTROPY_SHIFT+5)
 	int tap1, tap2, tap3, tap4, tap5;


