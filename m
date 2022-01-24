Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7134997E1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449873AbiAXVRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34316 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448595AbiAXVNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AA27B80CCF;
        Mon, 24 Jan 2022 21:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3CDC340E5;
        Mon, 24 Jan 2022 21:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058785;
        bh=7sD7+lXcXIAbqic7rspXCLXl8Os/glrqskRtRCYDPKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XloTH4P7zBXGhweuG3UCN6wQz85ZBVls+R7fgCbVhHKzb/OxDZzQrt+eG8NUzpie5
         NuygNZZQeJ/+cmfmwEtXLEOn2p9EO7FLThm8DfTLempYAa3c5N/+NdAhg1VOO44MMI
         wpHj6Ozaa6vYZDcCfigCm3S3KrHHUpXQOKZ4jRNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0400/1039] serial: liteuart: fix MODULE_ALIAS
Date:   Mon, 24 Jan 2022 19:36:29 +0100
Message-Id: <20220124184138.760726501@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



