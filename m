Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D743C420E8F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhJDN0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235047AbhJDNYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:24:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E1B96320D;
        Mon,  4 Oct 2021 13:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353039;
        bh=fh0tqSl829OX0Id7edlsLck8BtxdHJwHykOo4WLYxH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErhmPM26krAdAKlgS91fxmFAQ2gT2K/VJlQ6L2dk3PSPL5bGtt4PSMrDa+uRu7X9P
         wwQrkJRxZee5LtCacZreC6zH2aXxqOPmsvCCp9KTH3cucCAQH7Ji/saVeJjbzeqEmK
         0a8b9aeTfmn2Mt2/oop78+2+F0uyg+cZ557UVcAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 66/93] perf/x86/intel: Update event constraints for ICX
Date:   Mon,  4 Oct 2021 14:53:04 +0200
Message-Id: <20211004125036.752053089@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit ecc2123e09f9e71ddc6c53d71e283b8ada685fe2 ]

According to the latest event list, the event encoding 0xEF is only
available on the first 4 counters. Add it into the event constraints
table.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/1632842343-25862-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 3b8b8eede1a8..4684bf9fcc42 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -263,6 +263,7 @@ static struct event_constraint intel_icl_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT_RANGE(0xa8, 0xb0, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xb7, 0xbd, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xd0, 0xe6, 0xf),
+	INTEL_EVENT_CONSTRAINT(0xef, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xf0, 0xf4, 0xf),
 	EVENT_CONSTRAINT_END
 };
-- 
2.33.0



