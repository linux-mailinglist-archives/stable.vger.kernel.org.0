Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C78F689632
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbjBCKak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjBCKaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:30:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64029A80A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:29:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBB4961E53
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0DAC433D2;
        Fri,  3 Feb 2023 10:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420165;
        bh=PUM6koC+qKOph7zMlTme+UjPef8R6nOeJ6w3v9nwj7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOuF0ramLQBKz+74ehZlQ1ZwGN/5TcBzxWOW1pu+QjQAu2YRKql1pwuqkp6chNz0w
         +70zsWwRensciAqlpnvUOXc2Iad9YzneQTHg0Z7va62lv3Y6IXpitYKEMDBrc+yJrz
         t/6jpqSUzq+U1Cp0FvHrnaLsO65BwQK3ARzGTvmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Slaby <jirislaby@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 102/134] Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"
Date:   Fri,  3 Feb 2023 11:13:27 +0100
Message-Id: <20230203101028.419231569@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 3c44e2b6cde674797b76e76d3a903a63ce8a18bb upstream.

This reverts commit ac5408991ea6b06e29129b4d4861097c4c3e0d59 because
it causes loss of keyboard on HP 15-da1xxx.

Fixes: ac5408991ea6 ("Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/824effa5-8b9a-c28a-82bb-9b0ab24623e1@kernel.org
Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1206358
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -189,7 +189,6 @@ static const char * const smbus_pnp_ids[
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
-	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 


