Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8073B621546
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbiKHOKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235234AbiKHOKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:10:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286067722F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AD4C6157D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C50C433D6;
        Tue,  8 Nov 2022 14:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916595;
        bh=gya0bJPhRIzVdB0g3VDNw7gd6/xMQzaHVCvDAQ7OOLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0L765o1GkaZ3kDm0WSQiY+MbpYog79NLrkZ4TLNeIJ/axnubqeq8vC4khJsXf1JpQ
         c/bWWb1T/cq9gDu7Wu6BKFo9l7rWDnOSueBSO2Xzi3RS/24UBT56NODASbxKZS8ugG
         N9Y3FBXAuRSkl0zBPwyWcIfQVJ5wt9tYa4Eh7NgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rory Liu <hellojacky0226@hotmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 072/197] media: platform: cros-ec: Add Kuldax to the match table
Date:   Tue,  8 Nov 2022 14:38:30 +0100
Message-Id: <20221108133358.135832941@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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



