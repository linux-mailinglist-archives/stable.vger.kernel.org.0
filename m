Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35FE6431BF
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbiLETR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiLETQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:16:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150432613E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:15:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9282361324
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75FAC433C1;
        Mon,  5 Dec 2022 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267731;
        bh=a/8J8LHjuPFLkVSYb1lDYZ6PYLQFXbQAJ9J+/WRbQWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYsljI+Hk0d76qqYnB9kpRBLdnvBJ4B0nPhdyg5+rRnq+gAbbbkEBjea6HRexA0GG
         4vviNi6wuvdLoK8Qfw3kNfHch5AQqckN0WT99Md8P3/ez6islYCcHFWZQKWoyyfm+r
         s6DQloTz/hAbWd2ex01XgM5KnNTvcJ4bN3OD5y0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aman Dhoot <amandhoot12@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/77] Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode
Date:   Mon,  5 Dec 2022 20:09:21 +0100
Message-Id: <20221205190801.939050539@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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
index 0714d572e49a..53bd449a5e49 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -192,6 +192,7 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
-- 
2.35.1



