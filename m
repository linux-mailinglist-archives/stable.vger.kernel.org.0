Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CC43CAB71
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244736AbhGOTUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244760AbhGOTSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:18:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8D5361410;
        Thu, 15 Jul 2021 19:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376393;
        bh=z5CRr9uHvX/YCjApLw/rtBTEcqZGDMlsFP/f3WWWQy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFhCvMxvhCTz3wkiMMu4KFs4k9wSEKT/3+nBFnK3C4ajamEKL/k5QGrE9nYttUgSS
         d4vI+9aWafzWKfJgUVx7pbUc3w/uRSUAm1QsKo4kee8Nn4sv8ycOQZ1+s/5odYJVs1
         czYq+LYA3D9fHIYdlBEIiD5FAM5BMI0xSiZ03u0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.13 211/266] docs: Makefile: Use CONFIG_SHELL not SHELL
Date:   Thu, 15 Jul 2021 20:39:26 +0200
Message-Id: <20210715182647.036264216@linuxfoundation.org>
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


