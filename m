Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D269B5519F1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243402AbiFTM5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243472AbiFTM47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3470618E35;
        Mon, 20 Jun 2022 05:55:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07BD8614EC;
        Mon, 20 Jun 2022 12:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141D9C3411B;
        Mon, 20 Jun 2022 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729705;
        bh=LUqjWhd2x19oH7kQGPvqJsFKkYqV5H/4feAZdzzEdv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ax588mkbze4xDLODyWtIkUgJuOyCk8Sy9QgvicIpXVYF/K03JHKQA4PAtGKO+/wi/
         rkelbSKSSmYi8UOJ+yOqEqKNF5u/RwSDzCB367hmB+TK1XuIy1NoS9hGkTKNokvtG4
         r0j/Zfjqnft+EN5ozE5dFGLNtA3Qw2L4fiups1D4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George D Sworo <george.d.sworo@intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 048/141] platform/x86/intel: pmc: Support Intel Raptorlake P
Date:   Mon, 20 Jun 2022 14:49:46 +0200
Message-Id: <20220620124730.955235929@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



