Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7625582C8
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiFWRTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiFWRSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:18:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0769B55A;
        Thu, 23 Jun 2022 10:00:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DDA3B8248A;
        Thu, 23 Jun 2022 17:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97833C341C5;
        Thu, 23 Jun 2022 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003621;
        bh=3rZ4keeAZVuslG8FpTjQQGI8XwrSaROFMtyKvOT3rdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWl4n8MJfNAK2Pgp6vU3rGcGO5JbllFoSKkNrYzpNLI+oAUJ8/K3qFA5S8YEesIwt
         GpbZkGOYTcw5xaXMThEUPmovLIOa1NJo0wB4aWfhboTZVNnDWcrdQP/g6755aByrjA
         kcNOYuG5v87vsDkLk8se4C+0WtIlj24spfFf/73w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Tobin C. Harding" <me@tobin.cc>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 006/237] random: Fix whitespace pre random-bytes work
Date:   Thu, 23 Jun 2022 18:40:40 +0200
Message-Id: <20220623164343.329048734@linuxfoundation.org>
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

From: "Tobin C. Harding" <me@tobin.cc>

commit 8ddd6efa56c3fe23df9fe4cf5e2b49cc55416ef4 upstream.

There are a couple of whitespace issues around the function
get_random_bytes_arch().  In preparation for patching this function
let's clean them up.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tobin C. Harding <me@tobin.cc>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1742,7 +1742,7 @@ void get_random_bytes_arch(void *buf, in
 
 		if (!arch_get_random_long(&v))
 			break;
-		
+
 		memcpy(p, &v, chunk);
 		p += chunk;
 		nbytes -= chunk;
@@ -1753,7 +1753,6 @@ void get_random_bytes_arch(void *buf, in
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
-
 /*
  * init_std_data - initialize pool with system data
  *


