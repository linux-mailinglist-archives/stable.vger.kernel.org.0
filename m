Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CBE6949F6
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjBMPDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjBMPDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:03:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF7A1710
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2A146115A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01202C4339B;
        Mon, 13 Feb 2023 15:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300586;
        bh=8d91AQT1e3CnN4jFQL+iFmU6yHLD1qbExdC4WZSdfkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKVpj/G7iSXMAV955gJxumJ5DYe4dmhJrK7WSgMtki3UVQJDyRccu5mdkuD773XW3
         4zd7GtvJKp27v4Yo26kCedH66FQ6JIHxRtaZXD870LznSEpHJ7np/bgLzNTgjJSRgw
         NUZgBXWNJ5obviiQaYXZyAEiFrnbKrhDtB//QdaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Koba Ko <koba.ko@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/139] platform/x86: dell-wmi: Add a keymap for KEY_MUTE in type 0x0010 table
Date:   Mon, 13 Feb 2023 15:49:48 +0100
Message-Id: <20230213144747.966085276@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

From: Koba Ko <koba.ko@canonical.com>

[ Upstream commit 83bcf3e52e9cfc727df33f1055ef0618c91719d0 ]

Some platforms send the speaker-mute key from EC. dell-wmi can't
recognize it.

Add a new keymap for KEY_MUTE in type 0x0010 table.

Signed-off-by: Koba Ko <koba.ko@canonical.com>
Link: https://lore.kernel.org/r/20230117123436.200440-1-koba.ko@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index bbdb3e860892..6ef327a80ccf 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -259,6 +259,9 @@ static const struct key_entry dell_wmi_keymap_type_0010[] = {
 	{ KE_KEY,    0x57, { KEY_BRIGHTNESSDOWN } },
 	{ KE_KEY,    0x58, { KEY_BRIGHTNESSUP } },
 
+	/*Speaker Mute*/
+	{ KE_KEY, 0x109, { KEY_MUTE} },
+
 	/* Mic mute */
 	{ KE_KEY, 0x150, { KEY_MICMUTE } },
 
-- 
2.39.0



