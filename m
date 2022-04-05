Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406494F2EBC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbiDEInU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241094AbiDEIcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA19140F6;
        Tue,  5 Apr 2022 01:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D09C461001;
        Tue,  5 Apr 2022 08:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6B2C385A2;
        Tue,  5 Apr 2022 08:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147237;
        bh=AxMd18gbofm6w4krU29ftLJswZhLQ32cx6ujG2KM8Xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4gmTpRyN1b9/jjzOAekH0kQK8tBhGdPya5qrfToy0H8HkDmW4vh4yiabyemK+vGq
         xkWZc5UsrSX4UTw3QK21eLqodFvDexafv99XIgs+BOdRxgXzJjaeNnLHQEtHfxRH3M
         6KwQ8fw89IRTI1c2ePNCRr4kbgwlZzuc0W4Qs3zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.17 1044/1126] pinctrl: nuvoton: npcm7xx: Use %zu printk format for ARRAY_SIZE()
Date:   Tue,  5 Apr 2022 09:29:51 +0200
Message-Id: <20220405070438.116405741@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

commit 9d0f18bca3b557ae5d2128661ac06d33b3f45c0a upstream.

When compile-testing on 64-bit architectures, GCC complains about the
mismatch of types between the %d format specifier and value returned by
ARRAY_LENGTH(). Use %zu, which is correct everywhere.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 3b588e43ee5c7 ("pinctrl: nuvoton: add NPCM7xx pinctrl and GPIO driver")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220205155332.1308899-2-j.neuschaefer@gmx.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
@@ -1560,7 +1560,7 @@ static int npcm7xx_get_groups_count(stru
 {
 	struct npcm7xx_pinctrl *npcm = pinctrl_dev_get_drvdata(pctldev);
 
-	dev_dbg(npcm->dev, "group size: %d\n", ARRAY_SIZE(npcm7xx_groups));
+	dev_dbg(npcm->dev, "group size: %zu\n", ARRAY_SIZE(npcm7xx_groups));
 	return ARRAY_SIZE(npcm7xx_groups);
 }
 


