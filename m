Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CB96B49F8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbjCJPRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbjCJPRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:17:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51736A49
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:08:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE6A61AAF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98690C4339B;
        Fri, 10 Mar 2023 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460887;
        bh=IOpSy9e0pg/S/x7wRcGSFA+IZpQ3MyoJMN0TNT1S0+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OW2IAabpeEO+HtINrvMPlbAY00TCCgiaknzqKyR/2otfg2F8w1DvhYmDwZIDiCYnJ
         QCz2SNyA6fgUAZNUL9H+2WiMPtvdB8JoNvEwkJw75yc/uUuxj6ltvS12srPvGTkFNb
         6AeyfNgCPO3Lho2pbTN08kHuDMi/W/Ted9jXlg7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Souradeep Chowdhury <quic_schowdhu@quicinc.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 485/529] bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support
Date:   Fri, 10 Mar 2023 14:40:28 +0100
Message-Id: <20230310133827.324632221@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souradeep Chowdhury <quic_schowdhu@quicinc.com>

[ Upstream commit 6c40624930c58529185a257380442547580ed837 ]

The Data Capture and Compare(DCC) is a debugging tool that uses the bootconfig
for configuring the register values during boot-time. Increase the max nodes
supported by bootconfig to cater to the requirements of the Data Capture and
Compare Driver.

Link: https://lore.kernel.org/all/1674536682-18404-1-git-send-email-quic_schowdhu@quicinc.com/

Signed-off-by: Souradeep Chowdhury <quic_schowdhu@quicinc.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bootconfig.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bootconfig.h b/include/linux/bootconfig.h
index 2696eb0fc1497..df9cbf02d0303 100644
--- a/include/linux/bootconfig.h
+++ b/include/linux/bootconfig.h
@@ -29,7 +29,7 @@ struct xbc_node {
 /* Maximum size of boot config is 32KB - 1 */
 #define XBC_DATA_MAX	(XBC_VALUE - 1)
 
-#define XBC_NODE_MAX	1024
+#define XBC_NODE_MAX	8192
 #define XBC_KEYLEN_MAX	256
 #define XBC_DEPTH_MAX	16
 
-- 
2.39.2



