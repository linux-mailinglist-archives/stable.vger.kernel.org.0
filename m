Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BCB2C9ACE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388473AbgLAJBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388480AbgLAJBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:01:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 366712220B;
        Tue,  1 Dec 2020 09:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813254;
        bh=8qixQJveTgM/slIqqZMCI09l3i7SFF5l94iIB84rPyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUfpR/j6g7+CP+c8WKvI/siVQQ1irbYW6Ahy33WudLocynfHwDTPPdUzbro38oycN
         /YniMqRwP+f1txK86fFmniqGHRBg3s3wW7V+ZBRCkJ7h9mI6RdoYomqPyx+r5XRnj6
         LgqMYUk1nmoOQIt+L8gDji9A1bkC6OQZ40h73fHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/57] xtensa: uaccess: Add missing __user to strncpy_from_user() prototype
Date:   Tue,  1 Dec 2020 09:53:32 +0100
Message-Id: <20201201084650.498869030@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit dc293f2106903ab9c24e9cea18c276e32c394c33 ]

When adding __user annotations in commit 2adf5352a34a, the
strncpy_from_user() function declaration for the
CONFIG_GENERIC_STRNCPY_FROM_USER case was missed. Fix it.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-Id: <20200831210937.17938-1-laurent.pinchart@ideasonboard.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/include/asm/uaccess.h b/arch/xtensa/include/asm/uaccess.h
index f1158b4c629cf..da4effe270072 100644
--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -291,7 +291,7 @@ strncpy_from_user(char *dst, const char *src, long count)
 	return -EFAULT;
 }
 #else
-long strncpy_from_user(char *dst, const char *src, long count);
+long strncpy_from_user(char *dst, const char __user *src, long count);
 #endif
 
 /*
-- 
2.27.0



