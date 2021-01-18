Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23332FA9EB
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436944AbhARTQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:16:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390453AbhARLiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3F69223E8;
        Mon, 18 Jan 2021 11:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969852;
        bh=Yl66Pt7UMHiUg3roCnhhp6N4/cvv1hSpqW3XIVekJGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uv9ElhMOpDNLLg86YP68lBCYNs7IuwyDQjH/PIeUaWaIJkIIZSCKzteJABXSLde0C
         B9z+vJNNOhVaI2il4egqTG/qWVCQC6yCgHV7WqiZTJz89clu9aJLoWBDHRNsJ+Jr9t
         Aq8TpNx6VaibjeS5m9PjVEhJP6hgYWSM7P8z2Vyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 5.4 01/76] kbuild: enforce -Werror=return-type
Date:   Mon, 18 Jan 2021 12:34:01 +0100
Message-Id: <20210118113341.059255538@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

commit 172aad81a882443eefe1bd860c4eddc81b14dd5b upstream.

Catch errors which at least gcc tolerates by default:
 warning: 'return' with no value, in function returning non-void [-Wreturn-type]

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -480,7 +480,7 @@ KBUILD_AFLAGS   := -D__ASSEMBLY__ -fno-P
 KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
 		   -Werror=implicit-function-declaration -Werror=implicit-int \
-		   -Wno-format-security \
+		   -Werror=return-type -Wno-format-security \
 		   -std=gnu89
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_AFLAGS_KERNEL :=


