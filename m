Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFE95360BA
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352244AbiE0LxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353115AbiE0LvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:51:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E35140868;
        Fri, 27 May 2022 04:46:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0EC47CE1164;
        Fri, 27 May 2022 11:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17906C385A9;
        Fri, 27 May 2022 11:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652008;
        bh=PI9wF56zKrfi07MLCXgjjjfQXCRyWevrkV50RAwJeS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAzCPGXiQokkeIUQgouOrTxRw0gjg6Yz/V46x8lAK/I60cgljHRr7QYCO174nf7Aj
         tg1w0iQO2kdljfFwaB0pzLw3H3LYuwlUBTVeXZlBpXm388XQvYIzIzLRCrhqmAFToh
         +TCgUTgvPCamWYU0O9Gx0B+cNHVqwkV4v9IyvkPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 083/163] random: remove whitespace and reorder includes
Date:   Fri, 27 May 2022 10:49:23 +0200
Message-Id: <20220527084839.447777444@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 87e7d5abad0cbc9312dea7f889a57d294c1a5fcc upstream.

This is purely cosmetic. Future work involves figuring out which of
these headers we need and which we don't.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -193,11 +193,10 @@
 #include <linux/syscalls.h>
 #include <linux/completion.h>
 #include <linux/uuid.h>
+#include <linux/uaccess.h>
 #include <crypto/chacha.h>
 #include <crypto/blake2s.h>
-
 #include <asm/processor.h>
-#include <linux/uaccess.h>
 #include <asm/irq.h>
 #include <asm/irq_regs.h>
 #include <asm/io.h>


