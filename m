Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8203C2D43
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhGJCWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232618AbhGJCVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65DAB6140C;
        Sat, 10 Jul 2021 02:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883541;
        bh=Nr5gL9JOSKUjbA100HeDI/KrMsIKYBDVkr9sctcPrpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kh5BglNz1Sfyz09cI9sX/YXvw36xr8Ai9W05f0TCazSuK6tKNyRdbh/ZowacT9ZVM
         NDHQkE3+LhUZjquQdNavK4OAi01SwTVnTUJpvRIym1mqJTAHW2/wtfK7uZce3MnE7A
         oGmGmhfIyhwkW6fPZpBTKfP7QPHXs9e4KCaKgT/AWZrFfBTmLoeLsL9zgkBR7+fwvn
         8jytE4cvzQwfEftQrbP4sm8SVAWwcryKoYT8Fk8ybacLHwfiSmZ2gwQWA8UT5XyClX
         Qb0PvEPfkVtD/tbZnYkcGbDZb3jTpRSgd2YtONiVSo7AigFAtqX6bHLnuaDOoQ2+wh
         DBqoLdh2nKvtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Billauer <eli.billauer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 053/114] char: xillybus: Fix condition for invoking the xillybus/ subdirectory
Date:   Fri,  9 Jul 2021 22:16:47 -0400
Message-Id: <20210710021748.3167666-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Billauer <eli.billauer@gmail.com>

[ Upstream commit 1b1ee3a91d21fdf7d415c1060db1a7a07ae296b6 ]

As Xillybus' configuration symbol hierarchy has been reorganized recently,
the correct condition for compiling the xillybus/ subdirectory is now
CONFIG_XILLYBUS_CLASS, and not CONFIG_XILLYBUS.

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20210528092242.51104-1-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index ffce287ef415..c7e4fc733a37 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -44,6 +44,6 @@ obj-$(CONFIG_TCG_TPM)		+= tpm/
 
 obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 
-obj-$(CONFIG_XILLYBUS)		+= xillybus/
+obj-$(CONFIG_XILLYBUS_CLASS)	+= xillybus/
 obj-$(CONFIG_POWERNV_OP_PANEL)	+= powernv-op-panel.o
 obj-$(CONFIG_ADI)		+= adi.o
-- 
2.30.2

