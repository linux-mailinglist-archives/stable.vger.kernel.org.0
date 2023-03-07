Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596EE6AF2FE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjCGS6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbjCGS6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:58:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00241B79E6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:45:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95E96B819D2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08222C433D2;
        Tue,  7 Mar 2023 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214727;
        bh=rNGADHJy3eePnzbqDz9rHr2kAkoEd4vGmPrPiHYlVXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOCdJAS8o+Seqv/E6nVL77vLuqYYjiKEYq9HN6PKpOwpWFU55GCKapZuellrehRqk
         xbPc3/g/kxjQt9lls3HkuWzUdd+xEf0O5bRREaCNOGbKzQz9I1rxbvuVOB+wU15zoV
         IBhTGNWJRRLLo0/wFunEuryEyqDOQAFe6OBS9P4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/567] ARM: bcm2835_defconfig: Enable the framebuffer
Date:   Tue,  7 Mar 2023 17:56:06 +0100
Message-Id: <20230307165907.233382424@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit afc8dd99840b7fb7190e769a893cda673bc3a907 ]

Booting Linux on a Raspberry Pi based on bcm2835_defconfig there is
no display activity.

Enable CONFIG_FB which is nowadays required for CONFIG_FB_SIMPLE
and CONFIG_FRAMEBUFFER_CONSOLE.

Fixes: f611b1e7624c ("drm: Avoid circular dependencies for CONFIG_FB")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20230113205842.17051-1-stefan.wahren@i2se.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/bcm2835_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index 383c632eba7bd..1e244a9287902 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -108,6 +108,7 @@ CONFIG_MEDIA_SUPPORT=y
 CONFIG_MEDIA_CAMERA_SUPPORT=y
 CONFIG_DRM=y
 CONFIG_DRM_VC4=y
+CONFIG_FB=y
 CONFIG_FB_SIMPLE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_SOUND=y
-- 
2.39.2



