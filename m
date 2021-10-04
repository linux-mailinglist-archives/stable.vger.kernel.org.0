Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A13420DD4
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbhJDNTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234195AbhJDNQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E50C6126A;
        Mon,  4 Oct 2021 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352805;
        bh=zVWennPLgznWrX4GrMKdu0rIsdHHGG/jMVBFP0fQIcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEQac0EYgej+ZcdzWQyWnUNkz8ujHV9nwdNpD0elzCV3ae5PPVJFZOObQPJm+XHei
         F+GpQ0eSLk/KDEZymkbN3gvR2fMP4BWQiOjDAx149kixHnqc2fTacjBY744FE/t8vA
         9ojRbRDqLC43UzU1cMMJy/Q5DyWhKll5ndMX50vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/56] perf/x86/intel: Update event constraints for ICX
Date:   Mon,  4 Oct 2021 14:52:53 +0200
Message-Id: <20211004125031.043196886@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
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
index 9cb3266e148d..70758f99c9e4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -259,6 +259,7 @@ static struct event_constraint intel_icl_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT_RANGE(0xa8, 0xb0, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xb7, 0xbd, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xd0, 0xe6, 0xf),
+	INTEL_EVENT_CONSTRAINT(0xef, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xf0, 0xf4, 0xf),
 	EVENT_CONSTRAINT_END
 };
-- 
2.33.0



