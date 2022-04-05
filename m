Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135B54F2A69
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiDEKaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238790AbiDEJcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3255F66;
        Tue,  5 Apr 2022 02:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ABAA6144D;
        Tue,  5 Apr 2022 09:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4193C385A0;
        Tue,  5 Apr 2022 09:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150407;
        bh=xGJ+ArF/bMzVzpHzzWR2mQad4zARlA/iBKKkcu48jJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iN6d3vvZln0p3sb7nCg4zIerqhgmHG+g7IB1JUc1IE1qVJRfVC1738iSeV0Keency
         dEk0FmsE8iC5FjIZiJndw23bIvOhZGqdH5mr9YMV3ooO+RGssLeFNxdGH0zDdiHfNH
         EwAOIa13SKolOd+hA+CbTTMmpnRP4+aoz3CetPgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michael=20H=C3=BCbner?= <michaelh.95@t-online.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/913] HID: Add support for open wheel and no attachment to T300
Date:   Tue,  5 Apr 2022 09:17:51 +0200
Message-Id: <20220405070340.092325466@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Michael Hübner <michaelh.95@t-online.de>

[ Upstream commit 0a5a587501b54e8c6d86960b047d4491fd40dcf2 ]

Different add ons to the wheel base report different models. Having
no wheel mounted to the base and using the open wheel attachment is
added here.

Signed-off-by: Michael Hübner <michaelh.95@t-online.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index afdd778a10f0..a28c3e575650 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -64,7 +64,9 @@ struct tm_wheel_info {
  */
 static const struct tm_wheel_info tm_wheels_infos[] = {
 	{0x0306, 0x0006, "Thrustmaster T150RS"},
+	{0x0200, 0x0005, "Thrustmaster T300RS (Missing Attachment)"},
 	{0x0206, 0x0005, "Thrustmaster T300RS"},
+	{0x0209, 0x0005, "Thrustmaster T300RS (Open Wheel Attachment)"},
 	{0x0204, 0x0005, "Thrustmaster T300 Ferrari Alcantara Edition"},
 	{0x0002, 0x0002, "Thrustmaster T500RS"}
 	//{0x0407, 0x0001, "Thrustmaster TMX"}
-- 
2.34.1



