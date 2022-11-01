Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4626614899
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiKAL22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiKAL2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:28:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94171A05F;
        Tue,  1 Nov 2022 04:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FBD9615C3;
        Tue,  1 Nov 2022 11:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9F5C433C1;
        Tue,  1 Nov 2022 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302067;
        bh=gya0bJPhRIzVdB0g3VDNw7gd6/xMQzaHVCvDAQ7OOLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvtR+s92y+Bk+pbPtngKSfAZYpKO8PIelKj11l8lDysJq5qk5hnED46cqHtBNpvTP
         6IN4pRB7xLGiXWugV/tO7NmN8VR5bqwz9wQfd1ao0fGojYfAg8uCTM+/NQS1feCFOs
         XJoBcDIrkPjdS32iEYLDk9/ZA8caF4u+G1JqjJsXWQkrX4VidC+OHAjLGhvcNfYcXd
         7XwejT9OyJC/nD8qVRo3ruFNzzU41W4Iz9uD+im8M24lxiMmTErsUsW1U1OkMzt5Vy
         Odg3dwUp7jeC11bSWPfv//qNHowNlrfNm8IxyszX//qtHrRo4i0vpHM5k3sRK0SXpj
         7bmfWIiiB7aNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rory Liu <hellojacky0226@hotmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bleung@chromium.org,
        groeck@chromium.org, scott_chao@wistron.corp-partner.google.com,
        ajye_huang@compal.corp-partner.google.com, zhuohao@chromium.org,
        linux-media@vger.kernel.org, chrome-platform@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 09/34] media: platform: cros-ec: Add Kuldax to the match table
Date:   Tue,  1 Nov 2022 07:27:01 -0400
Message-Id: <20221101112726.799368-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rory Liu <hellojacky0226@hotmail.com>

[ Upstream commit 594b6bdde2e7833a56413de5092b6e4188d33ff7 ]

The Google Kuldax device uses the same approach as the Google Brask
which enables the HDMI CEC via the cros-ec-cec driver.

Signed-off-by: Rory Liu <hellojacky0226@hotmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/cros-ec/cros-ec-cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
index e5ebaa58be45..6ebedc71d67d 100644
--- a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
+++ b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
@@ -223,6 +223,8 @@ static const struct cec_dmi_match cec_dmi_match_table[] = {
 	{ "Google", "Moli", "0000:00:02.0", "Port B" },
 	/* Google Kinox */
 	{ "Google", "Kinox", "0000:00:02.0", "Port B" },
+	/* Google Kuldax */
+	{ "Google", "Kuldax", "0000:00:02.0", "Port B" },
 };
 
 static struct device *cros_ec_cec_find_hdmi_dev(struct device *dev,
-- 
2.35.1

