Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0D13BBBD4
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhGELCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231433AbhGELCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 160CA61416;
        Mon,  5 Jul 2021 11:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482805;
        bh=S2fo9lPy++KvmA7VXO26KmA2MoZz1Vqn0htmsKEl+UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYaNTGqzhIDhTIvRNmTLgAFcwo3RMxqrGfg5cPSE4/GTAL69bbsXpd30IW5e29nmX
         QPOxYeMjTCDYqxSVQTYQZbWxOc/pZvoVloD2hxaiPLvvHXDCB/2Csb4hEnjGGOau0b
         xYKRmtKLBAm2f6e/niIg2f0gPwDhn8Ysx38V0qvxcpTDZkt0g9m9oezazzCCWcmg0x
         wwED5v1wVSIUASWaiW9muo0yQ4NGb/pzTNNbDInzfU49HF2FBqnUc2GKODha0xfPCg
         Ags5Rqn8et6AXUGl3cCzSiWT8LJg/kigz2SLB4ii64NobjQnQIf15lgtTidRuhjIMZ
         CsciVecAdxkkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 7/7] Linux 5.10.48-rc1
Date:   Mon,  5 Jul 2021 06:59:57 -0400
Message-Id: <20210705105957.1513284-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
References: <20210705105957.1513284-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.48-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index fb2937bca41b..d07aea32e4fd 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 47
-EXTRAVERSION =
+SUBLEVEL = 48
+EXTRAVERSION = -rc1
 NAME = Dare mighty things
 
 # *DOCUMENTATION*
-- 
2.30.2

