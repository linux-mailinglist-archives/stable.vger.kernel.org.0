Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191D53C9FDA
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbhGONne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhGONnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 09:43:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D8C161167;
        Thu, 15 Jul 2021 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626356421;
        bh=DMnpQS8P9EMb009B/5EvzPzqeCvpYn2cHaL3ESM0bnc=;
        h=Subject:To:Cc:From:Date:From;
        b=DNRmUiP3SQLdrNoO7fdjnm+hnn7M4/ZOZKrO5XI7AsTyWxVYUb3VulrYB4KxwLKiq
         BFRE+O5D5c41N5yvPCMICPZBG0r2qfq6by4i2yegqxxpBtuV+r4WzSQ2arPTqENGAv
         obm5JuUWbixKzwjQPty+U8vO+aQIbRtjVfXo2dj0=
Subject: FAILED: patch "[PATCH] lkdtm: Enable DOUBLE_FAULT on all architectures" failed to apply to 5.4-stable tree
To:     keescook@chromium.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 15:40:11 +0200
Message-ID: <162635641113242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f123c42bbeff26bfe8bdb08a01307e92d51eec39 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Wed, 23 Jun 2021 13:39:33 -0700
Subject: [PATCH] lkdtm: Enable DOUBLE_FAULT on all architectures

Where feasible, I prefer to have all tests visible on all architectures,
but to have them wired to XFAIL. DOUBLE_FAIL was set up to XFAIL, but
wasn't actually being added to the test list.

Fixes: cea23efb4de2 ("lkdtm/bugs: Make double-fault test always available")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210623203936.3151093-7-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 645b31e98c77..2c89fc18669f 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -178,9 +178,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(STACKLEAK_ERASING),
 	CRASHTYPE(CFI_FORWARD_PROTO),
 	CRASHTYPE(FORTIFIED_STRSCPY),
-#ifdef CONFIG_X86_32
 	CRASHTYPE(DOUBLE_FAULT),
-#endif
 #ifdef CONFIG_PPC_BOOK3S_64
 	CRASHTYPE(PPC_SLB_MULTIHIT),
 #endif

