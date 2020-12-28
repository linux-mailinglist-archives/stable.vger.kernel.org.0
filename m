Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6062E4311
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405238AbgL1Nz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405226AbgL1Nz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:55:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF96F206D4;
        Mon, 28 Dec 2020 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163711;
        bh=QP+TBF0pG/qsyhBBxAFldz9+dC8+WRduNbkOf+HQf/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryTa1g+NOdoExvmj5p1NO7/RxDjDrzMfGDsCeDTPEVmovc91JDHOPQC3iEmsVD9dm
         6TodPjovkw/TGSBjm8ZhkmA3O8QbYWr6URY0PxKFNrM5QYFPH0Gn3BOcGxWvgzCZMK
         PQ9iIoILk5XOCKJh9bdm+2ZZ+ljCUsWd8wSwD8/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 382/453] powerpc/feature: Add CPU_FTR_NOEXECUTE to G2_LE
Date:   Mon, 28 Dec 2020 13:50:18 +0100
Message-Id: <20201228124955.584259268@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 197493af414ee22427be3343637ac290a791925a upstream.

G2_LE has a 603 core, add CPU_FTR_NOEXECUTE.

Fixes: 385e89d5b20f ("powerpc/mm: add exec protection on powerpc 603")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/39a530ee41d83f49747ab3af8e39c056450b9b4d.1602489653.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/cputable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -367,7 +367,7 @@ static inline void cpu_feature_keys_init
 	    CPU_FTR_PPC_LE | CPU_FTR_NEED_PAIRED_STWCX)
 #define CPU_FTRS_82XX	(CPU_FTR_COMMON | CPU_FTR_MAYBE_CAN_DOZE | CPU_FTR_NOEXECUTE)
 #define CPU_FTRS_G2_LE	(CPU_FTR_COMMON | CPU_FTR_MAYBE_CAN_DOZE | \
-	    CPU_FTR_MAYBE_CAN_NAP)
+	    CPU_FTR_MAYBE_CAN_NAP | CPU_FTR_NOEXECUTE)
 #define CPU_FTRS_E300	(CPU_FTR_MAYBE_CAN_DOZE | \
 	    CPU_FTR_MAYBE_CAN_NAP | \
 	    CPU_FTR_COMMON  | CPU_FTR_NOEXECUTE)


