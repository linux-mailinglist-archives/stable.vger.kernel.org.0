Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC03147B34
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733025AbgAXJlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:41:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733013AbgAXJll (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:41:41 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C74FD20718;
        Fri, 24 Jan 2020 09:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858901;
        bh=o9cXkAO97d8ZXR7kjU7FXjf00XBiJlSxfYL4kf0wC4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZiPf3CJvu+VTYkY6SJfUhLtqDG0ajdZ0pAzMz96jyGXkBr18RhWUMYrbOi8D60aJ
         Cv4No96Fjt9YUa158SZDOwIgN0j5pnxKHmh147OxPplIX0oCwEI7adKc70DU19fsxO
         rOKrVOuGiS3MSR6FRkIKbdCqWuAWU06DtG6hTcVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/102] rtc: bd70528: fix module alias to autoload module
Date:   Fri, 24 Jan 2020 10:31:19 +0100
Message-Id: <20200124092818.428041975@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit afe19a7ae8b6b6032d04d3895ebd5bbac7fe9f30 ]

The module alias platform tag contains a spelling mistake. Fix it.

Fixes: f33506abbcdd ("rtc: bd70528: Add MODULE ALIAS to autoload module")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20191106083418.159045-1-colin.king@canonical.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-bd70528.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-bd70528.c b/drivers/rtc/rtc-bd70528.c
index ddfef4d43bab7..627037aa66a80 100644
--- a/drivers/rtc/rtc-bd70528.c
+++ b/drivers/rtc/rtc-bd70528.c
@@ -491,4 +491,4 @@ module_platform_driver(bd70528_rtc);
 MODULE_AUTHOR("Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>");
 MODULE_DESCRIPTION("BD70528 RTC driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platofrm:bd70528-rtc");
+MODULE_ALIAS("platform:bd70528-rtc");
-- 
2.20.1



