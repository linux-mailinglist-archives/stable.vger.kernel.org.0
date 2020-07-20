Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BBD226B67
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgGTPpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729678AbgGTPpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:45:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53DD42065E;
        Mon, 20 Jul 2020 15:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259913;
        bh=nbwn6TZZ0LFmygzzXGwmza/qSf14tzLEA/vC7zv4svw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJqcNCSRPbB0SP9OwmxCWoibApD/TI+Nc1lFWzJpnvb+2IIj58ccifKXGYwaNUvpa
         iADePgLnH4Lyzz0Pe4OByPnOoIuwNfdc3DC6g2kRi6M2XqnQQ3zl/FvMoesvFp0DB+
         i7C1NkcSAOuONJeb9cCIQvRGZhehJV9HGjpDk1VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.14 039/125] ARC: elf: use right ELF_ARCH
Date:   Mon, 20 Jul 2020 17:36:18 +0200
Message-Id: <20200720152804.891376434@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
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


