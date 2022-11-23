Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F9163549C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiKWJJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237100AbiKWJJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:09:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968DF1025FC
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3397F61B10
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B333C433D7;
        Wed, 23 Nov 2022 09:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194550;
        bh=x59k8a8dxn+UmFAVzcjKfgR6g/7yTXPX/lXKHoUuAsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fHB6DOJcWqeYzYMVkRpCCgD04u9DcRewrNVAY+qLIu+mcCCgZX9Jpq5ZW5K+7DZ4
         KgUWv/Ddfw4BEiMZ0ngGfnm8n+UmKv8mIrrA5YBtxBNKKrgCr3iQvAX1NarIbu7a29
         OLcBU8SLsrOyegBmoKdM4WNhhgnwSocMYFjZiNkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 4.19 080/114] slimbus: stream: correct presence rate frequencies
Date:   Wed, 23 Nov 2022 09:51:07 +0100
Message-Id: <20221123084555.050907593@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit b9c1939627f8185dec8ba6d741e9573a4c7a5834 upstream.

Correct few frequencies in presence rate table - multiplied by 10
(110250 instead of 11025 Hz).

Fixes: abb9c9b8b51b ("slimbus: stream: add stream support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220929165202.410937-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/stream.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/slimbus/stream.c
+++ b/drivers/slimbus/stream.c
@@ -67,10 +67,10 @@ static const int slim_presence_rate_tabl
 	384000,
 	768000,
 	0, /* Reserved */
-	110250,
-	220500,
-	441000,
-	882000,
+	11025,
+	22050,
+	44100,
+	88200,
 	176400,
 	352800,
 	705600,


