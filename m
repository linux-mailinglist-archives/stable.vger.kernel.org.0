Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6AE4EC212
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345130AbiC3L6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345934AbiC3LzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B232BF2;
        Wed, 30 Mar 2022 04:52:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57F93B81C28;
        Wed, 30 Mar 2022 11:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2E1C36AE3;
        Wed, 30 Mar 2022 11:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641176;
        bh=xlVLfQ8SqePoNJyfOFHom3vupBlURqLqC/RgmldWlrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4oN2NkkkvudmII3uhLWLk1S8mpfycB6gW4VOzAFz/Butk5hCksOSI9HMAvdq72EH
         cLPozxY8LLSJUCPHfDOzfI4tIdjfjUO1Csp8Kz+3O5jyn6dfLBZ3/kdgoQenzez3oh
         mdoWPfxuBH6+JRMRDu9ZPKw6XIk16GrF/rEqVYm8tnpPMRc2bNW92/PxNVAAVWgtYK
         9Py0ZA9wYk5+lzTPQbqH9SUYJd9uh/XgY2oq/d5MRaZ7+BR71WcZTWk5nIpBxLxmtE
         k8Gxy/k/xTg/Ph5jkS1fMUeS/iXaTjKgO8MWJ5EzSgb+rv/M3asPwA1sHDiJyRMKX/
         E1hEjnbS3y8AQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        =?UTF-8?q?Maximilian=20B=C3=B6hm?= <maximilian.boehm@elbmurf.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/25] media: Revert "media: em28xx: add missing em28xx_close_extension"
Date:   Wed, 30 Mar 2022 07:52:20 -0400
Message-Id: <20220330115225.1672278-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115225.1672278-1-sashal@kernel.org>
References: <20220330115225.1672278-1-sashal@kernel.org>
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
index bfca9d0a1fe1..64f2033c2731 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -4035,11 +4035,8 @@ static void em28xx_usb_disconnect(struct usb_interface *intf)
 
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

