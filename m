Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC044CF94C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239790AbiCGKEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241333AbiCGKBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2898473067;
        Mon,  7 Mar 2022 01:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB01B8102B;
        Mon,  7 Mar 2022 09:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D428BC340F3;
        Mon,  7 Mar 2022 09:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646700;
        bh=XAdpkROvnoCMJTGEPTjC+34Zy9TbnvDoLlFeyd/ocdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPpi3hruWxAxAZIhbJfcp0/0KDlAF9o8di0qIGLogxFFmy/Obtz1bKTx3FzcTJgAe
         mFMWjKnhLAiUVV+G8VD7OnsqSfNMYw9HgLl4JrpoRo4WPBYuUFIG0+WMmjde67n1zP
         wODDBJUMcNZCLP5QHfMjpQAxaH4yiqjA06pibIvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 024/186] i2c: imx: allow COMPILE_TEST
Date:   Mon,  7 Mar 2022 10:17:42 +0100
Message-Id: <20220307091654.771977488@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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

[ Upstream commit 2ce4462f2724d1b3cedccea441c6d18bb360629a ]

Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
and easier maintenance.

Signed-off-by: Wolfram Sang <wsa@kernel.org>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index b1c20859fe8c9..66476c2257553 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -680,7 +680,7 @@ config I2C_IMG
 
 config I2C_IMX
 	tristate "IMX I2C interface"
-	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE
+	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE || COMPILE_TEST
 	select I2C_SLAVE
 	help
 	  Say Y here if you want to use the IIC bus controller on
-- 
2.34.1



