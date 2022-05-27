Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EA7535F98
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345750AbiE0Lje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351510AbiE0LjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:39:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8601269A8;
        Fri, 27 May 2022 04:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E727DB824D7;
        Fri, 27 May 2022 11:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53406C385A9;
        Fri, 27 May 2022 11:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651503;
        bh=aThohqI3+tLHQBF+zhv1hQ2mbcYDqYGaf7VMa0ZpgaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7QyT12oHTA9wwbkLVX4XIGMpMf7p6i/V9oAoDrOJKEC+8EYSqwOGdbVHbicdFXV7
         UapMDDhFGPvRi0/jv+AuSjbw1iOWbSXmiotnDIWSOfzCrJkFmH6iR6MQb5+MCv2r5a
         K9YoLCEW9Lt9iq2N2EoFQYOYwSNOY9tddaOFVgoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 018/163] crypto: blake2s - remove unneeded includes
Date:   Fri, 27 May 2022 10:48:18 +0200
Message-Id: <20220527084830.706787393@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit df412e7efda1e2c5b5fcb06701bba77434cbd1e8 upstream.

It doesn't make sense for the generic implementation of BLAKE2s to
include <crypto/internal/simd.h> and <linux/jump_label.h>, as these are
things that would only be useful in an architecture-specific
implementation.  Remove these unnecessary includes.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/blake2s_generic.c |    2 --
 1 file changed, 2 deletions(-)

--- a/crypto/blake2s_generic.c
+++ b/crypto/blake2s_generic.c
@@ -4,11 +4,9 @@
  */
 
 #include <crypto/internal/blake2s.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/hash.h>
 
 #include <linux/types.h>
-#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 


