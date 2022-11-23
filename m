Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0A3635E74
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbiKWMx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbiKWMwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:52:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8BF86A7F;
        Wed, 23 Nov 2022 04:44:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2201F61C63;
        Wed, 23 Nov 2022 12:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971D5C433C1;
        Wed, 23 Nov 2022 12:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207470;
        bh=cYb27BGY8SejQ3AIoV3asHQMvxsSPUbpmRYdgDbOY+I=;
        h=From:To:Cc:Subject:Date:From;
        b=OPXU3TetrnoLiOOUnrzYoE/KTURIAyQ7U4b5kgTOXo4a3yoLIiAHO8PDQ+vCY3eea
         hZijpQaU5MSmayv+Ul2QAvZ3fUhTla3BuzQwTRc3YNIvG21Fc8/gR7NGIwPyjrrgLO
         8lVJFhUEIWGiWS3TdThZW/W6HctKATqlAyTFGhIoBp/0cEkdDmAfLAJogRpRSoV/l8
         pwBJSXNyqAXStpOhMn9RG3GS5I5Lxjue2GuH9oPL5Sa7p0O1/dBDUHxUA5gEiuf9yZ
         FuM+J/HrfiKuB94aEOpa7q7pGTZAIjF1g0ReLkshZuRZFjmrXa0FITdurCeDBVwP7T
         wk609XxpDynCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aman Dhoot <amandhoot12@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        wsa+renesas@sang-engineering.com, lyude@redhat.com,
        markpearson@lenovo.com, snafu109@gmail.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/15] Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode
Date:   Wed, 23 Nov 2022 07:44:11 -0500
Message-Id: <20221123124427.266286-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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
index 4b81b2d0fe06..05b007d0a89b 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -189,6 +189,7 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
-- 
2.35.1

