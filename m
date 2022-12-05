Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484E964345E
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiLETp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbiLETpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:45:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2F626560
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:42:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEC7861335
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FA5C433C1;
        Mon,  5 Dec 2022 19:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269327;
        bh=cYb27BGY8SejQ3AIoV3asHQMvxsSPUbpmRYdgDbOY+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUaHODXld/eWwJ2Qye26ePHpo9q7XdCeNquBldlro3tt8v5v0rKv2dTlTR1+J77YD
         Ws5KvLggIq1Ux3JM+/my5xgR3drvaMvUmp4lAG8hf6/isgXkdb+w77YOdx4f06cnix
         VYXdIOgsN3FqR3XqKDp5bO+6TkL3W7I8pD2oVF2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aman Dhoot <amandhoot12@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/153] Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode
Date:   Mon,  5 Dec 2022 20:09:43 +0100
Message-Id: <20221205190810.419081803@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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



