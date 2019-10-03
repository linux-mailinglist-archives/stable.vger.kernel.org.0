Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1A9CAB19
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732108AbfJCRRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390274AbfJCQWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B01692054F;
        Thu,  3 Oct 2019 16:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119737;
        bh=ZsSQ/Q9nhpssLAIx6yD5sSkzGLXOhaVzTnt0SeF9+v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOmSzuDL6yDV26E4p98SGN/3IGuVgpv1HPMQAfcwiiCwGpj/a4sSj56mab4vyP3aJ
         nArKxV9pfLt88ipHh19TBEuBAkcCcWTk/AeyuQR3TtivcCYXj5yxBB1oCpmB63OGcA
         3FRwwq26xaegBPOX2gr+cD6Td67fT9N5J48t2irY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lihua Yao <ylhuajnu@outlook.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.19 174/211] ARM: samsung: Fix system restart on S3C6410
Date:   Thu,  3 Oct 2019 17:54:00 +0200
Message-Id: <20191003154526.656368734@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
 


