Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21A17F8B0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgCJMuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbgCJMuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:50:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0227D2468D;
        Tue, 10 Mar 2020 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844615;
        bh=vGUOX+Fc8v/Nw6WwDblSI4csNM6cyIMB9lzoBuNt5d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOq8FC5ycT6d26VrbVhRk1hbfnOASlzK9SVmm5wWJ89XDZBROzdN4RMalae4zgthu
         ouCDHMQEC6gybpTAFZHgqDfKb4NRnqzIZKPwxj5D0S/QJhWcCRsypVCmU3OezCCK6e
         bpLczaQ9xmveRNkutdTwX+Y/GAj+ElEi7QmHm6lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Guo Ren <guoren@kernel.org>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/168] arch/csky: fix some Kconfig typos
Date:   Tue, 10 Mar 2020 13:38:21 +0100
Message-Id: <20200310123640.919950800@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit bebd26ab623616728d6e72b5c74a47bfff5287d8 ]

Fix wording in help text for the CPU_HAS_LDSTEX symbol.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/csky/Kconfig b/arch/csky/Kconfig
index 3973847b5f42e..25de20e526e50 100644
--- a/arch/csky/Kconfig
+++ b/arch/csky/Kconfig
@@ -74,7 +74,7 @@ config CPU_HAS_TLBI
 config CPU_HAS_LDSTEX
 	bool
 	help
-	  For SMP, CPU needs "ldex&stex" instrcutions to atomic operations.
+	  For SMP, CPU needs "ldex&stex" instructions for atomic operations.
 
 config CPU_NEED_TLBSYNC
 	bool
-- 
2.20.1



