Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12F55611E3
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 07:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiF3Fne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 01:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiF3Fnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 01:43:33 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1784B1EC7F;
        Wed, 29 Jun 2022 22:43:32 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k22so25542723wrd.6;
        Wed, 29 Jun 2022 22:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sNsoruavgGCDOa6zIwfGVQ3gPIe8zWts0Tb325UtKCk=;
        b=c3H0RsrznPc7KcMTQsdNCnaKd8aXg8jczjApI0Th4Z7BB1CDDd46AjQwynVhn4cOow
         B8uGLTaTYW35RT1INpDNKuhpTtirQ/05AhAwKzGGwcf9mOf/2RBn/ZqVu2xKev4VbyM0
         voXX9M++jSLTRFladEjYiTNoQlT7TtAzaj1T0vBnxlIUky2LjklLPjZ7K7nSpNH8WgUX
         hc+F3rwGN0BiKu7TrE5VP0xY0/IFKUl/hL94CYpWfllsoRtkImdzY5tO5D8gjqEdLrNR
         kKRdM2Iy2BZfQr06I5C3gqCWRa5aZnPMYtxK0YG3ZKbYHwk26ERyOonFbl2lr7hPHIXo
         2EcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sNsoruavgGCDOa6zIwfGVQ3gPIe8zWts0Tb325UtKCk=;
        b=ap3nsqRIbVglIX5uOs5j/QqXFfEsLuOVHino0sBun5QUkoZvjg49kJP/HC+mihkMM2
         UV8wymLXGYVEm0t32SGI6OvoZ/oJMXTEpCbd1aswRR0reS2SVruqanodxqy517R0xf8Y
         yMqtrNF8sq8WZZ52KwxgUE3bhyZ/wUiIt06SsoGjuBWenj2evpmTPyNC9PgSZShyX5Ua
         TT2rLL/R2KXDTlB60xZonsP0TjS8GKlwd7X90ObbEmqi01y1Fm1ml36t43ZglZBQReQm
         bObD04KuLj+63t6m7m1Qx9R9MDDI/2IainJq4M/YVVu0hXj7HnEmRq/Q3O76C+kcLaPH
         N61g==
X-Gm-Message-State: AJIora8+XCUwsdmEp7NFO0hyIwRfsEno1EXfniwMFPuG1CGfEf+p2ZMT
        wPbrsADsovwJ7QQfZ+XYmGI=
X-Google-Smtp-Source: AGRyM1s8o6YScWcQySEP8fO7dhzrUhfQOVU58ewGqYEdklRoB1MFHp44EBzIi8sSICmPaTlpZ+jMYw==
X-Received: by 2002:a05:6000:1f9a:b0:21b:9a99:ee5f with SMTP id bw26-20020a0560001f9a00b0021b9a99ee5fmr6237719wrb.600.1656567810560;
        Wed, 29 Jun 2022 22:43:30 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id m20-20020a7bcf34000000b003a04d54b2f3sm1365612wmg.24.2022.06.29.22.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 22:43:29 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add Amir as xfs maintainer for 5.10.y
Date:   Thu, 30 Jun 2022 08:43:21 +0300
Message-Id: <20220630054321.3008933-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an attempt to direct the bots and human that are testing
LTS 5.10.y towards the maintainer of xfs in the 5.10.y tree.

This is not an upstream MAINTAINERS entry and 5.15.y and 5.4.y will
have their own LTS xfs maintainer entries.

Update Darrick's email address from upstream and add Amir as xfs
maintaier for the 5.10.y tree.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---

Greg,

We decided to try and fork MAINTAINERS.

I don't know if this was attempted before and I don't know if you
think that is a good idea, but the rationale is that at least some
of the scripts that report bugs on LTS, will be running get_maintainer.pl
on the LTS branch they are testing.

The scripts that run get_maintainer.pl on master can be tought to
do the right thing for LTS reporting.
This seems easier and more practical then teaching the scripts to
parse LTS specific entries in upstream MAINTAINERS.

You have another patch like that coming fro Leah for 5.15.y.

Thanks,
Amir.

 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c118b507912..4d10e79030a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19246,7 +19246,8 @@ F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
 
 XFS FILESYSTEM
-M:	Darrick J. Wong <darrick.wong@oracle.com>
+M:	Amir Goldstein <amir73il@gmail.com>
+M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
 S:	Supported
-- 
2.25.1

