Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3017C593FFF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239728AbiHOU4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346834AbiHOUzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:55:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2ACBFE9D;
        Mon, 15 Aug 2022 12:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B153B810A3;
        Mon, 15 Aug 2022 19:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DE9C433C1;
        Mon, 15 Aug 2022 19:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590672;
        bh=EycReFXUTuN8kGxk+znQDQO0kila6gKFLFqmORdtqFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7E6Wrb8vL7Hit+k8WC9eR+UCfsnvq0Wp0tK5EdW5GowsWpAW+PVz9dSyUisC1CgN
         yh2USwrhxqBKCu8kvBNuiZe5eqV0IYpKGNE5U+TJq3ZdSq6+xIHSC2SPzin58a6dhq
         Q+zBolzNi4ix2xHclREFojxeKb1w3iUzZHASWUqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0303/1095] drm/dp: Export symbol / kerneldoc fixes for DP AUX bus
Date:   Mon, 15 Aug 2022 19:55:02 +0200
Message-Id: <20220815180442.306248039@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 39c28cdfb719f0e306b447f0827dfd712f81858b ]

While working on the DP AUX bus code I found a few small things that
should be fixed. Namely the non-devm version of
of_dp_aux_populate_ep_devices() was missing an export. There was also
an extra blank line in a kerneldoc and a kerneldoc that incorrectly
documented a return value. Fix these.

Fixes: aeb33699fc2c ("drm: Introduce the DP AUX bus")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220510122726.v3.1.Ia91f4849adfc5eb9da1eb37ba79aa65fb3c95a0f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/dp/drm_dp_aux_bus.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/dp/drm_dp_aux_bus.c b/drivers/gpu/drm/dp/drm_dp_aux_bus.c
index 415afce3cf96..5f06bc0a34ac 100644
--- a/drivers/gpu/drm/dp/drm_dp_aux_bus.c
+++ b/drivers/gpu/drm/dp/drm_dp_aux_bus.c
@@ -66,7 +66,6 @@ static int dp_aux_ep_probe(struct device *dev)
  * @dev: The device to remove.
  *
  * Calls through to the endpoint driver remove.
- *
  */
 static void dp_aux_ep_remove(struct device *dev)
 {
@@ -120,8 +119,6 @@ ATTRIBUTE_GROUPS(dp_aux_ep_dev);
 /**
  * dp_aux_ep_dev_release() - Free memory for the dp_aux_ep device
  * @dev: The device to free.
- *
- * Return: 0 if no error or negative error code.
  */
 static void dp_aux_ep_dev_release(struct device *dev)
 {
@@ -256,6 +253,7 @@ int of_dp_aux_populate_ep_devices(struct drm_dp_aux *aux)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(of_dp_aux_populate_ep_devices);
 
 static void of_dp_aux_depopulate_ep_devices_void(void *data)
 {
-- 
2.35.1



