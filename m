Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8891D6BB30B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbjCOMlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbjCOMkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5ADA3BD9A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF1661D82
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1815C433D2;
        Wed, 15 Mar 2023 12:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883963;
        bh=u66U3m65PJqVDS28/79g2IDAVlH3OBmhN84cHiMjyqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKbLbNqPixhXbxV0aCcA2CRSWd1nUpXajnFIS0v87ZaUgBdbUNdUu7n+Vye6Q+uQU
         IOl4YUSSyK9cX/La4MxmptKAE6ZoPdhkvYv1BTlUb5XZsneoCAAoPAwhpUy/Stc3Qb
         7mlprR4wpL282MioXAj3tGGDWgLWFv+LFSV1TgzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 054/141] powerpc: dts: t1040rdb: fix compatible string for Rev A boards
Date:   Wed, 15 Mar 2023 13:12:37 +0100
Message-Id: <20230315115741.609431823@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ae44f1c9d1fc54aeceb335fedb1e73b2c3ee4561 ]

It looks like U-Boot fails to start the kernel properly when the
compatible string of the board isn't fsl,T1040RDB, so stop overriding it
from the rev-a.dts.

Fixes: 5ebb74749202 ("powerpc: dts: t1040rdb: fix ports names for Seville Ethernet switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts b/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
index 73f8c998c64df..d4f5f159d6f23 100644
--- a/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
+++ b/arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts
@@ -10,7 +10,6 @@
 
 / {
 	model = "fsl,T1040RDB-REV-A";
-	compatible = "fsl,T1040RDB-REV-A";
 };
 
 &seville_port0 {
-- 
2.39.2



