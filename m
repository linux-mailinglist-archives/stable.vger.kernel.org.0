Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30285624BD
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfGHPWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387563AbfGHPWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:22:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82FF214C6;
        Mon,  8 Jul 2019 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599327;
        bh=02UpBIi2kD3YHwnEWKXWDsNyLGN32xYTYA2qygZZHlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYt17OlXSlhbNGjHiChgTjUmQ42u/x5h6DqpOwj1frEPJwAvZbJnTungf0X5PMKH9
         7erGODjRIg9yuZL7BIWVHn4lWDZKcSVejD6qtJlh1hSptcUQ3WlDb1Q5hgskTrHB+4
         jdAjTZdc0MC6dX/A5HtXOzYq+YL4TfaeaKWmF43I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitrii Kolesnichenko <dmitrii@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 079/102] ARC: fix allnoconfig build warning
Date:   Mon,  8 Jul 2019 17:13:12 +0200
Message-Id: <20190708150530.547997255@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5464d03d92601ac2977ef605b0cbb33276567daf ]

Reported-by: Dmitrii Kolesnichenko <dmitrii@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index c7a081c583b9..2de75779a247 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -23,7 +23,7 @@ config ARC
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_FUTEX_CMPXCHG
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-- 
2.20.1



