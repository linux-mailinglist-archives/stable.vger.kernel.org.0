Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2E74F26B2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiDEIGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbiDEH74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6841AF1B;
        Tue,  5 Apr 2022 00:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B517B81B18;
        Tue,  5 Apr 2022 07:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1AEC340EE;
        Tue,  5 Apr 2022 07:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145391;
        bh=arK/Jdx6Jya54jloe0rN7JBuzPaeDIP9HfZ2GK9PVNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qx/E1JVrZ42YgazBO1J7fKevAowx5vgudt8gH3MP1M1VxMpEEpGlyFrjJD/AF1OGy
         ACVXEL+sho1T+/BhZeYHGlpTIHqyl6VseothFnUf0o1+bp/DTXlr7Gtq+CuOd3tmXA
         TdTd2YBpjVx66/MaCSIR0OLIGf3ndg7DWVZlTv/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0340/1126] firmware: ti_sci: Fix compilation failure when CONFIG_TI_SCI_PROTOCOL is not defined
Date:   Tue,  5 Apr 2022 09:18:07 +0200
Message-Id: <20220405070417.595774113@linuxfoundation.org>
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
index 0aad7009b50e..bd0d11af76c5 100644
--- a/include/linux/soc/ti/ti_sci_protocol.h
+++ b/include/linux/soc/ti/ti_sci_protocol.h
@@ -645,7 +645,7 @@ devm_ti_sci_get_of_resource(const struct ti_sci_handle *handle,
 
 static inline struct ti_sci_resource *
 devm_ti_sci_get_resource(const struct ti_sci_handle *handle, struct device *dev,
-			 u32 dev_id, u32 sub_type);
+			 u32 dev_id, u32 sub_type)
 {
 	return ERR_PTR(-EINVAL);
 }
-- 
2.34.1



