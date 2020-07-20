Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFDB226BF8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgGTQq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729732AbgGTPkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:40:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C53BE2176B;
        Mon, 20 Jul 2020 15:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259641;
        bh=nbwn6TZZ0LFmygzzXGwmza/qSf14tzLEA/vC7zv4svw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4WFKYwaMLZTybuEypr94AuaQQAvB4ZuSg3H3jY1yQRRCTaUZRzWCpSDYTR35ddgC
         7APhNlagQR34PNCSzarmWUqYQDexPR1Owrpcj/uUaKFxYJ1swMFLMMg5lq07UFiONn
         G0l+AGFQRpjCoLfVMNZB9UVfJM7QE4bwotcVY9Hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.9 25/86] ARC: elf: use right ELF_ARCH
Date:   Mon, 20 Jul 2020 17:36:21 +0200
Message-Id: <20200720152754.415928050@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
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
@@ -26,7 +26,7 @@
 #define  R_ARC_32_PCREL		0x31
 
 /*to set parameters in the core dumps */
-#define ELF_ARCH		EM_ARCOMPACT
+#define ELF_ARCH		EM_ARC_INUSE
 #define ELF_CLASS		ELFCLASS32
 
 #ifdef CONFIG_CPU_BIG_ENDIAN


