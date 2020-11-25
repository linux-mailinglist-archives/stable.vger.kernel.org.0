Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9142C43CE
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgKYPhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:37:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730291AbgKYPhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:37:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC6B221FC;
        Wed, 25 Nov 2020 15:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318629;
        bh=1e2Hlq7wAXg/fySaQFlHoIq8be1MOy+VJqG9Okkf8+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vzczthDgzBkc/dbMLwYw3hoJ7YwMD4fbLhxpOWBoraqXh+KMcECY7XHwkhuL69AP
         vRmOOyQDr+9Xp8LP7xSIIfsmprPFkvEbOMj2sLwzzUovm+Rj6sJVjgKPVnxbShkdMX
         J6LZlibbosk//VS2ytPHAoXPGoKP38p9OrlJW1aY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel test robot <lkp@intel.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 5.4 22/23] xtensa: uaccess: Add missing __user to strncpy_from_user() prototype
Date:   Wed, 25 Nov 2020 10:36:37 -0500
Message-Id: <20201125153638.810419-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153638.810419-1-sashal@kernel.org>
References: <20201125153638.810419-1-sashal@kernel.org>
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

