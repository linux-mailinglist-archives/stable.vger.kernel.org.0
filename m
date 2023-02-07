Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C63268D7A3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjBGNBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjBGNBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976243A580
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27BA6B81993
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627B1C4339B;
        Tue,  7 Feb 2023 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774874;
        bh=UaPsElJ3PyE8FI45seQnHwjHKE+lgR2HwsSU5iFta8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MxThs+dJ9yY4OOw2ZsuDr+/Kcrmkmqw2EV6UpZTbKo2JDsY4PRSfvyzfDx4qPXLT
         hcwcbfIBW5k/r5yywu5Pe6IoJDhzl8FryqQ71xoF4SWVe/Gfxxp64ZRogZXOnUrxej
         tmsODdww8+ImXOcKccrFnmoZMt/2GtFxZcowLUyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Roper <matthew.d.roper@intel.com>,
        Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/208] drm/i915/adlp: Fix typo for reference clock
Date:   Tue,  7 Feb 2023 13:55:17 +0100
Message-Id: <20230207125637.150254742@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

[ Upstream commit 47a2bd9d985bfdb55900f313603619fc9234f317 ]

Fix typo for reference clock from 24400 to 24000.

Bspec: 55409
Fixes: 626426ff9ce4 ("drm/i915/adl_p: Add cdclk support for ADL-P")
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230112094131.550252-1-chaitanya.kumar.borah@intel.com
(cherry picked from commit 2b6f7e39ccae065abfbe3b6e562ec95ccad09f1e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
index ed05070b7307..92925f0f7239 100644
--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -1323,7 +1323,7 @@ static const struct intel_cdclk_vals adlp_cdclk_table[] = {
 	{ .refclk = 24000, .cdclk = 192000, .divider = 2, .ratio = 16 },
 	{ .refclk = 24000, .cdclk = 312000, .divider = 2, .ratio = 26 },
 	{ .refclk = 24000, .cdclk = 552000, .divider = 2, .ratio = 46 },
-	{ .refclk = 24400, .cdclk = 648000, .divider = 2, .ratio = 54 },
+	{ .refclk = 24000, .cdclk = 648000, .divider = 2, .ratio = 54 },
 
 	{ .refclk = 38400, .cdclk = 179200, .divider = 3, .ratio = 14 },
 	{ .refclk = 38400, .cdclk = 192000, .divider = 2, .ratio = 10 },
-- 
2.39.0



