Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D556D47A2
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbjDCOV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbjDCOVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:21:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37742CAF9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA5C2B81BBE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D0EC433EF;
        Mon,  3 Apr 2023 14:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531696;
        bh=KVbgQFvAPmEHA1ZL6jDpi4Wr2grnJil6/b2CD+0LAwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGaPFf21HyXIJDanL+tXhlvTSIhLYuVVpKd5sp2FecIHleiZ0QSZ/EIIJww9Tknry
         PzIG3Gm5tQVHx01sEK1venuTkYdHI6JYt4UnOS42iFS9uSFj6s+QgLyE3v///wIs+o
         3jOZ3f3jL4BUg4vBV+8wHhYu1VfuXAgYvOFhqooE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Colin Ian King <colin.king@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/104] regulator: fix spelling mistake "Cant" -> "Cant"
Date:   Mon,  3 Apr 2023 16:09:09 +0200
Message-Id: <20230403140407.144732695@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 09dad81e0f1701ea26babe2442a1478d6ad447d3 ]

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20200810093931.50624-1-colin.king@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 02bcba0b9f9d ("regulator: Handle deferred clk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index f81533070058e..145402cc9ef26 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -181,7 +181,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 
 		drvdata->enable_clock = devm_clk_get(dev, NULL);
 		if (IS_ERR(drvdata->enable_clock)) {
-			dev_err(dev, "Cant get enable-clock from devicetree\n");
+			dev_err(dev, "Can't get enable-clock from devicetree\n");
 			return -ENOENT;
 		}
 	} else {
-- 
2.39.2



