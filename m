Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5307C147F8E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgAXLDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387800AbgAXLDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:03:10 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76D1A2075D;
        Fri, 24 Jan 2020 11:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863790;
        bh=2H0OlEXUigJTXu7tQLf7/KBOB9u+oISf7XJnwBADS0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=df2qHYF2EcNl8ghg/UhkbixuD6WnoBTv6gCPntMOAC71b/lZCDsvVwZUCckwZUs7F
         L5rp619yVJsEcVWtAf+W1BiYu1UXDIjvXAe4eIprwxvyvfDd+TK0t4UVAneFlV+2k9
         N1bzqLXilW8t4nKA7XtPiwOvxzSxTE+h/TnK8fZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/639] pinctrl: sh-pfc: sh73a0: Add missing TO pin to tpu4_to3 group
Date:   Fri, 24 Jan 2020 10:24:19 +0100
Message-Id: <20200124093058.483991161@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 124cde98f856b6206b804acbdec3b7c80f8c3427 ]

The tpu4_to3_mux[] array contains the TPU4TO3 pin mark, but the
tpu4_to3_pins[] array lacks the corresponding pin number.

Add the missing pin number, for non-GPIO pin F26.

Fixes: 5da4eb049de803c7 ("sh-pfc: sh73a0: Add TPU pin groups and functions")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
index d25e6f674d0ab..f8fbedb46585d 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
@@ -3086,6 +3086,7 @@ static const unsigned int tpu4_to2_mux[] = {
 };
 static const unsigned int tpu4_to3_pins[] = {
 	/* TO */
+	PIN_NUMBER(6, 26),
 };
 static const unsigned int tpu4_to3_mux[] = {
 	TPU4TO3_MARK,
-- 
2.20.1



