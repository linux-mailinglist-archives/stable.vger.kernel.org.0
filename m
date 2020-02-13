Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD8615C6DA
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgBMQEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:04:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbgBMPYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:01 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3043C24690;
        Thu, 13 Feb 2020 15:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607441;
        bh=bBRNU/XhX8hgq6uIAe2ranG1Tg5vXviudg/xQk03MkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytV2XzyOzHmRiaf3SGQAogXhXUw8Gq7VjaBV3vPrHjuG5jgmwB/uWgTjSy0NZ7jVG
         Z4Ur9lVe7aC+nhI3/GrmARDWukknCpjWs85FoA2PJzfM/x94JCs87z661GfszUQvNE
         L0aLI2343soj45BP+Xr4+jkpA8skQswU02sH4Tbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 062/116] powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize
Date:   Thu, 13 Feb 2020 07:20:06 -0800
Message-Id: <20200213151906.943052703@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit c3aae14e5d468d18dbb5d7c0c8c7e2968cc14aad upstream.

Clang warns:

../arch/powerpc/boot/4xx.c:231:3: warning: misleading indentation;
statement is not part of the previous 'else' [-Wmisleading-indentation]
        val = SDRAM0_READ(DDR0_42);
        ^
../arch/powerpc/boot/4xx.c:227:2: note: previous statement is here
        else
        ^

This is because there is a space at the beginning of this line; remove
it so that the indentation is consistent according to the Linux kernel
coding style and clang no longer warns.

Fixes: d23f5099297c ("[POWERPC] 4xx: Adds decoding of 440SPE memory size to boot wrapper library")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/ClangBuiltLinux/linux/issues/780
Link: https://lore.kernel.org/r/20191209200338.12546-1-natechancellor@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/boot/4xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/boot/4xx.c
+++ b/arch/powerpc/boot/4xx.c
@@ -232,7 +232,7 @@ void ibm4xx_denali_fixup_memsize(void)
 		dpath = 8; /* 64 bits */
 
 	/* get address pins (rows) */
- 	val = SDRAM0_READ(DDR0_42);
+	val = SDRAM0_READ(DDR0_42);
 
 	row = DDR_GET_VAL(val, DDR_APIN, DDR_APIN_SHIFT);
 	if (row > max_row)


