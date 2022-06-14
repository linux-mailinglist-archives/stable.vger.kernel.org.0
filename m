Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09FC54A509
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350908AbiFNCLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351572AbiFNCLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:11:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077963466A;
        Mon, 13 Jun 2022 19:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EEFBB8169B;
        Tue, 14 Jun 2022 02:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B04EC3411E;
        Tue, 14 Jun 2022 02:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172422;
        bh=LUqjWhd2x19oH7kQGPvqJsFKkYqV5H/4feAZdzzEdv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azep3MWpbswUgA1/19rF6cSzK48uV123lVMNeC69OxcE+RAjkqSVLzFbwkZozOFaX
         mtjgXCLeIlb525B6mid11+cAnXmGAXdujveOz+l/5WnQbDtf7eouxvM70g11xovnnb
         LHjLu2hqKWDaUQqhQhAdCrA3MmgFGLOxi0418G6tH1o0pDaZxVMUM0fTOAgsNlFpLe
         LIDX2rgGWnB7QwhPmeewkvkTn+WyJXNZXr7mjQlFoVMUe38FC7swFb1da51BWO+PAH
         g3AXIL5Uvys0yUSW8C7s0DL5msYOcYiyxXpibVPa29geboGfeO+vnySCwH1HqUTK5z
         sGYYGZ2/5V1UQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George D Sworo <george.d.sworo@intel.com>,
        "David E . Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 40/43] platform/x86/intel: pmc: Support Intel Raptorlake P
Date:   Mon, 13 Jun 2022 22:05:59 -0400
Message-Id: <20220614020602.1098943-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020602.1098943-1-sashal@kernel.org>
References: <20220614020602.1098943-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George D Sworo <george.d.sworo@intel.com>

[ Upstream commit 552f3b801de6eb062b225a76e140995483a0609c ]

Add Raptorlake P to the list of the platforms that intel_pmc_core driver
supports for pmc_core device. Raptorlake P PCH is based on Alderlake P
PCH.

Signed-off-by: George D Sworo <george.d.sworo@intel.com>
Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20220602012617.20100-1-george.d.sworo@intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index ac19fcc9abbf..8ee15a7252c7 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1912,6 +1912,7 @@ static const struct x86_cpu_id intel_pmc_core_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ROCKETLAKE,		&tgl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&tgl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_reg_map),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,        &tgl_reg_map),
 	{}
 };
 
-- 
2.35.1

