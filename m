Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF8D551C1B
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347899AbiFTNlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349527AbiFTNjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45762A427;
        Mon, 20 Jun 2022 06:15:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6773D61171;
        Mon, 20 Jun 2022 13:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517FAC36AEC;
        Mon, 20 Jun 2022 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730901;
        bh=gRkETQJvr2FxHDr9oXch+XuY+cPLZ3ZZHS7YjlX3Skc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5M+qOiSU/uLYUyeT2z0HSM7Cck4wIfZOBzPslx/nZxP017CfbpVrSE8Mrw7e0RxA
         naTZ9KhV6C/JTK3wqqP9To7dml6Pr0JEFLxJMQzJ12djqPDUl8CtMU4fhCnM7K7u6j
         soY1BqD8Z7oJCXozXKF55vC9eleDGsusZGwE0NDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 091/240] random: remove useless header comment
Date:   Mon, 20 Jun 2022 14:49:52 +0200
Message-Id: <20220620124741.650491692@linuxfoundation.org>
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

commit 6071a6c0fba2d747742cadcbb3ba26ed756ed73b upstream.

This really adds nothing at all useful.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/random.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -1,9 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*
- * include/linux/random.h
- *
- * Include file for the random number generator.
- */
+
 #ifndef _LINUX_RANDOM_H
 #define _LINUX_RANDOM_H
 


