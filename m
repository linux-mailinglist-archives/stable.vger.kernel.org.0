Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044C83CA7CC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240385AbhGOS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241428AbhGOSzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8BA6613CA;
        Thu, 15 Jul 2021 18:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375167;
        bh=sxeWXK9/YKizUNdUotgqt9AIZTxWnYMASNYAdk3TRhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBsOsOuW2XmQ1/VxAusUds/XobxwGh3Ucz58zzYH4uvdR+mVQ8VGdDb+uovXFRh4N
         zqpYcjaBV9VOwXoillv8+HFkfjSEB+HM8yFvwBIp3iVfTlvJ8i2VYf1AtKMjj1Hgdg
         TIQ/20B0Q3Dr3SB9CIiMg2B6Bit1xYmAnpOMv3yM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 186/215] selftests/lkdtm: Fix expected text for CR4 pinning
Date:   Thu, 15 Jul 2021 20:39:18 +0200
Message-Id: <20210715182632.130526073@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit c2eb472bbe25b3f360990f23b293b3fbadfa4bc0 upstream.

The error text for CR4 pinning changed. Update the test to match.

Fixes: a13b9d0b9721 ("x86/cpu: Use pinning mask for CR4 bits needing to be 0")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210623203936.3151093-3-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/lkdtm/tests.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


