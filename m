Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CFB4CF51A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbiCGJYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237239AbiCGJXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:23:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830CF53E2F;
        Mon,  7 Mar 2022 01:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F1A56103D;
        Mon,  7 Mar 2022 09:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0451CC340E9;
        Mon,  7 Mar 2022 09:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644930;
        bh=94F1j0DiZ7qJpTyWsfI+MmjhV156Q0ciHj/koAEnTgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1r7a3Y32YbpL5/NHS62mQLjOnlcGl5PgkhWEVnASBu3Uqn3OmQQ3WwCXAdBzvuuMP
         GyMtwb0vC7v+qea3oXW7tu1ONlBD8YI4TZB6jFwb7utQ1+yI4HXHQ14MlSO9wQ5TQO
         l62vcutigLZi1qPKf6SsEKAnUep0dDODSjfhEIVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/42] i2c: cadence: allow COMPILE_TEST
Date:   Mon,  7 Mar 2022 10:18:41 +0100
Message-Id: <20220307091636.364610917@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa@kernel.org>

[ Upstream commit 0b0dcb3882c8f08bdeafa03adb4487e104d26050 ]

Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
and easier maintenance.

Signed-off-by: Wolfram Sang <wsa@kernel.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index c457f65136f83..ab9c7f2f1f79b 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -459,7 +459,7 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
 
 config I2C_CADENCE
 	tristate "Cadence I2C Controller"
-	depends on ARCH_ZYNQ || ARM64 || XTENSA
+	depends on ARCH_ZYNQ || ARM64 || XTENSA || COMPILE_TEST
 	help
 	  Say yes here to select Cadence I2C Host Controller. This controller is
 	  e.g. used by Xilinx Zynq.
-- 
2.34.1



