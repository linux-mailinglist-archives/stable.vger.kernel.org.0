Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B57221FBE5
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgGNTFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730422AbgGNSy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:54:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7452622B4E;
        Tue, 14 Jul 2020 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752896;
        bh=gT5drgVkggJ7IsVykwTuD9LohfHoV0Is9KZ7YA3lFi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJs7fFJtwkhz+ESIecY/pjP1a0tTUOTlGi8xVBV+GW4dqX8hZSUqjJ968igo6pox0
         sRFQVee8KUqBLlZYMAec+Y/i1eBS0dSk4CZvs5RGQjTlZ4uJsFoiKdJ2lME2qhXYFB
         +yKtk1Op2I67jZ8kl06MBbHuxMktPZ920CaaFuDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 042/166] arm64: Add KRYO{3,4}XX silver CPU cores to SSB safelist
Date:   Tue, 14 Jul 2020 20:43:27 +0200
Message-Id: <20200714184117.893655849@linuxfoundation.org>
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

[ Upstream commit 108447fd0d1a34b0929cd26dc637c917a734ebab ]

QCOM KRYO{3,4}XX silver/LITTLE CPU cores are based on
Cortex-A55 and are SSB safe, hence add them to SSB
safelist -> arm64_ssb_cpus[].

Reported-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200625103123.7240-1-saiprakash.ranjan@codeaurora.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpu_errata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index df56d2295d165..0f37045fafab3 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -460,6 +460,8 @@ static const struct midr_range arm64_ssb_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A53),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
 	MIDR_ALL_VERSIONS(MIDR_BRAHMA_B53),
+	MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_3XX_SILVER),
+	MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
 	{},
 };
 
-- 
2.25.1



