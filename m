Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD7A65143E
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 21:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiLSUq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 15:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiLSUq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 15:46:27 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D511276F
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 12:46:26 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id l13-20020a056e021c0d00b003034e24b866so7340054ilh.22
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 12:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S7UrSOUGP+a8SdpdysICkGiHV2UeH0pTpanyW1FANts=;
        b=awanE9lkV2lS1NwSLmOwByOYf9g/kmku46qRrN0Qko+KTOC8NCLFn939E5b1YSq9iE
         e8I9HjrFjaRH0YufjNA1YtUq9cELaJ/9oNQKRTURdsAHf0fZon3vCt85dCE7CkNfgrjC
         GXtBmi0BQRPJPJkYcQi54sqSOrS4J5dF1RyBWcpQyas9hZUtYOs4UVkV/JtfbIWA2egd
         cvWbTIKloG9IS/l1R1KDWneqFiiJf4OOK/QnHPK1LYTUrkxwjGNgcqRHPCMesXO+htkB
         kQtPISQPX62cnn3pPqXepP2ZWMru0HvYxM01YPdFLwKrtpmjVBJsOC3Ox96baIQSNggn
         BdlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7UrSOUGP+a8SdpdysICkGiHV2UeH0pTpanyW1FANts=;
        b=kytOtDXao4a3cAl2Nz8a49k30c400kU7xaWMi8cNVJLh+vW4zu5XrUW9iA0maB7XVL
         apnbOA5FH5lO6uqui1BUNs/jvCZ52FKhQBlh+YeOEBXmJJ2WEBnyADt0FMzw7s/GHMNR
         bShKRo8hVPoGmPPnq2Iq97Q153WQAbkGuIxx99B9zYFLwKyxPXfU/nbVcurfeiuZ0Yns
         u8/ld5lNl6qJZwSAkmtNnfmrOJN2g9WMfpkHG4ifJEHGJz9ekLDWWkcbl5dmy+/j9ojk
         cLvt9vkhK/er4mv5ZczuxzSx99yiH99UkKiK9iJbIyQeJoQK+PGIexPJmkMGju6Rzm0t
         /9sQ==
X-Gm-Message-State: AFqh2kpXsTs89YvmNTD873HbC6KMl+hV26Fj+mXTnpq/o0ZgGIF68ZJv
        7OS23wwxalC3LK9QDmE2Seo2Uhz8AJHIWpc=
X-Google-Smtp-Source: AMrXdXvASLX+bEGK9PqHTbJ1D5tdl6EsQ+ZoWrZiL0X8c3M6xdBh7C7vDHsT1vuh3MKDIJ0/3XEWDcW2a90QzlA=
X-Received: from allenwebb.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:12e8])
 (user=allenwebb job=sendgmr) by 2002:a05:6e02:ec7:b0:30b:b665:fdc4 with SMTP
 id i7-20020a056e020ec700b0030bb665fdc4mr529287ilk.27.1671482786264; Mon, 19
 Dec 2022 12:46:26 -0800 (PST)
Date:   Mon, 19 Dec 2022 14:46:12 -0600
In-Reply-To: <20221219204619.2205248-1-allenwebb@google.com>
Mime-Version: 1.0
References: <20221219191855.2010466-1-allenwebb@google.com> <20221219204619.2205248-1-allenwebb@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221219204619.2205248-5-allenwebb@google.com>
Subject: [PATCH v9 04/10] stmpe-spi: Fix typo
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

A small difference in the name supplied to MODULE_DEVICE_TABLE
breaks a future patch set, so fix the typo.

Cc: stable@vger.kernel.org
Fixes: e789995d5c61 ("mfd: Add support for STMPE SPI interface")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Allen Webb <allenwebb@google.com>
---
 drivers/mfd/stmpe-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index ad8055a0e286..6791a5368977 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -129,7 +129,7 @@ static const struct spi_device_id stmpe_spi_id[] = {
 	{ "stmpe2403", STMPE2403 },
 	{ }
 };
-MODULE_DEVICE_TABLE(spi, stmpe_id);
+MODULE_DEVICE_TABLE(spi, stmpe_spi_id);
 
 static struct spi_driver stmpe_spi_driver = {
 	.driver = {
-- 
2.37.3

