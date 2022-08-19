Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9703259A439
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353555AbiHSQmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353994AbiHSQl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0A0128464;
        Fri, 19 Aug 2022 09:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 019436181D;
        Fri, 19 Aug 2022 16:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D57C433D6;
        Fri, 19 Aug 2022 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925344;
        bh=6Dm/QtZqMc5BBrSsShFxrrQs0b0gU7I+9RlqFFJcSeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gJdHpff0QmKu5vE5hI6Or+knak/t2KMO8wzqSLG1j0DOhRtE3/WI2MlJD2BFleXQ
         hyaLuSaezj/EASqWTVqgnEDo/La/cIXPiPj5vmuQuJLS9oagGpMrF9bBd0KE83TbBE
         Eb0AIvNs2HdQHDltEZ4S+Pj8uCOpl8n3X23y7Ryo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 461/545] mtd: rawnand: arasan: Fix a macro parameter
Date:   Fri, 19 Aug 2022 17:43:51 +0200
Message-Id: <20220819153850.020716331@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 698ddeb89e01840dec05ffdb538468782e641a56 ]

This macro is not yet being used so the compilers never complained
about it.

Fix the macro before using it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210505213750.257417-21-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/arasan-nand-controller.c b/drivers/mtd/nand/raw/arasan-nand-controller.c
index f9fb3b7a3ec3..a3d4ee988394 100644
--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -91,7 +91,7 @@
 
 #define DATA_INTERFACE_REG		0x6C
 #define   DIFACE_SDR_MODE(x)		FIELD_PREP(GENMASK(2, 0), (x))
-#define   DIFACE_DDR_MODE(x)		FIELD_PREP(GENMASK(5, 3), (X))
+#define   DIFACE_DDR_MODE(x)		FIELD_PREP(GENMASK(5, 3), (x))
 #define   DIFACE_SDR			0
 #define   DIFACE_NVDDR			BIT(9)
 
-- 
2.35.1



