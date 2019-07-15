Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517FD69014
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390007AbfGOOS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:18:57 -0400
Received: from glenfiddich.mraw.org ([62.210.215.98]:51532 "EHLO
        glenfiddich.mraw.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389999AbfGOOS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 10:18:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mraw.org;
         s=mail; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:
        Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qbMbTw2ER+pWeTSoKHpQKzwAQpwTIWCxN1KvnsZIj/4=; b=bDVu2TsU/QcQHFNRlUbMCjj40i
        iiazmXSobemcpl/1TyXIxhXINW9B81BruvawLYVDp8GkOuz9U2AG9HW9yKKQAxmzjRZvpyBdribg5
        1W6NhqolTgGM05PDx5h7ym5P7cxPU5oi2vdbjgXpCpgPaiYWbqxX5NAfpw+kFXnWPleU=;
Received: from localhost ([127.0.0.1] helo=armor.home)
        by glenfiddich.mraw.org with esmtp (Exim 4.89)
        (envelope-from <cyril@debamax.com>)
        id 1hn1YB-00008C-LP; Mon, 15 Jul 2019 16:01:55 +0200
From:   Cyril Brulebois <cyril@debamax.com>
To:     stable@vger.kernel.org
Cc:     charles.fendt@me.com, Liviu Dudau <liviu@dudau.co.uk>,
        Olof Johansson <olof@lixom.net>,
        Cyril Brulebois <cyril@debamax.com>
Subject: [PATCH 3/3] arm64: dts: broadcom: Use the .dtb name in the rule, rather than .dts
Date:   Mon, 15 Jul 2019 16:01:12 +0200
Message-Id: <20190715140112.6180-4-cyril@debamax.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190715140112.6180-1-cyril@debamax.com>
References: <20190715140112.6180-1-cyril@debamax.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liviu Dudau <liviu@dudau.co.uk>

commit 74cf77e8be35795b4cc57b7010bc348295e421b9 upstream.

Commit a7eb26392b893 ("arm64: dts: broadcom: Add reference to Compute
Module IO Board V3") adds the bcm2837-rpi-cm3-io3.dts file as a target
in the Makefile, rather than the .dtb name. This will skip the
generation of the .dtb file at compile time and will fail the dtbs_install
target.

Fixes: a7eb26392b893 ("arm64: dts: broadcom: Add reference to Compute Module IO Board V3")
Signed-off-by: Liviu Dudau <liviu@dudau.co.uk>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Tested-by: Charles Fendt <charles.fendt@me.com>
Signed-off-by: Cyril Brulebois <cyril@debamax.com>
---
 arch/arm64/boot/dts/broadcom/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/Makefile b/arch/arm64/boot/dts/broadcom/Makefile
index 3d98f5f5ab88..667ca989c11b 100644
--- a/arch/arm64/boot/dts/broadcom/Makefile
+++ b/arch/arm64/boot/dts/broadcom/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2837-rpi-3-b.dtb \
 			      bcm2837-rpi-3-b-plus.dtb \
-			      bcm2837-rpi-cm3-io3.dts
+			      bcm2837-rpi-cm3-io3.dtb
 
 subdir-y	+= northstar2
 subdir-y	+= stingray
-- 
2.11.0

