Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90627507CD
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfFXKKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730434AbfFXKIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:08:20 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDA0C2089F;
        Mon, 24 Jun 2019 10:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370900;
        bh=InnUAcskl1+Nq8HujBZuuO9oVUwRKPIL3VUFQVlFKk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3U5ysA1VK5fDL+uHbRMIGDo+RYoHST4c8srAPY2HrrGBpJOKAOElM6n6gUzdC/8J
         qu81Z4Gcu79av5HryD+gAjkGK3/z36IGFGrMNRe0ML2EIb9NBeQdy/RXv10dNMAYsU
         F3/nOEDBOf+eNVugWbnINPzG1gpg3LNkMYV529Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 043/121] MIPS: mark ginvt() as __always_inline
Date:   Mon, 24 Jun 2019 17:56:15 +0800
Message-Id: <20190624092322.981619939@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6074c33c6b2eabc70867ef76d57ca256e9ea9da7 ]

To meet the 'i' (immediate) constraint for the asm operands,
this function must be always inlined.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/ginvt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/ginvt.h b/arch/mips/include/asm/ginvt.h
index 49c6dbe37338..6eb7c2b94dc7 100644
--- a/arch/mips/include/asm/ginvt.h
+++ b/arch/mips/include/asm/ginvt.h
@@ -19,7 +19,7 @@ _ASM_MACRO_1R1I(ginvt, rs, type,
 # define _ASM_SET_GINV
 #endif
 
-static inline void ginvt(unsigned long addr, enum ginvt_type type)
+static __always_inline void ginvt(unsigned long addr, enum ginvt_type type)
 {
 	asm volatile(
 		".set	push\n"
-- 
2.20.1



