Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AC1412537
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382783AbhITSmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382336AbhITSkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC737614C8;
        Mon, 20 Sep 2021 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159066;
        bh=uPKAT3YKWHt2IcxCoKpHMe+GaRVzNlVrPnJhuZgcJPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxYDtIRxrC/qstJfscq8rTfxhPEyu3Z7mLCGAVO1JnGFTKFKsUlvgjB+tQ3Y/5vGm
         DdI3UI/j8tE2WwXldiiRrJABAlKaQuliMR0TCFFZ7GeRYO2CWxIb7ckrTlI4XZh/jh
         p/tqwavWUvAkuqMOQBqe/E1/ZlCCCXl9KO1zu+Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kortan <kortanzh@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.14 059/168] gen_compile_commands: fix missing sys package
Date:   Mon, 20 Sep 2021 18:43:17 +0200
Message-Id: <20210920163923.580466564@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kortan <kortanzh@gmail.com>

commit ec783c7cb2495c5a3b8ca10db8056d43c528f940 upstream.

We need to import the 'sys' package since the script has called
sys.exit() method.

Fixes: 6ad7cbc01527 ("Makefile: Add clang-tidy and static analyzer support to makefile")
Signed-off-by: Kortan <kortanzh@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/clang-tools/gen_compile_commands.py |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/clang-tools/gen_compile_commands.py
+++ b/scripts/clang-tools/gen_compile_commands.py
@@ -13,6 +13,7 @@ import logging
 import os
 import re
 import subprocess
+import sys
 
 _DEFAULT_OUTPUT = 'compile_commands.json'
 _DEFAULT_LOG_LEVEL = 'WARNING'


