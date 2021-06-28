Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741F43B617C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhF1OgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234933AbhF1OeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 958D761C98;
        Mon, 28 Jun 2021 14:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890474;
        bh=LmyV3yu7KEwebhDwCGYMqfqAjX8W0lH3yeHDT0IiEBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odHB/ElY8u2nrqWL99Qr0/uY11VcxzB1/TODTzE67i2Jec/azV3AHWohgJjFQvAfc
         wLx4X2wWfsAVq88c34ysc6X+VymDsnrM54iDiwA78fClm5JMmu/elGXoeb19Twyow5
         5Pp4PQMzChCGicfqRxwYu2BfIj6P3xoQnWGpSkmKrQqe4SMCsB/ujPp4vX9KMMQrVZ
         sBch7PMelBZ1j07ZHNYxdIrNEWbOBKQDPbia5MEgIe/lDK1kaAujrnkixRyg2S5RII
         tOR+Q3zhAQGyo+fG8ByxeaoydW36K7GX89A0aSYolZLMws4l4Bc2+XwLp5Q9OL4LoB
         nOoQJ6TxRo0sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/101] Linux 5.10.47-rc1
Date:   Mon, 28 Jun 2021 10:26:07 -0400
Message-Id: <20210628142607.32218-102-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index 7ab22f105a03..97c664d872b6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 46
-EXTRAVERSION =
+SUBLEVEL = 47
+EXTRAVERSION = -rc1
 NAME = Dare mighty things
 
 # *DOCUMENTATION*
-- 
2.30.2

