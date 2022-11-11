Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEF86250D6
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbiKKCiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiKKCg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6784367F6B;
        Thu, 10 Nov 2022 18:35:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06ED661E96;
        Fri, 11 Nov 2022 02:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2AFC433D7;
        Fri, 11 Nov 2022 02:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134149;
        bh=D12S1QJOCBDz/sO5Wa0HDRc7+ODBM7WKRmkzoARuMkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJ2Z8CU42xyTsOcc3vJi3e4VNRwMIfBpx+JxGWywa41+I1E6I0c5fAqL53nQvbLmU
         Quqtg4VRh6Qdvo7BcDEWR5aMrK72uUxCn3e1rhaoM/I4CoEV/wHQrRyo8UD2h5+2ZR
         3TXolyQyDTlLCnJd9Xah+J1vF5+Qu+dL4AUaM5hqmybQSoQkhrWWNNb4CuiIFuUJf4
         dApwKv34Cn8zyk5WLlkeBhJK7QPcdlaWc7eX7O8reUdQMbHt2FIG2Hw8G8NEwt/Nl3
         dpAcwj3StecXruGihgASBlPdZHcfBOKB0uzpUaGkV3nlwqm9Mb7uZXb8WDripNZ4sw
         dj8NZLNkWOPAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nam Cao <namcaov@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        jdelvare@suse.com, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/5] i2c: i801: add lis3lv02d's I2C address for Vostro 5568
Date:   Thu, 10 Nov 2022 21:35:42 -0500
Message-Id: <20221111023545.228051-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023545.228051-1-sashal@kernel.org>
References: <20221111023545.228051-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nam Cao <namcaov@gmail.com>

[ Upstream commit d6643d7207c572c1b0305ed505101f15502c6c87 ]

Dell Vostro 5568 laptop has lis3lv02d, but its i2c address is not known
to the kernel. Add this address.

Output of "cat /sys/devices/platform/lis3lv02d/position" on Dell Vostro
5568 laptop:
    - Horizontal: (-18,0,1044)
    - Front elevated: (522,-18,1080)
    - Left elevated: (-18,-360,1080)
    - Upside down: (36,108,-1134)

Signed-off-by: Nam Cao <namcaov@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 4e6d0b722ddc..2b84db59ab3c 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1253,6 +1253,7 @@ static const struct {
 	 * Additional individual entries were added after verification.
 	 */
 	{ "Vostro V131",        0x1d },
+	{ "Vostro 5568",        0x29 },
 };
 
 static void register_dell_lis3lv02d_i2c_device(struct i801_priv *priv)
-- 
2.35.1

