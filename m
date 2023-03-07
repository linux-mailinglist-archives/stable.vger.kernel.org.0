Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE8F6AEE74
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjCGSMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjCGSLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:11:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB90029142
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20451B819BA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F0DC433D2;
        Tue,  7 Mar 2023 18:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212418;
        bh=pZDr7Q26PdTgodbfdfcqc+pYhPZBzDfTECAF3TVGyek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGdgBu369sFhUE6fsNqA9wQgES+4iM63WxRQsOvfn5EBuu71/qzWmaOPiaWkPgZO5
         LK4JcxZ9Jew02fzgOFCUp4mAAaSof2aaw+uHDtxkdlRjZprg/H37A/xKZqvKcUyJ3O
         VIFuVIalRdPm975AMofYWFggSzTtaD2UbdJbuMjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/885] platform/chrome: cros_ec_typec: Update port DP VDO
Date:   Tue,  7 Mar 2023 17:51:22 +0100
Message-Id: <20230307170008.313733810@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 8d2b28df6c3dc1581d856f52d9f78059ef2a568f ]

The port advertising DP support is a Type-C receptacle. Fix the port's
DisplayPort VDO to reflect this.

Fixes: 1903adae0464 ("platform/chrome: cros_ec_typec: Add bit offset for DP VDO")
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221228004648.793339-6-pmalani@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 59de4ce01faba..a74d01e9089e1 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -27,7 +27,7 @@
 #define DRV_NAME "cros-ec-typec"
 
 #define DP_PORT_VDO	(DP_CONF_SET_PIN_ASSIGN(BIT(DP_PIN_ASSIGN_C) | BIT(DP_PIN_ASSIGN_D)) | \
-				DP_CAP_DFP_D)
+				DP_CAP_DFP_D | DP_CAP_RECEPTACLE)
 
 /* Supported alt modes. */
 enum {
-- 
2.39.2



