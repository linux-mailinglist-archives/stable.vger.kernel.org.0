Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82625580D0
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiFWQxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiFWQwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:52:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81160767E;
        Thu, 23 Jun 2022 09:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39010B8248F;
        Thu, 23 Jun 2022 16:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8495BC341C5;
        Thu, 23 Jun 2022 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003153;
        bh=b9t6lL+INKNOFLpFIcHfpH8GJGOZCDDRQxD+dRkzac8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jt7LnmEt4TtPSYbvL+zfhksgJFIrUFtAr/InYRCYVzD21yBYK85sHmy1hTNzRYw7R
         0AFx+K4kEFWRrQOzlIBBUUJoiP3Pr/wcg2NS7kC9oA0uyB0X1bAq9AaUpFvdgoBANJ
         QtWrZ1+lC7bs2ZtICeOW3UxJ3dVpkRi1nuvlL1Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 147/264] hwrng: core - Rewrite the header
Date:   Thu, 23 Jun 2022 18:42:20 +0200
Message-Id: <20220623164348.223959283@linuxfoundation.org>
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

commit dd8014830d2b1fdf5328978ada706df3ec180c21 upstream.

checkpatch have lot of complaint about header.
Furthermore, the header have some offtopic/useless information.

This patch rewrite a proper header.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/core.c |   38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -1,33 +1,13 @@
 /*
-        Added support for the AMD Geode LX RNG
-	(c) Copyright 2004-2005 Advanced Micro Devices, Inc.
-
-	derived from
-
- 	Hardware driver for the Intel/AMD/VIA Random Number Generators (RNG)
-	(c) Copyright 2003 Red Hat Inc <jgarzik@redhat.com>
-
- 	derived from
-
-        Hardware driver for the AMD 768 Random Number Generator (RNG)
-        (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
-
- 	derived from
-
-	Hardware driver for Intel i810 Random Number Generator (RNG)
-	Copyright 2000,2001 Jeff Garzik <jgarzik@pobox.com>
-	Copyright 2000,2001 Philipp Rumpf <prumpf@mandrakesoft.com>
-
-	Added generic RNG API
-	Copyright 2006 Michael Buesch <m@bues.ch>
-	Copyright 2005 (c) MontaVista Software, Inc.
-
-	Please read Documentation/hw_random.txt for details on use.
-
-	----------------------------------------------------------
-	This software may be used and distributed according to the terms
-        of the GNU General Public License, incorporated herein by reference.
-
+ * hw_random/core.c: HWRNG core API
+ *
+ * Copyright 2006 Michael Buesch <m@bues.ch>
+ * Copyright 2005 (c) MontaVista Software, Inc.
+ *
+ * Please read Documentation/hw_random.txt for details on use.
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
  */
 
 #include <linux/device.h>


