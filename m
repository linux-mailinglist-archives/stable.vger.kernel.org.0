Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC0C2C4408
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbgKYPkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731101AbgKYPhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:37:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E4F221FB;
        Wed, 25 Nov 2020 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318653;
        bh=8qixQJveTgM/slIqqZMCI09l3i7SFF5l94iIB84rPyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ua+OS+KFFXsxl2uGr14ft3qOJe4CrG+nta7GLHFd+LLlFaJy5UStidnlgwb/4VGEk
         Ku5aUX+htTGAOVomsDl1+EaldACd7CZd6V5c+Xw5RNqBGdyOmuu1WNfOntmzhyRvK9
         IIawRebQP1ZYptb7LpOJHVAGvgp0UBD3/NDnBrCI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel test robot <lkp@intel.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.19 15/15] xtensa: uaccess: Add missing __user to strncpy_from_user() prototype
Date:   Wed, 25 Nov 2020 10:37:12 -0500
Message-Id: <20201125153712.810655-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153712.810655-1-sashal@kernel.org>
References: <20201125153712.810655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

