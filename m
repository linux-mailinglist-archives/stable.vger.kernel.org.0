Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92318535CD0
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbiE0JDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350314AbiE0I7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:59:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E80579B3;
        Fri, 27 May 2022 01:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A5D1CE237A;
        Fri, 27 May 2022 08:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D59C34100;
        Fri, 27 May 2022 08:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641722;
        bh=m1t48f8J1t5GlS2HZ+kgwhOatWjtlZrYDKKdcmlt4Co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yo65ibpVD1mcKbt+cWT5Dr/0gbtYpiPtYVi3trLhuwM193y4deJ62PlMbP9ihrPGa
         YSaX+3B6nYCF0lql0mmdtGjayRTqpEm04Mto0cj9BQnFyRU4wfyg/EOlSGgUckIIc1
         bsNi+sMNfEZOl/7d9D76Fy5NRA0gFTF0PhBl19p8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 026/111] random: add proper SPDX header
Date:   Fri, 27 May 2022 10:48:58 +0200
Message-Id: <20220527084823.206306225@linuxfoundation.org>
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

commit a07fdae346c35c6ba286af1c88e0effcfa330bf9 upstream.

Convert the current license into the SPDX notation of "(GPL-2.0 OR
BSD-3-Clause)". This infers GPL-2.0 from the text "ALTERNATIVELY, this
product may be distributed under the terms of the GNU General Public
License, in which case the provisions of the GPL are required INSTEAD OF
the above restrictions" and it infers BSD-3-Clause from the verbatim
BSD 3 clause license in the file.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1,44 +1,9 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 /*
- * random.c -- A strong random number generator
- *
  * Copyright (C) 2017-2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
- *
  * Copyright Matt Mackall <mpm@selenic.com>, 2003, 2004, 2005
- *
  * Copyright Theodore Ts'o, 1994, 1995, 1996, 1997, 1998, 1999.  All
  * rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, and the entire permission notice in its entirety,
- *    including the disclaimer of warranties.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The name of the author may not be used to endorse or promote
- *    products derived from this software without specific prior
- *    written permission.
- *
- * ALTERNATIVELY, this product may be distributed under the terms of
- * the GNU General Public License, in which case the provisions of the GPL are
- * required INSTEAD OF the above restrictions.  (This clause is
- * necessary due to a potential bad interaction between the GPL and
- * the restrictions contained in a BSD-style copyright.)
- *
- * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
- * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
- * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
- * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
- * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
- * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
  */
 
 /*


