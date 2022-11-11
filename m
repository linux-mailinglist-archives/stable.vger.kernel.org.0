Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1345B6250B9
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiKKChe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiKKCgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BAE61BB1;
        Thu, 10 Nov 2022 18:35:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FA0061E8B;
        Fri, 11 Nov 2022 02:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00DFC43143;
        Fri, 11 Nov 2022 02:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134138;
        bh=Oct1CCLUuZzv8fyT8cTIxJxmEbxlDlfS6fPcJMbzTqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZmi6xVSDcOMRXVfjFBcYGnkSuBTIrC5Z/m0SDfmWmh14wMx8u2m+yAVaJA1ieThn
         wxd3RhQQplUeLukOAcme/Usje0VaSbwUNfQ0ACdvxO/xjz5SVI6sm4pe6Xwa80ZDbP
         MTyzIWbfrWgBJc3pFTMLInDGefxrj7HxWbSVx4krDZ2FnI3Y/JLKM76gfv9Ag3ssZh
         HanWVcgw+8QmbcClY+CU4YH0YQSMQVUK4Er/TAxCFysW7HgMTyXofP/MYeTsD03LCo
         pO4EELorlHI90Aq8o883SFaL3KifE6tz5Iw/ayEIf9PxK2IUT0G957BaTlIoRSJLMD
         zoygwiRVXJBQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nam Cao <namcaov@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        jdelvare@suse.com, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 3/6] i2c: i801: add lis3lv02d's I2C address for Vostro 5568
Date:   Thu, 10 Nov 2022 21:35:29 -0500
Message-Id: <20221111023532.227959-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023532.227959-1-sashal@kernel.org>
References: <20221111023532.227959-1-sashal@kernel.org>
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
index 5618c1ff34dc..45682d30d705 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1275,6 +1275,7 @@ static const struct {
 	 */
 	{ "Latitude 5480",      0x29 },
 	{ "Vostro V131",        0x1d },
+	{ "Vostro 5568",        0x29 },
 };
 
 static void register_dell_lis3lv02d_i2c_device(struct i801_priv *priv)
-- 
2.35.1

