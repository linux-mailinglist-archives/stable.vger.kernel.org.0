Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F20395F95
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhEaONG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhEaOLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85B4961459;
        Mon, 31 May 2021 13:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468460;
        bh=TQ1JQL4GbrtX2PfHGZCt7VdT0YbSfHC2BDFnkNa+D7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9lxQDIkJq4c3ETaEkXv4ZGTjgGqiS1R8Biu0tx4uwjzRGFdjUP6ydlSIwNmOyiZM
         kjWUcznkbDy86w2SPPQQSYupgdcHHYsjx0v6Mul3HgXrTWWG/PaFn0YHLpPaTFI1fR
         67aR9lBMWzWFM053oIyLvp1WFv763VJUIm+43mek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 250/252] scripts/clang-tools: switch explicitly to Python 3
Date:   Mon, 31 May 2021 15:15:15 +0200
Message-Id: <20210531130706.484285599@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 074075aea2ff72dade5231b4ee9f2ab9a055f1ec upstream.

For the same reason as commit 51839e29cb59 ("scripts: switch explicitly
to Python 3"), switch some more scripts, which I tested and confirmed
working on Python 3.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/clang-tools/gen_compile_commands.py |    2 +-
 scripts/clang-tools/run-clang-tools.py      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/clang-tools/gen_compile_commands.py
+++ b/scripts/clang-tools/gen_compile_commands.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 #
 # Copyright (C) Google LLC, 2018
--- a/scripts/clang-tools/run-clang-tools.py
+++ b/scripts/clang-tools/run-clang-tools.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 #
 # Copyright (C) Google LLC, 2020


