Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A316538AA
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 23:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiLUWcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 17:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbiLUWcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 17:32:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1632BCA;
        Wed, 21 Dec 2022 14:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AD0D0CE18B0;
        Wed, 21 Dec 2022 22:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7F9C433EF;
        Wed, 21 Dec 2022 22:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671661951;
        bh=vpTFTUZoLPL9QqfSnfML4gvTqf7OWx0P7wC6jwby11k=;
        h=Date:To:From:Subject:From;
        b=TnhtidT61gBqmWaiI4X5cbx+eGfPWUlLSGvh2c4OZZz88g2oIHrCfVWW9oVs8w579
         pO+unP/bZ5iEzALMPo91bmY5TlY7AhGrlxmaxyfYSgx+ntuPonq0Tr4ZsJByk2/rHP
         6OjzV1LVdOVfPh0MVQwjjTVW4uX/f5oVHnjmiNf8=
Date:   Wed, 21 Dec 2022 14:32:30 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kmsan-export-kmsan_handle_urb.patch removed from -mm tree
Message-Id: <20221221223230.DF7F9C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: kmsan: export kmsan_handle_urb
has been removed from the -mm tree.  Its filename was
     kmsan-export-kmsan_handle_urb.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kmsan: export kmsan_handle_urb
Date: Thu, 15 Dec 2022 17:26:57 +0100

USB support can be in a loadable module, and this causes a link failure
with KMSAN:

ERROR: modpost: "kmsan_handle_urb" [drivers/usb/core/usbcore.ko] undefined!

Export the symbol so it can be used by this module.

Link: https://lkml.kernel.org/r/20221215162710.3802378-1-arnd@kernel.org
Fixes: 553a80188a5d ("kmsan: handle memory sent to/from USB")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/hooks.c~kmsan-export-kmsan_handle_urb
+++ a/mm/kmsan/hooks.c
@@ -260,6 +260,7 @@ void kmsan_handle_urb(const struct urb *
 					       urb->transfer_buffer_length,
 					       /*checked*/ false);
 }
+EXPORT_SYMBOL_GPL(kmsan_handle_urb);
 
 static void kmsan_handle_dma_page(const void *addr, size_t size,
 				  enum dma_data_direction dir)
_

Patches currently in -mm which might be from arnd@arndb.de are


