Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B125117FCFD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgCJM6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbgCJM6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:58:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1679E2468E;
        Tue, 10 Mar 2020 12:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845081;
        bh=1Y8fBheo+gb39pMv7lTELFyrrzvQXoZGwB0CRyzuFc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbZZMjB0Q+YXh45xMLqthWt0nCDsa/E4485b8ZzMy85cAqXNgLrWiklmG4GVLK8v8
         YK1xDOgKboqz3xsAYKmW4HRp4NGZrHaUN8sIavOE+pEffPDq1SK7xE2mbblYwHxdJT
         IJMgooc4io6E4eRpFGixIMs4KZ+XgX9kYBkXVWgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 055/189] csky: Fixup compile warning for three unimplemented syscalls
Date:   Tue, 10 Mar 2020 13:38:12 +0100
Message-Id: <20200310123645.132891113@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 2305f60b76110cb3e8658a4ae85d1f7eb0c66a5b ]

Implement fstat64, fstatat64, clone3 syscalls to fixup
checksyscalls.sh compile warnings.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/include/uapi/asm/unistd.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/csky/include/uapi/asm/unistd.h b/arch/csky/include/uapi/asm/unistd.h
index 211c983c7282d..ba40189297338 100644
--- a/arch/csky/include/uapi/asm/unistd.h
+++ b/arch/csky/include/uapi/asm/unistd.h
@@ -1,7 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 // Copyright (C) 2018 Hangzhou C-SKY Microsystems co.,ltd.
 
+#define __ARCH_WANT_STAT64
+#define __ARCH_WANT_NEW_STAT
 #define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_SYS_CLONE3
 #define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_TIME32_SYSCALLS
 #include <asm-generic/unistd.h>
-- 
2.20.1



