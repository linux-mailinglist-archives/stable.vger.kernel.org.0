Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7312F7DAB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbfKKS5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfKKS5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 348702184C;
        Mon, 11 Nov 2019 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498656;
        bh=WO2DEEc8wfvZ5rNQKeh5fsVrAnqj7ZhxdyRMnL7mEws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3AE2R3aWjG5uHILsh5HwZZqQ8NpHXkAKmzVXNt02ZFJ2Qbjzq3JfGX3WojmoqwnT
         CpR+4w+ib1DxaJNW8VbiWk+B2Yc9KWnF78UEqK9Ex2seu0P+k+UJCTG84hd/b74GVC
         Y38IbRtzwjherqpo3MasHTd79IKWc/me/w6FZevI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 181/193] arm64: Brahma-B53 is SSB and spectre v2 safe
Date:   Mon, 11 Nov 2019 19:29:23 +0100
Message-Id: <20191111181514.460202989@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit e059770cb1cdfbcbe3f1748f76005861cc79dd1a ]

Add the Brahma-B53 CPU (all versions) to the whitelists of CPUs for the
SSB and spectre v2 mitigations.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpu_errata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index d9da4201ba858..799d62ef7a9bd 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -489,6 +489,7 @@ static const struct midr_range arm64_ssb_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A53),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
+	MIDR_ALL_VERSIONS(MIDR_BRAHMA_B53),
 	{},
 };
 
@@ -573,6 +574,7 @@ static const struct midr_range spectre_v2_safe_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A53),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
+	MIDR_ALL_VERSIONS(MIDR_BRAHMA_B53),
 	{ /* sentinel */ }
 };
 
-- 
2.20.1



