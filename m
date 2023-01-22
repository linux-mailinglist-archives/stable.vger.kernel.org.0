Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970CD676F70
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjAVPVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjAVPVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:21:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E58322A19
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F29AB80B22
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6420BC433D2;
        Sun, 22 Jan 2023 15:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400880;
        bh=AzwnMT4LleFSOrS5E2lqg2yqM7HBEVytpO5lCrrj7Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhWkKOb5kHXYpN1pKonjQKuiStBfwsdjeXDleE07jTEDzp965+tfEKRZ/7k+bruOA
         9jB8kx2cZsnnRW8bUNfJRb7uQAESe0c9jO1DOjLEKCT+3L2wjbqcLv0ASKujaRDlu9
         vgHRyDX4K6h7XpJZUOmzplBBlLZ8CMsgl8CAnSLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Rui <rui.zhang@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/193] perf/x86/rapl: Add support for Intel Meteor Lake
Date:   Sun, 22 Jan 2023 16:02:35 +0100
Message-Id: <20230122150247.570906644@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit f52853a668bfeddd79f319d536a506f68cc2b478 ]

Meteor Lake RAPL support is the same as previous Sky Lake.
Add Meteor Lake model for RAPL.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230104145831.25498-1-rui.zhang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/rapl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index ae5779ea4417..589c6885560d 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -809,6 +809,8 @@ static const struct x86_cpu_id rapl_model_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,	&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&model_skl),
+	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE,		&model_skl),
+	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	&model_skl),
 	{},
 };
 MODULE_DEVICE_TABLE(x86cpu, rapl_model_match);
-- 
2.35.1



