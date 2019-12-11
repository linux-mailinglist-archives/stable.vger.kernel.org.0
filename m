Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24EBB11B013
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbfLKPTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732066AbfLKPTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3210622527;
        Wed, 11 Dec 2019 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077553;
        bh=zmyNCSy0tpWy5TE1mS2OaviV0V1vdC2NHsGPOmi/44c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNDxKswYvgvgXvbrejoYGh+6TNcfnLyAAzSMXeZK2CE0SVQzaywuLYl/1XbzrLHXI
         Ln/9HKHuRXO6o0/QJDTq17Ag4BgUXv93Z+Yv7SoCtzSc7bgpmqH7tDd8v74SythAsT
         IwL7iPEyG/OvhITEGpA+zCI6MWorN1jUU8M/W0IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nylon Chen <nylon7@andestech.com>,
        Greentime Hu <greentime@andestech.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/243] nds32: Fix the items of hwcap_str ordering issue.
Date:   Wed, 11 Dec 2019 16:04:05 +0100
Message-Id: <20191211150344.710982600@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nylon Chen <nylon7@andestech.com>

[ Upstream commit a5234068e6dc18ae5300d678fbf3e129d9b93f78 ]

The hwcap_str should be set in a correct order according to HWCAP_xx.
We also add the missing "fpu_dp" to it.

Signed-off-by: Nylon Chen <nylon7@andestech.com>
Acked-by: Greentime Hu <greentime@andestech.com>
Signed-off-by: Greentime Hu <greentime@andestech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nds32/kernel/setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/nds32/kernel/setup.c b/arch/nds32/kernel/setup.c
index 63a1a5ef5219f..87683583f2064 100644
--- a/arch/nds32/kernel/setup.c
+++ b/arch/nds32/kernel/setup.c
@@ -71,8 +71,9 @@ static const char *hwcap_str[] = {
 	"div",
 	"mac",
 	"l2c",
-	"dx_regs",
+	"fpu_dp",
 	"v2",
+	"dx_regs",
 	NULL,
 };
 
-- 
2.20.1



