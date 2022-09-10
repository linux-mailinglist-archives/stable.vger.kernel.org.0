Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512295B4985
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiIJVUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiIJVUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:20:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1544D240;
        Sat, 10 Sep 2022 14:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AAB8B8093B;
        Sat, 10 Sep 2022 21:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE740C43470;
        Sat, 10 Sep 2022 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844655;
        bh=KcahzQve60dgc9Si8zjPq61t02Py46Nn/o4fttZwpdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jH8zmPTqtCAvypY9l930S5NqFqCB1M8Xh24Jm+VpZn181KAsNjOh0/pb3zi4ja8k/
         Hu41qs2S84VTpLwIIrQYNxR9OuI6fKclEgzRRGsI2SnYXWhawMBkF7crwm/gH/nGuM
         rw4Qy1X16v0KFD1AaH8aWe5LVFNV9yZGvgXafbESoG7zrf7bM2is8gUAUrmUhixAsk
         owE0SVFba/zB2z6JunLiuPaHe/UTrNnE9w99JQVOOuIrMW1fjpqTrx2amzUGH3uWHP
         WwG0no2WAULEWoKEe8LJh7F8VvEaaHX6Yp8lOnmT2Ma/AB+moZXw1ssjv67Ulla4C2
         etZeKgVLrNKEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        srinivas.kandagatla@linaro.org, amahesh@qti.qualcomm.com,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 33/38] misc: fastrpc: increase maximum session count
Date:   Sat, 10 Sep 2022 17:16:18 -0400
Message-Id: <20220910211623.69825-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 689a2d9f9332a27b1379ef230396e944f949a72b ]

The SC8280XP platform uses 14 sessions for the compute DSP so increment
the maximum session count.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220829080531.29681-4-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 93ebd174d8487..08032a207c1c0 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -25,7 +25,7 @@
 #define SDSP_DOMAIN_ID (2)
 #define CDSP_DOMAIN_ID (3)
 #define FASTRPC_DEV_MAX		4 /* adsp, mdsp, slpi, cdsp*/
-#define FASTRPC_MAX_SESSIONS	13 /*12 compute, 1 cpz*/
+#define FASTRPC_MAX_SESSIONS	14
 #define FASTRPC_MAX_VMIDS	16
 #define FASTRPC_ALIGN		128
 #define FASTRPC_MAX_FDLIST	16
-- 
2.35.1

