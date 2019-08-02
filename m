Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B197F354
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406699AbfHBJ4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406701AbfHBJ4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:56:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5DC62067D;
        Fri,  2 Aug 2019 09:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739773;
        bh=VquHcwOcF7WSDfdfcKHX4oo10wc6iWPacef/VpfOICg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6gRnQpRa6zGhJ1WgeI26kLwvGiEdR+xtKIL3W1zI0wmHev7iNvoK0mIvZkxWg/pb
         9CT13HuHzIzfM166HNUXBszUvHYjzrgqCZD/W2dAMt4uwOreUfHQ9NYOGML7aIOyXV
         zUnENpCwqtieJEkYxB/qJxU89beiAGwdz2Yuabvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Steve McIntyre <steve.mcintyre@arm.com>,
        Steve McIntyre <93sam@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.19 08/32] arm64: compat: Provide definition for COMPAT_SIGMINSTKSZ
Date:   Fri,  2 Aug 2019 11:39:42 +0200
Message-Id: <20190802092104.138562524@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 24951465cbd279f60b1fdc2421b3694405bcff42 upstream.

arch/arm/ defines a SIGMINSTKSZ of 2k, so we should use the same value
for compat tasks.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Reported-by: Steve McIntyre <steve.mcintyre@arm.com>
Tested-by: Steve McIntyre <93sam@debian.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/compat.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -159,6 +159,7 @@ static inline compat_uptr_t ptr_to_compa
 }
 
 #define compat_user_stack_pointer() (user_stack_pointer(task_pt_regs(current)))
+#define COMPAT_MINSIGSTKSZ	2048
 
 static inline void __user *arch_compat_alloc_user_space(long len)
 {


