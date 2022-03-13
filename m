Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0FB24D76F5
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 17:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiCMQp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 12:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiCMQp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 12:45:26 -0400
Received: from p-impout009.msg.pkvw.co.charter.net (p-impout009aa.msg.pkvw.co.charter.net [47.43.26.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823983BFB1;
        Sun, 13 Mar 2022 09:44:18 -0700 (PDT)
Received: from 2603-8090-2005-39b3-0000-0000-0000-1064.res6.spectrum.com.com ([24.31.246.181])
        by cmsmtp with ESMTP
        id TRKKn57frIjNRTRKKnG5bk; Sun, 13 Mar 2022 16:44:17 +0000
X-Authority-Analysis: v=2.4 cv=LeovVxTi c=1 sm=1 tr=0 ts=622e1f61
 a=cAe/7qmlxnd6JlJqP68I9A==:117 a=cAe/7qmlxnd6JlJqP68I9A==:17 a=NEAV23lmAAAA:8
 a=n9Sqmae0AAAA:8 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=8T_WfNOM4-2mpt9I8nUA:9
 a=UmAUUZEt6-oIqEbegvw9:22 a=SzazLyfi1tnkUD6oumHU:22 a=AjGcO6oz07-iQ99wixmX:22
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>, stable@vger.kernel.org
Subject: [PATCH] rtw88: Fix missing support for Realtek 8821CE RFE Type 6
Date:   Sun, 13 Mar 2022 11:43:58 -0500
Message-Id: <20220313164358.30426-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Author: Ping-Ke Shih <pkshih@realtek.com>
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfIpqnv6TH9q9vO99+cE/schcP5+CKzsRQUCyAq1KePPO3vQNeDp+Q2zuxqeGTbw2iBX5qnGuBWdNscNj/7oM2+xphC9R2cJcl3EcneZuicpuzMr3efRn
 JWcmLVQWWhp+77tIhTomA3BdG9ax351d9sB52r3WpkpZgadyMdAuVx8KDhEpZ3A/55quEJiA3MqziyZa97hKqw3SZZFsq43xaltuF4vXYP2tfBgDci4N2NQS
 T0kYZzfl/+ooVKaFHGqvLw11Vt0WlGdvtIWQzB1x/Ln23cxf3H7u4KG/TGCVkL0PvTN8rLNCsQxy77pk5A6nExIYJTvaTg9yVEliBmWCXxj3dW+/5cx7sFCM
 njQ/V18mzZcH7BKQ2x1L+7xEaqoohjvuwEU9heXokcQZYSV3wLk=
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The rtl8821ce with RFE Type 6 behaves the same as ones with RFE Type 0.

This change has been tested in the repo at git://GitHub.com/lwfinger/rtw88.git.
It fixes commit 769a29ce2af4 ("rtw88: 8821c: add basic functions").

Fixes: 769a29ce2af4 ("rtw88: 8821c: add basic functions").
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable@vger.kernel.org # 5.9+
---
Kalle,

This patch file was prepared a couple of months ago, but apparently not submitted
then. It should be applied as soon as possible.

Larry
---
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index db078df63f85..b1f4afb50830 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -1514,6 +1514,7 @@ static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8821c, 0, 0),
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[6] = RTW_DEF_RFE(8821c, 0, 0),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
-- 
2.35.1

