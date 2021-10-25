Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6436043A190
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhJYTjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235812AbhJYThh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:37:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0758061139;
        Mon, 25 Oct 2021 19:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190449;
        bh=rVjZnonIjs9iQhf+25GYEN+yAKjpStAF8+G+vHXsZYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwLixBjPGcVYbtwF8v8UxYGTza35x83qdR16M0ZmmOVNyRh4kpMpzX8URKA7mDkA0
         77GLNyfOj65frRL8taG2iyY1r6BfWs4G8LmPXlxrzw6z3GTjZR10s3rm49vptDhvc3
         AKa46rqQukBP27dj9dieEoCZHbrUGTYfkCm4ynd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 79/95] perf/x86/msr: Add Sapphire Rapids CPU support
Date:   Mon, 25 Oct 2021 21:15:16 +0200
Message-Id: <20211025191008.353678713@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 71920ea97d6d1d800ee8b51951dc3fda3f5dc698 ]

SMI_COUNT MSR is supported on Sapphire Rapids CPU.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/1633551137-192083-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/msr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 4be8f9cabd07..ca8ce64df2ce 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -68,6 +68,7 @@ static bool test_intel(int idx, void *data)
 	case INTEL_FAM6_BROADWELL_D:
 	case INTEL_FAM6_BROADWELL_G:
 	case INTEL_FAM6_BROADWELL_X:
+	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 
 	case INTEL_FAM6_ATOM_SILVERMONT:
 	case INTEL_FAM6_ATOM_SILVERMONT_D:
-- 
2.33.0



