Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF0A536011
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351758AbiE0LoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351743AbiE0LnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:43:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191A013CA35;
        Fri, 27 May 2022 04:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10E8661D29;
        Fri, 27 May 2022 11:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A457C34100;
        Fri, 27 May 2022 11:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651639;
        bh=g9yd1PyzmAB4C6qyqGY7YgXtwOLALFzGRlSbehuBFGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZZGNpquLdX+M0VzOe+ZJV0/rIKQ1aKuFNwukLyasT8WBcE5DbA7cDqYOubSW5drr
         znGQQI9JkqrfvUQL/uoI3b5DWGhL30XeJNCXYuJeeCmpTOOpeC1ORh62dPQA4Cviii
         CazuBZCIWKRkFTC/JTbdxbLW3hyTuaoG4qjJ+bLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 067/111] random: fix sysctl documentation nits
Date:   Fri, 27 May 2022 10:49:39 +0200
Message-Id: <20220527084829.025720524@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
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
@@ -1025,6 +1025,9 @@ This is a directory, with the following
 * ``boot_id``: a UUID generated the first time this is retrieved, and
   unvarying after that;
 
+* ``uuid``: a UUID generated every time this is retrieved (this can
+  thus be used to generate UUIDs at will);
+
 * ``entropy_avail``: the pool's entropy count, in bits;
 
 * ``poolsize``: the entropy pool size, in bits;
@@ -1032,10 +1035,7 @@ This is a directory, with the following
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


