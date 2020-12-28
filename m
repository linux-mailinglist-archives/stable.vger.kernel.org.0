Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CA12E3E92
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503410AbgL1O3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:29:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503408AbgL1O3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:29:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 032572245C;
        Mon, 28 Dec 2020 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165741;
        bh=WROAuKAvITckqHaZIK0oZSmdCLFJGc8TMKsDsMiIe8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+kGFfXJMRinKVmneUOJeT5X7Ck/4R0q8axX3khHqEVSBINCvabcFSiNXOuql7QML
         PQ9dZgszej87BrViHdM0n21tyhLcEZDPgI1Yz0CI0zD38VbP3Q5t5Z1YROFTOq42tn
         4IGKCgohoZ4ocCWlxfYJ85QStmL08yIeU1Q0Hihk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 611/717] powerpc/feature: Add CPU_FTR_NOEXECUTE to G2_LE
Date:   Mon, 28 Dec 2020 13:50:09 +0100
Message-Id: <20201228125050.184583720@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
@@ -369,7 +369,7 @@ static inline void cpu_feature_keys_init
 	    CPU_FTR_PPC_LE | CPU_FTR_NEED_PAIRED_STWCX)
 #define CPU_FTRS_82XX	(CPU_FTR_COMMON | CPU_FTR_MAYBE_CAN_DOZE | CPU_FTR_NOEXECUTE)
 #define CPU_FTRS_G2_LE	(CPU_FTR_COMMON | CPU_FTR_MAYBE_CAN_DOZE | \
-	    CPU_FTR_MAYBE_CAN_NAP)
+	    CPU_FTR_MAYBE_CAN_NAP | CPU_FTR_NOEXECUTE)
 #define CPU_FTRS_E300	(CPU_FTR_MAYBE_CAN_DOZE | \
 	    CPU_FTR_MAYBE_CAN_NAP | \
 	    CPU_FTR_COMMON  | CPU_FTR_NOEXECUTE)


