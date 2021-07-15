Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE7D3CAB3D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244208AbhGOTSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243965AbhGOTQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:16:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09C47613D0;
        Thu, 15 Jul 2021 19:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376339;
        bh=sxeWXK9/YKizUNdUotgqt9AIZTxWnYMASNYAdk3TRhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n87vHVpCTzyZHJ6FMfSnNLvLKxMWU6XuYKXFalc5hFJpRSi0ENaleLjEPBhkRyjgx
         1tEV7FJB2iQyUsZoFaWq18Dc8EIVYxTgi6ifUl2zX6cAysZEGqTggNnyaolpnp6JRi
         BrkJ6obD0pHCv9y2fWU77VPbFR2kF3fVE/WphaqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.13 229/266] selftests/lkdtm: Fix expected text for CR4 pinning
Date:   Thu, 15 Jul 2021 20:39:44 +0200
Message-Id: <20210715182649.623039848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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


