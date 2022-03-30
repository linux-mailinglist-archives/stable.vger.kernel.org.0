Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A584EC1CA
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241905AbiC3L5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345499AbiC3Lyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5A5285680;
        Wed, 30 Mar 2022 04:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BB8961671;
        Wed, 30 Mar 2022 11:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B681C340F2;
        Wed, 30 Mar 2022 11:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641071;
        bh=Y66+Jl3ZAG1Akrs5hWPgXgzuzMYmTlNbhpqvnCTJ//0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLsaibRP2HMBCf6krhf7k2oGyqATh2WnflW8WwKLqDGn2lpd3DLZ7b2GUSb3MiJ/V
         wBnhG+ruQfUD5/kDtk3eXuXIPrxxejvhAm3ebkvNND9DZEqdupfe8HeTKvMfHN9i3r
         +KLZaKE6rmge3/U1+7AKVSpINU/HqPXD+CKJ2ZIDiOPPSo1qN0yjkETpZ2cQLjtV06
         vFYrzuRWO2AMum1df3gvUNGn5cntN2RNOU3Z/MLtoAgMizPUwgEoyBG/12oHJexJMf
         KI5BZSITdJtv+aRKVnPv0fWVuF/UFrpJnuMEumr5RAVZoqd6WFgrZqLBsoWnJZTgPw
         T1HpwNiiYAq+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        =?UTF-8?q?Maximilian=20B=C3=B6hm?= <maximilian.boehm@elbmurf.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 43/50] media: Revert "media: em28xx: add missing em28xx_close_extension"
Date:   Wed, 30 Mar 2022 07:49:57 -0400
Message-Id: <20220330115005.1671090-43-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
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
index ebc430b05f21..44166becc850 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -4145,11 +4145,8 @@ static void em28xx_usb_disconnect(struct usb_interface *intf)
 
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

