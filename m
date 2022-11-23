Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BF4635545
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiKWJRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237461AbiKWJRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:17:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A159107E53
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:16:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40A7BB81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967D2C433C1;
        Wed, 23 Nov 2022 09:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194995;
        bh=x59k8a8dxn+UmFAVzcjKfgR6g/7yTXPX/lXKHoUuAsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOC+K/YEUN0lARE0WKRngSwYtTUbfzzK3/s5pMCBXqVgZv6o8UxOLN6Gf8hvECPCL
         iXRkYwICrKQN/2Iwt9D/CEkzkgPShzmXiRhSgfyHB/w9AHJFo0XwfuPyo5kcjUBnHw
         4Q72u42QAMmP7qq2qDp3Xxi19yLmW1HgJ31uJG7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.4 117/156] slimbus: stream: correct presence rate frequencies
Date:   Wed, 23 Nov 2022 09:51:14 +0100
Message-Id: <20221123084602.182678243@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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


