Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E207E499B36
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574830AbiAXVua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457345AbiAXVlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759F7C07E31C;
        Mon, 24 Jan 2022 12:28:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1584361518;
        Mon, 24 Jan 2022 20:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DE0C340E5;
        Mon, 24 Jan 2022 20:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056090;
        bh=7sD7+lXcXIAbqic7rspXCLXl8Os/glrqskRtRCYDPKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkabg1Tf21mVzDWCgJESCLx1eA7+FxiwyltozisZZJ3qfsludQmHQcxdmETKHL4Rg
         X2gdpSJ5dtDyLKRTNcV5bvBkEUjblXfofsMXAC7ydOJiJuK6y4lqtvjgufI8YqndsG
         MpbFiMuEtJFzHpwPi8sMOM5liPy4daVbYrUBtcKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 334/846] serial: liteuart: fix MODULE_ALIAS
Date:   Mon, 24 Jan 2022 19:37:31 +0100
Message-Id: <20220124184112.439816773@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Ross <hi@alyssa.is>

[ Upstream commit 556172fabd226ba14b70c1740d0826a4717473dc ]

modprobe can't handle spaces in aliases.

Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Link: https://lore.kernel.org/r/20220104131030.1674733-1-hi@alyssa.is
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/liteuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/liteuart.c b/drivers/tty/serial/liteuart.c
index 2941659e52747..7f74bf7bdcff8 100644
--- a/drivers/tty/serial/liteuart.c
+++ b/drivers/tty/serial/liteuart.c
@@ -436,4 +436,4 @@ module_exit(liteuart_exit);
 MODULE_AUTHOR("Antmicro <www.antmicro.com>");
 MODULE_DESCRIPTION("LiteUART serial driver");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform: liteuart");
+MODULE_ALIAS("platform:liteuart");
-- 
2.34.1



