Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5044E2A24
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343742AbiCUOOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349050AbiCUOHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:07:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33108B716A;
        Mon, 21 Mar 2022 07:02:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93028612DC;
        Mon, 21 Mar 2022 14:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE1DC340E8;
        Mon, 21 Mar 2022 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871326;
        bh=IAAFrUU8gQiQaC3sASTjgx3whxx7B6O72E6G9ckiAis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpbKgn5r8HpqSrKvLYiL3PK885mDp0zfaq1ps7bam9zlesqD1aZvjSDxVxc58jGei
         AyRrPGSVJ4nkfrzRuWSSDQq7+SMSwqj6j5M+fXm84q4etCnOLWVpv/sfqx6F/6/iic
         k8sFs1hYXHXUv9wQTg0fnrJawkzaLN6JsMSbQVi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juerg Haefliger <juergh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 22/37] net: phy: mscc: Add MODULE_FIRMWARE macros
Date:   Mon, 21 Mar 2022 14:53:04 +0100
Message-Id: <20220321133221.939774567@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juerg Haefliger <juerg.haefliger@canonical.com>

[ Upstream commit f1858c277ba40172005b76a31e6bb931bfc19d9c ]

The driver requires firmware so define MODULE_FIRMWARE so that modinfo
provides the details.

Fixes: fa164e40c53b ("net: phy: mscc: split the driver into separate files")
Signed-off-by: Juerg Haefliger <juergh@canonical.com>
Link: https://lore.kernel.org/r/20220316151835.88765-1-juergh@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index ebfeeb3c67c1..7e3017e7a1c0 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2685,3 +2685,6 @@ MODULE_DEVICE_TABLE(mdio, vsc85xx_tbl);
 MODULE_DESCRIPTION("Microsemi VSC85xx PHY driver");
 MODULE_AUTHOR("Nagaraju Lakkaraju");
 MODULE_LICENSE("Dual MIT/GPL");
+
+MODULE_FIRMWARE(MSCC_VSC8584_REVB_INT8051_FW);
+MODULE_FIRMWARE(MSCC_VSC8574_REVB_INT8051_FW);
-- 
2.34.1



