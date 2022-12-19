Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4AC65143A
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 21:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbiLSUq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 15:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiLSUqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 15:46:25 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9494C120A2
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 12:46:24 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i10-20020a25f20a000000b006ea4f43c0ddso12126585ybe.21
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 12:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6S5anngOGqBeJ8dWJgoyIXF8JBImIfN2OM+kqAQMiJE=;
        b=gnQMVJ3xF+K9w4Ke8/SF9LQfX63JngjuAaaKEfwICm0afC0ubsmlLvX2d+aJYYPPut
         xwDVxhQ+UVNR6WozYsWHk2OzoMgMuRCsS7/M2n8kC3agf1OnnvKkjN3Vajtk5OGqxQFA
         7xXkYzcDyqKcOR4oR0UgA1nDOo/Cmx29kWXiVsRI8HQqaTtfntgrPzQGh9MJJepxkBbX
         bU/wUvhMA1u9zzQq9V+8A6YAURGA388ei9l+gpGY8fr57zm3z7k2LLw5klooWKkMe/iT
         G7qCAr3jLShHNmsds2xY+/62uvMpDO/xyAprxT1lJZ4oAusILamm3Cvn4cN/R3SAIwlB
         PvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6S5anngOGqBeJ8dWJgoyIXF8JBImIfN2OM+kqAQMiJE=;
        b=akhXNcxSqUDvo9iAy/icm2q7VzU1suUGCumoN0HbIwrwSP4inLwA0Wqw/37cqbJy2r
         8kIuE60WQHHw3eDwZuwNH+3KiyeRko0+H8NgGo55OzsALXSOSG2FxjyjfdjzmbchSv7U
         07J1qHoIk6AUulXwNuQMorSJhx+egE2s53cRe+Gn+0uuFF0g7CbEYm/wEa2/7MWI87Go
         5yc9sO6dbPXYjQmWAwr6CkOVbjLVns/ZUVTNyxF7kbahbEE74TTcg7gM0IqVGz+59b1B
         ohik5Naxt4AWxAmiK91dKKVq7DESDBGEqh/uZNKWGCkeGrKMx12zC1xCjbZfVGHEUfQt
         fT9A==
X-Gm-Message-State: ANoB5pl0Lvkp4t9JdjyqG43bifYh9dvQqm7FMczqxIxTIkXQTc+ZhjTE
        kduqryOI59byJqeNmHdVSE5RQ5fLpGYBj1E=
X-Google-Smtp-Source: AA0mqf7kZBjoNWYV8TibcRALWUvI1Rfi91G32OQZdtuSY8fGUv9/eoVoqpXctVBvfvV0GPpqkHk4vvZGgsZlRtU=
X-Received: from allenwebb.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:12e8])
 (user=allenwebb job=sendgmr) by 2002:a25:e807:0:b0:6f8:a76c:7a23 with SMTP id
 k7-20020a25e807000000b006f8a76c7a23mr45891538ybd.513.1671482783822; Mon, 19
 Dec 2022 12:46:23 -0800 (PST)
Date:   Mon, 19 Dec 2022 14:46:10 -0600
In-Reply-To: <20221219204619.2205248-1-allenwebb@google.com>
Mime-Version: 1.0
References: <20221219191855.2010466-1-allenwebb@google.com> <20221219204619.2205248-1-allenwebb@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221219204619.2205248-3-allenwebb@google.com>
Subject: [PATCH v9 02/10] rockchip-mailbox: Fix typo
From:   Allen Webb <allenwebb@google.com>
To:     "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Allen Webb <allenwebb@google.com>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A one character difference in the name supplied to MODULE_DEVICE_TABLE
breaks a future patch set, so fix the typo.

Cc: stable@vger.kernel.org
Fixes: f70ed3b5dc8b ("mailbox: rockchip: Add Rockchip mailbox driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Allen Webb <allenwebb@google.com>
---
 drivers/mailbox/rockchip-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/rockchip-mailbox.c b/drivers/mailbox/rockchip-mailbox.c
index 979acc810f30..ca50f7f176f6 100644
--- a/drivers/mailbox/rockchip-mailbox.c
+++ b/drivers/mailbox/rockchip-mailbox.c
@@ -159,7 +159,7 @@ static const struct of_device_id rockchip_mbox_of_match[] = {
 	{ .compatible = "rockchip,rk3368-mailbox", .data = &rk3368_drv_data},
 	{ },
 };
-MODULE_DEVICE_TABLE(of, rockchp_mbox_of_match);
+MODULE_DEVICE_TABLE(of, rockchip_mbox_of_match);
 
 static int rockchip_mbox_probe(struct platform_device *pdev)
 {
-- 
2.37.3

