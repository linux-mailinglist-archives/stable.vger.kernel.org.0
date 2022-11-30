Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B885E63E004
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiK3Sw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiK3Swr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D55AE60
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 085F661D54
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8C2C433D7;
        Wed, 30 Nov 2022 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834359;
        bh=OEz5pe170WRbn7bIErG4oxky6D1iXWKCqtNHxTaSKzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vszxdBLKtEPq6ZkMkOXb1HPOvob6d3Ou22eqv+i8U+9EZnn4bn5+um17zz6gi6dU9
         5AVUpX5dRvyG/pRwCq9k4uJNITQVV4c/BinE41zfTBR1nxBiUBy1PXyucEkKfOgGJl
         hYIIPrMC78V393brnFxQWR5RsMyq9Xanf8Qr9hPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aman Dhoot <amandhoot12@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 224/289] Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode
Date:   Wed, 30 Nov 2022 19:23:29 +0100
Message-Id: <20221130180549.194762639@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Aman Dhoot <amandhoot12@gmail.com>

[ Upstream commit ac5408991ea6b06e29129b4d4861097c4c3e0d59 ]

The device works fine in native RMI mode, there is no reason to use legacy
PS/2 mode with it.

Signed-off-by: Aman Dhoot <amandhoot12@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index ffad142801b3..973a4c1d5d09 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -191,6 +191,7 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
-- 
2.35.1



