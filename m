Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340EE3C9F98
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhGONm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhGONm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 09:42:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 096BB61167;
        Thu, 15 Jul 2021 13:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626356373;
        bh=88CSbjAcCch0fdyjinFn1v7DBk1PG0ftyesxoV7TIHc=;
        h=Subject:To:Cc:From:Date:From;
        b=rJhuTFldYY3JwGbN2lkuEV/sdoMldGU2CqlnlcVuxVuTkmyufln9u71+9dZoU1LOo
         GIVaNwSEXceYK3+VnW9LwNLtxrx1Y2bBJws10srsdoF5alt7tGf7WjzeGUAnYzypO9
         5sko5Ji0VQsTcV7t/ndg+OOmocWZsihBZzRaTbdY=
Subject: FAILED: patch "[PATCH] selftests/lkdtm: Fix expected text for CR4 pinning" failed to apply to 5.4-stable tree
To:     keescook@chromium.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 15:39:31 +0200
Message-ID: <16263563716527@kroah.com>
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

From c2eb472bbe25b3f360990f23b293b3fbadfa4bc0 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Wed, 23 Jun 2021 13:39:29 -0700
Subject: [PATCH] selftests/lkdtm: Fix expected text for CR4 pinning

The error text for CR4 pinning changed. Update the test to match.

Fixes: a13b9d0b9721 ("x86/cpu: Use pinning mask for CR4 bits needing to be 0")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210623203936.3151093-3-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/tools/testing/selftests/lkdtm/tests.txt b/tools/testing/selftests/lkdtm/tests.txt
index 11ef159be0fd..a5fce7fd4520 100644
--- a/tools/testing/selftests/lkdtm/tests.txt
+++ b/tools/testing/selftests/lkdtm/tests.txt
@@ -11,7 +11,7 @@ CORRUPT_LIST_ADD list_add corruption
 CORRUPT_LIST_DEL list_del corruption
 STACK_GUARD_PAGE_LEADING
 STACK_GUARD_PAGE_TRAILING
-UNSET_SMEP CR4 bits went missing
+UNSET_SMEP pinned CR4 bits changed:
 DOUBLE_FAULT
 CORRUPT_PAC
 UNALIGNED_LOAD_STORE_WRITE

