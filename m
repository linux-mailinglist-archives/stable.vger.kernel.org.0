Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A851CA7C7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405960AbfJCQun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405956AbfJCQun (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:50:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3483720867;
        Thu,  3 Oct 2019 16:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121442;
        bh=ZsSQ/Q9nhpssLAIx6yD5sSkzGLXOhaVzTnt0SeF9+v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0j3XCAse7WTAOkqAJB8E5BX/2C0khQ1Kn15bYMo9wokc50zX/5mij1XfLuQWiNpR
         JCTPW5fReqiu9MJlYtO6LDMGPHXGrH9HF4voIie/CS2C1yWvsIsVrxL53XGEMYQIE0
         Z1tLKcoUdFLPP8DWGaZN7c7Jg+G9eK4z64uDSi+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lihua Yao <ylhuajnu@outlook.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.3 280/344] ARM: samsung: Fix system restart on S3C6410
Date:   Thu,  3 Oct 2019 17:54:05 +0200
Message-Id: <20191003154607.625396811@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lihua Yao <ylhuajnu@outlook.com>

commit 16986074035cc0205472882a00d404ed9d213313 upstream.

S3C6410 system restart is triggered by watchdog reset.

Cc: <stable@vger.kernel.org>
Fixes: 9f55342cc2de ("ARM: dts: s3c64xx: Fix infinite interrupt in soft mode")
Signed-off-by: Lihua Yao <ylhuajnu@outlook.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-samsung/watchdog-reset.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/plat-samsung/watchdog-reset.c
+++ b/arch/arm/plat-samsung/watchdog-reset.c
@@ -62,6 +62,7 @@ void samsung_wdt_reset(void)
 #ifdef CONFIG_OF
 static const struct of_device_id s3c2410_wdt_match[] = {
 	{ .compatible = "samsung,s3c2410-wdt" },
+	{ .compatible = "samsung,s3c6410-wdt" },
 	{},
 };
 


