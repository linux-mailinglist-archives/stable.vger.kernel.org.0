Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB915FDFA4
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiJMR44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiJMR4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:56:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C9B65DE;
        Thu, 13 Oct 2022 10:54:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3716B82025;
        Thu, 13 Oct 2022 17:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CC7C433D7;
        Thu, 13 Oct 2022 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683667;
        bh=3WroA/4vqnn9uePZj6BBoC3cuLg33kruPSiHg3MggMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFLezIXUy8bQ46Bm/oP7wYIlS52gtIPRyWP8BfxaDBO6iywh6vb5mq9/3nrCn8dm9
         XpZAjov2uOa2DoDUC12IA/lhWIpyBzkKkQHvtuuZk6E6SfAgrFCa83a2lvAFDDwzF2
         /ks5LMLchM/59yGkx6lGOYqMSWcPIU4uUchHGNfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChanWoo Lee <cw9316.lee@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 5.4 15/38] mmc: core: Replace with already defined values for readability
Date:   Thu, 13 Oct 2022 19:52:16 +0200
Message-Id: <20221013175144.783104209@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
References: <20221013175144.245431424@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChanWoo Lee <cw9316.lee@samsung.com>

commit e427266460826bea21b70f9b2bb29decfb2c2620 upstream.

SD_ROCR_S18A is already defined and is used to check the rocr value, so
let's replace with already defined values for readability.

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220706004840.24812-1-cw9316.lee@samsung.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -799,7 +799,7 @@ try_again:
 	 * the CCS bit is set as well. We deliberately deviate from the spec in
 	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr && (*rocr & 0x01000000)) {
+	if (!mmc_host_is_spi(host) && rocr && (*rocr & SD_ROCR_S18A)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;


