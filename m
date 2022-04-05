Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCBA4F3B4F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348265AbiDELw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357325AbiDEK0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:26:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBCE2656B;
        Tue,  5 Apr 2022 03:10:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39BC4B81B7A;
        Tue,  5 Apr 2022 10:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E572C385A1;
        Tue,  5 Apr 2022 10:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153400;
        bh=hG3tZNhv8iqzzUd0aDoTnF6ICPSgwvrkFVnMPHgNvpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3Yd5Q2D5sQVsaZFK1kk0c+lRh9Nr4fiYn2mjAVCG/QJIYPseWOdHIsgzm8TJOklL
         B1LZeJR6q7ZpuPmoGQrfERlhNz6a19CX1Q28np+Ac3rvR57YMWpDaoxH0Qy8ico3zE
         +cL5zuz+YHO8h8RFORXaoKQonYJa6i2W7oIQuNOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/599] firmware: ti_sci: Fix compilation failure when CONFIG_TI_SCI_PROTOCOL is not defined
Date:   Tue,  5 Apr 2022 09:28:24 +0200
Message-Id: <20220405070305.089879864@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 043cfff99a18933fda2fb2e163daee73cc07910b ]

Remove an extra ";" which breaks compilation.

Fixes: 53bf2b0e4e4c ("firmware: ti_sci: Add support for getting resource with subtype")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/e6c3cb793e1a6a2a0ae2528d5a5650dfe6a4b6ff.1640276505.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/ti/ti_sci_protocol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/soc/ti/ti_sci_protocol.h b/include/linux/soc/ti/ti_sci_protocol.h
index cf27b080e148..b1af87330f86 100644
--- a/include/linux/soc/ti/ti_sci_protocol.h
+++ b/include/linux/soc/ti/ti_sci_protocol.h
@@ -618,7 +618,7 @@ devm_ti_sci_get_of_resource(const struct ti_sci_handle *handle,
 
 static inline struct ti_sci_resource *
 devm_ti_sci_get_resource(const struct ti_sci_handle *handle, struct device *dev,
-			 u32 dev_id, u32 sub_type);
+			 u32 dev_id, u32 sub_type)
 {
 	return ERR_PTR(-EINVAL);
 }
-- 
2.34.1



