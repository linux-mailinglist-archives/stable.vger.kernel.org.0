Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E424E137FFA
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbgAKKYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:24:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729469AbgAKKYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:24:38 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70974205F4;
        Sat, 11 Jan 2020 10:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738278;
        bh=Cj40zb+AUa3NBq6HJj8kQ+SYKunwgnUJaZ+Ud1eZDWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvYLnx0WIIHRxXHXc7CE4s1pGhTFgEgY2IVyqvldMUQ9DraMwMrXwoezQV0CaFYl9
         Knd6u6slDLjv7OxlIwN96b3HMzRFqcMMb0pRv/vVfDHo94mPrZTkhujGW47B5wsdbn
         0O7REWDvSX5MlemzuO+Cdr0RsD9vccJnlASwLpVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/165] ARM: imx_v6_v7_defconfig: Explicitly restore CONFIG_DEBUG_FS
Date:   Sat, 11 Jan 2020 10:49:44 +0100
Message-Id: <20200111094926.587833913@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit 46db63abb79524209c15c683feccfba116746757 ]

This is currently off and that's not desirable: default imx config is
meant to be generally useful for development and debugging.

Running git bisect between v5.4 and v5.5-rc1 finds this started from
commit 0e4a459f56c3 ("tracing: Remove unnecessary DEBUG_FS dependency")

Explicit CONFIG_DEBUG_FS=y was earlier removed by
commit c29d541f590c ("ARM: imx_v6_v7_defconfig: Remove unneeded options")

A very similar fix was required before:
commit 7e9eb6268809 ("ARM: imx_v6_v7_defconfig: Explicitly restore CONFIG_DEBUG_FS")

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/imx_v6_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 0f7381ee0c37..dabb80453249 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -460,6 +460,7 @@ CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
 CONFIG_PRINTK_TIME=y
 CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_FS=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_PROVE_LOCKING=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
-- 
2.20.1



