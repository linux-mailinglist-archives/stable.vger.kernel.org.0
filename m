Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AB91576EA
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgBJMlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730038AbgBJMlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:39 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2022020733;
        Mon, 10 Feb 2020 12:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338498;
        bh=+rpPukVyXSRat+AIBRd3Dok+i5Z3ZVjtWl1lwbRpOjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBfM75xFG9H3GjnUQlO6Gua9DlfRIVRpBnwQIULdWVzLRnW37L9X2RF7nXOFad4Lj
         eNeY0KbQQtV+89Jbt2p7Q/vZzmgpjHcMdN/VGlVHEMiidRyDrK+iP3D32rHTk3PNoL
         2Bq7cVEbPCb553RuoQCVtSe/EtxvSCKUpCfvoOOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.5 288/367] powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize
Date:   Mon, 10 Feb 2020 04:33:21 -0800
Message-Id: <20200210122450.447695766@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
@@ -228,7 +228,7 @@ void ibm4xx_denali_fixup_memsize(void)
 		dpath = 8; /* 64 bits */
 
 	/* get address pins (rows) */
- 	val = SDRAM0_READ(DDR0_42);
+	val = SDRAM0_READ(DDR0_42);
 
 	row = DDR_GET_VAL(val, DDR_APIN, DDR_APIN_SHIFT);
 	if (row > max_row)


