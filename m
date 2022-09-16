Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22EB5BAAC9
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiIPKTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiIPKR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:17:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA469AF0F7;
        Fri, 16 Sep 2022 03:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36D98B82520;
        Fri, 16 Sep 2022 10:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1B8C433C1;
        Fri, 16 Sep 2022 10:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323096;
        bh=FTyZm82ma7c7kIDojvTdLUTSDMwwa3K7yYhHENatSfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuINz0EDgk7DCwe6y4M3tipysfmE3qk9b7XmviuVVfBaYio4XL1JRrI/TL7epJWPK
         900LOBUH8bAMOZbzFIF0i9uK8tCymEo1Ge3Xd9BnLM8fUu2MvNDP9Flb6BF2g/xmuc
         j5isFjBb5hpqKZSt6xQdE56czJJ4UVLQ+JxtewOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megi@xff.cz>,
        Jarrah Gosbell <kernel@undef.tools>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/35] Input: goodix - add support for GT1158
Date:   Fri, 16 Sep 2022 12:08:36 +0200
Message-Id: <20220916100447.495959142@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
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

From: Ondrej Jirman <megi@xff.cz>

[ Upstream commit 425fe4709c76e35f93f4c0e50240f0b61b2a2e54 ]

This controller is used by PinePhone and PinePhone Pro. Support for
the PinePhone Pro will be added in a later patch set.

Signed-off-by: Ondrej Jirman <megi@xff.cz>
Signed-off-by: Jarrah Gosbell <kernel@undef.tools>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220809091200.290492-1-kernel@undef.tools
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 3667f7e51fde4..54ea593897466 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -94,6 +94,7 @@ static const struct goodix_chip_data gt9x_chip_data = {
 
 static const struct goodix_chip_id goodix_chip_ids[] = {
 	{ .id = "1151", .data = &gt1x_chip_data },
+	{ .id = "1158", .data = &gt1x_chip_data },
 	{ .id = "5663", .data = &gt1x_chip_data },
 	{ .id = "5688", .data = &gt1x_chip_data },
 	{ .id = "917S", .data = &gt1x_chip_data },
-- 
2.35.1



