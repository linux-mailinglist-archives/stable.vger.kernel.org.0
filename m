Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A1368D7C8
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbjBGNDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjBGNDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FCEA256
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 170666138B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF33C433D2;
        Tue,  7 Feb 2023 13:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774977;
        bh=wDND9gLyrbUiDn+N+fgrzTLJVry4TzV6UJ++R+frSn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZimTKGcsCYGR4VSEtgd7V5vlS61WIulGZ/uskLED+2aKbPAMQ+aM59roFA2Pdi3t
         TfhAIZ2H+9TD66n4mTTs1PkYEZU0XfkHI3I73vn9QUK9yk26LDbNKWSbk8cntJO3PD
         KWKPg/08ya48An+S9z7PoEnNq5FJY9SjpOGeIpJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/208] perf/x86/intel: Add Emerald Rapids
Date:   Tue,  7 Feb 2023 13:55:51 +0100
Message-Id: <20230207125638.766973642@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 6795e558e9cc6123c24e2100a2ebe88e58a792bc ]

>From core PMU's perspective, Emerald Rapids is the same as the Sapphire
Rapids. The only difference is the event list, which will be
supported in the perf tool later.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230106160449.3566477-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 1b92bf05fd65..5a1d0ea402e4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6342,6 +6342,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case INTEL_FAM6_EMERALDRAPIDS_X:
 		pmem = true;
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, spr_hw_cache_event_ids, sizeof(hw_cache_event_ids));
-- 
2.39.0



