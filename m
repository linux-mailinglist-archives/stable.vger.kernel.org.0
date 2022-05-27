Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1A453615D
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348504AbiE0L6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353258AbiE0L4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5FF6D86B;
        Fri, 27 May 2022 04:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AD395CE251C;
        Fri, 27 May 2022 11:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5949C385A9;
        Fri, 27 May 2022 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652217;
        bh=Bm9uMf7PA3BLifaB9TdXmwHvLjkQieVHu4RNQJ9c2gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTkFie85Rge4bbaKumO+6meT7aJPjXu0J4PIAGa3nlpwHPPA8mVxsGWmhSaK9A5uu
         mF6iVgrnC+bECkiiZBJG+z3Hh19VP/dH2qd0K7KQXKbK4pCjpNzKEVV8xlWPuB5Wt5
         96BhCYUeIlmY62aFwM7ZDr0QLMMzuOb9B1mf6Wk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 102/145] random: fix sysctl documentation nits
Date:   Fri, 27 May 2022 10:50:03 +0200
Message-Id: <20220527084902.985343682@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 069c4ea6871c18bd368f27756e0f91ffb524a788 upstream.

A semicolon was missing, and the almost-alphabetical-but-not ordering
was confusing, so regroup these by category instead.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/sysctl/kernel.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1014,6 +1014,9 @@ This is a directory, with the following
 * ``boot_id``: a UUID generated the first time this is retrieved, and
   unvarying after that;
 
+* ``uuid``: a UUID generated every time this is retrieved (this can
+  thus be used to generate UUIDs at will);
+
 * ``entropy_avail``: the pool's entropy count, in bits;
 
 * ``poolsize``: the entropy pool size, in bits;
@@ -1021,10 +1024,7 @@ This is a directory, with the following
 * ``urandom_min_reseed_secs``: obsolete (used to determine the minimum
   number of seconds between urandom pool reseeding). This file is
   writable for compatibility purposes, but writing to it has no effect
-  on any RNG behavior.
-
-* ``uuid``: a UUID generated every time this is retrieved (this can
-  thus be used to generate UUIDs at will);
+  on any RNG behavior;
 
 * ``write_wakeup_threshold``: when the entropy count drops below this
   (as a number of bits), processes waiting to write to ``/dev/random``


