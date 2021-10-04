Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC7E421069
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbhJDNn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238124AbhJDNls (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 486FA61A50;
        Mon,  4 Oct 2021 13:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353543;
        bh=7m31bX1iO2IyIzJcTgqBu1iqbIz/OSr4EgdIewMj99k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaDVz7nqI1BAbSF5dDfD7vfGj3IjmMAAwvewp8tY3bxGyA4+Feg/4QGTFKOKOILGm
         vNtSwyhk8rfp+Fz1GWAVnN33tulWmIbN0WhuEkesPZ5bGGiiXMMy+oTVQp6uWEdoUu
         isOLQVVuM7uZA+woiwSMqu2cZIPbW6nRFhTIydqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 138/172] perf/x86/intel: Update event constraints for ICX
Date:   Mon,  4 Oct 2021 14:53:08 +0200
Message-Id: <20211004125049.426885885@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
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
index ac6fd2dabf6a..482224444a1e 100644
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



