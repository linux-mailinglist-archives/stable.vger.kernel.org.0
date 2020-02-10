Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DA4157B89
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbgBJNah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbgBJMgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:10 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 750182467A;
        Mon, 10 Feb 2020 12:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338169;
        bh=bBRNU/XhX8hgq6uIAe2ranG1Tg5vXviudg/xQk03MkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quDSrooD3sboguQS2RzPNA3giyWYqiuKSo6FSUTHYrI6J17FH08mUA6PPsGlsqfPa
         zIbmmfE/lIjNmfYvckApn/JtFUsORPn2ECFnvBVj+11/EztoOgBWBg3NmYhPUuKf3d
         UiwkZg8OVriz3B7E3fixwpV2zkIGgDOk6nW4qLrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 151/195] powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize
Date:   Mon, 10 Feb 2020 04:33:29 -0800
Message-Id: <20200210122320.092297141@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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


