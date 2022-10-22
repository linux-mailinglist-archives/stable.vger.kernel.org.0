Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FAA6086AA
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiJVHv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiJVHt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A9F2C1715;
        Sat, 22 Oct 2022 00:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E12B60B9B;
        Sat, 22 Oct 2022 07:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECE1C433D6;
        Sat, 22 Oct 2022 07:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424597;
        bh=c/sCNq7gkDPOwlsgPsrYGZOsvI3vWJnfm+lWwWvTG3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHYB11H5JycVoxhWUr4MpJL08ImvJvHosrqpBW6OPyNB3JNpEsuYI08CaOplEJIci
         YB9rQJ6Qd6oJI0mA6DuvB+v1NpkEqsO7EbKUdmpIhVh0OBIJQ88e1gHFP9it1D93PL
         rGEWvuBFkdfb+kCyW2OQRWj7KmIgWTPe3MclINVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 206/717] tsnep: Fix TSNEP_INFO_TX_TIME register define
Date:   Sat, 22 Oct 2022 09:21:25 +0200
Message-Id: <20221022072451.769700798@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



