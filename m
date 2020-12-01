Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FC12C9B2A
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgLAJFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388829AbgLAJEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:04:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0637120671;
        Tue,  1 Dec 2020 09:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813439;
        bh=1e2Hlq7wAXg/fySaQFlHoIq8be1MOy+VJqG9Okkf8+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYj7Uer0Ouv2d2iHtT8rNnvCINkOIgDmSWgfFwM7jsDxoW25JXSnc7kDlFlzH4XGE
         xL6vfbc2/zJQFhLWIlcLv3WBqGdUHlf/H7mFSZNk5bWqgZ1cJ2GGA/PqpDVY8uVUKR
         6T2IG5R6P4PRi2dfy5V7Fe7OTs4T8ZNQF4qBa0Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/98] xtensa: uaccess: Add missing __user to strncpy_from_user() prototype
Date:   Tue,  1 Dec 2020 09:53:17 +0100
Message-Id: <20201201084657.068991994@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
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
index 3f80386f18838..5cb24a789e9e1 100644
--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -300,7 +300,7 @@ strncpy_from_user(char *dst, const char *src, long count)
 	return -EFAULT;
 }
 #else
-long strncpy_from_user(char *dst, const char *src, long count);
+long strncpy_from_user(char *dst, const char __user *src, long count);
 #endif
 
 /*
-- 
2.27.0



