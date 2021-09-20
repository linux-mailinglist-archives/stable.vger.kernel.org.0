Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117184123E2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379187AbhITS23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378788AbhITS00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDEE561283;
        Mon, 20 Sep 2021 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158745;
        bh=uPKAT3YKWHt2IcxCoKpHMe+GaRVzNlVrPnJhuZgcJPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iHDfwCcp/MkK7B6T8z7KYf93Riiz4thbjPY9VNx7UbSJm0iITX/fZ8N2vb280pCs
         d/2TNp1L0KFnREQGRIVojKPJxX+/0sURV3E8iFmLKg4ob/paRYydttbnnc+1p8geps
         Qr8cMz5P+I4X3hq+fwJYxz1NJ8JJye+k3oS2y3ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kortan <kortanzh@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 037/122] gen_compile_commands: fix missing sys package
Date:   Mon, 20 Sep 2021 18:43:29 +0200
Message-Id: <20210920163917.008142221@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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


