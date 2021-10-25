Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEF743A338
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbhJYT5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235648AbhJYTzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0566F610A5;
        Mon, 25 Oct 2021 19:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191135;
        bh=NWmRiRW19PYgY4OfgDh+IoW5qa7oawkG0RlypOH1hM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AA2cRsTvjIltMLki3/p1InJFD0zXhdTRJX7jzK/TyNMMsrL2kXC3rmqwyyby9/mC
         Ws9tZmnE1Q1OoK8oodx7dCOG2QvsqJprjRZ1ThKAxs3oDZGlURjZqZRVC94zupEEpa
         k3OBnfnopaH8msXdmW6rbpg+fPvhTKSL5NCO3sEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 146/169] perf/x86/msr: Add Sapphire Rapids CPU support
Date:   Mon, 25 Oct 2021 21:15:27 +0200
Message-Id: <20211025191036.051265358@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
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
index c853b28efa33..96c775abe31f 100644
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



