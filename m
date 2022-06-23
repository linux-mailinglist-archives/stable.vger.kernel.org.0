Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB5C558160
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiFWQ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiFWQ6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4024EDEF;
        Thu, 23 Jun 2022 09:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 263E961F90;
        Thu, 23 Jun 2022 16:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D087BC3411B;
        Thu, 23 Jun 2022 16:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003230;
        bh=dFCsBs52RyVBTsB4B2q01Ax5YZX+Pkr7BvVsGXWOwUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTjTPuCSmGplDHeiixThvAnfhhwmjbPQLmLakrB8IwtnOq+7Fh/abAqkutmJnGbDN
         gaiQJAqSlrCk+WP0gigK2RQoKFb70NipSlIgGx5xbv5YBN5WJ3I7IpPatPiOwi3Bpi
         /nIy6sluns91bRR5qPtXd1XqynyFRN/I4Mr35p8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 132/264] random: remove useless header comment
Date:   Thu, 23 Jun 2022 18:42:05 +0200
Message-Id: <20220623164347.801089853@linuxfoundation.org>
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

commit 6071a6c0fba2d747742cadcbb3ba26ed756ed73b upstream.

This really adds nothing at all useful.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/random.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -1,8 +1,5 @@
-/*
- * include/linux/random.h
- *
- * Include file for the random number generator.
- */
+/* SPDX-License-Identifier: GPL-2.0 */
+
 #ifndef _LINUX_RANDOM_H
 #define _LINUX_RANDOM_H
 


