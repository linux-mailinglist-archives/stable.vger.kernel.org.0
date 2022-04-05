Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CAE4F3099
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245453AbiDEIzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241224AbiDEIc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D63EC4;
        Tue,  5 Apr 2022 01:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0852BB81B18;
        Tue,  5 Apr 2022 08:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FA6C385A1;
        Tue,  5 Apr 2022 08:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147387;
        bh=tLa8NN/Yoj4VYi5UBfeaoJ1QM4N3G25Do5BZ6upOFJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZgsMzZVkcondMeWnDUc/H7cLPjpLnrBYJL71USkiF4t0IHIFJZaX85Q8WNYDi0ls
         JZtrQx8g40ch92Wm1TL1LUQD6fxHGzQrCqpyQrZr/9+OtuGC8CE2+27DVGJQaT69DX
         WuAL2Wvf1HVSXaLzYfO+r+eyCZ4JYN9sz8gOOIRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guodong Liu <guodong.liu@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.17 1106/1126] pinctrl: canonical rsel resistance selection property
Date:   Tue,  5 Apr 2022 09:30:53 +0200
Message-Id: <20220405070439.903221397@linuxfoundation.org>
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

From: Guodong Liu <guodong.liu@mediatek.com>

commit 7966c5051fc7d52425155ab30ad568d9d97f3b02 upstream.

Change "mediatek,rsel_resistance_in_si_unit" to "mediatek,rsel-resistance-in-si-unit"

Fixes: fb34a9ae383a ("pinctrl: mediatek: support rsel feature")
Signed-off-by: Guodong Liu <guodong.liu@mediatek.com>
Link: https://lore.kernel.org/r/20220216032124.28067-4-guodong.liu@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -984,7 +984,7 @@ int mtk_paris_pinctrl_probe(struct platf
 	hw->nbase = hw->soc->nbase_names;
 
 	if (of_find_property(hw->dev->of_node,
-			     "mediatek,rsel_resistance_in_si_unit", NULL))
+			     "mediatek,rsel-resistance-in-si-unit", NULL))
 		hw->rsel_si_unit = true;
 	else
 		hw->rsel_si_unit = false;


