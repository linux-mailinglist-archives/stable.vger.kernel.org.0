Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F68676F6F
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjAVPVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjAVPVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:21:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B31322A09
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:21:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BF22B80B1D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01491C433D2;
        Sun, 22 Jan 2023 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400883;
        bh=PtlzAC8azuBHimLXPWec3uJc7Dv2kiaz9qte+QQltK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBK9kv/lHJhiQJJ4uUkKOOOdrg8nkdqwRhLcNzCofsDYsQr2OJJmUNisadusRIGVa
         3r417fX8fm6evjdz8ytcno6T/t2JDF7uBgjSvLIKYqqf2JDR4vnwFQkiXvou8miu0P
         E3RUCmA1RQyLyBrIvFTO1He2LFKMWdd6kh74lBRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Rui <rui.zhang@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/193] perf/x86/rapl: Add support for Intel Emerald Rapids
Date:   Sun, 22 Jan 2023 16:02:36 +0100
Message-Id: <20230122150247.624365747@linuxfoundation.org>
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

[ Upstream commit 57512b57dcfaf63c52d8ad2fb35321328cde31b0 ]

Emerald Rapids RAPL support is the same as previous Sapphire Rapids.
Add Emerald Rapids model for RAPL.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230104145831.25498-2-rui.zhang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/rapl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 589c6885560d..52e6e7ed4f78 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -806,6 +806,7 @@ static const struct x86_cpu_id rapl_model_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&model_spr),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&model_spr),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,	&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&model_skl),
-- 
2.35.1



