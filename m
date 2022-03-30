Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8E84EC0AB
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344108AbiC3Lvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344109AbiC3Lvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:51:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C9D25FD57;
        Wed, 30 Mar 2022 04:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C865FB81BBA;
        Wed, 30 Mar 2022 11:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB95C34112;
        Wed, 30 Mar 2022 11:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640882;
        bh=ggnRzu8aJoUeHTT+3KPleG8rjSsvXE/6Q+QS76nVfVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obmMcmi5NInTke+QiCkTxEpIiIpfgGVtXVxbmQhBii44cnZqBu3EOotiYMcrxqECr
         hkaDLvhx5BPVERJ2rT12gB4Dgx13tDuj1riS8zZ1r9N4X0LDup6964X3jJhGbttwNm
         JPvbXli+E/eheRi6PE9jHeE5CSbbMiHymKRmdPqCChKWIt+atyd4eWexb5npNvsDnB
         gM+MH/6QPxuYa339i+OjM2wnzbZH2rkrw0DGbauWbWX3tG/EH6Vb5KWbCfVsvUH+4H
         oGMG7QhHzihiv6Zk+46vPB4O/TLHZSglExRBcWSc2JyvckpP91PNKx+2LtFNYMwsbG
         D6SPqqP38VBkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        =?UTF-8?q?Maximilian=20B=C3=B6hm?= <maximilian.boehm@elbmurf.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 49/66] media: Revert "media: em28xx: add missing em28xx_close_extension"
Date:   Wed, 30 Mar 2022 07:46:28 -0400
Message-Id: <20220330114646.1669334-49-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit fde18c3bac3f964d8333ae53b304d8fee430502b ]

This reverts commit 2c98b8a3458df03abdc6945bbef67ef91d181938.

Reverted patch causes problems with Hauppauge WinTV dualHD as Maximilian
reported [1]. Since quick solution didn't come up let's just revert it
to make this device work with upstream kernels.

Link: https://lore.kernel.org/all/6a72a37b-e972-187d-0322-16336e12bdc5@elbmurf.de/ [1]

Reported-by: Maximilian Böhm <maximilian.boehm@elbmurf.de>
Tested-by: Maximilian Böhm <maximilian.boehm@elbmurf.de>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index b451ce3cb169..4a46ef50baf9 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -4150,11 +4150,8 @@ static void em28xx_usb_disconnect(struct usb_interface *intf)
 
 	em28xx_close_extension(dev);
 
-	if (dev->dev_next) {
-		em28xx_close_extension(dev->dev_next);
+	if (dev->dev_next)
 		em28xx_release_resources(dev->dev_next);
-	}
-
 	em28xx_release_resources(dev);
 
 	if (dev->dev_next) {
-- 
2.34.1

