Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3961558177
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiFWRAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiFWQ6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:58:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A9D2ED58;
        Thu, 23 Jun 2022 09:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27878CE25E7;
        Thu, 23 Jun 2022 16:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B1DC341C4;
        Thu, 23 Jun 2022 16:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003235;
        bh=G3cOUEmvk4NKvA6Zx2B0hlXdyqOnbcjiu2clXc5EBOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VW9ZTLiS9Ed7KDKe1kMT45OVErUjvuSHv7xXxOMLOlsZXL7KZJSPmSI3SGW0j9yME
         CVTdcJaInRlvuv14NscTVCbsKXdavM7rUitewSbJofSuYDSq6fQ8a1xMP11tLIeikT
         a4PP16GcgAPl33oGgcRnxrrkZBKP8g/35Lgsg/LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 133/264] random: remove whitespace and reorder includes
Date:   Thu, 23 Jun 2022 18:42:06 +0200
Message-Id: <20220623164347.829005451@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 87e7d5abad0cbc9312dea7f889a57d294c1a5fcc upstream.

This is purely cosmetic. Future work involves figuring out which of
these headers we need and which we don't.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -196,7 +196,6 @@
 #include <linux/uuid.h>
 #include <crypto/chacha20.h>
 #include <crypto/blake2s.h>
-
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>


