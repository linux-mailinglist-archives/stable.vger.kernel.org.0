Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4048604873
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbiJSN4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiJSNyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A37193EFF;
        Wed, 19 Oct 2022 06:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AEE8B82382;
        Wed, 19 Oct 2022 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3E7C433D6;
        Wed, 19 Oct 2022 08:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169418;
        bh=c/sCNq7gkDPOwlsgPsrYGZOsvI3vWJnfm+lWwWvTG3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbuyYs1slHVBT/0ahPQ/mds082rR6BQTBLr2s6jswltPX6pNpJr4/3bbcoPR6H5qM
         U8qGrKPlOsLpeSFKgzdBbHDZ4IxTzqJhd6lQFnwji7k8ndGkcj/BcBLOA9svmWZDcq
         1LZHz0+VwPxFQNrObh5K2ZEsOaKTHC50KR33DhgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 235/862] tsnep: Fix TSNEP_INFO_TX_TIME register define
Date:   Wed, 19 Oct 2022 10:25:22 +0200
Message-Id: <20221019083300.424003623@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit 7d8dd6b5cd1d67dd96c132f91d7ad29c49ed3c59 ]

Fixed register define is not used, but register definition shall be kept
in sync.

Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_hw.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
index 916ceac3ada2..e03aaafab559 100644
--- a/drivers/net/ethernet/engleder/tsnep_hw.h
+++ b/drivers/net/ethernet/engleder/tsnep_hw.h
@@ -92,8 +92,7 @@
 
 /* tsnep register */
 #define TSNEP_INFO 0x0100
-#define TSNEP_INFO_RX_ASSIGN 0x00010000
-#define TSNEP_INFO_TX_TIME 0x00020000
+#define TSNEP_INFO_TX_TIME 0x00010000
 #define TSNEP_CONTROL 0x0108
 #define TSNEP_CONTROL_TX_RESET 0x00000001
 #define TSNEP_CONTROL_TX_ENABLE 0x00000002
-- 
2.35.1



