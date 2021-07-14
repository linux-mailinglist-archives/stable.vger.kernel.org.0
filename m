Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C803C8C54
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhGNTln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233148AbhGNTl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B48B4613DC;
        Wed, 14 Jul 2021 19:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291515;
        bh=JApliMSbP4eWKiuwY4+sr/M1qExj+z1PXmkl7snZtJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juDD9xBSm7dvzip8bBD7CaSV5F8761/Jqjsn4H7Apl+Y8myPt8u9jqaDI/RhbH1CN
         Hog1GOZwsR/h88nGcsKDdV+JzRKcj9UwqcQrBwF6/xL2gotv0P7VtBjkdDWktqsFMk
         CPio+1bNyFTEBgAJ8eOEyc+BewJ5CHlxVJhmKNtKj6eZKFM9nDytVXPx5Z72KPSjm0
         dyDRcvL9VsV0lwep/KWLKBiUgsEVSiz0ZWvddZlsZvD9RVI8Fb+ZGHU+reuWvFA1cz
         VxL8DqJhcnxBY/nbFzUCX5d9L9ylRZswhkb4RgqgYpcu+ccFnvWPmWZ6ccDG+CGLfx
         cF9feKLwNlK+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.13 023/108] soc: bcm: brcmstb: remove unused variable 'brcmstb_machine_match'
Date:   Wed, 14 Jul 2021 15:36:35 -0400
Message-Id: <20210714193800.52097-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit c1f512182c54dc87efd2f7ac19f16a49ff8bb19e ]

Fix the following clang warning:

drivers/soc/bcm/brcmstb/common.c:17:34: warning: unused variable
'brcmstb_machine_match' [-Wunused-const-variable].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/brcmstb/common.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/soc/bcm/brcmstb/common.c b/drivers/soc/bcm/brcmstb/common.c
index e87dfc6660f3..2a010881f4b6 100644
--- a/drivers/soc/bcm/brcmstb/common.c
+++ b/drivers/soc/bcm/brcmstb/common.c
@@ -14,11 +14,6 @@
 static u32 family_id;
 static u32 product_id;
 
-static const struct of_device_id brcmstb_machine_match[] = {
-	{ .compatible = "brcm,brcmstb", },
-	{ }
-};
-
 u32 brcmstb_get_family_id(void)
 {
 	return family_id;
-- 
2.30.2

