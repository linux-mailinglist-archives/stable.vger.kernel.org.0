Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F3D551D4F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348435AbiFTNu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350471AbiFTNtT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:49:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE472FFE5;
        Mon, 20 Jun 2022 06:18:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5B2060FF1;
        Mon, 20 Jun 2022 13:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EDCC3411B;
        Mon, 20 Jun 2022 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731023;
        bh=BevbwWX2OSD1W1/1qk/rCqhmGFAAMpSJAO781kxqSM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tmdx3iktU6gXyVnlpq4cfz1+vEZiM8v2k5kI2dNPzsfQYKvPSyYkTlSrKZpTR8Og/
         lJaQbH6KLr9vfShoE1SQQKllDerD3Im69a4QJwXjTRSBTkpTpwIIEeNV+i3Qcfx/CO
         tH3c5Z0yWwxYEg13PWWcU2DuB50yFmW6dJpvowKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 129/240] random: fix sysctl documentation nits
Date:   Mon, 20 Jun 2022 14:50:30 +0200
Message-Id: <20220620124742.750178728@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
 Documentation/admin-guide/sysctl/kernel.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -876,6 +876,9 @@ This is a directory, with the following
 * ``boot_id``: a UUID generated the first time this is retrieved, and
   unvarying after that;
 
+* ``uuid``: a UUID generated every time this is retrieved (this can
+  thus be used to generate UUIDs at will);
+
 * ``entropy_avail``: the pool's entropy count, in bits;
 
 * ``poolsize``: the entropy pool size, in bits;
@@ -883,10 +886,7 @@ This is a directory, with the following
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


