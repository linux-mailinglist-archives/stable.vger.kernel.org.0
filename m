Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA6579ED9
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243059AbiGSNHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243066AbiGSNGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:06:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178C5A026A;
        Tue, 19 Jul 2022 05:27:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 093E0B81B21;
        Tue, 19 Jul 2022 12:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EDBC341C6;
        Tue, 19 Jul 2022 12:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233618;
        bh=3+J+jXiwac6CPBiXGQ37Kj8fZs/sHyewEEB+TPIh7go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SA7HnKBMxYH4CKc2jzcXcTIjpQw2Db7R3Ey5LyccH+/8wk39b8wr6fHcIeXKQdrDK
         2IMxFVzm/qPAKSPodQVZLKL/cEvYy5pcorZ1Vl/XDblK/USlZvobwxacepGiKxb49Y
         2oI5aL0yrZFwi+G6nLL4JIw8bHMfWki66Rk5hneU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 154/231] tee: tee_get_drvdata(): fix description of return value
Date:   Tue, 19 Jul 2022 13:53:59 +0200
Message-Id: <20220719114727.251309441@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit e5ce073c8a1e01b215a5eb32ba48f8d17ded3bd5 ]

This patch fixes the description of tee_get_drvdata()'s return value.
It actually returns the driver_data pointer supplied to
tee_device_alloc() since the TEE subsystem was added to the kernel.

Fixes: 967c9cca2cc5 ("tee: generic TEE subsystem")
Cc: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 8aa1a4836b92..cebe4963ad87 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -1075,7 +1075,7 @@ EXPORT_SYMBOL_GPL(tee_device_unregister);
 /**
  * tee_get_drvdata() - Return driver_data pointer
  * @teedev:	Device containing the driver_data pointer
- * @returns the driver_data pointer supplied to tee_register().
+ * @returns the driver_data pointer supplied to tee_device_alloc().
  */
 void *tee_get_drvdata(struct tee_device *teedev)
 {
-- 
2.35.1



