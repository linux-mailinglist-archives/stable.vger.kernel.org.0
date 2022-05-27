Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553685360B1
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiE0Lw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352930AbiE0LvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:51:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993843D1D8;
        Fri, 27 May 2022 04:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCAB6B824D2;
        Fri, 27 May 2022 11:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C470C385A9;
        Fri, 27 May 2022 11:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651984;
        bh=PI9wF56zKrfi07MLCXgjjjfQXCRyWevrkV50RAwJeS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/EzQ5u/qla2a8ndttpNSYFlpqnBPcjQQjwK5gExu+ozO2g//ZpH0npKVfxclnlWc
         DsFQDtPEZAYcHvx5DSZ3/kZ8iJvgJKD2G8GGeTNeXECQbyBMiRUjrsJQMbC83Tl53N
         FyULxW83GA+ss7iBUnB+q+GbVg2WIXFQ3Gt8jXKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 065/145] random: remove whitespace and reorder includes
Date:   Fri, 27 May 2022 10:49:26 +0200
Message-Id: <20220527084858.386368412@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
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


