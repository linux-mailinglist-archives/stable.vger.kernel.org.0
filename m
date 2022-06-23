Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3435583D5
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiFWRfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbiFWRf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:35:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0768C22F;
        Thu, 23 Jun 2022 10:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDD69B82499;
        Thu, 23 Jun 2022 17:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EDDC3411B;
        Thu, 23 Jun 2022 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003966;
        bh=2qmHMNf3gGkwSojxdQR7jXuUZbgIE+UA0FQlIEzkC+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0CM9rsPasFR6/BI/mfEAIsukH9AB36CcqjBPlBiO/NmFhqeSwRUXSFR4wnYnzdm6
         9S+wGdBH7k8Ao7T7tzzOZRO6JcQGoxahxtApyCr42Kj7o35f1A97cL/RdisJG8nNaZ
         F3nXih9vT32wnIB/T/vc5YI3XENhtzfFZfhTfMTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 146/237] random: fix sysctl documentation nits
Date:   Thu, 23 Jun 2022 18:43:00 +0200
Message-Id: <20220623164347.355497647@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 069c4ea6871c18bd368f27756e0f91ffb524a788 upstream.

A semicolon was missing, and the almost-alphabetical-but-not ordering
was confusing, so regroup these by category instead.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sysctl/kernel.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -795,6 +795,9 @@ This is a directory, with the following
 * ``boot_id``: a UUID generated the first time this is retrieved, and
   unvarying after that;
 
+* ``uuid``: a UUID generated every time this is retrieved (this can
+  thus be used to generate UUIDs at will);
+
 * ``entropy_avail``: the pool's entropy count, in bits;
 
 * ``poolsize``: the entropy pool size, in bits;
@@ -802,10 +805,7 @@ This is a directory, with the following
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


