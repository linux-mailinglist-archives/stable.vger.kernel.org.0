Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F485580D1
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiFWQxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiFWQxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:53:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE2B12613;
        Thu, 23 Jun 2022 09:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CE74B82490;
        Thu, 23 Jun 2022 16:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEA0C3411B;
        Thu, 23 Jun 2022 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003158;
        bh=Bv+xIPC3SbJTSVPMQ8rGVtTpPskdGB1ImBsO2eYtUMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlPACd7iOz6cshjbsqhRdf5WFdSYMHuRB5fLFgWqd4tyb1hiR9bCjx5kR4t37NtXg
         /gWZGxAiKdUWi02A3pGxQPMc14T73Ws1KTw00s9JnOWjjPip9+6ERH7Qk5HrupBCHb
         ony1nSKtVNZ7H/6dXmv2kjF9MMacZ/20SeWkomH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 149/264] hwrng: core - remove unused PFX macro
Date:   Thu, 23 Jun 2022 18:42:22 +0200
Message-Id: <20220623164348.280852697@linuxfoundation.org>
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

From: Corentin LABBE <clabbe.montjoie@gmail.com>

commit 079840bd13f793b915f6c8e44452eeb4a0aba8ba upstream.

This patch remove the unused PFX macro.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -25,7 +25,6 @@
 #include <asm/uaccess.h>
 
 #define RNG_MODULE_NAME		"hw_random"
-#define PFX			RNG_MODULE_NAME ": "
 
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;


