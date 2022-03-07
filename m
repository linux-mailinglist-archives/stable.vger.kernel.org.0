Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71864CF777
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiCGJqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239744AbiCGJkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891227486F;
        Mon,  7 Mar 2022 01:36:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 423B8B810BD;
        Mon,  7 Mar 2022 09:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FE2C36AE2;
        Mon,  7 Mar 2022 09:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645749;
        bh=KFjAbm0DbIrJYdiTFFJY1+Id3/hhVIdMaWYvBSCbkok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPmlqS63BG6ITv+D6jjZXpnytIR4TyZanA42vl9qwpXKzNsjQaijq/FCT9BDjmEPC
         CmSiNsoPBkwXpC2KsldYaGQTUAOkjCED4RUPyFk1i/AYmNltBxpzyILmhM4sM2NUK8
         ZFlMII/bNOXiAswi3pTuzhABy8CsnClpAS60lSJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/262] i2c: qup: allow COMPILE_TEST
Date:   Mon,  7 Mar 2022 10:16:08 +0100
Message-Id: <20220307091703.054130062@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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

[ Upstream commit 5de717974005fcad2502281e9f82e139ca91f4bb ]

Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
and easier maintenance.

Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index f76aaf9559365..fea403431f228 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -921,7 +921,7 @@ config I2C_QCOM_GENI
 
 config I2C_QUP
 	tristate "Qualcomm QUP based I2C controller"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Qualcomm SoCs.
-- 
2.34.1



