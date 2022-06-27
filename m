Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8CA55D15F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbiF0Lvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238346AbiF0Luu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC5A2640;
        Mon, 27 Jun 2022 04:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D3C161240;
        Mon, 27 Jun 2022 11:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3A9C3411D;
        Mon, 27 Jun 2022 11:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330235;
        bh=YKO1eM2YLao07HJsQnH3Deq/iTutfUzqtIVBaEnnHag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrPQlCpT5sLTTDipvIRA6p8OBz5AOwp8iPsbai3af3F0M4tn58ja2No7CKUigdjkZ
         MZSVZ+Jlm1QSPdGTvA+xswUX3eu+w4tJ/sZYo15oQYVPmdHsu8WTM9QGSBC3JtJN19
         H5SVd2ytrofv36FYsc9vZFhNfZ01McDCrBAOAwMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 092/181] iommu/ipmmu-vmsa: Fix compatible for rcar-gen4
Date:   Mon, 27 Jun 2022 13:21:05 +0200
Message-Id: <20220627111947.226990111@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 9f7d09fe23a0112c08d2326d9116fccb5a912660 ]

Fix compatible string for R-Car Gen4.

Fixes: ae684caf465b ("iommu/ipmmu-vmsa: Add support for R-Car Gen4")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220617010107.3229784-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/ipmmu-vmsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 8fdb84b3642b..1d42084d0276 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -987,7 +987,7 @@ static const struct of_device_id ipmmu_of_ids[] = {
 		.compatible = "renesas,ipmmu-r8a779a0",
 		.data = &ipmmu_features_rcar_gen4,
 	}, {
-		.compatible = "renesas,rcar-gen4-ipmmu",
+		.compatible = "renesas,rcar-gen4-ipmmu-vmsa",
 		.data = &ipmmu_features_rcar_gen4,
 	}, {
 		/* Terminator */
-- 
2.35.1



