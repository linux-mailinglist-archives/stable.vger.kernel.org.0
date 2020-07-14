Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC70B21FAAE
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgGNSyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729677AbgGNSyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:54:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79E6A22BEF;
        Tue, 14 Jul 2020 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752886;
        bh=RBIbnZzztTdxZ/SbCqbKeaEtPBUQ+wEz5vBOHX/Wrjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcf8IYg8ZQUA52/SWeFSIEydXtjwoW1lsuyLZFJen9hiWkQXvaQlV4GyGDw14mVEw
         /JjQsXHpAEqZzNfdfFYteuF2FbxrFs4etdi/LaXd6nkwg+vJuJFCtbjiCE5QIUmZcC
         N5JwB5EY1hhsL36a0xDvM+/Gsm2UEKDJWTGv5WaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 038/166] arm64: kpti: Add KRYO{3, 4}XX silver CPU cores to kpti safelist
Date:   Tue, 14 Jul 2020 20:43:23 +0200
Message-Id: <20200714184117.703665553@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit f4617be35b4b547e82d30993f56d631dfc2d5f88 ]

QCOM KRYO{3,4}XX silver/LITTLE CPU cores are based on Cortex-A55
and are meltdown safe, hence add them to kpti_safe_list[].

Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Link: https://lore.kernel.org/r/20200624123406.3472-1-saiprakash.ranjan@codeaurora.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9fac745aa7bb2..b0fb1d5bf2235 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1059,6 +1059,8 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 		MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
 		MIDR_ALL_VERSIONS(MIDR_NVIDIA_CARMEL),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_3XX_SILVER),
+		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
 		{ /* sentinel */ }
 	};
 	char const *str = "kpti command line option";
-- 
2.25.1



