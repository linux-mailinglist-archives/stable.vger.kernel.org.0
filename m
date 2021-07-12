Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38B93C4A83
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbhGLGwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239823AbhGLGuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F16C60FE3;
        Mon, 12 Jul 2021 06:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072435;
        bh=8BEMKaS714OT+apHIX5solBA0W7/5V5TO7cFAvn5F28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwOuJuRfigOJkKXcXfLrh5xiCycS6GrkLm0hliHA0brYi1hYasafi0UtFWBoODsSy
         bZSzaZ647qTFoHFL9+7FiZorRkejtVwn5luqdo833RuwTHUCPfencaFu64mLJN8i+K
         KaOn118or45CwOu+islYC0e2BGVdiVTgOMiCM2r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 496/593] s390/irq: select HAVE_IRQ_EXIT_ON_IRQ_STACK
Date:   Mon, 12 Jul 2021 08:10:56 +0200
Message-Id: <20210712060945.973018175@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 9ceed9988a8e6a1656ed2bdaa30501cf0f3dd925 ]

irq_exit() is always called on async stack. Therefore select
HAVE_IRQ_EXIT_ON_IRQ_STACK and get a tiny optimization in
invoke_softirq().

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 4a2a12be04c9..dc5c3e6fd200 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -154,6 +154,7 @@ config S390
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_VDSO
+	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZ4
-- 
2.30.2



