Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EE14F2A11
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343585AbiDEI5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242107AbiDEIgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEF9186CD;
        Tue,  5 Apr 2022 01:32:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55B5E60B0E;
        Tue,  5 Apr 2022 08:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A5EC385A0;
        Tue,  5 Apr 2022 08:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147541;
        bh=tSoeaE+WjF/2U0/bRU+xgk2xTbobXqV74Tlrj1zdDgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9YDojFQmk4QpWjUNv5TlW5hvkHWGIUoAcWydr2/i51dG2HHMASF060lV8oZ8187C
         24K01145MO7h2mBV8RMSsJc17YI40EwCpFF6hAOlerwFg9lRAEfFgv9V+a+MTEjvFl
         i3guvNxSxBLx9AVnVnlTgSsW6AVIPuTX8rvCLaYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michael=20H=C3=BCbner?= <michaelh.95@t-online.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0008/1017] HID: Add support for open wheel and no attachment to T300
Date:   Tue,  5 Apr 2022 09:15:21 +0200
Message-Id: <20220405070354.418014590@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 9da4240530dd..c3e6d69fdfbd 100644
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



