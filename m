Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39D42FAA24
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437083AbhART0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390419AbhARLiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0AE522C9D;
        Mon, 18 Jan 2021 11:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969831;
        bh=pHsrknxLbm2+TJwdXPtNjOIDAvP4x3BeYEw2KreNtEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leBYE2mK4mmG3nJAY05vve+kS0R/2rFylCaUINOI+ytCjoj/Aq8C+6YiWFqui43v8
         DR6D+fpjaqe2guA943FdZjhohHeHpz3KmGLOxcc3w1RZ2U765WfUP65yiwXGdYQmvM
         42ZGNYuUC/Ie3avgz3+vQo2AdOCPoN687TNsZOME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 43/43] kbuild: enforce -Werror=return-type
Date:   Mon, 18 Jan 2021 12:35:06 +0100
Message-Id: <20210118113337.013171620@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -438,7 +438,7 @@ KBUILD_AFLAGS   := -D__ASSEMBLY__
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common -fshort-wchar \
 		   -Werror-implicit-function-declaration \
-		   -Wno-format-security \
+		   -Werror=return-type -Wno-format-security \
 		   -std=gnu89
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_AFLAGS_KERNEL :=


