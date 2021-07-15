Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4DD3CA94E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242921AbhGOTGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242642AbhGOTFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D079D61419;
        Thu, 15 Jul 2021 19:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375673;
        bh=z5CRr9uHvX/YCjApLw/rtBTEcqZGDMlsFP/f3WWWQy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IoxwSwFlt/YatfRIoHJrUyDNOBcZpvqdbYSdFAGJmFCBBoDuCcLOouCH+Onn2z7bj
         LWIPZhM68fzW8/b6FIAn44VosQTxM8Xek32Drfp55Ol1z7BAxfTO2Pj6dZsnA3NlJt
         jq+twZNXPln3nRkBaGrlE0OPgGs9M+hdtYUI3MPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.12 187/242] docs: Makefile: Use CONFIG_SHELL not SHELL
Date:   Thu, 15 Jul 2021 20:39:09 +0200
Message-Id: <20210715182626.199924247@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 222a28edce38b62074a950fb243df621c602b4d3 upstream.

Fix think-o about which variable to find the Kbuild-configured shell.
This has accidentally worked due to most shells setting $SHELL by
default.

Fixes: 51e46c7a4007 ("docs, parallelism: Rearrange how jobserver reservations are made")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210617225808.3907377-1-keescook@chromium.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -76,7 +76,7 @@ quiet_cmd_sphinx = SPHINX  $@ --> file:/
 	PYTHONDONTWRITEBYTECODE=1 \
 	BUILDDIR=$(abspath $(BUILDDIR)) SPHINX_CONF=$(abspath $(srctree)/$(src)/$5/$(SPHINX_CONF)) \
 	$(PYTHON3) $(srctree)/scripts/jobserver-exec \
-	$(SHELL) $(srctree)/Documentation/sphinx/parallel-wrapper.sh \
+	$(CONFIG_SHELL) $(srctree)/Documentation/sphinx/parallel-wrapper.sh \
 	$(SPHINXBUILD) \
 	-b $2 \
 	-c $(abspath $(srctree)/$(src)) \


