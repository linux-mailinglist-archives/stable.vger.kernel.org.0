Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043FD5940B8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243783AbiHOVJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347911AbiHOVHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CC452DFF;
        Mon, 15 Aug 2022 12:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F36D7B8107A;
        Mon, 15 Aug 2022 19:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DC6C433C1;
        Mon, 15 Aug 2022 19:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590986;
        bh=4w1Henxr21HxdIOW24rJo+vlghp87PGzvVsvvHwWgHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1A22LiW/6Ek29wZoGlLR1C0iaevQ7G4GBQobEhjnr+7wtqemaD8WUVCVr3wgTDXbY
         Z4b1XjfHyPqCteNHmZ/sW+JllxBI6jBrLbxiUh7lwFGKj4BnS7Rp3yh2Utgyv7mslw
         yssq77dSiHxiIgfDZSLuHXYQ22yLCA0K6oge7vA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0404/1095] net: mscc: ocelot: delete ocelot_port :: xmit_template
Date:   Mon, 15 Aug 2022 19:56:43 +0200
Message-Id: <20220815180446.421996832@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 15f6d01e4829cd2a2dc4f02a00c51d7cec1c736d ]

This is no longer used since commit 7c4bb540e917 ("net: dsa: tag_ocelot:
create separate tagger for Seville").

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/soc/mscc/ocelot.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9b4e6c78d0f4..b191f0a7fe26 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -663,7 +663,6 @@ struct ocelot_port {
 
 	phy_interface_t			phy_mode;
 
-	u8				*xmit_template;
 	bool				is_dsa_8021q_cpu;
 	bool				learn_ena;
 
-- 
2.35.1



