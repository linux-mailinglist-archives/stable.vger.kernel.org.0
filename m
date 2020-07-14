Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1218721FC1F
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbgGNSwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730558AbgGNSwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:52:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C86F22B42;
        Tue, 14 Jul 2020 18:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752762;
        bh=8XehDhDAYZ5yLnOp2poj5t1BNfP/ZjLH1Sgm6/0JwTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cu6GryY5Q6L2jpXBRr5T/1uR85Lablw2s5KIIVVQz8Ru/kwQUyOuEH6MUAfZZD434
         BEJsTqs0UnI4XEFRoHeP3OmrWptS31GHojyLBP3UqGSDzsW0nJ6xpkR3SmNx2BGglC
         ysusgmTb8Kosw6wMJQOLlNmxP45uvzrTErq+H+rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.4 100/109] ARC: elf: use right ELF_ARCH
Date:   Tue, 14 Jul 2020 20:44:43 +0200
Message-Id: <20200714184110.339306035@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

commit b7faf971081a4e56147f082234bfff55135305cb upstream.

Cc: <stable@vger.kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/include/asm/elf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arc/include/asm/elf.h
+++ b/arch/arc/include/asm/elf.h
@@ -19,7 +19,7 @@
 #define  R_ARC_32_PCREL		0x31
 
 /*to set parameters in the core dumps */
-#define ELF_ARCH		EM_ARCOMPACT
+#define ELF_ARCH		EM_ARC_INUSE
 #define ELF_CLASS		ELFCLASS32
 
 #ifdef CONFIG_CPU_BIG_ENDIAN


