Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632F51A55F1
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgDKXNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730355AbgDKXNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5902A20787;
        Sat, 11 Apr 2020 23:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646791;
        bh=5E5acoX/23TDJSuUqQEMj3LTgMnNc8iD56xVZ48yBxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RF5KHJJIlTK7h5p3ZC2BtivGXPdrGmCk4xhbGuX/lO3W3VUIsgUU7ZiiEaIQCtm8c
         J8tA+Ml2YLHZeHIy4iUQXs3jp3hlL7K+67ce8A/V7CRmLHBdQ7MGgFPfLg+GTu/m+d
         eiK7zM3nwrjQjj2n3/NjmgF9gY+xfisUjWPP2P1s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Daly <pdaly@codeaurora.org>,
        "Isaac J . Manjarres" <isaacm@codeaurora.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 55/66] of: of_reserved_mem: Increase limit on number of reserved regions
Date:   Sat, 11 Apr 2020 19:11:52 -0400
Message-Id: <20200411231203.25933-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Daly <pdaly@codeaurora.org>

[ Upstream commit 632c99084052aef1c9dcfe43d2720306026d6d21 ]

Certain SoCs need to support a large amount of reserved memory
regions. For example, Qualcomm's SM8150 SoC requires that 20
regions of memory be reserved for a variety of reasons (e.g.
loading a peripheral subsystem's firmware image into a
particular space).

When adding more reserved memory regions to cater to different
usecases, the remaining number of reserved memory regions--12
to be exact--becomes too small. Thus, double the existing
limit of reserved memory regions.

Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 895c83e0c7b6c..794308b3b8b9a 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -21,7 +21,7 @@
 #include <linux/sort.h>
 #include <linux/slab.h>
 
-#define MAX_RESERVED_REGIONS	32
+#define MAX_RESERVED_REGIONS	64
 static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
 static int reserved_mem_count;
 
-- 
2.20.1

